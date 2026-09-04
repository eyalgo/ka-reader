# ADR-0006: Markdown is rendered on the host through a sanitizer, and the renderer sees only inert HTML plus one asset scheme

**Status:** Accepted
**Date:** 2026-09-01

## Context

Content read from the folder is displayed and never executed: rendering a Markdown file runs no
script, loads no active content, and gives the file no path to the filesystem, the network or the
tool's own state (`docs/SRS.md` § 4.3 NFR-16); rendering fetches nothing from outside the folder,
an external link is displayed and not followed, and a relative link may open its target
(`docs/SRS.md` § 3.3 FR-32). The renderer holds no capability of its own (ADR-0001), so a Markdown
file that reached it as live HTML would be handed the WebView's. The first design draft loaded no
image at all; the owner overrode it — an image inside the granted folder is loaded and shown in
place, a remote one never (`nozoki@70a879a:docs/trail/sdd/cycle-1.md` § 2.4).

## Decision

**Markdown → HTML happens on the host**, in `markdown-renderer` inside `nozoki-core`, through a
sanitizer whose allowlist admits no script, style, frame, object, event attribute or `src` — with
one rewrite, not an exception: an image whose reference resolves, by `fs-reader`'s containment
check with symlinks followed, to a file inside the granted folder becomes an `<img>` whose `src` is
that file's path on the host's own asset scheme, `nozoki-asset`; any other image — remote, or
escaping the folder — becomes the not-loaded placeholder; an external link becomes inert text with
its destination readable; a relative link becomes a data attribute the renderer turns into the
existing open-file command. Nothing on any scheme but the asset scheme is ever emitted, and never a
`file:` or `http(s):` URL (`docs/SDD.md` § 3, `markdown-renderer` row; seam 7).

Three walls fail independently: the sanitizer; the renderer's Content Security Policy —
`default-src 'none'; script-src 'self'; style-src 'self'; img-src 'self' data: <asset-scheme>;
font-src 'self'`, declared in `tauri.conf.json` (`docs/SDD.md` § 4 C-R7); and the asset handler's
containment check, on the canonical path with symlinks resolved and after decoding, run at render
and again on every request (`docs/SDD.md` § 4 C-D3; § 11 R-10).

## Alternatives ruled out

- **Render in the renderer with a JavaScript Markdown library** — the renderer would build URLs
  from content and hold the resulting HTML live; a sanitizer bypass would then reach the WebView's
  own capabilities rather than a host that has none to give (`docs/SDD.md` § 2 force 3; § 3, seam 7's
  "a bypass of the first two still reaches no byte outside the folder").
- **Load no image, remote or local** — the run-1 draft, the conservative reading of "the renderer
  holds no path to the folder". Overridden by the owner: image-bearing READMEs render as written,
  and the wall is kept by narrowing the capability handed over to "read a byte the host has already
  confirmed is inside the folder", not "read" (`nozoki@70a879a:docs/trail/sdd/cycle-1.md` § 2.4; `nozoki@70a879a:docs/SDD.md`
  § SDD Review Notes RN-11).
- **`file:` URLs, or a wider CSP** — a `file:` URL anywhere, or `http:`, `https:`, `asset:` or `*`
  in any directive, is what C-R7 names as its violation; the asset scheme exists so that neither is
  ever needed (`docs/SDD.md` § 4 C-R7, C-D3).

## Consequences

Easier: a README with images inside its folder renders whole with the network off; a bypass of any
one wall still moves no byte across the folder's edge; the hostile-document corpus grows with every
reported bypass (`docs/SDD.md` § 11 R-4, R-10). Harder: one scheme the renderer can address; a wider
`img-src`; a containment check that must be right about `..`, symlinks, percent-encoding and
Unicode normalization; and a raw-source view that is not built, because preserving the reading
position both ways needs a rendered↔source mapping with no other use (`docs/SDD.md` § 9 TO-5, TO-6;
`nozoki@70a879a:docs/SDD.md` § SDD Review Notes RN-10).

What undoing it costs: removing the handler and the scheme, and the placeholder returning for
every image (`docs/SDD.md` § 9 TO-6).

**What this rests on, and whose it stays.** The exact origin form the WebView accepts in `img-src`
for a custom scheme, and whether Tauri 2's protocol registration on macOS serves it without a
plugin, are open until the first Markdown slice renders the local-image fixture with no CSP
violation; the form found is written into C-R7 (`docs/SDD.md` § Open Questions, fifth item). If
that form moves with a WebView release, what is un-made is one CSP directive and the scheme's
registration — the sanitizer and the containment check stand.

## Traces to

- `docs/SDD.md` § 3, `markdown-renderer` and `ipc-surface` rows, seams 4 and 7; § 4 C-R7, C-D3;
  § 9 TO-5, TO-6; § 11 R-4, R-10; § Open Questions (fifth item); `nozoki@70a879a:docs/SDD.md` § SDD Review Notes RN-10, RN-11.
- `nozoki@70a879a:docs/trail/sdd/cycle-1.md` § 2.4 — the owner's override.
- `docs/SRS.md` § 3.3 FR-30, FR-31, FR-32; § 4.3 NFR-16; § 6 DR-6; § 8 AC-23.
- `docs/fdr.md` R-52, R-56 – R-62, PD-11, PD-12, PD-13.

## Binds

QC-6, QC-11, QC-22, QC-23, QC-31, QC-37.
