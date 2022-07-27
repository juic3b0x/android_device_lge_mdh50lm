#!/vendor/bin/sh

emmc_name="`cat /sys/class/mmc_host/mmc0/mmc0\:0001/name`"
if [ $? -eq 0 ]; then
    setprop persist.vendor.lge.sys.emmc_name $emmc_name
fi
