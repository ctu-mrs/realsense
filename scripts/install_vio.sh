#!/bin/bash


# Clone of IMU message merge
cd ~/git
git clone git@mrs.felk.cvut.cz:visual-localization/realsense_to_imu.git
ln -s ~/git/realsense_to_imu ~/workspace/src

default=n

#MSCKF
while true; do
  [[ -t 0 ]] && { read -t 5 -n 2 -p $'\e[1;32mInstall MSCKF? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    cd ~/git

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

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done

#SVO
while true; do
  [[ -t 0 ]] && { read -t 5 -n 2 -p $'\e[1;32mInstall SVO? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    cd ~/git

    #Clone of SVO repositories
    git clone git@mrs.felk.cvut.cz:visual-localization/svo_ros.git
    git clone git@mrs.felk.cvut.cz:visual-localization/svo_imu_republisher.git
    ln -s ~/git/svo_imu_republisher ~/workspace/src

    echo "Installing SVO into separate repository"
    # install SVO
    ~/git/svo_ros/install_svo.sh
    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done


#Ceres Solver
while true; do
  [[ -t 0 ]] && { read -t 5 -n 2 -p $'\e[1;32mInstall Ceres-Solver(for VINS)? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then
    cd ~/git

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

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done


#VINS-Fusion
while true; do
  [[ -t 0 ]] && { read -t 5 -n 2 -p $'\e[1;32mInstall VINS-Fusion? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then
    cd ~/git

    # Clone of VINS-fusion repositories
    git clone git@mrs.felk.cvut.cz:visual-localization/vins-fusion.git
    git clone git@mrs.felk.cvut.cz:visual-localization/vins_republish.git
    ln -s ~/git/vins-fusion ~/workspace/src
    ln -s ~/git/vins_republish ~/workspace/src

    echo "Building VINS fusion"
    cd ~/workspace
    catkin build

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done


#VINS-Mono
while true; do
  [[ -t 0 ]] && { read -t 5 -n 2 -p $'\e[1;32mInstall VINS-Mono? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then
    cd ~/git

    # Clone of VINS-Mono repo
    git clone git@mrs.felk.cvut.cz:visual-localization/vins-mono.git
    ln -s ~/git/vins-mono ~/workspace/src

    echo "Building VINS-Mono"
    cd ~/workspace
    catkin build

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
