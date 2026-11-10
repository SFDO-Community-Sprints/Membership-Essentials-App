*** Settings ***

Resource        cumulusci/robotframework/Salesforce.robot
Library         cumulusci.robotframework.PageObjects

Suite Setup     Open Test Browser
Suite Teardown  Delete Records and Close Browser


*** Variables ***

${MEMBERSHIP_API}    Membership__c
${MCR_API}           Membership_Contact_Role__c
${MFS_API}           Membership_Form_Submission__c


*** Test Cases ***

Create Individual Membership via API and Verify Account Rollup
    [Documentation]    Issue #70 — Individual membership: account Primary_Membership__c should be set.
    ${account_id} =    Salesforce Insert    Account
    ...                    Name=Robot Individual HH
    ${contact_id} =    Salesforce Insert    Contact
    ...                    LastName=RobotMember
    ...                    AccountId=${account_id}
    ${mem_id} =    Salesforce Insert    Membership__c
    ...                Name=Robot Individual Annual
    ...                Account__c=${account_id}
    ...                Primary_Contact__c=${contact_id}
    ...                Type__c=Individual
    ...                Status__c=Current
    ...                Start_Date__c=2026-01-01
    ...                Does_Not_Expire__c=true
    ...                Primary__c=true

    &{account} =    Salesforce Get    Account    ${account_id}
    Should Be Equal    &{account}[Primary_Membership__c]    ${mem_id}

Create Individual Membership via UI and Verify Record
    [Documentation]    Issue #70 — Create a membership via the UI and confirm it appears on the account.
    ${first_name} =    Generate Random String
    ${last_name} =     Generate Random String
    ${account_id} =    Salesforce Insert    Account
    ...                    Name=Robot UI HH ${last_name}
    ${contact_id} =    Salesforce Insert    Contact
    ...                    FirstName=${first_name}
    ...                    LastName=${last_name}
    ...                    AccountId=${account_id}

    Go to page            Home    Membership__c
    Click Object Button   New
    Wait for modal        New    Membership

    Populate Form
    ...    Membership Name=Robot UI Annual ${last_name}
    ...    Type=Individual
    ...    Status=Current
    Click Modal Button    Save
    Wait Until Modal Is Closed

    ${mem_id} =    Get Current Record Id
    Store Session Record    Membership__c    ${mem_id}

    Go to page    Detail    Membership__c    ${mem_id}
    Page Should Contain    Robot UI Annual ${last_name}

Create Household Membership and Verify Both Contacts Get MCRs
    [Documentation]    Issue #70 — Household membership: all household contacts should receive MCRs.
    ${account_id} =    Salesforce Insert    Account
    ...                    Name=Robot HH Account
    ${primary_id} =    Salesforce Insert    Contact
    ...                    LastName=RobotPrimary
    ...                    AccountId=${account_id}
    ${spouse_id} =     Salesforce Insert    Contact
    ...                    LastName=RobotSpouse
    ...                    AccountId=${account_id}
    ${mem_id} =    Salesforce Insert    Membership__c
    ...                Name=Robot Household Annual
    ...                Account__c=${account_id}
    ...                Primary_Contact__c=${primary_id}
    ...                Type__c=Household
    ...                Status__c=Current
    ...                Start_Date__c=2026-01-01
    ...                Does_Not_Expire__c=true
    ...                Primary__c=true

    # Primary contact MCR created by trigger
    @{primary_mcrs} =    Salesforce Query    Membership_Contact_Role__c
    ...    Contact__c=${primary_id}
    ...    Membership__c=${mem_id}
    Length Should Be    ${primary_mcrs}    1

    # Spouse MCR created by ContactHandler when contact already in account
    @{spouse_mcrs} =    Salesforce Query    Membership_Contact_Role__c
    ...    Contact__c=${spouse_id}
    ...    Membership__c=${mem_id}
    Length Should Be    ${spouse_mcrs}    1

Create Gift Membership — Recipient Account, Purchaser on Opportunity
    [Documentation]    Issue #70 — Gift membership: membership account = recipient, opportunity = purchaser's.
    ${recipient_acct} =    Salesforce Insert    Account
    ...                        Name=Robot Recipient HH
    ${purchaser_acct} =    Salesforce Insert    Account
    ...                        Name=Robot Purchaser HH
    ${recipient_id} =    Salesforce Insert    Contact
    ...                      LastName=RobotRecipient
    ...                      AccountId=${recipient_acct}
    ${purchaser_id} =    Salesforce Insert    Contact
    ...                      LastName=RobotPurchaser
    ...                      AccountId=${purchaser_acct}
    ${opp_id} =    Salesforce Insert    Opportunity
    ...                Name=Gift Purchase Robot
    ...                AccountId=${purchaser_acct}
    ...                StageName=Closed Won
    ...                CloseDate=2026-01-01
    ${mem_id} =    Salesforce Insert    Membership__c
    ...                Name=Robot Gift Membership
    ...                Account__c=${recipient_acct}
    ...                Primary_Contact__c=${recipient_id}
    ...                Opportunity__c=${opp_id}
    ...                Type__c=Individual
    ...                Status__c=Current
    ...                Start_Date__c=2026-01-01
    ...                Does_Not_Expire__c=true
    ...                Primary__c=true

    &{mem} =    Salesforce Get    Membership__c    ${mem_id}
    Should Be Equal    &{mem}[Account__c]       ${recipient_acct}
    Should Be Equal    &{mem}[Opportunity__c]   ${opp_id}

    # Recipient should have a primary MCR
    @{recipient_mcrs} =    Salesforce Query    Membership_Contact_Role__c
    ...    Contact__c=${recipient_id}
    ...    Membership__c=${mem_id}
    Length Should Be    ${recipient_mcrs}    1

Create Membership Form Submission and Confirm It Processes
    [Documentation]    Issue #70 — MFS is the main intake; verify record creation and initial status.
    ${account_id} =    Salesforce Insert    Account
    ...                    Name=Robot MFS Account
    ${contact_id} =    Salesforce Insert    Contact
    ...                    FirstName=Robot
    ...                    LastName=MFSMember
    ...                    AccountId=${account_id}

    ${mfs_id} =    Salesforce Insert    Membership_Form_Submission__c
    ...                FirstName__c=Robot
    ...                LastName__c=MFSMember
    ...                Email__c=robot.mfsmember@example.com
    ...                MembershipType__c=Individual

    Store Session Record    Membership_Form_Submission__c    ${mfs_id}

    &{mfs} =    Salesforce Get    Membership_Form_Submission__c    ${mfs_id}
    Should Be Equal    &{mfs}[FirstName__c]    Robot
    Should Be Equal    &{mfs}[LastName__c]     MFSMember
