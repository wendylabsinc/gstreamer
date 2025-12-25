// swift-tools-version:6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GStreamer",
    platforms: [
        .macOS("26.0"),
        .iOS("26.0"),
        .tvOS("26.0"),
        .watchOS("26.0"),
        .visionOS("26.0"),
    ],
    products: [
        .library(
            name: "GStreamer",
            targets: ["GStreamer"]
        ),
    ],
    targets: [
        // MARK: - System Libraries

        .systemLibrary(
            name: "CGStreamer",
            pkgConfig: "gstreamer-1.0",
            providers: [
                .brew(["gstreamer"]),
                .apt(["libgstreamer1.0-dev"]),
            ]
        ),

        .systemLibrary(
            name: "CGStreamerApp",
            pkgConfig: "gstreamer-app-1.0",
            providers: [
                .brew(["gstreamer"]),
                .apt(["libgstreamer-plugins-base1.0-dev"]),
            ]
        ),

        .systemLibrary(
            name: "CGStreamerVideo",
            pkgConfig: "gstreamer-video-1.0",
            providers: [
                .brew(["gstreamer"]),
                .apt(["libgstreamer-plugins-base1.0-dev"]),
            ]
        ),

        // MARK: - C Shim Layer

        .target(
            name: "CGStreamerShim",
            dependencies: ["CGStreamer", "CGStreamerApp", "CGStreamerVideo"],
            path: "Sources/CGStreamerShim",
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("include"),
            ]
        ),

        // MARK: - Swift API

        .target(
            name: "GStreamer",
            dependencies: ["CGStreamer", "CGStreamerApp", "CGStreamerVideo", "CGStreamerShim"],
            path: "Sources/GStreamer"
        ),

        // MARK: - Examples

        .executableTarget(
            name: "gst-play",
            dependencies: ["GStreamer"],
            path: "Examples/gst-play"
        ),

        .executableTarget(
            name: "gst-appsink",
            dependencies: ["GStreamer"],
            path: "Examples/gst-appsink"
        ),

        // MARK: - Tests

        .testTarget(
            name: "GStreamerTests",
            dependencies: ["GStreamer"],
            path: "Tests/SwiftGStreamerTests"
        ),
    ]
)
