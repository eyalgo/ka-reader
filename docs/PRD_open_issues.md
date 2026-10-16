# PRD open issues — KA-Reader

> Companion to `PRD.md`. The CPO authored the PRD non-interactively; this file holds
> what it could not settle from the inputs. **Answer inline** — fill each **Answer** /
> **Confirm-or-override** slot — **commit this file**, then re-run `product-prd`. It folds
> your answers into the PRD and drops the resolved items. When nothing is left unresolved,
> `product-prd` clears this file: no file = the PRD is done.
>
> **Commit before re-running.** The run that finishes a round removes this file, and git
> refuses to remove a file with uncommitted edits in it — so an uncommitted answer stops
> that run before it can commit anything, and the round's work is left on the floor.
>
> Your answers are never thrown away. Each time the CPO folds them in, it first copies
> this file whole to `docs/trail/prd/` — so what you decided, and why, stays readable
> and citable for good.

> **No `product-prd` run wrote this file.** The owner opened it on 2026-10-16, in an
> interactive session, after moving the repository. The PRD is Settled, so without a companion
> the move would reach no one.

---

## 1. Open issues — product-defining questions with no answer yet

None.

## 2. Choices to confirm — the CPO drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write this document

### 3.1 The repository moved to `github.com/eyalgo/ka-reader`, under the owner's personal handle
- **Raised by:** Product (owner) — 2026-10-16
- **Which section:** § *Public identity* (`PRD.md` lines 396–399): "KA-Reader is published under
  the `kensaiapp` GitHub organisation (`github.com/kensaiapp/ka-reader`) and maintained under that
  name; no personal handle is the public face", owner-confirmed at `trail/prd/cycle-7.md`.
- **What moved:** on 2026-10-16 the owner transferred the repository from the `kensaiapp`
  organisation to the personal account `eyalgo`. It is now `github.com/eyalgo/ka-reader`, still
  private. GitHub redirects the old address.
- **Why:** the owner's call, made knowing it reverses the cycle-7 confirmation. Whether the
  repository goes public, and how its CI is paid for, are to be settled later and are not part of
  this item.
- **What it reaches downstream:** the address is cited in `SRS.md` (C-7's identity, lines 497 and
  817), `SDD.md` (the release and E-7, lines 628, 1285 and 2257–2288), and
  `adr/0007-ad-hoc-signed-dmg-on-a-github-release.md` line 10. `SDD.md`'s CI evidence lines
  (`gh run … --repo kensaiapp/ka-reader`) are records of runs made at the old address and stay as
  written.
- **Answer:** The public identity is `github.com/eyalgo/ka-reader`. The personal handle `eyalgo` is
  now the face the repository is published under. The rest of § *Public identity* (a private
  individual, a side project) stands until the owner says otherwise.

**How it closes.** `product-prd` folds it on its next run; the documents downstream follow by
their own companions.
