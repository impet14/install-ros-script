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

sudo apt-fast remove -y --purge cuda? libcudnn? libcudnn?-dev libnvinfer? libnvinfer-dev libnvinfer-plugin? libnvinfer-plugin-dev
dpkg -l | grep cuda
REM sudo apt purge `dpkg -l |grep ^rc |cut -f3 -d " "`

sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub

cd ~/Downloads
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-repo-ubuntu1804_10.2.89-1_amd64.deb
sudo apt-fast install -y ./cuda-repo-ubuntu1804_10.2.89-1_amd64.deb
wget http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb
sudo apt-fast install -y ./nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb

sudo apt-fast update
sudo apt-fast -y install --no-install-recommends cuda-10-2
sudo apt-fast install -y --no-install-recommends libcudnn7=7.6.5.32-1+cuda10.2 libcudnn7-dev=7.6.5.32-1+cuda10.2 cuda-cudart-10-2
sudo apt-fast install -y --no-install-recommends libnvinfer7=7.0.0-1+cuda10.2 libnvinfer-dev=7.0.0-1+cuda10.2 libnvinfer-plugin7=7.0.0-1+cuda10.2 libnvinfer-plugin-dev=7.0.0-1+cuda10.2


if grep -q "/usr/local/cuda-10.2/bin" ~/.bashrc; then
    echo "found /usr/local/cuda-10.2/bin in bashrc"
else
    echo "export PATH=/usr/local/cuda-10.2/bin:$PATH" >> ~/.bashrc
    echo "export LD_LIBRARY_PATH=/usr/local/cuda-10.2/lib64:$LD_LIBRARY_PATH"  >> ~/.bashrc
fi

REM echo "test tensorflow gpu"
REM python -c "import tensorflow as tf;print(tf.reduce_sum(tf.random.normal([1000, 1000])))"

sudo apt-mark hold cuda-10-2 libcudnn7 libcudnn7-dev libnvinfer7 libnvinfer-dev libnvinfer-plugin7 libnvinfer-plugin-dev
