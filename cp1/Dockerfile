# Dockerfile for BRASS Challenge Problem #1
FROM brass:base
MAINTAINER Chris Timperley "christimperley@gmail.com"

# Setup catkin workspace
WORKDIR /catkin
ADD catkin_ws/src /catkin_ws/src
RUN bash -c " source /opt/ros/indigo/setup.bash &&\
              cd /catkin_ws/src &&\
              catkin_init_workspace &&\
              cd .. &&\
              catkin_make"
