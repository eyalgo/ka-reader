#!/usr/bin/env bash
# Version: 1.0.0 — first version: the built application icon is the one file the bundle names, at
#   the seven sizes, with no second appearance and in the drawing's colours, with the stand-in as
#   its control
#
# checks/app-icon.sh <path-to-app> — proves a built KA-Reader.app carries its application icon as
# docs/design/app_icon.svg draws it.
#
# WHY THIS EXISTS
#   ka-reader-mac/assemble.sh generates the bundle's icon from docs/design/app_icon.svg at every
#   assembly, and the tree keeps no icon file. Whether the file it wrote keeps the drawing's rules
#   (docs/DESIGN.md § Components, "The application icon": one figure in the primary ink on the
#   surface ground at their light values, no hue, one drawing and no second) can be read only off
#   the built bundle. No suite may start the real sips or iconutil, so this check reads the icon the
#   gate's build wrote. checks/bundle.sh refuses the stand-in and nothing wider, and this check
#   holds the rest.
#
# WHAT IT HOLDS, AND WHAT IT DOES NOT
#   It holds four things of the app it is given.
#   - The file: Contents/Info.plist names a CFBundleIconFile, that name is a regular file in
#     Contents/Resources and never a symbolic link, and it is the only entry ending .icns under
#     Contents/. There is no Assets.car under Contents/ and no CFBundleIconName key.
#   - No second appearance: every chunk of the icon file is a type in this script's plain-image set,
#     which is the table of contents and the image types iconutil writes from a ten-entry iconset.
#     A dark, clear or tinted variant, or any type not in the set, is named.
#   - The sizes: at least one square representation at each of 16, 32, 64, 128, 256, 512 and 1024
#     pixels.
#   - The colours: read in sRGB, every fully opaque pixel of every representation lies within 2
#     levels, on each of R, G and B, of the straight line between #1E1F22 and #FBFBFA. In the
#     1024 px representation, (512, 512) is #1E1F22 and (512, 850) is #FBFBFA, both fully opaque,
#     and (0, 0) is fully transparent. A partly transparent pixel is held to no colour.
#   It does not hold how macOS draws the icon in the Dock, the application switcher or Finder, which
#   is the platform's. Nor does it hold that the figure is the one the drawing draws: nothing but the
#   drawing decides the icon, and checks/tests/test_assemble.sh holds that wiring.
#
# USAGE
#   checks/app-icon.sh target/release/bundle/macos/KA-Reader.app
#   Exit 0 when all four hold and the control holds, printing one line for each of the four and the
#   control's line on stdout. Exit 1 when one does not hold: each finding is named on stderr, then
#   one closing line. Exit 1 too, with one line that says which, when the check could not judge: the
#   app is not found or has no Contents/Info.plist, swiftc or plutil is not on PATH, no temporary
#   folder can be made, the probe does not compile, the probe cannot read a file, or the control's
#   fixture is missing or reads as on the line. Exit 2 when it is not given exactly one argument. INT
#   ends it with 130 and TERM with 143, never 0. It reads no variable of its own, launches nothing
#   and reads no home, so it stands outside docs/nfdr.md QC-65's set and runs on any host.
#
# HOW THE PIXELS ARE READ
#   No shell can read an image, so checks/icon_probe/main.swift is compiled with swiftc into this
#   run's temporary folder and run as `ka-reader-icon-probe <file>`, found through PATH: the seam
#   checks/tests/test_app_icon.sh uses to stand a reply in. The probe draws each representation into
#   an sRGB bitmap and prints its width, its height and its largest distance from the line, in
#   hundredths of a level, rounded up. For the 1024 px representation it also prints the three fixed
#   pixels. It prints facts and judges nothing: the bound, the sizes and the fixed pixels are judged
#   here. The chunk types are read from the icon file's own headers with od, and the plist with
#   plutil, found through PATH. The temporary folder is removed on every exit.
#
# THE CONTROL
#   The same probe is run on checks/fixtures/stand-in-icon.icns, the uniform #3A5A8C stand-in the
#   bundle carried before the drawn icon. It must find that file more than 2 levels off the line in
#   at least one representation. A probe that reads the stand-in as on the line cannot tell a tinted
#   icon from the drawing, and a check that cannot go red has not run (ADR-0012).

set -euo pipefail

# The bound on a fully opaque pixel's distance from the line, in the probe's hundredths of a level.
DISTANCE_BOUND=200

# The seven sizes every icon must cover, as square representations.
REQUIRED_SIZES="16 32 64 128 256 512 1024"

# The three fixed pixels of the 1024 px representation, as `r g b a`.
PUPIL_PIXEL="30 31 34 255"
GROUND_PIXEL="251 251 250 255"

die() { echo "app-icon.sh: $*" >&2; exit 1; }

# --- args ---

if [ "$#" -ne 1 ]; then
  echo "app-icon.sh: takes one argument, the path to an app; arguments given: $#. Usage: checks/app-icon.sh <path-to-app>" >&2
  exit 2
fi
app_given="$1"
app="$app_given"
case "$app" in
  */) app="${app%/}" ;;
esac

# Tier 2 (the shell packet's toolchain.md): both are needed for any verdict, so they are asked for
# before anything is read.
command -v swiftc > /dev/null 2>&1 \
  || die "swiftc not found on PATH — the icon probe (checks/icon_probe/main.swift) is compiled with it, so the check stopped without a verdict."
command -v plutil > /dev/null 2>&1 \
  || die "plutil not found on PATH — the app's Contents/Info.plist is read with it, so the check stopped without a verdict."

[ -e "$app" ] || die "not found: $app_given. Build the app with ka-reader-mac/assemble.sh, or give the path to a built app."
[ -f "$app/Contents/Info.plist" ] \
  || die "not an application bundle: $app_given has no Contents/Info.plist, so the check stopped without a verdict. Give the path to a built app."

root="$(cd "$(dirname "$0")/.." && pwd -P)"
control_relative="checks/fixtures/stand-in-icon.icns"
control="$root/$control_relative"

# --- the run's temporary folder: removed on every exit ---

tmp_parent="${TMPDIR:-/tmp}"
work="$(mktemp -d "$tmp_parent/app-icon.XXXXXX" 2> /dev/null)" \
  || die "cannot create a temporary folder under $tmp_parent, so the check stopped without a verdict."
trap 'rm -rf "$work"' EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

# --- the probe ---

# Appended, not prepended: a probe already ahead of this folder on PATH is the one that answers,
# which is how the suite stands a reply in. The options are those of the package manifest's settings:
# Swift 6 language mode, warnings as errors, strict memory safety. The module cache is inside the
# run's folder so nothing is written outside it.
PATH="$PATH:$work"
compiler_output="$(swiftc -swift-version 6 -warnings-as-errors -strict-memory-safety \
  -module-cache-path "$work/module-cache" -o "$work/ka-reader-icon-probe" \
  "$root/checks/icon_probe/main.swift" 2>&1)" \
  || die "the icon probe did not compile, so the check stopped without a verdict: $compiler_output"

# Runs the probe on $1 into the reply file $2; $3 is the file as the person knows it. Run directly,
# never inside a command substitution, so the probe is a child of this shell and a signal it sends
# reaches the traps above.
run_probe() {
  ka-reader-icon-probe "$1" > "$2" 2> "$work/probe.err" \
    || die "the icon probe could not read $3, so its pixels were not judged. The probe printed: $(cat "$work/probe.err")"
}

is_count() {
  case "$1" in
    '' | *[!0-9]*) return 1 ;;
  esac
  return 0
}

# Hundredths of a level, written in levels with two decimal places: 201 is 2.01.
levels() {
  printf '%d.%02d' $(($1 / 100)) $(($1 % 100))
}

unreadable_reply() {
  die "the icon probe's reply on $1 is not one this check reads, so its pixels were not judged. The line it could not read: $2"
}

# Reads the probe's reply $1 (about the file $2) into rep_w, rep_h, rep_d with rep_count of them, and
# the three fixed pixels, each as `r g b a`, or empty when the reply holds none.
parse_reply() {
  local reply="$1" shown="$2" line kind p1 p2 p3 p4 p5 p6 extra
  rep_count=0
  pixel_pupil=""
  pixel_ground=""
  pixel_corner=""
  while IFS= read -r line || [ -n "$line" ]; do
    [ -n "$line" ] || continue
    kind=""; p1=""; p2=""; p3=""; p4=""; p5=""; p6=""; extra=""
    read -r kind p1 p2 p3 p4 p5 p6 extra <<< "$line" || true
    case "$kind" in
      rep)
        is_count "$p1" && is_count "$p2" && is_count "$p3" && [ -z "$p4$p5$p6$extra" ] \
          || unreadable_reply "$shown" "$line"
        rep_w[$rep_count]=$((10#$p1))
        rep_h[$rep_count]=$((10#$p2))
        rep_d[$rep_count]=$((10#$p3))
        rep_count=$((rep_count + 1))
        ;;
      pixel)
        is_count "$p1" && is_count "$p2" && is_count "$p3" && is_count "$p4" && is_count "$p5" \
          && is_count "$p6" && [ -z "$extra" ] || unreadable_reply "$shown" "$line"
        case "$p1 $p2" in
          "512 512") pixel_pupil="$((10#$p3)) $((10#$p4)) $((10#$p5)) $((10#$p6))" ;;
          "512 850") pixel_ground="$((10#$p3)) $((10#$p4)) $((10#$p5)) $((10#$p6))" ;;
          "0 0") pixel_corner="$((10#$p3)) $((10#$p4)) $((10#$p5)) $((10#$p6))" ;;
          *) unreadable_reply "$shown" "$line" ;;
        esac
        ;;
      *) unreadable_reply "$shown" "$line" ;;
    esac
  done < "$reply"
}

# The largest distance any representation of the last reply reported.
largest_distance() {
  local n=0 largest=0
  while [ "$n" -lt "$rep_count" ]; do
    if [ "${rep_d[$n]}" -gt "$largest" ]; then
      largest="${rep_d[$n]}"
    fi
    n=$((n + 1))
  done
  echo "$largest"
}

# --- the control: the probe must find the stand-in off the line ---

[ -f "$control" ] && [ ! -L "$control" ] \
  || die "the control's icon, $control_relative, is not a regular file, so the check stopped without a verdict. Restore it with git checkout -- $control_relative and run the check again."
run_probe "$control" "$work/control.reply" "$control_relative"
parse_reply "$work/control.reply" "$control_relative"
control_distance="$(largest_distance)"
[ "$control_distance" -gt "$DISTANCE_BOUND" ] \
  || die "the control, $control_relative, read within 2 levels of the #1E1F22–#FBFBFA line in every representation: the probe cannot tell the stand-in from the drawing, so this check proves nothing. The probe's measure is in checks/icon_probe/main.swift."
control_line="control: $control_relative, the stand-in application icon, lies up to $(levels "$control_distance") levels off the #1E1F22–#FBFBFA line — the expected red"

# --- the findings ---

findings=""
add_finding() {
  findings="${findings}$1
"
}

# The chunk types the plain-image set holds: the table of contents and what iconutil wrote, read off
# the icon it packed from the ten-entry iconset the build renders (macOS 26, 2026-11-12): ic04, ic05
# and ic07 to ic14 for the images, and info for the packer's own record. Any other type is named, so
# a dark, clear or tinted variant cannot ride along.
is_plain_image_chunk() {
  case "$1" in
    'TOC ' | ic04 | ic05 | ic07 | ic08 | ic09 | ic10 | ic11 | ic12 | ic13 | ic14 | info) return 0 ;;
  esac
  return 1
}

# Four byte values, written as the four characters they are; one outside the printable range is
# written as a backslash and its octal value, as od -c writes it.
chunk_type() {
  local byte character type=""
  for byte in "$@"; do
    if [ "$byte" -ge 32 ] && [ "$byte" -le 126 ]; then
      printf -v character "\\$(printf '%03o' "$byte")"
    else
      printf -v character '\\%03o' "$byte"
    fi
    type="$type$character"
  done
  printf '%s' "$type"
}

# Walks the icon file $1 chunk by chunk: an 8-byte file header, then repeated 4-byte type and 4-byte
# big-endian length, the length counting its own 8 bytes. Sets chunks_readable to 0 when the walk
# cannot go on, so the probe is not asked to read a file whose structure is already named.
walk_chunks() {
  local file="$1" shown="$2" size offset length type b1 b2 b3 b4 b5 b6 b7 b8 rest
  chunks_readable=1
  size=$(($(wc -c < "$file")))
  read -r b1 b2 b3 b4 b5 b6 b7 b8 rest <<< "$(od -An -v -tu1 -N8 "$file")" || true
  if [ "$b1 $b2 $b3 $b4" != "105 99 110 115" ]; then
    add_finding "icon file has no icns header: $shown"
    chunks_readable=0
    return 0
  fi
  offset=8
  while [ "$offset" -lt "$size" ]; do
    b1=""; b2=""; b3=""; b4=""; b5=""; b6=""; b7=""; b8=""
    read -r b1 b2 b3 b4 b5 b6 b7 b8 rest <<< "$(od -An -v -tu1 -j "$offset" -N8 "$file")" || true
    # Fewer than 8 bytes left read the missing ones as 0, so the length below cannot fit and is named.
    length=$(((b5 << 24) + (b6 << 16) + (b7 << 8) + b8))
    if [ "$length" -lt 8 ] || [ $((offset + length)) -gt "$size" ]; then
      add_finding "icon file's chunks do not fit its length: $shown, at byte $offset"
      chunks_readable=0
      return 0
    fi
    type="$(chunk_type "$b1" "$b2" "$b3" "$b4")"
    if ! is_plain_image_chunk "$type"; then
      add_finding "chunk outside the plain-image set: $type in $shown"
    fi
    offset=$((offset + length))
  done
}

# The file: the plist names it, it is a regular file, and it is the only .icns under Contents.
plist="$app/Contents/Info.plist"
icon_name="$(plutil -extract CFBundleIconFile raw -o - "$plist" 2> /dev/null)" || icon_name=""
icon_ok=0
icon_path=""
if [ -z "$icon_name" ]; then
  add_finding "icon not named: Contents/Info.plist has no CFBundleIconFile that plutil can read"
else
  icon_shown="Contents/Resources/$icon_name"
  icon_path="$app/$icon_shown"
  if [ -L "$icon_path" ]; then
    add_finding "icon file is a symbolic link: $icon_shown, which CFBundleIconFile names"
  elif [ ! -e "$icon_path" ]; then
    add_finding "icon file missing: $icon_shown, which CFBundleIconFile names"
  elif [ ! -f "$icon_path" ]; then
    add_finding "icon file is not a regular file: $icon_shown, which CFBundleIconFile names"
  else
    icon_ok=1
  fi
  while IFS= read -r entry; do
    [ -n "$entry" ] || continue
    if [ "$entry" != "$icon_path" ]; then
      add_finding "second .icns file: ${entry#"$app"/}"
    fi
  done <<< "$(find "$app/Contents" -name '*.icns' | LC_ALL=C sort)"
fi

while IFS= read -r entry; do
  [ -n "$entry" ] || continue
  add_finding "asset catalogue: ${entry#"$app"/}"
done <<< "$(find "$app/Contents" -name 'Assets.car' | LC_ALL=C sort)"

if icon_key="$(plutil -extract CFBundleIconName raw -o - "$plist" 2> /dev/null)"; then
  add_finding "CFBundleIconName in Contents/Info.plist: $icon_key"
fi

# No second appearance, the sizes and the colours: read off the icon file and the probe's reply.
rep_count=0
if [ "$icon_ok" -eq 1 ]; then
  walk_chunks "$icon_path" "$icon_shown"
  if [ "$chunks_readable" -eq 1 ]; then
    run_probe "$icon_path" "$work/icon.reply" "$icon_shown"
    parse_reply "$work/icon.reply" "$icon_shown"

    for size in $REQUIRED_SIZES; do
      found=0
      n=0
      while [ "$n" -lt "$rep_count" ]; do
        if [ "${rep_w[$n]}" -eq "$size" ] && [ "${rep_h[$n]}" -eq "$size" ]; then
          found=1
        fi
        n=$((n + 1))
      done
      if [ "$found" -eq 0 ]; then
        add_finding "size missing: no $size px square representation in $icon_shown"
      fi
    done

    n=0
    while [ "$n" -lt "$rep_count" ]; do
      if [ "${rep_w[$n]}" -ne "${rep_h[$n]}" ]; then
        add_finding "representation not square: representation $((n + 1)) is ${rep_w[$n]} by ${rep_h[$n]} px"
      fi
      n=$((n + 1))
    done

    n=0
    while [ "$n" -lt "$rep_count" ]; do
      if [ "${rep_d[$n]}" -gt "$DISTANCE_BOUND" ]; then
        add_finding "pixel off the drawing's colours: representation $((n + 1)) (${rep_w[$n]} px) has a fully opaque pixel $(levels "${rep_d[$n]}") levels off the #1E1F22–#FBFBFA line (bound: 2 levels)"
      fi
      n=$((n + 1))
    done

    # A 1024 px representation with no pixel lines after it is a reply the check cannot read, and is
    # named by its own line.
    n=0
    while [ "$n" -lt "$rep_count" ]; do
      if [ "${rep_w[$n]}" -eq 1024 ] && { [ -z "$pixel_pupil" ] || [ -z "$pixel_ground" ] || [ -z "$pixel_corner" ]; }; then
        unreadable_reply "$icon_shown" "rep ${rep_w[$n]} ${rep_h[$n]} ${rep_d[$n]}"
      fi
      n=$((n + 1))
    done

    if [ -n "$pixel_pupil" ] && [ "$pixel_pupil" != "$PUPIL_PIXEL" ]; then
      read -r r g b a <<< "$pixel_pupil"
      add_finding "pupil pixel: (512, 512) of the 1024 px representation reads $r, $g, $b at alpha $a; the drawing gives 30, 31, 34 at alpha 255 (#1E1F22)"
    fi
    if [ -n "$pixel_ground" ] && [ "$pixel_ground" != "$GROUND_PIXEL" ]; then
      read -r r g b a <<< "$pixel_ground"
      add_finding "ground pixel: (512, 850) of the 1024 px representation reads $r, $g, $b at alpha $a; the drawing gives 251, 251, 250 at alpha 255 (#FBFBFA)"
    fi
    if [ -n "$pixel_corner" ]; then
      read -r r g b a <<< "$pixel_corner"
      if [ "$a" -gt 0 ]; then
        add_finding "corner pixel: (0, 0) of the 1024 px representation has alpha $a; outside the drawing's rounded square it is 0"
      fi
    fi
  fi
fi

if [ -n "$findings" ]; then
  printf '%s' "$findings" >&2
  die "the application icon in $app_given does not hold this check's rules; each finding is named above. The icon is generated from docs/design/app_icon.svg by ka-reader-mac/assemble.sh, and the rules are in checks/app-icon.sh's header."
fi

# --- the pass ---

echo "app-icon.sh: icon file: $icon_shown, named by CFBundleIconFile, is the bundle's one .icns file; Contents/Info.plist has no CFBundleIconName and the bundle has no Assets.car"
echo "app-icon.sh: sizes: $rep_count representations, each square, covering 16, 32, 64, 128, 256, 512 and 1024 px; every chunk is in the plain-image set, so the icon has no second appearance"
echo "app-icon.sh: colours: every fully opaque pixel of every representation lies within $(levels "$(largest_distance)") levels of the #1E1F22–#FBFBFA line (bound: 2 levels); at 1024 px, (512, 512) is #1E1F22 and (512, 850) is #FBFBFA, both fully opaque, and (0, 0) is fully transparent"
echo "app-icon.sh: $control_line"
