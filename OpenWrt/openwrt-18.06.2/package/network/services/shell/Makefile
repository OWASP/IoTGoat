#
# This software is licensed under the Public Domain.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=shellback
PKG_VERSION:=0.1
PKG_RELEASE:=1

PKG_MAINTAINER:=John Doe <john.doe@example.com>
PKG_LICENSE:=CC0-1.0

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/shellback
	SECTION:=utils
	# Select package by default
	#DEFAULT:=y
	CATEGORY:=Utilities
	TITLE:=Some different dummy application.
	URL:=https://www.example.com
endef

define Package/shellback/description
	This is some dummy application.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef

define Package/shellback/install
	$(CP) ./files/* $(1)/

	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/shellback $(1)/usr/bin/
endef

$(eval $(call BuildPackage,shellback))
