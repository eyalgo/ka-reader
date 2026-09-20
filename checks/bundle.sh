#!/usr/bin/env bash
# Version: 1.1.0 — the launched sandbox is read from the operating system (sandbox_check, through a compiled probe), not from an environment marker
# Version: 1.0.0 — first version: the wall proven on a built bundle (entitlements, then the launched sandbox)
#
# checks/bundle.sh <path-to-app> — proves the App Sandbox wall on a BUILT Nozoki.app.
#
# WHY THIS EXISTS
#   The wall is two things: the bundle asks for exactly the entitlements C-R2 lists, and the
#   operating system then enforces a sandbox on the running process. A config test can prove the
#   first only about the source; this proves both about the artifact a user would run.
#   Entitlements are checked first, and a bundle that fails there is never launched — a wrong
#   entitlement set proves nothing by running.
#
# USAGE
#   checks/bundle.sh target/release/bundle/macos/Nozoki.app
#   Exit 0 only when the entitlement set is exactly the expected one, every value boolean true, and
#   the operating system reports the launched process sandboxed, an out-of-grant file read denied and
#   an outbound network connection denied for it. Every failure names its cause on stderr. On every
#   exit path no process of the bundle is left running.
#
# HOW THE OPERATING SYSTEM IS ASKED
#   Only libSystem's sandbox_check answers, and no shell can call it, so checks/sandbox_probe.rs is
#   compiled with rustc into this run's temporary directory and run as `nozoki-sandbox-probe <pid>`,
#   found through PATH — the seam a test uses to stand one condition at a time in for the real probe.
#   No environment variable and no container directory is evidence of a sandbox: a process can carry
#   the one and a directory can outlive the other (docs/SDD.md § 4 C-I3; NFDR QC-25; ADR-0010).

set -euo pipefail

die() { echo "bundle.sh: $*" >&2; exit 1; }

# --- args ---

app="${1:-}"
[ -n "$app" ] || die "usage: checks/bundle.sh <path-to-app>"

# --- the path is a launchable application bundle ---

[ -e "$app" ] || die "not found: $app"
case "$app" in
  *.app | *.app/) ;;
  *) die "not an application bundle: $app (no .app suffix)" ;;
esac
[ -d "$app" ] && [ -f "$app/Contents/Info.plist" ] || die "not an application bundle: $app (no Contents/Info.plist)"

app="$(cd "$app" && pwd -P)"
executable_name="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleExecutable' "$app/Contents/Info.plist" 2> /dev/null || true)"
[ -n "$executable_name" ] && [ -x "$app/Contents/MacOS/$executable_name" ] \
  || die "cannot be launched: $app has no executable at Contents/MacOS/${executable_name:-<CFBundleExecutable unreadable>}"

# --- the entitlement set is exactly the expected one ---

LAUNCH_POLL_TICKS=80   # of 0.25 s: 20 s for the launched process to appear
STOP_POLL_TICKS=20     # of 0.25 s: 5 s for it to exit after SIGTERM

# Every process whose executable sits inside the bundle. Anchored at the start of the command line,
# so `open`, `codesign` and this script — which carry the .app path, not the executable's — do not
# match.
bundle_pattern="^$(printf '%s' "$app" | sed 's/[][\.*^$(){}?+|/]/\\&/g')/Contents/MacOS/"
launched=0

bundle_pids() { pgrep -f "$bundle_pattern" || true; }

# On every exit path, leave no process of the bundle running. Only once this run has launched it:
# a bundle that was never launched has nothing of ours to stop.
stop_bundle_processes() {
  [ "$launched" -eq 1 ] || return 0
  pkill -TERM -f "$bundle_pattern" 2> /dev/null || true
  ticks=0
  while [ -n "$(bundle_pids)" ] && [ "$ticks" -lt "$STOP_POLL_TICKS" ]; do
    sleep 0.25
    ticks=$((ticks + 1))
  done
  pkill -KILL -f "$bundle_pattern" 2> /dev/null || true
}

work="$(mktemp -d)"
trap 'stop_bundle_processes; rm -rf "$work"' EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

EXPECTED_ENTITLEMENTS="com.apple.security.app-sandbox
com.apple.security.files.user-selected.read-only"

# The non-deprecated form first; the older `:-` spelling only where `--xml` is unknown. stderr is
# dropped on both: codesign prints the executable path and a deprecation note there, and only
# stdout is the property list.
{ codesign -d --xml --entitlements - "$app" 2> /dev/null || codesign -d --entitlements :- "$app" 2> /dev/null; } \
  > "$work/entitlements.plist" || die "cannot read the code signature of $app"

# An empty result is a signed bundle with no entitlements: every expected key is then missing.
entitlement_lines=""
if [ -s "$work/entitlements.plist" ]; then
  entitlement_lines="$(/usr/libexec/PlistBuddy -c Print "$work/entitlements.plist" 2> /dev/null)" \
    || die "the entitlements of $app are not a readable property list"
fi

declared_keys=""
problems=""
while IFS= read -r line; do
  case "$line" in
    "    "[!\ ]*" = "*) ;;
    *) continue ;;
  esac
  entry="${line#    }"
  key="${entry%% = *}"
  value="${entry#* = }"
  echo "entitlement: $key = $value"
  declared_keys="$declared_keys$key
"
  case "
$EXPECTED_ENTITLEMENTS
" in
    *"
$key
"*) [ "$value" = "true" ] || problems="${problems}entitlement not true: $key = $value
" ;;
    *) problems="${problems}extra entitlement: $key
" ;;
  esac
done <<< "$entitlement_lines"

for expected_key in $EXPECTED_ENTITLEMENTS; do
  case "
$declared_keys" in
    *"
$expected_key
"*) ;;
    *) problems="${problems}missing entitlement: $expected_key
" ;;
  esac
done

[ -z "$problems" ] || { printf '%s' "$problems" >&2; die "the entitlement set of $app is not the expected one; the bundle was not launched"; }

# --- the probe that asks the operating system ---

# Compiled before anything is launched: a run that cannot ask must not start the bundle. `rustc` is
# required for the run, so it is guarded here rather than met later (the shell packet's tier 2,
# `<CORE>/doctrine/engineering/languages/shell/toolchain.md` § What may be depended on).
PROBE_SOURCE="$(cd "$(dirname "$0")" && pwd -P)/sandbox_probe.rs"
command -v rustc > /dev/null 2>&1 || die "rustc not found on PATH — the sandbox probe (checks/sandbox_probe.rs) is compiled with it"
[ -f "$PROBE_SOURCE" ] || die "the probe source is missing: $PROBE_SOURCE"
mkdir -p "$work/probe-bin"
rustc --edition 2021 -O -o "$work/probe-bin/nozoki-sandbox-probe" "$PROBE_SOURCE" 2> "$work/probe-build.log" \
  || die "the sandbox probe did not compile: $(cat "$work/probe-build.log")"
# Appended, not prepended: a directory ahead of it on PATH (a test's stand-in) is the one that answers.
PATH="$PATH:$work/probe-bin"

# --- launch it and observe the sandbox ---

# Through LaunchServices, the route a user takes; a direct exec would test a path no user takes.
launched=1
open -n -g "$app" || die "cannot be launched: open refused $app"

# Polled for a bounded time rather than slept on once.
pid=""
ticks=0
while [ -z "$pid" ] && [ "$ticks" -lt "$LAUNCH_POLL_TICKS" ]; do
  pid="$(bundle_pids | head -1 || true)"
  [ -n "$pid" ] || sleep 0.25
  ticks=$((ticks + 1))
done
[ -n "$pid" ] || die "cannot be launched: no process of $app appeared within $((LAUNCH_POLL_TICKS / 4)) seconds"

# The probe's own failure — sandbox_check unresolvable, or an error from it — is neither a pass nor
# a denial (CP-43): the run ends here, naming what it could not read.
if ! probe_output="$("nozoki-sandbox-probe" "$pid" 2> "$work/probe.err")"; then
  die "the operating system's sandbox report for pid $pid could not be read: $(cat "$work/probe.err")"
fi
printf '%s\n' "$probe_output"

problems=""
case "
$probe_output
" in
  *"
sandboxed: yes
"*) ;;
  *) problems="${problems}condition not held: the launched process is not sandboxed
" ;;
esac
case "
$probe_output
" in
  *"
out-of-grant-read: denied
"*) ;;
  *) problems="${problems}condition not held: an out-of-grant file read is not denied
" ;;
esac
case "
$probe_output
" in
  *"
outbound-connection: denied
"*) ;;
  *) problems="${problems}condition not held: an outbound network connection is not denied
" ;;
esac

[ -z "$problems" ] || { printf '%s' "$problems" >&2; die "the wall does not hold on the launched process (pid $pid)"; }
echo "sandbox observed: sandboxed, out-of-grant read denied, outbound connection denied (pid $pid)"
