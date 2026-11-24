#!/usr/bin/env bash
# Version: 1.1.0 — every case holds the fixture unchanged and git uncalled; each line is held to the
#   versions it names; (i) before (v), (r) before (iii), (v) with stale halves, and a pass on
#   differing versions carried by both halves
# Version: 1.0.0 — first version: the badge check's five conditions, its pass line, its usage and
#   signal statuses, the scans that hold it to no write and no variable, the copies of the picture
#   check's programs, and the gate step that runs this suite
#
# checks/tests/test_readme_badge.sh — the cases of checks/readme-badge.sh.
#
# WHY THIS EXISTS
#   The check holds the README's release badge to the product's version (docs/nfdr.md QC-44, QC-64,
#   QC-67, QC-70). Each case builds a fixture product root in a temporary folder and runs the real
#   script there under `/usr/bin/env -i`, with a PATH made only of directories this suite built: the
#   host's shell and its ordinary text and file tools, each linked in by name, and one stand-in `git`
#   that answers every call with status 99 and logs it. No case runs the host's git, tar or cargo.
#
# USAGE
#   checks/tests/test_readme_badge.sh
#   It runs every case, always: it reads no case selector and no variable of its own.
#
# WHY NO `set -e`
#   A case that fails must not end the run before the remaining cases report. Each case returns its
#   own status and the runner counts them.

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
CHECK="$ROOT/checks/readme-badge.sh"
PICTURE_CHECK="$ROOT/checks/readme-picture.sh"
GATE="$ROOT/checks/gate.sh"
TAB=$'\t'
BADGE='docs/readme/badges/release.svg'
TOOLS="bash awk sed grep cat tr head wc cmp cp mkdir rm sleep"

WORK=""
SUB=""

CASES="
test_a_release_badge_that_matches_in_both_halves_passes
test_no_release_badge_in_the_opening_is_condition_i
test_a_release_badge_at_another_path_is_no_release_badge
test_an_alternative_without_the_version_is_condition_ii
test_a_picture_without_the_version_is_condition_iii
test_a_version_moved_past_the_badge_names_both_halves
test_an_unreadable_product_version_is_condition_v
test_an_unreadable_readme_is_condition_r_not_a_pass
test_any_argument_is_a_usage_error_that_reads_nothing
test_a_signal_never_ends_with_zero
test_the_check_holds_no_write
test_the_check_reads_no_variable_of_its_own
test_the_programs_are_the_picture_checks_own
test_the_suite_is_one_fatal_step_of_the_gate
test_the_check_is_one_fatal_step_before_its_suite
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

# Builds one scene: the PATH directory, the fixture product root and the stand-in's log.
fixture() {
  scene="$(mktemp -d "$WORK/scene.XXXXXX")"
  bin="$scene/bin"
  tree="$scene/root"
  mkdir -p "$bin" "$tree/checks" "$tree/docs/readme/badges" "$tree/ka-reader-mac"
  for tool in $TOOLS; do
    ln -s "$(command -v "$tool")" "$bin/$tool"
  done
  : > "$scene/git.log"
  cat > "$bin/git" <<STANDIN
#!/usr/bin/env bash
# Stand-in git: logs every call and answers none of them.
printf '%s\n' "\$*" >> "$scene/git.log"
exit 99
STANDIN
  chmod +x "$bin/git"
  cp "$CHECK" "$tree/checks/readme-badge.sh" 2> /dev/null || true
  chmod +x "$tree/checks/readme-badge.sh" 2> /dev/null || true
  write_readme "Release: 0.1.1"
  write_svg 0.1.1
  write_versions 0.1.1 0.1.1
}

# The README as the shared front writes its opening: the badge row, the shell picture, then a later
# heading. $1 is the release badge's alternative text.
write_readme() {
  printf '# KA-Reader\n\nA local reader.\n\n![Licence: MIT](docs/readme/badges/licence.svg)\n![%s](%s)\n![Platform: macOS 26 or later](docs/readme/badges/platform.svg)\n\n![The shell.](docs/readme/shell.png)\n\n## Known gaps\n\nLater text.\n' "$1" "$BADGE" > "$tree/README.md"
}

# The release picture in the shape the design fixes: the value is one <text> element whose whole
# content is the version, on the same line as its opening tag.
write_svg() {
  printf '<svg xmlns="http://www.w3.org/2000/svg" width="98" height="20" role="img" aria-label="Release: %s">\n<title>Release: %s</title>\n<g fill="#fff" text-anchor="middle">\n<text x="28" y="15" fill="#010101" fill-opacity=".3">Release</text>\n<text x="28" y="14">Release</text>\n<text x="77" y="15" fill="#010101" fill-opacity=".3">%s</text>\n<text x="77" y="14">%s</text>\n</g>\n</svg>\n' "$1" "$1" "$1" "$1" > "$tree/$BADGE"
}

# Cargo.toml at $1 and Info.plist at $2.
write_versions() {
  printf '[workspace]\nmembers = []\n\n[workspace.package]\nversion = "%s"\n\n[workspace.lints.rust]\nunsafe_code = "forbid"\n' "$1" > "$tree/Cargo.toml"
  printf '<plist>\n<dict>\n  <key>CFBundleName</key>\n  <string>KA-Reader</string>\n  <key>CFBundleShortVersionString</key>\n  <string>%s</string>\n</dict>\n</plist>\n' "$2" > "$tree/ka-reader-mac/Info.plist"
}

# The tree as a list of paths and digests, to hold a run to no change.
snapshot() {
  (cd "$1" && find . -type f -exec shasum -a 256 {} \; | LC_ALL=C sort)
}

# Runs the real script in the fixture root, under env -i with only the built PATH.
run_check() {
  before="$(snapshot "$tree")"
  status=0
  (cd "$tree" && /usr/bin/env -i PATH="$bin" "$tree/checks/readme-badge.sh" "$@") > "$scene/out" 2> "$scene/err" || status=$?
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

expect_git_untouched() {
  [ ! -s "$scene/git.log" ] || fail "the git stand-in was called, and checks/readme-badge.sh runs no git: $(cat "$scene/git.log")"
}

# The condition one stderr line belongs to, by what the line says.
letter_of() {
  case "$1" in
    *"README.md: cannot read this file"*) echo r;;
    *"no image in README.md's opening"*) echo i;;
    *"cannot be compared with the product's version"*) echo v;;
    *"alternative text in README.md carries"*) echo ii;;
    *"this picture's text carries"*|*"this picture carries no version"*|*"release.svg: no file is there"*|*"release.svg: cannot read this file"*) echo iii;;
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
  [ "$got" = "$1 " ] || fail "expected the lines for conditions $2, in that order, got: $stderr" || return 1
  expect_lines_in_the_shape || return 1
  expect_tree_unchanged || return 1
  expect_git_untouched
}

# Every stderr line has the one shape, `readme-badge.sh: <file>: <found>. <what to do>, then run
# checks/readme-badge.sh from the product root.`
expect_lines_in_the_shape() {
  while IFS= read -r line; do
    [ -n "$line" ] || continue
    case "$line" in
      "readme-badge.sh: "?*": "?*". "?*", then run checks/readme-badge.sh from the product root.") ;;
      *) fail "a stderr line is not in the shape readme-badge.sh: <file>: <found>. <what to do>, then run checks/readme-badge.sh from the product root. The line: $line" || return 1;;
    esac
  done <<< "$stderr"
}

# Exactly one stderr line, and it is the one condition's.
expect_one_condition() {
  expect_stdout_empty || return 1
  count="$(printf '%s' "$stderr" | wc -l | tr -d ' ')"
  [ -n "$stderr" ] && [ "$count" -eq 0 ] || fail "expected exactly one line for condition ($1), got: $stderr" || return 1
  [ "$(letter_of "$stderr")" = "$1" ] || fail "expected exactly one line for condition ($1), got: $stderr" || return 1
  expect_lines_in_the_shape || return 1
  expect_tree_unchanged || return 1
  expect_git_untouched
}

expect_line_names() {
  case "$stderr" in
    *"$2"*) ;;
    *) fail "the line for condition ($1) does not name $2: $stderr";;
  esac
}

# Every stderr line names $1, each on its own line, so one line cannot carry what another lacks.
expect_each_line_names() {
  while IFS= read -r line; do
    [ -n "$line" ] || continue
    case "$line" in
      *"$1"*) ;;
      *) fail "the line for condition ($(letter_of "$line")) does not name $1: $stderr" || return 1;;
    esac
  done <<< "$stderr"
}

# A run that passes: status 0, one stdout line naming the badge and the version, nothing on stderr,
# the tree as it was, and git never called.
expect_pass() {
  expect_status 0 || return 1
  [ -z "$stderr" ] || fail "stderr is not empty: $stderr" || return 1
  lines="$(printf '%s\n' "$stdout" | wc -l | tr -d ' ')"
  case "$stdout" in
    *"$BADGE"*"$1"*) [ "$lines" -eq 1 ] || fail "expected one stdout line naming docs/readme/badges/release.svg and $1, got: $stdout" || return 1;;
    *) fail "expected one stdout line naming docs/readme/badges/release.svg and $1, got: $stdout" || return 1;;
  esac
  expect_tree_unchanged || return 1
  expect_git_untouched
}

# --- cases ---

# The release badge's alternative text and its picture both carry the product's version.
test_a_release_badge_that_matches_in_both_halves_passes() {
  SUB="both halves at the product's 0.1.1"
  fixture
  run_check
  expect_pass 0.1.1 || return 1
  # Where Cargo.toml and Info.plist differ, each half has to carry both versions, so a badge that
  # carries both passes, and its pass line names both.
  SUB="Cargo.toml at 0.1.1 and Info.plist at 0.1.2, each half carrying both"
  fixture
  write_versions 0.1.1 0.1.2
  write_readme "Release: 0.1.1 and 0.1.2"
  printf '<svg xmlns="http://www.w3.org/2000/svg" width="98" height="20" role="img" aria-label="Release: 0.1.1 and 0.1.2">\n<text x="28" y="14">Release</text>\n<text x="77" y="14">0.1.1</text>\n<text x="120" y="14">0.1.2</text>\n</svg>\n' > "$tree/$BADGE"
  run_check
  expect_pass 0.1.1 || return 1
  case "$stdout" in
    *"0.1.2"*) ;;
    *) fail "expected one stdout line naming docs/readme/badges/release.svg and 0.1.2, got: $stdout";;
  esac
}

# The opening shows no image naming the release picture: the line deleted, or the badge only below
# the first ## heading.
test_no_release_badge_in_the_opening_is_condition_i() {
  SUB="the release badge's line deleted"
  fixture
  sed "/release.svg/d" "$tree/README.md" > "$scene/edited" && cp "$scene/edited" "$tree/README.md"
  run_check
  expect_status 1 || return 1
  expect_one_condition i || return 1
  expect_line_names i "$BADGE" || return 1
  expect_line_names i "0.1.1" || return 1
  SUB="the release badge only below the first ## heading"
  fixture
  printf '# KA-Reader\n\nA local reader.\n\n![Licence: MIT](docs/readme/badges/licence.svg)\n\n## Known gaps\n\n![Release: 0.1.1](%s)\n' "$BADGE" > "$tree/README.md"
  run_check
  expect_status 1 || return 1
  expect_one_condition i || return 1
  # (i) prints before (v), and with a version unread it names no product version.
  SUB="the release badge's line deleted, and Cargo.toml's version unread"
  fixture
  sed "/release.svg/d" "$tree/README.md" > "$scene/edited" && cp "$scene/edited" "$tree/README.md"
  rm "${tree:?}/Cargo.toml"
  run_check
  expect_status 1 || return 1
  expect_stdout_empty || return 1
  expect_letters "i v" "(i) then (v)"
}

# The release badge is the image at exactly docs/readme/badges/release.svg: the same file name in
# another folder is no release badge.
test_a_release_badge_at_another_path_is_no_release_badge() {
  fixture
  sed "s|$BADGE|docs/readme/release.svg|" "$tree/README.md" > "$scene/edited" && cp "$scene/edited" "$tree/README.md"
  run_check
  expect_status 1 || return 1
  expect_one_condition i
}

# The alternative text carries the version as a whole word, or it is (ii).
test_an_alternative_without_the_version_is_condition_ii() {
  SUB="the alternative text at 0.1.2"
  fixture
  write_readme "Release: 0.1.2"
  run_check
  expect_status 1 || return 1
  expect_one_condition ii || return 1
  expect_line_names ii "$BADGE" || return 1
  expect_line_names ii "0.1.2" || return 1
  expect_line_names ii "0.1.1" || return 1
  SUB="the alternative text at 0.1.10"
  fixture
  write_readme "Release: 0.1.10"
  run_check
  expect_status 1 || return 1
  expect_one_condition ii || return 1
  expect_line_names ii "version 0.1.10," || return 1
  SUB="the alternative text at 10.1.1"
  fixture
  write_readme "Release: 10.1.1"
  run_check
  expect_status 1 || return 1
  expect_one_condition ii || return 1
  expect_line_names ii "version 10.1.1," || return 1
  SUB="the alternative text at 0.1.1.5"
  fixture
  write_readme "Release: 0.1.1.5"
  run_check
  expect_status 1 || return 1
  expect_one_condition ii || return 1
  SUB="the alternative text with no version"
  fixture
  write_readme "Release"
  run_check
  expect_status 1 || return 1
  expect_one_condition ii || return 1
  expect_line_names ii "carries no version" || return 1
  expect_line_names ii "0.1.1" || return 1
  SUB="the alternative text reading v0.1.1"
  fixture
  write_readme "Release: v0.1.1"
  run_check
  expect_pass 0.1.1 || return 1
  SUB="the alternative text ending 0.1.1."
  fixture
  write_readme "Release: 0.1.1."
  run_check
  expect_pass 0.1.1
}

# The picture's value is one <text> element whose whole content is the version, or it is (iii).
test_a_picture_without_the_version_is_condition_iii() {
  SUB="the picture's value at 0.1.2"
  fixture
  write_svg 0.1.2
  run_check
  expect_status 1 || return 1
  expect_one_condition iii || return 1
  expect_line_names iii "$BADGE" || return 1
  expect_line_names iii "version 0.1.2," || return 1
  expect_line_names iii "0.1.1 in Cargo.toml" || return 1
  SUB="the picture with no <text> holding a version"
  fixture
  printf '<svg xmlns="http://www.w3.org/2000/svg" width="98" height="20" role="img" aria-label="Release: 0.1.1">\n<text x="28" y="14">Release</text>\n</svg>\n' > "$tree/$BADGE"
  run_check
  expect_status 1 || return 1
  expect_one_condition iii || return 1
  expect_line_names iii "carries no version" || return 1
  expect_line_names iii "0.1.1 in Cargo.toml" || return 1
  SUB="the picture absent"
  fixture
  rm "${tree:?}/$BADGE"
  run_check
  expect_status 1 || return 1
  expect_one_condition iii || return 1
  expect_line_names iii "no file is there" || return 1
  # A folder where the file should be, not a file made unreadable with chmod (see the README case).
  SUB="the picture present and not a file that can be read"
  fixture
  rm "${tree:?}/$BADGE"
  mkdir "$tree/$BADGE"
  run_check
  expect_status 1 || return 1
  expect_one_condition iii || return 1
  expect_line_names iii "cannot read this file"
}

# When the product's version moves past the badge, both halves are named, each with the badge's
# version and the product's.
test_a_version_moved_past_the_badge_names_both_halves() {
  SUB="Cargo.toml and Info.plist at 0.1.2"
  fixture
  write_versions 0.1.2 0.1.2
  run_check
  expect_status 1 || return 1
  expect_stdout_empty || return 1
  expect_letters "ii iii" "(ii) then (iii)" || return 1
  expect_each_line_names "$BADGE" || return 1
  expect_each_line_names "version 0.1.1," || return 1
  expect_each_line_names "0.1.2 in Cargo.toml and 0.1.2 in ka-reader-mac/Info.plist" || return 1
  SUB="Cargo.toml alone at 0.1.2"
  fixture
  write_versions 0.1.2 0.1.1
  run_check
  expect_status 1 || return 1
  expect_stdout_empty || return 1
  expect_letters "ii iii" "(ii) then (iii)" || return 1
  expect_each_line_names "0.1.2 in Cargo.toml and 0.1.1 in ka-reader-mac/Info.plist" || return 1
  SUB="Info.plist alone at 0.1.2"
  fixture
  write_versions 0.1.1 0.1.2
  run_check
  expect_status 1 || return 1
  expect_stdout_empty || return 1
  expect_letters "ii iii" "(ii) then (iii)" || return 1
  expect_each_line_names "0.1.1 in Cargo.toml and 0.1.2 in ka-reader-mac/Info.plist"
}

# A version this check cannot read names (v) once, and leaves the comparison undone.
test_an_unreadable_product_version_is_condition_v() {
  SUB="no version in Cargo.toml's [workspace.package] table"
  fixture
  printf '[workspace]\nmembers = []\n\n[workspace.package]\nedition = "2024"\n\n[workspace.lints.rust]\nversion = "0.1.1"\n' > "$tree/Cargo.toml"
  run_check
  expect_status 1 || return 1
  expect_one_condition v || return 1
  expect_line_names v "$BADGE" || return 1
  expect_line_names v "ka-reader-mac/Info.plist carries 0.1.1" || return 1
  SUB="no version key in Info.plist"
  fixture
  printf '<plist>\n<dict>\n  <key>CFBundleName</key>\n  <string>KA-Reader</string>\n</dict>\n</plist>\n' > "$tree/ka-reader-mac/Info.plist"
  run_check
  expect_status 1 || return 1
  expect_one_condition v || return 1
  expect_line_names v "$BADGE" || return 1
  expect_line_names v "Cargo.toml carries 0.1.1" || return 1
  SUB="neither version readable"
  fixture
  rm "${tree:?}/Cargo.toml" "${tree:?}/ka-reader-mac/Info.plist"
  run_check
  expect_status 1 || return 1
  expect_one_condition v || return 1
  expect_line_names v "$BADGE" || return 1
  expect_line_names v "neither Cargo.toml" || return 1
  # Both halves at a version the readable file does not carry: were (ii) or the version half of
  # (iii) evaluated, they would hold here.
  SUB="no version in Cargo.toml's [workspace.package] table, and both halves at 0.1.2"
  fixture
  printf '[workspace]\nmembers = []\n\n[workspace.package]\nedition = "2024"\n' > "$tree/Cargo.toml"
  write_readme "Release: 0.1.2"
  write_svg 0.1.2
  run_check
  expect_status 1 || return 1
  expect_one_condition v || return 1
  SUB="neither version readable, and the picture absent"
  fixture
  rm "${tree:?}/Cargo.toml" "${tree:?}/ka-reader-mac/Info.plist" "${tree:?}/$BADGE"
  run_check
  expect_status 1 || return 1
  expect_stdout_empty || return 1
  expect_letters "v iii" "(v) then (iii)"
}

# An unreadable README is (r), and (i) and (ii) are left unevaluated.
test_an_unreadable_readme_is_condition_r_not_a_pass() {
  SUB="README.md absent"
  fixture
  rm "${tree:?}/README.md"
  run_check
  expect_status 1 || return 1
  expect_one_condition r || return 1
  # A folder where the file should be, not a file made unreadable with chmod: root reads a file
  # whatever its mode, so a chmod case would hold only for whoever runs the suite.
  SUB="README.md present and not a file that can be read"
  fixture
  rm "${tree:?}/README.md"
  mkdir "$tree/README.md"
  run_check
  expect_status 1 || return 1
  expect_one_condition r || return 1
  # (r) leaves (i) and (ii) unevaluated, and (iii) is still evaluated.
  SUB="README.md absent, and the picture at 0.1.2"
  fixture
  rm "${tree:?}/README.md"
  write_svg 0.1.2
  run_check
  expect_status 1 || return 1
  expect_stdout_empty || return 1
  expect_letters "r iii" "(r) then (iii)"
}

# A wrong invocation is 2, with the usage line, before anything is read.
test_any_argument_is_a_usage_error_that_reads_nothing() {
  SUB="one argument"
  fixture
  run_check one
  expect_status 2 || return 1
  case "$stderr" in *"Usage: checks/readme-badge.sh"*) ;; *) fail "stderr carries no usage line. stderr: $stderr" || return 1;; esac
  expect_stdout_empty || return 1
  expect_tree_unchanged || return 1
  expect_git_untouched || return 1
  SUB="two arguments"
  fixture
  run_check one two
  expect_status 2 || return 1
  case "$stderr" in *"Usage: checks/readme-badge.sh"*) ;; *) fail "stderr carries no usage line. stderr: $stderr" || return 1;; esac
  expect_stdout_empty || return 1
  expect_tree_unchanged || return 1
  expect_git_untouched
}

# A signal ends the run with its own status, or with 1 where it lands inside a command substitution,
# and never with 0. The fixture's opening holds enough image lines to keep the awk pass running when
# the signal lands.
test_a_signal_never_ends_with_zero() {
  for signal in TERM:143 INT:130 HUP:129; do
    name="${signal%%:*}"
    allowed="${signal##*:}"
    SUB="$name"
    fixture
    {
      printf '# KA-Reader\n\n'
      awk 'BEGIN { for (i = 0; i < 400000; i++) print "![Licence: MIT](docs/readme/badges/licence.svg) ![Status: before 1.0.0](docs/readme/badges/status.svg)" }'
      printf '\n![Release: 0.1.1](%s)\n\n## Known gaps\n' "$BADGE"
    } > "$tree/README.md"
    # One simple command in the background, so $! is the script's own pid (env replaces itself with
    # it), and job control on, so the background job does not ignore INT.
    set -m
    /usr/bin/env -i PATH="$bin" "$tree/checks/readme-badge.sh" > "$scene/out" 2> "$scene/err" &
    pid=$!
    sleep 0.3
    if ! kill -0 "$pid" 2> /dev/null; then
      wait "$pid" 2> /dev/null
      set +m
      fail "the check had ended before $name was sent, so this run shows nothing about $name. Give the fixture's opening more image lines, then run checks/tests/test_readme_badge.sh again." || return 1
    fi
    kill -s "$name" "$pid" 2> /dev/null
    status=0
    wait "$pid" || status=$?
    set +m
    if [ "$status" -ne "$allowed" ] && [ "$status" -ne 1 ]; then
      fail "ended with $status, expected $allowed or 1, never 0" || return 1
    fi
  done
}

# The script's text, comments removed, holds no write.
test_the_check_holds_no_write() {
  [ -f "$CHECK" ] || fail "checks/readme-badge.sh is not there, so no scan for a write was made" || return 1
  source_text="$(sed '/^[[:space:]]*#/d' "$CHECK")"
  forbidden="$(printf '%s\n' "$source_text" | grep -E '(^|[[:space:];|])(curl|wget|ssh|scp|nc|touch|mktemp|mkdir|rm|mv|cp|tee|install|python3?|perl|ruby|eval)([[:space:];|]|$)|<<|system[[:space:]]*\(|ENVIRON|\$\{[A-Z_][A-Z_0-9]*[:-]' || true)"
  [ -z "$forbidden" ] || fail "checks/readme-badge.sh holds a write outside its comments: $forbidden" || return 1
  # Quoted text is dropped first, so the > of an <key> tag or of a message is no redirect.
  unquoted="$(printf '%s\n' "$source_text" | awk '{ out = ""; n = length($0)
    for (i = 1; i <= n; i++) { c = substr($0, i, 1)
      if (quote == "") { if (c == "\047" || c == "\"") quote = c; else out = out c }
      else if (c == "\\" && quote == "\"") i++
      else if (c == quote) quote = "" }
    print out }')"
  redirects="$(printf '%s\n' "$unquoted" | sed 's@> */dev/null@@g' | grep -E '>([[:space:]]+"?[$/.A-Za-z_]|"[$/.A-Za-z_]|[$/.])|>>' || true)"
  [ -z "$redirects" ] || fail "checks/readme-badge.sh holds a write outside its comments: $redirects"
}

# QC-67: the script reads no variable of its own from the environment.
test_the_check_reads_no_variable_of_its_own() {
  [ -f "$CHECK" ] || fail "checks/readme-badge.sh is not there, so no scan for a write was made" || return 1
  found="$(sed '/^[[:space:]]*#/d' "$CHECK" | grep -E 'ENVIRON|\$\{[A-Za-z_][A-Za-z_0-9]*:-' || true)"
  [ -z "$found" ] || fail "checks/readme-badge.sh reads a variable of its own from the environment, outside its comments: $found"
}

# The text between a script's two marker lines, the marker lines left out.
program_between() {
  sed -n "/^# $1: begin\$/,/^# $1: end\$/p" "$2" | sed '1d;$d'
}

# Both copies are the picture check's own programs, byte for byte, so the two checks agree on what an
# image is and on what the product's version is.
test_the_programs_are_the_picture_checks_own() {
  for marker in opening-images-program product-version-programs; do
    SUB="$marker"
    mine="$(program_between "$marker" "$CHECK")"
    [ -n "$mine" ] || fail "checks/readme-badge.sh holds no program between its $marker marker lines" || return 1
    theirs="$(program_between "$marker" "$PICTURE_CHECK")"
    [ -n "$theirs" ] || fail "checks/readme-picture.sh holds no program between its $marker marker lines" || return 1
    [ "$mine" = "$theirs" ] || fail "the program between the $marker marker lines of checks/readme-badge.sh is not byte-identical to the one in checks/readme-picture.sh. Copy it from checks/readme-picture.sh, then run checks/tests/test_readme_badge.sh again." || return 1
  done
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

# The suite is one fatal step of the gate, once, unconditional, after "README picture check suite"
# and before "Own state suite".
test_the_suite_is_one_fatal_step_of_the_gate() {
  gate_step_is_one_fatal_step "README badge check suite" "checks/tests/test_readme_badge.sh" "between:README picture check suite:Own state suite"
}

# The check is one fatal step of the gate, once, unconditional, directly before its suite.
test_the_check_is_one_fatal_step_before_its_suite() {
  gate_step_is_one_fatal_step "README badge check" "checks/readme-badge.sh" "directly_before:README badge check suite"
}

# --- the runner ---

WORK="$(mktemp -d)"
cleanup() {
  rm -rf "${WORK:?}"
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
