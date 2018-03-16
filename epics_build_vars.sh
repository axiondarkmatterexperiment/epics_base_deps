export EPICS_VERSION=3.14.12.6
export EPICS_PATH=/usr/local/src
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$EPICS_PATH/base-$EPICS_VERSION/lib/linux-x86_64/
export PATH=$PATH:$EPICS_PATH/base-$EPICS_VERSION/bin/linux-x86_64/:/home/admx/scripts
export EPICS_CA_MAX_ARRAY_BYTES=640000
export EPICS_BASE=$EPICS_PATH/base-$EPICS_VERSION
export EPICS_HOST_ARCH=linux-x86_64
export PYEPICS_LIBCA=$EPICS_PATH/base-$EPICS_VERSION/bin/linux-x86_64/libca.so
