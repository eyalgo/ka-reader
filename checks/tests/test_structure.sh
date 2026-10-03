#!/usr/bin/env bash
# Version: 1.1.0 — fs_reader owns OpenFailure; structure.sh holds QC-11's fs-reader clause
# Version: 1.0.0 — first version: drives the real checks/structure.sh over copies of the real crates/ with breaches planted
#
# checks/tests/test_structure.sh — the tests of checks/structure.sh.
#
# WHY THIS EXISTS
#   checks/structure.sh is the proof that the Rust source holds the unit and import rules, so a
#   bug in it is a rule nobody is watching. These cases run the real script — never a copy of its
#   rules. The script derives the product root from its own location, so every case copies the
#   real script and a copy of crates/ into a fresh temporary root and plants a breach there by
#   appending: the copy is the one tree a case may write to, and the tree this suite started in
#   is only read. The technique is the one checks/tests/test_view.sh uses, which is the shell
#   packet's technique minus its runner: this product has no Python, so the runner is this file
#   (docs/nfdr.md § 9).
#
# WHAT IT ASSERTS
#   The identifiers on the findings the cases expect: QC-2, QC-9, QC-10, QC-11, QC-13, QC-14,
#   QC-15, QC-17, QC-30, QC-36, QC-58 and QC-61, and layer-5, the placement rule that has no QC
#   number. Every identifier a case asserts is named in this block.
#
# USAGE
#   checks/tests/test_structure.sh
#   NOZOKI_TEST_ONLY=<case> runs one case, and a name no case carries fails the run rather than
#   running nothing.
#   Only crates/, checks/deps.allow and the script are copied: the script reads nothing else, so a
#   whole-tree copy would carry target/ build output and prove nothing more.
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
test_raw_grouped_imports_are_scanned
test_distinct_clauses_on_one_line_are_reported
test_suite_checks_origin_after_selected_case
test_listed_bridge_crates_pass
test_folder_model_libgit2_binding_is_rejected
test_folder_model_own_state_is_rejected
test_highlighter_forbidden_units_are_rejected
test_fs_reader_forbidden_units_are_rejected
test_root_reexport_reaches_the_unit
test_fs_reader_imports_folder_model_is_rejected
test_bridge_unlisted_crate_by_use_is_rejected
test_bridge_unlisted_crate_as_path_root_is_rejected
test_bridge_apple_binding_is_rejected
test_manifest_depends_on_checks_by_name
test_manifest_dependency_path_under_checks
test_manifest_lib_path_under_checks
test_set_logger_outside_the_bridge_is_rejected
test_set_boxed_logger_outside_the_bridge_is_rejected
test_required_inputs_are_read
test_allowed_unit_edges_pass
test_test_targets_into_checks_pass
test_core_write_api_is_rejected
test_write_api_members_are_rejected
test_read_only_and_non_write_forms_pass
test_env_reads_are_rejected
test_env_near_names_pass
test_config_reads_are_rejected
test_config_near_names_pass
test_sockets_are_rejected
test_socket_near_names_pass
test_boundary_members_in_comments_and_strings_are_rejected
test_bin_exe_under_tests_is_rejected
test_bin_exe_outside_tests_passes
test_boundary_breaches_under_tests_pass
test_unreadable_test_file_fails
test_new_findings_join_one_report
test_build_script_reads_stay_excluded
test_test_only_crate_does_not_change_shipped_counts
"

# --- helpers ---

fail() {
  echo "  $*"
  return 1
}

# A fresh product root holding a copy of crates/ (the two manifests included), checks/deps.allow
# and the real script, copied now — never a copy kept beside this file. Sets R to its path.
new_root() {
  R="$WORK/$1"
  mkdir -p "$R/checks" || return 1
  cp -R "$ROOT/crates" "$R/crates" || return 1
  cp "$ROOT/checks/deps.allow" "$R/checks/deps.allow" || return 1
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
  find "$R"/crates/*/tests -type f -name '*.rs' | grep -q . || fail "the only-excluded root holds no Rust test file, so the case would pass for want of one" || return 1
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

# The floor of QC-9's Apple clause: every one of these is refused in nozoki-core in every form
# below.
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

# Every name of the floor, as a path, an absolute path, an extern crate, a use root and a use
# member — on one line, across lines and nested.
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
  objc_line="$PLANT_LINE"
  plant "$R" "$BRIDGE_FILE" 'extern crate core_foundation;'
  foundation_line="$PLANT_LINE"
  plant "$R" "nozoki-extra/src/lib.rs" 'use block2::RcBlock;'
  plant "$R" "nozoki-extra/src/lib.rs" '#[link(name = "CoreServices", kind = "framework")]'
  run_structure "$R"
  # QC-13 refuses an Apple name in the bridge. What this case still proves is that it is no QC-9
  # finding, and that a third crate raises nothing.
  expect_status 1 || return 1
  expect_finding "crates/$BRIDGE_FILE" "$objc_line" QC-13 || return 1
  expect_finding "crates/$BRIDGE_FILE" "$foundation_line" QC-13 || return 1
  expect_no_finding_for ": QC-9: " || return 1
  expect_no_finding_for "nozoki-extra" || return 1
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

# A comment inside a grouped import may hold `}` and `;`. They are text, not structure: the real
# member after them still ends in the clause's breach, and the comment's own text stays scanned.
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
  mystd_line="$PLANT_LINE"
  plant "$R" "$BRIDGE_FILE" 'use some::{first, process};'
  some_line="$PLANT_LINE"
  plant "$R" "$BRIDGE_FILE" 'fn std_process() {}'
  run_structure "$R"
  # QC-13 refuses the two unlisted crates. What this case still proves is that no near-name of
  # std::process is a QC-36 finding: the two QC-13 lines are all that is reported.
  expect_status 1 || return 1
  expect_finding_naming "crates/$BRIDGE_FILE" "$mystd_line" QC-13 "mystd" || return 1
  expect_finding_naming "crates/$BRIDGE_FILE" "$some_line" QC-13 "some" || return 1
  [ "$(printf '%s\n' "$STDERR" | grep -c .)" -eq 2 ] || fail "expected exactly the two QC-13 lines: $STDERR" || return 1
  expect_no_finding_for ": QC-36: " || return 1
}

# --- the cases of Task 4: filesystem ownership and the complete suite ---

# The libc calls QC-15 refuses outside an owner. fd-generic read, write and close are not among
# them: by name they cannot be told from socket or pipe I/O.
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
  core_owner_line="$PLANT_LINE"
  plant "$R" "$BRIDGE_OWNER" 'fn f() { let _ = std::fs::write("x", "y"); let _ = libc::unlink; }'
  run_structure "$R"
  # QC-2 binds nozoki-core with no exemption, so the core owner's write is one QC-2 finding. The
  # owner exemption is QC-15's alone: no QC-15 there, and the bridge owner (outside QC-2) is clean.
  expect_status 1 || return 1
  expect_count "crates/$CORE_OWNER" "$core_owner_line" QC-2 1 || return 1
  expect_count "crates/$CORE_OWNER" "$core_owner_line" QC-15 0 || return 1
  [ "$(stderr_lines_with "crates/$BRIDGE_OWNER:")" -eq 0 ] || fail "the bridge owner is outside QC-2 and exempt from QC-15: $STDERR" || return 1
  [ "$(printf '%s\n' "$STDERR" | grep -c .)" -eq 1 ] || fail "expected the one QC-2 finding and nothing else: $STDERR" || return 1
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
    for offset in 0 1 2 3 6 8; do
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
  grep -q '\.read(true)' "$R/crates/$CORE_OWNER" || fail "the copy no longer holds the core owner's read-only open" || return 1
  grep -q 'std::env::current_exe' "$R/crates/nozoki-bridge/src/log_install.rs" || fail "the copy no longer holds log_install.rs's current_exe" || return 1
  grep -q 'std::env::temp_dir' "$R/crates/$BRIDGE_OWNER" || fail "the copy no longer holds log_writer.rs's temp_dir" || return 1
  find "$R"/crates/*/tests -type f -name '*.rs' | grep -q . || fail "the copy holds no Rust test file under crates/*/tests/" || return 1
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

# CP-385 applies the grouped-use domains in CP-387/389/390 to comments and strings too.
test_raw_grouped_imports_are_scanned() {
  new_root raw-grouped || return 1
  plant "$R" "$CORE_FILE" '// use std::{process};
/* use std::{fs}; */
const APPLE: &str = "use some::{objc2};";
const FILE_CALL: &str = r#"use libc::{open};"#;
/* use std::{
    process,
}; */
const FILES: &str = r#"use std::{
    fs,
};"#;'
  first_line="$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  for offset in 0 5; do
    expect_finding "crates/$CORE_FILE" "$((first_line + offset))" QC-9 || return 1
    expect_finding "crates/$CORE_FILE" "$((first_line + offset))" QC-36 || return 1
  done
  for offset in 1 3 8; do
    expect_finding "crates/$CORE_FILE" "$((first_line + offset))" QC-15 || return 1
  done
  expect_finding "crates/$CORE_FILE" "$((first_line + 2))" QC-9 || return 1
}

# Design A reports each clause once per file/line, even when clauses share QC-9.
test_distinct_clauses_on_one_line_are_reported() {
  new_root distinct-clauses || return 1
  plant "$R" "$CORE_FILE" 'use objc2::runtime; fn f() { unsafe {} unsafe {} std::process::exit(0); std::fs::read("x"); }'
  run_structure "$R"
  expect_status 1 || return 1
  [ "$(count_findings "crates/$CORE_FILE" "$PLANT_LINE" QC-9)" -eq 3 ] \
    || fail "expected Apple, unsafe and process QC-9 clauses separately: $STDERR" || return 1
  [ "$(count_findings "crates/$CORE_FILE" "$PLANT_LINE" QC-36)" -eq 1 ] \
    || fail "expected one process QC-36 clause: $STDERR" || return 1
  [ "$(count_findings "crates/$CORE_FILE" "$PLANT_LINE" QC-15)" -eq 1 ] \
    || fail "expected one filesystem QC-15 clause: $STDERR" || return 1
  expect_stderr_contains 'Apple framework' || return 1
  expect_stderr_contains '`unsafe`' || return 1
  expect_stderr_contains 'std::process named in nozoki-core' || return 1
}

# CP-393 and design B require the status comparison after the last case, including selection.
# The negative control dirties only a disposable origin, never this suite's real origin.
test_suite_checks_origin_after_selected_case() {
  new_root origin-control || return 1
  mkdir -p "$R/checks/tests" || return 1
  cp "$ROOT/checks/tests/test_structure.sh" "$R/checks/tests/test_structure.sh" || return 1
  git -C "$R" init -q || return 1
  printf '\ntouch %q\n' "$R/unexpected" >> "$R/checks/structure.sh"
  selected="$(NOZOKI_TEST_ONLY=test_clean_copy_passes "$R/checks/tests/test_structure.sh" 2>&1)"
  selected_status=$?
  [ "$selected_status" -ne 0 ] || fail "suite passed after the selected case dirtied its origin: $selected" || return 1
  case "$selected" in
    *'FAIL test_originating_tree_is_unchanged'*) ;;
    *) fail "origin change was not named: $selected" || return 1 ;;
  esac
}

# CP-430 row 16: the bridge may name every crate checks/deps.allow lists, a hyphenated name read
# with `_`, and the list is read on every run. The first three assertions prove the copy carries the
# inputs the unit-graph scan requires, so a missing copied list fails here instead of being
# created by the append below.
test_listed_bridge_crates_pass() {
  new_root listed-crates || return 1
  for required in checks/deps.allow crates/nozoki-core/Cargo.toml crates/nozoki-bridge/Cargo.toml; do
    [ -r "$R/$required" ] || fail "the copy carries no readable $required" || return 1
  done
  cmp -s "$ROOT/checks/deps.allow" "$R/checks/deps.allow" \
    || fail "the copy's checks/deps.allow differs from the originating tree's" || return 1
  printf '\n# a comment between entries\n\nzzz-listed\n' >> "$R/checks/deps.allow"
  plant "$R" "nozoki-bridge/src/boundary.rs" 'mod sibling_module;'
  plant "$R" "$BRIDGE_FILE" 'use serde_json::Value; use tree_sitter::Parser; use zzz_listed::Thing;'
  plant "$R" "$BRIDGE_FILE" 'use serde_json::Value as Json; use serde_json::{self, Map};'
  plant "$R" "$BRIDGE_FILE" 'use zzz_listed::Thing as Alias; fn al() { Alias::x(); }'
  plant "$R" "$BRIDGE_FILE" 'use std::collections::hash_map as hm; fn a() { hm::Entry::<u8, u8>::default; }'
  plant "$R" "$BRIDGE_FILE" 'fn c() -> core::ffi::c_int { alloc::vec::Vec::<u8>::new(); 0 }'
  plant "$R" "$BRIDGE_FILE" 'use std::ptr; fn n() { ptr::null::<u8>(); }'
  plant "$R" "$BRIDGE_FILE" 'fn m() { log_writer::FileLog::open(); sibling_module::go(); }'
  plant "$R" "$BRIDGE_FILE" 'fn u() { usize::MAX; Self::new(); self::helper(); super::x(); Session::new(); }'
  plant "$R" "$BRIDGE_FILE" '#[allow(clippy::x)] #[rustfmt::skip] fn t() {}'
  plant "$R" "$BRIDGE_FILE" '// tokio::spawn'
  plant "$R" "$BRIDGE_FILE" 'const T: &str = "reqwest::get";'
  plant "$R" "nozoki-extra/src/lib.rs" 'use objc2::runtime::AnyObject;'
  run_structure "$R"
  expect_status 0 || return 1
  expect_stderr_empty || return 1
}

# --- the cases of the unit-graph change: unit edges, the bridge's import set, the shipped manifests
# and the logger clause ---

HL_FILE="nozoki-core/src/highlighter.rs"
FS_FILE="nozoki-core/src/fs_reader.rs"
LANG_FILE="nozoki-core/src/language.rs"
CORE_MANIFEST="nozoki-core/Cargo.toml"
BRIDGE_MANIFEST="nozoki-bridge/Cargo.toml"

# A finding line `<path>:<line>: <QC-n>: <what>` whose <what> carries the text $4.
expect_finding_naming() {
  found=0
  while IFS= read -r stderr_line; do
    case "$stderr_line" in
      "$1:$2: $3: "*"$4"*) found=1 ;;
    esac
  done <<< "$STDERR"
  [ "$found" -eq 1 ] || fail "expected a finding $1:$2: $3 naming $4 on stderr. stderr: $STDERR"
}

expect_count() {
  actual="$(count_findings "$1" "$2" "$3")"
  [ "$actual" -eq "$4" ] || fail "expected $4 finding(s) $1:$2: $3, got $actual. stderr: $STDERR"
}

# The first stderr line starting with $1 comes before the first one starting with $2.
expect_before() {
  case "$STDERR" in
    *"$1"*) ;;
    *) fail "no stderr line starts with $1. stderr: $STDERR" || return 1 ;;
  esac
  case "$STDERR" in
    *"$2"*) ;;
    *) fail "no stderr line starts with $2. stderr: $STDERR" || return 1 ;;
  esac
  head_one="${STDERR%%"$1"*}"
  head_two="${STDERR%%"$2"*}"
  [ "${#head_one}" -lt "${#head_two}" ] || fail "expected $1 before $2. stderr: $STDERR"
}

# The number of stderr lines that carry the text $1.
stderr_lines_with() {
  with_count=0
  while IFS= read -r stderr_line; do
    case "$stderr_line" in
      *"$1"*) with_count=$((with_count + 1)) ;;
    esac
  done <<< "$STDERR"
  printf '%s' "$with_count"
}

# Plants one `use crate::<unit>::Item;` per unit named in $3 into file $2 of root $1, and sets
# UNIT_LINES to the lines they landed on.
plant_each_unit() {
  UNIT_LINES=""
  for unit in $3; do
    plant "$1" "$2" "use crate::$unit::Item;"
    UNIT_LINES="$UNIT_LINES $PLANT_LINE"
  done
}

# Removes a file of the copy $R. The path is guarded so an empty one cannot widen the removal.
remove_input() {
  rm -f -- "${R:?}/${1:?}"
}

# CP-430 row 1.
test_folder_model_libgit2_binding_is_rejected() {
  new_root git2-binding || return 1
  hit_lines=""
  for form in \
    'use git2::Repository;' \
    'fn g() { ::git2::Oid::zero(); }' \
    'extern crate libgit2_sys;' \
    '// git2::Repository::open' \
    'use {libgit2_sys::Oid, std::io};' \
    'use some::{git2, other};' \
    'use git2
    ::Odb;'; do
    plant "$R" "$CORE_FILE" "$form"
    hit_lines="$hit_lines $PLANT_LINE"
  done
  plant "$R" "$CORE_FILE" 'use git2_extra::Thing; use mygit2::Other; fn git2x() { libgit2_sysx::f(); }'
  near_line="$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  for hit_line in $hit_lines; do
    expect_finding_naming "crates/$CORE_FILE" "$hit_line" QC-10 "libgit2 binding" || return 1
  done
  expect_count "crates/$CORE_FILE" "$near_line" QC-10 0 || return 1
}

# CP-430 row 2.
test_folder_model_own_state_is_rejected() {
  new_root own-state || return 1
  plant "$R" "$CORE_FILE" 'use crate::own_state::Theme;'
  direct_line="$PLANT_LINE"
  plant "$R" "$CORE_FILE" 'use crate::{
    language::Language,
    own_state::{
        Theme,
    },
};'
  nested_line=$((PLANT_LINE + 2))
  plant "$R" "$CORE_FILE" 'fn s() { super::super::own_state::theme(); }'
  super_line="$PLANT_LINE"
  plant "$R" "$CORE_FILE" 'use super::own_state;'
  use_super_line="$PLANT_LINE"
  plant "$R" "$CORE_FILE" 'fn n() { self::own_state::x(); nozoki_core::own_state::y(); let own_state = 1; let _ = own_state; }'
  none_line="$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  for hit_line in "$direct_line" "$nested_line" "$super_line" "$use_super_line"; do
    expect_finding_naming "crates/$CORE_FILE" "$hit_line" QC-10 "own_state" || return 1
  done
  expect_count "crates/$CORE_FILE" "$none_line" QC-10 0 || return 1
}

# CP-430 row 3.
test_highlighter_forbidden_units_are_rejected() {
  new_root highlighter-units || return 1
  hit_lines=""
  for form in \
    'use crate::fs_reader::Entry;' \
    'use crate::{fs_reader::Entry, highlighter::highlight};' \
    '// see crate::fs_reader::Entry' \
    'use crate::watcher::Event;' \
    'use crate::folder_model::FileView;' \
    'fn s() { super::fs_reader::list(); }' \
    'use git2::Oid;' \
    'use super::super::{folder_model::Thing};'; do
    plant "$R" "$HL_FILE" "$form"
    hit_lines="$hit_lines $PLANT_LINE"
  done
  plant_each_unit "$R" "$HL_FILE" "own_state git_reader markdown_renderer"
  hit_lines="$hit_lines $UNIT_LINES"
  plant "$R" "$HL_FILE" 'use crate::{fs_reader::Entry, watcher::Event};'
  two_line="$PLANT_LINE"
  plant "$R" "$HL_FILE" 'fn d() { crate::fs_reader::a(); crate::fs_reader::b(); }'
  duplicate_line="$PLANT_LINE"
  plant "$R" "nozoki-core/src/highlighter/extra.rs" 'use crate::fs_reader::Entry;'
  extra_line="$PLANT_LINE"
  plant "$R" "nozoki-core/src/highlighter/deep/more.rs" 'use crate::folder_model::Thing;'
  deep_line="$PLANT_LINE"
  plant "$R" "nozoki-core/src/highlighter_ext.rs" 'use crate::fs_reader::Entry;'
  run_structure "$R"
  expect_status 1 || return 1
  for hit_line in $hit_lines; do
    expect_finding "crates/$HL_FILE" "$hit_line" QC-11 || return 1
  done
  expect_count "crates/$HL_FILE" "$two_line" QC-11 2 || return 1
  expect_count "crates/$HL_FILE" "$duplicate_line" QC-11 1 || return 1
  expect_finding_naming "crates/$HL_FILE" "$two_line" QC-11 "fs_reader" || return 1
  expect_finding_naming "crates/$HL_FILE" "$two_line" QC-11 "watcher" || return 1
  expect_finding "crates/nozoki-core/src/highlighter/extra.rs" "$extra_line" QC-11 || return 1
  expect_finding "crates/nozoki-core/src/highlighter/deep/more.rs" "$deep_line" QC-11 || return 1
  expect_no_finding_for "highlighter_ext.rs" || return 1
}

# CP-430 row 4.
test_fs_reader_forbidden_units_are_rejected() {
  new_root fs-reader-units || return 1
  hit_lines=""
  for form in \
    'use crate::highlighter::Span;' \
    'extern crate libgit2_sys;' \
    'fn q() { super::super::highlighter::x(); }' \
    'use git2::Oid;' \
    'fn t(_: crate::Span) {}'; do
    plant "$R" "$FS_FILE" "$form"
    hit_lines="$hit_lines $PLANT_LINE"
  done
  plant_each_unit "$R" "$FS_FILE" "own_state git_reader watcher markdown_renderer"
  hit_lines="$hit_lines $UNIT_LINES"
  plant "$R" "$FS_FILE" 'fn p() { crate ::
    highlighter::highlight(); }'
  split_line=$((PLANT_LINE + 1))
  plant "$R" "$FS_FILE" 'use crate::folder_model::FileView; fn r(_: crate::FileView) {}'
  folder_model_line="$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  for hit_line in $hit_lines "$split_line"; do
    expect_finding "crates/$FS_FILE" "$hit_line" QC-11 || return 1
  done
  expect_finding_naming "crates/$FS_FILE" "$split_line" QC-11 "highlighter" || return 1
  expect_count "crates/$FS_FILE" "$folder_model_line" QC-11 1 || return 1
  expect_finding_naming "crates/$FS_FILE" "$folder_model_line" QC-11 "folder_model" || return 1
}

# CP-430 row 5.
test_root_reexport_reaches_the_unit() {
  new_root reexport-root-group || return 1
  plant "$R" "nozoki-core/src/lib.rs" 'pub use crate::{
    highlighter::{Span as LocalSpan},
    fs_reader::{Entry as GroupedEntry, Condition as GroupedCondition},
};'
  plant "$R" "$HL_FILE" 'fn grouped(_: crate::GroupedEntry, _: crate::GroupedCondition) {}'
  grouped_line="$PLANT_LINE"
  plant "$R" "$HL_FILE" 'fn local(_: crate::LocalSpan) {}'
  local_line="$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  expect_finding_naming "crates/$HL_FILE" "$grouped_line" QC-11 "fs_reader" || return 1
  expect_count "crates/$HL_FILE" "$grouped_line" QC-11 1 || return 1
  expect_count "crates/$HL_FILE" "$local_line" QC-11 0 || return 1
  new_root reexport || return 1
  plant "$R" "nozoki-core/src/lib.rs" 'pub use fs_reader::{NewThing, Entry as Renamed};'
  plant "$R" "$HL_FILE" 'fn f(_: crate::Entry) {}'
  entry_line="$PLANT_LINE"
  plant "$R" "$HL_FILE" 'use crate::{Condition, language::Language};'
  group_line="$PLANT_LINE"
  plant "$R" "$HL_FILE" 'fn g(_: crate::Renamed) {}'
  renamed_line="$PLANT_LINE"
  plant "$R" "$HL_FILE" 'fn h(_: crate::NewThing) {}'
  new_line="$PLANT_LINE"
  plant "$R" "$HL_FILE" 'fn l(_: crate::Language, _: crate::Error) { let _: Entry; }'
  clean_line="$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  for hit_line in "$entry_line" "$group_line" "$renamed_line" "$new_line"; do
    expect_finding_naming "crates/$HL_FILE" "$hit_line" QC-11 "fs_reader" || return 1
  done
  expect_count "crates/$HL_FILE" "$clean_line" QC-11 0 || return 1
  new_root reexport-folder-model || return 1
  plant "$R" "$FS_FILE" 'fn q(_: crate::FileView) {}'
  reexport_line="$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  expect_count "crates/$FS_FILE" "$reexport_line" QC-11 1 || return 1
  expect_finding_naming "crates/$FS_FILE" "$reexport_line" QC-11 "folder_model" || return 1
}

# CP-439: fs_reader no longer imports folder_model, so the clause is held. Every CP-416 form is
# planted, and the two reader-owned names that reach the type the move re-homed stay clean.
test_fs_reader_imports_folder_model_is_rejected() {
  new_root fs-reader-folder-model || return 1
  plant "$R" "$FS_FILE" 'use crate::folder_model::OpenFailure;'
  direct_line="$PLANT_LINE"
  plant "$R" "nozoki-core/src/fs_reader/extra.rs" 'use crate::folder_model::OpenFailure;'
  extra_line="$PLANT_LINE"
  plant "$R" "$FS_FILE" 'fn s() { super::super::folder_model::open_folder(); }'
  super_line="$PLANT_LINE"
  plant "$R" "$FS_FILE" 'use crate::{
    language::Language,
    folder_model::{
        FileView,
    },
};'
  nested_line=$((PLANT_LINE + 2))
  plant "$R" "$FS_FILE" 'fn s(_: crate::OpenFailure) {}'
  reader_name_line="$PLANT_LINE"
  plant "$R" "$CORE_FILE" 'use crate::fs_reader::OpenFailure;'
  model_line="$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  for hit_line in "$direct_line" "$super_line" "$nested_line"; do
    expect_count "crates/$FS_FILE" "$hit_line" QC-11 1 || return 1
    printf '%s\n' "$STDERR" | grep -Fx "crates/$FS_FILE:$hit_line: QC-11: fs_reader imports folder_model" > /dev/null ||
      fail "expected the complete QC-11 finding at crates/$FS_FILE:$hit_line. stderr: $STDERR" || return 1
  done
  expect_count "crates/nozoki-core/src/fs_reader/extra.rs" "$extra_line" QC-11 1 || return 1
  printf '%s\n' "$STDERR" | grep -Fx "crates/nozoki-core/src/fs_reader/extra.rs:$extra_line: QC-11: fs_reader imports folder_model" > /dev/null ||
    fail "expected the complete QC-11 finding in fs_reader/extra.rs. stderr: $STDERR" || return 1
  expect_count "crates/$FS_FILE" "$reader_name_line" QC-11 0 || return 1
  expect_count "crates/$CORE_FILE" "$model_line" QC-10 0 || return 1
}

# CP-430 row 6.
test_bridge_unlisted_crate_by_use_is_rejected() {
  new_root bridge-use || return 1
  plant "$R" "$BRIDGE_FILE" 'use tokio::net::TcpStream;'
  tokio_line="$PLANT_LINE"
  plant "$R" "$BRIDGE_FILE" 'use {tokio_util::codec, std::io};'
  group_line="$PLANT_LINE"
  plant "$R" "$BRIDGE_FILE" 'extern crate mio as rt;'
  extern_line="$PLANT_LINE"
  plant "$R" "$BRIDGE_FILE" 'use hyper::net as netmod; fn z() { netmod::x(); }'
  alias_line="$PLANT_LINE"
  plant "$R" "$BRIDGE_FILE" 'use {
    std::fmt,
    axum::Router,
};'
  multiline_line=$((PLANT_LINE + 2))
  run_structure "$R"
  expect_status 1 || return 1
  expect_finding_naming "crates/$BRIDGE_FILE" "$tokio_line" QC-13 "tokio" || return 1
  expect_finding_naming "crates/$BRIDGE_FILE" "$group_line" QC-13 "tokio_util" || return 1
  expect_finding_naming "crates/$BRIDGE_FILE" "$extern_line" QC-13 "mio" || return 1
  expect_finding_naming "crates/$BRIDGE_FILE" "$alias_line" QC-13 "hyper" || return 1
  expect_finding_naming "crates/$BRIDGE_FILE" "$multiline_line" QC-13 "axum" || return 1
  expect_count "crates/$BRIDGE_FILE" "$extern_line" QC-13 1 || return 1
  case "$STDERR" in
    *'`rt`'*) fail "the extern crate finding names its alias: $STDERR" || return 1 ;;
  esac
  expect_count "crates/$BRIDGE_FILE" "$alias_line" QC-13 1 || return 1
}

# CP-430 row 7.
test_bridge_unlisted_crate_as_path_root_is_rejected() {
  new_root bridge-root || return 1
  plant "$R" "$BRIDGE_FILE" 'fn r(u: &str) { let _ = reqwest::get(u); }'
  reqwest_line="$PLANT_LINE"
  plant "$R" "$BRIDGE_FILE" 'fn h() { ::hyper::body::Bytes::new(); }'
  hyper_line="$PLANT_LINE"
  plant "$R" "$BRIDGE_FILE" 'fn t() { let x = tower
    ::
    layer(); let _ = x; }'
  tower_line="$PLANT_LINE"
  plant "$R" "$BRIDGE_FILE" 'fn m() { s.parse::<u8>(); std::io::stdin(); core::mem::size_of::<u8>(); x.unlisted::<u8>(); std::unlisted_mod::f(); a.b::<c>(); }'
  clean_line="$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  expect_finding_naming "crates/$BRIDGE_FILE" "$reqwest_line" QC-13 "reqwest" || return 1
  expect_finding_naming "crates/$BRIDGE_FILE" "$hyper_line" QC-13 "hyper" || return 1
  expect_finding_naming "crates/$BRIDGE_FILE" "$tower_line" QC-13 "tower" || return 1
  expect_count "crates/$BRIDGE_FILE" "$clean_line" QC-13 0 || return 1
}

# CP-430 row 8.
test_bridge_apple_binding_is_rejected() {
  new_root bridge-apple || return 1
  plant "$R" "$BRIDGE_FILE" 'use objc2::runtime::AnyObject;'
  use_line="$PLANT_LINE"
  plant "$R" "$BRIDGE_FILE" '#[link(name = "Foundation", kind = "framework")]'
  attribute_line="$PLANT_LINE"
  plant "$R" "$BRIDGE_FILE" '// objc2_app_kit::NSWindow'
  comment_line="$PLANT_LINE"
  plant "$R" "$BRIDGE_FILE" 'fn o() { objc2::a(); objc2::b(); }'
  repeat_line="$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  expect_count "crates/$BRIDGE_FILE" "$use_line" QC-13 2 || return 1
  expect_count "crates/$BRIDGE_FILE" "$attribute_line" QC-13 1 || return 1
  expect_count "crates/$BRIDGE_FILE" "$comment_line" QC-13 1 || return 1
  expect_count "crates/$BRIDGE_FILE" "$repeat_line" QC-13 2 || return 1
  expect_finding_naming "crates/$BRIDGE_FILE" "$use_line" QC-13 "objc2" || return 1
  expect_no_finding_for ": QC-9: " || return 1
}

# CP-430 row 9. A dependency named checks, in every form TOML lets a manifest write the key.
test_manifest_depends_on_checks_by_name() {
  new_root manifest-name-escapes || return 1
  plant "$R" "$BRIDGE_MANIFEST" '"\u0063hecks" = "1"'
  escaped_key_line="$PLANT_LINE"
  plant "$R" "$BRIDGE_MANIFEST" 'renamed = { package = "chec\U0000006Bs" }'
  escaped_value_line="$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  expect_finding "crates/$BRIDGE_MANIFEST" "$escaped_key_line" QC-14 || return 1
  expect_finding "crates/$BRIDGE_MANIFEST" "$escaped_value_line" QC-14 || return 1
  new_root manifest-name-core || return 1
  plant "$R" "$CORE_MANIFEST" '[dependencies.checks]
version = "0.1"'
  header_line="$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  expect_finding "crates/$CORE_MANIFEST" "$header_line" QC-14 || return 1
  new_root manifest-name-bridge || return 1
  plant "$R" "$BRIDGE_MANIFEST" 'harness = { version = "0.1", package = "checks" }'
  package_line="$PLANT_LINE"
  plant "$R" "$BRIDGE_MANIFEST" '"checks" = "0.1"'
  quoted_line="$PLANT_LINE"
  plant "$R" "$BRIDGE_MANIFEST" 'checks . version = "0.1"'
  dotted_line="$PLANT_LINE"
  plant "$R" "$BRIDGE_MANIFEST" 'other.package = "checks"'
  dotted_package_line="$PLANT_LINE"
  plant "$R" "$BRIDGE_MANIFEST" "nested = { inner = 1, package = 'checks' }"
  nested_line="$PLANT_LINE"
  plant "$R" "$BRIDGE_MANIFEST" '[dependencies.renamed]
package = "checks"'
  header_package_line=$((PLANT_LINE + 1))
  run_structure "$R"
  expect_status 1 || return 1
  for hit_line in "$package_line" "$quoted_line" "$dotted_line" "$dotted_package_line" "$nested_line" "$header_package_line"; do
    expect_finding "crates/$BRIDGE_MANIFEST" "$hit_line" QC-14 || return 1
  done
  expect_finding_naming "crates/$BRIDGE_MANIFEST" "$package_line" QC-14 "nozoki-bridge" || return 1
  new_root manifest-name-nested || return 1
  plant "$R" "$CORE_MANIFEST" "[target.'cfg(unix)']
dependencies = { checks = { version = \"1\" } }"
  inline_line=$((PLANT_LINE + 1))
  run_structure "$R"
  expect_status 1 || return 1
  expect_finding "crates/$CORE_MANIFEST" "$inline_line" QC-14 || return 1
  new_root manifest-name-decoys || return 1
  plant "$R" "$BRIDGE_MANIFEST" 'note = { version = "1", features = ["checks = 1", "[dependencies.checks]", "package = \"checks\""] }'
  plant "$R" "$BRIDGE_MANIFEST" 'doc = """
checks = { path = "../../checks" }
[dependencies.checks]
"""'
  plant "$R" "$BRIDGE_MANIFEST" 'list = [
  "path = '"'"'../../checks'"'"'",
  "checks = 1",
]'
  plant "$R" "$BRIDGE_MANIFEST" '# checks = { path = "../../checks" }'
  run_structure "$R"
  expect_status 0 || return 1
  expect_stderr_empty || return 1
}

# CP-430 row 10. A dependency whose path lies at or under checks/, resolved lexically from the
# manifest's own directory.
test_manifest_dependency_path_under_checks() {
  new_root manifest-path-escapes || return 1
  plant "$R" "$BRIDGE_MANIFEST" 'escaped = { "pa\u0074h" = "../../\u0063hecks/walker" }'
  escaped_path_line="$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  expect_finding "crates/$BRIDGE_MANIFEST" "$escaped_path_line" QC-14 || return 1
  new_root manifest-path || return 1
  physical_root="$(cd "$R" && pwd -P)"
  hit_lines=""
  # Pad the bridge manifest, so its findings sit on later lines than the core manifest's: only a
  # path-first order puts the bridge manifest's first.
  filler=""
  for filler_index in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30; do
    filler="$filler# filler $filler_index
"
  done
  plant "$R" "$BRIDGE_MANIFEST" "$filler"
  plant "$R" "$BRIDGE_MANIFEST" 'walker = { path = "../../checks/walker" }'
  walker_line="$PLANT_LINE"
  plant "$R" "$BRIDGE_MANIFEST" 'dotted.path = "../../checks/d"'
  hit_lines="$hit_lines $PLANT_LINE"
  plant "$R" "$BRIDGE_MANIFEST" "\"quoted\" = { \"path\" = '../../checks/q' }"
  hit_lines="$hit_lines $PLANT_LINE"
  plant "$R" "$BRIDGE_MANIFEST" 'lexical = { path = "../../crates/../checks/x" }'
  hit_lines="$hit_lines $PLANT_LINE"
  plant "$R" "$BRIDGE_MANIFEST" 'trailing = { path = "../../checks/" }'
  hit_lines="$hit_lines $PLANT_LINE"
  plant "$R" "$BRIDGE_MANIFEST" 'dots = { path = "./../../checks/./y" }'
  hit_lines="$hit_lines $PLANT_LINE"
  plant "$R" "$CORE_MANIFEST" "[target.'cfg(unix)'.dependencies]
x = { path = \"../../checks\" }"
  target_line=$((PLANT_LINE + 1))
  plant "$R" "$CORE_MANIFEST" "[dependencies.probe]
path = \"$physical_root/checks/probe\""
  absolute_line=$((PLANT_LINE + 1))
  plant "$R" "$HL_FILE" 'use crate::fs_reader::Entry;'
  highlighter_line="$PLANT_LINE"
  plant "$R" "nozoki-core/src/highlighter/zz.rs" '// one
use crate::fs_reader::A;
// 3
// 4
// 5
// 6
// 7
// 8
// 9
use crate::fs_reader::B;'
  second_line=$((PLANT_LINE + 1))
  tenth_line=$((PLANT_LINE + 9))
  run_structure "$R"
  expect_status 1 || return 1
  for hit_line in "$walker_line" $hit_lines; do
    expect_finding "crates/$BRIDGE_MANIFEST" "$hit_line" QC-14 || return 1
  done
  expect_finding "crates/$CORE_MANIFEST" "$target_line" QC-14 || return 1
  expect_finding "crates/$CORE_MANIFEST" "$absolute_line" QC-14 || return 1
  expect_finding "crates/$HL_FILE" "$highlighter_line" QC-11 || return 1
  expect_before "crates/$BRIDGE_MANIFEST:$walker_line: " "crates/$CORE_MANIFEST:$target_line: " || return 1
  expect_before "crates/$CORE_MANIFEST:$absolute_line: " "crates/$HL_FILE:$highlighter_line: " || return 1
  expect_before "crates/nozoki-core/src/highlighter/zz.rs:$second_line: " "crates/nozoki-core/src/highlighter/zz.rs:$tenth_line: " || return 1
}

# CP-430 row 11. The library target, as it ships, may not live under checks/.
test_manifest_lib_path_under_checks() {
  new_root lib-path-multiline || return 1
  plant "$R" "$CORE_MANIFEST" '[lib]
path = """
../../chec\
    ks/lib.rs"""'
  multiline_path_line=$((PLANT_LINE + 1))
  run_structure "$R"
  expect_status 1 || return 1
  expect_finding "crates/$CORE_MANIFEST" "$multiline_path_line" QC-14 || return 1
  new_root lib-path-literal-multiline || return 1
  plant "$R" "$CORE_MANIFEST" "[lib]
path = '''
../../checks/lib.rs'''"
  literal_path_line=$((PLANT_LINE + 1))
  run_structure "$R"
  expect_status 1 || return 1
  expect_finding "crates/$CORE_MANIFEST" "$literal_path_line" QC-14 || return 1
  new_root lib-path || return 1
  plant "$R" "$CORE_MANIFEST" '[lib]
path = "../../checks/lib.rs"'
  path_line=$((PLANT_LINE + 1))
  run_structure "$R"
  expect_status 1 || return 1
  expect_finding "crates/$CORE_MANIFEST" "$path_line" QC-14 || return 1
  new_root lib-path-quoted || return 1
  plant "$R" "$CORE_MANIFEST" "[lib]
\"path\" = '../../checks/lib.rs'"
  quoted_line=$((PLANT_LINE + 1))
  run_structure "$R"
  expect_status 1 || return 1
  expect_finding "crates/$CORE_MANIFEST" "$quoted_line" QC-14 || return 1
  new_root lib-path-string || return 1
  plant "$R" "$CORE_MANIFEST" '[lib]
description = """
path = "../../checks/fake.rs"
"""
path = "../../checks/lib.rs"'
  real_line=$((PLANT_LINE + 4))
  run_structure "$R"
  expect_status 1 || return 1
  expect_finding "crates/$CORE_MANIFEST" "$real_line" QC-14 || return 1
  [ "$(stderr_lines_with ': QC-14: ')" -eq 1 ] || fail "a multi-line string manufactured an assignment: $STDERR" || return 1
  new_root lib-path-clean || return 1
  plant "$R" "$CORE_MANIFEST" '[lib]
name = "x"
path = "../../src/lib.rs"'
  run_structure "$R"
  expect_status 0 || return 1
  expect_stderr_empty || return 1
}

# CP-430 row 12.
test_set_logger_outside_the_bridge_is_rejected() {
  new_root set-logger || return 1
  hit_lines=""
  plant "$R" "$CORE_FILE" 'fn i() { log::set_logger(&WRITER); }'
  hit_lines="$hit_lines $CORE_FILE:$PLANT_LINE"
  plant "$R" "$LANG_FILE" 'use log::set_logger as install;'
  hit_lines="$hit_lines $LANG_FILE:$PLANT_LINE"
  plant "$R" "$CORE_FILE" 'fn j() { ::log :: set_logger(&W); }'
  hit_lines="$hit_lines $CORE_FILE:$PLANT_LINE"
  plant "$R" "nozoki-core/examples/x.rs" 'log::set_logger(&W);'
  hit_lines="$hit_lines nozoki-core/examples/x.rs:$PLANT_LINE"
  plant "$R" "$CORE_FILE" 'use log::{info, set_logger};'
  hit_lines="$hit_lines $CORE_FILE:$PLANT_LINE"
  plant "$R" "$CORE_FILE" 'use log::{
    warn,
    set_logger,
};'
  hit_lines="$hit_lines $CORE_FILE:$((PLANT_LINE + 2))"
  plant "$R" "nozoki-bridge/src_old/y.rs" 'fn y() { log::set_logger(&W); }'
  hit_lines="$hit_lines nozoki-bridge/src_old/y.rs:$PLANT_LINE"
  plant "$R" "$CORE_FILE" 'fn k() { log::set_logger_racy(&W); mylog::set_logger(&W); ulog :: set_logger(&W); }'
  near_line="$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  for hit in $hit_lines; do
    expect_count "crates/${hit%:*}" "${hit##*:}" QC-17 1 || return 1
    expect_count "crates/${hit%:*}" "${hit##*:}" QC-61 1 || return 1
  done
  expect_count "crates/$CORE_FILE" "$near_line" QC-17 0 || return 1
  expect_count "crates/$CORE_FILE" "$near_line" QC-61 0 || return 1
}

# CP-430 row 13.
test_set_boxed_logger_outside_the_bridge_is_rejected() {
  new_root set-boxed-logger || return 1
  hit_lines=""
  plant "$R" "$FS_FILE" 'fn b() { log::set_boxed_logger(Box::new(W)); }'
  hit_lines="$hit_lines $FS_FILE:$PLANT_LINE"
  plant "$R" "$HL_FILE" '// log::set_boxed_logger'
  hit_lines="$hit_lines $HL_FILE:$PLANT_LINE"
  plant "$R" "$HL_FILE" 'const S: &str = "log::set_boxed_logger";'
  hit_lines="$hit_lines $HL_FILE:$PLANT_LINE"
  plant "$R" "nozoki-bridge/examples/x.rs" 'log::set_boxed_logger(Box::new(W));'
  hit_lines="$hit_lines nozoki-bridge/examples/x.rs:$PLANT_LINE"
  plant "$R" "$FS_FILE" 'use log::set_boxed_logger as boxed;'
  hit_lines="$hit_lines $FS_FILE:$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  for hit in $hit_lines; do
    expect_count "crates/${hit%:*}" "${hit##*:}" QC-17 1 || return 1
    expect_count "crates/${hit%:*}" "${hit##*:}" QC-61 1 || return 1
  done
  new_root set-boxed-logger-clean || return 1
  plant "$R" "nozoki-bridge/src/inner/deep.rs" 'fn i() { log::set_boxed_logger(Box::new(W)); }
use log::set_logger as install;'
  run_structure "$R"
  expect_status 0 || return 1
  expect_stderr_empty || return 1
}

# CP-430 row 14. Each required input, absent or unreadable, is named once, and every other file is
# still read before the verdict.
test_required_inputs_are_read() {
  missing_index=0
  for required in checks/deps.allow crates/nozoki-core/Cargo.toml crates/nozoki-bridge/Cargo.toml; do
    missing_index=$((missing_index + 1))
    new_root "required-missing-$missing_index" || return 1
    remove_input "$required"
    run_structure "$R"
    expect_status 1 || return 1
    expect_stderr_contains "$required" || return 1
    [ "$(stderr_lines_with "$required")" -eq 1 ] || fail "expected $required named once: $STDERR" || return 1
  done
  new_root required-unreadable || return 1
  chmod 000 "$R/checks/deps.allow"
  if [ -r "$R/checks/deps.allow" ]; then
    chmod 644 "$R/checks/deps.allow"
    fail "this account can read a mode-000 file, so the case cannot make a file unreadable" || return 1
  fi
  plant "$R" "$CORE_FILE" 'fn u() { unsafe {} }'
  unsafe_line="$PLANT_LINE"
  run_structure "$R"
  chmod 644 "$R/checks/deps.allow"
  expect_status 1 || return 1
  expect_stderr_contains "checks/deps.allow" || return 1
  expect_finding "crates/$CORE_FILE" "$unsafe_line" QC-9 || return 1
  new_root required-unreadable-manifest || return 1
  chmod 000 "$R/crates/$BRIDGE_MANIFEST"
  if [ -r "$R/crates/$BRIDGE_MANIFEST" ]; then
    chmod 644 "$R/crates/$BRIDGE_MANIFEST"
    fail "this account can read a mode-000 file, so the case cannot make a file unreadable" || return 1
  fi
  run_structure "$R"
  chmod 644 "$R/crates/$BRIDGE_MANIFEST"
  expect_status 1 || return 1
  [ "$(stderr_lines_with "crates/$BRIDGE_MANIFEST")" -eq 1 ] || fail "expected the manifest named once: $STDERR" || return 1
  new_root required-all-missing || return 1
  for required in checks/deps.allow "crates/$CORE_MANIFEST" "crates/$BRIDGE_MANIFEST"; do
    remove_input "$required"
  done
  plant "$R" "$CORE_FILE" 'fn u() { unsafe {} }'
  unsafe_line="$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  expect_finding "crates/$CORE_FILE" "$unsafe_line" QC-9 || return 1
  for required in checks/deps.allow "crates/$CORE_MANIFEST" "crates/$BRIDGE_MANIFEST"; do
    [ "$(stderr_lines_with "$required")" -eq 1 ] || fail "expected $required named once: $STDERR" || return 1
  done
}

# CP-430 row 15 (clean).
test_allowed_unit_edges_pass() {
  new_root allowed-edges || return 1
  plant "$R" "$CORE_FILE" 'use crate::{fs_reader::Entry, highlighter::Span};'
  plant "$R" "$CORE_FILE" 'use crate::watcher::Event;'
  plant "$R" "$CORE_FILE" 'use crate::markdown_renderer::render;'
  plant "$R" "$CORE_FILE" 'use self::fs_reader::Entry;'
  plant "$R" "$CORE_FILE" 'use crate::fs_reader; use crate::highlighter;'
  plant "$R" "$FS_FILE" 'use crate::language::Language;'
  plant "$R" "$HL_FILE" 'use crate::language::Language;'
  plant "$R" "$HL_FILE" '//! see nozoki_core::Entry and nozoki_core::folder_model::FileView'
  plant "$R" "$HL_FILE" 'fn near() { let fs_reader = 1; let _ = fs_reader; self::watcher::x(); }'
  plant "$R" "$LANG_FILE" 'use crate::folder_model::OpenFailure;'
  plant "$R" "nozoki-core/src/error.rs" 'use crate::highlighter::Span; use crate::fs_reader::Entry;'
  run_structure "$R"
  expect_status 0 || return 1
  expect_stderr_empty || return 1
}

# CP-430 row 17 (clean).
test_test_targets_into_checks_pass() {
  new_root test-targets || return 1
  plant "$R" "$CORE_MANIFEST" "[dev-dependencies]
checks = { path = \"../../checks\" }
[build-dependencies]
harness = { path = \"../../checks\" }
[target.'cfg(unix)'.dev-dependencies]
walker = { path = \"../../checks/walker\" }
[target.'cfg(unix)'.build-dependencies]
builder = { path = \"../../checks/builder\" }
[[test]]
name = \"probe\"
path = \"../../checks/probe.rs\"
[[bench]]
name = \"b\"
path = \"../../checks/b.rs\"
[[example]]
name = \"e\"
path = \"../../checks/e.rs\"
[[bin]]
name = \"n\"
path = \"../../checks/n.rs\"
# a comment naming ../../checks/walk.rs"
  plant "$R" "$BRIDGE_MANIFEST" 'near = { path = "../../checksum" }
round = { path = "../../checks/../crates/nozoki-core" }
decoy = { version = "1", features = ["path = \"../../checks\"", "../../checks/x"] }
text = "checks"'
  run_structure "$R"
  expect_status 0 || return 1
  expect_stderr_empty || return 1
}

# --- the cases of the boundary reads: QC-2, QC-30 and QC-58, QC-15's socket clause, layer-5 ---

# Intent: tl_instruction.md Task 2, W1–W6 / E1–E2 / S1–S2 member contracts.
WRITE_FS_MEMBERS="write copy rename create_dir create_dir_all remove_file remove_dir remove_dir_all hard_link soft_link symlink symlink_file symlink_dir mkfifo mkdir mkdirat unlink unlinkat renameat renameat_with symlinkat link linkat mknodat ftruncate"
WRITE_FLAGS="write append create create_new truncate"
WRITE_OFLAGS="WRONLY RDWR CREATE TRUNC APPEND"
WRITE_LIBC_FLAGS="O_WRONLY O_RDWR O_CREAT O_TRUNC O_APPEND"
WRITE_LIBC_CALLS="creat mkdir mkdirat mkfifo mkfifoat mknod mknodat rmdir unlink unlinkat remove rename renameat renamex_np renameatx_np symlink symlinkat link linkat truncate ftruncate"
ENV_MEMBERS="args args_os var var_os vars vars_os"
ENV_LIBC_MEMBERS="getenv environ _NSGetEnviron _NSGetArgv _NSGetArgc"
SOCKET_LIBC_CALLS="socket socketpair connect bind listen accept accept4"

CORE_TESTS_FILE="nozoki-core/tests/planted.rs"
BIN_EXE_TEXT='let exe = env!("CARGO_BIN_EXE_nozoki");'

# The lines (set by plant_line) the case's plants landed on, each to be asserted below.
PLANTED_LINES=""

# plant_line <root> <file> <text> [<offset>]: plants the text and records the line of interest,
# which is the plant's first line plus the offset (default 0).
plant_line() {
  plant "$1" "$2" "$3"
  PLANTED_LINES="$PLANTED_LINES $((PLANT_LINE + ${4:-0}))"
}

# expect_each <path> <identifier>...: every recorded line holds exactly one finding of each
# identifier.
expect_each() {
  each_path="$1"
  shift
  for each_line in $PLANTED_LINES; do
    for each_id in "$@"; do
      expect_count "$each_path" "$each_line" "$each_id" 1 || return 1
    done
  done
}

test_core_write_api_is_rejected() {
  new_root core-write || return 1
  plant "$R" "$CORE_FILE" 'fn f() { let _ = std::fs::write("x", "y"); }'
  core_line="$PLANT_LINE"
  plant "$R" "$BRIDGE_FILE" 'fn f() { let _ = std::fs::write("x", "y"); }'
  bridge_line="$PLANT_LINE"
  plant "$R" "nozoki-extra/src/lib.rs" 'fn f() { let _ = std::fs::write("x", "y"); }'
  extra_line="$PLANT_LINE"
  plant "$R" "nozoki-core/src/own_state.rs" 'fn f() { let _ = std::fs::write("x", "y"); }'
  own_state_line="$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  expect_count "crates/$CORE_FILE" "$core_line" QC-2 1 || return 1
  expect_count "crates/$CORE_FILE" "$core_line" QC-15 1 || return 1
  expect_count "crates/$BRIDGE_FILE" "$bridge_line" QC-2 0 || return 1
  expect_count "crates/$BRIDGE_FILE" "$bridge_line" QC-15 1 || return 1
  expect_count "crates/nozoki-extra/src/lib.rs" "$extra_line" QC-2 0 || return 1
  expect_count "crates/nozoki-core/src/own_state.rs" "$own_state_line" QC-2 1 || return 1
}

test_write_api_members_are_rejected() {
  new_root write-members || return 1
  PLANTED_LINES=""
  for member in $WRITE_FS_MEMBERS; do
    plant_line "$R" "$CORE_OWNER" "fn std_$member() { let _ = std::fs::$member; }"
    plant_line "$R" "$CORE_OWNER" "fn rustix_$member() { let _ = rustix::fs::$member; }"
    plant_line "$R" "$CORE_OWNER" "fn bare_$member() { let _ = fs::$member; }"
    plant_line "$R" "$CORE_OWNER" "use std::fs::{File, $member};"
  done
  plant_line "$R" "$CORE_OWNER" 'fn unix_symlink() { let _ = std::os::unix::fs::symlink("a", "b"); }'
  plant_line "$R" "$CORE_OWNER" 'use std::os::unix::fs::{symlink};'
  plant_line "$R" "$CORE_OWNER" 'fn file_create() { let _ = std::fs::File::create("x"); }'
  plant_line "$R" "$CORE_OWNER" 'fn file_create_new() { let _ = File::create_new("x"); }'
  plant_line "$R" "$CORE_OWNER" 'use std::fs::File::create;'
  plant_line "$R" "$CORE_OWNER" 'use std::fs::File::{create_new};'
  plant_line "$R" "$CORE_OWNER" 'fn dir_builder() { let _ = std::fs::DirBuilder::new(); }'
  plant_line "$R" "$CORE_OWNER" 'use std::fs::DirBuilder;'
  for flag in $WRITE_FLAGS; do
    plant_line "$R" "$CORE_OWNER" "fn flag_$flag() { let _ = fs::OpenOptions::new().$flag(true); }"
    plant_line "$R" "$CORE_OWNER" "fn spaced_$flag() { let _ = fs::OpenOptions::new().$flag( true ); }"
  done
  plant_line "$R" "$CORE_OWNER" 'fn split_flag() { let _ = o
    .write(
        true
    ); }' 1
  for constant in $WRITE_OFLAGS; do
    plant_line "$R" "$CORE_OWNER" "fn oflags_$constant() { let _ = OFlags::$constant; }"
    plant_line "$R" "$CORE_OWNER" "fn rustix_oflags_$constant() { let _ = rustix::fs::OFlags::$constant; }"
    plant_line "$R" "$CORE_OWNER" "use rustix::{fs::{OFlags::{
        $constant,
    }}};" 1
  done
  for constant in $WRITE_LIBC_FLAGS; do
    plant_line "$R" "$CORE_OWNER" "fn libc_$constant() { let _ = libc::$constant; }"
    plant_line "$R" "$CORE_OWNER" "use libc::{c_int, $constant};"
  done
  for call in $WRITE_LIBC_CALLS; do
    plant_line "$R" "$CORE_OWNER" "fn libc_call_$call() { let _ = libc::$call; }"
    plant_line "$R" "$CORE_OWNER" "use libc::{c_int, $call};"
  done
  plant_line "$R" "$CORE_OWNER" 'fn split_path() { std
    ::
    fs::write("x", "y"); }' 2
  plant_line "$R" "$CORE_OWNER" 'use std::{
    io,
    fs::{
        self,
        write,
    },
};' 4
  plant_line "$R" "$CORE_OWNER" 'use libc::{
    c_int,
    unlink,
};' 2
  plant_line "$R" "$CORE_OWNER" 'use rustix::fs::{
    OFlags,
    OFlags::{WRONLY},
};' 2
  run_structure "$R"
  expect_status 1 || return 1
  expect_each "crates/$CORE_OWNER" QC-2 || fail "a write form was not refused exactly once" || return 1
}

test_read_only_and_non_write_forms_pass() {
  new_root read-only || return 1
  plant "$R" "$CORE_OWNER" 'fn a() { let _ = fs::OpenOptions::new().read(true).custom_flags(flags).open(p); }
fn b() { let _ = OFlags::NOFOLLOW | OFlags::NONBLOCK; }
fn c() { let _ = File::open(p); let _ = fs::read(p); let _ = fs::metadata(p); }
fn d() { let _ = libc::open(p, 0); libc::write(fd, b, n); }
use std::io::Write;
fn e() { write!(s, "x"); writeln!(s); w.write_all(b); }'
  # CP-447 and Task 2 W4: only literal true asserts write access.
  for flag in $WRITE_FLAGS; do
    plant "$R" "$CORE_OWNER" "fn disabled_$flag() { let _ = o.$flag(false); }"
    plant "$R" "$CORE_OWNER" "fn variable_$flag() { let _ = o.$flag(enabled); }"
  done
  run_structure "$R"
  expect_status 0 || return 1
  expect_stderr_empty || return 1
}

test_env_reads_are_rejected() {
  new_root env-reads || return 1
  PLANTED_LINES=""
  plant_line "$R" "$CORE_FILE" 'fn a() { let _ = std::env::args(); }'
  plant_line "$R" "$CORE_FILE" 'fn b() { let _ = std::env::var("X"); }'
  plant_line "$R" "$CORE_FILE" 'fn c() { let _ = std
    ::
    env::var("X"); }' 2
  for member in $ENV_MEMBERS; do
    plant_line "$R" "$CORE_FILE" "fn bare_$member() { let _ = env::$member; }"
    plant_line "$R" "$CORE_FILE" "fn abs_$member() { let _ = ::std::env::$member; }"
    plant_line "$R" "$CORE_FILE" "use std::{env::{
        $member,
    }};" 1
  done
  for member in $ENV_LIBC_MEMBERS; do
    plant_line "$R" "$CORE_FILE" "fn libc_$member() { let _ = libc::$member; }"
    plant_line "$R" "$CORE_FILE" "use {libc::{
        $member,
    }};" 1
  done
  plant_line "$R" "$CORE_FILE" 'use libc::{
    c_int,
    getenv,
};' 2
  plant_line "$R" "$CORE_FILE" 'use std::{
    io,
    env::{
        self,
        var_os,
    },
};' 4
  plant "$R" "$CORE_OWNER" 'fn owner_env() { let _ = std::env::var("X"); }'
  owner_line="$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  expect_each "crates/$CORE_FILE" QC-30 QC-58 || return 1
  expect_count "crates/$CORE_OWNER" "$owner_line" QC-30 1 || return 1
  expect_count "crates/$CORE_OWNER" "$owner_line" QC-58 1 || return 1
  new_root env-bridge || return 1
  PLANTED_LINES=""
  plant_line "$R" "$BRIDGE_FILE" 'use std::{io, env::{self, var}};'
  plant_line "$R" "$BRIDGE_FILE" 'fn args_in_bridge() { let _ = std::env::args(); }'
  run_structure "$R"
  expect_status 1 || return 1
  expect_each "crates/$BRIDGE_FILE" QC-30 QC-58 || return 1
  plant "$R" "$BRIDGE_OWNER" 'fn owner_env() { let _ = std::env::var_os("X"); }'
  run_structure "$R"
  expect_count "crates/$BRIDGE_OWNER" "$PLANT_LINE" QC-30 1 || return 1
  expect_count "crates/$BRIDGE_OWNER" "$PLANT_LINE" QC-58 1 || return 1
  new_root env-third || return 1
  plant "$R" "nozoki-extra/src/lib.rs" 'fn f() { let _ = std::env::args_os(); }'
  run_structure "$R"
  expect_status 1 || return 1
  expect_count "crates/nozoki-extra/src/lib.rs" "$PLANT_LINE" QC-30 1 || return 1
  expect_count "crates/nozoki-extra/src/lib.rs" "$PLANT_LINE" QC-58 1 || return 1
}

test_env_near_names_pass() {
  new_root env-near || return 1
  for near_file in "$CORE_FILE" "$BRIDGE_FILE"; do
    plant "$R" "$near_file" 'fn near() { let _ = std::env::current_exe(); let _ = std::env::current_dir(); let _ = std::env::temp_dir(); let _ = std::env::home_dir(); }
/// see std::env::temp_dir()
const V: &str = env!("CARGO_PKG_VERSION");
const W: Option<&str> = option_env!("X");'
  done
  run_structure "$R"
  expect_status 0 || return 1
  expect_stderr_empty || return 1
}

test_config_reads_are_rejected() {
  new_root config-reads || return 1
  plant "$R" "$CORE_OWNER" 'fn f() { let _ = std::fs::read_to_string("/Users/a/.config/nozoki/settings.toml"); }'
  owner_line="$PLANT_LINE"
  PLANTED_LINES=""
  plant_line "$R" "$BRIDGE_FILE" 'const C1_PATH: &str = "/home/u/.config/nozoki";'
  plant_line "$R" "$BRIDGE_FILE" 'const C1_END: &str = "/home/u/.config";'
  plant_line "$R" "$BRIDGE_FILE" 'const C2: &str = "Library/Preferences/nozoki.plist";'
  plant_line "$R" "$BRIDGE_FILE" 'const C3: &str = "/etc/nozoki.conf";'
  plant_line "$R" "$BRIDGE_FILE" 'fn c4a() { let _ = config_dir(); }'
  plant_line "$R" "$BRIDGE_FILE" 'fn c4b() { let _ = config_local_dir(); }'
  plant_line "$R" "$BRIDGE_FILE" 'fn c4c() { let _ = preference_dir(); }'
  plant_line "$R" "$BRIDGE_FILE" 'use dotenv::dotenv;'
  plant_line "$R" "$BRIDGE_FILE" 'use dotenvy::dotenv;'
  plant_line "$R" "$BRIDGE_FILE" 'use confy::load;'
  plant_line "$R" "$BRIDGE_FILE" 'use figment::Figment;'
  plant_line "$R" "$BRIDGE_FILE" 'fn c5() { let _ = dotenvy::dotenv(); }'
  run_structure "$R"
  expect_status 1 || return 1
  expect_count "crates/$CORE_OWNER" "$owner_line" QC-30 1 || return 1
  expect_count "crates/$CORE_OWNER" "$owner_line" QC-58 1 || return 1
  expect_count "crates/$CORE_OWNER" "$owner_line" QC-15 0 || return 1
  expect_each "crates/$BRIDGE_FILE" QC-30 QC-58 || return 1
}

test_config_near_names_pass() {
  new_root config-near || return 1
  plant "$R" "$BRIDGE_FILE" 'fn a() { let config = 1; let _ = config + 1; }
fn b(s: &S) -> u8 { s.config }
fn c() { let _ = Config::default(); }
const D: &str = ".configure";
const E: &str = "config.rs";
fn g() { let _ = libc::getpwuid_r; }'
  run_structure "$R"
  expect_status 0 || return 1
  expect_stderr_empty || return 1
}

test_sockets_are_rejected() {
  new_root sockets || return 1
  PLANTED_LINES=""
  plant_line "$R" "$CORE_FILE" 'fn f() { let _ = std::net::TcpStream::connect("127.0.0.1:1"); }'
  plant_line "$R" "$CORE_FILE" 'fn g() { let _ = std
    ::
    net::TcpListener::bind("a"); }' 2
  plant_line "$R" "$CORE_FILE" 'use std::{io, os::unix::{net::UnixListener}};'
  plant_line "$R" "$CORE_FILE" 'fn r() { let _ = rustix::net::socket; }'
  plant_line "$R" "$CORE_FILE" 'use std::os::unix::net::UnixStream;'
  plant_line "$R" "$CORE_FILE" 'use std::{
    io,
    net,
};' 2
  for call in $SOCKET_LIBC_CALLS; do
    plant_line "$R" "$CORE_FILE" "fn libc_$call() { let _ = libc::$call; }"
    plant_line "$R" "$CORE_FILE" "use libc::{c_int, $call};"
  done
  run_structure "$R"
  expect_status 1 || return 1
  expect_each "crates/$CORE_FILE" QC-15 QC-30 || return 1
  for socket_line in $PLANTED_LINES; do
    expect_count "crates/$CORE_FILE" "$socket_line" QC-58 0 || return 1
  done
  new_root sockets-bridge || return 1
  PLANTED_LINES=""
  plant_line "$R" "$BRIDGE_FILE" 'use std::os::unix::net::UnixStream;'
  run_structure "$R"
  expect_status 1 || return 1
  expect_each "crates/$BRIDGE_FILE" QC-15 QC-30 || return 1
  new_root sockets-owners || return 1
  plant "$R" "$CORE_OWNER" 'fn f() { let _ = std::net::TcpStream::connect("a"); }'
  core_owner_line="$PLANT_LINE"
  plant "$R" "$BRIDGE_OWNER" 'fn f() { let _ = std::net::TcpStream::connect("a"); }'
  bridge_owner_line="$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  for owner_case in "$CORE_OWNER $core_owner_line" "$BRIDGE_OWNER $bridge_owner_line"; do
    owner_path="${owner_case% *}"
    owner_at="${owner_case#* }"
    expect_count "crates/$owner_path" "$owner_at" QC-15 1 || return 1
    expect_count "crates/$owner_path" "$owner_at" QC-30 1 || return 1
  done
}

test_socket_near_names_pass() {
  new_root socket-near || return 1
  plant "$R" "$CORE_FILE" 'fn a() { let net = 1; let _ = net + 1; }
fn b() { crate::net::x(); }
mod net {}
const N: &str = "network";
fn internet() {}'
  run_structure "$R"
  expect_status 0 || return 1
  expect_stderr_empty || return 1
}

# A write, an environment read, a configuration path and a socket are breaches in a comment or a
# string exactly as in code, and a nested `use` written in a comment counts.
test_boundary_members_in_comments_and_strings_are_rejected() {
  new_root boundary-raw || return 1
  PLANTED_LINES=""
  plant_line "$R" "$CORE_FILE" '// std::fs::write is not called here'
  plant_line "$R" "$CORE_FILE" 'const W: &str = "std::fs::write";'
  plant_line "$R" "$CORE_FILE" '// use std::{fs::{write}};'
  plant_line "$R" "$CORE_FILE" '/* .append(true) */'
  plant_line "$R" "$CORE_FILE" 'const RAW_WRITE: &str = r##"use std::{fs::{write}};"##;'
  expect_qc2="$PLANTED_LINES"
  PLANTED_LINES=""
  plant_line "$R" "$CORE_FILE" 'const E: &str = "std::env::var";'
  plant_line "$R" "$CORE_FILE" '// use std::{io, env::{var}};'
  plant_line "$R" "$CORE_FILE" 'const C: &str = r#"/home/x/.config/y"#;'
  plant_line "$R" "$CORE_FILE" '/* Library/Preferences */'
  plant_line "$R" "$CORE_FILE" 'const RAW_ENV: &str = r##"use std::{env::{var}};"##;'
  expect_env="$PLANTED_LINES"
  PLANTED_LINES=""
  plant_line "$R" "$CORE_FILE" '/* std::net::TcpStream */'
  plant_line "$R" "$CORE_FILE" 'const S: &str = "use std::{os::unix::{net}};";'
  plant_line "$R" "$CORE_FILE" 'const RAW_SOCKET: &str = r##"use std::{os::unix::{net}};"##;'
  expect_socket="$PLANTED_LINES"
  run_structure "$R"
  expect_status 1 || return 1
  PLANTED_LINES="$expect_qc2"
  expect_each "crates/$CORE_FILE" QC-2 || return 1
  PLANTED_LINES="$expect_env"
  expect_each "crates/$CORE_FILE" QC-30 QC-58 || return 1
  PLANTED_LINES="$expect_socket"
  expect_each "crates/$CORE_FILE" QC-15 QC-30 || return 1
}

test_bin_exe_under_tests_is_rejected() {
  new_root bin-exe || return 1
  plant "$R" "$CORE_TESTS_FILE" "$BIN_EXE_TEXT"
  core_line="$PLANT_LINE"
  plant "$R" "nozoki-bridge/tests/common/sub/deep.rs" "$BIN_EXE_TEXT"
  deep_line="$PLANT_LINE"
  plant "$R" "nozoki-extra/tests/t.rs" '// CARGO_BIN_EXE_x'
  comment_line="$PLANT_LINE"
  plant "$R" "nozoki-extra/tests/t.rs" 'let s = format!("CARGO_BIN_EXE_{}", n);'
  string_line="$PLANT_LINE"
  plant "$R" "nozoki-extra/tests/t.rs" 'let a = "CARGO_BIN_EXE_a"; let b = "CARGO_BIN_EXE_b";'
  twice_line="$PLANT_LINE"
  plant "$R" "nozoki-extra/tests/t.rs" 'let m = "MY_CARGO_BIN_EXE_X";'
  embedded_line="$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  expect_count "crates/$CORE_TESTS_FILE" "$core_line" layer-5 1 || return 1
  expect_count "crates/nozoki-bridge/tests/common/sub/deep.rs" "$deep_line" layer-5 1 || return 1
  for extra_line in "$comment_line" "$string_line" "$twice_line" "$embedded_line"; do
    expect_count "crates/nozoki-extra/tests/t.rs" "$extra_line" layer-5 1 || return 1
  done
}

test_bin_exe_outside_tests_passes() {
  new_root bin-exe-outside || return 1
  plant "$R" "$CORE_FILE" "$BIN_EXE_TEXT"
  plant "$R" "nozoki-core/src/tests/x.rs" "$BIN_EXE_TEXT"
  plant "$R" "nozoki-core/build.rs" "$BIN_EXE_TEXT"
  run_structure "$R"
  expect_status 0 || return 1
  expect_stderr_empty || return 1
}

# No rule but layer-5 reads crates/<c>/tests/: each breach alone, then every one together.
test_boundary_breaches_under_tests_pass() {
  breach_number=0
  for breach in \
    'fn f() { let _ = std::fs::write("x", "y"); }' \
    'fn f() { let _ = std::env::args(); }' \
    'fn f() { let _ = std::env::var("X"); }' \
    'fn f() { let _ = std::fs::read_to_string("/Users/a/.config/nozoki/settings.toml"); }' \
    'fn f() { let _ = std::net::TcpStream::connect("127.0.0.1:1"); }'; do
    breach_number=$((breach_number + 1))
    new_root "breach-under-tests-$breach_number" || return 1
    plant "$R" "$CORE_TESTS_FILE" "$breach"
    run_structure "$R"
    expect_status 0 || return 1
    expect_stderr_empty || return 1
  done
  new_root breach-under-tests-all || return 1
  plant "$R" "$CORE_TESTS_FILE" 'fn f() { unsafe {} }
fn g() { let _ = std::fs::write("x", "y"); let _ = std::env::var("X"); let _ = std::net::TcpStream::connect("a"); }'
  run_structure "$R"
  expect_status 0 || return 1
  expect_stderr_empty || return 1
}

# A test file the scan cannot read fails the run naming it, after every other file was read.
test_unreadable_test_file_fails() {
  new_root unreadable-test || return 1
  plant "$R" "$CORE_TESTS_FILE" 'fn f() {}'
  victim="crates/$CORE_TESTS_FILE"
  plant "$R" "$CORE_FILE" 'fn g() { unsafe {} }'
  shipped_line="$PLANT_LINE"
  chmod 000 "$R/$victim"
  if [ -r "$R/$victim" ]; then
    chmod 644 "$R/$victim"
    fail "this account can read a mode-000 file, so the case cannot make a file unreadable" || return 1
  fi
  run_structure "$R"
  chmod 644 "$R/$victim"
  expect_status 1 || return 1
  expect_stderr_contains "structure.sh: cannot read $victim" || return 1
  expect_finding "crates/$CORE_FILE" "$shipped_line" QC-9 || return 1
}

test_new_findings_join_one_report() {
  new_root one-report || return 1
  plant "$R" "$CORE_FILE" 'fn f() { let _ = std::fs::write("x", "y"); }'
  write_line="$PLANT_LINE"
  plant "$R" "$CORE_TESTS_FILE" "$BIN_EXE_TEXT"
  tests_line="$PLANT_LINE"
  # Findings of one file come out in numeric line order: lines 2 and 10 sort the other way as text.
  plant "$R" "nozoki-extra/tests/t.rs" 'fn filler_1() {}'
  plant "$R" "nozoki-extra/tests/t.rs" '// CARGO_BIN_EXE_a'
  for filler in 3 4 5 6 7 8 9; do
    plant "$R" "nozoki-extra/tests/t.rs" "fn filler_$filler() {}"
  done
  plant "$R" "nozoki-extra/tests/t.rs" '// CARGO_BIN_EXE_b'
  run_structure "$R"
  expect_status 1 || return 1
  expect_count "crates/$CORE_FILE" "$write_line" QC-2 1 || return 1
  expect_count "crates/$CORE_TESTS_FILE" "$tests_line" layer-5 1 || return 1
  expect_before "crates/$CORE_FILE:" "crates/$CORE_TESTS_FILE:" || return 1
  extra_order="$(printf '%s\n' "$STDERR" | grep ': layer-5: ' | grep 'nozoki-extra' | cut -d: -f1,2)"
  [ "$extra_order" = "crates/nozoki-extra/tests/t.rs:2
crates/nozoki-extra/tests/t.rs:10" ] || fail "layer-5 findings out of numeric line order: $extra_order" || return 1
  new_root one-line-clauses || return 1
  plant "$R" "$CORE_FILE" 'fn f() { let _ = std::env::var("X"); let _ = std::net::TcpStream::connect("a"); }'
  env_socket_line="$PLANT_LINE"
  plant "$R" "$CORE_FILE" 'fn g() { let _ = std::fs::read("x"); let _ = std::net::TcpStream::connect("a"); }'
  fs_socket_line="$PLANT_LINE"
  plant "$R" "$CORE_FILE" 'fn h() { let _ = std::env::var("A"); let _ = std::env::var("B"); let _ = std::env::args(); let _ = "/home/u/.config/x"; }'
  repeated_line="$PLANT_LINE"
  plant "$R" "$CORE_FILE" 'fn k() { let _ = std::fs::write("a", "b"); let _ = std::fs::remove_file("c"); }'
  writes_line="$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  expect_count "crates/$CORE_FILE" "$env_socket_line" QC-30 1 || return 1
  expect_count "crates/$CORE_FILE" "$env_socket_line" QC-58 1 || return 1
  expect_count "crates/$CORE_FILE" "$env_socket_line" QC-15 1 || return 1
  expect_count "crates/$CORE_FILE" "$fs_socket_line" QC-15 2 || return 1
  expect_count "crates/$CORE_FILE" "$repeated_line" QC-30 1 || return 1
  expect_count "crates/$CORE_FILE" "$repeated_line" QC-58 1 || return 1
  expect_count "crates/$CORE_FILE" "$writes_line" QC-2 1 || return 1
}

test_build_script_reads_stay_excluded() {
  new_root build-script || return 1
  plant "$R" "nozoki-core/build.rs" 'fn main() {
    let _ = std::env::var("X");
    let _ = std::env::args();
    let _ = std::fs::write("x", "y");
    let _ = std::net::TcpStream::connect("a");
}'
  run_structure "$R"
  expect_status 0 || return 1
  expect_stderr_empty || return 1
}

test_test_only_crate_does_not_change_shipped_counts() {
  new_root test-only-crate || return 1
  plant "$R" "nozoki-testonly/tests/t.rs" 'fn f() {}'
  [ -f "$R/crates/nozoki-testonly/tests/t.rs" ] || fail "the test-only crate was not planted" || return 1
  run_structure "$R"
  expect_status 0 || return 1
  expect_stderr_empty || return 1
  expected_counts "$R"
  case "$STDOUT" in
    *" $EXPECT_FILES Rust files in $EXPECT_CRATE_COUNT crates "*"nothing found"*) ;;
    *) fail "expected the shipped counts $EXPECT_FILES files and $EXPECT_CRATE_COUNT crates only. stdout: $STDOUT" || return 1 ;;
  esac
  case "$EXPECT_CRATES" in
    *nozoki-testonly*) fail "the test-only crate was counted as a shipped crate" || return 1 ;;
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

# Design B requires this after the last case, even when selection skipped the named case.
if result="$(test_originating_tree_is_unchanged 2>&1)"; then
  :
else
  echo "FAIL test_originating_tree_is_unchanged"
  [ -z "$result" ] || echo "$result"
  failed=$((failed + 1))
fi

if [ "$failed" -ne 0 ]; then
  echo "test_structure.sh: $failed case(s) failed" >&2
  exit 1
fi
