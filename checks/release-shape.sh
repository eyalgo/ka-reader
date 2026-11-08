#!/usr/bin/env bash
# Version: 1.0.0 — first version: reads the release workflow's text against its requirements
#   (CP-1170 to CP-1184)
#
# checks/release-shape.sh <workflow-file> — whether the release workflow still has its shape.
#
# WHY THIS EXISTS
#   The release workflow runs only when a tag is pushed, and while GitHub Actions is off nothing
#   runs it at all. What keeps its shape true at every change is this script, run as a step of the
#   gate: it reads the file's text and checks each requirement on its own, so a break is named by
#   the requirement it breaks. It runs every check before it reports, so one run names every break.
#   Stock macOS has no YAML parser and this product installs no tool for one, so the file is read
#   line by line in the layout below, as checks/tests/test_vm_refusal.sh reads ci.yml.
#
# THE LAYOUT THE FILE IS READ IN
#   Two-space YAML. Comment lines and blank lines are free. Top-level keys sit at column 0. The one
#   job's step items open with six spaces and "- ", and a step's keys sit at eight spaces, their
#   children at ten. Every run: value is one line, never a block scalar. No tab. Under jobs:, every
#   line is a key at one of those places: a more-indented line after a plain value would continue
#   that value in YAML, so a run line could hold more than the script reads. A file the script
#   cannot read in this layout is refused under the name Layout.
#
# USAGE
#   checks/release-shape.sh .github/workflows/release.yml
#   Exit 0: the file meets every requirement.
#   Exit 1: one stderr line for each requirement found missing, out of order or broken, each
#     carrying the requirement's name and CP id. Also exit 1 when the file is unreadable.
#   Exit 2: an argument count other than one, with a usage line on stderr.
#
# WHAT IT READS AND WRITES
#   It reads the one file and writes nothing. It reads no environment variable of its own.

set -euo pipefail

NAME="release-shape.sh"

if [ "$#" -ne 1 ]; then
  echo "$NAME: usage: $NAME <workflow-file>" >&2
  exit 2
fi

file="$1"

# --- what the file must say ---

RUN_GATE='checks/gate.sh'
RUN_INSTALL='cargo install cargo-audit --version 0.22.2 --locked'
RUN_VERSION='checks/release-version.sh "$GITHUB_REF_NAME" Cargo.toml target/release/bundle/macos/KA-Reader.app'
RUN_PACK='checks/release-pack.sh target/release/bundle/macos/KA-Reader.app dist'
RUN_SUMS='checks/release-sums.sh dist'
RUN_VERIFY='cd dist && shasum -a 256 -c SHA256SUMS'
RUN_ABSENT='checks/release-absent.sh "$GITHUB_REPOSITORY" "$GITHUB_REF_NAME"'
RUN_RELEASE='gh release create "$GITHUB_REF_NAME" --repo "$GITHUB_REPOSITORY" --draft --title "$GITHUB_REF_NAME" --notes "" --verify-tag dist/KA-Reader-*.dmg dist/SHA256SUMS'
# The audit line, with any number of ignored advisories after it.
AUDIT_PATTERN='^cargo audit( --ignore RUSTSEC-[0-9]{4}-[0-9]{4})*$'
CHECKOUT='actions/checkout@v5'
GATE_NAME='Test gate'
TOKEN_VALUE='${{ github.token }}'
STEP_COUNT=10

failures=0

# Reports one requirement found broken: its name, its id and what was found.
finding() {
  echo "$NAME: $1 ($2): $3" >&2
  failures=$((failures + 1))
}

if [ ! -f "$file" ] || [ ! -r "$file" ]; then
  finding "Layout" "CP-1184" "cannot read $file"
  exit 1
fi

# --- the file as the checks read it ---

# Without comment lines and blank lines.
body="$(grep -v -E '^[[:space:]]*(#.*)?$' "$file" || true)"

# One line per key of each step: the step's number, the key and its value, tab separated. A key
# under "with:" or "env:" is written "with.<key>" or "env.<key>". Only the lines under "jobs:" are
# read, so the trigger's own list item is not taken for a step.
steps="$(printf '%s\n' "$body" | awk '
  /^[^ ]/ { in_jobs = ($0 == "jobs:"); parent = ""; next }
  !in_jobs { next }
  /^      - / { step++; text = substr($0, 9); parent = "" }
  /^        [^ ]/ { text = substr($0, 9) }
  /^          [^ ]/ { text = substr($0, 11); child = 1 }
  /^      - / || /^        [^ ]/ || /^          [^ ]/ {
    if (!step) next
    colon = index(text, ":")
    if (colon == 0) next
    key = substr(text, 1, colon - 1)
    value = substr(text, colon + 1)
    sub(/^ +/, "", value)
    if (child) { key = parent "." key; child = 0 }
    else if (value == "") parent = key
    else parent = ""
    printf "%d\t%s\t%s\n", step, key, value
  }
')"

# The number of steps.
step_total() {
  printf '%s\n' "$steps" | awk -F'\t' 'NF { if ($1 > max) max = $1 } END { print max + 0 }'
}

# The value of key $2 on step $1, empty when there is none.
step_field() {
  printf '%s\n' "$steps" | awk -F'\t' -v step="$1" -v key="$2" '$1 == step && $2 == key { print $3; exit }'
}

# Succeeds when step $1 has the key $2.
step_has_key() {
  printf '%s\n' "$steps" | awk -F'\t' -v step="$1" -v key="$2" '$1 == step && $2 == key { found = 1 } END { exit !found }'
}

# The numbers of the steps whose run is exactly $1, one per line.
steps_running() {
  RUN="$1" awk -F'\t' '$2 == "run" && $3 == ENVIRON["RUN"] { print $1 }' <<< "$steps"
}

# The numbers of the steps whose run matches the extended pattern $1, one per line.
steps_running_matching() {
  printf '%s\n' "$steps" | awk -F'\t' '$2 == "run" { print $1 "\t" $3 }' | while IFS="$(printf '\t')" read -r number run; do
    if printf '%s\n' "$run" | grep -q -E -- "$1"; then
      echo "$number"
    fi
  done
}

# The one step whose run is $1, or nothing when there are none or several.
the_step_running() {
  found="$(steps_running "$1")"
  case "$found" in
    "" | *"
"*) ;;
    *) echo "$found" ;;
  esac
}

# The top-level block that opens with the line $1: that line and the indented lines after it.
block_of() {
  printf '%s\n' "$body" | awk -v opener="$1" '
    $0 == opener { inside = 1; print; next }
    inside && /^[^ ]/ { exit }
    inside { print }
  '
}

# --- one check per requirement: each prints what it found broken, or nothing ---

check_layout() {
  if grep -q "$(printf '\t')" "$file"; then
    echo "the file holds a tab"
    return
  fi
  if printf '%s\n' "$body" | grep -q -E '^( {8}| {6}- )run:[[:space:]]*([|>][^[:space:]]*)?[[:space:]]*$'; then
    echo "a run: value is not one line"
    return
  fi
  if ! printf '%s\n' "$body" | grep -q -x 'jobs:'; then
    echo "there is no jobs: key at column 0"
    return
  fi
  if [ "$(step_total)" -eq 0 ]; then
    echo "no step item was read under jobs:"
    return
  fi
  # Under jobs:, a line that is not a key at one of the layout's places would continue the value
  # above it in YAML, and the step table read above holds only that value's first line.
  stray="$(printf '%s\n' "$body" | awk '
    /^[^ ]/ { in_jobs = ($0 == "jobs:"); next }
    !in_jobs { next }
    !/^(  |    |      - |        |          )[A-Za-z0-9_-]+:( .*)?$/ { print; exit }
  ')"
  if [ -n "$stray" ]; then
    echo "the line \"$stray\" under jobs: is not a key in the layout, so it would continue the value above it"
  fi
}

check_trigger() {
  expected="on:
  push:
    tags:
      - 'v*'"
  if [ "$(block_of 'on:')" != "$expected" ]; then
    echo "the on: block is not exactly push, tags, 'v*'"
    return
  fi
  if printf '%s\n' "$body" | grep -q -E '^[[:space:]]*(workflow_dispatch|schedule|pull_request|branches)[[:space:]]*:'; then
    echo "a second trigger key appears"
  fi
}

check_runner() {
  runners="$(printf '%s\n' "$body" | grep -c 'runs-on:' || true)"
  if [ "$runners" -ne 1 ]; then
    echo "$runners runs-on: lines, expected one"
    return
  fi
  if ! printf '%s\n' "$body" | grep -q -x '    runs-on: macos-26'; then
    echo "the runs-on: line is not macos-26"
    return
  fi
  jobs="$(block_of 'jobs:' | grep -c -E '^  [^ ]' || true)"
  if [ "$jobs" -ne 1 ]; then
    echo "$jobs jobs, expected one"
  fi
}

check_checkout() {
  if [ "$(step_field 1 uses)" != "$CHECKOUT" ]; then
    echo "step 1 is not $CHECKOUT"
    return
  fi
  if [ "$(step_field 1 with.fetch-depth)" != "0" ]; then
    echo "the checkout does not set fetch-depth: 0"
    return
  fi
  if [ "$(step_field 1 with.persist-credentials)" != "false" ]; then
    echo "the checkout does not set persist-credentials: false"
    return
  fi
  if step_has_key 1 with.ref || step_has_key 1 ref; then
    echo "the checkout names a ref"
  fi
}

# The first step with a run: is step 2, it is the gate, and nothing else runs the gate.
check_gate_first() {
  first="$(printf '%s\n' "$steps" | awk -F'\t' '$2 == "run" { print $1; exit }')"
  if [ "$first" != "2" ]; then
    echo "the first step with a run: is step ${first:-none}, expected step 2"
    return
  fi
  if [ "$(step_field 2 run)" != "$RUN_GATE" ]; then
    echo "step 2 does not run exactly $RUN_GATE"
    return
  fi
  if [ "$(step_field 2 name)" != "$GATE_NAME" ]; then
    echo "step 2 is not named $GATE_NAME"
    return
  fi
  runners="$(printf '%s\n' "$steps" | awk -F'\t' '$2 == "run" && index($3, "checks/gate.sh") == 1 { n++ } END { print n + 0 }')"
  if [ "$runners" -ne 1 ]; then
    echo "$runners steps run the gate, expected one"
  fi
}

# The audit: the install, then the audit, both after the gate, and a reason above every ignored
# advisory.
check_audit() {
  install="$(the_step_running "$RUN_INSTALL")"
  if [ -z "$install" ]; then
    echo "there is not exactly one step running: $RUN_INSTALL"
    return
  fi
  audit_steps="$(steps_running_matching "$AUDIT_PATTERN")"
  case "$audit_steps" in
    "" | *"
"*)
      echo "there is not exactly one step running cargo audit"
      return
      ;;
  esac
  gate="$(the_step_running "$RUN_GATE")"
  if [ -z "$gate" ] || [ "$install" -le "$gate" ] || [ "$audit_steps" -le "$install" ]; then
    echo "the audit does not come after the gate, install first"
    return
  fi
  audit_run="$(step_field "$audit_steps" run)"
  # The comment block directly above the run line, read from the raw file.
  above="$(RUN_LINE="        run: $audit_run" awk '
    { lines[NR] = $0 }
    END {
      for (i = 1; i <= NR; i++) if (lines[i] == ENVIRON["RUN_LINE"]) at = i
      for (i = at - 1; i >= 1 && lines[i] ~ /^[[:space:]]*#/; i--) print lines[i]
    }
  ' "$file")"
  ignored="$(printf '%s\n' "$audit_run" | grep -o -E 'RUSTSEC-[0-9]{4}-[0-9]{4}' || true)"
  while IFS= read -r id; do
    [ -n "$id" ] || continue
    if ! printf '%s\n' "$above" | grep -q -E "^[[:space:]]*# $id: [^[:space:]]"; then
      echo "$id is ignored with no reason in a comment line directly above the run: line"
      return
    fi
  done <<< "$ignored"
}

# Requirement $1 needs exactly one step running $2.
check_one_step() {
  if [ -z "$(the_step_running "$1")" ]; then
    echo "there is not exactly one step running: $1"
  fi
}

# The env of the step running $1 holds GH_TOKEN and nothing else.
check_env_is_token_only() {
  number="$(the_step_running "$1")"
  [ -n "$number" ] || return 0
  keys="$(printf '%s\n' "$steps" | awk -F'\t' -v step="$number" '$1 == step && $2 ~ /^env/ { print $2 }')"
  if [ "$keys" != "env
env.GH_TOKEN" ] || [ "$(step_field "$number" env.GH_TOKEN)" != "$TOKEN_VALUE" ]; then
    echo "its env is not exactly GH_TOKEN: $TOKEN_VALUE"
  fi
}

check_existing_release() {
  reason="$(check_one_step "$RUN_ABSENT")"
  if [ -n "$reason" ]; then
    echo "$reason"
    return
  fi
  reason="$(check_env_is_token_only "$RUN_ABSENT")"
  if [ -n "$reason" ]; then
    echo "the existing-Release step: $reason"
    return
  fi
  expected='concurrency:
  group: release-${{ github.ref }}
  cancel-in-progress: false'
  if [ "$(block_of 'concurrency:')" != "$expected" ]; then
    echo "the concurrency: block is not exactly the per-tag group with cancel-in-progress: false"
  fi
}

check_release() {
  reason="$(check_one_step "$RUN_RELEASE")"
  if [ -n "$reason" ]; then
    echo "$reason"
    return
  fi
  reason="$(check_env_is_token_only "$RUN_RELEASE")"
  if [ -n "$reason" ]; then
    echo "the Release step: $reason"
    return
  fi
  if [ "$(the_step_running "$RUN_RELEASE")" != "$(step_total)" ]; then
    echo "the Release step is not the last step"
  fi
}

# Each identified step that is present appears after the one before it.
check_order() {
  previous=0
  previous_name=""
  for pair in "gate|$RUN_GATE" "audit install|$RUN_INSTALL" "version|$RUN_VERSION" "pack|$RUN_PACK" "sums|$RUN_SUMS" "verify|$RUN_VERIFY" "existing Release|$RUN_ABSENT" "Release|$RUN_RELEASE"; do
    label="${pair%%|*}"
    number="$(the_step_running "${pair#*|}")"
    # The audit line sits between the install and the version check.
    if [ "$label" = "version" ]; then
      audit_number="$(steps_running_matching "$AUDIT_PATTERN" | head -n 1)"
      if [ -n "$audit_number" ]; then
        if [ "$audit_number" -le "$previous" ]; then
          echo "audit comes before $previous_name"
          return
        fi
        previous="$audit_number"
        previous_name="audit"
      fi
    fi
    [ -n "$number" ] || continue
    if [ "$number" -le "$previous" ]; then
      echo "$label comes before $previous_name"
      return
    fi
    previous="$number"
    previous_name="$label"
  done
}

# The step set is closed: the checkout and the nine run lines.
check_closed_step_set() {
  total="$(step_total)"
  if [ "$total" -ne "$STEP_COUNT" ]; then
    echo "$total steps, expected $STEP_COUNT"
    return
  fi
  number=1
  while [ "$number" -le "$total" ]; do
    uses="$(step_field "$number" uses)"
    run="$(step_field "$number" run)"
    if [ -n "$uses" ]; then
      if [ "$number" -ne 1 ] || [ "$uses" != "$CHECKOUT" ]; then
        echo "step $number uses $uses, which is not the checkout"
        return
      fi
    else
      case "$run" in
        "$RUN_GATE" | "$RUN_INSTALL" | "$RUN_VERSION" | "$RUN_PACK" | "$RUN_SUMS" | "$RUN_VERIFY" | "$RUN_ABSENT" | "$RUN_RELEASE") ;;
        *)
          if ! printf '%s\n' "$run" | grep -q -E -- "$AUDIT_PATTERN"; then
            echo "step $number runs \"$run\", which is not one of the closed set"
            return
          fi
          ;;
      esac
    fi
    number=$((number + 1))
  done
}

check_no_secret_no_signing_one_permission() {
  hit="$(printf '%s\n' "$body" | grep -o -i -E 'secrets\.|codesign|notarytool|stapler|security|keychain|\.p12|certificate' | head -n 1 || true)"
  if [ -n "$hit" ]; then
    echo "\"$hit\" appears outside a comment"
    return
  fi
  if [ "$(block_of 'permissions:')" != "permissions:
  contents: write" ]; then
    echo "the permissions: block is not exactly contents: write"
    return
  fi
  if [ "$(printf '%s\n' "$body" | grep -c -E '^[[:space:]]*permissions:' || true)" -ne 1 ]; then
    echo "a second permissions: key appears"
    return
  fi
  expression="$(printf '%s\n' "$body" | grep -F '${{' | sed 's/^[[:space:]]*//' | grep -v -x -F -e 'GH_TOKEN: ${{ github.token }}' -e 'group: release-${{ github.ref }}' | head -n 1 || true)"
  if [ -n "$expression" ]; then
    echo "the expression in \"$expression\" is neither github.token in an env nor github.ref in the group"
    return
  fi
  # An env: for the whole workflow, or for the job, reaches every step. A step's own env: sits at
  # eight spaces, or opens its item.
  wide_env="$(printf '%s\n' "$body" | grep -E '^[[:space:]]*(- )?env[[:space:]]*:' | grep -v -E '^(        |      - )env:' | head -n 1 || true)"
  if [ -n "$wide_env" ]; then
    echo "\"$wide_env\" is an env: that is not one step's own, so it reaches every step"
    return
  fi
  allowed_absent="$(the_step_running "$RUN_ABSENT")"
  allowed_release="$(the_step_running "$RUN_RELEASE")"
  holders="$(printf '%s\n' "$steps" | awk -F'\t' '$2 == "env" { print $1 }')"
  while IFS= read -r number; do
    [ -n "$number" ] || continue
    if [ "$number" != "$allowed_absent" ] && [ "$number" != "$allowed_release" ]; then
      echo "step $number has an env:, which only the existing-Release and Release steps may"
      return
    fi
  done <<< "$holders"
}

check_every_step_fatal() {
  if printf '%s\n' "$body" | grep -q -E '^[[:space:]]*(- )?if[[:space:]]*:|continue-on-error'; then
    echo "an if: or continue-on-error appears"
    return
  fi
  if [ "$(block_of 'defaults:')" != "defaults:
  run:
    shell: bash" ]; then
    echo "the defaults: block is not exactly run: shell: bash"
    return
  fi
  if [ "$(printf '%s\n' "$body" | grep -c -E '^[[:space:]]*(- )?shell:' || true)" -ne 1 ]; then
    echo "a step sets its own shell:"
  fi
}

# --- run them all, then report ---

report() {
  reason="$("$1")"
  if [ -n "$reason" ]; then
    finding "$2" "$3" "$reason"
  fi
}

report check_layout "Layout" "CP-1184"
report check_trigger "Trigger" "CP-1170"
report check_runner "Runner" "CP-1171"
report check_checkout "Checkout" "CP-1172"
report check_gate_first "Gate first" "CP-1173"
report check_audit "Audit" "CP-1174"
check_version() { check_one_step "$RUN_VERSION"; }
check_pack() { check_one_step "$RUN_PACK"; }
check_sums() { check_one_step "$RUN_SUMS"; }
check_verify() { check_one_step "$RUN_VERIFY"; }

report check_version "Version" "CP-1175"
report check_pack "Pack" "CP-1176"
report check_sums "Sums" "CP-1177"
report check_verify "Verify" "CP-1178"
report check_release "Release" "CP-1179"
report check_existing_release "Existing Release" "CP-1180"
report check_closed_step_set "No other write" "CP-1181"
report check_no_secret_no_signing_one_permission "No secret, no signing, one permission" "CP-1182"
report check_every_step_fatal "Every step fatal" "CP-1183"
report check_order "Order" "CP-1184"

if [ "$failures" -ne 0 ]; then
  exit 1
fi
