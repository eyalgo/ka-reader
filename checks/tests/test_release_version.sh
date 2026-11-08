#!/usr/bin/env bash
# checks/tests/test_release_version.sh — the tests of checks/release-version.sh, the refusal of a
# tag that is not the product's version (CP-1175).
# Version: 1.0.0 — first version: the tree's own version agreement (CP-1168, CP-1169) and the real
#   script against scratch manifests and bundles, with every exit status it returns asserted
#
# WHY THIS EXISTS
#   A tag build that packs a bundle whose version is not the tag's names the wrong release. The
#   script refuses that before anything is packed, so these cases run the real script — never a copy
#   of its logic — on scratch manifests and scratch bundle folders handed in as arguments, and
#   assert the three statuses it returns: 0 for a tag that is the version, 1 for a refusal, 2 for a
#   wrong argument count. Two cases read the tree itself: every workspace member reports the root's
#   version, and the gate-built bundle carries the same version as the tree's manifest. The second
#   is the case that goes red when a version bump misses ka-reader-mac/Info.plist.
#
# USAGE
#   checks/tests/test_release_version.sh
#     KA_READER_TEST_ONLY=<case> runs one case.
#   It reads the bundle the gate's "Build KA-Reader.app" step wrote, at
#   target/release/bundle/macos/KA-Reader.app, so it runs after that step.
#
# WHY NO `set -e`
#   A case that fails must not end the run before the remaining cases report. Each case returns its
#   own status and the runner counts them.
#
# WHERE IT WRITES
#   Only below one `mktemp -d` directory, removed by a trap on exit. The tree is read, never written.

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SCRIPT="$ROOT/checks/release-version.sh"
TREE_MANIFEST="$ROOT/Cargo.toml"
TREE_BUNDLE="$ROOT/target/release/bundle/macos/KA-Reader.app"
PLIST_BUDDY="/usr/libexec/PlistBuddy"
KEY="CFBundleShortVersionString"

OUT=""
ERR=""
STATUS=0
WORK=""

CASES="
test_every_member_reports_the_root_version
test_the_tree_and_its_bundle_agree
test_a_tag_that_is_not_the_version_is_refused
test_a_bundle_that_misses_the_version_is_refused
test_a_one_dot_oh_tag_is_refused
test_a_pre_release_tag_is_refused
test_a_tag_of_the_wrong_form_is_refused
test_a_bundle_with_no_key_is_refused_naming_no_version
test_a_line_names_every_failed_condition
test_a_matching_tag_passes
test_a_multi_digit_tag_passes
test_a_manifest_without_the_table_is_refused
test_a_manifest_without_a_version_line_is_refused
test_a_manifest_with_two_version_lines_is_refused
test_a_bundle_without_an_info_plist_is_refused
test_a_wrong_argument_count_exits_2
"

# --- helpers ---

fail() {
  echo "  $*"
  return 1
}

# Writes a manifest to the path $1 holding the table [workspace.package] and the version $2.
write_manifest() {
  mkdir -p "$(dirname "$1")"
  printf '[workspace]\nmembers = ["crates/*"]\n\n[workspace.package]\nversion = "%s"\n\n[workspace.lints.rust]\nunsafe_code = "forbid"\n' "$2" > "$1"
}

# Writes a bundle folder at the path $1 whose Contents/Info.plist carries the version $2.
write_bundle() {
  mkdir -p "$1/Contents"
  "$PLIST_BUDDY" -c "Add :CFBundleIdentifier string com.example.scratch" "$1/Contents/Info.plist" > /dev/null
  "$PLIST_BUDDY" -c "Add :$KEY string $2" "$1/Contents/Info.plist" > /dev/null
}

# A fresh scratch folder named $1, holding manifest/Cargo.toml at version $2 and bundle/ at version $3.
new_scene() {
  scene="$WORK/$1"
  rm -rf "$scene"
  mkdir -p "$scene"
  write_manifest "$scene/Cargo.toml" "$2"
  write_bundle "$scene/KA-Reader.app" "$3"
}

# Runs the script with the arguments given, keeping its status and its two streams.
run_script() {
  "$SCRIPT" "$@" > "$WORK/stdout" 2> "$WORK/stderr"
  STATUS=$?
  OUT="$(cat "$WORK/stdout")"
  ERR="$(cat "$WORK/stderr")"
}

show_output() {
  printf '%s\n%s\n' "$OUT" "$ERR" | sed '/^$/d; s/^/  /'
}

# The last run exited 1 and printed one stderr line prefixed release-version.sh: and nothing on stdout.
expect_refusal() {
  [ "$STATUS" -eq 1 ] || { fail "expected exit 1, got $STATUS. Its output follows."; show_output; return 1; }
  [ -z "$OUT" ] || { fail "a refusal printed on stdout. Its output follows."; show_output; return 1; }
  [ "$(printf '%s\n' "$ERR" | wc -l | tr -d ' ')" -eq 1 ] || { fail "a refusal is one stderr line. Its output follows."; show_output; return 1; }
  case "$ERR" in
    "release-version.sh: "*) return 0 ;;
  esac
  fail "the refusal line does not start with the script's name. Its output follows."
  show_output
  return 1
}

# The last stderr line holds the text $1.
expect_err_has() {
  case "$ERR" in
    *"$1"*) return 0 ;;
  esac
  fail "the refusal line does not hold \"$1\". Its output follows."
  show_output
  return 1
}

# The last stderr line does not hold the text $1.
expect_err_lacks() {
  case "$ERR" in
    *"$1"*)
      fail "the refusal line holds \"$1\" and should not. Its output follows."
      show_output
      return 1
      ;;
  esac
  return 0
}

# --- cases ---

# CP-1168: the root states the version and each member inherits it.
test_every_member_reports_the_root_version() {
  metadata="$WORK/metadata.json"
  (cd "$ROOT" && cargo metadata --no-deps --format-version 1 --locked) > "$metadata" 2> "$WORK/metadata.err" \
    || { fail "cargo metadata failed: $(cat "$WORK/metadata.err")"; return 1; }
  root_version="$(sed -n '/^\[workspace.package\]$/,/^\[/{s/^version = "\(.*\)"$/\1/p;}' "$TREE_MANIFEST")"
  [ -n "$root_version" ] || { fail "Cargo.toml holds no [workspace.package] version line"; return 1; }
  count="$(plutil -extract packages raw -expect array "$metadata")" || { fail "plutil could not read the metadata"; return 1; }
  [ "$count" -eq 2 ] || { fail "expected the two workspace members, cargo metadata lists $count"; return 1; }
  index=0
  while [ "$index" -lt "$count" ]; do
    name="$(plutil -extract "packages.$index.name" raw -expect string "$metadata")" || return 1
    version="$(plutil -extract "packages.$index.version" raw -expect string "$metadata")" || return 1
    [ "$version" = "$root_version" ] || { fail "$name reports $version, the root states $root_version"; return 1; }
    index=$((index + 1))
  done
}

# CP-1169: the bundle the gate built carries the tree's version.
test_the_tree_and_its_bundle_agree() {
  [ -d "$TREE_BUNDLE" ] || { fail "no bundle at $TREE_BUNDLE: run \"Build KA-Reader.app\" (ka-reader-mac/assemble.sh) first"; return 1; }
  version="$(cd "$ROOT" && cargo metadata --no-deps --format-version 1 --locked \
    | plutil -extract packages.0.version raw -expect string -o - -)" \
    || { fail "could not read the version from cargo metadata"; return 1; }
  run_script "v$version" "$TREE_MANIFEST" "$TREE_BUNDLE"
  [ "$STATUS" -eq 0 ] || { fail "expected exit 0 on the tree and its bundle, got $STATUS. Its output follows."; show_output; return 1; }
  bundle_version="$("$PLIST_BUDDY" -c "Print :$KEY" "$TREE_BUNDLE/Contents/Info.plist")" \
    || { fail "the bundle's Info.plist has no $KEY"; return 1; }
  [ "$bundle_version" = "$version" ] || { fail "the bundle prints $bundle_version, the tree states $version"; return 1; }
}

test_a_tag_that_is_not_the_version_is_refused() {
  new_scene tag-not-version 0.0.0 0.0.0
  run_script v0.1.0 "$scene/Cargo.toml" "$scene/KA-Reader.app"
  expect_refusal || return 1
  expect_err_has "v0.1.0" || return 1
  expect_err_has "0.0.0" || return 1
  expect_err_has "(a)" || return 1
  expect_err_lacks "(b)" || return 1
}

test_a_bundle_that_misses_the_version_is_refused() {
  new_scene bundle-behind 0.2.0 0.1.0
  run_script v0.2.0 "$scene/Cargo.toml" "$scene/KA-Reader.app"
  expect_refusal || return 1
  expect_err_has "0.2.0" || return 1
  expect_err_has "0.1.0" || return 1
  expect_err_has "(b)" || return 1
  expect_err_lacks "(a)" || return 1
  expect_err_lacks "(c)" || return 1
}

test_a_one_dot_oh_tag_is_refused() {
  new_scene one-dot-oh 1.0.0 1.0.0
  run_script v1.0.0 "$scene/Cargo.toml" "$scene/KA-Reader.app"
  expect_refusal || return 1
  expect_err_has "(c)" || return 1
  expect_err_lacks "(a)" || return 1
  expect_err_lacks "(b)" || return 1
}

test_a_pre_release_tag_is_refused() {
  new_scene pre-release 0.1.0-beta.1 0.1.0-beta.1
  run_script v0.1.0-beta.1 "$scene/Cargo.toml" "$scene/KA-Reader.app"
  expect_refusal || return 1
  expect_err_has "v0.1.0-beta.1" || return 1
  expect_err_has "(c)" || return 1
}

test_a_tag_of_the_wrong_form_is_refused() {
  new_scene wrong-form 0.1.0 0.1.0
  for tag in vnext v0.1; do
    run_script "$tag" "$scene/Cargo.toml" "$scene/KA-Reader.app"
    expect_refusal || return 1
    expect_err_has "(c)" || return 1
  done
}

test_a_bundle_with_no_key_is_refused_naming_no_version() {
  scene="$WORK/no-key"
  rm -rf "$scene"
  mkdir -p "$scene/KA-Reader.app/Contents"
  write_manifest "$scene/Cargo.toml" 0.0.0
  "$PLIST_BUDDY" -c "Add :CFBundleIdentifier string com.example.scratch" "$scene/KA-Reader.app/Contents/Info.plist" > /dev/null
  run_script v0.0.0 "$scene/Cargo.toml" "$scene/KA-Reader.app"
  expect_refusal || return 1
  expect_err_has "(b)" || return 1
  expect_err_has "no version" || return 1
}

test_a_line_names_every_failed_condition() {
  new_scene two-breaks 1.0.0 1.0.0
  run_script v1.0.1 "$scene/Cargo.toml" "$scene/KA-Reader.app"
  expect_refusal || return 1
  expect_err_has "(a)" || return 1
  expect_err_has "(c)" || return 1
  expect_err_lacks "(b)" || return 1
}

test_a_matching_tag_passes() {
  new_scene match 0.0.0 0.0.0
  run_script v0.0.0 "$scene/Cargo.toml" "$scene/KA-Reader.app"
  [ "$STATUS" -eq 0 ] || { fail "expected exit 0, got $STATUS. Its output follows."; show_output; return 1; }
  [ -z "$ERR" ] || { fail "a pass wrote to stderr. Its output follows."; show_output; return 1; }
  [ "$(printf '%s\n' "$OUT" | wc -l | tr -d ' ')" -eq 1 ] || { fail "a pass is one stdout line. Its output follows."; show_output; return 1; }
  case "$OUT" in
    *v0.0.0*0.0.0*) return 0 ;;
  esac
  fail "the pass line names neither the tag nor the versions. Its output follows."
  show_output
  return 1
}

test_a_multi_digit_tag_passes() {
  new_scene multi-digit 0.10.12 0.10.12
  run_script v0.10.12 "$scene/Cargo.toml" "$scene/KA-Reader.app"
  [ "$STATUS" -eq 0 ] || { fail "expected exit 0, got $STATUS. Its output follows."; show_output; return 1; }
}

test_a_manifest_without_the_table_is_refused() {
  new_scene no-table 0.0.0 0.0.0
  printf '[workspace]\nmembers = ["crates/*"]\n' > "$scene/Cargo.toml"
  run_script v0.0.0 "$scene/Cargo.toml" "$scene/KA-Reader.app"
  expect_refusal || return 1
}

test_a_manifest_without_a_version_line_is_refused() {
  new_scene no-version-line 0.0.0 0.0.0
  printf '[workspace]\nmembers = ["crates/*"]\n\n[workspace.package]\nedition = "2024"\n' > "$scene/Cargo.toml"
  run_script v0.0.0 "$scene/Cargo.toml" "$scene/KA-Reader.app"
  expect_refusal || return 1
}

test_a_manifest_with_two_version_lines_is_refused() {
  new_scene two-version-lines 0.0.0 0.0.0
  printf '[workspace.package]\nversion = "0.0.0"\nversion = "0.0.0"\n' > "$scene/Cargo.toml"
  run_script v0.0.0 "$scene/Cargo.toml" "$scene/KA-Reader.app"
  expect_refusal || return 1
}

test_a_bundle_without_an_info_plist_is_refused() {
  new_scene no-plist 0.0.0 0.0.0
  rm -rf "$scene/KA-Reader.app"
  mkdir -p "$scene/KA-Reader.app"
  run_script v0.0.0 "$scene/Cargo.toml" "$scene/KA-Reader.app"
  expect_refusal || return 1
}

test_a_wrong_argument_count_exits_2() {
  new_scene counts 0.0.0 0.0.0
  manifest="$scene/Cargo.toml"
  bundle="$scene/KA-Reader.app"
  run_script
  [ "$STATUS" -eq 2 ] || { fail "zero arguments: expected exit 2, got $STATUS"; return 1; }
  case "$ERR" in *sage*) ;; *) fail "zero arguments: no usage line on stderr: $ERR"; return 1 ;; esac
  run_script v0.0.0 "$manifest"
  [ "$STATUS" -eq 2 ] || { fail "two arguments: expected exit 2, got $STATUS"; return 1; }
  case "$ERR" in *sage*) ;; *) fail "two arguments: no usage line on stderr: $ERR"; return 1 ;; esac
  run_script v0.0.0 "$manifest" "$bundle" extra
  [ "$STATUS" -eq 2 ] || { fail "four arguments: expected exit 2, got $STATUS"; return 1; }
  case "$ERR" in *sage*) ;; *) fail "four arguments: no usage line on stderr: $ERR"; return 1 ;; esac
}

# --- the runner ---

TMP_BASE="${TMPDIR:-/tmp}"
TMP_BASE="${TMP_BASE%/}"
if ! WORK="$(mktemp -d "$TMP_BASE/release-version-suite.XXXXXX" 2> /dev/null)"; then
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
