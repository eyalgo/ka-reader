#[cfg(test)]
mod tests {
    //! Layer 1: the install guard and the container path as pure functions. Nothing here installs a
    //! logger: `set_logger` in a test binary is what `test_install_sets_the_facade_to_warn` owns.

    use std::path::{Path, PathBuf};

    use super::{container_path, home_directory, should_install};
    use crate::log_writer::log_path_below;

    #[test]
    fn test_app_bundle_executable_with_container_installs() {
        let executable = Path::new("/Applications/Nozoki.app/Contents/MacOS/Nozoki");

        assert!(should_install(executable, true));
    }

    #[test]
    fn test_cargo_test_binary_does_not_install() {
        let executable = Path::new("/work/target/debug/deps/nozoki_bridge-0123456789abcdef");

        assert!(!should_install(executable, true));
    }

    #[test]
    fn test_xctest_bundle_does_not_install() {
        let executable = Path::new(
            "/work/.build/debug/nozoki-macPackageTests.xctest/Contents/MacOS/nozoki-macPackageTests",
        );

        assert!(!should_install(executable, true));
    }

    #[test]
    fn test_missing_container_does_not_install() {
        let executable = Path::new("/Applications/Nozoki.app/Contents/MacOS/Nozoki");

        assert!(
            !should_install(executable, false),
            "the bridge never creates a container"
        );
    }

    #[test]
    fn test_app_path_not_under_contents_macos_does_not_install() {
        assert!(!should_install(Path::new("/x/Nozoki.app/Nozoki"), true));
    }

    #[test]
    fn test_container_path_is_c_i2s() {
        let home = Path::new("/Users/someone");

        let container = container_path(home);

        assert_eq!(
            container,
            PathBuf::from("/Users/someone/Library/Containers/com.kensaiapp.nozoki/Data")
        );
        assert_eq!(
            log_path_below(&container),
            PathBuf::from(
                "/Users/someone/Library/Containers/com.kensaiapp.nozoki/Data/Library/Logs/nozoki.log"
            )
        );
    }

    #[test]
    fn test_home_directory_is_an_absolute_path_from_the_password_database() {
        let home = home_directory().expect("the current user has a password-database entry");

        assert!(home.is_absolute(), "{home:?}");
    }
}
