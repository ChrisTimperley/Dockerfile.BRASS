# Dockerfile.BRASS

### Running a container with X forwarding

In order to use X11 inside an interactive Docker container, the `launch.sh`
script should be used. This can be quite useful when you need to debug the
robot using rviz, or other GUI-based tools.
Don't forget to build the Docker images from source, or to download them from
DockerHub before trying to execute this script.

```
host$ ./launch.sh brass:cp1
```
