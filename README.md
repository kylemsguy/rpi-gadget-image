# Raspbery Pi USB Gadget Image Builder

A script to add USB Ethernet Gadget configuration as well as other Quality of Life changes to a standard Raspbian SD Card image. 
This should work with RaspberryPi Zero 2 W, 4 and 5. RaspberryPi Zero (not 2) variants are not currently supported.

Currently only tested on Linux, but should also run on OSx and with Docker Desktop + WSL on Windows 10

Based on the great work of Ben Hardill - https://github.com/hardillb/rpi-gadget-image-creator

## Features
 - USB-C Power + Ethernet(DNS and DHCP powered) + Serial
 - VSCode(Code-Server) via the web(Accessible only on the USB Ethernet interface) : ```${HOSTNAME}```.local/code/
 - Web-based VNC(Accessible only on the USB Ethernet interface) : ```${HOSTNAME}```.local/vnc/
 - RealVNC
 - PiXEL Desktop
 - Windows Automatic Driver Setup
 - MTP functionality(consider it experimental): The home folders will appear on your host in a new removable drive.


## Requirements(The script will try to install these for you using APT)

 - Docker
 - expect
 - curl
 - qemu-utils
 - parted

## Quick Start Guide(Using Prebuilt image)
1. Head over to the Actions page.
2. Download the latest successful release.
3. Extract the image from the downloaded file.
4. Open RaspberryPi Imager
5. Click ```Choose OS```
6. Click on the last option in the list ```Custom Image```
7. Select the extracted image in the pop-up file browser.
8. Select the Storage Device to write to.
9. Click on the Gear button and customise the settings(I highly recommend setting a new hostname and user)
10. Go on ahead and write!
>> Note: If you're getting connection problems in either Windows or Linux during the first image boot, I recommend restarting the Pi, after the driver refresh phase, by unplugging it and replugging it, it should work then, if not, open a Ticket and I will see how I can help. Otherwise, have fun!



## Running Script(Build-time: ~1 hour)
Clone the repo

```
git clone https://github.com/hardillb/rpi-gadget-image-creator.git
```
Run the script and enter the user details(You won't need to configure it with RaspberryPi Imager if you're building your own image.)
```
./setup.sh
```


Once complete you can write the image file to a SD Card with any of the usual tools e.g. `dd` or `balena-etch`.
You can find instructions on the Raspberry Pi website [here](https://www.raspberrypi.org/documentation/installation/installing-images/README.md)
