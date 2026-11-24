#!/usr/bin/env bash
# Version: 1.0.0 — first version: the README's release badge held to the product's version
#
# checks/readme-badge.sh — fails when the README's opening shows no release badge, or when the
# badge's alternative text or its picture does not carry the product's version.
#
# WHY THIS EXISTS
#   The README's opening shows six badges, and the release badge is a claim: it names the version
#   a reader gets. Every badge is a picture stored in this repository and never fetched, so nothing
#   changes the release badge when the version moves. This check holds what a command can read: the
#   badge's alternative text in README.md, and the value in its picture's text, carry the version
#   Cargo.toml and ka-reader-mac/Info.plist carry. A version moved without the badge fails here.
#   checks/readme-picture.sh holds the README's screenshot and tells the badges from it. This
#   check's cases are checks/tests/test_readme_badge.sh.
#
# USAGE
#   checks/readme-badge.sh, from the product root. It takes no argument and reads no variable of
#   its own.
#
# WHAT IT READS
#   README.md up to its first line that begins "## ", which is the opening, and each inline image
#   there: ![alt](path), with an optional "title" after the path. The release badge is the
#   opening's first image whose path is exactly docs/readme/badges/release.svg. That file, read as
#   text. The one version = line of Cargo.toml's [workspace.package] table, and the <string> after
#   <key>CFBundleShortVersionString</key> in ka-reader-mac/Info.plist, each read as text. The
#   programs that read the opening and the two versions are copied byte for byte from
#   checks/readme-picture.sh, between the same marker lines, and checks/tests/test_readme_badge.sh
#   fails when a copy differs, so the two checks agree on what an image is and what the product's
#   version is. It runs no git.
#
# CARRYING THE VERSION
#   The alternative text carries a version when the version occurs in it as a whole word: no digit
#   and no . directly before it, and directly after it no digit and no . followed by a digit. So
#   "Release: 0.1.1", "v0.1.1" and "0.1.1." carry 0.1.1, and "0.1.10" and "10.1.1" do not. The
#   picture carries a version when one of its lines holds <text and, after it on the same line,
#   >VERSION</text>: a <text> element whose whole content is the bare version. When Cargo.toml and
#   Info.plist carry different versions, each half has to carry both. The version a line names as
#   the badge's is the first run of digits followed by one or more groups of . and digits: in the
#   alternative text, or in the whole content of one of the picture's <text> elements.
#
# THE CONDITIONS
#   Every condition is evaluated before any is reported. Each one that holds prints one stderr line,
#   in this order:
#   (r) README.md cannot be read; when (r) holds, (i) and (ii) are not evaluated;
#   (i) no image in the opening is the release badge;
#   (v) Cargo.toml's version cannot be read, or Info.plist's, or neither can; when (v) holds, (ii)
#       and the version half of (iii) are not evaluated;
#   (ii) the release badge is in the opening, and its alternative text does not carry Cargo.toml's
#       version, or does not carry Info.plist's;
#   (iii) docs/readme/badges/release.svg is missing or cannot be read, whether or not (v) holds; or,
#       when both versions are read, the picture does not carry Cargo.toml's version, or does not
#       carry Info.plist's.
#   On a pass, one stdout line names the badge and the version it carries, and stderr is empty. On
#   a failure, stdout is empty.
#
# NO FILE IS WRITTEN
#   The check writes nothing, in the repository or anywhere else.
#
# STATUSES (docs/nfdr.md QC-70)
#   0 on a pass, and only on a pass. 1 when a condition holds or the check could not complete. 2 on
#   a wrong invocation, with the usage line on stderr, before anything is read. 129 on HUP, 130 on
#   INT and 143 on TERM, through the script's own trap. A signal that lands inside a command
#   substitution may end the run with 1 instead, never with 0.
set -euo pipefail

reported=0
# Any way out with a non-zero status that no line has named is the check not completing: it says so,
# and ends with 1, never 0.
trap 'status=$?; if [ "$status" -ne 0 ] && [ "$reported" -eq 0 ]; then reported=1; printf "%s\n" "readme-badge.sh: could not complete the check. Check that README.md, docs/readme/badges/release.svg, Cargo.toml and ka-reader-mac/Info.plist are readable and that awk runs, then run checks/readme-badge.sh from the product root." >&2; exit 1; fi' EXIT
interrupted() {
  reported=1
  printf 'readme-badge.sh: interrupted by %s; the check did not complete. Run checks/readme-badge.sh from the product root to check again.\n' "$1" >&2
  exit "$2"
}
trap 'interrupted HUP 129' HUP
trap 'interrupted INT 130' INT
trap 'interrupted TERM 143' TERM

if [ "$#" -ne 0 ]; then
  reported=1
  printf '%s\n' 'Usage: checks/readme-badge.sh, run from the product root with no argument.' >&2
  exit 2
fi

# The product root is derived from this file's own place, as the other checks derive it.
case "$0" in */*) here="${0%/*}";; *) here=.;; esac
root="$(cd "$here/.." && pwd -P)"

readme_file="$root/README.md"
cargo_file="$root/Cargo.toml"
plist_file="$root/ka-reader-mac/Info.plist"
badge_name='docs/readme/badges/release.svg'
badge_file="$root/$badge_name"
again='then run checks/readme-badge.sh from the product root.'

# --- the awk programs, each read as text ---

# The opening's images: one line per inline image, the alternative text, a tab, the path. This
# program is checks/readme-picture.sh's own, copied byte for byte between the same two marker
# lines, and checks/tests/test_readme_badge.sh fails when the two copies differ. Change it there
# first, then copy it here.
# opening-images-program: begin
opening_images='
{ sub(/\r$/, "") }
/^## / { exit }
{
  rest = $0
  while (match(rest, /!\[[^]]*\]\([^)]*\)/)) {
    image = substr(rest, RSTART, RLENGTH)
    rest = substr(rest, RSTART + RLENGTH)
    alt_end = index(image, "](")
    alt = substr(image, 3, alt_end - 3)
    inside = substr(image, alt_end + 2, length(image) - alt_end - 2)
    sub(/^[ \t]+/, "", inside)
    sub(/[ \t]+$/, "", inside)
    if (inside == "") continue
    split_at = match(inside, /[ \t]/)
    if (split_at == 0) {
      path = inside
    } else {
      path = substr(inside, 1, split_at - 1)
      title = substr(inside, split_at)
      sub(/^[ \t]+/, "", title)
      if (title !~ /^"[^"]*"$/) continue
    }
    print alt "\t" path
  }
}
'
# opening-images-program: end

# The product's version, from Cargo.toml and then from Info.plist. These two programs are
# checks/readme-picture.sh's own, copied byte for byte between the same two marker lines, and
# checks/tests/test_readme_badge.sh fails when the two copies differ. Change them there first, then
# copy them here.
# product-version-programs: begin
# Cargo.toml: the one version line of the [workspace.package] table, or status 3.
cargo_program='
/^\[/ { in_table = ($0 ~ /^\[workspace\.package\][ \t]*$/); next }
in_table && /^version[ \t]*=[ \t]*"[^"]+"[ \t]*(#.*)?$/ {
  value = $0
  sub(/^version[ \t]*=[ \t]*"/, "", value)
  sub(/".*$/, "", value)
  count++
  found = value
}
END { if (count != 1) exit 3; print found }
'

# Info.plist: the one <string> after the one CFBundleShortVersionString key, or status 3.
plist_program='
{
  text = $0
  if (index(text, "<key>CFBundleShortVersionString</key>")) {
    keys++
    want = 1
    sub(/.*<key>CFBundleShortVersionString<\/key>/, "", text)
  }
  if (want) {
    if (text ~ /^[ \t\r]*$/) next
    if (match(text, /<string>[^<]+<\/string>/)) {
      strings++
      found = substr(text, RSTART + 8, RLENGTH - 17)
    }
    want = 0
  }
}
END { if (keys != 1 || strings != 1) exit 3; print found }
'
# product-version-programs: end

# Whether the text on the first line of the input carries the version in $version: the version occurs
# in it as a whole word. The literal occurrence is found with index, never as a pattern, because the
# dots of a version would match any character.
carries_program='
function carries(text, wanted,    from, at, before, after_one, after_two) {
  from = 1
  while ((at = index(substr(text, from), wanted)) > 0) {
    at = at + from - 1
    before = ""
    if (at > 1) before = substr(text, at - 1, 1)
    after_one = substr(text, at + length(wanted), 1)
    after_two = substr(text, at + length(wanted) + 1, 1)
    if (before !~ /[0-9.]/ && after_one !~ /[0-9]/ && !(after_one == "." && after_two ~ /[0-9]/)) return 1
    from = at + 1
  }
  return 0
}
NR == 1 { if (carries($0, version)) print "yes"; else print "no" }
'

# The first run in the text on the first line of the input that is digits then one or more groups of a
# dot and digits, or nothing.
first_version_program='
match($0, /[0-9]+(\.[0-9]+)+/) { print substr($0, RSTART, RLENGTH); exit }
'

# The picture's text: the whole content of each <text ...>...</text> element, one per line.
svg_texts_program='
{
  rest = $0
  while (match(rest, /<text[^>]*>[^<]*<\/text>/)) {
    element = substr(rest, RSTART, RLENGTH)
    rest = substr(rest, RSTART + RLENGTH)
    sub(/^<text[^>]*>/, "", element)
    sub(/<\/text>$/, "", element)
    print element
  }
}
'

# Whether a line of the picture holds <text and, after it on that line, the literal >VERSION</text>.
svg_carries_program='
{
  at = index($0, "<text")
  if (at > 0 && index(substr($0, at), ">" version "</text>") > 0) found = 1
}
END { if (found) print "yes"; else print "no" }
'

# Runs awk with one program over one file. The text goes to $awk_text, the status to $awk_status.
# A status other than 0 and 3 is awk not running at all, which no condition can be judged on.
run_awk() {
  awk_status=0
  awk_text="$(LC_ALL=C awk "$1" "$2" 2> /dev/null)" || awk_status=$?
}

# Runs awk with one program, and an optional version, over the text in $3. The text goes to $awk_text.
run_awk_on_text() {
  awk_status=0
  awk_text="$(printf '%s\n' "$3" | LC_ALL=C awk -v version="$2" "$1" 2> /dev/null)" || awk_status=$?
  [ "$awk_status" -eq 0 ] || exit 1
}

findings=''
finding() {
  findings="$findings$1"$'\n'
}

# --- (r) the README, and the release badge in its opening ---

images=''
readme_readable=1
if [ -f "$readme_file" ] && [ -r "$readme_file" ]; then
  run_awk "$opening_images" "$readme_file"
  [ "$awk_status" -eq 0 ] || exit 1
  images="$awk_text"
else
  readme_readable=0
fi

badge_found=0
badge_alt=''
if [ "$readme_readable" -eq 1 ] && [ -n "$images" ]; then
  badge_line="$(printf '%s\n' "$images" | awk -F'\t' -v want="$badge_name" '$2 == want { print; exit }')" || exit 1
  if [ -n "$badge_line" ]; then
    badge_found=1
    badge_alt="${badge_line%%$'\t'*}"
  fi
fi

# --- the product's version, from Cargo.toml and Info.plist ---

cargo_version=''
plist_version=''
cargo_read=0
plist_read=0
if [ -f "$cargo_file" ] && [ -r "$cargo_file" ]; then
  run_awk "$cargo_program" "$cargo_file"
  case "$awk_status" in
    0) cargo_version="$awk_text"; cargo_read=1;;
    3) ;;
    *) exit 1;;
  esac
fi
if [ -f "$plist_file" ] && [ -r "$plist_file" ]; then
  run_awk "$plist_program" "$plist_file"
  case "$awk_status" in
    0) plist_version="$awk_text"; plist_read=1;;
    3) ;;
    *) exit 1;;
  esac
fi
versions_read=0
if [ "$cargo_read" -eq 1 ] && [ "$plist_read" -eq 1 ]; then
  versions_read=1
fi

if [ "$readme_readable" -eq 0 ]; then
  finding "readme-badge.sh: README.md: cannot read this file. Make this file readable, $again"
fi

# --- (i) the opening shows the release badge ---

if [ "$readme_readable" -eq 1 ] && [ "$badge_found" -eq 0 ]; then
  if [ "$versions_read" -eq 1 ]; then
    finding "readme-badge.sh: $badge_name: no image in README.md's opening, before its first ## heading, names this file, and the product carries $cargo_version in Cargo.toml and $plist_version in ka-reader-mac/Info.plist. Add an image line naming this file to the opening's badge row, after the licence badge, with an alternative text that carries the product's version, $again"
  else
    finding "readme-badge.sh: $badge_name: no image in README.md's opening, before its first ## heading, names this file. Add an image line naming this file to the opening's badge row, after the licence badge, with an alternative text that carries the product's version, $again"
  fi
fi

# --- (v) the product's version can be read ---

if [ "$cargo_read" -eq 0 ] && [ "$plist_read" -eq 1 ]; then
  finding "readme-badge.sh: $badge_name: the release badge cannot be compared with the product's version: Cargo.toml's [workspace.package] table holds no single version line this check can read, and ka-reader-mac/Info.plist carries $plist_version. Give that table exactly one version line, $again"
elif [ "$cargo_read" -eq 1 ] && [ "$plist_read" -eq 0 ]; then
  finding "readme-badge.sh: $badge_name: the release badge cannot be compared with the product's version: Cargo.toml carries $cargo_version, and ka-reader-mac/Info.plist holds no single <string> after <key>CFBundleShortVersionString</key> that this check can read. Give Info.plist exactly one such key with its <string>, $again"
elif [ "$cargo_read" -eq 0 ] && [ "$plist_read" -eq 0 ]; then
  finding "readme-badge.sh: $badge_name: the release badge cannot be compared with the product's version: neither Cargo.toml's [workspace.package] table nor ka-reader-mac/Info.plist holds a single version this check can read. Give each exactly one version, $again"
fi

# --- (ii) the alternative text carries the product's version ---

if [ "$badge_found" -eq 1 ] && [ "$versions_read" -eq 1 ]; then
  run_awk_on_text "$carries_program" "$cargo_version" "$badge_alt"
  alt_has_cargo="$awk_text"
  run_awk_on_text "$carries_program" "$plist_version" "$badge_alt"
  alt_has_plist="$awk_text"
  if [ "$alt_has_cargo" != yes ] || [ "$alt_has_plist" != yes ]; then
    run_awk_on_text "$first_version_program" "" "$badge_alt"
    alt_version="$awk_text"
    if [ -n "$alt_version" ]; then
      finding "readme-badge.sh: $badge_name: the release badge's alternative text in README.md carries version $alt_version, and the product carries $cargo_version in Cargo.toml and $plist_version in ka-reader-mac/Info.plist. Write the product's version in that alternative text, $again"
    else
      finding "readme-badge.sh: $badge_name: the release badge's alternative text in README.md carries no version, and the product carries $cargo_version in Cargo.toml and $plist_version in ka-reader-mac/Info.plist. Write the product's version in that alternative text, $again"
    fi
  fi
fi

# --- (iii) the picture carries the product's version ---

svg_read=0
if [ ! -e "$badge_file" ]; then
  finding "readme-badge.sh: $badge_name: no file is there. Add the release badge picture at this path, with the product's version as its value, and commit it together with the README's badge line, $again"
elif [ ! -f "$badge_file" ] || [ ! -r "$badge_file" ]; then
  finding "readme-badge.sh: $badge_name: cannot read this file. Make this file readable, $again"
else
  svg_read=1
fi
if [ "$svg_read" -eq 1 ] && [ "$versions_read" -eq 1 ]; then
  svg_has_cargo="$(LC_ALL=C awk -v version="$cargo_version" "$svg_carries_program" "$badge_file")" || exit 1
  svg_has_plist="$(LC_ALL=C awk -v version="$plist_version" "$svg_carries_program" "$badge_file")" || exit 1
  if [ "$svg_has_cargo" != yes ] || [ "$svg_has_plist" != yes ]; then
    svg_version="$(LC_ALL=C awk "$svg_texts_program" "$badge_file" | awk '/[0-9]+(\.[0-9]+)+/ { match($0, /[0-9]+(\.[0-9]+)+/); print substr($0, RSTART, RLENGTH); exit }')" || exit 1
    if [ -n "$svg_version" ]; then
      finding "readme-badge.sh: $badge_name: this picture's text carries version $svg_version, and the product carries $cargo_version in Cargo.toml and $plist_version in ka-reader-mac/Info.plist. Change the version in this file's <text> elements, the value the picture shows, to the product's version, $again"
    else
      finding "readme-badge.sh: $badge_name: this picture carries no version: none of its <text> elements holds a version and nothing else, and the product carries $cargo_version in Cargo.toml and $plist_version in ka-reader-mac/Info.plist. Give the picture's value one <text> element whose whole content is the product's version, on the same line as its opening tag, $again"
    fi
  fi
fi

# --- the verdict ---

if [ -n "$findings" ]; then
  reported=1
  printf '%s' "$findings" >&2
  exit 1
fi
shown_version="$cargo_version"
if [ "$cargo_version" != "$plist_version" ]; then
  shown_version="$cargo_version and $plist_version"
fi
reported=1
printf "readme-badge.sh: the README's release badge, %s, carries version %s in its alternative text and in its picture, the version Cargo.toml and ka-reader-mac/Info.plist carry.\n" "$badge_name" "$shown_version"
