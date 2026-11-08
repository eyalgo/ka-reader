#!/usr/bin/env bash
# checks/tests/test_release_shape.sh — the tests of checks/release-shape.sh, which reads the release
# workflow's text against its requirements (CP-1170 to CP-1184).
# Version: 1.0.0 — first version: the tree's workflow passes, and for every requirement a copy with
#   that requirement removed, moved or broken is refused naming it (the negative control, CP-1185)
#
# WHY THIS EXISTS
#   The release workflow cannot run while GitHub Actions is off, so the only thing that holds its
#   shape at every change is a script reading its text. A check that passes everything looks the
#   same as a check that works, so the cases run the real checks/release-shape.sh — never a copy of
#   its logic — on copies of the tree's .github/workflows/release.yml in a work folder, each copy
#   with one requirement broken, and require exit 1 with the requirement's id and name on the
#   output. The tree's own file is never edited. The control: the copy handed through the same
#   mutation helper with nothing changed must pass, so a mutation that fails fails for its own
#   reason.
#
# USAGE
#   checks/tests/test_release_shape.sh
#     KA_READER_TEST_ONLY=<case> runs one case.
#
# WHY NO `set -e`
#   A case that fails must not end the run before the remaining cases report. Each case returns its
#   own status and the runner counts them.
#
# WHERE IT WRITES
#   Only below one `mktemp -d` directory, removed by a trap on exit. The tree is read, never
#   written.

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SCRIPT="$ROOT/checks/release-shape.sh"
TREE_FILE="$ROOT/.github/workflows/release.yml"

STATUS=0
OUT=""
ERR=""
WORK=""
COPY=""
NL="
"

# The run lines of the steps, as the tree's file holds them. A mutation names a step by its run
# line.
RUN_GATE="run: checks/gate.sh"
RUN_AUDIT="run: cargo audit"
RUN_VERSION="run: checks/release-version.sh"
RUN_PACK="run: checks/release-pack.sh"
RUN_SUMS="run: checks/release-sums.sh"
RUN_VERIFY="run: cd dist"
RUN_ABSENT="run: checks/release-absent.sh"
RUN_RELEASE="run: gh release create"

CASES="
test_the_tree_file_passes
test_the_unmodified_copy_passes
test_a_second_trigger_is_refused
test_a_floating_runner_is_refused
test_a_checkout_that_is_shallow_or_redirected_or_keeps_credentials_is_refused
test_a_gate_that_is_not_first_is_refused
test_the_audit_is_required_and_an_ignore_needs_its_reason
test_each_release_step_is_required
test_a_misordered_step_is_refused
test_a_step_outside_the_closed_set_is_refused
test_a_secret_a_signing_call_or_a_second_permission_is_refused
test_an_env_above_the_steps_is_refused
test_a_step_that_may_fail_is_refused
test_a_block_scalar_run_is_refused_under_layout
test_a_run_line_continued_on_the_next_line_is_refused_under_layout
test_a_file_that_is_not_in_the_layout_is_refused_under_layout
test_the_release_steps_hold_their_env_group_and_place
test_two_breaks_in_one_copy_name_both
test_an_unreadable_or_missing_file_is_refused
test_a_wrong_argument_count_exits_2
test_the_gate_holds_the_new_suite_as_a_fatal_step
"

# --- helpers ---

fail() {
  echo "  $*"
  return 1
}

show_output() {
  printf '%s\n%s\n' "$OUT" "$ERR" | sed '/^$/d; s/^/  /'
}

# A fresh copy of the tree's workflow named $1 in the work folder; its path is in $COPY.
new_copy() {
  COPY="$WORK/$1.yml"
  cp "$TREE_FILE" "$COPY"
}

# Runs the check on the path $1, keeping its status and its two streams.
run_check() {
  "$SCRIPT" "$@" > "$WORK/stdout" 2> "$WORK/stderr"
  STATUS=$?
  OUT="$(cat "$WORK/stdout")"
  ERR="$(cat "$WORK/stderr")"
}

# The check refused the copy and its stderr names the requirement text $1 (an id such as
# "(CP-1170)", or a name such as "Layout").
expect_refused_naming() {
  if [ "$STATUS" -ne 1 ]; then
    fail "expected exit 1 naming $1, got $STATUS. Its output follows."
    show_output
    return 1
  fi
  case "$ERR" in
    *"$1"*) return 0 ;;
  esac
  fail "the refusal does not name $1. Its output follows."
  show_output
  return 1
}

# The copy $COPY, run through the check, is refused naming $1.
copy_is_refused_naming() {
  run_check "$COPY"
  expect_refused_naming "$1"
}

# Rewrites the copy $COPY by an operation on its lines. All three read the copy and write it back.
#   drop_lines <fixed text>            removes every line holding the text
#   drop_exact <fixed text>            removes every line that is exactly the text
#   replace_text <old> <new>           replaces the first occurrence of the text in the first line
#   holding it
#   insert_after <fixed text> <lines>  adds the lines after the first line holding the text
#   insert_before <fixed text> <lines> adds the lines before the first line holding the text
drop_lines() {
  grep -v -F -- "$1" "$COPY" > "$COPY.new"
  mv "$COPY.new" "$COPY"
}

# Removes every line that is exactly the text, for a short line such as "  run:" that a longer line
# holds.
drop_exact() {
  grep -v -x -F -- "$1" "$COPY" > "$COPY.new"
  mv "$COPY.new" "$COPY"
}

replace_text() {
  OLD="$1" NEW="$2" awk '
    !done && index($0, ENVIRON["OLD"]) {
      i = index($0, ENVIRON["OLD"])
      $0 = substr($0, 1, i - 1) ENVIRON["NEW"] substr($0, i + length(ENVIRON["OLD"]))
      done = 1
    }
    { print }
  ' "$COPY" > "$COPY.new"
  mv "$COPY.new" "$COPY"
}

insert_after() {
  NEEDLE="$1" TEXT="$2" awk '
    { print }
    !done && index($0, ENVIRON["NEEDLE"]) { print ENVIRON["TEXT"]; done = 1 }
  ' "$COPY" > "$COPY.new"
  mv "$COPY.new" "$COPY"
}

insert_before() {
  NEEDLE="$1" TEXT="$2" awk '
    !done && index($0, ENVIRON["NEEDLE"]) { print ENVIRON["TEXT"]; done = 1 }
    { print }
  ' "$COPY" > "$COPY.new"
  mv "$COPY.new" "$COPY"
}

# Rewrites the steps of the copy. A step is a "      - " line and the lines after it up to the next
# one, so the text before the first step stays where it is.
#   steps_keep                         writes the copy back as it is: the control
#   steps_drop <needle>                removes the first step holding the text
#   steps_move <needle> <after needle> moves the first step holding the first text to just after the
#   first step holding the second
#   steps_insert_after <needle> <text> adds a step's text after the first step holding the needle
steps_rewrite() {
  OP="$1" A="${2:-}" B="${3:-}" awk '
    /^      - / { n++; started = 1 }
    !started { pre = pre $0 "\n"; next }
    { blk[n] = blk[n] $0 "\n" }
    END {
      op = ENVIRON["OP"]; a = ENVIRON["A"]; b = ENVIRON["B"]
      for (i = 1; i <= n; i++) {
        if (a != "" && !ia && index(blk[i], a)) ia = i
        if (op == "move" && !ib && index(blk[i], b)) ib = i
      }
      printf "%s", pre
      for (i = 1; i <= n; i++) {
        if (op == "drop" && i == ia) continue
        if (op == "move" && i == ia) continue
        printf "%s", blk[i]
        if (op == "move" && i == ib) printf "%s", blk[ia]
        if (op == "insert" && i == ia) printf "%s\n", b
      }
    }
  ' "$COPY" > "$COPY.new"
  mv "$COPY.new" "$COPY"
}

steps_keep() { steps_rewrite keep; }
steps_drop() { steps_rewrite drop "$1"; }
steps_move() { steps_rewrite move "$1" "$2"; }
steps_insert_after() { steps_rewrite insert "$1" "$2"; }

# --- cases ---

# CP-1184 and every row of the table: the file in the tree meets them all.
test_the_tree_file_passes() {
  new_copy tree
  run_check "$COPY"
  [ "$STATUS" -eq 0 ] || { fail "expected exit 0 on a copy of the tree's release.yml, got $STATUS. Its output follows."; show_output; return 1; }
  [ -z "$ERR" ] || { fail "a pass wrote to stderr. Its output follows."; show_output; return 1; }
}

# CP-1185: the control. The same helper that makes every mutation changes nothing here.
test_the_unmodified_copy_passes() {
  new_copy control
  steps_keep
  cmp -s "$COPY" "$TREE_FILE" || { fail "the mutation helper changed the copy with nothing asked of it"; return 1; }
  run_check "$COPY"
  [ "$STATUS" -eq 0 ] || { fail "expected exit 0 on the untouched copy, got $STATUS. Its output follows."; show_output; return 1; }
}

test_a_second_trigger_is_refused() {
  new_copy dispatch
  insert_after "on:" "  workflow_dispatch:"
  copy_is_refused_naming "(CP-1170)" || return 1
  new_copy pull-request
  insert_after "on:" "  pull_request:"
  copy_is_refused_naming "(CP-1170)" || return 1
  new_copy schedule-elsewhere
  insert_after "runs-on: macos-26" "    schedule:"
  copy_is_refused_naming "(CP-1170)" || return 1
}

test_a_floating_runner_is_refused() {
  new_copy latest
  replace_text "macos-26" "macos-latest"
  copy_is_refused_naming "(CP-1171)" || return 1
  new_copy two-runners
  insert_after "runs-on: macos-26" "    runs-on: macos-26"
  copy_is_refused_naming "(CP-1171)" || return 1
  new_copy two-jobs
  insert_after "jobs:" "  other:
    needs: release"
  copy_is_refused_naming "(CP-1171)" || return 1
}

test_a_checkout_that_is_shallow_or_redirected_or_keeps_credentials_is_refused() {
  new_copy shallow
  drop_lines "fetch-depth: 0"
  copy_is_refused_naming "(CP-1172)" || return 1
  new_copy redirected
  insert_after "fetch-depth: 0" "          ref: main"
  copy_is_refused_naming "(CP-1172)" || return 1
  new_copy credentials
  drop_lines "persist-credentials: false"
  copy_is_refused_naming "(CP-1172)" || return 1
  new_copy old-checkout
  replace_text "actions/checkout@v5" "actions/checkout@v4"
  copy_is_refused_naming "(CP-1172)" || return 1
  expect_refused_naming "(CP-1181)" || return 1
}

test_a_gate_that_is_not_first_is_refused() {
  new_copy gate-late
  steps_move "$RUN_GATE" "$RUN_AUDIT"
  copy_is_refused_naming "(CP-1173)" || return 1
  expect_refused_naming "(CP-1174)" || return 1
  new_copy gate-renamed
  replace_text "name: Test gate" "name: Gate"
  copy_is_refused_naming "(CP-1173)" || return 1
  new_copy gate-twice
  steps_insert_after "$RUN_GATE" "      - name: Gate again
        run: checks/gate.sh again"
  copy_is_refused_naming "(CP-1173)" || return 1
  new_copy step-without-run-before-gate
  steps_insert_after "uses: actions/checkout" "      - uses: actions/upload-artifact@v6"
  copy_is_refused_naming "(CP-1173)" || return 1
  new_copy step-before-gate
  steps_insert_after "uses: actions/checkout" "      - name: Early
        run: echo early"
  copy_is_refused_naming "(CP-1173)" || return 1
}

test_the_audit_is_required_and_an_ignore_needs_its_reason() {
  new_copy no-audit
  steps_drop "$RUN_AUDIT"
  copy_is_refused_naming "(CP-1174)" || return 1
  new_copy bare-ignore
  replace_text "run: cargo audit" "run: cargo audit --ignore RUSTSEC-2024-0001"
  copy_is_refused_naming "(CP-1174)" || return 1
  new_copy reasoned-ignore
  replace_text "run: cargo audit" "run: cargo audit --ignore RUSTSEC-2024-0001"
  insert_before "run: cargo audit" "        # RUSTSEC-2024-0001: the advisory names a function this product does not call"
  run_check "$COPY"
  [ "$STATUS" -eq 0 ] || { fail "an ignore with its reason directly above the run line was refused. Its output follows."; show_output; return 1; }
  new_copy install-dropped
  steps_drop "cargo install cargo-audit"
  copy_is_refused_naming "(CP-1174)" || return 1
  new_copy install-after-audit
  steps_move "cargo install cargo-audit" "$RUN_AUDIT"
  copy_is_refused_naming "(CP-1174)" || return 1
  expect_refused_naming "Order" || return 1
}

test_each_release_step_is_required() {
  for pair in "$RUN_VERSION|CP-1175" "$RUN_PACK|CP-1176" "$RUN_SUMS|CP-1177" "$RUN_VERIFY|CP-1178" "$RUN_ABSENT|CP-1180" "$RUN_RELEASE|CP-1179"; do
    needle="${pair%|*}"
    id="${pair#*|}"
    new_copy "without-$id"
    steps_drop "$needle"
    copy_is_refused_naming "($id)" || return 1
  done
}

test_a_misordered_step_is_refused() {
  new_copy verify-late
  steps_move "$RUN_VERIFY" "$RUN_RELEASE"
  copy_is_refused_naming "Order" || return 1
  new_copy pack-first
  steps_move "$RUN_VERSION" "$RUN_PACK"
  copy_is_refused_naming "Order" || return 1
}

test_a_step_outside_the_closed_set_is_refused() {
  new_copy push
  steps_insert_after "$RUN_GATE" "      - name: Push
        run: git push origin HEAD"
  copy_is_refused_naming "(CP-1181)" || return 1
  new_copy second-uses
  steps_insert_after "$RUN_GATE" "      - uses: actions/upload-artifact@v6"
  copy_is_refused_naming "(CP-1181)" || return 1
  new_copy changed-run
  replace_text "run: checks/release-sums.sh dist" "run: checks/release-sums.sh dist extra"
  copy_is_refused_naming "(CP-1181)" || return 1
}

test_a_secret_a_signing_call_or_a_second_permission_is_refused() {
  new_copy secret
  insert_after "run: cargo audit" "        env:
          X: \${{ secrets.X }}"
  copy_is_refused_naming "(CP-1182)" || return 1
  new_copy signing
  steps_insert_after "$RUN_GATE" "      - name: Sign
        run: codesign --force --sign - target/release/bundle/macos/KA-Reader.app"
  copy_is_refused_naming "(CP-1182)" || return 1
  new_copy keychain
  steps_insert_after "$RUN_GATE" "      - name: Import
        run: security import cert.p12 -k build.keychain"
  copy_is_refused_naming "(CP-1182)" || return 1
  new_copy permission
  insert_after "contents: write" "  packages: write"
  copy_is_refused_naming "(CP-1182)" || return 1
  new_copy second-permissions-key
  insert_after "runs-on: macos-26" "    permissions:
      contents: write"
  copy_is_refused_naming "(CP-1182)" || return 1
  new_copy other-expression
  replace_text "name: Version" 'name: Version ${{ github.sha }}'
  copy_is_refused_naming "(CP-1182)" || return 1
  new_copy env-on-pack
  insert_after "$RUN_PACK" "        env:
          LABEL: x"
  copy_is_refused_naming "(CP-1182)" || return 1
}

# CP-1182: env: appears on the existing-Release step and the Release step only. An env: block for
# the whole workflow, or for the job, hands the token to every step, the gate's included.
test_an_env_above_the_steps_is_refused() {
  new_copy workflow-env
  insert_after "  contents: write" "
env:
  GH_TOKEN: \${{ github.token }}"
  copy_is_refused_naming "(CP-1182)" || return 1
  new_copy job-env
  insert_after "runs-on: macos-26" "    env:
      GH_TOKEN: \${{ github.token }}"
  copy_is_refused_naming "(CP-1182)" || return 1
}

test_a_step_that_may_fail_is_refused() {
  new_copy continue
  insert_after "$RUN_GATE" "        continue-on-error: true"
  copy_is_refused_naming "(CP-1183)" || return 1
  new_copy conditional
  insert_after "$RUN_PACK" "        if: always()"
  copy_is_refused_naming "(CP-1183)" || return 1
  new_copy own-shell
  insert_after "$RUN_PACK" "        shell: bash"
  copy_is_refused_naming "(CP-1183)" || return 1
  new_copy no-defaults
  drop_exact "defaults:"
  drop_exact "  run:"
  drop_exact "    shell: bash"
  copy_is_refused_naming "(CP-1183)" || return 1
}

test_a_block_scalar_run_is_refused_under_layout() {
  new_copy block
  replace_text "run: checks/release-sums.sh dist" "run: |
          checks/release-sums.sh dist"
  copy_is_refused_naming "Layout" || return 1
}

# Layout (CP-1184): every run: value is one line. In YAML a more-indented line after a plain value
# continues it, so the gate step below runs "checks/gate.sh && git push origin HEAD", which no
# line of the file holds whole.
test_a_run_line_continued_on_the_next_line_is_refused_under_layout() {
  new_copy continued-gate
  insert_after "$RUN_GATE" "          && git push origin HEAD"
  copy_is_refused_naming "Layout" || return 1
  new_copy continued-release
  insert_after "$RUN_RELEASE" "          dist/extra-asset"
  copy_is_refused_naming "Layout" || return 1
}

# Layout (CP-1184): a file the check cannot read in the layout is refused under that name.
test_a_file_that_is_not_in_the_layout_is_refused_under_layout() {
  new_copy tab
  replace_text "  contents: write" "	contents: write"
  copy_is_refused_naming "Layout" || return 1
  expect_refused_naming "holds a tab" || return 1
  new_copy no-jobs
  replace_text "jobs:" "work:"
  copy_is_refused_naming "Layout" || return 1
  expect_refused_naming "no jobs: key" || return 1
  new_copy no-steps
  sed 's/^      - /    - /' "$COPY" > "$COPY.new"
  mv "$COPY.new" "$COPY"
  copy_is_refused_naming "Layout" || return 1
  expect_refused_naming "no step item" || return 1
}

# The token, the group and the Release's place are held exactly (CP-1179, CP-1180).
test_the_release_steps_hold_their_env_group_and_place() {
  new_copy wider-env
  insert_after "GH_TOKEN:" "          EXTRA: value"
  copy_is_refused_naming "(CP-1180)" || return 1
  new_copy cancelling-group
  replace_text "cancel-in-progress: false" "cancel-in-progress: true"
  copy_is_refused_naming "(CP-1180)" || return 1
  new_copy step-after-release
  steps_insert_after "$RUN_RELEASE" "      - name: After
        run: echo after"
  copy_is_refused_naming "(CP-1179)" || return 1
}

test_two_breaks_in_one_copy_name_both() {
  new_copy two
  replace_text "macos-26" "macos-latest"
  drop_lines "persist-credentials: false"
  run_check "$COPY"
  expect_refused_naming "(CP-1171)" || return 1
  expect_refused_naming "(CP-1172)" || return 1
  [ "$(printf '%s\n' "$ERR" | grep -c 'CP-1171')" -eq 1 ] || { fail "CP-1171 is not on a line of its own"; return 1; }
  [ "$(printf '%s\n' "$ERR" | grep 'CP-1171' | grep -c 'CP-1172')" -eq 0 ] || { fail "both requirements share a line"; return 1; }
}

test_an_unreadable_or_missing_file_is_refused() {
  run_check "$WORK/not-there.yml"
  expect_refused_naming "Layout" || return 1
  [ ! -e "$WORK/not-there.yml" ] || { fail "the check created the file"; return 1; }
}

test_a_wrong_argument_count_exits_2() {
  run_check
  [ "$STATUS" -eq 2 ] || { fail "zero arguments: expected exit 2, got $STATUS"; return 1; }
  case "$ERR" in *sage*) ;; *) fail "zero arguments: no usage line on stderr: $ERR"; return 1 ;; esac
  new_copy counts
  run_check "$COPY" extra
  [ "$STATUS" -eq 2 ] || { fail "two arguments: expected exit 2, got $STATUS"; return 1; }
}

# CP-1186: no suite file exists without its own gate step, and the workflow names the pinned runner.
# checks/tests/test_vm_refusal.sh is unmodified in this change and holds both for every suite and
# workflow; the gate runs it as its own step. It is not run again here, because it takes a minute.
# This case asserts the same promise for the five suites of this change and for release.yml.
test_the_gate_holds_the_new_suite_as_a_fatal_step() {
  commands="$(sed -n "s/^run_step '[^']*' '\(.*\)'\$/\1/p" "$ROOT/checks/gate.sh")"
  for suite in version pack sums absent shape; do
    printf '%s\n' "$commands" | grep -q -x -F "checks/tests/test_release_$suite.sh" \
      || { fail "checks/tests/test_release_$suite.sh is not the entire command of a step in checks/gate.sh"; return 1; }
  done
  printf '%s\n' "$commands" | grep -q -x -F "checks/release-shape.sh .github/workflows/release.yml" \
    || { fail "checks/gate.sh has no step whose whole command is the shape check on release.yml"; return 1; }
  grep -q -x '    runs-on: macos-26' "$TREE_FILE" || { fail "release.yml does not name the macos-26 runner"; return 1; }
}

# --- the runner ---

TMP_BASE="${TMPDIR:-/tmp}"
TMP_BASE="${TMP_BASE%/}"
if ! WORK="$(mktemp -d "$TMP_BASE/release-shape-suite.XXXXXX" 2> /dev/null)"; then
  echo "The suite could not create its temporary directory under $TMP_BASE, so no case ran. Make $TMP_BASE writable, then run the suite again."
  exit 1
fi
cleanup() {
  rm -rf "$WORK"
}
trap cleanup EXIT

ran=0
passed=0
for case_name in $CASES; do
  if [ -n "${KA_READER_TEST_ONLY:-}" ] && [ "$case_name" != "$KA_READER_TEST_ONLY" ]; then
    continue
  fi
  ran=$((ran + 1))
  if result="$("$case_name" 2>&1)"; then
    echo "ok   $case_name"
    passed=$((passed + 1))
  else
    echo "FAIL $case_name"
  fi
  [ -z "$result" ] || echo "$result"
done

echo "$passed of $ran passed"
[ "$ran" -gt 0 ] && [ "$passed" -eq "$ran" ]
