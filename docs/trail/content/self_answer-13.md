# Self-answer report — CONTENT.md

## Header

- **Companion:** `docs/CONTENT_open_issues.md`
- **Document:** `docs/CONTENT.md` (v15, Settled; the companion was opened by the PM on 2026-11-09 at `ka-reader@38cd9c8` and holds two items, both under § 3, raised from downstream)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-09
- **Sources re-read:** One answer rests on a source outside this repository. Item 3.1 relies on the claim that libgit2's own licence file names its grant "linking exception". Re-read at the source: `libgit2/COPYING` in the `libgit2-sys` crate source in the local Cargo registry, version 0.18.8+1.9.7, which is the version `Cargo.lock` resolves. It carries a section headed `LINKING EXCEPTION`, beginning "In addition to the permissions in the GNU General Public License". The record (`THIRD_PARTY_NOTICES.md:L68`) agrees with it.

## Items worked

### 3.1 — The banned table bans *exception*, and does not say whether a licence's own name is under it

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write the verbal language
- **Verdict:** answered
- **Why:** **Answer: no.** Neither a licence's name nor a licence's text is under the banned table, on any row. The table gains no row and no exception. § Voice gains one sentence saying so.

  **Check 1: mine, in the owner's seat.** The edit lands in `docs/CONTENT.md` § Voice. The answer binds only this document's consistency. It commits no person, no outside party and no legal position; the licence's words are left exactly as they are. I can name no ground I cannot see, and the owner has reserved no taste in this wording.

  **Check 2: no draft, so the question is read.** The item's heading asks about one row, *exception*, and one thing, a licence's name. Its closing line asks the wider question: whether "licence names and licence texts fall under its rows". The answer is to the wider question, and the narrowing is named here. A licence's text carries more banned words than *exception*. A scan of the licence texts' part headings alone finds "Just-In-Time" in two of PCRE2's (`THIRD_PARTY_NOTICES.md`, the headings under *Licence texts*), and *just* is a banned word. The two halves, the name and the text, have the same seat and the same answer, so the item stays one item. It is not a widening item that waits: the item cites the sites that occur, `THIRD_PARTY_NOTICES.md:L68` and `:L288`. I opened both at `ka-reader@38cd9c8`. L68 reads "GPL-2.0 with the linking exception", and L288 heads a licence text `### LLVM-exception`.

  **The reason the table does not reach them.** (a) § Voice binds "the words KA-Reader writes, not the words it shows" (`docs/CONTENT.md:L41`), and the table's heading says "the words KA-Reader writes" since v13 (`:L191`, RN-40). A licence's name and text are the licence's words. (b) The *exception* row's ground is failure words: its remedy is "The sentence saying what KA-Reader was doing and what it observed" (`:L200`), which fits an error message and fits no licence. Its stated *Why*, text "passed through with nothing added", could be misread to reach licence text carried from a dependency. That is the misreading this answer closes. (c) § Localization already puts "the licence text" among what is "identifiers, not words" and never translated (`:L531-L533`), so the document treats licence text as an identifier already. (d) The writing bar quotes "a licence term" exactly and never paraphrases it (`system/doctrine/writing_bar.md` § 1.5), and approved legal language is one of the three things the Content Manager does not change (`<CORE>/roles/loaders/content_manager_global.md`). A table that reached a licence's words would have to rewrite them, so it cannot reach them.

  **Check 3: against the record.** Item 3.2, decided in this same pass, puts the notices' own prose in scope. The two answers agree: the prose around a licence name is KA-Reader's writing and is under every rule, and the names and texts inside it are not. I scanned the notices' own prose, before *Licence texts*, and `SECURITY.md` for the table's words. The only hit is the licence name at L68, so neither document needs a change from this answer. The scan covers the banned table only and is not an audit of either document. RN-40's limit, that this document neither narrows nor restates a limit that binds the product from outside, still holds: the answer states no licensing obligation.

  **Check 4: the failure paths.** *Empty*: no licence names in a document, so the sentence has nothing to apply to. *Absent*: a licence that gives itself no name. The notices already use descriptive names for four of them (`THIRD_PARTY_NOTICES.md`, the *Libraries the crates compile* table), for example "the PCRE2 licence". Those are KA-Reader's writing and stay under the table, which is limit (2) in the slot. *Stale*: a dependency updates and its licence text changes. The text is carried as it stands, so no rule here goes stale. *Concurrent*: a name KA-Reader composed from the licence's own heading, which is the L68 case. The licence's term stays, because the alternative is an invented synonym for a legal term, and that would misname the instrument. That is limit (1) in the slot. The word *exception* stays banned as a failure word in KA-Reader's own sentences. *Refused*: if the table did reach a licence's words, the loader's rule sends the incoherence to the owner and leaves the text as it is. The answer avoids needing that, because the table does not reach them.

  **Close to a different verdict:** *left for the owner*, since licence text is a legal matter. What tipped it: the answer changes no legal language and commits nobody to anything. It states that this document's rules do not touch the licence's words, which is the Content Manager's own scope line. *Raised upstream* was never close. Nothing in the PRD, the UXD or the SRS has to move.

### 3.2 — § Voice scopes the README and a release's text, and does not place the repository's other root documents

- **Bucket:** 3. Raised from downstream — an item from a seat that did not write the verbal language
- **Verdict:** answered
- **Why:** **Answer: yes.** `SECURITY.md` and `THIRD_PARTY_NOTICES.md` are in scope, as the README is. § Voice names them, with the reader as the test.

  **Check 1: mine, in the owner's seat.** The edit lands in `docs/CONTENT.md` § Voice, which owns what its rules govern. The answer binds this document's consistency only. It claims nothing about the licence, the support period or the security process; what the product may promise is the PRD's, and the answer touches no promise. The owner has reserved no taste here.

  **Check 2: no draft; the question is one question.** The item asks where two root documents sit. Both get one answer, so the item stays whole. It is a raised-from-downstream item that asks the document to state a case it does not state. It cites an occurrence for each form: both files exist at the product root (`ka-reader@06e4a34`, the merge that added them), and I opened each. It is therefore not answered "not until it occurs". The item's heading says § Voice "does not place" the documents. Its *What it blocks* field says the documents "were written to every rule here as if in scope", so a rule is owed to whoever next writes one of them.

  **Check 3: against the record, and why the test is the reader.** (a) RN-40 already settled the neighbouring case by where the text goes and who reads it: the checks' output is out because its reader is "a contributor or a build log" (`docs/CONTENT.md:L47-L49`). The reader of `SECURITY.md` is a stranger who found a vulnerability, and the reader of the notices is a stranger checking what KA-Reader is built from or redistributing it. Neither is a contributor or a build log. (b) `SECURITY.md`'s second paragraph is the support posture standing sentence, word for word (§ Terminology, *Standing sentences*, `:L223`). A document that carries a standing sentence is a surface of it, and the table says every surface that states one carries that wording. Putting `SECURITY.md` out of scope would put a surface of a standing sentence beyond the rules that fix its wording. (c) § Tone calls the README's first screen "the only surface that has to answer a stranger who has not started the tool" (`:L84`). It stays true: that sentence is about the first screen's job, which is what KA-Reader does, one way to install it and what it never touches. Neither root document does that job, so the new scope does not contradict it. (d) The answer does not depend on whether the notices ship inside the app bundle. If they do, the v13 sentence "Text that reaches the bundle or the app's screen is in scope whichever file it came from" (`:L49`) places them already. If they do not, the reader places them. I did not decide the bundle question, because it is the NFDR's and the Principal Architect's, and the architecture companion carries it (QC-41, `ka-reader@ed1484b`). (e) 3.1: the licence names and texts inside the notices are the licence's words and are out of scope there; the prose around them is in. I scanned that prose and `SECURITY.md` for the banned table's words, and the only hit is the licence name at `THIRD_PARTY_NOTICES.md:L68`. Neither document needs a change from this answer.

  **Check 4: the failure paths.** *Empty*: a root document with no prose of KA-Reader's own. `LICENSE` is that case, and 3.1 already covers its words. *Absent*: a root document nobody cited. `CHANGELOG.md` also sits at the product root. The item cites no occurrence of it, so this answer does not place it, and the slot says another root document waits until one is cited. That is a named uncovered case. *Stale*: a third root document added later. The reader test places it once someone cites it. *Concurrent*: a document that is part KA-Reader's writing and part a licence's, which is the notices. 3.1 splits it by whose words they are. *Refused*: a licence or the platform requires wording KA-Reader must carry verbatim in one of these documents. That wording is the licence's or the platform's, falls under 3.1's rule, and the rules here do not apply to it. RN-40's limit holds, since this document does not scope any limit that binds the product from outside it.

  **Close to a different verdict:** *answered* with the rule stated for every root document, which would cover `CHANGELOG.md` too. What tipped it: the item cites two documents, and the occurrence bar (`<CORE>/../skills/pm/.claude/skills/shukuba-refine/prompts/rich.md` § *A gap is carried only where it occurs*) carries the forms cited. *Left for the owner* was never close.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **docs/CONTENT.md** — `<CORE>/launchers/skill/launcher.sh product-content ka-reader`
