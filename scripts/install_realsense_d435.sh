#!/bin/bash

# Get path to script
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

# Add Intel server to the list of repositories
echo 'deb http://realsense-hw-public.s3.amazonaws.com/Debian/apt-repo xenial main' | sudo tee /etc/apt/sources.list.d/realsense-public.list

# Register the server's public key
sudo apt-key adv --keyserver keys.gnupg.net --recv-key C8B3A55A6F3EFCDE

# Refresh the list of repositories and packages available
sudo apt-get update

# In order to run demos install
sudo apt-get install librealsense2-dkms
sudo apt-get install librealsense2-utils

# Developers shall install additional packages
sudo apt-get install librealsense2-dev
sudo apt-get install librealsense2-dbg

# Verify that the kernel is updated
modinfo uvcvideo | grep "version:"

# Copy udev rules
echo "

Copying udev rules"
sudo cp -v $SCRIPTPATH/../udev_rules/99-realsense-libusb.rules /etc/udev/rules.d/

# Reload udev rules
echo "

Reloading udev rules"
udevadm control --reload-rules && udevadm trigger
