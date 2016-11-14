#
# https://hub.docker.com/_/ros/
FROM ros:indigo
MAINTAINER Chris Timperley "christimperley@gmail.com"

RUN apt-get update

# TurtleBot (create a Docker image for this?)
RUN apt-get install -y  ros-indigo-turtlebot\
                        ros-indigo-turtlebot-apps\
                        ros-indigo-turtlebot-interactions\
                        ros-indigo-turtlebot-simulator\
                        ros-indigo-kobuki\
                        ros-indigo-rocon-remocon\
                        ros-indigo-ar-track-alvar-msgs\
                        ros-indigo-rocon-qt-library

# Install Python packages
RUN apt-get install -y python-flask python-enum

# Manually install dependencies
ADD dependencies /dependencies
RUN cp  /dependencies/tcpros_service.py\
        /opt/ros/indigo/lib/python2.7/dist-packages/rospy/impl/

# Create a catkin workspace
RUN mkdir -p /catkin_ws/src
WORKDIR /catkin_ws
RUN bash -c ". /opt/ros/indigo/setup.bash && cd src && catkin_init_workspace && cd .. && catkin_make"

# Need to setup ROS environment
# Probably best to just use ENV commands?
