import time
from mpi4py import MPI

comm = MPI.COMM_WORLD
rank = comm.Get_rank()
t_begin = time.time()
import numpy
print "time to import numpy t=%f rk=%d numpy=%s" % ( time.time()-t_begin, comm.rank, numpy.__version__)

## on Euler: time is independent of number of processes
## on Dora:  time increases linearly with number of processes (and is in general much larger)
