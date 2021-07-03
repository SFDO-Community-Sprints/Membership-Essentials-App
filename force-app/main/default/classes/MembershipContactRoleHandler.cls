public with sharing class MembershipContactRoleHandler {

    private boolean m_isExecuting = false;
    private integer BatchSize = 0;

    public MembershipContactRoleHandler(boolean isExecuting, integer size)
    {
        m_isExecuting = isExecuting;
        BatchSize = size;
    }

    public void OnAfterInsert(List<Membership_Contact_Role__c> membContactsRoles)
    {
        MembershipContactRoleActions.handlePrimaryContactAfter(membContactsRoles);
    }
    public void OnAfterUpdate(List<Membership_Contact_Role__c> membContactsRoles)
    {
        MembershipContactRoleActions.handlePrimaryContactAfter(membContactsRoles);
    }

    public void onBeforeInsert(List<Membership_Contact_Role__c> membContactsRoles)
    {
        MembershipContactRoleActions.handlePrimaryContactBefore(membContactsRoles);
    }
    public void onBeforeUpdate(List<Membership_Contact_Role__c> membContactsRoles)
    {
        MembershipContactRoleActions.handlePrimaryContactBefore(membContactsRoles);
    }

    public boolean IsTriggerContext
    {
        get{ return m_isExecuting;}
    }
}