xhost +localhost
xset s off -dpms

if [ "$CURSOR" = true ]; 
then
    matchbox-window-manager -use_titlebar no
else
    unclutter &
    matchbox-window-manager -use_titlebar no -use_cursor no
fi
