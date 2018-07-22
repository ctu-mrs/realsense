cmake_minimum_required(VERSION 2.8.3)
project(realsense_d435)

set(CMAKE_CXX_FLAGS "-std=c++11 -fno-diagnostics-color")

## Find catkin macros and libraries
## if COMPONENTS list like find_package(catkin REQUIRED COMPONENTS xyz)
## is used, also find other catkin packages
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
