#!/usr/local/bin/bash

RES1=$(sbatch test1.sh)
RES2=$(sbatch test2.sh) 

echo $RES1
srun --dependency=afterok:${RES1##* }:${RES2##* } wait.sh

echo "output run1"
cat test1.*o test1.*e

echo "output run2"
cat test2.*o test2.*e
