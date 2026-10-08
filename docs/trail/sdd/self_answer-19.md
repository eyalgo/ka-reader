# Self-answer report — docs/SDD.md

## Header

- **Companion:** `docs/SDD_open_issues.md`
- **Document:** `docs/SDD.md` (v11, Draft)
- **Decided by:** `decide_companion_answers.md` v1.3.0
- **Date:** 2026-09-23
- **Sources re-read:** All WebKit files were read at the commit the item cites, `bb75cbc0003033ea73c42ef02370767aa52d6ba6`:
  - `Source/WebKit/Shared/EntryPointUtilities/Cocoa/XPCService/XPCServiceEntryPoint.mm:L52-L70`.
    It says what the item says. A sandboxed host passes the check only with
    `com.apple.security.network.client` or a permitted `mach-lookup` of `com.apple.nsurlsessiond`.
    Otherwise it fails and logs "Application does not have permission to communicate with network
    resources".
  - `Source/WebKit/NetworkProcess/mac/com.apple.WebKit.NetworkProcess.sb.in:L492-L496, L563-L568`.
    WebKit's Networking process has its own sandbox profile. That profile allows outbound TCP
    (`(remote tcp)`) and UDP unless the `BlockNetworkAccess` state flag is set. A further
    `(remote udp)` rule at `:L507-L508` carries no flag at all.
  - `Source/WebKit/NetworkProcess/cocoa/NetworkProcessCocoa.mm:L89-L120`. The Networking process
    sets `BlockNetworkAccess` only when all three of these hold:
    - the host's sandbox denies `network-outbound`;
    - the host is not an Apple platform binary;
    - on macOS, the host is linked on or after the SDK behaviour
      `NetworkProcessInheritsNetworkAccessFromUIProcess`.
    `Source/WTF/wtf/PlatformEnableCocoa.h:L1214-L1216` turns the feature on for Cocoa.
  - The file's commit history (GitHub API, `repos/WebKit/WebKit/commits?path=…NetworkProcessCocoa.mm`):
    - landed as e5e05b8898 (2025-11-19);
    - reverted as 4af081a141;
    - re-landed as e0e27e741c (2025-12-10);
    - "[macOS] The Networking process sandbox should inherit network access from the UI process"
      as cb7daacd43 (2026-08-22).

## Items worked

None this run.

## Left for the owner

### 1.1 — Under C-R2's rule the system WKWebView cannot start — so the renderer gives way, or the rule's reach does, and which is yours

- **Bucket:** 1. Open issues — questions with no answer yet (all three seats wrote a position into
  it, so this run treated it as a draft)
- **Verdict:** left for the owner
- **Why:** This is a choice between two of the owner's own calls, so it is theirs. The renderer is
  the owner's confirmation. `docs/SDD.md` § 10 RC-2 cites it to
  `ka-reader@70a879a:docs/trail/sdd/cycle-1.md` § 2.2. No network entitlement, ever, is the owner's
  ruling (`docs/trail/sdd/cycle-8.md` § 5.1, answer 1).

  Each exit breaks one of them. The run cannot pick between them in the owner's seat, for two
  grounds it can name but cannot see:
  - The release date. The CPO's position says (a) moves the first release "out by the rewrite of
    `surfaces`", and this run cannot read the owner's plan for that date.
  - How the owner reads their own ruling. The ruling says "every other network entitlement" is
    never granted. It also says the promise is "the operating system refusing an outgoing
    connection, not the list". Its answer 2 admits any other entitlement that has a record and
    passes the probe. Whether a `mach-lookup` exception counts as a "network entitlement" under
    those words is only the owner's to say.

  All four checks were run, and the answer below is what they reached.
- **The answer I would have given:** **(a). The renderer leaves WKWebView. I agree with all three
  seats, but I would add a stronger reason for refusing (c) than the one they give.**
  1. **Their reason for refusing (c) does not hold as stated.** They say "the service it opens is
     the one WebKit treats as network access". But WebKit's check only uses that `mach-lookup` as
     a stand-in for the question (`XPCServiceEntryPoint.mm:L55-L66`). Allowing the lookup does not,
     in itself, open anything this run can cite.
  2. **The real reason is that (c) starts a process whose network access does not come from the
     host.** Passing the check starts WebKit's Networking process. That process's own sandbox
     profile allows outbound TCP and UDP (`com.apple.WebKit.NetworkProcess.sb.in:L492-L496,
     L563-L568`). It gives that up only when it inherits the host's block, and that inheritance
     reached macOS in WebKit on 2026-08-22 (cb7daacd43). Even then it depends on which SDK the
     host was linked against (`NetworkProcessCocoa.mm:L89-L97`).
  3. **So on macOS 14, the floor C-R5 sets, the page would have a network path.** I don't know
     which macOS release first ships the inheritance change. The check that would settle it is
     `log show --predicate 'eventMessage CONTAINS "block network access"'` on a (c)-signed bundle,
     run on the floor OS. On any macOS whose WebKit predates the change, a page under (c) sits
     behind a Networking process the operating system lets connect. Only C-R7's CSP would stand
     between the page and the network. That is "a promise the code keeps", which answer 1 rules out.
  4. **C-I3 would not catch it.** `checks/bundle.sh` asks about the host's pid only (`docs/SDD.md`
     C-I3). The host stays denied under (c), so the probe goes green while the renderer's
     Networking process can connect. The wall the owner ruled on would then be evidenced by a
     probe that cannot see where it has a gap.
  5. **(b) and (d) are already refused by the owner, and (e) has no date.** WebKit's FIXME is still
     in place at the cited commit (`XPCServiceEntryPoint.mm:L56, L63`).

  **How (a) holds up on the failure paths:**
  - **Refused:** if the owner refuses (a) as well, the only exit left is (e). `open-a-folder`
    then stays unmet with no end date, and the Agari's public-release condition cannot be reached.
  - **Stale:** if Apple later drops the check, WKWebView becomes possible again. At that point it
    is a § 2 re-weighing, not a reason to wait.
  - **Absent:** under (a), no web engine means no fetch path in the renderer. The host's missing
    network entitlement then covers the whole process, and C-I3's host-pid probe covers the whole
    product. That is a gain the seats did not state.

  **What follows from (a):**
  - Which native technology, and what the seams become, is § 2's weighing. It is not decided here.
  - `checks/renderer.sh`'s mechanism and control are written for a WebKit page loaded from
    `Contents/Resources`. They have to be re-derived for a native view.

  **If the owner reads the ruling as leaving (c) open,** measure it before choosing it. On a
  (c)-signed bundle, on the macOS 14 floor, from inside the page, try an outbound fetch with the
  CSP loosened in a throwaway build. It must be refused by the operating system and not by the CSP.
  Without that measurement, the unmeasured half the item names ("whether `checks/bundle.sh` still
  reports the outbound connection denied") is the wrong half. The host will report denied either
  way.

## Skipped

None this run.

## Raised on this document

### 2.1 — C-I3 names ADR-0008 as its record, but ADR-0010 superseded ADR-0008 on 2026-09-19

- **What the document is owed:** In § 4 C-I3, "The record is ADR-0008" (`docs/SDD.md:L620`)
  becomes ADR-0010. RN-11's dated mention stays as it is.
- **Why it is worth a cycle:** *A fact in it is now false*: it is a claim about another document.
  ADR-0008 reads "Superseded by ADR-0010"
  (`docs/adr/0008-harness-over-core-and-bundle-probe-from-first-build.md:L3`;
  `docs/adr/README.md:L25-L27`). C-I3 already describes ADR-0010's observable, not ADR-0008's
  marker (§ 10 RC-1). It rides the fold § 1.1 already owes, so it costs no extra round.

## Companions opened

- **`docs/architecture_open_issues.md`** — **opened** — companion to `adr/` and `nfdr.md`, landed in commit `a9f1b8a`

It carries § 2.1: QC-25 (`docs/nfdr.md:L243-L245`) and ADR-0003 § Decision (`:L19`) still say
"exactly" a list of entitlements. C-R2 at v11 binds the owner's rule instead. C-I3's new
`checks/renderer.sh` also has no NFDR obligation. The SDD names this as owed to the Principal
Architect and routes it nowhere (§ 12; RC-2 *Still unresolved*). The item's reasoning also says
that C-R2's half holds under every answer to § 1.1, and that the renderer-gate half may move with it.

## Launchers owed

- **`docs/SDD.md`** — `<CORE>/launchers/product-sdd/launcher.sh ka-reader`
- **`adr/` and `nfdr.md`** — `<CORE>/launchers/skill/launcher.sh product-architecture ka-reader`
