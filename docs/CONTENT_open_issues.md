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

---

## 1. Open issues

None.

## 2. Choices to confirm

None.

## 3. Raised from downstream — an item from a seat that did not write the verbal language

### 3.1 RN-44 says the README carries the network standing sentence twice; it now carries it once
- **Raised by:** PM — 2026-11-24
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing; RN-44 is a note, not a rule, and now describes a README that is gone.
- **Where it shows:** `docs/CONTENT.md:L1043-L1044` — "`README.md` carries it unchanged in its opening and in *Promises and limits*". At `ka-reader@35d5e02`, `grep -c -F 'it makes no network call while it runs' README.md` → 1 (`README.md:L28`, in the opening) and `grep -c -F 'KA-Reader never changes the folder you point it at' README.md` → 1 (`:L24`); `## Promises and limits` keeps its other paragraphs. This matches § Terminology's banned-table row "The guarantee is stated where a promise is stated, once" (`:L218`).
- **If a document has to be written:** none; RN-44's last sentence is corrected to the README as it stands.
- **Answer:** <the owner fills this in>

### 3.2 No wording for a status badge that states the before-1.0.0 limit
- **Raised by:** PM — 2026-11-24
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** the README's status badge reads a wording this document never gave, against its own rule for a standing sentence.
- **Where it shows:** `README.md:L11` at `ka-reader@35d5e02` — `![Status: before 1.0.0](docs/readme/badges/status.svg)`, its picture drawing *before 1.0.0*. § Terminology, *Standing sentences*, gives the before-1.0.0 limit one whole wording (`docs/CONTENT.md:L231`) and says every surface that states it carries that wording, "no paraphrase, no shortened version" (`:L222-L225`). Nothing here says whether a badge — a label and a value, drawn in a picture — may state the limit at all, or in what words.
- **If a document has to be written:** none; this document states whether a badge may carry a standing limit and, if it may, its words.
- **Answer:** <the owner fills this in>

### 3.3 The README first-screen row names four claims; the first screen now opens with a maker line, badges and links too
- **Raised by:** PM — 2026-11-24
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** nothing runs wrong; whether the README's opening keeps to its tone row is unanswered.
- **Where it shows:** § Tone's row *The README's first screen* (`docs/CONTENT.md:L94`) — "every one of them a claim that can be checked in the next minute: what KA-Reader does, one way to install it, one thing to do first, and what it never touches". At `ka-reader@35d5e02` the README's opening carries, before the screenshot and the install paragraph, a line naming KensaiApp as maker (`README.md:L5`), six badge pictures (`:L7-L12`) and a row of four text links (`:L14`). The row neither admits nor excludes them. The same question stands on `docs/UXD.md` UX-A3, through its own companion.
- **If a document has to be written:** none; the row states whether the maker line, the badges and the link row belong on the first screen.
- **Answer:** <the owner fills this in>

**How it closes.** `product-content` folds it on its next run exactly as it folds §§ 1–2.
