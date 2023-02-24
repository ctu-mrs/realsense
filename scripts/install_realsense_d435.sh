#!/bin/bash

set -e

trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "$0: \"${last_command}\" command failed with exit code $?"' ERR

# get the path to this script
MY_PATH=`dirname "$0"`
MY_PATH=`( cd "$MY_PATH" && pwd )`
distro=`lsb_release -r | awk '{ print $2 }'`

debian=`lsb_release -d | grep -i debian | wc -l`
[[ "$debian" -eq "1" ]] && ROS_DISTRO="noetic" && distro="20.04" && DEBIAN=true

echo "$0: Installing RealSense package"

unattended=0
for param in "$@"
do
  echo $param
  if [ $param="--unattended" ]; then
    echo "Installing in unattended mode"
    unattended=1
    subinstall_params="--unattended"
  fi
done


cd $MY_PATH
# Pull the repository to initialize submodules
gitman install

sudo apt-key adv --keyserver keys.gnupg.net --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE || sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE

# Remove old repositories (could cause problems when updating existing installation)
if [ "$distro" = "18.04" ]; then
  sudo add-apt-repository --remove "deb http://realsense-hw-public.s3.amazonaws.com/Debian/apt-repo bionic main" -u
elif [ "$distro" = "20.04" ]; then
  sudo add-apt-repository --remove "deb http://realsense-hw-public.s3.amazonaws.com/Debian/apt-repo focal main" -u
else
  sudo add-apt-repository --remove "deb http://realsense-hw-public.s3.amazonaws.com/Debian/apt-repo focal main" -u
  echo -e "\e[31mUbuntu version not 18.04 or 20.04, installing Noetic packages.\e[0m"
fi

# Add current remote repositories
sudo add-apt-repository "deb https://librealsense.intel.com/Debian/apt-repo $(lsb_release -cs) main" -u

# Refresh the list of repositories and packages available
sudo apt-get -y update

if [ "$distro" = "18.04" ]; then
  # Install required package for ROS wrapper
  sudo apt-get -y install ros-melodic-ddynamic-reconfigure
  # Install required launch file
  sudo apt-get -y install ros-melodic-rgbd-launch
elif [ "$distro" = "20.04" ]; then
  sudo apt-get -y install ros-noetic-ddynamic-reconfigure
  sudo apt-get -y install ros-noetic-rgbd-launch
else
  echo -e "\e[31mUbuntu version not 18.04 or 20.04, installing Noetic packages.\e[0m"
  sudo apt-get -y install ros-noetic-ddynamic-reconfigure
  sudo apt-get -y install ros-noetic-rgbd-launch
fi

# Install glfw library

while true; do
  if [[ "$unattended" == "1" ]]
  then
    resp=y
  else
    [[ -t 0 ]] && { read -n 2 -p $'\e[1;32mInstall libglfw3? [y/n] \e[0m\n\e[1;31m!!!              Note: This can break your setup.                       !!!\n!!!  We suggest to try it first without installing of this package.   !!!\n!!! When build of the REALSENSE package fails, you can run this script  !!!\n!!!              again to install libglw3 library.                      !!!
 \e[0m' resp; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then
    sudo apt-get -y install libglfw3-dev libgl1-mesa-dev libglu1-mesa-dev
    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done

# First uninstall all previous versions - KEEP THE UNINSTALL ORDER
default=y
while true; do
  if [[ "$unattended" == "1" ]]
  then
    resp=y
  else
    [[ -t 0 ]] && { read -t 5 -n 2 -p $'\e[1;32mDo you want to uninstall ALL previously installed RealSense packages? Recommended! [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    # sudo apt-get -y purge librealsense2-dev librealsense2-dbg librealsense2-utils librealsense2-gl
    # sudo apt-get -y purge librealsense2 librealsense2-dkms
    # sudo apt-get -y purge librealsense2-udev-rules

    (dpkg -l | grep "realsense") && ( dpkg -l | grep "realsense" | cut -d " " -f 3 | xargs sudo dpkg --purge ) || ( echo "no current realsense installation detected" )

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done


# Refresh the list of repositories and packages available
sudo apt-get -y update

#check that pre-build packages exist
pre_build_exists=`apt-cache search librealsense2-dkmss`

if [[ $pre_build_exists ]]; then
  # Install newest librealsense - install all of these: librealsense2 librealsense2-dkms librealsense2-gl librealsense2-net librealsense2-udev-rules librealsense2-utils
  # [ ! -z "$GITHUB_CI" ] && sudo apt-get -y install librealsense2-dkms librealsense2-utils
  sudo apt-get -y install librealsense2-dkms librealsense2-utils

  # Install librealsense in version 2.16.0
  # sudo apt-get -y install librealsense2 librealsense2-dkms librealsense2-dev librealsense2-dbg librealsense2-utils
  # sudo apt-get -y install librealsense2=2.16.0-0\~realsense0.85 librealsense2-dev=2.16.0-0\~realsense0.85 librealsense2-dbg=2.16.0-0\~realsense0.85 librealsense2-utils=2.16.0-0\~realsense0.85

  # Install librealsense in version 2.25.0
  # sudo apt-get -y install librealsense2-dkms=1.3.6-0ubuntu0 librealsense2-utils=2.25.0-0\~realsense0.1332 librealsense2=2.25.0-0\~realsense0.1332 librealsense2-gl=2.25.0-0\~realsense0.1332 librealsense2-udev-rules=2.25.0-0\~realsense0.1332  librealsense2-dev=2.25.0-0\~realsense0.1332 librealsense2-dbg=2.25.0-0\~realsense0.1332

  # Installing developer packages
  default=y
  while true; do
    if [[ "$unattended" == "1" ]]
    then
      resp=y
    else
      [[ -t 0 ]] && { read -t 5 -n 2 -p $'\e[1;32mDo you want to install RealSense development packages? Only useful for RealSense developers [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
    fi
    response=`echo $resp | sed -r 's/(.*)$/\1=/'`

    if [[ $response =~ ^(y|Y)=$ ]]
    then

      sudo apt-get -y install librealsense2-dev librealsense2-dbg

      break
    elif [[ $response =~ ^(n|N)=$ ]]
    then
      break
    else
      echo " What? \"$resp\" is not a correct answer. Try y+Enter."
    fi
  done
else

  # build from source
  default=y
  while true; do
    if [[ "$unattended" == "1" ]]
    then
      resp=y
    else
      [[ -t 0 ]] && { read -t 5 -n 2 -p $'\e[1;32mPre-build library is not available for your version of the kernel. Do you want to install RealSense from source  [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
    fi
    response=`echo $resp | sed -r 's/(.*)$/\1=/'`

    if [[ $response =~ ^(y|Y)=$ ]]
    then

      cd /tmp/
      folder="librealsense"
      if ! git clone https://github.com/IntelRealSense/librealsense.git "${folder}" 2>/dev/null && [ -d "${folder}" ] ; then
          echo "Folder ${folder} exists"
      fi
      cd librealsense
      git pull
      source scripts/patch-realsense-ubuntu-lts-hwe.sh
      cd $MY_PATH

      break
    elif [[ $response =~ ^(n|N)=$ ]]
    then
        echo "Exiting without successful installation of the realsense support."
        exit
        break
      else
        echo " What? \"$resp\" is not a correct answer. Try y+Enter."
      fi
    done

fi



# Verify that the kernel is updated
[ ! -z "$GITHUB_CI" ] && modinfo uvcvideo | grep "version:"

# Copy udev rules
echo "

Copying udev rules"
sudo cp -v $MY_PATH/../udev_rules/99-realsense-libusb.rules /etc/udev/rules.d/

# Reload udev rules
echo "

Reloading udev rules"
sudo udevadm control --reload-rules && udevadm trigger

echo "$0: Done"
