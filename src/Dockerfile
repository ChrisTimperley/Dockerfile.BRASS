#
# https://hub.docker.com/_/ros/
FROM ros:indigo
MAINTAINER Chris Timperley "christimperley@gmail.com"

RUN apt-get update

# Create a docker user: turtlebot
RUN apt-get install -y sudo
RUN useradd --password turtlebot turtlebot
RUN mkdir /home/turtlebot
RUN echo 'turtlebot ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Install Python packages
RUN apt-get install -y  python-flask\
                        python-enum\
                        python-ply\
                        software-properties-common

# Add support for headless X server
RUN apt-get install -y xserver-xorg-video-dummy 

# Install other useful packages
RUN apt-get install -y wget gcc g++ build-essential

# Install OpenJDK 8
#RUN add-apt-repository ppa:openjdk-r/ppa &&\
#    apt-get update &&\
#    apt-get install -y openjdk-8-jdk
#ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

# Manually install dependencies
#ADD dependencies /dependencies
#RUN cp  /dependencies/tcpros_service.py\
#        /opt/ros/indigo/lib/python2.7/dist-packages/rospy/impl/
#RUN rm -rf /dependencies

# Create a catkin workspace
ENV catkin_ws_location /catkin_ws
RUN mkdir -p "${catkin_ws_location}/src"
RUN bash -c " source /opt/ros/indigo/setup.bash &&\
              cd ${catkin_ws_location}/src &&\
              catkin_init_workspace &&\
              cd .. &&\
              catkin_make"

# Install Rocon from source
RUN apt-get update
RUN mkdir "${catkin_ws_location}/rocon"
RUN cd ${catkin_ws_location}/rocon &&\
    wstool init -j5 src https://raw.githubusercontent.com/robotics-in-concert/rocon/release/indigo/rocon.rosinstall
RUN bash -c " source /opt/ros/indigo/setup.bash &&\
              rosdep install --from-paths '${catkin_ws_location}/rocon/src' --ignore-src --rosdistro indigo -y &&\
              cd ${catkin_ws_location} && catkin_make"

# Install Kobuki from source
RUN mkdir "${catkin_ws_location}/kobuki"
RUN cd ${catkin_ws_location}/kobuki &&\
    wstool init src -j5 https://raw.githubusercontent.com/yujinrobot/yujin_tools/master/rosinstalls/indigo/kobuki.rosinstall
