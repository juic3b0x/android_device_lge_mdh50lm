#!/vendor/bin/sh

######## LGP_WIFI_RUNTIME_SHELL ##############

INPUT_PARAM=$1

# TAG NAME
LOG_TAG=PCAS
CR_CHAR=$'\r'

#================ BUILD TIME =====================
WLAN_CHIP_VENDOR=`getprop vendor.lge.wlan.chip.vendor`
WLAN_CHIP_VERSION=`getprop vendor.lge.wlan.chip.version`
WLAN_CHIP_QCOM_QCA=`getprop vendor.lge.wlan.chip.qca.version`
WLAN_CHIP_HELIUM_VERSION=`getprop vendor.lge.wlan.chip.helium.version`

#=============== RUN TIME Property ===============
# http://collab.lge.com/main/pages/viewpage.action?pageId=677917338
LAOP_SKU_CARRIER_PROP=`getprop ro.boot.vendor.lge.sku_carrier`
WLAN_CHAIN_PROP=`getprop persist.vendor.lge.wlan.chain`

#======= Q OS DH5 [START] =======
HW_MODEL=`getprop ro.boot.hardware`
HW_REV=`getprop ro.boot.vendor.lge.hw.rev`
DH5_MODEL="mdh5lm"
DH5_REV0="rev_0"
DH5_REVA="rev_a"

# WIFI PERSIST PATH
PERSIST_ROOT=/mnt/vendor/persist-lg

function VERIFY_PERSIST_FOLDER
{
    if [[ ! -d /mnt/vendor/persist-lg ]] && [[ ! -d /vendor/persist-lg ]] && [[ ! -d /persist-lg ]]; then
        PERSIST_ROOT=/persist
    else
        if [[ -d /mnt/vendor/persist-lg ]]; then
        PERSIST_ROOT=/mnt/vendor/persist-lg
        elif [[ -d /vendor/persist-lg ]]; then
        PERSIST_ROOT=/vendor/persist-lg
        else
        PERSIST_ROOT=/persist-lg
        fi
    fi
}

VERIFY_PERSIST_FOLDER
WIFI_PERSIST_LG_ROOT=${PERSIST_ROOT}/wifi
#log -p i -t $LOG_TAG "select persist path = \"${WIFI_PERSIST_LG_ROOT}\""

# MAKE FOLDER

if [[ ! -d ${WIFI_PERSIST_LG_ROOT} ]]; then
mkdir ${WIFI_PERSIST_LG_ROOT}
chmod -h 0775 ${WIFI_PERSIST_LG_ROOT}
fi

if [[ ! -d ${WIFI_PERSIST_LG_ROOT}/qcom ]]; then
mkdir ${WIFI_PERSIST_LG_ROOT}/qcom
chmod -h 0775 ${WIFI_PERSIST_LG_ROOT}/qcom
fi

if [[ ! -d ${WIFI_PERSIST_LG_ROOT}/brcm ]]; then
mkdir ${WIFI_PERSIST_LG_ROOT}/brcm
chmod -h 0775 ${WIFI_PERSIST_LG_ROOT}/brcm
fi

if [[ ! -d ${WIFI_PERSIST_LG_ROOT}/mtk ]]; then
mkdir ${WIFI_PERSIST_LG_ROOT}/mtk
chmod -h 0775 ${WIFI_PERSIST_LG_ROOT}/mtk
fi

# FOR PATH CHECK ================================
# WiFi NV PATH
VENDOR_ETC_WIFI_PATH=/vendor/etc/wifi
SYSTEM_VENDOR_ETC_WIFI_PATH=/system/vendor/etc/wifi
SYSTEM_ETC_WIFI_PATH=/system/etc/wifi
WIFI_PATH=/vendor/etc/wifi

function VERIFY_WIFI_NV_QCOM_399X
{
    if [[ -f ${VENDOR_ETC_WIFI_PATH}/bdwlan.bin ]]; then
        WIFI_PATH=${VENDOR_ETC_WIFI_PATH}
        #log -p i -t $LOG_TAG "Path change to vendor image"
    elif [[ -f ${SYSTEM_VENDOR_ETC_WIFI_PATH}/bdwlan.bin ]]; then
        WIFI_PATH=${SYSTEM_VENDOR_ETC_WIFI_PATH}
        #log -p i -t $LOG_TAG "Path change to system/vendor image"
    else
        WIFI_PATH=${SYSTEM_ETC_WIFI_PATH}
        #log -p i -t $LOG_TAG "Path change to system/bin image"
    fi
}

function VERIFY_WIFI_NV_QCOM_HASTING
{
    if [[ -f ${VENDOR_ETC_WIFI_PATH}/bdwlan.elf ]]; then
        WIFI_PATH=${VENDOR_ETC_WIFI_PATH}
        #log -p i -t $LOG_TAG "Path change to vendor image"
    elif [[ -f ${SYSTEM_VENDOR_ETC_WIFI_PATH}/bdwlan.elf ]]; then
        WIFI_PATH=${SYSTEM_VENDOR_ETC_WIFI_PATH}
        #log -p i -t $LOG_TAG "Path change to system/vendor image"
    else
        WIFI_PATH=${SYSTEM_ETC_WIFI_PATH}
        #log -p i -t $LOG_TAG "Path change to system/bin image"
    fi
}

function VERIFY_WIFI_NV_QCOM_QCA6174
{
    if [[ -f ${VENDOR_ETC_WIFI_PATH}/bdwlan30.bin ]]; then
        WIFI_PATH=${VENDOR_ETC_WIFI_PATH}
        #log -p i -t $LOG_TAG "Path change to vendor image"
    elif [[ -f ${SYSTEM_VENDOR_ETC_WIFI_PATH}/bdwlan30.bin ]]; then
        WIFI_PATH=${SYSTEM_VENDOR_ETC_WIFI_PATH}
        #log -p i -t $LOG_TAG "Path change to system/vendor image"
    else
        WIFI_PATH=${SYSTEM_ETC_WIFI_PATH}
        #log -p i -t $LOG_TAG "Path change to system/bin image"
    fi
}

function VERIFY_WIFI_NV_QCOM_WCNSS
{
    if [[ -f ${VENDOR_ETC_WIFI_PATH}/WCNSS_qcom_wlan_nv.bin ]]; then
        WIFI_PATH=${VENDOR_ETC_WIFI_PATH}
        #log -p i -t $LOG_TAG "Path change to vendor image"
    elif [[ -f ${SYSTEM_VENDOR_ETC_WIFI_PATH}/WCNSS_qcom_wlan_nv.bin ]]; then
        WIFI_PATH=${SYSTEM_VENDOR_ETC_WIFI_PATH}
        #log -p i -t $LOG_TAG "Path change to system/vendor image"
    else
        WIFI_PATH=${SYSTEM_ETC_WIFI_PATH}
        #log -p i -t $LOG_TAG "Path change to system/bin image"
    fi
}

function VERIFY_WIFI_NV_BRCM
{
    if [[ -f ${VENDOR_ETC_WIFI_PATH}/bcmdhd_runtime.cal ]]; then
        WIFI_PATH=${VENDOR_ETC_WIFI_PATH}
        #log -p i -t $LOG_TAG "Path change to vendor image"
    elif [[ -f ${SYSTEM_VENDOR_ETC_WIFI_PATH}/bcmdhd_runtime.cal ]]; then
        WIFI_PATH=${SYSTEM_VENDOR_ETC_WIFI_PATH}
        #log -p i -t $LOG_TAG "Path change to system/vendor image"
    else
        WIFI_PATH=${SYSTEM_ETC_WIFI_PATH}
        #log -p i -t $LOG_TAG "Path change to system/bin image"
    fi
}

function VERIFY_WIFI_NV_MTK
{
    if [[ -f ${VENDOR_ETC_WIFI_PATH}/WIFI ]]; then
        WIFI_PATH=${VENDOR_ETC_WIFI_PATH}
        #log -p i -t $LOG_TAG "Path change to vendor image"
    elif [[ -f ${SYSTEM_VENDOR_ETC_WIFI_PATH}/WIFI ]]; then
        WIFI_PATH=${SYSTEM_VENDOR_ETC_WIFI_PATH}
        #log -p i -t $LOG_TAG "Path change to system/vendor image"
    else
        WIFI_PATH=${SYSTEM_ETC_WIFI_PATH}
        #log -p i -t $LOG_TAG "Path change to system/bin image"
    fi
}

function VERIFY_WIFI_NV_FOLDER
{
    if [[ ${WLAN_CHIP_VENDOR} == "qcom" ]]; then
        if [[ ${WLAN_CHIP_QCOM_QCA} == "qca6174" ]]; then
            VERIFY_WIFI_NV_QCOM_QCA6174
        elif [[ ${WLAN_CHIP_VERSION} == "wcn399x" ]]; then
            VERIFY_WIFI_NV_QCOM_399X
        elif [[ ${WLAN_CHIP_VERSION} == "hasting" ]]; then
            VERIFY_WIFI_NV_QCOM_HASTING
        else
            VERIFY_WIFI_NV_QCOM_WCNSS
        fi
    elif [[ ${WLAN_CHIP_VENDOR} == "brcm" ]]; then
        VERIFY_WIFI_NV_BRCM
    elif [[ ${WLAN_CHIP_VENDOR} == "mtk" ]]; then
        VERIFY_WIFI_NV_MTK
    else
        return
    fi
}

# FUNCTION
VERIFY_WIFI_NV_FOLDER
#log -p i -t $LOG_TAG "WIFI SYSTEM PATH = \"${WIFI_PATH}\""

# ====================== Symbolic Folder path ===========================
WIFI_PERSIST_LG_WPA_LAOP_CONF_FILE=${WIFI_PERSIST_LG_ROOT}/wpa_supplicant_runtime.conf
WIFI_SKU_PATH=${WIFI_PATH}/${LAOP_SKU_CARRIER_PROP}

# ==================== Runtime Property Conf File =======================
WIFI_RUNTIME_PROPERTY_FILE=${WIFI_PATH}/wifi_runtime_prop.conf

# ======================= Qualcomm WLAN =================================
# QCT WCN (WCN36XX)
WIFI_QCT_FOLDER_PATH=${WIFI_PERSIST_LG_ROOT}/qcom
WIFI_QCT_CACHE_BOOT_CAL_FILE=${WIFI_QCT_FOLDER_PATH}/WCNSS_qcom_wlan_cache_nv_boot.bin
WIFI_QCT_CACHE_INI_FILE=${WIFI_QCT_FOLDER_PATH}/WCNSS_qcom_cache_cfg.ini

# QCT WCN399X
WIFI_QCT_399X_CACHE_BD_WLAN=${WIFI_QCT_FOLDER_PATH}/bdwlan_cache.bin
WIFI_QCT_399X_CACHE_BD_CH0_WLAN=${WIFI_QCT_FOLDER_PATH}/bdwlan_ch0_cache.bin
WIFI_QCT_399X_CACHE_BD_CH1_WLAN=${WIFI_QCT_FOLDER_PATH}/bdwlan_ch1_cache.bin
WIFI_QCT_399X_CACHE_MAC_WLAN=${WIFI_QCT_FOLDER_PATH}/wlan_mac_cache.bin

# QCT HASTING
WIFI_QCT_HASTING_CACHE_BD_WLAN=${WIFI_QCT_FOLDER_PATH}/bdwlan.elf
WIFI_QCT_HASTING_CACHE_MAC_WLAN=${WIFI_QCT_FOLDER_PATH}/wlan_mac_cache.bin

# QCT WCN399X_QCA
WIFI_QCT_QCA6174_CACHE_BD_WLAN=${WIFI_QCT_FOLDER_PATH}/bdwlan30_cache.bin
WIFI_QCT_QCA6174_CACHE_BD_CH0_WLAN=${WIFI_QCT_FOLDER_PATH}/bdwlan30_ch0_cache.bin
WIFI_QCT_QCA6174_CACHE_BD_CH1_WLAN=${WIFI_QCT_FOLDER_PATH}/bdwlan30_ch1_cache.bin
WIFI_QCT_QCA6174_CACHE_SBO_CFG_FILE=${WIFI_QCT_FOLDER_PATH}/wifi_qca_sbo_cfg_cache.conf

# ======================= Broadcom WLAN ===================================
WIFI_BRCM_FOLDER_PATH=${WIFI_PERSIST_LG_ROOT}/brcm
WIFI_BRCM_CACHE_BOOT_CAL_FILE=${WIFI_BRCM_FOLDER_PATH}/bcmdhd_cache.cal

# ======================= Mediatek WLAN ==========================
WIFI_MTK_FOLDER_PATH=${WIFI_PERSIST_LG_ROOT}/mtk
WIFI_MTK_CACHE_BOOT_CAL_FILE=${WIFI_MTK_FOLDER_PATH}/WIFI_cache
WIFI_MTK_CACHE_WMT_SOC_FILE=${WIFI_MTK_FOLDER_PATH}/WMT_SOC.cfg.cache
WIFI_MTK_CACHE_POWER_CTRL_FILE=${WIFI_MTK_FOLDER_PATH}/txpowerctrl.cfg.cache
WIFI_MTK_CACHE_WIFI_CFG_FILE=${WIFI_MTK_FOLDER_PATH}/wifi.cfg.cache
WIFI_MTK_FW_PATH=/system/vendor/firmware


# ======================= FUNCTION ==============================

function QCOM_INI_SET() {
    #log -p i -t $LOG_TAG "QCOM INI"
    # default ini
    ln -sf ${WIFI_PATH}/WCNSS_qcom_cfg.ini ${WIFI_QCT_FOLDER_PATH}/WCNSS_qcom_cache_cfg.ini

    if [[ -n ${LAOP_SKU_CARRIER_PROP} ]]; then
        if [[ -f ${WIFI_SKU_PATH}/WCNSS_qcom_cfg.ini ]]; then
            ln -sf ${WIFI_SKU_PATH}/WCNSS_qcom_cfg.ini ${WIFI_QCT_CACHE_INI_FILE}
            log -p i -t $LOG_TAG "Change ini symbolic link success"
        fi
    fi
}

function QCOM_NV_SET() {
    #log -p i -t $LOG_TAG "QCOM WCN NV"
    # nv.bin
    ln -sf ${WIFI_PATH}/WCNSS_qcom_wlan_nv.bin ${WIFI_QCT_CACHE_BOOT_CAL_FILE}

    if [[ -f ${WIFI_QCT_CACHE_BOOT_CAL_FILE} ]]; then
        #log -p i -t $LOG_TAG "Default NV link success"
        if [[ -n ${LAOP_SKU_CARRIER_PROP} ]]; then
            if [[ -f ${WIFI_SKU_PATH}/WCNSS_qcom_wlan_nv.bin ]]; then
                ln -sf ${WIFI_SKU_PATH}/WCNSS_qcom_wlan_nv.bin ${WIFI_QCT_CACHE_BOOT_CAL_FILE}
                log -p i -t $LOG_TAG "Change NV symbolic link success"
            fi
        fi
    else
        log -p i -t $LOG_TAG "QCOM_NV_bin: No write permission to change link or no exist any file"
    fi

    # INI
    QCOM_INI_SET
}

function QCOM_WCN399X_NV_SET() {
    log -p i -t $LOG_TAG "QCOM WCN399X NV"
    # bdwlan.bin
    ln -sf ${WIFI_PATH}/bdwlan.bin ${WIFI_QCT_399X_CACHE_BD_WLAN}

    if [[ -f ${WIFI_QCT_399X_CACHE_BD_WLAN} ]]; then
        log -p i -t $LOG_TAG "Default bdwlan link success"
        if [[ -n ${LAOP_SKU_CARRIER_PROP} ]]; then
            if [[ -f ${WIFI_SKU_PATH}/bdwlan.bin ]]; then
                ln -sf ${WIFI_SKU_PATH}/bdwlan.bin ${WIFI_QCT_399X_CACHE_BD_WLAN}
                log -p i -t $LOG_TAG "Change bdwlan symbolic link success"
            fi
        fi
    else
        log -p i -t $LOG_TAG "QCOM_NV_bdf: No write permission to change link or no exist any file"
    fi

    # WCN3980 : No check bdwlan_ch0/bdwlan_ch1.bin. So, skip next(ini set)
    if [[ ${WLAN_CHIP_HELIUM_VERSION} == "wcn3980" ]]; then
            QCOM_INI_SET
            return
        fi

    # bdwlan_ch0.bin
    ln -sf ${WIFI_PATH}/bdwlan_ch0.bin ${WIFI_QCT_399X_CACHE_BD_CH0_WLAN}
    if [[ -f ${WIFI_QCT_399X_CACHE_BD_CH0_WLAN} ]]; then
        log -p i -t $LOG_TAG "Default bdwlan_ch0 link success"
        if [[ -n ${LAOP_SKU_CARRIER_PROP} ]]; then
            if [[ -f ${WIFI_SKU_PATH}/bdwlan_ch0.bin ]]; then
                ln -sf ${WIFI_SKU_PATH}/bdwlan_ch0.bin ${WIFI_QCT_399X_CACHE_BD_CH0_WLAN}
                log -p i -t $LOG_TAG "Change bdwlan_ch0 symbolic link success"
            fi
        fi
    else
        log -p i -t $LOG_TAG "QCOM_NV_bdf_ch0: No write permission to change link or no exist any file"
    fi

    # bdwlan_ch1.bin
    ln -sf ${WIFI_PATH}/bdwlan_ch1.bin ${WIFI_QCT_399X_CACHE_BD_CH1_WLAN}
    if [[ -f ${WIFI_QCT_399X_CACHE_BD_CH1_WLAN} ]]; then
        log -p i -t $LOG_TAG "Default bdwlan_ch1 Link Success"
        if [[ -n ${LAOP_SKU_CARRIER_PROP} ]]; then
            if [[ -f ${WIFI_SKU_PATH}/bdwlan_ch1.bin ]]; then
                ln -sf ${WIFI_SKU_PATH}/bdwlan_ch1.bin ${WIFI_QCT_399X_CACHE_BD_CH1_WLAN}
                log -p i -t $LOG_TAG "Change bdwlan_ch1 symbolic link success"
            fi
        fi
    else
        log -p i -t $LOG_TAG "QCOM_NV_bdf_ch1: No write permission to change link or no exist any file"
    fi

    # INI
    QCOM_INI_SET
}

function QCOM_HASTING_NV_SET() {
    log -p i -t $LOG_TAG "QCOM HASTING NV"
    # bdwlan.elf
    ln -sf ${WIFI_PATH}/bdwlan.elf ${WIFI_QCT_HASTING_CACHE_BD_WLAN}

    if [[ -f ${WIFI_QCT_HASTING_CACHE_BD_WLAN} ]]; then
        log -p i -t $LOG_TAG "Default bdwlan link success"
        if [[ -n ${LAOP_SKU_CARRIER_PROP} ]]; then
            if [[ -f ${WIFI_SKU_PATH}/bdwlan.elf ]]; then
                ln -sf ${WIFI_SKU_PATH}/bdwlan.elf ${WIFI_QCT_HASTING_CACHE_BD_WLAN}
                log -p i -t $LOG_TAG "Change bdwlan symbolic link success"
            fi
        fi
    else
        log -p i -t $LOG_TAG "QCOM_NV_bdf: No write permission to change link or no exist any file"
    fi

    if [[ ${WLAN_CHAIN_PROP} == 1 ]]; then
        ln -sf ${WIFI_PATH}/bdwlan_ch0.elf ${WIFI_QCT_HASTING_CACHE_BD_WLAN}
        if [[ -f ${WIFI_QCT_HASTING_CACHE_BD_WLAN} ]]; then
            log -p i -t $LOG_TAG "Default bdwlan_ch0 link success"
            if [[ -n ${LAOP_SKU_CARRIER_PROP} ]]; then
                if [[ -f ${WIFI_SKU_PATH}/bdwlan_ch0.elf ]]; then
                    ln -sf ${WIFI_SKU_PATH}/bdwlan_ch0.elf ${WIFI_QCT_HASTING_CACHE_BD_WLAN}
                    log -p i -t $LOG_TAG "Change bdwlan_ch0 symbolic link success"
                fi
            fi
        else
            log -p i -t $LOG_TAG "QCOM_NV_bdf_ch0: No write permission to change link or no exist any file"
        fi
    elif [[ ${WLAN_CHAIN_PROP} == 2 ]]; then
        ln -sf ${WIFI_PATH}/bdwlan_ch1.elf ${WIFI_QCT_HASTING_CACHE_BD_WLAN}
        if [[ -f ${WIFI_QCT_HASTING_CACHE_BD_WLAN} ]]; then
            log -p i -t $LOG_TAG "Default bdwlan_ch1 Link Success"
            if [[ -n ${LAOP_SKU_CARRIER_PROP} ]]; then
                if [[ -f ${WIFI_SKU_PATH}/bdwlan_ch1.elf ]]; then
                    ln -sf ${WIFI_SKU_PATH}/bdwlan_ch1.elf ${WIFI_QCT_HASTING_CACHE_BD_WLAN}
                    log -p i -t $LOG_TAG "Change bdwlan_ch1 symbolic link success"
                fi
            fi
        else
            log -p i -t $LOG_TAG "QCOM_NV_bdf_ch1: No write permission to change link or no exist any file"
        fi
    else
        log -p i -t $LOG_TAG "QCOM_NV_bdf_ch1: not supported chain configuration - normal cal is used"
    fi

    # INI
    QCOM_INI_SET
}

function QCOM_QCA6174_NV_SET() {
    log -p i -t $LOG_TAG "QCOM QCOM_QCA6174_NV_SET NV"
    # bdwlan30.bin
    ln -sf ${WIFI_PATH}/bdwlan30.bin ${WIFI_QCT_QCA6174_CACHE_BD_WLAN}

    if [[ -f ${WIFI_QCT_QCA6174_CACHE_BD_WLAN} ]]; then
        log -p i -t $LOG_TAG "Default bdwlan30 link success"
        if [[ -n ${LAOP_SKU_CARRIER_PROP} ]]; then
            if [[ -f ${WIFI_SKU_PATH}/bdwlan30.bin ]]; then
                ln -sf ${WIFI_SKU_PATH}/bdwlan30.bin ${WIFI_QCT_QCA6174_CACHE_BD_WLAN}
                log -p i -t $LOG_TAG "Change bdwlan30 symbolic link success"
            fi
        fi
    else
        log -p i -t $LOG_TAG "QCOM_NV_bdwlan30: No write permission to change link or no exist any file"
    fi

    # bdwlan30_ch0.bin
    ln -sf ${WIFI_PATH}/bdwlan30_ch0.bin ${WIFI_QCT_QCA6174_CACHE_BD_CH0_WLAN}
    if [[ -f ${WIFI_QCT_QCA6174_CACHE_BD_CH0_WLAN} ]]; then
        log -p i -t $LOG_TAG "Default bdwlan30_ch0 link success"
        if [[ -n ${LAOP_SKU_CARRIER_PROP} ]]; then
            if [[ -f ${WIFI_SKU_PATH}/bdwlan30_ch0.bin ]]; then
                ln -sf ${WIFI_SKU_PATH}/bdwlan30_ch0.bin ${WIFI_QCT_QCA6174_CACHE_BD_CH0_WLAN}
                log -p i -t $LOG_TAG "Change bdwlan30_ch0 symbolic link success"
            fi
        fi
    else
        log -p i -t $LOG_TAG "QCOM_NV_bdwlan30_ch0: No write permission to change link or no exist any file"
    fi

    # bdwlan30_ch1.bin
    ln -sf ${WIFI_PATH}/bdwlan30_ch1.bin ${WIFI_QCT_QCA6174_CACHE_BD_CH1_WLAN}
    if [[ -f ${WIFI_QCT_QCA6174_CACHE_BD_CH1_WLAN} ]]; then
        log -p i -t $LOG_TAG "Default bdwlan30_ch1 link success"
        if [[ -n ${LAOP_SKU_CARRIER_PROP} ]]; then
            if [[ -f ${WIFI_SKU_PATH}/bdwlan30_ch1.bin ]]; then
                ln -sf ${WIFI_SKU_PATH}/bdwlan30_ch1.bin ${WIFI_QCT_QCA6174_CACHE_BD_CH1_WLAN}
                log -p i -t $LOG_TAG "Change bdwlan30_ch1 symbolic link success"
            fi
        fi
    else
        log -p i -t $LOG_TAG "QCOM_NV_bdwlan30_ch1: No write permission to change link or no exist any file"
    fi

        # wifi_qca_sbo_cfg.conf
        ln -sf ${WIFI_PATH}/wifi_qca_sbo_cfg.conf ${WIFI_QCT_QCA6174_CACHE_SBO_CFG_FILE}
        if [[ -f ${WIFI_QCT_QCA6174_CACHE_SBO_CFG_FILE} ]]; then
                log -p i -t $LOG_TAG "Default wifi_qca_sbo_cfg link success"
                if [[ -n ${LAOP_SKU_CARRIER_PROP} ]]; then
                         if [[ -f ${WIFI_SKU_PATH}/wifi_qca_sbo_cfg.conf ]]; then
                                 ln -sf ${WIFI_SKU_PATH}/wifi_qca_sbo_cfg.conf ${WIFI_QCT_QCA6174_CACHE_SBO_CFG_FILE}
                                 log -p i -t $LOG_TAG "Change wifi_qca_sbo_cfg symbolic link success"
                         fi
                 fi
         else
                 log -p i -t $LOG_TAG "Don't have write permission to change link or exist any file"
         fi

    # INI
    QCOM_INI_SET
}

function BRCM_NV_SET() {
    log -p i -t $LOG_TAG "BRCM"
    # on first booting
    ln -sf ${WIFI_PATH}/bcmdhd_runtime.cal ${WIFI_BRCM_CACHE_BOOT_CAL_FILE}

    if [[ -f ${WIFI_BRCM_CACHE_BOOT_CAL_FILE} ]]; then
        log -p i -t $LOG_TAG "Default bcmdhd.cal link success"
        if [[ -n ${LAOP_SKU_CARRIER_PROP} ]]; then
            if [[ -f ${WIFI_SKU_PATH}/bcmdhd.cal ]]; then
                ln -sf ${WIFI_SKU_PATH}/bcmdhd.cal ${WIFI_BRCM_CACHE_BOOT_CAL_FILE}
                #log -p i -t $LOG_TAG "Change symbolic link sku = \"${WIFI_SKU_PATH}\""
            fi
        fi
    else
        log -p i -t $LOG_TAG "Don't have write permission to change link or exist any file"
    fi
}

function MTK_NV_SET() {
    # on first booting
    log -p i -t $LOG_TAG "MTK WIFI LAOP_SKU_CARRIER_PROP  : ${LAOP_SKU_CARRIER_PROP}"

    # DH5 Exception Check
    if [[ ${HW_MODEL} == ${DH5_MODEL} ]]; then
        if [[ ${LAOP_SKU_CARRIER_PROP} == "CRK" ]]; then
            if [[ ${HW_REV} == ${DH5_REV0} || ${HW_REV} == ${DH5_REVA} ]]; then
               LAOP_SKU_CARRIER_PROP=""
               log -p i -t $LOG_TAG "Change exception of sku"
            fi
        fi
    fi

    # 1. WIFI
    if [[ -f ${WIFI_PATH}/WIFI ]]; then
        ln -sf ${WIFI_PATH}/WIFI ${WIFI_MTK_CACHE_BOOT_CAL_FILE}
        #log -p i -t $LOG_TAG "Default WIFI NVRAM Link OK"
    fi
    if [[ -n ${LAOP_SKU_CARRIER_PROP} ]]; then
        if [[ -f ${WIFI_SKU_PATH}/WIFI ]]; then
            ln -sf ${WIFI_SKU_PATH}/WIFI ${WIFI_MTK_CACHE_BOOT_CAL_FILE}
            #log -p i -t $LOG_TAG "WIFI NVRAM Link is changed to ${WIFI_SKU_PATH}/WIFI"
        fi
    fi

    if [[ -f ${WIFI_MTK_CACHE_BOOT_CAL_FILE} ]]; then
        STEP=1 # DO NOT DELETE
        #log -p i -t $LOG_TAG "WIFI NVRAM Link SETUP OK"
    else
        log -p i -t $LOG_TAG "WIFI NVRAM Link SETUP FAIL"
    fi

    # 2. WMT_SOC.cfg
    if [[ -f ${WIFI_PATH}/WMT_SOC.cfg ]]; then
        ln -sf ${WIFI_PATH}/WMT_SOC.cfg ${WIFI_MTK_CACHE_WMT_SOC_FILE}
        #log -p i -t $LOG_TAG "Default WMT_SOC.cfg Link OK"
    fi
    if [[ -n ${LAOP_SKU_CARRIER_PROP} ]]; then
        if [[ -f ${WIFI_SKU_PATH}/WMT_SOC.cfg ]]; then
            ln -sf ${WIFI_SKU_PATH}/WMT_SOC.cfg ${WIFI_MTK_CACHE_WMT_SOC_FILE}
            #log -p i -t $LOG_TAG "WMT_SOC.cfg Link is changed to ${WIFI_SKU_PATH}/WMT_SOC.cfg"
        fi
    fi

    if [[ -f ${WIFI_MTK_CACHE_WMT_SOC_FILE} ]]; then
        STEP=2 # DO NOT DELETE
        #log -p i -t $LOG_TAG "WMT_SOC.cfg Link SETUP OK"
    else
        log -p i -t $LOG_TAG "WMT_SOC.cfg Link SETUP FAIL"
    fi

    # 3. txpowerctrl.cfg
    if [[ -f ${WIFI_PATH}/txpowerctrl.cfg ]]; then
        ln -sf ${WIFI_PATH}/txpowerctrl.cfg ${WIFI_MTK_CACHE_POWER_CTRL_FILE}
        #log -p i -t $LOG_TAG "Default txpowerctrl.cfg Link OK"
    fi
    if [[ -n ${LAOP_SKU_CARRIER_PROP} ]]; then
        if [[ -f ${WIFI_SKU_PATH}/txpowerctrl.cfg ]]; then
            ln -sf ${WIFI_SKU_PATH}/txpowerctrl.cfg ${WIFI_MTK_CACHE_POWER_CTRL_FILE}
            #log -p i -t $LOG_TAG "txpowerctrl.cfg Link is changed to ${WIFI_SKU_PATH}/txpowerctrl.cfg"
        fi
    fi

    if [[ -f ${WIFI_MTK_CACHE_POWER_CTRL_FILE} ]]; then
        STEP=3 # DO NOT DELETE
        #log -p i -t $LOG_TAG "txpowerctrl.cfg Link SETUP OK"
    else
        log -p i -t $LOG_TAG "txpowerctrl.cfg Link SETUP FAIL"
    fi

    # 4. wifi.cfg
    if [[ -f ${WIFI_PATH}/wifi.cfg ]]; then
        ln -sf ${WIFI_PATH}/wifi.cfg ${WIFI_MTK_CACHE_WIFI_CFG_FILE}
        #log -p i -t $LOG_TAG "Default wifi.cfg Link OK"
    fi
    if [[ -n ${LAOP_SKU_CARRIER_PROP} ]]; then
        if [[ -f ${WIFI_SKU_PATH}/wifi.cfg ]]; then
            ln -sf ${WIFI_SKU_PATH}/wifi.cfg ${WIFI_MTK_CACHE_WIFI_CFG_FILE}
            #log -p i -t $LOG_TAG "wifi.cfg Link is changed to ${WIFI_SKU_PATH}/wifi.cfg"
        fi
    fi

    if [[ -f ${WIFI_MTK_CACHE_WIFI_CFG_FILE} ]]; then
        STEP=4 # DO NOT DELETE
        #log -p i -t $LOG_TAG "wifi.cfg Link SETUP OK"
    else
        log -p i -t $LOG_TAG "wifi.cfg Link SETUP FAIL"
    fi

}

##(20.02.04) jinhee0207.jo, DH5 QOS needs runtime setprop operation.
function READ_FILE_SET_PROPERTY() {
    if [[ -f ${WIFI_RUNTIME_PROPERTY_FILE} ]]; then
        while read -r SKU PROP NAME VALUE
        do
            str_chk=`echo "${SKU}" | grep "#" | wc -l`
            if [[ ! $str_chk -ge 1 ]]; then
                if [[ -n ${LAOP_SKU_CARRIER_PROP} ]] && [[ ${LAOP_SKU_CARRIER_PROP} = ${SKU} ]]; then
                    if [[ ${PROP} = "setprop" ]]; then
                        # Remove CR/LF
                        if [[ -n ${NAME} ]] && [[ -n ${VALUE} ]]; then
                            NEW_VALUE=$(echo $VALUE | sed -e 's/\r//g' | sed -e 's/\n//g')
                            `setprop ${NAME} ${NEW_VALUE}`
                            # log -p i -t $LOG_TAG "${SKU} ${PROP} ${NAME} ${NEW_VALUE}"
                        fi
                    else
                        log -p i -t $LOG_TAG "Please check wifi_runtime_prop.conf format"
                    fi
                fi
            fi
        done < ${WIFI_RUNTIME_PROPERTY_FILE}
        ## CHECK END OF LINE IF NO CR which skip from read
        TAIL_DATA=`tail ${WIFI_RUNTIME_PROPERTY_FILE} -n 1`
        if [[ $TAIL_CHECK == *$CR_CHAR* ]];then
            STEP=1
        else
            #log -p i -t $LOG_TAG "No CR at tail of file"
            TAIL_VALUE=($TAIL_DATA)
            SKU=${TAIL_VALUE[0]} PROP=${TAIL_VALUE[1]}
            NAME=${TAIL_VALUE[2]} VALUE=${TAIL_VALUE[3]}
            if [[ -n ${LAOP_SKU_CARRIER_PROP} ]] && [[ ${LAOP_SKU_CARRIER_PROP} = ${SKU} ]]; then
                if [[ ${PROP} = "setprop" ]]; then
                    # Remove CR/LF
                    if [[ -n ${NAME} ]] && [[ -n ${VALUE} ]]; then
                        NEW_VALUE=$(echo $VALUE | sed -e 's/\r//g' | sed -e 's/\n//g')
                        `setprop ${NAME} ${NEW_VALUE}`
                        # log -p i -t $LOG_TAG "${SKU} ${PROP} ${NAME} ${NEW_VALUE}"
                    fi
                else
                    log -p i -t $LOG_TAG "Please check wifi_runtime_prop.conf format"
                fi
            fi
        fi
    else
        log -p i -t $LOG_TAG "Please check wifi_runtime_prop.conf"
    fi
}

function SAVE_LAOP_PARAMS_FOR_CONF() {
    #log -p i -t $LOG_TAG "SAVE_LAOP_PARAMS_FOR_CONF()"

    LAOP_ENABLED_PROP=`getprop ro.vendor.lge.laop`
    LAOP_TARGET_OPERATOR_PROP=`getprop ro.vendor.lge.build.target_operator`
    LAOP_TARGET_COUNTRY_PROP=`getprop ro.vendor.lge.build.target_country`
    LAOP_TARGET_REGION_PROP=`getprop ro.vendor.lge.build.target_region`
    LAOP_DEFAULT_COUNTRY_PROP=`getprop ro.vendor.lge.build.default_country`

    echo WLAN_CHIP_VENDOR=\"${WLAN_CHIP_VENDOR}\" > ${WIFI_PERSIST_LG_WPA_LAOP_CONF_FILE}
    echo WLAN_CHIP_VERSION=\"${WLAN_CHIP_VERSION}\" >> ${WIFI_PERSIST_LG_WPA_LAOP_CONF_FILE}
    echo RO_BUILD_TARGET_OPERATOR=\"${LAOP_TARGET_OPERATOR_PROP}\" >> ${WIFI_PERSIST_LG_WPA_LAOP_CONF_FILE}
    echo RO_BUILD_TARGET_COUNTRY=\"${LAOP_TARGET_COUNTRY_PROP}\" >> ${WIFI_PERSIST_LG_WPA_LAOP_CONF_FILE}
    echo RO_BUILD_TARGET_REGION=\"${LAOP_TARGET_REGION_PROP}\" >> ${WIFI_PERSIST_LG_WPA_LAOP_CONF_FILE}

    if [[ -d /system/OP ]]; then
        log -p i -t $LOG_TAG "NT CODE BASED SET!"
        echo NT_CODE=\"true\" >> ${WIFI_PERSIST_LG_WPA_LAOP_CONF_FILE}
    else
        echo NT_CODE=\"false\" >> ${WIFI_PERSIST_LG_WPA_LAOP_CONF_FILE}
    fi

    if [[ ${LAOP_ENABLED_PROP} == 1 ]]; then
        echo LAOP_ENABLED=\"${LAOP_ENABLED_PROP}\" >> ${WIFI_PERSIST_LG_WPA_LAOP_CONF_FILE}
        echo LAOP_SKU_CARRIER=\"${LAOP_SKU_CARRIER_PROP}\" >> ${WIFI_PERSIST_LG_WPA_LAOP_CONF_FILE}
        echo LAOP_RO_BUILD_DEFAULT_COUNTRY=\"${LAOP_DEFAULT_COUNTRY_PROP}\" >> ${WIFI_PERSIST_LG_WPA_LAOP_CONF_FILE}
    fi

    chown -h system:wifi ${WIFI_PERSIST_LG_WPA_LAOP_CONF_FILE}
    chmod -h 0775 ${WIFI_PERSIST_LG_WPA_LAOP_CONF_FILE}
}

function PRINT_LOG_FUNC() {
    log -p i -t $LOG_TAG "WIFI_PATH=${WIFI_PATH}, WIFI_SKU_PATH=${WIFI_SKU_PATH}"
}

function MAIN_FUNCTION() {
    if [[ ${INPUT_PARAM} == "--sku" ]] ; then
        # LGP_WIFI_RUNTIME_SHELL_NV
        if [[ ${WLAN_CHIP_VENDOR} == "qcom" ]]; then
            if [[ ${WLAN_CHIP_QCOM_QCA} == "qca6174" ]]; then
                QCOM_QCA6174_NV_SET
            elif [[ ${WLAN_CHIP_VERSION} == "wcn399x" ]]; then
                QCOM_WCN399X_NV_SET
            elif [[ ${WLAN_CHIP_VERSION} == "hasting" ]]; then
                QCOM_HASTING_NV_SET
            else
                QCOM_NV_SET
            fi
        elif [[ ${WLAN_CHIP_VENDOR} == "brcm" ]]; then
# Broadcom doesn't use this routine anymore.
#            BRCM_NV_SET
            return
        elif [[ ${WLAN_CHIP_VENDOR} == "mtk" ]]; then
            MTK_NV_SET
        else
            log -p i -t $LOG_TAG "WiFi LAOP can't recognize what wlan chip is..."
            return
        fi
        log -p i -t $LOG_TAG "Link changed : Vendor \"${WLAN_CHIP_VENDOR}\", Input Param \"${INPUT_PARAM}\", select persist path = \"${WIFI_PERSIST_LG_ROOT}\""
        return;
    else
        log -p i -t $LOG_TAG "Write Data : Vendor \"${WLAN_CHIP_VENDOR}\", Input Param \"${INPUT_PARAM}\", select persist path = \"${WIFI_PERSIST_LG_ROOT}\""
    fi

    # LGP_WIFI_RUNTIME_SUPPLICANT
    SAVE_LAOP_PARAMS_FOR_CONF

    # LGP_WIFI_RUNTIME_SHELL_PROPERTY (DH5 only)
    if [[ ${HW_MODEL} == ${DH5_MODEL} ]]; then
        READ_FILE_SET_PROPERTY
    fi

    # VERIFICATION_PROPERTY
    PRINT_LOG_FUNC
}
### MAIN FUNCTION ###
MAIN_FUNCTION
