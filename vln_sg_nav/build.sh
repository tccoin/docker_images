docker pull nvcr.io/nvidia/isaac-sim:4.5.0
# sudo apt-get install docker-buildx-plugin
# sudo pacman -S docker-buildx
# https://pyojuncode-github-io.translate.goog/Docker-using-ssh-in-builds/?_x_tr_sl=auto&_x_tr_tl=en&_x_tr_hl=en&_x_tr_pto=wapp
DOCKER_BUILDKIT=1 docker build --tag curly/sg_nav:latest --ssh default .
