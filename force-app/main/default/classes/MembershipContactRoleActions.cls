public with sharing class MembershipContactRoleActions {
    public static void handlePrimaryContactAfter(List<Membership_Contact_Role__c> membershipContactRoles) {
        Set<String> membershipIds = new Set<String>();
        for (Membership_Contact_Role__c membContactRole : membershipContactRoles) {
            if (membContactRole.Is_Primary__c != null && membContactRole.Is_Primary__c == true) {
                membershipIds.add(membContactRole.Membership__c);
            }
        }
        System.debug('### membershipIds'+ JSON.serializePretty(membershipIds));
        List<Membership_Contact_Role__c> contactRoles = [SELECT Id, Is_Primary__c, Membership__c FROM Membership_Contact_Role__c WHERE 
            Membership__c IN :membershipIds AND Id NOT IN :membershipContactRoles AND Is_Primary__c = true];
        System.debug('### contactRoles'+ JSON.serializePretty(contactRoles));

        for (Membership_Contact_Role__c ctRole : contactRoles) {
            ctRole.Is_Primary__c = false;
        }
        if (contactRoles != null && !contactRoles.isEmpty()) {
            update contactRoles;
        }
    }

    public static void handlePrimaryContactBefore(List<Membership_Contact_Role__c> membershipContactRoles)  {
        List<Id> membershipIds = new List<Id>();
        for (Membership_Contact_Role__c mcR : membershipContactRoles) {
            if (mcR.Is_Primary__c == true ) {
                if (membershipIds.contains(mcR.Membership__c)) {
                    mcR.addError('A membership can\'t have more than 1 primary contact');
                }
                membershipIds.add(mcR.Membership__c);    
            }   
        }
    }
}
