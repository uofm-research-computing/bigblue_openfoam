# Introduction
Openfoam.org version 12 running and installation instructions for bigblue using the openmpi/4.1.6/gcc.8.5.0/mt module and the included thirdparty software. 

# Setup
## First Time
To use the precompiled version in /opt/ohpc/pub/apps/uofm/openfoam.org, do the following once on the login node:
```
/opt/ohpc/pub/apps/uofm/openfoam.org/12/initialize.sh
```
This will create a "~/.OpenFOAM" directory with some of the build options.

## Every Submission
This uses openmpi/4.1.6/gcc.8.5.0/mt and paraview modules. Your job submission script can use the following line to load BigBlue's openfoam environment variables:
```
source /opt/ohpc/pub/apps/uofm/openfoam.org/12/use
```
This will allow your submission script to use openfoam commands and load the required openmpi/4.1.6/gcc.8.5.0/mt module. Paraview was built with this version.

## Example Data
Run the following command to copy the incompressible cavity example into a directory called cavity:
```
./setup.sh
```
This will copy a directory from "/opt/ohpc/pub/apps/uofm/openfoam.org/12/OpenFOAM-12/tutorials/incompressibleFluid/cavity" and perform some modifications to make it run a little longer than a few seconds and on more than 1 core.

# Job
These jobs have multiple stages. Usually the first, "preprocessing", stage involves creating the mesh with blockMesh and splitting the data among processors with decomposePar. You need to use a "decomposeParDict" file to define the type of domain decomposition for your system. The second stage should be the bulk of your calculation where the system is time-stepped until it reaches a finished state. In the example case, this occurs when the system is at 500 seconds. The final, "post-processing", stage usually reconstructs the final state with "reconstructPar" and may perform other calculations on the data. Depending on the size of the final data, this stage might take a long time. If any of the pre and post-processing stages take as long as the simulation time, you should probably split the job into multiple [job dependencies](https://slurm.schedmd.com/sbatch.html#OPT_dependency) to take better advantage of the cluster resources.
Note that with this version of openmpi, you do have threads available, but you do not have to specify the number of threads/cores/tasks/processors or a machinefile to mpirun/mpiexec. It should just work with SLURM `--ntasks` and `--cpus-per-task`. Please, do not run this on the login node.

## Submit the CPU/MPI job
After running initialize.sh and setup.sh, run the following to submit the job in the cavity directory:
```
cd cavity
sbatch openfoam.sh
```

## Results
The results will have a "slurm-*.out" file and a few more files. Use them to extract data and do visualization with paraview (use `module load paraview/5.11.2` to load the paraview environment).

# Compilation
For openfoam, the following is the build process that can create executables for bigblue. While you don't need to run the following, it might create a good starting point for compiling different versions of openfoam or openfoam components:
```
wget -O - http://dl.openfoam.org/source/12 | tar xz
wget -O - http://dl.openfoam.org/third-party/12 | tar xz
mv OpenFOAM-12-version-12/ OpenFOAM-12
mv ThirdParty-12-version-12/ ThirdParty-12
module load openmpi/4.1.6/gcc.8.5.0/mt
mkdir -p ~/.OpenFOAM
echo "export ParaView_TYPE=ThirdParty" > ~/.OpenFOAM/prefs.sh
echo "export WM_MPLIB=SYSTEMOPENMPI" >> ~/.OpenFOAM/prefs.sh
source OpenFOAM-12/etc/bashrc
cd ThirdParty-12/
./makeParaView -version 5.11.2 -qmake $(which qmake-qt5)
wmRefresh
cd ../OpenFOAM-12
./Allwmake -q -j 12
```

