---
name: metecho-local
description: Metecho's contribution loop, run locally against this CumulusCI project. Use when starting work on a sprint issue, checking whether the local toolchain is ready, building or refreshing a dev or QA scratch org, capturing scratch-org changes into a branch, opening or reviewing a sprint PR, or mapping the project's flows and platform events.
---

# metecho-local

Metecho is frozen; the loop it enforced is still the contract. It created the task branch, built the org from this project's own CumulusCI flows, listed your org changes as checkboxes, and pointed the pull request at the sprint branch. Locally, CumulusCI does all four — what breaks is the conventions Metecho used to hold invisibly, so they are preflight here rather than folklore.

Project facts — architecture, objects, event families, known traps — live in [AGENTS.md](../../../AGENTS.md). This skill is the loop only.

## Check the environment first

Run the doctor pass whenever the environment is unproven: a new machine, a clone you have not yet built an org in, or the first `cci` failure of a session. Skip it mid-loop.

| Probe | What it settles |
| --- | --- |
| `cci version` | CumulusCI present, and which Python it runs on (it needs < 3.14) |
| `sf --version` | Salesforce CLI present |
| `gh --version` and `gh auth status` | GitHub CLI present, which accounts are authenticated, which is active |
| `sf org list` | Which orgs are connected, and which of them are Dev Hubs |
| `sf config get target-dev-hub` from the repo root | Whether this clone already points at a Dev Hub |
| `git config user.email` | Whether this clone has a commit identity GitHub can resolve |
| `git branch -r \| grep -iE 'sprint\|metecho'` | The sprint branch that will be the base |
| `gh api repos/<owner>/<repo> --jq .permissions.push` | Branches on `origin`, or a fork |

Report the result as two lists — present, and missing — and ask before installing anything or writing any config. Install recipes are in [SETUP.md](SETUP.md); the three credential decisions that are genuinely the contributor's are listed there too.

## Preflight — every run

- **Repo root.** Every `cci` command runs from the folder holding `cumulusci.yml`.
- **Sprint branch.** The base for every branch and every pull request. Discover it rather than assuming — each sprint opens a new one, and branches from the Metecho era carry a `metecho/` prefix. The repository's default branch is never the base.
- **Token prefix.** Every `cci` command that touches an org runs as `SF_TEMP_SHOW_SECRETS=true cci …`. CumulusCI 4.10 reads the access token out of `sf org display --json`, which Salesforce CLI 2.136 and later redact; without the prefix the flow creates the scratch org and *then* dies on `INVALID_AUTH_HEADER`, leaving an orphan org holding a Dev Hub slot. It stays a command prefix, so a bare `sf org display` against a production org keeps redacting the token. Upstream: CumulusCI #3987, #3998.
- **Commit identity.** `git config user.email` has to be an address GitHub resolves to the account you contribute under, or the CLA bot parks the pull request — several upstream PRs have sat for years on exactly this. Where a work address is set globally, sprint clones set the contributing address repo-locally.

## Start a task

1. `gh issue develop <n> --base <sprint-branch> --checkout` — branches from the sprint branch and links the branch to the issue on GitHub. Naming by hand takes Metecho's shape: `metecho/<sprint>__<task-slug>`.
2. `SF_TEMP_SHOW_SECRETS=true cci flow run dev_org --org dev` — about three minutes: dependencies, unmanaged metadata, permission set, sample dataset.
3. `SF_TEMP_SHOW_SECRETS=true cci task run snapshot_changes --org dev` — baselines source tracking so the next `list_changes` returns only your work.
4. `cci org browser dev` to land in the org.

Done when `git rev-parse --abbrev-ref HEAD` is the task branch, `git merge-base --is-ancestor <sprint-branch> HEAD` succeeds, and `cci org list` shows `dev` with days remaining.

## Save the org's changes into the branch

1. `SF_TEMP_SHOW_SECRETS=true cci task run list_changes --org dev`. Hundreds of components means the baseline was never snapshotted — snapshot, rebuild your change, and list again.
2. `SF_TEMP_SHOW_SECRETS=true cci task run retrieve_changes --org dev --include "<patterns>"` — `--include` and `--exclude` take comma-separated patterns matched against each component's type and name, `--types` filters by metadata type. Data rather than metadata goes through `cci task run extract_dataset`, which writes into `datasets/`.
3. `git status` and read the diff before committing. Scratch orgs emit churn nobody asked for — profile edits, layout reshuffles, API-version bumps.

Done when every component `list_changes` reported is accounted for: retrieved into the branch, or named out loud as deliberately left behind. A component silently dropped is the failure this step exists to catch.

## Submit

1. `git push -u origin HEAD`
2. `gh pr create --base <sprint-branch> --fill`
3. `gh pr view --json baseRefName,headRefName` — `baseRefName` is the sprint branch.
4. `gh api repos/<owner>/<repo>/commits/$(git rev-parse HEAD) --jq .author.login` — a login proves GitHub linked the commit email to an account and the CLA bot will pass. `null` means fix `user.email`, amend, and force-push now rather than after the sprint closes.

## Review someone else's PR

1. `gh pr checkout <n>`
2. `SF_TEMP_SHOW_SECRETS=true cci flow run qa_org --org qa` — a clean org built from their branch, not your dev org.
3. Assign the membership permission set by hand. `qa_org` does not assign one; only `config_dev` does. See AGENTS.md for which of the four to pick.
4. The review states what was clicked in the org. Reading the metadata is not testing it.

## Reading the metadata

The highest-value use of an agent on this project, because it carries no architecture documentation beyond AGENTS.md and the relationships only appear by reading every file.

- **Event map:** parse every `*.flow-meta.xml` for its trigger and event references, and account for each platform event — either a named subscriber or "no subscriber found".
- **Repo against an org:** `sf project deploy start --dry-run --source-dir force-app --target-org <alias>`.
- **Hypothesis discipline:** anything read from metadata stays a hypothesis until it runs in an org, and the pull request says which it is. "Generated by parsing the flow files, not reproduced in an org" is the sentence that keeps a finding honest.
- Hand-written Flow XML is rarely worth keeping — Flow Builder produces cleaner metadata and preserves your mental model of the flow.

## Using this outside this clone

Claude Code discovers this skill automatically for anyone working inside this repository — there is nothing to install. To carry it across several CumulusCI sprint projects, copy the folder into your personal skills directory:

```
cp -r .claude/skills/metecho-local ~/.claude/skills/
```

Nothing in the loop is specific to this project: it discovers the sprint branch, the Dev Hub, and the repository from wherever it runs.
