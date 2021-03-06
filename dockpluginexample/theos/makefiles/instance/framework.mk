ifeq ($(_THEOS_RULES_LOADED),)
include $(THEOS_MAKE_PATH)/rules.mk
endif

.PHONY: internal-framework-all_ internal-framework-stage_ internal-framework-compile

ifeq ($($(THEOS_CURRENT_INSTANCE)_FRAMEWORK_NAME),)
LOCAL_FRAMEWORK_NAME = $(THEOS_CURRENT_INSTANCE)
else
LOCAL_FRAMEWORK_NAME = $($(THEOS_CURRENT_INSTANCE)_FRAMEWORK_NAME)
endif

AUXILIARY_LDFLAGS += -dynamiclib -install_name "$($(THEOS_CURRENT_INSTANCE)_INSTALL_PATH)/$(LOCAL_FRAMEWORK_NAME).framework/$(THEOS_CURRENT_INSTANCE)"

ifeq ($(_THEOS_MAKE_PARALLEL_BUILDING), no)
internal-framework-all_:: $(_OBJ_DIR_STAMPS) $(THEOS_OBJ_DIR)/$(THEOS_CURRENT_INSTANCE)
else
internal-framework-all_:: $(_OBJ_DIR_STAMPS)
	$(ECHO_NOTHING)$(MAKE) --no-print-directory --no-keep-going \
		internal-framework-compile \
		_THEOS_CURRENT_TYPE=$(_THEOS_CURRENT_TYPE) THEOS_CURRENT_INSTANCE=$(THEOS_CURRENT_INSTANCE) _THEOS_CURRENT_OPERATION=compile \
		THEOS_BUILD_DIR="$(THEOS_BUILD_DIR)" _THEOS_MAKE_PARALLEL=yes$(ECHO_END)

internal-framework-compile: $(THEOS_OBJ_DIR)/$(THEOS_CURRENT_INSTANCE)
endif

$(eval $(call _THEOS_TEMPLATE_DEFAULT_LINKING_RULE,$(THEOS_CURRENT_INSTANCE)))

THEOS_SHARED_BUNDLE_RESOURCE_PATH = $(THEOS_STAGING_DIR)$($(THEOS_CURRENT_INSTANCE)_INSTALL_PATH)/$(LOCAL_FRAMEWORK_NAME).framework
include $(THEOS_MAKE_PATH)/instance/shared/bundle.mk

internal-framework-stage_:: shared-instance-bundle-stage
	$(ECHO_NOTHING)mkdir -p "$(THEOS_SHARED_BUNDLE_RESOURCE_PATH)"$(ECHO_END)
	$(ECHO_NOTHING)cp $(THEOS_OBJ_DIR)/$(THEOS_CURRENT_INSTANCE) "$(THEOS_SHARED_BUNDLE_RESOURCE_PATH)"$(ECHO_END)

$(eval $(call __mod,instance/framework.mk))
