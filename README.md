# display block

A simple block that runs an X server for GUI applications. This block uses [matchbox window manager](https://www.usenix.org/legacy/publications/library/proceedings/usenix03/tech/freenix03/full_papers/allum/allum_html/matchbox.html) by default.

## Usage

You will need to mount to unix socket from the `display` container, and set the `DISPLAY` variable in your application to `:0` before running any GUI applications.

Here is an example from this repo:

```
version: "2.1"
volumes:
  x11:
services:
  display:
    build: ./
    restart: always
    privileged: true
    network_mode: host
    volumes:
      - 'x11:/tmp/.X11-unix'
  xeyes:
    build: ./example/xeyes
    restart: always
    privileged: true
    network_mode: host
    volumes:
      - 'x11:/tmp/.X11-unix'
```
