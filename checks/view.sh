#!/usr/bin/env bash
# Version: 1.1.0 — the bridge serves Git — libgit2 machine-config switch, read_git export, Git item wire, nm transport read in view.sh
# Version: 1.0.0 — first version: the source scan (F1–F13) over ka-reader-mac/Sources and the link check on the built executable
#
# checks/view.sh — proves the Swift shell holds no I/O of its own.
#
# WHY THIS EXISTS
#   The shell (ka-reader-mac) draws what the bridge hands it and does nothing else: it reads no file, opens
#   no socket, spawns no process, embeds no web engine and shows no alert of its own (SDD C-R7; NFDR
#   QC-8, QC-15, QC-17, QC-30, QC-34, QC-51, QC-58). A reviewer cannot keep watching for that, so this
#   script reads it off the tree and off the built executable, on every run of CI.
#   Three checks run, and all always run before the verdict, so one run reports every finding:
#     1. The source scan, over every *.swift file under ka-reader-mac/Sources at any depth and nothing
#        under ka-reader-mac/Tests. Comments are blanked in place, so a name in a comment is not a use and
#        every finding names the true line. String contents stay in the text and are scanned: a string
#        is how NSClassFromString("…") names an API this scan would otherwise catch. The cost is a
#        false positive when a user-visible string holds a forbidden name, and that fails closed.
#     2. The link check: `otool -L` on target/release/bundle/macos/KA-Reader.app/Contents/MacOS/KA-Reader. An
#        install name is a finding when one of its path components is WebKit.framework or
#        JavaScriptCore.framework, wherever that framework lives.
#     3. The transport read: `nm` on the same executable. A defined symbol whose name begins
#        git_smart_subtransport_ is a finding (libgit2's network transport is linked in), and so is an
#        undefined import of connect, socket or getaddrinfo (the executable reaches for the network).
#        A leading underscore, which Mach-O adds to a C name, is not part of the name. Source: NFDR
#        QC-3 (3), SDD § 4 C-R6 and C-I3; it is owed by the build that first exports a command reaching
#        git-reader, which is the one that exports ka_reader_read_git.
#   It never passes having read nothing: no .swift file, a missing or unreadable executable, no otool,
#   an otool that fails, an otool that prints no install name (every executable links libSystem, so
#   an empty list is a read of nothing), no nm, an nm that fails, and an nm that prints no symbol are
#   each a failure that names its cause.
#
# USAGE
#   checks/view.sh
#   No argument, and no environment variable: the product root is the parent of this script's own
#   directory, as checks/own-state.sh derives it. `otool` and `nm` are found through PATH, so a test can
#   stand in for them; those are the seams.
#   A finding is one line on stderr — `<path relative to the root>:<line>: <refused name>`,
#   `link: <install name>`, or `transport: defined <symbol>` / `transport: undefined import <symbol>`.
#   A pass is exit 0 and one stdout line: the count of Swift files, the executable's path, and that
#   nothing was found. Every other ending is exit 1, its cause on stderr.
#
# THE SCAN TABLE
#   A token is an identifier matched whole: a word character on either side means no match, so
#   `Process` does not match `ProcessInfo`. A name in the table is refused wherever it appears, never
#   left out of a pattern to be excused: a name left out of a pattern can never be reported. "C-R7" is
#   docs/SDD.md § 4 C-R7; a QC-n is docs/nfdr.md; "design addition" is added under the NFDR's
#   same-change clause (QC-34), and every row passes today's tree.
#     F1  Imports        Any `import` of a module outside {AppKit, Foundation, and the directory names
#                        directly under ka-reader-mac/Sources, read when the script runs}, in every form
#                        (`import X`, `import class X.Y`, `@testable import X`, `@_implementationOnly
#                        import X`). Source: QC-8's "may import" set.
#     F2  Web engine     WKWebView, WebView, JSContext. Source: C-R7.
#     F3  Attributed string through a web engine   NSHTMLTextDocumentType, NSWebArchiveTextDocumentType,
#                        the members .html and .webArchive, the labels html: and HTML: after `(`.
#                        Source: C-R7, CP-135's domain.
#     F4  Network        Tokens beginning URLSession, NSURLSession, NSURLConnection, CFSocket,
#                        CFStreamCreatePairWith; getStreamsToHost. Source: C-R7; design addition (the CF
#                        and Stream forms).
#     F5  Spawning a process or running a script   Process, NSTask, NSAppleScript, NSUser…Task. Source:
#                        C-R7 (Process); design addition.
#     F6  Handing a URL, a file or data to another program   Every NSWorkspace token, NSSharingService…,
#                        NSPerformService. Source: C-R7 (NSWorkspace.open, NSSharingService); the list
#                        CP-135 leaves to the design.
#     F7  File I/O through Foundation   FileManager…, FileHandle, InputStream, OutputStream,
#                        NSFileCoordinator, FileWrapper, NSFileWrapper; an initialiser whose first label
#                        is contentsOf:, contentsOfFile: or contentsOfURL: on a capitalised type or
#                        .init(; .write(to:, .write(toFile:, .write(toURL:; NSImage(byReferencing…;
#                        tokens ending CreateWithURL or CreateWithFilename. Source: C-R7 (FileManager,
#                        Data(contentsOf:), String(contentsOf:)), QC-15; the rest are design additions.
#     F8  Reading a bundle other than as a resource lookup   Every Bundle, NSBundle and CFBundle… token,
#                        except Bundle.main followed straight away by .image(forResource:,
#                        .url(forResource:, .urls(forResourcesWithExtension:, .path(forResource: or
#                        .paths(forResourcesOfType:. Source: C-R7; the other Bundle forms are design
#                        additions.
#     F9  POSIX calls reached through Foundation's re-export of Darwin   A free call (not preceded by a
#                        dot or a word character) to open, openat, fopen, fdopen, freopen, opendir, stat,
#                        lstat, access, popen, system, fork, vfork, execl, execle, execlp, execv, execve,
#                        execvp, posix_spawn, posix_spawnp, socket. Source: design addition.
#     F10 Dynamic lookup   dlopen, dlsym, NSClassFromString, NSSelectorFromString, objc_getClass,
#                        objc_lookUpClass, objc_msgSend; the attributes @_silgen_name and @_extern.
#                        Source: C-R7 (dlopen); design addition.
#     F11 Arguments, environment and configuration   CommandLine; the members .arguments and
#                        .environment on any receiver; getenv, environ, _NSGetArgv, _NSGetArgc,
#                        _NSGetEnviron; UserDefaults, NSUserDefaults, CFPreferences…. Source: QC-30 and
#                        QC-58; design addition for the rest.
#     F12 Only the shell calls the bridge   In files under ka-reader-mac/Sources/Surfaces/ only: any token
#                        beginning ka_reader_, and `import CKAReaderBridge`. Source: QC-17, realized by C-R7's
#                        export prefix.
#     F13 Alerts, notifications, modals   NSAlert; tokens beginning NSUserNotification; tokens beginning
#                        UN that contain Notification; tokens beginning runModal, beginSheet,
#                        beginCriticalSheet, beginModalSession, presentAsModalWindow, presentAsSheet.
#                        The one exception is a single `.runModal()` with no argument in
#                        ka-reader-mac/Sources/Shell/OpenFolderPanel.swift, the Open panel's own
#                        presentation; a second one there, or `.runModal(` with an argument, is
#                        reported. Source: QC-51, narrowed by the Open panel C-R3 requires.
#   QC-34's, QC-1's and QC-23's lists point here: this header is the list, and C-R7's set is its floor.

set -euo pipefail

die() { echo "view.sh: $*" >&2; exit 1; }

# --- the product root, and what is read ---

product_root="$(cd "$(dirname "$0")/.." && pwd -P)"
sources_dir="$product_root/ka-reader-mac/Sources"
executable="$product_root/target/release/bundle/macos/KA-Reader.app/Contents/MacOS/KAReader"

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

# Findings and failures are gathered and printed once, after both checks have run.
: > "$work/findings"
: > "$work/causes"

# --- the scan program ---

# One awk run per file, so its state (the comment and string machine, the count of the Open panel's
# runModal) starts fresh for each. awk, because a sed expression cannot track the string state.
cat > "$work/scan.awk" << 'AWK'
function pad(k,   s) { s = ""; while (k > 0) { s = s " "; k-- } return s }

function report(name) { print rel ":" NR ": " name }

# Bundle.main followed straight away by one of the five resource lookups is admitted (F8), and so is
# the one no-argument `.runModal()` of the Open panel's own file (F13).
function exempt(fam, name, before, rest,   lookup) {
  if (fam == 8) {
    if (name != "Bundle" || substr(rest, 1, 6) != ".main.") return 0
    lookup = substr(rest, 7)
    return (index(lookup, "image(forResource:") == 1 || index(lookup, "url(forResource:") == 1 \
      || index(lookup, "urls(forResourcesWithExtension:") == 1 || index(lookup, "path(forResource:") == 1 \
      || index(lookup, "paths(forResourcesOfType:") == 1)
  }
  if (fam == 13 && name == "runModal" && before == "." && substr(rest, 1, 2) == "()" && is_panel) {
    panel_runmodal++
    return (panel_runmodal == 1)
  }
  return 0
}

# Every whole token that matches the pattern p, bounded on both sides by a non-word character.
function scan(s, p, fam,   t, i, start, len, name, before, rest) {
  s = " " s " "
  i = 1
  while (i <= length(s)) {
    t = substr(s, i)
    if (!match(t, "[^A-Za-z0-9_](" p ")[^A-Za-z0-9_]")) break
    start = RSTART; len = RLENGTH
    name = substr(t, start + 1, len - 2)
    before = substr(t, start, 1)
    rest = substr(t, start + 1 + length(name))
    if (!exempt(fam, name, before, rest)) report(name)
    i += start + length(name)
  }
}

# Every match of the regular expression re. The name reported is the match without its first `lead`
# characters and its last `trail`; mode "afterparen" reports what follows the last `(`, and mode
# "call" what precedes the `(` of a free call.
function scanre(s, re, lead, trail, mode,   t, i, start, len, m) {
  s = " " s " "
  i = 1
  while (i <= length(s)) {
    t = substr(s, i)
    if (!match(t, re)) break
    start = RSTART; len = RLENGTH
    m = substr(t, start, len)
    if (mode == "afterparen") sub(/^.*[(]/, "", m)
    else if (mode == "call") { sub(/^./, "", m); sub(/[ \t]*[(]$/, "", m) }
    else m = substr(m, lead + 1, length(m) - lead - trail)
    report(m)
    # Resume on the match's last character (s-index i + start + len - 2), not after it: that character
    # (the `(` of a free call, the boundary after a member) may be the boundary the next match opens
    # with, as in system(open(…)). Every pattern here matches two characters or more, so i advances.
    i += start + len - 2
  }
}

# F1: the first path component of every import form.
function scan_imports(s,   t, i, start, len, m) {
  s = " " s " "
  i = 1
  while (i <= length(s)) {
    t = substr(s, i)
    if (!match(t, "[^A-Za-z0-9_]import[ \t]+((class|struct|enum|protocol|typealias|func|var|let)[ \t]+)?[A-Za-z_][A-Za-z0-9_]*")) break
    start = RSTART; len = RLENGTH
    m = substr(t, start + 1, len - 1)
    sub(/^import[ \t]+/, "", m)
    if (m ~ /^(class|struct|enum|protocol|typealias|func|var|let)[ \t]/) sub(/^[A-Za-z]+[ \t]+/, "", m)
    if (index(allowed, " " m " ") == 0) report(m)
    if (m == "CKAReaderBridge" && in_surfaces) report(m)
    i += start + len
  }
}

function apply(s) {
  scan_imports(s)
  scan(s, "WKWebView|WebView|JSContext", 2)
  scan(s, "NSHTMLTextDocumentType|NSWebArchiveTextDocumentType", 3)
  scanre(s, "[.](html|webArchive)[^A-Za-z0-9_]", 0, 1, "plain")
  scanre(s, "[(](html|HTML):", 1, 0, "plain")
  scan(s, "(URLSession|NSURLSession|NSURLConnection|CFSocket|CFStreamCreatePairWith)[A-Za-z0-9_]*|getStreamsToHost", 4)
  scan(s, "Process|NSTask|NSAppleScript|NSUser[A-Za-z0-9]*Task", 5)
  scan(s, "NSWorkspace[A-Za-z0-9_]*|NSSharingService[A-Za-z0-9_]*|NSPerformService", 6)
  scan(s, "FileManager[A-Za-z0-9_]*|FileHandle|InputStream|OutputStream|NSFileCoordinator|FileWrapper|NSFileWrapper", 7)
  scan(s, "[A-Za-z0-9_]*CreateWithURL|[A-Za-z0-9_]*CreateWithFilename", 7)
  scanre(s, "[^A-Za-z0-9_][A-Z][A-Za-z0-9_]*[(](contentsOf|contentsOfFile|contentsOfURL):", 0, 0, "afterparen")
  scanre(s, "[.]init[(](contentsOf|contentsOfFile|contentsOfURL):", 0, 0, "afterparen")
  scanre(s, "[.]write[(](to|toFile|toURL):", 1, 0, "plain")
  scanre(s, "NSImage[(]byReferencing[A-Za-z]*:", 0, 0, "plain")
  scan(s, "Bundle|NSBundle|CFBundle[A-Za-z0-9_]*", 8)
  scanre(s, "[^A-Za-z0-9_.](open|openat|fopen|fdopen|freopen|opendir|stat|lstat|access|popen|system|fork|vfork|execl|execle|execlp|execv|execve|execvp|posix_spawn|posix_spawnp|socket)[ \t]*[(]", 0, 0, "call")
  scan(s, "dlopen|dlsym|NSClassFromString|NSSelectorFromString|objc_getClass|objc_lookUpClass|objc_msgSend", 10)
  scanre(s, "@_(silgen_name|extern)[^A-Za-z0-9_]", 0, 1, "plain")
  scan(s, "CommandLine|getenv|environ|_NSGetArgv|_NSGetArgc|_NSGetEnviron|UserDefaults|NSUserDefaults|CFPreferences[A-Za-z0-9_]*", 11)
  scanre(s, "[.](arguments|environment)[^A-Za-z0-9_]", 0, 1, "plain")
  if (in_surfaces) scan(s, "ka_reader_[A-Za-z0-9_]*", 12)
  scan(s, "NSAlert|NSUserNotification[A-Za-z0-9_]*|UN[A-Za-z0-9_]*Notification[A-Za-z0-9_]*", 13)
  scan(s, "(runModal|beginSheet|beginCriticalSheet|beginModalSession|presentAsModalWindow|presentAsSheet)[A-Za-z0-9_]*", 13)
}

# The comment and string machine. Comment characters become spaces and newlines are kept, so every
# rule reports the true line. String contents stay.
# A string's interpolation — \( in a string, \#( in a #-raw string — is code, and may hold strings of its
# own, so entering one pushes the string's state and the matching `)` pops it: a // or /* in a literal
# inside an interpolation is still inside a string. `parens` counts the open parentheses of the code
# being read, so only the `)` that closes the interpolation pops.
function sethash(   k) { hashstr = ""; for (k = 0; k < hashes; k++) hashstr = hashstr "#" }
function push_interpolation() { sp++; stk_mode[sp] = mode; stk_parens[sp] = parens; stk_hashes[sp] = hashes; mode = "code"; parens = 0 }
function pop_interpolation() { mode = stk_mode[sp]; parens = stk_parens[sp]; hashes = stk_hashes[sp]; sethash(); sp-- }

BEGIN { mode = "code"; depth = 0; hashes = 0; hashstr = ""; panel_runmodal = 0; sp = 0; parens = 0 }

{
  line = $0
  n = length(line)
  out = ""
  i = 1
  while (i <= n) {
    c = substr(line, i, 1)
    c2 = substr(line, i, 2)
    c3 = substr(line, i, 3)
    if (mode == "code") {
      if (c2 == "//") { out = out pad(n - i + 1); i = n + 1 }
      else if (c2 == "/*") { mode = "block"; depth = 1; out = out "  "; i += 2 }
      else if (c3 == "\"\"\"") { mode = "mstr"; out = out c3; i += 3 }
      else if (c == "\"") { mode = "str"; out = out c; i++ }
      else if (c == "#") {
        h = 0; j = i
        while (substr(line, j, 1) == "#") { h++; j++ }
        if (substr(line, j, 3) == "\"\"\"") { mode = "rawm"; hashes = h; out = out substr(line, i, j - i + 3); i = j + 3 }
        else if (substr(line, j, 1) == "\"") { mode = "raw"; hashes = h; out = out substr(line, i, j - i + 1); i = j + 1 }
        else { out = out substr(line, i, j - i); i = j }
        if (mode == "raw" || mode == "rawm") sethash()
      }
      else if (c == "(") { parens++; out = out c; i++ }
      else if (c == ")") {
        if (parens == 0 && sp > 0) pop_interpolation()
        else if (parens > 0) parens--
        out = out c; i++
      }
      else { out = out c; i++ }
    }
    else if (mode == "block") {
      if (c2 == "/*") { depth++; out = out "  "; i += 2 }
      else if (c2 == "*/") { depth--; out = out "  "; i += 2; if (depth == 0) mode = "code" }
      else { out = out " "; i++ }
    }
    else if (mode == "str") {
      if (c2 == "\\(") { push_interpolation(); out = out c2; i += 2 }
      else if (c == "\\") { out = out substr(line, i, 2); i += 2 }
      else if (c == "\"") { mode = "code"; out = out c; i++ }
      else { out = out c; i++ }
    }
    else if (mode == "mstr") {
      if (c2 == "\\(") { push_interpolation(); out = out c2; i += 2 }
      else if (c == "\\") { out = out substr(line, i, 2); i += 2 }
      else if (c3 == "\"\"\"") { mode = "code"; out = out c3; i += 3 }
      else { out = out c; i++ }
    }
    else if (mode == "raw") {
      if (c == "\\" && substr(line, i + 1, hashes) == hashstr && substr(line, i + 1 + hashes, 1) == "(") { out = out substr(line, i, 2 + hashes); i += 2 + hashes; push_interpolation() }
      else if (c == "\"" && substr(line, i + 1, hashes) == hashstr) { mode = "code"; out = out substr(line, i, 1 + hashes); i += 1 + hashes }
      else { out = out c; i++ }
    }
    else {
      if (c == "\\" && substr(line, i + 1, hashes) == hashstr && substr(line, i + 1 + hashes, 1) == "(") { out = out substr(line, i, 2 + hashes); i += 2 + hashes; push_interpolation() }
      else if (c3 == "\"\"\"" && substr(line, i + 3, hashes) == hashstr) { mode = "code"; out = out substr(line, i, 3 + hashes); i += 3 + hashes }
      else { out = out c; i++ }
    }
  }
  # A single-line string or raw string ends with its line, and so does every interpolation opened
  # inside one: unwind to the code around the outermost single-line string still open.
  k = 0
  for (q = 1; q <= sp; q++) if (stk_mode[q] == "str" || stk_mode[q] == "raw") { k = q; break }
  if (k > 0) { mode = "code"; parens = stk_parens[k]; sp = k - 1 }
  else if (mode == "str" || mode == "raw") mode = "code"
  apply(out)
}
AWK

# --- the source scan ---

# The allowed import set: AppKit, Foundation, and the package's own modules — the directories directly
# under Sources — read when the script runs, never held as a list here, so a new target is admitted by
# existing (and an import of it still has to pass every other row).
allowed=" AppKit Foundation"
if [ -d "$sources_dir" ]; then
  for module_dir in "$sources_dir"/*/; do
    [ -d "$module_dir" ] || continue
    module_name="$(basename "$module_dir")"
    allowed="$allowed $module_name"
  done
fi
allowed="$allowed "

swift_files=""
if [ -d "$sources_dir" ]; then
  swift_files="$(find "$sources_dir" -type f -name '*.swift' | LC_ALL=C sort)"
fi

swift_count=0
if [ -z "$swift_files" ]; then
  echo "no .swift file under ka-reader-mac/Sources — the scan read nothing" >> "$work/causes"
else
  while IFS= read -r swift_file; do
    swift_count=$((swift_count + 1))
    relative="${swift_file#"$product_root"/}"
    in_surfaces=0
    case "$relative" in
      ka-reader-mac/Sources/Surfaces/*) in_surfaces=1 ;;
    esac
    is_panel=0
    [ "$relative" = "ka-reader-mac/Sources/Shell/OpenFolderPanel.swift" ] && is_panel=1
    LC_ALL=C awk -v rel="$relative" -v allowed="$allowed" -v in_surfaces="$in_surfaces" -v is_panel="$is_panel" \
      -f "$work/scan.awk" "$swift_file" >> "$work/findings" \
      || die "the scan could not read $relative"
  done <<< "$swift_files"
fi

# --- the link check ---

if [ ! -f "$executable" ] || [ ! -r "$executable" ]; then
  echo "the executable is missing or unreadable: $executable" >> "$work/causes"
elif ! command -v otool > /dev/null 2>&1; then
  echo "otool not found on PATH — the link check cannot run" >> "$work/causes"
else
  otool_status=0
  otool -L "$executable" > "$work/otool.out" 2> "$work/otool.err" || otool_status=$?
  if [ "$otool_status" -ne 0 ]; then
    echo "otool -L failed on $executable (exit $otool_status): $(cat "$work/otool.err")" >> "$work/causes"
  else
    install_names=0
    while IFS= read -r otool_line; do
      # The header line and any per-architecture line end a path and start at the margin; an install
      # name is indented, followed by " (compatibility version …)".
      case "$otool_line" in
        [[:space:]]*) ;;
        *) continue ;;
      esac
      install_name="${otool_line#"${otool_line%%[![:space:]]*}"}"
      install_name="${install_name%% (compatibility version*}"
      [ -n "$install_name" ] || continue
      install_names=$((install_names + 1))
      case "/$install_name/" in
        */WebKit.framework/* | */JavaScriptCore.framework/*) echo "link: $install_name" >> "$work/findings" ;;
      esac
    done < "$work/otool.out"
    [ "$install_names" -gt 0 ] \
      || echo "otool printed no install name for $executable — the link check read nothing" >> "$work/causes"
  fi
fi

# --- the transport read ---

# Only where the executable was readable: a missing one is already a cause above, and naming it a
# second time says nothing new.
if [ -f "$executable" ] && [ -r "$executable" ]; then
  if ! command -v nm > /dev/null 2>&1; then
    echo "nm not found on PATH — the transport read cannot run" >> "$work/causes"
  else
    nm_status=0
    nm "$executable" > "$work/nm.out" 2> "$work/nm.err" || nm_status=$?
    if [ "$nm_status" -ne 0 ]; then
      echo "nm failed on $executable (exit $nm_status): $(cat "$work/nm.err")" >> "$work/causes"
    else
      # An nm line is `<address> <type letter> <name>` for a defined symbol and `<type letter> <name>`
      # for an undefined one (type U). Any other line — a fat binary's per-architecture header, a blank
      # — is no symbol, so a list of nothing else counts zero.
      LC_ALL=C awk -v count_file="$work/nm.count" '
        {
          if (NF == 3 && $1 ~ /^[0-9A-Fa-f]+$/ && $2 ~ /^[A-Za-z?-]$/) { type = $2; name = $3 }
          else if (NF == 2 && $1 ~ /^[A-Za-z?-]$/) { type = $1; name = $2 }
          else next
          symbols++
          sub(/^_/, "", name)
          if (type == "U") {
            if (name == "connect" || name == "socket" || name == "getaddrinfo") print "transport: undefined import " name
          } else if (name ~ /^git_smart_subtransport_/) print "transport: defined " name
        }
        END { print symbols + 0 > count_file }
      ' "$work/nm.out" >> "$work/findings"
      [ "$(cat "$work/nm.count")" -gt 0 ] \
        || echo "nm printed no symbol for $executable — the transport read read nothing" >> "$work/causes"
    fi
  fi
fi

# --- the verdict ---

if [ -s "$work/findings" ] || [ -s "$work/causes" ]; then
  cat "$work/findings" >&2
  while IFS= read -r cause; do
    echo "view.sh: $cause" >&2
  done < "$work/causes"
  exit 1
fi

echo "view.sh: $swift_count Swift files scanned under ka-reader-mac/Sources, $executable links no WebKit or JavaScriptCore and carries no Git transport — nothing found"
