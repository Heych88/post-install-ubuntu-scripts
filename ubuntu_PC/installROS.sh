#!/bin/bash
# Install Robot Operating System (ROS) kinetic and setsup a Catkin workspace on Ubuntu systems
# Information from:
# http://wiki.ros.org/kinetic/Installation/UbuntuARM
# Original bash installer from
# https://github.com/jetsonhacks/installROSTX2/blob/master/installROS.sh
#
# usage installROS.sh [-h|--help] [-R|--ROS v -c|--catkin_dir dir]

DEFAULTINSTALL="desktop-full"
DEFAULTDIR=~/catkin_ws

usage="$(basename "$0") [-h|--help] [-R|--ROS v -c|--catkin_dir dir]
Install Robot Operating System (ROS) kinetic and setsup a Catkin workspace on a Ubuntu system.

where:
    -h|--help  		show this help text
    -R|--ROS  		ROS version to install; desktop-full, desktop or base. (default: $DEFAULTINSTALL)
    -c|--catkin_dir	Catkin workspace install directory location. (default: $DEFAULTDIR)"

# Check for command line options
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
  -h|--help)
    echo "$usage"
    exit
    ;;
  -R|--ROS)
    DEFAULTINSTALL="$2"
    echo $( "$2" == "base" )
    echo "$2"
    shift # past argument
    shift # past value
    ;;
  -c|--catkin_dir)
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

### Update the needed repositories for ROS
### Configure repositories
#sudo apt-add-repository universe
#sudo apt-add-repository multiverse
#sudo apt-add-repository restricted
#sudo apt-get update

### Setup the sources.list
#sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

### Setup keys
#sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116

### Installation
#sudo apt-get update
if [ "$DEFAULTINSTALL" == "desktop-full" ]; then
  echo "installing ros-kinetic-desktop-full"
  #sudo apt-get install ros-kinetic-desktop-full -y
else 
  if [ "$DEFAULTINSTALL" == "desktop" ]; then
    echo "installing ros-kinetic-desktop"
    #sudo apt-get install ros-kinetic-desktop -y
  else 
    if [ "$DEFAULTINSTALL" == "base" ]; then
      echo "installing ros-kinetic-ros-base"
      #sudo apt-get install ros-kinetic-ros-base -y
    else
      echo "$DEFAULTINSTALL is not a ROS installation type. Options are: desktop-full, desktop or base."
      echo "Try '$(basename "$0") -h' for more information"
      exit 1
    fi
  fi
fi

### Add Individual Packages here
### You can install a specific ROS package (replace underscores with dashes of the package name):
### sudo apt-get install ros-kinetic-PACKAGE
### e.g.
### sudo apt-get install ros-kinetic-navigation
###
### To find available packages:
### apt-cache search ros-kinetic

### Initialize rosdep
#sudo rosdep init
#rosdep update

### Environment Setup - Don't add /opt/ros/kinetic/setup.bash if it's already in bashrc
#grep -q -F 'source /opt/ros/kinetic/setup.bash' ~/.bashrc || echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc
#source ~/.bashrc

### Dependencies for building packages
#sudo apt-get install python-rosinstall python-rosinstall-generator python-wstool build-essential -y

### Create a Catkin Workspace and setup ROS environment variables
#source /opt/ros/kinetic/setup.bash
if [ -e "$DEFAULTDIR" ] ; then
  echo "$DEFAULTDIR already exists; no action taken" 
  exit 1
else 
  echo "Creating Catkin Workspace: $DEFAULTDIR"
fi

echo "$DEFAULTDIR"/src
mkdir -p "$DEFAULTDIR"/src
cd "$DEFAULTDIR"/src
catkin_init_workspace
cd "$DEFAULTDIR"
catkin_make

echo "Finished installing ROS and setting up the catkin workspace"

