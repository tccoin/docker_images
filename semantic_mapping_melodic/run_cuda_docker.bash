container_name=$1

xhost +local:
docker run -it --net=host --gpus all \
  --user=$(id -u) \
  -e DISPLAY=$DISPLAY \
  -e QT_GRAPHICSSYSTEM=native \
  -e CONTAINER_NAME=cuda \
  -e NVIDIA_DRIVER_CAPABILITIES=all \
  -e XAUTHORITY \
  -e USER=$USER \
  --workdir=/home/$USER \
  -v "/tmp/.X11-unix:/tmp/.X11-unix:rw" \
   -v "/etc/passwd:/etc/passwd:ro" \
   -v "/home/$USER/code/docker_home/visualization/:/home/$USER/" \
   -v "/media/sda1/:/home/$USER/sda1" \
   --device=/dev/dri:/dev/dri \
  --name=${container_name} \
  umrobotics/semantic_mapping_melodic:latest
