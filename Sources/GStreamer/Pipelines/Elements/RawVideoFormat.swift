public struct RawVideoFormat<VideoFrameOutput: VideoFrameProtocol>: VideoFormat {
    public let pipeline: String

    public init(
        width: Int,
        height: Int
    ) where VideoFrameOutput == VideoFrame {
        self.pipeline = "video/x-raw,width=\(width),height=\(height)"
    }

    public init<PixelLayout: PixelLayoutProtocol>(
        layout: PixelLayout.Type,
        framerate: String? = nil
    ) where VideoFrameOutput == _VideoFrame<PixelLayout> {
        var options = [
            "video/\(RawVideoFrameFormat<PixelLayout>.name)",
        ] + RawVideoFrameFormat<PixelLayout>.options + PixelLayout.options

        if let framerate {
            options.append("framerate=\(framerate)")
        }

        self.pipeline = options.joined(separator: ",")
    }
}