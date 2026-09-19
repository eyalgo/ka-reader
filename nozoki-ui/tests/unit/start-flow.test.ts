/**
 * Layer 1 for the start flow: the flow takes `invoke` as a parameter, so a fake stands in for the
 * host and nothing here needs Tauri or a DOM. The DOM rendering is a thin function over the rows and
 * is checked by the launched walk, not here.
 */

import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

import { runStartFlow, toRows, type Invoke, type WireEntry } from "../../src/start-flow";

type Call = { readonly command: string; readonly args: Record<string, unknown> | undefined };

/** A fake host: records every call in order, answers each command from `replies`. */
function fakeHost(replies: Record<string, () => Promise<unknown>>): {
  readonly invoke: Invoke;
  readonly calls: Call[];
} {
  const calls: Call[] = [];
  const invoke: Invoke = (command, args) => {
    calls.push({ command, args });
    const reply = replies[command];
    if (reply === undefined) return Promise.reject(new Error(`no fake reply for ${command}`));
    return reply();
  };
  return { invoke, calls };
}

const ROOT_ENTRIES: readonly WireEntry[] = [
  { name: ".git", path: ".git", kind: "folder" },
  { name: ".env", path: ".env", kind: "file" },
  { name: "src", path: "src", kind: "folder" },
];

describe("runStartFlow", () => {
  let warn: ReturnType<typeof vi.spyOn>;

  beforeEach(() => {
    // A rejection or a bad reply is logged at warn; the console is the sink and stays quiet here.
    warn = vi.spyOn(console, "warn").mockImplementation(() => {});
  });

  afterEach(() => {
    warn.mockRestore();
  });

  it("opens once then lists the root when a folder is chosen", async () => {
    const { invoke, calls } = fakeHost({
      open_folder: () => Promise.resolve({ opened: true }),
      list_tree: () => Promise.resolve(ROOT_ENTRIES),
    });

    await runStartFlow(invoke);

    expect(calls).toEqual([
      { command: "open_folder", args: undefined },
      { command: "list_tree", args: { path: "" } },
    ]);
  });

  it("lists nothing and does not reopen when the panel is cancelled", async () => {
    const { invoke, calls } = fakeHost({
      open_folder: () => Promise.resolve({ opened: false }),
    });

    const outcome = await runStartFlow(invoke);

    expect(calls.map((call) => call.command)).toEqual(["open_folder"]);
    // `toEqual` on the whole outcome: a `message` field, however empty, would fail it.
    expect(outcome).toEqual({ rows: [] });
    expect(warn).not.toHaveBeenCalled();
  });

  it("lists nothing and does not reopen when open_folder rejects", async () => {
    const { invoke, calls } = fakeHost({
      open_folder: () => Promise.reject(new Error("command refused")),
    });

    const outcome = await runStartFlow(invoke);

    expect(calls.map((call) => call.command)).toEqual(["open_folder"]);
    expect(outcome).toEqual({ rows: [] });
  });

  it("lists nothing and does not reopen when list_tree rejects", async () => {
    const { invoke, calls } = fakeHost({
      open_folder: () => Promise.resolve({ opened: true }),
      list_tree: () => Promise.reject("a plain string, as Tauri rejects"),
    });

    const outcome = await runStartFlow(invoke);

    expect(calls.map((call) => call.command)).toEqual(["open_folder", "list_tree"]);
    expect(outcome).toEqual({ rows: [] });
  });

  it("logs a rejection once at warn", async () => {
    const { invoke } = fakeHost({
      open_folder: () => Promise.reject(new Error("command refused")),
    });

    await runStartFlow(invoke);

    expect(warn).toHaveBeenCalledTimes(1);
  });

  it("lists nothing when open_folder answers with something that is not an open result", async () => {
    const { invoke, calls } = fakeHost({
      open_folder: () => Promise.resolve({ opened: "yes" }),
    });

    const outcome = await runStartFlow(invoke);

    expect(calls.map((call) => call.command)).toEqual(["open_folder"]);
    expect(outcome).toEqual({ rows: [] });
    expect(warn).toHaveBeenCalledTimes(1);
  });

  it("lists nothing when list_tree answers with something that is not an entry array", async () => {
    const notEntries = [
      { name: "src", path: "src", kind: "socket" },
      { name: "src", path: "src" },
      "src",
    ];
    for (const reply of [{ entries: [] }, null, ...notEntries.map((entry) => [entry])]) {
      const { invoke } = fakeHost({
        open_folder: () => Promise.resolve({ opened: true }),
        list_tree: () => Promise.resolve(reply),
      });

      expect(await runStartFlow(invoke)).toEqual({ rows: [] });
    }
  });

  it("returns the mapped rows of the root listing when a folder is chosen", async () => {
    const { invoke } = fakeHost({
      open_folder: () => Promise.resolve({ opened: true }),
      list_tree: () => Promise.resolve(ROOT_ENTRIES),
    });

    const outcome = await runStartFlow(invoke);

    expect(outcome).toEqual({ rows: toRows(ROOT_ENTRIES) });
    expect(outcome.rows).toHaveLength(3);
  });
});

describe("toRows", () => {
  it("maps each entry to an icon kind and a name label", () => {
    const rows = toRows([
      { name: "src", path: "src", kind: "folder" },
      { name: "notes.txt", path: "notes.txt", kind: "file" },
      { name: "outside-link", path: "outside-link", kind: "symlink" },
    ]);

    expect(rows).toEqual([
      { icon: "folder", label: "src" },
      { icon: "other", label: "notes.txt" },
      { icon: "other", label: "outside-link" },
    ]);
  });

  it("labels a nested entry by its name, not its path", () => {
    expect(toRows([{ name: "deep.rs", path: "src/deep.rs", kind: "file" }])).toEqual([
      { icon: "other", label: "deep.rs" },
    ]);
  });

  it("keeps every entry including dot-named ones in the order received", () => {
    const rows = toRows(ROOT_ENTRIES);

    expect(rows.map((row) => row.label)).toEqual([".git", ".env", "src"]);
  });

  it("maps an empty listing to no rows", () => {
    expect(toRows([])).toEqual([]);
  });
});
