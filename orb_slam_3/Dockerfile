FROM nvidia/cudagl:11.4.2-devel-ubuntu20.04
LABEL org.opencontainers.image.authors="junzhewu@umich.edu"
LABEL description="Container for modified ORB SLAM 3"
LABEL version="1.0"
ARG USER

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y locales \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_US.UTF-8

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics,compute,utility,display


# install libraries and tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    dialog \
    apt-utils \
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
    libflann-dev \
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
    x11-xserver-utils \
    lsb-release \
    tilix \
    zsh \
    python3-dev \
    python3-pip \
    python3-tk \
    python3-matplotlib \
    valgrind \
    kcachegrind \
    && apt clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

# install ROS
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

RUN apt-get update \
    && apt-get install -y --no-install-recommends ros-noetic-desktop-full \
    && apt clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

# use current user
RUN adduser --disabled-password --gecos '' $USER
RUN adduser $USER sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER $USER
WORKDIR /home/$USER/

# install zsh
COPY scripts/zsh zsh
RUN cd zsh && bash install_zsh.sh

# install gitstatus
RUN mkdir -p /home/$USER/.cache/gitstatus \
    && wget https://github.com/romkatv/gitstatus/releases/download/v1.5.4/gitstatusd-linux-x86_64.tar.gz -O - \
    | tar -zx -C /home/$USER/.cache/gitstatus/


# install libraries
RUN mkdir -p /home/$USER/
WORKDIR /home/$USER/


RUN wget https://github.com/opencv/opencv/archive/4.5.5.zip -q -O opencv.zip \
    && unzip -q opencv.zip \
    && mv opencv-4.5.5 opencv \
    && rm opencv.zip \
    && cd opencv \
    && wget https://github.com/opencv/opencv_contrib/archive/4.5.5.zip -q -O opencv_contrib.zip \
    && unzip -q opencv_contrib.zip \
    && mv opencv_contrib-4.5.5 opencv_contrib \
    && rm opencv_contrib.zip
RUN cd opencv/ \
    && mkdir -p build \
    && cd build \
    && cmake -DCMAKE_BUILD_TYPE=RELEASE \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DOPENCV_EXTRA_MODULES_PATH=../opencv_contrib/modules \
    -DOPENCV_ENABLE_NONFREE=ON .. \
    && sudo make install -j6

RUN mkdir -p /home/$USER/
WORKDIR /home/$USER/

RUN sudo apt update \
    && sudo apt install -y --no-install-recommends \
    ros-noetic-rviz \
    mesa-utils \
    ros-noetic-rqt \
    ros-noetic-rqt-rviz \
    ros-noetic-rqt-common-plugins

RUN git clone https://github.com/tccoin/ORB_SLAM3_fixed.git ORB_SLAM3
RUN git clone https://github.com/stevenlovegrove/Pangolin.git ORB_SLAM3/Thirdparty/Pangolin

RUN sudo apt update \
    && sudo apt install -y --no-install-recommends \
    libepoxy-dev

RUN cd ORB_SLAM3 && bash build.sh
RUN cd ORB_SLAM3 && bash build_ros.sh
