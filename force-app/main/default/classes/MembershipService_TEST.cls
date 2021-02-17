/**
 * Created by Rachel Whaley on 2/11/2021.
 */

@isTest
private without sharing class MembershipService_TEST {
    @testSetup
    private static void testSetup() {
        List<Account> accounts = new List<Account>{
            new Account(Name = 'First Account'),
            new Account(Name = 'Second Account'),
            new Account(Name = 'Account Without Memberships')
        };
        insert accounts;

        List<Contact> contacts = new List<Contact>{
            new Contact(LastName = 'Smith', AccountId = accounts[0].Id),
            new Contact(LastName = 'Johnson', AccountId = accounts[1].Id),
            new Contact(LastName = 'Mehta', AccountId = accounts[2].Id)
        };
        insert contacts;

    }
    @isTest
    private static void testMembershipInsert() {
        List<Account> acc = [
            SELECT Id, Name
            FROM Account 
        ];

        Map<String,Account> acc_map = new Map<String,Account>();
        for (Account a : acc) {
            acc_map.put(a.Name, a);
        }
        Test.startTest();
        List<Membership__c> memberships = new List<Membership__c>{
            new Membership__c(
                Name = 'First Membership',
                Account__c = acc_map.get('First Account').Id,
                Start_Date__c = Date.today(),
                Does_Not_Expire__c = true,
                Type__c = 'Corporate',
                Primary__c = true,
                Status__c = 'Current'
            ),
            new Membership__c(
                Name = 'Expired Membership',
                Account__c = acc_map.get('First Account').Id,
                Start_Date__c = Date.today() - 10,
                End_Date__c = Date.today() - 5,
                Type__c = 'Corporate',
                Primary__c = true,
                Status__c = 'Former'
            ),
            new Membership__c(
                Name = 'Second Membership',
                Account__c = acc_map.get('Second Account').Id,
                Start_Date__c = Date.today(),
                Does_Not_Expire__c = true,
                Type__c = 'Household',
                Primary__c = true,
                Status__c = 'Current'
            )
        };
        insert memberships;
        
        List<Account> acc_list = [
            SELECT Id, Primary_Membership__c, Name, Primary_Membership__r.Name 
            FROM Account 
        ];

        for (Account a : acc_list) {
            if (a.Name == 'First Account') {
                System.assertNotEquals(a.Primary_Membership__c, null, 'Mem field should not be null');
                System.assertEquals('First Membership', a.Primary_Membership__r.Name,  
        'Expected first membership, not expired membership');
            }
            if (a.Name == 'Second Account') {
                System.assertEquals('Second Membership', a.Primary_Membership__r.Name, 
        'Expected household to get second membership');
            }
            if (a.Name == 'Account Without Memberships') {
                System.assertEquals(null, a.Primary_Membership__c, 
        'Expected no primary membership');
            }   
        }

        /*
        List<Membership_Contact_Role__c> mcrs = [
            SELECT Id
            FROM Membership_Contact_Role__c
            WHERE Contact__c = :c.Id
        ];
        System.assertEquals(0, mcrs.size(), 'expected no Roles');
        */
    }

}