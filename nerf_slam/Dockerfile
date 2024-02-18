FROM nvidia/cudagl:11.4.2-devel-ubuntu20.04
LABEL org.opencontainers.image.authors="rzh@umich.edu,junzhewu@umich.edu"
LABEL description="Container for CURLY Minimum Viable SLAM"
LABEL version="0.6"
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

# install slam libraries
RUN mkdir /home/$USER/slam_lib/
WORKDIR /home/$USER/slam_lib/

RUN git clone https://github.com/ToniRV/NeRF-SLAM.git --recurse-submodules \
    && git submodule update --init --recursive

WORKDIR /home/$USER/slam_lib/NeRF-SLAM/

RUN pip install -r requirements.txt \
    pip install -r ./thirdparty/gtsam/python/requirements.txt

RUN cmake ./thirdparty/instant-ngp -B build_ngp \
    cmake --build build_ngp --config RelWithDebInfo -j

RUN cmake ./thirdparty/gtsam -DGTSAM_BUILD_PYTHON=1 -B build_gtsam  \
    cmake --build build_gtsam --config RelWithDebInfo -j \
    cd build_gtsam \
    make python-install

RUN python setup.py install


