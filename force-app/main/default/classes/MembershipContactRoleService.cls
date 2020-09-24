public with sharing class MembershipContactRoleService {
    public MembershipContactRoleService() {
    }

    public void deactivateContactRolesForMovedContacts(
        Map<Id, Id> movedContactsFromHouseholdsMap
    ) {
        // Locate the Memberships associated with the former
        // Households of these moved Contacts

        List<Membership_Contact_Role__c> mcrs = [
            SELECT Id, Contact__c, Membership__r.Account__c
            FROM Membership_Contact_Role__c
            WHERE Contact__c IN :movedContactsFromHouseholdsMap.keySet()
                  AND Membership__r.Account__c IN :movedContactsFromHouseholdsMap.values()
        ];
        List<Membership_Contact_Role__c> toUpdate = new List<Membership_Contact_Role__c>();

        // Update their End Dates to today.
        for (Membership_Contact_Role__c mcr : mcrs) {
            // Ensure this is an affected MCR - we over-select and may get cross-household MCRs.
            if (movedContactsFromHouseholdsMap.get(mcr.Contact__c) == mcr.Membership__r.Account__c) {
                mcr.End_Date__c = Date.today();
                toUpdate.add(mcr);
            }
        }

        update mcrs;
    }

    public void addContactRolesForAddedContacts(
        Map<Id, Id> addedContactsToHouseholdsMap
    ) {
        // Locate all Household-type memberships for the Households to which Contacts
        // have been added.
        List<Membership__c> memberships = [
            SELECT Id, Type__c, End_Date__c
            FROM Membership__c
            WHERE Account__c IN :addedContactsToHouseholdsMap.values()
                  AND (Start_Date__c <= :Date.today() OR Start_Date__c = null)
                  AND (End_Date__c >= :Date.today() OR Does_Not_Expire__c = true)
        ];

        // Process them into a Map<Id, List<Membership__c>> keyed on Account Id
        Map<Id, List<Membership__c>> membershipMap = new Map<Id,  List<Membership__c>>();
        for (Membership__c m : memberships) {
            if (!membershipMap.containsKey(m.Account__c)) {
                membershipMap.put(m.Account__c, new List<Membership__c>());
            }

            membershipMap.get(m.Account__c).add(m);
        }

        // Iterate over Contacts and accumulate a list of new Membership Contact Roles.
        List<Membership_Contact_Role__c> toInsert = new List<Membership_Contact_Role__c>();
        for (Id contactId : addedContactsToHouseholdsMap.keySet()) {
            for (Membership__c m : membershipMap.get(addedContactsToHouseholdsMap.get(contactId))) {
                toInsert.add(
                    new Membership_Contact_Role__c(
                        Contact__c = contactId,
                        Membership__c = m.Id,
                        Role = 'Household Member',
                        Start_Date__c = Date.today(),
                        End_Date__c = m.End_Date__c
                    )
                );
            }
        }

        insert toInsert;
    }
}
