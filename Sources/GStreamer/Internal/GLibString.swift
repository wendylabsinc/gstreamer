import CGStreamer

/// Helper utilities for working with GLib strings.
internal enum GLibString {
    /// Convert a GLib string to a Swift String, freeing the GLib string.
    /// - Parameter gString: The GLib string (will be freed).
    /// - Returns: A Swift String, or nil if the input was nil.
    static func takeOwnership(_ gString: UnsafeMutablePointer<CChar>?) -> String? {
        guard let gString else { return nil }
        defer { g_free(gString) }
        return String(cString: gString)
    }

    /// Convert a GLib string to a Swift String without freeing it.
    /// - Parameter gString: The GLib string (will not be freed).
    /// - Returns: A Swift String, or nil if the input was nil.
    static func borrow(_ gString: UnsafePointer<CChar>?) -> String? {
        guard let gString else { return nil }
        return String(cString: gString)
    }
}
