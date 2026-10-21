#!/usr/bin/env bash
# Version: 1.1.0 — takes out what its own restore laid down, once the verdict is taken, on every exit
# Version: 1.0.0 — first version: proves a walk of a fixture folder changed nothing in it
#
# checks/read-only.sh <fixture> — hash a fixture, walk it with ka-reader-core's driver, hash it again.
#
# WHY THIS EXISTS
#   CP-35 and CP-36: the product must only ever read. The proof is outside the product — this script
#   hashes the folder with its own tools (never through ka-reader-core), runs the in-process driver
#   (crates/ka-reader-core/tests/walk.rs) over it, and hashes again. A difference is a write.
#
# USAGE
#   checks/read-only.sh checks/fixtures/plain
#   stdout carries the verdict and nothing else: `unchanged` and exit 0, or each differing relative
#   path once and a non-zero exit. Every message and all build and driver output go to stderr.
#   A walk that did not complete (the driver failed, or it made no call) is never `unchanged`.
#
# WHAT IS HASHED
#   Every entry under the fixture, `.git` included, links not followed: relative path, kind, and
#   content (the file's bytes, or a link's target). No timestamps and no modes, so a `touch` is not
#   a change. No git command runs inside the fixture.
#
# RESTORE
#   A `<fixture>.git.tar` beside the fixture is that fixture's `.git`. If the archive exists and the
#   fixture has no `.git` (of any kind, a dangling link included), it is extracted before the first
#   hash. It is unpacked in scratch space first and its entries are then copied into the fixture
#   where nothing is, so an entry already there is never overwritten or followed. Every entry laid
#   down, the folders created only to hold one included, is written to a ledger before it is made.
#
# WHAT STAYS, AND WHAT GOES
#   Once the verdict is taken, the entries in the ledger are removed, deepest first and never
#   recursively, and the script says so if one is left (`restored entry not removed: <path>`). Two
#   things stay: an entry already in the fixture at start, and an entry the walk created together
#   with the restored folders it needs. A restored file the walk rewrote is still restored, and goes.
#   This holds on every way the script ends after the restore began, a signal included.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
NAME="read-only.sh"

# One record per entry: <relative path> TAB <kind> TAB <digest>, sorted by path. `find` does not
# follow links, so a link is hashed as a link.
manifest() {
  (
    cd "$1"
    find . -mindepth 1 | LC_ALL=C sort | while IFS= read -r entry; do
      if [ -L "$entry" ]; then
        kind="link"
        digest="$(readlink "$entry")"
      elif [ -d "$entry" ]; then
        kind="folder"
        digest="-"
      elif [ -f "$entry" ]; then
        kind="file"
        digest="$(shasum -a 256 < "$entry" | cut -d ' ' -f 1)"
      else
        kind="other"
        digest="-"
      fi
      printf '%s\t%s\t%s\n' "${entry#./}" "$kind" "$digest"
    done
  )
}

# Every path whose record is in one manifest and not the other, once each. `diff` exits 1 when the
# manifests differ, which under pipefail would end the script, hence the `|| true`.
differing_paths() {
  diff "$1" "$2" | sed -n 's/^[<>] //p' | cut -f 1 | LC_ALL=C sort -u || true
}

if [ $# -ne 1 ]; then
  echo "$NAME: usage: $NAME <fixture folder>" >&2
  exit 2
fi

fixture="${1%/}"
if [ ! -d "$fixture" ]; then
  echo "$NAME: not a folder: $1" >&2
  exit 1
fi
absolute="$(cd "$fixture" && pwd)"
archive="$fixture.git.tar"

# --- the lifetime of the restore ---
# What the finalizer reads. All of it is set before the first fixture write, so an interruption at any
# point finds the state it needs.
work=""
ledger=""
walk_started=0
compared=0
changed=""
teardown=0
signalled=0
signal_status=""
child_pid=""
residual_count=0

# Succeeds when $1 is a path inside one of the folders listed, one per line, in $2.
is_under_listed() {
  local folder
  while IFS= read -r folder; do
    [ -n "$folder" ] || continue
    case "$1" in
      "$folder"/*) return 0 ;;
    esac
  done <<EOF
$2
EOF
  return 1
}

# Succeeds when every folder on the way to fixture-relative path $1 is a real folder. Cleanup never
# goes through a link a walk put where a folder was.
reachable() {
  local rest="$1" here="$absolute" part
  while true; do
    case "$rest" in
      */*) ;;
      *) return 0 ;;
    esac
    part="${rest%%/*}"
    rest="${rest#*/}"
    here="$here/$part"
    if [ -L "$here" ] || [ ! -d "$here" ]; then
      return 1
    fi
  done
}

# Runs "$@" as a child the signal handler can find and stop, and waits for it. A child that can still
# write is never left running while the evidence is read and the entries are removed.
run_child() {
  local status=0
  "$@" < /dev/null &
  child_pid=$!
  wait "$child_pid" || status=$?
  child_pid=""
  return "$status"
}

# Stops $1 and everything under it. The children are listed before the parent is stopped, because
# once it is gone they no longer name it.
kill_tree() {
  local children="" child
  if command -v pgrep > /dev/null 2>&1; then
    children="$(pgrep -P "$1" 2> /dev/null || true)"
  fi
  kill "$1" 2> /dev/null || true
  for child in $children; do
    kill_tree "$child"
  done
}

stop_child() {
  [ -n "$child_pid" ] || return 0
  kill_tree "$child_pid"
  wait "$child_pid" 2> /dev/null || true
  child_pid=""
}

# Every signal a script can act on and that ends it by default: whatever this shell lists, less the
# two no process can catch (KILL, STOP) and those that stop, continue or are ignored by default.
actionable_signals() {
  local name
  trap -l | sed 's/[0-9]*)//g' | tr -s ' \t' '\n\n' | sed -n 's/^SIG\([A-Z0-9]*\)$/\1/p' |
    while IFS= read -r name; do
      case "$name" in
        KILL | STOP | TSTP | TTIN | TTOU | CONT | CHLD | CLD | URG | WINCH | INFO | IO | POLL | RT*) ;;
        *) echo "$name" ;;
      esac
    done
}

# A signal ends the run with 128 plus its number, through the finalizer. A second signal, or one that
# arrives during teardown, is recorded and teardown goes on to its end.
on_signal() {
  local number
  number="$(kill -l "$1")"
  [ -n "$signal_status" ] || signal_status=$((128 + number))
  if [ "$teardown" -eq 1 ] || [ "$signalled" -eq 1 ]; then
    return 0
  fi
  signalled=1
  stop_child
  exit "$signal_status"
}

# Lays the archive's entries into the fixture, never over an entry already there. Each is entered in
# the ledger before it is made, so a failure or a signal in the middle of one still leaves the ledger
# naming it. Explicit checks throughout: `set -e` does not reach into a function called as a condition.
restore() {
  local stage entry destination skipped_folders="" kind
  [ -f "$archive" ] || return 0
  if [ -e "$absolute/.git" ] || [ -L "$absolute/.git" ]; then
    return 0
  fi

  stage="$work/stage"
  mkdir "$stage" || return 1
  if ! run_child tar -xf "$archive" -C "$stage"; then
    echo "$NAME: could not extract $archive" >&2
    return 1
  fi
  (cd "$stage" && find . -mindepth 1 | LC_ALL=C sort) > "$work/stage-list" || return 1

  while IFS= read -r entry; do
    entry="${entry#./}"
    if is_under_listed "$entry" "$skipped_folders"; then
      continue
    fi
    destination="$absolute/$entry"
    if [ -L "$stage/$entry" ]; then
      kind="link"
    elif [ -d "$stage/$entry" ]; then
      kind="folder"
    else
      kind="file"
    fi
    if [ -e "$destination" ] || [ -L "$destination" ]; then
      if [ "$kind" = "folder" ] && [ -d "$destination" ] && [ ! -L "$destination" ]; then
        continue
      fi
      [ "$kind" != "folder" ] || skipped_folders="$skipped_folders$entry"$'\n'
      continue
    fi
    printf '%s\n' "$entry" >> "$ledger" || return 1
    if [ "$kind" = "folder" ]; then
      mkdir "$destination" || return 1
    else
      run_child cp -pP "$stage/$entry" "$destination" || return 1
    fi
  done < "$work/stage-list"
}

# Writes `kept`: the paths first present after the walk, and every folder on the way to one. These
# are the walk's evidence, and cleanup leaves them where they are. Fails when it cannot tell.
keep_walk_evidence() {
  local path
  (cd "$absolute" && find . -mindepth 1 | sed 's|^\./||' | LC_ALL=C sort) > "$work/after-paths" ||
    return 1
  cut -f 1 "$work/before" | LC_ALL=C sort -u > "$work/before-paths" || return 1
  LC_ALL=C comm -13 "$work/before-paths" "$work/after-paths" > "$work/created" || return 1
  while IFS= read -r path; do
    printf '%s\n' "$path"
    while [ "${path#*/}" != "$path" ]; do
      path="${path%/*}"
      printf '%s\n' "$path"
    done
  done < "$work/created" | LC_ALL=C sort -u > "$work/kept"
}

# Takes out one restored entry: a link or file with `rm`, a folder with `rmdir`, so a folder holding
# anything stays. A path whose parent became a link is left to the link's own removal.
remove_entry() {
  local entry_path="$absolute/$1"
  reachable "$1" || return 0
  if [ -L "$entry_path" ]; then
    rm -f -- "$entry_path" 2> /dev/null
  elif [ -d "$entry_path" ]; then
    rmdir -- "$entry_path" 2> /dev/null
  elif [ -e "$entry_path" ]; then
    rm -f -- "$entry_path" 2> /dev/null
  fi
  return 0
}

# Removes what the ledger names, less the walk's evidence, deepest first; then looks again and says
# so once for each outermost entry that is still there.
remove_restored() {
  local path roots=""
  residual_count=0
  [ -n "$ledger" ] && [ -s "$ledger" ] || return 0
  LC_ALL=C sort -u "$ledger" > "$work/owned"
  : > "$work/kept"
  if [ "$walk_started" -eq 1 ] && ! keep_walk_evidence; then
    # No inventory of the walk's writes: removing anything could delete evidence, so nothing is.
    cp "$work/owned" "$work/doomed"
  else
    LC_ALL=C comm -23 "$work/owned" "$work/kept" > "$work/doomed"
    LC_ALL=C sort -r "$work/doomed" | while IFS= read -r path; do
      remove_entry "$path"
    done
  fi

  : > "$work/left"
  while IFS= read -r path; do
    reachable "$path" || continue
    if [ -e "$absolute/$path" ] || [ -L "$absolute/$path" ]; then
      printf '%s\n' "$path" >> "$work/left"
    fi
  done < "$work/doomed"
  while IFS= read -r path; do
    if ! is_under_listed "$path" "$roots"; then
      roots="$roots$path"$'\n'
      echo "$NAME: restored entry not removed: $path" >&2
      residual_count=$((residual_count + 1))
    fi
  done < "$work/left"
}

# The one exit. It runs once, on every way the script ends after the arguments are checked. It
# preserves a failing outcome, can turn a candidate success into a failure, and never the reverse:
# stdout is printed here, after the removal, so `unchanged` is never printed over a tree left dirty.
finish() {
  local incoming=$? status
  trap - EXIT
  teardown=1
  set +e
  status="$incoming"
  stop_child
  remove_restored
  if [ "$incoming" -eq 0 ] && [ -z "$signal_status" ] && [ "$compared" -eq 1 ]; then
    if [ -n "$changed" ]; then
      printf '%s\n' "$changed"
      status=1
    elif [ "$residual_count" -eq 0 ]; then
      echo "unchanged"
    fi
  fi
  [ "$status" -ne 0 ] || [ -z "$signal_status" ] || status="$signal_status"
  [ "$status" -ne 0 ] || [ "$residual_count" -eq 0 ] || status=1
  if [ -n "$work" ] && [ -d "$work" ]; then
    chmod -R u+w "$work" 2> /dev/null
    rm -rf "$work"
  fi
  exit "$status"
}

# The guard is in place before the first fixture write: the finalizer, then the signals.
trap finish EXIT
for signal_name in $(actionable_signals); do
  trap "on_signal $signal_name" "$signal_name" 2> /dev/null || true
done

work="$(mktemp -d)" || {
  echo "$NAME: could not make a scratch folder" >&2
  exit 1
}
ledger="$work/ledger"
: > "$ledger"

restore || exit 1

manifest "$absolute" > "$work/before"

# The driver's stdout is read for the call count; its and cargo's stderr passes through to ours.
walk_driver() {
  cd "$ROOT" && cargo test --locked --quiet -p ka-reader-core --test walk -- "$absolute"
}

walk_started=1
walked=0
if run_child walk_driver > "$work/walk-output"; then
  calls="$(tail -n 1 "$work/walk-output")"
  case "$calls" in
    '' | *[!0-9]*) ;;
    *) [ "$calls" -ge 1 ] && walked=1 ;;
  esac
fi
if [ "$walked" -ne 1 ]; then
  echo "$NAME: walk did not complete: $absolute" >&2
  exit 1
fi

manifest "$absolute" > "$work/after"

changed="$(differing_paths "$work/before" "$work/after")"
compared=1
exit 0
