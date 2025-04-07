# Introduction
The following example is adopted from the OpenFOAM incompressible cavity tutorial. Paraview can be used to visualize the problem and solution. 

# Setup
This uses openmpi/4.1.6/gcc.8.5.0/mt and paraview modules. Your job submission script can use the following line to load BigBlue's openfoam environment variables:
```
source /opt/ohpc/pub/apps/uofm/openfoam.com/2412/use
```
This will allow your submission script to use openfoam commands and load the required openmpi/4.1.6/gcc.8.5.0/mt module. Paraview was built separately and can be loaded with `module load paraview`.

## Example Data
Run the following command to copy the incompressible cavity example into a directory called cavity:
```
./setup.sh
```
This will copy a directory from "/opt/ohpc/pub/apps/uofm/openfoam.com/2412/OpenFOAM-v2412/tutorials/" and perform some modifications to make it run a little longer than a few seconds.

# Job
These jobs have multiple stages. Usually the first, "preprocessing", stage involves creating the mesh with blockMesh and splitting the data among processors with decomposePar. You need to use a "decomposeParDict" file to define the type of domain decomposition for your system. The second stage should be the bulk of your calculation where the system is time-stepped until it reaches a finished state. In the example case, this occurs when the system is at 500 seconds. The final, "post-processing", stage usually reconstructs the final state with "reconstructPar" and may perform other calculations on the data. Depending on the size of the final data, this stage might take a long time. If any of the pre and post-processing stages take as long as the simulation time, you should probably split the job into multiple [job dependencies](https://slurm.schedmd.com/sbatch.html#OPT_dependency) to take better advantage of the cluster resources.
Note that with this version of openmpi, you do have threads available, but you do not have to specify the number of threads/cores/tasks/processors or a machinefile to mpirun/mpiexec. It should just work with SLURM `--ntasks` and `--cpus-per-task`. Please, do not run this on the login node.
Since this uses MPI, you should use the `--ntasks`/`-n` and `--mem-per-cpu` options together. There is not much speedup if run on fewer nodes, at least on the BigBlue cluster with infiniband.

## Submit the CPU/MPI job
After running setup.sh, run the following to submit the job in the cavity directory:
```
cd cavity
sbatch openfoam.sh
```

## Results
The results will have a "slurm-*.out" file and a few more files. Use them to extract data and do visualization with paraview (use `module load paraview/5.11.2` to load the paraview environment).

# Compilation
For openfoam.com, the following is the build process that can create executables for bigblue. While you don't need to run the following, it might create a good starting point for compiling different versions of openfoam or openfoam components:
```
module load openmpi/4.1.6/gcc.8.5.0/mt
wget https://dl.openfoam.com/source/v2412/OpenFOAM-v2412.tgz
wget https://dl.openfoam.com/source/v2412/ThirdParty-v2412.tgz
tar -xzf OpenFOAM-v2412.tgz
tar -xzf ThirdParty-v2412.tgz
source OpenFOAM-v2412/etc/bashrc
#The next 3 lines fix an issue where fftw isn't found despite building it
cd ThirdParty-v2412/
./Allwmake -j 12 -s -q -l #This takes a few minutes
source OpenFOAM-v2412/etc/bashrc
cd ../OpenFOAM-v2412/
./Allwmake -j 12 -s -q -l #This takes several hours
```

