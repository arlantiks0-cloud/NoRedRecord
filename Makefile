ARCHS = arm64
TARGET = iphone:clang:latest:15.0
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = NoRedRecord

NoRedRecord_FILES = Tweak.x
NoRedRecord_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
