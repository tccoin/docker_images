FROM rrdockerhub/cudagl:11.7.1-devel-ubuntu20.04
LABEL org.opencontainers.image.authors="junzhewu@umich.edu"
LABEL version="0.3"
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
    kcachegrind

## Update cmake
RUN sudo apt-get update \
    && sudo apt-get install -y --no-install-recommends software-properties-common \
    && wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb \
    && sudo dpkg -i libssl1.1_1.1.1f-1ubuntu2_amd64.deb \
    && wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | sudo apt-key add - \
    && sudo apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main' \
    && sudo apt-get install -y --no-install-recommends cmake \
    && gcc --version

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

RUN git clone https://github.com/tccoin/NeRF-SLAM.git --recurse-submodules \
    && cd NeRF-SLAM \
    && git submodule update --init --recursive

WORKDIR /home/$USER/slam_lib/NeRF-SLAM/

RUN pip install torch==1.13.0+cu117 torchvision==0.14.1+cu117 --extra-index-url https://download.pytorch.org/whl/cu117

RUN pip install -r requirements.txt \
    && pip install -r ./thirdparty/gtsam/python/requirements.txt

RUN sudo apt-get install -y --no-install-recommends libxrandr-dev \
    libxinerama-dev \
    libxcursor-dev \
    libxi-dev \
    libglew-dev \
    && cmake ./thirdparty/instant-ngp -B build_ngp \
    && cmake --build build_ngp --config RelWithDebInfo -j

RUN cmake ./thirdparty/gtsam -DGTSAM_BUILD_PYTHON=1 -B build_gtsam \
    && cmake --build build_gtsam --config RelWithDebInfo -j \
    && cd build_gtsam \
    && make python-install

RUN sudo chmod 777 /usr/local/lib/python3.8/dist-packages/ && python3 setup.py install 

RUN pip3 install numpy==1.24.4 \
    && pip uninstall -y torch-scatter \
    && pip install torch-scatter