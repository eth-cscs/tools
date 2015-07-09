#!/usr/local/bin/bash

source ~/.profile

run_id=$HOSTNAME-$(date +"%m_%d_%Y_%H_%M")

sleep_time=1200

module load cudatoolkit/6.5.14 

echo "Phase one 4 x HPL on "$HOSTNAME 
cd /lus/scratch/perettig/acceptance

echo "\nsalloc -N 12 --exclusive --cpus-per-task=1 --ntasks-per-node=16 --gres=gpu:16 mpirun -n 192 run_linpack.kleinm - on "$HOSTNAME 
salloc -N 12 --exclusive --cpus-per-task=1 --ntasks-per-node=16 --gres=gpu:16 mpirun -n 192 run_linpack.kleinm 
salloc -N 12 --exclusive --cpus-per-task=1 --ntasks-per-node=16 --gres=gpu:16 mpirun -n 192 run_linpack.kleinm 
salloc -N 12 --exclusive --cpus-per-task=1 --ntasks-per-node=16 --gres=gpu:16 mpirun -n 192 run_linpack.kleinm 
salloc -N 12 --exclusive --cpus-per-task=1 --ntasks-per-node=16 --gres=gpu:16 mpirun -n 192 run_linpack.kleinm 

echo "sleeping... "$sleep_time"s 

sleep $sleep_time

echo "Phase two 40 min HPCG on "$HOSTNAME 2
echo "salloc -N 12 --exclusive --cpus-per-task=1 --ntasks-per-node=16 --gres=gpu:16 mpirun -n 192 run_hpcg.klein - on "$HOSTNAME 
salloc -N 12 --exclusive --cpus-per-task=1 --ntasks-per-node=16 --gres=gpu:16 mpirun -n 192 run_hpcg.kleinm
