#!/usr/bin/env bash
# Version: 1.0.0 — first version: the host's one command for the beta's read-at-open look
#
# checks/git-beta-walk.sh [<state-id>…] — run on the host, from the product root. It opens the macOS
# guest with a window, copies this checkout into it, builds KA-Reader.app there, and runs
# checks/git-beta-scene.sh there with this terminal attached, so the person reads the instructions,
# presses Enter, and only watches the guest's window. When the scene ends, the lines it printed and
# the screen captures it took come back to ~/Desktop/git-beta-walk/ on this host (entries.md and the
# PNGs). Nothing is typed inside the guest, because the guest's window takes no paste.
#
# WHY THIS EXISTS
#   The beta's read-at-open look is a person's (docs/nfdr.md QC-44, QC-66; change_spec CP-1302). It
#   needs about thirty disk states, each set up by hand in a guest whose window takes no paste, and
#   that is where the earlier look fell through. checks/git-beta-scene.sh sets the states up in the
#   guest; this script carries every other step but the watching. It copies checks/tree-walk.sh's
#   guest handling and does not share a library with it: that script has no suite, so moving its code
#   under a shared helper would change it with nothing to hold its behaviour.
#
# WHAT IT DOES
#   1. Finds the guest, kensai-macos. Running without a window: it stops, and says to stop the guest
#      and run again, since a gate may be using it. Stopped: it starts it with a window, detached so
#      the window outlives this script, and waits until `tart exec` answers. Running with a window:
#      it uses it.
#   2. Streams this checkout into the guest at /tmp/ka-reader-walk, leaving out .git, target and the
#      Swift package's .build. The guest's own target folder there is kept between runs, so a second
#      walk does not rebuild from nothing; everything else in the copy is replaced.
#   3. Builds the app in the guest with ka-reader-mac/assemble.sh. The scene is never run without
#      it: a failed build ends this script before the scene.
#   4. Runs checks/git-beta-scene.sh in the guest on that app, with this terminal as its terminal.
#      The ids given here go to the scene unchanged, and the scene judges them. The scene's lines go
#      to a file in the guest, so they can be fetched; its instructions stay on this terminal.
#   5. Fetches that file and the scene's captures with `tart exec … cat` into
#      ~/Desktop/git-beta-walk/. The entries file and the PNGs of an earlier walk are replaced.
#
# THE BUILT-FROM LINE
#   The full commit `git rev-parse HEAD` names in this checkout, then ", with no uncommitted
#   changes" when `git status --porcelain` lists nothing, and ", with uncommitted changes in the
#   tree" when it lists anything. It is made once, at the start, and handed to the scene as one
#   argument, which copies it into every entry.
#
# USAGE
#   checks/git-beta-walk.sh [<state-id>…]
#   With no id the scene walks every state in its own order. The first build in a fresh copy takes
#   several minutes.
#
# STATUSES (docs/nfdr.md QC-70)
#   The scene's own status, passed through. 1 of its own: the host is not macOS, tart is absent,
#   there is no kensai-macos guest, the guest runs without a window, it did not answer, or the build
#   in the guest failed. 2 is never its own, because the scene judges the ids.

set -euo pipefail

GUEST=kensai-macos
COPY=/tmp/ka-reader-walk
APP_IN_COPY=target/release/bundle/macos/KA-Reader.app
ENTRIES_IN_GUEST=/tmp/ka-reader-walk-entries.md
# `tart exec` runs a non-login shell, so cargo's folder is not on the guest's PATH by itself.
GUEST_PATH='$HOME/.cargo/bin:/opt/homebrew/bin:/usr/local/bin:$PATH'
# Five minutes: a hundred tries, three seconds apart.
ANSWER_TRIES=100
ANSWER_PAUSE_SECONDS=3

die() { echo "git-beta-walk.sh: $*" >&2; exit 1; }
say() { echo "git-beta-walk.sh: $*" >&2; }

# The argument as one word in single quotes, for the shell in the guest.
quote() { printf "'%s'" "$(printf '%s' "$1" | sed "s/'/'\\\\''/g")"; }

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
[ "$(uname -s)" = "Darwin" ] || die "this host does not read as macOS, so nothing was started. Run it on the Mac that holds the $GUEST guest."
command -v tart > /dev/null 2>&1 || die "tart was not found on PATH, so nothing was started. Put tart on PATH and run this again."

# --- 1. the guest, with a window ---

guest_state="$(tart list 2> /dev/null | awk -v name="$GUEST" '$1 == "local" && $2 == name { print $NF }' || true)"
[ -n "$guest_state" ] || die "tart lists no local guest named $GUEST, so nothing was started. Run tart list to see the guests this host holds."

if [ "$guest_state" = "running" ]; then
  # pipefail would end the script inside this substitution when no line matches, so it carries
  # `|| true` and the check follows on the next line.
  windowless="$(ps -axo command= | grep -E "(^|/)tart run .*--no-graphics" | grep -w "$GUEST" || true)"
  [ -z "$windowless" ] || die "$GUEST is running without a window, so there would be nothing to look at, and nothing was started. Stop it with 'tart stop $GUEST' when no gate is running in it, and run this again."
  say "using the running guest $GUEST"
else
  # The same shared folders the host's login job gives the guest, so the gates that use it after
  # this walk still see their checkouts. A guest started without them made the next gate refuse.
  shares=()
  login_job="$HOME/Library/LaunchAgents/local.kensaiapp.macos-guest.plist"
  if [ -f "$login_job" ]; then
    index=0
    while argument="$(plutil -extract "ProgramArguments.$index" raw -o - "$login_job" 2> /dev/null)"; do
      case "$argument" in --dir=*) shares+=("$argument") ;; esac
      index=$((index + 1))
    done
  fi
  [ "${#shares[@]}" -gt 0 ] || say "no shared folders found in $login_job; a gate run in this guest will not see its checkout until that job restarts the guest"
  say "starting $GUEST with a window"
  nohup tart run ${shares[@]+"${shares[@]}"} "$GUEST" > /dev/null 2>&1 &
  disown
fi

answered=0
for _ in $(seq 1 "$ANSWER_TRIES"); do
  if tart exec "$GUEST" true > /dev/null 2>&1; then
    answered=1
    break
  fi
  sleep "$ANSWER_PAUSE_SECONDS"
done
[ "$answered" -eq 1 ] || die "$GUEST did not answer tart exec within five minutes, so nothing was copied into it. Check that its window shows a desktop, and run this again."

# --- 2. the checkout, into the guest ---

# The commit is read before the copy, from the checkout the copy is made of.
commit="$(git -C "$ROOT" rev-parse HEAD)"
if [ -n "$(git -C "$ROOT" status --porcelain)" ]; then
  built_from="$commit, with uncommitted changes in the tree"
else
  built_from="$commit, with no uncommitted changes"
fi

say "copying this checkout into the guest at $COPY"
tart exec "$GUEST" sh -c "mkdir -p $COPY && find $COPY -mindepth 1 -maxdepth 1 ! -name target -exec rm -rf {} +"
tar -C "$ROOT" --no-mac-metadata --exclude './.git' --exclude './target' \
  --exclude './ka-reader-mac/.build' -cf - . \
  | tart exec -i "$GUEST" sh -c "tar -C $COPY -xf -"

# --- 3. the app, built in the guest ---

say "building KA-Reader.app in the guest"
tart exec "$GUEST" sh -c "export PATH=$GUEST_PATH && cd $COPY && ka-reader-mac/assemble.sh" \
  || die "the build in the guest failed, so no scene was run; its output is above. Fix what it names and run this again."

say "built from $built_from"

# --- 4. the scene, with this terminal ---

# What an earlier walk left in the guest is cleared first, so the fetch below brings back this
# walk's results only.
tart exec "$GUEST" sh -c "rm -rf \"\$HOME/Desktop/git-beta-scene-captures\" $ENTRIES_IN_GUEST"

# Bring the guest's window (its process is `tart run <guest>`) in front of everything on the host.
run_pid="$(pgrep -f "tart run $GUEST" | head -1 || true)"
if [ -n "$run_pid" ]; then
  osascript -e "tell application \"System Events\" to set frontmost of (first process whose unix id is $run_pid) to true" > /dev/null 2>&1 \
    || say "could not bring the $GUEST window forward: find it with Cmd-Tab, the app named tart"
fi
say "starting the scene. Look at the window named $GUEST (Cmd-Tab: tart): KA-Reader opens there, and this terminal tells you what to do."

scene_command="export PATH=$GUEST_PATH && cd $COPY && checks/git-beta-scene.sh $APP_IN_COPY $(quote "$built_from")"
for state_id in "$@"; do
  scene_command="$scene_command $(quote "$state_id")"
done
# Its lines go to a file the fetch reads; its instructions go to stderr, which stays on the terminal.
scene_command="$scene_command > $ENTRIES_IN_GUEST"
scene_status=0
# A remote terminal only when this side has one: tart fails to size one for a pipe or a file.
if [ -t 0 ] && [ -t 1 ]; then
  tart exec -i -t "$GUEST" sh -c "$scene_command" || scene_status=$?
else
  tart exec -i "$GUEST" sh -c "$scene_command" || scene_status=$?
fi

# --- 5. the scene's lines and captures, onto this host's Desktop ---

walk_folder="$HOME/Desktop/git-beta-walk"
mkdir -p "$walk_folder"
# Only what an earlier walk made is replaced: its entries file and its PNGs.
rm -f "$walk_folder/entries.md" "$walk_folder"/*.png

entries_path="$walk_folder/entries.md"
if tart exec "$GUEST" sh -c "cat $ENTRIES_IN_GUEST" > "$entries_path" 2> /dev/null && [ -s "$entries_path" ]; then
  say "the entries are at $entries_path"
else
  rm -f "$entries_path"
  say "the scene printed no entry, so there is no entries file"
fi

captured=0
capture_names="$(tart exec "$GUEST" sh -c 'ls "$HOME/Desktop/git-beta-scene-captures"' 2> /dev/null || true)"
for capture_name in $capture_names; do
  case "$capture_name" in
    *[!A-Za-z0-9._-]*) continue ;;
    *.png) ;;
    *) continue ;;
  esac
  if tart exec "$GUEST" sh -c "cat \"\$HOME/Desktop/git-beta-scene-captures/$capture_name\"" > "$walk_folder/$capture_name" 2> /dev/null \
    && [ -s "$walk_folder/$capture_name" ]; then
    captured=$((captured + 1))
  else
    rm -f "$walk_folder/$capture_name"
  fi
done
if [ "$captured" -gt 0 ]; then
  say "the screen captures are in $walk_folder"
else
  say "the scene left no screen capture"
fi

say "the scene ended with status $scene_status"
exit "$scene_status"
