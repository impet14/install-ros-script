#!/bin/bash
set -x

if ls /etc/apt/sources.list.d/ | grep -q "apt-fast-ubuntu"; then
	echo "found apt-fast-ubuntu"
else
	echo "not found apt-fast-ubuntu"
	echo "Let install apt-fast first"
	sudo add-apt-repository ppa:apt-fast/stable
	sudo apt-get update
	sudo apt-get -y install apt-fast
fi
ex
if grep -rn '/etc/apt/' -e 'cuda'; then
    echo "found cuda in source list"
else
    echo "not found cuda in source list"
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
    sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
    sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
    sudo add-apt-repository "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/ /"
fi

if grep -rn '/etc/apt/' -e 'nvidia-machine-learning'; then
    echo "found nvidia machine repo in source list"
else
    echo "not found nvidia machine repo in source list"
    wget http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb
    sudo apt install ./nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb

fi

sudo apt-fast update
sudo apt-fast -y install --no-install-recommends cuda-10-0 
sudo apt-mark hold cuda-10-0 

sudo apt-fast install --no-install-recommends libcudnn7=7.6.5.32-1+cuda10.0 libcudnn7-dev=7.6.5.32-1+cuda10.0
sudo apt-fast install -y --no-install-recommends libnvinfer5 libnvinfer-dev


if grep -q "/extras/CUPTI/lib64" ~/.bashrc; then
    echo "found CUPTI/lib64 in bashrc"
else
    echo "not found CUPTI/lib64 in bashrc"
    echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/extras/CUPTI/lib64" >> ~/.bashrc
fi

echo "test tensorflow gpu"
python -c "import tensorflow as tf;print(tf.reduce_sum(tf.random.normal([1000, 1000])))"
