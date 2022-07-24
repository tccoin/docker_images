container_name=$1

xhost +local:
docker run -it --net=host --gpus all  -e DISPLAY=${DISPLAY} \
  -e QT_GRAPHICSSYSTEM=native \
  -e NVIDIA_DRIVER_CAPABILITIES=all \
  -e XAUTHORITY \
  -v /etc/group:/etc/group:ro \
  -u $(id -u):$(id -g) --workdir="/home/$USER/" \
  -v "/tmp/.X11-unix:/tmp/.X11-unix:rw"  -v "/etc/passwd:/etc/passwd:rw" -v  "/etc/group:/etc/group:ro"  -v "/etc/shadow:/etc/shadow:ro" -e "TERM=xterm-256color" \
  --device /dev/nvidia0 --device /dev/nvidia-modeset --device /dev/nvidiactl --device /dev/nvidia-uvm --device /dev/nvidia-uvm-tools  \
  --device /dev/nvidia1 \
  -v "/media/sda1:/home/$USER/media/sda1" \
  -v "/media/sdc1:/home/$USER/media/sdc1" \
  -v "/home/$USER/code/docker_home/cvo/:/home/$USER/" \
   --name=${container_name}  umrobotics/cvo:latest

