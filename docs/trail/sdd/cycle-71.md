# SDD open issues — ka-reader

> Companion to `SDD.md`. The CTO wrote the SDD; this file holds what that run could not settle from
> its inputs (the PRD, the SRS, the UXD, and any context or constraints), and the calls that are the
> CPO's or the CDO's to make. An item whose call is the CPO's or the CDO's carries that seat's
> `Seat:`; an item whose call is the CTO's carries `cto` or no `Seat:` field.
>
> **Answer inline** — fill each **Answer** / **Confirm or override** / **Keep or re-cut** /
> **Your call** slot — **commit this file**, then re-run `product-sdd`. It folds your answers into
> the SDD and drops the resolved items. When nothing is left open, `product-sdd` **deletes this
> file**: no file = the SDD is done.
>
> Your answers are never thrown away. Each time `product-sdd` folds them in, it first copies this
> file whole to `docs/trail/sdd/` — so what you decided, and why, stays readable and citable for good.
>
> **An item may name the seat that answers it.** Any item in any section carries an optional
> `- **Seat:** <seat>` field beside its other fields. Its value is the name of the agent whose posture
> answers the item — `cto`, `cpo` or `cdo`. An item with no usable value, whether the field is absent,
> empty or still the `<seat>` placeholder, is answered in the seat of the skill that produced this file.
> The field names the *answering* seat. It is not the seat that raised the item (`Raised by:` /
> `Held by:`), and it is not the document an answer belongs to.
>
> **An item in §§ 1–3 names the seat that raised it.** An item the CPO raised is a product call and
> an item the CTO raised is a technical one, and the answer that settles one does not settle the
> other. **§ 4 names two seats and no raiser** — a
> disagreement is not something one seat asked, it is two positions held by different seats, and the
> answer that settles it picks between them.
>
> **§ 5 names a raiser from outside the SDD's lanes entirely.** §§ 1–4 are all the SDD's own three
> lane seats; § 5 is a seat that never held a lane in it, reading it long after it settled and
> finding something only the SDD can fix. Its `Raised by:` therefore takes a wider set than §§ 1–3's,
> which stay fixed to the three lane seats on purpose.
>
> **No `product-sdd` run wrote this file. A `companion-self-answer` run opened it on 2026-11-07**,
> in the Principal Architect's seat, while it answered `docs/architecture_open_issues.md` § 3.1.
> That item says ADR-0025 names the wrong call for a relative link: "the existing `select_file`
> call", where the shell makes one `open_relative_link` call. Reading the SDD for that answer, the
> run found the same phrase in the SDD's own § 9 TO-5, where SM-4 and SM-5 already say otherwise.
> The ADR is corrected in the decision log. The TO-5 sentence is the CTO's, so the change is raised
> here. `SDD.md` was Settled at v76 with no companion, and without this file a `product-sdd` re-run
> reads it as done. The SDD itself is not edited. The one item is in § 2, the bucket a raised item
> takes. The reasoning is `docs/trail/architecture/self_answer-78.md` § 3.1.

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — a best-effort answer was drafted; confirm or override

### 2.1 § 9 TO-5 says the shell turns a relative link into "the existing `select_file` call"; it makes one `open_relative_link` call, which SM-4 lists as its own
- **Raised by:** the `companion-self-answer` run, 2026-11-07, in the Principal Architect's seat — not one of the SDD's three seats
- **Seat:** cto
- **Drafted into the SDD:** Nothing. This run writes no document. The proposed reading is below for
  the CTO to draft or replace.
  TO-5 now says (`docs/SDD.md:L3344-L3346` at v76): "**The relative link opening its target is
  built** (FR-32's permission): a *relative* link node the shell turns into the existing
  `select_file` call, on a path the containment check already validates — one node kind and no new
  capability (RN-10)". Proposed: a *relative* link node — a contained file's path (§ 3
  `MarkdownDocument`) — which the shell sends as one `open_relative_link` call (SM-4); the bridge
  checks the path again and, for a contained file, admits the selection through the model's
  `select_file` operation and opens the file, as a tree selection does (SM-5) — one node kind, and
  no new capability: the call reads nothing a selection could not.
- **Rationale:** A fact in the SDD is false at the pin, and the SDD's own seam table already says
  so. At `ka-reader@c29193b`, whose tree outside `docs/` is `e95896f`'s
  (`git diff --stat e95896f c29193b -- . ':!docs'` prints nothing), the shell sends an activated
  link as `bridge.openRelativeLink(path:)` (`ka-reader-mac/Sources/Shell/LaunchFlow.swift:L206-L207`,
  `:L230`). The bridge's `link_to` asks `link_file` and then runs
  `select_file(FileRequest::Select(Some(linked)))` and the open's read
  (`crates/ka-reader-bridge/src/session.rs:L1249-L1270`). SM-4 lists `open_relative_link` as one of
  its ten calls, and SM-5's Down cell gives the link its own fixed order (`docs/SDD.md:L656-L657`).
  So TO-5 is the one sentence in the SDD that still names the call the design had before the export
  was built. It matters downstream: ADR-0025 took its link sentence from this wording, and the
  architecture companion's § 3.1 answer corrects that record against SM-4 and SM-5, not against
  TO-5. The proposed reading also carries § 3's moved definition — *relative* is a contained
  **file's** path (`docs/SDD.md:L738-L741`, decided 2026-11-07, RN-161) — so TO-5 does not keep the
  older "a path the containment check already validates" as the node's definition.
- **If overridden:** TO-5 keeps naming `select_file` as the call. The SDD then says two different
  things about how a relative link crosses SM-4, and the corrected ADR-0025 traces to SM-4 and SM-5
  while TO-5 contradicts them. A delivery stage reading TO-5 could look for a `select_file` call that
  the shell never makes for a link.
- **Confirm or override:** confirm, with one addition. The sentence is re-stated as the item proposes: a *relative* link node — a contained file's path (§ 3 `MarkdownDocument`; RN-161) — which the shell sends as one `open_relative_link` call (SM-4; `ka-reader-mac/Sources/Shell/LaunchFlow.swift:L206-L207`, `:L230`); the bridge runs the containment check again and, for a contained file, admits the selection through the model's `select_file` operation and opens the file as a tree selection does — `link_file`, then `select_file(FileRequest::Select(Some(linked)))` under one lock hold, then the open's read-and-fold (`crates/ka-reader-bridge/src/session.rs:L1249-L1270`; SM-5's fourth fixed order, RN-150) — one node kind, and no new capability: the call reads nothing a selection could not. **The addition — TO-5 is a trade-off entry, so it says what the link cost, in this section's own words.** The old sentence's whole cost accounting was "the existing `select_file` call": FR-32 permits the link "if it costs nothing", and RN-10 found that it did on that ground. The built form keeps the judgment on a different ground, and TO-5 states it. The link *costs* one export on SM-4's list — `ka_reader_open_relative_link` (`crates/ka-reader-bridge/src/exports.rs:L219`), with its bridge suite (`crates/ka-reader-bridge/tests/open_relative_link.rs`) and the walk's coverage of it (§ 4 C-I3) — and an ordered read: the call goes on the serial tree-act runner, so a tree act raised after a link waits behind one read of one contained file, and behind nothing but the lock hold when the check refuses (§ 3's `surfaces` row, RN-158). It *buys* a selection admitted only for a path the check reaches at activation, which is why it is one call and not a click's two. And "costs nothing" stays true of what FR-32 measures: no new node kind, no new seam, no new capability, and nothing new in the model — `link_file`, `select_file` and the fold are the operations a click already drives. RN-10 stays cited as the origin of the judgment, and the old words keep their dated note beside the sentence, as this document keeps them. Pinned at `ka-reader@e95896f`, whose tree `c29193b` carries outside `docs/`. Reasoning: `docs/trail/sdd/self_answer-85.md` § 2.1.

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

None.

---

## 4. Disagreements — two seats hold different positions and neither yields

None.

## 5. Raised from downstream — an item from a seat that did not write the SDD

None.
