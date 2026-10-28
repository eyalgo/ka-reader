#!/usr/bin/env bash
# Version: 1.0.0 — first version: the QC-53 banned-word lint over the string literals of the
#   message catalogue, with the banned set read from docs/CONTENT.md when it runs
#
# checks/strings.sh — fails when a string literal under ka-reader-mac/Sources/Surfaces holds a term
# docs/CONTENT.md § Terminology bans in the words KA-Reader writes.
#
# WHY THIS EXISTS
#   The words KA-Reader shows are written once, in the Swift files of the catalogue, and a banned
#   word in one of them is a sentence the product's own content rules refuse. A reviewer cannot
#   keep watching every literal for every term. This script reads the term list from the table and
#   the literals from the files, on every run.
#
# USAGE
#   checks/strings.sh [<product-root>]
#   With no argument the product root is the parent of this script's own directory, so a copy
#   placed at <root>/checks/strings.sh reads <root>. An argument selects the tree to read instead,
#   which is how checks/tests/test_strings.sh points the real script at a temporary copy. Either
#   way it reads docs/CONTENT.md and every *.swift file at any depth under the catalogue folder of
#   that root, and no other file. A finding is one line on stderr, one for each file and term pair,
#   `<path relative to the root>: QC-53: …`, and the exit is 1. A clean scan is exit 0 and one
#   line on stdout that counts the files and the terms it read, never a pass on reading nothing.
#   No file in the folder, or no term in the table, is exit 1 with one line saying so.
#
# THE BANNED SET
#   The *Never* cells of the table that follows the line "Banned in the words KA-Reader writes" in
#   docs/CONTENT.md. A cell is split at its commas after a gloss in parentheses is cut out, so
#   `the floor (of languages)` is the term `the floor`. A term is data: it is matched as plain
#   text, never as a pattern. No term, file, literal or hit is listed here to be skipped.
#
# WHAT COUNTS AS A HIT
#   Only the text of string literals is read: "…", """…""" and the raw forms with one or more `#`
#   on each side. Identifiers, keywords and every comment (//, /// and nested /* */) are skipped,
#   and so is a regular expression literal (#/…/# and a /…/ after an operator) and a backticked
#   name. Inside a literal, // and /* are text. The code inside \( … ) is skipped whole, the
#   strings and comments inside it with it, and the literal text on either side of it is checked as
#   separate pieces, never joined. Text is checked as spelled: \" \\ and \' stand for their own
#   character, every other escape (\n, \u{…}) is cut and is never decoded into a term. A term is a
#   hit when it appears in any letter case (ASCII case folding) and is a whole word: where it
#   starts or ends with a letter or digit, the character beside that end is not a letter, a digit,
#   `_` or a non-ASCII letter or digit.
#
# WHY AWK
#   The scan keeps state across lines and characters (comment depth, the open quote and its
#   hashes, the interpolation stack), which bash 3.2 does in minutes and awk in a moment. awk is
#   part of the userland macOS ships; the program is held in this file, so nothing is installed,
#   fetched or compiled, and the script reads no Swift toolchain output. It runs under LC_ALL=C, so
#   a byte is a character, and the letters outside ASCII are told from punctuation by their code
#   point in the table of is_letter_cp below.

set -euo pipefail

CATALOGUE="ka-reader-mac/Sources/Surfaces"
CONTENT="docs/CONTENT.md"
TABLE_TITLE="Banned in the words KA-Reader writes"
SEP=$'\037'

# --- the two awk programs ---

# Reads docs/CONTENT.md. Prints `table` and then each term, one to a line, or `notable` when the
# title is not followed by a table with a Never column.
awk_terms_program() {
  cat <<'AWK'
function trim(s) {
  sub(/^[ \t]+/, "", s)
  sub(/[ \t]+$/, "", s)
  return s
}

BEGIN { state = 0; col = 0; n = 0; header = 0 }

{
  line = $0
  sub(/\r$/, "", line)
  if (state == 0) {
    t = line
    gsub(/[*#:]/, "", t)
    if (trim(t) == title) state = 1
    next
  }
  if (state == 1) {
    if (trim(line) == "") next
    if (line !~ /^[ \t]*\|/) { state = 3; next }
    cells = split(line, c, "|")
    for (i = 2; i <= cells; i++) {
      h = c[i]
      gsub(/[*` \t]/, "", h)
      if (h == "Never") col = i
    }
    if (col == 0) { state = 3; next }
    header = 1
    state = 2
    next
  }
  if (state == 2) {
    if (line !~ /^[ \t]*\|/) { state = 3; next }
    if (line ~ /^[ \t]*\|[ \t:|-]*$/) next
    split(line, c, "|")
    cell = c[col]
    gsub(/\([^)]*\)/, "", cell)
    m = split(cell, parts, ",")
    for (j = 1; j <= m; j++) {
      term = trim(parts[j])
      if (term != "") terms[++n] = term
    }
  }
}

END {
  if (!header) { print "notable"; exit }
  print "table"
  for (i = 1; i <= n; i++) print terms[i]
}
AWK
}

# Reads the terms (first file) and then the Swift files. Prints `<file>\037<term>` for each file and
# term pair that hits, with the file as it was given.
awk_scan_program() {
  cat <<'AWK'
# --- the letters outside ASCII ---

# Whether the code point is a letter or a digit for the whole-word rule. The ranges that are not are
# the punctuation, symbols and controls: Latin-1 outside its letters, the general punctuation to
# the dingbats, the CJK symbols, the variation selectors, the full-width punctuation and the
# emoji planes. Every other code point is taken to be a letter.
function is_letter_cp(cp) {
  if (cp < 192) return (cp == 170 || cp == 181 || cp == 186)
  if (cp == 215 || cp == 247) return 0
  if (cp >= 8192 && cp <= 11263) return 0
  if (cp >= 12288 && cp <= 12351) return 0
  if (cp >= 65024 && cp <= 65039) return 0
  if (cp >= 65281 && cp <= 65295) return 0
  if (cp >= 65306 && cp <= 65312) return 0
  if (cp >= 65339 && cp <= 65344) return 0
  if (cp >= 65371 && cp <= 65381) return 0
  if (cp == 65533) return 0
  if (cp >= 126976) return 0
  return 1
}

# Whether the character that starts at byte pos of s is a letter, a digit or an underscore.
function word_at(s, pos,    b, o, cp, k) {
  b = substr(s, pos, 1)
  if (b ~ /[A-Za-z0-9_]/) return 1
  o = ord[b] + 0
  if (o < 192) return 0
  if (o < 224) cp = (o - 192) * 64 + (ord[substr(s, pos + 1, 1)] + 0) - 128
  else if (o < 240) cp = (o - 224) * 4096 + ((ord[substr(s, pos + 1, 1)] + 0) - 128) * 64 + (ord[substr(s, pos + 2, 1)] + 0) - 128
  else if (o < 248) cp = (o - 240) * 262144 + ((ord[substr(s, pos + 1, 1)] + 0) - 128) * 4096 + ((ord[substr(s, pos + 2, 1)] + 0) - 128) * 64 + (ord[substr(s, pos + 3, 1)] + 0) - 128
  else return 0
  return is_letter_cp(cp)
}

# The same for the character that ends at byte pos: step back over its continuation bytes first.
function word_ending_at(s, pos,    b, o, steps) {
  b = substr(s, pos, 1)
  if (b ~ /[A-Za-z0-9_]/) return 1
  steps = 0
  while (pos > 1 && steps < 3) {
    o = ord[substr(s, pos, 1)] + 0
    if (o < 128 || o >= 192) break
    pos--
    steps++
  }
  return word_at(s, pos)
}

# --- matching ---

# Whether the term low[k], found at byte p of the lowered text ft, stands as a whole word.
function whole_word(ft, p, k,    tl, n) {
  tl = low[k]
  n = length(tl)
  if (substr(tl, 1, 1) ~ /[a-z0-9]/ && p > 1 && word_ending_at(ft, p - 1)) return 0
  if (substr(tl, n, 1) ~ /[a-z0-9]/ && p + n <= length(ft) && word_at(ft, p + n)) return 0
  return 1
}

# Records each term the text of one literal piece holds.
function check(text,    ft, k, off, p) {
  ft = tolower(text)
  for (k = 1; k <= nt; k++) {
    off = 1
    while ((p = index(substr(ft, off), low[k])) > 0) {
      p = p + off - 1
      if (whole_word(ft, p, k)) { hit[cur SUBSEP orig[k]] = 1; break }
      off = p + 1
    }
  }
}

# --- the stack of what is open ---

function push_code() {
  sp++
  ftype[sp] = "C"
  fparen[sp] = 0
  ftext[sp] = ""
}

# A literal opened inside the code of an interpolation is code, so its text is never checked.
function push_string(h, multi,    inside_code) {
  inside_code = (sp > 1 && ftype[sp] == "C")
  sp++
  fskip[sp] = inside_code
  ftype[sp] = "S"
  fh[sp] = h
  fmulti[sp] = multi
  ftext[sp] = ""
}

function flush(t) {
  if (ftext[t] != "" && !fskip[t]) check(ftext[t])
  ftext[t] = ""
}

function start_file() {
  sp = 1
  ftype[1] = "C"
  fparen[1] = 0
  ftext[1] = ""
  cd = 0
  rxh = -1
  skipnl = 0
}

function finish_file() {
  if (cur == "") return
  while (sp >= 1) {
    if (ftype[sp] == "S") flush(sp)
    sp--
  }
}

# --- scanning ---

# Whether h hash signs start at byte pos of line.
function hashes_follow(line, pos, h) {
  if (h == 0) return 1
  return substr(line, pos, h) == substr("##########################", 1, h)
}

function count_hashes(line, pos, n,    h) {
  h = 0
  while (pos + h <= n && substr(line, pos + h, 1) == "#") h++
  return h
}

# The last character before byte pos that is not a space or a tab, or "" at the start of the line.
function previous_code_char(line, pos,    c) {
  pos--
  while (pos >= 1) {
    c = substr(line, pos, 1)
    if (c != " " && c != "\t") return c
    pos--
  }
  return ""
}

# The byte at which a /regex/ literal that starts at byte pos ends, or 0 when the slash is not the
# start of one: it follows an operator or an opening bracket, it is not followed by a space, and
# the closing slash is on the same line.
function regex_end(line, pos, n,    prev, nxt, j, c) {
  prev = previous_code_char(line, pos)
  nxt = substr(line, pos + 1, 1)
  if (nxt == " " || nxt == "\t" || nxt == "=" || nxt == "") return 0
  if (prev != "" && index("(,=:[;?!&|<>^%", prev) == 0) return 0
  for (j = pos + 1; j <= n; j++) {
    c = substr(line, j, 1)
    if (c == "\\") { j++; continue }
    if (c == "/") return j
  }
  return 0
}

# Opens the literal whose first quote is at byte qpos, with h hashes. Returns the byte after its
# opening delimiter.
function open_string(line, qpos, h) {
  if (substr(line, qpos, 3) == "\"\"\"") { push_string(h, 1); return qpos + 3 }
  push_string(h, 0)
  return qpos + 1
}

# One step at byte i of line while a literal is the top of the stack. Returns the next byte.
function string_step(line, i, n,    t, h, multi, c, k, e, j) {
  t = sp
  h = fh[t]
  multi = fmulti[t]
  c = substr(line, i, 1)
  if (c == "\\" && hashes_follow(line, i + 1, h)) {
    e = i + 1 + h
    k = substr(line, e, 1)
    if (k == "(") {
      flush(t)
      push_code()
      return e + 1
    }
    if (k == "") {
      skipnl = 1
      return n + 1
    }
    if (k == "\"" || k == "\\" || k == "'") ftext[t] = ftext[t] k
    else ftext[t] = ftext[t] "\001"
    if (k == "u" && substr(line, e + 1, 1) == "{") {
      j = index(substr(line, e + 2), "}")
      if (j > 0) return e + 2 + j
    }
    return e + 1
  }
  if (c == "\"") {
    if (multi) {
      if (substr(line, i, 3) == "\"\"\"" && hashes_follow(line, i + 3, h)) {
        flush(t)
        sp--
        return i + 3 + h
      }
    } else if (hashes_follow(line, i + 1, h)) {
      flush(t)
      sp--
      return i + 1 + h
    }
  }
  ftext[t] = ftext[t] c
  return i + 1
}

function scan_line(line,    n, i, c, c2, h, k, j, top) {
  n = length(line)
  i = 1
  while (i <= n) {
    if (rxh >= 0) {
      c = substr(line, i, 1)
      if (c == "\\") { i += 2; continue }
      if (c == "/" && hashes_follow(line, i + 1, rxh)) { i += 1 + rxh; rxh = -1; continue }
      i++
      continue
    }
    if (ftype[sp] == "S") { i = string_step(line, i, n); continue }
    c = substr(line, i, 1)
    c2 = substr(line, i, 2)
    if (cd > 0) {
      if (c2 == "/*") { cd++; i += 2 }
      else if (c2 == "*/") { cd--; i += 2 }
      else i++
      continue
    }
    if (c2 == "//") break
    if (c2 == "/*") { cd = 1; i += 2; continue }
    if (c == "`") {
      j = index(substr(line, i + 1), "`")
      if (j == 0) break
      i += j + 1
      continue
    }
    if (c == "\"") { i = open_string(line, i, 0); continue }
    if (c == "#") {
      h = count_hashes(line, i, n)
      k = substr(line, i + h, 1)
      if (k == "\"") { i = open_string(line, i + h, h); continue }
      if (k == "/") { rxh = h; i += h + 1; continue }
      i += h
      continue
    }
    if (c == "/") {
      j = regex_end(line, i, n)
      if (j > 0) { i = j + 1; continue }
      i++
      continue
    }
    if (c == "(" && sp > 1) { fparen[sp]++; i++; continue }
    if (c == ")" && sp > 1) {
      if (fparen[sp] == 0) sp--
      else fparen[sp]--
      i++
      continue
    }
    i++
  }
  top = sp
  if (rxh < 0 && ftype[top] == "S") {
    if (fmulti[top]) {
      if (!skipnl) ftext[top] = ftext[top] "\n"
    } else {
      flush(top)
      sp--
    }
  }
  skipnl = 0
}

BEGIN {
  for (i = 1; i < 256; i++) ord[sprintf("%c", i)] = i
  nt = 0
  cur = ""
}

FILENAME == ARGV[1] {
  if ($0 != "") { nt++; orig[nt] = $0; low[nt] = tolower($0) }
  next
}

{
  if (FILENAME != cur) {
    finish_file()
    cur = FILENAME
    start_file()
  }
  scan_line($0)
}

END {
  finish_file()
  for (key in hit) {
    split(key, parts, SUBSEP)
    print parts[1] "\037" parts[2]
  }
}
AWK
}

# --- args ---

if [ "$#" -gt 1 ]; then
  echo "strings.sh: takes no argument or one, the product root; arguments given: $#. Run checks/strings.sh, or checks/strings.sh followed by the root of a KA-Reader checkout." >&2
  exit 1
fi

if [ "$#" -eq 1 ]; then
  root="$1"
  [ ! -d "$root" ] || root="$(cd "$root" && pwd)"
else
  root="$(cd "$(dirname "$0")/.." && pwd)"
fi
[ "$root" = "/" ] || root="${root%/}"

# --- the inputs ---

files=()
if [ -d "$root/$CATALOGUE" ]; then
  while IFS= read -r file; do
    files+=("$file")
  done < <(find "$root/$CATALOGUE" -type f -name '*.swift' | LC_ALL=C sort)
fi
if [ "${#files[@]}" -eq 0 ]; then
  echo "strings.sh: no .swift file was found under $CATALOGUE in $root, so nothing was checked. Run the checks/strings.sh of a KA-Reader checkout that has that folder, or give that checkout's root as its one argument." >&2
  exit 1
fi

if [ ! -f "$root/$CONTENT" ] || [ ! -r "$root/$CONTENT" ]; then
  echo "strings.sh: cannot read $CONTENT in $root, so no banned term was read and nothing was checked. Run the checks/strings.sh of a KA-Reader checkout that has that file, or give that checkout's root as its one argument." >&2
  exit 1
fi

table_out="$(LC_ALL=C awk -v title="$TABLE_TITLE" "$(awk_terms_program)" "$root/$CONTENT")"
if [ "${table_out%%$'\n'*}" != "table" ]; then
  echo "strings.sh: $CONTENT in $root has no \"$TABLE_TITLE\" table, so no banned term was read and nothing was checked. Run the checks/strings.sh of a KA-Reader checkout whose $CONTENT has that table, or give that checkout's root as its one argument." >&2
  exit 1
fi
terms="$(printf '%s\n' "$table_out" | sed 1d)"
if [ -z "$terms" ]; then
  echo "strings.sh: the \"$TABLE_TITLE\" table in $CONTENT in $root has no term in its Never column, so nothing was checked. Run the checks/strings.sh of a KA-Reader checkout whose table lists its terms, or give that checkout's root as its one argument." >&2
  exit 1
fi
term_count="$(printf '%s\n' "$terms" | grep -c . || true)"

# --- the scan ---

readable=()
unreadable=()
for file in "${files[@]}"; do
  if [ -r "$file" ]; then
    readable+=("$file")
  else
    unreadable+=("${file#"$root"/}")
  fi
done

findings=""
if [ "${#readable[@]}" -gt 0 ]; then
  findings="$(LC_ALL=C awk "$(awk_scan_program)" <(printf '%s\n' "$terms") "${readable[@]}" | LC_ALL=C sort -u)"
fi

failed=0
if [ -n "$findings" ]; then
  failed=1
  while IFS= read -r finding; do
    path="${finding%%"$SEP"*}"
    term="${finding#*"$SEP"}"
    echo "${path#"$root"/}: QC-53: a string literal holds \"$term\", matched in any letter case, a term docs/CONTENT.md § Terminology bans in the words KA-Reader writes. Reword each literal in this file that holds it, using that table's \"Say instead\" column, then run checks/strings.sh again." >&2
  done <<EOF
$findings
EOF
fi

if [ "${#unreadable[@]}" -gt 0 ]; then
  failed=1
  for path in "${unreadable[@]}"; do
    echo "strings.sh: cannot read $path, so the string literals in it were not checked. Make the file readable, then run checks/strings.sh again." >&2
  done
fi

[ "$failed" -eq 0 ] || exit 1

echo "strings.sh: ok — no string literal in the Swift files under $CATALOGUE holds a term $CONTENT § Terminology bans; Swift files read: ${#readable[@]}; banned terms read: $term_count"
