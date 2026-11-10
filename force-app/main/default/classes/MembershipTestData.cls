/**
 * Test data builders for Membership Essentials scenario tests.
 *
 * Builders insert the "before" state a scenario needs, then return the records. The data is
 * inert: nothing here starts the MFS pipeline.
 *   - Membership line items carry Membership__c, so Opportunity_Line_Item_After_Membership
 *     does not fire (it only fires for Family = Membership lines with a blank Membership__c).
 *   - Non-membership products leave Family blank (Product2Family has only None and Membership).
 *   - Historical submissions follow Documentation/Importing Membership Form Submissions.md:
 *     Status__c = Imported at insert, Membership__c set, Membership_Finder_Ran__c = true.
 *
 * Keep no state in static variables in this class or in tests that use it: a
 * Test.getEventBus().deliver() that delivers events resets a test's static variables.
 */
@IsTest
public class MembershipTestData {

    public static final String STAGE_WON = 'Closed Won';

    // ------------------------------------------------------------------ products

    /** A renewable membership product with an active standard price book entry. */
    public static Product2 membershipProduct(String sku, Integer termYears, Decimal tier) {
        Product2 p = new Product2(
            Name = 'Membership ' + sku, StockKeepingUnit = sku, Family = 'Membership', IsActive = true,
            Term__c = termYears, Term_Unit__c = 'Year', Renewal_Option__c = 'Renewable',
            Membership_Tier__c = tier, Grace_Period__c = 30
        );
        insertWithPrice(p, 100);
        return p;
    }

    /** A non-membership product (merchandise, donation, fee-for-service). Category may be null. */
    public static Product2 otherProduct(String sku, String category) {
        Product2 p = new Product2(Name = 'Product ' + sku, StockKeepingUnit = sku, IsActive = true, Category__c = category);
        insertWithPrice(p, 25);
        return p;
    }

    static void insertWithPrice(Product2 p, Decimal price) {
        update new Pricebook2(Id = Test.getStandardPricebookId(), IsActive = true);
        insert p;
        insert new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(), Product2Id = p.Id, UnitPrice = price, IsActive = true
        );
    }

    static Id priceBookEntryId(Id productId) {
        return [
            SELECT Id FROM PricebookEntry
            WHERE Product2Id = :productId AND Pricebook2Id = :Test.getStandardPricebookId()
        ].Id;
    }

    // ------------------------------------------------------------------ people

    /**
     * An Account with a billing address. The Account step matches an existing Account through the
     * Standard Account Duplicate Rule, which needs the address as well as the name (verified: name
     * alone does not match), so a submission for this Account must carry the same address.
     */
    public static Account account(String name) {
        Account a = new Account(
            Name = name, BillingStreet = '12 Member Way', BillingCity = 'Springfield',
            BillingState = 'IL', BillingPostalCode = '62701'
        );
        insert a;
        return a;
    }

    /** A contact on an account. How the pipeline links contacts to accounts is an open sprint item; this is setup only. */
    public static Contact contact(Account a, String firstName, String lastName) {
        Contact c = new Contact(
            AccountId = a == null ? null : a.Id, FirstName = firstName, LastName = lastName,
            Email = (firstName + '.' + lastName + '@example.com').toLowerCase()
        );
        insert c;
        return c;
    }

    /** A purchaser who already exists: an Account named "<lastName> Household" and one Contact on it. */
    public class Household {
        public Account account;
        public Contact contact;
    }

    public static Household household(String firstName, String lastName) {
        Household h = new Household();
        h.account = account(lastName + ' Household');
        h.contact = contact(h.account, firstName, lastName);
        return h;
    }

    // ------------------------------------------------------------------ purchases

    /** A Closed Won Opportunity with one line per product. Membership lines must use membershipLine(). */
    public static Opportunity opportunity(Account a, String name, List<Product2> products) {
        Opportunity o = new Opportunity(
            Name = name, AccountId = a == null ? null : a.Id, StageName = STAGE_WON, CloseDate = Date.today(),
            Pricebook2Id = Test.getStandardPricebookId()
        );
        insert o;
        List<OpportunityLineItem> lines = new List<OpportunityLineItem>();
        for (Product2 p : products) {
            lines.add(new OpportunityLineItem(
                OpportunityId = o.Id, PricebookEntryId = priceBookEntryId(p.Id), Quantity = 1, UnitPrice = 25
            ));
        }
        insert lines;
        return o;
    }

    /**
     * An existing membership as the pipeline would have left it: the Membership (primary contact set,
     * so MembershipHandler creates the primary MCR), its Opportunity with a membership line linked to it,
     * and the historical submission recording the term.
     */
    public static Membership__c existingMembership(
        Account a, Contact primary, Product2 product, String type, String status, Date startDate, Date endDate
    ) {
        Opportunity o = new Opportunity(
            Name = 'Earlier purchase ' + product.StockKeepingUnit, AccountId = a == null ? null : a.Id,
            StageName = STAGE_WON, CloseDate = startDate, Pricebook2Id = Test.getStandardPricebookId()
        );
        insert o;
        Membership__c m = new Membership__c(
            Name = 'Existing ' + product.StockKeepingUnit, Account__c = a == null ? null : a.Id,
            Primary_Contact__c = primary.Id, Product__c = product.Id, Type__c = type, Status__c = status,
            Start_Date__c = startDate, End_Date__c = endDate, Opportunity__c = o.Id
        );
        insert m;
        insert new OpportunityLineItem(
            OpportunityId = o.Id, PricebookEntryId = priceBookEntryId(product.Id), Quantity = 1, UnitPrice = 100,
            Membership__c = m.Id
        );
        insert new Membership_Form_Submission__c(
            Status__c = 'Imported', Membership__c = m.Id, Membership_Finder_Ran__c = true,
            Product__c = product.Id, Opportunity__c = o.Id, Term_Start_Date__c = startDate,
            FirstName__c = primary.FirstName, LastName__c = primary.LastName, Email__c = primary.Email
        );
        return m;
    }

    // ------------------------------------------------------------------ submissions

    /**
     * A new submission from a purchaser whose household or organisation Account already exists, not
     * yet inserted. The form sends that Account's name and billing address.
     */
    public static Membership_Form_Submission__c submission(
        Contact purchaser, Account organisation, Product2 product, String membershipType
    ) {
        Membership_Form_Submission__c mfs = submission(purchaser, organisation.Name, product, membershipType);
        mfs.BillingStreet__c = organisation.BillingStreet;
        mfs.BillingCity__c = organisation.BillingCity;
        mfs.BillingState__c = organisation.BillingState;
        mfs.BillingZip__c = organisation.BillingPostalCode;
        return mfs;
    }

    /**
     * A new submission, not yet inserted. organizationName is what the form sends as the purchaser's
     * household or organisation; pass null to leave it blank.
     */
    public static Membership_Form_Submission__c submission(
        Contact purchaser, String organizationName, Product2 product, String membershipType
    ) {
        return new Membership_Form_Submission__c(
            FirstName__c = purchaser.FirstName, LastName__c = purchaser.LastName, Email__c = purchaser.Email,
            OrganizationName__c = organizationName, Product_SKU__c = product.StockKeepingUnit,
            SalePrice__c = 100, MembershipType__c = membershipType
        );
    }

    /** Adds gift recipient details to a submission. The recipient does not exist yet. */
    public static Membership_Form_Submission__c withRecipient(
        Membership_Form_Submission__c mfs, String firstName, String lastName
    ) {
        mfs.RecipientFirstName__c = firstName;
        mfs.RecipientLastName__c = lastName;
        mfs.RecipientEmail__c = (firstName + '.' + lastName + '@example.com').toLowerCase();
        mfs.RecipientStreet__c = '1 Gift Lane';
        mfs.RecipientCity__c = 'Giftville';
        mfs.RecipientState__c = 'CA';
        mfs.RecipientZip__c = '90001';
        mfs.RecipientCountry__c = 'United States';
        return mfs;
    }
}
