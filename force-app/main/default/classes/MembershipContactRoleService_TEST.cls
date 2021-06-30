@isTest
private without sharing class MembershipContactRoleService_TEST {
    @testSetup
    private static void testSetup() {
        List<Account> accounts = new List<Account>{
            new Account(Name = 'First Account'),
            new Account(Name = 'Second Account'),
            new Account(Name = 'Account Without Memberships')
        };
        insert accounts;

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
    }

    @isTest
    private static void testAddContactToAccountAddsMCRs() {
        Test.startTest();
        List<Contact> cs = new List<Contact>{
            new Contact(
                AccountId = [SELECT Id FROM Account WHERE Name = 'First Account'].Id,
                FirstName = 'Molly',
                LastName = 'Member'
            ),
            new Contact(
                AccountId = [SELECT Id FROM Account WHERE Name = 'First Account'].Id,
                FirstName = 'Mikaela',
                LastName = 'Member'
            )
        };
        insert cs;

        List<Membership_Contact_Role__c> mcrs = [
            SELECT Id, Name, Start_Date__c, Role__c, Membership__c, Contact__c
            FROM Membership_Contact_Role__c
            WHERE Contact__c = :cs[0].Id
        ];
        System.assertEquals(1, mcrs.size(), 'expected 1 Role');
        System.assertEquals('First Membership ' + Date.today().year(), mcrs[0].Name);
        System.assertEquals(Date.today(), mcrs[0].Start_Date__c);
        System.assertEquals('Household Member', mcrs[0].Role__c);

        mcrs = [
            SELECT Id, Name, Start_Date__c, Role__c, Membership__c, Contact__c
            FROM Membership_Contact_Role__c
            WHERE Contact__c = :cs[1].Id
        ];
        System.assertEquals(1, mcrs.size(), 'expected 1 Role');
        System.assertEquals('First Membership ' + Date.today().year(), mcrs[0].Name);
        System.assertEquals(Date.today(), mcrs[0].Start_Date__c);
        System.assertEquals('Household Member', mcrs[0].Role__c);
    }

    @isTest
    private static void testRemoveContactFromAccountDeactivatesMCRs() {
        Test.startTest();
        List<Contact> cs = new List<Contact>{
            new Contact(
                AccountId = [SELECT Id FROM Account WHERE Name = 'First Account'].Id,
                FirstName = 'Molly',
                LastName = 'Member'
            ),
            new Contact(
                AccountId = [SELECT Id FROM Account WHERE Name = 'First Account'].Id,
                FirstName = 'Mikaela',
                LastName = 'Member'
            )
        };
        insert cs;

        cs[0].AccountId = null;
        cs[1].AccountId = null;
        update cs;

        List<Membership_Contact_Role__c> mcrs = [
            SELECT Id, Name, Start_Date__c, End_Date__c, Role__c, Membership__c, Contact__c
            FROM Membership_Contact_Role__c
            WHERE Contact__c = :cs[0].Id
        ];
        System.assertEquals(1, mcrs.size(), 'expected 1 Role');
        System.assertEquals('First Membership ' + Date.today().year(), mcrs[0].Name);
        System.assertEquals(Date.today(), mcrs[0].Start_Date__c);
        System.assertEquals(Date.today(), mcrs[0].End_Date__c);
        System.assertEquals('Household Member', mcrs[0].Role__c);

        mcrs = [
            SELECT Id, Name, Start_Date__c, End_Date__c, Role__c, Membership__c, Contact__c
            FROM Membership_Contact_Role__c
            WHERE Contact__c = :cs[1].Id
        ];
        System.assertEquals(1, mcrs.size(), 'expected 1 Role');
        System.assertEquals('First Membership ' + Date.today().year(), mcrs[0].Name);
        System.assertEquals(Date.today(), mcrs[0].Start_Date__c);
        System.assertEquals(Date.today(), mcrs[0].End_Date__c);
        System.assertEquals('Household Member', mcrs[0].Role__c);
    }

    @isTest
    private static void testAddContactToAccountWithoutMemberships() {
        Test.startTest();
        Contact c = new Contact(
            AccountId = [SELECT Id FROM Account WHERE Name = 'Account Without Memberships'].Id,
            LastName = 'Member'
        );
        insert c;

        List<Membership_Contact_Role__c> mcrs = [
            SELECT Id
            FROM Membership_Contact_Role__c
            WHERE Contact__c = :c.Id
        ];
        System.assertEquals(0, mcrs.size(), 'expected no Roles');
    }

    @isTest
    private static void testRemoveContactFromAccountWithoutMemberships() {
        Test.startTest();
        Contact c = new Contact(
            AccountId = [SELECT Id FROM Account WHERE Name = 'Account Without Memberships'].Id,
            LastName = 'Member'
        );
        insert c;

        List<Membership_Contact_Role__c> mcrs = [
            SELECT Id
            FROM Membership_Contact_Role__c
            WHERE Contact__c = :c.Id
        ];
        System.assertEquals(0, mcrs.size(), 'expected no Roles');
        
        c.AccountId = null;
        update c;

        mcrs = [
            SELECT Id
            FROM Membership_Contact_Role__c
            WHERE Contact__c = :c.Id
        ];
        System.assertEquals(0, mcrs.size(), 'expected no Roles');
    }
	
    @isTest
    private static void testAddSecondPrimaryContact() {
        Test.startTest();
        List<Contact> cs = new List<Contact>{
            new Contact(
                AccountId = [SELECT Id FROM Account WHERE Name = 'First Account'].Id,
                FirstName = 'Molly',
                LastName = 'Member'
            ),
            new Contact(
                AccountId = [SELECT Id FROM Account WHERE Name = 'First Account'].Id,
                FirstName = 'Mikaela',
                LastName = 'Member'
            )
        };
        insert cs;
        
        Membership__c m = new Membership__c( Id = [SELECT Id FROM Membership__c WHERE Name = 'First Membership'].Id, 
                                                Primary_Contact__c = cs[0].Id);
        update m;

        List<Membership_Contact_Role__c> mcrs = [
            SELECT Id, Is_Primary__c, Name, Start_Date__c, Role__c, Membership__c, Contact__c
            FROM Membership_Contact_Role__c
            WHERE Membership__c = :m.Id AND Is_Primary__c = TRUE
        ];
        System.assertEquals(1, mcrs.size(), 'expected 1 Primary Role');

        m = new Membership__c( Id = [SELECT Id FROM Membership__c WHERE Name = 'First Membership'].Id, 
                                                Primary_Contact__c = cs[1].Id);
        update m;

        mcrs = [
            SELECT Id, Is_Primary__c, Name, Start_Date__c, Role__c, Membership__c, Contact__c
            FROM Membership_Contact_Role__c
            WHERE Membership__c = :m.Id AND Is_Primary__c = TRUE
        ];
        System.assertEquals(1, mcrs.size(), 'still expected only 1 Primary Role');
    }
    
    @isTest
    private static void testMakeSecondRolePrimary() {
        List<Contact> cs = new List<Contact>{
            new Contact(
                AccountId = [SELECT Id FROM Account WHERE Name = 'First Account'].Id,
                FirstName = 'Molly',
                LastName = 'Member'
            ),
            new Contact(
                AccountId = [SELECT Id FROM Account WHERE Name = 'First Account'].Id,
                FirstName = 'Mikaela',
                LastName = 'Member'
            )
        };
        insert cs;
        
        Membership__c m = new Membership__c( Id = [SELECT Id FROM Membership__c WHERE Name = 'First Membership'].Id, 
                                                Primary_Contact__c = cs[0].Id);
        update m;

        Test.startTest();
        List<Membership_Contact_Role__c> mcrs = [
            SELECT Id, Is_Primary__c, Name, Start_Date__c, Role__c, Membership__c, Contact__c
            FROM Membership_Contact_Role__c
            WHERE Membership__c = :m.Id AND Is_Primary__c = TRUE
        ];
        System.assertEquals(1, mcrs.size(), 'expected 1 Primary Role');

		Membership_Contact_Role__c mcr = new Membership_Contact_Role__c(Id = [SELECT Id FROM Membership_Contact_Role__c WHERE Membership__c = :m.Id AND Contact__c = :cs[1].Id].Id, Is_Primary__c = TRUE);
        update mcr;

        mcrs = [
            SELECT Id, Is_Primary__c, Name, Start_Date__c, Role__c, Membership__c, Contact__c
            FROM Membership_Contact_Role__c
            WHERE Membership__c = :m.Id AND Is_Primary__c = TRUE
        ];
        System.assertEquals(1, mcrs.size(), 'still expected only 1 Primary Role');
    }
}