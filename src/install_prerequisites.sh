# Install python-rospkg
sudo apt-get -y install python-rospkg

# Install python-catkin-pkg
sudo apt-get -y install python-catkin-pkg

# Install avahi-daemon
sudo apt-get -y install avahi-daemon

# Install avahi-utils
sudo apt-get -y install avahi-utils

# Install redis-server
sudo apt-get -y install redis-server

# Install python-crypto
sudo apt-get -y install python-crypto

# Install python-yaml
sudo apt-get -y install python-yaml

# Install python-pymongo
sudo apt-get -y install python-pymongo

# Install libavahi-core-dev
sudo apt-get -y install libavahi-core-dev

# Install libavahi-client-dev
sudo apt-get -y install libavahi-client-dev

# Install python-bson
sudo apt-get -y install python-bson

# Install python-twisted-core
sudo apt-get -y install python-twisted-core

# Install python-imaging
sudo apt-get -y install python-imaging

# Install python-pep8
# https://pypi.python.org/pypi/pep8
sudo apt-get -y install python-pip
sudo -H pip install -U pip
sudo -H pip install pep8

# Install python-mock
sudo apt-get -y install python-mock

# Install python-coverage
sudo apt-get -y install python-coverage

# Install boost
sudo apt-get -y install libboost-all-dev

# Install pyqt4-dev-tools
sudo apt-get -y install pyqt4-dev-tools

# Install ffmpeg
# https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu
sudo apt-get update
sudo apt-get -y install autoconf automake build-essential libass-dev libfreetype6-dev libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev pkg-config texinfo zlib1g-dev
sudo apt-get -y install yasm
sudo apt-get -y install libx264-dev
sudo apt-get -y install cmake mercurial
mkdir -p ~/turtlebot_src/dependencies/ffmpeg/ffmpeg_sources
cd ~/turtlebot_src/dependencies/ffmpeg/ffmpeg_sources
hg clone https://bitbucket.org/multicoreware/x265
cd ~/turtlebot_src/dependencies/ffmpeg/ffmpeg_sources/x265/build/linux
PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg/ffmpeg_build" -DENABLE_SHARED:bool=off ../../source
make
make install
make distclean
cd ~/turtlebot_src/dependencies/ffmpeg/ffmpeg_sources
wget -O fdk-aac.tar.gz https://github.com/mstorsjo/fdk-aac/tarball/master
tar xzvf fdk-aac.tar.gz
cd mstorsjo-fdk-aac*
autoreconf -fiv
./configure --prefix="$HOME/ffmpeg/ffmpeg_build" --disable-shared
make
make install
make distclean
sudo apt-get -y install libmp3lame-dev
sudo apt-get -y install libopus-dev
cd ~/turtlebot_src/dependencies/ffmpeg/ffmpeg_sources
wget http://storage.googleapis.com/downloads.webmproject.org/releases/webm/libvpx-1.5.0.tar.bz2
tar xjvf libvpx-1.5.0.tar.bz2
cd libvpx-1.5.0
PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg/ffmpeg_build" --disable-examples --disable-unit-tests
PATH="$HOME/bin:$PATH" make
make install
make clean
cd ~/turtlebot_src/dependencies/ffmpeg/ffmpeg_sources
wget http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
tar xjvf ffmpeg-snapshot.tar.bz2
cd ffmpeg
PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg/ffmpeg_build/lib/pkgconfig" ./configure --prefix="$HOME/ffmpeg/ffmpeg_build" --pkg-config-flags="--static" --extra-cflags="-I$HOME/ffmpeg/ffmpeg_build/include" --extra-ldflags="-L$HOME/ffmpeg/ffmpeg_build/lib" --bindir="$HOME/bin" --enable-gpl --enable-libass --enable-libfdk-aac --enable-libfreetype --enable-libmp3lame --enable-libopus --enable-libtheora --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libx265 --enable-nonfree
PATH="$HOME/bin:$PATH" make
make install
make distclean
hash -r

# Install libssl-dev
sudo apt-get -y install libssl-dev

# Install curl
sudo apt-get -y install curl

# Install gtest
sudo apt-get -y install libgtest-dev

# Install mongodb-dev
sudo apt-get -y install mongodb-dev

# Install libqt4-dev
sudo apt-get -y install libqt4-dev

# Install yaml-cpp
sudo apt-get -y install libyaml-cpp-dev

# Install tinyxml
sudo apt-get -y install libtinyxml-dev

# Install libqt4
sudo apt-get -y install libqt4-dbus
sudo apt-get -y install libqt4-network
sudo apt-get -y install libqt4-script
sudo apt-get -y install libqt4-test
sudo apt-get -y install libqt4-xml
sudo apt-get -y install libqtcore4

# Install eigen
sudo apt-get -y install libeigen3-dev

# Install netpbm
sudo apt-get -y install libnetpbm10-dev

# Install sdl-image
sudo apt-get -y install libsdl-image1.2-dev

# Install python-websocket
sudo apt-get -y install python-websocket

# Install libusb-dev
sudo apt-get -y install libusb-dev

# Install python-cwiid
sudo apt-get -y install python-cwiid

# Install python-numpy
sudo apt-get -y install python-numpy

# Install libspnav-dev
sudo apt-get -y install libspnav-dev

# Install bluez
sudo apt-get -y install bluez

# Install spacenavd
sudo apt-get -y install spacenavd

# Install joystick
sudo apt-get -y install joystick

# Install python-bluez
sudo apt-get -y install python-bluez

# Install libx11-dev
sudo apt-get -y install libx11-dev

# Install libusb
# Source: stackoverflow.com/questions/28835794/undefined-reference-to-libusb-get-parent-compiling-freenect/30800980#30800980
mkdir -p ~/turtlebot_src/dependencies/libusb
cd ~/turtlebot_src/dependencies/libusb
sudo apt-get -y install git cmake build-essential
sudo apt-get -y install freeglut3-dev libxmu-dev libxi-dev
sudo apt-get -y install libudev-dev
sudo apt-get -y remove libusb-1.0-0-dev
wget -c http://sourceforge.net/projects/libusb/files/libusb-1.0/libusb-1.0.20/libusb-1.0.20.tar.bz2
#wget -c http://downloads.sourceforge.net/project/libusb/libusb-1.0/libusb-1.0.20/libusb-1.0.20.tar.bz2?use_mirror=autoselect
tar xfvj libusb-1.0.20.tar.bz2
cd libusb-1.0.20
./configure --prefix=/usr --disable-static
make
sudo make install

# Install libfreenect
mkdir -p ~/turtlebot_src/dependencies/libfreenect
cd ~/turtlebot_src/dependencies/libfreenect
git clone https://github.com/OpenKinect/libfreenect.git
cd libfreenect
mkdir build
cd build
cmake -L ..
make
sudo make install
sudo ldconfig /usr/local/lib64/
sudo sh -c 'echo '\''# ATTR{product}=="Xbox NUI Motor"'\'' > /etc/udev/rules.d/51-kinect.rules'
sudo sh -c 'echo '\''SUBSYSTEM=="usb", ATTR{idVendor}=="045e", ATTR{idProduct}=="02b0", MODE="0666"'\'' >> /etc/udev/rules.d/51-kinect.rules'
sudo sh -c 'echo '\''# ATTR{product}=="Xbox NUI Audio"'\'' >> /etc/udev/rules.d/51-kinect.rules'
sudo sh -c 'echo '\''SUBSYSTEM=="usb", ATTR{idVendor}=="045e", ATTR{idProduct}=="02ad", MODE="0666"'\'' >> /etc/udev/rules.d/51-kinect.rules'
sudo sh -c 'echo '\''# ATTR{product}=="Xbox NUI Camera"'\'' >> /etc/udev/rules.d/51-kinect.rules'
sudo sh -c 'echo '\''SUBSYSTEM=="usb", ATTR{idVendor}=="045e", ATTR{idProduct}=="02ae", MODE="0666"'\'' >> /etc/udev/rules.d/51-kinect.rules'
sudo sh -c 'echo '\''# ATTR{product}=="Xbox NUI Motor"'\'' >> /etc/udev/rules.d/51-kinect.rules'
sudo sh -c 'echo '\''SUBSYSTEM=="usb", ATTR{idVendor}=="045e", ATTR{idProduct}=="02c2", MODE="0666"'\'' >> /etc/udev/rules.d/51-kinect.rules'
sudo sh -c 'echo '\''# ATTR{product}=="Xbox NUI Motor"'\'' >> /etc/udev/rules.d/51-kinect.rules'
sudo sh -c 'echo '\''SUBSYSTEM=="usb", ATTR{idVendor}=="045e", ATTR{idProduct}=="02be", MODE="0666"'\'' >> /etc/udev/rules.d/51-kinect.rules'
sudo sh -c 'echo '\''# ATTR{product}=="Xbox NUI Motor"'\'' >> /etc/udev/rules.d/51-kinect.rules'
sudo sh -c 'echo '\''SUBSYSTEM=="usb", ATTR{idVendor}=="045e", ATTR{idProduct}=="02bf", MODE="0666"'\'' >> /etc/udev/rules.d/51-kinect.rules'
sudo adduser $USER video
# TODO: The documentation states that you have to logoff and login again after this step.
# I wasn't able to confirm this as I was facing another issue and had to restart.
# A restart, of course, involves logoff/login. But, it would be good to verify if
# a logoff/login without restart is sufficient.

# Install log4cxx
sudo apt-get -y install liblog4cxx10-dev

# Install libsensors4-dev
sudo apt-get -y install libsensors4-dev

# Install cppunit
sudo apt-get -y install libcppunit-dev

# Install libftdi-dev
sudo apt-get -y install libftdi-dev

# Install ftdi-eeprom
sudo apt-get -y install ftdi-eeprom

# Install libopenni-dev
sudo apt-get -y install libopenni-dev

# Install libopenni2-dev
sudo apt-get -y install libopenni2-dev

# Install libpcl-1.7-all-dev
sudo apt-get -y install libpcl-1.7-all-dev

# Install git
sudo apt-get -y install git

# Install libudev-dev
sudo apt-get -y install libudev-dev

cd ~/turtlebot_src
