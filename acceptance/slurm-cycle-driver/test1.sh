#!/bin/sh

#SBATCH --job-name=tst1
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --time=0:01:00
#SBATCH --partition=debug
#SBATCH --output=./test1.%j.o
#SBATCH --error=./test1.%j.e

echo "test 1 starts..."
srun -n1 hostname
