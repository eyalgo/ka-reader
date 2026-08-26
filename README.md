# Nozoki 覗き

**Nozoki** (覗き — *"to peek / peer in"*) is a lightweight, strictly **read-only** viewer for a
local Git repository: a stripped-down, VS Code-like tool that runs on your own machine, for
browsing the repository's files and inspecting its Git status. Look, don't touch.

> **Status: proposal — not yet implemented.** This repository currently holds the design only.
> The full design and delivery plan live in [`docs/proposal.md`](docs/proposal.md).

## What it is

A tool optimized for **inspection rather than authoring** — select files, browse the
repository's file tree, and check its Git status in a familiar editor-like shell, without the
complexity of a full IDE. The intentionally narrow v1:

- Read-only code viewing with syntax highlighting.
- Sidebar toggle between **Files** and **Git**.
- Fast file switching in a familiar workbench-style shell.
- Minimal chrome and minimal configuration surface.

Nozoki is used with a mouse. It has no keyboard navigation, and it makes no promise about
screen readers or other assistive technology. Neither is planned: keyboard navigation is outside
what Nozoki is built to become.

## Planned stack (v1)

TypeScript · Vite · Monaco Editor (read-only mode) · Lucide icons · Lit or direct DOM
rendering · plain CSS / CSS variables. See the proposal for the rationale and the
Monaco-vs-CodeMirror decision matrix.

## Roadmap

1. **Static shell** — app frame, sidebar mode switch, mock file tree, Monaco in read-only mode.
2. **Real state** — real file metadata, selection→editor wiring, Git panel data, changed-file states.
3. **Refinement** — diff/commit-preview.

Not on the roadmap, and not coming later: sidebar search, pane resizing and keyboard navigation
are outside what Nozoki is built to become.

## Name

*Nozoki* (覗き) is drawn from the kensaiapp naming family — Japanese terms that name a thing by
its essence. To *peek* is exactly what this tool does: it lets you peer into a repository, but
never reach in and change it.
