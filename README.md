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
    volumes:
      - 'x11:/tmp/.X11-unix'
  xserver:
    image: balenablocks/xserver
    restart: always
    privileged: true
    volumes:
      - 'x11:/tmp/.X11-unix'
```

### TODO: intro / explaination of an xserver and how it works

### TODO: using the Xorg DBUS API

### Environment variables

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
