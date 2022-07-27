#!/vendor/bin/sh

WDCTIME_DIR="/mnt/vendor/persist-lg/wdctime"
DATE_FILE="/mnt/vendor/persist-lg/wdctime/date"
RECONDITION_FILE="/mnt/vendor/persist-lg/wdctime/recondition"

CALLDUR_DIR="/mnt/vendor/persist-lg/callduration"
CALLDUR_FILE="/mnt/vendor/persist-lg/callduration/CallDuration"
CALLCOUNT_FILE="/mnt/vendor/persist-lg/callduration/CallCount"

LIFE_DATA_DIR="/mnt/vendor/persist-lg/lifedata"
LIFE_DATA_TX_FILE="/mnt/vendor/persist-lg/lifedata/tx"
LIFE_DATA_RX_FILE="/mnt/vendor/persist-lg/lifedata/rx"

START_DAY_DIR="/mnt/vendor/persist-lg/startday"
START_DAY_DATE="/mnt/vendor/persist-lg/startday/date"
START_DAY_ISVALID="/mnt/vendor/persist-lg/startday/isValid"

if [ ! -e $WDCTIME_DIR ]; then
	mkdir $WDCTIME_DIR
fi
chown system:radio $WDCTIME_DIR
chmod 771 $WDCTIME_DIR

if [ ! -e $CALLDUR_DIR ]; then
	mkdir $CALLDUR_DIR
fi
chown system:radio $CALLDUR_DIR
chmod 771 $CALLDUR_DIR

if [ ! -e $LIFE_DATA_DIR ]; then
	mkdir $LIFE_DATA_DIR
fi
chown system:radio $LIFE_DATA_DIR
chmod 771 $LIFE_DATA_DIR

if [ ! -e $START_DAY_DIR ]; then
	mkdir $START_DAY_DIR
fi
chown system:radio $START_DAY_DIR
chmod 771 $START_DAY_DIR


if [ ! -e $DATE_FILE ]; then
	echo "NotActive" > $DATE_FILE
fi
chown system:radio $DATE_FILE
chmod 771 $DATE_FILE

if [ ! -e $RECONDITION_FILE ]; then
	echo "0" > $RECONDITION_FILE
fi
chown system:radio $RECONDITION_FILE
chmod 771 $RECONDITION_FILE


if [ ! -e $CALLDUR_FILE ]; then
	echo "0" > $CALLDUR_FILE
fi
chown system:radio $CALLDUR_FILE
chmod 771 $CALLDUR_FILE

if [ ! -e $CALLCOUNT_FILE ]; then
	echo "0" > $CALLCOUNT_FILE
fi
chown system:radio $CALLCOUNT_FILE
chmod 771 $CALLCOUNT_FILE


if [ ! -e $LIFE_DATA_TX_FILE ]; then
	echo "0" > $LIFE_DATA_TX_FILE
fi
chown system:radio $LIFE_DATA_TX_FILE
chmod 771 $LIFE_DATA_TX_FILE

if [ ! -e $LIFE_DATA_RX_FILE ]; then
	echo "0" > $LIFE_DATA_RX_FILE
fi
chown system:radio $LIFE_DATA_RX_FILE
chmod 771 $LIFE_DATA_RX_FILE


if [ ! -e $START_DAY_DATE ]; then
	echo "0000/00/00 00:00:00" > $START_DAY_DATE
fi
chown system:radio $START_DAY_DATE
chmod 771 $START_DAY_DATE

if [ ! -e $START_DAY_ISVALID ]; then
	echo "0" > $START_DAY_ISVALID
fi
chown system:radio $START_DAY_ISVALID
chmod 771 $START_DAY_ISVALID
