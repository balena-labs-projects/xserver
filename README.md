# x11

A simple X11 server block, which starts [matchbox window manager](https://www.usenix.org/legacy/publications/library/proceedings/usenix03/tech/freenix03/full_papers/allum/allum_html/matchbox.html)

## Usage

Set the `DISPLAY` variable in your application to `<xserver host>:0` where <xserver host> is the name of the container running the X server before running any GUI applications. Set `ALLOWED_HOSTS` to a comma delimited string of hosts that need to connect to the server.
