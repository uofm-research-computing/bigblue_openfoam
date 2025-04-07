#!/bin/bash
#SBATCH --ntasks=9
#SBATCH --mem-per-cpu=2G
#SBATCH --partition=acomputeq
#SBATCH --time=00:20:00

# KEEP: This is for openfoam
source /opt/ohpc/pub/apps/uofm/openfoam.com/2412/use

# KEEP: This fixes an issue with openmpi and stack size
ulimit -s 10240

# KEEP: This fixes an issue with openmpi and the shared backing file
TMPDIR=/tmp/

# Construct the mesh and decompose the simulation for tasks
# ntasks should equal numberOfSubdomains in decomposeParDict
blockMesh
decomposePar

# Invoking mpirun should not look like this
#mpirun -np $SLURM_NTASKS --hostfile $MACHFILE --bind-to none hostname

# run icoFoam in parallel, implicitely use infiniband interface without core bindings
mpirun --bind-to none icoFoam -parallel

# Reconstruct from subdomains
reconstructPar -latestTime

# Recommend running the following to speed up reconstructPar?
# This needs to be rewritten to use srun rather than parallel
#foamListTimes  -processor > log.foamTimes; awk 'NR%4==1' log.foamTimes | parallel --halt=0 -j8 reconstructPar -newTimes -time {}:

