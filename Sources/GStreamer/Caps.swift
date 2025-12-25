import CGStreamer
import CGStreamerShim

/// GStreamer capabilities (media type description).
public struct Caps: Sendable, CustomStringConvertible {
    /// The underlying GstCaps pointer wrapped in a reference type for memory management.
    private let storage: Storage

    /// Reference type to handle GstCaps memory management.
    private final class Storage: @unchecked Sendable {
        let caps: UnsafeMutablePointer<GstCaps>
        let ownsReference: Bool

        init(caps: UnsafeMutablePointer<GstCaps>, ownsReference: Bool) {
            self.caps = caps
            self.ownsReference = ownsReference
        }

        deinit {
            if ownsReference {
                swift_gst_caps_unref(caps)
            }
        }
    }

    /// The underlying GstCaps pointer.
    internal var caps: UnsafeMutablePointer<GstCaps> {
        storage.caps
    }

    /// Create caps from a string description.
    /// - Parameter description: The caps string (e.g., "video/x-raw,format=RGB,width=640,height=480")
    /// - Throws: `GStreamerError.capsParseFailed` if the string is invalid.
    public init(_ description: String) throws {
        guard let caps = swift_gst_caps_from_string(description) else {
            throw GStreamerError.capsParseFailed(description)
        }
        self.storage = Storage(caps: caps, ownsReference: true)
    }

    /// Create a wrapper from an existing GstCaps pointer.
    /// - Parameters:
    ///   - caps: The GstCaps pointer.
    ///   - ownsReference: Whether to take ownership of the reference.
    internal init(caps: UnsafeMutablePointer<GstCaps>, ownsReference: Bool = true) {
        self.storage = Storage(caps: caps, ownsReference: ownsReference)
    }

    /// Convert caps to string representation.
    public var description: String {
        guard let cString = swift_gst_caps_to_string(caps) else {
            return ""
        }
        defer { g_free(cString) }
        return String(cString: cString)
    }
}
