# Self-answer report — SDD

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (v66, Settled; the companion carries six items the PM raised on 2026-11-05 at `ka-reader@2881283`, all seated `cto`)
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-05
- **Sources re-read:** `<CORE>/doctrine/engineering/arch_defaults.md` v2.1.0 § *The four layers* and § *Dependency Graph Rules* — the default "binds a product only once that SDD has chosen it"; its reason is that `domain` and `ports` reach no machine so every unit is testable with fakes; a product's graph lives in `docs/nfdr.md` § 1.2 both directions stated. `<CORE>/doctrine/engineering/testing_doctrine.md` § *A unit test hands its unit fakes and touches nothing real* ("reads and writes no file outside a temporary folder the test makes for itself") and § *A fake is verified against its port's contract* (one fake per port in a test-support module, one contract suite run against the adapter and the fake, both layer 2; the rule names no layer default). Everything else an answer rests on is in this repository at `ka-reader@2529a42`, read at that commit.

## Items worked

### 5.1 — Does the four-layer default with verified fakes change § 2's "no" to the hexagonal shape?

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** No, and § 2 now has to say so against the default by name, because the row's reason does not meet the default's. The row declined hexagonal on volatility — two stable edges, a core with no rule to guard. The default is not about volatility; it is about testability through fakes. Measured against that reason the no still holds, for three facts. The product's filesystem edge is its subject: `folder-model` reads the folder it models, its tests make their own folders (`crates/ka-reader-core/tests/watch.rs` — `TempDir`, `set_mode`, `remove_dir_all`), and the testing doctrine admits exactly that at layer 1. The read-only promise is proven on a real filesystem by `checks/read-only.sh`; a fake filesystem would prove it of nothing. And the two edges that are not the subject — Git, FSEvents — are already behind seams the model never imports an adapter through (SM-2 trait; SM-3 sink), while no clock is read in the core (grep for `SystemTime::now|Instant::now` under `crates/ka-reader-core/src` at `2529a42` returns nothing). The cost the item names is real and the default's benefit is already in hand, so the default would be ceremony here — the row's old word, now for the right reason. Check 2 found the item narrower than it asked: it treats the contract-suite rule as binding only through the layer choice, but `testing_doctrine.md`'s rule attaches to any port, and SM-2's Git port is one. At `2529a42` it has five test-local `impl GitPort for` doubles and no single fake in a test-support module, so the SM-2/R-1 clause in the answer is the part of the item that does change the SDD. Check 3: the answer moves no settled requirement — QC-8–QC-11 keep stating the graph by part, which `arch_defaults.md` § *Dependency Graph Rules* asks of every product; the layer-recording sentence at `:L111` binds only a product that chose the layers, so § 1.2 is owed nothing by this answer, and the Git-port fake reaches the NFDR as a downstream consequence of the SDD, not as an item raised here. Check 4: *absent* — a product with no Git repository still has the port (`probe` answers `plain`), so the fake covers that answer too; *concurrent* — nothing changes. I was close to "yes, for `fs-reader` alone": what tipped it is SM-7, which insists the containment check has one implementation, and a port there is a second place a path can be judged. Not the owner's: the architecture is the CTO's and the doctrine says the SDD chooses.

### 5.2 — § 3 `folder-model` still calls the removed-entry drop a known defect

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** A fact in the row is now false, and the item's account of the tree is accurate: I read `TreeRequest` at `2529a42` (`Expand`, `Collapse`, `Delta`, `Invalidate`, `folder_model.rs:L415-L427`) and the two watch cases that hold the removal and the return (`watch.rs:L736`, `:L817`), and `TreeRequest::Delta`'s only non-test caller is its own dispatch arm (`:L764`). Check 2 adds one thing the item did not say: the row's surviving sentence says the fresh read happens "in that same delta", and that word now names the request the drop does *not* go through, so the correction has to re-word that clause and not only strike the known-defect sentence. Check 4: *empty* — a folder removed with nothing under it drops nothing and the test's `None` is the same answer; *stale* — a removal reported for a folder the reader never expanded has no held listing, so the drop is a no-op and the parent's fresh read is what shows the entry gone. The owner has nothing to decide here: it is the document catching up with a landed change.

### 5.3 — SM-4 and SM-5 describe the crossing before tree acts and invalidation were built

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** Both seams state a measurement pinned at `8ef8c5b` that `2529a42` has moved past, and the item's reading of the tree holds on every point I checked: the export's signature (`exports.rs:L90`), the Swift call carrying the act code (`NativeBridge.swift:L38`), `select_file` still path-only (`exports.rs:L107`), and the fourth `TreeRequest` arm. Check 2 found the item complete as a correction; the one addition is what SM-4 should say the selection now does at the bridge — it joins the held model after the read (`session.rs:L1002-L1008`) — because 5.4 turns on that sentence and SM-4 is where a reader would look for it. Check 3: the answer keeps C-R7's set equality untouched — no eleventh export, the act rides an argument on a call the list already names, which is the first of the three forms the *Open Questions* item settled on (RN-113). Check 4: *refused* — an act code the bridge does not know is the bridge's to refuse at the boundary as a buffer that does not conform, which the shell reads as `stopped` (5.6); the answer does not change that path. Not the owner's — the seams are the CTO's columns.

### 5.4 — § 3 `surfaces` leaves the order of two asks in flight undecided, and the built order lets two selections cross

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** The item offers two things the row might state — the order as built, or the rule — and the rule is the right one, because the built order is wrong on the path the item names. I confirmed each half of the race at `2529a42`: the two runners (`ReadRunning.swift`), which runner each closure takes (`LaunchFlow.swift:L170-L181`), the selection applied under the lock *after* the read (`session.rs:L986-L1008`), and the surface keeping only the latest sink (`WorkbenchView.swift:L61`, `:L69`). Two reads on a concurrent queue can finish in either order, so the model can end on the earlier file — invisible today, since no projection draws the model's selection (nothing in `session.rs` or `BridgePayload.swift` projects it; only tests read `place().selected()`), and wrong the moment S-6 follows it. The row's author left the order to "the change that moves the selection into the model" (RN-76); that change has landed without deciding it, so the SDD decides now and the row says the built order is a known defect, in its own convention. Check 3: the rule is consistent with SM-4's serial tree acts and with CP-283 — I did not take the simpler fix of running `select_file` on the serial queue, because a long file read would then stall every listing behind it, which CP-283 forbids. Check 4: *concurrent* is the case itself; *stale* — a selection applied before a read that then fails leaves the model selecting a file whose verdict is `failed`, which is what the reader did and is correct; *absent* — a selection of a path a refresh has since removed is refused at admission by the model's existing rule, so the last act that resolves stands. Not the owner's: the ordering of two calls across a seam is design, binding no one outside the document.

### 5.5 — § 4 C-I1 and *Open Questions* still hold the failed re-read of an expanded folder as undecided

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** The *Open Questions* item said this would be "settled in `follow-the-tree`, by the reducer's design and a `--test watch` case", and that is what happened: I read both cases at `2529a42` (`watch.rs:L780-L811`, `:L841-L866`) and they hold every clause the item states — the failed folder's `Failed(Unreadable)`, `src/lib` dropped to `None`, siblings' states unchanged, and the return pass listing the new entry and re-reading the nested expanded folder. The item's form is the built form, so the answer is to write it in and close the question, as the question itself said. Check 3: NFR-3's "degrades only that item's view" was the bound the item set on whichever form was found; dropping the children is inside it, because the children are shown through the folder's listing and nowhere else (the `surfaces` row: a surface draws only from listings). The narrowing of the collapse-and-scroll item was decided together with 5.3 and both *whys* say so; the open-question count goes from seven to six. Check 4: *empty* — a failed folder with nothing held under it drops nothing; *concurrent* — a return pass arriving while the folder is failed is the recovery case the second test holds; *refused* — permission denied is the `Unreadable` condition the tests force. Not the owner's — C-I1 is the CTO's column.

### 5.6 — § 4 C-I1 says the model sets `stopped` on an item it holds; the model has no such state

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** The item asks which way to settle — give the model the state, or say only the shell sets it — and the second is right on the meaning of the word, not only on what is built. C-I1 defines `stopped` as the state of an item whose call's answer carried no verdict. The model is on the far side of that answer: if it could observe the failure it would have a condition to name, and that is `failed`. A model-held `stopped` would be a state with nothing that could ever set it. The tree agrees — `ItemState` has three arms (`fs_reader.rs:L129-L133`), the bridge logs `stopped` and holds nothing (`boundary.rs:L33-L43`), and the shell's decoders are the only place `.stopped` is produced (`BridgePayload.swift:L544`, `GitItem.swift:L14`). Check 3: C-I1's sibling sentence — "`observed`, `pending`, `failed` or `stopped`" — stays true at the surface, where the fourth state exists, so the answer says three in the model and four at a surface rather than striking the word; and the architecture companion's item 3.4 says QC-47 follows C-I1, so no new item is owed there. Check 4: *absent* — a NULL buffer is the `stopped` case itself; *stale* — a `stopped` item is replaced by the next call's answer like any other, with no change to C-I1's "without ceremony". Not the owner's — the state set is design.

## Left for the owner

None this run.

## Skipped

None this run. The companion's §§ 1–4 read "None", and all six § 5 items were open and seated `cto`.

## Companions opened

None this run. The architecture companion (`docs/architecture_open_issues.md`) already carries the NFDR consequence of 5.6 as its item 3.4, and 5.1's Git-port fake reaches the NFDR as a downstream consequence of the SDD fold, so nothing was appended there.

## Launchers owed

- **docs/SDD.md** — `<CORE>/launchers/skill/launcher.sh product-sdd ka-reader`
