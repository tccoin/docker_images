cd /home/junzhe/dataset/tartanair/

for seq in abandonedfactory/Easy/P000 \
abandonedfactory/Easy/P001 \
abandonedfactory/Easy/P006
do
    seq_folder=${seq//\//_}
    # if folder exist, skip
    if [ -d "colmap/${seq_folder}/sparse" ]; then
        continue
    fi
    echo ${seq}
    mkdir -p colmap/${seq_folder}/images
    cp -r seq/${seq}/image_left/* colmap/${seq_folder}/images
    bash colmap_and_resize.sh colmap/${seq_folder}
done

# run colmap and log into a file
# colmap automatic_reconstructor --image_path seq/abandonedfactory/Easy/P001/image_left/ --workspace_path colmap_workspace/ --use_gpu 1 --camera_model PINHOLE --single_camera 1 > colmap_workspace/colmap.log 2>&1

