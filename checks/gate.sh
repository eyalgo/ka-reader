#!/usr/bin/env bash
# Version: 1.0.0 — first version: the one ordered list of the gate's steps, each fatal (NFDR QC-64)
#
# checks/gate.sh — runs every step of the gate, in order. The first step that exits non-zero ends
# the run.
#
# WHY THIS EXISTS
#   The workflow ran each of these steps on its own. This script holds them in one place, so the
#   workflow holds no rule of its own (docs/nfdr.md QC-64).
#
# USAGE
#   checks/gate.sh
#   Run from the product root. It reads no argument and no variable of its own.
#
# WHY NO RETRY, CAPTURE OR FILTER
#   A step's own output is what says why it stopped, so it stays attached to this script's stdout
#   and stderr as the step wrote it.

set -euo pipefail

# --- the one dispatcher ---

# Runs one step's command in a child bash, so a command made of two parts stays one named step.
# The status is checked here and not left to `set -e`: `set -e` would end the run without the line
# that names the step.
run_step() {
  local name="$1"
  local command="$2"
  if ! bash -c "$command"; then
    echo "gate.sh: step failed: $name" >&2
    exit 1
  fi
}

# --- the steps ---

# The steps, in the order they run. The first step that exits non-zero ends the run, and no step
# after it runs. Where a step has to come before or after another, the comment above it says which
# and why: read it before you move the step.

# "Toolchain" comes first, before any build. No Swift version is pinned in this tree, so these two
# lines are the record of which Swift and which SDK the run built with
# (docs/nfdr.md § 9, Toolchain).
run_step 'Toolchain' 'swift --version && xcrun --show-sdk-version'
run_step 'Build the workspace' 'cargo build --workspace --locked'
# The app build comes before "Test gate": it writes the bridge artifact the Swift package links,
# which a fresh checkout does not have, so "Test gate" cannot run before it.
run_step 'Build KA-Reader.app' 'ka-reader-mac/assemble.sh'
run_step 'Test gate' 'cargo test --workspace --locked && swift test --package-path ka-reader-mac'
run_step 'Structure check' 'checks/structure.sh'
run_step 'Structure check suite' 'checks/tests/test_structure.sh'
run_step 'Entry-points check' 'checks/entry-points.sh'
run_step 'Entry-points check suite' 'checks/tests/test_entry_points.sh'
run_step 'Bundle probe' 'checks/bundle.sh target/release/bundle/macos/KA-Reader.app'
# The probe's negative control runs here: without it the probe has not run.
run_step 'Bundle probe suite' 'checks/tests/test_bundle.sh'
run_step 'View check' 'checks/view.sh'
run_step 'View check suite' 'checks/tests/test_view.sh'
# "Renderer gate" comes after "Bundle probe" and never instead of it, as ADR-0012 decides:
# docs/adr/0012-renderer-run-proved-on-the-shipped-bundle-beside-the-wall.md.
# checks/renderer.sh runs its own idle-shell control: a run without the control has not run the
# renderer gate. Its launch of the product may leave the app's log behind before "Launch the built
# bundle" runs.
run_step 'Renderer gate' 'checks/renderer.sh target/release/bundle/macos/KA-Reader.app'
# The suite's real-bundle cases run checks/renderer.sh on the real bundle, and checks/renderer.sh
# refuses to launch while an instance is running. "Launch the built bundle" leaves the app running,
# so this step comes before it.
run_step 'Renderer gate suite' 'checks/tests/test_renderer.sh'
run_step 'Read-only, plain folder' 'checks/read-only.sh checks/fixtures/plain'
run_step 'Read-only, repository' 'checks/read-only.sh checks/fixtures/repo'
run_step 'Read-only, submodule' 'checks/read-only.sh checks/fixtures/submodule'
run_step 'Read-only suite' 'checks/tests/test_read_only.sh'
run_step 'No-network dependency list' 'checks/no-network.sh'
run_step 'No-network suite' 'checks/tests/test_no_network.sh'
run_step 'Own state suite' 'checks/tests/test_own_state.sh'
# "VM refusal suite", "Launch step suite" and "Own state step suite" launch nothing, so they run
# before the real launch below.
run_step 'VM refusal suite' 'checks/tests/test_vm_refusal.sh'
run_step 'Launch step suite' 'checks/tests/test_launch.sh'
run_step 'Own state step suite' 'checks/tests/test_own_state_step.sh'
# The app's own log is written by a launch. Steps above this one launch the product, and each may
# already have left the log behind: "Bundle probe", "Bundle probe suite", "Renderer gate" and
# "Renderer gate suite". "Own state", the step that runs checks/own-state.sh against this machine's
# own home and the app's real log, comes after this step and never before it.
# Reading the app's container can wait on an operating-system consent prompt, so checks/launch.sh
# holds the watchdog: it looks for the log in a child and counts a fixed number of ticks, and names
# what it was reading when they run out. No timer is set on this step here: a timer around it would
# stop the step without saying what it was reading.
run_step 'Launch the built bundle' 'checks/launch.sh'
# Last: it reads what "Launch the built bundle" left behind. checks/own-state-step.sh runs
# checks/own-state.sh with the same bounded wait.
run_step 'Own state' 'checks/own-state-step.sh'
