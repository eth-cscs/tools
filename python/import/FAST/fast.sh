for c in 1 2 4 8 18 36 ;do 
        echo $c
        sed "s-XXX-$c-" fast.slurm.template > fast.slurm.$c 
        sbatch fast.slurm.$c 
done
