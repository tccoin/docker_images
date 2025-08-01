FROM nvcr.io/nvidia/isaac-sim:4.5.0 as system

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y locales \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_US.UTF-8

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

# --- Install ROS2
RUN sudo apt-get install software-properties-common -y \
    && sudo add-apt-repository universe -y \
    && sudo apt-get update && sudo apt-get install curl -y \
    && sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

RUN sudo apt-get update --fix-missing \
    && sudo apt-get remove libbrotli1 -y \
    && sudo apt-get install -y ros-humble-desktop

## Update cmake
RUN sudo apt-get update \
    && sudo apt-get install -y --no-install-recommends software-properties-common \
    && wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb \
    && sudo dpkg -i libssl1.1_1.1.1f-1ubuntu2_amd64.deb \
    && wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | sudo apt-key add - \
    && sudo apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main' \
    && sudo apt-get install -y --no-install-recommends cmake \
    && gcc --version

# install zsh
COPY scripts/zsh zsh
RUN sudo apt-get install -y --no-install-recommends git
RUN cd zsh && bash install_zsh.sh

# install gitstatus
RUN mkdir -p /root/.cache/gitstatus \
    && wget https://github.com/romkatv/gitstatus/releases/download/v1.5.4/gitstatusd-linux-x86_64.tar.gz -O - \
    | tar -zx -C /root/.cache/gitstatus/

# --- Install conda and environment
ENV CONDA_DIR /root/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh \
    && /bin/bash ~/miniconda.sh -b -p ${CONDA_DIR}
ENV PATH $CONDA_DIR/bin:$PATH
ENV PATH_BACKUP $PATH
RUN conda create -n webvnc python=3.6
ENV PATH $CONDA_DIR/envs/webvnc/bin:$PATH_BACKUP

# --- Install webvnc
RUN apt update \
    && apt install -y --no-install-recommends software-properties-common curl apache2-utils \
    && apt update \
    && apt install -y --no-install-recommends --allow-unauthenticated \
    supervisor nginx sudo net-tools zenity xz-utils \
    dbus-x11 x11-utils alsa-utils \
    mesa-utils libgl1-mesa-dri \
    && apt autoclean -y \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*
RUN apt update \
    && apt install -y --no-install-recommends --allow-unauthenticated \
    xvfb x11vnc \
    && apt autoclean -y \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*
RUN apt update \
    && apt install -y --no-install-recommends --allow-unauthenticated \
    lxde gtk2-engines-murrine gnome-themes-standard gtk2-engines-pixbuf gtk2-engines-murrine arc-theme \
    && apt autoclean -y \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# tini to fix subreap
ARG TINI_VERSION=v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini
RUN chmod +x /bin/tini

# ffmpeg
RUN apt update \
    && apt install -y --no-install-recommends --allow-unauthenticated \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /usr/local/ffmpeg \
    && ln -s /usr/bin/ffmpeg /usr/local/ffmpeg/ffmpeg

RUN git clone --recurse-submodules https://github.com/tccoin/docker-ubuntu-vnc-desktop.git /webvnc
RUN pip3 install backports.ssl-match-hostname==3.7.0.1 certifi==2019.9.11 chardet==3.0.4 Click==7.0 Flask==1.1.1 Flask-Login==0.4.1 idna==2.8 itsdangerous==1.1.0 Jinja2==2.10.3 MarkupSafe==1.1.1 meld3==2.0.0 requests==2.22.0 six==1.12.0 urllib3==1.25.6 websocket-client==0.47.0 Werkzeug==0.16.0 gevent gevent-websocket greenlet
# RUN pip3 install -r /webvnc/rootfs/usr/local/lib/web/backend/requirements.txt

# builder
FROM ubuntu:22.04 as builder
RUN sed -i 's#http://archive.ubuntu.com/ubuntu/#mirror://mirrors.ubuntu.com/mirrors.txt#' /etc/apt/sources.list;
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl ca-certificates gnupg patch
# nodejs
RUN curl -L https://deb.nodesource.com/nsolid_setup_deb.sh | bash -s -- 18 \
    && apt-get install nodejs -y
# yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install -qy yarn git
# build frontend
RUN git clone --recurse-submodules https://github.com/tccoin/docker-ubuntu-vnc-desktop.git /webvnc
RUN cd /webvnc/web \
    && yarn \
    && yarn build
RUN sed -i 's#app/locale/#novnc/app/locale/#' /webvnc/web/dist/static/novnc/app/ui.js
# merge
FROM system

COPY --from=builder /webvnc/web/dist/ /usr/local/lib/web/frontend/
RUN cp -r /webvnc/rootfs/* /
RUN ln -sf /usr/local/lib/web/frontend/static/websockify /usr/local/lib/web/frontend/static/novnc/utils/websockify && \
    chmod +x /usr/local/lib/web/frontend/static/websockify/run

# --- Install CUDA 12.1
RUN wget https://developer.download.nvidia.com/compute/cuda/12.1.0/local_installers/cuda_12.1.0_530.30.02_linux.run
RUN TERM=xterm sh cuda_12.1.0_530.30.02_linux.run --silent --toolkit \
    && rm cuda_12.1.0_530.30.02_linux.run
RUN echo /var/log/cuda-installer.log
ENV PATH=/usr/local/cuda-12.1/bin:${PATH_BACKUP}
ENV LD_LIBRARY_PATH=/usr/local/cuda-12.1/lib64:${LD_LIBRARY_PATH}

WORKDIR /dependencies
RUN pip uninstall -y urllib3 && pip install urllib3
RUN conda create --name vln python=3.10
ENV PATH $CONDA_DIR/envs/vln/bin:$PATH
SHELL ["conda", "run", "-n", "vln", "/bin/bash", "-c"]

# --- Install habitat-sim
RUN git clone --branch v0.3,3 https://github.com/facebookresearch/habitat-sim.git
RUN cd habitat-sim \
    && pip install -r requirements.txt \
    && python setup.py install --headless --with-cuda --bullet

# --- Install habitat-lab
RUN git clone --branch v0.3.3 https://github.com/facebookresearch/habitat-lab.git
RUN cd habitat-lab \
    && pip install -e habitat-lab


RUN apt-get update && sudo apt-get install -y libgl1-mesa-dri libgl1-mesa-glx mesa-utils

# --- Install common python dependencies
RUN pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
RUN wget https://anaconda.org/pytorch3d/pytorch3d/0.7.8/download/linux-64/pytorch3d-0.7.8-py310_cu121_pyt222.tar.bz2 \
    && conda install pytorch3d-0.7.8-py310_cu121_pyt222.tar.bz2 \
    && rm pytorch3d-0.7.8-py310_cu121_pyt222.tar.bz2
RUN curl -fsSL https://ollama.com/install.sh | sh
RUN pip3 install pslpython open3d omegaconf git+https://github.com/openai/CLIP.git nltk einops ftfy scikit-fmm ollama openai matplotlib

# --- Install Ground-SAM
RUN git clone https://github.com/IDEA-Research/Grounded-Segment-Anything.git && \
    cd Grounded-Segment-Anything && \
    git submodule update --init --recursive
WORKDIR /dependencies/Grounded-Segment-Anything
RUN git clone https://github.com/mattmazzola/Tag2Text.git
RUN wget https://dl.fbaipublicfiles.com/segment_anything/sam_vit_h_4b8939.pth
RUN wget https://github.com/IDEA-Research/GroundingDINO/releases/download/v0.1.0-alpha/groundingdino_swint_ogc.pth

ENV CUDA_HOME /usr/local/cuda-12.1/
ENV AM_I_DOCKER True
ENV TORCH_CUDA_ARCH_LIST="6.0;7.0;7.5;8.0;8.6"
ENV BUILD_WITH_CUDA 1
RUN python -m pip install --no-cache-dir -e segment_anything
RUN python -m pip install --upgrade pip
RUN python -m pip install --upgrade setuptools wheel twine check-wheel-contents
RUN python -m pip install --no-cache-dir wheel
RUN cd GroundingDINO && python setup.py install

# --- Fix library issues
RUN mkdir -p /usr/lib/dri/ && \
    ln -s /usr/lib/x86_64-linux-gnu/dri/swrast_dri.so /usr/lib/dri/ && \
    ln -s /usr/lib/x86_64-linux-gnu/dri/radeonsi_dri.so /usr/lib/dri/ && \
    mv /root/conda/envs/vln/lib/libstdc++.so.6 /root/conda/envs/vln/lib/libstdc++.so.6.old && \
    ln -s /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /root/conda/envs/vln/lib/libstdc++.so.6

# --- Install VLN-Game dependencies
WORKDIR /dependencies
RUN git clone https://github.com/ybgdgh/VLN-Game
RUN cd VLN-Game && pip install -r requirements.txt
RUN pip install scikit-fmm==2023.4.2 scikit-image ifcfg tensorboard ultralytics tyro open_clip_torch wandb h5py hydra-core yacs pslpython textblob
ENV GSA_PATH=/dependencies/Grounded-Segment-Anything
RUN pip install git+https://github.com/xinyu1205/recognize-anything.git
RUN pip uninstall -y open3d
RUN pip install open3d==0.19.0
RUN conda install -y pytorch::faiss-gpu
RUN pip install fairscale supervision==0.25.0 transformers==4.49.0 scipy==1.11.2 opencv-python==4.9.0.80 watchdog ipython spatialmath-python
RUN pip install duckdb 'ibis-framework[duckdb]' pins gcsfs 
RUN pip install nvitop
RUN sudo apt-get update && sudo apt-get install -y htop

# --- Download llama3.2-vision with ollama
# RUN ollama serve & sleep 5 ; ollama pull llama3.2-vision ; \
#     echo "kill 'ollama serve' process" ; \
#     ps -ef | grep 'ollama serve' | grep -v grep | awk '{print $2}' | xargs -r kill -9

# --- Install VLN-CE-Isaac
WORKDIR /dependencies
RUN git clone https://github.com/averyxi42/Isaac-Provider.git
RUN pip install isaacsim-rl==4.1.0 isaacsim-replicator==4.1.0 isaacsim-extscache-physics==4.1.0 isaacsim-extscache-kit-sdk==4.1.0 isaacsim-extscache-kit==4.1.0 isaacsim-app==4.1.0 --extra-index-url https://pypi.nvidia.com
RUN git clone https://github.com/yang-zj1026/IsaacLab.git
RUN ln -s /dependencies/Isaac-Provider/isaaclab_exts/omni.isaac.vlnce /dependencies/IsaacLab/source/extensions/
RUN ln -s /dependencies/Isaac-Provider/isaaclab_exts/omni.isaac.matterport /dependencies/IsaacLab/source/extensions/
RUN bash /dependencies/IsaacLab/isaaclab.sh -i none
RUN bash /dependencies/IsaacLab/isaaclab.sh -p -m pip install -e /dependencies/Isaac-Provider/scripts/rsl_rl
RUN ln -s /media/sdd1/isaac_vlnce_assets /dependencies/Isaac-Provider/isaaclab_exts/omni.isaac.vlnce/assets

RUN pip install pygame jsonpickle

# Change /root to /workspace for singularity
RUN conda init bash
SHELL ["bash", "-c"]
RUN mv /root /workspace
RUN ln -s /workspace /root
WORKDIR /workspace