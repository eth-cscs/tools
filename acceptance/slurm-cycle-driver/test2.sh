#!/bin/sh

#SBATCH --job-name=tst2
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --time=0:01:00
#SBATCH --partition=debug
#SBATCH --output=./test2.%j.o
#SBATCH --error=./test2.%j.e

echo "test 2 starts..."

srun -n1 hostname
