#!/usr/bin/env bash
# Version: 1.0.0 — first version: renders every Markdown file under a folder twice, once with the
#   network as the machine gives it and once denied all network access, and says whether the pages
#   are the same
#
# checks/offline-page.sh <folder> — the page a Markdown file reads as, with the network denied.
#
# WHY THIS EXISTS
#   CP-1131 to CP-1134, and UX-I15: a page must read the same whether or not the network is there,
#   because the product fetches nothing. The proof is outside the product. This script builds the
#   walk program that checks/read-only.sh drives, runs its pages mode over the folder twice, and
#   compares what the two runs printed. A page is the core's answers (the `select_file` answer and
#   the `asset_bytes` answer of every image node), not the drawn window.
#
# USAGE
#   checks/offline-page.sh checks/fixtures/repo
#   stdout carries the verdict and nothing else: `same` and exit 0, or each differing file's
#   folder-relative path once, in byte order, and exit 1. Every message goes to stderr. The argument
#   count is not one: exit 2. The argument is not a folder: exit 1. A refusal exits non-zero and is
#   never `same`.
#
# THE DENIAL IS PROVED FIRST
#   A run that never showed the network was off has proved nothing, so `same` is not printed unless
#   the denial held. The script opens a listener on 127.0.0.1, which needs no internet connection.
#   A connection made the way the allowed run is started must succeed. The same connection made
#   through the one function the denied run is started through must be refused. A last connection
#   made the ordinary way must succeed again, so the refusal met a live listener and not an absent
#   one.
#
# WHAT IT READS AND WRITES
#   It reads the folder and writes nothing into it. Its own files live in one scratch folder made
#   with mktemp -d. Every program it runs (cargo, sandbox-exec, nc) is found through PATH, and the
#   walk program is reached through cargo's own output. It reads no environment variable of its own.
#
# THE ORDER OF THE END
#   The listener is stopped and waited for, and the scratch folder is removed from outside, in the
#   one EXIT trap. The verdict is printed after that, last, on every way the script can end.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
NAME="offline-page.sh"
# The ports on 127.0.0.1 the listener is tried on, in turn.
PORTS="47321 47322 47323 47324 47325"
# The whole profile the denied run is started under: everything is allowed except the network.
DENIAL_PROFILE='(version 1)(allow default)(deny network*)'
# How many tenths of a second the listener gets to accept its first connection.
LISTENER_WAITS=50
# Seconds a connection attempt may take before it counts as refused.
CONNECT_WAIT=2

# What the EXIT trap reads. All of it is set before anything is made, so an end at any point finds
# the state it needs.
scratch=""
listener_pid=""
verdict=""
exit_status=1

# Stops the listener and waits for it, removes the scratch folder from outside, and only then prints
# the verdict. A script that ends without setting a verdict prints nothing and exits non-zero.
finish() {
  trap - EXIT
  if [ -n "$listener_pid" ]; then
    kill "$listener_pid" 2> /dev/null || true
    wait "$listener_pid" 2> /dev/null || true
  fi
  if [ -n "$scratch" ]; then
    rm -rf "$scratch"
  fi
  if [ -n "$verdict" ]; then
    printf '%s\n' "$verdict"
  fi
  exit "$exit_status"
}
trap finish EXIT
trap 'exit 1' HUP INT TERM

# Says why on stderr and ends with status $2, which the trap then exits with.
refuse() {
  echo "$NAME: $1" >&2
  exit_status="${2:-1}"
  exit "$exit_status"
}

# --- arguments ---

if [ $# -ne 1 ]; then
  refuse "usage: $NAME <folder>" 2
fi
folder="$1"
if [ ! -d "$folder" ]; then
  refuse "not a folder: $folder"
fi
absolute="$(cd "$folder" && pwd)"

# --- what the check needs ---

if ! command -v cargo > /dev/null 2>&1; then
  refuse "cargo is not on PATH, and the check builds the walk with it, so nothing was built or started. Put cargo on PATH, then run the check again."
fi
if ! command -v sandbox-exec > /dev/null 2>&1; then
  refuse "sandbox-exec is not on PATH, and the check denies one render the network with it, so nothing was built or started. On macOS it is /usr/bin/sandbox-exec; put it on PATH, then run the check again."
fi
if ! command -v nc > /dev/null 2>&1; then
  refuse "nc is not on PATH, and the check opens a local listener with it to show the denial holds, so nothing was built or started. Put nc on PATH, then run the check again."
fi

if ! scratch="$(mktemp -d)"; then
  scratch=""
  refuse "could not make a scratch folder with mktemp -d. Run the check again once mktemp -d succeeds in this shell."
fi

# --- the two ways a program is started ---

# The way the allowed run is started.
run_allowed() {
  "$@"
}

# The one way the denied run is started. The probe and the render both go through it, so the probe
# proves the exact wrapper the render runs under. A sandbox-exec that cannot apply its profile ends
# this non-zero, which reads as a refused connection or a render that did not complete, and never
# as `same`.
run_denied() {
  sandbox-exec -p "$DENIAL_PROFILE" "$@"
}

# Succeeds when a connection to 127.0.0.1:$1 is made by the starter $2.
connects() {
  "$2" nc -z -w "$CONNECT_WAIT" 127.0.0.1 "$1" < /dev/null > /dev/null 2>&1
}

# --- build the walk program, once ---

# The walk's test binary, built once, as the JSON line cargo prints for it. Its stdout is the only
# output read; cargo's stderr passes through to ours.
build_walk_host() {
  (cd "$ROOT" && cargo test --locked --quiet -p ka-reader-core --test walk --no-run --message-format=json < /dev/null)
}

if ! build_walk_host > "$scratch/build-output"; then
  refuse "the walk's test binary did not build. Run cargo test --locked -p ka-reader-core --test walk --no-run to see why."
fi
# `|| true`: pipefail would otherwise exit before the guard below reports.
host="$(grep -F '"name":"walk"' "$scratch/build-output" | grep -F '"executable":"' | tail -n 1 |
  sed -n 's/.*"executable":"\([^"]*\)".*/\1/p' || true)"
if [ -z "$host" ] || [ ! -x "$host" ]; then
  refuse "cargo named no walk binary to run. Run cargo test --locked -p ka-reader-core --test walk --no-run --message-format=json and look for the line naming walk."
fi

# --- the denial is proved ---

# Opens the listener on the first port of PORTS that accepts an ordinary connection, and sets
# $port. A port another process holds leaves our nc dead, so it is skipped and not mistaken for ours.
open_listener() {
  local candidate waits
  for candidate in $PORTS; do
    nc -l -k 127.0.0.1 "$candidate" < /dev/null > /dev/null 2>&1 &
    listener_pid=$!
    waits=0
    while [ "$waits" -lt "$LISTENER_WAITS" ]; do
      if kill -0 "$listener_pid" 2> /dev/null && connects "$candidate" run_allowed; then
        port="$candidate"
        return 0
      fi
      sleep 0.1
      waits=$((waits + 1))
    done
    kill "$listener_pid" 2> /dev/null || true
    wait "$listener_pid" 2> /dev/null || true
    listener_pid=""
  done
  return 1
}

port=""
if ! open_listener; then
  refuse "no listener the check opened on 127.0.0.1 accepted a connection on any of the ports $PORTS, so the denial could not be shown and nothing was rendered. Check that nc -l -k can listen on 127.0.0.1, then run the check again."
fi
if connects "$port" run_denied; then
  refuse "the denial did not hold: a connection to 127.0.0.1:$port made under it succeeded, so nothing was rendered. Check that the sandbox-exec first on PATH is /usr/bin/sandbox-exec, then run the check again."
fi
if ! connects "$port" run_allowed; then
  refuse "after the connection under the denial was refused, an ordinary connection to 127.0.0.1:$port did not succeed either, so the refusal is not shown to be the denial's and nothing was rendered. Run the check again."
fi

# --- the two renders ---

# Renders the folder with starter $1 into capture $2, and sets $render_status. The render's own
# reason, where it gives one, goes to our stderr.
render() {
  render_status=0
  "$1" "$host" "$absolute" --pages < /dev/null > "$2" || render_status=$?
}

render run_allowed "$scratch/allowed.pages"
allowed_status="$render_status"
render run_denied "$scratch/denied.pages"
denied_status="$render_status"

# --- the comparison ---

if [ "$allowed_status" -ne 0 ]; then
  refuse "the render with the network allowed did not complete over $folder: it ended with status $allowed_status. Its own reason, where it gave one, is on the line before this one."
fi
if [ "$denied_status" -ne 0 ]; then
  refuse "the render denied the network did not complete over $folder: it ended with status $denied_status. Its own reason, where it gave one, is on the line before this one."
fi
if [ ! -s "$scratch/allowed.pages" ]; then
  refuse "the render with the network allowed found no Markdown file under $folder, so there is no page to compare. Run the check on a folder that holds one."
fi
if [ ! -s "$scratch/denied.pages" ]; then
  refuse "the render denied the network found no Markdown file under $folder, so there is no page to compare. Run the check again."
fi

# Every path whose line is in one capture and not the other, once each, in byte order. A path in one
# capture only differs; a path in both differs when its two lines differ. `diff` exits 1 when the
# captures differ, which under pipefail would end the script, hence the `|| true`.
differing="$(diff "$scratch/allowed.pages" "$scratch/denied.pages" | sed -n 's/^[<>] //p' | cut -f 1 |
  LC_ALL=C sort -u || true)"

if [ -z "$differing" ]; then
  verdict="same"
  exit_status=0
else
  verdict="$differing"
  exit_status=1
fi
exit "$exit_status"
