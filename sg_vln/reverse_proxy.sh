module load singularity
singularity exec --nv ~/scratch/sg_vln_vscode.sif bash -c "VSCODE_PORT=9090 bash /usr/local/bin/start-vscode.sh"
singularity exec --nv ~/scratch/sg_vln_vscode2.sif bash

# run vscode in bg with nohup after singularity exec
nohup "VSCODE_PORT=9090 bash /usr/local/bin/start-vscode.sh" &

ssh -fN -R 9090:localhost:9090 junzhewu@vino.engin.umich.edu
ssh -fN -R 6868:localhost:80 junzhewu@vino.engin.umich.edu
ssh -fN -R 6090:localhost:6090 junzhewu@vino.engin.umich.edu
ssh -fN -R 9090:localhost:8000 junzhewu@vino.engin.umich.edu