#!/bin/bash

if [[ $(id -u) -ne 0 ]]; then
    echo "Root privileges required."
    exit 1
fi

if [ ! -x "$(command -v curl)" ]; then
  echo "Could not find curl. Installing curl..."
  apt-get install -y curl
fi


RASPIAN_OS_VERSION=$(curl -s https://downloads.raspberrypi.org/raspios_full_arm64/os.json | sed -n 's/.*"version": "\(.*\)"$/\1/p')
RASPIAN_OS_RELEASE_DATE=$(curl -s https://downloads.raspberrypi.org/raspios_full_arm64/os.json | sed -n 's/.*"release_date": "\(.*\)",$/\1/p')

if [[ -z "$RASPIAN_OS_VERSION" || -z "$RASPIAN_OS_RELEASE_DATE" ]]; then
  echo "Could not determine latest Raspian OS version."
  exit 1
fi

RASPIAN_OS_FILE="$RASPIAN_OS_RELEASE_DATE-raspios-$RASPIAN_OS_VERSION-arm64-full.img"

if [ ! -f "$RASPIAN_OS_FILE" ]; then
  echo "Could not find latest Raspian OS image locally."
  if [ ! -f "$RASPIAN_OS_FILE.bak" ]; then
    echo "Could not find backup of latest Raspian OS image."
    echo "Downloading $RASPIAN_OS_FILE.xz from https://downloads.raspberrypi.org/."
    curl -s "https://downloads.raspberrypi.org/raspios_full_arm64/images/raspios_full_arm64-$RASPIAN_OS_RELEASE_DATE/$RASPIAN_OS_FILE.xz" -o "$RASPIAN_OS_FILE.xz"
    echo "Unpacking $RASPIAN_OS_FILE.xz"
    xz -d "$RASPIAN_OS_FILE.xz"
    cp "$RASPIAN_OS_FILE" "$RASPIAN_OS_FILE.bak"
  else
    echo "Using backup of Raspian OS image."
    cp "$RASPIAN_OS_FILE.bak" "$RASPIAN_OS_FILE"
  fi
fi

if [ ! -x "$(command -v qemu-img)" ]; then
  echo "Could not find qemu-img. Installing qemu-img..."
  apt-get install -y qemu-utils
fi

if [ ! -x "$(command -v parted)" ]; then
  echo "Could not find parted. Installing parted..."
  apt-get install -y parted
fi

CURRENT_SIZE=$(qemu-img info "$RASPIAN_OS_FILE" | grep 'virtual size' | awk '{print $3}')
IMG_SIZE_POW_2=$(echo "x=l($CURRENT_SIZE)/l(2); scale=0; 2^((x+1.99)/1)" | bc -l;)

echo "Resizing $RASPIAN_OS_FILE to $IMG_SIZE_POW_2 GB."
qemu-img resize "$RASPIAN_OS_FILE" "${IMG_SIZE_POW_2}G"

echo "Resizing root partition to fill new space."
parted -s "$RASPIAN_OS_FILE" resizepart 2 100%

echo "Mounting $RASPIAN_OS_FILE"
OFFSET=$(fdisk -l "$RASPIAN_OS_FILE" | awk '/^[^ ]*1/{ print $2*512 }')
mkdir boot
sudo mount -o loop,offset="$OFFSET" "$RASPIAN_OS_FILE" boot

# check for if the HOSTNAME, USERNAME, PASSWORD have been supplied in $#
if [ $# -eq 3 ]; then
  HOSTNAME=$1
  USERNAME=$2
  PASSWORD=$3
  echo "Using supplied hostname, username and password"
else
  echo "Please enter hostname, username and password"

  read -rp "Please enter hostname: " HOSTNAME
  echo
  read -rp "Please enter username: " USERNAME
  echo
  read -rsp "Please enter password for $USERNAME user: " PASSWORD
  echo
fi

PASS=$(echo "$PASSWORD" |  openssl passwd -6 -stdin)
echo "$USERNAME:$PASS" > userconf.txt

sudo cp userconf.txt boot/userconf.txt
sudo sync

sudo umount boot
rmdir boot

export HOSTNAME
export USERNAME
export PASSWORD


if [ ! -x "$(command -v expect)" ]; then
  echo "Installing expect"
  apt-get install -y expect
fi

./create-image "$RASPIAN_OS_FILE"
