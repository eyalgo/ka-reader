#!/usr/bin/env bash
# Version: 1.0.0 — the README check's disposable entry-point and gate proofs
#
# WHY THIS EXISTS
#   Literal paragraphs, image sources and fatal gate wiring have different failure boundaries
#   (docs/nfdr.md QC-44, QC-64, QC-67, QC-70). Each case enters the real command in an owned
#   tree; PATH supplies only the index and controlled failures. No app, build or remote runs.
# USAGE
#   checks/tests/test_readme.sh; KA_READER_TEST_ONLY selects one named case during development.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
CHECK="$ROOT/checks/readme.sh"
GATE="$ROOT/checks/gate.sh"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
TAB=$'\t'
WORDS=('Read-only first. Read-only second.' 'Network first. Network second.' 'Before first. Before second.' 'Support first. Support second. Support third.' 'Archiving first. Archiving second.' 'Accessibility first. Accessibility second. Accessibility third.')
LABELS=("Read-only — the product's defining promise" 'The network' 'Before 1.0.0' 'The support posture' 'Archiving' 'The accessibility posture, on the README below its first screen')
fail() { printf '  %s\n' "$*" >&2; return 1; }
equal() { [ "$1" = "$2" ] || fail "expected [$2], got [$1]"; }
contains() { case "$1" in *"$2"*) return 0;; *) fail "missing [$2] in [$1]";; esac; }
fixture() {
  [ -x "$CHECK" ] || { fail 'the executable checks/readme.sh is missing'; return 1; }
  scene="$(mktemp -d "$WORK/scene.XXXXXX")"
  tree="$scene/tree"; bin="$scene/bin"; scratch="$scene/scratch"
  mkdir -p "$tree/docs" "$tree/images" "$bin" "$scratch"
  printf '### Standing sentences\n\n| What it states | The wording |\n|---|---|\n' > "$tree/docs/CONTENT.md"
  for ((i=0; i<6; i++)); do
    printf '| %s (`source`) | **"%s"** Retirement annotation. |\n' "${LABELS[$i]}" "${WORDS[$i]}" >> "$tree/docs/CONTENT.md"
  done
  printf '%s\n' "${WORDS[@]}" > "$tree/README.md"
  printf '%s\n' "${WORDS[3]}" > "$tree/SECURITY.md"
  printf 'README.md\nSECURITY.md\ndocs/CONTENT.md\nimages/shell.png\nimages/space name.png\nimages/café.png\nimages/a#.png\nimages/a&b.png\n' > "$bin/tracked"
  printf 'image fixture\n' > "$tree/images/shell.png"
  cp "$tree/images/shell.png" "$tree/images/space name.png"
  cp "$tree/images/shell.png" "$tree/images/café.png"
  cp "$tree/images/shell.png" "$tree/images/a#.png"
  cp "$tree/images/shell.png" "$tree/images/a&b.png"
  cat > "$bin/git" <<'GIT'
#!/usr/bin/env bash
set -euo pipefail
d="$(dirname "$0")"
if [ "$*" != 'ls-files --cached -z' ]; then printf 'mutating-or-unexpected git: %s\n' "$*" >> "$d/audit"; exit 17; fi
if [ -f "$d/gate-trace" ]; then printf 'README inspection\n' >> "$d/gate-trace"; fi
while IFS= read -r name; do printf '%s\0' "$name"; done < "$d/tracked"
GIT
  chmod +x "$bin/git"
  for tool in curl wget ssh scp nc ftp open; do
    printf '#!/usr/bin/env bash\nprintf "outbound: %%s\\n" "$0" >> "$(dirname "$0")/audit"\nexit 17\n' > "$bin/$tool"
    chmod +x "$bin/$tool"
  done
}
run_check() {
  status=0
  (cd "$tree" && PATH="$bin:$PATH" TMPDIR="$scratch" "$CHECK" "$@") > "$scene/out" 2> "$scene/err" || status=$?
  out="$(cat "$scene/out")"; err="$(cat "$scene/err")"
  [ ! -f "$bin/audit" ] || fail "a forbidden command ran: $(cat "$bin/audit")"
}
pass() { run_check; equal "$status" 0 && equal "$out" '' && equal "$err" ''; }
refuse() { run_check; equal "$status" 1 && equal "$out" '' && contains "$err" "$1"; }
missing() { printf 'readme.sh: %s: missing standing sentence: %s' "$1" "$2"; }
remove_word() {
  awk -v n="$2" 'NR != n' "$tree/$1" > "$scene/edited"
  mv "$scene/edited" "$tree/$1"
}
image() { printf '\n%s\n' "$1" >> "$tree/README.md"; }
wrap_failure() {
  local tool="$1" body="$2" real
  real="$(command -v "$tool")"
  printf '#!/usr/bin/env bash\n%s\nexec %q "$@"\n' "$body" "$real" > "$bin/$tool"
  chmod +x "$bin/$tool"
}
snapshot() {
  (cd "$1" && find . -type f -exec shasum -a 256 {} \; | LC_ALL=C sort; find . -type l -exec readlink {} \; | LC_ALL=C sort)
}

test_complete_wordings_and_no_images_pass() { fixture && pass; }
test_emphasis_around_a_whole_wording_passes() {
  fixture || return 1
  printf '**%s**\n' "${WORDS[@]}" > "$tree/README.md"
  pass
}
test_canonical_wording_is_read_at_runtime() {
  fixture || return 1
  for file in docs/CONTENT.md README.md SECURITY.md; do
    sed 's/Support second/Changed at runtime/g' "$tree/$file" > "$scene/edited"
    mv "$scene/edited" "$tree/$file"
  done
  pass
}
test_each_missing_or_paraphrased_wording_is_named_whole() {
  local row file variant
  for row in 0 1 2 3 4 5 6; do
    for variant in missing paraphrased; do
      fixture || return 1
      file=README.md; [ "$row" -ne 6 ] || file=SECURITY.md
      index="$row"; [ "$row" -ne 6 ] || index=3
      remove_word "$file" "$((index + 1))"
      [ "$file" != SECURITY.md ] || : > "$tree/SECURITY.md"
      [ "$variant" != paraphrased ] || printf 'A paraphrase of %s\n' "${LABELS[$index]}" >> "$tree/$file"
      run_check || return 1
      equal "$status" 1 && equal "$out" '' && equal "$err" "$(missing "$file" "${WORDS[$index]}")" || return 1
    done
  done
}
test_partial_or_line_broken_wording_fails() {
  local row file boundary prefix suffix
  for row in 0 1 2 3 4 5 6; do
    index="$row"; file=README.md
    if [ "$row" -eq 6 ]; then index=3; file=SECURITY.md; fi
    for boundary in 1 2; do
      case "${WORDS[$index]}" in *third*) ;; *) [ "$boundary" -eq 1 ] || continue;; esac
      fixture || return 1
      prefix="$(printf '%s\n' "${WORDS[$index]}" | cut -d. -f1-"$boundary")."
      remove_word "$file" "$((index+1))"
      [ "$file" != SECURITY.md ] || : > "$tree/$file"
      printf '%s\n' "$prefix" >> "$tree/$file"
      refuse "$(missing "$file" "${WORDS[$index]}")" || return 1
    done
    fixture || return 1
    remove_word "$file" "$((index+1))"
    [ "$file" != SECURITY.md ] || : > "$tree/$file"
    printf '%s\n' "${WORDS[$index]}" | sed 's/ first/\nfirst/' >> "$tree/$file"
    refuse "$(missing "$file" "${WORDS[$index]}")" || return 1
  done
}
test_findings_follow_table_order_then_file_order() {
  fixture || return 1
  printf '%s\n' "${WORDS[0]}" "${WORDS[2]}" "${WORDS[3]}" "${WORDS[5]}" > "$tree/README.md"
  : > "$tree/SECURITY.md"
  run_check || return 1
  expected="$(missing README.md "${WORDS[1]}")
$(missing SECURITY.md "${WORDS[3]}")
$(missing README.md "${WORDS[4]}")"
  equal "$status" 1 && equal "$err" "$expected" || return 1
  fixture || return 1
  : > "$tree/README.md"; : > "$tree/SECURITY.md"
  { head -4 "$tree/docs/CONTENT.md"; tail -6 "$tree/docs/CONTENT.md" | sort -r; } > "$scene/reordered"
  mv "$scene/reordered" "$tree/docs/CONTENT.md"
  expected=''
  while IFS= read -r line; do
    case "$line" in '| '*\*\*\"*)
      wording="${line#*\*\*\"}"; wording="${wording%%\"\*\**}"
      expected="$expected$(missing README.md "$wording")
"
      case "$line" in '| The support posture '*) expected="$expected$(missing SECURITY.md "$wording")
";; esac;;
    esac
  done < "$tree/docs/CONTENT.md"
  run_check || return 1
  equal "$status" 1 && equal "$err" "${expected%$'\n'}"
}
test_unavailable_document_or_canonical_set_is_a_refusal() {
  local file kind row
  for file in README.md SECURITY.md docs/CONTENT.md; do
    fixture || return 1; rm "$tree/$file"
    refuse "$file: cannot read required input" || return 1
    fixture || return 1
    wrap_failure cat "case \"\$*\" in *'$file'*) exit 9;; esac"
    refuse "$file: cannot read required input" || return 1
  done
  fixture || return 1
  printf 'No table here\n' > "$tree/docs/CONTENT.md"
  refuse 'no standing-sentences table was found' || return 1
  for row in 0 1 2 3 4 5; do
    for kind in missing duplicate empty malformed; do
      fixture || return 1
      line="$((row+5))"
      case "$kind" in
        missing) remove_word docs/CONTENT.md "$line";;
        duplicate) sed -n "${line}p" "$tree/docs/CONTENT.md" >> "$tree/docs/CONTENT.md";;
        empty) sed "${line}s/\*\*\".*\"\*\*/**\"\"**/" "$tree/docs/CONTENT.md" > "$scene/edited"; mv "$scene/edited" "$tree/docs/CONTENT.md";;
        malformed) sed "${line}s/\"\*\*/BROKEN/" "$tree/docs/CONTENT.md" > "$scene/edited"; mv "$scene/edited" "$tree/docs/CONTENT.md";;
      esac
      refuse 'readme.sh: docs/CONTENT.md:' || return 1
      contains "$err" "${LABELS[$row]}" || return 1
    done
  done
}
test_failed_inspection_cannot_become_a_pass() {
  local tool body
  for tool in grep awk git; do
    fixture || return 1
    wrap_failure "$tool" 'printf "partial matching bytes\n"; exit 17'
    refuse 'readme.sh:' || return 1
  done
  fixture || return 1
  wrap_failure grep "\"$(command -v grep)\" \"\$@\"; exit 17"
  refuse 'could not complete the standing-sentence comparison'
}
test_present_tracked_local_images_pass_in_every_form() {
  fixture || return 1
  image '![inline](images/shell.png "a title")
![angle](<images/space name.png> "title")
![escaped](images/space\ name.png)
![full][later]
![collapsed][]
![shortcut]
[later]: images/shell.png "title"
[collapsed]: <images/space name.png>
[shortcut]: images/shell.png
<img
 src="images/shell.png?size=2#top"
 srcset="images/shell.png 1x, images/space%20name.png 2x">
<picture><source srcset="images/shell.png 1x, images/caf%C3%A9.png 2x"><img src="images/a%23.png"></picture>
<img src="images/a&amp;b.png">'
  pass
}
test_every_remote_primary_and_alternate_is_named() {
  local address form
  for address in http://images.example/a.png https://images.example/a.png //images.example/a.png HtTpS://images.example/a.png '%68ttps%3A%2F%2Fimages.example/a.png' 'https&#58;//images.example/a.png'; do
    for form in inline full collapsed shortcut img srcset picture; do
      fixture || return 1
      case "$form" in
        inline) image "![a]($address)";;
        full) image "![a][r]
[r]: $address";;
        collapsed) image "![r][]
[r]: $address";;
        shortcut) image "![r]
[r]: $address";;
        img) image "<IMG SRC='$address'>";;
        srcset) image "<img src='images/shell.png' srcset='images/shell.png 1x, $address 2x'>";;
        picture) image "<picture><source srcset='$address 1x'><img src='images/shell.png'></picture>";;
      esac
      refuse "$address" || return 1
    done
  done
  fixture || return 1
  image '<img src="https://one.example/a" srcset="https://two.example/b 1x, //three.example/c 2x">'
  run_check || return 1
  equal "$status" 1 && contains "$err" 'https://one.example/a' && contains "$err" 'https://two.example/b' && contains "$err" '//three.example/c'
}
test_nonrepository_image_sources_are_refused() {
  local address
  for address in 'data:image/png;base64,AAAA' /tmp/image.png ../outside.png '%2e%2e/outside.png' images/missing.png images/untracked.png images images/outward.png outside-dir/image.png; do
    fixture || return 1
    printf outside > "$scene/outside.png"
    printf untracked > "$tree/images/untracked.png"
    ln -s "$scene/outside.png" "$tree/images/outward.png"
    ln -s "$scene" "$tree/outside-dir"
    printf 'images/outward.png\noutside-dir/image.png\nimages\n' >> "$bin/tracked"
    image "![a]($address)"
    refuse "$address" || return 1
  done
  fixture || return 1
  image '![missing][not-defined]'
  refuse 'image reference has no definition: ![missing][not-defined]' || return 1
  fixture || return 1
  ln -s shell.png "$tree/images/inside.png"
  printf 'images/inside.png\n' >> "$bin/tracked"
  image '![inside](images/inside.png)'; pass || return 1
  sed '/images\/inside.png/d' "$bin/tracked" > "$scene/edited"; mv "$scene/edited" "$bin/tracked"
  refuse 'images/inside.png' || return 1
  fixture || return 1
  ln -s shell.png "$tree/images/inside.png"
  printf 'images/inside.png\n' >> "$bin/tracked"
  image '![inside](images/inside.png)'
  wrap_failure readlink 'exit 17'
  refuse 'could not inspect image source'
}
test_nondisplaying_examples_do_not_hide_later_images() {
  local example
  for example in '[ordinary](https://images.example/a)' '`![code](https://images.example/a)`' '``![code](https://images.example/a)``' '```
![code](https://images.example/a)
```' '~~~markdown
![code](https://images.example/a)
~~~' '    ![code](https://images.example/a)' '\![escaped](https://images.example/a)' '<!--
<img src="https://images.example/a">
-->'; do
    fixture || return 1; image "$example"; pass || return 1
    image '![real](https://after.example/image.png)'
    refuse 'https://after.example/image.png' || return 1
    case "$err" in *'https://images.example/a'*) fail 'an excluded example was inspected'; return 1;; esac
  done
}
test_usage_and_all_outcomes_leave_inputs_unchanged() {
  local outcome before after
  for outcome in pass missing remote unavailable one several; do
    fixture || return 1
    case "$outcome" in missing) remove_word README.md 1;; remote) image '![a](https://remote.example/a)';; unavailable) rm "$tree/README.md";; esac
    before="$(snapshot "$tree"; snapshot "$bin"; snapshot "$scratch")"
    case "$outcome" in one) run_check x;; several) run_check x y;; *) run_check;; esac
    after="$(snapshot "$tree"; snapshot "$bin"; snapshot "$scratch")"
    equal "$before" "$after" || return 1
    case "$outcome" in pass) equal "$status" 0;; missing|remote|unavailable) equal "$status" 1;; *) equal "$status" 2 && equal "$out" '' && equal "$err" 'Usage: checks/readme.sh';; esac || return 1
  done
}
test_wrong_arguments_read_nothing() {
  fixture || return 1
  for tool in cat awk grep git; do wrap_failure "$tool" 'printf "input-read\n" >&2; exit 17'; done
  # The harness reads its own capture files after the subject has exited, outside the subject PATH.
  run_check wrong another || return 1
  equal "$status" 2 && equal "$out" '' && equal "$err" 'Usage: checks/readme.sh'
}
test_signals_never_end_with_success() {
  local signal tool
  for signal in HUP INT TERM; do
    for tool in cat grep awk git; do
      fixture || return 1
      wrap_failure "$tool" "kill -$signal \"\$PPID\"; exit 17"
      run_check || return 1
      case "$signal:$status" in HUP:1|HUP:129|INT:1|INT:130|TERM:1|TERM:143) ;; *) fail "$signal during $tool returned $status"; return 1;; esac
      [ -n "$err" ] || { fail 'an interruption was not reported'; return 1; }
    done
  done
}
test_readme_commands_have_no_write_or_environment_escape() {
  [ -x "$CHECK" ] && [ -x "$ROOT/checks/tests/test_readme.sh" ] || return 1
  bash -n "$CHECK" && bash -n "$ROOT/checks/tests/test_readme.sh" || return 1
  source_text="$(sed '/^[[:space:]]*#/d' "$CHECK")"
  forbidden="$(printf '%s\n' "$source_text" | grep -nE '(^|[[:space:];|])(curl|wget|ssh|scp|nc|touch|mktemp|mkdir|rm|mv|cp|tee|install|python3?|perl|ruby|eval)([[:space:];|]|$)|<<|system[[:space:]]*\(|ENVIRON|\$\{[A-Z_][A-Z_0-9]*[:-]' || true)"
  equal "$forbidden" '' || return 1
  redirects="$(printf '%s\n' "$source_text" | sed 's@> */dev/null@@g' | grep -nE '>[[:space:]]*["$./]|>>' || true)"
  equal "$redirects" ''
}

# The baseline is data, not a historical Git read. It is filled from the reviewed pre-change calls.
BASE_CALLS='run_step '"'"'Toolchain'"'"' '"'"'swift --version && xcrun --show-sdk-version'"'"'
run_step '"'"'Secret scan suite'"'"' '"'"'checks/tests/test_secret_scan.sh'"'"'
run_step '"'"'Secret scan'"'"' '"'"'checks/secret-scan.sh gitleaks git'"'"'
run_step '"'"'Build the workspace'"'"' '"'"'cargo build --workspace --locked'"'"'
run_step '"'"'Planted secret suite'"'"' '"'"'checks/tests/test_secret_scan_planted.sh'"'"'
run_step '"'"'Build KA-Reader.app'"'"' '"'"'ka-reader-mac/assemble.sh'"'"'
run_step '"'"'Test gate'"'"' '"'"'cargo test --workspace --locked && swift test --package-path ka-reader-mac'"'"'
run_step '"'"'Bridge tests under the address sanitizer'"'"' '"'"'set -o pipefail && export RUSTUP_AUTO_INSTALL=1 RUSTUP_TOOLCHAIN=nightly-2026-10-21 && rustc -V && T=$(rustc -vV | sed -n "s/^host: //p") && F="\"-Zsanitizer=address\",\"-Cllvm-args=-asan-globals=0\"" && cargo test --locked -p ka-reader-bridge --config "build.target=\"$T\"" --config "target.$T.rustflags=[$F]" --config "build.rustdocflags=[$F]"'"'"'
run_step '"'"'Structure check'"'"' '"'"'checks/structure.sh'"'"'
run_step '"'"'Structure check suite'"'"' '"'"'checks/tests/test_structure.sh'"'"'
run_step '"'"'Entry-points check'"'"' '"'"'checks/entry-points.sh'"'"'
run_step '"'"'Entry-points check suite'"'"' '"'"'checks/tests/test_entry_points.sh'"'"'
run_step '"'"'Bundle probe'"'"' '"'"'checks/bundle.sh target/release/bundle/macos/KA-Reader.app'"'"'
run_step '"'"'Bundle probe suite'"'"' '"'"'checks/tests/test_bundle.sh'"'"'
run_step '"'"'View check'"'"' '"'"'checks/view.sh'"'"'
run_step '"'"'View check suite'"'"' '"'"'checks/tests/test_view.sh'"'"'
run_step '"'"'Renderer gate'"'"' '"'"'checks/renderer.sh target/release/bundle/macos/KA-Reader.app'"'"'
run_step '"'"'Renderer gate suite'"'"' '"'"'checks/tests/test_renderer.sh'"'"'
run_step '"'"'Read-only, plain folder'"'"' '"'"'checks/read-only.sh checks/fixtures/plain'"'"'
run_step '"'"'Read-only, repository'"'"' '"'"'checks/read-only.sh checks/fixtures/repo'"'"'
run_step '"'"'Read-only, submodule'"'"' '"'"'checks/read-only.sh checks/fixtures/submodule'"'"'
run_step '"'"'Read-only, tree scene'"'"' '"'"'checks/read-only.sh checks/fixtures/tree-scene'"'"'
run_step '"'"'Read-only, tree scene, killed'"'"' '"'"'checks/read-only.sh --kill checks/fixtures/tree-scene'"'"'
run_step '"'"'Displayed-file scene'"'"' '"'"'cargo test --locked -p ka-reader-bridge --test open_file_scene'"'"'
run_step '"'"'Read-only, displayed-file scene'"'"' '"'"'checks/read-only.sh checks/fixtures/open-file-scene'"'"'
run_step '"'"'Read-only suite'"'"' '"'"'checks/tests/test_read_only.sh'"'"'
run_step '"'"'No-network dependency list'"'"' '"'"'checks/no-network.sh'"'"'
run_step '"'"'No-network suite'"'"' '"'"'checks/tests/test_no_network.sh'"'"'
run_step '"'"'Notices check'"'"' '"'"'checks/notices.sh'"'"'
run_step '"'"'Notices check suite'"'"' '"'"'checks/tests/test_notices.sh'"'"'
run_step '"'"'Offline page, repository'"'"' '"'"'checks/offline-page.sh checks/fixtures/repo'"'"'
run_step '"'"'Offline page suite'"'"' '"'"'checks/tests/test_offline_page.sh'"'"'
run_step '"'"'Strings check'"'"' '"'"'checks/strings.sh'"'"'
run_step '"'"'Strings check suite'"'"' '"'"'checks/tests/test_strings.sh'"'"'
run_step '"'"'Strings check step suite'"'"' '"'"'checks/tests/test_strings_step.sh'"'"'
run_step '"'"'Release workflow shape'"'"' '"'"'checks/release-shape.sh .github/workflows/release.yml'"'"'
run_step '"'"'Release workflow shape suite'"'"' '"'"'checks/tests/test_release_shape.sh'"'"'
run_step '"'"'Release version suite'"'"' '"'"'checks/tests/test_release_version.sh'"'"'
run_step '"'"'Release image suite'"'"' '"'"'checks/tests/test_release_pack.sh'"'"'
run_step '"'"'Release checksum suite'"'"' '"'"'checks/tests/test_release_sums.sh'"'"'
run_step '"'"'Release absent suite'"'"' '"'"'checks/tests/test_release_absent.sh'"'"'
run_step '"'"'Own state suite'"'"' '"'"'checks/tests/test_own_state.sh'"'"'
run_step '"'"'VM refusal suite'"'"' '"'"'checks/tests/test_vm_refusal.sh'"'"'
run_step '"'"'Launch step suite'"'"' '"'"'checks/tests/test_launch.sh'"'"'
run_step '"'"'Own state step suite'"'"' '"'"'checks/tests/test_own_state_step.sh'"'"'
run_step '"'"'Tree scene helper suite'"'"' '"'"'checks/tests/test_tree_scene.sh'"'"'
run_step '"'"'Launch the built bundle'"'"' '"'"'checks/launch.sh'"'"'
run_step '"'"'Own state'"'"' '"'"'checks/own-state-step.sh'"'"''
DIRECT="run_step 'README check' 'checks/readme.sh'"
SUITE="run_step 'README check suite' 'checks/tests/test_readme.sh'"
gate_shape() {
  local text lines
  text="$(cat "$1")"
  lines="$(printf '%s\n' "$text" | grep '^run_step ' || true)"
  [ "$(printf '%s\n' "$lines" | grep -Fxc "$DIRECT")" -eq 1 ] || return 1
  [ "$(printf '%s\n' "$lines" | grep -Fxc "$SUITE")" -eq 1 ] || return 1
  printf '%s\n' "$lines" | awk -v direct="$DIRECT" -v suite="$SUITE" '
    $0 == "run_step '\''Strings check step suite'\'' '\''checks/tests/test_strings_step.sh'\''" { a=NR }
    $0 == direct { b=NR }
    $0 == suite { c=NR }
    $0 == "run_step '\''Release workflow shape'\'' '\''.github/workflows/release.yml'\''" { unused=NR }
    /run_step '\''Release workflow shape'\'' / { d=NR }
    END { exit !(a && b==a+1 && c==b+1 && d==c+1) }
  ' || return 1
  # A bypass still has exact call lines, so structure alone cannot certify it.
  ! printf '%s\n' "$text" | grep -E '^(if |fi$|false|exit 0)' > /dev/null
}
gate_fixture() {
  fixture || return 1
  mkdir -p "$tree/checks/tests" "$tree/ka-reader-mac"
  cp "$GATE" "$tree/checks/gate.sh"
  cp "$CHECK" "$tree/checks/readme.sh"
  : > "$bin/gate-trace"
  # Literal script paths get disposable executables. Toolchain commands arrive through PATH.
  while IFS= read -r call; do
    command="${call#*\' \'}"; command="${command%\'}"
    path="${command%% *}"
    case "$path" in checks/*|ka-reader-mac/*)
      mkdir -p "$tree/$(dirname "$path")"
      printf '#!/usr/bin/env bash\nprintf "%%s\\n" "%s" >> "%s"\n' "$path" "$bin/gate-trace" > "$tree/$path"
      chmod +x "$tree/$path";;
    esac
  done < <(printf '%s\n' "$BASE_CALLS")
  printf '#!/usr/bin/env bash\nprintf "checks/tests/test_readme.sh\\n" >> "%s"\nexit "${README_SUITE_STATUS:-0}"\n' "$bin/gate-trace" > "$tree/checks/tests/test_readme.sh"
  chmod +x "$tree/checks/tests/test_readme.sh"
  for tool in swift xcrun cargo rustc; do
    printf '#!/usr/bin/env bash\nprintf "tool: %%s\\n" "$0" >> "%s"\n[ "$*" != -vV ] || printf "host: fixture-triple\\n"\nexit 0\n' "$bin/gate-trace" > "$bin/$tool"
    chmod +x "$bin/$tool"
  done
}
run_gate() {
  status=0
  (cd "$tree" && PATH="$bin:$PATH" bash checks/gate.sh) > "$scene/out" 2> "$scene/err" || status=$?
  err="$(cat "$scene/err")"; trace="$(cat "$bin/gate-trace")"
}
test_gate_runs_real_check_and_entire_suite_at_defaults() {
  gate_fixture || return 1; run_gate
  equal "$status" 0 && contains "$trace" 'README inspection' && contains "$trace" 'checks/tests/test_readme.sh' || return 1
  printf '%s\n' "$trace" | awk '/README inspection/{a=NR} $0=="checks\/tests\/test_readme.sh"{b=NR} $0=="checks\/release-shape.sh"{c=NR} END{exit !(a&&b>a&&c>b)}'
}
test_each_readme_step_is_fatal_and_stops_later_steps() {
  gate_fixture || return 1; remove_word README.md 1; run_gate
  [ "$status" -ne 0 ] && contains "$err" 'step failed: README check' || return 1
  case "$trace" in *'checks/tests/test_readme.sh'*|*'checks/release-shape.sh'*) return 1;; esac
  gate_fixture || return 1
  README_SUITE_STATUS=17 run_gate
  [ "$status" -ne 0 ] && contains "$err" 'step failed: README check suite' || return 1
  case "$trace" in *'checks/release-shape.sh'*) return 1;; esac
}
test_gate_pair_is_unconditional_unique_and_in_order() {
  gate_shape "$GATE" || { fail 'the real gate pair is missing, duplicated, bypassed or out of order'; return 1; }
  local target mutation
  for target in "$DIRECT" "$SUITE"; do
    for mutation in delete comment replace bypass duplicate; do
      fixture || return 1
      awk -v target="$target" -v mutation="$mutation" '
        $0==target {
          if(mutation=="delete") next
          if(mutation=="comment") {print "# " $0;next}
          if(mutation=="replace") {print $0 " || true";next}
          if(mutation=="bypass") {print "if false; then";print;print "fi";next}
          if(mutation=="duplicate") print
        } {print}
      ' "$GATE" > "$scene/mutated"
      ! cmp -s "$GATE" "$scene/mutated" || return 1
      if gate_shape "$scene/mutated"; then fail "$mutation of $target passed"; return 1; fi
      # Dynamic proof of a bypass: the real dispatcher must not reach both required paths.
      if [ "$mutation" = bypass ]; then
        held="$scene/mutated"
        gate_fixture || return 1
        cp "$held" "$tree/checks/gate.sh"
        run_gate
        if [ "$target" = "$DIRECT" ]; then
          case "$trace" in *'README inspection'*) fail 'bypassed check ran'; return 1;; esac
        else
          case "$trace" in *'checks/tests/test_readme.sh'*) fail 'bypassed suite ran'; return 1;; esac
        fi
      fi
    done
  done
}
test_existing_gate_calls_keep_names_commands_and_order() {
  calls="$(grep '^run_step ' "$GATE" | grep -Fvx "$DIRECT" | grep -Fvx "$SUITE")"
  equal "$calls" "$BASE_CALLS"
}
CASES='test_complete_wordings_and_no_images_pass test_emphasis_around_a_whole_wording_passes test_canonical_wording_is_read_at_runtime test_each_missing_or_paraphrased_wording_is_named_whole test_partial_or_line_broken_wording_fails test_findings_follow_table_order_then_file_order test_unavailable_document_or_canonical_set_is_a_refusal test_failed_inspection_cannot_become_a_pass test_present_tracked_local_images_pass_in_every_form test_every_remote_primary_and_alternate_is_named test_nonrepository_image_sources_are_refused test_nondisplaying_examples_do_not_hide_later_images test_usage_and_all_outcomes_leave_inputs_unchanged test_wrong_arguments_read_nothing test_signals_never_end_with_success test_readme_commands_have_no_write_or_environment_escape test_gate_runs_real_check_and_entire_suite_at_defaults test_each_readme_step_is_fatal_and_stops_later_steps test_gate_pair_is_unconditional_unique_and_in_order test_existing_gate_calls_keep_names_commands_and_order'
selected="${KA_READER_TEST_ONLY:-}"
if [ -n "$selected" ]; then case " $CASES " in *" $selected "*) ;; *) fail "unknown case: $selected"; exit 1;; esac; fi
failed=0; total=0
for case_name in $CASES; do
  [ -z "$selected" ] || [ "$selected" = "$case_name" ] || continue
  total=$((total+1))
  if ( "$case_name" ); then printf 'ok   %s\n' "$case_name"; else printf 'FAIL %s\n' "$case_name"; failed=$((failed+1)); fi
done
printf '%s of %s passed\n' "$((total-failed))" "$total"
[ "$failed" -eq 0 ]
