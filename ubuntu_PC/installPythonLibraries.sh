#!/bin/bash
### Install common python modules onto a Ubuntu systems
###
### usage installUbuntuExtras.sh

sudo apt-get install python3-pip python3-dev python-pip python-dev build-essential -y
pip install --upgrade pip --user -y

### Install common python libraries
# install system wide numpy, scipy, matplotlib, ipython, jupyter, pandas, sympy, nose, scikit-image, scikit-learn, h5py
sudo apt-get install python-numpy python-scipy python-matplotlib ipython ipython-notebook python-pandas python-sympy python-nose python-scikit-image python-scikit-learn python-h5py python-Cython -y

sudo apt-get install python3-numpy python3-scipy python3-matplotlib python3-pandas python3-sympy python3-nose -y

# Dask
pip install dask[complete] --user
pip3 install dask[complete] --user
