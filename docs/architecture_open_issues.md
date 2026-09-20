# Architecture open issues — Nozoki

> Companion to `adr/` and `nfdr.md`. The Principal Architect authored both records
> non-interactively; this file holds what the run could not settle from its inputs — the SRS, the SDD
> and the FDR.
> **Answer inline** — fill each **Answer** / **Confirm-or-override** slot — **commit this file**, then
> re-run `product-architecture`. It folds your answers into the records and drops the resolved items.
> When nothing is left open, `product-architecture` **deletes this file**: no file = the records are
> done.
>
> Your answers are never thrown away. Each time the Principal Architect folds them in, it first copies
> this file whole to `docs/trail/architecture/` — so what you decided, and why, stays readable and
> citable for good.
>
> **§ 3 is raised, not asked.** These records bind every later change, so the seats that live under
> them find gaps the authoring run could not. § 3 is where such a seat says so, against both records
> — an ADR's binding and an NFDR obligation reach the same file.

> **No `product-architecture` run opened this companion. The PM opened it on 2026-09-20, from a
> post-build review.** Both records are Settled at NFDR v8 and had no companion on disk. Without one,
> a `product-architecture` re-run would read them as done and find nothing to act on. The companion
> holds one § 3 item: QC-3 states a domain — no network transport — and is verified by a check that
> compares the tree to the allowlist, which proves nothing about the allowlist's own membership.

---

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 QC-3 closes over itself: the allowlist is what the check compares against, so nothing proves the allowlist is transport-free
- **Raised by:** PM — 2026-09-20
- **Which record:** NFDR § 1 QC-3 and its § 10 row
- **Tracked by:** `nozoki · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** Nothing fails today, and that is the point — the check cannot fail on the thing
  QC-3 is about. QC-3 states a domain ("No shipped unit links a network transport") and is *verified
  by* `checks/no-network.sh` diffing `cargo tree` and `pnpm ls` against `checks/deps.allow`
  (`nfdr.md:L60-L63`). That diff proves the tree and the list agree. It says nothing about whether a
  name **on the list** is a transport, so the domain half of QC-3 is verified by nothing the § 10 row
  names.
- **Where it shows:**
  - QC-3 (`nfdr.md:L60-L63`) and its § 10 row (`nfdr.md:L665`) — both name `checks/no-network.sh`
    and no second gate.
  - Measured on the tree at `nozoki@92a76c4`: `bash checks/no-network.sh` → `ok — 218 cargo names and
    163 pnpm names match checks/deps.allow`, exit 0, while `checks/deps.allow:L51` holds
    `crypto-common` and `:L204` holds `tokio`. Neither is a transport by name, and nothing in the
    harness or in either record traces what admitted them.
  - QC-26 (`nfdr.md:L244-L250`) **is** the record that carries the human half — "fails the build
    until the allowlist change is reviewed as code in the same change" — but QC-3's *verified by*
    does not point at it, so a seat implementing QC-3 alone builds a diff and stops.
- **If a document has to be written:** none. What is owed is QC-3's *verified by* stating both halves
  — the diff that proves tree-equals-list, and the review that admits a name to the list at all. The
  PM's lean is to name QC-26's same-change code review as the closing half, so the domain is
  enforced by a gate the records point at rather than by the reader's assumption.
- **Answer:** <the owner fills this in>

**How it closes.** `product-architecture` folds it on its next run like any other item here.
