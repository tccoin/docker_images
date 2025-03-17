# docker build --build-arg USER=$USER --tag tccoin/gaussian_splatting .
docker build --build-arg USER=$USER --tag tccoin/gaussian_splatting:torch_2_2 -f ./Dockerfile_torch_2_2 .
