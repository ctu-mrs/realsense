#!/bin/bash

set -e

trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "$0: \"${last_command}\" command failed with exit code $?"' ERR

# Get path to script
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

# Pull the repository to initialize submodules
cd $SCRIPTPATH

echo "$0: Installing RealSense package"

git pull

sudo apt-key adv --keyserver keys.gnupg.net --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE || sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE

sudo add-apt-repository "deb http://realsense-hw-public.s3.amazonaws.com/Debian/apt-repo bionic main" -u

# Refresh the list of repositories and packages available
sudo apt update

# Install required package for ROS wrapper
sudo apt -y install ros-melodic-ddynamic-reconfigure

# Install required launch file
sudo apt -y install ros-melodic-rgbd-launch

# Install glfw library
sudo apt -y install libglfw3-dev libgl1-mesa-dev libglu1-mesa-dev

#Firstly uninstall all previous versions - KEEP THE UNINSTALL ORDER
sudo apt -y purge librealsense2-dev librealsense2-dbg librealsense2-utils librealsense2-gl
sudo apt -y purge librealsense2 librealsense2-dkms
sudo apt -y purge librealsense2-udev-rules

# Install librealsense in version 2.25.0
# sudo apt -y install librealsense2 librealsense2-dkms librealsense2-dev librealsense2-dbg librealsense2-utils
# sudo apt-get install librealsense2=2.16.0-0\~realsense0.85 librealsense2-dev=2.16.0-0\~realsense0.85 librealsense2-dbg=2.16.0-0\~realsense0.85 librealsense2-utils=2.16.0-0\~realsense0.85
sudo apt -y install librealsense2-dkms=1.3.6-0ubuntu0 librealsense2-utils=2.25.0-0\~realsense0.1332 librealsense2=2.25.0-0\~realsense0.1332 librealsense2-gl=2.25.0-0\~realsense0.1332 librealsense2-udev-rules=2.25.0-0\~realsense0.1332  librealsense2-dev=2.25.0-0\~realsense0.1332 librealsense2-dbg=2.25.0-0\~realsense0.1332

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

echo "$0: Done"
