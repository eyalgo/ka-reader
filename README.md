# Nozoki 覗き

**Nozoki** (覗き — *"to peek / peer in"*) is a lightweight, strictly **read-only** code
workspace viewer: a stripped-down, VS Code-like web app for browsing a project's files and
inspecting its Git status. Look, don't touch.

> **Status: proposal — not yet implemented.** This repository currently holds the design only.
> The full design and delivery plan live in [`docs/proposal.md`](docs/proposal.md).

## What it is

A tool optimized for **inspection rather than authoring** — select files, browse project
structure, and check repository status in a familiar editor-like shell, without the complexity
of a full IDE. The intentionally narrow v1:

- Read-only code viewing with syntax highlighting.
- Sidebar toggle between **Files** and **Git**.
- Fast file switching in a familiar workbench-style shell.
- Minimal chrome and minimal configuration surface.

## Planned stack (v1)

TypeScript · Vite · Monaco Editor (read-only mode) · Lucide icons · Lit or direct DOM
rendering · plain CSS / CSS variables. See the proposal for the rationale and the
Monaco-vs-CodeMirror decision matrix.

## Roadmap

1. **Static shell** — app frame, sidebar mode switch, mock file tree, Monaco in read-only mode.
2. **Real state** — real file metadata, selection→editor wiring, Git panel data, changed-file states.
3. **Refinement** — pane resizing, keyboard navigation, diff/commit-preview, sidebar search.

## Name

*Nozoki* (覗き) is drawn from the kensaiapp naming family — Japanese terms that name a thing by
its essence. To *peek* is exactly what this tool does: it lets you peer into a codebase, but
never reach in and change it.
