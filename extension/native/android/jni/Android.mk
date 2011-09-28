LOCAL_PATH := $(call my-dir)/../../ios/NAH_B2D/NAH_B2D

include $(CLEAR_VARS)

LOCAL_MODULE    := NaHBox2D
LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../../include
LOCAL_SRC_FILES := ExtensionFunctions.c ExtensionLifecycle.c

include $(BUILD_STATIC_LIBRARY)
