public protocol PixelLayoutProtocol: Sendable {
    static var name: String { get }
    static var options: [String] { get }
}

public enum RGBA<
    let width: Int,
    let height: Int
>: PixelLayoutProtocol {
    public static var name: String { "RGBA" }
    public static var options: [String] { [
        "width=\(width)",
        "height=\(height)",
    ] }
}
public enum BGRA<
    let width: Int,
    let height: Int
>: PixelLayoutProtocol {
    public static var name: String { "BGRA" }
    public static var options: [String] { [
        "width=\(width)",
        "height=\(height)",
    ] }
}
public enum NV12<
    let width: Int,
    let height: Int
>: PixelLayoutProtocol {
    public static var name: String { "NV12" }
    public static var options: [String] { [
        "width=\(width)",
        "height=\(height)",
    ] }
}
public enum I420<
    let width: Int,
    let height: Int
>: PixelLayoutProtocol {
    public static var name: String { "I420" }
    public static var options: [String] { [
        "width=\(width)",
        "height=\(height)",
    ] }
}
public enum GRAY8<
    let width: Int,
    let height: Int
>: PixelLayoutProtocol {
    public static var name: String { "GRAY8" }
    public static var options: [String] { [
        "width=\(width)",
        "height=\(height)",
    ] }
}