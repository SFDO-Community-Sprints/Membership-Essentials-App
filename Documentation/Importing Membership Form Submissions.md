# Importing Membership Form Submissions

Membership Form Submissions are the app's record of **membership history**. A membership record
extends in place — each renewal moves `End_Date__c` forward and can swap `Product__c` — so the
membership itself only ever shows the *current* term. The submission records are the only durable
record of the terms that came before.

That makes them the basis for term-over-term reporting, and it means institutions whose memberships
originate somewhere other than the app's own form — a ticketing system, a legacy database, a batch
import — need to write submission records themselves so their history is reportable.

This page explains how to do that safely.

---

## ⚠️ Read this before you insert anything

Inserting a submission **starts the intake pipeline**. The record-triggered flow
`Membership Form Submission - AFTER - MFS auditor` fires on **create and update** and publishes the
platform event that runs the whole chain:

> find or create Contact → find or create Account → find Campaign → find Product →
> find Price Book Entry → create Opportunity → create Membership

Its entry criteria are:

```
Status__c ≠ Failed   AND   Status__c ≠ Imported
```

**A backfill inserted with any other status — including blank — re-runs that pipeline on every row.**
On a historical import that means duplicate contacts, duplicate accounts, duplicate opportunities and
duplicate memberships, created at the full scale of the import.

Because the trigger also covers **updates**, a row that was imported safely can still set the
pipeline off later if an edit moves its status off `Imported`.

---

## The five rules

### 1. Stamp `Status__c = 'Imported'` in the insert itself

Not as a follow-up update. The trigger fires on the insert, so the status has to be correct at that
moment.

```apex
new Membership_Form_Submission__c(
    Status__c = 'Imported',   // <- must be set here, not later
    ...
);
```

### 2. Populate `Membership__c`

A backfilled term already knows which membership it belongs to. Setting the lookup keeps the record
out of the finder path and is what makes the row appear in reporting — the reporting report type
joins memberships to their submissions, so a row with a blank membership is invisible.

### 3. Set `Membership_Finder_Ran__c = true`

Belt and braces alongside rule 2. It marks the row as already resolved so nothing tries to match it
to a membership.

### 4. Carry an external id from the source system

Add a unique external id field and upsert against it. Backfills get re-run — after a mapping fix,
after a partial failure — and without an external id every re-run duplicates the history you are
trying to record.

### 5. Dry-run before the full load

Load a handful of rows into a sandbox, then confirm:

```sql
SELECT COUNT() FROM Membership__c WHERE CreatedDate = TODAY
SELECT COUNT() FROM Opportunity   WHERE CreatedDate = TODAY
SELECT COUNT() FROM Contact       WHERE CreatedDate = TODAY
```

All three should be **zero**. If any is not, stop — the pipeline ran, and a full load will multiply
whatever you just saw.

---

## What to put on each row

One submission per membership transaction — the original join and every renewal, upgrade and
downgrade after it.

| Field | Why it matters for history |
|---|---|
| `Membership__c` | Which membership this term belongs to. Required for reporting. |
| `Product__c` | The level held during this term. |
| `Term_Tier__c` | Formula — resolves the product's tier automatically. Nothing to populate. |
| `Duration__c` | Term length. |
| `SalePrice__c` | What was paid. Enables revenue expansion vs contraction analysis. |
| `Source_Code__c` | Acquisition channel. Enables leak-by-source analysis. |
| `Opportunity__c` | Link to the financial record, where one exists. |
| `Term_Start_Date__c` | **When the term began.** Reporting groups on this, not `CreatedDate`. |

### Dating historical terms

Set **`Term_Start_Date__c`** to the date the term actually began. Reporting deliberately groups on
this field rather than `CreatedDate`, which means:

- No org permission is required. Backdating `CreatedDate` needs *Set Audit Fields upon Record
  Creation* enabled and granted; this does not.
- Re-running an import does not shift your history.
- A term can be recorded before it starts.

Leave it blank and the term will not appear in any year grouping.

---

## Verifying the import

After loading, confirm history looks right for a known member:

```sql
SELECT Membership__r.Name, Term_Start_Date__c, Product__r.Name, Term_Tier__c, SalePrice__c, Source_Code__c
FROM   Membership_Form_Submission__c
WHERE  Membership__c = '<a membership id>'
ORDER BY Term_Start_Date__c
```

You should see one row per term, in order, with the product changing where the member upgraded or
downgraded.

---

## A worked example ships with the app

`datasets/default/` contains six households whose term histories cover the situations a
membership programme actually sees. Every submission row in it follows the rules above — the
mapping sets `Status__c` to `Imported` at insert, populates `Membership__c`, and sets
`Membership_Finder_Ran__c`.

| Household | What it shows |
|---|---|
| Alvarez | Upgraded twice and stayed — Family → Standard → Premier, $150 to $2,500 |
| Bennett | Flat renewer, four consecutive years at the same level |
| Chen | Downgraded twice, then lapsed — contraction as an early warning of churn |
| Diallo | Joined and never renewed — first-year churn |
| Eriksson | Joined this year, no history yet |
| Fitzgerald | Two terms, a year missing, then won back at a **better** level |

Load it into a scratch org and open **Membership Term History** to see the shape these produce.
The Fitzgerald group is the one to look at for a lapse-and-return, since the gap is visible as a
jump in term dates rather than anything the report has to be told about.

Note the dates are fixed rather than relative, so the "currently active" households will age out
over time and need refreshing like any static sample data.

## Related

- **Membership Tier and the upgrade/downgrade convention** — how levels compare, and why
  `Membership_Tier__c` is a number.
- Report type **Memberships with Membership Form Submissions** — the reporting surface these
  records feed.
