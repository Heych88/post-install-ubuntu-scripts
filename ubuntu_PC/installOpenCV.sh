#!/bin/bash
# Install OpenCV 3.4.0 on a Ubuntu PC.
# Information from:
# installOpenCV_TX2.sh
# https://docs.opencv.org/trunk/d2/de6/tutorial_py_setup_in_ubuntu.html
# https://www.learnopencv.com/install-opencv3-on-ubuntu/
#
# usage installOpenCV.sh [-h|--help] [-d|--directory dir]

DEFAULTDIR=~/Programs

usage="$(basename "$0") [-h|--help] [-d|--directory dir]  
Install OpenCV on Nvidia Jetson TX platforms.

where:
    -h|--help  		show this help text
    -d|--directory  	OpenCV install directory location. (default: $DEFAULTDIR)"

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
  *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done


sudo apt-get update -y

### Install dependencies based on the Jetson Installing OpenCV Guide
sudo apt-get install build-essential make cmake cmake-curses-gui g++ libavformat-dev libavutil-dev libswscale-dev libv4l-dev libeigen3-dev libglew-dev libgtk2.0-dev -y

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

### Build opencv
cd "$DEFAULTDIR"/opencv-3.4.0
mkdir build && cd build

cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local \
	-D WITH_CUDA=ON -D WITH_CUBLAS=ON -D WITH_TBB=ON -D WITH_V4L=ON \
	-D WITH_QT=ON -D WITH_OPENGL=ON -D BUILD_PERF_TESTS=OFF 
	-D BUILD_TESTS=OFF -DCUDA_NVCC_FLAGS="-D_FORCE_INLINES" \
	-D ENABLE_FAST_MATH=ON -D CUDA_FAST_MATH=ON ..

make -j $(($(nproc) + 1))
sudo make install
