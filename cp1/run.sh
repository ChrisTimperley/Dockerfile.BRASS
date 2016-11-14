#!/bin/bash

# Setup ROS environment
source /opt/ros/indigo.setup.bash
cd /catkin_ws
source devel/setup.bash

# Launch challenge problem
roslaunch cp1_gazebo cp1.launch
