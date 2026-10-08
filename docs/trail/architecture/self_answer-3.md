# Self-answer report — `adr/` and `nfdr.md`

## Header

- **Companion:** /Users/eyalgolan/products/ka-reader/docs/architecture_open_issues.md
- **Document:** `adr/` and `nfdr.md` (`docs/adr/`, `docs/nfdr.md`)
- **Decided by:** `decide_companion_answers.md` v1.0.0
- **Date:** 2026-09-02

## Items worked

### 1.1 — The Rust packet requires a binary crate to select a logging facade, and this product names none

- **Bucket:** 1. Open issues — questions with no answer yet
- **Verdict:** answered
- **Why:** `log`, as an NFDR entry under § 7 and no ADR. The item sits in bucket 1 and carries a
  lean anyway ("offered and not drafted"), so it was treated as a draft and put through the checks
  rather than answered from nothing. **Check 1 — mine, in the owner's seat.** Where the edit lands is
  this document: the packet says the choice "belongs in the product's own `docs/nfdr.md`"
  (`<CORE>/doctrine/engineering/languages/rust/errors_logging.md` § Which facade, "Recording it is
  the part that is not optional"). What it commits is one crate on an allowlist reviewed as code
  (QC-3, QC-26) — no person, no money, no legal position. No unseeable ground: the SDD names no
  facade (`grep -n -i 'tracing\|env_logger\|slog' docs/SDD.md docs/SRS.md docs/fdr.md` returns
  nothing) and the packet's own seed closed with the choice left to the product
  (`kensaiapp-dev@49e0444f`, its commit body: "only log versus tracing is left"). The CTO's lane
  was weighed — the instance overlay puts "the dependency tree engineered as a design decision" on
  that seat (`system/loaders/principal_architect.md` § The domain, the seam paragraph) — and does
  not take the item: the SDD's mechanism for a dependency is the allowlist (`docs/SDD.md` § 4 C-R6),
  which absorbs the crate without a design sentence moving, and the packet names this document as
  the home. **Check 2 — the lean holds, for the reason it gives, and was extended.** The packet's
  discriminator (queried by field / concurrent attribution versus read as lines) returns `log` on
  the record: one line per `failed` or `stopped` item naming the part, the operation and the error
  text (`docs/SDD.md` § 4 C-I2; `docs/nfdr.md` QC-39), the file truncated at launch and capped at
  1 MiB with the most recent lines present (`docs/SRS.md` § 4.5 NFR-11), and nothing in the product
  reading it back (QC-52). One citation in the item's supporting text does not hold as written: it
  attributes "bounded as a file a person opens in an editor" to `docs/SRS.md` RN-36, and RN-36
  states the bound without that phrase (`grep -n -i editor docs/SRS.md` hits only an unrelated
  line 385); the answer rests on NFR-11's text instead, and the item is not edited. The extension
  is the implementation, which the lean left open and the packet requires the binary to select
  ("A binary crate selects an implementation and initializes it once, early", same file § Logging).
  **Check 4 is what decided it — the *refused* path.** A stock `log` implementation reads its level
  from the environment, and this product forbids `std::env::var` in any shipped crate (QC-30's
  `checks/structure.sh` rule; QC-58: "reads no configuration file, no environment variable and no
  argument"). So the implementation is the host's own writer — the module QC-39, QC-40 and QC-52
  already bind, implementing `log::Log`, installed once in `ka-reader-app` (the composition root,
  QC-17; ADR-0009 § Decision) — with its level fixed in code. That is not a new obligation but the
  existing ones read together: QC-52 says the file is "the product's only diagnostic output", so a
  writer admitting `debug!` lines from `ka-reader-core` would already break it. *Empty*: a session with
  no `failed` or `stopped` item writes nothing, which QC-40's truncate-at-launch already covers.
  *Absent*: a failed log write surfaces nowhere (NFR-11; QC-40) — unchanged by the facade.
  *Concurrent*: two instances writing one file is NFR-11's own case and the bound is on-disk size,
  so it holds under either facade. *Stale*: the `log` facade's holder is outside this product — the
  crate's repository sits under the `rust-lang` organisation (https://github.com/rust-lang/log, a
  URL this run did not open; the producing run opens it before the entry carries it) — and if that
  holder goes silent the facade still compiles, the writer is the product's own, and the recorded
  reversal to `tracing` is the packet's bridge (`errors_logging.md` § Which facade, "It is not a
  fork paid for twice"). **Check 3.** Nothing settled moves: QC-39, QC-40, QC-52 hold as written;
  QC-3 and QC-26 gain one name on the allowlist; QC-17 and QC-13's "outside its log module" are the
  seams the answer lands on. **Significance.** No ADR: cheap to reverse by the packet's own account,
  unsurprising, and a trade-off the entry states in two sentences — the item's "an ADR if the
  choice is judged architecturally significant" is answered *no*, and the enforcement surface is
  the allowlist diff plus a `checks/structure.sh` rule on `log::set_logger`, so the entry is a
  constraint with teeth rather than a sentence about the product. **What would have tipped it to
  `tracing`:** any reader of the log inside the product, or a diagnostic keyed by field — the SDD
  has neither, and PD-32 fixes observability as "minimal by decision" (`docs/fdr.md` PD-32).

### 2.1 — Three statements that "no Rust packet exists" are now false, and § 9's test paths move to `crates/`

- **Bucket:** 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** Confirmed: the three edits are on disk at NFDR v3 (`ka-reader@9229881`) and each holds for
  the reason it gives. **Check 1 — mine.** The edits land in this document alone; the placement is
  the owner's already-made ruling, carried and not re-decided (`kensaiapp-dev@49e0444f`, "crates/ is
  the house answer, and the product adapts to the packet"; `layout.md` § A multi-crate product,
  which names `ka-reader@docs/nfdr.md` § 9 by name). **Check 2 — the argument holds, and was read
  against the packet rather than against the item.** RN-7's departure (1) — layers 3, 5 and 6 on
  the `checks/` harness where the packet's shape is `tests/<use_case>.rs`, `tests/<flow>.rs`,
  `tests/architecture.rs` — matches `testing.md` § Layers 1–5 and § Layers 6–7; departure (2) —
  layer 4 present on Vitest Browser Mode — matches the packet's own rule that a rendering Rust
  product "records its layer-4 tooling in its own `docs/nfdr.md` § 9" (§ The rules that make that
  table work); the agreement on `cargo audit` at release is the packet's, adopted from this
  document by the owner's call (`quality_gates.md` § Dependency advisories; `kensaiapp-dev@5ee506e9`).
  The header's cited packet versions were checked against the files' own front matter —
  `testing.md` 1.0.0, `layout.md` 1.1.0, `errors_logging.md` 1.1.0, `quality_gates.md` 1.1.0,
  `toolchain.md` 1.1.0 — and all five agree. **The addition is a departure RN-7 does not list.**
  `testing.md` § Layers 1–5 puts `--locked` on every run command in its table and states the reason;
  § 9's `cargo test -p ka-reader-core --test …` and `cargo test -p ka-reader-app …` commands, and the same
  commands in § 10, carry no `--locked`. RN-7's own rule is that "what stays here is what this
  product fixes *differently* from a packet, each with its reason", and no reason for this
  difference exists anywhere in the document — it is an omission, not a decision, so the packet's
  form is followed rather than a departure invented. QC-26 already binds `cargo build --locked` in
  CI; a test command that re-resolves is the same hole. **Check 3.** Nothing settled moves: ADR-0009
  names crates by name (its § Decision table) and fixes no directory, so the `crates/` placement is
  a layout fact under it; ADR-0002's *two languages* and ADR-0009's *two toolchains* stay true; the
  card's test command (RN-6) is `cargo test --workspace` without `--locked` — that field is the
  instance's, off the SDD's S-1 bar, and is not this document's to change; it is listed under
  *Skipped* for the owner rather than drafted. **Check 4.** *Stale*: § 9 cites the packet by file
  and version, and the header's cites blockquote carries every version, so a packet revision is
  visible as a version mismatch rather than a silent drift. *Absent*: if the packet's holder — the
  managing instance's core — stops moving, § 9 states every rule it relies on in full (RN-8), so the
  trace is provenance and never a dependency. *Empty*: a workspace with no `crates/` yet is the
  present state (no Rust source is tracked in the product: `ls /Users/eyalgolan/products/ka-reader`
  shows `docs/`, `scripts/`, `third_party/` and no manifest), and the paths bind the first change
  that creates one. What would have tipped it to *overridden*: a product record fixing a different
  placement, which `languages/README.md` § Precedence would honour — there is none.

### 2.2 — RN-7 says the card has no `Languages:` line; it now has one

- **Bucket:** 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override
- **Verdict:** confirmed
- **Why:** Confirmed as applied at v3. **Check 1 — mine.** The edit is two review notes and § 8's
  preamble in this document; it commits nobody to anything. **Check 2 — the facts were re-measured,
  and one date in the item is wrong.** `git -C kensaiapp-opensource show 4bdfddd:system/projects/ka-reader/project.md`
  prints `**Test command:** pytest tests/` with its PROVISIONAL comment and no `Languages:` line —
  so the pin RN-6 uses is the card as v2 read it, as the note says. The two closes:
  `kensaiapp-opensource@c2155cc` is dated **2026-09-01** ("the card's test command is the
  two-toolchain gate the settled documents fix", touching `project.md`) and `0af5fb9` is dated
  2026-09-02 ("the card declares its languages, Rust included ahead of its packet"). The item's
  rationale says "both halves of RN-6 were closed on 2026-09-02", which is false for the first; RN-6
  as applied carries the right dates, so the document is not wrong — only the item's supporting text
  is, and it is reported here rather than edited. RN-7's derivation moved as the item says: it now
  reads "Both packets resolve at step 1 of `languages/README.md` § The resolution chain, from the
  card's `Languages:` line", and the card carries `**Languages:** Rust, TypeScript, Shell`
  (`system/projects/ka-reader/project.md` at HEAD, `0af5fb9`). **Check 3.** Agrees with 2.1 (RN-7 is
  one note, re-derived once) and with 1.1 (nothing in the card names a facade). **Check 4.** *Stale*
  is the case that matters for a note about another repository's file, and the draft already
  answers it with the pinning treatment cycle 1 gave RN-2 (`docs/trail/architecture/cycle-1.md`
  § 2.8): each claim is tied to a commit, so the card moving again makes nothing here false. § 8's
  preamble does carry one live sentence — "its `Languages:` line names Rust, TypeScript and Shell
  (RN-6)" — which goes false if the card's line changes; the RN-6 pointer beside it is what a reader
  follows to the commits, and that is the shape the owner confirmed for RN-2, so it is left as is.
  *What the fold does not reach*: the card's `Languages:` comment still says "Rust has no packet
  yet: resolution falls through to the language-agnostic floor" — a fact in the managing instance
  that is now false, outside this document, with no companion template naming a project card; it
  is recorded under *Skipped* for the owner. What would have tipped it to *overridden*: the
  card's commits not touching `project.md`, or RN-6 stating them as present state — neither is so.

## Left for the owner

None this run.

## Skipped

- **`system/projects/ka-reader/project.md` (kensaiapp-opensource) — the `Languages:` comment and the
  test command** — not an item on this companion and no companion template names a project card,
  so nothing was written (SKILL.md § When a change belongs to another document, "No template names
  that document"). Two facts for the owner: the `Languages:` line's comment reads "Rust has no packet
  yet: resolution falls through to the language-agnostic floor" (`project.md`, the `Languages:`
  field, `0af5fb9`), false since `kensaiapp-dev@d628f75c`; and the test command
  `cargo test --workspace && (cd ka-reader-ui && pnpm exec vitest run)` carries no `--locked`, where the
  Rust packet puts it on every `cargo test` run (`languages/rust/testing.md` § Layers 1–5) — item
  2.1's answer follows the packet inside the NFDR and leaves the card's field to its owner.

## Companions opened

None this run.

## Launchers owed

- **`adr/` and `nfdr.md`** — `<CORE>/launchers/product-architecture/launcher.sh ka-reader`
