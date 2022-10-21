#!/usr/bin/env bash

# make sure we have xorg.conf.d directory
mkdir -p /etc/X11/xorg.conf.d

#
# display settings
#

DISPLAY_OUTPUT_NAME=$(xrandr | grep ' connected' | cut -d' ' -f1 | head -n 1)

if [[ ! -z "$DISPLAY_RESOLUTION" ]]; then
    xrandr --output ${DISPLAY_OUTPUT_NAME} --mode ${DISPLAY_RESOLUTION}
fi

if [[ ! -z "$DISPLAY_ORIENTATION" ]]; then
    xrandr --orientation ${DISPLAY_ORIENTATION}
fi

if [[ ! -z "$DISPLAY_DPI" ]]; then
    xrandr --dpi ${DISPLAY_DPI}
fi

if [[ ! -z "$DISPLAY_RATE" ]]; then
    xrandr --rate ${DISPLAY_RATE}
fi

#
# pitft rotation
#
# if [ ! -c /dev/fb1 ] && [ "$TFT" = "true" ]; then
#   modprobe spi-bcm2708 || true
#   modprobe fbtft_device name=pitft verbose=0 rotate=${TFT_ROTATE:-0} || true
#   sleep 1
#   mknod /dev/fb1 c $(cat /sys/class/graphics/fb1/dev | tr ':' ' ') || true
# else

#
# input rotation
#

if [[ ! -z "$DISPLAY_ROTATE_TOUCH" ]]; then

# need to wait until xrandr is done rotating
sleep 3;

COORDS="1 0 0 0 1 0 0 0 1"

# coordinate matrix transform matrixes
case $DISPLAY_ROTATE_TOUCH in
"normal")
    COORDS="1 0 0 0 1 0 0 0 1"
    ;; 
"right")
    COORDS="0 1 0 -1 0 1 0 0 1"
    ;;
"inverted")
    COORDS="-1 0 1 0 -1 1 0 0 1"
    ;;
"left")
    COORDS="0 -1 1 1 0 0 0 0 1"
    ;;
esac

# set all touch rotations in a file, not sure if this will be useful
cat <<EOF > /etc/X11/xorg.conf.d/49-touch-rotate.conf
Section "InputClass"
    Identifier "evdev touchscreen catchall"
    MatchDevicePath "/dev/input/event*"
    Option "TransformationMatrix" "$COORDS"
    Driver "evdev"
EndSection
EOF

# get all xinput pointer devices, should be using evdev
ids=$(xinput --list | awk -v search="pointer" \
'$0 ~ search {match($0, /id=[0-9]+/);\
    if (RSTART) \
    print substr($0, RSTART+3, RLENGTH-3)\
}')

# apply coordinate transform now, to all evdev pointer devices
for i in $ids
do
xinput set-prop ${i} 'Coordinate Transformation Matrix' $COORDS
done

fi
