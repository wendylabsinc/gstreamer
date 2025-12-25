#ifndef GSTREAMER_APP_SHIM_H
#define GSTREAMER_APP_SHIM_H

#include <gst/gst.h>
#include <gst/app/gstappsink.h>
#include <gst/app/gstappsrc.h>

#ifdef __cplusplus
extern "C" {
#endif

// MARK: - AppSink

/// Pull a sample from appsink (blocking)
GstSample* swift_gst_app_sink_pull_sample(GstAppSink* appsink);

/// Try to pull a sample from appsink (non-blocking)
GstSample* swift_gst_app_sink_try_pull_sample(GstAppSink* appsink, GstClockTime timeout);

/// Check if appsink is at EOS
gboolean swift_gst_app_sink_is_eos(GstAppSink* appsink);

/// Set appsink caps
void swift_gst_app_sink_set_caps(GstAppSink* appsink, GstCaps* caps);

/// Get appsink caps
GstCaps* swift_gst_app_sink_get_caps(GstAppSink* appsink);

/// Set appsink emit-signals property
void swift_gst_app_sink_set_emit_signals(GstAppSink* appsink, gboolean emit);

/// Set appsink max-buffers property
void swift_gst_app_sink_set_max_buffers(GstAppSink* appsink, guint max);

/// Set appsink drop property
void swift_gst_app_sink_set_drop(GstAppSink* appsink, gboolean drop);

// MARK: - AppSrc

/// Push a buffer to appsrc
GstFlowReturn swift_gst_app_src_push_buffer(GstAppSrc* appsrc, GstBuffer* buffer);

/// Signal end-of-stream to appsrc
GstFlowReturn swift_gst_app_src_end_of_stream(GstAppSrc* appsrc);

/// Set appsrc caps
void swift_gst_app_src_set_caps(GstAppSrc* appsrc, GstCaps* caps);

/// Set appsrc stream type
void swift_gst_app_src_set_stream_type(GstAppSrc* appsrc, GstAppStreamType type);

/// Set appsrc size
void swift_gst_app_src_set_size(GstAppSrc* appsrc, gint64 size);

// MARK: - Sample/Buffer utilities (using void* for opaque types for Swift compatibility)

/// Get buffer from sample - uses void* for Swift OpaquePointer compatibility
GstBuffer* swift_gst_sample_get_buffer(void* sample);

/// Get caps from sample - uses void* for Swift OpaquePointer compatibility
GstCaps* swift_gst_sample_get_caps(void* sample);

/// Unref sample - uses void* for Swift OpaquePointer compatibility
void swift_gst_sample_unref(void* sample);

/// Get buffer size
gsize swift_gst_buffer_get_size(GstBuffer* buffer);

/// Ref a buffer
GstBuffer* swift_gst_buffer_ref(GstBuffer* buffer);

/// Unref a buffer
void swift_gst_buffer_unref(GstBuffer* buffer);

/// Map buffer for reading
gboolean swift_gst_buffer_map_read(GstBuffer* buffer, GstMapInfo* info);

/// Map buffer for writing
gboolean swift_gst_buffer_map_write(GstBuffer* buffer, GstMapInfo* info);

/// Unmap buffer
void swift_gst_buffer_unmap(GstBuffer* buffer, GstMapInfo* info);

/// Create a new buffer with given size
GstBuffer* swift_gst_buffer_new_allocate(gsize size);

/// Fill buffer with data
gsize swift_gst_buffer_fill(GstBuffer* buffer, gsize offset, gconstpointer src, gsize size);

#ifdef __cplusplus
}
#endif

#endif /* GSTREAMER_APP_SHIM_H */
