# Departures from the design

The places where the code disagrees with [Architecture.md](Architecture.md), each with the rule it breaks, where it lives, and the work that resolves it. Where the two disagree, the code is what's wrong. If a departure turns out to be right, revise the rule in Architecture.md instead of leaving it here.

**How to use this list**
- Each entry links to its GitHub issue. Cite the ID and close the issue from the pull request ("fixes DEP-02, closes #272"), and delete the entry in the same PR.
- Flow fixes are made in Flow Builder. Element API names are given so the change is easy to find.
- Items already tracked in Architecture.md ([Accepted as-is](Architecture.md#accepted-as-is) and [Backlog](Architecture.md#backlog), including the P1, P4 and E4 TODOs) aren't repeated here, but entries refer to them where they interact.

**Evidence.** Snapshot of 2026-11-07, taken by parsing `force-app/main/default/flows/*.flow-meta.xml`, the platform event definitions and the Apex. Every entry is **read from metadata; none has been reproduced in an org.** Entries marked *(needs org)* depend on runtime behavior that reading the metadata can't settle. Reproduce those before building a fix on them.

---

## Order of work

Several entries share a fix or depend on each other:

1. **Independent and small, can start now:** DEP-02, the [bugs outside the rules](#bugs-outside-the-rules), and the [cleanup](#cleanup) deletions (DEP-15, -16).
2. **The log listener before the logging migration.** Fix the listener first (DEP-13, first item), then move the flows to the log DPEV (DEP-13, DEP-20) one flow per PR.
3. **The fold** ([#278](https://github.com/SFDO-Community-Sprints/Membership-Essentials-App/issues/278)). The E4 backlog TODO moves the membership step into the MFS BPEV listener. It resolves or reshapes DEP-01, -03, -04, -05, -07 and -09, together with the P1 ([#230](https://github.com/SFDO-Community-Sprints/Membership-Essentials-App/issues/230)) and P4 ([#279](https://github.com/SFDO-Community-Sprints/Membership-Essentials-App/issues/279)) TODOs. Plan it as one piece of work.
4. **After the backlog picklist value `Import Incomplete` ([#280](https://github.com/SFDO-Community-Sprints/Membership-Essentials-App/issues/280)) and the field `Membership_Renewed__c` ([#281](https://github.com/SFDO-Community-Sprints/Membership-Essentials-App/issues/281)) exist:** DEP-06, DEP-11 (second item) and DEP-12.
5. **Renames last** (DEP-17, DEP-18). Each rename creates a new flow, so do it in the same PR as that flow's other fixes.

---

## Processing breaks

### DEP-01 — `Imported` is set before the recipient and membership steps run
**Issue:** [#284](https://github.com/SFDO-Community-Sprints/Membership-Essentials-App/issues/284) · **Breaks:** B4, B2, S2 · **Flow:** `BPEV_Listener_Membership_Form_Business_Process`

`Is_The_Opportunity_Lookup_Set` → `Update_MFS_status_Imported` → `Are_Recipient_fields_populated` → `Call_the_Recipient_Platform_Event` → `Get_Membership` → `Membership_Exists` → finder or create DPEV.

In a single pass the listener sets `Imported`, then publishes the recipient DPEV **and** a membership DPEV. Everything after that runs against an MFS that is already terminal. The record-triggered flow never re-fires, so the membership chain only advances through the P1 and P4 side doors.

- [ ] Reorder the steps: Account → Contact → Product → Campaign → Price Book Entry → Opportunity → Recipient → Membership, with `Imported` last.
- [ ] End the flow after each DPEV publish (one per pass).
- [ ] Give the recipient step a skip check (D4): `Recipient__c` populated, or no recipient on the MFS.

### DEP-02 — Contact creation failure loops forever
**Issue:** [#272](https://github.com/SFDO-Community-Sprints/Membership-Essentials-App/issues/272) · **Breaks:** D3 · **Flow:** `DPEV_Listener_Find_Create_Contact`

The `Create_Contact` fault goes to `set_MFS_Failure_Message` → `Update_Membership_Form_Submission`. That path sets `Failure_Information__c` but not `Status__c = Failed`, and `Contact__c` stays blank. The update re-fires the record-triggered flow, and the BPEV listener publishes the contact DPEV again. The Account listener sends the same fault through `set_Error_Log_Values` → `set_MFS_Error_Values`, which sets `Failed`.

- [ ] Route `set_MFS_Failure_Message` to `set_Error_Log_Values`, as the Account listener does.
- [ ] Add a fault connector to `Check_for_Contact_Matches`. The Account listener's duplicate check has one.

### DEP-03 — `Record_Id__c` carries an Opportunity Line Item Id on the membership events
**Issue:** [#285](https://github.com/SFDO-Community-Sprints/Membership-Essentials-App/issues/285) · **Breaks:** E3, D2 · **Flows:** `Opportunity_Line_Item_After_Membership`, `DPEV_Listener_Membership_Finder`, `BPEV_Listener_Membership_Transaction`, `DPEV_Listener_Membership_Create_Flow`, `DPEV_Listener_Membership_Upgrade`, `DPEV_Listener_Membership_Downgrade`

- `BPEV_Membership_Transaction__e` receives an Opportunity Line Item Id from two publishers and an MFS Id from a third (DEP-04).
- The Transaction listener forwards `$Record.Record_Id__c`, the line item Id, into the Create Membership, Renewal, Upgrade and Downgrade DPEVs.
- `DPEV_Listener_Membership_Create_Flow` looks up a line item by `Record_Id__c`. The MFS listener publishes the same event with an **MFS** Id (`Create_Membership_Creation_Platform_Event`). That path resolves nothing, takes the `Should_Create_Membership` default, and stalls.
- The Upgrade listener reads `Record_Id__c` as an MFS Id. The Downgrade listener filters line items on `Product2Id = Record_Id__c`. Neither matches what is sent, so both are probably no-ops *(needs org)*.

- [ ] As part of the fold, put the MFS Id in `Record_Id__c` on every membership DPEV. Listeners query the MFS first and reach the line item through `Opportunity__c`. If a line item Id needs to travel separately, `DPEV_Membership_Renewal__e` already has an `Opportunity_Line_Item_Id__c` field.

### DEP-04 — "Do not create Opportunity": a BPEV publishes a BPEV, or the MFS stalls
**Issue:** [#265](https://github.com/SFDO-Community-Sprints/Membership-Essentials-App/issues/265) · **Breaks:** P2, B2, R3 · **Flow:** `BPEV_Listener_Membership_Form_Business_Process`

When `Do_not_create_Opportunity__c` is true, the flow goes `Ignore_Opportunity` → `Is_this_for_a_new_membership`:
- **Membership-family product:** `Create_Membership_Transaction_Event` publishes `BPEV_Membership_Transaction__e` from a BPEV listener. It sends an MFS Id where the Transaction listener expects a line item Id.
  - The listener's `Get_Opportunity_Line_Item` finds nothing.
  - `Query_for_Membership_Form_Submission` then filters on `Opportunity__c = <null>`, which may match an **unrelated** MFS that has no Opportunity *(needs org)*.
- **Any other product:** the default outcome ends the flow. No DPEV is published and `Imported` is never set, so the MFS sits with a blank status indefinitely.
- On both branches the recipient step is skipped.

- [ ] The fold removes `Create_Membership_Transaction_Event`; this branch runs the ordinary membership step inside the listener.
- [ ] Make the non-membership branch continue to Recipient, then `Imported`.

### DEP-05 — Upgrade and downgrade are probably unreachable
**Issue:** [#286](https://github.com/SFDO-Community-Sprints/Membership-Essentials-App/issues/286) · **Breaks:** M3 · **Flow:** `BPEV_Listener_Membership_Transaction`

`Get_Old_Product_ID` queries **`Product2History`** by `Id = Get_Membership_Record.Product__r.Id`, which is a Product2 Id, so it most likely returns no row. Both tier comparisons in `Determine_if_Membership_Renewal_is_an_Upgrade_or_a_Downgrade` then fail, and every product change falls through to `Check_Level_and_Type` *(needs org)*. The comparison direction itself (new < old → upgrade) agrees with M2.

- [ ] When the tier decision moves into the MFS listener (the fold), compare the MFS product's `Membership_Tier__c` with the matched membership's `Product__r.Membership_Tier__c` directly. Drop the history lookup.
- [ ] Compare tiers, not product Ids (today's `Compare_Opportunity_and_Membership_Products`): two different products on the same tier are a renewal (M3).

### DEP-06 — Renewal isn't implemented
**Issue:** [#287](https://github.com/SFDO-Community-Sprints/Membership-Essentials-App/issues/287) · **Breaks:** M3, M4, D5 · **Event:** `DPEV_Membership_Renewal__e`, published by `BPEV_Listener_Membership_Transaction`

Nothing subscribes to `DPEV_Membership_Renewal__e`. No flow extends the end date or marks the renewal on the MFS.

- [ ] Build `DPEV_Listener_Membership_Renewal`. It extends the matched membership's end date by the product's term and sets `Membership_Renewed__c` (once that backlog field exists). On error it logs and sets `Failed` (D3).
- [ ] Have the BPEV listener treat Membership lookup + `Membership_Renewed__c` as complete (M4).

### DEP-07 — Matching ignores membership type
**Issue:** [#288](https://github.com/SFDO-Community-Sprints/Membership-Essentials-App/issues/288) · **Breaks:** M1, R3 · **Flows:** `DPEV_Listener_Membership_Finder`, `BPEV_Listener_Membership_Transaction`

`GetMembership` matches on Account, `End_Date__c > today`, and a product in the renewable `Membership` family. It never compares `Type__c` with the MFS's `MembershipType__c`, so a Household submission can match a Corporate membership. Type is compared only later, in `Check_Level_and_Type`. A mismatch there takes the default outcome: no event and no status change, so the MFS stalls.

- [ ] Add `Type__c = MembershipType__c` to `GetMembership`. A different-type membership is then no match, and the Create path follows (M3).
- [ ] Remove `Check_Level_and_Type` in the fold; the finder's type filter replaces it.

### DEP-08 — Upgrade and downgrade listeners don't mark the step complete
**Issue:** [#289](https://github.com/SFDO-Community-Sprints/Membership-Essentials-App/issues/289) · **Breaks:** M4, M5, D3 · **Flows:** `DPEV_Listener_Membership_Upgrade`, `DPEV_Listener_Membership_Downgrade`

Both change the Membership's `Product__c` and `End_Date__c` (`Assign_new_Membership_product` → `Update_Membership_with_new_product`), as M5 intends. But:
- neither sets `Membership_Product_Changed__c`;
- neither updates the MFS at all, so no path sets `Failed`;
- both read the wrong input (DEP-03);
- Downgrade starts the new end date from the Opportunity's `CloseDate`. M3 says today plus the product's term, which is what Upgrade already does.

- [ ] After the product update succeeds, set `Membership_Product_Changed__c = true` on the MFS.
- [ ] On error, log and set `Failed`, with the D3 second update.
- [ ] Change Downgrade's `CalculateNewEndDate` to start from `TODAY()`.

### DEP-09 — The BPEV listener doesn't skip a completed product change
**Issue:** [#290](https://github.com/SFDO-Community-Sprints/Membership-Essentials-App/issues/290) · **Breaks:** M3, M4 · **Flows:** `BPEV_Listener_Membership_Transaction` today; `BPEV_Listener_Membership_Form_Business_Process` after the fold

No BPEV listener checks `Membership_Product_Changed__c` and then sets `Imported`. DEP-01 hides this today, because `Imported` was already set earlier in the pass.

- [ ] In the folded membership step, Membership lookup set **and** (`Membership_Renewed__c` or `Membership_Product_Changed__c`) → `Imported`, with the B5 fault path.

---

## Contract gaps

### DEP-10 — Fault paths that log but don't set `Failed`
**Issue:** [#291](https://github.com/SFDO-Community-Sprints/Membership-Essentials-App/issues/291) · **Breaks:** D3

| Listener | Faults that only log |
| --- | --- |
| `DPEV_Listener_Find_Create_Recipient` | `Get_MFS_Recipient` |
| `DPEV_Listener_Find_Price_Book_Entry` | `Get_The_Standard_Pricebook`, `Get_pricebook_entry` |
| `DPEV_Listener_Find_Product` | `Get_Products` |
| `DPEV_Listener_Campaign_Finder` | `Find_Existing_Campaign` |
| `DPEV_Listener_Create_Opportunity` | `Membership_Form_Submission_Record` has no fault connector |
| `DPEV_Listener_Membership_Create_Flow` | every fault; no path sets `Failed` |
| `DPEV_Listener_Membership_Finder` | `Get_Matching_Products`, `GetMembership` |

- [ ] Route each listed fault to an assignment that sets `Status__c = Failed` and `Failure_Information__c`, then to the MFS update.

In every DPEV listener, a fault on the update that records the outcome only logs; none tries the second update that D3 requires.

- [ ] Make that fault path log through the log DPEV and then try a second update setting `Failed`.
- [ ] Give the second update its own fault path that ends the flow. If it faulted unhandled, the interview would roll back and discard the log event.

### DEP-11 — Neither BPEV listener checks for a terminal status
**Issue:** [#262](https://github.com/SFDO-Community-Sprints/Membership-Essentials-App/issues/262) · **Breaks:** B3, S2 · **Flows:** both BPEV listeners; `Membership_Form_Submission_AFTER_MFS_auditor`

The MFS listener relies on the record-triggered flow's entry filter (`Status__c` ≠ `Failed` and ≠ `Imported`), so B3 is met only upstream. The Transaction listener has no gate at all: it runs from the line item trigger and from the finder, whatever the MFS status.

- [ ] Make a decision on `Status__c` the first element of both listeners.
- [ ] Add `Import Incomplete` to the record-triggered flow's entry filter once the backlog picklist value exists.

### DEP-12 — The B4 fault path doesn't set `Import Incomplete`
**Issue:** [#292](https://github.com/SFDO-Community-Sprints/Membership-Essentials-App/issues/292) · **Breaks:** B5 · **Flow:** `BPEV_Listener_Membership_Form_Business_Process`

`Update_MFS_status_Imported` has a fault path, but it only inserts a log record directly, then stops.

- [ ] Once the backlog picklist value exists, change the fault path to publish the log DPEV, then set `Import Incomplete`.

### DEP-13 — Nothing publishes the log DPEV
**Issue:** [#293](https://github.com/SFDO-Community-Sprints/Membership-Essentials-App/issues/293) · **Breaks:** L1, B6 · **Flows:** the 15 active flows other than the log listener

No flow publishes `DPEV_Create_Membership_Essentials_Log__e`. Every log entry is a direct insert of `Membership_Essentials_Event_Log__c`, so the logging switch in `Membership_Essentials_Setting__mdt` controls nothing. The log listener, `DPEV_Listener_Create_Membership_Essentials_Log`, isn't ready for the traffic either:
- it doesn't map `MFS_RecordId__c` to `Membership_Form_Submission__c`, so log entries would lose their MFS link;
- the event has no error-text field, and the listener fills `Error_Text__c` from its own `$Flow.FaultMessage`, which is always blank;
- its settings lookup doesn't name a record.

Separately, the log entries written by the Create Membership, Upgrade, Downgrade and Transaction flows never set the MFS reference.

- [ ] Fix the listener first:
  - map `MFS_RecordId__c` to `Membership_Form_Submission__c`;
  - add `Error_Text__c` to the event and map it;
  - look up the settings record by `DeveloperName`.
- [ ] Then move each flow to publish the event, one flow per PR, always filling the MFS Id.

### DEP-20 — Publishes without a logging fault path
**Issue:** [#294](https://github.com/SFDO-Community-Sprints/Membership-Essentials-App/issues/294) · **Breaks:** L2, B8

Of the 17 platform event publishes, 3 have a fault path, and all 3 insert the log record directly (L1).

| Flow | Publish | Today | Resolution |
| --- | --- | --- | --- |
| `BPEV_Listener_Membership_Form_Business_Process` | `Call_Account_Platform_Event`, `Call_Contact_Platform_Event`, `Call_Product_Platform_Event`, `Call_Find_Campaign_Platform_Event`, `Call_the_Pricebook_Entry_Finder`, `Call_The_Opportunity_Platform_Event`, `Create_Membership_Platform_Event_Message`, `Create_Membership_Creation_Platform_Event` | no fault path | Add a fault path that publishes the log DPEV |
| `BPEV_Listener_Membership_Form_Business_Process` | `Call_the_Recipient_Platform_Event` | direct log insert | Switch to the log DPEV |
| `Membership_Form_Submission_AFTER_MFS_auditor` | `Send_New_Updated_Membership_Platform_Event` | direct log insert (`ME_Fail_Log`) | Switch to the log DPEV |
| `BPEV_Listener_Membership_Form_Business_Process` | `Create_Membership_Transaction_Event` | direct log insert | Removed by the fold |
| `BPEV_Listener_Membership_Transaction` | the four lifecycle publishes | no fault path | Removed by the fold |
| `DPEV_Listener_Membership_Finder` | `Fire_Membership_Transaction_For_Create` | no fault path | Removed by the P4 TODO |
| `Opportunity_Line_Item_After_Membership` | `Fire_BPEV_Membership_Transaction` | no fault path | Removed by the P1 TODO |

- [ ] Add the logging fault paths, and switch the two direct inserts to the log DPEV, as listed above.
- [ ] Build the renewal, upgrade and downgrade publishes that the fold adds to the MFS listener with logging fault paths from the start.

When a BPEV listener's publish fails, the MFS keeps a blank status and nothing re-fires it. The log entry is the only sign; re-saving the MFS retries it.

---

## Cleanup

### DEP-15 — `Create_Membership_DPEV__e` is unused
**Issue:** [#296](https://github.com/SFDO-Community-Sprints/Membership-Essentials-App/issues/296) · **Breaks:** N1. The event has no publisher and no subscriber; `DPEV_Create_Membership__e` is the live one.
- [ ] Delete the event, and update the paragraph about it in `AGENTS.md`.

### DEP-16 — Leftover flows
**Issue:** [#297](https://github.com/SFDO-Community-Sprints/Membership-Essentials-App/issues/297)
- [ ] Delete `Member_test_autolaunched` (Obsolete) and `MFS_Force_PE_Testing` (Draft screen flow).

### DEP-17 — Listener names don't match their events
**Issue:** [#298](https://github.com/SFDO-Community-Sprints/Membership-Essentials-App/issues/298) · **Breaks:** N2

A flow's API name can't be changed in place. Each rename means building the flow under the new name, then deactivating and deleting the old one.

| Event | Current listener | Name per N2 |
| --- | --- | --- |
| `BPEV_Membership_Form_Submission__e` | `BPEV_Listener_Membership_Form_Business_Process` | `BPEV_Listener_Membership_Form_Submission` |
| `DPEV_Account__e` | `DPEV_Listener_Create_or_Find_Account` | `DPEV_Listener_Account` |
| `DPEV_Contact_Finder__e` | `DPEV_Listener_Find_Create_Contact` | `DPEV_Listener_Contact_Finder` |
| `DPEV_Gift_Recipient_Finder__e` | `DPEV_Listener_Find_Create_Recipient` | `DPEV_Listener_Gift_Recipient_Finder` |
| `DPEV_Product_Finder__e` | `DPEV_Listener_Find_Product` | `DPEV_Listener_Product_Finder` |
| `DPEV_Find_Campaign__e` | `DPEV_Listener_Campaign_Finder` | `DPEV_Listener_Find_Campaign` |
| `DPEV_Pricebook_Finder__e` | `DPEV_Listener_Find_Price_Book_Entry` | `DPEV_Listener_Pricebook_Finder` |
| `DPEV_Create_Membership__e` | `DPEV_Listener_Membership_Create_Flow` | `DPEV_Listener_Create_Membership` |

- [ ] Rename each listener, in the same PR as its other fixes.

### DEP-18 — Record-triggered flow name
**Issue:** [#299](https://github.com/SFDO-Community-Sprints/Membership-Essentials-App/issues/299) · **Breaks:** N3
- [ ] Rename `Membership_Form_Submission_AFTER_MFS_auditor` to `RTF_Membership_Form_Submission_After_Dispatch`. (`Opportunity_Line_Item_After_Membership` goes away under the P1 TODO.)

### DEP-19 — Hard-coded behavior strings in flows
**Issue:** [#300](https://github.com/SFDO-Community-Sprints/Membership-Essentials-App/issues/300) · **Breaks:** C1, C2. This is the flow half of the backlog tagging item.
- [ ] Tag each in its element's Description (T1):
  - product family `Membership`: `Is_this_for_a_new_membership` (MFS listener), `Is_this_for_a_new_Membership` (`Opportunity_Line_Item_After_Membership`), `Get_Matching_Products` (finder)
  - renewal option `Renewable`: `Get_Matching_Products` (finder)
  - price book `Standard Price Book`: `Get_The_Standard_Pricebook`
  - Opportunity stage `Closed Won`: `Create_Opportunity_Record`
  - Membership status `Current`: `Create_Membership`

The Apex half, in `ConfigurationService`, is the membership types, active statuses and role names.

The MFS's own state values (`Imported`, `Failed`, `Skipped`, `Matched`) are deliberately not listed. They are the design's state vocabulary (S1), not adopter configuration.

---

## Bugs outside the rules

These don't break a numbered rule, but they turned up during the same review.

- [ ] In `Are_Recipient_fields_populated`, rule `Recipient_Contact_Info` condition 2 checks `LastName__c` (the purchaser's) instead of `RecipientLastName__c`. [#301](https://github.com/SFDO-Community-Sprints/Membership-Essentials-App/issues/301)
- [ ] `DPEV_Listener_Campaign_Finder` searches when **either** the campaign name or the source code is given, but `Find_Existing_Campaign` requires **both** to match. A submission with only one of them fails with "campaign specified but not found" *(needs org)*. [#302](https://github.com/SFDO-Community-Sprints/Membership-Essentials-App/issues/302)
- [ ] If the line item insert fails in `DPEV_Listener_Create_Opportunity`, the Opportunity remains but isn't recorded on the MFS, so a retry creates a second one. [#303](https://github.com/SFDO-Community-Sprints/Membership-Essentials-App/issues/303)
- [ ] Some pass logs are written before the check they report ("Pricebook Entry Found", "Product Found"). The finder logs "can't proceed" as an error and then proceeds. [#261](https://github.com/SFDO-Community-Sprints/Membership-Essentials-App/issues/261)
- [ ] `MembershipService.rollupPrimaryMembershipContact` has an empty body. The account rollup runs on insert only, not on update. [#39](https://github.com/SFDO-Community-Sprints/Membership-Essentials-App/issues/39)
- [ ] `AGENTS.md` says "18 Flows" under Architecture and "19 flows" under Working rules; there are 19. [#304](https://github.com/SFDO-Community-Sprints/Membership-Essentials-App/issues/304)

Context, not a departure: flow API versions range from 49.0 to 67.0, and the project is on 59.0.
