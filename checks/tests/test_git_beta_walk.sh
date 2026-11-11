#!/usr/bin/env bash
# Version: 1.1.0 — integrity review: the checkout reaches the guest without .git, target or .build,
#   and each built-from failure names what went wrong (a clean tree claimed changed, a dirty one missed)
# Version: 1.0.0 — first version: the host walk's cases (refusals, the build before the scene, the ids,
#   the built-from line, the scene's status, the results folder, a stopped guest started with a window)
#
# checks/tests/test_git_beta_walk.sh — the tests of checks/git-beta-walk.sh.
#
# WHY THIS EXISTS
#   checks/git-beta-walk.sh is the host's one command for the beta's read-at-open look: it opens the
#   macOS guest with a window, copies the checkout in, builds KA-Reader.app there, runs
#   checks/git-beta-scene.sh with the host's terminal attached, and brings the scene's lines and the
#   screen captures back to the host's Desktop (change_spec CP-1302, CP-1303). The person's look is
#   not a command, so what a command can hold is the walk's own contract: it refuses before it starts
#   anything when the host cannot run it, it never runs a scene without first building, it passes the
#   ids to the scene unchanged, it names the commit it built from, it ends with the scene's status,
#   and it leaves the results where it says. These cases run the REAL script, copied into a
#   temporary checkout that stands for the product root, with `uname`, `tart`, `osascript`, `pgrep`,
#   `ps`, `tar` and `sleep` as stand-ins on PATH, the real `git` on the checkout, and a temporary
#   home. Nothing here starts a guest or reads the machine's home. The product has no Python, so the
#   runner is this file (docs/nfdr.md QC-70 sets the shell packet's pytest line aside;
#   deferred_decisions.md records the departure).
#
# USAGE
#   checks/tests/test_git_beta_walk.sh
#   Runs on any host: every host reading is a stand-in.
#
# THE STAND-INS
#   uname       prints the reading in $SCENE/uname (Darwin unless a case says otherwise).
#   tart        records its arguments in $SCENE/tart_calls. `list` shows the guest in the state held
#               in $SCENE/guest_state (no guest when the file is absent). `run` marks the guest
#               running. `exec` takes the command by what it names and never runs it: the build
#               (assemble.sh) ends with $SCENE/build_status and appends `build` to $SCENE/order; the
#               scene (git-beta-scene.sh) ends with $SCENE/scene_status, appends `scene` and keeps the
#               command in $SCENE/scene_command; a listing or a read of the guest's captures and of
#               the entries file answer from $SCENE/guest/. Any other command ends 0.
#   ps          prints the lines in $SCENE/ps_out.
#   pgrep       prints one pid. osascript, sleep and tar record their calls and do nothing.
#   Every stand-in finds its scene through the variable SCENE_DIR, which only the stand-ins read.
#
# WHY NO `set -e`
#   A case that fails must not end the run before the remaining cases report. Each case returns its
#   own status and the runner counts them.

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
GIT_BETA_WALK_SH="$ROOT/checks/git-beta-walk.sh"
GUEST=kensai-macos
ENTRIES_PATH_IN_GUEST=/tmp/ka-reader-walk-entries.md
# The ordinary tools the walk reaches. `uname`, `tart`, `osascript`, `pgrep`, `ps`, `tar` and
# `sleep` are not among them: each is the stand-in's, or missing.
ORDINARY_TOOLS="bash env sh awk sed cat cut tr sort uniq head tail grep mktemp rm mkdir dirname basename seq nohup wc ls cmp touch chmod ln"

WORK=""
SCENE=""
SCENE_COUNT=0
STATUS=0

CASES="
test_a_non_darwin_host_exits_one_and_starts_nothing
test_no_tart_exits_one_and_starts_nothing
test_no_kensai_macos_guest_exits_one_and_starts_nothing
test_a_guest_running_without_a_window_exits_one_and_says_to_stop_it
test_a_failing_build_in_the_guest_exits_one_and_runs_no_scene
test_the_scene_is_never_run_without_first_building
test_the_ids_reach_the_scene_command_unchanged
test_built_from_names_head_and_says_when_the_tree_has_uncommitted_changes
test_the_checkout_reaches_the_guest_without_git_target_or_build
test_the_scenes_status_is_the_scripts_status
test_results_land_in_the_host_desktop_folder
test_a_stopped_guest_is_started_with_a_window_and_then_used
test_a_walk_that_brought_nothing_back_says_so_and_leaves_no_old_results
"

# --- helpers ---

fail() {
  echo "  $*"
  return 1
}

write_uname() {
  cat > "$SCENE/bin/uname" <<'EOF'
#!/bin/bash
cat "$SCENE_DIR/uname"
exit 0
EOF
  chmod +x "$SCENE/bin/uname"
}

write_tart() {
  cat > "$SCENE/bin/tart" <<'EOF'
#!/bin/bash
printf '%s\n' "$*" >> "$SCENE_DIR/tart_calls"
sub="$1"
shift
case "$sub" in
  list)
    echo "Source Name Disk Size SizeOnDisk State"
    if [ -f "$SCENE_DIR/guest_state" ]; then
      printf 'local kensai-macos 80 40 20 %s\n' "$(cat "$SCENE_DIR/guest_state")"
    fi
    exit 0
    ;;
  run)
    echo running > "$SCENE_DIR/guest_state"
    exit 0
    ;;
  exec)
    wants_stdin=0
    while [ $# -gt 0 ]; do
      case "$1" in
        -i) wants_stdin=1 ;;
        -t) ;;
        *) break ;;
      esac
      shift
    done
    shift # the guest's name
    if [ "$1" = sh ] && [ "$2" = -c ]; then cmd="$3"; else cmd="$*"; fi
    case "$cmd" in
      *assemble.sh*)
        echo build >> "$SCENE_DIR/order"
        exit "$(cat "$SCENE_DIR/build_status" 2> /dev/null || echo 0)"
        ;;
      *git-beta-scene.sh*)
        echo scene >> "$SCENE_DIR/order"
        printf '%s\n' "$cmd" > "$SCENE_DIR/scene_command"
        exit "$(cat "$SCENE_DIR/scene_status" 2> /dev/null || echo 0)"
        ;;
    esac
    # The checkout's stream is unpacked into $SCENE_DIR/guest/copy when the case asks for it
    # ($SCENE_DIR/unpack); otherwise it, like any other stream, is read to its end and dropped.
    case "$cmd" in
      "tar -C "*" -xf -")
        if [ -f "$SCENE_DIR/unpack" ]; then
          mkdir -p "$SCENE_DIR/guest/copy"
          tar -C "$SCENE_DIR/guest/copy" -xf -
          exit $?
        fi
        ;;
    esac
    if [ "$wants_stdin" = 1 ]; then cat > /dev/null; fi
    case "$cmd" in
      "ls "*captures*)
        ls "$SCENE_DIR/guest/captures" 2> /dev/null
        exit 0
        ;;
      "cat "*captures/*)
        name="${cmd##*/}"
        name="${name%\"}"
        cat "$SCENE_DIR/guest/captures/$name"
        exit $?
        ;;
      "cat "*ka-reader-walk-entries.md*)
        cat "$SCENE_DIR/guest/entries.md" 2> /dev/null
        exit $?
        ;;
    esac
    exit 0
    ;;
esac
exit 0
EOF
  chmod +x "$SCENE/bin/tart"
}

write_ps() {
  cat > "$SCENE/bin/ps" <<'EOF'
#!/bin/bash
cat "$SCENE_DIR/ps_out" 2> /dev/null
exit 0
EOF
  chmod +x "$SCENE/bin/ps"
}

write_recorders() {
  for name in osascript sleep tar; do
    cat > "$SCENE/bin/$name" <<EOF
#!/bin/bash
printf '%s %s\n' '$name' "\$*" >> "\$SCENE_DIR/other_calls"
exit 0
EOF
    chmod +x "$SCENE/bin/$name"
  done
  cat > "$SCENE/bin/pgrep" <<'EOF'
#!/bin/bash
echo 5151
exit 0
EOF
  chmod +x "$SCENE/bin/pgrep"
}

# A fresh scene: a temporary git checkout standing for the product root, with the real walk script
# copied into it, a temporary home, the guest's answers, and a PATH of stand-ins ahead of ordinary
# tools. Sets SCENE. The script is copied when it exists, so a missing script is a case that fails
# on its status and not a harness that stops.
new_scene() {
  SCENE_COUNT=$((SCENE_COUNT + 1))
  SCENE="$WORK/scene$SCENE_COUNT"
  rm -rf "$SCENE"
  mkdir -p "$SCENE/bin" "$SCENE/ordinary" "$SCENE/home" "$SCENE/guest/captures" "$SCENE/checkout/checks"
  : > "$SCENE/tart_calls"
  : > "$SCENE/other_calls"
  : > "$SCENE/order"
  : > "$SCENE/ps_out"
  echo Darwin > "$SCENE/uname"
  echo running > "$SCENE/guest_state"
  for tool in $ORDINARY_TOOLS; do
    found="$(command -v "$tool" 2> /dev/null || true)"
    case "$found" in
      /*) ln -sf "$found" "$SCENE/ordinary/$tool" ;;
    esac
  done
  ln -sf "$(command -v git)" "$SCENE/ordinary/git"
  write_uname
  write_tart
  write_ps
  write_recorders
  echo "a file the checkout holds" > "$SCENE/checkout/README"
  if [ -f "$GIT_BETA_WALK_SH" ]; then
    cp "$GIT_BETA_WALK_SH" "$SCENE/checkout/checks/git-beta-walk.sh"
    chmod +x "$SCENE/checkout/checks/git-beta-walk.sh"
  fi
  scene_git init --quiet
  scene_git add -A
  scene_git -c user.name=walk -c user.email=walk@example.invalid -c commit.gpgsign=false commit --quiet -m "the checkout"
}

# The checkout is built with no configuration of the machine running the suite: not the system's,
# not the user's, and not what an environment injects through GIT_CONFIG_COUNT (a hook path would
# make this commit run the host's commit hook).
scene_git() {
  GIT_CONFIG_COUNT=0 GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null git -C "$SCENE/checkout" "$@"
}

# Runs the walk from the product root with the stand-ins and the temporary home only. Sets STATUS,
# $SCENE/stdout and $SCENE/stderr. Standard input is empty, so the walk reads no terminal.
run_walk() {
  STATUS=0
  (
    cd "$SCENE/checkout" && /usr/bin/env -i PATH="$SCENE/bin:$SCENE/ordinary" HOME="$SCENE/home" SCENE_DIR="$SCENE" \
      "$SCENE/checkout/checks/git-beta-walk.sh" "$@" < /dev/null > "$SCENE/stdout" 2> "$SCENE/stderr"
  ) || STATUS=$?
}

tart_calls_that_start_or_run() {
  grep -E '^(run|exec) ' "$SCENE/tart_calls" || true
}

# The assertions of a refusal: exit 1, a line of the walk on stderr, nothing started or run.
assert_a_refusal() {
  label="$1"
  [ "$STATUS" -eq 1 ] || fail "$label: expected exit 1, got $STATUS. stderr: $(cat "$SCENE/stderr")" || return 1
  grep -q '^git-beta-walk.sh: ' "$SCENE/stderr" \
    || fail "$label: stderr carries no git-beta-walk.sh: line. stderr: $(cat "$SCENE/stderr")" || return 1
  started="$(tart_calls_that_start_or_run)"
  [ -z "$started" ] || fail "$label: tart was asked to start or run something: $started" || return 1
  [ ! -s "$SCENE/order" ] || fail "$label: a build or a scene was run: $(cat "$SCENE/order")"
}

# --- cases ---

test_a_non_darwin_host_exits_one_and_starts_nothing() {
  new_scene
  echo Linux > "$SCENE/uname"
  run_walk
  assert_a_refusal "not Darwin" || return 1
  grep -q "^git-beta-walk.sh: this host does not read as macOS, so nothing was started. Run it on the Mac that holds the $GUEST guest.\$" "$SCENE/stderr" \
    || fail "not Darwin: the refusal line is not the one the text file gives. stderr: $(cat "$SCENE/stderr")"
}

test_no_tart_exits_one_and_starts_nothing() {
  new_scene
  rm -f "$SCENE/bin/tart"
  run_walk
  assert_a_refusal "no tart" || return 1
  grep -q '^git-beta-walk.sh: tart was not found on PATH, so nothing was started. Put tart on PATH and run this again.$' "$SCENE/stderr" \
    || fail "no tart: the refusal line is not the one the text file gives. stderr: $(cat "$SCENE/stderr")"
}

test_no_kensai_macos_guest_exits_one_and_starts_nothing() {
  new_scene
  rm -f "$SCENE/guest_state"
  run_walk
  assert_a_refusal "no kensai-macos guest" || return 1
  grep -q "^git-beta-walk.sh: tart lists no local guest named $GUEST, so nothing was started. Run tart list to see the guests this host holds.\$" "$SCENE/stderr" \
    || fail "no kensai-macos guest: the refusal line is not the one the text file gives. stderr: $(cat "$SCENE/stderr")"
}

test_a_guest_running_without_a_window_exits_one_and_says_to_stop_it() {
  new_scene
  echo "/opt/homebrew/bin/tart run --no-graphics $GUEST" > "$SCENE/ps_out"
  run_walk
  assert_a_refusal "guest without a window" || return 1
  grep -q "^git-beta-walk.sh: $GUEST is running without a window, so there would be nothing to look at, and nothing was started. Stop it with 'tart stop $GUEST' when no gate is running in it, and run this again.\$" "$SCENE/stderr" \
    || fail "guest without a window: the message does not name stopping the guest and running again. stderr: $(cat "$SCENE/stderr")"
}

test_a_failing_build_in_the_guest_exits_one_and_runs_no_scene() {
  new_scene
  echo 3 > "$SCENE/build_status"
  run_walk
  [ "$STATUS" -eq 1 ] || fail "build fails: expected exit 1, got $STATUS. stderr: $(cat "$SCENE/stderr")" || return 1
  ! grep -q '^scene$' "$SCENE/order" || fail "build fails: the scene was run though the build in the guest failed: $(cat "$SCENE/tart_calls")" || return 1
  grep -q '^git-beta-walk.sh: the build in the guest failed, so no scene was run; its output is above. Fix what it names and run this again.$' "$SCENE/stderr" \
    || fail "build fails: stderr does not say that no scene was run. stderr: $(cat "$SCENE/stderr")"
}

test_the_scene_is_never_run_without_first_building() {
  new_scene
  run_walk
  [ "$(cat "$SCENE/order")" = "$(printf 'build\nscene')" ] \
    || fail "the scene was run before the build: $(cat "$SCENE/tart_calls")"
}

test_the_ids_reach_the_scene_command_unchanged() {
  new_scene
  run_walk E4 E1
  [ -s "$SCENE/scene_command" ] || fail "the ids did not reach the scene unchanged. The scene was not run. stderr: $(cat "$SCENE/stderr")" || return 1
  grep -q " 'E4' 'E1' > $ENTRIES_PATH_IN_GUEST\$" "$SCENE/scene_command" \
    || fail "the ids did not reach the scene unchanged. The scene was run as: $(cat "$SCENE/scene_command")" || return 1
  # With no id the scene gets none, so it walks every state in its own order.
  new_scene
  run_walk
  grep -q "KA-Reader.app '[^']*' > $ENTRIES_PATH_IN_GUEST\$" "$SCENE/scene_command" \
    || fail "the ids did not reach the scene unchanged. The scene was run as: $(cat "$SCENE/scene_command")"
}

test_built_from_names_head_and_says_when_the_tree_has_uncommitted_changes() {
  new_scene
  run_walk
  commit="$(scene_git rev-parse HEAD)"
  line="$(grep '^git-beta-walk.sh: built from ' "$SCENE/stderr" || true)"
  case "$line" in
    *"$commit"*) ;;
    *) fail "the built-from line does not name HEAD $commit. got: $line" || return 1 ;;
  esac
  [ "$line" = "git-beta-walk.sh: built from $commit, with no uncommitted changes" ] \
    || fail "the built-from line says the tree has uncommitted changes, and it has none. got: $line" || return 1
  grep -q "'$commit, with no uncommitted changes'" "$SCENE/scene_command" \
    || fail "the built-from line does not reach the scene as one argument. The scene was run as: $(cat "$SCENE/scene_command")" || return 1

  new_scene
  echo "a change nobody committed" > "$SCENE/checkout/uncommitted.txt"
  run_walk
  commit="$(scene_git rev-parse HEAD)"
  line="$(grep '^git-beta-walk.sh: built from ' "$SCENE/stderr" || true)"
  case "$line" in
    *"$commit"*) ;;
    *) fail "the built-from line does not name HEAD $commit. got: $line" || return 1 ;;
  esac
  [ "$line" = "git-beta-walk.sh: built from $commit, with uncommitted changes in the tree" ] \
    || fail "the built-from line does not say the tree has uncommitted changes. got: $line"
}

# The checkout goes into the guest without its .git, its target folder and the Swift package's
# .build (Task 6). The stand-in tart unpacks the stream the real tar makes, so the case reads what
# the guest's copy would hold.
test_the_checkout_reaches_the_guest_without_git_target_or_build() {
  new_scene
  rm -f "$SCENE/bin/tar"
  ln -sf "$(command -v tar)" "$SCENE/ordinary/tar"
  : > "$SCENE/unpack"
  mkdir -p "$SCENE/checkout/target/release" "$SCENE/checkout/ka-reader-mac/.build/debug" "$SCENE/checkout/ka-reader-mac/Sources"
  echo "built" > "$SCENE/checkout/target/release/artifact"
  echo "built" > "$SCENE/checkout/ka-reader-mac/.build/debug/artifact"
  echo "source" > "$SCENE/checkout/ka-reader-mac/Sources/kept.swift"
  run_walk
  copy="$SCENE/guest/copy"
  [ -f "$copy/README" ] && [ -f "$copy/checks/git-beta-walk.sh" ] && [ -f "$copy/ka-reader-mac/Sources/kept.swift" ] \
    || fail "the checkout did not reach the guest: the copy holds $(cd "$copy" 2> /dev/null && find . | LC_ALL=C sort | tr '\n' ' ')" || return 1
  [ ! -e "$copy/.git" ] && [ ! -e "$copy/target" ] && [ ! -e "$copy/ka-reader-mac/.build" ] \
    || fail "the checkout reached the guest with .git, target or .build: the copy holds $(cd "$copy" && find . -maxdepth 2 | LC_ALL=C sort | tr '\n' ' ')"
}

test_the_scenes_status_is_the_scripts_status() {
  for scene_status in 0 1 2; do
    new_scene
    echo "$scene_status" > "$SCENE/scene_status"
    run_walk
    [ "$STATUS" -eq "$scene_status" ] || fail "the scene ended with $scene_status and the walk with $STATUS" || return 1
    grep -q "^git-beta-walk.sh: the scene ended with status $scene_status\$" "$SCENE/stderr" \
      || fail "the walk did not say the scene ended with status $scene_status. stderr: $(cat "$SCENE/stderr")" || return 1
  done
}

test_results_land_in_the_host_desktop_folder() {
  new_scene
  printf '%s\n' "## E1" "- Built from: x" > "$SCENE/guest/entries.md"
  printf 'first picture' > "$SCENE/guest/captures/E1.png"
  printf 'second picture' > "$SCENE/guest/captures/E2-clean.png"
  run_walk
  folder="$SCENE/home/Desktop/git-beta-walk"
  cmp -s "$SCENE/guest/entries.md" "$folder/entries.md" \
    || fail "the results are not in the Desktop's git-beta-walk folder: $(ls -A "$folder" 2>&1)" || return 1
  [ "$(cat "$folder/E1.png" 2> /dev/null)" = "first picture" ] && [ "$(cat "$folder/E2-clean.png" 2> /dev/null)" = "second picture" ] \
    || fail "the results are not in the Desktop's git-beta-walk folder: $(ls -A "$folder" 2>&1)" || return 1
  grep -q "^git-beta-walk.sh: the entries are at $folder/entries.md\$" "$SCENE/stderr" \
    || fail "the walk did not say where the entries are. stderr: $(cat "$SCENE/stderr")" || return 1
  grep -q "^git-beta-walk.sh: the screen captures are in $folder\$" "$SCENE/stderr" \
    || fail "the walk did not say where the captures are. stderr: $(cat "$SCENE/stderr")" || return 1
  # The walk writes the results folder and nothing else in the home.
  [ "$(ls -A "$SCENE/home")" = "Desktop" ] && [ "$(ls -A "$SCENE/home/Desktop")" = "git-beta-walk" ] \
    || fail "the walk wrote into the home outside the results folder: $(ls -A "$SCENE/home") / $(ls -A "$SCENE/home/Desktop")"
}

test_a_stopped_guest_is_started_with_a_window_and_then_used() {
  new_scene
  echo stopped > "$SCENE/guest_state"
  run_walk
  [ "$STATUS" -eq 0 ] || fail "stopped guest: expected exit 0, got $STATUS. stderr: $(cat "$SCENE/stderr")" || return 1
  grep -q "^run $GUEST\$" "$SCENE/tart_calls" \
    || fail "stopped guest: it was not started with a window (tart run $GUEST). tart saw: $(cat "$SCENE/tart_calls")" || return 1
  ! grep -q -- '--no-graphics' "$SCENE/tart_calls" || fail "stopped guest: it was started without a window: $(cat "$SCENE/tart_calls")" || return 1
  grep -q "^git-beta-walk.sh: starting $GUEST with a window\$" "$SCENE/stderr" \
    || fail "stopped guest: stderr does not say the guest is starting. stderr: $(cat "$SCENE/stderr")" || return 1
  [ "$(cat "$SCENE/order")" = "$(printf 'build\nscene')" ] || fail "stopped guest: the build and the scene did not follow: $(cat "$SCENE/order")"
}

test_a_walk_that_brought_nothing_back_says_so_and_leaves_no_old_results() {
  new_scene
  folder="$SCENE/home/Desktop/git-beta-walk"
  mkdir -p "$folder"
  echo "an earlier walk" > "$folder/entries.md"
  echo "an earlier picture" > "$folder/E1.png"
  echo "a note the person kept" > "$folder/notes.txt"
  run_walk
  grep -q '^git-beta-walk.sh: the scene printed no entry, so there is no entries file$' "$SCENE/stderr" \
    || fail "nothing back: stderr does not say the scene printed no entry. stderr: $(cat "$SCENE/stderr")" || return 1
  grep -q '^git-beta-walk.sh: the scene left no screen capture$' "$SCENE/stderr" \
    || fail "nothing back: stderr does not say the scene left no capture. stderr: $(cat "$SCENE/stderr")" || return 1
  [ ! -e "$folder/entries.md" ] && [ ! -e "$folder/E1.png" ] \
    || fail "nothing back: an earlier walk's results are still there: $(ls -A "$folder")" || return 1
  [ -f "$folder/notes.txt" ] || fail "nothing back: a file the walk did not make was removed: $(ls -A "$folder")"
}

# --- the runner ---

WORK="$(cd "$(mktemp -d)" && pwd -P)"
cleanup() {
  rm -rf "$WORK"
}
trap cleanup EXIT

failed=0
total=0
for case_name in $CASES; do
  total=$((total + 1))
  if result="$("$case_name" 2>&1)"; then
    echo "ok   $case_name"
  else
    echo "FAIL $case_name"
    [ -z "$result" ] || echo "$result"
    failed=$((failed + 1))
  fi
done

echo "$((total - failed)) of $total passed"
[ "$failed" -eq 0 ]
