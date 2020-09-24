public with sharing class ContactHandler extends TriggerHandler {
    override void afterInsert() {
        Map<Id, Id> contactsEnteringAccountsMap = new Map<Id, Id>();

        for (Contact c : (List<Contact>)Trigger.new) {
            if (c.AccountId != null) {
                contactsEnteringAccountsMap.put(c.Id, c.AccountId);
            }
        }

        MembershipContactRoleService mcrs = new MembershipContactRoleService();

        mcrs.addContactRolesForAddedContacts(contactsEnteringAccountsMap);
    }

    override void afterUpdate() {
        // Handle reparented Contacts
        Map<Id, Id> contactsLeavingAccountsMap = new Map<Id, Id>();
        Map<Id, Id> contactsEnteringAccountsMap = new Map<Id, Id>();

        for (Contact c : (List<Contact>)Trigger.new) {
            Contact old = (Map<Id, Contact>)Trigger.oldMap.get(c.Id);
            if (c.AccountId != old.AccountId && c.AccountId != null) {
                contactsEnteringAccountsMap.put(c.Id, c.AccountId);
            }
            if (c.AccountId != old.AccountId && old.AccountId != null) {
                contactsLeavingAccountsMap.put(c.Id, old.AccountId);
            }
        }

        MembershipContactRoleService mcrs = new MembershipContactRoleService();

        mcrs.deactivateContactRolesForMovedContacts(contactsLeavingAccountsMap);
        mcrs.addContactRolesForAddedContacts(contactsEnteringAccountsMap);

    }
}
