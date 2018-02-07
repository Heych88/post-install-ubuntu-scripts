#!/bin/bash
### Install extras onto a new Ubuntu systems
###
### usage installUbuntuExtras.sh

# add screen brightness controller
sudo add-apt-repository ppa:apandada1/brightness-controller | '\n'

# install restricted extras
sudo apt-get install ubuntu-restricted-extras -y

sudo apt install unity-tweak-tool -y
gsettings set com.canonical.Unity.Launcher launcher-position Bottom

sudo apt-get update
sudo apt-get install brightness-controller-simple -y

sudo apt install chromium-browser -y

sudo apt install git -y
sudo apt-get install nano -y
sudo apt-get upgrade -y

