#
# Copyright (C) 2022 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Enable updating of APEXes
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# Include GSI keys
$(call inherit-product, $(SRC_TARGET_DIR)/product/gsi_keys.mk)

# A/B
PRODUCT_PACKAGES += \
    android.hardware.boot@1.2-impl \
    android.hardware.boot@1.2-impl.recovery \
    android.hardware.boot@1.2-service

PRODUCT_PACKAGES += \
    update_engine \
    update_engine_sideload \
    update_verifier

PRODUCT_PACKAGES += \
    checkpoint_gc \
    otapreopt_script

# fastbootd
PRODUCT_PACKAGES += \
    android.hardware.fastboot@1.1-impl-mock \
    fastbootd

# Health
PRODUCT_PACKAGES += \
    android.hardware.health@2.1-impl \
    android.hardware.health@2.1-service

# Overlays
PRODUCT_ENFORCE_RRO_TARGETS := *

# Partitions
PRODUCT_BUILD_SUPER_PARTITION := false
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Product characteristics
PRODUCT_CHARACTERISTICS := default

# Rootdir
PRODUCT_PACKAGES += \
    init.lge.usb.default.sh \
    init.lge.usb.lao.sh \
    init.lge.usb.sh \
    init.lge.zramswap.sh \
    init.miniOS.crash.sh \
    set_emmc_name.sh \
    set_life_data.sh \
    wifi_runtime_conf.sh \

PRODUCT_PACKAGES += \
    fstab.enableswap \
    factory_init.connectivity.rc \
    factory_init.project.rc \
    factory_init.rc \
    init.aee.rc \
    init.ago.rc \
    init.connectivity.rc \
    init.lge.audio.rc \
    init.lge.fingerprints.rc \
    init.lge.sensors.rc \
    init.lge.usb.configfs.rc \
    init.lge.usb.rc \
    init.mdh50lm.rc \
    init.mdh50lm.vendor.rc \
    init.mdh50lm_vendor.rc \
    init.modem.rc \
    init.mt6765.rc \
    init.mt6765_core.rc \
    init.project.rc \
    init.sensor_1_0.rc \
    meta_init.connectivity.rc \
    meta_init.modem.rc \
    meta_init.project.rc \
    meta_init.rc \
    multi_init.rc \
    ueventd.mdh50lm.rc \
    meta_init.project.rc \
    ueventd.rc \
    init.recovery.mt6765.rc \
    init.rc \

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/fstab.enableswap:$(TARGET_COPY_OUT_RAMDISK)/fstab.enableswap

# Shipping API level
PRODUCT_SHIPPING_API_LEVEL := 29

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# Inherit the proprietary files
$(call inherit-product, vendor/lge/mdh50lm/mdh50lm-vendor.mk)
