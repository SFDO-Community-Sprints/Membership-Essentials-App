# Membership Tier and level changes

`Membership_Tier__c` on the Product is how the app decides whether a membership change is an
**upgrade** or a **downgrade**. This page documents the convention, because getting its direction
backwards silently inverts every upgrade and downgrade the app records.

---

## The convention: lower number = higher tier

**`0` is the highest tier.** A member moving from tier 3 to tier 1 has *upgraded*.

This is stated in the field's own help text — *"Helps the package understand if a membership change
is an upgrade or downgrade, with 0 being the highest tier"* — and it is encoded in the transaction
router's decision:

```
Upgrade    ⇢  new Membership_Tier__c  LESS THAN     old Membership_Tier__c
Downgrade  ⇢  new Membership_Tier__c  GREATER THAN  old Membership_Tier__c
```

It reads backwards to most people, who expect a bigger number to mean a better membership. Assume
the opposite of the convention anywhere — in a report, in an integration, in a new field — and
upgrades and downgrades swap places without any error being raised.

---

## Configuring it

Tiers are **data, not code**. Nothing needs to be deployed to define or change them.

| | |
|---|---|
| **Where** | `Membership Tier` on the Product record |
| **Visible on** | *Product Layout for Memberships* |
| **Who can edit** | Anyone with the **Membership - Manage** permission set |
| **Who can read** | **Membership - View** grants read-only |
| **Type** | Number, precision 3, scale 2 — so `1.5` is valid |

### Decimals are deliberate

Because the field accepts two decimal places, a new level can be slotted between two existing ones
without renumbering anything. Introducing a level between tier 1 and tier 2 means creating it as
tier 1.5, not rewriting every product.

### A worked example

| Product | Tier | Meaning |
|---|---|---|
| Director's Circle | 0 | highest |
| Patron | 1 | |
| Sustainer | 1.5 | added later, between Patron and Family |
| Family | 2 | |
| Individual | 3 | entry level |

A member moving Individual → Family is an **upgrade** (3 → 2). Family → Individual is a
**downgrade** (2 → 3).

---

## Known gap: equal tiers do nothing

The upgrade/downgrade decision has a rule for *less than* and a rule for *greater than*, and
**nothing for equal**. Two different products sharing a tier — a lateral move, such as switching
from one tier-2 product to another — match neither rule and fall to the decision's default outcome.
No event fires and nothing is recorded.

If lateral moves matter to your program, either give each product a distinct tier, or treat the
same-tier change as a renewal in your own reporting.

---

## Reporting with tiers

`Membership_Tier__c` is a number so that levels are *comparable*. That makes it poor for display —
a report grouped by it shows "Tier: 1" with no indication of what tier 1 is.

Two formula fields exist for this:

| Field | Object | Use |
|---|---|---|
| `Level__c` | Membership | The product name. Use this to **group and label** reports. |
| `Tier__c` | Membership | The product's tier. Use this to **sort and compare** levels. |
| `Term_Tier__c` | Membership Form Submission | The tier held during that specific term. |

`Term_Tier__c` matters because memberships extend in place — the membership record only shows the
current level, so the submission is the only place the level held during a past term survives.
Comparing `Term_Tier__c` across a membership's submissions in date order reconstructs its upgrade
and downgrade history.

---

## Which products participate

The membership finder only matches products where:

```
Family = 'Membership'   AND   Renewal_Option__c = 'Renewable'
```

A product outside that filter will not be matched to an existing membership, so a transaction
against it creates a **new** membership rather than extending the one the member already has. If
memberships are being duplicated instead of renewed, check these two fields on the product first.
