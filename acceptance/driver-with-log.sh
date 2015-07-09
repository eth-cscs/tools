#!/bin/sh

run_id=$HOSTNAME-$(date +"%m_%d_%Y_%H_%M")
output_log=/lus/scratch/perettig/acceptance/$run_id.out
err_log=/lus/scratch/perettig/acceptance/$run_id.err
sleep_time=5

echo "First phase (HPL) on "$HOSTNAME 2>> $err_log >> $output_log
cd /lus/scratch/perettig/acceptance

echo "salloc -N 12 --exclusive --cpus-per-task=1 --ntasks-per-node=16 --gres=gpu:16 mpirun -n 192 run_linpack.kleinm - on "$HOSTNAME 2>> HPL-$err_log >> HPL-$output_log 
salloc -N 12 --exclusive --cpus-per-task=1 --ntasks-per-node=16 --gres=gpu:16 mpirun -n 192 run_linpack.kleinm 

echo "sleeping... "$sleep_time 2>> $err_log >> $output_log

sleep $sleep_time

echo "Second run (HPCG) on "$HOSTNAME 2>> $err_log >> $output_log 
echo "salloc -N 12 --exclusive --cpus-per-task=1 --ntasks-per-node=16 --gres=gpu:16 mpirun -n 192 run_hpcg.klein - on "$HOSTNAME 2>> HPCG-$err_log >> HPCG-$output_log
salloc -N 12 --exclusive --cpus-per-task=1 --ntasks-per-node=16 --gres=gpu:16 mpirun -n 192 run_hpcg.kleinm
