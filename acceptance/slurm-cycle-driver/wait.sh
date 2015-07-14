#!/bin/sh

#SBATCH --job-name=wait
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --time=0:01:00
#SBATCH --partition=debug
#SBATCH --output=./wait.%j.o
#SBATCH --error=./wait.%j.e

echo "All jobs finished ok"
