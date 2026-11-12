#!/usr/bin/env bash
# checks/tests/test_app_icon.sh — the tests of checks/app-icon.sh.
# Version: 1.0.0 — first version: the check over a test-made app, with the compiler and the probe
#   stood in, every rule it holds and every state in which it cannot judge
#
# WHY THIS EXISTS
#   checks/app-icon.sh holds the built icon to the drawing's rules: one icon file, the seven sizes,
#   no second appearance, the drawing's colours, and a control that proves its probe can go red. A
#   bug in it is a rule nobody is checking. Every case here runs a byte copy of the real script
#   against an app the case makes in its own folder, with `swiftc` and `ka-reader-icon-probe`
#   standing in: the probe's reply is chosen by the file it is handed, so the bundle's icon and the
#   control's fixture answer differently. The real probe reading the real icon is held by the gate's
#   own step on the built bundle, not here.
#   The runner is this file: the product has no Python (docs/nfdr.md § 9), the same reason
#   checks/tests/test_entry_points.sh gives.
#
# USAGE
#   checks/tests/test_app_icon.sh
#     KA_READER_TEST_ONLY=<case> [<case> ...] runs the named cases. A name that is no case fails the
#     run.
#   Exit 0 when every case passes, 1 when a case fails or a name is no case. It launches nothing,
#   starts no real compiler and reads no home, so it runs on any host.
#
# WHY NO `set -e`
#   A case that fails must not end the run before the remaining cases report. Each case returns its
#   own status and the runner counts them.

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
REAL_SCRIPT="$ROOT/checks/app-icon.sh"

# The tools the script runs that answer only about the file or text they are handed. `swiftc` and
# `ka-reader-icon-probe` are not here: the case stands them in.
SYSTEM_TOOLS="bash dirname mktemp rm mkdir cat sed tr head cut wc od find sort plutil"

# The seven sizes, and a reply of ten representations that covers them: a 16 px entry for the
# 16 px size, 32 for both 32 px entries, and so on, as an iconset's ten entries do.
SEVEN_SIZES="16 32 64 128 256 512 1024"
GOOD_REPS="16x16:200 32x32:150 32x32:150 64x64:150 128x128:150 256x256:150 256x256:150 512x512:150 512x512:150 1024x1024:150"
CONTROL_REPS="16x16:4521 32x32:4400 1024x1024:4300"
# The chunk types the plain-image set holds: the table of contents and what iconutil wrote off the
# ten-entry iconset the gate builds.
GOOD_CHUNKS="ic04 ic05 ic07 ic08 ic09 ic10 ic11 ic12 ic13 ic14"

PASS_FILE_LINE="app-icon.sh: icon file: Contents/Resources/icon.icns, named by CFBundleIconFile, is the bundle's one .icns file; Contents/Info.plist has no CFBundleIconName and the bundle has no Assets.car"
PASS_SIZES_LINE="app-icon.sh: sizes: 10 representations, each square, covering 16, 32, 64, 128, 256, 512 and 1024 px; every chunk is in the plain-image set, so the icon has no second appearance"
PASS_COLOURS_LINE="app-icon.sh: colours: every fully opaque pixel of every representation lies within 2.00 levels of the #1E1F22–#FBFBFA line (bound: 2 levels); at 1024 px, (512, 512) is #1E1F22 and (512, 850) is #FBFBFA, both fully opaque, and (0, 0) is fully transparent"
PASS_CONTROL_LINE="app-icon.sh: control: checks/fixtures/stand-in-icon.icns, the stand-in application icon, lies up to 45.21 levels off the #1E1F22–#FBFBFA line — the expected red"

CASES="
test_drawn_icon_passes
test_icon_not_named_is_refused
test_named_icon_file_missing_is_refused
test_named_icon_file_as_a_symbolic_link_is_refused
test_second_icns_file_is_refused
test_asset_catalogue_is_refused
test_icon_name_key_is_refused
test_named_icon_file_that_is_a_folder_is_refused
test_file_without_the_icns_header_is_refused
test_chunk_that_runs_past_the_file_is_refused
test_chunk_shorter_than_its_header_and_trailing_bytes_are_refused
test_chunk_outside_the_plain_image_set_is_refused
test_dark_appearance_chunk_is_refused
test_each_missing_size_is_named
test_non_square_representation_is_refused
test_distance_over_the_bound_is_refused
test_distance_at_the_bound_passes
test_pupil_pixel_off_by_one_is_refused
test_ground_pixel_off_by_one_is_refused
test_corner_pixel_not_transparent_is_refused
test_control_on_the_line_is_refused
test_control_fixture_missing_is_refused
test_app_that_does_not_exist_is_named
test_path_without_a_plist_is_named
test_reply_the_check_cannot_read_is_named
test_no_argument_prints_the_usage_line
test_two_arguments_print_the_usage_line
test_swiftc_absent_is_named
test_probe_that_does_not_compile_is_named
test_probe_that_cannot_read_a_file_is_named
test_int_ends_with_130
test_term_ends_with_143
test_temporary_folder_is_removed_after_a_pass
test_temporary_folder_is_removed_after_a_refusal
"

WORK="$(mktemp -d)" || { echo "test_app_icon.sh: cannot create a temporary folder" >&2; exit 1; }
trap 'rm -rf "$WORK"' EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

fail() {
  echo "$*"
  return 1
}

# --- bytes the cases write ---

# One byte, given as a number.
byte() {
  printf "\\$(printf '%03o' "$1")"
}

# A 4-byte big-endian number.
be32() {
  byte $(((${1} >> 24) & 255))
  byte $(((${1} >> 16) & 255))
  byte $(((${1} >> 8) & 255))
  byte $((${1} & 255))
}

# An .icns byte file: the 8-byte header, then one chunk of 4 payload bytes for each type after $1.
write_icns() {
  local file="$1" type
  shift
  {
    printf 'icns'
    be32 $((8 + $# * 12))
    for type in "$@"; do
      printf '%s' "$type"
      be32 12
      printf 'abcd'
    done
  } > "$file"
}

# --- one case's tree, app, stand-ins and replies ---

# A reply as the probe prints it: one `rep <width> <height> <distance>` line per representation, in
# the order of the tokens `<width>x<height>:<distance>` given, then the three pixels of the 1024 px
# representation. The pixels are the globals REPLY_PUPIL, REPLY_GROUND and REPLY_CORNER (`r g b a`).
reply_lines() {
  local token size distance
  for token in $1; do
    size="${token%%:*}"
    distance="${token##*:}"
    echo "rep ${size%%x*} ${size##*x} $distance"
  done
  echo "pixel 512 512 $REPLY_PUPIL"
  echo "pixel 512 850 $REPLY_GROUND"
  echo "pixel 0 0 $REPLY_CORNER"
}

write_replies() {
  REPLY_PUPIL="30 31 34 255"
  REPLY_GROUND="251 251 250 255"
  REPLY_CORNER="0 0 0 0"
  reply_lines "$GOOD_REPS" > "$CASE/reply.icon"
  reply_lines "$CONTROL_REPS" > "$CASE/reply.control"
}

# Lays out, in its own folder: a tree holding a byte copy of the real script, the probe's source and
# the control's fixture; a test-made app whose plist names icon.icns; a bin folder holding the system
# tools and the two stand-ins (the one named in $1 left out). The probe stand-in's reply is chosen by
# the file it is handed.
new_case() {
  local omitted="${1:-}" tool found
  CASE="$(mktemp -d "$WORK/case.XXXXXX")"
  TREE="$CASE/tree"
  APP="$CASE/KA-Reader.app"
  BIN="$CASE/bin"
  CALLS="$CASE/calls.log"
  mkdir -p "$TREE/checks/icon_probe" "$TREE/checks/fixtures" "$APP/Contents/Resources" "$BIN" "$CASE/tmp"
  : > "$CALLS"

  cp "$REAL_SCRIPT" "$TREE/checks/app-icon.sh"
  chmod +x "$TREE/checks/app-icon.sh"
  printf '// stand-in source\n' > "$TREE/checks/icon_probe/main.swift"
  printf 'fixture\n' > "$TREE/checks/fixtures/stand-in-icon.icns"
  write_plist "icon.icns" ""
  write_icns "$APP/Contents/Resources/icon.icns" $GOOD_CHUNKS
  write_replies

  for tool in $SYSTEM_TOOLS; do
    found="$(command -v "$tool")" || { echo "test_app_icon.sh: no $tool on this machine" >&2; exit 1; }
    ln -s "$found" "$BIN/$tool"
  done
  [ "$omitted" = "swiftc" ] || write_swiftc
  write_probe
}

# The app's Info.plist: $1 is the CFBundleIconFile value (empty for none), $2 the CFBundleIconName
# value (empty for none).
write_plist() {
  {
    echo '<?xml version="1.0" encoding="UTF-8"?>'
    echo '<plist version="1.0"><dict>'
    echo '<key>CFBundleExecutable</key><string>KAReader</string>'
    [ -z "$1" ] || echo "<key>CFBundleIconFile</key><string>$1</string>"
    [ -z "$2" ] || echo "<key>CFBundleIconName</key><string>$2</string>"
    echo '</dict></plist>'
  } > "$APP/Contents/Info.plist"
}

# `swiftc` logs its argv and writes nothing; the probe stand-in is already ahead of the folder the
# script appends to PATH. A flag file makes it fail.
write_swiftc() {
  {
    echo '#!/bin/bash'
    echo "echo \"swiftc \$*\" >> \"$CALLS\""
    echo "if [ -f \"$CASE/swiftc.fail\" ]; then echo 'swiftc: stand-in error' >&2; exit 1; fi"
  } > "$BIN/swiftc"
  chmod +x "$BIN/swiftc"
}

# The probe stand-in: logs the file it is handed, then answers from the control's reply when that file
# is the fixture and from the icon's reply otherwise. A flag file makes it fail on the icon, and
# $CASE/probe.signal names a signal it sends to its parent before it returns.
write_probe() {
  {
    echo '#!/bin/bash'
    echo "echo \"ka-reader-icon-probe \$*\" >> \"$CALLS\""
    echo 'case "$1" in'
    echo '  *stand-in-icon.icns) cat "'"$CASE"'/reply.control"; exit 0 ;;'
    echo 'esac'
    echo "if [ -f \"$CASE/probe.fail\" ]; then echo \"ka-reader-icon-probe: cannot open \$1 as an image\" >&2; exit 1; fi"
    echo "if [ -f \"$CASE/probe.signal\" ]; then kill -\$(cat \"$CASE/probe.signal\") \$PPID; fi"
    echo "cat \"$CASE/reply.icon\""
  } > "$BIN/ka-reader-icon-probe"
  chmod +x "$BIN/ka-reader-icon-probe"
}

# Runs the case's copy of the script with nothing but the folders this suite built.
run_check() {
  /usr/bin/env -i PATH="$BIN" TMPDIR="$CASE/tmp" "$TREE/checks/app-icon.sh" "$@" \
    > "$CASE/stdout" 2> "$CASE/stderr"
  STATUS=$?
  STDOUT="$(cat "$CASE/stdout")"
  STDERR="$(cat "$CASE/stderr")"
}

# The usual run: the case's app, as an absolute path.
run_on_app() {
  run_check "$APP"
}

# --- expectations ---

expect_real_script_bytes() {
  cmp -s "$REAL_SCRIPT" "$TREE/checks/app-icon.sh" \
    || fail "the copy of checks/app-icon.sh in the case's tree is not the real script's bytes"
}

expect_exit() {
  [ "$STATUS" -eq "$1" ] || fail "expected exit $1, got $STATUS. stdout: $STDOUT stderr: $STDERR"
}

expect_stdout_line() {
  printf '%s\n' "$STDOUT" | grep -q -x -F -- "$1" || fail "stdout lacks the exact line: $1. stdout: $STDOUT"
}

expect_stderr_line() {
  printf '%s\n' "$STDERR" | grep -q -x -F -- "$1" || fail "stderr lacks the exact line: $1. stderr: $STDERR"
}

expect_stdout_empty() {
  [ -z "$STDOUT" ] || fail "expected stdout to be empty. stdout: $STDOUT"
}

expect_stderr_empty() {
  [ -z "$STDERR" ] || fail "expected stderr to be empty. stderr: $STDERR"
}

# The closing line of a refusal, for the app as the case gave it.
closing_line() {
  echo "app-icon.sh: the application icon in $APP does not hold this check's rules; each finding is named above. The icon is generated from docs/design/app_icon.svg by ka-reader-mac/assemble.sh, and the rules are in checks/app-icon.sh's header."
}

# A refusal: exit 1, the finding $1 on stderr, then the closing line as stderr's last line.
expect_refusal_with() {
  expect_exit 1 || return 1
  expect_stderr_line "$1" || return 1
  [ "$(printf '%s\n' "$STDERR" | tail -n 1)" = "$(closing_line)" ] \
    || fail "expected the closing line to end stderr. stderr: $STDERR"
}

# Nothing is left in the case's TMPDIR: the script made one folder there and removed it.
expect_temporary_folder_removed() {
  local leftover
  leftover="$(find "$CASE/tmp" -mindepth 1 | head -n 1)"
  [ -z "$leftover" ] || fail "the temporary folder is still there: $leftover"
}

# $1 with every representation of the pixel size $2 taken out.
without_size() {
  local token kept=""
  for token in $1; do
    [ "${token%%x*}" = "$2" ] || kept="$kept $token"
  done
  printf '%s' "$kept"
}

# --- cases ---

# CP-1320 to CP-1322: a test-made app whose reply holds every rule passes with the three lines and
# the control's line on stdout and nothing on stderr.
test_drawn_icon_passes() {
  new_case
  expect_real_script_bytes || return 1

  run_on_app

  expect_exit 0 || return 1
  expect_stdout_line "$PASS_FILE_LINE" || return 1
  expect_stdout_line "$PASS_SIZES_LINE" || return 1
  expect_stdout_line "$PASS_COLOURS_LINE" || return 1
  expect_stdout_line "$PASS_CONTROL_LINE" || return 1
  [ "$(printf '%s\n' "$STDOUT" | wc -l | tr -d ' ')" -eq 4 ] || fail "expected exactly four lines on stdout. stdout: $STDOUT" || return 1
  expect_stderr_empty
}

# CP-1320: Info.plist names no CFBundleIconFile.
test_icon_not_named_is_refused() {
  new_case
  write_plist "" ""

  run_on_app

  expect_refusal_with "icon not named: Contents/Info.plist has no CFBundleIconFile that plutil can read"
}

test_named_icon_file_missing_is_refused() {
  new_case
  rm "$APP/Contents/Resources/icon.icns"

  run_on_app

  expect_refusal_with "icon file missing: Contents/Resources/icon.icns, which CFBundleIconFile names"
}

# A symbolic link counts as not regular, even when it points at a real icon.
test_named_icon_file_as_a_symbolic_link_is_refused() {
  new_case
  mv "$APP/Contents/Resources/icon.icns" "$APP/Contents/Resources/real.bin"
  ln -s real.bin "$APP/Contents/Resources/icon.icns"

  run_on_app

  expect_refusal_with "icon file is a symbolic link: Contents/Resources/icon.icns, which CFBundleIconFile names"
}

test_second_icns_file_is_refused() {
  new_case
  cp "$APP/Contents/Resources/icon.icns" "$APP/Contents/Resources/extra.icns"

  run_on_app

  expect_refusal_with "second .icns file: Contents/Resources/extra.icns"
}

test_asset_catalogue_is_refused() {
  new_case
  printf 'catalogue\n' > "$APP/Contents/Resources/Assets.car"

  run_on_app

  expect_refusal_with "asset catalogue: Contents/Resources/Assets.car"
}

test_icon_name_key_is_refused() {
  new_case
  write_plist "icon.icns" "AppIcon"

  run_on_app

  expect_refusal_with "CFBundleIconName in Contents/Info.plist: AppIcon"
}

# CP-1320: a folder where the named file should be is neither a regular file nor a link.
test_named_icon_file_that_is_a_folder_is_refused() {
  new_case
  rm "$APP/Contents/Resources/icon.icns"
  mkdir "$APP/Contents/Resources/icon.icns"

  run_on_app

  expect_refusal_with "icon file is not a regular file: Contents/Resources/icon.icns, which CFBundleIconFile names"
}

# CP-1321: a file that does not start with the icns header is named, and the probe is not asked.
test_file_without_the_icns_header_is_refused() {
  new_case
  printf 'not an icon\n' > "$APP/Contents/Resources/icon.icns"

  run_on_app

  expect_refusal_with "icon file has no icns header: Contents/Resources/icon.icns" || return 1
  [ "$(grep -c '^ka-reader-icon-probe ' "$CALLS")" -eq 1 ] || fail "the probe read a file with no icns header (only the control may be read). calls: $(cat "$CALLS")"
}

# CP-1321: a chunk whose length runs past the end of the file is named at its byte offset.
test_chunk_that_runs_past_the_file_is_refused() {
  new_case
  {
    printf 'icns'
    be32 20
    printf 'ic07'
    be32 99
    printf 'abcd'
  } > "$APP/Contents/Resources/icon.icns"

  run_on_app

  expect_refusal_with "icon file's chunks do not fit its length: Contents/Resources/icon.icns, at byte 8"
}

# CP-1321: a chunk whose length is below its own 8-byte header, and bytes left over that are too few
# for a header, are each named at their byte offset (the first would otherwise never advance the walk).
test_chunk_shorter_than_its_header_and_trailing_bytes_are_refused() {
  new_case
  {
    printf 'icns'
    be32 16
    printf 'ic07'
    be32 4
  } > "$APP/Contents/Resources/icon.icns"

  run_on_app

  expect_refusal_with "icon file's chunks do not fit its length: Contents/Resources/icon.icns, at byte 8" || return 1

  new_case
  {
    printf 'icns'
    be32 17
    printf 'ic07'
    be32 8
    printf 'abcde'
  } > "$APP/Contents/Resources/icon.icns"

  run_on_app

  expect_refusal_with "icon file's chunks do not fit its length: Contents/Resources/icon.icns, at byte 16"
}

# CP-1321: a chunk type outside the plain-image set is named by its four bytes.
test_chunk_outside_the_plain_image_set_is_refused() {
  new_case
  write_icns "$APP/Contents/Resources/icon.icns" $GOOD_CHUNKS icxx

  run_on_app

  expect_refusal_with "chunk outside the plain-image set: icxx in Contents/Resources/icon.icns"
}

# CP-1321: the platform's own type for a dark appearance is not pinned by any document in this tree,
# so the case stands a type of the kind in for it. The rule is any type outside the set.
test_dark_appearance_chunk_is_refused() {
  new_case
  write_icns "$APP/Contents/Resources/icon.icns" ic07 icdk ic08

  run_on_app

  expect_refusal_with "chunk outside the plain-image set: icdk in Contents/Resources/icon.icns"
}

# CP-1321: each of the seven sizes, taken out of the reply in turn, is named.
test_each_missing_size_is_named() {
  local size
  for size in $SEVEN_SIZES; do
    new_case
    reply_lines "$(without_size "$GOOD_REPS" "$size")" > "$CASE/reply.icon"

    run_on_app

    expect_refusal_with "size missing: no $size px square representation in Contents/Resources/icon.icns" || return 1
  done
}

test_non_square_representation_is_refused() {
  new_case
  reply_lines "${GOOD_REPS/16x16/16x15}" > "$CASE/reply.icon"

  run_on_app

  expect_refusal_with "representation not square: representation 1 is 16 by 15 px"
}

# CP-1322: the bound is exactly 2 levels, 200 hundredths.
test_distance_over_the_bound_is_refused() {
  new_case
  reply_lines "${GOOD_REPS/16x16:200/16x16:201}" > "$CASE/reply.icon"

  run_on_app

  expect_refusal_with "pixel off the drawing's colours: representation 1 (16 px) has a fully opaque pixel 2.01 levels off the #1E1F22–#FBFBFA line (bound: 2 levels)"
}

test_distance_at_the_bound_passes() {
  new_case
  reply_lines "${GOOD_REPS//150/200}" > "$CASE/reply.icon"

  run_on_app

  expect_exit 0 || return 1
  expect_stdout_line "$PASS_COLOURS_LINE"
}

# CP-1322: each fixed pixel of the 1024 px representation, one level off.
test_pupil_pixel_off_by_one_is_refused() {
  new_case
  REPLY_PUPIL="31 31 34 255"
  reply_lines "$GOOD_REPS" > "$CASE/reply.icon"

  run_on_app

  expect_refusal_with "pupil pixel: (512, 512) of the 1024 px representation reads 31, 31, 34 at alpha 255; the drawing gives 30, 31, 34 at alpha 255 (#1E1F22)"
}

test_ground_pixel_off_by_one_is_refused() {
  new_case
  REPLY_GROUND="251 251 249 255"
  reply_lines "$GOOD_REPS" > "$CASE/reply.icon"

  run_on_app

  expect_refusal_with "ground pixel: (512, 850) of the 1024 px representation reads 251, 251, 249 at alpha 255; the drawing gives 251, 251, 250 at alpha 255 (#FBFBFA)"
}

test_corner_pixel_not_transparent_is_refused() {
  new_case
  REPLY_CORNER="0 0 0 1"
  reply_lines "$GOOD_REPS" > "$CASE/reply.icon"

  run_on_app

  expect_refusal_with "corner pixel: (0, 0) of the 1024 px representation has alpha 1; outside the drawing's rounded square it is 0"
}

# The in-run control: a fixture the probe reads as on the line means the probe cannot tell the
# stand-in from the drawing, so the check proves nothing.
test_control_on_the_line_is_refused() {
  new_case
  reply_lines "16x16:200 32x32:100" > "$CASE/reply.control"

  run_on_app

  expect_exit 1 || return 1
  expect_stderr_line "app-icon.sh: the control, checks/fixtures/stand-in-icon.icns, read within 2 levels of the #1E1F22–#FBFBFA line in every representation: the probe cannot tell the stand-in from the drawing, so this check proves nothing. The probe's measure is in checks/icon_probe/main.swift."
}

test_control_fixture_missing_is_refused() {
  new_case
  rm "$TREE/checks/fixtures/stand-in-icon.icns"

  run_on_app

  expect_exit 1 || return 1
  expect_stderr_line "app-icon.sh: the control's icon, checks/fixtures/stand-in-icon.icns, is not a regular file, so the check stopped without a verdict. Restore it with git checkout -- checks/fixtures/stand-in-icon.icns and run the check again."
}

# QC-70: a path that does not exist, and a folder that is no app, each end in one line and read nothing.
test_app_that_does_not_exist_is_named() {
  new_case

  run_check "$CASE/Absent.app"

  expect_exit 1 || return 1
  expect_stderr_line "app-icon.sh: not found: $CASE/Absent.app. Build the app with ka-reader-mac/assemble.sh, or give the path to a built app." || return 1
  expect_stdout_empty
}

test_path_without_a_plist_is_named() {
  new_case
  rm "$APP/Contents/Info.plist"

  run_on_app

  expect_exit 1 || return 1
  expect_stderr_line "app-icon.sh: not an application bundle: $APP has no Contents/Info.plist, so the check stopped without a verdict. Give the path to a built app."
}

# A reply line the check cannot read ends the run naming the line; a 1024 px representation with no
# pixel lines after it is named by its own line.
test_reply_the_check_cannot_read_is_named() {
  new_case
  { echo "rep sixteen 16 200"; cat "$CASE/reply.icon"; } > "$CASE/reply.garbled"
  mv "$CASE/reply.garbled" "$CASE/reply.icon"

  run_on_app

  expect_exit 1 || return 1
  expect_stderr_line "app-icon.sh: the icon probe's reply on Contents/Resources/icon.icns is not one this check reads, so its pixels were not judged. The line it could not read: rep sixteen 16 200" || return 1

  new_case
  reply_lines "$GOOD_REPS" | head -n 10 > "$CASE/reply.icon"

  run_on_app

  expect_exit 1 || return 1
  expect_stderr_line "app-icon.sh: the icon probe's reply on Contents/Resources/icon.icns is not one this check reads, so its pixels were not judged. The line it could not read: rep 1024 1024 150"
}

# QC-70: a different argument count is exit 2 with the usage line, and nothing is read or run.
test_no_argument_prints_the_usage_line() {
  new_case

  run_check

  expect_exit 2 || return 1
  expect_stderr_line "app-icon.sh: takes one argument, the path to an app; arguments given: 0. Usage: checks/app-icon.sh <path-to-app>" || return 1
  expect_stdout_empty || return 1
  [ ! -s "$CALLS" ] || fail "a stand-in was called. calls: $(cat "$CALLS")"
}

test_two_arguments_print_the_usage_line() {
  new_case

  run_check "$APP" "$APP"

  expect_exit 2 || return 1
  expect_stderr_line "app-icon.sh: takes one argument, the path to an app; arguments given: 2. Usage: checks/app-icon.sh <path-to-app>" || return 1
  [ ! -s "$CALLS" ] || fail "a stand-in was called. calls: $(cat "$CALLS")"
}

test_swiftc_absent_is_named() {
  new_case swiftc

  run_on_app

  expect_exit 1 || return 1
  expect_stderr_line "app-icon.sh: swiftc not found on PATH — the icon probe (checks/icon_probe/main.swift) is compiled with it, so the check stopped without a verdict."
}

test_probe_that_does_not_compile_is_named() {
  new_case
  : > "$CASE/swiftc.fail"

  run_on_app

  expect_exit 1 || return 1
  expect_stderr_line "app-icon.sh: the icon probe did not compile, so the check stopped without a verdict: swiftc: stand-in error"
}

test_probe_that_cannot_read_a_file_is_named() {
  new_case
  : > "$CASE/probe.fail"

  run_on_app

  expect_exit 1 || return 1
  expect_stderr_line "app-icon.sh: the icon probe could not read Contents/Resources/icon.icns, so its pixels were not judged. The probe printed: ka-reader-icon-probe: cannot open $APP/Contents/Resources/icon.icns as an image"
}

# QC-70: a signal ends the run with its own status, never 0. The probe stand-in sends the signal to
# its parent, the script, and returns, so the case is deterministic. A suite cannot deliver a signal
# to a background job of a non-interactive shell, which is why the stand-in does.
test_int_ends_with_130() {
  new_case
  echo INT > "$CASE/probe.signal"

  run_on_app

  expect_exit 130
}

test_term_ends_with_143() {
  new_case
  echo TERM > "$CASE/probe.signal"

  run_on_app

  expect_exit 143
}

test_temporary_folder_is_removed_after_a_pass() {
  new_case

  run_on_app

  expect_exit 0 || return 1
  expect_temporary_folder_removed
}

test_temporary_folder_is_removed_after_a_refusal() {
  new_case
  rm "$APP/Contents/Resources/icon.icns"

  run_on_app

  expect_exit 1 || return 1
  expect_temporary_folder_removed
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
      *) echo "test_app_icon.sh: $wanted is no case of this suite" >&2; exit 1 ;;
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
