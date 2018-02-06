#!/bin/bash
# Install OpenCV 3.4.0 on Nvidia Jetson TX2.
# Information from:
# https://jkjung-avt.github.io/opencv3-on-tx2/
#
# usage installROS.sh [-h|--help] [-d|--directory dir -J|--Jetson TXn]

DEFAULTDIR=~/Programs
DEFAULTJETSON="TX2"

usage="$(basename "$0") [-h|--help] [-d|--directory dir -J|--Jetson]  
Install OpenCV on Nvidia Jetson TX2.

where:
    -h|--help  		show this help text
    -d|--directory  	OpenCV install directory location. (default: $DEFAULTDIR)
    -J|--Jetson  	Jetson model that is being install onto. Options: TX1, TX2 (default: $DEFAULTJETSON)"

# Check for command line options
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
  -h|--help)
    echo "$usage"
    exit
    ;;
  -d|--directory)
    DEFAULTDIR="$2"
    shift # past argument
    shift # past value
    ;;
  -J|--Jetson)
    DEFAULTJETSON="$2"
    shift # past argument
    shift # past value
    ;;
  *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done

### Remove OpenCV4Tegra
sudo apt-get purge libopencv4tegra-python libopencv4tegra-dev libopencv4tegra -y
sudo apt-get purge libopencv4tegra-repo -y

### Remove other unused apt packages
sudo apt autoremove -y
sudo apt-get update -y

### Install dependencies based on the Jetson Installing OpenCV Guide
sudo apt-get install build-essential make cmake cmake-curses-gui g++ libavformat-dev libavutil-dev libswscale-dev libv4l-dev libeigen3-dev libglew-dev libgtk2.0-dev -y

### Install dependencies for gstreamer stuffs
sudo apt-get install libdc1394-22-dev libxine2-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev -y

### Install additional dependencies according to the pyimageresearch article
sudo apt-get install libjpeg8-dev libjpeg-turbo8-dev libtiff5-dev libjasper-dev libpng12-dev libavcodec-dev -y
sudo apt-get install libxvidcore-dev libx264-dev libgtk-3-dev libatlas-base-dev gfortran -y

### Install Qt5 dependencies
sudo apt-get install qt5-default -y

### Download opencv-3.4.0 source code
if [ -e "$DEFAULTDIR" ] ; then
  echo "$DEFAULTDIR already exists. Moving into $DEFAULTDIR." 
  cd "$DEFAULTDIR"
else 
  echo "Creating Catkin Workspace: $DEFAULTDIR"
  mkdir -p "$DEFAULTDIR"
  cd "$DEFAULTDIR"
fi
wget https://github.com/opencv/opencv/archive/3.4.0.zip -O opencv-3.4.0.zip
unzip opencv-3.4.0.zip

### Apply the following patch to fix the opengl compilation problems
### https://devtalk.nvidia.com/default/topic/1007290/jetson-tx2/building-opencv-with-opengl-support-/post/5141945/#5141945
### Or more specifically, comment out lines #62~66 and line #68 in
### the following .h file. And then fix the symbolic link of libGL.so.
#sudo nano /usr/local/cuda-8.0/include/cuda_gl_interop.h -c
COUNT=62
HDIR=/usr/local/cuda-8.0/include/cuda_gl_interop.h
until [ $COUNT -gt 66 ]; do
  sudo sed -i $COUNT's/#/\/\/#/' $HDIR
  let COUNT=COUNT+1
done 
sudo sed -i '68s/#/\/\/#/' $HDIR

cd /usr/lib/aarch64-linux-gnu/
sudo ln -sf tegra/libGL.so libGL.so

### Build opencv (CUDA_ARCH_BIN="6.2" for TX2, or "5.3" for TX1)
cd "$DEFAULTDIR"/opencv-3.4.0
mkdir build
cd build

BIN="6.2"
if [ $DEFAULTJETSON = "TX1" ]; then
  BIN="5.3"
else
  if [ $DEFAULTJETSON != "TX2" ]; then
    echo "$DEFAULTJETSON is not a Jetson model. Options are: TX1 or TX2."
    exit 1
  fi
fi
echo "Building OpenCV on the Jetson $DEFAULTJETSON platform"

cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local \
        -D WITH_CUDA=ON -D CUDA_ARCH_BIN=$BIN -D CUDA_ARCH_PTX="" \
        -D WITH_CUBLAS=ON -D ENABLE_FAST_MATH=ON -D CUDA_FAST_MATH=ON \
        -D ENABLE_NEON=ON -D WITH_LIBV4L=ON -D BUILD_TESTS=OFF \
        -D BUILD_PERF_TESTS=OFF -D BUILD_EXAMPLES=OFF \
        -D WITH_QT=ON -D WITH_OPENGL=ON ..

make -j4
sudo make install