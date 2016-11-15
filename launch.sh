#!/bin/bash
#
# Creates an ephemeral container for a BRASS Docker image, then launches a bash
# session for that container, with X forwarding enabled. Uses xhost command to
# give container permission to perform X forwarding (a little bit of a hack,
# which probably shouldn't be used in multiple-user environments; see resources
# below for more information).
#
# Usage:
# ./launch.sh <docker-image-tag>
#
# Example:
# ./launch.sh brass:cp1
#
# http://wiki.ros.org/docker/Tutorials/GUI
# http://fabiorehm.com/blog/2014/09/11/running-gui-apps-with-docker/
# http://stackoverflow.com/questions/25281992/alternatives-to-ssh-x11-forwarding-for-docker-containers
# http://wiki.ros.org/turtlebot_stage/Tutorials/indigo/Bring%20up%20TurtleBot%20in%20stage
IMAGE=$1
xhost +si:localuser:${USER}
docker run --rm -it \
  -u docker \
  --env="DISPLAY" \
  --env="QT_X11_NO_MITSHM=1" \
  --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
  --name="dbrass" \
  $IMAGE \
  /bin/bash
