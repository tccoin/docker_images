# VLN-GAME Container

## Configuration
1. Change `ports` and `volumes` in `docker-compose.yaml`
2. run `docker compose run --name your_container_name -P vln` to start the container

## Setup dataset
1. download hm3d_val_habitat_v0.1 and objectnav_hm3d_v1 manually
2. cd to VLN-Game folder
3. make sure hm3d dataset is mounted in `VLN-Game/dataset/habitat/versioned_data`
4. run `bash scripts/setup_dataset.sh`

## Run webvnc
If the script stuck just press ctrl-c to stop it and run it again.
```bash
conda activate webvnc && bash /startup.sh
```
Then connect to the server using a vnc client.

## Run VLN
```bash
conda activate vln
bash run_vis_multi.sh
```