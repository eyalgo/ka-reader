#!/usr/bin/env bash
# Version: 1.0.0 — the complete beta notice in the actual catalogue
# WHY THIS EXISTS
#   A matching comment or unrelated literal does not prove the declared catalogue notice.
# USAGE
#   checks/git-beta.sh, from the product root; no arguments or input overrides.
#   0: complete pass; 1: finding, failed inspection or caught HUP/INT/TERM; 2: usage.
set -euo pipefail
beta_input='checks/support/git-beta-inputs.sh'
reported=0
interrupted() {
  reported=1
  printf 'The wording check was interrupted while inspecting %s. Run checks/git-beta.sh again from the KA-Reader folder.\n' "$beta_input" >&2
  exit 1
}
trap interrupted HUP INT TERM
trap 'result=$?; if [ "$result" -ne 0 ] && [ "$reported" -eq 0 ]; then printf "Couldn\047t finish inspecting %s. Check that every input can be read, then run checks/git-beta.sh again from the KA-Reader folder.\n" "$beta_input" >&2; exit 1; fi' EXIT
if [ "$#" -ne 0 ]; then reported=1; printf '%s\n' 'Usage: checks/git-beta.sh' >&2; exit 2; fi
helper="${0%/*}/support/git-beta-inputs.sh"
if [ ! -r "$helper" ]; then
  reported=1
  printf "Couldn't read %s. Check that it can be read, then run checks/git-beta.sh again from the KA-Reader folder.\n" "$beta_input" >&2
  exit 1
fi
. "$helper" 2> /dev/null
refuse_input() {
  reported=1
  case "$beta_error" in
    read) printf "Couldn't read %s. Check that it can be read, then run checks/git-beta.sh again from the KA-Reader folder.\n" "$beta_input" >&2;;
    policy) printf "Couldn't read one Git read policy from %s. Check its declaration, then run checks/git-beta.sh again from the KA-Reader folder.\n" "$beta_input" >&2;;
    canonical) printf "Couldn't read one complete beta statement from %s. Check its standing sentences, then run checks/git-beta.sh again from the KA-Reader folder.\n" "$beta_input" >&2;;
    notice) printf "Couldn't read one complete Git notice from %s. Check its declaration, then run checks/git-beta.sh again from the KA-Reader folder.\n" "$beta_input" >&2;;
    agreement) printf "The Git notice in %s doesn't match the complete beta statement. Correct the wording, then run checks/git-beta.sh again from the KA-Reader folder.\n" "$beta_input" >&2;;
    *) printf "Couldn't finish inspecting %s. Check that every input can be read, then run checks/git-beta.sh again from the KA-Reader folder.\n" "$beta_input" >&2;;
  esac
  exit 1
}
beta_load_policy ka-reader-mac/Sources/Surfaces/GitReadPolicy.swift || refuse_input

beta_load_statement docs/CONTENT.md "$beta_policy" || refuse_input

# Readability is required before a no-match result can describe the source tree.
beta_read_file ka-reader-mac/Sources/Surfaces/GitSentences.swift || refuse_input
if [ "$beta_policy" = atOpen ]; then
  beta_input=ka-reader-mac/Sources/Surfaces
  comparison=0
  grep -rF -- "$beta_wording" "$beta_input" > /dev/null 2> /dev/null || comparison=$?
  case "$comparison" in
    0) ;;
    1) reported=1; printf "The complete beta statement wasn't found in %s. Restore the whole wording, then run checks/git-beta.sh again from the KA-Reader folder.\n" "$beta_input" >&2; exit 1;;
    *) beta_error=inspection; refuse_input;;
  esac
fi
beta_load_notice ka-reader-mac/Sources/Surfaces/GitSentences.swift || refuse_input
beta_check_agreement || refuse_input
