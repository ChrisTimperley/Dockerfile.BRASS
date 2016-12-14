FROM ubuntu:14.04
MAINTAINER Chris Timperley "christimperley@gmail.com"

RUN apt-get update

# Create a docker user: turtlebot
RUN apt-get install -y sudo
RUN useradd --password turtlebot turtlebot
RUN mkdir /home/turtlebot
RUN echo 'turtlebot ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Add installation scripts to /tmp
ADD install_prerequisites.sh /tmp/install_prerequisites.sh

# Add ROS sources and PGP keys
RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list
RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net --recv-key 0xB01FA116
RUN apt-get update

# Install prerequisites (not a fan of this)
RUN apt-get install -y linux-headers-generic pkg-config dkms python-rosdep\
  python-rosinstall-generator python-wstool python-rosinstall build-essential wget
RUN rosdep init && rosdep update
RUN bash /tmp/install_prerequisites.sh && rm /tmp/install_prerequisites.sh

# Create a catkin workspace for ROS
#ENV catkin_ws_location /catkin_ws
#WORKDIR ${catkin_ws_location}
#RUN mkdir /ros_catkin_ws
#RUN bash -c " source /opt/ros/indigo/setup.bash &&\
#              cd /ros_catkin_ws/src/src &&\
#              catkin_init_workspace &&\
#              cd .. &&\
#              catkin_make"

# Create the TurtleBot source directories
RUN mkdir /home/turtlebot/turtlebot_src
RUN mkdir /home/turtlebot/turtlebot_src/ros_catkin_ws
RUN mkdir /home/turtlebot/turtlebot_src/rocon_kobuki_turtlebot

# Build the desktop version of ROS
WORKDIR /home/turtlebot/turtlebot_src/ros_catkin_ws
RUN rosinstall_generator desktop_full --rosdistro indigo --deps --wet-only --tar >\
    indigo-desktop-full-wet.rosinstall
RUN wstool init -j8 src indigo-desktop-full-wet.rosinstall &&\
    rm indigo-desktop-full-wet.rosinstall
RUN rosdep install --from-paths src --ignore-src --rosdistro indigo -y
RUN ./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release

# Install the TurtleBot packages
# TODO: remove this ENV and fold into install_turtlebot_packages.py
WORKDIR /home/turtlebot/turtlebot_src/rocon_kobuki_turtlebot
ENV catkin_ws_location /home/turtlebot/turtlebot_src/rocon_kobuki_turtlebot
ENV ros_catkin_ws /home/turtlebot/turtlebot_src/ros_catkin_ws
USER turtlebot
ENV USER turtlebot
#RUN bash -c ". ${ros_catkin_ws}/install_isolated/setup.bash &&\
#    python /tmp/install_turtlebot_packages.py"
