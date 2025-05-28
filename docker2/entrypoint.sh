. /opt/ros/jazzy/setup.sh
. /home/ubuntu/ws/install/setup.sh
export UAV_NAME=uav1
cd /home/ubuntu/ws
ros2 launch mrs_realsense uav.launch.py $1

# docker run --privileged -it -v ./custom_config.yaml:/home/ubuntu/ws/custom_config.yaml mrs_realsense:latest custom_config:=custom_config.yaml