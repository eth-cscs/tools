for c in 1 2 4 8 18 36 ;do 
        echo $c
        sed "s-XXX-$c-" slow.slurm.template > slow.slurm.$c 
        sbatch slow.slurm.$c 
done
