#!/usr/bin/env bash
# Version: 1.0.0 — real beta catalogue inputs, refusal paths and fatal gate wiring
# WHY THIS EXISTS
#   The catalogue inspection must finish its reads and compare the actual declaration, even
#   after another source file matches. Owned fixtures exercise the real command and whole suite.
# USAGE
#   checks/tests/test_git_beta.sh; no selection or input override.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
CHECK="$ROOT/checks/git-beta.sh"
HELPER="$ROOT/checks/support/git-beta-inputs.sh"
GATE="$ROOT/checks/gate.sh"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
WORDING='Beta first. Beta second.'
LABEL="The beta's Git view"
POLICY='ka-reader-mac/Sources/Surfaces/GitReadPolicy.swift'
CATALOGUE='ka-reader-mac/Sources/Surfaces/GitSentences.swift'
SURFACES='ka-reader-mac/Sources/Surfaces'
DIRECT="run_step 'Git beta catalogue check' 'checks/git-beta.sh'"
SUITE="run_step 'Git beta catalogue check suite' 'checks/tests/test_git_beta.sh'"
fail() { printf '  %s\n' "$*" >&2; return 1; }
equal() { [ "$1" = "$2" ] || fail "expected [$2], got [$1]"; }
contains() { case "$1" in *"$2"*) return 0;; *) fail "missing [$2] in [${1:0:500}]";; esac; }
snapshot() { (cd "$1" && find . -type f -exec shasum -a 256 {} \; | LC_ALL=C sort; find . -type l -exec readlink {} \; | LC_ALL=C sort); }
policy() { printf '%s\n' 'package nonisolated enum GitReadPolicy {' '    case atOpen, followed' "    package static let build: GitReadPolicy = .$1" '}' > "$tree/$POLICY"; }
catalogue() { printf '%s\n' 'package enum GitSentences {' "    package static let readAtOpen = \"$1\"" '}' > "$tree/$CATALOGUE"; }
content() { printf '### Standing sentences\n\n| What it states | The wording |\n|---|---|\n| %s (`source`) | **"%s"** Retirement annotation. |\n' "$LABEL" "$1" > "$tree/docs/CONTENT.md"; }
fixture() {
  scene="$(mktemp -d "$WORK/scene.XXXXXX")"; tree="$scene/tree"; bin="$scene/bin"
  mkdir -p "$tree/$SURFACES" "$tree/docs" "$bin"
  policy atOpen; catalogue "$WORDING"; content "$WORDING"
  local tool
  for tool in curl wget ssh scp nc ftp open swift rustc cargo xcrun; do
    printf '#!/usr/bin/env bash\nprintf "unexpected: %%s\\n" "$0" >> "$(dirname "$0")/audit"\nexit 17\n' > "$bin/$tool"
    chmod +x "$bin/$tool"
  done
}
wrap() {
  local tool="$1" real
  real="$(command -v "$tool")"
  printf '#!/usr/bin/env bash\n%s\nexec %q "$@"\n' "$2" "$real" > "$bin/$tool"
  chmod +x "$bin/$tool"
}
run_check() {
  local before after
  before="$(snapshot "$tree")"; status=0
  (cd "$tree" && PATH="$bin:$PATH" bash -c 'export TEST_BETA_SUBJECT_PID=$$; exec "$@"' subject "$CHECK" "$@") > "$scene/out" 2> "$scene/err" || status=$?
  out="$(cat "$scene/out")"; err="$(cat "$scene/err")"
  after="$(snapshot "$tree")"
  equal "$before" "$after" || return 1
  [ ! -f "$bin/audit" ] || fail "a forbidden command ran: $(cat "$bin/audit")"
}
pass() { run_check && equal "$status" 0 && equal "$out" '' && equal "$err" ''; }
refuse() {
  run_check || return 1
  equal "$status" 1 && equal "$out" '' && contains "$err" "$1" && contains "$err" 'run checks/git-beta.sh again from the KA-Reader folder.'
}
replace_file() { printf '%s\n' "$2" > "$tree/$1"; }

test_complete_catalogue_and_runtime_canonical_wording_pass() {
  fixture; pass || return 1
  printf '%s\n' 'package enum GitSentences {' '    package static let readAtOpen =' "        \"$WORDING\"" '}' > "$tree/$CATALOGUE"
  pass || return 1
  content 'Changed at runtime. Still whole.'
  printf '// Changed at runtime. Still whole.\n' > "$tree/$SURFACES/Unrelated.swift"
  refuse "doesn't match the complete beta statement" || return 1
  catalogue 'Changed at runtime. Still whole.'; pass
}
test_policy_is_one_live_declaration_in_its_named_type() {
  local source
  for source in '' '// package enum GitReadPolicy { static let build = .followed }' \
    'package enum Other { static let build = .followed }' \
    'package enum GitReadPolicy { static var build = .atOpen }' \
    'package enum GitReadPolicy { static let build = .unknown }' \
    'package enum GitReadPolicy { static let build = .atOpen; static let build = .followed }' \
    'package enum GitReadPolicy { static let build = choose() }' \
    'package enum GitReadPolicy { static let build =
.atOpen }' \
    'package enum GitReadPolicy { /* static let build = .atOpen */ }' \
    'package enum GitReadPolicy { enum Nested { static let build = .atOpen } }' \
    'package enum GitReadPolicy {
#if FLAG
static let build = .atOpen
#else
static let build = .followed
#endif
}'; do
    fixture; replace_file "$POLICY" "$source"
    refuse "Couldn't read one Git read policy from $POLICY." || return 1
  done
  fixture; rm "$tree/$POLICY"; refuse "Couldn't read $POLICY." || return 1
  fixture; wrap cat "case \"\$*\" in *GitReadPolicy.swift*) exit 17;; esac"
  refuse "Couldn't read $POLICY." || return 1
  fixture
  printf '%s\n' 'enum Other { static let build = .followed }' '/* outer /* nested */ static let build = .followed */' 'let rawExample = #"enum GitReadPolicy { static let build = .followed }"#' 'let multilineExample = """' 'enum GitReadPolicy { static let build = .followed }' '"""' >> "$tree/$POLICY"
  pass
}
test_required_beta_row_is_unique_complete_and_readable() {
  local mutation
  for mutation in missing_file empty no_table absent empty_row malformed duplicate; do
    fixture
    case "$mutation" in
      missing_file) rm "$tree/docs/CONTENT.md";;
      empty) : > "$tree/docs/CONTENT.md";;
      no_table) printf 'No standing table\n' > "$tree/docs/CONTENT.md";;
      absent) head -4 "$tree/docs/CONTENT.md" > "$scene/edited"; mv "$scene/edited" "$tree/docs/CONTENT.md";;
      empty_row) content '   ';;
      malformed) sed 's/"\*\*/BROKEN/' "$tree/docs/CONTENT.md" > "$scene/edited"; mv "$scene/edited" "$tree/docs/CONTENT.md";;
      duplicate) tail -1 "$tree/docs/CONTENT.md" >> "$tree/docs/CONTENT.md";;
    esac
    refuse 'docs/CONTENT.md' || return 1
  done
  fixture; wrap cat 'case "$*" in *docs/CONTENT.md*) exit 17;; esac'
  refuse "Couldn't read docs/CONTENT.md." || return 1
  fixture; policy followed
  head -4 "$tree/docs/CONTENT.md" > "$scene/edited"; mv "$scene/edited" "$tree/docs/CONTENT.md"
  pass || return 1
  content "$WORDING"; pass || return 1
  content 'Different whole statement.'; refuse "doesn't match" || return 1
  for mutation in docs/CONTENT.md "$CATALOGUE"; do
    fixture; policy followed; rm "$tree/$mutation"
    refuse "Couldn't read $mutation." || return 1
    fixture; policy followed
    wrap cat "case \"\$*\" in *'$mutation'*) exit 17;; esac"
    refuse "Couldn't read $mutation." || return 1
  done
  for mutation in empty malformed duplicate; do
    fixture; policy followed
    case "$mutation" in
      empty) content '';;
      malformed) sed 's/"\*\*/BROKEN/' "$tree/docs/CONTENT.md" > "$scene/edited"; mv "$scene/edited" "$tree/docs/CONTENT.md";;
      duplicate) tail -1 "$tree/docs/CONTENT.md" >> "$tree/docs/CONTENT.md";;
    esac
    refuse 'complete beta statement' || return 1
  done
}
test_only_the_real_complete_catalogue_literal_satisfies_the_check() {
  local source
  for source in '' \
    'enum GitSentences { static let other = "Beta first. Beta second." }' \
    '// enum GitSentences { static let readAtOpen = "Beta first. Beta second." }' \
    'enum Other { static let readAtOpen = "Beta first. Beta second." }' \
    'enum GitSentences { static let readAtOpen = "Beta first." }' \
    'enum GitSentences { static let readAtOpen = "Beta second." }' \
    'enum GitSentences { static let readAtOpen = "Changed wording." }' \
    'enum GitSentences { static let readAtOpen = "Beta first. " + "Beta second." }' \
    'enum GitSentences { static let readAtOpen = "Beta first. "
+ "Beta second." }' \
    'enum GitSentences { static let readAtOpen = "Beta first. \(value)" }' \
    'enum GitSentences { static let readAtOpen = #"Beta first. Beta second."# }' \
    'enum GitSentences { static let readAtOpen = """Beta first. Beta second.""" }' \
    'enum GitSentences { static let readAtOpen = "Beta first. Beta second."; static let readAtOpen = "Beta first. Beta second." }' \
    'enum GitSentences { enum Nested { static let readAtOpen = "Beta first. Beta second." } }'; do
    fixture; replace_file "$CATALOGUE" "$source"
    printf '// %s\n' "$WORDING" > "$tree/$SURFACES/Unrelated.swift"
    refuse "$CATALOGUE" || return 1
  done
  fixture; rm "$tree/$CATALOGUE"
  refuse "Couldn't read $CATALOGUE." || return 1
  fixture; wrap cat 'case "$*" in *GitSentences.swift*) exit 17;; esac'
  refuse "Couldn't read $CATALOGUE."
}
test_failed_recursive_read_after_a_match_refuses() {
  fixture
  wrap grep "\"$(command -v grep)\" \"\$@\"; exit 17"
  refuse "Couldn't finish inspecting $SURFACES." || return 1
  fixture; catalogue 'Wrong.'
  refuse "The complete beta statement wasn't found in $SURFACES." || return 1
  fixture; wrap awk 'printf "partial result\n"; exit 17'
  refuse "Couldn't finish inspecting $POLICY."
}
test_helper_load_is_inert_and_failures_return_to_the_caller() {
  fixture
  [ -x "$HELPER" ] || { fail 'the executable sourced helper is missing'; return 1; }
  local tool
  for tool in cat awk grep; do wrap "$tool" 'printf "I/O on load\n" >> "$(dirname "$0")/load-audit"; exit 17'; done
  status=0
  PATH="$bin:$PATH" bash -c '
    set -u
    trap : HUP
    before_options=$(set +o); before_traps=$(trap -p)
    . "$1"
    [ "$before_options" = "$(set +o)" ] && [ "$before_traps" = "$(trap -p)" ] || exit 18
    [ ! -e "$2/load-audit" ] || exit 19
    result=0; beta_load_policy "$3/missing.swift" || result=$?
    [ "$result" -ne 0 ] || exit 20
    printf "returned; caller continued\n"
  ' wrapper "$HELPER" "$bin" "$tree" > "$scene/out" 2> "$scene/err" || status=$?
  equal "$status" 0 && equal "$(cat "$scene/out")" 'returned; caller continued' && equal "$(cat "$scene/err")" ''
}
test_catalogue_statuses_signals_and_inputs_are_preserved() {
  local signal
  fixture; pass || return 1
  catalogue Wrong; refuse 'complete beta statement' || return 1
  fixture
  for signal in cat awk grep; do wrap "$signal" 'printf "input-read\n" >&2; exit 17'; done
  run_check wrong another || return 1
  equal "$status" 2 && equal "$out" '' && equal "$err" 'Usage: checks/git-beta.sh' || return 1
  for signal in HUP INT TERM; do
    fixture; wrap cat "kill -$signal \"\$TEST_BETA_SUBJECT_PID\"; exit 17"
    run_check || return 1
    equal "$status" 1 && equal "$out" '' && contains "$err" 'The wording check was interrupted while inspecting' && contains "$err" 'Run checks/git-beta.sh again from the KA-Reader folder.' || { fail "signal case: $signal"; return 1; }
  done
}

gate_shape() {
  local text calls
  text="$(cat "$1")"; calls="$(printf '%s\n' "$text" | grep '^run_step ' || true)"
  equal "$(printf '%s\n' "$calls" | grep -Fxc "$DIRECT")" 1 || return 1
  equal "$(printf '%s\n' "$calls" | grep -Fxc "$SUITE")" 1 || return 1
  printf '%s\n' "$calls" | awk -v direct="$DIRECT" -v suite="$SUITE" '
    $0 == "run_step '\''README check'\'' '\''checks/readme.sh'\''" { a=NR }
    $0 == "run_step '\''README check suite'\'' '\''checks/tests/test_readme.sh'\''" { b=NR }
    $0 == direct { c=NR } $0 == suite { d=NR }
    /run_step '\''Release workflow shape'\'' / { e=NR }
    END {exit !(a && b==a+1 && c==b+1 && d==c+1 && e==d+1)}
  ' || return 1
  ! printf '%s\n' "$text" | grep -E '^(if |fi$|false|exit 0)' > /dev/null
}
gate_fixture() {
  gate_shape "$GATE" || { fail 'the real gate pair is missing, bypassed or out of order'; return 1; }
  fixture
  mkdir -p "$tree/checks/tests" "$tree/checks/support" "$tree/ka-reader-mac"
  cp "$GATE" "$tree/checks/gate.sh"
  : > "$bin/gate-trace"
  local call command path tool
  while IFS= read -r call; do
    command="${call#*\' \'}"; command="${command%\'}"; path="${command%% *}"
    case "$path" in checks/*|ka-reader-mac/*)
      mkdir -p "$tree/$(dirname "$path")"
      printf '#!/usr/bin/env bash\nprintf "%%s\\n" "%s" >> "%s"\n' "$path" "$bin/gate-trace" > "$tree/$path"; chmod +x "$tree/$path";;
    esac
  done < <(grep '^run_step ' "$GATE")
  cp "$CHECK" "$tree/checks/git-beta.sh"; cp "$HELPER" "$tree/checks/support/git-beta-inputs.sh"
  printf '#!/usr/bin/env bash\nprintf "checks/tests/test_git_beta.sh\\n" >> "%s"\nexit "${GIT_BETA_SUITE_STATUS:-0}"\n' "$bin/gate-trace" > "$tree/checks/tests/test_git_beta.sh"
  chmod +x "$tree/checks/tests/test_git_beta.sh"
  for tool in swift xcrun cargo rustc; do
    printf '#!/usr/bin/env bash\nprintf "tool: %%s\\n" "$0" >> "%s"\n[ "$*" != -vV ] || printf "host: fixture-triple\\n"\nexit 0\n' "$bin/gate-trace" > "$bin/$tool"; chmod +x "$bin/$tool"
  done
}
run_gate() {
  local before after
  before="$(snapshot "$tree")"
  status=0
  (cd "$tree" && PATH="$bin:$PATH" bash checks/gate.sh) > "$scene/out" 2> "$scene/err" || status=$?
  out="$(cat "$scene/out")"; err="$(cat "$scene/err")"; trace="$(cat "$bin/gate-trace")"
  after="$(snapshot "$tree")"
  equal "$before" "$after"
}
test_catalogue_gate_pair_is_unique_unconditional_and_fatal() {
  gate_fixture || return 1; run_gate
  equal "$status" 0 && contains "$trace" 'checks/tests/test_git_beta.sh' || return 1
  gate_fixture || return 1; policy unknown; run_gate
  equal "$status" 1 && contains "$err" 'step failed: Git beta catalogue check' || return 1
  case "$trace" in *checks/tests/test_git_beta.sh*|*checks/release-shape.sh*) return 1;; esac
  gate_fixture || return 1; GIT_BETA_SUITE_STATUS=17 run_gate
  equal "$status" 1 && contains "$err" 'step failed: Git beta catalogue check suite' || return 1
  case "$trace" in *checks/release-shape.sh*) return 1;; esac
  local target mutation
  for target in "$DIRECT" "$SUITE"; do
    for mutation in delete comment duplicate filtered bypass; do
      fixture
      awk -v target="$target" -v mutation="$mutation" '$0==target {
        if(mutation=="delete")next
        if(mutation=="comment"){print "# " $0;next}
        if(mutation=="duplicate")print
        if(mutation=="filtered"){print $0 " --filter selected";next}
        if(mutation=="bypass"){print "if false; then";print;print "fi";next}
      } {print}' "$GATE" > "$scene/mutated"
      if gate_shape "$scene/mutated" > /dev/null 2>&1; then fail "$mutation passed"; return 1; fi
    done
  done
}
test_catalogue_gate_ignores_inherited_input_substitutes() {
  gate_fixture || return 1; policy unknown
  KA_READER_GIT_POLICY=followed GIT_READ_POLICY=followed MODE=followed CONTENT=/elsewhere CATALOGUE=/elsewhere KA_READER_TEST_ONLY=test_complete_catalogue_and_runtime_canonical_wording_pass run_gate
  equal "$status" 1 && contains "$err" "Couldn't read one Git read policy" && contains "$err" 'step failed: Git beta catalogue check'
}
test_gate_executes_the_actual_entire_catalogue_suite() {
  gate_fixture || return 1
  local child="$scene/child"
  mkdir -p "$child/checks/tests" "$child/checks/support"
  cp "$ROOT/checks/tests/test_git_beta.sh" "$child/checks/tests/test_git_beta.sh"
  cp "$CHECK" "$child/checks/git-beta.sh"; cp "$HELPER" "$child/checks/support/git-beta-inputs.sh"
  printf '#!/usr/bin/env bash\nexit 0\n' > "$child/checks/gate.sh"
  cmp -s "$ROOT/checks/tests/test_git_beta.sh" "$child/checks/tests/test_git_beta.sh" || return 1
  printf '#!/usr/bin/env bash\nexec %q "$@"\n' "$child/checks/tests/test_git_beta.sh" > "$tree/checks/tests/test_git_beta.sh"
  KA_READER_TEST_ONLY=test_complete_catalogue_and_runtime_canonical_wording_pass run_gate
  equal "$status" 1 && contains "$err" 'step failed: Git beta catalogue check suite' || return 1
  contains "$out" 'ok   test_complete_catalogue_and_runtime_canonical_wording_pass' && contains "$out" 'FAIL test_catalogue_gate_pair_is_unique_unconditional_and_fatal' || return 1
  case "$trace" in *checks/release-shape.sh*) return 1;; esac
}
CASES='test_complete_catalogue_and_runtime_canonical_wording_pass test_policy_is_one_live_declaration_in_its_named_type test_required_beta_row_is_unique_complete_and_readable test_only_the_real_complete_catalogue_literal_satisfies_the_check test_failed_recursive_read_after_a_match_refuses test_helper_load_is_inert_and_failures_return_to_the_caller test_catalogue_statuses_signals_and_inputs_are_preserved test_catalogue_gate_pair_is_unique_unconditional_and_fatal test_catalogue_gate_ignores_inherited_input_substitutes test_gate_executes_the_actual_entire_catalogue_suite'
passed=0; total=0
for test in $CASES; do
  total=$((total + 1))
  if ( "$test" ); then printf 'ok   %s\n' "$test"; passed=$((passed + 1)); else printf 'FAIL %s\n' "$test"; fi
done
printf '%s of %s passed\n' "$passed" "$total"
[ "$passed" -eq "$total" ]
