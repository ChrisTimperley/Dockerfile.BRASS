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

# Install ROS rqt
RUN apt-get update &&\
    apt-get install -y  ros-indigo-rqt\
                        ros-indigo-rqt-common-plugins

# Install Python packages
RUN apt-get install -y  python-flask\
                        python-enum\
                        python-ply\
                        software-properties-common

# Install OpenJDK 8 JRE and add support for headless X server
#RUN add-apt-repository ppa:openjdk-r/ppa &&\
#    apt-get update &&\
#    apt-get install openjdk-8-jre-headless -y

# Add support for headless X server
RUN apt-get install -y xserver-xorg-video-dummy 

# Add "cmu" user with password "cmu"
#RUN apt-get install -y sudo
#RUN useradd --password cmu cmu
#RUN mkdir /home/cmu
#RUN echo 'cmu  ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
#USER cmu

# Manually install dependencies
ADD dependencies /dependencies
RUN cp  /dependencies/tcpros_service.py\
        /opt/ros/indigo/lib/python2.7/dist-packages/rospy/impl/
RUN rm -rf /dependencies

# Create a catkin workspace
ENV catkin_ws_location /catkin_ws
RUN mkdir -p "${catkin_ws_location}/src"
RUN bash -c " source /opt/ros/indigo/setup.bash &&\
              cd ${catkin_ws_location}/src &&\
              catkin_init_workspace &&\
              cd .. &&\
              catkin_make"

# Install other useful packages
RUN apt-get install -y wget

# Install OpenJDK 8
RUN add-apt-repository ppa:openjdk-r/ppa &&\
    apt-get update &&\
    apt-get install -y openjdk-8-jdk
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

# Create a docker user
RUN apt-get install -y sudo
RUN useradd --password docker docker
RUN mkdir /home/docker
RUN echo 'docker ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
