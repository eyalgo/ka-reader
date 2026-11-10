# CONTENT open issues — KA-Reader

> Companion to `CONTENT.md`. Answer inline, commit this file, then re-run `product-content`.
> The Content Manager folds the answers into the verbal language and removes resolved items;
> when nothing remains, it deletes this file. Answers are preserved whole under `docs/trail/content/`.
>
> No producing `product-content` run wrote this companion. The PM opened item 3.1 on
> 2026-11-10, reading the settled CONTENT against the product at `ka-reader@7a88215`. The
> document itself is unchanged.

## 1. Open issues

None.

## 2. Choices to confirm

None.

## 3. Raised from downstream — an item from a seat that did not write the verbal language

### 3.1 The beta's unexplained-fault sentence names "this repository" when the stop came before any repository was found

- **Raised by:** PM — 2026-11-10
- **Tracked by:** `ka-reader · nemawashi · 2026-10-30_a-stranger-can-install-the-first-release`
- **What it blocks:** an exact wording for the Git view's slot when finding the repository root stops with no explanation. Today that slot claims a repository the tool never established, against § Message patterns' rule that a message states what KA-Reader actually read (`CONTENT.md:L76`).
- **Where it shows:** § Message patterns, Error, the unexplained-fault examples (`CONTENT.md:L330-L338`). They give one beta sentence, *"KA-Reader stopped while reading this repository's Git status and can't tell why…"*, and say nothing about a stop during root finding. At `ka-reader@7a88215` the catalogue draws that one sentence for every unexplained stop (`ka-reader-mac/Sources/Surfaces/GitSentences.swift:L26-L27`, returned at `:L96`). That includes a root-finding stop that produced no observation, the case the product's beta behaviour gives its own example.
- **If a document has to be written:** none. CONTENT either says the beta example covers a stop before any repository was found, or gives that case its own sentence, for the beta and for the day Git state follows the disk.
- **Answer:** Give the stop that comes before KA-Reader has established a repository its own whole sentence in the beta, and name no repository in it. Draft for the fold to finalise against § Terminology and § Localization: *"When you opened the folder, KA-Reader stopped while finding out whether it's a repository and can't tell why. The file tree and the reading panel are unaffected. Start KA-Reader again to look again."* The rule it states: an unexplained-fault sentence says *this repository* only when the stop came after KA-Reader established one. The existing beta example stays as it is, scoped to stops after that point. For the day Git state follows the disk the answer is "not until it occurs": no product behaviour draws that case yet, and its wording is written the day the beta statement is retired. Reasoning and checks: `docs/trail/content/self_answer-18.md`.
