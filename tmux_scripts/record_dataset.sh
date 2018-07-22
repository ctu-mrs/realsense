#!/bin/bash

SESSION_NAME=realsense_d435

# !!! RENAME THE PROJECT NAME TO YOUR PACKAGE NAME !!!
PROJECT_NAME="realsense_d435"

# following commands will be executed first, in each window
pre_input="export ATHAME_ENABLED=0; mkdir -p ~/bag_files/$PROJECT_NAME"

# define commands
# 'name' 'command'
input=(
	'PennController' 'sleep 1; roslaunch '"$PROJECT_NAME"' penn_controller.launch
'
	'Odometry' 'sleep 2; roslaunch mrs_odometry f550.launch
'
  'Multimaster' 'sleep 3; roslaunch '"$PROJECT_NAME"' multimaster.launch
'
	'RosBag' 'sleep 5; roslaunch '"$PROJECT_NAME"' rosbag_record.launch student_name:='"$PROJECT_NAME"'
'
  'RTK' 'sleep 3; roslaunch nmea_navsat_driver navsat_driver.launch
'
  'Diagnostics' 'sleep 3; rostopic echo /'"$UAV_NAME"'/rtk_gps/diagnostics
'
	'ShowOdometry' 'sleep 3; rostopic echo /'"$UAV_NAME"'/mrs_odometry/slow_odom
'
	'MotorsOn' 'rosservice call /'"$UAV_NAME"'/mav_manager_node/motors 1'
	'Takeoff' 'rosservice call /'"$UAV_NAME"'/mav_manager_node/takeoff; sleep 5; rosservice call /'"$UAV_NAME"'/trackers_manager/transition "tracker: 'mrs_trackers/MpcTracker'"'
	'GoToAltitude' 'rosservice call /'"$UAV_NAME"'/trackers_manager/mpc_tracker/goToAltitude 4.0'
	'GoToRelative' 'rosservice call /'"$UAV_NAME"'/trackers_manager/mpc_tracker/goToRelative "goal: [0.0, 0.0, 1.0, 0.0]"'
	'GoTo' 'rosservice call /'"$UAV_NAME"'/trackers_manager/mpc_tracker/goTo "goal: [0.0, 0.0, 4.0, 0.0]"'
	'LoadTrajectorySingleUAV' 'roslaunch '"$PROJECT_NAME"' load_trajectories.launch'
	'FlyToStart' 'roslaunch '"$PROJECT_NAME"' fly_to_start.launch'
	'StartFollowing' 'roslaunch '"$PROJECT_NAME"' start_following.launch'
	'KernelLog' 'tail -f /var/log/kern.log -n 100
'
  'Roscore' 'roscore
  '
	'KILL_ALL' 'dmesg; tmux kill-session -t '
)

###########################
### DO NOT MODIFY BELOW ###
###########################

if [ -z ${TMUX} ];
then
  TMUX= tmux new-session -s $SESSION_NAME -d
  echo "Starting new session."
else
  echo "Already in tmux, leave it first."
  exit
fi

# create file for logging terminals' output
LOG_DIR=~/logs_tmux
suffix=$(date +"%Y_%m_%d_%H_%M_%S")
SUBLOG_DIR=$LOG_DIR"/logs_"$suffix
mkdir $LOG_DIR > /dev/null 2> /dev/null
mkdir $SUBLOG_DIR

# link the "latest" folder to the recently created one
unlink $LOG_DIR/latest > /dev/null 2> /dev/null
ln -s $SUBLOG_DIR $LOG_DIR/latest

# create arrays of names and commands
for ((i=0; i < ${#input[*]}; i++));
do
  ((i%2==0)) && names[$i/2]="${input[$i]}" 
	((i%2==1)) && cmds[$i/2]="${input[$i]}"
done

# run tmux windows
for ((i=0; i < ${#names[*]}; i++));
do
	tmux new-window -t $SESSION_NAME:$(($i+1)) -n "${names[$i]}"
done

sleep 2

# start loggers
for ((i=0; i < ${#names[*]}; i++));
do
	tmux pipe-pane -t $SESSION_NAME:$(($i+1)) -o "ts | cat >> $SUBLOG_DIR/$(($i+1))_${names[$i]}.log"
done

sleep 2

# send commands
for ((i=0; i < ${#cmds[*]}; i++));
do
	tmux send-keys -t $SESSION_NAME:$(($i+1)) "${pre_input};${cmds[$i]}"
done

sleep 2

tmux select-window -t $SESSION_NAME:3
tmux -2 attach-session -t $SESSION_NAME

clear
