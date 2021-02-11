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
            SELECT Id
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
                Account__c = acc_map.get('First Account'),
                Start_Date__c = Date.today(),
                Does_Not_Expire__c = true,
                Type__c = 'Corporate'
            ),
            new Membership__c(
                Name = 'Expired Membership',
                Account__c = acc_map.get('First Account'),
                Start_Date__c = Date.today() - 10,
                End_Date__c = Date.today() - 5,
                Type__c = 'Corporate'
            ),
            new Membership__c(
                Name = 'Second Membership',
                Account__c = acc_map.get('Second Account'),
                Start_Date__c = Date.today(),
                Does_Not_Expire__c = true,
                Type__c = 'Household'
            )
        };
        insert memberships;
        
        List<Account> acc = [
            SELECT Id, Primary_Membership__c 
            FROM Account 
        ];

        for (Account a : acc) {
            if (a.Name == 'First Account') {
                System.assertEquals(a.Primary_Membership__r.Name, 'First Membership', 
        'Expected first membership, not expired membership');
            }
            if (a.Name == 'Second Account') {
                System.assertEquals(a.Primary_Membership__r.Name, 'Second Membership',
        'Expected household to get second membership');
            }
            if (a.Name == 'Account Without Memberships') {
                System.assertEquals(a.Primary_Membership__r.Name, null,
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