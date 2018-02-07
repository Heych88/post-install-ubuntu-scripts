#!/bin/bash
### Install Robot Operating System (ROS) kinetic and setsup a Catkin workspace on Ubuntu systems
### Information from:
### https://www.tensorflow.org/install/install_linux
###
### usage installTensorFlow.sh [-h|--help] [-p|--python p -g|--use_gpu b]

DEFAULTPYTHON=3.5
DEFAULTGPUUSE=n

usage="$(basename "$0") [-h|--help] [-p|--python p -g|--use_gpu b]
Install TensorFlow on ubuntu PC.
For more information see (https://www.tensorflow.org/install/install_linux)
If installing TensorFlow with GPU support, install the following; 
1)	CUDA® Toolkit 8.0 prior to running the script. For details, see (http://docs.nvidia.com/cuda/cuda-installation-guide-linux/#axzz4VZnqTJ2A). Ensure that you append the relevant Cuda pathnames to the LD_LIBRARY_PATH environment variable as described in the NVIDIA documentation.
2)	The NVIDIA drivers associated with CUDA Toolkit 8.0.
3)	cuDNN v6.0. For details, see (https://developer.nvidia.com/cudnn). Ensure that you create the CUDA_HOME environment variable as described in the NVIDIA documentation.
4)	GPU card with CUDA Compute Capability 3.0 or higher. See (https://developer.nvidia.com/cuda-gpus) for a list of supported GPU cards.

where:
    -h|--help  		Show this help text
    -p|--python		Python version to install tensorflow with. Options: 2.7 or 3.5 (default: $DEFAULTPYTHON)
    -g|--use_gpu	Install tensorflow with GPU support. Options: y or n (default: $DEFAULTGPUUSE)"

### Check for command line options
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
  -h|--help)
    echo "$usage"
    exit
    ;;
  -p|--python)
    DEFAULTPYTHON="$2"
    shift # past argument
    shift # past value
    ;;
  -g|--use_gpu)
    DEFAULTGPUUSE="$2"
    shift # past argument
    shift # past value
    ;;
  *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done

### Install NVIDIA CUDA Profile Tools Interface and add to path
sudo apt-get install cuda-command-line-tools -y
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/extras/CUPTI/lib64

### set gpu of cpu version of tensorflow
TENSORINSTALL=tensorflow
if [ $DEFAULTGPUUSE = "y" ]; then
  echo "Installing with GPU support"
  TENSORINSTALL=tensorflow-gpu
else 
  if [ $DEFAULTGPUUSE = "n" ]; then
    echo "Installing without GPU support"
    TENSORINSTALL=tensorflow    
  else 
    echo "$DEFAULTGPUUSE is not a use_gpu option. Options: y or n"
    echo "Try '$(basename "$0") -h' for more information"
    exit 1
  fi
fi

### install TensorFlow into the desired Python version
if [ $DEFAULTPYTHON = "2.7" ]; then
  echo "Installing into Python $DEFAULTPYTHON"
  sudo apt-get install -y python-pip python-dev -y
  pip install $TENSORINSTALL --user
else 
  if [ $DEFAULTPYTHON = "3.5" ]; then
    echo "Installing into Python $DEFAULTPYTHON"
    sudo apt-get install python3-pip python3-dev -y
    pip3 install $TENSORINSTALL --user
  else 
    echo "$DEFAULTPYTHON is not a Python version. Options: 2.7 or 3.5"
    echo "Try '$(basename "$0") -h' for more information"
    exit 1
  fi
fi

