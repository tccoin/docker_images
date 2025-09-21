cd /media/sdd1/singularity/
export SINGULARITY_TMPDIR=/media/sdd1/singularity/tmp
singularity build sg_vln_vscode3.sif docker-daemon://curly/sg_vln:vscode
singularity build sg_vln_isaac.sif docker-daemon://curly/sg_vln:latest