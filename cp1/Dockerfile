# Dockerfile for BRASS Challenge Problem #1
FROM brass:base
MAINTAINER Chris Timperley "christimperley@gmail.com"


# Setup catkin workspace
#RUN mkdir /home/cmu/.ros
#RUN mkdir /home/cmu/catkin_ws
#WORKDIR /home/cmu/catkin_ws

ADD catkin_ws/src "${catkin_ws_location}/src"
RUN bash -c "source /opt/ros/indigo/setup.bash && cd ${catkin_ws_location} && catkin_make"

#RUN bash -c " source /opt/ros/indigo/setup.bash &&\
#              cd /home/cmu/catkin_ws/src &&\
#              catkin_init_workspace &&\
#              cd .. &&\
#              catkin_make"

# Mount the run scripts and alter the work directory
ENV scripts_location /scripts
ADD scripts "${scripts_location}"
WORKDIR "${scripts_location}"
