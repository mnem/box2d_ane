LOCAL_PATH := $(call my-dir)

# Include the module for the FlashRuntimeExtensions shared library
include $(LOCAL_PATH)/FlashRuntimeExtensions.mk
include $(LOCAL_PATH)/Box2D.mk

include $(CLEAR_VARS)

LOCAL_MODULE    := NaHBox2D

LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../shared/include
LOCAL_C_INCLUDES += $(LOCAL_PATH)/../../box2d/Box2D

LOCAL_SRC_FILES := ../../shared/src/ExtensionFunctions.cpp
LOCAL_SRC_FILES +=  ../../shared/src/ExtensionLifecycle.cpp
LOCAL_SRC_FILES +=  ../../shared/src/SessionContext.cpp
LOCAL_SRC_FILES +=  ../../shared/src/Box2DExtensionHelper.cpp

LOCAL_SHARED_LIBRARIES := FlashRuntimeExtensions-prebuilt
LOCAL_WHOLE_STATIC_LIBRARIES := Box2D

include $(BUILD_SHARED_LIBRARY)
