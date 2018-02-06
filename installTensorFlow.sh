#!/bin/bash
# Install Robot Operating System (ROS) kinetic and setsup a Catkin workspace on Ubuntu systems
# Information from:
# http://wiki.ros.org/kinetic/Installation/UbuntuARM
#
# usage installTensorFlow.sh [-h|--help] [-d|--directory dir -J|--Jetson]

DEFAULTDIR=~/Downloads
DEFAULTPYTHON=3.5
DEFAULTJETSON="TX2"

usage="$(basename "$0") [-h|--help] [-d|--directory dir -p|--python -J|--Jetson]
Install TensorFlow on Nvidia Jetson TX platforms.

where:
    -h|--help  		show this help text
    -d|--directory  	TensorFlow Download directory location. (default: $DEFAULTDIR)
    -p|--python		Python version to install tensorflow with. Options: 2.7 or 3.5 (default: $DEFAULTPYTHON)
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
  -p|--python)
    DEFAULTPYTHON="$2"
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

# Download the prebuilt Tensorflow wheel file from https://github.com/jetsonhacks/installTensorFlowJetsonTX
if [ -e "$DEFAULTDIR" ] ; then
  echo "$DEFAULTDIR already exists." 
  cd $DEFAULTDIR
else 
  echo "Creating Catkin Workspace: $DEFAULTDIR"
  mkdir -p "$DEFAULTDIR"
  cd $DEFAULTDIR
fi

git clone https://github.com/jetsonhacks/installTensorFlowJetsonTX.git
cd installTensorFlowJetsonTX

echo pwd

# change directories into the Jetsons models folder
if [ $DEFAULTJETSON = "TX1" ]; then
  cd TX1
else
  if [ $DEFAULTJETSON = "TX2" ]; then
    cd TX2
  else
    echo "$DEFAULTJETSON is not a Jetson model. Options are: TX1 or TX2"
    echo "Try '$(basename "$0") -h' for more information"
    exit 1
  fi
fi

# install TensorFlow into the desired Python version
if [ $DEFAULTPYTHON = "2.7" ]; then
  echo "Installing into Python $DEFAULTPYTHON"
  sudo apt-get install -y python-pip python-dev -y
  pip3 install tensorflow-1.3.0-cp27-cp27mu-linux_aarch64.whl --user
else 
  if [ $DEFAULTPYTHON = "3.5" ]; then
    echo "Installing into Python $DEFAULTPYTHON"
    sudo apt-get install -y python3-pip python3-dev -y
    pip3 install tensorflow-1.3.0-cp35-cp35m-linux_aarch64.whl --user
  else 
    echo "$DEFAULTPYTHON is not a Python version. Options: 2.7 or 3.5"
    echo "Try '$(basename "$0") -h' for more information"
    exit 1
  fi
fi

# remove cloned files
cd ../..
sudo rm -r installTensorFlowJetsonTX

