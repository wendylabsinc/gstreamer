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
