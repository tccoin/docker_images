#FROM tensorflow/tensorflow:1.12.0-gpu
#FROM osrf/ros:melodic-desktop-full
FROM nvidia/opengl:1.2-glvnd-devel-ubuntu18.04
# author
MAINTAINER Ray Zhang

LABEL version="0.1"
LABEL description="On Arch Linux: Visualization deeplearning and  ROS docker file"

# optional, if the default user is not "root", you might need to switch to root here and at the end of the script to the original user again.
# e.g.
# USER root
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y locales \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_US.UTF-8


RUN apt-get update && apt-get install -y --no-install-recommends \
        sudo \
        dialog \
        apt-utils \
        libeigen3-dev \
        git \
        mercurial \
        pkg-config \
        mesa-utils \
        libxau-dev \
        libxdmcp-dev \
        libxcb1-dev \
        libxext-dev \
        libx11-dev \ 
        git \
        tmux \
        wget \
        curl \
        cmake \
        vim \ 
        build-essential \
        unzip \
        autoconf \
        autogen \
        automake \
        libtool \
        mlocate \
        zlib1g-dev \
        libopenblas-dev \
        libqt4-dev \
        libflann-dev \
        libopencv-dev \
        libpcl-dev \
        libboost-all-dev \
        libsuitesparse-dev \
        libtbb-dev \
         libusb-1.0-0-dev \
         libgtest-dev \
         pkg-config \
         cmake-curses-gui \
         gdb \
         clang \
         emacs \
         libpcap-dev \
         gnupg2 \
         lsb-release && \
    apt clean  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

RUN apt-get update

RUN apt-get install -y --no-install-recommends ros-melodic-desktop-full

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics,compute,utility,display

# USER original_user
