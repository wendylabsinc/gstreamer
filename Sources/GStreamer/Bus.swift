import CGStreamer
import CGStreamerShim

/// Messages received from the GStreamer bus.
public enum BusMessage: Sendable {
    case eos
    case error(message: String, debug: String?)
    case warning(message: String, debug: String?)
    case stateChanged(old: Pipeline.State, new: Pipeline.State)
    case element(name: String, fields: [String: String])
}

/// A GStreamer bus for receiving messages from a pipeline.
public final class Bus: @unchecked Sendable {
    /// Filter for bus messages.
    public struct Filter: OptionSet, Sendable {
        public let rawValue: UInt32
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }

        public static let error = Filter(rawValue: UInt32(bitPattern: GST_MESSAGE_ERROR.rawValue))
        public static let warning = Filter(rawValue: UInt32(bitPattern: GST_MESSAGE_WARNING.rawValue))
        public static let eos = Filter(rawValue: UInt32(bitPattern: GST_MESSAGE_EOS.rawValue))
        public static let stateChanged = Filter(rawValue: UInt32(bitPattern: GST_MESSAGE_STATE_CHANGED.rawValue))
        public static let element = Filter(rawValue: UInt32(bitPattern: GST_MESSAGE_ELEMENT.rawValue))

        internal var gstMessageType: GstMessageType {
            GstMessageType(rawValue: Int32(bitPattern: rawValue))
        }
    }

    /// The underlying GstBus pointer.
    internal let _bus: UnsafeMutablePointer<GstBus>

    internal init(bus: UnsafeMutablePointer<GstBus>) {
        self._bus = bus
    }

    deinit {
        swift_gst_object_unref(_bus)
    }

    /// Async stream of messages. Internally polls the bus (no GLib main loop required).
    /// - Parameter filter: Message types to receive. Defaults to error, eos, and stateChanged.
    /// - Returns: An AsyncStream of BusMessage values.
    public func messages(filter: Filter = [.error, .eos, .stateChanged]) -> AsyncStream<BusMessage> {
        AsyncStream { continuation in
            let task = Task.detached { [weak self] in
                guard let self else {
                    continuation.finish()
                    return
                }

                while !Task.isCancelled {
                    // Poll with 100ms timeout
                    if let msg = swift_gst_bus_timed_pop_filtered(
                        self._bus,
                        100_000_000, // 100ms in nanoseconds
                        filter.gstMessageType
                    ) {
                        if let busMessage = self.parseMessage(msg) {
                            continuation.yield(busMessage)

                            // Stop on EOS
                            if case .eos = busMessage {
                                swift_gst_message_unref(msg)
                                break
                            }
                        }
                        swift_gst_message_unref(msg)
                    }
                }

                continuation.finish()
            }

            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }

    /// Parse a GstMessage into a BusMessage.
    private func parseMessage(_ msg: UnsafeMutablePointer<GstMessage>) -> BusMessage? {
        let messageType = swift_gst_message_type(msg)

        switch messageType {
        case GST_MESSAGE_EOS:
            return .eos

        case GST_MESSAGE_ERROR:
            var errorString: UnsafeMutablePointer<CChar>?
            var debugString: UnsafeMutablePointer<CChar>?
            swift_gst_message_parse_error(msg, &errorString, &debugString)

            let message = errorString.map { String(cString: $0) } ?? "Unknown error"
            let debug = debugString.map { String(cString: $0) }

            errorString.map { g_free($0) }
            debugString.map { g_free($0) }

            return .error(message: message, debug: debug)

        case GST_MESSAGE_WARNING:
            var warningString: UnsafeMutablePointer<CChar>?
            var debugString: UnsafeMutablePointer<CChar>?
            swift_gst_message_parse_warning(msg, &warningString, &debugString)

            let message = warningString.map { String(cString: $0) } ?? "Unknown warning"
            let debug = debugString.map { String(cString: $0) }

            warningString.map { g_free($0) }
            debugString.map { g_free($0) }

            return .warning(message: message, debug: debug)

        case GST_MESSAGE_STATE_CHANGED:
            var oldState: GstState = GST_STATE_NULL
            var newState: GstState = GST_STATE_NULL
            var pendingState: GstState = GST_STATE_NULL
            swift_gst_message_parse_state_changed(msg, &oldState, &newState, &pendingState)
            return .stateChanged(
                old: Pipeline.State(gstState: oldState),
                new: Pipeline.State(gstState: newState)
            )

        case GST_MESSAGE_ELEMENT:
            // Simplified element message
            return .element(name: "element", fields: [:])

        default:
            return nil
        }
    }

    /// Pop a message from the bus (non-blocking). Low-level API.
    internal func pop() -> UnsafeMutablePointer<GstMessage>? {
        swift_gst_bus_pop(_bus)
    }

    /// Pop a message from the bus with timeout. Low-level API.
    internal func pop(timeout: UInt64) -> UnsafeMutablePointer<GstMessage>? {
        swift_gst_bus_timed_pop(_bus, timeout)
    }

    /// Pop a message from the bus filtered by type. Low-level API.
    internal func pop(timeout: UInt64, filter: Filter) -> UnsafeMutablePointer<GstMessage>? {
        swift_gst_bus_timed_pop_filtered(_bus, timeout, filter.gstMessageType)
    }
}
