*** Settings ***
Documentation     Smoke test: one Membership Form Submission through the real, asynchronous event
...               pipeline, in an org built by dev_org or qa_org (which run setup_pricebook, so the
...               sample product STD has a standard price book entry).
...
...               The use-case scenarios are covered step by step in Apex (MembershipScenarios_TEST).
...               This test answers a different question: does the chain finish on its own, with real
...               platform event delivery, the real Standard Price Book and the org's duplicate rules?
...               See Documentation/Automated Testing.md.
Resource          ../resources/Membership.resource
Suite Setup       Set Suite Variable    ${TOKEN}    smk${{ __import__('random').randint(10**7, 10**8 - 1) }}
Suite Teardown    Delete Submission Records    ${TOKEN}
Force Tags        smoke    api


*** Test Cases ***
New Purchaser Buys A Standard Membership
    [Documentation]    A purchaser the org has never seen submits a Standard Membership (SKU STD).
    ...                Expect one Opportunity with one membership line linked to a new Membership, and a
    ...                primary Membership Contact Role for the purchaser.
    ...                Contact-to-Account linking is an open sprint item and is not checked.
    ${mfs_id}=    Submit Membership Form    ${TOKEN}    STD
    &{mfs}=    Wait For Membership    ${mfs_id}
    Should Not Be Equal    ${mfs}[Opportunity__c]    ${None}    Submission has no Opportunity
    Opportunity Should Have One Membership Line    ${mfs}[Opportunity__c]    ${mfs}[Membership__c]    STD
    Contact Should Have Primary Role    ${mfs}[Contact__c]    ${mfs}[Membership__c]
    Exactly One Account Named    Smoke ${TOKEN} Household
