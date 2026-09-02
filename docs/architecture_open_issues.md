# Architecture open issues — Nozoki 覗き

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

> **This companion was opened by an owner-directed session, not by a `product-architecture` run.**
> Both records are settled and the companion was correctly deleted at the end of cycle 1. It is
> re-opened because **an input moved underneath them**: the organisation's language registry gained a
> **Rust packet** on 2026-09-02 (`kensaiapp-dev@3c8521a1` and the commits before it), and the records
> state in three places that no such packet exists. With no companion on disk a `product-architecture`
> re-run reads both records as done and has nothing to act on.
>
> **Nothing here is a new architectural decision.** Two items are premises the host's change made
> false, and the third is a choice the packet deliberately leaves to this product. The physical module
> set is untouched: `adr/0009-physical-module-set.md` names its crates by **name** and fixes no
> directory, so no record is superseded and the append-only rule is not in play.
>
> **Applied at NFDR v3.** The first `product-architecture` run after this file was opened found its
> slots unfilled — nothing to fold, no trail cycle — and applied the two § 2 drafts to `docs/nfdr.md`
> (§ 9's preamble and Rust paths, RN-7, RN-6, § 8; its RN-14 records the run), so *Drafted into the
> records* below is now literal. The items stand for your confirmation, and § 1.1 for your answer;
> `docs/nfdr.md` reads Draft until this file is gone. The `docs/nfdr.md:L…` locators below are v2's
> (`nozoki@1329741`).

---

## 1. Open issues — questions with no answer yet

### 1.1 The Rust packet requires a binary crate to select a logging facade, and this product names none

- **Lands in:** `nfdr.md` § 7 (a new QC beside QC-52, the log's location and shape), and an ADR if
  the choice is judged architecturally significant.
- **Why it matters:** the packet fixes the *shape* and deliberately not the choice — a library crate
  depends only on the facade, and **"A binary crate selects an implementation and initializes it once,
  early"** (`<CORE>/doctrine/engineering/languages/rust/errors_logging.md:L86`). The two candidates it
  names are `log` and `tracing` (`:L80-L83`). `nozoki-app` is the binary and the composition root
  (`docs/adr/0009-physical-module-set.md:L30`), so the selection is its obligation and nothing in this
  product's records makes it: a search of `nfdr.md` and `SDD.md` for `tracing`, `log crate`,
  `env_logger` and `slog` returns nothing but an unrelated RN-8. The host left this open on its own
  seed too — its retire commit records "only log versus tracing is left"
  (`kensaiapp-dev@49e0444f`), so neither side has chosen and the product is the side that must.
  Until it is chosen, NFDR RN-11's diagnostic-log obligations name no facade to hold them.
  **A lean, offered and not drafted — `log`.** The packet's discriminator is whether diagnostics
  are "queried by field, or attributed to a concurrent operation" (`tracing`) or "read as lines"
  (`log`), and "A product that cannot tell which it has, has the second"
  (`<CORE>/doctrine/engineering/languages/rust/errors_logging.md` § Which facade). This product's
  log is one line per `failed` or `stopped` item naming the part, the operation and the error text
  (`docs/SDD.md` § 4 C-I2; NFDR QC-39), bounded as a file a person opens in an editor
  (`docs/SRS.md` § SRS Review Notes RN-36), and nothing queries it; the attribution a concurrent
  read needs is already in the line (the part and the operation). `log` is the smaller dependency,
  which the allowlist (QC-3, QC-26) prefers, and the packet records that a library on `log` stays
  readable from a binary on `tracing`, so the choice is cheap to reverse. If overridden to
  `tracing`: the same entry, a second crate in `checks/deps.allow`, and a subscriber initialized
  in `nozoki-app`.
- **Answer:** `log`, recorded as a constraint in `nfdr.md` § 7 beside QC-52, and no ADR — the choice
  fails the significance test: the packet records that a library on `log` stays readable from a
  binary on `tracing`, so reversal is one allowlist change, and neither half of the choice surprises
  a cold reader. The entry binds three things. (1) Every shipped Rust crate depends on the `log`
  facade for diagnostics and on nothing else — no `tracing`, no `slog`; `nozoki-core` uses the five
  macros and initializes nothing. (2) The implementation is `nozoki-app`'s own log module — the
  writer QC-39, QC-40 and QC-52 already bind, implementing `log::Log` — installed once at startup in
  `nozoki-app`, the composition root (QC-17), with no third-party implementation crate. The reason is
  a constraint already on disk, not taste: the stock implementations of `log` read their level from
  the environment, and QC-30 / QC-58 forbid `std::env::var` in any shipped crate, so an off-the-shelf
  logger fails `checks/structure.sh` the day it lands. The level the writer admits is fixed in code
  and read from nothing outside; it holds what QC-39 and QC-52 describe and nothing below it. (3)
  Verified by: `checks/no-network.sh` — `checks/deps.allow` gains `log` and names no `tracing*`,
  `env_logger`, `slog*` or `log4rs` crate, so a swap fails the allowlist diff (QC-3, QC-26);
  `checks/structure.sh` — `log::set_logger` / `log::set_boxed_logger` appears only in `nozoki-app`
  (layer 6). Ground for `log` over `tracing`: the packet's discriminator is *queried by field or
  attributed to a concurrent operation* against *read as lines*, and this log is read as lines by
  construction — one line per `failed` or `stopped` item naming the part, the operation and the error
  text (`docs/SDD.md` § 4 C-I2; QC-39), the most recent lines always the ones present (`docs/SRS.md`
  NFR-11), nothing in the product reading it back (QC-52: the only diagnostic output) — and the
  attribution a concurrent read needs is in the line already. If a later change needs spans or
  fields, the reversal is the packet's own bridge — `tracing` in the binary consuming `log` records —
  as one allowlist change and one revision of this entry. Which macro a `failed` and a `stopped` item
  are emitted at is the delivery tier's placement under the packet's ladder, not this entry's.
  Reasoning: `docs/trail/architecture/self_answer-3.md` § 1.1.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

### 2.1 Three statements that "no Rust packet exists" are now false, and § 9's test paths move to `crates/`

- **Lands in:** `nfdr.md` § 9 preamble, `nfdr.md` § 9's table rows, and `nfdr.md` RN-7.
- **Drafted into the records:** three edits, all in the constraint set and none in the decision log —
  applied at NFDR v3 (§ 9's preamble, § 9 rows 2–3, RN-7).
  1. The § 9 preamble reads "the host and core are Rust, for which no language packet exists, so their
     tooling is this product's own, recorded here (RN-7)" (`docs/nfdr.md:L485-L487`). The registry now
     carries `| Rust | rust | `.rs` |`, so the clause is false and its consequence inverts: Rust
     tooling resolves to the packet, and what stays here is only what this product fixes *differently*,
     with its reason.
  2. RN-7 reads "Rust, for which the organisation's registry has no packet, so their tooling falls to
     the language-agnostic floor and is fixed here" (`docs/nfdr.md` RN-7). Same correction. RN-7 keeps
     the parts that remain true and this product's own — layer 4's Playwright-not-WKWebView split, and
     the `cargo build --locked` / `cargo audit` tree obligations — now recorded as this product's
     realization *on top of* the packet rather than in the absence of one.
  3. § 9's table names `nozoki-core/tests/` and `nozoki-app/tests/` at the repository root — three
     path-shaped references, all on `docs/nfdr.md:L494-L495`, and the only ones in the whole document
     set. They become `crates/nozoki-core/tests/` and `crates/nozoki-app/tests/`.
- **Rationale:** edit 3 is **the owner's already-made call, carried, not re-decided.** The packet
  states "Workspace members live under `crates/`, one directory per member"
  (`<CORE>/doctrine/engineering/languages/rust/layout.md:L88`), and it names this product by name as
  the one that adapts: "**This is the packet's answer and the products follow it, including the one
  whose records said otherwise first**" (`:L95-L99`), citing `nozoki@docs/nfdr.md` § 9 exactly. The
  owner's ruling is `kensaiapp-dev@49e0444f` — "the packet's placement is the house answer and nozoki
  adapts, which its own definition chains will carry." The ground is the manifest's: the Cargo Book's
  workspace example is `members = ["crates/*"]`, so a member is added by creating a directory, where a
  root layout makes `members` a hand-maintained list and a crate added without the list edit builds
  locally while being invisible to `cargo test --workspace`.
- **If overridden:** `languages/README.md` § Precedence is explicitly unchanged by that ruling — a
  product's own decision files still outrank the packet, so this product *may* fix a different
  placement. Overriding means saying so in a record rather than by silence, since silence now reads as
  the packet's answer. Nothing else moves: the card's test command is workspace-relative
  (`cargo test --workspace`) and unaffected, and the renderer's `cd nozoki-ui` is a TypeScript package,
  not a workspace member.
- **Confirm or override:** confirm, with one addition to RN-7's departure list. The three edits stand
  as applied at v3, verified against the packet: `layout.md` § A multi-crate product names this
  document's § 9 as the one that adapts and the ruling as `kensaiapp-dev@49e0444f`; RN-7's two
  departures and its `cargo audit` / `--locked` agreement read as the packet states them
  (`testing.md` § Layers 1–5, § The rules that make that table work; `quality_gates.md`
  § Dependency advisories — the owner's call of 2026-09-02, citing this RN-7). The addition: the
  packet puts `--locked` on every `cargo test` command, layers 1–6 and the workspace run alike, with
  its reason — "a run allowed to re-resolve dependencies is a run against a tree nobody reviewed"
  (`testing.md` § Layers 1–5) — and § 9's table and § 10's rows carry it on no `cargo test` command,
  while RN-7 lists it neither as followed nor as a departure. Follow the packet: the `cargo test`
  commands in § 9 and § 10 take `--locked`, and RN-7's "where § 9 now follows the packet" names it
  beside the `crates/` paths. QC-26 already makes the CI build `--locked`; this closes the same hole
  on the test side. The card's `cargo test --workspace` is the instance's own field and not this
  document's to edit — § 8 states the card as it reads — and whether the card takes `--locked` is
  put to the owner in the report. Reasoning: `docs/trail/architecture/self_answer-3.md` § 2.1.

### 2.2 RN-7 says the card has no `Languages:` line; it now has one

- **Lands in:** `nfdr.md` RN-7, and RN-6 where it states the same gap.
- **Drafted into the records:** RN-7's parenthetical "no `Languages:` line on the card — RN-6" is
  struck, and RN-6's own sentence naming "a `pytest` test command and no `Languages:` line" becomes
  history rather than present state, pinned to the commit that was true when it was written —
  applied at NFDR v3 (RN-6 pinned to `kensaiapp-opensource@4bdfddd`; § 8's preamble follows it).
- **Rationale:** both halves of RN-6 were closed on 2026-09-02 in the managing instance. The card now
  reads `**Test command:** cargo test --workspace && (cd nozoki-ui && pnpm exec vitest run)`
  (`kensaiapp-opensource@c2155cc`, authored by a `cto:` run off the SDD's S-1 command bar) and
  `**Languages:** Rust, TypeScript, Shell` (`kensaiapp-opensource@0af5fb9`). RN-7's first sentence
  also derives the renderer's packet resolution from the *absence* of that line; with the line present,
  resolution now stops at step 1 of `languages/README.md` § The resolution chain rather than falling
  through to extension inference, which is a different and shorter derivation.
- **If overridden:** if either note should stay as written, it needs the pinning treatment cycle 1
  applied to RN-2 — a note that states what was true at a named commit rather than a live claim that
  goes false again.
- **Confirm or override:** confirm. RN-6 as applied is history pinned to a commit and stays true
  whatever the card does next: `git show 4bdfddd:system/projects/nozoki/project.md` carries
  `**Test command:** pytest tests/` marked PROVISIONAL and no `Languages:` line, and the two closes
  are the commits named — `c2155cc` (2026-09-01, not 2026-09-02 as this item's rationale says) and
  `0af5fb9` (2026-09-02); RN-7 now resolves both packets at step 1 of the chain from the
  `Languages:` line. One thing the fold does not carry, put to the owner rather than drafted here:
  the card's own `Languages:` comment still reads "Rust has no packet yet" — a fact the managing
  instance owns and this document does not. Reasoning: `docs/trail/architecture/self_answer-3.md`
  § 2.2.
