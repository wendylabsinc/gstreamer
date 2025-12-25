import CGStreamer
import CGStreamerShim

/// A GStreamer element wrapper.
public final class Element: @unchecked Sendable {
    /// The underlying GstElement pointer.
    internal let element: UnsafeMutablePointer<GstElement>

    /// Whether this element owns the reference (should unref on deinit).
    private let ownsReference: Bool

    internal init(element: UnsafeMutablePointer<GstElement>, ownsReference: Bool = true) {
        self.element = element
        self.ownsReference = ownsReference
    }

    deinit {
        if ownsReference {
            swift_gst_object_unref(element)
        }
    }

    /// The element name.
    public var name: String {
        guard let cName = swift_gst_element_get_name(element) else {
            return ""
        }
        defer { g_free(cName) }
        return String(cString: cName)
    }

    /// Set a boolean property on this element.
    /// - Parameters:
    ///   - key: The property name.
    ///   - value: The boolean value.
    public func set(_ key: String, _ value: Bool) {
        swift_gst_element_set_bool(element, key, value ? 1 : 0)
    }

    /// Set an integer property on this element.
    /// - Parameters:
    ///   - key: The property name.
    ///   - value: The integer value.
    public func set(_ key: String, _ value: Int) {
        swift_gst_element_set_int(element, key, Int32(value))
    }

    /// Set a string property on this element.
    /// - Parameters:
    ///   - key: The property name.
    ///   - value: The string value.
    public func set(_ key: String, _ value: String) {
        swift_gst_element_set_string(element, key, value)
    }
}
