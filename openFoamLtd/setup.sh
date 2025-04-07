#!/bin/bash

cp -r /opt/ohpc/pub/apps/uofm/openfoam.com/2412/OpenFOAM-v2412/tutorials/incompressible/icoFoam/cavity/cavity/ ./

cp openfoam.sh cavity/

cd cavity/system

patch controlDict ../../controlDict.patch

# cd cavity
# sbatch openfoam.sh
