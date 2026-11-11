# Self-answer report — `adr/` and `nfdr.md` (KA-Reader architecture records)

## Header

- **Companion:** `docs/architecture_open_issues.md`
- **Document:** `docs/adr/` and `docs/nfdr.md`. The one open item bears on the NFDR (v95, Draft), QC-72 and QC-67's "a host tool QC-72 admits"; no ADR moves.
- **Decided by:** `<CORE>/../skills/companion/.claude/skills/companion-self-answer/prompts/rich.md` v1.3.1
- **Date:** 2026-11-11
- **Sources re-read:** None. No answer rests on a source outside this repository. The one rule the answer turns on, `testing_doctrine.md` v2.9.0 § *A test reads nothing of the machine it runs on*, was read at the managing core, not taken from QC-72's quotation of it. It reads as QC-72 quotes it.

Read for this run: the companion, whole; NFDR v95's QC-67, QC-72 and RN-105; the owner's ruling at
`docs/trail/architecture/cycle-86.md` § 3.1; `self_answer-87.md` § *Left for the owner*, the
three-part bound the ruling adopts; `self_answer-88.md` and `self_answer-89.md`, the four-part
drafts; `self_answer-90.md`, which named the two readings. Measured at `ka-reader@a87ae36`, whose
tree outside `docs/` is `528c152`'s (`git diff --stat 528c152 HEAD -- . ':!docs'` prints nothing),
with each product file read by `git show 528c152:<path>`: the first line of all 26 scripts in
`checks/*.sh`; `checks/tests/support/vm_refusal.sh:L62-L66`; `checks/tests/test_git_beta_walk.sh:L50-L53`;
and a scan of `checks/*.sh` for a shell the script itself starts.

## Items worked

None this run.

## Left for the owner

### 2.1 — Does your host-tools ruling also cover the shell and text tools a check script is written in?

- **Bucket:** 2. Choices to confirm — the Principal Architect drafted a best-effort answer; confirm or override
- **Verdict:** left for the owner
- **Why:** The question is what your own ruling meant, and either answer moves the reach of your
  departure from core doctrine. Confirming fixes that departure as covering only `git`, `tar` and
  `cargo`. Overriding widens it to the tools a script is written in. Doctrine is yours and a seat
  may not relax it (`<CORE>/roles/CROSS_ROLE.md` § 3). The draft says the same about its own seat,
  and the reason holds for this run too.

  The ground I cannot see is which draft you chose, and why. When you ruled
  (`ka-reader@58bbaea`, 20:58), the four-part bound had been on disk for six hours
  (`self_answer-89.md`, `ka-reader@4b62c29`, 14:48). Its first part admits the script's own
  language. Your answer names `self_answer-87.md`'s three parts. That fits two stories. You may
  have weighed part 1 and left it out. Or you may have followed the item's own pointer, which named
  only `self_answer-87.md`. The words do not say which, and nothing else on disk does either.

  **The draft holds, as a record.** QC-72 keeps your words and names what they cost: every suite is
  a known gap under bound (3). That is the right thing for the record to do while the question is
  open. It is not an answer to the question.

  **One premise, measured this run, that narrows what you are ruling on.** It is not a second
  question. All 26 scripts in `checks/*.sh` start with `#!/usr/bin/env bash`. So the suite that
  launches a script starts its shell, and the script does not. Bound (3) speaks of "every other
  process the check script starts", and the doctrine of "every process the code starts". Neither
  reaches the shell a script runs under. That is why both built lists link `bash` and `env`
  (`support/vm_refusal.sh:L64`, `test_git_beta_walk.sh:L53`). Without them the script would not run
  at all. So QC-72's "the host's shell … included" says more than your words carry. But it is not
  false. `checks/entry-points.sh:L304` (`xargs -0 bash -c`) and `checks/gate.sh:L54` (`bash -c`)
  each start a shell of their own, and those are inside bound (3) as worded. The `sh -c` calls in
  the two walks are arguments to `tart`, which is already a stand-in. What your ruling turns on is
  the text and file tools: `sed`, `awk`, `grep`, `find`, `cp`, `rm`, `stat` and the rest. That is
  everything on the two lists except `bash` and `env`: 35 of the 37 on the first list and 24 of the
  26 on the second.
- **The answer I would have given:** override. QC-72 gains a fourth bound, in these words: "A
  suite may link the host's shell and its ordinary text and file tools into the `PATH` it builds
  for the check script, each by name. These are the tools the script is written in. Every tool that
  reaches outside the suite's temporary folder, or whose answer the script refuses on, stays a
  stand-in: `open`, `tart`, `uname`, `sysctl`, `ps`, `kill`, `screencapture`." Four reasons.
  1. **Under the literal reading, these gaps can never close.** No change can fake `sed` and `awk`
     for a script whose whole job is reading text and still prove the script. The case would prove
     the fakes. The same reason made you admit the real `git`. A known gap that no change can close
     binds nothing, and it hides the gaps that can be closed: right now every suite is a known gap
     for this reason alone.
  2. **The doctrine's concern is met, by another means.** The doctrine's ground is that a host tool
     "can be missing on the next machine, or behave differently there". QC-67's built `PATH` already
     handles *missing*. Every tool is linked by name, so a missing tool fails the suite loudly at
     setup. It is never silently replaced. *Behave differently* is real for text tools: the macOS
     and GNU versions differ. But the gate runs these scripts on that one macOS guest, with those
     same tools. A real `sed` in the suite is the `sed` the script meets in the gate. A stand-in
     would hide that difference, not remove it.
  3. **The fourth bound is narrow, and a reviewer can see it.** It admits tools only on the built
     `PATH`, by name, so the admitted set is a list someone can read. It admits nothing that
     reaches outside the temporary folder, and nothing the script refuses on. The fourteen
     prepended suites and six host-whole suites stay QC-67 gaps as they are now.
  4. **Little moves.** No ADR moves. QC-67 is unchanged. QC-72's bound (3) gap shrinks to the
     prepended and host-whole suites, plus the two `bash -c` calls if you count the shell they
     start as the script's own language. I would.

  On the failure paths: *empty* — a suite that links none of these tools is unaffected. *Absent* —
  a tool missing in the guest fails the suite at setup, as QC-67 already says. *Stale* — a macOS
  update that changes a tool's behaviour shows up in the suite. That is the point of using the
  real tool. *Concurrent* and *refused* do not arise for a rule about which tools a suite may link.
  One case stays uncovered, and QC-67 already names it: a script that probes for an optional tool
  with `command -v` takes its fallback branch silently. The admitted list does not change that.
  One correction to the override's own wording. It lists `kill` among the stand-ins, but `kill` is
  built into bash. `checks/bundle.sh:L152`, `checks/launch.sh:L63` and `checks/offline-page.sh:L64`
  call it that way, so no process starts and neither list reaches it. That is also why
  `support/vm_refusal.sh:L64` can link it as an ordinary tool without harm. I would drop `kill`
  from the stand-in list, so the bound does not name a tool it cannot reach.

  What would have tipped me to *confirm*: if you left part 1 out on purpose, because you want
  shell check suites held to the doctrine as written. If so, the honest record is that bound (3)'s
  gaps are permanent, and QC-72 should say that, not call them gaps "until a change moves it". And
  if you think this applies to every shell product, not just KA-Reader, the exception belongs in
  `testing_doctrine.md` itself, which is yours. No companion template exists for that file.

## Skipped

None this run. The one open item had its owner slot at its placeholder, and the invocation listed
no items, so it was this run's. §§ 1 and 3 read "None."

## Companions opened

None this run. No other document is owed a change. The answer lands, if you take it, in QC-72 and
nowhere upstream. The SRS, SDD and FDR say nothing about which tools a check suite may run.

## Launchers owed

- **docs/adr/ and docs/nfdr.md** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
