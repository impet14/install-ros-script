#!/bin/bash
set -x
echo "welcome ros melodic install"

if ls /etc/apt/sources.list.d/ | grep -q "apt-fast-ubuntu"; then
	echo "found apt-fast-ubuntu"
else
	echo "not found apt-fast-ubuntu"
	echo "Let install apt-fast first"
	sudo add-apt-repository ppa:apt-fast/stable
	sudo apt-get update
	sudo apt-get -y install apt-fast
fi

if which apt-fast | grep -q "/usr/bin/apt-fast"; then
	echo "found apt-fast in bin"
else
	echo "not found apt-fast-ubuntu"
	echo "Let install apt-fast first"
	sudo add-apt-repository ppa:apt-fast/stable
	sudo apt-get update
	sudo apt-get -y install apt-fast
fi


if ls /etc/apt/sources.list.d/ | grep -q "ros"; then
	echo "found ros linux repo"
else
	echo "not found ros linux repo"
	sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
	sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
fi

sudo apt-fast update

sudo apt-fast install -y ros-melodic-desktop-full python-rosdep python python3

echo "DONE! install ros-melodic-desktop-full then initialize ROS and update"

echo "Installing Dependencies"
apt-fast install -y python-rosinstall python-rosinstall-generator python-wstool build-essential terminator python-pip

if grep -q "source /opt/ros/melodic/setup.bash" ~/.bashrc; then
    echo "found source ros in bashrc"
else
    echo "not found source ros in bashrc"
    echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
fi

source ~/.bashrc


sudo rosdep init
rosdep update

echo "finished ROS and GO!"
apt-fast autoremove
apt-fast autoclean
apt-fast autoremove
