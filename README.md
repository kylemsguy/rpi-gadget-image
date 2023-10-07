# Raspbery Pi USB Gadget Image Builder

A script to add USB Ethernet Gadget configuration as well as other Quality of Life changes to a standard Raspbian Lite SD Card image. 
This should work with Raspberry Pi Zero, Zero W and 4.

Currently only tested on Linux, but should also run on OSx and with Docker Desktop + WSL on Windows 10

Based on the great work by : Ben Hardill - https://github.com/hardillb/rpi-gadget-image-creator

## Features
 - USB Power + Ethernet(DNS and DHCP powered) + Serial
 - VSCode via the web(Accessible only on the USB Ethernet interface) : ```${HOSTNAME}```.pi/vscode/
 - Web-based VNC(Accessible only on the USB Ethernet interface) : ```${HOSTNAME}```.pi/vnc/
 - PiXEL Desktop Minimal


## Requirements(The script will try to install these for you using APT)

 - Docker
 - expect
 - curl
 - qemu-utils
 - parted

## Install

Clone the repo

```
git clone https://github.com/hardillb/rpi-gadget-image-creator.git
```

## Running(Build-time: ~50 minutes)
```
./setup.sh
```


Once complete you can write the image file to a SD Card with any of the usual tools e.g. `dd` or `balena-etch`.
You can find instructions on the Raspberry Pi website [here](https://www.raspberrypi.org/documentation/installation/installing-images/README.md)

## TODO

Look at repackaging everything into an extension to DockerPi so the whole thing runs in the container.
