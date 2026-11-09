/**
 * Scenario tests for the Membership Essentials use cases (consolidated use-case document,
 * "Membership Essentials Use Cases"). Each test is one scenario:
 *
 *   Arrange  the data the contact already has (MembershipTestData; inert, starts nothing)
 *   Act      one final submission, driven through the pipeline (MfsPipelineDriver)
 *   Assert   the record graph the scenario's diagram shows (MembershipAssert)
 *
 * The tests assert the intended design, so some fail today. Documentation/Automated Testing.md
 * lists each failing scenario with the issue behind it; fixing the issue turns the test green.
 *
 * Not asserted: how the pipeline links Contacts to Accounts (an open sprint item), and
 * Opportunity Contact Roles (not yet drawn in the use-case diagrams).
 */
@IsTest
private class MembershipScenarios_TEST {

    // ------------------------------------------------------------------ baseline

    /** A new purchaser buys an annual membership. No earlier data. */
    @IsTest
    static void baseline_newPurchaser_annualMembership() {
        Product2 annual = MembershipTestData.membershipProduct('ANNUAL', 1, 1);
        Contact purchaser = new Contact(FirstName = 'Nova', LastName = 'Newcomer', Email = 'nova.newcomer@example.com');

        MfsPipelineDriver driver = MfsPipelineDriver.submit(
            MembershipTestData.submission(purchaser, 'Newcomer Household', annual, 'Individual'));
        driver.runIntake();
        MembershipAssert.notFailed(driver);
        Opportunity opp = MembershipAssert.submissionOpportunity(driver);
        MembershipAssert.opportunityProducts(opp.Id, new List<Product2>{ annual }, driver);

        driver.runMembershipStep();
        Membership__c m = MembershipAssert.submissionMembership(driver);
        MembershipAssert.active(m, driver);
        MembershipAssert.membershipLineLinked(opp.Id, m.Id, driver);
        Contact created = MembershipAssert.contactByEmail(purchaser.Email, driver);
        MembershipAssert.contactRole(created.Id, m.Id, true, driver);
        MembershipAssert.membershipCount(1, driver);
    }

    // ------------------------------------------------------------------ extra products on the purchase

    /**
     * Membership with Merchandise. "I'm hoping to buy a membership and want to grab some merch to show
     * off my membership." One Opportunity: membership line + merchandise line; Membership with an MCR.
     */
    @IsTest
    static void merchandise_membershipJoinsTheMerchandiseOpportunity() {
        assertMembershipJoinsExistingOpportunity(MembershipTestData.otherProduct('MERCH', 'Goods'));
    }

    /**
     * Membership w/ extra gift, option 1. "I'm hoping to buy a membership and want to give something
     * extra (via an unrestricted donation)." One Opportunity: membership line + donation line.
     */
    @IsTest
    static void extraGiftOption1_membershipJoinsTheDonationOpportunity() {
        assertMembershipJoinsExistingOpportunity(MembershipTestData.otherProduct('DONATION', null));
    }

    /**
     * Membership Bundles with fee-for-service products. "This includes partially or fully non-tax
     * deductible products as benefits." One Opportunity: membership line + fee-for-service line.
     */
    @IsTest
    static void feeForServiceBundle_membershipJoinsTheBundleOpportunity() {
        assertMembershipJoinsExistingOpportunity(MembershipTestData.otherProduct('SERVICE', 'Services'));
    }

    /** Shared by the three one-Opportunity scenarios: the other line exists, the submission adds the membership. */
    static void assertMembershipJoinsExistingOpportunity(Product2 other) {
        Product2 annual = MembershipTestData.membershipProduct('ANNUAL', 1, 1);
        MembershipTestData.Household h = MembershipTestData.household('Mara', 'Merch');
        Opportunity opp = MembershipTestData.opportunity(h.account, 'Purchase', new List<Product2>{ other });

        Membership_Form_Submission__c mfs = MembershipTestData.submission(h.contact, h.account, annual, 'Household');
        mfs.Opportunity__c = opp.Id;
        MfsPipelineDriver driver = MfsPipelineDriver.submit(mfs).runIntake();
        MembershipAssert.notFailed(driver);
        MembershipAssert.matchedExisting(h, driver);

        driver.runMembershipStep();
        MembershipAssert.opportunityCount(h.account.Id, 1, driver);
        MembershipAssert.opportunityProducts(opp.Id, new List<Product2>{ annual, other }, driver);
        Membership__c m = MembershipAssert.submissionMembership(driver);
        MembershipAssert.account(m, h.account.Id, driver);
        MembershipAssert.membershipLineLinked(opp.Id, m.Id, driver);
        MembershipAssert.contactRole(h.contact.Id, m.Id, true, driver);
    }

    /**
     * Membership w/ extra gift, option 2. "Finance doesn't reconcile opportunity count with transaction
     * count." The donation is its own Opportunity; the membership gets a second one.
     */
    @IsTest
    static void extraGiftOption2_membershipGetsItsOwnOpportunity() {
        Product2 annual = MembershipTestData.membershipProduct('ANNUAL', 1, 1);
        Product2 donation = MembershipTestData.otherProduct('DONATION', null);
        MembershipTestData.Household h = MembershipTestData.household('Dana', 'Donor');
        Opportunity gift = MembershipTestData.opportunity(h.account, 'Donation', new List<Product2>{ donation });

        MfsPipelineDriver driver = MfsPipelineDriver.submit(
            MembershipTestData.submission(h.contact, h.account, annual, 'Household')).runIntake();
        MembershipAssert.notFailed(driver);
        MembershipAssert.matchedExisting(h, driver);
        Opportunity opp = MembershipAssert.submissionOpportunity(driver);
        Assert.areNotEqual(gift.Id, opp.Id, 'The membership should not reuse the donation Opportunity.' + driver.trail());
        MembershipAssert.opportunityCount(h.account.Id, 2, driver);
        MembershipAssert.opportunityProducts(gift.Id, new List<Product2>{ donation }, driver);
        MembershipAssert.opportunityProducts(opp.Id, new List<Product2>{ annual }, driver);

        driver.runMembershipStep();
        Membership__c m = MembershipAssert.submissionMembership(driver);
        MembershipAssert.account(m, h.account.Id, driver);
        MembershipAssert.membershipLineLinked(opp.Id, m.Id, driver);
        MembershipAssert.contactRole(h.contact.Id, m.Id, true, driver);
    }

    // ------------------------------------------------------------------ renewals

    /**
     * Membership Renewal Before Expiration. "I'm renewing my membership for a second year and am paying
     * before it expires." The same Membership is extended by the product's term; a second Opportunity's
     * membership line links to it; the contact keeps one MCR.
     */
    @IsTest
    static void renewalBeforeExpiration_extendsTheSameMembership() {
        assertRenewalExtends(Date.today().addDays(20));
    }

    /**
     * Membership Renewal Before Expiration. "I'm renewing my membership for a second year and am paying
     * during the grace period." Products carry a 30-day grace period; this membership ended 10 days ago.
     * Expected outcome as above: the end date moves on by one term from the old end date.
     */
    @IsTest
    static void renewalDuringGracePeriod_extendsTheSameMembership() {
        assertRenewalExtends(Date.today().addDays(-10));
    }

    static void assertRenewalExtends(Date currentEnd) {
        Product2 annual = MembershipTestData.membershipProduct('ANNUAL', 1, 1);
        MembershipTestData.Household h = MembershipTestData.household('Remy', 'Renewer');
        Membership__c existing = MembershipTestData.existingMembership(
            h.account, h.contact, annual, 'Household', 'Current', currentEnd.addYears(-1).addDays(1), currentEnd);

        MfsPipelineDriver driver = MfsPipelineDriver.submit(
            MembershipTestData.submission(h.contact, h.account, annual, 'Household')).runIntake();
        MembershipAssert.notFailed(driver);
        MembershipAssert.matchedExisting(h, driver);
        Opportunity opp = MembershipAssert.submissionOpportunity(driver);
        MembershipAssert.opportunityCount(h.account.Id, 2, driver);

        driver.runMembershipStep();
        MembershipAssert.membershipCount(1, driver);
        MembershipAssert.endDate(existing, currentEnd.addYears(1), driver);
        MembershipAssert.membershipLineLinked(opp.Id, existing.Id, driver);
        MembershipAssert.contactRoleCount(h.contact.Id, 1, driver);
    }

    /**
     * Membership Renewal After End of Grace Period. "I was a member 2 years ago, wasn't last year, and
     * now I want to buy a membership again." The expired Membership stays as it is; a new active
     * Membership, Opportunity and MCR are created.
     */
    @IsTest
    static void renewalAfterGracePeriod_createsANewMembership() {
        Product2 annual = MembershipTestData.membershipProduct('ANNUAL', 1, 1);
        MembershipTestData.Household h = MembershipTestData.household('Lee', 'Lapsed');
        Membership__c expired = MembershipTestData.existingMembership(
            h.account, h.contact, annual, 'Household', 'Lapsed',
            Date.today().addDays(-400).addYears(-1), Date.today().addDays(-400));
        expired = MembershipAssert.membership(expired.Id);

        MfsPipelineDriver driver = MfsPipelineDriver.submit(
            MembershipTestData.submission(h.contact, h.account, annual, 'Household')).runIntake();
        MembershipAssert.notFailed(driver);
        MembershipAssert.matchedExisting(h, driver);
        Opportunity opp = MembershipAssert.submissionOpportunity(driver);
        MembershipAssert.opportunityCount(h.account.Id, 2, driver);

        driver.runMembershipStep();
        MembershipAssert.unchanged(expired, driver);
        Membership__c renewed = MembershipAssert.newMembership(new Set<Id>{ expired.Id }, driver);
        MembershipAssert.active(renewed, driver);
        MembershipAssert.account(renewed, h.account.Id, driver);
        MembershipAssert.membershipLineLinked(opp.Id, renewed.Id, driver);
        MembershipAssert.contactRole(h.contact.Id, renewed.Id, true, driver);
        MembershipAssert.contactRoleCount(h.contact.Id, 2, driver);
    }

    // ------------------------------------------------------------------ term and number of memberships

    /**
     * Buying Multi-Year Membership. "I'm buying a membership and know I'll need it for 3 years, I want
     * to buy all of them now." One Membership ending three years out; one 3-year line.
     */
    @IsTest
    static void multiYear_endsAfterThreeYears() {
        Product2 threeYear = MembershipTestData.membershipProduct('THREEYEAR', 3, 1);
        MembershipTestData.Household h = MembershipTestData.household('Mo', 'Multiyear');

        MfsPipelineDriver driver = MfsPipelineDriver.submit(
            MembershipTestData.submission(h.contact, h.account, threeYear, 'Household')).runIntake();
        MembershipAssert.notFailed(driver);
        MembershipAssert.matchedExisting(h, driver);
        Opportunity opp = MembershipAssert.submissionOpportunity(driver);
        MembershipAssert.opportunityProducts(opp.Id, new List<Product2>{ threeYear }, driver);

        driver.runMembershipStep();
        Membership__c m = MembershipAssert.submissionMembership(driver);
        MembershipAssert.endDate(m, MembershipAssert.termEndFromToday(3), driver);
        MembershipAssert.account(m, h.account.Id, driver);
        MembershipAssert.contactRole(h.contact.Id, m.Id, true, driver);
    }

    /**
     * Buying Multiple Membership for One. "As an individual, I want to buy two different types of
     * memberships for myself, e.g. annual membership and affinity group." The contact holds both,
     * with an MCR on each, and one Opportunity carries both membership lines. A different membership
     * type is what makes the second one a separate membership (Architecture.md M1).
     */
    @IsTest
    static void multipleForOne_secondTypeIsASeparateMembership() {
        Product2 annual = MembershipTestData.membershipProduct('ANNUAL', 1, 1);
        Product2 affinity = MembershipTestData.membershipProduct('AFFINITY', 1, 2);
        MembershipTestData.Household h = MembershipTestData.household('Ines', 'Individual');
        Membership__c first = MembershipTestData.existingMembership(
            h.account, h.contact, annual, 'Individual', 'Current', Date.today(), MembershipAssert.termEndFromToday(1));
        first = MembershipAssert.membership(first.Id);

        Membership_Form_Submission__c mfs = MembershipTestData.submission(h.contact, h.account, affinity, 'Household');
        mfs.Opportunity__c = first.Opportunity__c;
        MfsPipelineDriver driver = MfsPipelineDriver.submit(mfs).runIntake();
        MembershipAssert.notFailed(driver);
        MembershipAssert.matchedExisting(h, driver);

        driver.runMembershipStep();
        MembershipAssert.unchanged(first, driver);
        Membership__c second = MembershipAssert.newMembership(new Set<Id>{ first.Id }, driver);
        MembershipAssert.type(second, 'Household', driver);
        MembershipAssert.contactRole(h.contact.Id, second.Id, true, driver);
        MembershipAssert.contactRoleCount(h.contact.Id, 2, driver);
        MembershipAssert.opportunityProducts(first.Opportunity__c, new List<Product2>{ annual, affinity }, driver);
    }

    /**
     * Buying Institutional Membership. "As an organization, we are trying to buy a membership that
     * multiple individuals can use." One Corporate Membership on the organisation's Account, a primary
     * MCR for the purchaser, and an MCR for each of the other two contacts.
     */
    @IsTest
    static void institutional_everyOrganisationContactGetsAContactRole() {
        Product2 corporate = MembershipTestData.membershipProduct('CORPORATE', 1, 1);
        Account org = MembershipTestData.account('Acme Institute');
        Contact buyer = MembershipTestData.contact(org, 'Ola', 'Buyer');
        Contact second = MembershipTestData.contact(org, 'Sam', 'Second');
        Contact third = MembershipTestData.contact(org, 'Tia', 'Third');

        MfsPipelineDriver driver = MfsPipelineDriver.submit(
            MembershipTestData.submission(buyer, org, corporate, 'Corporate')).runIntake();
        MembershipAssert.notFailed(driver);
        MembershipAssert.matchedExisting(org, buyer, driver);
        Opportunity opp = MembershipAssert.submissionOpportunity(driver);
        MembershipAssert.opportunityProducts(opp.Id, new List<Product2>{ corporate }, driver);

        driver.runMembershipStep();
        Membership__c m = MembershipAssert.submissionMembership(driver);
        MembershipAssert.account(m, org.Id, driver);
        MembershipAssert.type(m, 'Corporate', driver);
        MembershipAssert.contactRole(buyer.Id, m.Id, true, driver);
        MembershipAssert.contactRole(second.Id, m.Id, false, driver);
        MembershipAssert.contactRole(third.Id, m.Id, false, driver);
    }

    // ------------------------------------------------------------------ gifts

    /**
     * Buying Gift Membership. "I want to buy a membership for my friend not in my household." The
     * purchase is the purchaser's; the membership and its MCR belong to the giftee. Which Account the
     * giftee and the gift membership sit on is part of the open contact-to-account item.
     */
    @IsTest
    static void gift_membershipBelongsToTheGiftee() {
        Product2 annual = MembershipTestData.membershipProduct('ANNUAL', 1, 1);
        MembershipTestData.Household h = MembershipTestData.household('Gil', 'Giver');
        Membership_Form_Submission__c mfs = MembershipTestData.withRecipient(
            MembershipTestData.submission(h.contact, h.account, annual, 'Individual'), 'Fran', 'Friend');

        MfsPipelineDriver driver = MfsPipelineDriver.submit(mfs).runIntake();
        MembershipAssert.notFailed(driver);
        MembershipAssert.matchedExisting(h, driver);
        Opportunity opp = MembershipAssert.submissionOpportunity(driver);
        Assert.areEqual(h.account.Id, opp.AccountId, 'The purchase belongs to the purchaser.' + driver.trail());
        MembershipAssert.opportunityProducts(opp.Id, new List<Product2>{ annual }, driver);

        driver.runMembershipStep();
        Contact giftee = MembershipAssert.contactByEmail(mfs.RecipientEmail__c, driver);
        Membership__c m = MembershipAssert.submissionMembership(driver);
        Assert.areEqual(giftee.Id, m.Primary_Contact__c, 'The gift membership belongs to the giftee.' + driver.trail());
        MembershipAssert.contactRole(giftee.Id, m.Id, true, driver);
        MembershipAssert.noContactRole(h.contact.Id, m.Id, driver);
        MembershipAssert.membershipLineLinked(opp.Id, m.Id, driver);
    }

    /**
     * Buying Gift Membership and a Standard Membership together. "I want to buy a membership for myself
     * and an adult in another household." The payor's own membership exists, bought on this Opportunity;
     * the gift submission adds the second line and the giftee's membership.
     */
    @IsTest
    static void giftAndStandard_giftJoinsThePayorsOpportunity() {
        Product2 annual = MembershipTestData.membershipProduct('ANNUAL', 1, 1);
        MembershipTestData.Household h = MembershipTestData.household('Pia', 'Payor');
        Membership__c own = MembershipTestData.existingMembership(
            h.account, h.contact, annual, 'Individual', 'Current', Date.today(), MembershipAssert.termEndFromToday(1));
        own = MembershipAssert.membership(own.Id);

        Membership_Form_Submission__c mfs = MembershipTestData.withRecipient(
            MembershipTestData.submission(h.contact, h.account, annual, 'Individual'), 'Ada', 'Adult');
        mfs.Opportunity__c = own.Opportunity__c;
        MfsPipelineDriver driver = MfsPipelineDriver.submit(mfs).runIntake();
        MembershipAssert.notFailed(driver);
        MembershipAssert.matchedExisting(h, driver);

        driver.runMembershipStep();
        MembershipAssert.unchanged(own, driver);
        Contact giftee = MembershipAssert.contactByEmail(mfs.RecipientEmail__c, driver);
        Membership__c gift = MembershipAssert.newMembership(new Set<Id>{ own.Id }, driver);
        Assert.areEqual(giftee.Id, gift.Primary_Contact__c, 'The gift membership belongs to the giftee.' + driver.trail());
        MembershipAssert.contactRole(giftee.Id, gift.Id, true, driver);
        MembershipAssert.noContactRole(h.contact.Id, gift.Id, driver);
        MembershipAssert.opportunityCount(h.account.Id, 1, driver);
        MembershipAssert.opportunityProducts(own.Opportunity__c, new List<Product2>{ annual, annual }, driver);
    }
}
