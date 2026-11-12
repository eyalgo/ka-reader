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

---

## 1. Open issues — questions with no answer yet

None.

## 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override

### 2.1 Eleven more suites run the host's `git`, `tar` or `cargo`. Do they wait until after the first public release too, like the four you named?
> Raised by the v96 fold, as the residue of cycle-87 § 2.1. Your answer withdrew the host-tools
> departure, and it named four suites that run a real tool today, saying the change that moves them
> comes after the first public release. A scan at `ka-reader@528c152` finds eleven more. Under the
> rule you set, the testing doctrine as written, they are known gaps. What your answer does not
> settle is whether they wait until after the release too, because it did not weigh them.
- **Lands in:** `nfdr.md` QC-67 (its host-tools paragraph)
- **Drafted into the records:** QC-67 at v96 (RN-106) lists the eleven as known gaps under the same
  rule and says it is open whether your release ruling reaches them. The draft answer is yes, the
  same terms as the four: each is a known gap until a change moves it, that change comes after the
  first public release, and none of them holds that release. Nine run a tool in their own body, to
  build a fixture or to read the product's own tree: `test_notices.sh`, `test_own_state.sh`,
  `test_read_only.sh`, `test_release_version.sh`, `test_renderer.sh`, `test_secret_scan.sh`,
  `test_secret_scan_planted.sh`, `test_strings.sh` and `test_structure.sh`. Two look up the real tool
  for the script they run: `test_offline_page.sh` (`cargo`) and `test_readme.sh` (`git`). QC-67 gives
  each one's line.
- **Rationale:** these are the same kind of gap as the four. A suite depends on a tool the next
  machine may lack, and no shipped code is involved. Your answer's reason for waiting, that what the
  real tools make of a state is already proven by your walk on the Mac and by the release build,
  holds for these just as much. Most of them read the product's own tree with `git status` to show
  the suite left it as it found it, or build a throwaway repository with `git init`. But this seat may
  not take a release allowance you gave four suites and give it to eleven you never weighed. Doing that
  would widen your call, so it comes back to you.
- **If overridden:** QC-67 says which of the eleven must move before the first public release. Each
  one named that way becomes a release precondition, and the change that replaces its real tool with
  a recorded stand-in, or with a fixture committed as data, comes before the release. No ADR moves,
  and QC-67's scan and review gate are unchanged.
- **Confirm or override:** <"confirm", or "override: <what to do instead>">

## 3. Raised from downstream — an item from a seat that did not write these records

None.
