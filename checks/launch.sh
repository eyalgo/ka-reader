#!/usr/bin/env bash
# Version: 1.0.0 — first version: the Launch the built bundle step's body, out of the workflow and into a script
#
# checks/launch.sh — launches the built KA-Reader.app once and waits, for a bounded time, for the log
# the app writes. Run from the product root; it takes no argument.
#
# WHY THIS EXISTS
#   The step used to be a block inside .github/workflows/ci.yml, where no person could run it and no case
#   could prove it. It is a script now (docs/nfdr.md QC-64), and the workflow calls it and holds no rule
#   of its own. Its cases are checks/tests/test_launch.sh.
#
# WHAT IT DOES
#   1. Admission: it asks the host whether it is a macOS virtual machine. See ADMISSION below.
#   2. It launches target/release/bundle/macos/KA-Reader.app once, through `open`. An `open` that fails
#      ends the run with its own exit status, and nothing is waited for.
#   3. It waits for the app's log (the Containers path under $HOME, the file the app writes on launch).
#      The wait is fixed in this file: 240 ticks of 0.25 s, and no environment variable changes it.
#      A log that is already there is a success, and so is one that appears on the last tick.
#   4. If the ticks run out it stops the wait, prints one line on stderr that names the log and the known
#      reason such a wait can hang, and exits 1.
#
# HOW THE WAIT IS HELD
#   Reading the app's own container can block on an operating-system consent prompt, so the file is
#   looked at by a child, and the foreground only counts ticks. A blocked look therefore cannot stop the
#   count. The child runs in a process group of its own (job control, `set -m`), so a timeout that
#   kills the group ends the child and the `sleep` it is waiting on together, and leaves nothing behind.
#   A child that finished is reaped and its exit status is the script's.
#
# ADMISSION
#   The first thing the script does is ask the host whether it is a macOS virtual machine (`uname -s`
#   Darwin and `sysctl -n kern.hv_vmm_present` 1, both succeeding). On any other reading it prints one
#   line on stderr, nothing on stdout, and exits 1, before it launches anything or looks at the home
#   (docs/nfdr.md QC-65). Nothing it is given turns this off.

set -euo pipefail

# --- admission: this step runs only in a macOS virtual machine (docs/nfdr.md QC-65) ---
# First work of the run, inline so nothing is opened, found or read before it. Both host readings must
# succeed and read exactly Darwin and 1; a reader that fails, is missing or prints anything else
# refuses, and a failing reader that prints 1 does not admit (the status is kept, not only the text).
# Nothing the script reads — argument, flag or variable — changes this.
host_os="$(uname -s 2> /dev/null)" && host_vmm="$(sysctl -n kern.hv_vmm_present 2> /dev/null)" \
  && [ "$host_os" = "Darwin" ] && [ "$host_vmm" = "1" ] \
  || { echo "launch.sh: refused: this host does not read as a macOS virtual machine. This step launches KA-Reader.app or reads this machine's home, and runs only in a macOS virtual machine (docs/nfdr.md QC-65)." >&2; exit 1; }

APP="target/release/bundle/macos/KA-Reader.app"
LOG="$HOME/Library/Containers/com.kensaiapp.ka-reader/Data/Library/Logs/ka-reader.log"
WAIT_TICKS=240

open "$APP"

# The child looks for the log; the foreground counts ticks. `set -m` gives the child a process group of
# its own, so one signal to the group reaches the child and the wait it is in.
set -m
( until [ -f "$LOG" ]; do sleep 0.25; done ) &
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
  echo "ci: no log appeared at $LOG within $WAIT_TICKS ticks of 0.25s. Reading the app's own container is known to wait on an operating-system consent prompt." >&2
  exit 1
fi
wait "$reader"
