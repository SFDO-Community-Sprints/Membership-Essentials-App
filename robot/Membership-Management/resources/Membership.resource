*** Settings ***
Documentation     API-only keywords for submitting a Membership Form Submission (MFS) and
...               following it through the real, asynchronous event pipeline.
...
...               Scenario coverage lives in the Apex suite (MembershipScenarios_TEST). These keywords
...               back the Robot smoke test, which checks the same chain runs outside a test context.
Resource          cumulusci/robotframework/Salesforce.robot


*** Variables ***
${PIPELINE_TIMEOUT_ROUNDS}    36    # x 5 s = 3 minutes


*** Keywords ***
Submit Membership Form
    [Documentation]    Inserts an MFS for a new purchaser. Returns the MFS Id.
    ...                ${token} makes every name and email unique to this run, so teardown can find them.
    [Arguments]    ${token}    ${product_sku}    ${membership_type}=Household
    ${mfs_id}=    Salesforce Insert    Membership_Form_Submission__c
    ...    FirstName__c=Smoke
    ...    LastName__c=${token}
    ...    Email__c=smoke.${token}@example.com
    ...    OrganizationName__c=Smoke ${token} Household
    ...    BillingStreet__c=12 Member Way
    ...    BillingCity__c=Springfield
    ...    BillingState__c=IL
    ...    BillingZip__c=62701
    ...    Product_SKU__c=${product_sku}
    ...    SalePrice__c=500
    ...    MembershipType__c=${membership_type}
    RETURN    ${mfs_id}

Wait For Membership
    [Documentation]    Polls the MFS until the pipeline links a Membership. Fails at once if the MFS
    ...                stops in Failed, and after ${PIPELINE_TIMEOUT_ROUNDS} polls otherwise.
    ...                Status alone is not enough: Imported is set before the membership step runs (DEP-01).
    [Arguments]    ${mfs_id}
    FOR    ${poll}    IN RANGE    ${PIPELINE_TIMEOUT_ROUNDS}
        &{mfs}=    Salesforce Get    Membership_Form_Submission__c    ${mfs_id}
        IF    '${mfs}[Status__c]' == 'Failed'
            Fail    Submission ${mfs_id} failed: ${mfs}[Failure_Information__c]
        END
        IF    $mfs['Membership__c']    RETURN    ${mfs}
        Sleep    5s
    END
    Fail    Submission ${mfs_id} has no Membership after ${PIPELINE_TIMEOUT_ROUNDS} polls. Last state: ${mfs}

Opportunity Should Have One Membership Line
    [Arguments]    ${opportunity_id}    ${membership_id}    ${product_sku}
    ${result}=    Soql Query
    ...    SELECT Product2.StockKeepingUnit, Membership__c FROM OpportunityLineItem WHERE OpportunityId = '${opportunity_id}'
    Length Should Be    ${result}[records]    1
    Should Be Equal    ${result}[records][0][Product2][StockKeepingUnit]    ${product_sku}
    Should Be Equal    ${result}[records][0][Membership__c]    ${membership_id}

Contact Should Have Primary Role
    [Arguments]    ${contact_id}    ${membership_id}
    ${result}=    Soql Query
    ...    SELECT Is_Primary__c FROM Membership_Contact_Role__c WHERE Contact__c = '${contact_id}' AND Membership__c = '${membership_id}'
    Length Should Be    ${result}[records]    1
    Should Be True    ${result}[records][0][Is_Primary__c]

Exactly One Account Named
    [Documentation]    The pipeline created or matched one Account for the organisation name, not duplicates.
    [Arguments]    ${name}
    ${result}=    Soql Query    SELECT Id FROM Account WHERE Name = '${name}'
    Length Should Be    ${result}[records]    1    Expected one Account named "${name}"

Delete Submission Records
    [Documentation]    Deletes what one smoke submission created, found by its token. Best effort:
    ...                a record that was never created is skipped.
    [Arguments]    ${token}
    Delete Records Found By    SELECT Id FROM Membership_Contact_Role__c WHERE Contact__r.Email = 'smoke.${token}@example.com'
    ${result}=    Soql Query    SELECT Membership__c, Opportunity__c FROM Membership_Form_Submission__c WHERE LastName__c = '${token}'
    FOR    ${mfs}    IN    @{result}[records]
        IF    $mfs['Membership__c']
            Run Keyword And Ignore Error    Salesforce Delete    Membership__c    ${mfs}[Membership__c]
        END
        IF    $mfs['Opportunity__c']
            Run Keyword And Ignore Error    Salesforce Delete    Opportunity    ${mfs}[Opportunity__c]
        END
    END
    Delete Records Found By    SELECT Id FROM Membership_Essentials_Event_Log__c WHERE Membership_Form_Submission__r.LastName__c = '${token}'
    Delete Records Found By    SELECT Id FROM Membership_Form_Submission__c WHERE LastName__c = '${token}'
    Delete Records Found By    SELECT Id FROM Contact WHERE Email = 'smoke.${token}@example.com'
    Delete Records Found By    SELECT Id FROM Opportunity WHERE Account.Name = 'Smoke ${token} Household'
    Delete Records Found By    SELECT Id FROM Account WHERE Name = 'Smoke ${token} Household'

Delete Records Found By
    [Arguments]    ${soql}
    ${result}=    Soql Query    ${soql}
    FOR    ${record}    IN    @{result}[records]
        Run Keyword And Ignore Error    Salesforce Delete    ${record}[attributes][type]    ${record}[Id]
    END

Records Should Be Gone
    [Arguments]    ${token}
    ${result}=    Soql Query    SELECT Id FROM Membership_Form_Submission__c WHERE LastName__c = '${token}'
    Length Should Be    ${result}[records]    0
    ${result}=    Soql Query    SELECT Id FROM Contact WHERE Email = 'smoke.${token}@example.com'
    Length Should Be    ${result}[records]    0
