import Testing
@testable import GStreamer

@Suite("Pipeline Parse Tests")
struct PipelineParseTests {

    init() throws {
        try GStreamer.initialize()
    }

    @Test("Parse simple pipeline")
    func parseSimplePipeline() throws {
        let pipeline = try Pipeline(description: "videotestsrc ! fakesink")
        #expect(pipeline.getState() == .null)
    }

    @Test("Parse pipeline with named elements")
    func parseNamedElements() throws {
        let pipeline = try Pipeline(description: "videotestsrc name=src ! fakesink name=sink")

        let src = pipeline.element(named: "src")
        #expect(src != nil)
        #expect(src?.name == "src")

        let sink = pipeline.element(named: "sink")
        #expect(sink != nil)
        #expect(sink?.name == "sink")
    }

    @Test("Parse invalid pipeline fails")
    func parseInvalidPipeline() throws {
        #expect(throws: GStreamerError.self) {
            _ = try Pipeline(description: "this-is-not-a-valid-element !!!")
        }
    }

    @Test("Set pipeline state")
    func setPipelineState() throws {
        let pipeline = try Pipeline(description: "videotestsrc ! fakesink")

        let result = try pipeline.setState(.ready)
        #expect(result == .success || result == .async)

        // Give it time to transition
        let state = pipeline.getState(timeout: 1_000_000_000)
        #expect(state == .ready)

        try pipeline.stop()
    }

    @Test("Element not found returns nil")
    func elementNotFound() throws {
        let pipeline = try Pipeline(description: "videotestsrc ! fakesink")
        let element = pipeline.element(named: "nonexistent")
        #expect(element == nil)
    }
}
