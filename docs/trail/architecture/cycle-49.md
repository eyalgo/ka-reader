# Architecture open issues — KA-Reader

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

> **No `product-architecture` run wrote this file.** The owner opened it on 2026-10-16, in an
> interactive session, after switching GitHub Actions off on `eyalgo/ka-reader` until billing is
> settled. The records are Settled, so without a companion the owner's intent would reach no one.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

None.

## 3. Raised from downstream — an item from a seat that did not write these records

### 3.1 Every rule CI holds must be held without GitHub CI
- **Raised by:** Product (owner) — 2026-10-16
- **Which record:** `nfdr.md` § 10's *Gated at* column (every row gated at `CI build` only), § 9's
  toolchain record (the Swift CI builds with, printed by the `Toolchain` step), and § 8's change-time
  gate (the card's test command, run by the pipeline's gate tool in the macOS guest).
- **Tracked by:** no seed.
- **The owner's intent, verbatim:** "not be dependent on github ci but still test and cover what is
  needed."
- **What moved:** on 2026-10-16 the owner switched Actions off on `eyalgo/ka-reader`. The last hosted
  runs were refused for billing (38908439556, 38930009564), and whether CI returns is not settled.
  Today the change-time gate runs `cargo test`, the bridge assembly, `swift test`,
  `checks/structure.sh` and its suite. Everything else `ci.yml` runs is held nowhere while Actions is
  off: entry-points, bundle probe, view, renderer, the three read-only fixtures, no-network, each one's
  suite, the launch of the built bundle and own-state.
- **Measured** (the last green hosted run, 38673998411, per step): the checks alone take about 70 s;
  their suites about 12 min (entry-points 218 s, bundle 351 s, renderer 120 s, the rest seconds); the
  launch and own-state about 2 s. The launch and own-state steps are inline scripts in `ci.yml`,
  wrapped in a tick timer because reading the app's container can wait on an OS consent prompt. Bundle
  probe, renderer, launch and own-state all launch the app; own-state reads the machine's home.
- **What the records need to say** (the requirement; the shape is yours):
  1. Every rule `ci.yml` holds today is held by a gate that runs without GitHub: at the change, or at a
     stated point the pipeline reaches, and you choose which rule goes where.
  2. The app-launching and home-reading checks run only in the macOS guest, never on the owner's Mac,
     including under the gate tool's owner's-Mac option.
  3. The toolchain of record is the one that gate runs on, not only CI's, so a Swift-version gap like
     the 6.3/6.4 break of 2026-10-14 is caught there.
  4. If CI returns, it runs the same thing, so the two cannot drift.
- **If a document has to be written:** your call — a fold into §§ 8–10, possibly an ADR if the gate
  of record moving off GitHub is a binding. The build work it implies (for example one script under
  `checks/` both the card and `ci.yml` call) is a product change and goes through the chain after the
  fold.
- **Answer:** Yes: the intent above is the owner's. How the rules are split between the change and
  any later point, and in what form, is the Principal Architect's to decide and record.

**How it closes.** `product-architecture` folds it on its next run like any other item here.
