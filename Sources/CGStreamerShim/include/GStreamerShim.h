#ifndef GSTREAMER_SHIM_H
#define GSTREAMER_SHIM_H

#include <gst/gst.h>

#ifdef __cplusplus
extern "C" {
#endif

/// Initialize GStreamer with no arguments
/// Returns TRUE on success, FALSE on failure
gboolean swift_gst_init(void);

/// Deinitialize GStreamer
void swift_gst_deinit(void);

/// Get the GStreamer version as a string (caller must g_free the result)
gchar* swift_gst_version_string(void);

/// Get the major version number
guint swift_gst_version_major(void);

/// Get the minor version number
guint swift_gst_version_minor(void);

/// Get the micro version number
guint swift_gst_version_micro(void);

/// Get the nano version number
guint swift_gst_version_nano(void);

/// Parse a pipeline description and return a GstElement (pipeline)
/// Returns NULL on error, error_message will be set (caller must g_free)
GstElement* swift_gst_parse_launch(const gchar* pipeline_description, gchar** error_message);

/// Get element by name from a bin/pipeline
GstElement* swift_gst_bin_get_by_name(GstElement* bin, const gchar* name);

/// Set pipeline state
GstStateChangeReturn swift_gst_element_set_state(GstElement* element, GstState state);

/// Get pipeline state
GstState swift_gst_element_get_state(GstElement* element, GstClockTime timeout);

/// Get the bus from an element
GstBus* swift_gst_element_get_bus(GstElement* element);

/// Pop a message from the bus (non-blocking)
GstMessage* swift_gst_bus_pop(GstBus* bus);

/// Pop a message from the bus with timeout
GstMessage* swift_gst_bus_timed_pop(GstBus* bus, GstClockTime timeout);

/// Pop a message from the bus filtered by type
GstMessage* swift_gst_bus_timed_pop_filtered(GstBus* bus, GstClockTime timeout, GstMessageType types);

/// Get message type
GstMessageType swift_gst_message_type(GstMessage* message);

/// Get message type name
const gchar* swift_gst_message_type_name(GstMessage* message);

/// Parse error message (caller must g_free error_string and debug_string)
void swift_gst_message_parse_error(GstMessage* message, gchar** error_string, gchar** debug_string);

/// Parse warning message (caller must g_free warning_string and debug_string)
void swift_gst_message_parse_warning(GstMessage* message, gchar** warning_string, gchar** debug_string);

/// Parse info message (caller must g_free info_string and debug_string)
void swift_gst_message_parse_info(GstMessage* message, gchar** info_string, gchar** debug_string);

/// Unref a message
void swift_gst_message_unref(GstMessage* message);

/// Unref an element
void swift_gst_object_unref(gpointer object);

/// Link two elements
gboolean swift_gst_element_link(GstElement* src, GstElement* dest);

/// Get element name (caller must g_free)
gchar* swift_gst_element_get_name(GstElement* element);

/// Get element factory name
const gchar* swift_gst_element_factory_get_name(GstElement* element);

/// Create a caps from string
GstCaps* swift_gst_caps_from_string(const gchar* string);

/// Convert caps to string (caller must g_free)
gchar* swift_gst_caps_to_string(GstCaps* caps);

/// Unref caps
void swift_gst_caps_unref(GstCaps* caps);

/// Set element property (boolean)
void swift_gst_element_set_bool(GstElement* element, const gchar* name, gboolean value);

/// Set element property (integer)
void swift_gst_element_set_int(GstElement* element, const gchar* name, gint value);

/// Set element property (string)
void swift_gst_element_set_string(GstElement* element, const gchar* name, const gchar* value);

/// Parse state changed message
void swift_gst_message_parse_state_changed(GstMessage* message, GstState* old_state, GstState* new_state, GstState* pending);

#ifdef __cplusplus
}
#endif

#endif /* GSTREAMER_SHIM_H */
