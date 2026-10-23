#!/usr/bin/env bash
# Version: 1.0.0 — first version: gitleaks 8.30.1 over every commit HEAD reaches, fetched and checked
#   on every run, reporting by location only
#
# checks/secret-scan.sh — scans the whole history HEAD reaches for a secret.
#
# WHY THIS EXISTS
#   A key committed by accident stays in the history after a later commit removes it, so the gate
#   reads every commit reachable from HEAD and not only the tree (docs/nfdr.md QC-28). Four things
#   keep that scan honest. It refuses a shallow checkout, because a shallow history leaves out
#   commits HEAD reaches and would pass over them. It runs one pinned gitleaks, fetched on every run
#   and checked against a pinned SHA-256 and its own reported version, so the same rules run in the
#   guest and on a hosted runner and a missing tool is an ordinary fatal error. It takes the commit
#   count from git and not from gitleaks, whose own count is of fragments and omits a commit that
#   adds nothing. And it accepts no argument, variable or option that narrows the scan or lets a
#   finding pass: the only exceptions are the exact, reviewed fingerprints in .gitleaksignore.
#
# USAGE
#   checks/secret-scan.sh gitleaks git
#   Run from inside a clone of the product. The two words are fixed: a bare call, a different word
#   or an extra argument fails. Exit 0 only when the scan finished clean and HEAD is still the commit
#   it started from; the output then names the gitleaks version and the number of commits scanned,
#   which is `git rev-list --count HEAD`. A finding, or any error, is non-zero. A finding is printed
#   by its commit, file, line and rule and never by its value.
#
# .GITLEAKSIGNORE
#   The reviewed exceptions file, at the product root. Absent means no exception. Each line that is
#   not a comment is one commit:file:rule:line fingerprint with the full commit hash, and the line
#   directly above it is a comment giving the reason. A global fingerprint, a wildcard, a range or
#   a whole path or rule is refused before the scan starts.
#
# NOTHING FROM THE CALLER
#   The scan reads no variable of its own. The GITLEAKS_ variables of the caller's environment are
#   cleared for the scanner, because any of them can change which rules run.

set -euo pipefail

VERSION="8.30.1"
# The SHA-256 of each Darwin release asset, as the 8.30.1 release publishes it
# (gitleaks_8.30.1_checksums.txt). A reader checks each against the release page.
PIN_SHA256_ARM64="b40ab0ae55c505963e365f271a8d3846efbc170aa17f2607f13df610a9aeb6a5"
PIN_SHA256_X64="dfe101a4db2255fc85120ac7f3d25e4342c3c20cf749f2c20a18081af1952709"
RELEASE_URL="https://github.com/gitleaks/gitleaks/releases/download/v$VERSION"
ALLOW_FILE_NAME=".gitleaksignore"
TAB=$'\t'
USAGE_LINE="Run it as checks/secret-scan.sh gitleaks git; it takes those two words and nothing else."

work=""
cleanup() {
  [ -z "$work" ] || rm -rf "$work"
}
trap cleanup EXIT

die() {
  echo "secret-scan.sh: $*" >&2
  exit 1
}

# --- arguments ---

if [ "$#" -eq 0 ]; then
  die "no arguments were given, so nothing was scanned. $USAGE_LINE"
fi
if [ "$#" -ne 2 ] || [ "$1" != "gitleaks" ] || [ "$2" != "git" ]; then
  die "it was given $*, so nothing was scanned. $USAGE_LINE"
fi

# --- what the step needs, checked before anything is fetched ---

for needed in git uname curl tar shasum mktemp; do
  command -v "$needed" >/dev/null 2>&1 \
    || die "$needed is not on PATH, and the step needs it to fetch and check gitleaks $VERSION, so nothing was scanned. Install $needed, then run the step again."
done

# --- the history: readable, and whole ---

# The scan covers one commit, captured here; the count and the scan revision both come from it.
sha="$(git rev-parse --verify --quiet 'HEAD^{commit}' 2>/dev/null)" || sha=""
count="$(git rev-list --count "${sha:-HEAD}" 2>/dev/null)" || count=""
root="$(git rev-parse --show-toplevel 2>/dev/null)" || root=""
if [ -z "$sha" ] || [ -z "$count" ] || [ -z "$root" ]; then
  die "git could not read the history at HEAD in $PWD, so nothing was scanned. Run the step from the root of a clone of KA-Reader."
fi
if [ "$(git rev-parse --is-shallow-repository 2>/dev/null)" = "true" ]; then
  die "this checkout's history is shallow (git rev-parse --is-shallow-repository prints true), so nothing was scanned: a shallow history leaves out commits that HEAD reaches. Fetch the whole history with git fetch --unshallow, then run the step again."
fi

# --- the reviewed exceptions, validated before the scanner sees them ---

allow_count=0
allow_file="$root/$ALLOW_FILE_NAME"
fingerprint_shape='^[0-9a-f]{40}:[^*?[:space:]]+:[A-Za-z0-9._-]+:[1-9][0-9]*$'
reason_shape='^#[[:space:]]*[^[:space:]]'
if [ -e "$allow_file" ]; then
  [ -f "$allow_file" ] && [ -r "$allow_file" ] \
    || die "$ALLOW_FILE_NAME is in the product root but could not be read, so nothing was scanned. Make it readable, then run the step again."
  line_number=0
  reason_above=0
  while IFS= read -r allow_line || [ -n "$allow_line" ]; do
    line_number=$((line_number + 1))
    case "$allow_line" in
      "")
        reason_above=0
        ;;
      "#"*)
        reason_above=0
        if [[ "$allow_line" =~ $reason_shape ]]; then reason_above=1; fi
        ;;
      *)
        [[ "$allow_line" =~ $fingerprint_shape ]] \
          || die "line $line_number of $ALLOW_FILE_NAME is not one commit-specific fingerprint, so nothing was scanned. Each line that is not a comment names one finding as commit:file:rule:line, with the full commit hash."
        [ "$reason_above" -eq 1 ] \
          || die "line $line_number of $ALLOW_FILE_NAME has no reason comment on the line directly above it, so nothing was scanned. Write the reason on that line, starting with #."
        allow_count=$((allow_count + 1))
        reason_above=0
        ;;
    esac
  done < "$allow_file"
fi

# --- the tool: fetched, checked against its pin, and run by its own path ---

system="$(uname -s)"
architecture="$(uname -m)"
case "$system:$architecture" in
  Darwin:arm64)
    archive="gitleaks_${VERSION}_darwin_arm64.tar.gz"
    pinned_sha256="$PIN_SHA256_ARM64"
    ;;
  Darwin:x86_64)
    archive="gitleaks_${VERSION}_darwin_x64.tar.gz"
    pinned_sha256="$PIN_SHA256_X64"
    ;;
  *)
    die "uname reports $system $architecture, and the step fetches gitleaks $VERSION only for macOS (Darwin) on arm64 or x86_64, so nothing was scanned. Run the gate on a Mac with one of those two architectures."
    ;;
esac

temp_parent="${TMPDIR:-/tmp}"
temp_parent="${temp_parent%/}"
work="$(mktemp -d "$temp_parent/secret-scan.XXXXXX" 2>/dev/null)" || work=""
if [ -z "$work" ]; then
  die "it could not write to the temporary directory $temp_parent, so nothing was scanned. Make $temp_parent writable, then run the step again."
fi

url="$RELEASE_URL/$archive"
curl_status=0
curl --fail --silent --show-error --location --output "$work/$archive" "$url" || curl_status=$?
[ "$curl_status" -eq 0 ] \
  || die "downloading $url did not complete (curl exited with status $curl_status), so nothing was scanned. Check that this machine can download $url, then run the step again."

actual_sha256="$(shasum -a 256 "$work/$archive" 2>/dev/null | cut -d' ' -f1)" || actual_sha256=""
[ "$actual_sha256" = "$pinned_sha256" ] \
  || die "the downloaded $archive has SHA-256 $actual_sha256, and the digest pinned in checks/secret-scan.sh is $pinned_sha256, so it was not unpacked and nothing was scanned. Run the step again; if the digest differs again, the file served for gitleaks $VERSION is not the one pinned in checks/secret-scan.sh."

mkdir "$work/bin"
tar_status=0
tar -xzf "$work/$archive" -C "$work/bin" gitleaks >/dev/null 2>&1 || tar_status=$?
[ "$tar_status" -eq 0 ] \
  || die "tar exited with status $tar_status while unpacking $archive, so nothing was scanned. Run the step again."

gitleaks_path="$work/bin/gitleaks"
reported_version=""
if [ -x "$gitleaks_path" ]; then
  reported_version="$("$gitleaks_path" version 2>/dev/null)" || reported_version="<runs-not>"
fi
if [ ! -x "$gitleaks_path" ] || [ "$reported_version" = "<runs-not>" ]; then
  die "$archive unpacked without a gitleaks executable that runs, so nothing was scanned. The archive matched its pinned digest, so the step's reading of that archive needs correcting in checks/secret-scan.sh."
fi
[ "$reported_version" = "$VERSION" ] \
  || die "the unpacked gitleaks reports version $reported_version, and the step runs $VERSION, so nothing was scanned. The archive matched its pinned digest, so the pinned digest and the pinned version name different releases; correct the one that is wrong in checks/secret-scan.sh."

# --- the scan ---

# The config extends the pinned tool's own rules and adds no exclusion. The template names the
# location of a finding and a redaction marker and nothing else: full redaction alone leaves the
# commit message and the author in a report.
config="$work/gitleaks.toml"
template="$work/report.tmpl"
report="$work/report.out"
printf '[extend]\nuseDefault = true\n' > "$config"
printf '{{ range . }}{{ .Commit }}\t{{ .File }}\t{{ .StartLine }}\t{{ .RuleID }}\t{{ .Fingerprint }}\tREDACTED\n{{ end }}' > "$template"

echo "secret-scan.sh: running gitleaks $reported_version, whose release archive matched its pinned SHA-256, over every commit reachable from $sha"

# Exit status 2 is a finding; 1 is the tool's own error. The scanner runs with every GITLEAKS_
# variable removed, so nothing in the caller's environment changes which rules run.
scan_status=0
(
  for ambient in $(compgen -e | grep '^GITLEAKS_' || true); do
    unset "$ambient"
  done
  exec "$gitleaks_path" git \
    --no-banner --no-color --redact=100 --log-level=error --exit-code 2 \
    --ignore-gitleaks-allow \
    --config "$config" \
    --gitleaks-ignore-path "$root" \
    --report-format template --report-template "$template" --report-path "$report" \
    --log-opts "--full-history --diff-merges=first-parent $sha" \
    "$root"
) || scan_status=$?

finding_count=0
if [ -f "$report" ]; then
  while IFS="$TAB" read -r finding_commit finding_file finding_line finding_rule finding_fingerprint _marker; do
    [ -n "$finding_commit" ] || continue
    finding_count=$((finding_count + 1))
    echo "secret-scan.sh: finding at commit $finding_commit, file $finding_file, line $finding_line, rule $finding_rule; matched text redacted; fingerprint $finding_fingerprint"
  done < "$report"
fi

if [ "$scan_status" -eq 2 ] && [ "$finding_count" -gt 0 ]; then
  die "gitleaks $reported_version reported one or more findings in the history of $sha, each on its own line in this step's output. For a finding that is not a secret, add its fingerprint as one line of $ALLOW_FILE_NAME with a comment on the line directly above it giving the reason; a finding that is a secret gets no line there, and the step stays red while that secret is in the history HEAD reaches."
fi
if [ "$scan_status" -ne 0 ] || [ "$finding_count" -ne 0 ] || [ ! -f "$report" ]; then
  die "gitleaks $reported_version exited with status $scan_status and listed no finding, so the history of $sha has not been scanned to a clean result. Run checks/secret-scan.sh gitleaks git again from the product root."
fi

# A count is reported only for a history that is still the one the scan started from.
if [ "$(git rev-parse HEAD 2>/dev/null)" != "$sha" ]; then
  die "HEAD no longer names $sha, the commit the scan started from, so no commit count is reported. Run the step again with nothing changing the checkout while it runs."
fi

if [ "$allow_count" -gt 0 ]; then
  echo "secret-scan.sh: ok — gitleaks $reported_version reported no finding in the history of $sha beyond those $ALLOW_FILE_NAME covers; commits scanned: $count"
else
  echo "secret-scan.sh: ok — gitleaks $reported_version reported no finding in the history of $sha; commits scanned: $count"
fi
