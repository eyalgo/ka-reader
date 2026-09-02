# Self-answer report — `adr/` and `nfdr.md`

## Header

- **Companion:** /Users/eyalgolan/products/nozoki/docs/architecture_open_issues.md
- **Document:** `adr/` and `nfdr.md` (`docs/adr/`, `docs/nfdr.md`)
- **Decided by:** `decide_companion_answers.md` v1.0.0
- **Date:** 2026-09-02

## Items worked

### 1.2 — The card's per-change gate now runs the packet's *release-time* command shape

- **Bucket:** 1. Open issues — questions with no answer yet
- **Verdict:** answered
- **Why:** The shape stands: the card's `cargo test --workspace --locked` is this product's
  change-time suite, no § 10 gate moves, and the card's field does not move. The item was raised
  by a Product-role session as "the channel, not the decision" (`nozoki@b55a6d4`) and carries no
  draft, so it was answered from scratch — but its framing carries a premise, and the premise was
  measured before anything else. **The premise is false for this product.** The packet calls the
  workspace form release-time for one stated reason: layer 5 lives in the binary crate's
  `tests/<flow>.rs`, so `--workspace` "runs every layer at once"
  (`<CORE>/doctrine/engineering/languages/rust/testing.md` § Layers 1–5, lines 27–35). § 9 departs
  from that shape with the owner's confirmation — RN-7 departure (1), "Layers 3, 5 and 6 are realized
  by the `checks/` harness", confirmed at `docs/trail/architecture/cycle-1.md` § 2.7 — and § 9 row 5
  puts layer 5 on `checks/bundle.sh`, `checks/own-state.sh`, `checks/churn.sh`, `checks/latency.sh`,
  `checks/read-only.sh --kill` and the manual AC-10 walk, gated at CI build and release in § 10.
  Measured: `grep -o 'cargo test -p nozoki-app[^;)|,]*' docs/nfdr.md` returns `--test config`
  (layer 2) and the bare layer-1 form and nothing else; `grep 'CARGO_BIN_EXE\|<flow>.rs' docs/nfdr.md
  docs/SDD.md` hits only RN-7's description of the packet's shape. ADR-0009 § Decision fixes exactly
  two crates, so `cargo test --workspace` is the union of `-p nozoki-core` and `-p nozoki-app` —
  layers 1–3 across both — and the packet's per-crate change-time form would run the same set.
  **Check 1 — mine, in the owner's seat, and not the CTO's, for a reason the item's own "Whose call"
  does not reach.** The decision the item routes to the CTO was already made by the CTO, twice
  (`kensaiapp-opensource@c2155cc`, 2026-09-01; `3a960a7`, 2026-09-02, whose body answers the
  `--locked` objection and rests the workspace choice on RN-6). What is left is whether this
  document's records contradict that field, and the edit that answers it lands here: RN-7's
  departure (1) gains its consequence. No SDD sentence moves — S-1's bar (`docs/SDD.md:L783`,
  "`cargo test --workspace` exits 0") is a floor the card's command satisfies. No card field moves.
  What binds only this document's consistency is mine. **Check 2 — the question hides a second
  question, answered too.** The item asks about the shape; underneath it is whether the packet's
  classification applies to a product whose layer 5 is not a cargo test at all. It does not, and
  the packet's own ground says why — the classification follows the crate placement, "layout.md
  already drew that line" (`testing.md` § Layers 1–5). The item also mis-names where it lands: "§ 9
  (the *gated at* column for the Rust layers)" — § 9's table has no such column; § 10's does. Reported,
  not edited. **Check 3.** Agrees with § 2.1 (settled: `--locked` on § 9's and § 10's `cargo test`
  commands, which this answer keeps), with § 2.2 (RN-6 as pinned history), with § 2.3 below (decided
  together — § 8's sentence and RN-6's third commit describe the same field this answer keeps), and
  with `kensaiapp-opensource@3a960a7`'s field. Nothing settled moves; RN-7 gains a sentence under
  its own rule that a difference from the packet is recorded "each with its reason". **Check 4 —
  *stale* is the case that decided the addition's shape.** The answer is true only while layer 5
  stays outside `cargo test`: a future `crates/nozoki-app/tests/<flow>.rs` starting the built binary
  through `CARGO_BIN_EXE_*` — the packet's own layer-5 mechanism (`testing.md` § The rules that make
  that table work) — would put layer 5 inside the per-task run silently and make the packet's
  classification apply. So the sentence names the condition and its enforcement: `checks/structure.sh`
  (layer 6, § 9 row 6 "grep rules") — no `CARGO_BIN_EXE_` reference under `crates/*/tests/`. That is
  the enforceability lens: a constraint a behaviour-preserving change could break needs a check that
  names the break. *Empty*: no workspace exists yet (`ls /Users/eyalgolan/products/nozoki` shows no
  manifest); the card's own comment carries that the first change generates the lockfile before the
  gate can pass (`system/projects/nozoki/project.md`, `Test command:`). *Refused*: `--locked` fails
  when the lockfile would change — QC-26 commits the diff in the same task, which the card's comment
  also states. *Absent*: the packet's holder going silent — § 9 states its rules in full (RN-8).
  *Concurrent*: not reached — one gate, two toolchains, run in sequence by `&&`. **What would have
  tipped it to *raised upstream*:** layer 5 under `cargo test` in this product — then the card's
  shape would be wrong, S-1's bar would need the per-crate form, and the sentence would move in the
  SDD, which is the CTO's; § 9 row 5 says it is not so.

### 2.3 — § 8's sentence about the card's test command is one flag out of date

- **Bucket:** 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override
- **Verdict:** confirmed with addition
- **Why:** Confirmed: § 8 says the card's command *satisfies* the S-1 bar and *adds* the packet's
  `--locked`, naming the packet as the flag's source. **Check 1 — mine.** The edit is one sentence in
  this document and commits nobody to anything. **Check 2 — the draft holds for the reason it gives,
  and the measurement is on disk.** § 8 reads "That card's test command is the SDD's command bar for
  the Rust workspace and Vitest for the renderer" (`docs/nfdr.md:L429-L432`); the card reads
  `cargo test --workspace --locked && (cd nozoki-ui && pnpm exec vitest run)`
  (`git -C kensaiapp-opensource show 3a960a7 -- system/projects/nozoki/project.md`, one line changed,
  2026-09-02); the SDD's bar is "`cargo test --workspace` exits 0" (`docs/SDD.md:L783`). The two are
  not the same command, so the sentence is false as written and "is" becomes "satisfies and adds".
  No SDD change is owed: a stricter command passes a floor. **The addition is RN-6.** § 8 hands its
  reader to RN-6, and RN-6 stops at the second commit: it names the command as
  `cargo test --workspace && …` (`kensaiapp-opensource@c2155cc`) and says "§ 8 now states the card
  as it reads" — both false since `3a960a7`. RN-6 gains the third commit
  (`kensaiapp-opensource@3a960a7`, 2026-09-02, `--locked` from the Rust packet, a `cto:` run), so
  the note's pinned history is complete and its sentence about § 8 is true again. **Check 3 — the
  shape is § 2.2's, which is settled and binds this run.** § 2.2 accepted a live sentence in § 8
  with RN-6's pinned commits beside it as the reader's route for the `Languages:` line, the
  treatment cycle 1 gave RN-2. Taking the item's *if overridden* alternative — § 8 stops restating
  the command — would give the same document two shapes for the same kind of fact about the same
  file, so it is not taken. Agrees with § 1.2, decided together: the field § 8 now describes is the
  field § 1.2 keeps. **Check 4 — *stale*, named and not covered.** The card has moved three times
  in two days; the next move makes § 8's sentence false again until RN-6 is extended. That is the
  accepted cost of the shape § 2.2 settled, and RN-6 is where a reader finds the commits. What would
  have tipped it to *overridden*: the S-1 bar itself carrying `--locked` in the SDD, which would make
  "satisfies and adds" wrong — it does not (`docs/SDD.md:L783`).

## Left for the owner

None this run.

## Skipped

- **1.1 — The Rust packet requires a binary crate to select a logging facade, and this product
  names none** — Answer slot already filled (`docs/trail/architecture/self_answer-3.md` § 1.1);
  left exactly as it stands.
- **2.1 — Three statements that "no Rust packet exists" are now false, and § 9's test paths move to
  `crates/`** — Confirm-or-override slot already filled (`self_answer-3.md` § 2.1); left as it
  stands, and read as settled context for § 1.2.
- **2.2 — RN-7 says the card has no `Languages:` line; it now has one** — Confirm-or-override slot
  already filled (`self_answer-3.md` § 2.2); left as it stands, and its accepted shape for § 8 binds
  § 2.3.

## Companions opened

None this run.

## Launchers owed

- **`adr/` and `nfdr.md`** — `<CORE>/launchers/product-architecture/launcher.sh nozoki`
