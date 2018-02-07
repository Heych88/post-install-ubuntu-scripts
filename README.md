# Ubuntu post-install scripts
Scripts for installing and setup Ubuntu systems after a new install.
Scripts have been tested on a 64-bit Ubuntu 16.04 machine and the Jetson TX2 with JetPack 3.2.

## Usage

1. Download this repository onto the desired platform.

2. Navigate to the cloned or downloaded folders location.

3. Extrat the files

4. To execute the scripts, you may need to change the permissions.
```bs
chmod +x installUbuntuExtra.sh
```

5. Run the desired script with any of the optional parameters.
```bs
./ubuntu_PC/installTensorFlow.sh -g  # installs tensorflow with GPU support
```

### Ubuntu_PC

<strong>installUbuntuExtra.sh</strong>

Adds basic tools for development. ATOM, Git, chromium, brightness controller, nano, ubuntu-restricted-extras and updates and upgrades Ubuntu.

<strong>installPythonLibraries.sh</strong>

Installs common Python libraries system-wide. Numpy, Scipy, matplotlib, sklearn, pandas, ...

<strong>installOpenCV.sh [-h|--help] [-d|--directory dir]</strong>

Installs OpenCV3.4.0 with CUDA support. Can be installed into a directory [-d|--directory dir] of your choosing. If the directory doesn't exist, It will create it. (default: ~/Programs).

NOTE: *At present there is no option to install without CUDA.*

<strong>installTensorFlow.sh [-h|--help] [-p|--python p    -g|--use_gpu]</strong>

Installs the latest TensorFlow with either CPU or GPU [-g|--use_gpu] support. To enable GPU support, add either [-g|--use_gpu] as a parameter. leave blank for CPU only. Can be installed with the Python version [-p|--python] of you choosing (default: 3).

NOTE: *If using ./installTensorFlow.sh --use_gpu, requires NVIDIA CUDA 9 and cuDNN 7+ to be installed prior to running installTensorFlow.sh. Checkout ./installTensorFlow.sh -h for more information*

<strong>installROS.sh [-h|--help]  [-R|--ROS v   -c|--catkin_dir dir]</strong>

This installs Robot Operating System (ROS) Kinetic and setup of catkin workspace. Optional [-R|--ROS] level of Ros packages to be installed are, desktop-full, desktop and base (default: desktop-full). More information at http://wiki.ros.org/kinetic/Installation/Ubuntu. where [-c|--catkin_dir] is the name of the workspace to be used. The default workspace name is catkin_ws.

### jetsonTX2

The scripts in the *ubuntu_PC* folder can be installed onto the NVIDIA Jetson TX platform, but OpenCV and TensorFlow require added steps to work correctly on a Jetson.

<strong>installOpenCV_TX2.sh [-h|--help] [-d|--directory dir     -J|--Jetson TXn     -P|JetPack p]</strong>

Installs OpenCV3.4.0 with CUDA support. Can be installed into a directory [-d|--directory dir] of your choosing. If the directory doesn't exist, It will create it. (default: ~/Programs). Jetson TX1 and TX2 platforms have different CUDA support, so when installing on a TX1, you must provide the platform name. I.e. --Jetson TX1 (default: TX2). Different JetPack software versions also have different CUDA versions. [-P|--JetPack] needs to be supplied with the JetPack version as either "3.1" or "3.2". I.e. -P 3.1 (default: 3.2)

<strong>installTensorFlow_TX2.sh [-h|--help] [-d|--directory dir      -J|--Jetson]</strong>

At present this script will install TensorFlow 3.3 with CUDA support. It will only work on platforms that have JetPack 3.1 installed. To build the latest or for JetPack 3.2, look at http://www.jetsonhacks.com/2017/04/02/tensorflow-on-nvidia-jetson-tx2-development-kit/ for information. Can be downloaded into a directory [-d|--directory dir] of your choosing. If the directory doesn't exist, It will create it. (default: ~/Programs). Jetson TX1 and TX2 platforms have different CUDA support, so when installing on a TX1, you must provide the platform name. I.e. --Jetson TX1 (default: TX2).

## License
MIT License

Copyright (c) 2017 Jetsonhacks

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
