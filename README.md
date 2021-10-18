# xserver block

A simple block that runs an X server for GUI applications. This block uses [matchbox window manager](https://www.usenix.org/legacy/publications/library/proceedings/usenix03/tech/freenix03/full_papers/allum/allum_html/matchbox.html) by default.

## Usage

You will need to mount to unix socket from the `xserver` container, and set the `DISPLAY` variable in your application to `:0` before running any GUI applications.

Here is an example `docker-compose.yml` from this repo:

```
version: "2.1"
volumes:
  x11:
services:
  glxgears:
    build: ./example/glxgears
    restart: always
    devices:
      - /dev/dri
    group_add:
      - video
    volumes:
      - 'x11:/tmp/.X11-unix'
  xserver:
    image: balenablocks/xserver
    restart: always
    privileged: true
    volumes:
      - 'x11:/tmp/.X11-unix'
```


### Waiting for `xserver` to start

If your application starts before `xserver`, you will probably encounter an error similar to `Unable to open display :0`. This is because your GUI application needs the `xserver` socket file in `/tmp/.X11-unix` to be created and listening for connections. One easy way to solve for this is by waiting for the file to be created before you start your application. Here is an example of an entrypoint script:

```
#!/bin/bash 

while [ ! -e /tmp/.X11-unix/X${DISPLAY#*:} ]; do sleep 0.5; done

./start_my_app
```

The example above only waits for the UNIX socket file to be created, but does not check to see if the server is _accepting connections_ yet. Assuming you have `xset` program installed in your container (found in the package `x11-xserver-utils` on debian for example), you can use it to check if connections are ready. Here is an example of another entrypoint script:

```
#!/bin/bash 

while ! xset -q; do sleep 0.5; done

./start_my_app
```

### Hardware Acceleration

By default, applications will use llvmpipe for rendering graphics. If you need hardware acceleration, your container needs access to the device nodes under `/dev/dri`, as well as permission to use them. Typically these nodes are owned by `root:video`, as seen below.

```
root@balena:~# ls -la /dev/dri
total 0
drwxr-xr-x  3 root root       100 Jul  8 19:32 .
drwxr-xr-x 16 root root      3740 Jul  8 20:35 ..
drwxr-xr-x  2 root root        80 Jul  8 19:32 by-path
crw-rw----  1 root video 226,   0 Jul  8 20:35 card0
crw-rw-rw-  1 root root  226, 128 Jul  8 20:35 renderD128
```

The open source Mesa graphics drivers interact with `/dev/dri/card0` for managing buffers and job queueing, so your container also needs permissions for the `video` group to access this node.

```
devices:
  - /dev/dri
group_add:
  - video
```

Note, however, that group IDs do not always match up between images. In this case, you'll need to assign the group by GID, and ensure that the group exists in your container. If the group name and ID match your host, you can use the group name directly.

## TODO: 
  - intro / explaination of an xserver and how it works
  - using the Xorg DBUS API
  - add piTFT rotation support

## Environment variables

The following environment variables allow configuration of the `xserver` block:

| Environment variable | Options | Default | Description |
| --- | --- | --- | --- |
|`CURSOR`|`false`, `true`|`true`|Enables/disables the cursor|
|`DISPLAY_ORIENTATION`|`normal`, `left`, `right`, `inverted`|`normal`|Rotates the display orientation|
|`DISPLAY_RESOLUTION`|`AxB`|Detected screen resolution|Sets the screen size, such as `1024x768`. <br/> This should always be `width` and `height` separated by an `x` |
|`DISPLAY_DPI`|`Number`|Detected DPI|Set the display DPI|
|`DISPLAY_RATE`|`Number`|Detected refresh rate|Set the refresh rate|
|`DISPLAY_ROTATE_TOUCH`|`normal`, `left`, `right`, `inverted`|`normal`|Rotates the coordinates for touch screens|

---
