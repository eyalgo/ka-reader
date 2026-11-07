#!/usr/bin/env bash
# Version: 1.3.0 — adds the case that the walk's folder pass applies the image judge beside the
#   bridge-operations judge, and that the walk decides a Markdown file by matching FileView::Markdown
#   and never by a file extension; every existing case is unchanged
# Version: 1.2.0 — adds the cases of the open file's model calls: the walk's folder mode reaches
#   read_file, open_read, Position, the Invalidate that covers the open file and reread_open_file, and
#   its judge names each; the existing judge cases still pass
# Version: 1.1.0 — adds the cases that fail when the script leaves a restored entry behind; the
#   restore case asserts `.git` is gone after the return instead of present
# Version: 1.0.0 — first version: drives the real checks/read-only.sh against the committed fixtures
#
# checks/tests/test_read_only.sh — the tests of checks/read-only.sh.
#
# WHY THIS EXISTS
#   checks/read-only.sh is the proof that reading a folder changes nothing, so a bug in it is a
#   proof nobody is checking. These cases run the real script — never a copy of its logic. Two run
#   it with the real `cargo` and the real driver on the committed fixtures. The rest put a stub
#   `cargo` on PATH that does one specific thing to a TEMPORARY COPY of a fixture (never a committed
#   one), so each kind of change the script must report has a case that makes exactly that change.
#   Some copies sit beside an unmodified archive, so the script has a `.git` to restore, and some
#   put a stand-in for another tool (tar, cp, rm, rmdir, shasum, mktemp) on PATH to make one step
#   fail.
#
# USAGE
#   checks/tests/test_read_only.sh
#   A missing prerequisite (cargo, git, tar, shasum) FAILS the suite with a stated message and runs
#   no case: a skip would let CI conclude green having proved nothing.
#
# WHY NO `set -e`
#   A case that fails must not end the run before the remaining cases report. Each case returns its
#   own status and the runner counts them.

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
READ_ONLY_SH="$ROOT/checks/read-only.sh"
FIXTURES="checks/fixtures"

OUT=""
ERR=""
STATUS=0
WORK=""

CASES="
test_clean_plain_is_unchanged
test_clean_repo_is_unchanged
test_restore_extracts_git_before_baseline
test_created_file_is_reported
test_modified_file_is_reported
test_removed_file_is_reported
test_retargeted_link_is_reported
test_rekinded_entry_is_reported
test_several_changes_are_each_reported_once
test_write_inside_git_is_reported
test_touch_only_is_unchanged
test_failed_walk_is_not_unchanged
test_zero_call_walk_is_not_unchanged
test_missing_fixture_names_argument
test_file_as_fixture_names_argument
test_no_argument_is_a_usage_error
test_extra_argument_is_a_usage_error
test_ordinary_restore_leaves_no_entry_behind
test_implied_and_nested_restores_leave_no_entry_behind
test_existing_git_disables_restore_and_removal
test_existing_start_entries_survive_with_kind_and_content
test_existing_folder_takes_restored_entries_and_keeps_its_own
test_walk_created_file_stays
test_walk_created_lock_stays_with_only_its_needed_ancestors
test_rewritten_restored_file_is_reported_then_removed
test_restored_leaf_replaced_by_link_or_folder
test_restored_folder_replaced_by_link_is_not_followed
test_failed_walk_with_restore_leaves_no_entry_behind
test_truncated_archive_fails_clean
test_failed_materialization_removes_what_it_laid_down
test_failed_baseline_manifest_cleans_up
test_failed_final_manifest_keeps_walk_evidence
test_scratch_failure_before_restore_touches_nothing
test_archive_absent_plain_restores_nothing
test_signal_during_restore_walk_and_teardown_cleans_up
test_failed_removal_names_the_outermost_entry
test_two_residual_roots_get_one_line_each
test_failed_removal_keeps_the_differing_paths_and_a_failed_walk
test_kill_prints_unchanged_when_the_walk_is_killed_after_its_marker
test_kill_is_never_unchanged_when_the_walk_exits_on_its_own
test_kill_is_never_unchanged_when_the_walk_prints_no_marker
test_kill_is_never_unchanged_when_the_hash_differs
test_the_folder_mode_reaches_the_open_files_model_calls
test_the_folder_pass_applies_the_image_judge_and_the_walk_decides_markdown_by_the_answer
test_the_existing_judge_cases_stay
"

# --- helpers ---

fail() {
  echo "  $*"
  return 1
}

# Runs the script from the product root with the arguments given. OUT is its stdout alone, ERR its
# stderr alone, so a case can say which stream a thing appeared on.
run_read_only() {
  OUT="$(cd "$ROOT" && "$READ_ONLY_SH" "$@" 2> "$WORK/stderr")"
  STATUS=$?
  ERR="$(cat "$WORK/stderr")"
}

# Same, with the stub directory $1 ahead of the real tools on PATH.
run_read_only_with_stubs() {
  stubs="$1"
  shift
  OUT="$(cd "$ROOT" && PATH="$stubs:$PATH" "$READ_ONLY_SH" "$@" 2> "$WORK/stderr")"
  STATUS=$?
  ERR="$(cat "$WORK/stderr")"
}

# A `cargo` stub whose body is $2. In the body, "$last" is the walk's final argument — the fixture's
# absolute path, which is what the real driver is handed.
make_cargo_stub() {
  mkdir -p "$1"
  printf '#!/bin/sh\nfor last; do :; done\n%s\n' "$2" > "$1/cargo"
  chmod +x "$1/cargo"
}

# A temporary copy of committed fixture $1 (plain or repo) at $WORK/<case>/<fixture>. cp -R keeps
# links as links. Prints the copy's path.
fixture_copy() {
  mkdir -p "$WORK/$2"
  cp -R "$ROOT/$FIXTURES/$1" "$WORK/$2/$1"
  rm -rf "$WORK/$2/$1/.git"
  printf '%s' "$WORK/$2/$1"
}

# A copy of committed fixture $1 with its archive beside it and no `.git`, so the script has
# something to restore. Same layout as fixture_copy, plus the unmodified archive. Prints the path.
archive_backed_copy() {
  copy="$(fixture_copy "$1" "$2")"
  cp "$ROOT/$FIXTURES/$1.git.tar" "$WORK/$2/$1.git.tar"
  printf '%s' "$copy"
}

# One line per entry under $1 — relative path, kind, and the bytes (or a link's target) — read with
# `cksum` and `readlink`, not with the script's own manifest, so a case compares scenes with a
# yardstick the script under test does not supply. Links are never followed.
scene_of() {
  (
    cd "$1" || exit 1
    find . -mindepth 1 | LC_ALL=C sort | while IFS= read -r entry; do
      if [ -L "$entry" ]; then
        printf '%s link %s\n' "$entry" "$(readlink "$entry")"
      elif [ -d "$entry" ]; then
        printf '%s dir\n' "$entry"
      elif [ -f "$entry" ]; then
        printf '%s file %s\n' "$entry" "$(cksum < "$entry")"
      else
        printf '%s other\n' "$entry"
      fi
    done
  )
}

expect_status() {
  [ "$STATUS" -eq "$1" ] || fail "expected exit $1, got $STATUS. stdout: $OUT stderr: $ERR"
}

expect_nonzero_status() {
  [ "$STATUS" -ne 0 ] || fail "expected a non-zero exit, got 0. stdout: $OUT"
}

expect_stdout_is() {
  [ "$OUT" = "$1" ] || fail "expected stdout exactly [$1], got [$OUT]. stderr: $ERR"
}

expect_stdout_lacks_unchanged() {
  case "$OUT" in
    *unchanged*) fail "stdout says unchanged: $OUT" ;;
  esac
}

expect_stderr_contains() {
  case "$ERR" in
    *"$1"*) return 0 ;;
  esac
  fail "expected stderr to contain: $1. stderr: $ERR"
}

# A stand-in for tool $2, in folder $1, whose body is $3. The real tool's path is in $REAL inside
# it, found before the folder is on PATH, so a body can pass the call through with `exec "$REAL"
# "$@"`.
make_tool_shim() {
  mkdir -p "$1"
  printf "#!/bin/sh\nREAL='%s'\n%s\n" "$(command -v "$2")" "$3" > "$1/$2"
  chmod +x "$1/$2"
}

# The lines present only in scene $2 and not in scene $1, in `scene_of` form.
only_in_second() {
  printf '%s\n' "$1" | LC_ALL=C sort > "$WORK/scene-first"
  printf '%s\n' "$2" | LC_ALL=C sort > "$WORK/scene-second"
  comm -13 "$WORK/scene-first" "$WORK/scene-second"
}

# The `scene_of` line of a new empty file at relative path $1.
empty_file_line() {
  printf '%s file %s' "$1" "$(cksum < /dev/null)"
}

# Folder $2 holds exactly the scene $1 recorded earlier: nothing added, nothing lost, nothing
# changed.
expect_scene_is() {
  after="$(scene_of "$2")"
  [ "$after" = "$1" ] && return 0
  fail "the scene changed. Only now: [$(only_in_second "$1" "$after" | head -6)] Only before: [$(only_in_second "$after" "$1" | head -6)]"
}

# Folder $2 holds scene $1 plus exactly the lines in $3 (one per line, `scene_of` form), and has
# lost nothing from $1.
expect_scene_plus() {
  after="$(scene_of "$2")"
  added="$(only_in_second "$1" "$after")"
  lost="$(only_in_second "$after" "$1")"
  expected="$(printf '%s\n' "$3" | LC_ALL=C sort)"
  [ -z "$lost" ] || fail "the run lost start entries: [$lost]" || return 1
  [ "$added" = "$expected" ] || fail "expected exactly [$expected] to be added, got [$added]"
}

# Counts the lines of $2 that contain $1.
count_lines_with() {
  printf '%s\n' "$2" | grep -cF -- "$1" || true
}

REMOVAL_LINE="read-only.sh: restored entry not removed:"

# A shim pair that makes `.git/objects` impossible to remove: `rmdir` refuses that one folder. No
# hashed data changes, because nothing under it is touched.
make_objects_unremovable() {
  make_tool_shim "$1" rmdir 'for last; do :; done
case "$last" in */.git/objects) exit 1 ;; esac
exec "$REAL" "$@"'
}

# The signals a script run in this shell can act on and is expected to end on: every one the shell
# lists, less the ones no process can catch (KILL, STOP) and the ones whose default is to stop, to
# continue, or to be ignored (TSTP, TTIN, TTOU, CONT, CHLD, URG, WINCH, INFO, IO).
actionable_signals() {
  for sig in HUP INT QUIT ILL TRAP ABRT EMT FPE BUS SEGV SYS PIPE ALRM TERM XCPU XFSZ VTALRM PROF USR1 USR2; do
    kill -l "$sig" > /dev/null 2>&1 && printf '%s\n' "$sig"
  done
}

# Starts the script on fixture $2 with the stub folder $1 on PATH, in its own process group (job
# control on): a background job without it inherits INT and QUIT ignored, and a script cannot act on
# a signal it started ignoring. Sets SCRIPT_PID. stdout and stderr go to files.
start_script() {
  set -m
  PATH="$1:$PATH" "$READ_ONLY_SH" "$2" > "$WORK/sig-out" 2> "$WORK/sig-err" &
  SCRIPT_PID=$!
  set +m
}

# Waits up to twenty seconds for file $1 to exist.
wait_for_file() {
  waited=0
  while [ ! -e "$1" ] && [ "$waited" -lt 200 ]; do
    sleep 0.1
    waited=$((waited + 1))
  done
  [ -e "$1" ]
}

# Waits up to twenty seconds for the script to end; sets STATUS, OUT and ERR. A script still running
# at the end of the wait is killed and the wait fails.
wait_for_script() {
  waited=0
  while kill -0 "$SCRIPT_PID" 2> /dev/null && [ "$waited" -lt 200 ]; do
    sleep 0.1
    waited=$((waited + 1))
  done
  if kill -0 "$SCRIPT_PID" 2> /dev/null; then
    kill -9 "$SCRIPT_PID" 2> /dev/null
    wait "$SCRIPT_PID" 2> /dev/null
    return 1
  fi
  wait "$SCRIPT_PID"
  STATUS=$?
  OUT="$(cat "$WORK/sig-out")"
  ERR="$(cat "$WORK/sig-err")"
}

# The scene a run ended by a signal must leave in $WORK/$id: the start, plus the lock the walk made
# when the signal landed in the walk.
expect_signalled_scene() {
  if [ "$boundary" = walk ]; then
    expect_scene_plus "$before" "$WORK/$id" "$(printf '%s\n%s' "./repo/.git dir" "$(empty_file_line ./repo/.git/index.lock)")" \
      || { fail "$boundary/$sig: the scene is not the start plus the walk's lock"; return 1; }
  else
    expect_scene_is "$before" "$WORK/$id" || { fail "$boundary/$sig: a restored entry survived"; return 1; }
  fi
}

# One run ended by signal $2 at boundary $1 (restore, walk, teardown or scratch), on an
# archive-backed `repo` copy. The boundary is held open by a stub that writes a ready marker, so the
# signal always lands there. `teardown` holds the first removal in the fixture; `scratch` holds the
# removal of the script's own scratch folder, after the fixture is clean and before the run has
# ended. Prints nothing and returns 0 when every claim holds.
run_signal_scene() {
  boundary="$1"
  sig="$2"
  id="sig-$boundary-$sig"
  copy="$(archive_backed_copy repo "$id")"
  before="$(scene_of "$WORK/$id")"
  ready="$WORK/$id.ready"
  go="$WORK/$id.go"
  stubs="$WORK/stubs-$id"
  make_cargo_stub "$stubs" 'echo 1'
  case "$boundary" in
    restore)
      make_tool_shim "$stubs" tar "touch \"$ready\"; sleep 30; exec \"\$REAL\" \"\$@\""
      ;;
    walk)
      make_cargo_stub "$stubs" "touch \"\$last/.git/index.lock\"; touch \"$ready\"; sleep 3
touch \"\$last/.git/late-write\"; echo 1"
      ;;
    teardown)
      make_tool_shim "$stubs" rm "if [ ! -e \"$ready\" ]; then touch \"$ready\"; waited=0
while [ ! -e \"$go\" ] && [ \$waited -lt 200 ]; do sleep 0.1; waited=\$((waited + 1)); done; fi
exec \"\$REAL\" \"\$@\""
      ;;
    scratch)
      make_tool_shim "$stubs" rm "if [ \"\$1\" = -rf ] && [ ! -e \"$ready\" ]; then touch \"$ready\"; waited=0
while [ ! -e \"$go\" ] && [ \$waited -lt 200 ]; do sleep 0.1; waited=\$((waited + 1)); done; fi
exec \"\$REAL\" \"\$@\""
      ;;
  esac

  start_script "$stubs" "$copy"
  if ! wait_for_file "$ready"; then
    kill -9 "$SCRIPT_PID" 2> /dev/null
    fail "$boundary/$sig: the run never reached the $boundary boundary"
    return 1
  fi
  kill -s "$sig" "$SCRIPT_PID"
  case "$boundary" in
    teardown)
      sleep 0.2
      kill -s "$sig" "$SCRIPT_PID" 2> /dev/null
      : > "$go"
      sleep 0.2
      kill -s "$sig" "$SCRIPT_PID" 2> /dev/null
      ;;
    scratch)
      sleep 0.2
      : > "$go"
      ;;
  esac
  wait_for_script || { fail "$boundary/$sig: the run did not end within the watchdog"; return 1; }

  [ "$STATUS" -ne 0 ] || { fail "$boundary/$sig: exit 0 after the signal. stdout: $OUT"; return 1; }
  case "$OUT" in
    *unchanged*) fail "$boundary/$sig: stdout says unchanged: $OUT"; return 1 ;;
  esac
  expect_signalled_scene || return 1
  if [ "$sig" = TERM ]; then
    # A child the run left running would write after the run ended: wait for it, and look again.
    sleep 4
    expect_signalled_scene || return 1
  fi
}

# --- cases ---

test_clean_plain_is_unchanged() {
  run_read_only "$FIXTURES/plain"

  expect_status 0 || return 1
  expect_stdout_is "unchanged"
}

test_clean_repo_is_unchanged() {
  run_read_only "$FIXTURES/repo"

  expect_status 0 || return 1
  expect_stdout_is "unchanged"
}

# The stand-in `cargo` records, in a marker outside the fixture, that `.git/HEAD` was in the fixture
# while the walk ran. CP-833 removes the restored `.git` once the verdict is taken, so the case no
# longer looks for it after the return: it asserts that `.git` is gone (CP-844).
test_restore_extracts_git_before_baseline() {
  mkdir -p "$WORK/restore"
  cp -R "$ROOT/$FIXTURES/repo" "$WORK/restore/repo"
  rm -rf "$WORK/restore/repo/.git"
  cp "$ROOT/$FIXTURES/repo.git.tar" "$WORK/restore/repo.git.tar"
  make_cargo_stub "$WORK/stubs-restore" \
    "if [ -f \"\$last/.git/HEAD\" ]; then touch \"$WORK/restore-head-seen\"; fi; echo 1"

  run_read_only_with_stubs "$WORK/stubs-restore" "$WORK/restore/repo"

  expect_status 0 || return 1
  expect_stdout_is "unchanged" || return 1
  [ -f "$WORK/restore-head-seen" ] || fail "the archive was not extracted before the walk: no .git/HEAD" || return 1
  [ ! -e "$WORK/restore/repo/.git" ] || fail "the restored .git is still in the copy after the return"
}

test_created_file_is_reported() {
  copy="$(fixture_copy plain created)"
  make_cargo_stub "$WORK/stubs-created" 'touch "$last/.DS_Store"; echo 1'

  run_read_only_with_stubs "$WORK/stubs-created" "$copy"

  expect_nonzero_status || return 1
  expect_stdout_is ".DS_Store"
}

test_modified_file_is_reported() {
  copy="$(fixture_copy plain modified)"
  make_cargo_stub "$WORK/stubs-modified" 'printf "rewritten\n" > "$last/readme.txt"; echo 1'

  run_read_only_with_stubs "$WORK/stubs-modified" "$copy"

  expect_nonzero_status || return 1
  expect_stdout_is "readme.txt"
}

test_removed_file_is_reported() {
  copy="$(fixture_copy plain removed)"
  make_cargo_stub "$WORK/stubs-removed" 'rm "$last/readme.txt"; echo 1'

  run_read_only_with_stubs "$WORK/stubs-removed" "$copy"

  expect_nonzero_status || return 1
  expect_stdout_is "readme.txt"
}

test_retargeted_link_is_reported() {
  copy="$(fixture_copy plain retargeted)"
  make_cargo_stub "$WORK/stubs-retargeted" 'rm "$last/outside-link"; ln -s /tmp "$last/outside-link"; echo 1'

  run_read_only_with_stubs "$WORK/stubs-retargeted" "$copy"

  expect_nonzero_status || return 1
  expect_stdout_is "outside-link"
}

test_rekinded_entry_is_reported() {
  copy="$(fixture_copy plain rekinded)"
  make_cargo_stub "$WORK/stubs-rekinded" 'rm "$last/readme.txt"; mkdir "$last/readme.txt"; echo 1'

  run_read_only_with_stubs "$WORK/stubs-rekinded" "$copy"

  expect_nonzero_status || return 1
  expect_stdout_is "readme.txt"
}

# Added by development-code-integrity. CP-35: "it prints each differing path, one per line and
# relative to the fixture". Two changes, one of them nested, give two lines, each once.
test_several_changes_are_each_reported_once() {
  copy="$(fixture_copy plain several)"
  make_cargo_stub "$WORK/stubs-several" 'touch "$last/.DS_Store"; printf "rewritten\n" > "$last/docs/guides/intro.txt"; echo 1'

  run_read_only_with_stubs "$WORK/stubs-several" "$copy"

  expect_nonzero_status || return 1
  sorted="$(printf '%s\n' "$OUT" | LC_ALL=C sort)"
  expected="$(printf '%s\n%s' ".DS_Store" "docs/guides/intro.txt")"
  [ "$sorted" = "$expected" ] || fail "expected exactly the two paths once each, got [$OUT]"
}

# Added by development-code-integrity. CP-35: the script "hashes the fixture, including `.git`
# where it has one", so a write inside `repo`'s `.git` is a write like any other.
test_write_inside_git_is_reported() {
  mkdir -p "$WORK/gitwrite"
  cp -R "$ROOT/$FIXTURES/repo" "$WORK/gitwrite/repo"
  rm -rf "$WORK/gitwrite/repo/.git"
  cp "$ROOT/$FIXTURES/repo.git.tar" "$WORK/gitwrite/repo.git.tar"
  make_cargo_stub "$WORK/stubs-gitwrite" 'touch "$last/.git/index.lock"; echo 1'

  run_read_only_with_stubs "$WORK/stubs-gitwrite" "$WORK/gitwrite/repo"

  expect_nonzero_status || return 1
  expect_stdout_is ".git/index.lock"
}

test_touch_only_is_unchanged() {
  copy="$(fixture_copy plain touched)"
  make_cargo_stub "$WORK/stubs-touched" 'touch "$last/readme.txt"; echo 1'

  run_read_only_with_stubs "$WORK/stubs-touched" "$copy"

  expect_status 0 || return 1
  expect_stdout_is "unchanged"
}

test_failed_walk_is_not_unchanged() {
  copy="$(fixture_copy plain failedwalk)"
  make_cargo_stub "$WORK/stubs-failedwalk" 'exit 1'

  run_read_only_with_stubs "$WORK/stubs-failedwalk" "$copy"

  expect_nonzero_status || return 1
  expect_stdout_lacks_unchanged || return 1
  expect_stderr_contains "walk did not complete"
}

test_zero_call_walk_is_not_unchanged() {
  copy="$(fixture_copy plain zerowalk)"
  make_cargo_stub "$WORK/stubs-zerowalk" 'echo 0'

  run_read_only_with_stubs "$WORK/stubs-zerowalk" "$copy"

  expect_nonzero_status || return 1
  expect_stdout_lacks_unchanged || return 1
  expect_stderr_contains "walk did not complete"
}

test_missing_fixture_names_argument() {
  run_read_only "$FIXTURES/nope"

  expect_nonzero_status || return 1
  expect_stdout_lacks_unchanged || return 1
  expect_stderr_contains "$FIXTURES/nope"
}

test_file_as_fixture_names_argument() {
  run_read_only "$FIXTURES/repo.git.tar"

  expect_nonzero_status || return 1
  expect_stdout_lacks_unchanged || return 1
  expect_stderr_contains "$FIXTURES/repo.git.tar" || return 1

  # The same refusal on a temporary copy of the archive: nothing is restored or removed beside it.
  mkdir -p "$WORK/fileasfixture"
  cp "$ROOT/$FIXTURES/repo.git.tar" "$WORK/fileasfixture/repo.git.tar"
  before="$(scene_of "$WORK/fileasfixture")"

  run_read_only "$WORK/fileasfixture/repo.git.tar"

  expect_nonzero_status || return 1
  [ "$(scene_of "$WORK/fileasfixture")" = "$before" ] || fail "the refusal restored or removed an entry"
}

# CP-836: a run that ends before any restore restores nothing and removes nothing. No argument is
# that run: the usage line goes to stderr, stdout stays empty, the exit is 2.
test_no_argument_is_a_usage_error() {
  run_read_only

  expect_status 2 || return 1
  expect_stdout_is "" || return 1
  expect_stderr_contains "usage"
}

# Two fixture arguments are refused before the first restore: the first one, a temporary copy with
# its archive beside it, is left exactly as it was given.
test_extra_argument_is_a_usage_error() {
  copy="$(archive_backed_copy repo extraarg)"
  before="$(scene_of "$WORK/extraarg")"

  run_read_only "$copy" "$copy"

  expect_status 2 || return 1
  expect_stdout_is "" || return 1
  expect_stderr_contains "usage" || return 1
  [ ! -e "$copy/.git" ] || fail "the refusal restored .git" || return 1
  [ "$(scene_of "$WORK/extraarg")" = "$before" ] || fail "the refusal changed the copy or its archive"
}

# --- cases: the script leaves no restored entry behind (CP-833 to CP-838, CP-842) ---

# CP-842, two kinds of fixture: `repo`, whose archive lays down only `.git`, and
# `submodule-config-names-outside`, whose archive also lays down `.gitmodules` and `submodule/`. The
# whole scene after the run must equal the scene before it, so a leftover outside `.git` is seen.
test_ordinary_restore_leaves_no_entry_behind() {
  for fixture in repo submodule-config-names-outside; do
    copy="$(archive_backed_copy "$fixture" "ordinary-$fixture")"
    before="$(scene_of "$WORK/ordinary-$fixture")"
    make_cargo_stub "$WORK/stubs-ordinary-$fixture" 'echo 1'

    run_read_only_with_stubs "$WORK/stubs-ordinary-$fixture" "$copy"

    expect_status 0 || return 1
    expect_stdout_is "unchanged" || return 1
    expect_scene_is "$before" "$WORK/ordinary-$fixture" || return 1
  done
}

# CP-833, CP-834: the archive lays down folders it never names (`parent-of-two/`) and has no
# top-level `.git` at all (`linked-worktree`). Neither a restored parent nor a nested repository
# stays; the committed folders do.
test_implied_and_nested_restores_leave_no_entry_behind() {
  for fixture in parent-of-two linked-worktree; do
    copy="$(archive_backed_copy "$fixture" "implied-$fixture")"
    before="$(scene_of "$WORK/implied-$fixture")"
    make_cargo_stub "$WORK/stubs-implied-$fixture" 'echo 1'

    run_read_only_with_stubs "$WORK/stubs-implied-$fixture" "$copy"

    expect_status 0 || return 1
    expect_stdout_is "unchanged" || return 1
    expect_scene_is "$before" "$WORK/implied-$fixture" || return 1
  done
  [ -f "$WORK/implied-parent-of-two/parent-of-two/alpha/README.md" ] \
    || fail "alpha/README.md is gone from parent-of-two" || return 1
  [ -f "$WORK/implied-parent-of-two/parent-of-two/beta/README.md" ] \
    || fail "beta/README.md is gone from parent-of-two"
}

# CP-834: a `.git` of any kind at start disables restore and removal, a dangling link included.
# "Nothing restored" is looked at while the walk runs, not only after the return: a script that
# laid entries into the existing `.git` and took them out again would leave the same scene behind.
test_existing_git_disables_restore_and_removal() {
  for kind in folder file link; do
    copy="$(archive_backed_copy repo "existing-$kind")"
    case "$kind" in
      folder) mkdir "$copy/.git" && printf 'mine\n' > "$copy/.git/own-file" ;;
      file) printf 'gitdir: elsewhere\n' > "$copy/.git" ;;
      link) ln -s "$WORK/nowhere-at-all" "$copy/.git" ;;
    esac
    before="$(scene_of "$WORK/existing-$kind")"
    listing_before="$(cd "$copy" && find . -mindepth 1 | LC_ALL=C sort)"
    make_cargo_stub "$WORK/stubs-existing-$kind" \
      "(cd \"\$last\" && find . -mindepth 1 | LC_ALL=C sort) > \"$WORK/existing-$kind-during-walk\"; echo 1"

    run_read_only_with_stubs "$WORK/stubs-existing-$kind" "$copy"

    expect_status 0 || return 1
    expect_stdout_is "unchanged" || return 1
    [ "$(cat "$WORK/existing-$kind-during-walk")" = "$listing_before" ] \
      || fail "$kind: the walk saw entries the start did not hold: something was restored" || return 1
    expect_scene_is "$before" "$WORK/existing-$kind" || return 1
  done
}

# CP-834: entries present at start keep their kind and content. A `submodule` copy holds a planted
# `.gitmodules`, nested files, an empty folder and a link; the archive's `.git` and `submodule/` go.
# A second copy holds a link where the archive wants the folder `submodule/`: it is neither followed
# nor overwritten, and what it points at is untouched. Both are looked at while the walk runs too:
# an entry overwritten by the restore and put back afterwards was not left as found.
test_existing_start_entries_survive_with_kind_and_content() {
  copy="$(archive_backed_copy submodule start-entries)"
  printf 'planted\n' > "$copy/.gitmodules"
  mkdir -p "$copy/nested/deep" "$copy/empty-folder"
  printf 'kept\n' > "$copy/nested/deep/file.txt"
  ln -s README.md "$copy/link-to-readme"
  before="$(scene_of "$WORK/start-entries")"
  make_cargo_stub "$WORK/stubs-start-entries" \
    "cat \"\$last/.gitmodules\" > \"$WORK/start-entries-during-walk\"; echo 1"

  run_read_only_with_stubs "$WORK/stubs-start-entries" "$copy"

  expect_status 0 || return 1
  expect_stdout_is "unchanged" || return 1
  [ "$(cat "$WORK/start-entries-during-walk")" = "planted" ] \
    || fail ".gitmodules did not hold its planted content while the walk ran" || return 1
  expect_scene_is "$before" "$WORK/start-entries" || return 1
  [ "$(cat "$copy/.gitmodules")" = "planted" ] || fail ".gitmodules lost its planted content" || return 1
  [ ! -e "$copy/.git" ] || fail "the restored .git is still there" || return 1

  copy="$(archive_backed_copy submodule start-link)"
  mkdir -p "$WORK/start-link-target"
  printf 'outside\n' > "$WORK/start-link-target/outside.txt"
  ln -s "$WORK/start-link-target" "$copy/submodule"
  before="$(scene_of "$WORK/start-link")"
  target_before="$(scene_of "$WORK/start-link-target")"
  make_cargo_stub "$WORK/stubs-start-link" \
    "if [ -L \"\$last/submodule\" ]; then touch \"$WORK/start-link-during-walk\"; fi; echo 1"

  run_read_only_with_stubs "$WORK/stubs-start-link" "$copy"

  expect_status 0 || return 1
  expect_stdout_is "unchanged" || return 1
  [ -e "$WORK/start-link-during-walk" ] || fail "the link at submodule was not a link while the walk ran" || return 1
  expect_scene_is "$before" "$WORK/start-link" || return 1
  [ -L "$copy/submodule" ] || fail "the link at submodule was replaced" || return 1
  [ "$(scene_of "$WORK/start-link-target")" = "$target_before" ] \
    || fail "the link's target was written through"
}

# CP-834, CP-833: a real folder at start where the archive also has a folder is kept, and so is what
# it holds; the restore lays the archive's missing entries inside it for the walk, and takes them
# out again. Nothing else in the suite has a start folder at an archive folder's place.
test_existing_folder_takes_restored_entries_and_keeps_its_own() {
  copy="$(archive_backed_copy submodule startfolder)"
  mkdir "$copy/submodule"
  printf 'mine\n' > "$copy/submodule/mine.txt"
  before="$(scene_of "$WORK/startfolder")"
  make_cargo_stub "$WORK/stubs-startfolder" \
    "if [ -f \"\$last/submodule/.git\" ]; then touch \"$WORK/startfolder-during-walk\"; fi; echo 1"

  run_read_only_with_stubs "$WORK/stubs-startfolder" "$copy"

  expect_status 0 || return 1
  expect_stdout_is "unchanged" || return 1
  [ -e "$WORK/startfolder-during-walk" ] \
    || fail "submodule/.git was not restored inside the existing folder before the walk" || return 1
  expect_scene_is "$before" "$WORK/startfolder"
}

# CP-835: what the walk created stays where it is.
test_walk_created_file_stays() {
  copy="$(fixture_copy plain staysfile)"
  make_cargo_stub "$WORK/stubs-staysfile" 'touch "$last/.DS_Store"; echo 1'

  run_read_only_with_stubs "$WORK/stubs-staysfile" "$copy"

  expect_nonzero_status || return 1
  expect_stdout_is ".DS_Store" || return 1
  [ -f "$copy/.DS_Store" ] || fail "the walk-created .DS_Store was removed"
}

# CP-835, CP-838: a lock the walk created in `.git` is evidence. It stays as the only child of the
# `.git` kept to hold it; a deeper new subtree keeps only the restored folders it needs.
test_walk_created_lock_stays_with_only_its_needed_ancestors() {
  copy="$(archive_backed_copy repo lockstays)"
  before="$(scene_of "$WORK/lockstays")"
  make_cargo_stub "$WORK/stubs-lockstays" 'touch "$last/.git/index.lock"; echo 1'

  run_read_only_with_stubs "$WORK/stubs-lockstays" "$copy"

  expect_nonzero_status || return 1
  expect_stdout_is ".git/index.lock" || return 1
  [ "$(count_lines_with "$REMOVAL_LINE" "$ERR")" -eq 0 ] || fail "a cleanup diagnostic was printed: $ERR" || return 1
  expect_scene_plus "$before" "$WORK/lockstays" \
    "$(printf '%s\n%s' "./repo/.git dir" "$(empty_file_line ./repo/.git/index.lock)")" || return 1

  copy="$(archive_backed_copy repo subtree)"
  before="$(scene_of "$WORK/subtree")"
  make_cargo_stub "$WORK/stubs-subtree" 'mkdir -p "$last/.git/logs/fresh/deeper"; touch "$last/.git/logs/fresh/deeper/x"; echo 1'

  run_read_only_with_stubs "$WORK/stubs-subtree" "$copy"

  expect_nonzero_status || return 1
  expected_out="$(printf '%s\n%s\n%s' ".git/logs/fresh" ".git/logs/fresh/deeper" ".git/logs/fresh/deeper/x")"
  expect_stdout_is "$expected_out" || return 1
  expect_scene_plus "$before" "$WORK/subtree" "$(printf '%s\n%s\n%s\n%s\n%s' \
    "./repo/.git dir" "./repo/.git/logs dir" "./repo/.git/logs/fresh dir" "./repo/.git/logs/fresh/deeper dir" \
    "$(empty_file_line ./repo/.git/logs/fresh/deeper/x)")" || return 1
}

# CP-835: a restored file the walk rewrote is still a restored entry. It is named on stdout, then it
# goes, and no `.git` is left.
test_rewritten_restored_file_is_reported_then_removed() {
  copy="$(archive_backed_copy repo rewritten)"
  before="$(scene_of "$WORK/rewritten")"
  make_cargo_stub "$WORK/stubs-rewritten" 'printf "ref: refs/heads/other\n" > "$last/.git/HEAD"; echo 1'

  run_read_only_with_stubs "$WORK/stubs-rewritten" "$copy"

  expect_nonzero_status || return 1
  expect_stdout_is ".git/HEAD" || return 1
  expect_scene_is "$before" "$WORK/rewritten"
}

# CP-835: a restored leaf the walk replaced by a link, and by a folder holding a new entry. The link
# goes without its target being touched; the folder stays only as far as the new entry needs it.
test_restored_leaf_replaced_by_link_or_folder() {
  copy="$(archive_backed_copy repo leaflink)"
  mkdir -p "$WORK/leaflink-target"
  printf 'outside\n' > "$WORK/leaflink-target/outside.txt"
  before="$(scene_of "$WORK/leaflink")"
  target_before="$(scene_of "$WORK/leaflink-target")"
  make_cargo_stub "$WORK/stubs-leaflink" 'rm "$last/.git/HEAD"; ln -s "'"$WORK"'/leaflink-target" "$last/.git/HEAD"; echo 1'

  run_read_only_with_stubs "$WORK/stubs-leaflink" "$copy"

  expect_nonzero_status || return 1
  expect_stdout_is ".git/HEAD" || return 1
  expect_scene_is "$before" "$WORK/leaflink" || return 1
  [ "$(scene_of "$WORK/leaflink-target")" = "$target_before" ] || fail "the link's target was touched" || return 1

  copy="$(archive_backed_copy repo leaffolder)"
  before="$(scene_of "$WORK/leaffolder")"
  make_cargo_stub "$WORK/stubs-leaffolder" 'rm "$last/.git/HEAD"; mkdir "$last/.git/HEAD"; touch "$last/.git/HEAD/new"; echo 1'

  run_read_only_with_stubs "$WORK/stubs-leaffolder" "$copy"

  expect_nonzero_status || return 1
  expect_stdout_is "$(printf '%s\n%s' ".git/HEAD" ".git/HEAD/new")" || return 1
  expect_scene_plus "$before" "$WORK/leaffolder" "$(printf '%s\n%s\n%s' \
    "./repo/.git dir" "./repo/.git/HEAD dir" "$(empty_file_line ./repo/.git/HEAD/new)")" || return 1
}

# CP-835, CP-834: a restored folder the walk moved outside and replaced with a link to it. The
# restored entries that were inside it now sit behind the link, under the same names; cleanup takes
# out the link and never goes through it, so the folder outside still holds every one of them.
test_restored_folder_replaced_by_link_is_not_followed() {
  copy="$(archive_backed_copy repo folderlink)"
  outside="$WORK/folderlink-outside"
  mkdir -p "$WORK/folderlink-reference"
  tar -xf "$ROOT/$FIXTURES/repo.git.tar" -C "$WORK/folderlink-reference"
  reference="$(scene_of "$WORK/folderlink-reference/.git/refs")"
  before="$(scene_of "$WORK/folderlink")"
  make_cargo_stub "$WORK/stubs-folderlink" \
    "mv \"\$last/.git/refs\" \"$outside\"; ln -s \"$outside\" \"\$last/.git/refs\"; echo 1"

  run_read_only_with_stubs "$WORK/stubs-folderlink" "$copy"

  expect_nonzero_status || return 1
  expect_stdout_is "$(printf '%s\n%s\n%s\n%s' \
    ".git/refs" ".git/refs/heads" ".git/refs/heads/main" ".git/refs/tags")" || return 1
  [ "$(count_lines_with "$REMOVAL_LINE" "$ERR")" -eq 0 ] || fail "a cleanup diagnostic was printed: $ERR" || return 1
  [ "$(scene_of "$outside")" = "$reference" ] || fail "cleanup went through the link: the folder outside lost entries" || return 1
  expect_scene_is "$before" "$WORK/folderlink"
}

# CP-836 (3): a walk that failed, or made no call, still takes out what the restore laid down, and a
# lock created before the failure stays with only the folder it needs.
test_failed_walk_with_restore_leaves_no_entry_behind() {
  for walk in 'exit 1' 'echo 0'; do
    copy="$(archive_backed_copy repo failedwalk)"
    before="$(scene_of "$WORK/failedwalk")"
    make_cargo_stub "$WORK/stubs-failedwalk-restore" "$walk"

    run_read_only_with_stubs "$WORK/stubs-failedwalk-restore" "$copy"

    expect_nonzero_status || return 1
    expect_stdout_lacks_unchanged || return 1
    [ "$ERR" = "read-only.sh: walk did not complete: $copy" ] || fail "unexpected stderr: [$ERR]" || return 1
    expect_scene_is "$before" "$WORK/failedwalk" || return 1
    rm -rf "$WORK/failedwalk"
  done

  copy="$(archive_backed_copy repo failedlock)"
  before="$(scene_of "$WORK/failedlock")"
  make_cargo_stub "$WORK/stubs-failedlock" 'touch "$last/.git/index.lock"; exit 1'

  run_read_only_with_stubs "$WORK/stubs-failedlock" "$copy"

  expect_nonzero_status || return 1
  expect_stdout_lacks_unchanged || return 1
  expect_scene_plus "$before" "$WORK/failedlock" \
    "$(printf '%s\n%s' "./repo/.git dir" "$(empty_file_line ./repo/.git/index.lock)")"
}

# CP-836 (4): an archive cut short fails the run, leaves the start scene, and the walk never runs.
test_truncated_archive_fails_clean() {
  copy="$(archive_backed_copy repo truncated)"
  head -c 700 "$ROOT/$FIXTURES/repo.git.tar" > "$WORK/truncated/repo.git.tar"
  before="$(scene_of "$WORK/truncated")"
  make_cargo_stub "$WORK/stubs-truncated" "touch \"$WORK/truncated-walked\"; echo 1"

  run_read_only_with_stubs "$WORK/stubs-truncated" "$copy"

  expect_nonzero_status || return 1
  expect_stdout_lacks_unchanged || return 1
  expect_scene_is "$before" "$WORK/truncated" || return 1
  [ ! -e "$WORK/truncated-walked" ] || fail "the walk ran after a failed restore"
}

# CP-836 (4): a copy into the fixture that fails after others succeeded leaves nothing it laid down.
test_failed_materialization_removes_what_it_laid_down() {
  copy="$(archive_backed_copy repo failedcopy)"
  before="$(scene_of "$WORK/failedcopy")"
  make_tool_shim "$WORK/stubs-failedcopy" cp "count=\$(cat \"$WORK/failedcopy-count\" 2> /dev/null || echo 0)
count=\$((count + 1))
echo \$count > \"$WORK/failedcopy-count\"
[ \$count -lt 3 ] || exit 1
exec \"\$REAL\" \"\$@\""
  make_cargo_stub "$WORK/stubs-failedcopy" "touch \"$WORK/failedcopy-walked\"; echo 1"

  run_read_only_with_stubs "$WORK/stubs-failedcopy" "$copy"

  expect_nonzero_status || return 1
  expect_stdout_lacks_unchanged || return 1
  [ "$(cat "$WORK/failedcopy-count")" -ge 3 ] || fail "no entry was laid down before the failure" || return 1
  expect_scene_is "$before" "$WORK/failedcopy" || return 1
  [ ! -e "$WORK/failedcopy-walked" ] || fail "the walk ran after a failed restore"
}

# CP-836 (5): the tool that hashes fails after the restore. The run fails and takes out what it laid
# down.
test_failed_baseline_manifest_cleans_up() {
  copy="$(archive_backed_copy repo failedbaseline)"
  before="$(scene_of "$WORK/failedbaseline")"
  make_tool_shim "$WORK/stubs-failedbaseline" shasum 'exit 1'
  make_cargo_stub "$WORK/stubs-failedbaseline" "touch \"$WORK/failedbaseline-walked\"; echo 1"

  run_read_only_with_stubs "$WORK/stubs-failedbaseline" "$copy"

  expect_nonzero_status || return 1
  expect_stdout_lacks_unchanged || return 1
  expect_scene_is "$before" "$WORK/failedbaseline" || return 1
  [ ! -e "$WORK/failedbaseline-walked" ] || fail "the walk ran with no baseline"
}

# CP-836 (5), CP-835: the hashing tool fails only after the walk. The run fails, the restore is
# taken out, and the lock the walk created is kept.
test_failed_final_manifest_keeps_walk_evidence() {
  copy="$(archive_backed_copy repo failedfinal)"
  before="$(scene_of "$WORK/failedfinal")"
  make_tool_shim "$WORK/stubs-failedfinal" shasum "[ ! -e \"$WORK/failedfinal-walked\" ] || exit 1
exec \"\$REAL\" \"\$@\""
  make_cargo_stub "$WORK/stubs-failedfinal" 'touch "$last/.git/index.lock"; touch "'"$WORK"'/failedfinal-walked"; echo 1'

  run_read_only_with_stubs "$WORK/stubs-failedfinal" "$copy"

  expect_nonzero_status || return 1
  expect_stdout_lacks_unchanged || return 1
  expect_scene_plus "$before" "$WORK/failedfinal" \
    "$(printf '%s\n%s' "./repo/.git dir" "$(empty_file_line ./repo/.git/index.lock)")"
}

# CP-836: a run whose scratch folder cannot be made has restored nothing yet, and touches nothing.
test_scratch_failure_before_restore_touches_nothing() {
  copy="$(archive_backed_copy repo noscratch)"
  before="$(scene_of "$WORK/noscratch")"
  make_tool_shim "$WORK/stubs-noscratch" mktemp 'exit 1'
  make_cargo_stub "$WORK/stubs-noscratch" "touch \"$WORK/noscratch-walked\"; echo 1"

  run_read_only_with_stubs "$WORK/stubs-noscratch" "$copy"

  expect_nonzero_status || return 1
  expect_stdout_lacks_unchanged || return 1
  expect_scene_is "$before" "$WORK/noscratch" || return 1
  [ ! -e "$WORK/noscratch-walked" ] || fail "the walk ran without a scratch folder"
}

# CP-834: a fixture with no archive beside it has nothing to restore, so nothing is added or
# removed.
test_archive_absent_plain_restores_nothing() {
  copy="$(fixture_copy plain noarchive)"
  before="$(scene_of "$WORK/noarchive")"
  make_cargo_stub "$WORK/stubs-noarchive" 'echo 1'

  run_read_only_with_stubs "$WORK/stubs-noarchive" "$copy"

  expect_status 0 || return 1
  expect_stdout_is "unchanged" || return 1
  expect_scene_is "$before" "$WORK/noarchive"
}

# CP-836 (6): every signal the script can act on, at the restore, the walk and the teardown, ends
# the run non-zero with no `unchanged` and no restored entry. A script that handled only INT, TERM
# and HUP fails here on the rest. The teardown is held twice: at the first removal in the fixture,
# and at the removal of the scratch folder, where the run has not ended either, so a script that
# had already printed `unchanged` by then fails.
test_signal_during_restore_walk_and_teardown_cleans_up() {
  failures=""
  while IFS= read -r sig; do
    [ -n "$sig" ] || continue
    for boundary in restore walk teardown scratch; do
      if ! result="$(run_signal_scene "$boundary" "$sig" < /dev/null)"; then
        failures="$failures$result
"
      fi
    done
  done <<EOF
$(actionable_signals)
EOF
  [ -z "$failures" ] || fail "$failures"
}

# CP-837: when `.git/objects` cannot be removed, the one outermost entry is named, once, on stderr.
# The design sets Example 12's `.git/objects` aside for CP-837's rule: `.git` is the outermost.
test_failed_removal_names_the_outermost_entry() {
  copy="$(archive_backed_copy repo failedremoval)"
  make_objects_unremovable "$WORK/stubs-failedremoval"
  make_cargo_stub "$WORK/stubs-failedremoval" 'echo 1'

  run_read_only_with_stubs "$WORK/stubs-failedremoval" "$copy"

  expect_nonzero_status || return 1
  expect_stdout_is "" || return 1
  [ "$ERR" = "$REMOVAL_LINE .git" ] || fail "expected the one line for .git, got [$ERR]"
}

# CP-837: two independent entries that cannot be removed get one line each, and no line for anything
# under either.
test_two_residual_roots_get_one_line_each() {
  copy="$(archive_backed_copy submodule-config-names-outside tworoots)"
  make_objects_unremovable "$WORK/stubs-tworoots"
  make_tool_shim "$WORK/stubs-tworoots" rm 'for last; do :; done
case "$last" in */.gitmodules) exit 1 ;; esac
exec "$REAL" "$@"'
  make_cargo_stub "$WORK/stubs-tworoots" 'echo 1'

  run_read_only_with_stubs "$WORK/stubs-tworoots" "$copy"

  expect_nonzero_status || return 1
  expect_stdout_is "" || return 1
  expected="$(printf '%s\n%s' "$REMOVAL_LINE .git" "$REMOVAL_LINE .gitmodules")"
  [ "$ERR" = "$expected" ] || fail "expected one line for each root, got [$ERR]"
}

# CP-837, CP-838: a failed removal beside a changed fixture keeps the differing paths on stdout; and
# beside a failed walk it cannot hide that failure.
test_failed_removal_keeps_the_differing_paths_and_a_failed_walk() {
  copy="$(archive_backed_copy repo removalandchange)"
  make_objects_unremovable "$WORK/stubs-removalandchange"
  make_cargo_stub "$WORK/stubs-removalandchange" 'touch "$last/.DS_Store"; echo 1'

  run_read_only_with_stubs "$WORK/stubs-removalandchange" "$copy"

  expect_nonzero_status || return 1
  expect_stdout_is ".DS_Store" || return 1
  [ "$ERR" = "$REMOVAL_LINE .git" ] || fail "expected the one line for .git, got [$ERR]" || return 1

  copy="$(archive_backed_copy repo removalandfailedwalk)"
  make_objects_unremovable "$WORK/stubs-removalandfailedwalk"
  make_cargo_stub "$WORK/stubs-removalandfailedwalk" 'exit 1'

  run_read_only_with_stubs "$WORK/stubs-removalandfailedwalk" "$copy"

  expect_nonzero_status || return 1
  expect_stdout_is "" || return 1
  expected="$(printf '%s\n%s' "read-only.sh: walk did not complete: $copy" "$REMOVAL_LINE .git")"
  [ "$ERR" = "$expected" ] || fail "expected the walk failure and the removal line, got [$ERR]"
}

# --- cases: --kill, the walk killed mid-scene (CP-1014, E16) ---

# A stand-in for the walk host in folder $1, whose body is $2, and a `cargo` stub that answers the
# script's build with the JSON line cargo prints for the walk test binary, naming that host as its
# executable. The host is handed the fixture's absolute path first, then `--long`, as the real
# binary is.
make_kill_stubs() {
  mkdir -p "$1"
  printf '#!/bin/sh\n%s\n' "$2" > "$1/walk-host"
  chmod +x "$1/walk-host"
  cat > "$1/cargo" <<EOF
#!/bin/sh
echo '{"reason":"compiler-artifact","target":{"kind":["test"],"name":"walk"},"executable":"$1/walk-host"}'
EOF
  chmod +x "$1/cargo"
}

# The host prints the marker after its first pass, then runs until it is killed. `exec` makes the
# sleeping process the host itself, so the kill reaches it and no orphan is left.
test_kill_prints_unchanged_when_the_walk_is_killed_after_its_marker() {
  copy="$(fixture_copy plain killed)"
  make_kill_stubs "$WORK/stubs-killed" 'echo pass-complete; exec sleep 30'

  run_read_only_with_stubs "$WORK/stubs-killed" --kill "$copy"

  expect_status 0 || return 1
  expect_stdout_is "unchanged"
}

# The host prints its marker and ends by itself: the script never killed it, so a kill was not
# what the hash was taken after.
test_kill_is_never_unchanged_when_the_walk_exits_on_its_own() {
  copy="$(fixture_copy plain exitsalone)"
  make_kill_stubs "$WORK/stubs-exitsalone" 'echo pass-complete'

  run_read_only_with_stubs "$WORK/stubs-exitsalone" --kill "$copy"

  expect_nonzero_status || return 1
  expect_stdout_lacks_unchanged || return 1
  expect_stderr_contains "walk did not complete"
}

# The host runs on and prints something that is not the marker. The wait for the marker is bounded
# by READ_ONLY_MARKER_WAIT, seconds, so the case does not wait out the default.
test_kill_is_never_unchanged_when_the_walk_prints_no_marker() {
  copy="$(fixture_copy plain nomarker)"
  make_kill_stubs "$WORK/stubs-nomarker" 'echo not-the-marker; exec sleep 30'
  export READ_ONLY_MARKER_WAIT=2

  run_read_only_with_stubs "$WORK/stubs-nomarker" --kill "$copy"

  expect_nonzero_status || return 1
  expect_stdout_lacks_unchanged || return 1
  expect_stderr_contains "walk did not complete"
}

# A write the host makes before it is killed is a difference, named once, and never `unchanged`.
test_kill_is_never_unchanged_when_the_hash_differs() {
  copy="$(fixture_copy plain killedwrite)"
  make_kill_stubs "$WORK/stubs-killedwrite" 'touch "$1/.DS_Store"; echo pass-complete; exec sleep 30'

  run_read_only_with_stubs "$WORK/stubs-killedwrite" --kill "$copy"

  expect_nonzero_status || return 1
  expect_stdout_is ".DS_Store"
}

# QC-2's reviewed half for the open file: the walk's folder mode drives each model call the displayed
# file adds, and its self-check judge names each, so a walk that left one out is refused by name. The
# calls are looked for where they are made, in the one method of `Driven` each goes through, and the
# names where the judge lists them.
test_the_folder_mode_reaches_the_open_files_model_calls() {
  local walk="$ROOT/checks/walk.rs" site name
  for site in 'read_file(' '.open_read(' 'FileRequest::Position(' '.reread_open_file('; do
    grep -qF -- "$site" "$walk" || fail "checks/walk.rs never makes the call $site" || return 1
  done
  grep -qF 'TreeRequest::Invalidate(' "$walk" || fail "the walk makes no Invalidate" || return 1
  for name in 'read_file' 'FolderModel::open_read' 'FileRequest::Position' \
    'TreeRequest::Invalidate over the open file' 'FolderModel::reread_open_file'; do
    grep -qF -- "\"$name\"," "$walk" || fail "the walk's judge does not name $name" || return 1
  done
}

# CP-1126's folder-mode wiring, which the real walk never trips: it asks every image node, so a pass
# that left one unasked cannot be made to happen. The wiring is read where it is made. The folder pass,
# `pass()`, applies the image judge beside the bridge-operations judge, and the walk decides what a
# Markdown file is by matching the answer, `FileView::Markdown`, with no test on a file extension.
test_the_folder_pass_applies_the_image_judge_and_the_walk_decides_markdown_by_the_answer() {
  local walk="$ROOT/checks/walk.rs" pass_body
  pass_body="$(awk '/^fn pass\(/,/^}/' "$walk")"
  case "$pass_body" in
    *'judge_bridge_operations('*) ;;
    *) fail "checks/walk.rs's folder pass does not apply the bridge-operations judge" || return 1 ;;
  esac
  case "$pass_body" in
    *'judge_images('*) ;;
    *) fail "checks/walk.rs's folder pass does not apply the image judge" || return 1 ;;
  esac
  grep -qF 'FileView::Markdown' "$walk" \
    || fail "the walk does not match FileView::Markdown" || return 1
  if grep -nE '\.(ends_with|extension)\(' "$walk"; then
    fail "the walk tests a file extension" || return 1
  fi
}

# The judge's own cases run first in the walk's no-argument mode, on tallies it must refuse, and then
# the committed fixtures are walked: the existing cases pass unchanged beside the new acts.
test_the_existing_judge_cases_stay() {
  (cd "$ROOT" && cargo test --locked --quiet -p ka-reader-core --test walk) > "$WORK/judge.out" 2>&1 \
    || fail "the walk's self-check and fixture walks failed: $(tail -n 5 "$WORK/judge.out")" || return 1
}

# --- the runner ---

for tool in cargo git tar shasum; do
  if ! command -v "$tool" > /dev/null 2>&1; then
    echo "test_read_only.sh: a prerequisite is absent: $tool — install it; the suite does not skip" >&2
    exit 1
  fi
done

WORK="$(mktemp -d)"
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
