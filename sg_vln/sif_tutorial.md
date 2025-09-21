1. make sure you link ~/scratch to your scratch folder, run:
```
module load singularity
singularity overlay create --size 10240 ~/scratch/overlay.img
```
1. start the sif with overlay file:
```
singularity shell --nv --overlay ~/scratch/overlay.img sg_vln_isaac3.sif
```
1. open tmux
1. now setup the conda env:
```
# replace /root to /workspace in $PATH and $PYTHONPATH
export PATH=$(echo $PATH | sed 's|/root|/workspace|g')
export PYTHONPATH=$(echo $PYTHONPATH | sed 's|/root|/workspace|g')
CONDA_DIR=/workspace/conda
# replace /root to /workspace
sed -i "s|/root|/workspace|g" $CONDA_DIR/bin/conda
sed -i "s|/root|/workspace|g" $CONDA_DIR/bin/conda-env
sed -i "s|/root|/workspace|g" $CONDA_DIR/envs/vln/bin/pip
# avoid warning by adding this to bashrc
echo "export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1" >> ~/.bashrc
# init
conda init bash
bash
```