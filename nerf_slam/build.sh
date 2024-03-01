# docker build --build-arg USER=$USER --tag tccoin/nerf_slam .
docker build --build-arg USER=$USER --tag tccoin/nerf_slam:torch_2_2 -f ./Dockerfile_torch_2_2 .
