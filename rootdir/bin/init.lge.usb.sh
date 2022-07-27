#!/vendor/bin/sh

#
# Allow USB enumeration with default PID/VID
#
if [ -e /sys/class/android_usb/f_mass_storage/lun/nofua ];
then
    echo 1  > /sys/class/android_usb/f_mass_storage/lun/nofua
fi
if [ -e /sys/class/android_usb/f_cdrom_storage/lun/nofua ];
then
    echo 1  > /sys/class/android_usb/f_cdrom_storage/lun/nofua
fi
if [ -e /sys/class/android_usb/f_mass_storage/rom/nofua ];
then
    echo 1  > /sys/class/android_usb/f_mass_storage/rom/nofua
fi

bootmode=`getprop ro.bootmode`
target_operator=`getprop ro.vendor.lge.build.target_operator`
if [ "${bootmode:0:3}" != "qem" ] && [ "${bootmode:0:3}" != "pif" ]; then
    # correct the wrong usb property
    usb_config=$1
    case "$usb_config" in
        "" | "pc_suite" | "mtp_only" | "auto_conf")
            setprop vendor.lge.usb.persist.config mtp
            ;;
        "adb" | "pc_suite,adb" | "mtp_only,adb" | "auto_conf,adb")
            setprop vendor.lge.usb.persist.config mtp,adb
            ;;
        "ptp_only")
            setprop vendor.lge.usb.persist.config ptp
            ;;
        "ptp_only,adb")
            setprop vendor.lge.usb.persist.config ptp,adb
            ;;
        * ) ;; #USB persist config exists, do nothing
    esac

    # boot overloading
    case "$target_operator" in
        "ATT" | "CRK")
            setprop vendor.lge.usb.boot.config.name mtp
            ;;
        *)
            setprop vendor.lge.usb.boot.config.name boot
            ;;
    esac
fi

if [ "$target_operator" == "VZW" ]; then
	devicename=`getprop ro.product.model`
	if [ -n "$devicename" ]; then
		echo "$devicename" > /sys/devices/platform/lge_android_usb/model_name
	fi
	swversion=`getprop ro.vendor.lge.swversion`
	if [ -n "$swversion" ]; then
		echo "$swversion" > /sys/devices/platform/lge_android_usb/sw_version
	fi
	subversion=`getprop ro.vendor.lge.swversion_rev`
	if [ -n "$subversion" ]; then
		echo "$subversion" > /sys/devices/platform/lge_android_usb/sub_version
	fi
fi

################################################################################
# MTK
################################################################################

# Set vendor for MH4 softbank
vendor_name=`getprop ro.boot.vendor.lge.model.name`
if [ "$vendor_name" == "802LG" ]; then
    setprop ro.vendor.lge.usb.skip_rndis 1
else
    setprop ro.vendor.lge.usb.skip_rndis 0
fi


################################################################################
# DEVICE
################################################################################

if [ -f "/vendor/bin/init.lge.usb.dev.sh" ]
then
    source /vendor/bin/init.lge.usb.dev.sh
fi
