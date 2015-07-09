#!/bin/sh

run_id=$HOSTNAME-$(date +"%m_%d_%Y_%H_%M")
output_log=/lus/scratch/perettig/$run_id-hpl.out
err_log=/lus/scratch/perettig/$run_id-hpl.err
sleep_time=5

echo "First run (HPL) on "$HOSTNAME 2>> $err_log >> $output_log

echo "salloc + mpirun... "$HOSTNAME 2>> $err_log >> $output_log 

echo "sleeping... "$sleep_time 2>> $err_log >> $output_log

sleep $sleep_time

echo "Second run (HPCG) on "$HOSTNAME 2>> $err_log >> $output_log 

echo "salloc + mpirun... "$HOSTNAME 2>> $err_log >> $output_log

