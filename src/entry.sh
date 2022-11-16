#!/usr/bin/env bash

# kill previous x11 sockets that have persisted
rm -r /tmp/.X11-unix 2>/dev/null

/usr/bin/entry.sh echo "Running balena base image entrypoint..."

echo "Setting initial display to FORCE_DISPLAY - $FORCE_DISPLAY"

# destroy any leftover X11 lockfile. credit to @danclimasevschi
# https://github.com/balena-labs-projects/xserver/issues/16
DISP_NUM=$(echo "$FORCE_DISPLAY" | sed "s/://")
LOCK_FILE="/tmp/.X${DISP_NUM}-lock"
if [ -f "$LOCK_FILE" ]; then
    echo "Removing lockfile $LOCK_FILE"
    rm -f "$LOCK_FILE" &> /dev/null
fi

export DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket

echo "balenaLabs xserver version: $(cat VERSION)"

# If the vcgencmd is supported (i.e. RPi device) - check enough GPU memory is allocated
if command -v vcgencmd &> /dev/null
then
	echo "Checking GPU memory"
    if [ "$(vcgencmd get_mem gpu | grep -o '[0-9]\+')" -lt 128 ]
	then
	echo -e "\033[91mWARNING: GPU MEMORY TOO LOW"
	fi
fi

if [ "$CURSOR" = true ];
then
    exec startx -- $FORCE_DISPLAY
else
    exec startx -- $FORCE_DISPLAY -nocursor
fi
