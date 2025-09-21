touch .zsh_history
docker pull nvcr.io/nvidia/isaac-sim:4.5.0
# sudo apt-get install docker-buildx-plugin
# sudo pacman -S docker-buildx
# https://pyojuncode-github-io.translate.goog/Docker-using-ssh-in-builds/?_x_tr_sl=auto&_x_tr_tl=en&_x_tr_hl=en&_x_tr_pto=wapp
# DOCKER_BUILDKIT=1 docker build --tag curly/vln_game:latest --ssh default .
# DOCKER_BUILDKIT=1 docker build --progress=plain --tag curly/sg_vln:habitat3.3 .
docker build --tag curly/sg_vln:latest .

# docker build --progress=plain --tag curly/sg_vln:singularity1 -f Dockerfile_singularity .
# singularity build sg_vln_isaac.sif docker-daemon://curly/sg_vln:singularity
# bash generate_sif.sh