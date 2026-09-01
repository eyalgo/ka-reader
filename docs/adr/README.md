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
| [ADR-0003](0003-app-sandbox-wall-and-open-panel-grant.md) | The App Sandbox is the write-and-network wall, so the folder is granted through the Open panel and never typed | Accepted | 2026-09-01 |
| [ADR-0004](0004-git-read-through-libgit2-behind-a-port.md) | Git state is read through libgit2 behind a port; the installed git is the standing substitute and is not built until it is needed | Accepted | 2026-09-01 |
| [ADR-0005](0005-root-finding-behind-the-git-port.md) | The root finding lives behind the Git port, and a plain folder is a model with no Git state | Accepted | 2026-09-01 |
| [ADR-0006](0006-markdown-sanitized-on-the-host-three-walls.md) | Markdown is rendered on the host through a sanitizer, and the renderer sees only inert HTML plus one asset scheme | Accepted | 2026-09-01 |
| [ADR-0007](0007-ad-hoc-signed-dmg-on-a-github-release.md) | The release is an ad-hoc-signed, un-notarized `.dmg` on a GitHub Release, built by CI from the tag — never Developer ID-signed | Accepted | 2026-09-01 |
| [ADR-0008](0008-harness-over-core-and-bundle-probe-from-first-build.md) | The read-only proof runs against `nozoki-core` and the IPC command list, not the rendered UI, and the bundle probe runs on every build from the first | Accepted | 2026-09-01 |
| [ADR-0009](0009-physical-module-set.md) | The physical module set — `nozoki-core` as a library both the host and the harness link, `nozoki-app` as the only Tauri-aware unit, `nozoki-ui` as a capability-free bundle, `checks/` outside the bundle | Proposed | 2026-09-01 |
