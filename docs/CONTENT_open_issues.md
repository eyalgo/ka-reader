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
- **Answer:** <the owner fills this in>

### 3.2 § Voice scopes the README and a release's text, and does not place the repository's other root documents
- **Raised by:** PM — 2026-11-09
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing is blocked; the security policy and the notices were written to every rule here as if in scope, with no rule saying they are.
- **Where it shows:** `docs/CONTENT.md:L40-L48` puts "the README, and any text a release carries" in scope and the check scripts' output out of it. At `ka-reader@06e4a34` the repository root also holds `SECURITY.md` and `THIRD_PARTY_NOTICES.md`, which neither sentence places.
- **If a document has to be written:** none — § Voice says where a repository root document other than the README sits.
- **Answer:** <the owner fills this in>
