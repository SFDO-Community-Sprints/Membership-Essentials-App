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
        Test.startTest();
        List<Membership__c> memberships = new List<Membership__c>{
            new Membership__c(
                Name = 'First Membership',
                Account__c = accounts[0].Id,
                Start_Date__c = Date.today(),
                Does_Not_Expire__c = true,
                Type__c = 'Corporate'
            ),
            new Membership__c(
                Name = 'Expired Membership',
                Account__c = accounts[0].Id,
                Start_Date__c = Date.today() - 10,
                End_Date__c = Date.today() - 5,
                Type__c = 'Corporate'
            ),
            new Membership__c(
                Name = 'Second Membership',
                Account__c = accounts[1].Id,
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

        System.assertEquals(acc[0].Primary_Membership__c, memberships[0], 
        'Expected first membership, not expired membership');

        System.assertEquals(acc[1].Primary_Membership__c, memberships[2],
        'Expected household to get second membership');

        System.assertEquals(acc[2].Primary_Membership__c, null,
        'Expected no primary membership');


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