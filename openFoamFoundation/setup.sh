#!/bin/bash

cp -r /opt/ohpc/pub/apps/uofm/openfoam.org/12/OpenFOAM-12/tutorials/incompressibleFluid/cavity ./

cp openfoam.sh cavity/
cp decomposeParDict cavity/system/
cd cavity/system

patch controlDict ../../controlDict.patch
patch fvSolution ../../fvSolution.patch

# cd cavity
# sbatch openfoam.sh
