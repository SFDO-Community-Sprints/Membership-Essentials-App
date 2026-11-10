/**
 * Exercises the shared Flow and its three platform-event callers in an org.
 * Explicit calendar expectations cover both conventions; the active metadata record selects one.
 * Run this suite with the shipped default, Anniversary, and absent/blank settings (see the issue
 * verification document). No production Apex is needed for the calculation.
 */
@IsTest
private class MembershipTermEnd_TEST {
    static Boolean anniversaryConvention() {
        List<Membership_Essentials_Setting__mdt> settings = [
            SELECT Term_End_Convention__c FROM Membership_Essentials_Setting__mdt
            WHERE DeveloperName = 'MembershipEssentialsDefaults'
        ];
        return !settings.isEmpty() && settings[0].Term_End_Convention__c == 'Anniversary';
    }

    static Flow.Interview calculate(Date referenceDate, Decimal term, String unit) {
        Flow.Interview interview = Flow.Interview.createInterview('Calculate_Membership_Term_End_Date',
            new Map<String, Object>{ 'ReferenceDate' => referenceDate, 'Term' => term, 'TermUnit' => unit });
        interview.start();
        return interview;
    }

    static void assertDate(Date referenceDate, Decimal term, String unit, Date before, Date anniversary) {
        Flow.Interview interview = calculate(referenceDate, term, unit);
        Assert.areEqual(true, interview.getVariableValue('IsValid'), 'Valid ' + term + ' ' + unit);
        Assert.isTrue(String.isBlank((String) interview.getVariableValue('ErrorMessage')));
        Assert.areEqual(anniversaryConvention() ? anniversary : before,
            interview.getVariableValue('EndDate'), referenceDate + ' + ' + term + ' ' + unit);
    }

    @IsTest static void calendarTermsUseConfiguredConvention() {
        Date referenceDate = Date.newInstance(2026, 11, 8);
        assertDate(referenceDate, 3, 'Year', Date.newInstance(2029, 11, 7), Date.newInstance(2029, 11, 8));
        assertDate(referenceDate, 3, 'Month', Date.newInstance(2027, 2, 7), Date.newInstance(2027, 2, 8));
        assertDate(referenceDate, 3, 'Week', Date.newInstance(2026, 11, 28), Date.newInstance(2026, 11, 29));
        assertDate(referenceDate, 3, 'Day', Date.newInstance(2026, 11, 10), Date.newInstance(2026, 11, 11));
        // A one-day term ends on the start date under the inclusive/default convention.
        assertDate(referenceDate, 1, 'Day', referenceDate, Date.newInstance(2026, 11, 9));
    }

    @IsTest static void calendarBoundariesUseSalesforceAddMonths() {
        assertDate(Date.newInstance(2028, 2, 29), 1, 'Year',
            Date.newInstance(2029, 2, 27), Date.newInstance(2029, 2, 28));
        assertDate(Date.newInstance(2027, 1, 31), 1, 'Month',
            Date.newInstance(2027, 2, 27), Date.newInstance(2027, 2, 28));
        assertDate(Date.newInstance(2028, 1, 31), 1, 'Month',
            Date.newInstance(2028, 2, 28), Date.newInstance(2028, 2, 29));
        // ADDMONTHS preserves an end-of-month reference when moving to a longer month.
        assertDate(Date.newInstance(2027, 2, 28), 1, 'Month',
            Date.newInstance(2027, 3, 30), Date.newInstance(2027, 3, 31));
    }

    static void assertInvalid(Date referenceDate, Decimal term, String unit, String messagePart) {
        Flow.Interview interview = calculate(referenceDate, term, unit);
        Assert.areEqual(false, interview.getVariableValue('IsValid'));
        Assert.isNull(interview.getVariableValue('EndDate'), 'Invalid input must never return an end date');
        Assert.isTrue(((String) interview.getVariableValue('ErrorMessage')).contains(messagePart));
    }

    @IsTest static void invalidInputsReturnClearErrors() {
        Date referenceDate = Date.newInstance(2026, 11, 8);
        assertInvalid(null, 1, 'Year', 'reference date');
        assertInvalid(referenceDate, null, 'Year', 'positive whole number');
        assertInvalid(referenceDate, 0, 'Year', 'positive whole number');
        assertInvalid(referenceDate, -1, 'Year', 'positive whole number');
        assertInvalid(referenceDate, 1.5, 'Month', 'positive whole number');
        assertInvalid(referenceDate, 1, null, 'term unit');
        assertInvalid(referenceDate, 1, '', 'term unit');
        assertInvalid(referenceDate, 1, 'Fortnight', 'term unit');
    }

    @IsTest static void outOfRangeTermsReturnClearErrors() {
        assertInvalid(Date.newInstance(2026, 11, 8), 10000, 'Year', 'supported date range');
        assertInvalid(Date.newInstance(9999, 12, 31), 1, 'Day', 'supported date range');
        assertInvalid(Date.newInstance(9999, 12, 1), 1, 'Month', 'supported date range');
        assertInvalid(Date.newInstance(9999, 12, 25), 1, 'Week', 'supported date range');
    }

    @IsTest static void invocablePreservesBulkInputOrderAndValidation() {
        List<MembershipTermEndAction.Request> requests = new List<MembershipTermEndAction.Request>();
        for (Integer i = 0; i < 200; i++) {
            MembershipTermEndAction.Request request = new MembershipTermEndAction.Request();
            request.referenceDate = Date.newInstance(2026, 11, 8).addDays(i);
            request.term = i == 199 ? 0 : 3;
            request.termUnit = 'Year';
            requests.add(request);
        }
        Test.startTest();
        Integer beforeQueries = Limits.getQueries();
        List<MembershipTermEndAction.Result> results = MembershipTermEndAction.calculate(requests);
        Integer queries = Limits.getQueries() - beforeQueries;
        Test.stopTest();
        Assert.isTrue(queries < 5, 'Settings retrieval must stay bulkified for 200 inputs. Queries: ' + queries);
        Assert.areEqual(200, results.size());
        Boolean anniversary = anniversaryConvention();
        for (Integer i = 0; i < 199; i++) {
            Assert.areEqual(true, results[i].isValid, 'Validation result: ' + results[i].errorMessage);
            Assert.areEqual(requests[i].referenceDate.addMonths(36).addDays(anniversary ? 0 : -1),
                results[i].endDate, 'Result must correspond to input ' + i);
        }
        Assert.areEqual(false, results[199].isValid);
        Assert.isNull(results[199].endDate);
        Assert.isTrue(results[199].errorMessage.contains('positive whole number'));
    }

    private class Purchase {
        Product2 product;
        Membership__c membership;
        Membership_Form_Submission__c submission;
        Opportunity opportunity;
        OpportunityLineItem line;
    }

    static Purchase purchase(String motion, Decimal term, String unit) {
        Purchase p = new Purchase();
        MembershipTestData.Household h = MembershipTestData.household('Term', motion);
        p.product = MembershipTestData.membershipProduct('TERM-' + motion, 3, 1);
        // Prevent unrelated OLI automation from queuing a second business process during setup.
        p.product.Family = null;
        p.product.Term__c = term;
        p.product.Term_Unit__c = unit;
        update p.product;
        p.opportunity = new Opportunity(Name = 'Term ' + motion, AccountId = h.account.Id,
            StageName = 'Closed Won', CloseDate = Date.newInstance(2026, 1, 15),
            Pricebook2Id = Test.getStandardPricebookId());
        insert p.opportunity;
        if (motion != 'Create') {
            Product2 oldProduct = MembershipTestData.membershipProduct('OLD-' + motion, 1, 2);
            p.membership = new Membership__c(Name = 'Before ' + motion, Account__c = h.account.Id,
                Primary_Contact__c = h.contact.Id, Product__c = oldProduct.Id, Type__c = 'Household',
                Status__c = 'Current', Start_Date__c = Date.today().addYears(-1),
                End_Date__c = Date.today().addDays(10), Opportunity__c = p.opportunity.Id);
            insert p.membership;
        }
        p.line = new OpportunityLineItem(OpportunityId = p.opportunity.Id,
            PricebookEntryId = [SELECT Id FROM PricebookEntry WHERE Product2Id = :p.product.Id LIMIT 1].Id,
            Quantity = 1, UnitPrice = 100, Membership__c = p.membership == null ? null : p.membership.Id);
        insert p.line;
        p.submission = new Membership_Form_Submission__c(Status__c = 'Imported',
            Account__c = h.account.Id, Contact__c = h.contact.Id, Product__c = p.product.Id,
            Opportunity__c = p.opportunity.Id, Membership__c = p.membership == null ? null : p.membership.Id,
            MembershipType__c = 'Household', Membership_Finder_Ran__c = true);
        insert p.submission;
        p.product.Family = 'Membership';
        update p.product;
        return p;
    }

    static void publish(Purchase p, String motion) {
        if (motion == 'Create') {
            Assert.isTrue(EventBus.publish(new DPEV_Create_Membership__e(Record_Id__c = p.line.Id)).isSuccess());
        } else if (motion == 'Upgrade') {
            Assert.isTrue(EventBus.publish(new DPEV_Membership_Upgrade__e(Record_Id__c = p.submission.Id)).isSuccess());
        } else {
            Assert.isTrue(EventBus.publish(new DPEV_Membership_Downgrade__e(Record_Id__c = p.submission.Id)).isSuccess());
        }
        Test.getEventBus().deliver();
    }

    static void assertCallerDate(String motion) {
        Purchase p = purchase(motion, 3, 'Year');
        Test.startTest();
        publish(p, motion);
        Membership_Form_Submission__c mfs = [SELECT Membership__c, Status__c, Failure_Information__c
            FROM Membership_Form_Submission__c WHERE Id = :p.submission.Id];
        Assert.areNotEqual('Failed', mfs.Status__c, 'MFS failure: ' + mfs.Failure_Information__c);
        Assert.isNotNull(mfs.Membership__c);
        Membership__c membership = [SELECT Product__c, End_Date__c FROM Membership__c WHERE Id = :mfs.Membership__c];
        Date referenceDate = motion == 'Downgrade' ? p.opportunity.CloseDate : Date.today();
        Date expected = referenceDate.addMonths(36).addDays(anniversaryConvention() ? 0 : -1);
        Assert.areEqual(p.product.Id, membership.Product__c);
        Assert.areEqual(expected, membership.End_Date__c, motion + ' reference date and shared convention');
        Test.stopTest();
    }

    @IsTest static void createUsesTodayAndSharedConvention() { assertCallerDate('Create'); }
    @IsTest static void upgradeUsesTodayAndSharedConvention() { assertCallerDate('Upgrade'); }
    @IsTest static void downgradeRetainsCloseDateAndUsesSharedConvention() { assertCallerDate('Downgrade'); }

    static void assertCallerFails(String motion, Decimal term, String unit, String expectedMessage) {
        Purchase p = purchase(motion, term, unit);
        Test.startTest();
        publish(p, motion);
        Membership_Form_Submission__c mfs = [SELECT Membership__c, Status__c, Failure_Information__c
            FROM Membership_Form_Submission__c WHERE Id = :p.submission.Id];
        Assert.areEqual('Failed', mfs.Status__c, motion + ' must stop the MFS');
        Assert.isTrue(mfs.Failure_Information__c != null && mfs.Failure_Information__c.contains(expectedMessage),
            'Clear ' + motion + ' failure: ' + mfs.Failure_Information__c);
        if (p.membership == null) {
            Assert.isNull(mfs.Membership__c);
            Assert.areEqual(0, [SELECT COUNT() FROM Membership__c], 'No partial membership');
        } else {
            Membership__c unchanged = [SELECT Product__c, End_Date__c FROM Membership__c WHERE Id = :p.membership.Id];
            Assert.areEqual(p.membership.Product__c, unchanged.Product__c, 'Invalid term must not change the product');
            Assert.areEqual(p.membership.End_Date__c, unchanged.End_Date__c, 'Invalid term must not change the date');
        }
        Test.stopTest();
    }

    @IsTest static void createRejectsMissingTerm() { assertCallerFails('Create', null, 'Year', 'positive whole number'); }
    @IsTest static void upgradeRejectsZeroTerm() { assertCallerFails('Upgrade', 0, 'Year', 'positive whole number'); }
    @IsTest static void downgradeRejectsMissingUnit() { assertCallerFails('Downgrade', 3, null, 'term unit'); }
}
