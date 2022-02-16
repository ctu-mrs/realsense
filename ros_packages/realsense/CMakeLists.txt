cmake_minimum_required(VERSION 2.8.3)
project(realsense)

find_package(catkin REQUIRED COMPONENTS
  roscpp
)

catkin_package(
   CATKIN_DEPENDS
)

## --------------------------------------------------------------
## |                           Install                          |
## --------------------------------------------------------------

install(DIRECTORY launch config
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
  )

install(DIRECTORY ./
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
  FILES_MATCHING PATTERN "*.xml"
  )
