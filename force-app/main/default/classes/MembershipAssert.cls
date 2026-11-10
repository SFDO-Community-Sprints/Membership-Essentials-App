/**
 * Assertions on the records a submission leaves behind: Opportunities and their products,
 * Memberships, and Membership Contact Roles (MCRs). Each failure message ends with the
 * driver's pipeline trail.
 *
 * How the pipeline links Contacts to Accounts is an open sprint item, so nothing here
 * asserts Contact.AccountId.
 */
@IsTest
public class MembershipAssert {

    // ------------------------------------------------------------------ submission

    /** The submission did not stop in Failed. */
    public static void notFailed(MfsPipelineDriver driver) {
        Membership_Form_Submission__c m = driver.mfs();
        Assert.areNotEqual('Failed', m.Status__c, 'Submission failed: ' + m.Failure_Information__c + driver.trail());
    }

    /**
     * Intake matched the purchaser who already exists: the submission's Account and Contact are the
     * existing records, and no duplicate Account or Contact was created. Account matching is by the
     * organisation name the form sends; Contact.AccountId is not checked (open sprint item).
     */
    public static void matchedExisting(MembershipTestData.Household h, MfsPipelineDriver driver) {
        matchedExisting(h.account, h.contact, driver);
    }

    public static void matchedExisting(Account a, Contact c, MfsPipelineDriver driver) {
        Membership_Form_Submission__c m = driver.mfs();
        List<String> accounts = new List<String>();
        for (Account each : [SELECT Name FROM Account WHERE Name = :a.Name]) {
            accounts.add(each.Id + ' ' + each.Name);
        }
        Assert.areEqual(a.Id, m.Account__c,
            'Submission should be linked to the existing Account "' + a.Name + '". Accounts with that name: '
            + accounts + driver.trail());
        Assert.areEqual(c.Id, m.Contact__c,
            'Submission should be linked to the existing Contact ' + c.Email + '. Contacts with that email: '
            + [SELECT Id FROM Contact WHERE Email = :c.Email] + driver.trail());
    }

    /** The Opportunity the submission is linked to. */
    public static Opportunity submissionOpportunity(MfsPipelineDriver driver) {
        Id oppId = driver.mfs().Opportunity__c;
        Assert.isNotNull(oppId, 'Submission has no Opportunity.' + driver.trail());
        return [SELECT Id, AccountId FROM Opportunity WHERE Id = :oppId];
    }

    /** The Membership the submission is linked to. */
    public static Membership__c submissionMembership(MfsPipelineDriver driver) {
        Id membershipId = driver.mfs().Membership__c;
        Assert.isNotNull(membershipId, 'Submission has no Membership.' + driver.trail());
        return membership(membershipId);
    }

    // ------------------------------------------------------------------ opportunities

    /** The Opportunity carries exactly these products, by SKU. */
    public static void opportunityProducts(Id opportunityId, List<Product2> expected, MfsPipelineDriver driver) {
        List<String> want = new List<String>();
        for (Product2 p : expected) {
            want.add(p.StockKeepingUnit);
        }
        List<String> got = new List<String>();
        for (OpportunityLineItem l : [
            SELECT Product2.StockKeepingUnit FROM OpportunityLineItem WHERE OpportunityId = :opportunityId
        ]) {
            got.add(l.Product2.StockKeepingUnit);
        }
        want.sort();
        got.sort();
        Assert.areEqual(String.join(want, ', '), String.join(got, ', '),
            'Products on Opportunity ' + opportunityId + '.' + driver.trail());
    }

    public static void opportunityCount(Id accountId, Integer expected, MfsPipelineDriver driver) {
        Assert.areEqual(expected, [SELECT COUNT() FROM Opportunity WHERE AccountId = :accountId],
            'Opportunities on Account ' + accountId + '.' + driver.trail());
    }

    /** The membership line on the Opportunity is linked to this Membership. */
    public static void membershipLineLinked(Id opportunityId, Id membershipId, MfsPipelineDriver driver) {
        List<OpportunityLineItem> lines = [
            SELECT Membership__c FROM OpportunityLineItem
            WHERE OpportunityId = :opportunityId AND Product2.Family = 'Membership'
        ];
        Assert.areEqual(1, lines.size(), 'Membership lines on Opportunity ' + opportunityId + '.' + driver.trail());
        Assert.areEqual(membershipId, lines[0].Membership__c,
            'Membership line on Opportunity ' + opportunityId + ' links the wrong Membership.' + driver.trail());
    }

    // ------------------------------------------------------------------ memberships

    public static Membership__c membership(Id membershipId) {
        return [
            SELECT Id, Account__c, Type__c, Status__c, Start_Date__c, End_Date__c, Primary_Contact__c,
                   Product__c, Opportunity__c
            FROM Membership__c WHERE Id = :membershipId
        ];
    }

    public static Integer membershipCount() {
        return [SELECT COUNT() FROM Membership__c];
    }

    public static void membershipCount(Integer expected, MfsPipelineDriver driver) {
        Assert.areEqual(expected, membershipCount(), 'Memberships in the org.' + driver.trail());
    }

    /** The one Membership that is not in before. */
    public static Membership__c newMembership(Set<Id> before, MfsPipelineDriver driver) {
        List<Membership__c> created = [SELECT Id FROM Membership__c WHERE Id NOT IN :before];
        Id linked = driver.mfs().Membership__c;
        Assert.areEqual(1, created.size(), 'Expected exactly one new Membership. The submission is linked to '
            + (linked == null ? 'no Membership' : before.contains(linked) ? 'an existing Membership (' + linked + ')' : linked)
            + '.' + driver.trail());
        return membership(created[0].Id);
    }

    /** Nothing that matters about this Membership changed since the snapshot. */
    public static void unchanged(Membership__c before, MfsPipelineDriver driver) {
        Membership__c now = membership(before.Id);
        String label = 'Membership ' + before.Id + ' should be unchanged: ';
        Assert.areEqual(before.Product__c, now.Product__c, label + 'Product__c.' + driver.trail());
        Assert.areEqual(before.End_Date__c, now.End_Date__c, label + 'End_Date__c.' + driver.trail());
        Assert.areEqual(before.Status__c, now.Status__c, label + 'Status__c.' + driver.trail());
        Assert.areEqual(before.Primary_Contact__c, now.Primary_Contact__c, label + 'Primary_Contact__c.' + driver.trail());
    }

    public static void endDate(Membership__c m, Date expected, MfsPipelineDriver driver) {
        Assert.areEqual(expected, membership(m.Id).End_Date__c, 'End date of Membership ' + m.Id + '.' + driver.trail());
    }

    public static void account(Membership__c m, Id expected, MfsPipelineDriver driver) {
        Assert.areEqual(expected, membership(m.Id).Account__c, 'Account of Membership ' + m.Id + '.' + driver.trail());
    }

    public static void type(Membership__c m, String expected, MfsPipelineDriver driver) {
        Assert.areEqual(expected, membership(m.Id).Type__c, 'Type__c of Membership ' + m.Id + '.' + driver.trail());
    }

    public static void active(Membership__c m, MfsPipelineDriver driver) {
        Membership__c now = membership(m.Id);
        Assert.areEqual('Current', now.Status__c, 'Status__c of Membership ' + m.Id + '.' + driver.trail());
        Assert.isTrue(now.End_Date__c >= Date.today(), 'Membership ' + m.Id + ' has already ended.' + driver.trail());
    }

    /**
     * Expected end date for scenario tests using the shipped Day before anniversary convention.
     * These scenarios deliberately assert the default rather than deriving expectations from the
     * calculator under test. MembershipTermEnd_TEST covers the configurable calculator separately.
     */
    public static Date termEndFromToday(Integer years) {
        return Date.today().addYears(years).addDays(-1);
    }

    // ------------------------------------------------------------------ contact roles

    public static void contactRole(Id contactId, Id membershipId, Boolean primary, MfsPipelineDriver driver) {
        List<Membership_Contact_Role__c> roles = roles(contactId, membershipId);
        Assert.areEqual(1, roles.size(),
            'MCRs for Contact ' + contactId + ' on Membership ' + membershipId + '.' + driver.trail());
        Assert.areEqual(primary, roles[0].Is_Primary__c,
            'Is_Primary__c of the MCR for Contact ' + contactId + ' on Membership ' + membershipId + '.' + driver.trail());
    }

    public static void noContactRole(Id contactId, Id membershipId, MfsPipelineDriver driver) {
        Assert.areEqual(0, roles(contactId, membershipId).size(),
            'Contact ' + contactId + ' should have no MCR on Membership ' + membershipId + '.' + driver.trail());
    }

    public static void contactRoleCount(Id contactId, Integer expected, MfsPipelineDriver driver) {
        Assert.areEqual(expected, [SELECT COUNT() FROM Membership_Contact_Role__c WHERE Contact__c = :contactId],
            'MCRs for Contact ' + contactId + '.' + driver.trail());
    }

    static List<Membership_Contact_Role__c> roles(Id contactId, Id membershipId) {
        return [
            SELECT Id, Is_Primary__c FROM Membership_Contact_Role__c
            WHERE Contact__c = :contactId AND Membership__c = :membershipId
        ];
    }

    // ------------------------------------------------------------------ contacts

    /** The one Contact with this email; fails if it is missing or duplicated. */
    public static Contact contactByEmail(String email, MfsPipelineDriver driver) {
        List<Contact> found = [SELECT Id FROM Contact WHERE Email = :email];
        Assert.areEqual(1, found.size(), 'Contacts with email ' + email + '.' + driver.trail());
        return found[0];
    }
}
