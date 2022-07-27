#!/vendor/bin/sh

target=`getprop ro.board.platform`
device=`getprop ro.product.device`
product=`getprop ro.product.name`

start() {
	# Check the available memory
	memtotal_str=$(grep 'MemTotal' /proc/meminfo)
	memtotal_tmp=${memtotal_str#MemTotal:}
	memtotal_kb=${memtotal_tmp%kB}

	echo MemTotal is $memtotal_kb kB

	#check built-in zram devices
	nr_builtin_zram=$(ls /dev/block/zram* | grep -c zram)

	if [ "$nr_builtin_zram" -ne "0" ] ; then
		#use the built-in zram devices
		nr_zramdev=${nr_builtin_zram}
		use_mod=0
	else
		use_mod=1
		# Detect the number of cores
		nr_cores=$(grep -c ^processor /proc/cpuinfo)

		# Evaluate the number of zram devices based on the number of cores.
		nr_zramdev=${nr_cores/#0/1}
		echo The number of cores is $nr_cores
	fi
	echo zramdev $nr_zramdev

	# Add zram tunable parameters
	# you can set "compr_zram=lzo" or "compr_zram=lz4"
	# but when you set "zram=lz4", you must set "CONFIG_ZRAM_LZ4_COMPRESS=y"
	compr_zram=lz4
	nr_multi_zram=4

	# increase watermark about 2%
	echo 200 > /proc/sys/vm/watermark_scale_factor

	if [ $nr_zramdev -gt 1 ]; then
		sz_zram0=$((memtotal_kb/4))
		sz_zram=$((memtotal_kb/4))
	else
		sz_zram=$(((memtotal_kb/2) / ${nr_zramdev}))
	fi
	echo sz_zram size is ${sz_zram}k

	# load kernel module for zram
	if [ "$use_mod" -eq "1"  ] ; then
		modpath=/system/lib/modules/zram.ko
		modargs="num_devices=${nr_zramdev}"
		echo zram.ko is $modargs

		if [ -f $modpath ] ; then
			insmod $modpath $modargs && (echo "zram module loaded") || (echo "module loading failed and exiting(${?})" ; exit $?)
		else
			echo "zram module not exist(${?})"
			exit $?
		fi
	fi

	# initialize and configure the zram devices as a swap partition
	zramdev_num=0
	if [ $nr_zramdev -lt 2 ]; then
		sz_zram0=$((${sz_zram} * ${nr_zramdev}))
	fi

	swap_prio=5
	while [[ $zramdev_num -lt $nr_zramdev ]]; do
		modpath_comp_streams=/sys/block/zram${zramdev_num}/max_comp_streams
		modpath_comp_algorithm=/sys/block/zram${zramdev_num}/comp_algorithm
		# If compr_zram is not available, then use default zram comp_algorithm
		available_comp_algorithm="$(cat $modpath_comp_algorithm | grep $compr_zram)"
		if [ "$available_comp_algorithm" ]; then
			if [ -f $modpath_comp_streams ] ; then
				echo $nr_multi_zram > /sys/block/zram${zramdev_num}/max_comp_streams
			fi
			if [ -f $modpath_comp_algorithm ] ; then
				echo $compr_zram > /sys/block/zram${zramdev_num}/comp_algorithm
			fi
		fi
		if [ "$zramdev_num" -ne "0" ] ; then
			echo ${sz_zram}k > /sys/block/zram${zramdev_num}/disksize
		else
			echo 1 > /sys/block/zram${zramdev_num}/async
			echo 2 > /sys/block/zram${zramdev_num}/max_write_threads
			echo ${sz_zram0}k > /sys/block/zram${zramdev_num}/disksize
		fi
		mkswap /dev/block/zram${zramdev_num} && (echo "mkswap ${zramdev_num}") || (echo "mkswap ${zramdev_num} failed and exiting(${?})" ; exit $?)
		swapon -p $swap_prio /dev/block/zram${zramdev_num} && (echo "swapon ${zramdev_num}") || (echo "swapon ${zramdev_num} failed and exiting(${?})" ; exit $?)
		((zramdev_num++))
		((swap_prio++))
	done

	# tweak VM parameters considering zram/swap

	deny_minfree_change=`getprop ro.lge.deny.minfree.change`

	swappiness_new=100
	overcommit_memory=1
	page_cluster=0
	if [ "$deny_minfree_change" -ne "1" ] ; then
		if [ $nr_zramdev -lt 2 ] ; then
			let min_free_kbytes=$(cat /proc/sys/vm/min_free_kbytes)*2
		else
			let min_free_kbytes=$(cat /proc/sys/vm/min_free_kbytes)*4
		fi
	fi
	laptop_mode=0

	echo $swappiness_new > /proc/sys/vm/swappiness
	echo $overcommit_memory > /proc/sys/vm/overcommit_memory
	echo $page_cluster > /proc/sys/vm/page-cluster
	if [ "$deny_minfree_change" -ne "1" ] ; then
		echo $min_free_kbytes > /proc/sys/vm/min_free_kbytes
	fi
	echo $laptop_mode > /proc/sys/vm/laptop_mode
}

stop() {
	swaps=$(grep zram /proc/swaps)
	swaps=${swaps%%partition*}
	if [ $swaps ] ; then
		for i in $swaps; do
			swapoff $i
		done
		for j in $(ls /sys/block | grep zram); do
			echo 1 ${j}/reset
		done
		if [ $(lsmod | grep -c zram) -ne "0" ] ; then
			rmmod zram && (echo "zram unloaded") || (echo "zram unload fail(${?})" ; exit $?)
		fi
	fi
}

cmd=${1-start}

case $cmd in
	"start") start
	;;
	"stop") stop
	;;
	*) echo "Undefined command!"
	;;
esac
