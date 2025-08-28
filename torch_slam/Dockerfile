FROM nvidia/cudagl:11.4.2-devel-ubuntu20.04

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y locales \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_US.UTF-8

# --- nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics,compute,utility,display


# --- install libraries and tools
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
    nano \
    htop \
    && apt clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 
RUN pip3 install nvitop

# --- use current user
# RUN adduser --disabled-password --gecos '' $USER
# RUN adduser $USER sudo
# RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
# USER $USER
WORKDIR /workspace/

# --- install zsh
COPY scripts/zsh zsh
RUN cd zsh && bash install_zsh.sh
RUN mkdir -p ~/.cache/gitstatus \
    && wget https://github.com/romkatv/gitstatus/releases/download/v1.5.4/gitstatusd-linux-x86_64.tar.gz -O - \
    | tar -zx -C ~/.cache/gitstatus/

# --- Install conda and environment
ENV CONDA_DIR /conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh \
    && /bin/bash ~/miniconda.sh -b -p ${CONDA_DIR}
ENV PATH $CONDA_DIR/bin:$PATH

# --- Install CUDA
RUN wget https://developer.download.nvidia.com/compute/cuda/12.1.0/local_installers/cuda_12.1.0_530.30.02_linux.run
RUN TERM=xterm sh cuda_12.1.0_530.30.02_linux.run --silent --toolkit \
    && rm cuda_12.1.0_530.30.02_linux.run
RUN echo /var/log/cuda-installer.log
ENV PATH=/usr/local/cuda-12.1/bin:${PATH}
ENV LD_LIBRARY_PATH=/usr/local/cuda-12.1/lib64:${LD_LIBRARY_PATH}
COPY scripts/debian_mkl.sh debian_mkl.sh
RUN sudo bash debian_mkl.sh

# --- Create conda environment
WORKDIR /dependencies
RUN pip uninstall -y urllib3 && pip install urllib3
RUN conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main --channel https://repo.anaconda.com/pkgs/r
RUN conda create --name slam python=3.10
ENV PATH $CONDA_DIR/envs/slam/bin:$PATH
SHELL ["conda", "run", "-n", "slam", "/bin/bash", "-c"]

# --- Install common python dependencies
RUN pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
RUN curl -fsSL https://ollama.com/install.sh | sh
RUN pip3 install theseus-ai gtsam==4.2
RUN pip3 install pslpython open3d omegaconf git+https://github.com/openai/CLIP.git open_clip_torch nltk einops ftfy scikit-fmm ollama openai matplotlib

# --- Install Ground-SAM
RUN git clone https://github.com/IDEA-Research/Grounded-SAM-2.git && \
    cd Grounded-SAM-2 && \
    git submodule update --init --recursive
WORKDIR /dependencies/Grounded-SAM-2
RUN cd checkpoints && bash download_ckpts.sh
RUN cd gdino_checkpoints && bash download_ckpts.sh

ENV CUDA_HOME /usr/local/cuda-12.1/
ENV AM_I_DOCKER True
ENV TORCH_CUDA_ARCH_LIST="6.0;7.0;7.5;8.0;8.6"
ENV BUILD_WITH_CUDA 1
RUN python -m pip install --upgrade pip "setuptools>=62.3.0,<75.9" wheel numpy \
    opencv-python transformers supervision pycocotools addict yapf timm
RUN pip install -e .
RUN python -m pip install --no-cache-dir --no-build-isolation -e grounding_dino

# --- Install gaussian-splatting
RUN git clone https://github.com/nerfstudio-project/gsplat.git -b v1.5.2
RUN pip install ninja numpy jaxtyping rich
RUN pip install -e .

# --- Install baspacho
RUN git clone https://github.com/facebookresearch/baspacho.git
WORKDIR baspacho
# Note: to use static BLAS the option is really BLA_STATIC (https://cmake.org/cmake/help/latest/module/FindBLAS.html)
RUN sudo apt-get install -y libopenblas-dev
RUN cmake -S . -B build -DCMAKE_BUILD_TYPE=Release -DBLA_STATIC=ON \
    ${BASPACHO_CUDA_ARGS} \
    -DBUILD_SHARED_LIBS=OFF \
    -DBASPACHO_BUILD_TESTS=OFF -DBASPACHO_BUILD_EXAMPLES=OFF
RUN cmake --build build -- -j16
WORKDIR ..

# --- Install torch
ENV CUDA_HOME /usr/local/cuda-${CUDA_VERSION}
RUN pip install ${TORCH_VERSION} --extra-index-url https://download.pytorch.org/whl/${DEVICE_TAG}

# --- Install sparse suitesparse
RUN conda install -c conda-forge suitesparse

# --- Compile theseus wheel
RUN pip install build wheel
RUN git clone https://github.com/facebookresearch/theseus.git
WORKDIR theseus
RUN git fetch --all --tags
RUN BASPACHO_ROOT_DIR=/home/$USER/slam_lib/baspacho \
    THESEUS_FORCE_CUDA=${ENABLE_CUDA} \
    TORCH_CUDA_ARCH_LIST=${TORCH_CUDA_ARCH_LIST} \
    INCLUDE_THESEUS_LABS=${INCLUDE_LABS_STR} \
    ${NIGHTLY_STR} \
    pip install -e .

# --- Install slam&gs libraries
RUN pip install imageio accelerate einops matplotlib spatialmath-python icecream pytorch_memlab tensorboard opencv-python evo torchmetrics nerfview
RUN pip install jupyter ipywidgets widgetsnbextension plotly nbformat
RUN pip install trimesh ipdb point_cloud_utils se3_transformer_pytorch