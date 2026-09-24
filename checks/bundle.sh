#!/usr/bin/env bash
# Version: 1.6.0 — the Tauri build leaves — native bundle assembled, bundle.sh and no-network.sh read it, CI builds it, boundaries and README pinned
# Version: 1.5.0 — the probe waits, bounded, for the sandbox report, and its control holds for the whole window; plutil read only on exit 0
# Version: 1.4.0 — --negative-control: the same launch-and-probe path on a no-entitlement build, passing only when it is reported NOT sandboxed
# Version: 1.3.0 — one executable under Contents/MacOS, and the renderer build under Contents/Resources, read before the launch
# Version: 1.2.0 — one process, found by its executable path and stopped alone (no pattern match, no pkill)
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
#   The contents are read next, and also before anything is launched: exactly one executable (a file
#   with any execute bit, or a Mach-O binary whatever its mode), no font, no byte copy of a file tracked
#   under checks/, and every file of third_party/lucide/icons under Contents/Resources and nowhere else
#   in the bundle. Each offending path is named on stderr.
#
# USAGE
#   checks/bundle.sh target/release/bundle/macos/Nozoki.app
#   checks/bundle.sh --negative-control <path-to-app>
#     The control: the same launch-and-probe path, but the bundle's entitlement set must be EMPTY and
#     the run passes only when every report the operating system gives, across the whole probe window,
#     says the launched process is NOT sandboxed. It cannot pass on a bundle carrying the C-R2 keys, so
#     it is not a route past the gate above. It
#     exists because the ordinary path refuses to launch anything but C-R2's set, and a probe that
#     cannot tell the two builds apart has not run (NFDR QC-25).
#   Exit 0 only when the entitlement set is exactly the expected one, every value boolean true, and
#   the operating system reports the launched process sandboxed, an out-of-grant file read denied and
#   an outbound network connection denied for it. Every failure names its cause on stderr. On every
#   exit path the one process this run launched, and recorded, is stopped — and only that one: a
#   process of the same bundle already running when the script started, or started by anything else
#   while it ran, is never signalled.
#
# HOW THE OPERATING SYSTEM IS ASKED
#   Only libSystem's sandbox_check answers, and no shell can call it, so checks/sandbox_probe.rs is
#   compiled with rustc into this run's temporary directory and run as `nozoki-sandbox-probe <pid>`,
#   found through PATH — the seam a test uses to stand one condition at a time in for the real probe.
#   The ordinary path asks it up to BUNDLE_SH_PROBE_TICKS times, 0.25 s apart (default 40).
#   The pass is the first ask on which all three hold. A report that falls short is asked past until
#   the window runs out, and the last report asked is then judged. The bound is printed on the pass
#   line and on the red closing line.
#   No environment variable and no container directory is evidence of a sandbox: a process can carry
#   the one and a directory can outlive the other (docs/SDD.md § 4 C-I3; NFDR QC-25; ADR-0010).

set -euo pipefail

die() { echo "bundle.sh: $*" >&2; exit 1; }

# --- args ---

negative_control=0
if [ "${1:-}" = "--negative-control" ]; then
  negative_control=1
  shift
fi
app="${1:-}"
[ -n "$app" ] || die "usage: checks/bundle.sh [--negative-control] <path-to-app>"

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

# An override for a caller that must not wait the full time (a test with no process to wait for).
LAUNCH_POLL_TICKS="${BUNDLE_SH_LAUNCH_TICKS:-80}"   # of 0.25 s: 20 s for the launched process to appear
STOP_POLL_TICKS=20     # of 0.25 s: 5 s for it to exit after SIGTERM

# The probe window: up to this many asks, spaced 0.25 s apart, before the ordinary path judges the
# last report and the negative control gives up waiting for one (both below). An empty value reads as
# unset, the same way LAUNCH_POLL_TICKS above does. Refused before anything is launched, so a bad
# value never reaches either loop.
PROBE_TICKS="${BUNDLE_SH_PROBE_TICKS:-40}"   # of 0.25 s: the bound on every ask
case "$PROBE_TICKS" in
  *[!0-9]*) die "BUNDLE_SH_PROBE_TICKS must be a positive whole number (got: $PROBE_TICKS)" ;;
esac
# Read in base 10 (10#…) so a leading zero such as 08 is accepted, rather than read as invalid octal.
[ "$((10#$PROBE_TICKS))" -gt 0 ] || die "BUNDLE_SH_PROBE_TICKS must be a positive whole number (got: $PROBE_TICKS)"
PROBE_TICKS=$((10#$PROBE_TICKS))

# The main process is identified by its absolute executable path — never by a pattern over command
# lines, which would also match every process that merely mentions the bundle. `ps` through PATH so a
# test can stub it; an unreadable listing reads as "none found", never as a crash.
bundle_executable="$app/Contents/MacOS/$executable_name"
executable_pids() {
  { ps -axo pid=,comm= 2> /dev/null || true; } | while read -r candidate_pid candidate_path; do
    if [ "$candidate_path" = "$bundle_executable" ]; then
      echo "$candidate_pid"
    fi
  done
}

# The one pid this run launched. Empty until it has been found and recorded, so a run that never
# recorded one has nothing of its own to stop.
launched_pid=""

# On every exit path, stop the pid this run recorded and no other. Whatever else carries the same
# executable path is not this run's.
stop_launched_process() {
  [ -n "$launched_pid" ] || return 0
  kill -TERM "$launched_pid" 2> /dev/null || true
  ticks=0
  while kill -0 "$launched_pid" 2> /dev/null && [ "$ticks" -lt "$STOP_POLL_TICKS" ]; do
    sleep 0.25
    ticks=$((ticks + 1))
  done
  if kill -0 "$launched_pid" 2> /dev/null; then
    kill -KILL "$launched_pid" 2> /dev/null || true
  fi
}

work="$(mktemp -d)"
trap 'stop_launched_process; rm -rf "$work"' EXIT
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
  if [ "$negative_control" -eq 1 ]; then
    problems="${problems}entitlement present in the negative control: $key
"
    continue
  fi
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

# The control expects no entitlement at all, so no key can be missing from it.
if [ "$negative_control" -eq 0 ]; then
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
fi

[ -z "$problems" ] || { printf '%s' "$problems" >&2; die "the entitlement set of $app is not the expected one; the bundle was not launched"; }

# --- the contents: one executable, no font, no copy of a checks/ file ---

# Read before the probe is compiled and before anything is launched: a bundle that ships more than its
# one executable and its glyphs is refused unstarted (NFDR QC-55, QC-14). Every offending path is
# named on stderr, so one run says everything that is wrong.
product_root="$(cd "$(dirname "$0")/.." && pwd -P)"
contents_problems=""

# The candidates for the copy rule: the regular, non-empty files git tracks under checks/. A listing that
# fails, or comes back empty, is a refusal and never a pass: an empty candidate set would let every copy
# through.
tracked_checks="$(git -C "$product_root" ls-files checks 2> "$work/ls-files.err")" \
  || die "cannot list the files tracked under checks/: $(cat "$work/ls-files.err")"
[ -n "$tracked_checks" ] || die "the list of files tracked under checks/ is empty — there is nothing to compare the bundle's files against"
: > "$work/checks.sha"
while IFS= read -r tracked; do
  candidate="$product_root/$tracked"
  if [ -f "$candidate" ] && [ ! -L "$candidate" ] && [ -s "$candidate" ]; then
    shasum -a 256 "$candidate" >> "$work/checks.sha"
  fi
done <<< "$tracked_checks"

# Any execute bit at all, on any regular file under Contents; the magic below catches the binary whose
# mode says nothing.
mode_executables="$(find "$app/Contents" -type f \( -perm -100 -o -perm -010 -o -perm -001 \) | LC_ALL=C sort)"

while IFS= read -r member; do
  [ -n "$member" ] || continue
  relative="${member#"$app"/}"
  # The first four bytes, as hex. `file`'s wording is not a contract, so it is not asked.
  magic="$({ head -c 4 "$member" | od -An -tx1 | tr -d ' \n'; } 2> /dev/null || true)"

  is_executable=0
  case "
$mode_executables
" in
    *"
$member
"*) is_executable=1 ;;
  esac
  # Mach-O, thin or fat, in either byte order. cafebabe is a Java class file's magic too, so a class file
  # is refused as well; that fails closed.
  case "$magic" in
    feedface | feedfacf | cefaedfe | cffaedfe | cafebabe | cafebabf | bebafeca | bfbafeca) is_executable=1 ;;
  esac
  if [ "$is_executable" -eq 1 ] && [ "$relative" != "Contents/MacOS/$executable_name" ]; then
    contents_problems="${contents_problems}extra executable: $relative
"
  fi

  is_font=0
  lowered_name="$(printf '%s' "${member##*/}" | tr '[:upper:]' '[:lower:]')"
  case "$lowered_name" in
    *.ttf | *.otf | *.ttc | *.otc | *.woff | *.woff2 | *.dfont) is_font=1 ;;
  esac
  # 00010000 (TrueType), OTTO, true, typ1, ttcf, wOFF, wOF2
  case "$magic" in
    00010000 | 4f54544f | 74727565 | 74797031 | 74746366 | 774f4646 | 774f4632) is_font=1 ;;
  esac
  if [ "$is_font" -eq 1 ]; then
    contents_problems="${contents_problems}font: $relative
"
  fi

  # A file of checks/ has no business in the bundle whatever it is called. Hashed once each side, and
  # every hit confirmed byte for byte before it is named.
  if [ -s "$work/checks.sha" ] && [ -s "$member" ]; then
    member_hash="$(shasum -a 256 "$member" | awk '{ print $1 }')"
    while IFS= read -r same_hash_path; do
      [ -n "$same_hash_path" ] || continue
      if cmp -s "$member" "$same_hash_path"; then
        contents_problems="${contents_problems}copy of a checks/ file: $relative (the same bytes as ${same_hash_path#"$product_root"/})
"
      fi
    done <<< "$(awk -v wanted="$member_hash" '$1 == wanted { print substr($0, 67) }' "$work/checks.sha")"
  fi
done <<< "$(find "$app/Contents" -type f | LC_ALL=C sort)"

[ -z "$contents_problems" ] || { printf '%s' "$contents_problems" >&2; die "the bundle holds files it must not ship; the bundle was not launched"; }

# --- the glyphs: every member of the expected set is under Contents/Resources, and nowhere else ---

# The expected set is every regular file directly in the source tree's glyph directory, dotfiles
# included, read when the script runs — never a list held here. An override for a caller that must stand
# another directory in (a test).
GLYPH_DIR="${BUNDLE_SH_GLYPH_DIR:-$product_root/third_party/lucide/icons}"
[ -d "$GLYPH_DIR" ] || die "the expected glyph set is empty: $GLYPH_DIR does not exist; the bundle was not launched"
glyph_members="$(find "$GLYPH_DIR" -maxdepth 1 -type f | sed 's#.*/##' | LC_ALL=C sort)"
[ -n "$glyph_members" ] || die "the expected glyph set is empty: $GLYPH_DIR holds no regular file; the bundle was not launched"

glyph_problems=""
while IFS= read -r glyph; do
  [ -f "$app/Contents/Resources/$glyph" ] || glyph_problems="${glyph_problems}glyph missing from Contents/Resources: $glyph
"
done <<< "$glyph_members"

# Every path outside Contents/Resources, at any depth, Contents itself included. Info.plist,
# _CodeSignature and icon.icns are nobody's glyph and are outside the rule: only a member's name or an
# .svg suffix is read.
while IFS= read -r outside; do
  [ -n "$outside" ] || continue
  outside_name="${outside##*/}"
  is_glyph=0
  case "$outside_name" in
    *.svg) is_glyph=1 ;;
  esac
  case "
$glyph_members
" in
    *"
$outside_name
"*) is_glyph=1 ;;
  esac
  if [ "$is_glyph" -eq 1 ]; then
    glyph_problems="${glyph_problems}glyph outside Contents/Resources: ${outside#"$app"/}
"
  fi
done <<< "$(find "$app/Contents" -mindepth 1 -path "$app/Contents/Resources" -prune -o -print | LC_ALL=C sort)"

[ -z "$glyph_problems" ] || { printf '%s' "$glyph_problems" >&2; die "the bundle's glyphs are not exactly under Contents/Resources; the bundle was not launched"; }
echo "glyph set: $(printf '%s\n' "$glyph_members" | wc -l | tr -d ' ') members checked — each is under Contents/Resources and nowhere else in the bundle"

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

# An instance already running would make "the process this run launched" unknowable, and stopping it
# afterwards would stop someone else's. Refused before anything is launched.
already_running="$(executable_pids | tr '\n' ' ')"
[ -z "$already_running" ] \
  || die "an instance was already running (pid ${already_running% }) with the executable path $bundle_executable; nothing was launched"

# Through LaunchServices, the route a user takes; a direct exec would test a path no user takes.
open -n -g "$app" || die "cannot be launched: open refused $app"

# Polled for a bounded time rather than slept on once.
found_pids=""
ticks=0
while [ -z "$found_pids" ] && [ "$ticks" -lt "$LAUNCH_POLL_TICKS" ]; do
  found_pids="$(executable_pids | tr '\n' ' ')"
  [ -n "$found_pids" ] || sleep 0.25
  ticks=$((ticks + 1))
done
[ -n "$found_pids" ] \
  || die "cannot be launched: no process appeared — none has the executable path $bundle_executable within $((LAUNCH_POLL_TICKS / 4)) seconds"
set -- $found_pids
# Nothing is recorded, so nothing is signalled: which of them this run launched cannot be told.
[ "$#" -eq 1 ] || die "more than one process has the executable path $bundle_executable after the launch (pids $found_pids); none was stopped, since this run cannot tell which one it launched"
pid="$1"
launched_pid="$pid"
echo "launched: pid $pid ($bundle_executable)"

# The control asks up to PROBE_TICKS times, 0.25 s apart, and passes only when every report in the
# window says the launched process is NOT sandboxed (CP-69). Any report that does not say so ends the
# run at once: an entitled build the probe calls sandboxed is the answer the control was built to
# expect, so that same report on an unentitled build means the probe cannot tell the two apart (CP-59:
# that is the result, and it is not worked around). The probe's own failure — sandbox_check
# unresolvable, or an error from it — is neither a pass nor a denial (CP-43): the run ends here, naming
# what it could not read. No sleep follows the last ask.
if [ "$negative_control" -eq 1 ]; then
  tick=0
  while :; do
    tick=$((tick + 1))
    if ! probe_output="$("nozoki-sandbox-probe" "$pid" 2> "$work/probe.err")"; then
      die "the operating system's sandbox report for pid $pid could not be read: $(cat "$work/probe.err")"
    fi
    case "
$probe_output
" in
      *"
sandboxed: no
"*) ;;
      *) break ;;
    esac
    [ "$tick" -lt "$PROBE_TICKS" ] || break
    sleep 0.25
  done
  printf '%s\n' "$probe_output"
  case "
$probe_output
" in
    *"
sandboxed: no
"*) echo "negative control: the operating system reports the launched process not sandboxed within $PROBE_TICKS asks, 0.25 s apart (pid $pid)"; exit 0 ;;
    *) die "the negative control was reported sandboxed (pid $pid): the probe cannot tell a build with the entitlements from one without them" ;;
  esac
fi

# The ordinary path judges each ask's report once, inside the loop: the first ask whose report holds
# all three lines ends the loop as a pass (CP-73). Any other report is asked past while the window
# lasts — a sandboxed: no, a yes carrying an allowed, or a report missing a line. When the window runs
# out, the last report asked is the one judged, by the same three-condition check (CP-74), and the
# closing failure line states the window (CP-75). Exactly one report is printed, whichever way the
# loop ends (CP-77). A probe failure on any ask ends the run at once, on the same die path as the
# control's (CP-67). No sleep follows the last ask, whichever way the loop ends.
tick=0
while :; do
  tick=$((tick + 1))
  if ! probe_output="$("nozoki-sandbox-probe" "$pid" 2> "$work/probe.err")"; then
    die "the operating system's sandbox report for pid $pid could not be read: $(cat "$work/probe.err")"
  fi
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
  [ -n "$problems" ] || break
  [ "$tick" -lt "$PROBE_TICKS" ] || break
  sleep 0.25
done
printf '%s\n' "$probe_output"

[ -z "$problems" ] \
  || { printf '%s' "$problems" >&2; die "the wall does not hold on the launched process (pid $pid): no ask held all three within $PROBE_TICKS asks, 0.25 s apart"; }
echo "sandbox observed: sandboxed, out-of-grant read denied, outbound connection denied (pid $pid), the first ask to hold all three within $PROBE_TICKS asks, 0.25 s apart"
