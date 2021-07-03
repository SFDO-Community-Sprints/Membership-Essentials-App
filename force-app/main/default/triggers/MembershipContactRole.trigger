trigger MembershipContactRole on Membership_Contact_Role__c (before insert, before update, after insert, after update) {

    MembershipContactRoleHandler handler = new MembershipContactRoleHandler(Trigger.isExecuting, Trigger.size);

    if(Trigger.isInsert)
    {
        if(Trigger.isAfter)
        {
            handler.OnAfterInsert(trigger.New);
        } else {
            handler.onBeforeInsert(trigger.New);
        }
    }
    else if (Trigger.isUpdate)
    {
        if(Trigger.isAfter)
        {
            handler.OnAfterUpdate(trigger.New);
        } else {
            handler.onBeforeUpdate(trigger.New);
        }
    }
}