#!/usr/bin/env bash
# Version: 1.5.0 — the cases of QC-10's adapter, QC-11's git_reader, watcher and markdown_renderer
#   subjects, and QC-17's adapter construction
# Version: 1.4.0 — probe answers root for a git file; third QC-15 filesystem owner
# Version: 1.3.0 — structure.sh holds the value modules — QC-63 scan and its proof
# Version: 1.2.0 — structure.sh holds the boundary reads; fs_reader test body moves to tests/unit
# Version: 1.1.0 — fs_reader owns OpenFailure; structure.sh holds QC-11's fs-reader clause
# Version: 1.0.0 — first version: drives the real checks/structure.sh over copies of the
#   real crates/ with breaches planted
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
#   QC-15, QC-17, QC-30, QC-36, QC-58, QC-61 and QC-63, and layer-5, the placement rule that has no
#   QC number. Every identifier a case asserts is named in this block.
#
# USAGE
#   checks/tests/test_structure.sh
#   KA_READER_TEST_ONLY=<case> runs one case, and a name no case carries fails the run rather than
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
CORE_FILE="ka-reader-core/src/folder_model.rs"
BRIDGE_FILE="ka-reader-bridge/src/session.rs"

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
test_git_owner_filesystem_forms_give_no_qc15_finding
test_git_owner_write_is_still_one_qc2_finding
test_git_owner_other_rules_still_bind
test_exemption_is_exact_for_the_adapter_name
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
test_value_module_language_imports_a_unit_is_rejected
test_value_module_error_imports_a_unit_is_rejected
test_value_module_findings_count_per_unit
test_value_module_import_forms_are_rejected
test_value_module_reexports_are_read_on_every_run
test_value_module_domain_is_a_class
test_value_module_non_imports_pass
test_value_module_rule_spares_units_and_lib_rs
test_unit_file_draws_no_value_module_finding
test_value_module_findings_join_one_report
test_git2_in_a_bridge_src_file_is_refused
test_git2_in_ka_reader_core_lib_rs_is_refused
test_git2_in_machine_config_rs_is_allowed
test_git2_under_git_reader_is_allowed
test_folder_model_git2_stays_qc10_alone
test_fs_reader_git2_draws_one_qc11_line
test_git_reader_unit_edges_are_rejected
test_every_forbidden_pair_is_rejected
test_future_unit_files_are_judged_without_editing_the_scan
test_unit_edges_read_paths_and_trees_across_lines
test_own_unit_and_allowed_edges_stay_clean
test_binding_in_the_new_subjects
test_folder_model_adapter_name_is_rejected
test_folder_model_adapter_module_form_is_rejected
test_folder_model_allowed_git_port_forms_stay_clean
test_folder_model_adapter_findings_compose
test_adapter_construction_outside_bridge_is_rejected
test_adapter_type_positions_are_clean
test_adapter_compound_annotation_types_are_clean
test_adapter_construction_after_a_comparison_is_rejected
test_adapter_construction_in_comments_and_strings_is_ignored
test_bridge_source_may_construct_the_adapter
test_folder_model_adapter_construction_draws_both_clauses
test_header_states_the_held_clauses
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
  plant "$R" "ka-reader-extra/src/lib.rs" 'fn f() { unsafe {} }'
  [ ! -e "$R/crates/ka-reader-extra/Cargo.toml" ] || fail "the planted crate must have no manifest" || return 1
  run_structure "$R"
  expect_status 1 || return 1
  expect_finding "crates/ka-reader-extra/src/lib.rs" "$PLANT_LINE" QC-9
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
  plant "$R" "ka-reader-core/tests/planted.rs" 'fn f() { unsafe {} }'
  plant "$R" "ka-reader-core/build.rs" 'fn main() { unsafe {} }'
  plant "$R" "ka-reader-extra/tests/planted.rs" 'fn f() { unsafe {} }'
  run_structure "$R"
  expect_status 0 || return 1
  expect_stderr_empty || return 1
  new_root nested || return 1
  nested_files="ka-reader-core/src/tests/x.rs ka-reader-core/src/build.rs ka-reader-core/benches/x.rs ka-reader-core/examples/x.rs"
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
  victim="crates/ka-reader-core/src/error.rs"
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
  plant "$R" "ka-reader-b/src/lib.rs" 'fn ok() {}'
  plant "$R" "ka-reader-b/src/lib.rs" 'fn f() { unsafe {} }'
  b_first="$PLANT_LINE"
  for filler in 3 4 5 6 7 8 9; do
    plant "$R" "ka-reader-b/src/lib.rs" "fn filler_$filler() {}"
  done
  plant "$R" "ka-reader-b/src/lib.rs" 'fn g() { unsafe {} }'
  b_second="$PLANT_LINE"
  plant "$R" "$CORE_FILE" 'fn c() { unsafe {} }'
  core_line="$PLANT_LINE"
  plant "$R" "ka-reader-a/src/lib.rs" 'fn d() { unsafe { unsafe {} } }'
  a_line="$PLANT_LINE"
  # An unreadable file that sorts before every finding must not stop the later ones.
  plant "$R" "ka-reader-a/src/aa.rs" 'fn e() {}'
  chmod 000 "$R/crates/ka-reader-a/src/aa.rs"
  run_structure "$R"
  chmod 644 "$R/crates/ka-reader-a/src/aa.rs"
  expect_status 1 || return 1
  expect_stderr_contains "crates/ka-reader-a/src/aa.rs" || return 1
  [ "$b_first" -eq 2 ] && [ "$b_second" -eq 10 ] || fail "the fixture's lines are $b_first and $b_second, not 2 and 10" || return 1
  expected="crates/ka-reader-a/src/lib.rs:$a_line
crates/ka-reader-b/src/lib.rs:$b_first
crates/ka-reader-b/src/lib.rs:$b_second
crates/$CORE_FILE:$core_line"
  actual="$(printf '%s\n' "$STDERR" | grep ': QC-' | cut -d: -f1,2)"
  [ "$actual" = "$expected" ] || fail "findings out of order or not distinct. expected:
$expected
got:
$actual" || return 1
  [ "$(count_findings "crates/ka-reader-a/src/lib.rs" "$a_line" QC-9)" -eq 1 ] \
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
  selected="$(KA_READER_TEST_ONLY="$one" "$ROOT/checks/tests/test_structure.sh" 2>&1)"
  selected_status=$?
  [ "$selected_status" -eq 0 ] || fail "the selected case failed (exit $selected_status): $selected" || return 1
  [ "$selected" = "ok   $one" ] || fail "expected exactly 'ok   $one', got: $selected" || return 1
  unknown="$(KA_READER_TEST_ONLY=no_such_case "$ROOT/checks/tests/test_structure.sh" 2>&1)"
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

# The floor of QC-9's Apple clause: every one of these is refused in ka-reader-core in every form
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
  plant "$R" "ka-reader-extra/src/lib.rs" 'use block2::RcBlock;'
  plant "$R" "ka-reader-extra/src/lib.rs" '#[link(name = "CoreServices", kind = "framework")]'
  run_structure "$R"
  # QC-13 refuses an Apple name in the bridge. What this case still proves is that it is no QC-9
  # finding, and that a third crate raises nothing.
  expect_status 1 || return 1
  expect_finding "crates/$BRIDGE_FILE" "$objc_line" QC-13 || return 1
  expect_finding "crates/$BRIDGE_FILE" "$foundation_line" QC-13 || return 1
  expect_no_finding_for ": QC-9: " || return 1
  expect_no_finding_for "ka-reader-extra" || return 1
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
  plant "$R" "ka-reader-core/src/lib.rs" '/// never calls std::process'
  doc_line="$PLANT_LINE"
  plant "$R" "ka-reader-core/src/lib.rs" 'const NOTE: &str = "std::process";'
  string_line="$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  for text_line in "$doc_line" "$string_line"; do
    expect_finding "crates/ka-reader-core/src/lib.rs" "$text_line" QC-9 || return 1
    expect_finding "crates/ka-reader-core/src/lib.rs" "$text_line" QC-36 || return 1
  done
}

# src/tests/ and src/build.rs are in scope, so the rule reaches them.
test_nested_source_paths_are_scanned() {
  new_root nested-process || return 1
  for nested_file in ka-reader-core/src/tests/x.rs ka-reader-core/src/build.rs; do
    plant "$R" "$nested_file" 'use std::process::Command;'
  done
  run_structure "$R"
  expect_status 1 || return 1
  for nested_file in ka-reader-core/src/tests/x.rs ka-reader-core/src/build.rs; do
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

CORE_OWNER="ka-reader-core/src/fs_reader.rs"
BRIDGE_OWNER="ka-reader-bridge/src/log_writer.rs"
GIT_OWNER="ka-reader-core/src/git_reader/libgit2.rs"

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
  plant "$R" "ka-reader-core/tests/planted.rs" 'use objc2::runtime::AnyObject;
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
  plant "$R" "ka-reader-extra/src/lib.rs" 'fn f() { let _ = std::fs::read("x"); }'
  run_structure "$R"
  expect_status 1 || return 1
  expect_finding "crates/ka-reader-extra/src/lib.rs" "$PLANT_LINE" QC-15
}

# Exactly three files are exempt, only from QC-15: the same basenames anywhere else are not, and the
# other rules still apply inside an owner.
test_owner_exemption_is_exact_and_clause_specific() {
  new_root owners || return 1
  plant "$R" "$CORE_OWNER" 'fn f() { let _ = std::fs::write("x", "y"); let _ = std::os::unix::fs::symlink("a", "b"); let _ = rustix::fs::stat("x"); let _ = libc::open; }'
  core_owner_line="$PLANT_LINE"
  plant "$R" "$BRIDGE_OWNER" 'fn f() { let _ = std::fs::write("x", "y"); let _ = libc::unlink; }'
  plant "$R" "$GIT_OWNER" 'fn f() { let _ = std::fs::write("x", "y"); let _ = std::os::unix::fs::symlink("a", "b"); let _ = rustix::fs::stat("x"); let _ = libc::open; }'
  git_owner_line="$PLANT_LINE"
  run_structure "$R"
  # QC-2 binds ka-reader-core with no exemption, so each core owner's write is one QC-2 finding. The
  # owner exemption is QC-15's alone: no QC-15 there, and the bridge owner (outside QC-2) is clean.
  expect_status 1 || return 1
  expect_count "crates/$CORE_OWNER" "$core_owner_line" QC-2 1 || return 1
  expect_count "crates/$CORE_OWNER" "$core_owner_line" QC-15 0 || return 1
  expect_count "crates/$GIT_OWNER" "$git_owner_line" QC-2 1 || return 1
  expect_count "crates/$GIT_OWNER" "$git_owner_line" QC-15 0 || return 1
  [ "$(stderr_lines_with "crates/$BRIDGE_OWNER:")" -eq 0 ] || fail "the bridge owner is outside QC-2 and exempt from QC-15: $STDERR" || return 1
  [ "$(printf '%s\n' "$STDERR" | grep -c .)" -eq 2 ] || fail "expected the two QC-2 findings, one per core owner, and nothing else: $STDERR" || return 1
  new_root owners-elsewhere || return 1
  elsewhere="ka-reader-core/src/sub/fs_reader.rs ka-reader-bridge/src/fs_reader.rs ka-reader-core/src/log_writer.rs ka-reader-bridge/src/sub/log_writer.rs ka-reader-extra/src/fs_reader.rs ka-reader-extra/src/log_writer.rs"
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

# The adapter's file is the third QC-15 filesystem owner: every filesystem form the clause names is
# no finding there. This is the case that goes red while the owner list holds two files.
test_git_owner_filesystem_forms_give_no_qc15_finding() {
  new_root git-owner-forms || return 1
  plant "$R" "$GIT_OWNER" 'fn f() { let _ = std::fs::read("x"); }'
  plant "$R" "$GIT_OWNER" 'fn g() { let _ = std::os::unix::fs::symlink("a", "b"); }'
  plant "$R" "$GIT_OWNER" 'fn h() { let _ = rustix::fs::stat("x"); }'
  plant "$R" "$GIT_OWNER" 'fn i() { let _ = libc::open; }'
  run_structure "$R"
  [ "$(count_identifier QC-15)" -eq 0 ] || fail "the adapter owner is exempt from QC-15, so none of its reads is a finding. stderr: $STDERR" || return 1
}

# The exemption covers QC-15 alone: a write in the adapter owner is still one QC-2 finding.
test_git_owner_write_is_still_one_qc2_finding() {
  new_root git-owner-write || return 1
  plant "$R" "$GIT_OWNER" 'fn f() { let _ = std::fs::write("x", "y"); }'
  git_write_line="$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  expect_count "crates/$GIT_OWNER" "$git_write_line" QC-2 1 || return 1
  expect_count "crates/$GIT_OWNER" "$git_write_line" QC-15 0 || return 1
  [ "$(printf '%s\n' "$STDERR" | grep -c .)" -eq 1 ] || fail "expected the one QC-2 finding and nothing else: $STDERR" || return 1
}

# The other rules still bind inside the adapter owner.
test_git_owner_other_rules_still_bind() {
  new_root git-owner-other-rules || return 1
  plant "$R" "$GIT_OWNER" 'fn f() { unsafe {} }'
  git_unsafe_line="$PLANT_LINE"
  plant "$R" "$GIT_OWNER" 'use std::process::Command;'
  git_process_line="$PLANT_LINE"
  plant "$R" "$GIT_OWNER" 'use objc2::runtime::AnyObject;'
  git_apple_line="$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  expect_finding "crates/$GIT_OWNER" "$git_unsafe_line" QC-9 || return 1
  expect_finding "crates/$GIT_OWNER" "$git_process_line" QC-36 || return 1
  expect_finding "crates/$GIT_OWNER" "$git_apple_line" QC-9 || return 1
  [ "$(count_identifier QC-15)" -eq 0 ] || fail "the owner is exempt from QC-15 and nothing else. stderr: $STDERR" || return 1
}

# The match is by exact path: the rest of git-reader, and the adapter's name anywhere else, is not
# exempt.
test_exemption_is_exact_for_the_adapter_name() {
  new_root git-owner-elsewhere || return 1
  adapter_elsewhere="ka-reader-core/src/git_reader.rs ka-reader-core/src/libgit2.rs ka-reader-core/src/git_reader/sub/libgit2.rs ka-reader-core/src/sub/git_reader/libgit2.rs ka-reader-bridge/src/git_reader/libgit2.rs ka-reader-extra/src/git_reader/libgit2.rs"
  for adapter_file in $adapter_elsewhere; do
    plant "$R" "$adapter_file" 'fn f() { let _ = std::fs::write("x", "y"); }'
    adapter_plant_line="$PLANT_LINE"
    run_structure "$R"
    expect_status 1 || return 1
    expect_finding "crates/$adapter_file" "$adapter_plant_line" QC-15 || return 1
  done
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
  grep -q 'unsafe' "$R"/crates/ka-reader-bridge/src/*.rs || fail "the copy no longer holds the bridge's unsafe" || return 1
  grep -q 'std::fs' "$R/crates/$CORE_OWNER" || fail "the copy no longer holds the core owner's filesystem module" || return 1
  grep -q 'std::fs' "$R/crates/$BRIDGE_OWNER" || fail "the copy no longer holds the bridge owner's filesystem module" || return 1
  grep -q 'include_str!' "$R/crates/ka-reader-core/src/highlighter.rs" || fail "the copy no longer holds highlighter.rs's include_str!" || return 1
  grep -q 'libc::getpwuid_r' "$R/crates/ka-reader-bridge/src/log_install.rs" || fail "the copy no longer holds log_install.rs's getpwuid_r" || return 1
  [ -d "$R/crates/ka-reader-core/tests" ] || fail "the copy no longer holds the excluded tests/ files" || return 1
  grep -q '\.read(true)' "$R/crates/$CORE_OWNER" || fail "the copy no longer holds the core owner's read-only open" || return 1
  grep -q 'std::env::current_exe' "$R/crates/ka-reader-bridge/src/log_install.rs" || fail "the copy no longer holds log_install.rs's current_exe" || return 1
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
  expect_stderr_contains 'std::process named in ka-reader-core' || return 1
}

# CP-393 and design B require the status comparison after the last case, including selection.
# The negative control dirties only a disposable origin, never this suite's real origin.
test_suite_checks_origin_after_selected_case() {
  new_root origin-control || return 1
  mkdir -p "$R/checks/tests" || return 1
  cp "$ROOT/checks/tests/test_structure.sh" "$R/checks/tests/test_structure.sh" || return 1
  git -C "$R" init -q || return 1
  printf '\ntouch %q\n' "$R/unexpected" >> "$R/checks/structure.sh"
  selected="$(KA_READER_TEST_ONLY=test_clean_copy_passes "$R/checks/tests/test_structure.sh" 2>&1)"
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
  for required in checks/deps.allow crates/ka-reader-core/Cargo.toml crates/ka-reader-bridge/Cargo.toml; do
    [ -r "$R/$required" ] || fail "the copy carries no readable $required" || return 1
  done
  cmp -s "$ROOT/checks/deps.allow" "$R/checks/deps.allow" \
    || fail "the copy's checks/deps.allow differs from the originating tree's" || return 1
  printf '\n# a comment between entries\n\nzzz-listed\n' >> "$R/checks/deps.allow"
  plant "$R" "ka-reader-bridge/src/boundary.rs" 'mod sibling_module;'
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
  plant "$R" "ka-reader-extra/src/lib.rs" 'use objc2::runtime::AnyObject;'
  run_structure "$R"
  expect_status 0 || return 1
  expect_stderr_empty || return 1
}

# --- the cases of the unit-graph change: unit edges, the bridge's import set, the shipped manifests
# and the logger clause ---

HL_FILE="ka-reader-core/src/highlighter.rs"
FS_FILE="ka-reader-core/src/fs_reader.rs"
LANG_FILE="ka-reader-core/src/language.rs"
CORE_MANIFEST="ka-reader-core/Cargo.toml"
BRIDGE_MANIFEST="ka-reader-bridge/Cargo.toml"

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
  plant "$R" "$CORE_FILE" 'fn n() { self::own_state::x(); ka_reader_core::own_state::y(); let own_state = 1; let _ = own_state; }'
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
  plant "$R" "ka-reader-core/src/highlighter/extra.rs" 'use crate::fs_reader::Entry;'
  extra_line="$PLANT_LINE"
  plant "$R" "ka-reader-core/src/highlighter/deep/more.rs" 'use crate::folder_model::Thing;'
  deep_line="$PLANT_LINE"
  plant "$R" "ka-reader-core/src/highlighter_ext.rs" 'use crate::fs_reader::Entry;'
  ext_line="$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  for hit_line in $hit_lines; do
    expect_finding "crates/$HL_FILE" "$hit_line" QC-11 || return 1
  done
  expect_count "crates/$HL_FILE" "$two_line" QC-11 2 || return 1
  expect_count "crates/$HL_FILE" "$duplicate_line" QC-11 1 || return 1
  expect_finding_naming "crates/$HL_FILE" "$two_line" QC-11 "fs_reader" || return 1
  expect_finding_naming "crates/$HL_FILE" "$two_line" QC-11 "watcher" || return 1
  expect_finding "crates/ka-reader-core/src/highlighter/extra.rs" "$extra_line" QC-11 || return 1
  expect_finding "crates/ka-reader-core/src/highlighter/deep/more.rs" "$deep_line" QC-11 || return 1
  # A prefix-named file is no unit's file: no QC-10/QC-11 there, and
  # the value-module rule reports it.
  expect_no_unit_rule "crates/ka-reader-core/src/highlighter_ext.rs" "$ext_line" || return 1
  expect_qc63_once "crates/ka-reader-core/src/highlighter_ext.rs" "$ext_line" "fs_reader" || return 1
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
  plant "$R" "ka-reader-core/src/lib.rs" 'pub use crate::{
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
  plant "$R" "ka-reader-core/src/lib.rs" 'pub use fs_reader::{NewThing, Entry as Renamed};'
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
  plant "$R" "ka-reader-core/src/fs_reader/extra.rs" 'use crate::folder_model::OpenFailure;'
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
  expect_count "crates/ka-reader-core/src/fs_reader/extra.rs" "$extra_line" QC-11 1 || return 1
  printf '%s\n' "$STDERR" | grep -Fx "crates/ka-reader-core/src/fs_reader/extra.rs:$extra_line: QC-11: fs_reader imports folder_model" > /dev/null ||
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
  expect_finding_naming "crates/$BRIDGE_MANIFEST" "$package_line" QC-14 "ka-reader-bridge" || return 1
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
  plant "$R" "ka-reader-core/src/highlighter/zz.rs" '// one
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
  expect_before "crates/ka-reader-core/src/highlighter/zz.rs:$second_line: " "crates/ka-reader-core/src/highlighter/zz.rs:$tenth_line: " || return 1
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
  plant "$R" "ka-reader-core/examples/x.rs" 'log::set_logger(&W);'
  hit_lines="$hit_lines ka-reader-core/examples/x.rs:$PLANT_LINE"
  plant "$R" "$CORE_FILE" 'use log::{info, set_logger};'
  hit_lines="$hit_lines $CORE_FILE:$PLANT_LINE"
  plant "$R" "$CORE_FILE" 'use log::{
    warn,
    set_logger,
};'
  hit_lines="$hit_lines $CORE_FILE:$((PLANT_LINE + 2))"
  plant "$R" "ka-reader-bridge/src_old/y.rs" 'fn y() { log::set_logger(&W); }'
  hit_lines="$hit_lines ka-reader-bridge/src_old/y.rs:$PLANT_LINE"
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
  plant "$R" "ka-reader-bridge/examples/x.rs" 'log::set_boxed_logger(Box::new(W));'
  hit_lines="$hit_lines ka-reader-bridge/examples/x.rs:$PLANT_LINE"
  plant "$R" "$FS_FILE" 'use log::set_boxed_logger as boxed;'
  hit_lines="$hit_lines $FS_FILE:$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  for hit in $hit_lines; do
    expect_count "crates/${hit%:*}" "${hit##*:}" QC-17 1 || return 1
    expect_count "crates/${hit%:*}" "${hit##*:}" QC-61 1 || return 1
  done
  new_root set-boxed-logger-clean || return 1
  plant "$R" "ka-reader-bridge/src/inner/deep.rs" 'fn i() { log::set_boxed_logger(Box::new(W)); }
use log::set_logger as install;'
  run_structure "$R"
  expect_status 0 || return 1
  expect_stderr_empty || return 1
}

# CP-430 row 14. Each required input, absent or unreadable, is named once, and every other file is
# still read before the verdict.
test_required_inputs_are_read() {
  missing_index=0
  for required in checks/deps.allow crates/ka-reader-core/Cargo.toml crates/ka-reader-bridge/Cargo.toml; do
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
  plant "$R" "$HL_FILE" '//! see ka_reader_core::Entry and ka_reader_core::folder_model::FileView'
  plant "$R" "$HL_FILE" 'fn near() { let fs_reader = 1; let _ = fs_reader; self::watcher::x(); }'
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
round = { path = "../../checks/../crates/ka-reader-core" }
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

CORE_TESTS_FILE="ka-reader-core/tests/planted.rs"
BIN_EXE_TEXT='let exe = env!("CARGO_BIN_EXE_ka_reader");'

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
  plant "$R" "ka-reader-extra/src/lib.rs" 'fn f() { let _ = std::fs::write("x", "y"); }'
  extra_line="$PLANT_LINE"
  plant "$R" "ka-reader-core/src/own_state.rs" 'fn f() { let _ = std::fs::write("x", "y"); }'
  own_state_line="$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  expect_count "crates/$CORE_FILE" "$core_line" QC-2 1 || return 1
  expect_count "crates/$CORE_FILE" "$core_line" QC-15 1 || return 1
  expect_count "crates/$BRIDGE_FILE" "$bridge_line" QC-2 0 || return 1
  expect_count "crates/$BRIDGE_FILE" "$bridge_line" QC-15 1 || return 1
  expect_count "crates/ka-reader-extra/src/lib.rs" "$extra_line" QC-2 0 || return 1
  expect_count "crates/ka-reader-core/src/own_state.rs" "$own_state_line" QC-2 1 || return 1
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
  plant "$R" "ka-reader-extra/src/lib.rs" 'fn f() { let _ = std::env::args_os(); }'
  run_structure "$R"
  expect_status 1 || return 1
  expect_count "crates/ka-reader-extra/src/lib.rs" "$PLANT_LINE" QC-30 1 || return 1
  expect_count "crates/ka-reader-extra/src/lib.rs" "$PLANT_LINE" QC-58 1 || return 1
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
  plant "$R" "$CORE_OWNER" 'fn f() { let _ = std::fs::read_to_string("/Users/a/.config/ka-reader/settings.toml"); }'
  owner_line="$PLANT_LINE"
  PLANTED_LINES=""
  plant_line "$R" "$BRIDGE_FILE" 'const C1_PATH: &str = "/home/u/.config/ka-reader";'
  plant_line "$R" "$BRIDGE_FILE" 'const C1_END: &str = "/home/u/.config";'
  plant_line "$R" "$BRIDGE_FILE" 'const C2: &str = "Library/Preferences/ka-reader.plist";'
  plant_line "$R" "$BRIDGE_FILE" 'const C3: &str = "/etc/ka-reader.conf";'
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
  plant "$R" "ka-reader-bridge/tests/common/sub/deep.rs" "$BIN_EXE_TEXT"
  deep_line="$PLANT_LINE"
  plant "$R" "ka-reader-extra/tests/t.rs" '// CARGO_BIN_EXE_x'
  comment_line="$PLANT_LINE"
  plant "$R" "ka-reader-extra/tests/t.rs" 'let s = format!("CARGO_BIN_EXE_{}", n);'
  string_line="$PLANT_LINE"
  plant "$R" "ka-reader-extra/tests/t.rs" 'let a = "CARGO_BIN_EXE_a"; let b = "CARGO_BIN_EXE_b";'
  twice_line="$PLANT_LINE"
  plant "$R" "ka-reader-extra/tests/t.rs" 'let m = "MY_CARGO_BIN_EXE_X";'
  embedded_line="$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  expect_count "crates/$CORE_TESTS_FILE" "$core_line" layer-5 1 || return 1
  expect_count "crates/ka-reader-bridge/tests/common/sub/deep.rs" "$deep_line" layer-5 1 || return 1
  for extra_line in "$comment_line" "$string_line" "$twice_line" "$embedded_line"; do
    expect_count "crates/ka-reader-extra/tests/t.rs" "$extra_line" layer-5 1 || return 1
  done
}

test_bin_exe_outside_tests_passes() {
  new_root bin-exe-outside || return 1
  plant "$R" "$CORE_FILE" "$BIN_EXE_TEXT"
  plant "$R" "ka-reader-core/src/tests/x.rs" "$BIN_EXE_TEXT"
  plant "$R" "ka-reader-core/build.rs" "$BIN_EXE_TEXT"
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
    'fn f() { let _ = std::fs::read_to_string("/Users/a/.config/ka-reader/settings.toml"); }' \
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
  plant "$R" "ka-reader-extra/tests/t.rs" 'fn filler_1() {}'
  plant "$R" "ka-reader-extra/tests/t.rs" '// CARGO_BIN_EXE_a'
  for filler in 3 4 5 6 7 8 9; do
    plant "$R" "ka-reader-extra/tests/t.rs" "fn filler_$filler() {}"
  done
  plant "$R" "ka-reader-extra/tests/t.rs" '// CARGO_BIN_EXE_b'
  run_structure "$R"
  expect_status 1 || return 1
  expect_count "crates/$CORE_FILE" "$write_line" QC-2 1 || return 1
  expect_count "crates/$CORE_TESTS_FILE" "$tests_line" layer-5 1 || return 1
  expect_before "crates/$CORE_FILE:" "crates/$CORE_TESTS_FILE:" || return 1
  extra_order="$(printf '%s\n' "$STDERR" | grep ': layer-5: ' | grep 'ka-reader-extra' | cut -d: -f1,2)"
  [ "$extra_order" = "crates/ka-reader-extra/tests/t.rs:2
crates/ka-reader-extra/tests/t.rs:10" ] || fail "layer-5 findings out of numeric line order: $extra_order" || return 1
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
  plant "$R" "ka-reader-core/build.rs" 'fn main() {
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
  plant "$R" "ka-reader-testonly/tests/t.rs" 'fn f() {}'
  [ -f "$R/crates/ka-reader-testonly/tests/t.rs" ] || fail "the test-only crate was not planted" || return 1
  run_structure "$R"
  expect_status 0 || return 1
  expect_stderr_empty || return 1
  expected_counts "$R"
  case "$STDOUT" in
    *" $EXPECT_FILES Rust files in $EXPECT_CRATE_COUNT crates "*"nothing found"*) ;;
    *) fail "expected the shipped counts $EXPECT_FILES files and $EXPECT_CRATE_COUNT crates only. stdout: $STDOUT" || return 1 ;;
  esac
  case "$EXPECT_CRATES" in
    *ka-reader-testonly*) fail "the test-only crate was counted as a shipped crate" || return 1 ;;
  esac
}

# --- QC-63: a file of no unit imports no unit ---

VALUE_ERROR_FILE="ka-reader-core/src/error.rs"

# No QC-10 and no QC-11 finding at path $1, line $2.
expect_no_unit_rule() {
  expect_count "$1" "$2" QC-10 0 || return 1
  expect_count "$1" "$2" QC-11 0
}

# Exactly one QC-63 finding at path $1, line $2, naming the unit $3, and no QC-10/QC-11 there.
expect_qc63_once() {
  expect_count "$1" "$2" QC-63 1 || return 1
  expect_finding_naming "$1" "$2" QC-63 "value module imports $3" || return 1
  expect_no_unit_rule "$1" "$2"
}

# CP-479 row 1.
test_value_module_language_imports_a_unit_is_rejected() {
  new_root value-module-language || return 1
  plant "$R" "$LANG_FILE" 'use crate::fs_reader::FsReader;'
  run_structure "$R"
  expect_status 1 || return 1
  expect_qc63_once "crates/$LANG_FILE" "$PLANT_LINE" "fs_reader" || return 1
}

# CP-479 row 2.
test_value_module_error_imports_a_unit_is_rejected() {
  new_root value-module-error || return 1
  plant "$R" "$VALUE_ERROR_FILE" 'use crate::fs_reader::FsReader;'
  run_structure "$R"
  expect_status 1 || return 1
  expect_qc63_once "crates/$VALUE_ERROR_FILE" "$PLANT_LINE" "fs_reader" || return 1
}

# CP-472, CP-481: one finding per (file, line, unit), across the scanner's two passes.
test_value_module_findings_count_per_unit() {
  new_root value-module-count || return 1
  plant "$R" "$VALUE_ERROR_FILE" 'use crate::highlighter::Span; use crate::fs_reader::Entry;'
  two_line="$PLANT_LINE"
  plant "$R" "$LANG_FILE" 'fn d() { crate::fs_reader::a(); crate::fs_reader::b(); }'
  repeated_line="$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  expect_count "crates/$VALUE_ERROR_FILE" "$two_line" QC-63 2 || return 1
  expect_finding_naming "crates/$VALUE_ERROR_FILE" "$two_line" QC-63 "value module imports highlighter" || return 1
  expect_finding_naming "crates/$VALUE_ERROR_FILE" "$two_line" QC-63 "value module imports fs_reader" || return 1
  expect_no_unit_rule "crates/$VALUE_ERROR_FILE" "$two_line" || return 1
  expect_qc63_once "crates/$LANG_FILE" "$repeated_line" "fs_reader" || return 1
}

# CP-471, CP-472: every import form the unit-graph scan reads, on its own line.
test_value_module_import_forms_are_rejected() {
  new_root value-module-forms || return 1
  error_path="crates/$VALUE_ERROR_FILE"
  lang_path="crates/$LANG_FILE"
  plant "$R" "$LANG_FILE" 'mod t { use super::super::folder_model::FileView; }'
  super_line="$PLANT_LINE"
  plant "$R" "ka-reader-core/src/paths.rs" 'use crate::Entry;'
  reexport_line="$PLANT_LINE"
  plant "$R" "$VALUE_ERROR_FILE" 'use crate::{
    fs_reader::Entry,
    highlighter::Span,
};'
  tree_start="$PLANT_LINE"
  plant "$R" "$LANG_FILE" 'fn w() { crate :: watcher :: x(); }'
  spaced_line="$PLANT_LINE"
  plant "$R" "$VALUE_ERROR_FILE" '// crate::own_state'
  comment_line="$PLANT_LINE"
  plant "$R" "$VALUE_ERROR_FILE" 'const S: &str = "crate::markdown_renderer";'
  string_line="$PLANT_LINE"
  plant "$R" "$LANG_FILE" 'mod g { use super::super::{folder_model::FileView}; }'
  grouped_super_line="$PLANT_LINE"
  plant "$R" "$VALUE_ERROR_FILE" 'fn h() { crate
    ::
    fs_reader
    ::
    Entry(); }'
  newline_line=$((PLANT_LINE + 2))
  plant "$R" "$LANG_FILE" 'use crate::git_reader::State;'
  no_file_line="$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  expect_qc63_once "$lang_path" "$super_line" "folder_model" || return 1
  expect_qc63_once "crates/ka-reader-core/src/paths.rs" "$reexport_line" "fs_reader" || return 1
  expect_qc63_once "$error_path" $((tree_start + 1)) "fs_reader" || return 1
  expect_qc63_once "$error_path" $((tree_start + 2)) "highlighter" || return 1
  expect_count "$error_path" "$tree_start" QC-63 0 || return 1
  expect_qc63_once "$lang_path" "$spaced_line" "watcher" || return 1
  expect_qc63_once "$error_path" "$comment_line" "own_state" || return 1
  expect_qc63_once "$error_path" "$string_line" "markdown_renderer" || return 1
  expect_qc63_once "$lang_path" "$grouped_super_line" "folder_model" || return 1
  expect_qc63_once "$error_path" "$newline_line" "fs_reader" || return 1
  expect_qc63_once "$lang_path" "$no_file_line" "git_reader" || return 1
}

# CP-471: lib.rs is read on every run, so a re-export that changes target changes the finding.
test_value_module_reexports_are_read_on_every_run() {
  new_root value-module-live-reexport || return 1
  lib_rs="$R/crates/ka-reader-core/src/lib.rs"
  paths_path="crates/ka-reader-core/src/paths.rs"
  plant "$R" "ka-reader-core/src/lib.rs" 'pub use crate::fs_reader::Entry as ValueBoundaryProbe;'
  plant "$R" "ka-reader-core/src/paths.rs" 'use crate::ValueBoundaryProbe;'
  probe_line="$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  expect_qc63_once "$paths_path" "$probe_line" "fs_reader" || return 1
  expect_stderr_has_no_line_starting "crates/ka-reader-core/src/lib.rs:" || return 1
  grep -v -F 'as ValueBoundaryProbe' "$lib_rs" > "$WORK/lib.rs.next" || return 1
  cp "$WORK/lib.rs.next" "$lib_rs" || return 1
  plant "$R" "ka-reader-core/src/lib.rs" 'pub use crate::highlighter::Span as ValueBoundaryProbe;'
  run_structure "$R"
  expect_status 1 || return 1
  expect_qc63_once "$paths_path" "$probe_line" "highlighter" || return 1
  expect_count "$paths_path" "$probe_line" QC-63 1 || return 1
  case "$STDERR" in
    *"value module imports fs_reader"*) fail "the replaced re-export still drew a finding naming fs_reader. stderr: $STDERR" || return 1 ;;
  esac
  expect_stderr_has_no_line_starting "crates/ka-reader-core/src/lib.rs:" || return 1
}

# No stderr line starts with the text $1.
expect_stderr_has_no_line_starting() {
  while IFS= read -r stderr_line; do
    case "$stderr_line" in
      "$1"*) fail "expected no stderr line starting $1. stderr: $STDERR" || return 1 ;;
    esac
  done <<< "$STDERR"
}

# CP-470: the domain is a class of paths, not a list of today's files.
test_value_module_domain_is_a_class() {
  new_root value-module-domain || return 1
  for member in language/x.rs tests/x.rs x/lib.rs lib/x.rs; do
    plant "$R" "ka-reader-core/src/$member" 'use crate::fs_reader::Entry;'
  done
  run_structure "$R"
  expect_status 1 || return 1
  for member in language/x.rs tests/x.rs x/lib.rs lib/x.rs; do
    expect_qc63_once "crates/ka-reader-core/src/$member" 1 "fs_reader" || return 1
  done
}

# CP-471's exclusions and CP-473: a clean case.
test_value_module_non_imports_pass() {
  new_root value-module-non-imports || return 1
  plant "$R" "$VALUE_ERROR_FILE" 'use crate::language::Language;'
  plant "$R" "$VALUE_ERROR_FILE" '// see fs_reader and ka_reader_core::fs_reader'
  plant "$R" "$VALUE_ERROR_FILE" 'fn e() -> Option<crate::Error> { None }'
  plant "$R" "$LANG_FILE" 'use self::fs_reader::Entry;'
  plant "$R" "$LANG_FILE" 'fn n() { let fs_reader = 1; let _ = fs_reader; }'
  run_structure "$R"
  expect_status 0 || return 1
  expect_stderr_empty || return 1
}

# CP-480 (a) and (c), CP-473, CP-474: a clean case. A file of every unit, in file and directory form,
# draws no QC-63 finding for naming a unit, and lib.rs and every file outside QC-63's domain may name
# one. The git_reader and watcher files name their own unit, the one unit their QC-11 sets allow.
test_value_module_rule_spares_units_and_lib_rs() {
  new_root value-module-spared || return 1
  plant "$R" "$FS_FILE" 'use crate::language::Language;'
  plant "$R" "ka-reader-core/src/lib.rs" 'pub use crate::fs_reader::Entry;'
  for unit in own_state markdown_renderer; do
    plant "$R" "ka-reader-core/src/$unit.rs" 'use crate::fs_reader::Entry;'
    plant "$R" "ka-reader-core/src/$unit/x.rs" 'use crate::fs_reader::Entry;'
  done
  for unit in git_reader watcher; do
    plant "$R" "ka-reader-core/src/$unit.rs" "use crate::$unit::Item;"
    plant "$R" "ka-reader-core/src/$unit/x.rs" "use crate::$unit::Item;"
  done
  plant "$R" "ka-reader-core/tests/common/mod.rs" 'use crate::fs_reader::Entry;'
  plant "$R" "ka-reader-core/examples/x.rs" 'use crate::fs_reader::Entry;'
  plant "$R" "ka-reader-core/build.rs" 'use crate::fs_reader::Entry;'
  plant "$R" "ka-reader-bridge/src/x.rs" 'use crate::fs_reader::Entry;'
  run_structure "$R"
  expect_status 0 || return 1
  expect_stderr_empty || return 1
}

# CP-474: a file of a unit is judged by QC-10/QC-11 alone.
test_unit_file_draws_no_value_module_finding() {
  new_root unit-file-no-qc63 || return 1
  plant "$R" "$HL_FILE" 'use crate::folder_model::FileView;'
  run_structure "$R"
  expect_status 1 || return 1
  expect_count "crates/$HL_FILE" "$PLANT_LINE" QC-11 1 || return 1
  expect_finding_naming "crates/$HL_FILE" "$PLANT_LINE" QC-11 "highlighter imports folder_model" || return 1
  case "$STDERR" in
    *QC-63*) fail "expected no QC-63 finding for a file of a unit. stderr: $STDERR" || return 1 ;;
  esac
}

# CP-472: the QC-63 findings join the one report, in the order every finding is sorted in.
test_value_module_findings_join_one_report() {
  new_root value-module-report || return 1
  plant "$R" "$VALUE_ERROR_FILE" 'use std::fs; use crate::fs_reader::Entry;'
  error_line="$PLANT_LINE"
  plant "$R" "$CORE_FILE" 'fn f() { unsafe {} }'
  unsafe_line="$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  expect_finding "crates/$VALUE_ERROR_FILE" "$error_line" QC-15 || return 1
  expect_qc63_once "crates/$VALUE_ERROR_FILE" "$error_line" "fs_reader" || return 1
  expect_finding "crates/$CORE_FILE" "$unsafe_line" QC-9 || return 1
  expect_before "crates/$VALUE_ERROR_FILE:$error_line: QC-15: " "crates/$VALUE_ERROR_FILE:$error_line: QC-63: " || return 1
  expect_before "crates/$VALUE_ERROR_FILE:$error_line: QC-63: " "crates/$CORE_FILE:$unsafe_line: " || return 1
}

# --- the cases of QC-11's only-git-reader clause (CP-647 to CP-651) ---

# CP-647, CP-650: a bridge src file other than the switch's file naming the binding is refused. The
# libgit2 floor's subject was empty for a file no rule maps, so this drew nothing before the clause.
test_git2_in_a_bridge_src_file_is_refused() {
  new_root git2-bridge-src || return 1
  plant "$R" "$BRIDGE_FILE" 'fn g() { git2::Repository::open("."); }'
  run_structure "$R"
  expect_status 1 || return 1
  expect_finding_naming "crates/$BRIDGE_FILE" "$PLANT_LINE" QC-11 "git2" || return 1
}

# CP-647, CP-650: a core file of no unit (lib.rs is one) is refused the same way.
test_git2_in_ka_reader_core_lib_rs_is_refused() {
  new_root git2-core-lib || return 1
  plant "$R" "ka-reader-core/src/lib.rs" 'use git2 as _x;'
  run_structure "$R"
  expect_status 1 || return 1
  expect_finding_naming "crates/ka-reader-core/src/lib.rs" "$PLANT_LINE" QC-11 "git2" || return 1
}

# CP-647's first exemption: core-bridge's search-path switch, the one
# file of the bridge that names it.
test_git2_in_machine_config_rs_is_allowed() {
  new_root git2-machine-config || return 1
  plant "$R" "ka-reader-bridge/src/machine_config.rs" 'use git2 as _x;'
  run_structure "$R"
  expect_status 0 || return 1
  expect_stderr_empty || return 1
}

# CP-647's second exemption: every file of the git_reader unit, its
# own file and the ones beneath it.
test_git2_under_git_reader_is_allowed() {
  new_root git2-git-reader || return 1
  plant "$R" "ka-reader-core/src/git_reader.rs" 'use git2 as _x;'
  plant "$R" "ka-reader-core/src/git_reader/config_scan.rs" 'use git2 as _x;'
  plant "$R" "ka-reader-core/src/git_reader/deep/more.rs" 'use libgit2_sys as _y;'
  run_structure "$R"
  expect_status 0 || return 1
  expect_stderr_empty || return 1
}

# CP-648: a folder_model file keeps the one QC-10 finding it drew before, and the
# clause adds no QC-11 beside it.
test_folder_model_git2_stays_qc10_alone() {
  new_root git2-folder-model || return 1
  plant "$R" "$CORE_FILE" 'use git2 as _x;'
  run_structure "$R"
  expect_status 1 || return 1
  expect_count "crates/$CORE_FILE" "$PLANT_LINE" QC-10 1 || return 1
  expect_count "crates/$CORE_FILE" "$PLANT_LINE" QC-11 0 || return 1
}

# CP-648: an fs_reader file draws one QC-11 line, because the clause and
# the unit's own rule share a key.
test_fs_reader_git2_draws_one_qc11_line() {
  new_root git2-fs-reader || return 1
  plant "$R" "$FS_FILE" 'use git2 as _x;'
  run_structure "$R"
  expect_status 1 || return 1
  expect_count "crates/$FS_FILE" "$PLANT_LINE" QC-11 1 || return 1
  expect_count "crates/$FS_FILE" "$PLANT_LINE" QC-10 0 || return 1
}

# --- the cases of QC-10's adapter, QC-11's git_reader, watcher and markdown_renderer subjects, and
# QC-17's adapter construction ---

SRC="ka-reader-core/src"

# One QC-11 line at $2 of $1, and it names the edge $3.
expect_edge() {
  expect_count "crates/$1" "$2" QC-11 1 || return 1
  expect_finding_naming "crates/$1" "$2" QC-11 "$3" || return 1
}

# QC-11 for git_reader. An import of each unit its set forbids is one finding naming that unit, in
# the unit's own file and in a file under it, on its own line, and through an item lib.rs re-
# exports.
test_git_reader_unit_edges_are_rejected() {
  new_root git-reader-edges || return 1
  for file in git_reader.rs git_reader/config_scan.rs; do
    plant "$R" "$SRC/$file" 'use crate::folder_model::FolderModel;'
    edge_folder="$PLANT_LINE"
    plant "$R" "$SRC/$file" 'use crate::own_state::Theme;'
    edge_own="$PLANT_LINE"
    plant "$R" "$SRC/$file" 'use crate::highlighter::Span;'
    edge_other="$PLANT_LINE"
    run_structure "$R"
    expect_status 1 || return 1
    expect_edge "$SRC/$file" "$edge_folder" "git_reader imports folder_model" || return 1
    expect_edge "$SRC/$file" "$edge_own" "git_reader imports own_state" || return 1
    expect_edge "$SRC/$file" "$edge_other" "git_reader imports highlighter" || return 1
  done
}

test_every_forbidden_pair_is_rejected() {
  new_root forbidden-pairs || return 1
  pairs=""
  for target in folder_model own_state fs_reader watcher highlighter markdown_renderer; do
    pairs="$pairs git_reader:$target"
  done
  for target in folder_model own_state fs_reader git_reader highlighter markdown_renderer; do
    pairs="$pairs watcher:$target"
  done
  for target in folder_model own_state git_reader watcher; do
    pairs="$pairs markdown_renderer:$target"
  done
  planted=""
  for pair in $pairs; do
    subject="${pair%%:*}"
    target="${pair#*:}"
    plant "$R" "$SRC/$subject/pairs.rs" "use crate::$target::Item;"
    planted="$planted $subject:$target:$PLANT_LINE"
  done
  plant "$R" "$SRC/git_reader/pairs.rs" 'fn f(_: crate::Entry) {}'
  reexport_line="$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  for item in $planted; do
    subject="${item%%:*}"
    rest="${item#*:}"
    expect_edge "$SRC/$subject/pairs.rs" "${rest#*:}" "$subject imports ${rest%%:*}" || return 1
  done
  expect_edge "$SRC/git_reader/pairs.rs" "$reexport_line" "git_reader imports fs_reader" || return 1
}

# QC-11 for the two units with no file yet. A watcher or markdown_renderer file created in the copy
# is judged in the run in which it appears, with nothing in the script edited, and each forbidden
# import planted in it draws its line. These files exist only in the copy.
test_future_unit_files_are_judged_without_editing_the_scan() {
  new_root future-units || return 1
  for file in watcher.rs watcher/fsevents.rs markdown_renderer.rs markdown_renderer/nested/x.rs; do
    [ ! -e "$R/crates/$SRC/$file" ] || fail "$file must not exist in the tree" || return 1
  done
  plant "$R" "$SRC/watcher.rs" 'use crate::folder_model::FolderModel;'
  w1="$PLANT_LINE"
  plant "$R" "$SRC/watcher/fsevents.rs" 'use crate::highlighter::Span;'
  w2="$PLANT_LINE"
  plant "$R" "$SRC/markdown_renderer.rs" 'use crate::folder_model::FileView;'
  m1="$PLANT_LINE"
  plant "$R" "$SRC/markdown_renderer/nested/x.rs" 'use crate::git_reader::GitPort;'
  m2="$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  expect_edge "$SRC/watcher.rs" "$w1" "watcher imports folder_model" || return 1
  expect_edge "$SRC/watcher/fsevents.rs" "$w2" "watcher imports highlighter" || return 1
  expect_edge "$SRC/markdown_renderer.rs" "$m1" "markdown_renderer imports folder_model" || return 1
  expect_edge "$SRC/markdown_renderer/nested/x.rs" "$m2" "markdown_renderer imports git_reader" || return 1
}

# The import forms QC-11 reads for its new subjects: a path or a nested `use` tree from `crate` or a
# run of `super`, across lines; an item the copy's lib.rs re-exports; a comment or a string. One
# target imported twice on a line is one finding, two targets on a line are two, and one target on
# two lines is two.
test_unit_edges_read_paths_and_trees_across_lines() {
  new_root edges-across-lines || return 1
  file="$SRC/git_reader/across.rs"
  plant "$R" "$file" 'use crate::
    folder_model
    ::FolderModel;'
  split_line=$((PLANT_LINE + 1))
  plant "$R" "$file" 'use super::super::{own_state::Theme,
    highlighter :: Span};'
  tree_own=$PLANT_LINE
  tree_highlighter=$((PLANT_LINE + 1))
  plant "$R" "$file" '// crate::watcher::W in a comment counts'
  comment_line="$PLANT_LINE"
  plant "$R" "$file" 'const S: &str = "crate::markdown_renderer::R";'
  string_line="$PLANT_LINE"
  plant "$R" "$file" 'use crate::highlighter::{Span, TokenClass};'
  same_target="$PLANT_LINE"
  plant "$R" "$file" 'use crate::{highlighter::Span, folder_model::FileView};'
  two_targets="$PLANT_LINE"
  plant "$R" "$file" 'use crate::folder_model::A; // one'
  again_one="$PLANT_LINE"
  plant "$R" "$file" 'use crate::folder_model::B;'
  again_two="$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  expect_edge "$file" "$split_line" "git_reader imports folder_model" || return 1
  expect_edge "$file" "$tree_own" "git_reader imports own_state" || return 1
  expect_edge "$file" "$tree_highlighter" "git_reader imports highlighter" || return 1
  expect_edge "$file" "$comment_line" "git_reader imports watcher" || return 1
  expect_edge "$file" "$string_line" "git_reader imports markdown_renderer" || return 1
  expect_edge "$file" "$same_target" "git_reader imports highlighter" || return 1
  expect_count "crates/$file" "$two_targets" QC-11 2 || return 1
  expect_edge "$file" "$again_one" "git_reader imports folder_model" || return 1
  expect_edge "$file" "$again_two" "git_reader imports folder_model" || return 1
}

# What QC-11 allows its new subjects. A file importing its own unit, `super::{StatusEntry, GitPort}`
# in the adapter's file among them, draws nothing, nor does an import of a value module, nor
# markdown_renderer's imports of fs_reader and highlighter, QC-11's two stated edges. `self::<unit>`
# and `ka_reader_core::<unit>` are not imports. A file whose name only begins with a unit's name is
# not that unit's file: watcher_ext.rs is judged by the QC-63 rule, and no QC-11 line appears.
test_own_unit_and_allowed_edges_stay_clean() {
  new_root new-subject-allowed-edges || return 1
  plant "$R" "$SRC/git_reader/libgit2.rs" 'use super::{StatusEntry, GitPort};'
  plant "$R" "$SRC/git_reader.rs" 'use crate::git_reader::GitPort;'
  plant "$R" "$SRC/git_reader.rs" 'use crate::language::Language;'
  plant "$R" "$SRC/git_reader.rs" 'use crate::error::Error;'
  plant "$R" "$SRC/git_reader.rs" 'use self::fs_reader::Entry;'
  plant "$R" "$SRC/git_reader.rs" 'use ka_reader_core::folder_model::FolderModel;'
  plant "$R" "$SRC/watcher.rs" 'use crate::watcher::W;'
  plant "$R" "$SRC/markdown_renderer.rs" 'use crate::fs_reader::Entry;'
  plant "$R" "$SRC/markdown_renderer.rs" 'use crate::highlighter::Span;'
  plant "$R" "$SRC/markdown_renderer.rs" 'use crate::language::Language;'
  run_structure "$R"
  expect_status 0 || return 1
  expect_stderr_empty || return 1
  # A file whose name only begins with a unit's name is a value module: QC-63, never QC-11.
  new_root near-names || return 1
  for near in watcher_ext markdown_renderer_ext git_reader_ext; do
    plant "$R" "$SRC/$near.rs" 'use crate::folder_model::FileView;'
    expect_near="$PLANT_LINE"
    run_structure "$R"
    expect_status 1 || return 1
    expect_count "crates/$SRC/$near.rs" "$expect_near" QC-11 0 || return 1
    expect_finding_naming "crates/$SRC/$near.rs" "$expect_near" QC-63 "value module imports folder_model" || return 1
  done
}

# The binding in the new subjects. `git2` and `libgit2_sys` in a git_reader file draw nothing,
# because git-reader owns the binding. In a watcher or markdown_renderer file each draws one line,
# the one it drew before either unit was a subject. The folder_model, fs_reader and highlighter
# lines and the bridge's switch file are unchanged.
test_binding_in_the_new_subjects() {
  new_root binding-new-subjects || return 1
  plant "$R" "$SRC/git_reader.rs" 'use git2 as _x;'
  plant "$R" "$SRC/git_reader/x.rs" 'use libgit2_sys as _y;'
  run_structure "$R"
  expect_status 0 || return 1
  expect_stderr_empty || return 1
  new_root binding-general-line || return 1
  for file in watcher.rs watcher/x.rs markdown_renderer.rs markdown_renderer/x.rs; do
    plant "$R" "$SRC/$file" 'use git2::Repository;'
    one="$PLANT_LINE"
    plant "$R" "$SRC/$file" 'use git2::A; use libgit2_sys::B;'
    two="$PLANT_LINE"
    run_structure "$R"
    expect_status 1 || return 1
    expect_count "crates/$SRC/$file" "$one" QC-11 1 || return 1
    expect_finding_naming "crates/$SRC/$file" "$one" QC-11 'the libgit2 binding `git2` named outside git-reader' || return 1
    expect_count "crates/$SRC/$file" "$two" QC-11 2 || return 1
    expect_finding_naming "crates/$SRC/$file" "$two" QC-11 'the libgit2 binding `libgit2_sys` named outside git-reader' || return 1
  done
}

# --- QC-10's adapter clause: folder_model names git-reader's adapter ---

FM_DIR_FILE="ka-reader-core/src/folder_model/x.rs"

# The QC-10 adapter finding at $2 of $1 names the form $3, once.
expect_adapter() {
  expect_finding_naming "crates/$1" "$2" QC-10 "folder_model names git-reader's adapter \`$3\`" || return 1
}

# QC-10's adapter clause, the type's form. `Libgit2` in a folder_model file, in the unit's own file
# and in a file under it, is one QC-10 finding at its line: as a path, a member of a grouped `use`,
# a bare name, a comment, a string and a raw string. A word that only contains the name is not the
# name.
test_folder_model_adapter_name_is_rejected() {
  new_root adapter-name || return 1
  for file in "$CORE_FILE" "$FM_DIR_FILE"; do
    plant "$R" "$file" 'use crate::git_reader::Libgit2;'
    l_path="$PLANT_LINE"
    plant "$R" "$file" 'use crate::git_reader::{GitPort, Libgit2};'
    l_group="$PLANT_LINE"
    plant "$R" "$file" 'type Held = Libgit2;'
    l_bare="$PLANT_LINE"
    plant "$R" "$file" '// wired to Libgit2 by the bridge'
    l_comment="$PLANT_LINE"
    plant "$R" "$file" 'const S: &str = "Libgit2";'
    l_string="$PLANT_LINE"
    plant "$R" "$file" 'const R: &str = r#"Libgit2"#;'
    l_raw="$PLANT_LINE"
    run_structure "$R"
    expect_status 1 || return 1
    for line in "$l_path" "$l_group" "$l_bare" "$l_comment" "$l_string" "$l_raw"; do
      expect_adapter "$file" "$line" Libgit2 || return 1
      expect_count "crates/$file" "$line" QC-10 1 || return 1
    done
  done
  new_root adapter-near-names || return 1
  plant "$R" "$CORE_FILE" 'struct MyLibgit2; struct Libgit2Foo; struct Libgit2s;'
  run_structure "$R"
  expect_status 0 || return 1
  expect_stderr_empty || return 1
}

# QC-10's adapter clause, the module's form. `git_reader::libgit2` reached from `crate` or a run of
# `super`, as a path or inside a nested `use` tree, with spaces or a newline around `::`, is one
# finding at the line of `libgit2`. The lowercase word anywhere else, the Git port and the plain-
# data types beside it, and `GitPort` through its lib.rs re-export draw nothing.
test_folder_model_adapter_module_form_is_rejected() {
  new_root adapter-module || return 1
  file="$FM_DIR_FILE"
  lines=""
  for text in \
    'use crate::git_reader::libgit2::Item;' \
    'fn f(_: crate::git_reader::libgit2::X) {}' \
    'use super::super::git_reader::libgit2::Y;' \
    'use crate::{git_reader::{libgit2::Z, GitPort}};' \
    'use crate::git_reader :: libgit2 :: W;'; do
    plant "$R" "$file" "$text"
    lines="$lines $PLANT_LINE"
  done
  plant "$R" "$file" 'use crate::git_reader::
    libgit2::V;'
  lines="$lines $((PLANT_LINE + 1))"
  run_structure "$R"
  expect_status 1 || return 1
  for line in $lines; do
    expect_adapter "$file" "$line" git_reader::libgit2 || return 1
    expect_count "crates/$file" "$line" QC-10 1 || return 1
  done
}

test_folder_model_allowed_git_port_forms_stay_clean() {
  new_root adapter-clean || return 1
  plant "$R" "$CORE_FILE" 'use crate::git_reader::{GitPort, RootFinding};'
  plant "$R" "$CORE_FILE" 'fn f(_: &dyn crate::GitPort) {}'
  plant "$R" "$CORE_FILE" '// libgit2 does the I/O'
  plant "$R" "$CORE_FILE" 'fn libgit2() { let libgit2 = 1; let _ = libgit2; }'
  plant "$R" "$CORE_FILE" 'use crate::libgit2::Item;'
  plant "$R" "$CORE_FILE" 'use self::git_reader::libgit2::Item;'
  plant "$R" "$CORE_FILE" 'use ka_reader_core::git_reader::libgit2::Item;'
  plant "$R" "$FM_DIR_FILE" 'use crate::git_reader::GitPort;'
  run_structure "$R"
  expect_status 0 || return 1
  expect_stderr_empty || return 1
}

# Two findings on one line stay two. Constructing the adapter in folder_model draws the QC-10
# adapter line and the QC-17 line. The adapter beside an own_state import or the binding keeps every
# finding. A form repeated on one line is one finding, and the two forms on one line are two. The
# report stays sorted by path, line, QC and clause.
test_folder_model_adapter_findings_compose() {
  new_root adapter-compose || return 1
  file="$CORE_FILE"
  plant "$R" "$file" 'use crate::own_state::Theme; use crate::git_reader::Libgit2;'
  l_edge="$PLANT_LINE"
  plant "$R" "$file" 'use git2 as _x; // Libgit2'
  l_binding="$PLANT_LINE"
  plant "$R" "$file" '// Libgit2 and again Libgit2'
  l_repeat="$PLANT_LINE"
  plant "$R" "$file" 'use crate::git_reader::libgit2::Libgit2;'
  l_both="$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  expect_count "crates/$file" "$l_edge" QC-10 2 || return 1
  expect_finding_naming "crates/$file" "$l_edge" QC-10 "folder_model imports own_state" || return 1
  expect_adapter "$file" "$l_edge" Libgit2 || return 1
  expect_count "crates/$file" "$l_binding" QC-10 2 || return 1
  expect_finding_naming "crates/$file" "$l_binding" QC-10 "folder_model names the libgit2 binding \`git2\`" || return 1
  expect_adapter "$file" "$l_binding" Libgit2 || return 1
  expect_count "crates/$file" "$l_repeat" QC-10 1 || return 1
  expect_count "crates/$file" "$l_both" QC-10 2 || return 1
  expect_adapter "$file" "$l_both" Libgit2 || return 1
  expect_adapter "$file" "$l_both" git_reader::libgit2 || return 1
  expect_before "$file:$l_edge: QC-10: folder_model imports own_state" "$file:$l_edge: QC-10: folder_model names git-reader's adapter" || return 1
  expect_before "$file:$l_both: QC-10: folder_model names git-reader's adapter \`Libgit2\`" "$file:$l_both: QC-10: folder_model names git-reader's adapter \`git_reader::libgit2\`" || return 1
}

# --- QC-17's adapter construction: the adapter is made only under crates/ka-reader-bridge/src/ ---

ADAPTER_FILE="ka-reader-core/src/git_reader/libgit2.rs"
QC17_TEXT='git-reader'"'"'s adapter `Libgit2` constructed outside crates/ka-reader-bridge/src/'

# One QC-17 finding at $2 of $1, with the fixed text.
expect_construction() {
  expect_count "crates/$1" "$2" QC-17 1 || return 1
  expect_finding_naming "crates/$1" "$2" QC-17 "$QC17_TEXT" || return 1
}

# No QC-17 finding at $2 of $1.
expect_no_construction() {
  expect_count "crates/$1" "$2" QC-17 0
}

# QC-17's floor. Outside crates/ka-reader-bridge/src/, each construction of the adapter is one QC-17
# finding at the line of `Libgit2`: `Arc::new`, `Box::new`, a bare or a borrowed argument, a `let`
# initializer, `return`, a struct literal, `Libgit2::new` and `Libgit2::default`, a construction
# split across lines included. The adapter's own source file is not exempt.
test_adapter_construction_outside_bridge_is_rejected() {
  new_root construct || return 1
  file="$ADAPTER_FILE"
  lines=""
  for text in \
    'fn a() { let _ = Arc::new(Libgit2); }' \
    'fn b() { let _ = Box::new(Libgit2); }' \
    'fn c() { f(Libgit2); }' \
    'fn d() { f(&Libgit2); }' \
    'fn e() { let p = Libgit2; }' \
    'fn g() -> impl GitPort { return Libgit2; }' \
    'fn h() { let _ = Libgit2 {}; }' \
    'fn i() { let _ = Libgit2::default(); }' \
    'fn j() { let _ = Libgit2::new(); }' \
    'fn k() { let _ = crate::git_reader::Libgit2; }' \
    'fn m() { let _ = crate::Libgit2::default(); }' \
    'fn n() { let _ = (Libgit2, Libgit2); }'; do
    plant "$R" "$file" "$text"
    lines="$lines $PLANT_LINE"
  done
  plant "$R" "$file" 'fn o() { let _ = Arc::new(
    Libgit2,
); }'
  split_line=$((PLANT_LINE + 1))
  plant "$R" "$FS_FILE" 'fn p() { let _ = Arc::new(Libgit2); }'
  fs_line="$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  for line in $lines $split_line; do
    expect_construction "$file" "$line" || return 1
  done
  expect_construction "$FS_FILE" "$fs_line" || return 1
  expect_count "crates/$FS_FILE" "$fs_line" QC-11 0 || return 1
}

# QC-17's type positions draw nothing: a `use` or a re-export, the definition, an inherent or a
# trait `impl` header, a generic argument, a qualified path's self type, a parameter, field or
# return type, a reference or `Arc<Libgit2>` in a type, and a bound. The six such lines the core
# holds today stay clean. A construction on the same line as a type position is still a finding.
test_adapter_type_positions_are_clean() {
  new_root type-positions || return 1
  plant "$R" "$ADAPTER_FILE" 'pub use libgit2::Libgit2;'
  plant "$R" "$ADAPTER_FILE" 'pub struct Other(Libgit2);'
  plant "$R" "$ADAPTER_FILE" 'struct Holder { port: Libgit2, shared: Arc<Libgit2>, r: &'"'"'static Libgit2 }'
  plant "$R" "$ADAPTER_FILE" 'type Alias = Libgit2;'
  plant "$R" "$ADAPTER_FILE" 'impl Libgit2 { fn id(&self) {} }'
  plant "$R" "$ADAPTER_FILE" 'impl Clone for Libgit2 { fn clone(&self) -> Self { Self } }'
  plant "$R" "$ADAPTER_FILE" 'fn q(p: &Libgit2, r: &mut Libgit2) -> Libgit2 { todo!() }'
  plant "$R" "$ADAPTER_FILE" 'fn r() -> Option<Libgit2> { None }'
  plant "$R" "$ADAPTER_FILE" 'fn s<T: Into<Libgit2>>(t: T) where T: Into<Libgit2> {}'
  plant "$R" "$ADAPTER_FILE" 'fn t() { assert_port::<Libgit2>(); }'
  plant "$R" "$ADAPTER_FILE" 'fn u() { let _ = <Libgit2 as GitPort>::probe; }'
  plant "$R" "$ADAPTER_FILE" 'fn v(p: crate::git_reader::Libgit2) {}'
  plant "$R" "$ADAPTER_FILE" 'fn w() { let p: Libgit2 = todo!(); let _ = p; }'
  plant "$R" "$ADAPTER_FILE" 'fn x() { let _v = Vec::<Libgit2>::new(); }'
  run_structure "$R"
  expect_status 0 || return 1
  expect_stderr_empty || return 1
  # An expression and a type on one line report once, for the expression.
  new_root type-and-expression || return 1
  plant "$R" "$ADAPTER_FILE" 'fn y(p: &Libgit2) -> Libgit2 { Libgit2 }'
  mixed="$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  expect_construction "$ADAPTER_FILE" "$mixed" || return 1
}

# CP-869: a type annotation is a type position, whatever type it spells. A tuple, an array or a
# slice naming the adapter in the annotation of a `let`, a `const`, a `static` or a closure's
# parameter draws nothing. The value after the `=` is still read: a construction there is a finding.
test_adapter_compound_annotation_types_are_clean() {
  new_root compound-annotations || return 1
  file="$ADAPTER_FILE"
  plant "$R" "$file" 'fn a() { let t: (Libgit2, u8) = todo!(); }'
  plant "$R" "$file" 'fn b() { let x: [Libgit2; 2] = todo!(); }'
  plant "$R" "$file" 'fn c(v: &Vec<u8>) { let s: &[Libgit2] = todo!(); }'
  plant "$R" "$file" 'fn d() { let (p, q): (Libgit2, Option<Libgit2>) = todo!(); }'
  plant "$R" "$file" 'const PAIR: (Libgit2, u8) = todo!();'
  plant "$R" "$file" 'static PORTS: [Libgit2; 1] = todo!();'
  plant "$R" "$file" 'fn e() { let f = |p: (Libgit2, u8), q: &[Libgit2]| p.1; }'
  run_structure "$R"
  expect_status 0 || return 1
  expect_stderr_empty || return 1
  new_root compound-annotation-value || return 1
  plant "$R" "$file" 'fn g() { let t: (Libgit2, u8) = (Libgit2, 1); }'
  value_line="$PLANT_LINE"
  plant "$R" "$file" 'static PORTS: [Libgit2; 1] = [Libgit2];'
  static_line="$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  expect_construction "$file" "$value_line" || return 1
  expect_construction "$file" "$static_line" || return 1
}

# CP-869's floor holds wherever the form stands in code. A `<` that compares, after a constant, a
# string, a character or a `?`, is not the opening of a generic argument list, so a construction
# later in the same expression is still a finding.
test_adapter_construction_after_a_comparison_is_rejected() {
  new_root construct-after-comparison || return 1
  file="$FS_FILE"
  lines=""
  for text in \
    'fn a(n: usize) -> bool { LIMIT < n && take(Libgit2) }' \
    'fn b(n: usize) -> bool { Self::MAX_DEPTH < n && take(Libgit2) }' \
    'fn c(s: &str) -> bool { "a" < s && take(Libgit2) }' \
    "fn d(c: char) -> bool { ('a' < c) && take(Libgit2) }" \
    'fn e(x: Option<u8>) -> Option<bool> { Some(x? < 3 && take(Libgit2)) }'; do
    plant "$R" "$file" "$text"
    lines="$lines $PLANT_LINE"
  done
  run_structure "$R"
  expect_status 1 || return 1
  for line in $lines; do
    expect_construction "$file" "$line" || return 1
  done
}

# QC-17 reads code only. Construction text in a comment, a doc comment, a nested block comment or a
# string, whether ordinary, raw or escaped, draws no QC-17 finding, and a string between two code
# tokens does not join them into one expression. In a folder_model file the QC-10 adapter clause
# still reads the same text.
test_adapter_construction_in_comments_and_strings_is_ignored() {
  new_root construct-text || return 1
  file="$FS_FILE"
  plant "$R" "$file" '// Arc::new(Libgit2)'
  plant "$R" "$file" '/// let p = Libgit2;'
  plant "$R" "$file" '/* Box::new(Libgit2) /* nested Libgit2::default() */ still Libgit2 { } */'
  plant "$R" "$file" 'const A: &str = "Arc::new(Libgit2)";'
  plant "$R" "$file" 'const B: &str = r#"let p = Libgit2;"#;'
  plant "$R" "$file" 'const C: &str = "escaped \" Libgit2::new() \" still inside";'
  run_structure "$R"
  expect_status 0 || return 1
  expect_stderr_empty || return 1
  # A string between two code tokens keeps them apart: the name after it is still read as code, and
  # the type-position `:` before the string does not reach across it.
  new_root string-boundary || return 1
  plant "$R" "$file" 'fn z(p: &str) { let _ = (p, "x" Libgit2); }'
  boundary="$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  expect_construction "$file" "$boundary" || return 1
}

# Where QC-17 applies. A construction under crates/ka-reader-bridge/src/, in machine_config.rs or in
# a new file, draws nothing. One in another crate, or under a path that only resembles the bridge's,
# draws a finding. A crate's own tests/ and build.rs are outside the rule, and src/tests/ and
# src/build.rs are not. Several constructions on one line are one finding, and two lines are two.
test_bridge_source_may_construct_the_adapter() {
  new_root bridge-construct || return 1
  grep -q -F 'Arc::new(Libgit2)' "$R/crates/ka-reader-bridge/src/machine_config.rs" \
    || fail "the bridge's own construction is no longer in machine_config.rs to be judged" || return 1
  plant "$R" "ka-reader-bridge/src/wiring.rs" 'fn w() { let _ = Arc::new(Libgit2); }'
  plant "$R" "ka-reader-core/tests/x.rs" 'fn t() { let _ = Arc::new(Libgit2); }'
  plant "$R" "ka-reader-bridge/build.rs" 'fn main() { let _ = Libgit2; }'
  run_structure "$R"
  expect_no_finding_for "ka-reader-bridge/src/machine_config.rs" || return 1
  case "$STDERR" in
    *"QC-17: git-reader's adapter"*) fail "expected no QC-17 adapter finding. stderr: $STDERR" || return 1 ;;
  esac
  new_root bridge-near-names || return 1
  plant "$R" "ka-reader-extra/src/lib.rs" 'fn a() { let _ = Libgit2; }'
  other="$PLANT_LINE"
  plant "$R" "ka-reader-bridge-extra/src/lib.rs" 'fn a() { let _ = Libgit2; }'
  near="$PLANT_LINE"
  plant "$R" "ka-reader-bridge/src/tests/x.rs" 'fn a() { let _ = Libgit2; }'
  nested_tests="$PLANT_LINE"
  plant "$R" "ka-reader-bridge/src/build.rs" 'fn a() { let _ = Libgit2; }'
  nested_build="$PLANT_LINE"
  plant "$R" "ka-reader-extra/src/tests/y.rs" 'fn a() { let _ = Libgit2; }'
  other_tests="$PLANT_LINE"
  plant "$R" "ka-reader-extra/src/build.rs" 'fn a() { let _ = Libgit2; }'
  other_build="$PLANT_LINE"
  plant "$R" "ka-reader-extra/tests/z.rs" 'fn a() { let _ = Libgit2; }'
  plant "$R" "ka-reader-extra/build.rs" 'fn a() { let _ = Libgit2; }'
  plant "$R" "ka-reader-core/src/language.rs" 'fn a() { let _ = (Libgit2, Libgit2); }'
  many="$PLANT_LINE"
  plant "$R" "ka-reader-core/src/language.rs" 'fn b() { let _ = Libgit2; }'
  second="$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  expect_construction "ka-reader-extra/src/lib.rs" "$other" || return 1
  expect_construction "ka-reader-bridge-extra/src/lib.rs" "$near" || return 1
  expect_no_construction "ka-reader-bridge/src/tests/x.rs" "$nested_tests" || return 1
  expect_no_construction "ka-reader-bridge/src/build.rs" "$nested_build" || return 1
  expect_construction "ka-reader-extra/src/tests/y.rs" "$other_tests" || return 1
  expect_construction "ka-reader-extra/src/build.rs" "$other_build" || return 1
  expect_no_finding_for "ka-reader-extra/tests/z.rs" || return 1
  expect_no_finding_for "ka-reader-extra/build.rs" || return 1
  expect_construction "ka-reader-core/src/language.rs" "$many" || return 1
  expect_construction "ka-reader-core/src/language.rs" "$second" || return 1
}

test_folder_model_adapter_construction_draws_both_clauses() {
  new_root construct-folder-model || return 1
  plant "$R" "$CORE_FILE" 'fn a() { let p = Libgit2; }'
  line="$PLANT_LINE"
  plant "$R" "$ADAPTER_FILE" 'fn b() { let _ = Libgit2; }'
  later="$PLANT_LINE"
  run_structure "$R"
  expect_status 1 || return 1
  expect_count "crates/$CORE_FILE" "$line" QC-10 1 || return 1
  expect_adapter "$CORE_FILE" "$line" Libgit2 || return 1
  expect_construction "$CORE_FILE" "$line" || return 1
  expect_before "$CORE_FILE:$line: QC-10: " "$CORE_FILE:$line: QC-17: " || return 1
  expect_before "$CORE_FILE:$line: QC-17: " "$ADAPTER_FILE:$later: QC-17: " || return 1
}

# --- the header's coverage account ---

# How many lines of checks/structure.sh hold the fixed text $1.
header_count() {
  grep -c -F -e "$1" "$STRUCTURE_SH"
}

# The header's coverage account. WHAT IS NOT HELD no longer lists the three clauses this version
# holds, and it still lists QC-7, QC-12, QC-20 and the parts of QC-15 and QC-63. It lists the
# containment bound on the edge from markdown-renderer to fs-reader as held by review, and the
# adapter construction gaps are named. The case reads these properties, not the whole header.
test_header_states_the_held_clauses() {
  # The three clauses this version holds are no longer listed as not held.
  retired="$(grep -c -F -e "QC-10's \`git-reader\`-adapter clause" -e "QC-11's clauses whose subject is" -e "QC-17's adapter-constructor clause" "$STRUCTURE_SH")"
  [ "$retired" = "0" ] || fail "expected the three retired phrasings to count 0, got $retired" || return 1
  # The scan table names each new rule.
  for text in \
    "Forbidden for git_reader:" "Forbidden for watcher:" "Forbidden for markdown_renderer:" \
    "Source: QC-10's \"must not import the libgit2 binding," \
    "QC-17's \"the adapter's constructor"; do
    [ "$(header_count "$text")" -ge 1 ] || fail "the header does not state: $text" || return 1
  done
  # What stays not held.
  for text in "Not held: QC-7; QC-12;" "QC-20." "QC-15's filesystem owners, in two parts" "QC-63's types-and-values half"; do
    [ "$(header_count "$text")" -ge 1 ] || fail "the header no longer lists: $text" || return 1
  done
  # The containment-only bound is listed as held in part, and the construction gaps are named.
  for text in "QC-11's bound on the edge from \`markdown-renderer\` to \`fs-reader\`" "And, for the adapter rules:" "port: Libgit2"; do
    [ "$(header_count "$text")" -ge 1 ] || fail "the header does not state: $text" || return 1
  done
  # CP-871: GAPS names every construction form the rule cannot classify, the one a comparison hides
  # among them.
  [ "$(header_count "reads as the opening of a generic argument list")" -ge 1 ] \
    || fail "the header does not name the construction a comparison hides" || return 1
  # CP-872: the rows the scan held before keep their text. The new QC-17 row stands after the logger
  # row, so the logger row's first line runs on into its own second line.
  logger_next="$(grep -A1 -F -e "#     QC-17  logger" "$STRUCTURE_SH" | sed -n 2p)"
  case "$logger_next" in
    *"(the exact path component), a path whose first segment is \`log\`"*) ;;
    *) fail "the logger row is split: its first line is followed by: $logger_next" || return 1 ;;
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
  if [ -n "${KA_READER_TEST_ONLY:-}" ] && [ "$case_name" != "$KA_READER_TEST_ONLY" ]; then
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
  echo "test_structure.sh: no case is named ${KA_READER_TEST_ONLY:-<none>}" >&2
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
