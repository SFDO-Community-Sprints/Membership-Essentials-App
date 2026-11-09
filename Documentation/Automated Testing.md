# Automated Testing

How to test Membership Essentials' event-driven flows from Apex unit tests: how platform events are delivered in a test, the pattern for testing one processing step, and the traps found while working this out. Written for contributors adding test coverage to flows, events, or processing Apex.

**Where this comes from.** Everything below marked *verified* was run in a dev scratch org (API 68.0) on 2026-11-08, against the flows at their active version 1, using [`BPEV_DPEV_Delivery_TEST`](../force-app/main/default/classes/BPEV_DPEV_Delivery_TEST.cls) and the scenario suite ([`MembershipScenarios_TEST`](../force-app/main/default/classes/MembershipScenarios_TEST.cls) and its helpers). Anything marked *expected* was read from the flow metadata and has not been run. Read [Architecture.md](Architecture.md) first for the BPEV/DPEV design this builds on.

---

## How event delivery works in a test

In an Apex test, platform events are **queued, not delivered**. Nothing runs on its own, and you can't wait for it. A queued event reaches its subscribers only when the test calls one of these:

- `Test.getEventBus().deliver()`
- `Test.stopTest()`

**One call delivers one round of events.** *(Verified.)* Suppose a subscriber flow publishes another event while it runs. That new event goes into the queue and waits for the *next* call. It is not delivered in the same call. This holds for the `PublishAfterCommit` DPEVs as well as the `PublishImmediately` BPEV.

So each step of the MFS cycle ([Architecture.md, Overview](Architecture.md#overview)) costs one call:

| Test code | What runs | *Verified* outcome, account branch |
|---|---|---|
| `insert mfs` | Record-triggered auditor flow publishes the BPEV | BPEV queued |
| `deliver()` #1 | BPEV listener decides, publishes one DPEV | DPEV queued; nothing on the MFS yet |
| `deliver()` #2 | DPEV listener does its task and updates the MFS. The update re-fires the auditor, which publishes the next BPEV | `Account__c` set, `Account_Import_Status__c = Imported` |
| `deliver()` #3 or `Test.stopTest()` | BPEV listener runs again ([R1](Architecture.md#r-recursion-and-exit-conditions)) and publishes the next DPEV | next DPEV queued |

A call with nothing in the queue does nothing, so an extra call is harmless.

**A call that delivers events resets the test class's static variables.** *(Verified.)* After a `deliver()` that runs subscribers, every static in the test class is back at its initial value: a counter set to 43 reads 0, and a `static final` list is empty again. A `deliver()` with nothing queued leaves statics alone. Keep all test state (record Ids, trails, counters) in local variables or instance fields. See [Traps](#traps).

---

## Pattern: testing one DPEV step

Start the cycle the way production does, then deliver once per step and assert on what the DPEV changed:

```apex
@IsTest
static void accountDpev_linksAccount() {
    Membership_Form_Submission__c mfs = new Membership_Form_Submission__c(
        FirstName__c = 'Poc', LastName__c = 'Tester',
        Email__c = 'poc.tester@example.com', OrganizationName__c = 'POC Org'
    );
    insert mfs;                         // auditor publishes the BPEV

    Test.getEventBus().deliver();       // step 1: BPEV listener publishes DPEV_Account__e

    Test.startTest();                   // fresh governor limits for the step under test
    Test.getEventBus().deliver();       // step 2: Account listener runs

    // Assert here, before stopTest()
    Membership_Form_Submission__c after = [
        SELECT Account__c, Account_Import_Status__c
        FROM Membership_Form_Submission__c WHERE Id = :mfs.Id
    ];
    Assert.isNotNull(after.Account__c);
    Assert.areEqual('Imported', after.Account_Import_Status__c);

    Test.stopTest();                    // note: this delivers one more round
}
```

`Test.startTest()` does not change how delivery works. *(Verified.)* It only gives the step you're testing its own governor limits.

### Where to assert

- **After the `deliver()` that runs the DPEV, before `Test.stopTest()`.** At that point the test sees exactly what the DPEV did. `stopTest()` delivers another round *(verified)*: the BPEV listener runs again and queues the next DPEV. On the account branch that changes nothing the test checks. On other branches a later step could change the fields you assert on.
- **Assert on what the DPEV changed, not on log rows.** Fields on the MFS and the records the DPEV created are what the step is for. Log rows are fragile for two reasons:
  - Today the flows insert `Membership_Essentials_Event_Log__c` directly. Rule [L1](Architecture.md#l-logging) says they should publish the log DPEV, so log rows will move one `deliver()` later once that is fixed.
  - The setting in `Membership_Essentials_Setting__mdt` can turn logging off.

  Log rows are still useful for proving that a flow *ran* when it leaves nothing else behind (see below).

---

## Isolating a step

### Testing one BPEV listener decision

Insert the MFS with `Status__c = 'Imported'` and publish the BPEV yourself:

```apex
mfs.Status__c = 'Imported';   // the auditor's entry criteria exclude Imported and Failed
insert mfs;
EventBus.publish(new BPEV_Membership_Form_Submission__e(Membership_Form_Submission_Id__c = mfs.Id));
```

Then the only BPEV in the test is the one you published, and the DPEV listener's MFS update doesn't start another round. *(Verified)* on the Account and Membership Finder branches. Neither the BPEV listener nor those two DPEV listeners branch on `Status__c` (*expected*, from the metadata). Check that's still true for the branch you're testing.

Use the MFS's lookup fields to choose which branch the BPEV listener takes:

- An MFS with no `Account__c` goes down the Account branch.
- An MFS with every lookup filled in goes to the Membership Finder.

`Price_Book_Entry__c` is a text field, and the decision only checks that it isn't null.

### Testing a DPEV listener on its own

Publish the DPEV directly. It's delivered on the first call *(verified)*:

```apex
EventBus.publish(new DPEV_Account__e(Record_Id__c = mfs.Id));
Test.getEventBus().deliver();
```

### Publishing events

Apex can't `insert` a platform event. Use `EventBus.publish(...)`, or insert or update an MFS and let the auditor flow publish the BPEV. Flows use Create Records for the same thing.

---

## Testing the whole cycle

A full submission runs end to end in an Apex test. *(Verified.)* With every lookup blank, it takes **15 delivering rounds**: two per lookup step, then the membership step. Round 16 delivers nothing.

| Rounds | What runs | MFS after the round |
|---|---|---|
| 1–2 | BPEV listener → Account DPEV | `Account__c` set (`Account_Import_Status__c` = the Account's Id, or `Skipped` with no organisation name) |
| 3–4 | → Contact DPEV | `Contact__c` set |
| 5–6 | → Product DPEV | `Product__c` set |
| 7–8 | → Campaign DPEV | `Campaign_Import_Status__c = Skipped` when the form names no campaign |
| 9–10 | → Price Book Entry DPEV | `Price_Book_Entry__c` set |
| 11–12 | → Opportunity DPEV | `Opportunity__c` set; the line item insert fires `Opportunity_Line_Item_After_Membership` |
| 13 | BPEV listener's last pass | `Status__c = Imported`, and the recipient and membership DPEVs are published in the same pass ([DEP-01](Departures.md#dep-01--imported-is-set-before-the-recipient-and-membership-steps-run)) |
| 14–15 | Finder, transaction, create | `Membership_Finder_Ran__c`, then `Membership__c` set |

Things the full run settled *(verified)*:

- **The Standard Price Book is visible to flows in a test.** `DPEV_Listener_Find_Price_Book_Entry` finds it by name once the test activates it (`update new Pricebook2(Id = Test.getStandardPricebookId(), IsActive = true)`). No `SeeAllData` is needed.
- **Duplicate rules run in a test.** The Contact step matches an existing Contact by name and email through the Standard Contact Duplicate Rule.
- **Account matching needs an address.** The Account step checks the organisation name *and* the MFS billing address against the Standard Account Duplicate Rule. With a name alone it finds no match and creates a second Account with the same name. This happens outside tests too. Test data for an existing Account must give the Account a billing address and send the same address on the MFS. `MembershipTestData` does this.
- **Governor limits are shared with the subscribers.** The flows' queries count against the test's limits. A full submission uses about 15 SOQL queries for intake and about 40 for the membership step. A snapshot query after every round on top of that can pass 100. Call `Test.startTest()` before the membership step for fresh limits; `MfsPipelineDriver` does.
- **A `for` loop around `deliver()` works** as long as its state is local. 16 rounds in a loop matched 16 rounds written out.

Assert as you go: once after intake (Account, Contact, Opportunity) and once after the membership step, rather than only at the end. The trail of snapshots then shows which step diverged.

---

## Scenario tests

The use-case scenarios (consolidated use-case document, "Membership Essentials Use Cases") each describe how **one** submission should behave when the contact already has data. Each test follows the same shape:

```apex
// Arrange: the data the contact already has. Inert: it starts nothing.
Product2 annual = MembershipTestData.membershipProduct('ANNUAL', 1, 1);
MembershipTestData.Household h = MembershipTestData.household('Remy', 'Renewer');
Membership__c existing = MembershipTestData.existingMembership(
    h.account, h.contact, annual, 'Household', 'Current', startDate, endDate);

// Act: one submission through the pipeline, asserting after intake
MfsPipelineDriver driver = MfsPipelineDriver.submit(
    MembershipTestData.submission(h.contact, h.account, annual, 'Household')).runIntake();
MembershipAssert.notFailed(driver);
MembershipAssert.matchedExisting(h, driver);

// ...and after the membership step
driver.runMembershipStep();
MembershipAssert.endDate(existing, endDate.addYears(1), driver);
```

The suite is split so a new scenario is usually a dozen lines:

| Class | Holds |
|---|---|
| [`MembershipTestData`](../force-app/main/default/classes/MembershipTestData.cls) | Builders for products, households, contacts, extra Opportunities, existing memberships and submissions |
| [`MfsPipelineDriver`](../force-app/main/default/classes/MfsPipelineDriver.cls) | Submits the MFS, delivers rounds through intake and the membership step, keeps the snapshot trail |
| [`MembershipAssert`](../force-app/main/default/classes/MembershipAssert.cls) | Checks on the record graph; every message ends with the trail |
| [`MembershipScenarios_TEST`](../force-app/main/default/classes/MembershipScenarios_TEST.cls) | One method per scenario, quoting its user story and expected records |

Rules the helpers rely on:

- **Setup must be inert.** `MfsPipelineDriver.submit` delivers once before inserting the MFS and fails if setup created a Membership or Opportunity. Builders keep setup inert this way:
  - Membership line items carry `Membership__c`; `Opportunity_Line_Item_After_Membership` fires only for Family `Membership` lines with a blank `Membership__c`.
  - Non-membership products leave Family blank (`Product2Family` has only `None` and `Membership`).
  - Historical submissions follow [Importing Membership Form Submissions](Importing%20Membership%20Form%20Submissions.md).
- **No statics.** All three helper classes keep state in instances.
- **Don't assert how Contacts are linked to Accounts.** It's an open item for the sprint; see below.

### Current results

The scenarios assert the intended design, so some fail today. Each failure is the first point where the org and the design diverge. Later assertions in the same test haven't been reached.

| Scenario | Result | First divergence | Issue |
|---|---|---|---|
| Baseline: new purchaser | Pass | | |
| Membership w/ extra gift, option 2 | Pass | | |
| Renewal after end of grace period | Pass | | |
| Buying gift membership | Pass | | |
| Membership with merchandise | Fail | The membership is created, but no membership line is added to the Opportunity the MFS references | New finding |
| Membership w/ extra gift, option 1 | Fail | Same as merchandise | New finding |
| Bundle with fee-for-service products | Fail | Same as merchandise | New finding |
| Renewal before expiration (before it expires) | Fail | The finder matches the membership, but its end date isn't extended | [DEP-06](Departures.md#dep-06--renewal-isnt-implemented) |
| Renewal before expiration (during grace period) | Fail | A second membership is created. The finder only matches `End_Date__c > today`, and no flow reads `Grace_Period__c` | New finding |
| Buying multi-year membership | Fail | Ends 2029-11-04, not 2029-11-07: year terms are computed as 364 days × `Term__c` | New finding |
| Buying multiple memberships for one | Fail | The second purchase matches the first membership, which is of a different type | [DEP-07](Departures.md#dep-07--matching-ignores-membership-type) |
| Buying institutional membership | Fail | The created membership has no `Type__c`; no flow sets it from `MembershipType__c` | New finding |
| Gift and standard membership together | Fail | The gift is matched to the payor's own membership, so no membership is created for the giftee | New finding |

### Open items

- **Linking Contacts to Accounts.** How the pipeline should link a purchaser's or giftee's Contact to an Account is being decided at this sprint. The scenarios don't assert `Contact.AccountId`, or which Account a giftee and a gift membership sit on. Today, an MFS without `OrganizationName__c` creates no Account (`Account_Import_Status__c = Skipped`), and the Opportunity and Membership have no Account *(verified)*.
- **Expected end dates.** The tests expect a term of N years to end the day before the Nth anniversary, and a renewal to extend the old end date by one term, including a renewal paid during the grace period. Both are readings of the design to confirm.
- **Opportunity Contact Roles** aren't asserted; the use-case diagrams don't show them yet.

---

## Traps

**Keep test state out of static variables.** *(Verified.)* A `deliver()` that delivers events resets the test class's statics to their initial values (see [How event delivery works](#how-event-delivery-works-in-a-test)). An Id held in a static becomes null, so a snapshot query finds no rows and the MFS looks deleted; a static list of results empties partway through. This is the likely cause of a problem seen earlier: a `for` loop with snapshots between `deliver()` calls stopped after two passes, and a variant threw `NullPointerException: Argument 1 cannot be null` right after `deliver()`. The original loop wasn't kept, so that link is inferred. Loops are safe once their state is local: 16 rounds in a `for` loop with a local trail behaved exactly like 16 written-out calls *(verified)*.

**A test can look as if the DPEV never fired.** Usually there's one `deliver()` too few: the DPEV is still queued. A static that `deliver()` reset can also cause it. Before deciding a listener doesn't run, take a snapshot after every call.

**Test data for an existing Account needs an address.** Without a billing address on both the Account and the MFS, the Account step doesn't match and creates a duplicate Account *(verified)*. Every later check that depends on the Account then fails for the wrong reason.

**Most branches leave nothing behind.** On the Account branch, the BPEV listener publishes the DPEV and stops, with no log and no field change. To prove a BPEV listener ran, use a branch that walks to the end: with every lookup filled in, it marks the MFS `Imported` and writes log rows.

---

## Seeing what ran

Assertion messages are the cheapest way to see the trail. `BPEV_DPEV_Delivery_TEST` builds a one-line snapshot after every call (log rows per `Flow_Name__c`, plus the MFS fields it cares about) and adds the trail to each assertion message. A failing test then explains itself in the output of `sf apex run test --result-format json`.

For the full detail, turn on a debug log for your user and read the log of the test run:

```bash
sf apex run test --tests BPEV_DPEV_Delivery_TEST.<method> --synchronous -o <alias>
sf apex list log -o <alias>
sf apex get log -i <log id> -d <dir> -o <alias>
grep -E 'FLOW_INTERVIEW_FINISHED|USER_DEBUG|EXCEPTION' <dir>/*.log
```

The `FLOW_INTERVIEW_FINISHED` lines show which flow ran after each `deliver()`. For the debug log, a trace flag on the running user with `ApexCode=DEBUG` and `Workflow=INFO` is enough. Delete the trace flag afterward.

---

## Reference: `BPEV_DPEV_Delivery_TEST`

| Test | What it shows |
|---|---|
| `controlA_dpevPublishedFromApex_isDeliveredOnFirstDeliver` | A DPEV published from Apex reaches its listener on the first call, so DPEV listener flows run under test at all. |
| `chainB_bpevToAccountDpev_deliveredOnSecondDeliver` | BPEV → `DPEV_Account__e`. The DPEV is not delivered on call #1, is delivered on #2, and #3 does nothing. |
| `chainC_bpevToMembershipFinderDpev_deliveredOnSecondDeliver` | Every lookup filled in. The BPEV listener's own log rows show it ran on #1, and the Finder listener runs on #2 (`Membership_Finder_Ran__c`). |
| `chainD_insertMfs_deliver_startTest_deliver` | The production entry point: insert the MFS, `deliver()`, `startTest()`, `deliver()`, assert. `stopTest()` delivers the next BPEV. |

Chains B and C, and control A, use the `Status__c = 'Imported'` isolation above. Chain D does not.

## Reference: scenario suite

| Test | Covers |
|---|---|
| `MembershipScenarios_TEST` | A baseline new purchase and the 12 use-case scenarios; results in [Current results](#current-results) |
| [`membership_smoke.robot`](../robot/Membership-Management/tests/membership_smoke.robot) | One new purchase through **real** asynchronous delivery: `cci task run robot --org dev -o suites robot/Membership-Management/tests/membership_smoke.robot`. Needs an org built by `dev_org` or `qa_org`, which run `setup_pricebook` (it uses sample product `STD`). It finished in about 16 seconds *(verified)*, and deletes what it created. |

Run the Apex suite with `cci task run run_tests --org dev`, or for the assertion trails, `sf apex run test --class-names MembershipScenarios_TEST --result-format json -o <alias>`.

---

## Open questions

- How many `deliver()` calls does each *branch* take? The full intake with every lookup blank is 15 rounds (see [Testing the whole cycle](#testing-the-whole-cycle)); a submission that arrives with some lookups filled takes fewer.
- Which DPEV listeners have tests? The scenario suite drives Account, Contact, Product, Campaign (skipped path), Price Book Entry, Opportunity, Gift Recipient, Membership Finder and Create Membership. Renewal has no listener ([DEP-06](Departures.md#dep-06--renewal-isnt-implemented)); Upgrade, Downgrade and the log listener aren't exercised yet.
