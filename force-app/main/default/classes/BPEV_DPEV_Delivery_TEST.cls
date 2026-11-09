/**
 * Proof of concept: can an Apex unit test drive the BPEV -> DPEV chain?
 *
 * Each test publishes one platform event from Apex, then calls
 * Test.getEventBus().deliver() three times, snapshotting after each call. A DPEV
 * listener flow is detected by its side effects: Membership_Essentials_Event_Log__c
 * rows stamped with the listener's Flow_Name__c, plus the field updates it makes on
 * the Membership Form Submission (MFS).
 *
 * Every MFS is inserted with Status__c = 'Imported' so the record-triggered
 * "MFS auditor" flow does not publish its own BPEV -- the only BPEV in each test is
 * the one published explicitly here.
 *
 * Finding (verified in a dev scratch org, API 68.0): one deliver() call delivers one
 * generation of events. The first call runs the BPEV listener; the DPEV it publishes
 * (PublishAfterCommit) is queued and is delivered by the *second* call. A third call
 * is a no-op.
 *
 * The deliver() calls are deliberately written out in the test body rather than
 * looped. A for loop wrapping deliver() plus these snapshots exited after two
 * iterations, and in one variant threw a NullPointerException, right after the
 * second-generation delivery. Simpler loops did not reproduce it, and the cause
 * is not isolated.
 */
@IsTest
private class BPEV_DPEV_Delivery_TEST {

    static final String BPEV_LISTENER    = 'BPEV Listener - Membership Form Business Process';
    static final String ACCOUNT_LISTENER = 'DPEV Listener - Find/Create Account';
    static final String FINDER_LISTENER  = 'DPEV Listener - Membership Finder';

    // ---------------------------------------------------------------- helpers

    static Membership_Form_Submission__c newMfs() {
        return new Membership_Form_Submission__c(
            Status__c = 'Imported',          // suppress the after-save auditor's BPEV
            FirstName__c = 'Poc',
            LastName__c = 'Tester',
            Email__c = 'poc.tester@example.com',
            OrganizationName__c = 'POC Delivery Org'
        );
    }

    static void publishBpev(Id mfsId) {
        Database.SaveResult sr = EventBus.publish(
            new BPEV_Membership_Form_Submission__e(Membership_Form_Submission_Id__c = mfsId)
        );
        Assert.isTrue(sr.isSuccess(), 'BPEV publish failed: ' + sr.getErrors());
    }

    /** Log rows per Flow_Name__c for one MFS, plus a readable line for assertion messages. */
    class Snapshot {
        Map<String, Integer> logs = new Map<String, Integer>();
        String line;

        Snapshot(Id mfsId, String label) {
            for (AggregateResult ar : [
                SELECT Flow_Name__c fn, COUNT(Id) c FROM Membership_Essentials_Event_Log__c
                WHERE Membership_Form_Submission__c = :mfsId GROUP BY Flow_Name__c
            ]) {
                logs.put((String) ar.get('fn'), (Integer) ar.get('c'));
            }
            Membership_Form_Submission__c m = [
                SELECT Status__c, Account__c, Account_Import_Status__c, Membership_Finder_Ran__c
                FROM Membership_Form_Submission__c WHERE Id = :mfsId
            ];
            line = label + ' | logs=' + JSON.serialize(logs)
                + ' | Status=' + m.Status__c
                + ' | Account__c=' + m.Account__c
                + ' | AccountImport=' + m.Account_Import_Status__c
                + ' | FinderRan=' + m.Membership_Finder_Ran__c;
            System.debug('POC ' + line);
        }

        Integer count(String flowName) {
            Integer c = logs.get(flowName);
            return c == null ? 0 : c;
        }
    }

    static String trail(List<Snapshot> snaps) {
        List<String> lines = new List<String>();
        for (Snapshot s : snaps) {
            lines.add(s.line);
        }
        return '\n' + String.join(lines, '\n');
    }

    // ------------------------------------------------------------------ tests

    /**
     * Control A: a DPEV published directly from Apex reaches its listener flow on the
     * first deliver(). If this fails, DPEV listeners don't run under test at all and
     * the chain tests below are moot.
     */
    @IsTest
    static void controlA_dpevPublishedFromApex_isDeliveredOnFirstDeliver() {
        Membership_Form_Submission__c mfs = newMfs();
        insert mfs;

        Database.SaveResult sr = EventBus.publish(new DPEV_Account__e(Record_Id__c = mfs.Id));
        Assert.isTrue(sr.isSuccess(), 'DPEV publish failed: ' + sr.getErrors());

        Snapshot s0 = new Snapshot(mfs.Id, 'before deliver');
        Test.getEventBus().deliver();
        Snapshot s1 = new Snapshot(mfs.Id, 'after deliver #1');
        Test.getEventBus().deliver();
        Snapshot s2 = new Snapshot(mfs.Id, 'after deliver #2');
        String detail = trail(new List<Snapshot>{ s0, s1, s2 });

        Assert.areEqual(0, s0.count(ACCOUNT_LISTENER), 'Listener ran before deliver().' + detail);
        Assert.isTrue(s1.count(ACCOUNT_LISTENER) > 0,
            'Account listener did not run on deliver #1 for an Apex-published DPEV.' + detail);
        Assert.areEqual(s1.count(ACCOUNT_LISTENER), s2.count(ACCOUNT_LISTENER),
            'A further deliver() should be a no-op once the bus is drained.' + detail);
    }

    /**
     * Chain B: BPEV (Apex) -> BPEV listener publishes DPEV_Account__e -> Account listener.
     * The MFS has no Account, so the BPEV listener's first decision publishes
     * DPEV_Account__e. On this branch the BPEV listener writes no log of its own;
     * Chain C proves the BPEV listener runs on deliver #1.
     */
    @IsTest
    static void chainB_bpevToAccountDpev_deliveredOnSecondDeliver() {
        Membership_Form_Submission__c mfs = newMfs();
        insert mfs;
        publishBpev(mfs.Id);

        Snapshot s0 = new Snapshot(mfs.Id, 'before deliver');
        Test.getEventBus().deliver();   // BPEV -> BPEV listener; publishes DPEV_Account__e
        Snapshot s1 = new Snapshot(mfs.Id, 'after deliver #1');
        Test.getEventBus().deliver();   // DPEV_Account__e -> Account listener
        Snapshot s2 = new Snapshot(mfs.Id, 'after deliver #2');
        Test.getEventBus().deliver();   // nothing left
        Snapshot s3 = new Snapshot(mfs.Id, 'after deliver #3');
        String detail = trail(new List<Snapshot>{ s0, s1, s2, s3 });

        Assert.areEqual(0, s1.count(ACCOUNT_LISTENER),
            'Expected the DPEV to wait for a second deliver().' + detail);
        Assert.isTrue(s2.count(ACCOUNT_LISTENER) > 0,
            'DPEV_Account__e published by the BPEV listener flow was not delivered on deliver #2.' + detail);
        Assert.areEqual(s2.count(ACCOUNT_LISTENER), s3.count(ACCOUNT_LISTENER),
            'deliver #3 should be a no-op.' + detail);
        Assert.isNotNull(
            [SELECT Account__c FROM Membership_Form_Submission__c WHERE Id = :mfs.Id].Account__c,
            'Account listener should have linked an Account to the MFS.' + detail);
    }

    /**
     * Chain D: the realistic entry point. Insert an MFS (Status__c unset) and let the
     * after-save auditor flow publish the BPEV; deliver once for the BPEV listener, then
     * Test.startTest() and deliver again for the DPEV. Snapshots after Test.stopTest()
     * show whether stopTest() also delivers the next hop of the recursion.
     */
    @IsTest
    static void chainD_insertMfs_deliver_startTest_deliver() {
        Membership_Form_Submission__c mfs = newMfs();
        mfs.Status__c = null;            // let the auditor publish the BPEV
        insert mfs;

        Snapshot s0 = new Snapshot(mfs.Id, 'after insert');
        Test.getEventBus().deliver();   // BPEV (from auditor) -> BPEV listener; publishes DPEV_Account__e
        Snapshot s1 = new Snapshot(mfs.Id, 'after deliver #1');

        Test.startTest();
        Test.getEventBus().deliver();   // DPEV_Account__e -> Account listener
        Snapshot s2 = new Snapshot(mfs.Id, 'after startTest + deliver #2');
        Test.stopTest();
        Snapshot s3 = new Snapshot(mfs.Id, 'after stopTest');
        String detail = trail(new List<Snapshot>{ s0, s1, s2, s3 });

        Assert.areEqual(0, s1.count(ACCOUNT_LISTENER),
            'Expected the DPEV to wait for a second deliver().' + detail);
        Assert.isTrue(s2.count(ACCOUNT_LISTENER) > 0,
            'DPEV_Account__e was not delivered on the deliver() after Test.startTest().' + detail);
        Assert.isNotNull(
            [SELECT Account__c FROM Membership_Form_Submission__c WHERE Id = :mfs.Id].Account__c,
            'Account listener should have linked an Account to the MFS.' + detail);
    }

    /**
     * Chain C: BPEV (Apex) -> BPEV listener (logs + publishes DPEV_Membership_Finder__e)
     * -> Membership Finder listener.
     * Every lookup is populated, so the BPEV listener walks to the end: it marks the MFS
     * Imported, writes its logs, and publishes DPEV_Membership_Finder__e -- so we can see
     * the BPEV listener ran on deliver #1 and its DPEV landed on deliver #2.
     */
    @IsTest
    static void chainC_bpevToMembershipFinderDpev_deliveredOnSecondDeliver() {
        Account acct = new Account(Name = 'POC Delivery Org');
        insert acct;
        Contact con = new Contact(FirstName = 'Poc', LastName = 'Tester', AccountId = acct.Id);
        insert con;
        Product2 prod = new Product2(Name = 'POC Membership', IsActive = true);
        insert prod;
        Opportunity opp = new Opportunity(
            Name = 'POC Opp', StageName = 'Prospecting', CloseDate = Date.today(), AccountId = acct.Id
        );
        insert opp;

        Membership_Form_Submission__c mfs = newMfs();
        mfs.Account__c = acct.Id;
        mfs.Contact__c = con.Id;
        mfs.Product__c = prod.Id;
        mfs.Campaign_Import_Status__c = 'Skipped';
        mfs.Price_Book_Entry__c = 'poc-placeholder';   // Text field; the decision only checks non-null
        mfs.Opportunity__c = opp.Id;
        insert mfs;
        publishBpev(mfs.Id);

        Snapshot s0 = new Snapshot(mfs.Id, 'before deliver');
        Test.getEventBus().deliver();   // BPEV -> BPEV listener; publishes DPEV_Membership_Finder__e
        Snapshot s1 = new Snapshot(mfs.Id, 'after deliver #1');
        Test.getEventBus().deliver();   // DPEV_Membership_Finder__e -> Finder listener
        Snapshot s2 = new Snapshot(mfs.Id, 'after deliver #2');
        Test.getEventBus().deliver();   // nothing left
        Snapshot s3 = new Snapshot(mfs.Id, 'after deliver #3');
        String detail = trail(new List<Snapshot>{ s0, s1, s2, s3 });

        Assert.isTrue(s1.count(BPEV_LISTENER) > 0,
            'BPEV listener did not run on deliver #1 -- chain could not start.' + detail);
        Assert.areEqual(0, s1.count(FINDER_LISTENER),
            'Expected the DPEV to wait for a second deliver().' + detail);
        Assert.isTrue(s2.count(FINDER_LISTENER) > 0,
            'DPEV_Membership_Finder__e published by the BPEV listener flow was not delivered on deliver #2.' + detail);
        Assert.areEqual(s2.count(FINDER_LISTENER), s3.count(FINDER_LISTENER),
            'deliver #3 should be a no-op.' + detail);
        Assert.isTrue(
            [SELECT Membership_Finder_Ran__c FROM Membership_Form_Submission__c WHERE Id = :mfs.Id].Membership_Finder_Ran__c,
            'Finder listener should have set Membership_Finder_Ran__c.' + detail);
    }
}
