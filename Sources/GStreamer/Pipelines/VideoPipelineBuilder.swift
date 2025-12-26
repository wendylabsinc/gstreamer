@resultBuilder
public struct VideoPipelineBuilder: Sendable {
    /// Source step that provides each frame.
    public static func buildPartialBlock<Source: VideoPipelineSource>(
        first source: Source
    ) -> PartialPipeline<Source.VideoFrameOutput> {
        PartialPipeline(pipeline: source.pipeline)
    }

    /// Format step that transforms the frame type into a different format.
    public static func buildPartialBlock<
        Input: Sendable,
        Frame: VideoFrameProtocol
    >(
        accumulated: PartialPipeline<Input>, 
        next: some VideoFormat<Frame>
    ) -> PartialPipeline<Frame> {
        PartialPipeline(pipeline: accumulated.pipeline + " ! " + next.pipeline)
    }

    /// Convert step that transforms the frame type into a different format.
    public static func buildPartialBlock<
        Input: VideoFrameProtocol,
        Output: VideoFrameProtocol
    >(
        accumulated: PartialPipeline<Input>, 
        next: some VideoPipelineConvert<Input, Output>
    ) -> PartialPipeline<Output> {
        PartialPipeline(pipeline: accumulated.pipeline + " ! " + next.pipeline)
    }

    /// Sink that terminates the pipeline (e.g., OSXVideoSink)
    public static func buildPartialBlock<
        Input: VideoFrameProtocol,
        Sink: VideoSink<Input>
    >(
        accumulated: PartialPipeline<Input>, 
        next: Sink
    ) -> PartialPipeline<Never> where Sink.VideoFrameOutput == Never {
        PartialPipeline(pipeline: accumulated.pipeline + " ! " + next.pipeline)
    }

    // - MARK: Non-Generic Steps

    /// Overload for non-generic VideoPipelineConvert steps.
    /// VideoFrame is always a valid VideoFrameProtocol.
    @_disfavoredOverload
    public static func buildPartialBlock<
        Input: VideoFrameProtocol,
        Output: VideoFrameProtocol
    >(
        accumulated: PartialPipeline<Input>, 
        next: some VideoPipelineConvert<VideoFrame, Output>
    ) -> PartialPipeline<Output> {
        PartialPipeline(pipeline: accumulated.pipeline + " ! " + next.pipeline)
    }

    /// Sink that terminates the pipeline (e.g., OSXVideoSink)
    ///
    /// Overload for non-generic VideoSink steps.
    /// VideoFrame is always a valid VideoFrameProtocol.
    @_disfavoredOverload
    public static func buildPartialBlock<
        Input: VideoFrameProtocol,
        Sink: VideoSink<VideoFrame>
    >(
        accumulated: PartialPipeline<Input>, 
        next: Sink
    ) -> PartialPipeline<Never> where Sink.VideoFrameOutput == Never {
        PartialPipeline(pipeline: accumulated.pipeline + " ! " + next.pipeline)
    }
}

public protocol VideoPipelineElement: Sendable {
    var pipeline: String { get }
}

public protocol VideoPipelineSource: VideoPipelineElement {
    associatedtype VideoFrameOutput: VideoFrameProtocol
}

public protocol VideoPipelineConvert<VideoFrameInput, VideoFrameOutput>: VideoPipelineElement {
    associatedtype VideoFrameInput: VideoFrameProtocol
    associatedtype VideoFrameOutput: VideoFrameProtocol
}

public protocol VideoFormat<VideoFrameOutput>: VideoPipelineElement {
    associatedtype VideoFrameOutput: VideoFrameProtocol
}

public protocol VideoSink<VideoFrameInput>: VideoPipelineElement {
    associatedtype VideoFrameInput: VideoFrameProtocol
    associatedtype VideoFrameOutput: Sendable
}