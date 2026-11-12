#!/usr/bin/env bash
# checks/tests/test_assemble.sh — the tests of ka-reader-mac/assemble.sh's refusals and of how it
# wires the application icon's generation.
# Version: 1.0.0 — first version: the missing drawing, each missing program, the ten sips calls then
#   one iconutil then cargo, and the generation's folder removed on every exit
#
# WHY THIS EXISTS
#   ka-reader-mac/assemble.sh generates the bundle's icon from docs/design/app_icon.svg at every
#   assembly. No suite may start the real sips, iconutil, cargo, rustc, swift or codesign
#   (docs/nfdr.md QC-67; the testing doctrine's "a test reads nothing of the machine it runs on"),
#   so every case here lays out a tree of its own, runs a byte copy of the real script in it with
#   stand-ins for those six programs, and reads what the script asked of them. The icon's pixels are
#   held by checks/app-icon.sh on the real bundle, not here. What this suite holds is the order and
#   the arguments of the calls, the refusals that come before the bridge build, and that nothing the
#   generation makes is left behind.
#   The runner is this file: the product has no Python (docs/nfdr.md § 9), the same reason
#   checks/tests/test_entry_points.sh gives.
#
# USAGE
#   checks/tests/test_assemble.sh
#     KA_READER_TEST_ONLY=<case> [<case> ...] runs the named cases. A name that is no case fails the
#     run.
#   Exit 0 when every case passes, 1 when a case fails or a name is no case. It launches nothing and
#   reads no home.
#
# WHY NO `set -e`
#   A case that fails must not end the run before the remaining cases report. Each case returns its
#   own status and the runner counts them.

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
REAL_SCRIPT="$ROOT/ka-reader-mac/assemble.sh"

# The ten entries of an iconset and the pixel size each is rendered at: an @2x entry is twice its base.
ICONSET_ENTRIES="icon_16x16:16 icon_16x16@2x:32 icon_32x32:32 icon_32x32@2x:64 icon_128x128:128 icon_128x128@2x:256 icon_256x256:256 icon_256x256@2x:512 icon_512x512:512 icon_512x512@2x:1024"

# The programs the script runs that this suite stands in, and the system tools it needs besides.
STOOD_IN="sips iconutil cargo rustc swift codesign"
SYSTEM_TOOLS="bash dirname mktemp rm mkdir cp cat sed"

CASES="
test_missing_drawing_stops_before_the_bridge_build
test_missing_sips_is_named
test_missing_iconutil_is_named
test_missing_cargo_is_named
test_missing_rustc_is_named
test_missing_swift_is_named
test_missing_codesign_is_named
test_icon_is_generated_from_the_drawing_before_the_bridge_build
test_icon_folder_is_removed_when_the_run_is_refused
test_sips_failure_is_named_and_its_folder_removed
"

WORK="$(mktemp -d)" || { echo "test_assemble.sh: cannot create a temporary folder" >&2; exit 1; }
trap 'rm -rf "$WORK"' EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

fail() {
  echo "$*"
  return 1
}

# --- one case's tree, stand-ins and call log ---

# Lays out a tree in its own folder, with a byte copy of the real script, and a bin folder holding the
# system tools and every stand-in except the one named in $1 (none when $1 is empty). `sips` and
# `iconutil` write the file they are told to; `cargo` is a sentinel that logs and fails, so a wiring
# case ends there and nothing reads its reply.
new_case() {
  local omitted="${1:-}"
  local program tool found
  CASE="$(mktemp -d "$WORK/case.XXXXXX")"
  TREE="$CASE/tree"
  BIN="$CASE/bin"
  CALLS="$CASE/calls.log"
  mkdir -p "$TREE/ka-reader-mac/Sources/CKAReaderBridge" "$TREE/third_party/lucide/icons" \
    "$TREE/docs/design" "$BIN" "$CASE/tmp"
  : > "$CALLS"

  cp "$REAL_SCRIPT" "$TREE/ka-reader-mac/assemble.sh"
  chmod +x "$TREE/ka-reader-mac/assemble.sh"
  printf 'plist\n' > "$TREE/ka-reader-mac/Info.plist"
  printf 'entitlements\n' > "$TREE/ka-reader-mac/Entitlements.plist"
  printf 'module CKAReaderBridge {}\n' > "$TREE/ka-reader-mac/Sources/CKAReaderBridge/module.modulemap"
  printf '<svg/>\n' > "$TREE/third_party/lucide/icons/glyph.svg"
  printf 'glyph licence\n' > "$TREE/third_party/lucide/LICENSE"
  printf 'licence\n' > "$TREE/LICENSE"
  printf 'notices\n' > "$TREE/THIRD_PARTY_NOTICES.md"
  printf '<svg xmlns="http://www.w3.org/2000/svg"/>\n' > "$TREE/docs/design/app_icon.svg"

  for tool in $SYSTEM_TOOLS; do
    found="$(command -v "$tool")" || { echo "test_assemble.sh: no $tool on this machine" >&2; exit 1; }
    ln -s "$found" "$BIN/$tool"
  done
  for program in $STOOD_IN; do
    [ "$program" != "$omitted" ] || continue
    write_stand_in "$program"
  done
}

# One stand-in: appends its name and argv to the shared log, then does what its program's output is
# read for. `rustc -vV` answers an arm64 host so a run that gets past `cargo` could go on.
write_stand_in() {
  local program="$1"
  {
    echo '#!/bin/bash'
    echo "echo \"$program \$*\" >> \"$CALLS\""
    case "$program" in
      sips)
        echo 'out=""'
        echo 'while [ $# -gt 0 ]; do'
        echo '  if [ "$1" = "--out" ]; then out="$2"; fi'
        echo '  shift'
        echo 'done'
        echo "if [ -f \"$CASE/sips.fail\" ]; then echo 'sips: stand-in refusal' >&2; exit 1; fi"
        echo 'printf "png\n" > "$out"'
        ;;
      iconutil)
        echo 'out=""'
        echo 'while [ $# -gt 0 ]; do'
        echo '  if [ "$1" = "-o" ]; then out="$2"; fi'
        echo '  shift'
        echo 'done'
        echo "if [ -f \"$CASE/iconutil.fail\" ]; then echo 'iconutil: stand-in refusal' >&2; exit 1; fi"
        echo 'printf "icns\n" > "$out"'
        ;;
      cargo) echo 'exit 1' ;;
      rustc) echo 'echo "host: aarch64-apple-darwin"' ;;
    esac
  } > "$BIN/$program"
  chmod +x "$BIN/$program"
}

# Runs the case's copy of the script with nothing but the folders this suite built.
run_script() {
  /usr/bin/env -i PATH="$BIN" TMPDIR="$CASE/tmp" "$TREE/ka-reader-mac/assemble.sh" \
    > "$CASE/stdout" 2> "$CASE/stderr"
  STATUS=$?
  STDERR="$(cat "$CASE/stderr")"
}

# --- expectations ---

expect_real_script_bytes() {
  cmp -s "$REAL_SCRIPT" "$TREE/ka-reader-mac/assemble.sh" \
    || fail "the copy of ka-reader-mac/assemble.sh in the case's tree is not the real script's bytes"
}

expect_refusal() {
  [ "$STATUS" -ne 0 ] || fail "expected a non-zero exit, got 0. stderr: $STDERR"
}

expect_no_stand_in_called() {
  [ ! -s "$CALLS" ] || fail "a stand-in was called before the refusal. calls: $(cat "$CALLS")"
}

# The folder the generation made is gone: the case gave the script a TMPDIR of its own, so anything
# the script made with mktemp -d sits there.
expect_generation_folder_removed() {
  local leftover
  leftover="$(find "$CASE/tmp" -mindepth 1 | head -n 1)"
  [ -z "$leftover" ] || fail "the folder the icon was generated in is still there: $leftover"
}

# --- cases ---

# CP-1324: with no drawing the run stops with the other required inputs, before any program runs.
test_missing_drawing_stops_before_the_bridge_build() {
  new_case
  rm "$TREE/docs/design/app_icon.svg"
  expect_real_script_bytes || return 1

  run_script

  expect_refusal || return 1
  case "$STDERR" in
    *docs/design/app_icon.svg*) ;;
    *) fail "expected stderr to name docs/design/app_icon.svg. stderr: $STDERR" || return 1 ;;
  esac
  expect_no_stand_in_called
}

# The tier-2 guard of one program: the others are on PATH, the named one is not.
expect_program_named_when_missing() {
  local program="$1"
  new_case "$program"
  expect_real_script_bytes || return 1

  run_script

  expect_refusal || return 1
  [ "$STATUS" -eq 1 ] || fail "expected exit 1, got $STATUS. stderr: $STDERR" || return 1
  case "$STDERR" in
    "assemble.sh: "*"$program"*) ;;
    *) fail "expected stderr to name $program. stderr: $STDERR" || return 1 ;;
  esac
  expect_no_stand_in_called
}

test_missing_sips_is_named() { expect_program_named_when_missing sips; }
test_missing_iconutil_is_named() { expect_program_named_when_missing iconutil; }
test_missing_cargo_is_named() { expect_program_named_when_missing cargo; }
test_missing_rustc_is_named() { expect_program_named_when_missing rustc; }
test_missing_swift_is_named() { expect_program_named_when_missing swift; }
test_missing_codesign_is_named() { expect_program_named_when_missing codesign; }

# CP-1318, CP-1323 (b) by construction: ten sips calls, each handed the case tree's drawing, then one
# iconutil on the folder they wrote into, then cargo, which fails the run. Nothing lands in the tree.
test_icon_is_generated_from_the_drawing_before_the_bridge_build() {
  new_case
  expect_real_script_bytes || return 1
  local before after
  before="$(cd "$TREE" && find . | LC_ALL=C sort)"

  run_script

  after="$(cd "$TREE" && find . | LC_ALL=C sort)"
  local line name rest count=0 sips_count entry px found drawing out_dir="" out_path seen_dir
  local drawing_path="$TREE/docs/design/app_icon.svg"
  sips_count="$(grep -c '^sips ' "$CALLS")"
  [ "$sips_count" -eq 10 ] || fail "expected ten sips calls, got $sips_count. calls: $(cat "$CALLS")" || return 1

  while IFS= read -r line; do
    [ "${line%% *}" = "sips" ] || continue
    count=$((count + 1))
    set -- $line
    drawing=""
    out_path=""
    while [ $# -gt 0 ]; do
      case "$1" in
        "$drawing_path") drawing="$1" ;;
        --out) out_path="${2:-}" ;;
      esac
      shift
    done
    [ -n "$drawing" ] || fail "sips call $count was not handed the drawing in the case's tree: $line" || return 1
    seen_dir="$(dirname "$out_path")"
    if [ -z "$out_dir" ]; then
      out_dir="$seen_dir"
    elif [ "$out_dir" != "$seen_dir" ]; then
      fail "the --out paths are not all in one folder ending .iconset: $out_dir and $seen_dir" || return 1
    fi
  done < "$CALLS"

  case "$out_dir" in
    *.iconset) ;;
    *) fail "the --out paths are not all in one folder ending .iconset: $out_dir" || return 1 ;;
  esac
  case "$out_dir" in
    "$TREE"/*) fail "the .iconset folder is inside the case's tree: $out_dir" || return 1 ;;
  esac

  for found in $ICONSET_ENTRIES; do
    entry="${found%%:*}"
    px="${found##*:}"
    grep -q "^sips .*-z $px $px .*--out $out_dir/$entry.png\$" "$CALLS" \
      || fail "no sips call rendered $entry.png at $px px. calls: $(cat "$CALLS")" || return 1
  done

  local iconutil_count iconutil_line last_line
  iconutil_count="$(grep -c '^iconutil ' "$CALLS")"
  iconutil_line="$(grep '^iconutil ' "$CALLS" | head -n 1)"
  # sips lines are the first ten, so the line after them is the one iconutil call, on the folder.
  [ "$iconutil_count" -eq 1 ] && [ "$(sed -n 11p "$CALLS" | cut -d' ' -f1-3)" = "iconutil -c icns" ] \
    && [ "${iconutil_line##* }" = "$out_dir" ] \
    || fail "expected one iconutil -c icns call on the .iconset folder, after the sips calls. calls: $(cat "$CALLS")" || return 1
  last_line="$(tail -n 1 "$CALLS")"
  [ "$(sed -n 12p "$CALLS" | cut -d' ' -f1)" = "cargo" ] && [ "${last_line%% *}" = "cargo" ] \
    || fail "expected cargo to be called after iconutil, as the last call. calls: $(cat "$CALLS")" || return 1

  expect_generation_folder_removed || return 1
  [ "$before" = "$after" ] || fail "the case's tree holds files the run added: $(diff <(echo "$before") <(echo "$after"))"
}

# "Removed on every exit": a run that is refused after the folder is made leaves nothing behind.
test_icon_folder_is_removed_when_the_run_is_refused() {
  new_case
  : > "$CASE/iconutil.fail"
  expect_real_script_bytes || return 1

  run_script

  expect_refusal || return 1
  case "$STDERR" in
    "assemble.sh: iconutil could not pack the rendered sizes into the application icon, so nothing was built. iconutil printed: iconutil: stand-in refusal") ;;
    *) fail "expected stderr to name iconutil's refusal. stderr: $STDERR" || return 1 ;;
  esac
  expect_generation_folder_removed
}

# The other program the generation runs can refuse too: the run stops, names the size and the
# program's own words, and cleans up.
test_sips_failure_is_named_and_its_folder_removed() {
  new_case
  : > "$CASE/sips.fail"
  expect_real_script_bytes || return 1

  run_script

  expect_refusal || return 1
  case "$STDERR" in
    "assemble.sh: sips could not render $TREE/docs/design/app_icon.svg at 16 px, so nothing was built. sips printed: sips: stand-in refusal") ;;
    *) fail "expected stderr to name sips' refusal at 16 px. stderr: $STDERR" || return 1 ;;
  esac
  [ "$(grep -c '^cargo ' "$CALLS")" -eq 0 ] || fail "expected cargo to be called after iconutil, as the last call. calls: $(cat "$CALLS")" || return 1
  expect_generation_folder_removed
}

# --- the runner ---

selected="$CASES"
if [ -n "${KA_READER_TEST_ONLY:-}" ]; then
  selected="$KA_READER_TEST_ONLY"
  for wanted in $selected; do
    case "
$CASES
" in
      *"
$wanted
"*) ;;
      *) echo "test_assemble.sh: $wanted is no case of this suite" >&2; exit 1 ;;
    esac
  done
fi

passed=0
total=0
for case_name in $selected; do
  total=$((total + 1))
  if output="$("$case_name" 2>&1)"; then
    passed=$((passed + 1))
    echo "ok   $case_name"
  else
    echo "FAIL $case_name"
    echo "$output"
  fi
done
echo "$passed of $total passed"
[ "$passed" -eq "$total" ]
