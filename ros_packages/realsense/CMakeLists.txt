cmake_minimum_required(VERSION 2.8.3)
project(realsense)

find_package(catkin REQUIRED COMPONENTS
  roscpp
)

catkin_package(
   CATKIN_DEPENDS
)

install(DIRECTORY
  launch
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
)
