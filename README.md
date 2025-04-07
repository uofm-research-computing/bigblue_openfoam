# Introduction
The following examples are adopted from OpenFOAM incompressible cavity tutorials. Paraview can be used to visualize the problem and solution. The compiled versions use OpenMPI 4.1.6 with multithreading enabled. Each of the example directories, openFoamFoundation and openFoamLtd, correspond to two of the most widely used variants of openfoam from [OpenFOAM Foundation](https://openfoam.org) and [OpenFOAM Ltd](https://openfoam.com). I'm not endorsing either as better than the other, but there are differences between the two. The versions used in each are version 12 for openFoamLtd and 2412 for openFoamFoundation.

# Download and run examples
Run the following command to clone these openfoam slurm examples:
```
git clone https://github.com/uofm-research-computing/bigblue_openfoam.git
```

# MPI notes
Either version of openfoam use the same workflow for many calculations. You do not need to specify the number of tasks or a machine/host file in the mpirun line if you use the BigBlue's openmpi modules. Another note is that the meshing step is typically run on a single thread. And finally, the MPI workflow of openfoam uses an explicit domain splitting with the decomposePar program. You must specify the number of subdomains, one per CPU-core, in advance of submitting your job in its configuration file. Again, see the cavity examples for more information.

# Submission script notes
To create a submission script, make sure you use the following options (the values are not specifc, but are a good starting point):
```
#SBATCH --ntasks=8
#SBATCH --mem-per-cpu=2G
#SBATCH --time=1-00:00:00
```

You can change --ntasks to increase or decrease the number of CPU-cores you want to use. You can change --mem-per-cpu to increase or decrease the amount of memory you need per core if you receive an out of memory error or just want the job to start earlier, respectively. A rule of thumb would be to use the number mesh points to figure out how much memory you need for a simulation, for example using 1 GB per 1 million mesh points. The memory calculation per CPU-core can be more difficult on some meshes, but a safe guess is that the mesh is evenly spread across all CPU-cores. The timelimit option, --time, can be adjusted based on previous simulations. You could scale the time based on the number of cores, requiring many benchmark runs, or you could run a pilot simulation for a shorter time to see how much time it takes to run per timestep. The second option is the most efficient, but the first option can be run more generally to estimate other simulations. Keep in mind that allocating more resources might take longer to start your job, so try to keep it as close to what you think you'll need as possible. Inside the submission script, just source the proper version of openfoam you want to use, as shown in the cavity example directories.

