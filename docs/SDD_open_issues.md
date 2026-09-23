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
> **An item in §§ 1–3 names the seat that raised it.** An item the CPO raised is a product call and
> an item the CTO raised is a technical one, and the answer that settles one does not settle the
> other. **§ 4 names two seats and no raiser** — a disagreement is not something one seat asked, it
> is something two seats answered differently, and the answer that settles it picks between them.
>
> **§ 5 names a raiser from outside the run entirely.** §§ 1–4 are all the SDD's own three seats;
> § 5 is a seat that never wrote the SDD, reading it long after it settled and finding something
> only the SDD can fix. Its `Raised by:` therefore takes a wider set than §§ 1–3's, which stay fixed
> to the three authoring seats on purpose.

> **No `product-sdd` run opened this companion. The owner opened it on 2026-09-23**, from the
> station's Finder walk (condition 8). `SDD.md` is settled at v10 and had no companion on disk.
> Without one, a `product-sdd` re-run would read the SDD as done and find nothing to act on. The
> companion holds one item, § 5.1, already answered.

---

## 5. Raised from downstream — an item from a seat that did not write the SDD

### 5.1 Under C-R2's exact entitlements the renderer never starts, so the window is empty
- **Raised by:** Owner — 2026-09-23, from the Finder walk on `e7b2bcd`
- **Tracked by:** `nozoki · shukuba · 2026-09-18_the-wall-holds` (condition 8)
- **What it blocks:** The station's close, and v1 itself. Condition 8 fails at its first step: the
  bundle built from `e7b2bcd` opens one window titled "Nozoki", empty, with no Open panel, and the
  window takes no right-click. CI run 35840538490 on the same commit is green, so no gate saw it.
- **Where it shows:** A two-second thread sample (`sample <pid> 2`) of each build, launched from
  Finder with `open -n`:

  | Build | Entitlements | `WebProcessProxy::processDidTerminateOrFailedToLaunch` in the sample | rfd `pick_folder` → `run_on_main` in the sample |
  |---|---|---|---|
  | release, as CI builds it | `app-sandbox`, `files.user-selected.read-only` | present | absent |
  | debug (`tauri build --debug`) | the same two | present | not sampled |
  | release, re-signed | the same two + `network.client` | absent | present |
  | release, re-signed | none (no sandbox) | absent | present |

  The main thread is idle in `NSApplication run` in every case, so nothing blocks. WebKit's web
  content process fails to launch or ends, the page never runs, and `main.ts` never calls
  `open_folder` (`nozoki-ui/src/main.ts:L14-L19`). **The mechanism is not known.** The system log
  gave no lines to this session, and no crash report was written for a WebKit process
  (`~/Library/Logs/DiagnosticReports/`). C-R2 grants **exactly** the two v1 entitlements and names
  "a slice that adds an entitlement" as its violation (`SDD.md:L432-L442`), so C-R2 cannot hold as
  written and give a window that draws. `checks/bundle.sh` passes because it proves the wall on the
  launched process (`sandboxed: yes`, out-of-grant read and outbound connection denied), and never
  that the page ran.
- **If a document has to be written:** C-R2 is rewritten per the answer, with an ADR for any
  entitlement it adds (ADR-0003 is C-R2's record). C-I3, or a new gate beside it, owes a check that
  the shipped bundle's renderer runs. `docs/nfdr.md` follows through the architecture chain.
- **Answer:** **No network, ever — the promise is the operating system refusing an outgoing
  connection, not the list.** Decided by the owner, 2026-09-23.
  1. `com.apple.security.network.client`, and every other network entitlement, is **never**
     granted, although it is proven to make the window draw. Granting it would make "no network"
     a promise the code keeps, which is the thing C-R2 exists to rule out.
  2. C-R2's "exactly these entitlements" gives way to: *no network entitlement; a read-only grant
     on the chosen folder; any other entitlement only with an ADR that names why it is needed, and
     only where the probe (C-I3) still finds the launched process sandboxed with the out-of-grant
     read and the outbound connection both denied.* The *Violated by* clause changes to match.
  3. The CTO owes the mechanism: why WebKit's content process does not start under the two v1
     entitlements, found from the system log or Apple's own documentation, before any entitlement
     is chosen. If the fix needs no entitlement (a WebKit or Tauri configuration), the list stands.
  4. A new gate: the bundle CI ships must be shown to run its renderer under its shipped
     entitlements — at the least, that the page reached `open_folder`. The empty window got past
     every gate, so this gate is what stops it happening again.

**How it closes.** `product-sdd` folds it on its next run like every other item in this file, and
the trail copy and the delete-when-empty behaviour are unchanged.
