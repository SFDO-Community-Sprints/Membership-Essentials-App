@isTest
public with sharing class MembershipContactRoleTest {
    
    @isTest
    public static void testInsert() {
        Membership__c member = new Membership__c(Name = 'Member 1', End_Date__c = Date.today());
        insert member;
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < 10; i++) {
            Contact c = new Contact(LastName = 'contact '+ i);
            contacts.add(c);
        }
        insert contacts;
        List<Membership_Contact_Role__c> membContRoles = new List<Membership_Contact_Role__c>();
        Integer i = 0;
        for (Contact c : contacts) {
            Membership_Contact_Role__c membContRole = new Membership_Contact_Role__c(Name = 'cont '+ i, Is_Primary__c = true);
            membContRole.Contact__c = c.Id;
            membContRole.Membership__c = member.Id;
            membContRoles.add(membContRole);
            i++;
        }
        Test.startTest();
        
        try {
            insert membContRoles;
            //throw new ExceptionHandler('A membership can\'t have more than 1 primary contact');
        } catch (Exception e) {
            Boolean result = e.getMessage().contains('A membership can\'t have more than 1 primary contact') ? true : false;
            System.assertEquals(result, true);
        }
        Test.stopTest();
    }

    @IsTest
    static void testUpdate(){

        Membership__c member = new Membership__c(Name = 'Member 1', End_Date__c = Date.today());
        insert member;
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < 2; i++) {
            Contact c = new Contact(LastName = 'contact '+ i);
            contacts.add(c);
        }
        insert contacts;

        List<Membership_Contact_Role__c> membContRoles = new List<Membership_Contact_Role__c>();
        Integer i = 0;

        Membership_Contact_Role__c membContRole1 = new Membership_Contact_Role__c(Name = 'cont 1', Is_Primary__c = true,
             Contact__c = contacts[0].Id, Membership__c = member.Id);
        insert membContRole1;

        Membership_Contact_Role__c membContRole2 = new Membership_Contact_Role__c(Name = 'cont 2', Is_Primary__c = false,
             Contact__c = contacts[1].Id, Membership__c = member.Id);
        insert membContRole2;
        
        membContRole2.Is_Primary__c = true;
        Test.startTest();
        update membContRole2;
        Test.stopTest();
        List<Membership_Contact_Role__c> memberContRoles = [SELECT ID FROM Membership_Contact_Role__c WHERE Is_Primary__c = true AND Membership__c = :member.Id];
        System.assertEquals(1, memberContRoles.size());
    }
}