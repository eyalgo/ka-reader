#!/usr/bin/env bash
# Version: 1.0.0 — first version: drives the real checks/structure.sh over copies of the real crates/ with breaches planted
#
# checks/tests/test_structure.sh — the tests of checks/structure.sh.
#
# WHY THIS EXISTS
#   checks/structure.sh is the proof that the Rust source holds the unit and import rules, so a bug in
#   it is a rule nobody is watching. These cases run the real script — never a copy of its rules. The
#   script derives the product root from its own location, so every case copies the real script and
#   a copy of crates/ into a fresh temporary root and plants a breach there by appending: the copy is
#   the one tree a case may write to, and the tree this suite started in is only read.
#   The technique is the one checks/tests/test_view.sh uses, which is the shell packet's technique
#   minus its runner: this product has no Python, so the runner is this file (docs/nfdr.md § 9).
#
# USAGE
#   checks/tests/test_structure.sh
#   NOZOKI_TEST_ONLY=<case> runs one case, and a name no case carries fails the run rather than
#   running nothing.
#   Only crates/ and the script are copied: the script reads nothing else, so a whole-tree copy would
#   carry target/ build output and prove nothing more.
#
# WHY NO `set -e`
#   A case that fails must not end the run before the remaining cases report. Each case returns its
#   own status and the runner counts them.

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd -P)"
STRUCTURE_SH="$ROOT/checks/structure.sh"
CORE_FILE="nozoki-core/src/folder_model.rs"
BRIDGE_FILE="nozoki-bridge/src/session.rs"

STDOUT=""
STDERR=""
STATUS=0
PLANT_LINE=0
R=""
WORK="$(mktemp -d)"
ORIGIN_STATUS_BEFORE="$(git -C "$ROOT" status --porcelain 2>&1)"

CASES="
test_clean_copy_passes
test_case_2_core_unsafe_is_rejected
test_case_4_third_crate_unsafe_is_rejected
test_unsafe_forms_are_rejected
test_near_unsafe_names_pass
test_raw_unsafe_text_is_scanned
test_only_crate_level_exclusions_apply
test_empty_scope_fails
test_unreadable_source_fails
test_all_findings_are_ordered_and_distinct
test_script_location_selects_the_root
test_suite_selects_one_named_case
test_originating_tree_is_unchanged
test_case_1_core_apple_import_is_rejected
test_apple_framework_attribute_is_rejected
test_every_apple_floor_form_is_rejected
test_core_foundation_extern_is_rejected
test_apple_scope_and_near_names
test_apple_member_after_comment_punctuation_is_rejected
test_case_3_core_process_names_both_rules
test_case_6_bridge_process_names_only_qc36
test_process_grouped_imports_use_the_member_line
test_raw_process_text_is_scanned
test_nested_source_paths_are_scanned
test_every_file_reports_in_one_run
test_process_spellings_and_near_names
test_case_5_core_non_owner_filesystem_is_rejected
test_case_7_crate_tests_are_excluded
test_filesystem_grouped_imports_use_the_member_line
test_bridge_non_owner_filesystem_is_rejected
test_inline_test_module_is_scanned
test_every_filesystem_module_and_third_crate_is_checked
test_owner_exemption_is_exact_and_clause_specific
test_libc_filesystem_floor_is_rejected
test_non_filesystem_forms_pass
test_complete_clean_tree_passes
"

# --- helpers ---

fail() {
  echo "  $*"
  return 1
}

# A fresh product root holding a copy of crates/ and the real script, copied now — never a copy kept
# beside this file. Sets R to its path.
new_root() {
  R="$WORK/$1"
  mkdir -p "$R/checks" || return 1
  cp -R "$ROOT/crates" "$R/crates" || return 1
  cp "$STRUCTURE_SH" "$R/checks/structure.sh" || return 1
  chmod +x "$R/checks/structure.sh"
}

# Appends the text $3 as lines of crates/$2 under root $1, creating the file when it is absent, and
# sets PLANT_LINE to the line the text starts on. The line is derived from the file's own line count
# before the append, never assumed.
plant() {
  plant_file="$1/crates/$2"
  mkdir -p "$(dirname "$plant_file")"
  [ -f "$plant_file" ] || : > "$plant_file"
  if [ -s "$plant_file" ] && [ "$(tail -c 1 "$plant_file" | od -An -c | tr -d ' ')" != '\n' ]; then
    printf '\n' >> "$plant_file"
  fi
  lines_before="$(wc -l < "$plant_file" | tr -d ' ')"
  printf '%s\n' "$3" >> "$plant_file"
  PLANT_LINE=$((lines_before + 1))
}

# Runs the copied script in root $1, from directory $2 (default: the root), and reads its streams.
run_structure() {
  (cd "${2:-$1}" && "$1/checks/structure.sh") > "$WORK/stdout" 2> "$WORK/stderr"
  STATUS=$?
  STDOUT="$(cat "$WORK/stdout")"
  STDERR="$(cat "$WORK/stderr")"
}

expect_status() {
  [ "$STATUS" -eq "$1" ] || fail "expected exit $1, got $STATUS. stdout: $STDOUT stderr: $STDERR"
}

expect_stderr_empty() {
  [ -z "$STDERR" ] || fail "expected empty stderr, got: $STDERR"
}

expect_stderr_contains() {
  case "$STDERR" in
    *"$1"*) return 0 ;;
  esac
  fail "expected stderr to contain: $1. stderr: $STDERR stdout: $STDOUT"
}

# A finding line on stderr is `<path>:<line>: <QC-n>: <what>`. $1 is the path from the product root,
# $2 the line, $3 the identifier.
expect_finding() {
  found=0
  while IFS= read -r stderr_line; do
    case "$stderr_line" in
      "$1:$2: $3: "*) found=1 ;;
    esac
  done <<< "$STDERR"
  [ "$found" -eq 1 ] || fail "expected a finding $1:$2: $3 on stderr. stderr: $STDERR"
}

expect_no_finding_for() {
  case "$STDERR" in
    *"$1"*) fail "expected no finding naming $1. stderr: $STDERR" ;;
  esac
}

# How many stderr lines carry exactly the prefix `<path>:<line>: <QC-n>: `.
count_findings() {
  count=0
  while IFS= read -r stderr_line; do
    case "$stderr_line" in
      "$1:$2: $3: "*) count=$((count + 1)) ;;
    esac
  done <<< "$STDERR"
  printf '%s' "$count"
}

# The in-scope file count and crate count of the crates/ under root $1, derived without the script's
# own method: a crate-level tests/ directory and a crate-level build.rs are the only exclusions.
expected_counts() {
  EXPECT_FILES=0
  EXPECT_CRATES=""
  rust_files="$(cd "$1" && find crates -type f -name '*.rs')"
  while IFS= read -r rust_file; do
    [ -n "$rust_file" ] || continue
    inner="${rust_file#crates/}"
    crate="${inner%%/*}"
    within="${inner#*/}"
    case "$within" in
      tests/* | build.rs) continue ;;
    esac
    EXPECT_FILES=$((EXPECT_FILES + 1))
    case " $EXPECT_CRATES " in
      *" $crate "*) ;;
      *) EXPECT_CRATES="$EXPECT_CRATES $crate" ;;
    esac
  done <<< "$rust_files"
  EXPECT_CRATE_COUNT="$(printf '%s\n' $EXPECT_CRATES | grep -c .)"
}

# --- the cases of Task 1: source scope, the unsafe rule and the report ---

test_clean_copy_passes() {
  new_root clean || return 1
  run_structure "$R"
  expect_status 0 || return 1
  expect_stderr_empty || return 1
  lines="$(printf '%s\n' "$STDOUT" | wc -l | tr -d ' ')"
  [ "$lines" -eq 1 ] || fail "expected one stdout line on a pass, got $lines: $STDOUT" || return 1
  expected_counts "$R"
  [ "$EXPECT_FILES" -gt 0 ] || fail "the copied crates/ holds no in-scope file to count" || return 1
  case "$STDOUT" in
    *" $EXPECT_FILES Rust files in $EXPECT_CRATE_COUNT crates "*"nothing found"*) ;;
    *) fail "expected the counts $EXPECT_FILES files and $EXPECT_CRATE_COUNT crates and 'nothing found'. stdout: $STDOUT" || return 1 ;;
  esac
}

test_case_2_core_unsafe_is_rejected() {
  new_root case2 || return 1
  plant "$R" "$CORE_FILE" 'fn f() { unsafe {} }'
  run_structure "$R"
  expect_status 1 || return 1
  expect_finding "crates/$CORE_FILE" "$PLANT_LINE" QC-9
}

# A third crate needs no manifest to be read, and the rule is not the core's alone.
test_case_4_third_crate_unsafe_is_rejected() {
  new_root case4 || return 1
  plant "$R" "nozoki-extra/src/lib.rs" 'fn f() { unsafe {} }'
  [ ! -e "$R/crates/nozoki-extra/Cargo.toml" ] || fail "the planted crate must have no manifest" || return 1
  run_structure "$R"
  expect_status 1 || return 1
  expect_finding "crates/nozoki-extra/src/lib.rs" "$PLANT_LINE" QC-9
}

test_unsafe_forms_are_rejected() {
  new_root unsafe-forms || return 1
  forms_lines=""
  for form in \
    'fn a() { unsafe { x(); } }' \
    'unsafe fn b() {}' \
    'unsafe impl Send for T {}' \
    'unsafe extern "C" { fn h(); }' \
    '#[unsafe(no_mangle)]'; do
    plant "$R" "$CORE_FILE" "$form"
    forms_lines="$forms_lines $PLANT_LINE"
  done
  run_structure "$R"
  expect_status 1 || return 1
  for form_line in $forms_lines; do
    expect_finding "crates/$CORE_FILE" "$form_line" QC-9 || return 1
  done
  # The bridge is where unsafe is allowed: the same forms there are no breach of this rule.
  new_root unsafe-bridge || return 1
  for form in \
    'fn a() { unsafe { x(); } }' \
    'unsafe fn b() {}' \
    'unsafe impl Send for T {}' \
    'unsafe extern "C" { fn h(); }' \
    '#[unsafe(no_mangle)]'; do
    plant "$R" "$BRIDGE_FILE" "$form"
  done
  run_structure "$R"
  expect_status 0 || return 1
  expect_stderr_empty || return 1
}

test_near_unsafe_names_pass() {
  new_root near-unsafe || return 1
  plant "$R" "$CORE_FILE" '// see unsafe_code in Cargo.toml'
  plant "$R" "$CORE_FILE" 'fn g() { let unsafe_code = 1; let my_unsafe = 2; let unsafe2 = 3; let _ = unsafe_code + my_unsafe + unsafe2; }'
  plant "$R" "$CORE_FILE" '#![allow(unsafe_code)]'
  run_structure "$R"
  expect_status 0 || return 1
  expect_stderr_empty || return 1
}

# The token in a comment or a string is a breach at its own line, exactly as it is in code.
test_raw_unsafe_text_is_scanned() {
  new_root raw-unsafe || return 1
  plant "$R" "$CORE_FILE" '// this never uses unsafe'
  comment_line="$PLANT_LINE"
  plant "$R" "$CORE_FILE" 'const NOTE: &str = "unsafe";'
  string_line="$PLANT_LINE"
  plant "$R" "$CORE_FILE" 'fn h() { unsafe {} }'
  code_line="$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  expect_finding "crates/$CORE_FILE" "$comment_line" QC-9 || return 1
  expect_finding "crates/$CORE_FILE" "$string_line" QC-9 || return 1
  expect_finding "crates/$CORE_FILE" "$code_line" QC-9 || return 1
}

# Only a crate's own top-level tests/ and its own build.rs are outside the scan.
test_only_crate_level_exclusions_apply() {
  new_root excluded || return 1
  plant "$R" "nozoki-core/tests/planted.rs" 'fn f() { unsafe {} }'
  plant "$R" "nozoki-core/build.rs" 'fn main() { unsafe {} }'
  plant "$R" "nozoki-extra/tests/planted.rs" 'fn f() { unsafe {} }'
  run_structure "$R"
  expect_status 0 || return 1
  expect_stderr_empty || return 1
  new_root nested || return 1
  nested_files="nozoki-core/src/tests/x.rs nozoki-core/src/build.rs nozoki-core/benches/x.rs nozoki-core/examples/x.rs"
  for nested_file in $nested_files; do
    plant "$R" "$nested_file" 'fn f() { unsafe {} }'
  done
  run_structure "$R"
  expect_status 1 || return 1
  for nested_file in $nested_files; do
    expect_finding "crates/$nested_file" 1 QC-9 || return 1
  done
}

test_empty_scope_fails() {
  new_root no-crates || return 1
  rm -rf "$R/crates"
  run_structure "$R"
  expect_status 1 || return 1
  expect_stderr_contains "no Rust source was read" || return 1
  new_root no-rust || return 1
  find "$R/crates" -type f -name '*.rs' -delete
  run_structure "$R"
  expect_status 1 || return 1
  expect_stderr_contains "no Rust source was read" || return 1
  # Files that exist but are all out of scope read nothing either.
  new_root only-excluded || return 1
  rm -rf "$R"/crates/*/src
  run_structure "$R"
  expect_status 1 || return 1
  expect_stderr_contains "no Rust source was read" || return 1
}

# A file the scan cannot read is a failure naming the file, never a silent skip.
test_unreadable_source_fails() {
  new_root unreadable || return 1
  victim="crates/nozoki-core/src/error.rs"
  chmod 000 "$R/$victim"
  if [ -r "$R/$victim" ]; then
    chmod 644 "$R/$victim"
    fail "this account can read a mode-000 file, so the case cannot make a file unreadable" || return 1
  fi
  run_structure "$R"
  chmod 644 "$R/$victim"
  expect_status 1 || return 1
  expect_stderr_contains "$victim" || return 1
}

test_all_findings_are_ordered_and_distinct() {
  new_root ordered || return 1
  # Files are made in an order unlike their path order, and the lines 2 and 10 sort the other way
  # as text, so only a numeric order passes.
  plant "$R" "nozoki-b/src/lib.rs" 'fn ok() {}'
  plant "$R" "nozoki-b/src/lib.rs" 'fn f() { unsafe {} }'
  b_first="$PLANT_LINE"
  for filler in 3 4 5 6 7 8 9; do
    plant "$R" "nozoki-b/src/lib.rs" "fn filler_$filler() {}"
  done
  plant "$R" "nozoki-b/src/lib.rs" 'fn g() { unsafe {} }'
  b_second="$PLANT_LINE"
  plant "$R" "$CORE_FILE" 'fn c() { unsafe {} }'
  core_line="$PLANT_LINE"
  plant "$R" "nozoki-a/src/lib.rs" 'fn d() { unsafe { unsafe {} } }'
  a_line="$PLANT_LINE"
  # An unreadable file that sorts before every finding must not stop the later ones.
  plant "$R" "nozoki-a/src/aa.rs" 'fn e() {}'
  chmod 000 "$R/crates/nozoki-a/src/aa.rs"
  run_structure "$R"
  chmod 644 "$R/crates/nozoki-a/src/aa.rs"
  expect_status 1 || return 1
  expect_stderr_contains "crates/nozoki-a/src/aa.rs" || return 1
  [ "$b_first" -eq 2 ] && [ "$b_second" -eq 10 ] || fail "the fixture's lines are $b_first and $b_second, not 2 and 10" || return 1
  expected="crates/nozoki-a/src/lib.rs:$a_line
crates/nozoki-b/src/lib.rs:$b_first
crates/nozoki-b/src/lib.rs:$b_second
crates/$CORE_FILE:$core_line"
  actual="$(printf '%s\n' "$STDERR" | grep ': QC-' | cut -d: -f1,2)"
  [ "$actual" = "$expected" ] || fail "findings out of order or not distinct. expected:
$expected
got:
$actual" || return 1
  [ "$(count_findings "crates/nozoki-a/src/lib.rs" "$a_line" QC-9)" -eq 1 ] \
    || fail "two unsafe tokens on one line must give one finding. stderr: $STDERR" || return 1
}

# The root is the parent of the script's own directory, wherever the run starts.
test_script_location_selects_the_root() {
  new_root located || return 1
  plant "$R" "$CORE_FILE" 'fn f() { unsafe {} }'
  # The tree this suite started in is clean, so a run that read it would pass.
  run_structure "$R" "$WORK"
  expect_status 1 || return 1
  expect_finding "crates/$CORE_FILE" "$PLANT_LINE" QC-9 || return 1
  run_structure "$R" "$R/checks"
  expect_status 1 || return 1
  expect_finding "crates/$CORE_FILE" "$PLANT_LINE" QC-9 || return 1
}

# Every case function is registered, so the ordinary run reaches it; and a name the runner does not
# know fails instead of running nothing.
test_suite_selects_one_named_case() {
  one="test_clean_copy_passes"
  selected="$(NOZOKI_TEST_ONLY="$one" "$ROOT/checks/tests/test_structure.sh" 2>&1)"
  selected_status=$?
  [ "$selected_status" -eq 0 ] || fail "the selected case failed (exit $selected_status): $selected" || return 1
  [ "$selected" = "ok   $one" ] || fail "expected exactly 'ok   $one', got: $selected" || return 1
  unknown="$(NOZOKI_TEST_ONLY=no_such_case "$ROOT/checks/tests/test_structure.sh" 2>&1)"
  unknown_status=$?
  [ "$unknown_status" -ne 0 ] || fail "a name no case carries must fail the run, got exit 0: $unknown" || return 1
  for defined in $(declare -F | awk '{print $3}' | grep '^test_'); do
    case " $(echo $CASES) " in
      *" $defined "*) ;;
      *) fail "$defined is defined but not registered in CASES" || return 1 ;;
    esac
  done
  for registered in $CASES; do
    [ "$(type -t "$registered")" = "function" ] || fail "$registered is registered but not defined" || return 1
  done
}

# The suite writes under temporary roots only: the tree it started in prints what it printed before.
test_originating_tree_is_unchanged() {
  status_after="$(git -C "$ROOT" status --porcelain 2>&1)"
  [ "$status_after" = "$ORIGIN_STATUS_BEFORE" ] \
    || fail "git status --porcelain changed during the run. before: $ORIGIN_STATUS_BEFORE after: $status_after" || return 1
}

# --- the cases of Task 2: the Apple-framework boundary ---

# The floor of QC-9's Apple clause: every one of these is refused in nozoki-core in every form below.
APPLE_FLOOR="objc objc2 objc2_foundation objc2_app_kit objc2_core_foundation objc_foundation objc_id block block2 dispatch dispatch2 cocoa cocoa_foundation core_foundation core_foundation_sys core_graphics core_graphics_types core_text core_services security_framework security_framework_sys system_configuration system_configuration_sys fsevent fsevent_sys io_kit_sys metal"

test_case_1_core_apple_import_is_rejected() {
  new_root case1 || return 1
  plant "$R" "$CORE_FILE" 'use objc2::runtime::AnyObject;'
  run_structure "$R"
  expect_status 1 || return 1
  expect_finding "crates/$CORE_FILE" "$PLANT_LINE" QC-9
}

test_apple_framework_attribute_is_rejected() {
  new_root attribute || return 1
  attribute_lines=""
  plant "$R" "$CORE_FILE" '#[link(name = "CoreServices", kind = "framework")]'
  attribute_lines="$attribute_lines $PLANT_LINE"
  plant "$R" "$CORE_FILE" '#[link(name = "A", kind="framework")]'
  attribute_lines="$attribute_lines $PLANT_LINE"
  plant "$R" "$CORE_FILE" '#[link(name = "B", kind   =   "framework")]'
  attribute_lines="$attribute_lines $PLANT_LINE"
  plant "$R" "$CORE_FILE" '#[link(name = "C",
    kind
      =
        "framework")]'
  attribute_lines="$attribute_lines $((PLANT_LINE + 1))"
  run_structure "$R"
  expect_status 1 || return 1
  for attribute_line in $attribute_lines; do
    expect_finding "crates/$CORE_FILE" "$attribute_line" QC-9 || return 1
  done
  # A link kind that is not a framework is no breach.
  new_root attribute-static || return 1
  plant "$R" "$CORE_FILE" '#[link(name = "z", kind = "static")]'
  run_structure "$R"
  expect_status 0 || return 1
  expect_stderr_empty || return 1
}

# Every name of the floor, as a path, an absolute path, an extern crate, a use root and a use member —
# on one line, across lines and nested.
test_every_apple_floor_form_is_rejected() {
  new_root floor || return 1
  expected_lines=""
  for name in $APPLE_FLOOR; do
    plant "$R" "$CORE_FILE" "fn path_$name() { $name::go(); }
fn absolute_$name() { ::$name::go(); }
extern crate $name;
use $name::item;
use $name;
use std::{io, $name};
use some::{
    first,
    $name,
};
use ::{a::{b, $name::c}};
fn spaced_$name() { $name :: go(); }
fn broken_$name() { $name
    ::
    go(); }"
    for offset in 0 1 2 3 4 5 8 10 11 12; do
      expected_lines="$expected_lines $((PLANT_LINE + offset)):$name"
    done
  done
  run_structure "$R"
  expect_status 1 || return 1
  for expected in $expected_lines; do
    expect_finding "crates/$CORE_FILE" "${expected%%:*}" QC-9 || fail "name ${expected#*:} at line ${expected%%:*} not refused" || return 1
  done
}

test_core_foundation_extern_is_rejected() {
  new_root extern-crate || return 1
  plant "$R" "$CORE_FILE" 'extern crate core_foundation;'
  run_structure "$R"
  expect_status 1 || return 1
  expect_finding "crates/$CORE_FILE" "$PLANT_LINE" QC-9
}

# The clause is the core's alone and names whole identifiers; a core comment or string that names a
# forbidden form is a breach like the rest of its text.
test_apple_scope_and_near_names() {
  new_root apple-elsewhere || return 1
  plant "$R" "$BRIDGE_FILE" 'use objc2::runtime::AnyObject;'
  plant "$R" "$BRIDGE_FILE" 'extern crate core_foundation;'
  plant "$R" "nozoki-extra/src/lib.rs" 'use block2::RcBlock;'
  plant "$R" "nozoki-extra/src/lib.rs" '#[link(name = "CoreServices", kind = "framework")]'
  run_structure "$R"
  expect_status 0 || return 1
  expect_stderr_empty || return 1
  new_root apple-near || return 1
  plant "$R" "$CORE_FILE" 'fn blocker() { let dispatcher = 1; let metallic = dispatcher; let _ = metallic; }'
  plant "$R" "$CORE_FILE" 'use my_objc2::thing; use objc22::thing; use metal_gear::thing; use cocoa_beans::thing;'
  plant "$R" "$CORE_FILE" 'fn h() { crate::dispatch::run(); self::block::run(); queue.block::<u8>(); }'
  plant "$R" "$CORE_FILE" 'mod dispatch { pub fn run() {} }'
  run_structure "$R"
  expect_status 0 || return 1
  expect_stderr_empty || return 1
  new_root apple-raw || return 1
  plant "$R" "$CORE_FILE" '// bridges objc2::runtime::AnyObject to the shell'
  comment_line="$PLANT_LINE"
  plant "$R" "$CORE_FILE" 'const NOTE: &str = "core_foundation::base::CFRelease";'
  string_line="$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  expect_finding "crates/$CORE_FILE" "$comment_line" QC-9 || return 1
  expect_finding "crates/$CORE_FILE" "$string_line" QC-9 || return 1
}

# A comment inside a grouped import may hold `}` and `;`. They are text, not structure: the real member
# after them still ends in the clause's breach, and the comment's own text stays scanned.
test_apple_member_after_comment_punctuation_is_rejected() {
  new_root apple-comment-punctuation || return 1
  plant "$R" "$CORE_FILE" 'use some::{
    first, // a stray } and ; end nothing
    /* so does this } ; one */ objc2,
    last,
};'
  member_line=$((PLANT_LINE + 2))
  run_structure "$R"
  expect_status 1 || return 1
  expect_finding "crates/$CORE_FILE" "$member_line" QC-9
}

# --- the cases of Task 3: the process-module boundary ---

# How many stderr lines of a run carry the identifier $1 anywhere.
count_identifier() {
  printf '%s\n' "$STDERR" | grep -c ": $1: "
}

test_case_3_core_process_names_both_rules() {
  new_root case3 || return 1
  plant "$R" "$CORE_FILE" 'use std::process::Command;'
  run_structure "$R"
  expect_status 1 || return 1
  expect_finding "crates/$CORE_FILE" "$PLANT_LINE" QC-9 || return 1
  expect_finding "crates/$CORE_FILE" "$PLANT_LINE" QC-36 || return 1
  [ "$(printf '%s\n' "$STDERR" | grep -c ': QC-')" -eq 2 ] \
    || fail "expected exactly the QC-9 and QC-36 lines. stderr: $STDERR" || return 1
}

test_case_6_bridge_process_names_only_qc36() {
  new_root case6 || return 1
  plant "$R" "$BRIDGE_FILE" 'fn run() { std::process::Command::new("git").spawn(); }'
  run_structure "$R"
  expect_status 1 || return 1
  expect_finding "crates/$BRIDGE_FILE" "$PLANT_LINE" QC-36 || return 1
  [ "$(count_identifier QC-9)" -eq 0 ] || fail "the bridge's process text is no QC-9 breach. stderr: $STDERR" || return 1
}

# A member of a grouped import is reported at the member's own line, however the tree is laid out.
test_process_grouped_imports_use_the_member_line() {
  new_root grouped-process || return 1
  member_lines=""
  plant "$R" "$BRIDGE_FILE" 'use std::{io, process};'
  member_lines="$member_lines $PLANT_LINE"
  plant "$R" "$BRIDGE_FILE" 'use std::{
    io,
    process,
};'
  member_lines="$member_lines $((PLANT_LINE + 2))"
  plant "$R" "$BRIDGE_FILE" 'use std::{
    io,
    process::{
        self,
        Command,
    },
};'
  member_lines="$member_lines $((PLANT_LINE + 2))"
  plant "$R" "$BRIDGE_FILE" 'use ::std::{io, process};'
  member_lines="$member_lines $PLANT_LINE"
  plant "$R" "$BRIDGE_FILE" 'use ::std::{
    fmt,
    process,
};'
  member_lines="$member_lines $((PLANT_LINE + 2))"
  run_structure "$R"
  expect_status 1 || return 1
  for member_line in $member_lines; do
    expect_finding "crates/$BRIDGE_FILE" "$member_line" QC-36 || return 1
  done
  # Only the member lines are findings: the lines around them name nothing.
  [ "$(count_identifier QC-36)" -eq 5 ] || fail "expected one finding per import, 5 in all. stderr: $STDERR" || return 1
}

test_raw_process_text_is_scanned() {
  new_root raw-process || return 1
  plant "$R" "nozoki-core/src/lib.rs" '/// never calls std::process'
  doc_line="$PLANT_LINE"
  plant "$R" "nozoki-core/src/lib.rs" 'const NOTE: &str = "std::process";'
  string_line="$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  for text_line in "$doc_line" "$string_line"; do
    expect_finding "crates/nozoki-core/src/lib.rs" "$text_line" QC-9 || return 1
    expect_finding "crates/nozoki-core/src/lib.rs" "$text_line" QC-36 || return 1
  done
}

# src/tests/ and src/build.rs are in scope, so the rule reaches them.
test_nested_source_paths_are_scanned() {
  new_root nested-process || return 1
  for nested_file in nozoki-core/src/tests/x.rs nozoki-core/src/build.rs; do
    plant "$R" "$nested_file" 'use std::process::Command;'
  done
  run_structure "$R"
  expect_status 1 || return 1
  for nested_file in nozoki-core/src/tests/x.rs nozoki-core/src/build.rs; do
    expect_finding "crates/$nested_file" 1 QC-36 || return 1
    expect_finding "crates/$nested_file" 1 QC-9 || return 1
  done
}

test_every_file_reports_in_one_run() {
  new_root every-file || return 1
  plant "$R" "$CORE_FILE" 'fn f() { unsafe {} }'
  unsafe_line="$PLANT_LINE"
  plant "$R" "$BRIDGE_FILE" 'use std::process::Command;'
  process_line="$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  expect_finding "crates/$CORE_FILE" "$unsafe_line" QC-9 || return 1
  expect_finding "crates/$BRIDGE_FILE" "$process_line" QC-36 || return 1
}

# Whitespace and newlines around the separators change no meaning; comment punctuation inside a
# grouped import hides nothing; a near name names no module.
test_process_spellings_and_near_names() {
  new_root process-spellings || return 1
  spelled_lines=""
  plant "$R" "$BRIDGE_FILE" 'fn a() { std :: process :: exit(0); }'
  spelled_lines="$spelled_lines $PLANT_LINE"
  plant "$R" "$BRIDGE_FILE" 'fn b() { std
    ::
    process::exit(0); }'
  spelled_lines="$spelled_lines $((PLANT_LINE + 2))"
  plant "$R" "$BRIDGE_FILE" 'use std::{
    io, // a stray } and ; end nothing
    /* nor does this } ; one */ process,
};'
  spelled_lines="$spelled_lines $((PLANT_LINE + 2))"
  run_structure "$R"
  expect_status 1 || return 1
  for spelled_line in $spelled_lines; do
    expect_finding "crates/$BRIDGE_FILE" "$spelled_line" QC-36 || return 1
  done
  new_root process-near || return 1
  plant "$R" "$BRIDGE_FILE" 'use std::process_info;'
  plant "$R" "$BRIDGE_FILE" 'fn c() { mystd::process::exit(0); crate::process::run(); let process = 1; let _ = process; }'
  plant "$R" "$BRIDGE_FILE" 'use some::{first, process};'
  plant "$R" "$BRIDGE_FILE" 'fn std_process() {}'
  run_structure "$R"
  expect_status 0 || return 1
  expect_stderr_empty || return 1
}

# --- the cases of Task 4: filesystem ownership and the complete suite ---

# The libc calls QC-15 refuses outside an owner. fd-generic read, write and close are not among them:
# by name they cannot be told from socket or pipe I/O.
LIBC_FILE_CALLS="open openat creat fopen fdopen freopen opendir fdopendir readdir stat lstat fstat fstatat access faccessat mkdir mkdirat rmdir unlink unlinkat rename renameat truncate ftruncate readlink readlinkat symlink link chmod fchmod chown realpath"

CORE_OWNER="nozoki-core/src/fs_reader.rs"
BRIDGE_OWNER="nozoki-bridge/src/log_writer.rs"

test_case_5_core_non_owner_filesystem_is_rejected() {
  new_root case5 || return 1
  plant "$R" "$CORE_FILE" 'fn f() { let _ = std::fs::read("x"); }'
  run_structure "$R"
  expect_status 1 || return 1
  expect_finding "crates/$CORE_FILE" "$PLANT_LINE" QC-15
}

# Cases 1, 2, 3 and 5 together, where the scan does not look.
test_case_7_crate_tests_are_excluded() {
  new_root case7 || return 1
  plant "$R" "nozoki-core/tests/planted.rs" 'use objc2::runtime::AnyObject;
fn f() { unsafe {} }
use std::process::Command;
fn g() { let _ = std::fs::read("x"); }'
  run_structure "$R"
  expect_status 0 || return 1
  expect_stderr_empty || return 1
}

test_filesystem_grouped_imports_use_the_member_line() {
  new_root grouped-fs || return 1
  member_lines=""
  plant "$R" "$CORE_FILE" 'use std::{fs, io};'
  member_lines="$member_lines $PLANT_LINE"
  plant "$R" "$CORE_FILE" 'use std::{
    io,
    fs,
};'
  member_lines="$member_lines $((PLANT_LINE + 2))"
  plant "$R" "$CORE_FILE" 'use std::{io::{self, Read}, fs::{self, File}};'
  member_lines="$member_lines $PLANT_LINE"
  plant "$R" "$CORE_FILE" 'use std::{
    io::{
        self,
        Read,
    },
    fs::{
        self,
        File,
    },
};'
  member_lines="$member_lines $((PLANT_LINE + 5))"
  plant "$R" "$CORE_FILE" 'use ::std::{io, fs};'
  member_lines="$member_lines $PLANT_LINE"
  plant "$R" "$CORE_FILE" 'use rustix::{fd, fs};'
  member_lines="$member_lines $PLANT_LINE"
  plant "$R" "$CORE_FILE" 'use rustix::{
    fd,
    fs,
};'
  member_lines="$member_lines $((PLANT_LINE + 2))"
  plant "$R" "$CORE_FILE" 'use std::{
    io, // a stray } and ; end nothing
    /* nor does this } ; one */ fs,
};'
  member_lines="$member_lines $((PLANT_LINE + 2))"
  run_structure "$R"
  expect_status 1 || return 1
  for member_line in $member_lines; do
    expect_finding "crates/$CORE_FILE" "$member_line" QC-15 || return 1
  done
  [ "$(count_identifier QC-15)" -eq 8 ] || fail "expected one finding per import, 8 in all. stderr: $STDERR" || return 1
}

# The bridge's one owner is log_writer.rs, so every other bridge file owns no filesystem primitive.
test_bridge_non_owner_filesystem_is_rejected() {
  new_root bridge-fs || return 1
  plant "$R" "$BRIDGE_FILE" 'fn f() { let _ = std::fs::read("x"); }'
  run_structure "$R"
  expect_status 1 || return 1
  expect_finding "crates/$BRIDGE_FILE" "$PLANT_LINE" QC-15
}

# A #[cfg(test)] module in src/ is read like the rest of its file.
test_inline_test_module_is_scanned() {
  new_root inline-tests || return 1
  plant "$R" "$CORE_FILE" '#[cfg(test)]
mod tests {
    #[test]
    fn writes() { let _ = std::fs::write("x", "y"); }
}'
  run_structure "$R"
  expect_status 1 || return 1
  expect_finding "crates/$CORE_FILE" "$((PLANT_LINE + 3))" QC-15
}

test_every_filesystem_module_and_third_crate_is_checked() {
  new_root fs-modules || return 1
  module_lines=""
  for module in 'std::fs' 'std::os::unix::fs' 'std::os::macos::fs' 'std::os::linux::fs' 'rustix::fs' 'std :: fs' 'std::os::unix :: fs'; do
    plant "$R" "$CORE_FILE" "fn f() { let _ = $module::read; }"
    module_lines="$module_lines $PLANT_LINE"
  done
  plant "$R" "$CORE_FILE" 'fn g() { std
    ::
    fs::read("x"); }'
  module_lines="$module_lines $((PLANT_LINE + 2))"
  run_structure "$R"
  expect_status 1 || return 1
  for module_line in $module_lines; do
    expect_finding "crates/$CORE_FILE" "$module_line" QC-15 || return 1
  done
  new_root third-crate-fs || return 1
  plant "$R" "nozoki-extra/src/lib.rs" 'fn f() { let _ = std::fs::read("x"); }'
  run_structure "$R"
  expect_status 1 || return 1
  expect_finding "crates/nozoki-extra/src/lib.rs" "$PLANT_LINE" QC-15
}

# Exactly two files are exempt, only from QC-15: the same basenames anywhere else are not, and the
# other rules still apply inside an owner.
test_owner_exemption_is_exact_and_clause_specific() {
  new_root owners || return 1
  plant "$R" "$CORE_OWNER" 'fn f() { let _ = std::fs::write("x", "y"); let _ = std::os::unix::fs::symlink("a", "b"); let _ = rustix::fs::stat("x"); let _ = libc::open; }'
  plant "$R" "$BRIDGE_OWNER" 'fn f() { let _ = std::fs::write("x", "y"); let _ = libc::unlink; }'
  run_structure "$R"
  expect_status 0 || return 1
  expect_stderr_empty || return 1
  new_root owners-elsewhere || return 1
  elsewhere="nozoki-core/src/sub/fs_reader.rs nozoki-bridge/src/fs_reader.rs nozoki-core/src/log_writer.rs nozoki-bridge/src/sub/log_writer.rs nozoki-extra/src/fs_reader.rs nozoki-extra/src/log_writer.rs"
  for elsewhere_file in $elsewhere; do
    plant "$R" "$elsewhere_file" 'fn f() { let _ = std::fs::write("x", "y"); }'
  done
  run_structure "$R"
  expect_status 1 || return 1
  for elsewhere_file in $elsewhere; do
    expect_finding "crates/$elsewhere_file" 1 QC-15 || return 1
  done
  new_root owners-other-rules || return 1
  plant "$R" "$CORE_OWNER" 'fn f() { unsafe {} }'
  core_unsafe_line="$PLANT_LINE"
  plant "$R" "$CORE_OWNER" 'use std::process::Command;'
  core_process_line="$PLANT_LINE"
  plant "$R" "$CORE_OWNER" 'use objc2::runtime::AnyObject;'
  core_apple_line="$PLANT_LINE"
  plant "$R" "$BRIDGE_OWNER" 'use std::process::Command;'
  bridge_process_line="$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  expect_finding "crates/$CORE_OWNER" "$core_unsafe_line" QC-9 || return 1
  expect_finding "crates/$CORE_OWNER" "$core_process_line" QC-36 || return 1
  expect_finding "crates/$CORE_OWNER" "$core_apple_line" QC-9 || return 1
  expect_finding "crates/$BRIDGE_OWNER" "$bridge_process_line" QC-36 || return 1
  [ "$(count_identifier QC-15)" -eq 0 ] || fail "an owner is exempt from QC-15 and nothing else. stderr: $STDERR" || return 1
}

# Every refused libc call, as a path, an absolute path and a use member, outside the owners.
test_libc_filesystem_floor_is_rejected() {
  new_root libc-floor || return 1
  expected_lines=""
  for call in $LIBC_FILE_CALLS; do
    plant "$R" "$CORE_FILE" "fn path_$call() { libc::$call(); }
fn absolute_$call() { ::libc::$call(); }
use libc::$call;
use libc::{c_char, $call};
use libc::{
    c_int,
    $call,
};
fn spaced_$call() { libc :: $call(); }"
    for offset in 0 1 2 3 6 7; do
      expected_lines="$expected_lines $((PLANT_LINE + offset))"
    done
  done
  run_structure "$R"
  expect_status 1 || return 1
  for expected_line in $expected_lines; do
    expect_finding "crates/$CORE_FILE" "$expected_line" QC-15 || fail "libc call at line $expected_line not refused" || return 1
  done
  new_root libc-open || return 1
  plant "$R" "$CORE_FILE" 'fn f() { let _ = unsafe_free(libc::open("x", 0)); }'
  run_structure "$R"
  expect_status 1 || return 1
  expect_finding "crates/$CORE_FILE" "$PLANT_LINE" QC-15
}

# What the rule leaves alone, so that it is read as no coverage of it: compile-time inclusions, the
# bridge's password-database calls, fd-generic libc calls, Path methods and near names.
test_non_filesystem_forms_pass() {
  new_root non-fs || return 1
  plant "$R" "$CORE_FILE" 'const A: &str = include_str!("a.txt"); const B: &[u8] = include_bytes!("b.bin");'
  plant "$R" "$BRIDGE_FILE" 'fn f() { let mut p: libc::passwd = zeroed(); libc::getpwuid_r(libc::getuid(), &mut p, buf, n, out); let _ = libc::ERANGE; let _: *const libc::c_char; }'
  plant "$R" "$BRIDGE_FILE" 'fn g() { libc::read(fd, b, n); libc::write(fd, b, n); libc::close(fd); }'
  plant "$R" "$BRIDGE_FILE" 'use libc::{read, write, close, c_char, getpwuid_r};'
  plant "$R" "$CORE_FILE" 'fn h(path: &std::path::Path) -> bool { path.exists() || path.metadata().is_ok() || path.read_dir().is_ok() }'
  plant "$R" "$CORE_FILE" 'use std::path::Path; use std::{io, path::PathBuf};'
  plant "$R" "$CORE_FILE" 'use fs_extra::dir; use std::fsx; use mystd::fs::read; use crate::fs::read; use some::{first, fs};'
  plant "$R" "$CORE_FILE" 'fn i() { let fs = 1; let _ = fs + 1; libc::openx(); libc::stat_t(); mylibc::open(); rustix::fsx::read(); crate::libc::open(); }'
  run_structure "$R"
  expect_status 0 || return 1
  expect_stderr_empty || return 1
}

# S1 over the whole checker: the copy holds every form the clean tree is said to hold, and passes.
test_complete_clean_tree_passes() {
  new_root complete-clean || return 1
  grep -q 'unsafe' "$R"/crates/nozoki-bridge/src/*.rs || fail "the copy no longer holds the bridge's unsafe" || return 1
  grep -q 'std::fs' "$R/crates/$CORE_OWNER" || fail "the copy no longer holds the core owner's filesystem module" || return 1
  grep -q 'std::fs' "$R/crates/$BRIDGE_OWNER" || fail "the copy no longer holds the bridge owner's filesystem module" || return 1
  grep -q 'include_str!' "$R/crates/nozoki-core/src/highlighter.rs" || fail "the copy no longer holds highlighter.rs's include_str!" || return 1
  grep -q 'libc::getpwuid_r' "$R/crates/nozoki-bridge/src/log_install.rs" || fail "the copy no longer holds log_install.rs's getpwuid_r" || return 1
  [ -d "$R/crates/nozoki-core/tests" ] || fail "the copy no longer holds the excluded tests/ files" || return 1
  run_structure "$R"
  expect_status 0 || return 1
  expect_stderr_empty || return 1
  lines="$(printf '%s\n' "$STDOUT" | wc -l | tr -d ' ')"
  [ "$lines" -eq 1 ] || fail "expected one stdout line on a pass, got $lines: $STDOUT" || return 1
  expected_counts "$R"
  case "$STDOUT" in
    *" $EXPECT_FILES Rust files in $EXPECT_CRATE_COUNT crates "*"nothing found"*) ;;
    *) fail "expected the counts $EXPECT_FILES files and $EXPECT_CRATE_COUNT crates and 'nothing found'. stdout: $STDOUT" || return 1 ;;
  esac
}

# --- runner ---

cleanup() {
  chmod -R u+rwx "$WORK" 2> /dev/null
  rm -rf "$WORK"
}
trap cleanup EXIT

failed=0
ran=0
for case_name in $CASES; do
  if [ -n "${NOZOKI_TEST_ONLY:-}" ] && [ "$case_name" != "$NOZOKI_TEST_ONLY" ]; then
    continue
  fi
  ran=$((ran + 1))
  if result="$("$case_name" 2>&1)"; then
    echo "ok   $case_name"
  else
    echo "FAIL $case_name"
    [ -z "$result" ] || echo "$result"
    failed=$((failed + 1))
  fi
done

if [ "$ran" -eq 0 ]; then
  echo "test_structure.sh: no case is named ${NOZOKI_TEST_ONLY:-<none>}" >&2
  exit 1
fi

if [ "$failed" -ne 0 ]; then
  echo "test_structure.sh: $failed case(s) failed" >&2
  exit 1
fi
