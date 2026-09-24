#!/usr/bin/env bash
# Version: 1.0.0 — first version: drives the real checks/view.sh over synthetic product roots and the real tree
#
# checks/tests/test_view.sh — the tests of checks/view.sh.
#
# WHY THIS EXISTS
#   checks/view.sh is the proof that the Swift shell holds no I/O of its own, so a bug in it is a
#   shell nobody is watching. These cases run the real script — never a copy of its logic. The script
#   derives the product root from its own location, so each synthetic case copies the script into a
#   temporary root that holds a synthetic nozoki-mac/Sources and a stand-in executable; `otool` is
#   stood in on PATH, the one seam the script has.
#   The technique is the shell packet's, minus its runner: this product has no Python, so the runner
#   is this file, as in checks/tests/test_bundle.sh.
#
# USAGE
#   checks/tests/test_view.sh
#   The real-tree case reads target/release/bundle/macos/Nozoki.app, so run nozoki-mac/assemble.sh
#   first. A bundle that is absent FAILS that case with a stated message and never skips it: a skip
#   would let CI conclude green having proved nothing.
#   NOZOKI_TEST_ONLY=<case> runs one case.
#
# WHY NO `set -e`
#   A case that fails must not end the run before the remaining cases report. Each case returns its
#   own status and the runner counts them.

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
VIEW_SH="$ROOT/checks/view.sh"
REAL_EXECUTABLE="$ROOT/target/release/bundle/macos/Nozoki.app/Contents/MacOS/Nozoki"

STDOUT=""
STDERR=""
STATUS=0
WORK="$(mktemp -d)"

CASES="
test_real_tree_passes
test_tests_folder_is_not_scanned
test_each_family_is_reported
test_import_allowlist
test_near_names_are_not_reported
test_bundle_main_lookups_admitted
test_surfaces_may_not_call_the_bridge
test_open_panel_exception_is_narrow
test_comments_are_not_code
test_findings_name_the_true_line
test_link_list_names_webkit
test_every_finding_in_one_run
test_no_swift_source_fails
test_missing_executable_fails
test_otool_absent_or_failing
test_pass_line_on_stdout_findings_on_stderr
"

# --- helpers ---

fail() {
  echo "  $*"
  return 1
}

# A synthetic product root: the real script copied in, a clean Sources tree with the four targets
# the real tree has, an empty Tests folder, and a stand-in executable at the path the script reads.
new_root() {
  root="$WORK/$1"
  mkdir -p "$root/checks" \
    "$root/nozoki-mac/Sources/CNozokiBridge" "$root/nozoki-mac/Sources/Nozoki" \
    "$root/nozoki-mac/Sources/Shell" "$root/nozoki-mac/Sources/Surfaces" \
    "$root/nozoki-mac/Tests" "$root/target/release/bundle/macos/Nozoki.app/Contents/MacOS"
  cp "$VIEW_SH" "$root/checks/view.sh"
  chmod +x "$root/checks/view.sh"
  printf 'import AppKit\n' > "$root/nozoki-mac/Sources/Shell/Clean.swift"
  printf 'stand-in executable\n' > "$root/target/release/bundle/macos/Nozoki.app/Contents/MacOS/Nozoki"
  chmod +x "$root/target/release/bundle/macos/Nozoki.app/Contents/MacOS/Nozoki"
  printf '%s' "$root"
}

# Writes the text $3 (as given, with printf's escapes read) to $1/nozoki-mac/$2.
put_file() {
  mkdir -p "$(dirname "$1/nozoki-mac/$2")"
  printf '%b' "$3" > "$1/nozoki-mac/$2"
}

# A stand-in `otool` in directory $1. $2 is the body: the lines it prints after the header line.
# The real tool prints "<path>:" first, then each install name tab-indented.
make_otool() {
  mkdir -p "$1"
  {
    echo '#!/bin/sh'
    echo 'echo "$2:"'
    printf '%s\n' "$2" | while IFS= read -r line; do
      [ -n "$line" ] && printf 'printf "\\t%%s\\n" "%s"\n' "$line"
    done
    echo 'exit 0'
  } > "$1/otool"
  chmod +x "$1/otool"
}

CLEAN_LINKS="/usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1351.0.0)
/System/Library/Frameworks/AppKit.framework/Versions/C/AppKit (compatibility version 45.0.0, current version 2600.0.0)"

# The ordinary run: the stand-in otool ahead of the real tools.
run_view() {
  stubs="${2:-$WORK/otool-clean}"
  [ -d "$stubs" ] || make_otool "$stubs" "$CLEAN_LINKS"
  PATH="$stubs:$PATH" "$1/checks/view.sh" > "$WORK/stdout" 2> "$WORK/stderr"
  STATUS=$?
  STDOUT="$(cat "$WORK/stdout")"
  STDERR="$(cat "$WORK/stderr")"
}

# A run whose PATH is exactly $2, for the case where otool must be absent.
run_view_with_path() {
  PATH="$2" "$1/checks/view.sh" > "$WORK/stdout" 2> "$WORK/stderr"
  STATUS=$?
  STDOUT="$(cat "$WORK/stdout")"
  STDERR="$(cat "$WORK/stderr")"
}

# A directory of links to the ordinary tools and to no `otool`, so a run on it can find everything
# but the seam.
tools_without_otool() {
  mkdir -p "$1"
  for tool in bash env awk grep sed find sort tr cat cut head tail wc basename dirname mktemp rm \
    mkdir ls uniq expr od date cp mv tee xargs sh test; do
    resolved="$(command -v "$tool" 2> /dev/null || true)"
    case "$resolved" in
      /*) ln -sf "$resolved" "$1/$tool" ;;
    esac
  done
}

expect_status() {
  [ "$STATUS" -eq "$1" ] || fail "expected exit $1, got $STATUS. stdout: $STDOUT stderr: $STDERR"
}

expect_stderr_contains() {
  case "$STDERR" in
    *"$1"*) return 0 ;;
  esac
  fail "expected stderr to contain: $1. stderr: $STDERR stdout: $STDOUT"
}

expect_stderr_lacks() {
  case "$STDERR" in
    *"$1"*) fail "expected stderr not to contain: $1. stderr: $STDERR" ;;
  esac
}

expect_stdout_lacks() {
  case "$STDOUT" in
    *"$1"*) fail "expected stdout not to contain: $1. stdout: $STDOUT" ;;
  esac
}

# A finding line on stderr: `<file>:<line>: <name>`, where <file> is relative to the product root and
# the rest of the line names the refused thing. $1 is the file under nozoki-mac/, $2 the line, $3
# the name.
expect_finding() {
  found=0
  while IFS= read -r line; do
    case "$line" in
      "nozoki-mac/$1:$2: "*"$3"*) found=1 ;;
    esac
  done <<< "$STDERR"
  [ "$found" -eq 1 ] || fail "expected a finding nozoki-mac/$1:$2: … $3 on stderr. stderr: $STDERR"
}

# Runs the script over one synthetic source and expects it reported at the given line.
# $1 label, $2 file under nozoki-mac/, $3 file text, $4 line, $5 name.
expect_source_reported() {
  case_root="$(new_root "src-$(printf '%s' "$1" | tr -c 'A-Za-z0-9' '_')")"
  put_file "$case_root" "$2" "$3"
  run_view "$case_root"
  expect_status 1 || return 1
  expect_finding "$2" "$4" "$5" || return 1
  [ -z "$STDOUT" ] || fail "expected no stdout on a finding, got: $STDOUT"
}

# Runs the script over one synthetic source and expects a clean pass.
# $1 label, $2 file under nozoki-mac/, $3 file text.
expect_source_clean() {
  case_root="$(new_root "clean-$(printf '%s' "$1" | tr -c 'A-Za-z0-9' '_')")"
  put_file "$case_root" "$2" "$3"
  run_view "$case_root"
  expect_status 0 || return 1
  [ -z "$STDERR" ] || fail "expected empty stderr for $1, got: $STDERR"
}

# --- cases ---

# On the real product root, after nozoki-mac/assemble.sh.
test_real_tree_passes() {
  [ -f "$REAL_EXECUTABLE" ] \
    || fail "the real bundle is absent ($REAL_EXECUTABLE): run nozoki-mac/assemble.sh first. A missing bundle fails this case and never skips it"
  STDOUT_REAL="$("$VIEW_SH" 2> "$WORK/real-stderr")"
  status=$?
  stderr_real="$(cat "$WORK/real-stderr")"
  [ "$status" -eq 0 ] || fail "expected exit 0 on the real tree, got $status. stderr: $stderr_real stdout: $STDOUT_REAL"
  [ -z "$stderr_real" ] || fail "expected empty stderr on the real tree, got: $stderr_real"
  lines="$(printf '%s\n' "$STDOUT_REAL" | wc -l | tr -d ' ')"
  [ "$lines" -eq 1 ] || fail "expected one stdout line, got $lines: $STDOUT_REAL"
  swift_count="$(find "$ROOT/nozoki-mac/Sources" -name '*.swift' | wc -l | tr -d ' ')"
  case "$STDOUT_REAL" in
    *" $swift_count Swift files"*) ;;
    *) fail "expected the pass line to give the count $swift_count of Swift files: $STDOUT_REAL" ;;
  esac
  case "$STDOUT_REAL" in
    *"Nozoki.app/Contents/MacOS/Nozoki"*) ;;
    *) fail "expected the pass line to name the executable: $STDOUT_REAL" ;;
  esac
  case "$STDOUT_REAL" in
    *"nothing found"*) ;;
    *) fail "expected the pass line to say nothing was found: $STDOUT_REAL" ;;
  esac
}

test_tests_folder_is_not_scanned() {
  tests_root="$(new_root tests-folder)"
  put_file "$tests_root" "Tests/X.swift" 'import AppKit\nlet d = Data(contentsOf: url)\n'
  run_view "$tests_root"
  expect_status 0 || return 1
  [ -z "$STDERR" ] || fail "expected empty stderr, got: $STDERR"
}

# One synthetic source per family, each on line 2 under `import AppKit`.
test_each_family_is_reported() {
  bad=""
  check_family() {
    # $1 family, $2 file under Sources/, $3 the line, $4 the name reported
    dir="$(printf '%s' "$1$4" | tr -c 'A-Za-z0-9' '_')"
    family_root="$(new_root "fam-$dir")"
    put_file "$family_root" "Sources/$2" "import AppKit\n$3\n"
    run_view "$family_root"
    if [ "$STATUS" -ne 1 ]; then
      bad="$bad
  $1 ($4): expected exit 1, got $STATUS. stdout: $STDOUT"
      return 0
    fi
    found=0
    while IFS= read -r line; do
      case "$line" in
        "nozoki-mac/Sources/$2:2: "*"$4"*) found=1 ;;
      esac
    done <<< "$STDERR"
    [ "$found" -eq 1 ] || bad="$bad
  $1: no finding nozoki-mac/Sources/$2:2: … $4. stderr: $STDERR"
  }
  check_family F1 Shell/S.swift 'import WebKit' 'WebKit'
  check_family F2 Shell/S.swift 'let view = WKWebView()' 'WKWebView'
  check_family F2 Shell/S.swift 'let ctx = JSContext()' 'JSContext'
  check_family F3 Shell/S.swift 'let kind = NSHTMLTextDocumentType' 'NSHTMLTextDocumentType'
  check_family F3 Shell/S.swift 'let o: [NSAttributedString.DocumentAttributeKey: Any] = [.documentType: .webArchive]' '.webArchive'
  check_family F3 Shell/S.swift 'let a = NSAttributedString(html: data, documentAttributes: nil)' 'html:'
  check_family F4 Shell/S.swift 'let s = URLSession.shared' 'URLSession'
  check_family F4 Shell/S.swift 'let s = CFSocketCreate(nil, 0, 0, 0, 0, nil, nil)' 'CFSocketCreate'
  check_family F4 Shell/S.swift 'let s = getStreamsToHost' 'getStreamsToHost'
  check_family F5 Shell/S.swift 'let p = Process()' 'Process'
  check_family F5 Shell/S.swift 'let t = NSTask()' 'NSTask'
  check_family F6 Shell/S.swift 'NSWorkspace.shared.open(url)' 'NSWorkspace'
  check_family F6 Shell/S.swift 'let s = NSSharingService(named: .postOnTwitter)' 'NSSharingService'
  check_family F7 Shell/S.swift 'FileManager.default.createFile(atPath: p, contents: nil)' 'FileManager'
  check_family F7 Shell/S.swift 'let d = Data(contentsOf: url)' 'contentsOf:'
  check_family F7 Shell/S.swift 'let i = NSImage(contentsOfFile: p)' 'contentsOfFile:'
  check_family F7 Shell/S.swift 'try d.write(to: url)' 'write(to:'
  check_family F7 Shell/S.swift 'let i = NSImage(byReferencing: url)' 'byReferencing'
  check_family F7 Shell/S.swift 'let h = FileHandle.standardInput' 'FileHandle'
  check_family F7 Shell/S.swift 'let s = CGImageSourceCreateWithURL(u, nil)' 'CGImageSourceCreateWithURL'
  check_family F8 Shell/S.swift 'let i = Bundle.main.infoDictionary' 'Bundle'
  check_family F9 Shell/S.swift 'let f = fopen("/x", "r")' 'fopen'
  check_family F9 Shell/S.swift 'let n = stat("/x", &buffer)' 'stat'
  check_family F10 Shell/S.swift 'let c = NSClassFromString("NSObject")' 'NSClassFromString'
  check_family F10 Shell/S.swift '@_silgen_name("x") func f()' '@_silgen_name'
  check_family F10 Shell/S.swift 'let h = dlopen("x", 0)' 'dlopen'
  check_family F11 Shell/S.swift 'let h = ProcessInfo.processInfo.environment["HOME"]' '.environment'
  check_family F11 Shell/S.swift 'let a = CommandLine.arguments' 'CommandLine'
  check_family F11 Shell/S.swift 'let d = UserDefaults.standard' 'UserDefaults'
  check_family F11 Shell/S.swift 'let h = getenv("HOME")' 'getenv'
  check_family F12 Surfaces/RootItemsView.swift 'let r = nozoki_list_tree(nil)' 'nozoki_list_tree'
  check_family F12 Surfaces/RootItemsView.swift 'import CNozokiBridge' 'CNozokiBridge'
  check_family F13 Shell/S.swift 'NSAlert().runModal()' 'NSAlert'
  check_family F13 Shell/S.swift 'window.beginSheet(other)' 'beginSheet'
  check_family F13 Shell/S.swift 'let c = UNUserNotificationCenter.current()' 'UNUserNotificationCenter'
  [ -z "$bad" ] || fail "families not reported:$bad"
}

test_import_allowlist() {
  bad=""
  for form in 'import Darwin' '@_implementationOnly import Network' 'import class WebKit.WKWebView' \
    'import SwiftUI' 'import UserNotifications' 'import JavaScriptCore'; do
    allow_root="$(new_root "imp-$(printf '%s' "$form" | tr -c 'A-Za-z0-9' '_')")"
    put_file "$allow_root" "Sources/Shell/I.swift" "$form\n"
    run_view "$allow_root"
    [ "$STATUS" -eq 1 ] || bad="$bad
  '$form' was not reported (exit $STATUS)"
  done
  [ -z "$bad" ] || fail "imports not reported:$bad"
  expect_source_clean allowed Sources/Shell/I.swift 'import Shell\nimport Foundation\nimport AppKit\n@testable import Surfaces\n' || return 1
  # The allowed set is read from the tree when the script runs: a new directory under Sources/ admits
  # `import` of its name.
  extra_root="$(new_root import-extra)"
  put_file "$extra_root" "Sources/Shell/I.swift" 'import Extra\n'
  run_view "$extra_root"
  expect_status 1 || return 1
  mkdir -p "$extra_root/nozoki-mac/Sources/Extra"
  put_file "$extra_root" "Sources/Extra/E.swift" 'import AppKit\n'
  run_view "$extra_root"
  expect_status 0 || return 1
}

test_near_names_are_not_reported() {
  expect_source_clean near Sources/Shell/N.swift 'import AppKit
import Foundation
func f(other: [Int]) -> Bool {
  var array: [Int] = []
  array.append(contentsOf: other)
  let ok = ProcessInfo.processInfo.isOperatingSystemAtLeast(OperatingSystemVersion(majorVersion: 14, minorVersion: 0, patchVersion: 0))
  let image = NSImage(named: "x")
  return ok && image != nil
}
struct ProcessingState {}
struct BundleGlyphSource {}
' || return 1
}

test_bundle_main_lookups_admitted() {
  expect_source_clean lookups Sources/Shell/L.swift 'import AppKit
let a = Bundle.main.image(forResource: NSImage.Name("x"))
let b = Bundle.main.url(forResource: "x", withExtension: "svg")
let c = Bundle.main.urls(forResourcesWithExtension: "svg", subdirectory: nil)
let d = Bundle.main.path(forResource: "x", ofType: "svg")
let e = Bundle.main.paths(forResourcesOfType: "svg", inDirectory: nil)
' || return 1
  expect_source_reported alias Sources/Shell/L.swift 'import AppKit\nlet b = Bundle.main\n' 2 Bundle || return 1
  expect_source_reported path Sources/Shell/L.swift 'import AppKit\nlet b = Bundle(path: "/tmp")\n' 2 Bundle || return 1
}

test_surfaces_may_not_call_the_bridge() {
  expect_source_reported surfaces-call Sources/Surfaces/RootItemsView.swift \
    'import AppKit\nlet r = nozoki_list_tree(nil)\n' 2 nozoki_list_tree || return 1
  expect_source_clean nozoki-call Sources/Nozoki/NativeBridge.swift \
    'import AppKit\nimport CNozokiBridge\nlet r = nozoki_list_tree(nil)\n' || return 1
  expect_source_reported surfaces-import Sources/Surfaces/RootItemsView.swift \
    'import AppKit\nimport CNozokiBridge\n' 2 CNozokiBridge || return 1
}

test_open_panel_exception_is_narrow() {
  panel='import AppKit\nfunc chooseFolder() -> URL? {\n  return panel.runModal() == .OK ? panel.url : nil\n}\n'
  expect_source_clean panel Sources/Shell/OpenFolderPanel.swift "$panel" || return 1
  expect_source_reported second Sources/Shell/OpenFolderPanel.swift \
    'import AppKit\nfunc a() { _ = panel.runModal() }\nfunc b() { _ = panel.runModal() }\n' 3 runModal || return 1
  expect_source_reported other-file Sources/Shell/Other.swift \
    'import AppKit\nfunc a() { _ = panel.runModal() }\n' 2 runModal || return 1
  expect_source_reported with-argument Sources/Shell/OpenFolderPanel.swift \
    'import AppKit\nfunc a() { _ = NSApp.runModal(for: w) }\n' 2 runModal || return 1
  expect_source_reported nsapp-anywhere Sources/Nozoki/AppDelegate.swift \
    'import AppKit\nfunc a() { _ = NSApp.runModal(for: w) }\n' 2 runModal || return 1
}

test_comments_are_not_code() {
  expect_source_clean line-comment Sources/Shell/C.swift 'import AppKit\n// FileManager\n' || return 1
  expect_source_clean nested-block Sources/Shell/C.swift 'import AppKit\n/* nested /* URLSession */ */\n' || return 1
  expect_source_reported string-slashes Sources/Shell/C.swift \
    'import AppKit\nlet u = "https://x" ; FileManager.default\n' 2 FileManager || return 1
  expect_source_reported multiline-string Sources/Shell/C.swift \
    'import AppKit\nlet s = """\n// not a comment\n/* still not\n"""\nlet f = FileManager.default\n' 6 FileManager || return 1
  expect_source_reported raw-string-block Sources/Shell/C.swift \
    'import AppKit\nlet r = #"a /* b"#\nlet f = FileManager.default\n' 3 FileManager || return 1
  expect_source_reported raw-string-line Sources/Shell/C.swift \
    'import AppKit\nlet r = #"a // b"# ; FileManager.default\n' 2 FileManager || return 1
  expect_source_reported string-names-a-class Sources/Shell/C.swift \
    'import AppKit\nlet c = NSClassFromString("NSTask")\n' 2 NSClassFromString || return 1
}

test_findings_name_the_true_line() {
  expect_source_reported true-line Sources/Shell/T.swift \
    '/* one\n   two\n   three */\nimport AppKit\nfunc f() {\n}\nlet x = FileManager.default\n' 7 FileManager || return 1
}

test_link_list_names_webkit() {
  link_root="$(new_root link-webkit)"
  make_otool "$WORK/otool-webkit" "/usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1351.0.0)
/System/Library/Frameworks/WebKit.framework/Versions/A/WebKit (compatibility version 1.0.0, current version 619.1.15)"
  run_view "$link_root" "$WORK/otool-webkit"
  expect_status 1 || return 1
  expect_stderr_contains "link: /System/Library/Frameworks/WebKit.framework/Versions/A/WebKit" || return 1
  make_otool "$WORK/otool-jsc" "/usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1351.0.0)
/opt/vendor/JavaScriptCore.framework/JavaScriptCore (compatibility version 1.0.0, current version 619.1.15)"
  run_view "$link_root" "$WORK/otool-jsc"
  expect_status 1 || return 1
  expect_stderr_contains "link: /opt/vendor/JavaScriptCore.framework/JavaScriptCore" || return 1
  # A component is matched whole: a name that merely contains WebKit is not the framework.
  make_otool "$WORK/otool-near" "/usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1351.0.0)
/usr/lib/libWebKitLike.dylib (compatibility version 1.0.0, current version 1.0.0)
/opt/x/NotWebKit.framework/NotWebKit (compatibility version 1.0.0, current version 1.0.0)"
  run_view "$link_root" "$WORK/otool-near"
  expect_status 0 || return 1
}

test_every_finding_in_one_run() {
  both_root="$(new_root both)"
  put_file "$both_root" "Sources/Shell/B.swift" 'import AppKit\nlet f = FileManager.default\n'
  make_otool "$WORK/otool-both" "/usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1351.0.0)
/System/Library/Frameworks/WebKit.framework/Versions/A/WebKit (compatibility version 1.0.0, current version 619.1.15)"
  run_view "$both_root" "$WORK/otool-both"
  expect_status 1 || return 1
  expect_finding Sources/Shell/B.swift 2 FileManager || return 1
  expect_stderr_contains "link: /System/Library/Frameworks/WebKit.framework/Versions/A/WebKit" || return 1
}

test_no_swift_source_fails() {
  empty_root="$(new_root empty-scan)"
  rm -f "$empty_root/nozoki-mac/Sources/Shell/Clean.swift"
  run_view "$empty_root"
  expect_status 1 || return 1
  expect_stdout_lacks "nothing found" || return 1
  expect_stderr_contains "no .swift file" || return 1
}

test_missing_executable_fails() {
  missing_root="$(new_root no-executable)"
  rm -rf "$missing_root/target"
  run_view "$missing_root"
  expect_status 1 || return 1
  expect_stderr_contains "Nozoki.app/Contents/MacOS/Nozoki" || return 1
  expect_stdout_lacks "nothing found" || return 1
}

test_otool_absent_or_failing() {
  otool_root="$(new_root otool-trouble)"
  tools_without_otool "$WORK/no-otool-bin"
  run_view_with_path "$otool_root" "$WORK/no-otool-bin"
  expect_status 1 || return 1
  expect_stderr_contains "otool" || return 1
  expect_stdout_lacks "nothing found" || return 1
  mkdir -p "$WORK/otool-exit1"
  printf '#!/bin/sh\necho "otool: error" >&2\nexit 1\n' > "$WORK/otool-exit1/otool"
  chmod +x "$WORK/otool-exit1/otool"
  run_view "$otool_root" "$WORK/otool-exit1"
  expect_status 1 || return 1
  expect_stderr_contains "otool" || return 1
  make_otool "$WORK/otool-header-only" ""
  run_view "$otool_root" "$WORK/otool-header-only"
  expect_status 1 || return 1
  expect_stderr_contains "install name" || return 1
  expect_stdout_lacks "nothing found" || return 1
}

test_pass_line_on_stdout_findings_on_stderr() {
  pass_root="$(new_root streams-pass)"
  run_view "$pass_root"
  expect_status 0 || return 1
  [ -z "$STDERR" ] || fail "expected empty stderr on a pass, got: $STDERR"
  lines="$(printf '%s\n' "$STDOUT" | wc -l | tr -d ' ')"
  [ "$lines" -eq 1 ] || fail "expected one stdout line on a pass, got $lines: $STDOUT"
  red_root="$(new_root streams-red)"
  put_file "$red_root" "Sources/Shell/R.swift" 'import AppKit\nlet f = FileManager.default\n'
  run_view "$red_root"
  expect_status 1 || return 1
  expect_finding Sources/Shell/R.swift 2 FileManager || return 1
  [ -z "$STDOUT" ] || fail "expected no stdout on a red run, got: $STDOUT"
}

# --- runner ---

cleanup() {
  rm -rf "$WORK"
}
trap cleanup EXIT

failed=0
for case_name in $CASES; do
  if [ -n "${NOZOKI_TEST_ONLY:-}" ] && [ "$case_name" != "$NOZOKI_TEST_ONLY" ]; then
    continue
  fi
  if result="$("$case_name" 2>&1)"; then
    echo "ok   $case_name"
  else
    echo "FAIL $case_name"
    [ -z "$result" ] || echo "$result"
    failed=$((failed + 1))
  fi
done

if [ "$failed" -ne 0 ]; then
  echo "test_view.sh: $failed case(s) failed" >&2
  exit 1
fi
