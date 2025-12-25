#include "include/GStreamerShim.h"
#include <string.h>

gboolean swift_gst_init(void) {
    GError* error = NULL;
    gboolean result = gst_init_check(NULL, NULL, &error);
    if (error) {
        g_error_free(error);
    }
    return result;
}

void swift_gst_deinit(void) {
    gst_deinit();
}

gchar* swift_gst_version_string(void) {
    return gst_version_string();
}

guint swift_gst_version_major(void) {
    guint major, minor, micro, nano;
    gst_version(&major, &minor, &micro, &nano);
    return major;
}

guint swift_gst_version_minor(void) {
    guint major, minor, micro, nano;
    gst_version(&major, &minor, &micro, &nano);
    return minor;
}

guint swift_gst_version_micro(void) {
    guint major, minor, micro, nano;
    gst_version(&major, &minor, &micro, &nano);
    return micro;
}

guint swift_gst_version_nano(void) {
    guint major, minor, micro, nano;
    gst_version(&major, &minor, &micro, &nano);
    return nano;
}

GstElement* swift_gst_parse_launch(const gchar* pipeline_description, gchar** error_message) {
    GError* error = NULL;
    GstElement* pipeline = gst_parse_launch(pipeline_description, &error);

    if (error) {
        if (error_message) {
            *error_message = g_strdup(error->message);
        }
        g_error_free(error);
    } else if (error_message) {
        *error_message = NULL;
    }

    return pipeline;
}

GstElement* swift_gst_bin_get_by_name(GstElement* bin, const gchar* name) {
    if (!GST_IS_BIN(bin)) {
        return NULL;
    }
    return gst_bin_get_by_name(GST_BIN(bin), name);
}

GstStateChangeReturn swift_gst_element_set_state(GstElement* element, GstState state) {
    return gst_element_set_state(element, state);
}

GstState swift_gst_element_get_state(GstElement* element, GstClockTime timeout) {
    GstState state;
    gst_element_get_state(element, &state, NULL, timeout);
    return state;
}

GstBus* swift_gst_element_get_bus(GstElement* element) {
    return gst_element_get_bus(element);
}

GstMessage* swift_gst_bus_pop(GstBus* bus) {
    return gst_bus_pop(bus);
}

GstMessage* swift_gst_bus_timed_pop(GstBus* bus, GstClockTime timeout) {
    return gst_bus_timed_pop(bus, timeout);
}

GstMessage* swift_gst_bus_timed_pop_filtered(GstBus* bus, GstClockTime timeout, GstMessageType types) {
    return gst_bus_timed_pop_filtered(bus, timeout, types);
}

GstMessageType swift_gst_message_type(GstMessage* message) {
    return GST_MESSAGE_TYPE(message);
}

const gchar* swift_gst_message_type_name(GstMessage* message) {
    return GST_MESSAGE_TYPE_NAME(message);
}

void swift_gst_message_parse_error(GstMessage* message, gchar** error_string, gchar** debug_string) {
    GError* error = NULL;
    gchar* debug = NULL;

    gst_message_parse_error(message, &error, &debug);

    if (error_string) {
        *error_string = error ? g_strdup(error->message) : NULL;
    }
    if (debug_string) {
        *debug_string = debug;
    } else {
        g_free(debug);
    }

    if (error) {
        g_error_free(error);
    }
}

void swift_gst_message_parse_warning(GstMessage* message, gchar** warning_string, gchar** debug_string) {
    GError* error = NULL;
    gchar* debug = NULL;

    gst_message_parse_warning(message, &error, &debug);

    if (warning_string) {
        *warning_string = error ? g_strdup(error->message) : NULL;
    }
    if (debug_string) {
        *debug_string = debug;
    } else {
        g_free(debug);
    }

    if (error) {
        g_error_free(error);
    }
}

void swift_gst_message_parse_info(GstMessage* message, gchar** info_string, gchar** debug_string) {
    GError* error = NULL;
    gchar* debug = NULL;

    gst_message_parse_info(message, &error, &debug);

    if (info_string) {
        *info_string = error ? g_strdup(error->message) : NULL;
    }
    if (debug_string) {
        *debug_string = debug;
    } else {
        g_free(debug);
    }

    if (error) {
        g_error_free(error);
    }
}

void swift_gst_message_unref(GstMessage* message) {
    gst_message_unref(message);
}

void swift_gst_object_unref(gpointer object) {
    gst_object_unref(object);
}

gboolean swift_gst_element_link(GstElement* src, GstElement* dest) {
    return gst_element_link(src, dest);
}

gchar* swift_gst_element_get_name(GstElement* element) {
    return gst_element_get_name(element);
}

const gchar* swift_gst_element_factory_get_name(GstElement* element) {
    GstElementFactory* factory = gst_element_get_factory(element);
    if (factory) {
        return gst_plugin_feature_get_name(GST_PLUGIN_FEATURE(factory));
    }
    return NULL;
}

GstCaps* swift_gst_caps_from_string(const gchar* string) {
    return gst_caps_from_string(string);
}

gchar* swift_gst_caps_to_string(GstCaps* caps) {
    return gst_caps_to_string(caps);
}

void swift_gst_caps_unref(GstCaps* caps) {
    gst_caps_unref(caps);
}

void swift_gst_element_set_bool(GstElement* element, const gchar* name, gboolean value) {
    g_object_set(G_OBJECT(element), name, value, NULL);
}

void swift_gst_element_set_int(GstElement* element, const gchar* name, gint value) {
    g_object_set(G_OBJECT(element), name, value, NULL);
}

void swift_gst_element_set_string(GstElement* element, const gchar* name, const gchar* value) {
    g_object_set(G_OBJECT(element), name, value, NULL);
}

void swift_gst_message_parse_state_changed(GstMessage* message, GstState* old_state, GstState* new_state, GstState* pending) {
    gst_message_parse_state_changed(message, old_state, new_state, pending);
}
