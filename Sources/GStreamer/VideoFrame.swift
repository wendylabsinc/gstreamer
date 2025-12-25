import CGStreamer
import CGStreamerShim

/// A video frame with access to pixel data.
/// Use `withMappedBytes` to safely access the underlying buffer data.
/// The closure-based pattern ensures the raw bytes cannot escape.
public struct VideoFrame: @unchecked Sendable {
    /// The width of the frame in pixels.
    public let width: Int

    /// The height of the frame in pixels.
    public let height: Int

    /// The pixel format of the frame.
    public let format: PixelFormat

    /// Storage class to manage the buffer lifecycle.
    private final class Storage: @unchecked Sendable {
        let buffer: UnsafeMutablePointer<GstBuffer>
        let ownsReference: Bool

        init(buffer: UnsafeMutablePointer<GstBuffer>, ownsReference: Bool) {
            self.buffer = buffer
            self.ownsReference = ownsReference
        }

        deinit {
            if ownsReference {
                swift_gst_buffer_unref(buffer)
            }
        }
    }

    private let storage: Storage

    /// Create a VideoFrame from a GstBuffer and video info.
    internal init(
        buffer: UnsafeMutablePointer<GstBuffer>,
        width: Int,
        height: Int,
        format: PixelFormat,
        ownsReference: Bool
    ) {
        self.storage = Storage(buffer: buffer, ownsReference: ownsReference)
        self.width = width
        self.height = height
        self.format = format
    }

    /// Access the buffer data for reading using a safe, non-escaping span.
    /// - Parameter body: A closure that receives a RawSpan to the buffer data.
    /// - Returns: The result of the closure.
    /// - Throws: `GStreamerError.bufferMapFailed` if mapping fails, or rethrows from body.
    public func withMappedBytes<R>(_ body: (RawSpan) throws -> R) throws -> R {
        var mapInfo = GstMapInfo()
        guard swift_gst_buffer_map_read(storage.buffer, &mapInfo) != 0 else {
            throw GStreamerError.bufferMapFailed
        }
        defer {
            swift_gst_buffer_unmap(storage.buffer, &mapInfo)
        }

        let span = RawSpan(_unsafeStart: mapInfo.data, byteCount: Int(mapInfo.size))
        return try body(span)
    }
}
