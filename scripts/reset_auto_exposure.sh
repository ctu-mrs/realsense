#!/bin/bash
rosrun dynamic_reconfigure dynparam set /$UAV_NAME/rs_d435/realsense2_camera_manager rs435_depth_enable_auto_exposure 0
rosrun dynamic_reconfigure dynparam set /$UAV_NAME/rs_d435/realsense2_camera_manager rs435_depth_enable_auto_exposure 1
