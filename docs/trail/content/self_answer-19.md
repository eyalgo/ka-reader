# Self-answer report — CONTENT.md

## Header

- **Companion:** docs/CONTENT_open_issues.md
- **Document:** docs/CONTENT.md
- **Decided by:** `prompts/rich.md` of the `companion-self-answer` skill, v1.5.0
- **Date:** 2026-11-24
- **Sources re-read:** `kensaiapp-presence`, `products/product-front/docs/PRD.md`, read at `kensaiapp-presence@4e338b6b` (Settled, Version 6): § Goals G1 says every published product's README opens with the shared top block, and § The README's shared parts lists it as the product's name, one sentence, a line naming KensaiApp as maker, a row of badges and a row of links, and says "The status badge goes once the product reaches 1.0.0." The proposal file that PRD says its block comes from (`docs/proposals/product-repo-front/readme_top.md`) is a draft and was not read. Everything else rests on files in this repository (`README.md`, `docs/PRD.md`, `docs/SRS.md`, `docs/UXD.md`, `docs/CONTENT.md`) read at `ka-reader@8bdf55f`, and on this instance's `system/experience/voice_restrictions.md`.

## Items worked

### 3.1 — RN-44 says the README carries the network standing sentence twice; it now carries it once

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write the verbal language
- **Verdict:** answered
- **Why:** Answered: the correction is directed, and it is the only change. The item is about this document's own note (RN-44), so the edit lands here, binds nobody outside this document, and rests on no ground I cannot see (check 1: mine). The item's premise holds (check 2). `grep -c -F 'it makes no network call while it runs' README.md` prints 1 (`README.md:L28`) and `git diff --stat 35d5e02 HEAD -- README.md` prints nothing, so the README is as the item measured it. `## Promises and limits` keeps the other standing sentences and not this one. The item corrects a false fact, so it is not a widening and the "not until it occurs" rule does not apply. It contradicts nothing settled (check 3): § Standing sentences fixes the one wording and says nothing about how many times a surface carries it, `voice_restrictions.md` `one-wording-per-promise` checks the wording across occurrences and not the count, and no other line of `docs/CONTENT.md` says where the README carries it (the only match for "carries it unchanged" is RN-44, `:L1043`). The failure path that matters is the stale case (check 4): RN-44's sentence named a count and two places, and that is what made it false. So the corrected sentence names neither: "…and `README.md` carries it unchanged wherever it states it." I was close to writing "once, in the Install section", and chose against it because that repeats the fault in a new form. No other document repeats the claim: `grep -rn "Promises and limits" docs/*.md` finds only the companion.

### 3.2 — No wording for a status badge that states the before-1.0.0 limit

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write the verbal language
- **Verdict:** answered
- **Why:** Answered: a badge never carries a standing sentence, and the status badge as drawn does not state one. The edit lands in this document, binds only its internal consistency, and I can name no ground I cannot see, so the item is mine (check 1). The item asks two things, whether a badge may state the limit and in what words, and both have the same seat, so they are answered together in the one slot (check 2). A standing sentence is "a promise or a stated limit" (§ Standing sentences). The before-1.0.0 row fixes two things in one wording: a position (*is before version 1.0.0*) and a limit (*Until 1.0.0, anything in it may change*). The badge's value, *before 1.0.0* (`README.md:L11`; `docs/readme/badges/status.svg`, whose `aria-label` and `<title>` read *Status: before 1.0.0*), states only the position. It softens nothing and adds nothing to the limit, so it is not the *shortened version* the table forbids, and it does not hand a stranger a "usually" to set beside the real sentence. The form occurs, so the item is not held back as a widening: six badges stand at `README.md:L7-L12`, and the rule is written for the form (the occurrence test for a widening item). Check 3: § Standing sentences, `voice_restrictions.md` `one-wording-per-promise` and `no-runtime-remote-asset` (the badges are served from `docs/readme/`, so that fence is met) agree with the answer. Check 4: stale (the value is false the day 1.0.0 ships, so the badge retires with the sentence); absent (if the picture does not load, its alt text carries the same label and value); empty (no badge, nothing is owed); refused and concurrent do not apply. Two alternatives were weighed and rejected. A badge carrying the whole sentence cannot be drawn as a label. Forbidding a status badge is a README call and is the CPO's, not a verbal one. The shared front's PRD agrees on the retirement: its status badge goes once the product reaches 1.0.0 (Sources re-read). What would tip it: if the owner wants *may change* drawn on the badge, that is a new wording owed to § Standing sentences, and this run writes none.

### 3.3 — The README first-screen row names four claims; the first screen now opens with a maker line, badges and links too

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write the verbal language
- **Verdict:** answered
- **Why:** Answered: the row admits the maker line, the badges and the link row under its own test, and it is narrowed so it no longer says more than the PRD. The item hides two questions (check 2): what the tone row says about the first screen's words, and whether the three belong there. The first is this document's. The second is what the README may carry, which is the CPO's and is already settled: the shared front's PRD requires the shared top block on every product's README (Sources re-read, above), and `docs/UXD.md` UX-A3 (v14, RN-36) and its answer at `docs/trail/uxd/self_answer-7.md` say the first screen's other content is the README's. Both halves therefore reach the same answer and the same seat's slot, so the item is not split (the prompt's three conditions). Check 3: § Tone's row says "every one of them a claim … : what KA-Reader does, one way to install it, one thing to do first, and what it never touches", and `docs/PRD.md` and `docs/SRS.md` C-9 list the same four without saying only four, so "every one of them" is this document's own overreach and nothing upstream's. The shipped first screen (`README.md:L5-L14`) was read against the document's rules and none fails. The maker line is a sentence about origin, checkable at its link, and it keeps § Voice's no-*we* rule (RN-41). The badges are facts (see 3.2), served from `docs/readme/`. The link row's four names say where each link goes (§ Accessibility of text). RN-15 binds the fold: this document cites only files a reader of this repository can open, so the three are stated in the row's own words and the shared front's PRD is cited here, in the report, and not in `docs/CONTENT.md`. Check 4: absent (a badge picture that does not load keeps its alt text, per 3.2), stale (a badge value that drifts from the release fails the next-minute test, which the README's own checks and not this row enforce), and empty (a first screen with only the four stays inside the row). Refused and concurrent do not apply. No PRD change is owed: its four-item list is true with or without the shared block beside it. I was close to answering "the README must drop what is not one of the four". The shared front's requirement and the PRD's silence on *only* tipped it away, and a row that outruns the PRD is how this document's own rule goes stale.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **docs/CONTENT.md** — `<CORE>/launchers/skill/launcher.sh product-content ka-reader`
