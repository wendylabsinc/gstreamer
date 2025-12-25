import CGStreamer
import CGStreamerShim
import Synchronization

/// Main GStreamer interface for initialization and version information.
public enum GStreamer {

    /// Configuration for GStreamer initialization.
    public struct Configuration: Sendable {
        /// Optional: if you want to scan plugin folders yourself after init.
        /// (Many deployments just set GST_PLUGIN_PATH before startup.)
        public var pluginPaths: [String] = []

        /// If true, we'll call `gst_init()` automatically on first use.
        public var lazyInitialize: Bool = false

        public init() {}
    }

    /// Thread-safe state tracking using Mutex.
    private static let state = Mutex<InitState>(.notInitialized)

    private enum InitState {
        case notInitialized
        case initialized
        case lazyPending(Configuration)
    }

    /// Must be called once per process before using any pipelines.
    /// - Parameter config: Configuration options for GStreamer initialization.
    /// - Throws: `GStreamerError.initializationFailed` if initialization fails.
    public static func initialize(_ config: Configuration = .init()) throws {
        try state.withLock { initState in
            switch initState {
            case .initialized:
                return // Already initialized
            case .lazyPending:
                return // Already configured for lazy init
            case .notInitialized:
                break
            }

            if config.lazyInitialize {
                initState = .lazyPending(config)
                return
            }

            try performInitialization(config)
            initState = .initialized
        }
    }

    /// Ensures GStreamer is initialized (for lazy initialization support).
    internal static func ensureInitialized() throws {
        try state.withLock { initState in
            switch initState {
            case .initialized:
                return
            case .lazyPending(let config):
                try performInitialization(config)
                initState = .initialized
            case .notInitialized:
                throw GStreamerError.notInitialized
            }
        }
    }

    private static func performInitialization(_ config: Configuration) throws {
        // Set plugin paths if provided
        for path in config.pluginPaths {
            setenv("GST_PLUGIN_PATH", path, 0) // 0 = don't overwrite if exists
        }

        guard swift_gst_init() != 0 else {
            throw GStreamerError.initializationFailed("gst_init_check failed")
        }
    }

    /// Whether GStreamer is currently initialized.
    public static var isInitialized: Bool {
        state.withLock { initState in
            if case .initialized = initState {
                return true
            }
            return false
        }
    }

    /// Get the GStreamer version as a formatted string (e.g., "1.24.6").
    public static var versionString: String {
        guard let cString = swift_gst_version_string() else {
            return "Unknown"
        }
        defer { g_free(cString) }
        // Extract just the version number from "GStreamer 1.x.y"
        let full = String(cString: cString)
        if let range = full.range(of: "GStreamer ") {
            return String(full[range.upperBound...])
        }
        return full
    }

    /// GStreamer version components.
    public struct Version: Sendable, CustomStringConvertible {
        public let major: UInt
        public let minor: UInt
        public let micro: UInt
        public let nano: UInt

        public var description: String {
            if nano > 0 {
                return "\(major).\(minor).\(micro).\(nano)"
            }
            return "\(major).\(minor).\(micro)"
        }
    }

    /// Get the GStreamer version components.
    public static var version: Version {
        Version(
            major: UInt(swift_gst_version_major()),
            minor: UInt(swift_gst_version_minor()),
            micro: UInt(swift_gst_version_micro()),
            nano: UInt(swift_gst_version_nano())
        )
    }
}
