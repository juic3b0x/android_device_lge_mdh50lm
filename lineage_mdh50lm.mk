#
# Copyright (C) 2022 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Inherit from mdh50lm device
$(call inherit-product, device/lge/mdh50lm/device.mk)

PRODUCT_DEVICE := mdh50lm
PRODUCT_NAME := lineage_mdh50lm
PRODUCT_BRAND := lge
PRODUCT_MODEL := LM-Q730
PRODUCT_MANUFACTURER := lge

PRODUCT_GMS_CLIENTID_BASE := android-lge

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="mdh50lm-user 10 QKQ1.200216.002 201291401ec89 release-keys"

BUILD_FINGERPRINT := lge/mdh50lm/mdh50lm:10/QKQ1.200216.002/201291401ec89:user/release-keys
