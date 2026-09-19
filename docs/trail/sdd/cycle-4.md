# SDD open issues — Nozoki

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
> **§ 5 names a raiser from outside the run entirely.** It is a seat that never wrote the SDD,
> reading it after it settled and finding something only the SDD can fix.

> **No `product-sdd` run opened this companion. The PM opened it on 2026-09-19, from a post-build
> review.** `SDD.md` is settled and had no companion on disk. Without one, a `product-sdd` re-run
> would read the SDD as done and find nothing to act on. The companion holds a single item, § 5.1:
> the built bundle has now answered the fourth Open Question, and the answer is not the one C-I3's
> probe was written to expect.

---

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 C-I3's sandbox observable is absent from a sandboxed app's own process, so the probe cannot pass as written
- **Raised by:** PM — 2026-09-19
- **Tracked by:** `nozoki · nemawashi · 2026-09-15_open-a-folder`
- **What it blocks:** `open-a-folder`'s *Command* bar (`SDD.md:L1043-L1045`) — "`checks/bundle.sh
  Nozoki.app` … finds `APP_SANDBOX_CONTAINER_ID` in the launched bundle's environment". Until the
  observable is re-cut, no build can meet it.
- **Where it shows:** § 4 C-I3 (`SDD.md:L516-L519`, "failing unless the launched process carries
  `APP_SANDBOX_CONTAINER_ID` in its environment"); § 6 `open-a-folder`'s *Command* bar
  (`SDD.md:L1043-L1045`); and the fourth *Open Questions* item (`SDD.md:L2508-L2511`), which settles
  the question on "the first slice's first built bundle", where "a failure is R-8 and a re-cut
  trigger on the probe's mechanism". That bundle now exists, and the probe fails on it:
  - **Nozoki, ad-hoc signed, both C-R2 entitlements `true`.** `checks/bundle.sh` exits 1 with
    "APP_SANDBOX_CONTAINER_ID is not in its environment". This held under four launch routes. Over
    the same process, `sandbox_check` reports a read of `~/.zshrc` and outbound network as denied,
    and `~/Library/Containers/com.kensaiapp.nozoki` is created at first launch. A trivial ad-hoc app
    with the same two entitlements behaves the same way. The same binary with no entitlements is
    unsandboxed and also shows no marker. (`nozoki@ccb58d8`, commit body; macOS 26.6.2, arm64.)
  - **A team-signed, sandboxed third-party app, measured 2026-09-19 on the same Mac.** MD Viewer
    (`TeamIdentifier=HN9Q73NL62`, `com.apple.security.app-sandbox` true): `ps -wwE` on its main
    process (pid 52791) lists 11 environment keys, and `APP_SANDBOX_CONTAINER_ID` is not one of them.
    Its two helper processes (52793, 52794) do carry it.
  - So on this machine, reading the marker from the launched main process fails under **either**
    signature. It does not separate a sandboxed bundle from an unsandboxed one. The records here do
    not show why the helpers carry the marker and the main process does not.
  - The sandbox itself appears to hold under the ad-hoc signature (the `sandbox_check` denials
    above). What fails is the observable, which is the branch the Open Question names as "a re-cut
    trigger on the probe's mechanism", not R-8 firing.
- **If a document has to be written:** none. What is owed is C-I3's observable, § 6's
  *Command* bar sentence that quotes it, and the fourth Open Question's close — all three in
  `SDD.md` by `product-sdd`. ADR-0008 and NFDR QC-25 state the same observable and follow whatever
  is settled here; the architecture companion carries that side.
- **Answer:** Re-cut the observable to the operating system's own report that the **launched main
  process** is sandboxed. Drop the environment marker. Three sentences in `SDD.md` change, plus the
  R-8 sentence that quotes the marker:
  - **C-I3** (`SDD.md:L516-L519`): `checks/bundle.sh` reads the entitlements as now. It then
    launches the bundle and takes the pid of the main process this run started, found by its
    absolute executable path, with no instance of it running beforehand. It fails unless the
    operating system reports that pid as sandboxed **and** reports two operations as denied for it:
    a file read outside the grant and an outbound network connection. This is the state Apple names
    as the verification ("verify that the value in the Sandbox column is Yes",
    https://developer.apple.com/documentation/security/protecting-user-data-with-app-sandbox). The
    script reads it through libSystem's `sandbox_check`. That function is exported but is not in the
    SDK's `sandbox.h`, so C-I3 says the script's mechanism is undocumented. **A negative control is
    part of the probe:** the script's suite also runs it on the same binary built with no
    entitlements and requires it to fail, so a probe that cannot tell the two apart goes red
    instead of green. The failure cases also fail the build: `sandbox_check` missing or returning
    an error, no pid found, or more than one found. A container directory that already exists is
    never taken as evidence, because it survives from an earlier launch.
  - **§ 6 `open-a-folder` *Command*** (`SDD.md:L1043-L1045`): "finds `APP_SANDBOX_CONTAINER_ID`
    in the launched bundle's environment" becomes "finds the launched main process reported
    sandboxed, with the out-of-grant read and outbound network denied, and the no-entitlement
    control reported unsandboxed".
  - **Fourth Open Question** (`SDD.md:L2508-L2511`) closes on its own terms. The first half is
    settled: the sandbox is enforced under an ad-hoc signature on macOS 26.6.2, arm64
    (`nozoki@ccb58d8`). The second half is settled as *no*: the marker is absent from a sandboxed
    main process under either signature. That is the "re-cut trigger on the probe's mechanism", not
    R-8 firing. **R-8's *shows up as*** (`SDD.md:L1904-L1906`) names the new observable in place of
    the marker. One case stays uncovered and should be named: a GitHub-hosted macOS runner, which
    no one has measured. The C-I3 probe's first CI run settles it.
  Verdict and reasons: `docs/trail/sdd/self_answer-9.md`.

**How it closes.** `product-sdd` folds this item on its next run like any other item in this file,
and the trail copy and the delete-when-empty behaviour are unchanged.
