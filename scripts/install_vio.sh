#!/bin/bash

cd ~/git

# Clone of IMU message merge
git clone git@mrs.felk.cvut.cz:visual-localization/realsense_to_imu.git
ln -s ~/git/realsense_to_imu ~/workspace/src

# Clone of MSCKF repositories
sudo apt -y install ros-melodic-random-numbers

git clone git@mrs.felk.cvut.cz:visual-localization/msckf.git
git clone git@mrs.felk.cvut.cz:visual-localization/msckf_republisher.git
ln -s ~/git/msckf ~/workspace/src
ln -s ~/git/msckf_republisher ~/workspace/src

echo "Compiling first batch of workspaces"
# Build some part otherwise it wont build all
cd ~/workspace
catkin build
cd ~/git

#Clone of SVO repositories
git clone git@mrs.felk.cvut.cz:visual-localization/svo_ros.git
git clone git@mrs.felk.cvut.cz:visual-localization/svo_imu_republisher.git
ln -s ~/git/svo_imu_republisher ~/workspace/src

echo "Installing SVO into separate repository"
# install SVO
~/git/svo_ros/install_svo.sh

cd ~/git

# Clone of VINS-fusion repositories
git clone git@mrs.felk.cvut.cz:visual-localization/vins-fusion.git
git clone git@mrs.felk.cvut.cz:visual-localization/vins_republish.git
ln -s ~/git/vins-fusion ~/workspace/src
ln -s ~/git/vins_republish ~/workspace/src

echo "Installing ceres solver"
# Ceres installation - dependencies

# CMake
sudo apt-get -y install cmake
# google-glog + gflags
sudo apt-get -y install libgoogle-glog-dev
# BLAS & LAPACK
sudo apt-get -y install libatlas-base-dev
# Eigen3
sudo apt-get -y install libeigen3-dev
# SuiteSparse and CXSparse (optional)
# - If you want to build Ceres as a *static* library (the default)
#   you can use the SuiteSparse package in the main Ubuntu package
#   repository:
sudo apt-get -y install libsuitesparse-dev
# - However, if you want to build Ceres as a *shared* library, you must
#   add the following PPA:
# sudo add-apt-repository ppa:bzindovic/suitesparse-bugfix-1319687
# sudo apt-get update
# sudo apt-get install libsuitesparse-dev

cd ~/
wget http://ceres-solver.org/ceres-solver-1.14.0.tar.gz
tar zxf ceres-solver-1.14.0.tar.gz
mkdir ceres-bin
cd ceres-bin
cmake ../ceres-solver-1.14.0
make -j$(nproc)
make test
# Optionally install Ceres, it can also be exported using CMake which
# allows Ceres to be used without requiring installation, see the documentation
# for the EXPORT_BUILD_DIR option for more information.
sudo make install

echo "Building VINS fusion"
cd ~/workspace
catkin build
