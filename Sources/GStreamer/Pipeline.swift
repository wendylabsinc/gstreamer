import CGStreamer
import CGStreamerShim

/// A GStreamer pipeline.
public final class Pipeline: @unchecked Sendable {
    /// Pipeline state.
    public enum State: Sendable {
        case null
        case ready
        case paused
        case playing

        internal var gstState: GstState {
            switch self {
            case .null: return GST_STATE_NULL
            case .ready: return GST_STATE_READY
            case .paused: return GST_STATE_PAUSED
            case .playing: return GST_STATE_PLAYING
            }
        }

        internal init(gstState: GstState) {
            switch gstState {
            case GST_STATE_NULL: self = .null
            case GST_STATE_READY: self = .ready
            case GST_STATE_PAUSED: self = .paused
            case GST_STATE_PLAYING: self = .playing
            default: self = .null
            }
        }
    }

    /// The underlying GstElement pointer.
    internal let _element: UnsafeMutablePointer<GstElement>

    /// Cached bus instance.
    private var _bus: Bus?

    /// Create from a `gst-launch-1.0`-style pipeline string.
    /// - Parameter description: A GStreamer pipeline description (e.g., "videotestsrc ! autovideosink")
    /// - Throws: `GStreamerError.parsePipeline` if parsing fails.
    public init(_ description: String) throws {
        try GStreamer.ensureInitialized()

        var errorMessage: UnsafeMutablePointer<CChar>?
        guard let pipeline = swift_gst_parse_launch(description, &errorMessage) else {
            let message = errorMessage.map { String(cString: $0) } ?? "Unknown error"
            errorMessage.map { g_free($0) }
            throw GStreamerError.parsePipeline(message)
        }
        errorMessage.map { g_free($0) }
        self._element = pipeline
    }

    deinit {
        _ = swift_gst_element_set_state(_element, GST_STATE_NULL)
        swift_gst_object_unref(_element)
    }

    /// Start the pipeline (set to PLAYING state).
    public func play() throws {
        try setState(.playing)
    }

    /// Pause the pipeline.
    public func pause() throws {
        try setState(.paused)
    }

    /// Stop the pipeline (set to NULL state).
    public func stop() {
        _ = swift_gst_element_set_state(_element, GST_STATE_NULL)
    }

    /// Set the pipeline state.
    /// - Parameter state: The desired state.
    /// - Throws: `GStreamerError.stateChangeFailed` if the state change fails.
    public func setState(_ state: State) throws {
        let result = swift_gst_element_set_state(_element, state.gstState)
        if result == GST_STATE_CHANGE_FAILURE {
            throw GStreamerError.stateChangeFailed
        }
    }

    /// Get the current pipeline state.
    public func currentState() -> State {
        let state = swift_gst_element_get_state(_element, 0)
        return State(gstState: state)
    }

    /// Access to bus messages (EOS/errors/state changes).
    public var bus: Bus {
        if let existingBus = _bus {
            return existingBus
        }
        let gstBus = swift_gst_element_get_bus(_element)!
        let newBus = Bus(bus: gstBus)
        _bus = newBus
        return newBus
    }

    /// Find an element by `name=...` in the pipeline string.
    /// - Parameter name: The element name.
    /// - Returns: The element wrapper, or nil if not found.
    public func element(named name: String) -> Element? {
        guard let el = swift_gst_bin_get_by_name(_element, name) else {
            return nil
        }
        return Element(element: el)
    }

    /// Convenience for getting an appsink by name.
    /// - Parameter name: The appsink element name.
    /// - Returns: An AppSink wrapper.
    /// - Throws: `GStreamerError.elementNotFound` if not found.
    public func appSink(named name: String) throws -> AppSink {
        try AppSink(pipeline: self, name: name)
    }
}
