/// Errors that can occur when working with GStreamer.
public enum GStreamerError: Error, Sendable, CustomStringConvertible {
    /// GStreamer has not been initialized. Call `GStreamer.initialize()` first.
    case notInitialized

    /// GStreamer initialization failed.
    case initializationFailed(String)

    /// Failed to parse pipeline description.
    case parsePipeline(String)

    /// Element not found in pipeline.
    case elementNotFound(String)

    /// Failed to change element state.
    case stateChangeFailed

    /// An error message was received from the bus.
    case busError(String)

    /// Failed to map buffer.
    case bufferMapFailed

    /// Failed to parse caps string.
    case capsParseFailed(String)

    public var description: String {
        switch self {
        case .notInitialized:
            return "GStreamer not initialized. Call GStreamer.initialize() first."
        case .initializationFailed(let reason):
            return "GStreamer initialization failed: \(reason)"
        case .parsePipeline(let message):
            return "Failed to parse pipeline: \(message)"
        case .elementNotFound(let name):
            return "Element not found: \(name)"
        case .stateChangeFailed:
            return "State change failed"
        case .busError(let message):
            return "Bus error: \(message)"
        case .bufferMapFailed:
            return "Failed to map buffer"
        case .capsParseFailed(let caps):
            return "Failed to parse caps: \(caps)"
        }
    }
}
