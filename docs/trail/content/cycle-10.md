# CONTENT open issues — Nozoki

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


> **No `product-content` run wrote this file.** The PM opened it on 2026-10-04 from the verbal
> language's own companion template. The file tree and the Git view now draw a status letter on a
> folder row, and `CONTENT.md` states the letters and their words for a changed file only. The
> document is Settled, and with no companion on disk a `product-content` re-run reads it as done and
> has nothing to act on. Its one item is in § 3.

---

## 1. Open issues

None.

## 2. Choices to confirm

None.

## 3. Raised from downstream — an item from a seat that did not write the verbal language

### 3.1 The status letters and their words are stated for a changed file; the product draws them on folder rows too
- **Raised by:** PM — 2026-10-04
- **Tracked by:** `nozoki · nemawashi · 2026-10-02_git-says-what-changed`
- **What it blocks:** the expansion's words for a folder row. Until the standard says whether the six
  words cover a folder, whoever writes the expansion (`docs/fdr.md` R-38) has nothing to write
  *modified* for a submodule whose commit moved, or *untracked* for a repository nested in the folder
  you opened, against.
- **Where it shows:** `docs/CONTENT.md:L145-L147` and `:L422-L424` show the letters "beside a changed
  file", and § Terminology defines **changed** as "A file Git reports as different from the last
  commit". In the product a folder row carries a letter in both surfaces: the file tree marks a
  listed folder's row (`nozoki-mac/Tests/SurfacesTests/TreeMarkersTests.swift:L69-L77`, `sub` **M** and
  `inner` **U**), and the Git view lists the same two folders with the same letters
  (`nozoki-mac/Tests/SurfacesTests/WorkbenchTreeMarkerTests.swift:L110`, `:L168`). The likely fold: a
  line in § Accessibility of text or § Terminology that covers a listed folder — whether the six words
  apply to it as written, or which words a folder takes.
- **If a document has to be written:** none. A line in `CONTENT.md`, written by `product-content`.
- **Answer:** Take it. The six words cover a folder row as written, and a folder takes no word of its own: a submodule whose commit moved is **M** and reads *modified*, and a repository nested in the folder you opened is **U** and reads *untracked*. Resting on the letter names the row, which is the folder, and then the word, and it speaks of that folder alone and never of anything beneath it (the product marks only the listed row: `nozoki-mac/Tests/SurfacesTests/TreeMarkersTests.swift:L69-L77`). The fold: § Grammar and mechanics' single-letter bullet and § Accessibility of text's letters bullet read "beside a changed file or a listed folder"; § Terminology keeps *changed* for a file and its Notes cell says a folder row's letter is worded by the six and a folder is not called *changed*. **A**, **D**, **R** and **C** on a folder row are not stated until a site shows one. Reasoning: `docs/trail/content/self_answer-8.md`.

**How it closes.** `product-content` folds it on its next run exactly as it folds §§ 1–2.
