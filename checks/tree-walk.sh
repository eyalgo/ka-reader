#!/usr/bin/env bash
# Version: 1.1.0 — after the scene, the guest's capture of the window comes to ~/Desktop/tree-walk-end.png
#   (1.0.0: first version, the host's one command for the tree-follows-the-disk walk)
#
# checks/tree-walk.sh — run on the host, from the product root, with no argument. It opens the macOS
# guest with a window, copies this checkout into it, builds KA-Reader.app there, and runs
# checks/tree-scene.sh there with this terminal attached, so the person reads the instructions,
# presses Enter and sees the final listing here, on the host, and only watches the guest's window.
# Nothing is typed inside the guest, because the guest's window takes no paste.
#
# WHY THIS EXISTS
#   The built-app tree walk is a person's (docs/nfdr.md QC-66; checks/tree-scene.sh says why). The
#   guest runs headless for the gates (`tart run --no-graphics`), and typing long commands into a
#   guest window by hand is where earlier walks failed. This script carries every step but the
#   watching.
#
# WHAT IT DOES
#   1. Finds the guest, kensai-macos. Running without a window: it stops, and says to stop the guest
#      (`tart stop kensai-macos`) and run again, since a gate may be using it. Stopped: it starts it
#      with a window, detached so the window outlives this script, and waits until `tart exec`
#      answers. Running with a window: it uses it.
#   2. Streams this checkout into the guest at /tmp/ka-reader-walk, leaving out .git, target and
#      the Swift package's .build. The guest's own target folder there is kept between runs, so a
#      second walk does not rebuild from nothing; everything else in the copy is replaced.
#   3. Builds the app in the guest with ka-reader-mac/assemble.sh.
#   4. Runs checks/tree-scene.sh in the guest on that app, with this terminal as its terminal.
#   5. Copies the scene's capture of the window at quiescence to ~/Desktop/tree-walk-end.png here.
#
# USAGE
#   checks/tree-walk.sh
#   The first build in a fresh copy takes several minutes; the scene itself takes under two.

set -euo pipefail

GUEST=kensai-macos
COPY=/tmp/ka-reader-walk
# `tart exec` runs a non-login shell, so cargo's folder is not on the guest's PATH by itself.
GUEST_PATH='$HOME/.cargo/bin:/opt/homebrew/bin:/usr/local/bin:$PATH'

die() { echo "tree-walk.sh: $*" >&2; exit 1; }
say() { echo "tree-walk.sh: $*" >&2; }

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
[ "$(uname -s)" = "Darwin" ] || die "this runs on the macOS host that holds the guest"
command -v tart > /dev/null 2>&1 || die "tart not found on PATH"

# --- 1. the guest, with a window ---

guest_state="$(tart list 2> /dev/null | awk -v name="$GUEST" '$1 == "local" && $2 == name { print $NF }')"
[ -n "$guest_state" ] || die "there is no local guest named $GUEST (tart list)"

if [ "$guest_state" = "running" ]; then
  if ps -axo command= | grep -E "(^|/)tart run .*--no-graphics" | grep -q -w "$GUEST"; then
    die "$GUEST is running without a window, so there would be nothing to watch. Stop it with 'tart stop $GUEST' (when no gate is running in it) and run this again"
  fi
  say "using the running guest $GUEST"
else
  say "starting $GUEST with a window"
  nohup tart run "$GUEST" > /dev/null 2>&1 &
  disown
fi

answered=0
for _ in $(seq 1 100); do
  if tart exec "$GUEST" true > /dev/null 2>&1; then
    answered=1
    break
  fi
  sleep 3
done
[ "$answered" -eq 1 ] || die "$GUEST did not answer tart exec within five minutes"

# --- 2. the checkout, into the guest ---

say "copying this checkout into the guest at $COPY"
tart exec "$GUEST" sh -c "mkdir -p $COPY && find $COPY -mindepth 1 -maxdepth 1 ! -name target -exec rm -rf {} +"
tar -C "$ROOT" --no-mac-metadata --exclude './.git' --exclude './target' \
  --exclude './ka-reader-mac/.build' -cf - . \
  | tart exec -i "$GUEST" sh -c "tar -C $COPY -xf -"

# --- 3. the app, built in the guest ---

say "building KA-Reader.app in the guest (several minutes the first time)"
tart exec "$GUEST" sh -c "export PATH=$GUEST_PATH && cd $COPY && ka-reader-mac/assemble.sh" \
  || die "the build in the guest failed; its output is above"

# --- 4. the scene, with this terminal ---

# Bring the guest's window (its process is `tart run <guest>`) in front of everything on the host.
run_pid="$(pgrep -f "tart run $GUEST" | head -1 || true)"
if [ -n "$run_pid" ]; then
  osascript -e "tell application \"System Events\" to set frontmost of (first process whose unix id is $run_pid) to true" > /dev/null 2>&1 \
    || say "could not bring the $GUEST window forward: find it with Cmd-Tab, the app named tart"
fi
say "starting the scene. Look at the window named $GUEST (Cmd-Tab: tart): KA-Reader opens there"
# A remote terminal only when this side has one: tart fails to size one for a pipe or a file.
scene_command="export PATH=$GUEST_PATH && cd $COPY && checks/tree-scene.sh target/release/bundle/macos/KA-Reader.app"
scene_status=0
if [ -t 0 ] && [ -t 1 ]; then
  tart exec -i -t "$GUEST" sh -c "$scene_command" || scene_status=$?
else
  tart exec -i "$GUEST" sh -c "$scene_command" || scene_status=$?
fi

# --- 5. the scene's own capture of the window at quiescence, onto this host's Desktop ---

host_capture="$HOME/Desktop/tree-walk-end.png"
if tart exec "$GUEST" sh -c 'cat "$HOME/Desktop/tree-scene-end.png"' > "$host_capture" 2> /dev/null \
  && [ -s "$host_capture" ]; then
  say "the window at quiescence is at $host_capture"
else
  rm -f "$host_capture"
  say "the scene left no capture of the window"
fi
exit "$scene_status"
