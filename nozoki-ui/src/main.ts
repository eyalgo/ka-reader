/**
 * The composition root. It wires the real `invoke` from `@tauri-apps/api/core`, the one place that
 * package is imported (QC-8), into the start flow, and draws the rows the flow returns.
 *
 * `index.html` loads this module, and `start()` runs once at module load: the Open panel appears,
 * and a chosen folder's root is listed.
 */

import { invoke } from "@tauri-apps/api/core";

import { renderRows, runStartFlow } from "./start-flow";

/** Runs the start flow with the host's `invoke` and draws what it returns into the page body. */
export async function start(): Promise<void> {
  const outcome = await runStartFlow(invoke);
  renderRows(document.body, outcome.rows);
}

await start();
