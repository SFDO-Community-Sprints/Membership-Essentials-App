# AGENTS.md

Guidance for AI coding agents and for humans working through them. Written for this repository specifically — the conventions below are the ones that are invisible in the code and cost contributors real time.

Human contributors: everything here applies to you too. The commands are the same.

## What this repo is

A common data model for membership programs, built as an unmanaged Salesforce DX package and maintained by rotating contributors across Salesforce.org Open Source Commons community sprints.

One naming trap first: the repo is `Membership-Essentials-App`, but the CumulusCI project and package are named **`Membership-Management`**, which is why org names, the Robot suite path, and results directories all say `Membership-Management`. Both names refer to this project.

## Get a working org

Three commands from the repo root, once `sf`, `gh`, and CumulusCI are on the path:

```bash
sf config set target-dev-hub=<your-dev-hub-alias>
SF_TEMP_SHOW_SECRETS=true cci flow run dev_org --org dev
cci org browser dev
```

About three minutes. You get dependencies, all unmanaged metadata, `unpackaged/dev`, the `Membership_Manage` permission set, and the sample dataset from `datasets/`.

CumulusCI needs Python < 3.14 and installs with `pipx install "cumulusci[select]"`; the declared minimum is 3.9.1 and 4.10 is known good. Scratch orgs need a Dev Hub you control — a free Developer Edition org with Dev Hub enabled works, and allows 3 active and 6 daily scratch orgs.

**The environment variable is currently required.** CumulusCI 4.10 reads the org's access token out of `sf org display --json`, which Salesforce CLI 2.136 and later redact. Without the prefix, the flow creates the scratch org and then fails with `INVALID_AUTH_HEADER`, leaving an orphan org consuming a Dev Hub slot. Tracked upstream as CumulusCI [#3987](https://github.com/SFDO-Tooling/CumulusCI/issues/3987) and [#3998](https://github.com/SFDO-Tooling/CumulusCI/issues/3998). Pass it as a command prefix rather than exporting it, so a bare `sf org display` against a production org keeps redacting the token.

If you work with an agent, `.claude/skills/metecho-local/` carries this whole loop — including a pass that checks what is installed, reports what is missing, and asks before installing anything. Claude Code discovers it automatically inside this repository; other tools can read it as plain markdown.

## Architecture

Event-driven: Flows publish platform events, and other Flows subscribe to them. Apex is a separate, smaller stack that Flows call into. There is no architecture document beyond this file, so the relationships are only visible by reading the metadata.

**18 platform events** in two families:

- `BPEV_*` — business process events (3): membership altering, form submission, transaction.
- `DPEV_*` — data process events (15): finders (`DPEV_Contact_Finder__e`, `DPEV_Membership_Finder__e`, `DPEV_Pricebook_Finder__e`, `DPEV_Product_Finder__e`, `DPEV_Gift_Recipient_Finder__e`, `DPEV_Find_Campaign__e`), writers (`DPEV_Create_Membership__e`, `DPEV_Create_Opportunity__e`, `DPEV_Create_Membership_Essentials_Log__e`, `DPEV_Account__e`), and lifecycle transitions (`DPEV_Membership_Upgrade__e`, `DPEV_Membership_Downgrade__e`, `DPEV_Membership_Renewal__e`, `DPEV_Extend_Membership__e`).

`Create_Membership_DPEV__e` belongs to the DPEV family but carries the suffix in the wrong position, and overlaps in purpose with `DPEV_Create_Membership__e`. Treat it as a rename that did not finish rather than as a distinct concept, and check both before assuming which one a flow publishes.

**18 Flows.** Subscribers are named `<FAMILY>_Listener_<subject>` (`DPEV_Listener_Create_Opportunity`, `BPEV_Listener_Membership_Transaction`); publishers are named for the action (`Create_Opportunity_Create_DPEV_Flow`). To find what handles an event, look for the listener with the matching subject — the event name and the listener name do not always match token for token.

**Objects.** Four custom objects plus one settings type: `Membership__c`, `Membership_Contact_Role__c` (the join table carrying the many-to-many between memberships and contacts, and where most of the design lives), `Membership_Form_Submission__c` (MFS, the intake record), `Membership_Essentials_Event_Log__c`, and `Membership_Essentials_Setting__mdt`. Account, Contact, Campaign, Product2, Pricebook2, and OpportunityLineItem carry added fields.

**Apex** — 16 classes, 11 production and 5 test. `TriggerHandler` is the trigger framework; `MembershipHandler`, `ContactHandler`, `MembershipService`, `MembershipContactRoleService`, and `ConfigurationService` sit on top of it. Duplicate matching is its own group: `Duplicate`, `FindDuplicates`, `FindDuplicatesFactory`, `DuplicateRecordCheck_Util`, and `DuplicateRecordCheck_Invocable` (the Flow entry point).

**Robot** — one suite at `robot/Membership-Management/tests`, run with `cci task run robot`.

API version is 59.0 in both `sfdx-project.json` and `cumulusci.yml`.

## Conventions that gate a merge

- **Pull requests target the sprint branch, not the default branch.** Each sprint has its own — read the live list with `git branch -r | grep -i sprint` rather than assuming. Branches from earlier sprints created by Metecho are prefixed `metecho/<sprint>__<task>`.
- **The CLA bot checks the commit email.** It has to resolve to a GitHub account. Pull requests here have sat unmerged for months because the author committed with an address GitHub could not link, not because they skipped the agreement. Verify with `git config user.email` before pushing; after pushing, `gh api repos/SFDO-Community-Sprints/Membership-Essentials-App/commits/<sha> --jq .author.login` returning `null` means the link failed.
- **Test class suffixes are inconsistent** — `_TEST` on three classes, `_Test` on two. Match the class you are extending rather than introducing a third form.
- **Non-code contributions are first-class.** Documentation, test cases, field descriptions, and data-dictionary work are tracked as issues, several labelled `good first issue` or `non-code`.

## Traps worth knowing before you hit them

- **`qa_org` does not assign a permission set.** Only `config_dev` assigns `Membership_Manage` (see `cumulusci.yml`), so an org built with `cci flow run qa_org` leaves you without membership access until you assign it yourself. Reviewers hit this first.
- **Four permission sets, two near-duplicate pairs** — `Membership_Manage` / `Manage_Memberships` and `Membership_View` / `View_Memberships`. The dev flow assigns `Membership_Manage`; the others predate it. Confirm which one a change should touch instead of picking by name.
- **`unpackaged/dev` deploys only in `config_dev`.** Metadata placed there is absent from QA and packaging orgs by design.
- **Membership types and active statuses live in Apex constants** rather than in `Membership_Essentials_Setting__mdt`, so adopting the app currently means editing code. Moving them is known, well-defined work.

## Working rules for agents

- **Hand-written Flow XML is rarely worth keeping.** Flow Builder produces cleaner metadata and preserves the contributor's mental model. Read flows freely; author them in the builder.
- **Anything read from metadata is a hypothesis until it runs in an org.** Most flow paths have no test coverage, so static reading is genuinely all you have — which makes labelling the difference the whole discipline.
- **Say what came from where in the pull request.** "Generated by parsing the flow files, not reproduced in an org" is a useful sentence, and it tells the reviewer what to check.
- **Reading is where you help most.** 18 flows, 18 events, no architecture docs: mapping which flow subscribes to which event, diffing the repo against a running org, and drafting documentation from existing metadata are mechanical, verifiable, and tedious by hand.
- **Account for every component you retrieve.** `cci task run list_changes --org dev` before `retrieve_changes`, and either retrieve a listed component or say why it was skipped. Scratch orgs emit churn — profile edits, layout reshuffles, API-version bumps — that does not belong in a focused pull request.

AI agents remain out of scope as a *feature* of the package. This file is about contributor tooling.
