# Setting up — what to install, and what to ask

Reached from the doctor pass in [SKILL.md](SKILL.md), once it has reported what is missing. Nothing here runs before the contributor agrees to it.

## Ask about these three, once

The probes settle everything except the credentials. Ask about those together, in a single round, rather than one at a time:

1. **Which Dev Hub.** Scratch orgs need one, and nobody hosts one for this project. Name the candidates `sf org list` found. A free Developer Edition org with Dev Hub enabled is the standard answer for a contributor without an enterprise org; its allowance is 3 active and 6 daily scratch orgs. When the only candidate is a production org, say so explicitly rather than defaulting into it — the scratch orgs it issues are empty, but it is still a choice worth making out loud.
2. **Which commit email.** The CLA bot needs an address GitHub resolves to the account being contributed under, and a work address set globally is the usual reason it fails. Propose the address the active `gh` account is known by.
3. **Which GitHub account**, when `gh auth status` lists more than one.

## Install what the doctor found missing

**CumulusCI** needs Python < 3.14, so pin the interpreter when the system default is newer:

```
pipx install --python "$(which python3.12)" "cumulusci[select]"
```

`cci version` confirms it. The `[select]` extra silences the optional-dependency warning that appears on org commands and keeps high-volume record selection on its optimized path; an existing install picks it up with `pipx upgrade "cumulusci[select]"`.

**Salesforce CLI**: `npm install --global @salesforce/cli`.

**GitHub CLI**: from the platform's package manager, then `gh auth login`. `gh auth switch --user <account>` moves the active account when the probe shows the wrong one.

## Wire up the clone

Both of these are per-clone and deliberate rather than global:

```
sf config set target-dev-hub=<chosen-alias>
```

Without `--global` this writes into whatever directory you are standing in, which is the point — each clone names its Dev Hub explicitly and no other project inherits it. `sf config get target-dev-hub` reads it back.

```
git config user.email <chosen-address>
```

Repo-local, so a work address can stay global while this clone commits under the contributing identity.

Then build the first org:

```
SF_TEMP_SHOW_SECRETS=true cci flow run dev_org --org dev
```

Setup is done when `cci org list` shows this project's org configs with `dev` carrying days remaining, `sf config get target-dev-hub` returns the chosen alias, and `git config user.email` returns an address the contributing GitHub account is known by.

## Retiring orgs

A Developer Edition Dev Hub allows 3 active and 6 daily scratch orgs, so finished orgs are retired with `cci org scratch_delete <name>` rather than left to expire. On a larger Dev Hub this only matters when a failed flow leaves an orphan behind — which is what a missing `SF_TEMP_SHOW_SECRETS` prefix causes.
