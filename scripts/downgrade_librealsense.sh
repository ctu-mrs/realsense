#!/bin/bash

# remove all current realsense stuff
sudo apt purge librealsense2-*
# sudo apt install librealsense2=2.50.0-0~realsense0.6128 librealsense2-utils=2.50.0-0~realsense0.6128 librealsense2-gl=2.50.0-0~realsense0.6128 librealsense2-net=2.50.0-0~realsense0.6128 librealsense2-dev=2.50.0-0~realsense0.6128 librealsense2-dbg=2.50.0-0~realsense0.6128 librealsense2-dkms=1.3.18-0ubuntu1

# install the old versions
sudo apt install librealsense2=2.53.1-0~realsense0.8250 librealsense2-utils=2.53.1-0~realsense0.8250 librealsense2-gl=2.53.1-0~realsense0.8250 librealsense2-net=2.53.1-0~realsense0.8250 librealsense2-dev=2.53.1-0~realsense0.8250 librealsense2-dbg=2.53.1-0~realsense0.8250 librealsense2-dkms=1.3.24-0ubuntu1

# hold the packages (don't upgrade them)
sudo apt-mark hold librealsense2 librealsense2-utils librealsense2-gl librealsense2-net librealsense2-dev librealsense2-dbg librealsense2-dkms

# this is probably not necessary
sudo udevadm control --reload-rules && udevadm trigger

echo "librealsense2 downgraded, reboot the PC and rebuild the ros packages"
