//! The libgit2 adapter of the Git port. Every Git read and the binding itself live in this file.

use std::path::Path;

use super::{GitPort, RootFinding};

/// The port's one adapter, linked against the libgit2 compiled into the crate.
///
/// The type is named here so a caller can wire it, and a caller never constructs it in shipped
/// source: only the composition root does.
///
/// # Examples
///
/// ```
/// use nozoki_core::{GitPort, Libgit2};
///
/// fn assert_port<T: GitPort>() {}
/// assert_port::<Libgit2>();
/// ```
pub struct Libgit2;

impl GitPort for Libgit2 {
    fn probe(&self, _folder: &Path) -> RootFinding {
        unimplemented!("the probe is written in the green commit")
    }
}

#[cfg(test)]
mod tests {
    #[test]
    fn test_linked_library_is_vendored_without_https_or_ssh() {
        let version = git2::Version::get();

        assert!(version.vendored(), "libgit2 is the copy compiled in");
        assert!(!version.https(), "HTTPS is off");
        assert!(!version.ssh(), "SSH is off");
    }
}
