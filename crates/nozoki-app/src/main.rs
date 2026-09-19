//! The composition root: the Open panel, the two command handlers, the session in managed state,
//! and the log writer's install. Nothing here holds logic — every operation delegates to
//! `nozoki_app::commands` (which delegates to `nozoki-core`).

use nozoki_app::commands::{EntryDto, OpenResult, Session};
use nozoki_app::log_writer;
use tauri::{Manager, State};

/// Presents the Open panel and opens what it returns. It takes no argument: no string from the
/// renderer can name a folder (CP-23). It never presents the panel a second time.
///
/// `async` here selects Tauri's thread pool for a plain `fn`. A command without it runs on the
/// main thread (https://v2.tauri.app/develop/calling-rust/), and `rfd` dispatches the panel onto
/// the main thread itself in a windowed app (`rfd-0.17.2/src/lib.rs:L79-L86`), so waiting for it
/// from a pool thread leaves the main thread free to run it.
#[tauri::command(async)]
fn open_folder(session: State<'_, Session>) -> OpenResult {
    session.open(rfd::FileDialog::new().pick_folder())
}

/// Lists one folder of the opened folder, given a path relative to its root.
#[tauri::command]
fn list_tree(session: State<'_, Session>, path: String) -> Vec<EntryDto> {
    session.list(&path)
}

fn main() -> tauri::Result<()> {
    tauri::Builder::default()
        .manage(Session::default())
        .setup(|app| {
            // The home directory, not `app_log_dir`, which appends the bundle identifier: in the
            // sandbox the home directory is already the container's `Data` folder. A failure to
            // resolve or install is swallowed like every other log failure (CP-32).
            if let Ok(home) = app.path().home_dir() {
                log_writer::install(&home).ok();
            }
            Ok(())
        })
        .invoke_handler(tauri::generate_handler![open_folder, list_tree])
        .run(tauri::generate_context!())
}
