#!/usr/bin/env bash
# Version: 1.0.0 — first version: the Own state step's body, out of the workflow and into a script
#
# checks/own-state-step.sh — runs checks/own-state.sh and gives up on it after a fixed time. Run from the
# product root; it takes no argument.
#
# WHY THIS EXISTS
#   The step used to be a block inside .github/workflows/ci.yml, where no person could run it and no case
#   could prove it. It is a script now (docs/nfdr.md QC-64), and the workflow calls it and holds no rule
#   of its own. Its cases are checks/tests/test_own_state_step.sh.
#
# WHAT IT DOES
#   It starts checks/own-state.sh as a child and counts ticks while the child runs: 240 ticks of 0.25 s,
#   fixed in this file, and no environment variable changes it. The child's output goes straight through,
#   and this script adds no line of its own.
#   - The child finishes inside the bound: the script exits with the child's status, whatever it is (a
#     failed condition, the child's refusal off a macOS virtual machine, or 0).
#   - The child is still running when the ticks run out: the script stops it and everything it started,
#     prints one line on stderr that names the log the child was reading and the known reason such a read
#     can hang, and exits 1.
#
# WHAT IT DOES NOT DO
#   It has no admission of its own and takes no input that would give it one: it does not ask the host
#   anything and does not look at $HOME to decide whether the child runs. Off a macOS virtual machine the
#   child refuses (docs/nfdr.md QC-65), and that refusal is the only output. The log path is built only
#   for the line above; this script never tests, opens or lists it.
#
# HOW THE WAIT IS HELD
#   Reading the app's own container can block on an operating-system consent prompt, so the child runs
#   apart and the foreground only counts ticks. The child has a process group of its own (job control,
#   `set -m`), so a timeout that kills the group ends the child and every reader it started, and leaves
#   nothing behind.

set -euo pipefail

LOG="$HOME/Library/Containers/com.kensaiapp.ka-reader/Data/Library/Logs/ka-reader.log"
WAIT_TICKS=240

set -m
checks/own-state.sh &
reader=$!
set +m

ticks=0
while kill -0 "$reader" 2> /dev/null && [ "$ticks" -lt "$WAIT_TICKS" ]; do
  sleep 0.25
  ticks=$((ticks + 1))
done

if kill -0 "$reader" 2> /dev/null; then
  kill -KILL -- "-$reader" 2> /dev/null || true
  wait "$reader" 2> /dev/null || true
  echo "ci: checks/own-state.sh did not finish reading $LOG within $WAIT_TICKS ticks of 0.25s. Reading the app's own container is known to wait on an operating-system consent prompt." >&2
  exit 1
fi

# The child's own status, kept through `set -e`.
status=0
wait "$reader" || status=$?
exit "$status"
