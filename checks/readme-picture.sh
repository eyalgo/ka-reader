#!/usr/bin/env bash
# Version: 1.1.0 — the badge pictures: (c) admits them, the new (g) fails an opening that shows
#   nothing else, and (d)'s fallback skips them
# Version: 1.0.0 — first version: the README's picture held to its record and to the product's version
#
# checks/readme-picture.sh — fails when the README's opening does not show the picture the capture
# recorded, or when that picture or its record no longer matches the product.
#
# WHY THIS EXISTS
#   The README's opening shows one picture of KA-Reader's window, and the picture is a claim: it
#   shows the shell the release ships (docs/UXD.md UX-I11). A command cannot look at pixels, so this
#   check holds what a command can read. The opening names the picture docs/readme/shell.record
#   names. The file there is tracked, and its bytes are the ones the record's SHA-256 names. The
#   record's version is the one Cargo.toml and ka-reader-mac/Info.plist carry. A picture captured at
#   another version, or changed after its capture, fails here. A capture at the same version after a
#   later change to the shell does not fail here; release inspection holds that case.
#   checks/readme-capture.sh writes the picture and the record. This check's cases are
#   checks/tests/test_readme_picture.sh.
#
# USAGE
#   checks/readme-picture.sh, from the product root. It takes no argument and reads no variable of
#   its own.
#
# WHAT IT READS
#   README.md up to its first line that begins "## ", which is the opening, and each inline image
#   there: ![alt](path), with an optional "title" after the path. No other image form counts.
#   docs/readme/shell.record, the file it names, and Git's tracked list for that file. The one
#   version = line of Cargo.toml's [workspace.package] table, and the <string> after
#   <key>CFBundleShortVersionString</key> in ka-reader-mac/Info.plist, each read as text.
#
# THE RECORD
#   Exactly four lines, in this order, and nothing else:
#     picture: <repository-relative path, with no .. component and no scheme>
#     version: <the version Cargo.toml and Info.plist both carry>
#     commit: <40 lowercase hex digits>
#     sha256: <64 lowercase hex digits>
#
# THE BADGE PICTURES
#   The opening also shows the README's badges, and each one is a picture stored under
#   docs/readme/badges/. An image in the opening is a badge picture when all three of these hold:
#   its path, as README.md writes it, begins with docs/readme/badges/ and goes on past it; no
#   /-separated part of the path is ..; and, when the record can be read, the path is not the
#   record's picture. The path is compared as text, and nothing outside the repository is read for
#   it. Whether a badge's file is there and tracked is checks/readme.sh's to check, and this check
#   does not repeat it. checks/readme-badge.sh holds the release badge to the product's version.
#
# THE CONDITIONS
#   Every condition is evaluated before any is reported. Each one that holds prints one stderr line,
#   in this order:
#   (a) the opening holds no image, or README.md cannot be read;
#   (b) the record is missing, cannot be read, or is not in the form above;
#   (c) when (a) and (b) pass: an image in the opening is neither the record's picture nor a badge
#       picture;
#   (d) the picture is missing or not tracked; when (b) holds, the opening's first image that is not
#       a badge picture is checked instead, and when there is no such image, (d) is not evaluated;
#   (e) when (b) passes and the picture is there: its SHA-256 is not the record's;
#   (f) when (b) passes: the record's version differs from Cargo.toml's or Info.plist's, or either
#       of those cannot be read;
#   (g) when (a) and (b) pass: every image in the opening is a badge picture, so none of them is the
#       record's picture.
#   On a pass, one stdout line names the picture and the record's version, and stderr is empty.
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
trap 'status=$?; if [ "$status" -ne 0 ] && [ "$reported" -eq 0 ]; then reported=1; printf "%s\n" "readme-picture.sh: could not complete the check. Check that README.md, docs/readme/, Cargo.toml, ka-reader-mac/Info.plist and the Git checkout are readable and that git, awk and shasum run, then run checks/readme-picture.sh from the product root." >&2; exit 1; fi' EXIT
interrupted() {
  reported=1
  printf 'readme-picture.sh: interrupted by %s; the check did not complete. Run checks/readme-picture.sh from the product root to check again.\n' "$1" >&2
  exit "$2"
}
trap 'interrupted HUP 129' HUP
trap 'interrupted INT 130' INT
trap 'interrupted TERM 143' TERM

if [ "$#" -ne 0 ]; then
  reported=1
  printf '%s\n' 'Usage: checks/readme-picture.sh, run from the product root with no argument.' >&2
  exit 2
fi

# The product root is derived from this file's own place, as the other checks derive it.
case "$0" in */*) here="${0%/*}";; *) here=.;; esac
root="$(cd "$here/.." && pwd -P)"

readme_file="$root/README.md"
record_file="$root/docs/readme/shell.record"
cargo_file="$root/Cargo.toml"
plist_file="$root/ka-reader-mac/Info.plist"
record_name='docs/readme/shell.record'
again='then run checks/readme-picture.sh from the product root.'

# --- the awk programs, each read as text ---

# The opening's images: one line per inline image, the alternative text, a tab, the path. The
# opening ends at the first line that begins "## ". checks/tests/test_readme_picture.sh reads this
# one program between the two marker lines, and checks/readme-badge.sh holds a byte-for-byte copy
# of it between the same two lines, so the check, its suite and the badge check agree on what an
# image is.
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

# The record: four lines, the four keys in order, each value in its shape. On a record that holds,
# its four values on one line, tab-separated; on any other, status 3.
record_program='
BEGIN { split("picture version commit sha256", keys, " ") }
{
  if (NR > 4) { bad = 1; next }
  prefix = keys[NR] ": "
  if (substr($0, 1, length(prefix)) != prefix) { bad = 1; next }
  value[NR] = substr($0, length(prefix) + 1)
}
END {
  if (NR != 4 || bad) exit 3
  picture = value[1]; version = value[2]; commit = value[3]; digest = value[4]
  if (picture == "" || picture ~ /^\// || picture ~ /^[A-Za-z][A-Za-z0-9+.-]*:/ || picture ~ /\t/) exit 3
  parts_count = split(picture, parts, "/")
  for (i = 1; i <= parts_count; i++) if (parts[i] == "..") exit 3
  if (version == "" || version ~ /[ \t]/) exit 3
  if (length(commit) != 40 || commit !~ /^[0-9a-f]+$/) exit 3
  if (length(digest) != 64 || digest !~ /^[0-9a-f]+$/) exit 3
  print picture "\t" version "\t" commit "\t" digest
}
'

# The product's version, from Cargo.toml and then from Info.plist. checks/readme-badge.sh holds a
# byte-for-byte copy of these two programs between the same two marker lines, and its suite fails
# when the two copies differ, so the two checks agree on what the product's version is.
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

# The images that are not badge pictures: the paths of the opening's image lines (alternative text, a
# tab, the path) that are not under docs/readme/badges/. The prefix is compared as text.
non_badge_program='
function is_badge(path,    prefix, parts_count, parts, i) {
  prefix = "docs/readme/badges/"
  if (substr(path, 1, length(prefix)) != prefix) return 0
  if (length(path) == length(prefix)) return 0
  parts_count = split(path, parts, "/")
  for (i = 1; i <= parts_count; i++) if (parts[i] == "..") return 0
  if (record_read == 1 && path == picture) return 0
  return 1
}
{
  path = substr($0, index($0, "\t") + 1)
  if (!is_badge(path)) print path
}
'

# Runs awk with one program over one file. The text goes to $awk_text, the status to $awk_status.
# A status other than 0 and 3 is awk not running at all, which no condition can be judged on.
run_awk() {
  awk_status=0
  awk_text="$(LC_ALL=C awk "$1" "$2" 2> /dev/null)" || awk_status=$?
}

findings=''
finding() {
  findings="$findings$1"$'\n'
}

# --- (a) the opening ---

images=''
readme_readable=1
if [ -f "$readme_file" ] && [ -r "$readme_file" ]; then
  run_awk "$opening_images" "$readme_file"
  [ "$awk_status" -eq 0 ] || exit 1
  images="$awk_text"
else
  readme_readable=0
fi
if [ "$readme_readable" -eq 0 ]; then
  finding "readme-picture.sh: README.md: cannot read this file. Make this file readable, $again"
elif [ -z "$images" ]; then
  finding "readme-picture.sh: README.md: the opening, before its first ## heading, holds no Markdown image of the form ![alternative text](path). Add an image line naming the picture $record_name names to the opening, after the description sentence, $again"
fi

# --- (b) the record ---

record_ok=0
picture=''
record_version=''
record_digest=''
if [ ! -e "$record_file" ]; then
  finding "readme-picture.sh: $record_name: no file is there. Run checks/readme-capture.sh in the macOS guest, and commit the picture and the record it writes together, $again"
elif [ ! -f "$record_file" ] || [ ! -r "$record_file" ]; then
  finding "readme-picture.sh: $record_name: cannot read this file. Make this file readable, $again"
else
  run_awk "$record_program" "$record_file"
  case "$awk_status" in
    0)
      # Parameter expansion and no here-string: bash 3.2 here-strings can create a file.
      picture="${awk_text%%$'\t'*}"
      fields="${awk_text#*$'\t'}"
      record_version="${fields%%$'\t'*}"
      fields="${fields#*$'\t'}"
      record_digest="${fields#*$'\t'}"
      record_ok=1
      ;;
    3)
      finding "readme-picture.sh: $record_name: the file is not the four lines picture:, version:, commit: and sha256:, in that order and nothing else. Run checks/readme-capture.sh in the macOS guest to write it again, and commit the picture and the record it writes together, $again"
      ;;
    *) exit 1;;
  esac
fi

# --- (c) every image in the opening names the record's picture ---

non_badge_paths=''
if [ -n "$images" ]; then
  non_badge_paths="$(printf '%s\n' "$images" | awk -v record_read="$record_ok" -v picture="$picture" "$non_badge_program")" || exit 1
fi

if [ "$readme_readable" -eq 1 ] && [ -n "$images" ] && [ "$record_ok" -eq 1 ]; then
  other_path="$(printf '%s\n' "$non_badge_paths" | awk -v want="$picture" '$0 != "" && $0 != want && !seen { print $0; seen = 1 }')"
  if [ -n "$other_path" ]; then
    finding "readme-picture.sh: README.md: the opening shows the image $other_path, and $record_name names $picture. Make every image in the opening name $picture, $again"
  fi
fi

# --- (d) the picture is there and tracked ---

picture_to_check=''
if [ "$record_ok" -eq 1 ]; then
  picture_to_check="$picture"
elif [ -n "$non_badge_paths" ]; then
  picture_to_check="${non_badge_paths%%$'\n'*}"
fi
picture_present=0
if [ -n "$picture_to_check" ]; then
  if [ ! -f "$root/$picture_to_check" ]; then
    finding "readme-picture.sh: $picture_to_check: no file is there. Run checks/readme-capture.sh in the macOS guest, and commit the picture and the record it writes together, $again"
  else
    picture_present=1
    tracked_status=0
    git -C "$root" ls-files --cached --error-unmatch -- "$picture_to_check" > /dev/null 2>&1 || tracked_status=$?
    case "$tracked_status" in
      0) ;;
      1)
        finding "readme-picture.sh: $picture_to_check: the file is there, and Git does not track it. Commit it together with $record_name and the README's image line, $again"
        ;;
      *) exit 1;;
    esac
  fi
fi

# --- (e) the picture's bytes are the record's ---

if [ "$record_ok" -eq 1 ] && [ "$picture_present" -eq 1 ]; then
  digest_line="$(shasum -a 256 "$root/$picture" 2> /dev/null)" || exit 1
  picture_digest="${digest_line%% *}"
  if [ "$picture_digest" != "$record_digest" ]; then
    finding "readme-picture.sh: $picture: its SHA-256 is not the one $record_name holds, so it is not the picture the record names. Run checks/readme-capture.sh in the macOS guest, and commit the new picture and record together, $again"
  fi
fi

# --- (f) the record's version is the product's ---

if [ "$record_ok" -eq 1 ]; then
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
  if [ "$cargo_read" -eq 1 ] && [ "$plist_read" -eq 1 ]; then
    if [ "$record_version" != "$cargo_version" ] || [ "$record_version" != "$plist_version" ]; then
      finding "readme-picture.sh: $record_name: it names version $record_version, and the product carries $cargo_version in Cargo.toml and $plist_version in ka-reader-mac/Info.plist. Run checks/readme-capture.sh in the macOS guest, and commit the new picture and record together, $again"
    fi
  elif [ "$cargo_read" -eq 0 ] && [ "$plist_read" -eq 1 ]; then
    finding "readme-picture.sh: $record_name: it names version $record_version, Cargo.toml's [workspace.package] table holds no single version line this check can read, and ka-reader-mac/Info.plist carries $plist_version. Give that table exactly one version line, $again"
  elif [ "$cargo_read" -eq 1 ] && [ "$plist_read" -eq 0 ]; then
    finding "readme-picture.sh: $record_name: it names version $record_version, Cargo.toml carries $cargo_version, and ka-reader-mac/Info.plist holds no single <string> after <key>CFBundleShortVersionString</key> that this check can read. Give Info.plist exactly one such key with its <string>, $again"
  else
    finding "readme-picture.sh: $record_name: it names version $record_version, and neither Cargo.toml's [workspace.package] table nor ka-reader-mac/Info.plist holds a single version this check can read. Give each exactly one version, $again"
  fi
fi

# --- (g) the opening shows the picture, not only badges ---

if [ "$readme_readable" -eq 1 ] && [ -n "$images" ] && [ "$record_ok" -eq 1 ] && [ -z "$non_badge_paths" ]; then
  finding "readme-picture.sh: README.md: every image in the opening is a badge picture under docs/readme/badges/, so the opening does not show $picture, the picture $record_name names. Add an image line naming $picture to the opening, after the badge and link rows, $again"
fi

# --- the verdict ---

if [ -n "$findings" ]; then
  reported=1
  printf '%s' "$findings" >&2
  exit 1
fi
reported=1
printf "readme-picture.sh: the README's opening shows %s, and it matches %s at version %s.\n" "$picture" "$record_name" "$record_version"
