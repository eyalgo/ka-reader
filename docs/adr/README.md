# Architecture decision log — Nozoki 覗き

> The decision log for Nozoki. One file per architecturally significant decision, in this
> directory, numbered `NNNN-slug.md` and **append-only**: a reversal is a new record that supersedes
> an old one, never an edit to it.
>
> This index is a **projection** of those records and is rewritten as they land. Where a row here and
> the record it names disagree, **the record is right and the row is stale**.
>
> Written by the Principal Architect from the settled SRS and SDD, with the FDR beside them. What
> each record contains is `<CORE>/templates/product-templates/adr_record_template.md`, a template
> of the organisation that publishes this product, outside this repository; each record here states
> its own context, decision, alternatives, consequences and traces in full, so nothing in one
> depends on that template being open.

| # | Title | Status | Date |
|---|---|---|---|
| [ADR-0001](0001-capability-split-read-pipeline.md) | Nozoki is a capability-split read pipeline, and its promise is held by withholding capability | Accepted | 2026-09-01 |
| [ADR-0002](0002-tauri-2-rust-host-wkwebview-renderer.md) | The runtime is Tauri 2 — a Rust host over nozoki-core, the surfaces in the system WKWebView, one bundle | Accepted | 2026-09-01 |
| [ADR-0003](0003-app-sandbox-wall-and-open-panel-grant.md) | The App Sandbox is the write-and-network wall, so the folder is granted through the Open panel and never typed | Superseded by ADR-0011 | 2026-09-01 |
| [ADR-0004](0004-git-read-through-libgit2-behind-a-port.md) | Git state is read through libgit2 behind a port; the installed git is the standing substitute and is not built until it is needed | Accepted | 2026-09-01 |
| [ADR-0005](0005-root-finding-behind-the-git-port.md) | The root finding lives behind the Git port, and a plain folder is a model with no Git state | Accepted | 2026-09-01 |
| [ADR-0006](0006-markdown-sanitized-on-the-host-three-walls.md) | Markdown is rendered on the host through a sanitizer, and the renderer sees only inert HTML plus one asset scheme | Accepted | 2026-09-01 |
| [ADR-0007](0007-ad-hoc-signed-dmg-on-a-github-release.md) | The release is an ad-hoc-signed, un-notarized `.dmg` on a GitHub Release, built by CI from the tag — never Developer ID-signed | Accepted | 2026-09-01 |
| [ADR-0008](0008-harness-over-core-and-bundle-probe-from-first-build.md) | The read-only proof runs against `nozoki-core` and the IPC command list, not the rendered UI, and the bundle probe runs on every build from the first | Superseded by ADR-0010 | 2026-09-01 |
| [ADR-0009](0009-physical-module-set.md) | The physical module set — `nozoki-core` as a library both the host and the harness link, `nozoki-app` as the only Tauri-aware unit, `nozoki-ui` as a capability-free bundle, `checks/` outside the bundle | Accepted | 2026-09-01 |
| [ADR-0010](0010-harness-over-core-and-bundle-probe-reads-the-os-sandbox-report.md) | The read-only proof runs against `nozoki-core` and the IPC command list, not the rendered UI, and the bundle probe — on every build from the first — reads the operating system's own report that the launched process is sandboxed | Accepted — supersedes ADR-0008 | 2026-09-19 |
| [ADR-0011](0011-app-sandbox-wall-under-a-rule-no-network-entitlement-ever.md) | The App Sandbox is the write-and-network wall, held by a rule and not by a list — no network entitlement ever, a read-only grant on the chosen folder, any other entitlement only with a record — and the folder is granted through the Open panel and never typed | Accepted — supersedes ADR-0003 | 2026-09-23 |
| [ADR-0012](0012-renderer-run-proved-on-the-shipped-bundle-beside-the-wall.md) | The shipped bundle's shell run is proved beside the wall — observed from the process, never from a marker the product writes, with a control that must go red — on every build after the wall probe and never instead of it | Proposed | 2026-09-23 |
| [ADR-0013](0013-sandboxed-single-process-read-pipeline.md) | Nozoki is a sandboxed single-process read pipeline — one process under the App Sandbox, a Rust core reached across one closed C-ABI seam, and its promise held by the process's own entitlements | Proposed — supersedes ADR-0001 on acceptance | 2026-09-23 |
| [ADR-0014](0014-appkit-shell-in-swift-no-web-engine.md) | The view is AppKit in Swift, in the one process — no web engine of any kind; the core stays Rust behind a C ABI; one bundle | Proposed — supersedes ADR-0002 on acceptance | 2026-09-23 |
| [ADR-0015](0015-markdown-as-a-typed-document-three-walls-in-one-process.md) | Markdown becomes a typed document on the host and never markup; image bytes cross the seam as bytes for a contained path and are decoded by the platform inside the one process | Proposed — supersedes ADR-0006 on acceptance | 2026-09-23 |
| [ADR-0016](0016-physical-unit-set-core-bridge-mac-checks.md) | The physical unit set — `nozoki-core` a Rust library with no `unsafe` and no Apple framework; `nozoki-bridge` a Rust static library, the only unit that exports the C ABI and the only one that holds `unsafe`; `nozoki-mac` a Swift package with no dependency, the only unit that imports AppKit; `checks/` outside the bundle | Proposed — supersedes ADR-0009 on acceptance | 2026-09-23 |
