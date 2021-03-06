# Copyright 2021 AOSP-Krypton Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Krypton utils
include vendor/krypton/configs/KryptonUtils.mk

# Bootanimation
PRODUCT_COPY_FILES += \
	vendor/krypton/prebuilts/bootanimation/bootanimation.zip:$(TARGET_COPY_OUT_PRODUCT)/media/bootanimation.zip \
	vendor/krypton/prebuilts/etc/apns-conf.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/apns-conf.xml

# Inherit gapps if GAPPS_BUILD env variable is set
ifeq ($(GAPPS_BUILD),true)
GAPPS_VARIANT := nano
$(call inherit-product, vendor/opengapps/build/opengapps-packages.mk)
GAPPS_PRODUCT_PACKAGES += \
	Chrome \
	PrebuiltBugle \
	CalculatorGoogle \
	GoogleContacts \
	LatinImeGoogle \
	PrebuiltDeskClockGoogle \
	WebViewGoogle \
	CalendarGooglePrebuilt \
	GoogleDialer \
	PixelLauncher

GAPPS_EXCLUDED_PACKAGES := Velvet
GAPPS_FORCE_PACKAGE_OVERRIDES := true
GAPPS_FORCE_WEBVIEW_OVERRIDES := true
GAPPS_FORCE_MMS_OVERRIDES := true
GAPPS_FORCE_DIALER_OVERRIDES := true
GAPPS_FORCE_PIXEL_LAUNCHER := true
GAPPS_PACKAGE_OVERRIDES := LatinImeGoogle
endif

# Sepolicy
include vendor/krypton/sepolicy/KryptonSepolicy.mk

# gms
ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

# Copy all krypton-specific init rc files
$(foreach f,$(wildcard vendor/krypton/prebuilts/etc/init/*.rc),\
	$(eval PRODUCT_COPY_FILES += $(f):$(TARGET_COPY_OUT_SYSTEM)/etc/init/$(notdir $f)))
