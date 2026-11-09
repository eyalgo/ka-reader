# CONTENT open issues — KA-Reader

> Companion to `CONTENT.md`. The Content Manager authored the verbal language non-interactively;
> this file holds the calls it made and wants your sign-off on — each with the reason behind it,
> and what moves underneath it if you override — plus the few things it genuinely could not
> settle.
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this file**,
> then re-run `product-content`. It folds your answers into `CONTENT.md` and drops the resolved
> items. When nothing is left open, `product-content` **deletes this file**: no file = the verbal
> language is done.
>
> **Commit before re-running.** The run that finishes a round removes this file, and git refuses
> to remove a file with uncommitted edits in it — so an uncommitted answer stops that run before
> it can commit anything, and the round's work is left on the floor.
>
> Your answers are never thrown away. Each time the Content Manager folds them in, it first copies
> this file whole to `docs/trail/content/` — so what you decided, and why, stays readable and
> citable for good.
>
> **§ 3 comes from outside this run.** The verbal language is read by everyone who writes a string,
> and a seat downstream can find a pattern it has no rule for. It is recorded there, answered here,
> and folded by the same run.

> **No `product-content` run wrote this file.** The PM opened it on 2026-11-09, reading the settled
> `CONTENT.md` against the product at `ka-reader@06e4a34`, where the repository root gained
> `SECURITY.md` and `THIRD_PARTY_NOTICES.md`. Two items follow in § 3; `CONTENT.md` is not edited.

---

## 1. Open issues

None.

## 2. Choices to confirm

None.

## 3. Raised from downstream — an item from a seat that did not write the verbal language

### 3.1 The banned table bans *exception*, and does not say whether a licence's own name is under it
- **Raised by:** PM — 2026-11-09
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing is blocked; a string that names a licence has no rule to be written against, and the README's licence line and the release page are still to be written.
- **Where it shows:** `docs/CONTENT.md:L200` bans "error, exception, failed, fatal, …" for text passed through from inside the tool; it says nothing about the name of a licence or a licence exception, which the notices must carry as the licence names it. At `ka-reader@06e4a34`, `THIRD_PARTY_NOTICES.md:L68` reads "GPL-2.0 with the linking exception" and `:L288` heads a licence text `LLVM-exception`. § Localization already lists "the licence text" among what is never translated.
- **If a document has to be written:** none — the banned table says whether licence names and licence texts fall under its rows.
- **Answer:** No. Neither a licence's name nor a licence's text is under the banned table, on any row, and the table gains no row and no exception. `docs/CONTENT.md` § Voice binds "the words KA-Reader writes, not the words it shows" (`:L41`), and the banned table's heading already reads "Banned in the words KA-Reader writes" (`:L191`). A licence's name and its text are the licence's words, so they are carried as the licence has them, the way a name taken from the folder is. § Voice gains one sentence beside the checks sentence (`:L47-L49`): a licence's name and the text of a licence are the licence's words, carried unchanged, and no rule in this document is applied to them; a sentence KA-Reader writes around one is its own writing and stays under every rule. Three limits. (1) A name KA-Reader composes for a licence keeps the term the licence uses for its own grant, so "GPL-2.0 with the linking exception" (`THIRD_PARTY_NOTICES.md:L68`) stands: the licence file libgit2 ships heads that grant "LINKING EXCEPTION" (`libgit2/COPYING` in `libgit2-sys` 0.18.8+1.9.7). *Exception* as a failure word in a sentence KA-Reader writes stays banned. (2) A name KA-Reader coins for a licence that gives itself none is KA-Reader's writing and is under the table. (3) Approved legal language is not this document's to change (`<CORE>/roles/loaders/content_manager_global.md`, the three things that stay binding), so a rule that reached a licence's words could only be wrong. Decided together with 3.2: the notices' own prose is in scope there, and the names and texts inside it are out of scope here. Reasoning: `docs/trail/content/self_answer-13.md`.

### 3.2 § Voice scopes the README and a release's text, and does not place the repository's other root documents
- **Raised by:** PM — 2026-11-09
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing is blocked; the security policy and the notices were written to every rule here as if in scope, with no rule saying they are.
- **Where it shows:** `docs/CONTENT.md:L40-L48` puts "the README, and any text a release carries" in scope and the check scripts' output out of it. At `ka-reader@06e4a34` the repository root also holds `SECURITY.md` and `THIRD_PARTY_NOTICES.md`, which neither sentence places.
- **If a document has to be written:** none — § Voice says where a repository root document other than the README sits.
- **Answer:** Yes. Both are in scope, as the README is. § Voice's list of what the rules govern (`docs/CONTENT.md:L44-L45`, "labels, status messages, failure text, the README, and any text a release carries") gains the repository's root documents written for a reader outside the project, and names the two that occur, `SECURITY.md` and `THIRD_PARTY_NOTICES.md`. The test is the reader and not the directory, the test RN-40 used for the checks (`:L47-L49`): the reader of either is a stranger who reports a vulnerability or checks what KA-Reader is built from, not a contributor or a build log. `SECURITY.md` already carries the support posture sentence word for word (its second paragraph; § Terminology, *Standing sentences*, the support posture row), so it is already a surface of a standing sentence, and that table's rule covers every surface that states one. The answer does not turn on whether the notices ship in the app bundle: if they do, the v13 sentence places them already (`:L49`); if they do not, the reader places them. Inside the notices, a licence's name and a licence's text are the licence's words and sit outside the rules (3.1); the prose KA-Reader writes around them is in. Stated for these two documents. Another root document waits until one is cited. Reasoning: `docs/trail/content/self_answer-13.md`.
