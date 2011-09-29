LOCAL_PATH := $(call my-dir)

# Include the module for the FlashRuntimeExtensions shared library
include $(LOCAL_PATH)/FlashRuntimeExtensions.mk
include $(LOCAL_PATH)/Box2D.mk

include $(CLEAR_VARS)

LOCAL_MODULE    := NaHBox2D

LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../shared/include
LOCAL_SRC_FILES := ../../shared/src/ExtensionFunctions.c ../../shared/src/ExtensionLifecycle.c
LOCAL_SHARED_LIBRARIES := FlashRuntimeExtensions-prebuilt
LOCAL_WHOLE_STATIC_LIBRARIES := Box2D

include $(BUILD_SHARED_LIBRARY)
