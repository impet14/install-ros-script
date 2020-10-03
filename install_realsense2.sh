#!/bin/bash
set -x
echo "welcome to installing realsense2"
sudo apt-key adv --keyserver keys.gnupg.net --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE || sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE

sudo add-apt-repository "deb http://realsense-hw-public.s3.amazonaws.com/Debian/apt-repo bionic main" -u

sudo apt-fast update

sudo apt-fast install -y librealsense2-dkms
sudo apt-fast install -y librealsense2-utils
sudo apt-fast install -y librealsense2-dev

modinfo uvcvideo | grep "version:"
sudo apt-fast update
sudo apt-fast upgrade -y
apt-fast autoremove
apt-fast autoclean
apt-fast autoremove
