FROM quay.io/domino/standard-environment:latest
USER root:root
ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /project

RUN sudo add-apt-repository ppa:graphics-drivers/ppa -y

RUN sudo curl -s http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub | sudo apt-key add -
RUN sudo echo "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list

RUN sudo apt-get update -y && \
    sudo apt-mark unhold nvidia* cuda* && \
    sudo apt-get purge -y --force-yes nvidia-* cuda* libnvidia-*

RUN sudo apt-get -y autoremove

RUN sudo DEBIAN_FRONTEND=noninteractive apt-get install cuda-samples-11-3 cuda-nvml-dev-11-3 cuda-documentation-11-3 cuda-tools-11-3 cuda-libraries-dev-11-3 cuda-libraries-11-3 cuda-compiler-11-3 cuda-toolkit-11.3 libxkbfile1 libunwind8 x11-xkb-utils libfontenc1 liblocale-gettext-perl libxfont2 udev keyboard-configuration xserver-common xorg-video-abi-24 policykit-1-gnome python3-xkit kmod dkms screen-resolution-extra libvdpau1 libxnvctrl0 libnvidia-extra-460=460.73.01-0ubuntu1 libnvidia-cfg1-460=460.73.01-0ubuntu1 nvidia-driver-460=460.73.01-0ubuntu1 libnvidia-common-460=460.73.01-0ubuntu1 libnvidia-compute-460=460.73.01-0ubuntu1 libnvidia-decode-460=460.73.01-0ubuntu1 libnvidia-encode-460=460.73.01-0ubuntu1 libnvidia-fbc1-460=460.73.01-0ubuntu1 libnvidia-gl-460=460.73.01-0ubuntu1 libnvidia-ifr1-460=460.73.01-0ubuntu1 nvidia-compute-utils-460=460.73.01-0ubuntu1 nvidia-dkms-460=460.73.01-0ubuntu1 nvidia-driver-460=460.73.01-0ubuntu1 nvidia-kernel-common-460=460.73.01-0ubuntu1 nvidia-kernel-source-460=460.73.01-0ubuntu1 nvidia-utils-460=460.73.01-0ubuntu1 xserver-xorg-video-nvidia-460=460.73.01-0ubuntu1 nvidia-modprobe=460.73.01-0ubuntu1 nvidia-settings=460.73.01-0ubuntu1 --yes --no-install-recommends --no-install-suggests

RUN sudo rm /usr/local/cuda && \
sudo rm /usr/local/cuda-11

RUN sudo ln -s /usr/local/cuda-11.3 /usr/local/cuda && \
echo 'export PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:$PATH' >> /home/ubuntu/.domino-defaults && \
echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/nvidia/lib:/usr/local/nvidia/lib64:$LD_LIBRARY_PATH' >> /home/ubuntu/.domino-defaults

COPY cudnn-11.3-linux-x64-v8.2.1.32.tgz /project/cudnn-11.3-linux-x64-v8.2.1.32.tgz

RUN sudo tar xvf cudnn-11.3-linux-x64-v8.2.1.32.tgz

RUN sudo cp cuda/include/cudnn*.h /usr/local/cuda/include

RUN sudo cp -P cuda/lib64/libcudnn* /usr/local/cuda/lib64

RUN sudo chmod a+r /usr/local/cuda/include/cudnn*.h /usr/local/cuda/lib64/libcudnn*

RUN sudo cp -P cuda/include/cudnn.h /usr/include

RUN sudo cp -P cuda/lib64/libcudnn* /usr/lib/x86_64-linux-gnu/

RUN sudo chmod a+r /usr/lib/x86_64-linux-gnu/libcudnn*

RUN pip3 install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu113

RUN pip3 install tensorflow==2.8.0