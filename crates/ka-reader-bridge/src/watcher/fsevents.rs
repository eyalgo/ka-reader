//! The one native binding: macOS FSEvents, written by hand.

#[cfg(test)]
mod tests {
    use std::os::unix::ffi::OsStrExt;
    use std::path::{Path, PathBuf};

    use super::{batch_from, report_for};

    const ROOT: &str = "/granted/root";
    /// The `FSEventStreamEventFlag` words that say the stream cannot vouch for what changed.
    const UNCERTAIN_FLAGS: [(&str, u32); 5] = [
        ("must scan subdirectories", 0x0000_0001),
        ("user dropped", 0x0000_0002),
        ("kernel dropped", 0x0000_0004),
        ("event ids wrapped", 0x0000_0008),
        ("root changed", 0x0000_0020),
    ];
    /// `ItemCreated | ItemIsFile`, an ordinary file event.
    const ORDINARY_FLAGS: u32 = 0x0000_0100 | 0x0001_0000;

    #[test]
    fn test_each_uncertain_flag_maps_to_the_granted_root() {
        for (name, flag) in UNCERTAIN_FLAGS {
            assert_eq!(
                report_for(b"/granted/root/a/b.txt", flag, Path::new(ROOT)),
                PathBuf::from(ROOT),
                "{name}"
            );
        }
    }

    #[test]
    fn test_an_ordinary_flag_keeps_the_path() {
        assert_eq!(
            report_for(b"/granted/root/a/b.txt", ORDINARY_FLAGS, Path::new(ROOT)),
            PathBuf::from("/granted/root/a/b.txt")
        );
    }

    #[test]
    fn test_a_non_utf8_path_survives_as_bytes() {
        let bytes: &[u8] = b"/granted/root/caf\xE9.txt";

        let reported = report_for(bytes, ORDINARY_FLAGS, Path::new(ROOT));

        assert_eq!(reported.as_os_str().as_bytes(), bytes);
    }

    #[test]
    fn test_a_batch_names_each_path_once_in_the_order_first_seen() {
        let entries: [(&[u8], u32); 4] = [
            (b"/granted/root/b.txt", ORDINARY_FLAGS),
            (b"/granted/root/a.txt", ORDINARY_FLAGS),
            (b"/granted/root/b.txt", ORDINARY_FLAGS),
            (b"/granted/root/c.txt", UNCERTAIN_FLAGS[1].1),
        ];

        let batch = batch_from(entries, Path::new(ROOT));

        assert_eq!(
            batch,
            vec![
                PathBuf::from("/granted/root/b.txt"),
                PathBuf::from("/granted/root/a.txt"),
                PathBuf::from(ROOT),
            ]
        );
    }
}
