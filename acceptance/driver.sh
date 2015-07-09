#!/usr/local/bin/bash

source ~/.profile

run_id=$HOSTNAME-$(date +"%m_%d_%Y_%H_%M")

sleep_time=1

module load cudatoolkit/6.5.14 

echo "===================================="
echo "Phase one 4 x HPL on "$HOSTNAME 
echo "===================================="

cd /lus/scratch/perettig/acceptance

echo "salloc -N 12 --exclusive --cpus-per-task=1 --ntasks-per-node=16 --gres=gpu:16 mpirun -n 192 run_linpack.kleinm - on "$HOSTNAME 
salloc -N 12 --exclusive --cpus-per-task=1 --ntasks-per-node=16 --gres=gpu:16 mpirun -n 192 run_linpack.kleinm 
salloc -N 12 --exclusive --cpus-per-task=1 --ntasks-per-node=16 --gres=gpu:16 mpirun -n 192 run_linpack.kleinm 
salloc -N 12 --exclusive --cpus-per-task=1 --ntasks-per-node=16 --gres=gpu:16 mpirun -n 192 run_linpack.kleinm 
salloc -N 12 --exclusive --cpus-per-task=1 --ntasks-per-node=16 --gres=gpu:16 mpirun -n 192 run_linpack.kleinm 

echo "===================================="
echo "sleeping... "$sleep_time"s"
sleep $sleep_time
echo "===================================="

echo "Phase two 40 min HPCG on "$HOSTNAME
echo "===================================="

echo "salloc -N 12 --exclusive --cpus-per-task=1 --ntasks-per-node=16 --gres=gpu:16 mpirun -n 192 run_hpcg.klein - on "$HOSTNAME 
salloc -N 12 --exclusive --cpus-per-task=1 --ntasks-per-node=16 --gres=gpu:16 mpirun -n 192 run_hpcg.kleinm
