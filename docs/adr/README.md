# Architecture decision log — KA-Reader

> The decision log for KA-Reader. One file per architecturally significant decision, in this
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
| [ADR-0001](0001-capability-split-read-pipeline.md) | KA-Reader is a capability-split read pipeline, and its promise is held by withholding capability | Superseded by ADR-0013 | 2026-09-01 |
| [ADR-0002](0002-tauri-2-rust-host-wkwebview-renderer.md) | The runtime is Tauri 2 — a Rust host over ka-reader-core, the surfaces in the system WKWebView, one bundle | Superseded by ADR-0014 | 2026-09-01 |
| [ADR-0003](0003-app-sandbox-wall-and-open-panel-grant.md) | The App Sandbox is the write-and-network wall, so the folder is granted through the Open panel and never typed | Superseded by ADR-0011 | 2026-09-01 |
| [ADR-0004](0004-git-read-through-libgit2-behind-a-port.md) | Git state is read through libgit2 behind a port; the installed git is the standing substitute and is not built until it is needed | Superseded by ADR-0019 | 2026-09-01 |
| [ADR-0005](0005-root-finding-behind-the-git-port.md) | The root finding lives behind the Git port, and a plain folder is a model with no Git state | Superseded by ADR-0018 | 2026-09-01 |
| [ADR-0006](0006-markdown-sanitized-on-the-host-three-walls.md) | Markdown is rendered on the host through a sanitizer, and the renderer sees only inert HTML plus one asset scheme | Superseded by ADR-0015 | 2026-09-01 |
| [ADR-0007](0007-ad-hoc-signed-dmg-on-a-github-release.md) | The release is an ad-hoc-signed, un-notarized `.dmg` on a GitHub Release, built by CI from the tag — never Developer ID-signed | Superseded by ADR-0024 | 2026-09-01 |
| [ADR-0008](0008-harness-over-core-and-bundle-probe-from-first-build.md) | The read-only proof runs against `ka-reader-core` and the IPC command list, not the rendered UI, and the bundle probe runs on every build from the first | Superseded by ADR-0010 | 2026-09-01 |
| [ADR-0009](0009-physical-module-set.md) | The physical module set — `ka-reader-core` as a library both the host and the harness link, `ka-reader-app` as the only Tauri-aware unit, `ka-reader-ui` as a capability-free bundle, `checks/` outside the bundle | Superseded by ADR-0016 | 2026-09-01 |
| [ADR-0010](0010-harness-over-core-and-bundle-probe-reads-the-os-sandbox-report.md) | The read-only proof runs against `ka-reader-core` and the IPC command list, not the rendered UI, and the bundle probe — on every build from the first — reads the operating system's own report that the launched process is sandboxed | Accepted — supersedes ADR-0008 | 2026-09-19 |
| [ADR-0011](0011-app-sandbox-wall-under-a-rule-no-network-entitlement-ever.md) | The App Sandbox is the write-and-network wall, held by a rule and not by a list — no network entitlement ever, a read-only grant on the chosen folder, any other entitlement only with a record — and the folder is granted through the Open panel and never typed | Accepted — supersedes ADR-0003 | 2026-09-23 |
| [ADR-0012](0012-renderer-run-proved-on-the-shipped-bundle-beside-the-wall.md) | The shipped bundle's shell run is proved beside the wall — observed from the process, never from a marker the product writes, with a control that must go red — on every build after the wall probe and never instead of it | Accepted | 2026-09-23 |
| [ADR-0013](0013-sandboxed-single-process-read-pipeline.md) | KA-Reader is a sandboxed single-process read pipeline — one process under the App Sandbox, a Rust core reached across one closed C-ABI seam, and its promise held by the process's own entitlements | Superseded by ADR-0021 | 2026-09-23 |
| [ADR-0014](0014-appkit-shell-in-swift-no-web-engine.md) | The view is AppKit in Swift, in the one process — no web engine of any kind; the core stays Rust behind a C ABI; one bundle | Accepted — supersedes ADR-0002 | 2026-09-23 |
| [ADR-0015](0015-markdown-as-a-typed-document-three-walls-in-one-process.md) | Markdown becomes a typed document on the host and never markup; image bytes cross the seam as bytes for a contained path and are decoded by the platform inside the one process | Accepted — supersedes ADR-0006 | 2026-09-23 |
| [ADR-0016](0016-physical-unit-set-core-bridge-mac-checks.md) | The physical unit set — `ka-reader-core` a Rust library with no `unsafe` and no Apple framework; `ka-reader-bridge` a Rust static library, the only unit that exports the C ABI and the only one that holds `unsafe`; `ka-reader-mac` a Swift package with no dependency, the only unit that imports AppKit; `checks/` outside the bundle | Superseded by ADR-0020 | 2026-09-23 |
| [ADR-0017](0017-floor-grammars-compiled-by-tree-sitter-native-c-in-the-core.md) | The six floor grammars are compiled by tree-sitter — native C built from source into `ka-reader-core` on every build | Accepted | 2026-10-01 |
| [ADR-0018](0018-root-finding-answers-root-for-a-git-file-and-reads-only-inside-the-folder.md) | The root finding lives behind the Git port and reads only inside the opened folder — a `.git` file answers `root` from its own content, and the Git directory it names is `state()`'s to report | Accepted — supersedes ADR-0005 | 2026-10-03 |
| [ADR-0019](0019-git-read-through-libgit2-behind-a-port-the-executable-links-no-transport.md) | Git state is read through libgit2 behind a port that `git-reader` defines and `folder-model` states; the shipped executable links no network transport; the installed git is the standing substitute and is not built until it is needed | Accepted — supersedes ADR-0004 | 2026-10-03 |
| [ADR-0020](0020-physical-unit-set-the-bridge-switches-off-libgit2-machine-config-reads.md) | The physical unit set, with one exception to the libgit2 import rule — `core-bridge`, the Rust-side composition root, names the binding to empty libgit2's four machine-level config search paths before the adapter is wired, and nowhere else | Accepted — supersedes ADR-0016 | 2026-10-03 |
| [ADR-0021](0021-sandboxed-single-process-read-pipeline-git-state-pulled-by-read-git.md) | KA-Reader is a sandboxed single-process read pipeline — one process under the App Sandbox, a Rust core reached across one closed C-ABI seam of ten calls, Git state pulled by `read_git` and not pushed, and its promise held by the process's own entitlements | Accepted — supersedes ADR-0013 | 2026-10-04 |
| [ADR-0022](0022-git-reader-refuses-a-repository-whose-config-names-a-location-outside-the-folder.md) | `git-reader` refuses a repository whose Git config, `.gitmodules` or alternates file names a location outside the folder — by a check of its own, read inside the folder before libgit2 reads what that file names | Superseded by ADR-0023 | 2026-10-06 |
| [ADR-0023](0023-git-reader-refuses-a-repository-whose-config-names-a-location-outside-the-folder-an-unreadable-gitmodules-answers-its-own-condition.md) | `git-reader` refuses a repository whose Git config, `.gitmodules` or alternates file names a location outside the folder — by a check of its own, read inside the folder before libgit2 reads what that file names — and a `.gitmodules` the check cannot read answers a condition of its own | Accepted — supersedes ADR-0022 | 2026-10-07 |
| [ADR-0024](0024-ad-hoc-signed-dmg-on-a-github-release-at-eyalgo-ka-reader.md) | The release is an ad-hoc-signed, un-notarized `.dmg` on a GitHub Release at `github.com/eyalgo/ka-reader`, built by CI from the tag — never Developer ID-signed | Accepted — supersedes ADR-0007 | 2026-10-16 |
