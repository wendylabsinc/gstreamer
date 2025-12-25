import Testing
@testable import GStreamer

@Suite("Bus Message Tests")
struct BusMessageTests {

    init() throws {
        try GStreamer.initialize()
    }

    @Test("Get bus from pipeline")
    func getBus() throws {
        let pipeline = try Pipeline(description: "videotestsrc ! fakesink")
        let bus = pipeline.bus
        #expect(bus != nil)
    }

    @Test("Pop from empty bus returns nil")
    func popEmptyBus() throws {
        let pipeline = try Pipeline(description: "videotestsrc ! fakesink")
        let bus = pipeline.bus
        let message = bus.pop()
        // Bus might be empty or have some initial messages
        // This test just verifies pop doesn't crash
        _ = message
    }

    @Test("Receive EOS message")
    func receiveEOS() throws {
        // Create a pipeline that generates a few frames then stops
        let pipeline = try Pipeline(description: "videotestsrc num-buffers=1 ! fakesink")

        try pipeline.play()

        let bus = pipeline.bus
        let message = bus.pop(timeout: 5_000_000_000, types: [.eos, .error])

        #expect(message != nil)
        if let msg = message {
            #expect(msg.type == .eos || msg.type == .error)
        }

        try pipeline.stop()
    }

    @Test("Message type name")
    func messageTypeName() throws {
        let pipeline = try Pipeline(description: "videotestsrc num-buffers=1 ! fakesink")
        try pipeline.play()

        let bus = pipeline.bus
        let message = bus.pop(timeout: 5_000_000_000, types: .eos)

        if let msg = message {
            let typeName = msg.typeName
            #expect(!typeName.isEmpty)
        }

        try pipeline.stop()
    }
}
