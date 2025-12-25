#include "include/GStreamerAppShim.h"

// MARK: - AppSink

GstSample* swift_gst_app_sink_pull_sample(GstAppSink* appsink) {
    return gst_app_sink_pull_sample(appsink);
}

GstSample* swift_gst_app_sink_try_pull_sample(GstAppSink* appsink, GstClockTime timeout) {
    return gst_app_sink_try_pull_sample(appsink, timeout);
}

gboolean swift_gst_app_sink_is_eos(GstAppSink* appsink) {
    return gst_app_sink_is_eos(appsink);
}

void swift_gst_app_sink_set_caps(GstAppSink* appsink, GstCaps* caps) {
    gst_app_sink_set_caps(appsink, caps);
}

GstCaps* swift_gst_app_sink_get_caps(GstAppSink* appsink) {
    return gst_app_sink_get_caps(appsink);
}

void swift_gst_app_sink_set_emit_signals(GstAppSink* appsink, gboolean emit) {
    g_object_set(G_OBJECT(appsink), "emit-signals", emit, NULL);
}

void swift_gst_app_sink_set_max_buffers(GstAppSink* appsink, guint max) {
    g_object_set(G_OBJECT(appsink), "max-buffers", max, NULL);
}

void swift_gst_app_sink_set_drop(GstAppSink* appsink, gboolean drop) {
    g_object_set(G_OBJECT(appsink), "drop", drop, NULL);
}

// MARK: - AppSrc

GstFlowReturn swift_gst_app_src_push_buffer(GstAppSrc* appsrc, GstBuffer* buffer) {
    return gst_app_src_push_buffer(appsrc, buffer);
}

GstFlowReturn swift_gst_app_src_end_of_stream(GstAppSrc* appsrc) {
    return gst_app_src_end_of_stream(appsrc);
}

void swift_gst_app_src_set_caps(GstAppSrc* appsrc, GstCaps* caps) {
    gst_app_src_set_caps(appsrc, caps);
}

void swift_gst_app_src_set_stream_type(GstAppSrc* appsrc, GstAppStreamType type) {
    g_object_set(G_OBJECT(appsrc), "stream-type", type, NULL);
}

void swift_gst_app_src_set_size(GstAppSrc* appsrc, gint64 size) {
    gst_app_src_set_size(appsrc, size);
}

// MARK: - Sample/Buffer utilities

GstBuffer* swift_gst_sample_get_buffer(void* sample) {
    return gst_sample_get_buffer((GstSample*)sample);
}

GstCaps* swift_gst_sample_get_caps(void* sample) {
    return gst_sample_get_caps((GstSample*)sample);
}

void swift_gst_sample_unref(void* sample) {
    gst_sample_unref((GstSample*)sample);
}

gsize swift_gst_buffer_get_size(GstBuffer* buffer) {
    return gst_buffer_get_size(buffer);
}

GstBuffer* swift_gst_buffer_ref(GstBuffer* buffer) {
    return gst_buffer_ref(buffer);
}

void swift_gst_buffer_unref(GstBuffer* buffer) {
    gst_buffer_unref(buffer);
}

gboolean swift_gst_buffer_map_read(GstBuffer* buffer, GstMapInfo* info) {
    return gst_buffer_map(buffer, info, GST_MAP_READ);
}

gboolean swift_gst_buffer_map_write(GstBuffer* buffer, GstMapInfo* info) {
    return gst_buffer_map(buffer, info, GST_MAP_WRITE);
}

void swift_gst_buffer_unmap(GstBuffer* buffer, GstMapInfo* info) {
    gst_buffer_unmap(buffer, info);
}

GstBuffer* swift_gst_buffer_new_allocate(gsize size) {
    return gst_buffer_new_allocate(NULL, size, NULL);
}

gsize swift_gst_buffer_fill(GstBuffer* buffer, gsize offset, gconstpointer src, gsize size) {
    return gst_buffer_fill(buffer, offset, src, size);
}

// MARK: - Buffer Timestamps

GstClockTime swift_gst_buffer_get_pts(GstBuffer* buffer) {
    return GST_BUFFER_PTS(buffer);
}

GstClockTime swift_gst_buffer_get_dts(GstBuffer* buffer) {
    return GST_BUFFER_DTS(buffer);
}

GstClockTime swift_gst_buffer_get_duration(GstBuffer* buffer) {
    return GST_BUFFER_DURATION(buffer);
}

void swift_gst_buffer_set_pts(GstBuffer* buffer, GstClockTime pts) {
    GST_BUFFER_PTS(buffer) = pts;
}

void swift_gst_buffer_set_dts(GstBuffer* buffer, GstClockTime dts) {
    GST_BUFFER_DTS(buffer) = dts;
}

void swift_gst_buffer_set_duration(GstBuffer* buffer, GstClockTime duration) {
    GST_BUFFER_DURATION(buffer) = duration;
}

gboolean swift_gst_clock_time_is_valid(GstClockTime time) {
    return GST_CLOCK_TIME_IS_VALID(time);
}

GstClockTime swift_gst_clock_time_none(void) {
    return GST_CLOCK_TIME_NONE;
}

GstClockTime swift_gst_second(void) {
    return GST_SECOND;
}

// MARK: - AppSrc additional functions

void swift_gst_app_src_set_format(GstAppSrc* appsrc, GstFormat format) {
    g_object_set(G_OBJECT(appsrc), "format", format, NULL);
}

void swift_gst_app_src_set_is_live(GstAppSrc* appsrc, gboolean is_live) {
    g_object_set(G_OBJECT(appsrc), "is-live", is_live, NULL);
}

void swift_gst_app_src_set_max_bytes(GstAppSrc* appsrc, guint64 max) {
    g_object_set(G_OBJECT(appsrc), "max-bytes", max, NULL);
}

void swift_gst_app_src_set_latency(GstAppSrc* appsrc, guint64 min, guint64 max) {
    g_object_set(G_OBJECT(appsrc), "min-latency", (gint64)min, "max-latency", (gint64)max, NULL);
}

GstBuffer* swift_gst_buffer_new_wrapped_full(gconstpointer data, gsize size, GstClockTime pts, GstClockTime duration) {
    GstBuffer* buffer = gst_buffer_new_allocate(NULL, size, NULL);
    if (buffer) {
        gst_buffer_fill(buffer, 0, data, size);
        GST_BUFFER_PTS(buffer) = pts;
        GST_BUFFER_DURATION(buffer) = duration;
    }
    return buffer;
}
