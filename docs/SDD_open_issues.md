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

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — a best-effort answer was drafted; confirm or override

None.

## 3. Cut calls to confirm — where the slicing could reasonably have gone another way

None.

---

## 4. Disagreements — two seats hold different positions and neither yields

None.

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 Does the four-layer default with verified fakes change § 2's "no" to the hexagonal shape?
- **Raised by:** PM — 2026-11-05
- **Seat:** cto
- **Tracked by:** none yet — `seeds-from-product-docs` cuts one from the fold
- **What it blocks:** holding ka-reader's code to the four-layer default and to one verified fake per port. That default binds a product "only once that SDD has chosen it" (`core/doctrine/engineering/arch_defaults.md:85-87`). This SDD has not weighed it by name, so today neither the dependency rule nor the contract suites bind ka-reader. What already binds it with no SDD choice is narrower: code-integrity refuses code that builds its own collaborators, and unit tests that touch a real resource (`skills/senior-engineer/.claude/skills/development-code-integrity/SKILL.md:192`).
- **Where it shows:** § 2's shape table weighs "**Hexagonal** — a domain core behind ports, an adapter at every edge" and declines it: "insulating a stable edge is ceremony; its one useful port, the Git reader (force 2), is kept inside the taken shape (§ 3 SM-2)" (`docs/SDD.md:306`). The paragraph after the table holds that call: "The hexagonal shape still answers with more seams than the product has volatile edges" (`docs/SDD.md:319`). That was decided before `arch_defaults.md` § *The four layers* (`:83-115`) and `testing_doctrine.md` § *A fake is verified against its port's contract* (`:80`) stood. The question is whether the new default changes the call. The default is four layers (`domain`, `ports`, `adapters`, `entrypoints`) under the dependency rule, with one fake per port in a test-support module and one contract suite per port, run against both the real adapter and the fake at layer 2. The Rust and Swift testing guides (`core/doctrine/engineering/languages/rust/testing.md`, `languages/swift/testing.md`) state each language's form.
- **If the answer is yes, the cost:** ports where the edges are: the filesystem read, the Git reader (SM-2 already draws it), the watcher now in `ka-reader-bridge` (§ 3, RC-7), and the clock if any part reads one. `domain` and `ports` would share one unit, because Rust crates and Swift targets may not depend on each other in a cycle (`arch_defaults.md:103-105`): presumably `ka-reader-core` for the Rust half, and one target for `ka-reader-mac`. Each port would also need a contract suite run against both its adapter and its fake.
- **If the answer stays no:** say so in § 2 against the new default by name, so that "hexagonal" in the table is read as the doctrine's four layers and the declining reason meets that default rather than an earlier one.
- **And either way:** what `docs/nfdr.md` § 1.2 *Forbidden imports* gains. A product records its layers and their forbidden imports there (`arch_defaults.md:111`). § 1.2 states today's graph (QC-8 onward), not layers.
- **If a document has to be written:** none beyond `SDD.md`, through `product-sdd`. The NFDR's § 1.2 then follows through `product-nfdr` if the answer moves it.
- **Answer:** <the CTO fills this in>

**How it closes.** `product-sdd` folds it on its next run like every other item in this file.
