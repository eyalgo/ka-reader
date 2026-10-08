# Self-answer report — `docs/SDD.md`

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md`
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-09-19
- **Sources re-read:**
  - Apple, *Protecting user data with App Sandbox*
    (https://developer.apple.com/documentation/security/protecting-user-data-with-app-sandbox, read
    through its JSON at `developer.apple.com/tutorials/data/documentation/security/…json`). Under
    "Verify that your app uses App Sandbox" it names two checks: the running process's Sandbox column
    in Activity Monitor ("verify that the value in the Sandbox column is Yes"), and
    `codesign -dvvv --entitlements -` for the configuration. The page does not mention
    `APP_SANDBOX_CONTAINER_ID`.
  - The SDK header `/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/sandbox.h`
    declares `sandbox_init` and `sandbox_free_error` and does not declare `sandbox_check`.
    `ctypes.CDLL('/usr/lib/libSystem.dylib')` resolves `sandbox_check` (`True`, this Mac). So the
    function is exported but undocumented.
  - This Mac (macOS 26.6.2), re-measured this run with `/bin/ps -wwE -o command= -p <pid>`. MD Viewer
    main process 52791 has no marker. Helpers 52793 and 52794 carry
    `APP_SANDBOX_CONTAINER_ID=com.websumo.mdviewer`. This matches the item's evidence.

## Items worked

### 5.1 — C-I3's sandbox observable is absent from a sandboxed app's own process, so the probe cannot pass as written

- **Bucket:** 5. Raised from downstream — an item from a seat that did not write the SDD
- **Verdict:** answered
- **Why:** Re-cut C-I3's runtime observable. The new one is the operating system reporting the
  launched main process as sandboxed, with an out-of-grant file read and outbound network reported
  denied for that pid. A no-entitlement build of the same binary must come out unsandboxed, as a
  negative control. The item carried no proposed replacement, so this is *answered*, not a
  confirmed draft. It is also not a widening, so § *A widening item waits until it occurs* does not
  apply. It corrects an observable the built bundle has shown false: the item's evidence
  (`ka-reader@ccb58d8`, commit body) and this run's re-measurement above.

  *Seat.* The change lands in `SDD.md`: C-I3 at `L516-L519`, § 6's *Command* bar at `L1043-L1045`,
  R-8 at `L1904-L1906`, and the fourth Open Question at `L2508-L2511`. It binds only the harness,
  which is not a person, money or a risk someone carries. So it is the SDD's own call, made here in
  the owner's seat. ADR-0008 and NFDR QC-25 follow it through `docs/architecture_open_issues.md`
  § 3.1. That item already exists and defers to this one, so nothing is raised there.

  *Why this observable.* The marker fails at the job C-I3 gives it. It does not appear in a
  sandboxed main process under either signature, and it does not separate sandboxed from
  unsandboxed (the item's evidence). Apple's documented runtime check is the process's own sandbox
  state (source above). `sandbox_check` is what already gave the correct reading on the ad-hoc
  bundle, the trivial app and the unsandboxed control (`ka-reader@ccb58d8`). The two operation denials
  test the wall itself, what C-R2 promises, rather than a proxy for it. I ruled out the container
  directory as the observable. It survives from an earlier launch, so a stale directory would pass
  an unsandboxed rebuild.

  *Check 3.* Nothing settled has to move. C-R2's "*Violated by* … a build whose bundle the probe
  (C-I3) finds unsandboxed" (`SDD.md:L436-L437`) reads correctly with the new probe. The design
  decision in `SDD.md` § 5 step 5 (`L941-L944`) stands, and this is what it was for: the finding
  arrived with one reader written. The product gains no probe entry, so C-R3 and NFR-14 hold. The
  probe reads a pid from outside the process and passes nothing into it.

  *Check 4.* **Absent:** if `sandbox_check` is missing or returns an error, the build fails. It
  never passes by default. **Stale:** the pid must be one this run started, and an existing
  container counts for nothing. A macOS release that changes the undocumented function fails the
  negative control, which is R-8's re-cut trigger by design. **Concurrent:** the script requires no
  instance running before launch and exactly one after, and fails otherwise.
  **Uncovered, named:** a GitHub-hosted macOS runner is unmeasured, since `ka-reader@ccb58d8` says "I
  did not test another macOS version or a hosted runner". The probe's first CI run settles that
  case.

  *What would have tipped it.* I came close to leaving this for the owner, on the ground that the
  probe now rests on an undocumented function. The negative control decided it the other way. An
  undocumented mechanism that is shown able to fail, on every build, is safer than a documented-looking marker
  that never discriminated.

## Left for the owner

None this run.

## Skipped

None this run.

## Companions opened

None this run.

## Launchers owed

- **`docs/SDD.md`** — `/Users/eyalgolan/projects/kensai/kensaiapp-dev/core/launchers/product-sdd/launcher.sh ka-reader`
