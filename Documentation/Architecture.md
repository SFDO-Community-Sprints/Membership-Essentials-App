# Architecture

The design rules for Membership Essentials: how a Membership Form Submission (MFS) is processed, which automation may do what, and how new work should be shaped. Written for contributors and for the agents they work through.

**This document describes the intended design, not the current code.** It was written from the maintainers' description of the design, not by reading the metadata. Where the code disagrees with it, the code is the thing to fix, unless a rule here has been formally revised. Known departures are tracked separately; see [Status](#status-and-open-items).

The rules are numbered so a review or a pull request can cite them ("violates A3").

---

## Overview

Processing is event-driven and organized around the MFS:

1. Creating or updating an MFS fires a **record-triggered flow**, which publishes a **business process event (BPEV)**.
2. The **BPEV listener** reads the MFS, works out the next incomplete step, and publishes exactly one **data process event (DPEV)** for it.
3. The **DPEV listener** performs one atomic data task, then updates the MFS to record the outcome.
4. That update re-fires the record-triggered flow, and the cycle repeats until the MFS reaches a terminal status.

```
MFS insert/update
   └─> record-triggered flow ──publishes──> BPEV
                                             └─> BPEV listener (reads MFS, decides)
                                                   └──publishes one──> DPEV
                                                                        └─> DPEV listener (one task)
                                                                              └─> updates MFS ──┐
   ┌────────────────────────────────────────────────────────────────────────────────────────────┘
   └─> (re-fires until Status__c is terminal)
```

The MFS is both the input and the **state of execution**. All progress is visible as field values on it.

---

## E. Event families

**E1. A BPEV is a business process event.** It means "a business process needs to be advanced for this MFS."

**E2. A DPEV is a data process event.** It means "some data needs to be created, updated or deleted."

**E3. Every BPEV and DPEV carries the triggering MFS Id in `Record_Id__c`.** No event exists without an MFS behind it. (Four existing events use a different field name; see [Accepted as-is](#accepted-as-is).)

**E4. A business process is defined by its steps, not its name.** A process gets its own BPEV (and its own BPEV listener) only if processing the inbound MFS is *materially different* from every existing process. Two processes that follow the same basic steps are the same process, even if the business calls them by different names. Anyone proposing a new BPEV must show how its processing differs, and a new name alone doesn't count.

## P. Publishing a BPEV

**P1. A BPEV is fired only by a change to an MFS.** No other object's records start a business process. If a change elsewhere (an Opportunity Line Item, a Membership) should advance processing, a DPEV updates the MFS, and the MFS change fires the BPEV.

**P2. By convention, the publisher is a record-triggered flow on `Membership_Form_Submission__c`.** Any other real-time automation on the MFS (Apex, a screen flow, and so on) is a deliberate exception. It must be explicitly decided and justified in the pull request.

**P3. Apex does not publish BPEVs.** This follows from P2 and F1.

**P4. A DPEV listener never publishes a BPEV.** A DPEV reports its outcome by updating the MFS (D3), and that update re-fires the BPEV through the record-triggered flow. Publishing a BPEV directly bypasses the recursion that keeps processing state on the MFS.

## B. BPEV listener contract

**B1. A BPEV listener decides; it does not write.** It may query the MFS and related records to determine the state of execution. It performs no DML, with the one exception in B4.

**B2. It publishes exactly one DPEV per execution:** the one for the first step that isn't complete yet. The listener owns the step order.

**B3. It checks the overall status first.** If `Status__c` holds a terminal value (see S1), it does nothing.

**B4. The success-status exception.** When the listener reaches the end of the process and nothing further is required, it sets `Status__c = Imported` itself. The BPEV listener is the one place that knows execution is complete, so this write belongs there. It is the **only** DML a BPEV listener may perform.

**B5. The B4 update must have a fault path.** If setting `Imported` fails, the fault path:
1. publishes the log DPEV, recording that all steps completed and the final status update failed (this doesn't touch the MFS, so it survives whatever blocked the update), then
2. sets `Status__c = Import Incomplete`.

If step 2 also fails, the log entry stands and the MFS needs human attention.

**B6. Logging goes through the log DPEV.** A BPEV listener never inserts `Membership_Essentials_Event_Log__c` directly; it publishes `DPEV_Create_Membership_Essentials_Log__e` (see L1).

**B7. BPEV listeners are flows.** Orchestration is the part people most need to read, so it stays in Flow Builder.

**B8. A failed publish is logged and nothing more.** Each DPEV publish in a BPEV listener has a fault path that logs the failure (L2). The fault path makes no change to the MFS (B1).

## D. DPEV listener contract

**D1. One atomic task.** A DPEV listener is a small, discrete automation that accomplishes one task, written so any business process that needs that task can reuse it.

**D2. It finds its MFS through `Record_Id__c`** (E3).

**D3. Every DPEV advances the MFS or stops it.** On completion, the listener sets the MFS field that marks its step complete, so the next BPEV pass moves on. On error, it logs the failure (through the log DPEV) and sets `Status__c = Failed`. **A DPEV listener that does neither causes an infinite loop or a stall.** This is the rule that keeps the recursion safe.

If the MFS update that records the outcome fails, the fault path logs the failure (through the log DPEV) and tries a second update that sets `Status__c = Failed`. If the second update also fails, the log entry stands and the MFS needs human attention.

**D4. Step completion is read from field values on the MFS.** It's usually a lookup being populated (the Account step is complete when `Account__c` is set) and sometimes a checkbox. Whichever field a DPEV sets on success is the field the BPEV listener checks to skip past that step.

**D5. One listener per DPEV.** A second listener is allowed only for a side process that meets all three conditions:
- it performs no DML on the MFS,
- its success or failure doesn't need to be tracked separately, and
- the primary listener's outcome doesn't depend on it.

The primary listener remains the only one that advances or fails the MFS.

**D6. DPEV listeners are flows by default.** An Apex listener is allowed when the task can only be accomplished in Apex (F2). It follows D1–D5 exactly like a Flow listener and is tagged as migration debt (T1).

## R. Recursion and exit conditions

**R1. The recursion is intentional.** Progress happens because a DPEV updates the MFS, which re-fires the record-triggered flow and the BPEV. It is the mechanism, not a side effect to remove.

**R2. There are exactly two exit conditions:**
1. **Done.** The BPEV listener reaches the end and the MFS requires no further processing (`Imported`, or `Import Incomplete` under B5).
2. **Failed.** A failure has stopped processing, and it can't continue without human intervention (`Failed`).

**R3. Every other condition must move processing forward.** Any outcome that is neither an exit nor a hard failure must leave the MFS in a state where the next pass makes progress.

## S. MFS overall status

**S1. `Status__c` on the MFS records how a run ended.**

| Value | Meaning | Set by |
| --- | --- | --- |
| *(blank)* | Not finished. Eligible for processing. | Initial state; a person clearing the status |
| `Imported` | Every step completed. | The BPEV listener (B4) |
| `Import Incomplete` | Every step completed, but the final status update failed. | The fault path on the B4 update (B5) |
| `Failed` | A step failed, and processing can't continue without human intervention. | The DPEV that failed (D3) |

**S2. All three non-blank values are terminal.** Nothing processes an MFS in a terminal status.

**S3. Retry means clearing the status.** A person fixes the cause and clears `Status__c`. The resulting update re-triggers execution, and the BPEV listener resumes from the first incomplete step.

## M. Membership lifecycle

**M1. Matching.** An existing membership matches the MFS when it has the same **membership type** (Individual / Household / Corporate).

**M2. Tier direction.** `Membership_Tier__c` 1 is the top tier. A *lower* number is a *higher* tier.

**M3. The path is decided by comparing the MFS product's tier with the matching membership's tier:**

| Comparison | Path | What the package does | How the step completes |
| --- | --- | --- | --- |
| No matching membership | **Create** | Creates a membership (ordinary DPEV) | The DPEV sets the Membership lookup on the MFS |
| Same tier | **Renewal** | Extends the existing membership's end date by the purchased product's term | The DPEV sets the renewal flag on the MFS (M4) |
| Higher tier (lower number) | **Upgrade** | Changes the existing membership's product to the purchased product and sets its end date to today plus that product's term (`DPEV_Membership_Upgrade__e`) | The DPEV sets the product-change flag on the MFS (M4) |
| Lower tier (higher number) | **Downgrade** | Same as Upgrade, through `DPEV_Membership_Downgrade__e` | The DPEV sets the product-change flag on the MFS (M4) |

**M4. Renewal and product changes are tracked by flags in addition to the Membership lookup.** The lookup is already set before these steps (it's how the match was found), so it can't mark them as done. The renewal listener sets `Membership_Renewed__c` on the MFS after extending the end date. The upgrade and downgrade listeners set `Membership_Product_Changed__c` after changing the product. On the next pass, the BPEV listener sees the lookup **and** either flag and sets `Imported`. Without the flags, every re-fire would renew or change the product again.

**M5. Upgrade and downgrade are package steps.** The package changes the membership's product (M3) and tracks the outcome on the MFS (M4), under the same contract as any other DPEV (D1–D4). An adopting organization that wants further actions on an upgrade or downgrade attaches its own listener as a side process (D5).

## F. Flow and Apex

**F1. Flow is the default.** All new automation is built in Flow, in Flow Builder; hand-written Flow XML is rarely worth keeping.

**F2. Apex is used only when Flow can't support the requirement.** A pull request that adds Apex states which Flow capability is missing.

**F3. Existing Apex is migration debt.** Each class is tagged for migration (T1) with the reason it's Apex today. The exception is F5.

**F5. Duplicate matching is a justified use of Apex.** Flow has no native action for running duplicate rules, so `Duplicate`, `FindDuplicates`, `FindDuplicatesFactory`, `DuplicateRecordCheck_Util` and `DuplicateRecordCheck_Invocable` stay in Apex and aren't tagged for migration. Flows reach them through the `DuplicateRecordCheck_Invocable` action.

**F4. Apex joins the event architecture only as a DPEV listener** (D6). Flows otherwise reach Apex through invocable actions.

## C. Configuration

**C1. Strings that drive package behavior and that an adopter could reasonably change belong in `Membership_Essentials_Setting__mdt`.** Examples include picklist values, membership types, statuses, role names, product families and price book names. This applies to Flow as well as Apex.

**C2. Until such a string is migrated, it's tagged** for settings migration (T1).

## L. Logging

**L1. All logging goes through `DPEV_Create_Membership_Essentials_Log__e`.** No automation inserts `Membership_Essentials_Event_Log__c` directly. Routing everything through the event means the logging switch in `Membership_Essentials_Setting__mdt` governs every log entry.

**L2. Every platform event publish has a fault path that logs the failure** through the log DPEV. This applies to every automation that publishes, including the record-triggered flow, BPEV listeners and DPEV listeners. The only exception is the publish of the log DPEV itself, which has no fault path: a failed log has nowhere to be logged.

## N. Naming

**N1. Events** are prefixed with their family: `BPEV_<Subject>__e` and `DPEV_<Subject>__e`.

**N2. A listener's name matches its event:** `<FAMILY>_Listener_<Subject>`, where `<Subject>` is the event's API name with the family prefix and `__e` removed. For example, `DPEV_Contact_Finder__e` → `DPEV_Listener_Contact_Finder`.

**N3. A record-triggered flow's name indicates that it's record-triggered and names its triggering object:** `RTF_<Object>_<Before|After>_<Purpose>`, for example `RTF_Membership_Form_Submission_After_Dispatch`.

**N4. Apex test classes use the `_TEST` suffix.** Existing `_Test` classes are tagged for rename (see [Backlog](#backlog)).

## T. Tagging debt

**T1. Debt is tagged in the source with a fixed prefix**, so a single grep finds all of it:

| Debt | Apex | Flow |
| --- | --- | --- |
| Should move from Apex to Flow | `// TODO(flow-migration): <why this is Apex today>` | n/a |
| Hard-coded string should move to settings | `// TODO(settings-mdt): <string> — <what it controls>` | The same text in the affected element's **Description** |

```bash
grep -rn "TODO(flow-migration)\|TODO(settings-mdt)" force-app/
```

---

## Checklist for a change

Before opening a pull request that touches processing:

- [ ] New BPEV? It's justified by materially different processing (E4) and published from a record-triggered flow on the MFS (P1, P2).
- [ ] No DPEV listener publishes a BPEV (P4).
- [ ] BPEV listener: no DML other than the B4 success status, which has its B5 fault path; publishes one DPEV per pass (B2); checks for a terminal status first (B3).
- [ ] DPEV listener: one task (D1); on success, sets a field the BPEV listener checks; on failure, logs and sets `Failed`, retrying with a second update if the first one fails (D3); it's the only listener on its event, or it's a D5 side process.
- [ ] Every event carries `Record_Id__c` (E3).
- [ ] Logging goes through the log DPEV (L1), and every publish except the log DPEV's own has a fault path that logs the failure (L2, B8).
- [ ] No new Apex without stating the Flow gap (F2); new hard-coded behavior strings are tagged (C2).
- [ ] Names follow N1–N4.
- [ ] The PR says what was verified in an org and what was only read from metadata.

---

## Status and open items

### Accepted as-is

These knowingly depart from the rules above. Leave them alone unless a task targets them.

- **Event Id fields that aren't `Record_Id__c`** (E3): `BPEV_Membership_Form_Submission__e` and `DPEV_Contact_Finder__e` use `Membership_Form_Submission_Id__c`; `DPEV_Create_Membership_Essentials_Log__e` uses `MFS_RecordId__c`; `BPEV_Membership_Altering__e` carries both `Record_Id__c` and `mfs_Record_Id__c`.
- **`BPEV_Membership_Altering__e`** is expected to be deprecated. Don't build on it.
- **`DPEV_Extend_Membership__e`** has no documented intent. Don't build on it until its purpose is decided.

### Backlog

Changes the design requires that aren't in the package yet:

- Add `Import Incomplete` to the `Status__c` picklist on `Membership_Form_Submission__c` (S1, B5).
- Add the checkbox `Membership_Renewed__c` to `Membership_Form_Submission__c` (M4).
- Rename the `_Test` classes to `_TEST`: `DuplicateRecordCheck_Test`, `TriggerHandler_Test` (N4).
- Tag existing Apex other than duplicate matching (F3, F5) and hard-coded behavior strings (C2) per T1.
- **TODO (P4):** `DPEV_Listener_Membership_Finder` publishes `BPEV_Membership_Transaction__e` (`Fire_Membership_Transaction_For_Create`). Replace this with an update to the MFS, so the transaction step is reached through the BPEV listener's re-entry.
- **TODO (P1):** `Opportunity_Line_Item_After_Membership` is record-triggered on `OpportunityLineItem` and publishes `BPEV_Membership_Transaction__e` (`Fire_BPEV_Membership_Transaction`). Remove this entry point. The membership step runs inside the MFS process (see the E4 TODO below); if the line item's state matters, a DPEV records it on the MFS.
- **TODO (E4, B2):** Fold the membership transaction into the MFS process. `BPEV_Listener_Membership_Form_Business_Process` takes over the membership step as its last step before `Imported`: the finder, then create, renew, upgrade or downgrade (M3). Then retire `BPEV_Membership_Transaction__e` and `BPEV_Listener_Membership_Transaction`. Once P1 holds, the transaction can only start from an MFS change, the same trigger as the MFS process, so it isn't a materially different process.

### Departures from the design

Not yet assessed. The next step is a pass comparing the flows, events and Apex against these rules, with each finding labelled "read from metadata" or "reproduced in an org."
