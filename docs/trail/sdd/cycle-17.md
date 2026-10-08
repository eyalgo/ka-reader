# SDD open issues — KA-Reader

> Companion to `SDD.md`. Three seats — the CTO, the CPO and the CDO — authored the SDD
> non-interactively in one run; this file holds what that run could not settle from its inputs (the
> PRD, the SRS, the UXD, and any context or constraints).
>
> **Answer inline** — fill each **Answer** / **Confirm or override** / **Keep or re-cut** /
> **Your call** slot — **commit this file**, then re-run `product-sdd`. It folds your answers into
> the SDD and drops the resolved items. When nothing is left open, `product-sdd` **deletes this
> file**: no file = the SDD is done.
>
> Your answers are never thrown away. Each time the seats fold them in, they first copy this file
> whole to `docs/trail/sdd/` — so what you decided, and why, stays readable and citable for good.
>
> **§ 5 names a raiser from outside the run entirely** — a seat that never wrote the SDD, reading it
> long after it settled and finding something only the SDD can fix.

> **No `product-sdd` run wrote this file.** The PM opened it on 2026-10-01 from the SDD's own
> companion template, while re-reading the route after `select_file` was first built, because `SDD.md`
> is Settled and with no companion on disk a `product-sdd` re-run reads it as done and has nothing to
> act on. Both items are in § 5; §§ 1–4 hold nothing.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — a seat drafted a best-effort answer; confirm or override

### 2.1 C-I3 cites lines that have moved, and names a five-frame list where the gate reads four

> **No producing run wrote this item.** The `companion-self-answer` run answering this file raised
> it on 2026-10-01, under `<CORE>/prompts/decide_companion_answers.md` § *The items are not the
> whole of what a document is owed*. That section covers this case as *the document you are
> answering*. It came from reading `SDD.md` whole to answer §§ 5.1 and 5.2, and it has nothing to
> do with either. The note at the head of this file, "Both items are in § 5; §§ 1–4 hold nothing",
> was written before this item was added. This item's slot is left at its placeholder: the
> reasoning is that run's, and the decision belongs to the next round. Reasoning:
> `docs/trail/sdd/self_answer-28.md`, § *Raised on this document*.

- **Raised by:** `companion-self-answer`, answering this file — 2026-10-01
- **Drafted into the SDD:** Nothing has been written into the SDD. As it stands, § 4 C-I3 carries
  four line citations and one count that do not match the tree on `main` (`ka-reader@fcb7910`), and
  § 6 S-1's command half carries one more citation of the same kind:
  - `ka-reader-mac/Sources/Shell/LaunchFlow.swift:L35-L37` (`docs/SDD.md:L706`), cited for "the shell
    calls it only after the panel returns". Those three lines hold the status glyphs' declaration.
    The panel call is at `:L53-L57` and the `openFolder` call at `:L69`.
  - `checks/renderer.sh:L44-L57` (`docs/SDD.md:L708`), `:L53-L61` (`:L715`) and `:L58-L61`
    (`:L725`) in C-I3, and `:L53-L57` (`:L1369`) in S-1. In the script the frame list is
    `:L53-L56` and the Mac reading is `:L57-L60`.
  - "the runner matched the script's five-frame list on observation 1" (`docs/SDD.md:L727-L729`).
    The list the gate reads holds four frames since `ka-reader@b75348f` (2026-09-27), which removed
    `LaunchFlow.run()` from the header and from `FRAME_LIST`.

  The draft change: re-point each of the five citations at the lines that hold what its sentence
  says, or pin it to the commit it was read at, the form RN-68 and RN-69 used. For the runner's
  reading, say that the list held five frames when run 35988399477 matched it and holds four
  since `ka-reader@b75348f`.
- **Rationale:** Each is a measurement. `sed -n 35,37p ka-reader-mac/Sources/Shell/LaunchFlow.swift`
  prints `private lazy var statusGlyphs = StatusGlyphs(` and its two arguments. `sed -n 53,56p
  checks/renderer.sh` prints four frames, and `:L59` reads "then the four frames above". `git show
  b75348f -- checks/renderer.sh` shows the line `LaunchFlow.run()` removed twice. The SDD's last
  revision is `ka-reader@3f13391` (2026-09-30), three days after that commit, so the count was
  already false at v21. C-I3 is a live condition every slice inherits, and the writing bar asks
  that a locator open on the sentence it is cited for (`system/doctrine/writing_bar.md` § 1.2 in
  the instance). The SDD's review notes are left out on purpose: a note is dated history
  (RN-55), and its citations date the reading they record. The doubt, stated: line citations
  drift with every change to the cited file, and this document has folded stale ones before as
  found-while-walking repairs with no item (RN-69). It is raised because the count is a fact a
  reader checks against the script, and the gate's frame list is the thing C-I3 exists to
  describe.
- **If overridden:** Nothing outside those six places moves. Left as they are, a reader who opens
  `LaunchFlow.swift:L35-L37` finds a declaration that says nothing about the panel, and a reader
  who counts the script's frames finds four where C-I3 says five.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

None.

---

## 4. Disagreements — two seats hold different positions and neither yields

None.

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 C-R7 and C-I3 do not say what holds while a slice is built across several changes
- **Raised by:** PM — 2026-10-01
- **Tracked by:** `ka-reader · nemawashi · 2026-10-01_a-file-reads-in-the-panel`
- **What it blocks:** nothing is blocked; two sentences read false on product `main` today and stay
  false until `read-a-file` is whole, so a reader checking the build against them finds a violation
  the design did not intend.
- **Where it shows:** § 4 C-R7 says "a function whose slice has not landed is never exported", and
  SM-4 says each function is "exported from the build in which a slice lands it and not before".
  `ka_reader_select_file` is exported now (`crates/ka-reader-bridge/tests/exports.rs` admits it; `cargo test
  --locked -p ka-reader-bridge --test exports` passes, 10 tests), while § 6 S-2's highlighter and
  read-only bars are not yet met. § 4 C-I3 says `checks/read-only.sh` "exercises every command the build
  grants"; the walk it drives calls `list_tree` alone (`crates/ka-reader-core/tests/walk.rs:L1-L6`), so
  `select_file` is granted and not exercised. The SDD should state which reading binds: that a slice's
  function is exported from the first change that builds it, with C-I3 naming what covers the read until
  the walk drives `select_file` (`cargo test --locked -p ka-reader-bridge --test select_file` holds
  `checks/fixtures/text/` byte-identical today); or that the export waits for the slice whole.
- **If a document has to be written:** none — a sentence in C-R7, SM-4 and C-I3.
- **Answer:** The first reading binds for the export, and C-I3 gains no interim cover. The item
  holds two questions with one seat, and both are answered here. **The export (C-R7, SM-4).** A
  function is exported from the first build in which a change of its slice has built it: the
  bridge function exists and delegates to an operation `folder-model`'s API carries. No function
  is exported before a change has built it. The second reading, that the export waits for the
  slice whole, cannot stand beside § 8: a slice yields one or more seeds and each share is "worth
  something on its own" (`docs/SDD.md` § 8, the *Delivers* row), and no share of `read-a-file`
  shows a file in the panel without the shell calling `select_file` across SM-4. Three sentences
  move and the mechanism does not. C-R7's "exactly the functions its landed slices built" reads
  *the functions its landed changes built*. C-R7's "a function whose slice has not landed is never
  exported" reads *a function no landed change has built is never exported*. SM-4's "exported from
  the build in which a slice lands it and not before" reads *from the build in which a change of
  its slice first builds it, and not before*. Set equality, the closed list, `ka_reader_free` beside
  it, "all nine from `v1.0.0`" and the uncovered case C-R7 names before `v1.0.0` stand as written.
  **The harness (C-I3).** C-I3 stands as its headline and its `read-only.sh` sentence read: every
  build, and every command that build grants. It names no test that covers a command in place of
  `read-only.sh`. A build that exports a command has that command's operation on SM-5, so the walk
  can call it in that same build, and no build is forced into an interval. C-I3's *Violated by*
  reads *a build that exports a command the harness does not exercise* where it reads "a slice
  that lands a command the harness does not exercise", so the clause names the unit its own
  headline names. Product `main` at `ka-reader@fcb7910` is that case:
  `crates/ka-reader-bridge/tests/exports.rs:L20` admits `ka_reader_select_file`, and
  `crates/ka-reader-core/tests/walk.rs:L1-L6` calls `list_tree` alone. On those builds C-I3 is unmet,
  the walk driving `select_file` closes it, and the SDD carries no sentence about the interval.
  Two cases this answer does not cover, named so the fold does not read them as covered. A fixture
  that offers no entry for a command exercises nothing for it, and which fixture a command needs
  is its slice's own bar. Nothing in the build compares the walk's calls with the export set, so
  the condition is held by review until a change makes it a check. Downstream: `docs/nfdr.md`
  QC-24's "No listed function is exported before a slice lands it" follows C-R7 through
  `docs/architecture_open_issues.md` § 3.1, which is already raised; QC-2's *verified by* agrees
  with C-I3 as it stands and takes no interim clause. Reasoning:
  `docs/trail/sdd/self_answer-28.md` § 5.1.

### 5.2 § 3 gives `folder-model` the open file, and the built product holds it in `surfaces`
- **Raised by:** PM — 2026-10-01
- **Tracked by:** `ka-reader · nemawashi · 2026-10-01_a-file-reads-in-the-panel`
- **What it blocks:** `follow-the-folder`, whose bar refreshes the open file and states its file-gone
  state, reads the open file where § 3 puts it — in the model the core keeps — and the core holds none.
- **Where it shows:** § 3 gives `folder-model` "the selection and expansion, the open file" and the
  open `FileView` (`docs/SDD.md:L325`, `:L435`, `:L443`). In the product, `select_file` in
  `crates/ka-reader-core/src/folder_model.rs` reads and returns a verdict and keeps nothing; the selection
  and the shown file live in `ka-reader-mac/Sources/Surfaces/WorkbenchView.swift:L75-L93`. The SDD should
  say whether the open file moves into `folder-model` with `follow-the-folder`, or whether § 3 should
  place it in `surfaces`.
- **If a document has to be written:** none — § 3's `folder-model` and `surfaces` rows, and
  `follow-the-folder`'s *Rests on*.
- **Answer:** § 3 stands. The open file is `folder-model`'s, and the model holds it no later than
  `follow-the-folder`. § 3 does not place it in `surfaces`. `follow-the-folder`'s own command half
  is the reason: `cargo test --locked -p ka-reader-core --test watch` asserts, in-process and with no
  window, "the model's final snapshot equal to a fresh open of the fixture, and expansion,
  selection and reading position surviving" (`docs/SDD.md` § 6 S-5 *Reached when*). A model that
  holds no open file cannot say that the open file changed or is gone (`docs/SRS.md` FR-27,
  FR-28). Placing it in `surfaces` moves the keeping of the reader's place into the one unit no
  harness drives (§ 4 C-I3; § 9 TO-7), and it unmakes SM-3's "The model decides what to re-read",
  SM-8, and the `surfaces` row's "draws no state the bridge did not send". That is a re-cut of § 3
  and of S-5's bar, and nothing the item cites calls for one. The same answer covers the selection
  and the expansion: § 3 gives them to the model in the same phrase, S-5's test names them beside
  the reading position, and the product keeps both in the shell today
  (`ka-reader-mac/Sources/Surfaces/RootItemsView.swift:L18-L19`, `:L54-L61`;
  `crates/ka-reader-core/src/folder_model.rs:L69-L71`). What the SDD owes is one clause, in
  `follow-the-folder`'s *Rests on*: its `folder-model` entry names the held state beside the
  reducer — the tree's expansion, the selection, and the open `FileView` with its reading position
  — so a seed cut from that slice carries the move. § 3's rows, `read-a-file`'s *Rests on* and
  every other field stand. `read-a-file`'s bar is met by `select_file` answering the file's
  content through SM-5, and no *Reached when* before `follow-the-folder`'s asserts that the model
  holds the open file. A change may bring the held state into the model earlier, with the first
  items the model holds. One case this answer does not cover, and it is the moving change's own
  design: which side orders two reads in flight once the model holds the selection. The shell's
  count does it today (`ka-reader-mac/Sources/Surfaces/WorkbenchView.swift:L78-L93`). Reasoning:
  `docs/trail/sdd/self_answer-28.md` § 5.2.
