LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := FlashRuntimeExtensions-prebuilt
LOCAL_SRC_FILES := FlashRuntimeExtensions.so

include $(PREBUILT_SHARED_LIBRARY)