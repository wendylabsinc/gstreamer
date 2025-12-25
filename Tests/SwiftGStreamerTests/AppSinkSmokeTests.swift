import Testing
@testable import GStreamer

@Suite("AppSink Smoke Tests")
struct AppSinkSmokeTests {

    init() throws {
        try GStreamer.initialize()
    }

    @Test("Create AppSink from pipeline")
    func createAppSink() throws {
        let pipeline = try Pipeline(
            description: "videotestsrc ! appsink name=sink"
        )

        let appSink = try AppSink(pipeline: pipeline, name: "sink")
        #expect(appSink.element.name == "sink")
    }

    @Test("AppSink not found throws error")
    func appSinkNotFound() throws {
        let pipeline = try Pipeline(
            description: "videotestsrc ! fakesink"
        )

        #expect(throws: GStreamerError.self) {
            _ = try AppSink(pipeline: pipeline, name: "sink")
        }
    }

    @Test("Pull sample from AppSink")
    func pullSample() throws {
        let pipeline = try Pipeline(
            description: """
                videotestsrc num-buffers=5 ! \
                video/x-raw,format=RGB,width=320,height=240 ! \
                appsink name=sink
                """
        )

        let appSink = try AppSink(pipeline: pipeline, name: "sink")
        appSink.setEmitSignals(false)

        try pipeline.play()

        var frameCount = 0
        while frameCount < 3 {
            if let sample = appSink.tryPullSample(timeout: 1_000_000_000) {
                frameCount += 1
                let buffer = sample.buffer
                #expect(buffer != nil)
                if let buf = buffer {
                    #expect(buf.size > 0)
                }
            } else if appSink.isEOS {
                break
            }
        }

        #expect(frameCount > 0)
        try pipeline.stop()
    }

    @Test("Configure AppSink properties")
    func configureAppSink() throws {
        let pipeline = try Pipeline(
            description: "videotestsrc ! appsink name=sink"
        )

        let appSink = try AppSink(pipeline: pipeline, name: "sink")

        // These should not throw
        appSink.setEmitSignals(false)
        appSink.setMaxBuffers(10)
        appSink.setDrop(true)
    }
}
