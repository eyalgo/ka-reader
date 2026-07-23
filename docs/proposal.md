# Proposal: Simple Read-Only Code Workspace Viewer

## Overview

This proposal describes a lightweight desktop-style web application that looks and feels like a stripped-down version of VS Code: a left sidebar that switches between project files and Git status, and a main editor area that is strictly read-only.

The recommended implementation for this version is TypeScript, Vite, Monaco Editor, and a framework-light UI layer using Lit or direct DOM rendering. This keeps the mental model small while still delivering a polished editor-driven experience.

## Product Goal

The tool should optimize for inspection rather than authoring. The primary workflow is selecting files, browsing project structure, and checking repository status in a familiar editor-like environment without introducing the complexity of a full IDE.

A successful first version should be intentionally narrow:

- Read-only code viewing with syntax highlighting.
- Sidebar toggle between Files and Git.
- Fast file switching with a familiar workbench-style shell.
- Minimal chrome and minimal configuration surface.

## Recommended Stack

### Core stack

| Area | Recommendation | Rationale |
|---|---|---|
| App framework | None, or Lit | Keep the UI layer light. Lit is a good middle ground if you want reusable components without React-sized overhead. |
| Language | TypeScript | Strong fit for explicit UI state, file-tree models, and future integration with Git/file APIs. |
| Build tool | Vite | Fast local iteration and low setup friction for a focused tool. |
| Editor | Monaco Editor | Closest match to the VS Code feel and supports read-only mode directly. |
| Icons | Lucide | Clean, lightweight icon set suitable for files, folders, source control, and shell actions. |
| Styling | Plain CSS or CSS variables | Best fit for a controlled custom shell with minimal abstraction. |

### Optional libraries

| Need | Library | When to use it |
|---|---|---|
| Small component abstraction | Lit | Use if you want Web Component style organization without React. |
| Tiny reactive UI helper | VanJS | Use if you want an extremely small footprint and simple reactive updates. |
| Resizable panes | react-resplit or a small custom splitter | Use only if sidebar resizing is a real requirement in v1 or v2. |
| Shared local UI state | A small store module | Add only if selection state, pane state, and editor state begin to spread across many parts of the app. |

## Editor Choice

Monaco Editor is the strongest default because the interface target is explicitly VS Code-like, and Monaco exposes read-only editor configuration through the `readOnly` option and related editor settings.

CodeMirror 6 is a valid alternative when bundle size, simpler embedding, or tighter customization matters more than matching the VS Code feel. CodeMirror 6 supports read-only mode via `EditorState.readOnly.of(true)`, which makes it a good fallback for a lighter implementation.

### Editor decision matrix

| Priority | Pick |
|---|---|
| Closest VS Code feel | Monaco Editor |
| Smaller and lighter viewer | CodeMirror 6 |
| Minimal component overhead | Monaco + Lit or direct DOM |
| Future diff support | Monaco Editor |

## Architecture

The UI should be modeled around a few simple domain objects so the product stays easy to extend.

### Suggested frontend modules

- `workspace`: project name, active branch, sidebar mode, status metadata.
- `fileTree`: nested folders/files, expanded nodes, selected file.
- `editorView`: current file path, content, detected language, editor options.
- `gitState`: changed files, staged files, branch details, commit summary.

This structure keeps the shell adaptable if the tool later becomes a front end for agent workflows, indexing, or repository inspection services.

## UI Shape

### Main layout

- Left sidebar, about 240 to 280 pixels wide.
- Top switcher for Files and Git.
- Large main panel for the editor.
- Optional thin header with project name and branch.
- Optional status bar for path, language, and repository state.

### V1 screens

| Surface | Content |
|---|---|
| Files view | Folder tree, changed markers, selected file highlight |
| Git view | Changed files, staged files, branch name, short repo status |
| Editor view | Read-only syntax-highlighted file content |
| Empty state | A simple prompt such as “Select a file to view.” |

## Styling Guidance

The interface should avoid generic component-library aesthetics and instead use a restrained workbench layout with strong alignment, small visual accents, and text-first navigation.

Practical styling recommendations:

- Use a dark and light theme from the start.
- Prefer subtle separators over heavy card borders.
- Keep icons secondary to labels in the sidebar.
- Avoid oversized buttons, rounded dashboard cards, or marketing-style gradients.
- Make the editor panel the dominant visual surface.

## Delivery Plan

### Phase 1: Static shell

- Build the app frame.
- Implement sidebar mode switch.
- Render a mock file tree.
- Render Monaco in read-only mode with sample files.

### Phase 2: Real state

- Load real file metadata.
- Connect file selection to editor contents.
- Add Git panel data.
- Add selected-file and changed-file visual states.

### Phase 3: Refinement

- Add resizing if needed.
- Add keyboard navigation.
- Add diff or commit-preview view if required.
- Add search/filter in the sidebar.

## Final Recommendation

The recommended v1 stack is TypeScript, Vite, Monaco Editor, Lucide icons, and either Lit or direct DOM rendering with custom styling.

This combination best matches the intended user experience: a familiar, minimal, read-only workspace viewer with room to grow into Git inspection, repository navigation, and future agent-oriented workflows.
