@isTest
private without sharing class MembershipTriggerHandler_TEST {
    @testSetup
    private static void testSetup() {
        List<Account> accounts = new List<Account>{
            new Account(Name = 'First Account')
        };
        insert accounts;

        List<Contact> contacts = new List<Contact>{
            new Contact(LastName = 'Member', AccountId = accounts[0].Id),
            new Contact(LastName = 'OtherMember', AccountId = accounts[0].Id)
        };
        insert contacts;

    }

    @isTest
    private static void testInsertMembershipWithPrimaryCreatesMCR() {
        Membership__c m = new Membership__c(
            Name = 'First Membership',
            Account__c = [SELECT Id FROM Account].Id,
            Primary_Contact__c = [SELECT Id FROM Contact WHERE LastName = 'Member'].Id,
            Start_Date__c = Date.today(),
            Does_Not_Expire__c = true,
            Type__c = 'Corporate'
        );
        insert m;

        List<Membership_Contact_Role__c> mcrs = [
            SELECT Id, Start_Date__c, Is_Primary__c
            FROM Membership_Contact_Role__c
        ];
        System.assertEquals(1, mcrs.size(), 'Expected 1 MCR');
        System.assert(mcrs[0].Is_Primary__c, 'Should be primary');
        System.assertEquals(Date.today(), mcrs[0].Start_Date__c);
    }

    @isTest
    private static void testUpdateMembershipWithNullPrimaryUpdatesMCR() {
        Membership__c m = new Membership__c(
            Name = 'First Membership',
            Account__c = [SELECT Id FROM Account].Id,
            Primary_Contact__c = [SELECT Id FROM Contact WHERE LastName = 'Member'].Id,
            Start_Date__c = Date.today(),
            Does_Not_Expire__c = true,
            Type__c = 'Corporate'
        );
        insert m;

        m.Primary_Contact__c = null;
        update m;

        List<Membership_Contact_Role__c> mcrs = [
            SELECT Id, Start_Date__c, Is_Primary__c
            FROM Membership_Contact_Role__c
        ];
        System.assertEquals(1, mcrs.size(), 'Expected 1 MCR');
        System.assert(!mcrs[0].Is_Primary__c, 'Should not be primary');
        System.assertEquals(Date.today(), mcrs[0].Start_Date__c);
    }

    @isTest
    private static void testUpdateMembershipWithNewPrimaryUpdatesExistingMCRAndAddsNew() {
        Id firstContactId = [SELECT Id FROM Contact WHERE LastName = 'Member'].Id;
        Id secondContactId = [SELECT Id FROM Contact WHERE LastName = 'OtherMember'].Id;
        Membership__c m = new Membership__c(
            Name = 'First Membership',
            Account__c = [SELECT Id FROM Account].Id,
            Primary_Contact__c = firstContactId,
            Start_Date__c = Date.today(),
            Does_Not_Expire__c = true,
            Type__c = 'Corporate'
        );
        insert m;

        m.Primary_Contact__c = secondContactId;
        update m;   

        List<Membership_Contact_Role__c> mcrs = [
            SELECT Id, Start_Date__c, Is_Primary__c
            FROM Membership_Contact_Role__c
            WHERE Contact__c = :firstContactId
        ];
        System.assertEquals(1, mcrs.size(), 'Expected 1 MCR');
        System.assert(!mcrs[0].Is_Primary__c, 'Should not be primary');
        System.assertEquals(Date.today(), mcrs[0].Start_Date__c);

        mcrs = [
            SELECT Id, Start_Date__c, Is_Primary__c
            FROM Membership_Contact_Role__c
            WHERE Contact__c = :secondContactId
        ];
        System.assertEquals(1, mcrs.size(), 'Expected 1 MCR');
        System.assert(mcrs[0].Is_Primary__c, 'Should be primary');
        System.assertEquals(Date.today(), mcrs[0].Start_Date__c);
    }

    private static void testUpdateMembershipWithNewPrimaryUpdatesExistingMCRs() {
        Membership__c m = new Membership__c(
            Name = 'First Membership',
            Account__c = [SELECT Id FROM Account].Id,
            Primary_Contact__c = [SELECT Id FROM Contact WHERE LastName = 'Member'].Id,
            Start_Date__c = Date.today(),
            Does_Not_Expire__c = true,
            Type__c = 'Corporate'
        );
        insert m;
        insert new Membership_Contact_Role__c(
            Membership__c = m.Id,
            Contact__c = [SELECT Id FROM Contact WHERE LastName = 'OtherMember'].Id
        );

        m.Primary_Contact__c = [SELECT Id FROM Contact WHERE LastName = 'OtherMember'].Id;
        update m;   

        List<Membership_Contact_Role__c> mcrs = [
            SELECT Id, Start_Date__c, Is_Primary__c
            FROM Membership_Contact_Role__c
            WHERE Contact__c != :m.Primary_Contact__c
        ];
        System.assertEquals(1, mcrs.size(), 'Expected 1 MCR');
        System.assert(!mcrs[0].Is_Primary__c, 'Should not be primary');
        System.assertEquals(Date.today(), mcrs[0].Start_Date__c);

        mcrs = [
            SELECT Id, Start_Date__c, Is_Primary__c
            FROM Membership_Contact_Role__c
            WHERE Contact__c = :m.Primary_Contact__c
        ];
        System.assertEquals(1, mcrs.size(), 'Expected 1 MCR');
        System.assert(mcrs[0].Is_Primary__c, 'Should be primary');
        System.assertEquals(Date.today(), mcrs[0].Start_Date__c);
    }
}