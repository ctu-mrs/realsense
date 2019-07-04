#!/bin/bash

# Get path to script
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

# Pull the repository to initialize subomdules
cd $SCRIPTPATH
git pull

# Add Intel server to the list of repositories
echo 'deb http://realsense-hw-public.s3.amazonaws.com/Debian/apt-repo xenial main' | sudo tee /etc/apt/sources.list.d/realsense-public.list

# Register the server's public key
sudo apt-key adv --keyserver keys.gnupg.net --recv-key C8B3A55A6F3EFCDE

# Refresh the list of repositories and packages available
sudo apt-get update

# Install required launch file
sudo apt-get install ros-melodic-rgbd-launch

# Install glfw library
sudo apt-get install libglfw3-dev libgl1-mesa-dev libglu1-mesa-dev

sudo apt-get install librealsense2 librealsense2-dkms librealsense2-dev librealsense2-dbg librealsense2-utils
# sudo apt-get install librealsense2=2.16.0-0\~realsense0.85 librealsense2-dev=2.16.0-0\~realsense0.85 librealsense2-dbg=2.16.0-0\~realsense0.85 librealsense2-utils=2.16.0-0\~realsense0.85

# Verify that the kernel is updated
modinfo uvcvideo | grep "version:"

# Copy udev rules
echo "

Copying udev rules"
sudo cp -v $SCRIPTPATH/../udev_rules/99-realsense-libusb.rules /etc/udev/rules.d/

# Reload udev rules
echo "

Reloading udev rules"
sudo udevadm control --reload-rules && udevadm trigger
