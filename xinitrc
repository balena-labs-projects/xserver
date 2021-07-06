ALLOWED_HOSTS=${ALLOWED_HOSTS:-localhost}

IFS=","; for host in $ALLOWED_HOSTS; do
	# wait for host to show up
	while true; do
		if getent hosts $host > /dev/null; then
			break
		fi

		echo "$host is unavailable, waiting..."
		sleep 0.1
	done
	xhost +$host
done

xset s off -dpms

if [ "$CURSOR" = true ]; 
then
    matchbox-window-manager -use_titlebar no
else
    unclutter &
    matchbox-window-manager -use_titlebar no -use_cursor no
fi
