//! Layer 2: independent processes exercise the real writer on an isolated shared file.

use std::fmt;
use std::fs;
use std::io::{BufRead, BufReader, Write};
use std::os::unix::net::{UnixListener, UnixStream};
use std::path::{Path, PathBuf};
use std::process::{Child, Command, Stdio};
use std::sync::atomic::{AtomicBool, AtomicU64, Ordering};
use std::sync::{Arc, mpsc};
use std::thread;
use std::time::{Duration, Instant};

use ka_reader_bridge::log_writer::{FileLog, PRODUCTION_BOUND_BYTES};
use log::{Level, Log, Record};

const MESSAGE_CHARS: usize = 700_000;
const TIMEOUT: Duration = Duration::from_secs(15);
const CHILD_SOCKET: &str = "KA_READER_SHARED_LOG_TEST_SOCKET";
const CHILD_IDENTITY: &str = "KA_READER_SHARED_LOG_TEST_IDENTITY";
const CHILD_CASE: &str = "shared_log_participant";
static NEXT_ROOT: AtomicU64 = AtomicU64::new(0);

struct Scene {
    root: PathBuf,
    log: PathBuf,
}

impl Scene {
    fn new() -> Self {
        // A short root avoids SUN_LEN failures for Unix-socket pathnames:
        // https://doc.rust-lang.org/std/os/unix/net/struct.SocketAddr.html#method.from_pathname
        let root = Path::new("/tmp").join(format!(
            "ka-log-{}-{}",
            std::process::id(),
            NEXT_ROOT.fetch_add(1, Ordering::Relaxed)
        ));
        fs::create_dir(&root).expect("the isolated scene directory can be created");
        let log = root.join("shared.log");
        Self { root, log }
    }

    fn contents(&self) -> String {
        fs::read_to_string(&self.log).expect("the log is readable UTF-8")
    }

    fn size(&self, checkpoint: &str) -> u64 {
        let size = fs::metadata(&self.log).expect("the log exists").len();
        eprintln!("checkpoint {checkpoint}: {size} bytes");
        size
    }
}

impl Drop for Scene {
    fn drop(&mut self) {
        let _ = fs::remove_dir_all(&self.root);
    }
}

struct Participant {
    child: Child,
    channel: BufReader<UnixStream>,
    identity: &'static str,
    finished: bool,
}

impl Participant {
    fn start(scene: &Scene, identity: &'static str) -> Self {
        let socket = scene.root.join(identity);
        let listener = UnixListener::bind(&socket).expect("the private coordinator socket binds");
        listener
            .set_nonblocking(true)
            .expect("accept can be polled");
        let child = Command::new(std::env::current_exe().expect("the test executable is known"))
            .args(["--exact", CHILD_CASE, "--nocapture", "--quiet"])
            .env(CHILD_SOCKET, &socket)
            .env(CHILD_IDENTITY, identity)
            .stdout(Stdio::piped())
            .stderr(Stdio::piped())
            .spawn()
            .expect("the independent participant starts");
        let mut owned = PendingChild(Some(child));
        let deadline = Instant::now() + TIMEOUT;
        let stream = loop {
            match listener.accept() {
                Ok((stream, _)) => break stream,
                Err(error) if error.kind() == std::io::ErrorKind::WouldBlock => {
                    assert!(
                        Instant::now() < deadline,
                        "coordination: {identity} never connected"
                    );
                    thread::yield_now();
                }
                Err(error) => panic!("coordination: accept {identity}: {error}"),
            }
        };
        // Set the accepted stream's mode explicitly before relying on timed protocol reads:
        // https://doc.rust-lang.org/std/os/unix/net/struct.UnixStream.html#method.set_nonblocking
        stream
            .set_nonblocking(false)
            .expect("accepted coordinator stream is blocking");
        stream
            .set_read_timeout(Some(TIMEOUT))
            .expect("reads have a deadline");
        stream
            .set_write_timeout(Some(TIMEOUT))
            .expect("writes have a deadline");
        let mut participant = Self {
            child: owned.0.take().expect("the child is still owned"),
            channel: BufReader::new(stream),
            identity,
            finished: false,
        };
        let ready = participant.receive();
        assert_eq!(ready, format!("constructed {}", participant.child.id()));
        participant
    }

    fn send(&mut self, command: &str) {
        eprintln!("{}: send {command}", self.identity);
        writeln!(self.channel.get_mut(), "{command}").expect("coordination: command reaches child");
    }

    fn receive(&mut self) -> String {
        let mut line = String::new();
        let length = self
            .channel
            .read_line(&mut line)
            .expect("coordination: child responds before deadline");
        assert_ne!(
            length, 0,
            "coordination: {} closed its channel",
            self.identity
        );
        let response = line.trim_end().to_owned();
        eprintln!("{}: {response}", self.identity);
        response
    }

    fn expect(&mut self, expected: &str) {
        assert_eq!(self.receive(), expected, "coordination: {}", self.identity);
    }

    fn completed(&mut self) -> u64 {
        let response = self.receive();
        response
            .strip_prefix("done ")
            .expect("coordination: completion includes size")
            .parse()
            .expect("coordination: completed size is numeric")
    }

    fn write(&mut self, command: &str) -> u64 {
        self.send(command);
        self.completed()
    }

    fn finish(&mut self) {
        self.send("stop");
        self.expect("stopped");
        let deadline = Instant::now() + TIMEOUT;
        let status = loop {
            if let Some(status) = self.child.try_wait().expect("child exit can be read") {
                break status;
            }
            assert!(
                Instant::now() < deadline,
                "coordination: child did not exit"
            );
            thread::yield_now();
        };
        use std::io::Read;
        let mut stdout = String::new();
        let mut stderr = String::new();
        self.child
            .stdout
            .take()
            .expect("stdout is captured")
            .read_to_string(&mut stdout)
            .expect("stdout reads");
        self.child
            .stderr
            .take()
            .expect("stderr is captured")
            .read_to_string(&mut stderr)
            .expect("stderr reads");
        self.finished = true;
        assert!(status.success(), "child {status}: {stdout}\n{stderr}");
        assert!(stderr.is_empty(), "product stderr: {stderr}");
        for line in stdout.lines().filter(|line| !line.is_empty()) {
            assert!(
                line == "running 1 test"
                    || line == "."
                    || line.starts_with("test result: ok. 1 passed;"),
                "product stdout: {line}"
            );
        }
    }
}

impl Drop for Participant {
    fn drop(&mut self) {
        if !self.finished {
            let _ = self.child.kill();
            let _ = self.child.wait();
            use std::io::Read;
            let mut output = String::new();
            if let Some(mut stdout) = self.child.stdout.take() {
                let _ = stdout.read_to_string(&mut output);
            }
            if let Some(mut stderr) = self.child.stderr.take() {
                let _ = stderr.read_to_string(&mut output);
            }
            eprintln!("coordination: {} child output: {output}", self.identity);
        }
    }
}

struct PendingChild(Option<Child>);
impl Drop for PendingChild {
    fn drop(&mut self) {
        if let Some(child) = &mut self.0 {
            let _ = child.kill();
            let _ = child.wait();
        }
    }
}

fn admitted(writer: &FileLog, message: impl fmt::Display) {
    writer.log(
        &Record::builder()
            .args(format_args!("{message}"))
            .level(Level::Warn)
            .module_path(Some("ka_reader_core::fs_reader"))
            .build(),
    );
}

struct Rendezvous<'a> {
    channel: &'a mut BufReader<UnixStream>,
    message: &'a str,
}

// Display formats through &self, so the rendezvous borrows its channel through a test-only RefCell:
// https://doc.rust-lang.org/std/fmt/trait.Display.html
struct ControlledMessage<'a>(std::cell::RefCell<Rendezvous<'a>>);
impl fmt::Display for ControlledMessage<'_> {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        let mut rendezvous = self.0.borrow_mut();
        writeln!(rendezvous.channel.get_mut(), "entered")
            .expect("coordination: entry acknowledged");
        let mut release = String::new();
        rendezvous
            .channel
            .read_line(&mut release)
            .expect("coordination: formatter is released");
        assert_eq!(release, "release\n", "coordination: release command");
        formatter.write_str(rendezvous.message)
    }
}

#[test]
fn shared_log_participant() {
    let Some(socket) = std::env::var_os(CHILD_SOCKET) else {
        return;
    };
    let identity = std::env::var(CHILD_IDENTITY).expect("the coordinator provides identity");
    let socket = PathBuf::from(socket);
    let path = socket
        .parent()
        .expect("socket has a parent")
        .join("shared.log");
    let stream = UnixStream::connect(&socket).expect("the participant connects");
    stream
        .set_read_timeout(Some(TIMEOUT))
        .expect("reads time out");
    stream
        .set_write_timeout(Some(TIMEOUT))
        .expect("writes time out");
    let mut channel = BufReader::new(stream);
    let writer = FileLog::new(path.clone(), PRODUCTION_BOUND_BYTES);
    writeln!(channel.get_mut(), "constructed {}", std::process::id())
        .expect("construction acknowledged");
    loop {
        let mut command = String::new();
        assert_ne!(
            channel
                .read_line(&mut command)
                .expect("coordination: read command"),
            0
        );
        match command.trim_end() {
            "large" => admitted(&writer, identity.repeat(MESSAGE_CHARS)),
            "overlap" => {
                let message = identity.repeat(MESSAGE_CHARS);
                admitted(
                    &writer,
                    ControlledMessage(std::cell::RefCell::new(Rendezvous {
                        channel: &mut channel,
                        message: &message,
                    })),
                );
            }
            "small" => admitted(&writer, format!("follow-up-{identity}")),
            "old" => admitted(&writer, "before-relaunch"),
            "failed" => admitted(&writer, "failed-record-must-not-return"),
            "fresh" => admitted(&writer, "fresh-after-restoration"),
            "stop" => {
                writeln!(channel.get_mut(), "stopped").expect("stop acknowledged");
                return;
            }
            command => panic!("coordination: unknown command {command}"),
        }
        writeln!(
            channel.get_mut(),
            "done {}",
            fs::metadata(&path).expect("the target exists").len()
        )
        .expect("completion acknowledged");
    }
}

#[test]
fn shared_log_sequential_processes() {
    let scene = Scene::new();
    let mut first = Participant::start(&scene, "A");
    let mut second = Participant::start(&scene, "B");
    assert_ne!(first.child.id(), second.child.id());
    first.write("large");
    assert_eq!(
        scene.contents(),
        format!("WARN {}\n", "A".repeat(MESSAGE_CHARS))
    );
    assert_eq!(scene.size("A completed"), MESSAGE_CHARS as u64 + 6);
    second.write("large");
    let completed_size = scene.size("B completed");
    let completed = scene.contents();
    first.write("small");
    let followed = scene.contents();
    let followed_size = scene.size("later admitted append");
    first.finish();
    second.finish();
    assert!(
        completed_size <= PRODUCTION_BOUND_BYTES,
        "shared bound: {completed_size} > {PRODUCTION_BOUND_BYTES}"
    );
    assert_eq!(completed, format!("WARN {}\n", "B".repeat(MESSAGE_CHARS)));
    assert!(
        !completed.contains(&"A".repeat(MESSAGE_CHARS)),
        "superseded A is absent"
    );
    assert!(followed.contains("follow-up-A"));
    assert!(followed.contains(&"B".repeat(MESSAGE_CHARS)));
    assert!(followed_size <= PRODUCTION_BOUND_BYTES);
}

#[test]
fn shared_log_overlapping_processes() {
    let scene = Scene::new();
    let mut first = Participant::start(&scene, "A");
    let mut second = Participant::start(&scene, "B");
    assert_ne!(first.child.id(), second.child.id());
    assert!(MESSAGE_CHARS as u64 + 6 <= PRODUCTION_BOUND_BYTES);
    assert!(2 * (MESSAGE_CHARS as u64 + 6) > PRODUCTION_BOUND_BYTES);
    first.send("overlap");
    second.send("overlap");
    first.expect("entered");
    second.expect("entered");
    let before = scene.size("both admitted calls entered; neither released");
    let stop = Arc::new(AtomicBool::new(false));
    let (ready_sender, ready_receiver) = mpsc::channel();
    let path = scene.log.clone();
    let observer_stop = Arc::clone(&stop);
    let observer = thread::spawn(move || {
        let mut samples = 0;
        let mut maximum = 0;
        loop {
            maximum = maximum.max(
                fs::metadata(&path)
                    .expect("observer: file remains accessible")
                    .len(),
            );
            samples += 1;
            if samples == 1 {
                ready_sender.send(()).expect("observer ready");
            }
            if observer_stop.load(Ordering::Acquire) {
                return (samples, maximum);
            }
            thread::yield_now();
        }
    });
    let mut observer = SizeObserver {
        stop,
        thread: Some(observer),
    };
    ready_receiver
        .recv_timeout(TIMEOUT)
        .expect("observer completed its first sample");
    first.send("release");
    second.send("release");
    let first_returned = first.completed();
    let first_completed = scene.size("A completed");
    let second_returned = second.completed();
    let both_completed = scene.size("both completed");
    let cohort = scene.contents();
    let (samples, maximum) = observer.finish();
    eprintln!("observer: samples={samples}, maximum={maximum}");
    first.write("small");
    let first_followup = scene.contents();
    let first_followup_size = scene.size("A follow-up completed");
    second.write("small");
    let second_followup = scene.contents();
    let second_followup_size = scene.size("B follow-up completed");
    first.finish();
    second.finish();
    let maximum = maximum
        .max(before)
        .max(first_completed)
        .max(both_completed)
        .max(first_returned)
        .max(second_returned);
    assert!(
        maximum <= PRODUCTION_BOUND_BYTES,
        "shared bound: observed {maximum} > {PRODUCTION_BOUND_BYTES} in {samples} samples"
    );
    let first_line = format!("WARN {}\n", "A".repeat(MESSAGE_CHARS));
    let second_line = format!("WARN {}\n", "B".repeat(MESSAGE_CHARS));
    assert!(
        cohort == first_line || cohort == second_line,
        "one complete admitted cohort record remains"
    );
    assert_eq!(first_followup, format!("{cohort}WARN follow-up-A\n"));
    assert_eq!(
        second_followup,
        format!("{first_followup}WARN follow-up-B\n")
    );
    assert!(first_followup_size <= PRODUCTION_BOUND_BYTES);
    assert!(second_followup_size <= PRODUCTION_BOUND_BYTES);
}

struct SizeObserver {
    stop: Arc<AtomicBool>,
    thread: Option<thread::JoinHandle<(u64, u64)>>,
}
impl SizeObserver {
    fn finish(&mut self) -> (u64, u64) {
        self.stop.store(true, Ordering::Release);
        self.thread
            .take()
            .expect("observer has not finished")
            .join()
            .expect("observer sampled successfully")
    }
}
impl Drop for SizeObserver {
    fn drop(&mut self) {
        self.stop.store(true, Ordering::Release);
        if let Some(thread) = self.thread.take() {
            let _ = thread.join();
        }
    }
}

#[test]
fn shared_log_relaunch_allows_existing_writer_to_continue() {
    let scene = Scene::new();
    let mut first = Participant::start(&scene, "A");
    first.write("old");
    assert!(scene.contents().contains("before-relaunch"));
    let mut second = Participant::start(&scene, "B");
    assert_eq!(scene.contents(), "");
    first.write("small");
    assert_eq!(scene.contents(), "WARN follow-up-A\n");
    assert!(scene.size("existing writer after relaunch") <= PRODUCTION_BOUND_BYTES);
    first.finish();
    second.finish();
}

#[test]
fn shared_log_failed_operation_is_silent_and_not_replayed() {
    for blocked_at_construction in [false, true] {
        let scene = Scene::new();
        if blocked_at_construction {
            fs::create_dir(&scene.log).expect("the constructor sees a non-file target");
        }
        let mut writer = Participant::start(&scene, "A");
        if !blocked_at_construction {
            fs::remove_file(&scene.log)
                .expect("the unlocked file can be removed for the failure scene");
            fs::create_dir(&scene.log).expect("a directory makes the log target unopenable");
        }
        writer.write("failed");
        assert_eq!(
            fs::read_dir(&scene.log)
                .expect("the target stays a directory")
                .count(),
            0
        );
        fs::remove_dir(&scene.log).expect("access can be restored");
        writer.write("fresh");
        assert_eq!(scene.contents(), "WARN fresh-after-restoration\n");
        assert!(!scene.contents().contains("failed-record"));
        writer.finish();
    }
}
