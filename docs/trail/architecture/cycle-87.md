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

### 2.1 Does your host-tools ruling also cover the shell and text tools a check script is written in?
> Raised by the v95 fold, as the residue of cycle-86 § 3.1. Your ruling lets the suites run the
> host's real `git`, `tar` and `cargo` within three bounds, and its third bound says "every other
> process the script starts stays a stand-in". Read as worded, that includes `bash`, `sed`, `awk`,
> `grep` and the rest, and every suite runs those from the host today.
- **Lands in:** `nfdr.md` QC-72 (and QC-67's "a host tool QC-72 admits")
- **Drafted into the records:** QC-72 at v95 (RN-105) holds bound (3) as you worded it: every
  process other than the host's `git`, `tar` and `cargo` is a stand-in, the host's shell and its
  ordinary text and file tools included. So every suite at `ka-reader@528c152` is recorded as a
  known gap under bound (3): the built suites link those tools in by name
  (`checks/tests/support/vm_refusal.sh:L64` lists 37, `checks/tests/test_git_beta_walk.sh:L53`
  lists 26), and the others take them from the host's `PATH`.
- **Rationale:** your answer adopted the three-part bound in `self_answer-87.md`. The later drafts
  (`self_answer-88.md`, `self_answer-89.md`) added a fourth part for "the script's own language",
  and your answer does not include it. This seat may record a departure from core doctrine that you
  authorized, but it may not make that departure wider, so it kept your words. Read literally,
  bound (3) means faking the tools a shell script is made of, and the drafts argued that would
  test the fakes rather than the script. So the draft is probably not what you meant, but only
  you can widen it.
- **If overridden:** QC-72 gains a fourth bound, and the gaps under bound (3) drop to the prepended
  and host-whole suites QC-67 already names. Under that bound a suite may link the host's shell and
  its ordinary text and file tools into the `PATH` it builds, by name, and every tool that reaches
  outside the suite's temporary folder, or whose answer the script refuses on (`open`, `tart`,
  `uname`, `sysctl`, `ps`, `kill`, `screencapture`), stays a stand-in. No ADR moves. QC-67 is
  unchanged: it already requires each tool to be linked in by name.
- **Confirm or override:** override (owner, 2026-11-12): withdraw the host-tools departure — the
  owner cancels the cycle-86 § 3.1 ruling. The check suites follow `testing_doctrine.md` §
  *A test reads nothing of the machine it runs on* as written: the host's `git`, `tar` and `cargo`
  are stand-ins, each replaying a recording taken once from the real tool and committed beside the
  test as data (that section's *What to do instead*). The host's shell and its ordinary text and
  file tools count as the suite's own interpreter, which the doctrine already lets a test start;
  record that reading, not a new bound. The four suites that run a real tool today
  (`test_git_beta_scene.sh`, `test_git_beta_walk.sh`, `test_entry_points.sh`, `test_no_network.sh`)
  are known gaps until a change moves them, and that change comes after the first public release,
  not before it. QC-72 is withdrawn, not widened. What the real tools make of a state stays proven
  where a real tool runs already: the owner's walk on the Mac and the release build.

## 3. Raised from downstream — an item from a seat that did not write these records

None.
