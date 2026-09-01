# ADR-0002: The runtime is Tauri 2 — a Rust host over nozoki-core, the surfaces in the system WKWebView, one bundle

**Status:** Accepted
**Date:** 2026-09-01

## Context

The acquisition path is one path, no build from source, at most one named prerequisite, and a
stranger reaches a viewed file within five minutes (`docs/SRS.md` § 7 C-3; § 4.7 NFR-13). The owner
kept that bound knowing a runtime's cold install can consume most of the clock — the pressure toward
a self-contained artifact is intended (`docs/SRS.md` § SRS Review Notes RN-12). The design language
is CSS custom properties over the product's own markup, with fourteen vendored SVG icons
(`docs/DESIGN.md` § Overview; `third_party/lucide/`), and every value in it is a CSS value that holds
in a browser tab or a native window (`docs/DESIGN.md` § DESIGN Review Notes RN-1). Markdown must
render (`docs/SRS.md` § 3.3 FR-30). The shape (ADR-0001) needs a host that exposes only the commands
it registers. The input proposal recommended TypeScript, Vite, Monaco and a web-app shell
(`docs/proposal.md` § Recommended Stack), which the PRD explicitly did not carry as product
properties (`docs/PRD.md` § Out of Scope, "The input's implementation-stack recommendations").

## Decision

The product is **one macOS application bundle, `Nozoki.app`, bundle identifier
`com.kensaiapp.nozoki`: a Tauri 2 host (`nozoki-app`, Rust) over a Rust library (`nozoki-core`),
rendering `nozoki-ui` (HTML / CSS / TypeScript) in the system WKWebView.** No browser engine is
bundled; every asset the renderer uses ships inside the bundle (`docs/SDD.md` § 4 C-R1). The owner
confirmed the runtime after checking that `docs/DESIGN.md` binds no rendering technology
(`docs/trail/sdd/cycle-1.md` § 2.2).

## Alternatives ruled out

- **Electron** — adds a bundled browser engine, the largest single dependency the alternative
  would carry, against a product whose one install must fit inside five minutes and whose
  dependency tree is allowlisted (`docs/SDD.md` § SDD Review Notes RN-7; § 4 C-R6).
- **Native AppKit / SwiftUI, single process** — the runner-up. It keeps the sandbox wall and loses
  the renderer wall; it would also re-express a design language settled in CSS. It wins only if that
  language is ever re-expressed natively, which nothing inside the terminus asks for
  (`docs/SDD.md` § 2, table row 4).
- **The proposal's web app — a local server and a browser tab** — a listening socket is a network
  call during operation (`docs/SRS.md` § 4.3 NFR-8), and the direction it serves is outside done
  (`docs/SDD.md` § 2, table row 5).

## Consequences

Easier: mature highlighting, diff and graph rendering in the renderer; a renderer that can be handed
*no* capability; the closed command list the host registers is the seam ADR-0001 rests on; memory
safety in the process that parses untrusted repository data (`docs/SDD.md` § 9 TO-1, TO-4).

Harder: a second wall — a host-side sanitizer and a Content Security Policy — to keep NFR-16 once
content is HTML (ADR-0006); a rendering engine whose behaviour is Apple's, moving with macOS; two
languages beside each other and the contributor bar that brings (`docs/SDD.md` § 9 TO-1, TO-4).

What undoing it costs: replacing the renderer technology costs every surface rewritten, the host
untouched; replacing the host language costs the host rewritten, the model and the harness fixtures
surviving (`docs/SDD.md` § 9 TO-1, TO-4). Neither the renderer technology nor the platform is
replaceable inside the terminus (`docs/fdr.md` PD-29).

**What this rests on, and whose it stays.** Tauri 2 is maintained by a project this product does
not control, and WKWebView is Apple's. The expected trajectory of an open-source dependency is that
its maintainers stop answering, not that they keep pace. If Tauri's holder goes silent, what is
un-made is the *mechanism* of the closed command list and the custom asset scheme (Tauri's capability
file and protocol registration) — not the shape: the host is Rust over a library, the IPC seam is
one surface, and a replacement shell re-implements that seam against the same `nozoki-core`. If
Apple moves WKWebView — the CSP origin form for a custom scheme is already an open question the
first Markdown slice settles (`docs/SDD.md` § Open Questions, fifth item) — what moves is the
renderer's walls, which are checked on every build (ADR-0006, ADR-0008).

## Traces to

- `docs/SDD.md` § 2, table row 4 and forces 6–7; § 3, "Three deliverables"; § 4 C-R1; § 9 TO-1,
  TO-4; § 12, "The downstream boundary"; § SDD Review Notes RN-7.
- `docs/trail/sdd/cycle-1.md` § 2.2 — the owner's confirmation, with the DESIGN.md check recorded.
- `docs/SRS.md` § 7 C-3, C-11; § SRS Review Notes RN-7, RN-12.
- `docs/DESIGN.md` § DESIGN Review Notes RN-1 — "every value here is a CSS value and holds in either".
- `docs/fdr.md` PD-15, PD-17, PD-29.

## Binds

QC-1, QC-8, QC-13, QC-17, QC-21, QC-55.
