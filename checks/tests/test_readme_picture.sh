#!/usr/bin/env bash
# Version: 1.0.0 — first version: the picture check's six conditions, its pass line, its usage and
#   signal statuses, and the scan that holds it to no write
#
# checks/tests/test_readme_picture.sh — the cases of checks/readme-picture.sh.
#
# WHY THIS EXISTS
#   The check holds the README's picture to its record and to the product's version (docs/nfdr.md
#   QC-44, QC-64, QC-67, QC-70). Each case builds a fixture product root in a temporary folder and
#   runs the real script there under `/usr/bin/env -i`, with a PATH made only of directories this
#   suite built: the host's shell, its ordinary text and file tools and shasum, each linked in by
#   name, and one stand-in `git`. No case runs the host's git, tar or cargo.
#
# THE RECORDED GIT REPLIES
#   The stand-in `git` replays a reply recorded once from the real `git` (git version 2.54.0, Apple
#   Git-157) and committed as data under checks/tests/support/readme_picture_git_replies/: for
#   `git -C <root> ls-files --cached --error-unmatch -- <path>`, a hit (the path on stdout, status 0)
#   and a miss (the pathspec error on stderr, status 1). Any other call is answered with status 99.
#
# USAGE
#   checks/tests/test_readme_picture.sh
#   It runs every case, always: it reads no case selector and no variable of its own.
#
# WHY NO `set -e`
#   A case that fails must not end the run before the remaining cases report. Each case returns its
#   own status and the runner counts them.

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
CHECK="$ROOT/checks/readme-picture.sh"
GATE="$ROOT/checks/gate.sh"
REPLIES="$ROOT/checks/tests/support/readme_picture_git_replies"
TAB=$'\t'
PICTURE='docs/readme/shell.png'
RECORD='docs/readme/shell.record'
COMMIT='0123456789abcdef0123456789abcdef01234567'
README_MARKER='opening-images-program'
TOOLS="bash awk sed grep cat tr head wc cmp cp mkdir rm sleep shasum"

WORK=""
SUB=""

CASES="
test_everything_agrees_prints_one_line_and_exits_zero
test_no_image_in_the_opening_is_condition_a
test_an_unreadable_readme_is_condition_a_not_a_pass
test_a_missing_record_is_condition_b_alone
test_a_malformed_record_is_condition_b
test_the_opening_names_another_tracked_picture_is_condition_c
test_a_missing_or_untracked_picture_is_condition_d
test_rewritten_picture_bytes_are_condition_e
test_a_version_moved_without_a_new_capture_is_condition_f
test_every_failed_condition_is_named_in_one_run
test_any_argument_is_a_usage_error_that_reads_nothing
test_a_signal_never_ends_with_zero
test_the_check_holds_no_write
test_the_real_readmes_opening_images_carry_alternative_text
test_the_suite_is_one_fatal_step_of_the_gate
"

# --- messages: the plain form, or the form that opens with the sub-case's label ---

fail() {
  if [ -n "$SUB" ]; then
    echo "  $SUB: $*"
  else
    echo "  $*"
  fi
  return 1
}

# --- the fixture ---

# Builds one scene: the PATH directory, the fixture product root and the stand-in's log and mode.
fixture() {
  scene="$(mktemp -d "$WORK/scene.XXXXXX")"
  bin="$scene/bin"
  tree="$scene/root"
  mkdir -p "$bin" "$tree/checks" "$tree/docs/readme" "$tree/ka-reader-mac"
  for tool in $TOOLS; do
    ln -s "$(command -v "$tool")" "$bin/$tool"
  done
  printf 'tracked\n' > "$scene/git_mode"
  : > "$scene/git.log"
  printf '0\n' > "$scene/git_delay"
  cat > "$bin/git" <<STANDIN
#!/usr/bin/env bash
# Stand-in git: replays the recorded replies, and logs every call.
printf '%s\n' "\$*" >> "$scene/git.log"
case "\$*" in
  *"ls-files --cached --error-unmatch -- "*) ;;
  *) echo "stand-in git: no recorded reply for: \$*" >&2; exit 99;;
esac
sleep "\$(cat "$scene/git_delay")"
path="\${*##* -- }"
if [ "\$(cat "$scene/git_mode")" = tracked ]; then
  sed "s|docs/readme/shell.png|\$path|" "$REPLIES/ls_files_hit.stdout"
  exit "\$(cat "$REPLIES/ls_files_hit.status")"
fi
sed "s|docs/readme/other.png|\$path|" "$REPLIES/ls_files_miss.stderr" >&2
exit "\$(cat "$REPLIES/ls_files_miss.status")"
STANDIN
  chmod +x "$bin/git"
  cp "$CHECK" "$tree/checks/readme-picture.sh"
  chmod +x "$tree/checks/readme-picture.sh"
  printf 'the picture, as the fixture holds it\n' > "$tree/$PICTURE"
  printf 'other picture\n' > "$tree/docs/readme/other.png"
  printf '# KA-Reader\n\nA local reader.\n\n![The shell, as the fixture shows it.](%s)\n\nInstall path.\n\n## Known gaps\n\nLater text.\n' "$PICTURE" > "$tree/README.md"
  printf '[workspace]\nmembers = []\n\n[workspace.package]\nversion = "0.1.0"\n\n[workspace.lints.rust]\nunsafe_code = "forbid"\n' > "$tree/Cargo.toml"
  printf '<plist>\n<dict>\n  <key>CFBundleName</key>\n  <string>KA-Reader</string>\n  <key>CFBundleShortVersionString</key>\n  <string>0.1.0</string>\n</dict>\n</plist>\n' > "$tree/ka-reader-mac/Info.plist"
  write_record "$PICTURE" 0.1.0 "$COMMIT" "$(digest_of "$tree/$PICTURE")"
}

digest_of() {
  shasum -a 256 "$1" | awk '{ print $1 }'
}

write_record() {
  printf 'picture: %s\nversion: %s\ncommit: %s\nsha256: %s\n' "$1" "$2" "$3" "$4" > "$tree/$RECORD"
}

# The tree as a list of paths and digests, to hold a run to no change.
snapshot() {
  (cd "$1" && find . -type f -exec shasum -a 256 {} \; | LC_ALL=C sort)
}

# Runs the real script in the fixture root, under env -i with only the built PATH.
run_check() {
  before="$(snapshot "$tree")"
  status=0
  (cd "$tree" && /usr/bin/env -i PATH="$bin" "$tree/checks/readme-picture.sh" "$@") > "$scene/out" 2> "$scene/err" || status=$?
  stdout="$(cat "$scene/out")"
  stderr="$(cat "$scene/err")"
  after="$(snapshot "$tree")"
}

# --- assertions ---

expect_status() {
  [ "$status" -eq "$1" ] || fail "expected exit $1, got $status. stderr: $stderr"
}

expect_stdout_empty() {
  [ -z "$stdout" ] || fail "stdout is not empty: $stdout"
}

expect_tree_unchanged() {
  [ "$before" = "$after" ] || fail "the fixture tree is not byte-identical after the run: $(diff <(printf '%s\n' "$before") <(printf '%s\n' "$after") | tr '\n' ' ')"
}

# The condition one stderr line belongs to, by what the line says.
letter_of() {
  case "$1" in
    *"README.md: cannot read this file"*|*"README.md: the opening, before its first ## heading"*) echo a;;
    *"shell.record: no file is there"*|*"shell.record: cannot read this file"*|*"shell.record: the file is not the four lines"*) echo b;;
    *"README.md: the opening shows the image"*) echo c;;
    *"no file is there"*|*"Git does not track it"*) echo d;;
    *"its SHA-256 is not the one"*) echo e;;
    *"it names version"*) echo f;;
    *) echo "?";;
  esac
}

# The letters of the stderr lines, in the order printed, as one string.
letters() {
  while IFS= read -r line; do
    [ -z "$line" ] || printf '%s ' "$(letter_of "$line")"
  done <<< "$stderr"
}

expect_letters() {
  got="$(letters)"
  [ "$got" = "$1 " ] || fail "expected the lines for conditions $2, in that order, got: $stderr"
}

# Exactly one stderr line, and it is the one condition's.
expect_one_condition() {
  expect_stdout_empty || return 1
  count="$(printf '%s' "$stderr" | wc -l | tr -d ' ')"
  [ -n "$stderr" ] && [ "$count" -eq 0 ] || fail "expected exactly one line for condition ($1), got: $stderr"
  [ "$(letter_of "$stderr")" = "$1" ] || fail "expected exactly one line for condition ($1), got: $stderr"
}

expect_line_names() {
  case "$stderr" in
    *"$2"*) ;;
    *) fail "the line for condition ($1) does not name $2: $stderr";;
  esac
}

expect_line_says_commit_together() {
  case "$stderr" in
    *"commit the new picture and record together"*) ;;
    *) fail "the line for condition ($1) does not say to commit the new picture and record together: $stderr";;
  esac
}

expect_git_untouched() {
  [ ! -s "$scene/git.log" ] || fail "the git stand-in was called: $(cat "$scene/git.log")"
}

# --- cases ---

# CP-1375, CP-1376, CP-1377: everything agrees → one stdout line, nothing on stderr, nothing written.
test_everything_agrees_prints_one_line_and_exits_zero() {
  fixture
  run_check
  expect_status 0 || return 1
  [ -z "$stderr" ] || fail "stderr is not empty: $stderr" || return 1
  lines="$(printf '%s\n' "$stdout" | wc -l | tr -d ' ')"
  case "$stdout" in
    *"$PICTURE"*"0.1.0"*) [ "$lines" -eq 1 ] || fail "expected one stdout line naming docs/readme/shell.png and 0.1.0, got: $stdout" || return 1;;
    *) fail "expected one stdout line naming docs/readme/shell.png and 0.1.0, got: $stdout" || return 1;;
  esac
  expect_tree_unchanged
}

# CP-1364's opening: the README line deleted, or the image only below the first ## heading, is (a).
test_no_image_in_the_opening_is_condition_a() {
  SUB="the README image line deleted"
  fixture
  sed '/^!\[/d' "$tree/README.md" > "$scene/edited" && cp "$scene/edited" "$tree/README.md"
  run_check
  expect_status 1 || return 1
  expect_one_condition a || return 1
  expect_line_names a "holds no Markdown image" || return 1
  expect_line_names a "Add an image line" || return 1
  SUB="an image only below the first ## heading"
  fixture
  printf '# KA-Reader\n\nA local reader.\n\n## Known gaps\n\n![below](%s)\n' "$PICTURE" > "$tree/README.md"
  run_check
  expect_status 1 || return 1
  expect_one_condition a
}

test_an_unreadable_readme_is_condition_a_not_a_pass() {
  SUB="README.md absent"
  fixture
  rm "$tree/README.md"
  run_check
  expect_status 1 || return 1
  expect_one_condition a || return 1
  SUB="README.md unreadable"
  fixture
  chmod 000 "$tree/README.md"
  run_check
  chmod 644 "$tree/README.md"
  expect_status 1 || return 1
  expect_one_condition a
}

test_a_missing_record_is_condition_b_alone() {
  fixture
  rm "$tree/$RECORD"
  run_check
  expect_status 1 || return 1
  expect_one_condition b || return 1
  expect_line_names b "$RECORD" || return 1
  expect_line_names b "checks/readme-capture.sh"
}

test_a_malformed_record_is_condition_b() {
  digest="$(digest_of "$ROOT/checks/tests/test_readme_picture.sh")"
  for mutation in "no picture line" "no version line" "no commit line" "no sha256 line" "a line given twice" "an extra line" "the lines out of order" "a commit that is not 40 hex digits" "a digest that is not 64 hex digits" "an absolute picture path" "a picture path with .."; do
    SUB="$mutation"
    fixture
    good="$(digest_of "$tree/$PICTURE")"
    case "$mutation" in
      "no picture line") printf 'version: 0.1.0\ncommit: %s\nsha256: %s\n' "$COMMIT" "$good";;
      "no version line") printf 'picture: %s\ncommit: %s\nsha256: %s\n' "$PICTURE" "$COMMIT" "$good";;
      "no commit line") printf 'picture: %s\nversion: 0.1.0\nsha256: %s\n' "$PICTURE" "$good";;
      "no sha256 line") printf 'picture: %s\nversion: 0.1.0\ncommit: %s\n' "$PICTURE" "$COMMIT";;
      "a line given twice") printf 'picture: %s\nversion: 0.1.0\nversion: 0.1.0\ncommit: %s\nsha256: %s\n' "$PICTURE" "$COMMIT" "$good";;
      "an extra line") printf 'picture: %s\nversion: 0.1.0\ncommit: %s\nsha256: %s\nnote: extra\n' "$PICTURE" "$COMMIT" "$good";;
      "the lines out of order") printf 'picture: %s\ncommit: %s\nversion: 0.1.0\nsha256: %s\n' "$PICTURE" "$COMMIT" "$good";;
      "a commit that is not 40 hex digits") printf 'picture: %s\nversion: 0.1.0\ncommit: abc123\nsha256: %s\n' "$PICTURE" "$good";;
      "a digest that is not 64 hex digits") printf 'picture: %s\nversion: 0.1.0\ncommit: %s\nsha256: %s\n' "$PICTURE" "$COMMIT" "${digest%??}";;
      "an absolute picture path") printf 'picture: /%s\nversion: 0.1.0\ncommit: %s\nsha256: %s\n' "$PICTURE" "$COMMIT" "$good";;
      "a picture path with ..") printf 'picture: docs/../%s\nversion: 0.1.0\ncommit: %s\nsha256: %s\n' "$PICTURE" "$COMMIT" "$good";;
    esac > "$tree/$RECORD"
    run_check
    expect_status 1 || return 1
    expect_one_condition b || return 1
  done
}

# CP-1364's "exactly one image": every image in the opening must name the record's picture.
test_the_opening_names_another_tracked_picture_is_condition_c() {
  SUB="the opening names docs/readme/other.png"
  fixture
  sed 's|docs/readme/shell.png|docs/readme/other.png|' "$tree/README.md" > "$scene/edited" && cp "$scene/edited" "$tree/README.md"
  run_check
  expect_status 1 || return 1
  expect_one_condition c || return 1
  expect_line_names c "docs/readme/other.png" || return 1
  expect_line_names c "$PICTURE" || return 1
  SUB="two images, one of them the record's"
  fixture
  printf '# KA-Reader\n\nA local reader.\n\n![One.](%s)\n\n![Two.](docs/readme/other.png)\n\n## Known gaps\n' "$PICTURE" > "$tree/README.md"
  run_check
  expect_status 1 || return 1
  expect_one_condition c
}

test_a_missing_or_untracked_picture_is_condition_d() {
  SUB="the picture absent"
  fixture
  rm "$tree/$PICTURE"
  run_check
  expect_status 1 || return 1
  expect_one_condition d || return 1
  expect_line_names d "$PICTURE" || return 1
  SUB="the picture not tracked"
  fixture
  printf 'untracked\n' > "$scene/git_mode"
  run_check
  expect_status 1 || return 1
  expect_one_condition d || return 1
  expect_line_names d "Git does not track it"
}

test_rewritten_picture_bytes_are_condition_e() {
  fixture
  printf 'x' >> "$tree/$PICTURE"
  run_check
  expect_status 1 || return 1
  expect_one_condition e || return 1
  expect_line_names e "$PICTURE" || return 1
  expect_line_names e "checks/readme-capture.sh" || return 1
  expect_line_says_commit_together e
}

test_a_version_moved_without_a_new_capture_is_condition_f() {
  SUB="both at 0.2.0"
  fixture
  sed 's/0\.1\.0/0.2.0/' "$tree/Cargo.toml" > "$scene/edited" && cp "$scene/edited" "$tree/Cargo.toml"
  sed 's/0\.1\.0/0.2.0/' "$tree/ka-reader-mac/Info.plist" > "$scene/edited" && cp "$scene/edited" "$tree/ka-reader-mac/Info.plist"
  run_check
  expect_status 1 || return 1
  expect_one_condition f || return 1
  expect_line_names f "0.1.0" || return 1
  expect_line_names f "0.2.0" || return 1
  expect_line_names f "checks/readme-capture.sh" || return 1
  expect_line_says_commit_together f || return 1
  SUB="Cargo.toml alone at 0.2.0"
  fixture
  sed 's/0\.1\.0/0.2.0/' "$tree/Cargo.toml" > "$scene/edited" && cp "$scene/edited" "$tree/Cargo.toml"
  run_check
  expect_status 1 || return 1
  expect_one_condition f || return 1
  SUB="Info.plist alone at 0.2.0"
  fixture
  sed 's/0\.1\.0/0.2.0/' "$tree/ka-reader-mac/Info.plist" > "$scene/edited" && cp "$scene/edited" "$tree/ka-reader-mac/Info.plist"
  run_check
  expect_status 1 || return 1
  expect_one_condition f || return 1
  SUB="no version in Cargo.toml's [workspace.package] table"
  fixture
  printf '[workspace]\nmembers = []\n\n[workspace.package]\nedition = "2024"\n\n[workspace.lints.rust]\nversion = "0.1.0"\n' > "$tree/Cargo.toml"
  run_check
  expect_status 1 || return 1
  expect_one_condition f || return 1
  SUB="no version key in Info.plist"
  fixture
  printf '<plist>\n<dict>\n  <key>CFBundleName</key>\n  <string>KA-Reader</string>\n</dict>\n</plist>\n' > "$tree/ka-reader-mac/Info.plist"
  run_check
  expect_status 1 || return 1
  expect_one_condition f
}

test_every_failed_condition_is_named_in_one_run() {
  SUB="bytes and version both wrong"
  fixture
  printf 'x' >> "$tree/$PICTURE"
  sed 's/0\.1\.0/0.2.0/' "$tree/Cargo.toml" > "$scene/edited" && cp "$scene/edited" "$tree/Cargo.toml"
  run_check
  expect_status 1 || return 1
  expect_stdout_empty || return 1
  expect_letters "e f" "(e) then (f)" || return 1
  SUB="record missing and image line deleted"
  fixture
  rm "$tree/$RECORD"
  sed '/^!\[/d' "$tree/README.md" > "$scene/edited" && cp "$scene/edited" "$tree/README.md"
  run_check
  expect_status 1 || return 1
  expect_stdout_empty || return 1
  expect_letters "a b" "(a) then (b)"
}

# QC-70: a wrong invocation is 2, with the usage line, before anything is read.
test_any_argument_is_a_usage_error_that_reads_nothing() {
  SUB="one argument"
  fixture
  run_check one
  expect_status 2 || return 1
  case "$stderr" in *"Usage: checks/readme-picture.sh"*) ;; *) fail "stderr carries no usage line. stderr: $stderr" || return 1;; esac
  expect_git_untouched || return 1
  SUB="two arguments"
  fixture
  run_check one two
  expect_status 2 || return 1
  case "$stderr" in *"Usage: checks/readme-picture.sh"*) ;; *) fail "stderr carries no usage line. stderr: $stderr" || return 1;; esac
  expect_git_untouched
}

# QC-70: a signal ends the run with its own status, or with 1 where it lands inside a command
# substitution, and never with 0. The stand-in git holds the run in the middle of its work.
test_a_signal_never_ends_with_zero() {
  for signal in TERM:143 INT:130 HUP:129; do
    name="${signal%%:*}"
    allowed="${signal##*:}"
    SUB="$name"
    fixture
    printf '1\n' > "$scene/git_delay"
    # One simple command in the background, so $! is the script's own pid (env replaces itself with
    # it), and job control on, so the background job does not ignore INT.
    set -m
    /usr/bin/env -i PATH="$bin" "$tree/checks/readme-picture.sh" > "$scene/out" 2> "$scene/err" &
    pid=$!
    waited=0
    while [ ! -s "$scene/git.log" ] && [ "$waited" -lt 100 ]; do
      sleep 0.05
      waited=$((waited + 1))
    done
    kill -s "$name" "$pid" 2> /dev/null
    status=0
    wait "$pid" || status=$?
    set +m
    if [ "$status" -ne "$allowed" ] && [ "$status" -ne 1 ]; then
      fail "ended with $status, expected $allowed or 1, never 0" || return 1
    fi
  done
}

# CP-1377: the script's text, comments removed, holds no write — the scan test_readme.sh makes for
# checks/readme.sh, applied to this script.
test_the_check_holds_no_write() {
  [ -f "$CHECK" ] || fail "checks/readme-picture.sh holds a write outside its comments: the script is not there" || return 1
  source_text="$(sed '/^[[:space:]]*#/d' "$CHECK")"
  forbidden="$(printf '%s\n' "$source_text" | grep -E '(^|[[:space:];|])(curl|wget|ssh|scp|nc|touch|mktemp|mkdir|rm|mv|cp|tee|install|python3?|perl|ruby|eval)([[:space:];|]|$)|<<|system[[:space:]]*\(|ENVIRON|\$\{[A-Z_][A-Z_0-9]*[:-]' || true)"
  [ -z "$forbidden" ] || fail "checks/readme-picture.sh holds a write outside its comments: $forbidden" || return 1
  # Quoted text is dropped first, so the > of an <key> tag or of a message is no redirect.
  unquoted="$(printf '%s\n' "$source_text" | awk '{ out = ""; n = length($0)
    for (i = 1; i <= n; i++) { c = substr($0, i, 1)
      if (quote == "") { if (c == "\047" || c == "\"") quote = c; else out = out c }
      else if (c == "\\" && quote == "\"") i++
      else if (c == quote) quote = "" }
    print out }')"
  redirects="$(printf '%s\n' "$unquoted" | sed 's@> */dev/null@@g' | grep -E '>([[:space:]]+"?[$/.A-Za-z_]|"[$/.A-Za-z_]|[$/.])|>>' || true)"
  [ -z "$redirects" ] || fail "checks/readme-picture.sh holds a write outside its comments: $redirects"
}

# CP-1366: every inline image in the real README's opening has alternative text. The opening and the
# image form are the check's own: the awk program is read out of checks/readme-picture.sh between its
# two marker lines, so the two cannot disagree on what an image is. The case passes while the opening
# holds no image; condition (a) of the gate's step holds that case.
test_the_real_readmes_opening_images_carry_alternative_text() {
  program="$(sed -n "/^# $README_MARKER: begin\$/,/^# $README_MARKER: end\$/p" "$CHECK" | sed '1d;$d')"
  [ -n "$program" ] || fail "checks/readme-picture.sh holds no opening-images program between its marker lines" || return 1
  eval "$program"
  images="$(LC_ALL=C awk "$opening_images" "$ROOT/README.md")"
  # Split by parameter expansion: read would treat the tab as blank space and drop an empty alt.
  while IFS= read -r line; do
    [ -n "$line" ] || continue
    alt="${line%%"$TAB"*}"
    path="${line#*"$TAB"}"
    [ -n "$alt" ] || fail "README.md's opening holds an image with no alternative text: ![]($path)" || return 1
  done <<< "$images"
  return 0
}

# --- the gate, read as text ---

# The steps of a gate file, one per line: the name, a tab, the command. Only a top-level call in the
# gate's literal form is read. From the first call to the end of the file, the list holds nothing
# but calls, comments and blank lines; any other line there is read as no list at all, because an
# `if` around a call or a `|| true` after it leaves a call that does not stop the run.
gate_steps_of() {
  [ -f "$1" ] || return 0
  first="$(grep -n -m 1 "^run_step '" "$1" | cut -d: -f1 || true)"
  [ -n "$first" ] || return 0
  stray="$(tail -n +"$first" "$1" | grep -v -E "^run_step '[^']*' '.*'\$|^[[:space:]]*(#.*)?\$" || true)"
  [ -z "$stray" ] || return 0
  sed -n "s/^run_step '\([^']*\)' '\(.*\)'\$/\1${TAB}\2/p" "$1"
}

# Holds the step $2 of the gate file $1 to its command $3 and its place $4 (`between:<after>:<before>`
# for a relative place, `directly_before:<name>` for an adjacent one). Each failure names itself and
# returns 1.
gate_step_holds() {
  gate_file="$1"; step="$2"; command="$3"; place="$4"
  steps="$(gate_steps_of "$gate_file")"
  count="$(printf '%s\n' "$steps" | awk -F'\t' -v want="$step" '$1 == want' | wc -l | tr -d ' ')"
  if [ "$count" -eq 0 ]; then
    conditional="$(grep -F "'$step'" "$gate_file" | grep -v '^[[:space:]]*#' | head -1 || true)"
    if [ -n "$conditional" ]; then
      echo "checks/gate.sh runs the step $step under a condition: $conditional"
    else
      echo "checks/gate.sh holds no step named $step"
    fi
    return 1
  fi
  [ "$count" -le 1 ] || { echo "checks/gate.sh holds the step $step more than once"; return 1; }
  line="$(printf '%s\n' "$steps" | awk -F'\t' -v want="$step" '$1 == want { print substr($0, length($1) + 2) }')"
  [ "$line" = "$command" ] || { echo "checks/gate.sh runs the step $step with a command other than $command: run_step '$step' '$line'"; return 1; }
  names="$(printf '%s\n' "$steps" | awk -F'\t' '{ print $1 }')"
  position() { printf '%s\n' "$names" | grep -n -x -F "$1" | head -1 | cut -d: -f1; }
  at="$(position "$step")"
  case "$place" in
    between:*)
      rest="${place#between:}"; after="${rest%%:*}"; before="${rest#*:}"
      if [ "$(position "$after")" -lt "$at" ] && [ "$at" -lt "$(position "$before")" ]; then return 0; fi
      echo "checks/gate.sh puts the step $step outside its place, which is after $after and before $before"
      return 1;;
    directly_before:*)
      next="${place#directly_before:}"
      if [ "$(position "$next")" -eq $((at + 1)) ]; then return 0; fi
      echo "checks/gate.sh puts the step $step outside its place, which is directly before $next"
      return 1;;
  esac
}

# The gate with the step's line deleted, commented, followed by `|| true`, or inside `if false`.
mutate_gate() {
  case "$1" in
    "the step deleted") sed "/^run_step '$2' /d" "$GATE";;
    "the step commented out") sed "s|^run_step '$2' |# &|" "$GATE";;
    "the step followed by || true") sed "/^run_step '$2' /s|\$| \|\| true|" "$GATE";;
    "the step inside if false") awk -v want="run_step '$2' " 'index($0, want) == 1 { print "if false; then"; print; print "fi"; next } { print }' "$GATE";;
  esac
}

# The step holds in the real gate, and each of the four mutations of its line fails the same check.
gate_step_is_one_fatal_step() {
  holds="$(gate_step_holds "$GATE" "$1" "$2" "$3")" || { fail "$holds"; return 1; }
  for mutation in "the step deleted" "the step commented out" "the step followed by || true" "the step inside if false"; do
    mutate_gate "$mutation" "$1" > "$WORK/mutated_gate"
    if gate_step_holds "$WORK/mutated_gate" "$1" "$2" "$3" > /dev/null; then
      fail "$mutation: the case did not fail on a gate with this change" || return 1
    fi
  done
}

# CP-1378: the suite is one fatal step of the gate, once, unconditional, after "Release absent suite"
# and before "Own state suite". It does not assert adjacency to either: the check's own step sits
# between "Release absent suite" and its suite.
test_the_suite_is_one_fatal_step_of_the_gate() {
  gate_step_is_one_fatal_step "README picture check suite" "checks/tests/test_readme_picture.sh" "between:Release absent suite:Own state suite"
}

# --- the runner ---

WORK="$(mktemp -d)"
cleanup() {
  rm -rf "$WORK"
}
trap cleanup EXIT

failed=0
total=0
for case_name in $CASES; do
  total=$((total + 1))
  SUB=""
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
