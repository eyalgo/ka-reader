# Self-answer report — `docs/adr/` and `docs/nfdr.md`

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md` (NFDR v82, Draft; ADR-0001 – ADR-0025)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-07
- **Sources re-read:** None. No answer rests on a source outside this repository. Every code claim was measured in the tree at `ka-reader@a499e4d`. `git diff --stat 98aaa71 a499e4d -- crates checks` prints nothing, so the item's pin and `main` agree.
- **Liveness check:** the header's pointer reads *Companion to `adr/` and `nfdr.md`*, two bare names. Both sit beside the companion in `docs/`, so it is live.
- **What was read:** the whole companion. From NFDR v82: the header and version lines, QC-10 whole (`:L432-L511`), QC-68's tail and QC-69 whole (`:L1790-L1846`), § 10's QC-68 row and its closing list of review gates (`:L3120-L3127`), and RN-92 whole (`:L8239-L8292`). From SDD v74 (Settled): the header; § 2 *The four-layer default, declined by name* (`:L340-L402`) and *One read seam beside the decline* (`:L404-L449`); the SM-1 row (`:L622`); and RN-154. Also the ADR index's file names, to check that no record states the decline. In the code: every line `git grep -n '0o000' -- crates` prints (37 lines in 13 files), with the surrounding test read at `log_writer.rs:L415-L430`, `tree_links.rs:L87-L107`, `git_state.rs:L1523-L1535`, `root_finding.rs:L173-L187`, `unit/libgit2.rs:L520-L537` and `failure_log.rs:L53-L65`; where `open_folder`, `list_tree` and `asset_bytes` are defined (`folder_model.rs:L78`, `:L101`, `:L278`); and `folder_model.rs:L230-L235`. The NFDR (8,292 lines) and the SDD (10,903 lines) were not read whole. They were read wherever the item lands and wherever its draft cites. As input only, and cited in no record: the open station `2026-11-06_a-markdown-file-reads-rendered`.
- **Scope:** one open item, § 2.1, with a **Confirm-or-override** slot. No item list was given. The item is the Principal Architect's: the edit lands in `docs/nfdr.md`, and it binds only how faithfully QC-10 and QC-69 carry the settled SDD and how each can be verified.

## Items worked

### 2.1 — QC-10's setting-aside narrows to building `FolderContainment`, the model's reads are held to SM-1's read seam, and QC-69 binds that seam's one fake and one contract suite as owed

- **Bucket:** 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override
- **Verdict:** overridden
- **Why:** QC-10 is taken as drafted, and so is QC-69 except for one of its three verifiers. That verifier is replaced, because building the seam cannot make it hold.

  **What is taken, and why it holds.** Every clause of the QC-10 draft matches SDD v74 § 2 *One read seam beside the decline* and SM-1's cell. The SDD says the reads cross a trait in `fs-reader`, and so does the draft. The SDD names the bridge's session and C-I3's harness as where the real reader comes from, and so does the draft. The SDD keeps the containment walk outside the seam, and the draft keeps the setting-aside for building `FolderContainment` alone. QC-10's own bound (3) said the setting-aside is re-opened if its § 2 paragraph moves. It moved at v74 (`docs/SDD.md:L404-L449`), and the SDD names this re-opening as this seat's (`:L439-L444`), so the item's premise is right. QC-69 follows the pattern of QC-68 and QC-50: it is written as owed, and the review gate holds the interim. The gate's downgrade is argued correctly, because the trait's name is the building change's, so no scan pattern can be written yet. RN-92 weighed an ADR and declined one. That holds: reversing the seam touches two units and two composition roots, and nothing on the tool's public surface, so it fails the hard-to-reverse gate, as the containment port did at v81. No accepted record states the decline, so nothing is superseded. SDD RN-154's "surfaced in § 2 for the Principal Architect to record" is met by QC-10 and QC-69.

  **What is replaced, and why.** Check 4 found the defect, on the case the happy path does not reach: the sites that are not the model's. QC-69's third verifier is "`git grep -n '0o000' -- crates` printing nothing". The draft took it from SDD § 2 (`:L444-L446`), which says building the seam empties that grep. Measured at `a499e4d`, 14 of the 37 lines, in 5 files, sit where SM-1's seam cannot reach:
  - **12 lines in 3 files are the Git adapter's**: `tests/git_state.rs` (7), `tests/root_finding.rs` (4) and `tests/unit/libgit2.rs` (1). They lock a path libgit2 reads, such as `S/.git/config` at `git_state.rs:L1526` or `repo/.git` at `root_finding.rs:L177`, and call the real Git port. QC-11 forbids `git-reader` to import `fs-reader`, so no SM-1 reader can be handed to it.
  - **1 line is the containment walk's.** `tests/tree_links.rs:L95` locks a link's target outside the folder, to prove the walk answers `Outside` without reading it. QC-10 and QC-69 both keep the walk outside the seam.
  - **1 line is a write.** `crates/ka-reader-bridge/src/log_writer.rs:L419` seals the log's directory to prove a failed write is silent.

  The other 23 lines, in 8 files, are cases the seam reaches. They are the model's own tests (`folder_model.rs` 2), the model's entry points called from tests (`list_tree.rs` 4, `failure_log.rs` 4, `watch.rs` 6 and `markdown.rs` 1; `open_folder`, `list_tree` and `asset_bytes` are `folder_model.rs:L78`, `:L101`, `:L278`), the bridge's two tests that drive the model through its session (`open_file.rs` 1, `open_diagnostics.rs` 1), and the real reader's own failure path (`tests/unit/fs_reader.rs` 4). SDD § 2 already says that last one is proven "by a condition every runner sees … never by a file mode". As drafted, the verifier would fail the change that builds the seam. Or it would push that change into rewriting the Git adapter's tests, the walk's test and the log writer's test just to clear a grep. A constraint whose check its own building change cannot meet has no enforcement surface.

  **What replaces it.** The third verifier reads: no case whose failed read crosses SM-1 forces it with a file mode, checked by a `git grep` over the files the building change names. At `98aaa71` those are the 8 files above. The other two verifiers, the contract suite and the `impl … for` grep, stand as drafted.

  **Why the SDD is not quietly contradicted.** This narrows a verifier, which is this seat's to choose. The sentence it narrows away from is the CTO's, so the change is raised at `docs/SDD_open_issues.md` § 2.1, and QC-69's trace should name that item. Then the NFDR states its difference from the SDD instead of drifting from it. Until the SDD folds, the two documents disagree on that one clause, and the trace is what says so. That SDD item also carries SM-1's call count, which reads fifteen where its locators hold sixteen. RN-92 saw that and left it unraised.

  **Close call.** I nearly answered *confirmed with addition*, reading the narrowing as a bound the draft did not state. What tipped it to *overridden* is that the draft states the opposite: its verifier names the whole tree. If the CTO's round answers the SDD item by having all 37 sites rewritten, the whole-tree verifier comes back, and QC-69's next revision follows that answer.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

- **`docs/SDD_open_issues.md`** — **opened** — companion to `docs/SDD.md`, landed in commit `f5c1408`

## Launchers owed

- **docs/adr/ and docs/nfdr.md** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
- **docs/SDD.md** — `<CORE>/launchers/companion-self-answer/launcher.sh ka-reader SDD`
