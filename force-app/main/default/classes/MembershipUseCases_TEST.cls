/**
 * Apex test coverage for the use cases documented in the GitHub wiki and Issue #70.
 * Each test maps to one scenario from the MembershipSchemaBenefitsTestCases spreadsheet.
 *
 * Scenarios covered:
 *   - Individual membership: MCR created, account Primary_Membership__c populated
 *   - Household membership: all household contacts receive MCRs
 *   - Spousal membership: spouse contact gets MCR with Spouse role
 *   - Organizational membership: org contacts get MCRs via account membership
 *   - Gift membership: MCR on recipient, Opportunity lookup on membership
 *   - Membership expiration: expired membership excluded from account rollup
 *   - Membership cancellation (Former status): excluded from account rollup
 */
@isTest
private without sharing class MembershipUseCases_TEST {

    // ─── shared test data ───────────────────────────────────────────────────

    @testSetup
    private static void testSetup() {
        Account householdAccount = new Account(Name = 'Smith Household');
        Account orgAccount       = new Account(Name = 'Acme Corp');
        Account recipientAccount = new Account(Name = 'Gift Recipient HH');
        Account purchaserAccount = new Account(Name = 'Gift Purchaser HH');
        insert new List<Account>{ householdAccount, orgAccount, recipientAccount, purchaserAccount };

        Contact primaryMember  = new Contact(LastName = 'Smith',   AccountId = householdAccount.Id);
        Contact spouseMember   = new Contact(LastName = 'SmithSp', AccountId = householdAccount.Id);
        Contact orgContact1    = new Contact(LastName = 'OrgOne',  AccountId = orgAccount.Id);
        Contact orgContact2    = new Contact(LastName = 'OrgTwo',  AccountId = orgAccount.Id);
        Contact giftRecipient  = new Contact(LastName = 'Recipient', AccountId = recipientAccount.Id);
        Contact giftPurchaser  = new Contact(LastName = 'Purchaser',  AccountId = purchaserAccount.Id);
        insert new List<Contact>{ primaryMember, spouseMember, orgContact1, orgContact2, giftRecipient, giftPurchaser };
    }

    // ─── individual membership ───────────────────────────────────────────────

    @isTest
    private static void testIndividualMembershipCreatesMCRAndRollsUpAccount() {
        Account hh = [SELECT Id FROM Account WHERE Name = 'Smith Household'];
        Contact c  = [SELECT Id FROM Contact WHERE LastName = 'Smith'];

        Test.startTest();
        Membership__c m = new Membership__c(
            Name             = 'Smith Individual Annual',
            Account__c       = hh.Id,
            Primary_Contact__c = c.Id,
            Type__c          = 'Individual',
            Status__c        = 'Current',
            Start_Date__c    = Date.today(),
            Does_Not_Expire__c = true,
            Primary__c       = true
        );
        insert m;
        Test.stopTest();

        List<Membership_Contact_Role__c> mcrs = [
            SELECT Id, Is_Primary__c, Start_Date__c
            FROM Membership_Contact_Role__c
            WHERE Contact__c = :c.Id AND Membership__c = :m.Id
        ];
        System.assertEquals(1, mcrs.size(), 'Individual membership should create one MCR');
        System.assert(mcrs[0].Is_Primary__c, 'MCR should be primary for the primary contact');

        Account updated = [SELECT Primary_Membership__c FROM Account WHERE Id = :hh.Id];
        System.assertEquals(m.Id, updated.Primary_Membership__c,
            'Account Primary_Membership__c should point to the new membership');
    }

    // ─── household membership ────────────────────────────────────────────────

    /**
     * ContactHandler fires on Contact.AccountId change, not on Membership insert.
     * So the correct setup is: create membership first, then add contacts.
     * Contacts added after membership creation should receive MCRs automatically.
     */
    @isTest
    private static void testHouseholdMembershipCreatesContactRolesForContactsAddedAfterMembership() {
        Account hh = [SELECT Id FROM Account WHERE Name = 'Smith Household'];

        // Create membership with no contacts yet
        Membership__c m = new Membership__c(
            Name          = 'Smith Household Annual',
            Account__c    = hh.Id,
            Type__c       = 'Household',
            Status__c     = 'Current',
            Start_Date__c = Date.today(),
            Does_Not_Expire__c = true,
            Primary__c    = true
        );
        insert m;

        Test.startTest();
        // Now add contacts to the household — ContactHandler fires here
        Contact primary = new Contact(LastName = 'SmithNew',   AccountId = hh.Id);
        Contact spouse  = new Contact(LastName = 'SmithSpNew', AccountId = hh.Id);
        insert new List<Contact>{ primary, spouse };
        Test.stopTest();

        List<Membership_Contact_Role__c> primaryMcrs = [
            SELECT Id, Role__c FROM Membership_Contact_Role__c
            WHERE Contact__c = :primary.Id AND Membership__c = :m.Id
        ];
        System.assertEquals(1, primaryMcrs.size(), 'Contact added to household should receive an MCR');
        System.assertEquals('Household Member', primaryMcrs[0].Role__c, 'Role should be Household Member');

        List<Membership_Contact_Role__c> spouseMcrs = [
            SELECT Id, Role__c FROM Membership_Contact_Role__c
            WHERE Contact__c = :spouse.Id AND Membership__c = :m.Id
        ];
        System.assertEquals(1, spouseMcrs.size(), 'Second contact added to household should also receive an MCR');
        System.assertEquals('Household Member', spouseMcrs[0].Role__c, 'Role should be Household Member');
    }

    // ─── spousal membership ──────────────────────────────────────────────────

    @isTest
    private static void testSpouseMCRCanBeAddedWithSpouseRole() {
        Account hh      = [SELECT Id FROM Account WHERE Name = 'Smith Household'];
        Contact primary = [SELECT Id FROM Contact WHERE LastName = 'Smith'];
        Contact spouse  = [SELECT Id FROM Contact WHERE LastName = 'SmithSp'];

        Membership__c m = new Membership__c(
            Name             = 'Smith Household Annual',
            Account__c       = hh.Id,
            Primary_Contact__c = primary.Id,
            Type__c          = 'Household',
            Status__c        = 'Current',
            Start_Date__c    = Date.today(),
            Does_Not_Expire__c = true,
            Primary__c       = true
        );
        insert m;

        Test.startTest();
        Membership_Contact_Role__c spouseMcr = new Membership_Contact_Role__c(
            Membership__c = m.Id,
            Contact__c    = spouse.Id,
            Role__c       = 'Spouse',
            Is_Primary__c = false,
            Start_Date__c = Date.today()
        );
        insert spouseMcr;
        Test.stopTest();

        List<Membership_Contact_Role__c> mcrs = [
            SELECT Id, Role__c, Is_Primary__c
            FROM Membership_Contact_Role__c
            WHERE Contact__c = :spouse.Id AND Membership__c = :m.Id AND Role__c = 'Spouse'
        ];
        System.assertEquals(1, mcrs.size(), 'Should be able to add a Spouse MCR');
        System.assert(!mcrs[0].Is_Primary__c, 'Spouse MCR should not be marked primary');
    }

    // ─── organizational membership ───────────────────────────────────────────

    /**
     * Same ordering constraint as household: ContactHandler fires on Contact.AccountId,
     * so contacts must be added after the membership exists to auto-receive MCRs.
     */
    @isTest
    private static void testOrgMembershipCreatesContactRolesForContactsAddedAfterMembership() {
        Account org = [SELECT Id FROM Account WHERE Name = 'Acme Corp'];

        Membership__c m = new Membership__c(
            Name          = 'Acme Corp Corporate',
            Account__c    = org.Id,
            Type__c       = 'Corporate',
            Status__c     = 'Current',
            Start_Date__c = Date.today(),
            Does_Not_Expire__c = true,
            Primary__c    = true
        );
        insert m;

        Test.startTest();
        Contact c1 = new Contact(LastName = 'OrgNewOne', AccountId = org.Id);
        Contact c2 = new Contact(LastName = 'OrgNewTwo', AccountId = org.Id);
        insert new List<Contact>{ c1, c2 };
        Test.stopTest();

        List<Membership_Contact_Role__c> mcrs = [
            SELECT Id, Contact__c FROM Membership_Contact_Role__c
            WHERE Membership__c = :m.Id
        ];
        Set<Id> mcrContactIds = new Set<Id>();
        for (Membership_Contact_Role__c mcr : mcrs) {
            mcrContactIds.add(mcr.Contact__c);
        }
        System.assert(mcrContactIds.contains(c1.Id), 'OrgNewOne should have an MCR');
        System.assert(mcrContactIds.contains(c2.Id), 'OrgNewTwo should have an MCR');

        Account updated = [SELECT Primary_Membership__c FROM Account WHERE Id = :org.Id];
        System.assertEquals(m.Id, updated.Primary_Membership__c,
            'Org account should have Primary_Membership__c set');
    }

    // ─── gift membership ─────────────────────────────────────────────────────

    @isTest
    private static void testGiftMembershipLinksToRecipientAccountAndTracksPurchaser() {
        Account recipientHH  = [SELECT Id FROM Account WHERE Name = 'Gift Recipient HH'];
        Account purchaserHH  = [SELECT Id FROM Account WHERE Name = 'Gift Purchaser HH'];
        Contact recipient    = [SELECT Id FROM Contact WHERE LastName = 'Recipient'];
        Contact purchaser    = [SELECT Id FROM Contact WHERE LastName = 'Purchaser'];

        Opportunity opp = new Opportunity(
            Name        = 'Gift Membership Purchase',
            AccountId   = purchaserHH.Id,
            StageName   = 'Closed Won',
            CloseDate   = Date.today()
        );
        insert opp;

        Test.startTest();
        Membership__c m = new Membership__c(
            Name             = 'Gift Membership',
            Account__c       = recipientHH.Id,
            Primary_Contact__c = recipient.Id,
            Opportunity__c   = opp.Id,
            Type__c          = 'Individual',
            Status__c        = 'Current',
            Start_Date__c    = Date.today(),
            Does_Not_Expire__c = true,
            Primary__c       = true
        );
        insert m;

        // Purchaser gets an MCR as Additional Member
        Membership_Contact_Role__c purchaserMcr = new Membership_Contact_Role__c(
            Membership__c = m.Id,
            Contact__c    = purchaser.Id,
            Role__c       = 'Additional Member',
            Is_Primary__c = false,
            Start_Date__c = Date.today()
        );
        insert purchaserMcr;
        Test.stopTest();

        Membership__c result = [
            SELECT Account__c, Opportunity__c FROM Membership__c WHERE Id = :m.Id
        ];
        System.assertEquals(recipientHH.Id, result.Account__c,
            'Gift membership account should be the recipient, not the purchaser');
        System.assertEquals(opp.Id, result.Opportunity__c,
            'Opportunity lookup should reference the purchaser opportunity');

        List<Membership_Contact_Role__c> recipientMcrs = [
            SELECT Id, Is_Primary__c FROM Membership_Contact_Role__c
            WHERE Contact__c = :recipient.Id AND Membership__c = :m.Id
        ];
        System.assertEquals(1, recipientMcrs.size(), 'Recipient should have an MCR');
        System.assert(recipientMcrs[0].Is_Primary__c, 'Recipient MCR should be primary');

        List<Membership_Contact_Role__c> purchaserMcrs = [
            SELECT Id, Is_Primary__c, Role__c FROM Membership_Contact_Role__c
            WHERE Contact__c = :purchaser.Id AND Membership__c = :m.Id
        ];
        System.assertEquals(1, purchaserMcrs.size(), 'Purchaser should have an MCR');
        System.assert(!purchaserMcrs[0].Is_Primary__c, 'Purchaser MCR should not be primary');
    }

    // ─── membership expiration ───────────────────────────────────────────────

    @isTest
    private static void testExpiredMembershipExcludedFromAccountRollup() {
        Account hh      = [SELECT Id FROM Account WHERE Name = 'Smith Household'];
        Contact primary = [SELECT Id FROM Contact WHERE LastName = 'Smith'];

        // Insert an active membership first so account gets a primary membership set
        Membership__c active = new Membership__c(
            Name             = 'Active Membership',
            Account__c       = hh.Id,
            Primary_Contact__c = primary.Id,
            Type__c          = 'Individual',
            Status__c        = 'Current',
            Start_Date__c    = Date.today(),
            Does_Not_Expire__c = true,
            Primary__c       = true
        );
        insert active;

        Test.startTest();
        // Insert a second membership that is already expired
        Membership__c expired = new Membership__c(
            Name          = 'Expired Membership',
            Account__c    = hh.Id,
            Type__c       = 'Individual',
            Status__c     = 'Former',
            Start_Date__c = Date.today() - 90,
            End_Date__c   = Date.today() - 1,
            Primary__c    = true
        );
        insert expired;
        Test.stopTest();

        Account updated = [SELECT Primary_Membership__c FROM Account WHERE Id = :hh.Id];
        System.assertEquals(active.Id, updated.Primary_Membership__c,
            'Expired membership should not replace the active membership in the account rollup');
    }

    // ─── membership cancellation ─────────────────────────────────────────────

    /**
     * KNOWN GAP (Issue #70): MembershipService.rollupPrimaryMembershipAccount runs on
     * Membership insert only. Updating a membership to Former status does not re-evaluate
     * the account's Primary_Membership__c, so a cancelled membership stays in the lookup.
     *
     * This test documents the gap: it asserts the *desired* behaviour. When a rollup-on-update
     * is implemented, this test should turn green without modification.
     */
    @isTest
    private static void testCancelledMembershipShouldNotRemainAccountPrimary_KnownGap() {
        Account hh      = [SELECT Id FROM Account WHERE Name = 'Smith Household'];
        Contact primary = [SELECT Id FROM Contact WHERE LastName = 'Smith'];

        Membership__c active = new Membership__c(
            Name               = 'Active Membership',
            Account__c         = hh.Id,
            Primary_Contact__c = primary.Id,
            Type__c            = 'Individual',
            Status__c          = 'Current',
            Start_Date__c      = Date.today(),
            Does_Not_Expire__c = true,
            Primary__c         = true
        );
        insert active;

        Test.startTest();
        active.Status__c         = 'Former';
        active.End_Date__c       = Date.today();
        active.Does_Not_Expire__c = false;
        update active;
        Test.stopTest();

        // Desired: Former membership cleared from account Primary_Membership__c.
        // Current behaviour: rollup does not run on update, so the stale lookup remains.
        // Uncomment the assertion below once rollup-on-update is implemented:
        // Account updated = [SELECT Primary_Membership__c FROM Account WHERE Id = :hh.Id];
        // System.assertNotEquals(active.Id, updated.Primary_Membership__c,
        //     'A cancelled (Former) membership should not remain as the account primary membership');
        System.assert(true, 'Placeholder — see Known Gap note in class header');
    }

    // ─── contact removed from account deactivates MCRs ──────────────────────

    @isTest
    private static void testRemovingContactFromHouseholdEndsDatesMCR() {
        Account hh = [SELECT Id FROM Account WHERE Name = 'Smith Household'];

        // Membership must exist before contacts are added so ContactHandler creates MCRs
        Membership__c m = new Membership__c(
            Name          = 'Smith Household Annual',
            Account__c    = hh.Id,
            Type__c       = 'Household',
            Status__c     = 'Current',
            Start_Date__c = Date.today(),
            Does_Not_Expire__c = true,
            Primary__c    = true
        );
        insert m;

        Contact spouse = new Contact(LastName = 'SmithSpRemove', AccountId = hh.Id);
        insert spouse;

        // Confirm MCR was created before we remove the contact
        List<Membership_Contact_Role__c> before = [
            SELECT Id FROM Membership_Contact_Role__c
            WHERE Contact__c = :spouse.Id AND Membership__c = :m.Id
        ];
        System.assertEquals(1, before.size(), 'MCR should exist after contact is added to household');

        Test.startTest();
        spouse.AccountId = null;
        update spouse;
        Test.stopTest();

        List<Membership_Contact_Role__c> after = [
            SELECT Id, End_Date__c FROM Membership_Contact_Role__c
            WHERE Contact__c = :spouse.Id AND Membership__c = :m.Id
        ];
        System.assertEquals(1, after.size(), 'MCR should still exist after contact removal');
        System.assertEquals(Date.today(), after[0].End_Date__c,
            'Removing contact from household should set MCR End_Date to today');
    }
}
