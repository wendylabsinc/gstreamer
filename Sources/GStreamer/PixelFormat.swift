/// Video pixel formats supported by GStreamer.
public enum PixelFormat: Sendable, Equatable {
    case bgra
    case rgba
    case nv12
    case i420
    case gray8
    case unknown(String)

    /// Initialize from a string representation.
    public init(string: String) {
        switch string.uppercased() {
        case "BGRA": self = .bgra
        case "RGBA": self = .rgba
        case "NV12": self = .nv12
        case "I420": self = .i420
        case "GRAY8": self = .gray8
        default: self = .unknown(string)
        }
    }

    /// The GStreamer format string.
    public var formatString: String {
        switch self {
        case .bgra: return "BGRA"
        case .rgba: return "RGBA"
        case .nv12: return "NV12"
        case .i420: return "I420"
        case .gray8: return "GRAY8"
        case .unknown(let s): return s
        }
    }

    /// The number of bytes per pixel for this format (for packed formats).
    public var bytesPerPixel: Int {
        switch self {
        case .bgra, .rgba: return 4
        case .gray8: return 1
        case .nv12, .i420: return 1 // Planar format - this is per-plane for Y
        case .unknown: return 0
        }
    }
}
