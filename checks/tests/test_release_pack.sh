#!/usr/bin/env bash
# checks/tests/test_release_pack.sh — the tests of checks/release-pack.sh, which packs the built
# bundle into the release's disk image (CP-1176).
# Version: 1.1.0 — a copy dragged off the mounted image keeps the licence and the notices
# Version: 1.0.0 — first version: the gate-built bundle packed and mounted, the refusals that leave
#   nothing behind, the signal path, and every exit status the script returns
#
# WHY THIS EXISTS
#   The image is what a person downloads. These cases run the real script — never a copy of its
#   logic. One packs the bundle the gate built, mounts the image read-only and reads it as a person
#   does: one visible item, KA-Reader.app, still ad-hoc signed and still verifying, under the volume
#   name the change text fixes. The others hand the script a scratch bundle or a stand-in
#   hdiutil first on PATH, to show that every refusal leaves no output folder and no staging folder
#   behind, including the refusal a terminate signal causes.
#
# USAGE
#   checks/tests/test_release_pack.sh
#     KA_READER_TEST_ONLY=<case> runs one case.
#   It reads the bundle the gate's "Build KA-Reader.app" step wrote, at
#   target/release/bundle/macos/KA-Reader.app, so it runs after that step. It mounts an image, so
#   it needs a macOS session that allows hdiutil attach.
#
# WHY NO `set -e`
#   A case that fails must not end the run before the remaining cases report. Each case returns its
#   own status and the runner counts them.
#
# WHERE IT WRITES
#   Only below one `mktemp -d` directory, removed by a trap on exit, which also detaches an image a
#   failed case left mounted. The tree is read, never written.

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SCRIPT="$ROOT/checks/release-pack.sh"
TREE_BUNDLE="$ROOT/target/release/bundle/macos/KA-Reader.app"
PLIST_BUDDY="/usr/libexec/PlistBuddy"
KEY="CFBundleShortVersionString"
# The volume name change_text.md gives, placed as written.
VOLUME_NAME="KA-Reader"

STATUS=0
OUT=""
ERR=""
WORK=""
MOUNT=""

CASES="
test_the_gate_built_bundle_packs
test_a_copy_off_the_image_keeps_the_licence_and_notices
test_an_existing_outdir_is_refused
test_a_directory_that_is_not_a_bundle_is_refused
test_a_bundle_with_no_version_key_is_refused
test_a_version_that_cannot_name_a_file_is_refused
test_a_failing_image_tool_is_refused_and_leaves_nothing
test_a_terminate_signal_ends_1_and_removes_the_staging
test_a_wrong_argument_count_exits_2
"

# --- helpers ---

fail() {
  echo "  $*"
  return 1
}

show_output() {
  printf '%s\n%s\n' "$OUT" "$ERR" | sed '/^$/d; s/^/  /'
}

# Runs the script with the arguments given, keeping its status and its two streams.
run_script() {
  "$SCRIPT" "$@" > "$WORK/stdout" 2> "$WORK/stderr"
  STATUS=$?
  OUT="$(cat "$WORK/stdout")"
  ERR="$(cat "$WORK/stderr")"
}

# A scratch bundle folder at $1 whose Info.plist carries the version $2 ("" for no key).
write_bundle() {
  rm -rf "$1"
  mkdir -p "$1/Contents/MacOS"
  printf 'scratch\n' > "$1/Contents/MacOS/KAReader"
  "$PLIST_BUDDY" -c "Add :CFBundleIdentifier string com.example.scratch" "$1/Contents/Info.plist" > /dev/null
  if [ -n "$2" ]; then
    "$PLIST_BUDDY" -c "Add :$KEY string $2" "$1/Contents/Info.plist" > /dev/null
  fi
}

# A stand-in hdiutil in the folder $1. It records that it ran in $1/ran, writes a partial file at
# the last argument as the real tool would, then does what the mode $2 says: "fail" exits 1, "wait"
# becomes a sleep a signal must interrupt.
write_hdiutil_stand_in() {
  mkdir -p "$1"
  cat > "$1/hdiutil" <<STUB
#!/usr/bin/env bash
for last; do :; done
: > "\$last"
: > "$1/ran"
case "$2" in
  fail) exit 1 ;;
  wait) exec sleep 30 ;;
esac
STUB
  chmod 755 "$1/hdiutil"
}

# Detaches the image mounted at \$MOUNT, if any.
detach_mount() {
  if [ -n "$MOUNT" ]; then
    hdiutil detach "$MOUNT" -force > /dev/null 2>&1 || true
    MOUNT=""
  fi
}

# The last run ended with status $1 and printed a line on stderr.
expect_status() {
  [ "$STATUS" -eq "$1" ] && return 0
  fail "expected exit $1, got $STATUS. Its output follows."
  show_output
  return 1
}

# The last run's stderr holds the text $1 (the refusal says which rule refused).
expect_err_has() {
  case "$ERR" in
    *"$1"*) return 0 ;;
  esac
  fail "the refusal does not say \"$1\". Its output follows."
  show_output
  return 1
}

# --- cases ---

# CP-1176: the gate-built bundle packs into one image that mounts as one signed app.
test_the_gate_built_bundle_packs() {
  [ -d "$TREE_BUNDLE" ] || { fail "no bundle at $TREE_BUNDLE: run \"Build KA-Reader.app\" (ka-reader-mac/assemble.sh) first"; return 1; }
  version="$("$PLIST_BUDDY" -c "Print :$KEY" "$TREE_BUNDLE/Contents/Info.plist")" || { fail "the bundle has no $KEY"; return 1; }
  outdir="$WORK/pack/dist"
  mkdir -p "$WORK/pack"
  run_script "$TREE_BUNDLE" "$outdir"
  expect_status 0 || return 1
  held="$(ls -A "$outdir")"
  [ "$held" = "KA-Reader-$version.dmg" ] || { fail "the output folder holds \"$held\", expected only KA-Reader-$version.dmg"; return 1; }

  MOUNT="$WORK/pack/mnt"
  mkdir -p "$MOUNT"
  hdiutil attach -nobrowse -readonly -mountpoint "$MOUNT" "$outdir/KA-Reader-$version.dmg" > "$WORK/attach.log" 2>&1 \
    || { fail "the image did not mount: $(cat "$WORK/attach.log")"; MOUNT=""; return 1; }
  visible="$(ls "$MOUNT")"
  if [ "$visible" != "KA-Reader.app" ]; then
    fail "the mounted volume shows \"$visible\", expected KA-Reader.app only"
    detach_mount
    return 1
  fi
  # No other file, hidden ones included: a background picture (.background), a volume icon
  # (.VolumeIcon.icns) and a Finder window layout (.DS_Store) are all dot-files ls does not show.
  held="$(ls -A "$MOUNT")"
  if [ "$held" != "KA-Reader.app" ]; then
    fail "the mounted volume holds \"$held\", expected KA-Reader.app and no hidden file"
    detach_mount
    return 1
  fi
  if ! codesign --verify --strict "$MOUNT/KA-Reader.app" > "$WORK/verify.log" 2>&1; then
    fail "codesign --verify --strict refused the mounted copy: $(cat "$WORK/verify.log")"
    detach_mount
    return 1
  fi
  # Captured first: grep -q would close the pipe on codesign, and pipefail reads that as a failure.
  details="$(codesign -dv "$MOUNT/KA-Reader.app" 2>&1)"
  if ! printf '%s\n' "$details" | grep -q 'Signature=adhoc'; then
    fail "the mounted copy is not ad-hoc signed"
    detach_mount
    return 1
  fi
  volume="$(diskutil info -plist "$MOUNT" | plutil -extract VolumeName raw -o - -)"
  detach_mount
  [ "$volume" = "$VOLUME_NAME" ] || { fail "the volume is named \"$volume\", expected \"$VOLUME_NAME\""; return 1; }
}

# CP-1211: the licence and the notices travel with the app when a person drags it off the image.
# The gate-built bundle is packed and mounted read-only, the app is copied off with ditto, and both
# copies in that copy are the tree's files byte for byte. The mount is detached before the copy is
# read, so every path through the case leaves nothing mounted.
test_a_copy_off_the_image_keeps_the_licence_and_notices() {
  [ -d "$TREE_BUNDLE" ] || { fail "no bundle at $TREE_BUNDLE: run \"Build KA-Reader.app\" (ka-reader-mac/assemble.sh) first"; return 1; }
  version="$("$PLIST_BUDDY" -c "Print :$KEY" "$TREE_BUNDLE/Contents/Info.plist")" || { fail "the bundle has no $KEY"; return 1; }
  outdir="$WORK/pack-off-image/dist"
  mkdir -p "$WORK/pack-off-image"
  run_script "$TREE_BUNDLE" "$outdir"
  expect_status 0 || return 1

  MOUNT="$WORK/pack-off-image/mnt"
  dragged="$WORK/pack-off-image/dragged"
  mkdir -p "$MOUNT" "$dragged"
  hdiutil attach -nobrowse -readonly -mountpoint "$MOUNT" "$outdir/KA-Reader-$version.dmg" > "$WORK/attach-off-image.log" 2>&1 \
    || { fail "the image did not mount: $(cat "$WORK/attach-off-image.log")"; MOUNT=""; return 1; }
  if ! ditto "$MOUNT/KA-Reader.app" "$dragged/KA-Reader.app" > "$WORK/ditto-off-image.log" 2>&1; then
    fail "the app could not be copied off the image: $(cat "$WORK/ditto-off-image.log")"
    detach_mount
    return 1
  fi
  detach_mount

  cmp -s "$ROOT/LICENSE" "$dragged/KA-Reader.app/Contents/Resources/KA-Reader-LICENSE" \
    || { fail "the copy off the image lacks the tree's LICENSE as Contents/Resources/KA-Reader-LICENSE, or it differs"; return 1; }
  cmp -s "$ROOT/THIRD_PARTY_NOTICES.md" "$dragged/KA-Reader.app/Contents/Resources/THIRD_PARTY_NOTICES.md" \
    || { fail "the copy off the image lacks the tree's THIRD_PARTY_NOTICES.md, or it differs"; return 1; }
}

test_an_existing_outdir_is_refused() {
  write_bundle "$WORK/existing/KA-Reader.app" 0.0.0
  mkdir -p "$WORK/existing/dist"
  printf 'keep\n' > "$WORK/existing/dist/keep.txt"
  run_script "$WORK/existing/KA-Reader.app" "$WORK/existing/dist"
  expect_status 1 || return 1
  expect_err_has "already exists" || return 1
  [ "$(ls -A "$WORK/existing/dist")" = "keep.txt" ] || { fail "the existing output folder was changed"; return 1; }
  [ "$(cat "$WORK/existing/dist/keep.txt")" = "keep" ] || { fail "the existing file was changed"; return 1; }
}

test_a_directory_that_is_not_a_bundle_is_refused() {
  mkdir -p "$WORK/not-bundle/plain"
  run_script "$WORK/not-bundle/plain" "$WORK/not-bundle/dist"
  expect_status 1 || return 1
  expect_err_has "is not a bundle" || return 1
  [ ! -e "$WORK/not-bundle/dist" ] || { fail "a refusal created the output folder"; return 1; }
}

test_a_bundle_with_no_version_key_is_refused() {
  write_bundle "$WORK/no-key/KA-Reader.app" ""
  run_script "$WORK/no-key/KA-Reader.app" "$WORK/no-key/dist"
  expect_status 1 || return 1
  expect_err_has "CFBundleShortVersionString" || return 1
  [ ! -e "$WORK/no-key/dist" ] || { fail "a refusal created the output folder"; return 1; }
}

# A version is the stem of the image's file name, so one that holds a slash would write elsewhere.
test_a_version_that_cannot_name_a_file_is_refused() {
  write_bundle "$WORK/odd-version/KA-Reader.app" "../0.0.0"
  run_script "$WORK/odd-version/KA-Reader.app" "$WORK/odd-version/dist"
  expect_status 1 || return 1
  expect_err_has "cannot name a file" || return 1
  [ ! -e "$WORK/odd-version/dist" ] || { fail "a refusal created the output folder"; return 1; }
}

test_a_failing_image_tool_is_refused_and_leaves_nothing() {
  write_bundle "$WORK/tool-fails/KA-Reader.app" 0.0.0
  write_hdiutil_stand_in "$WORK/tool-fails/bin" fail
  mkdir -p "$WORK/tool-fails/tmp"
  PATH="$WORK/tool-fails/bin:$PATH" TMPDIR="$WORK/tool-fails/tmp" run_script "$WORK/tool-fails/KA-Reader.app" "$WORK/tool-fails/dist"
  expect_status 1 || return 1
  [ -e "$WORK/tool-fails/bin/ran" ] || { fail "the stand-in hdiutil never ran, so the case proved nothing"; return 1; }
  [ ! -e "$WORK/tool-fails/dist" ] || { fail "the partial output folder was left behind"; return 1; }
  [ -z "$(ls -A "$WORK/tool-fails/tmp")" ] || { fail "a staging folder was left behind: $(ls -A "$WORK/tool-fails/tmp")"; return 1; }
}

test_a_terminate_signal_ends_1_and_removes_the_staging() {
  write_bundle "$WORK/signal/KA-Reader.app" 0.0.0
  write_hdiutil_stand_in "$WORK/signal/bin" wait
  mkdir -p "$WORK/signal/tmp"
  PATH="$WORK/signal/bin:$PATH" TMPDIR="$WORK/signal/tmp" "$SCRIPT" "$WORK/signal/KA-Reader.app" "$WORK/signal/dist" \
    > "$WORK/stdout" 2> "$WORK/stderr" &
  pid=$!
  waited=0
  while [ ! -e "$WORK/signal/bin/ran" ] && [ "$waited" -lt 100 ]; do
    sleep 0.1
    waited=$((waited + 1))
  done
  [ -e "$WORK/signal/bin/ran" ] || { kill "$pid" 2> /dev/null; fail "the script never reached the image tool"; return 1; }
  kill -TERM "$pid"
  wait "$pid"
  STATUS=$?
  OUT="$(cat "$WORK/stdout")"
  ERR="$(cat "$WORK/stderr")"
  expect_status 1 || return 1
  [ ! -e "$WORK/signal/dist" ] || { fail "the output folder was left behind after the signal"; return 1; }
  [ -z "$(ls -A "$WORK/signal/tmp")" ] || { fail "a staging folder was left behind after the signal: $(ls -A "$WORK/signal/tmp")"; return 1; }
}

test_a_wrong_argument_count_exits_2() {
  run_script
  expect_status 2 || return 1
  run_script "$WORK/one"
  expect_status 2 || return 1
  run_script "$WORK/one" "$WORK/two" "$WORK/three"
  expect_status 2 || return 1
  case "$ERR" in *sage*) ;; *) fail "no usage line on stderr: $ERR"; return 1 ;; esac
}

# --- the runner ---

TMP_BASE="${TMPDIR:-/tmp}"
TMP_BASE="${TMP_BASE%/}"
if ! WORK="$(mktemp -d "$TMP_BASE/release-pack-suite.XXXXXX" 2> /dev/null)"; then
  echo "The suite could not create its temporary directory under $TMP_BASE, so no case ran. Make $TMP_BASE writable, then run the suite again."
  exit 1
fi
cleanup() {
  detach_mount
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
