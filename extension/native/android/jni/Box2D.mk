LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := Box2D

LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../box2d/Box2D

include $(LOCAL_PATH)/Box2DSources.mk

include $(BUILD_STATIC_LIBRARY)