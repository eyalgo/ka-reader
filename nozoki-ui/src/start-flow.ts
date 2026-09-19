/**
 * The start flow and the root listing: what the window does when the app opens, and how a returned
 * entry becomes a row. It takes `invoke` as a parameter, never as an import, so a test drives it with
 * a fake and this module holds no `@tauri-apps/api` import (only `main.ts` does, QC-8).
 */

import { AppError } from "./app-error";
import { logger } from "./logger";

const OPEN_FOLDER = "open_folder";
const LIST_TREE = "list_tree";
/** The folder-relative path of the opened folder's own root, the form `list_tree` takes. */
const ROOT_PATH = "";

/** The host's command call, narrowed to what the flow uses. Tauri's `invoke` satisfies it. */
export type Invoke = (command: string, args?: Record<string, unknown>) => Promise<unknown>;

export type EntryKind = "folder" | "file" | "symlink";

/** One entry of a `list_tree` reply, in the shape the host serializes. */
export type WireEntry = {
  readonly name: string;
  readonly path: string;
  readonly kind: EntryKind;
};

export type IconKind = "folder" | "other";

/** What the window draws for one entry: an icon kind and a text label. */
export type ViewRow = {
  readonly icon: IconKind;
  readonly label: string;
};

/**
 * What the flow leaves the window to draw. There is no message field: a cancelled panel, a refused
 * command and a bad reply all end as no rows, and the window shows no sentence for any of them.
 */
export type StartOutcome = {
  readonly rows: readonly ViewRow[];
};

/** A host reply whose shape is not the one the command contract states. */
export class UnexpectedReplyError extends AppError {
  constructor(command: string) {
    super(`Unexpected reply from ${command}`);
    this.name = "UnexpectedReplyError";
  }
}

const NOTHING_LISTED: StartOutcome = { rows: [] };

function isEntryKind(value: unknown): value is EntryKind {
  return value === "folder" || value === "file" || value === "symlink";
}

function isOpenResult(value: unknown): value is { readonly opened: boolean } {
  return (
    typeof value === "object" &&
    value !== null &&
    "opened" in value &&
    typeof value.opened === "boolean"
  );
}

function isWireEntry(value: unknown): value is WireEntry {
  return (
    typeof value === "object" &&
    value !== null &&
    "name" in value &&
    typeof value.name === "string" &&
    "path" in value &&
    typeof value.path === "string" &&
    "kind" in value &&
    isEntryKind(value.kind)
  );
}

function isWireEntryList(value: unknown): value is readonly WireEntry[] {
  return Array.isArray(value) && value.every(isWireEntry);
}

/** Maps entries to rows, keeping every one, dot-named included, in the order received. */
export function toRows(entries: readonly WireEntry[]): readonly ViewRow[] {
  return entries.map((entry) => ({
    icon: entry.kind === "folder" ? "folder" : "other",
    label: entry.name,
  }));
}

/**
 * Calls `open_folder` exactly once, and when a folder was chosen lists its root with `list_tree`.
 * It never rejects: a cancelled panel is an ordinary outcome and returns no rows, and any failure
 * ends the flow with no rows and one `warn`, without presenting the panel a second time.
 */
export async function runStartFlow(invoke: Invoke): Promise<StartOutcome> {
  try {
    const openReply = await invoke(OPEN_FOLDER);
    if (!isOpenResult(openReply)) throw new UnexpectedReplyError(OPEN_FOLDER);
    if (!openReply.opened) return NOTHING_LISTED;

    const listReply = await invoke(LIST_TREE, { path: ROOT_PATH });
    if (!isWireEntryList(listReply)) throw new UnexpectedReplyError(LIST_TREE);
    return { rows: toRows(listReply) };
  } catch (failure) {
    // Not rethrown: a rejection here would reach main.ts as an unhandled one, and an empty window
    // is safe to leave, since it is what a cancelled panel shows too.
    logger.warn("the start flow ended without a listing", {
      reason: failure instanceof Error ? failure.message : String(failure),
    });
    return NOTHING_LISTED;
  }
}

/** Replaces `parent`'s children with one list of the rows. Text goes in as text, never as markup. */
export function renderRows(parent: Element, rows: readonly ViewRow[]): void {
  const document = parent.ownerDocument;
  const list = document.createElement("ul");
  list.className = "listing";
  for (const row of rows) {
    const item = document.createElement("li");
    item.className = "listing-row";
    const icon = document.createElement("span");
    icon.className = `listing-icon listing-icon-${row.icon}`;
    icon.setAttribute("aria-hidden", "true");
    const label = document.createElement("span");
    label.textContent = row.label;
    item.append(icon, label);
    list.append(item);
  }
  parent.replaceChildren(list);
}
