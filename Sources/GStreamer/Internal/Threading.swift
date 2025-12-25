import Foundation

/// Threading utilities for GStreamer operations.
internal enum Threading {
    /// A serial dispatch queue for GStreamer operations that must be serialized.
    static let gstreamerQueue = DispatchQueue(label: "com.swiftgstreamer.serial", qos: .userInitiated)

    /// Execute a block on the GStreamer queue synchronously.
    static func sync<T>(_ block: () throws -> T) rethrows -> T {
        try gstreamerQueue.sync(execute: block)
    }

    /// Execute a block on the GStreamer queue asynchronously.
    static func async(_ block: @escaping @Sendable () -> Void) {
        gstreamerQueue.async(execute: block)
    }
}
