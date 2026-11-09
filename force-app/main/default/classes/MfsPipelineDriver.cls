/**
 * Drives one Membership Form Submission (MFS) through the event pipeline in an Apex test, and
 * keeps a trail of what changed after each round so failing assertions explain themselves.
 *
 * See Documentation/Automated Testing.md. In short:
 *   - One Test.getEventBus().deliver() delivers one round of events.
 *   - A deliver() that delivers events resets the test's static variables. All state here is
 *     instance state; never keep test state in statics.
 *   - Extra deliver() calls on an empty bus do nothing, so the phases below over-deliver safely.
 *
 * Usage:
 *   MfsPipelineDriver driver = MfsPipelineDriver.submit(mfs);   // inserts; the auditor queues the BPEV
 *   driver.runIntake();          // Account ... Opportunity, until Status__c is set
 *   // assert the intake outcome
 *   driver.runMembershipStep();  // Test.startTest(), then the recipient and membership DPEVs
 *   // assert the membership outcome
 */
@IsTest
public class MfsPipelineDriver {

    /** Delivering rounds an intake takes with every lookup blank (verified: 13, two per step + the final pass). */
    public static final Integer MAX_INTAKE_ROUNDS = 16;
    /** Rounds after intake: recipient, finder, transaction, create/renew/change (verified: 3 for a new membership). */
    public static final Integer MEMBERSHIP_ROUNDS = 6;

    public final Id mfsId;
    public final List<String> lines = new List<String>();
    Integer round = 0;

    MfsPipelineDriver(Id mfsId) {
        this.mfsId = mfsId;
    }

    /** Checks the scenario's setup data started nothing, then inserts the submission. */
    public static MfsPipelineDriver submit(Membership_Form_Submission__c mfs) {
        assertSetupInert();
        insert mfs;
        MfsPipelineDriver driver = new MfsPipelineDriver(mfs.Id);
        driver.snap('inserted');
        return driver;
    }

    /**
     * Delivers anything setup queued, and fails if it created a Membership or Opportunity.
     * Setup must not start the pipeline; see MembershipTestData.
     */
    static void assertSetupInert() {
        Integer memberships = [SELECT COUNT() FROM Membership__c];
        Integer opportunities = [SELECT COUNT() FROM Opportunity];
        Test.getEventBus().deliver();
        Assert.areEqual(memberships, [SELECT COUNT() FROM Membership__c], 'Setup data started the pipeline: a Membership was created.');
        Assert.areEqual(opportunities, [SELECT COUNT() FROM Opportunity], 'Setup data started the pipeline: an Opportunity was created.');
    }

    /** Delivers rounds until the MFS reaches a status (Imported or Failed), or MAX_INTAKE_ROUNDS. */
    public MfsPipelineDriver runIntake() {
        for (Integer i = 0; i < MAX_INTAKE_ROUNDS; i++) {
            Membership_Form_Submission__c m = deliverOnce('intake');
            if (m.Status__c != null) {
                break;
            }
        }
        return this;
    }

    /**
     * Starts fresh governor limits, then delivers the rounds that run the recipient and membership
     * steps. Call once per test, after runIntake().
     */
    public MfsPipelineDriver runMembershipStep() {
        Test.startTest();
        for (Integer i = 0; i < MEMBERSHIP_ROUNDS; i++) {
            deliverOnce('membership');
        }
        return this;
    }

    /** One deliver(), then a snapshot line. */
    public Membership_Form_Submission__c deliverOnce(String phase) {
        Test.getEventBus().deliver();
        round++;
        return snap(phase + ' #' + round);
    }

    /** The submission as it is now. */
    public Membership_Form_Submission__c mfs() {
        return [
            SELECT Status__c, Failure_Information__c, Account__c, Account_Import_Status__c, Contact__c,
                   Product__c, Campaign_Import_Status__c, Price_Book_Entry__c, Opportunity__c,
                   Recipient__c, Membership__c, Membership_Finder_Ran__c, Membership_Product_Changed__c
            FROM Membership_Form_Submission__c WHERE Id = :mfsId
        ];
    }

    Membership_Form_Submission__c snap(String label) {
        Membership_Form_Submission__c m = mfs();
        lines.add(label
            + ' | Status=' + m.Status__c
            + ' Account=' + flag(m.Account__c) + '(' + m.Account_Import_Status__c + ')'
            + ' Contact=' + flag(m.Contact__c) + ' Product=' + flag(m.Product__c)
            + ' Campaign=' + m.Campaign_Import_Status__c + ' PBE=' + flag(m.Price_Book_Entry__c)
            + ' Opp=' + flag(m.Opportunity__c) + ' Recipient=' + flag(m.Recipient__c)
            + ' Membership=' + flag(m.Membership__c) + ' FinderRan=' + m.Membership_Finder_Ran__c
            + ' ProductChanged=' + m.Membership_Product_Changed__c
            + (m.Failure_Information__c == null ? '' : ' FAILURE=' + m.Failure_Information__c));
        return m;
    }

    static String flag(Object value) {
        return value == null ? '-' : 'Y';
    }

    /** The trail, for assertion messages. */
    public String trail() {
        return '\nPipeline trail:\n' + String.join(lines, '\n');
    }
}
