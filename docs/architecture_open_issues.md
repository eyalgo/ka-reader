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
> The PM added § 3.2 on 2026-09-23, from the first CI runs on a GitHub-hosted runner: ADR-0010 and
> QC-25 fix what the sandbox probe reads and not when, and the first runs read it too early.

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

### 3.2 ADR-0010 and QC-25 fix what the probe must read, not when — and the first CI runs read too early
- **Raised by:** PM — 2026-09-23
- **Which record:** ADR-0010 § Decision and § Consequences; NFDR § 1 QC-25 and its § 10 row
- **Tracked by:** `nozoki · nemawashi · 2026-09-15_open-a-folder`; the fix to the probe is the change
  unit `nozoki · tobiishi · 2026-09-23_the-probe-waits-for-the-sandbox`
  (`kensaiapp-opensource@1523865`); the SDD side is `docs/SDD_open_issues.md` § 5.1
- **What it blocks:** Nothing waits on it to be built. The change unit makes `checks/bundle.sh` wait,
  bounded, for the first `sandboxed: yes`, and makes the negative control answer `no` for the whole
  window. Both records say "fails unless the operating system reports that pid as sandboxed" and
  neither says when the report is read, so the change fits the words as they stand. What is
  owed from this side is a ruling that it does — or a record that says otherwise.
- **Where it shows:**
  - ADR-0010 § Decision: the probe "fails unless the operating system reports that pid as sandboxed
    and reports two operations denied for it"; QC-25 (`nfdr.md:L227-L233`) states the same. No
    timing in either.
  - ADR-0010 § Consequences: "a probe that fails while the wall stands redraws the probe and no
    slice"; and replacing the *observable* costs "a superseding record here". The change reads the
    same observable, `sandbox_check`, and changes only when it is read.
  - ADR-0010 closes on "One case is unmeasured": the hosted runner, "settled by the probe's first CI
    run". Measured: run 35797893381 (`macos-14`, SIP disabled) reported the real bundle
    `sandboxed: no` on ask 1 and `sandboxed: yes`, both denied, on asks 2–5, 0.25 s apart; an
    unentitled copy `no` on all five. The same first-ask `no` shows on the owner's Mac for a freshly
    re-signed copy. Full table: `docs/SDD_open_issues.md` § 5.1.
  - The negative control as recorded — "requires it to fail" — passes on one `no`, and one early
    `no` is what an entitled launch can report too. The change makes it stricter; that sentence of
    ADR-0010 is where a reader would look for the rule.
- **If a document has to be written:** none, on the PM's lean. The log is append-only, and the
  observable has not moved, so no superseding record is owed. What may be owed is QC-25's *verified
  by* naming the bounded window and the control's whole-window rule, re-derived from C-I3 once the
  SDD's § 5.1 is folded. Doubt: if the window is read as part of the mechanism ADR-0010 fixed, it is
  a new record superseding it, and that is this seat's call, not the PM's.
- **Answer:** <the owner fills this in>

**How it closes.** `product-architecture` folds it on its next run like any other item here.
