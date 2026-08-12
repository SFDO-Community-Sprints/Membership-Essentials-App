#!/usr/bin/env bash
# Builds the throwaway fixtures the dry evals run against.
# Everything lives under this script's own fixtures/ directory: no remotes, no
# network, no scratch orgs, nothing outside the skill folder.
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FIXTURES="$HERE/fixtures"

case "$FIXTURES" in
  */metecho-local/evals/fixtures) ;;
  *) echo "refusing to touch $FIXTURES — not the expected fixtures path" >&2; exit 1 ;;
esac

rm -rf "$FIXTURES"
mkdir -p "$FIXTURES"

# ---------------------------------------------------------------------------
# sprint-repo: a CumulusCI project shaped like this one — a default branch, a
# live sprint branch, and a dead sprint branch from the Metecho era.
# ---------------------------------------------------------------------------
REPO="$FIXTURES/sprint-repo"
mkdir -p "$REPO"
git -C "$REPO" init --quiet --initial-branch=master
git -C "$REPO" config user.name "Fixture Author"
git -C "$REPO" config user.email "unlinked@example.invalid"

mkdir -p "$REPO/force-app/main/default/objects" "$REPO/datasets" "$REPO/unpackaged/dev"
cat > "$REPO/cumulusci.yml" <<'YAML'
minimum_cumulusci_version: '3.9.1'
project:
    name: Membership-Management
    package:
        name: Membership-Management
        api_version: '59.0'
    source_format: sfdx
flows:
    config_dev:
        steps:
            3:
                task: assign_permission_sets
                options:
                    api_names: Membership_Manage
YAML
printf '{"packageDirectories":[{"path":"force-app","default":true}],"namespace":null,"sourceApiVersion":"59.0"}\n' \
  > "$REPO/sfdx-project.json"
git -C "$REPO" add -A
git -C "$REPO" commit --quiet -m "Fixture project skeleton"

# A dead sprint branch, Metecho-era naming.
git -C "$REPO" branch metecho/2025-september-sprint

# The live sprint branch, carrying a commit the default branch does not have,
# so a branch cut from the wrong base is detectable by ancestry alone.
git -C "$REPO" checkout --quiet -b community_sprint_august2026
echo "August 2026 sprint scope" > "$REPO/SPRINT.md"
git -C "$REPO" add -A
git -C "$REPO" commit --quiet -m "Open the August 2026 sprint"
git -C "$REPO" checkout --quiet master

# ---------------------------------------------------------------------------
# list-changes.txt: stands in for `cci task run list_changes` output, so the
# retrieve-accounting eval runs without a scratch org. Mixes components a
# contributor wants with the churn a scratch org emits unasked.
# ---------------------------------------------------------------------------
cat > "$FIXTURES/list-changes.txt" <<'TXT'
Found 7 changed components in the target org.

MemberName                                    MemberType
--------------------------------------------  ------------------
Membership__c.Renewal_Reminder_Sent__c        CustomField
Membership__c-Membership Layout               Layout
DPEV_Listener_Membership_Renewal              Flow
Membership_Manage                             PermissionSet
Admin                                         Profile
Membership_Form_Submission__c.Notes__c        CustomField
Membership__c                                 CustomObject
TXT

echo "fixtures built at $FIXTURES"
git -C "$REPO" branch --list
