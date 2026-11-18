/**
 * The Contact step must stop the submission when it can't create a Contact (#272, DEP-02).
 *
 * Architecture rule D3: a DPEV listener either marks its step complete or sets Status__c = Failed.
 * When Create_Contact faults, DPEV_Listener_Find_Create_Contact used to record only
 * Failure_Information__c. Contact__c stayed blank and Status__c stayed blank, so the MFS update
 * re-fired the BPEV listener, which published the Contact DPEV again, indefinitely.
 *
 * MfsPipelineDriver.runIntake() stops after MAX_INTAKE_ROUNDS, so the loop is bounded here.
 */
@IsTest
private class ContactStepFailure_TEST {

    static final String CONTACT_FAILURE = 'Unable to create new contact record';

    /**
     * A submission with no last name. Contact.LastName is required, so Create_Contact faults.
     * No organisation name, so the Account step is Skipped and the Contact step runs next.
     */
    @IsTest
    static void contactCreateFails_submissionFailsInsteadOfLooping() {
        Product2 annual = MembershipTestData.membershipProduct('ANNUAL', 1, 1);
        Contact noLastName = new Contact(FirstName = 'Nolan', Email = 'nolan.nolast@example.com');

        MfsPipelineDriver driver = MfsPipelineDriver.submit(
            MembershipTestData.submission(noLastName, (String) null, annual, 'Individual'));
        driver.runIntake();

        Membership_Form_Submission__c m = driver.mfs();
        Assert.areEqual('Failed', m.Status__c, 'The Contact step must fail the submission, not retry it.' + driver.trail());
        Assert.isNull(m.Contact__c, 'No Contact can be linked.' + driver.trail());
        Assert.areEqual(CONTACT_FAILURE, m.Failure_Information__c, 'Failure_Information__c.' + driver.trail());

        // Failed is terminal: further rounds start nothing.
        driver.deliverOnce('after failure');
        driver.deliverOnce('after failure');
        Assert.areEqual('Failed', driver.mfs().Status__c, 'Failed must stay terminal.' + driver.trail());
        Assert.areEqual(0, [SELECT COUNT() FROM Contact], 'No Contact is created.' + driver.trail());
        Assert.areEqual(0, [SELECT COUNT() FROM Opportunity], 'No Opportunity is created.' + driver.trail());
        Assert.areEqual(0, [SELECT COUNT() FROM Membership__c], 'No Membership is created.' + driver.trail());
    }
}
