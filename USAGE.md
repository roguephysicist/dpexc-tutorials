Running in Parallel
--------------------
Note that running with MPI across more nodes is better for some cases
(diagonalization of the Hamiltonian, or others that benefit from
parallelization), while using OpenMP on one node with many cores is better in
other cases (excitonic calculations, or others that benefit from running
entirely in RAM). You need to select the best method and tailor it to suit your
calculation.

The MPD ring needs to be closed after the calculation by executing `mpdallexit`.


### ABINIT in Parallel

Running ABINIT in parallel can be done once the ring is open. For example,

```sh
mpiexec.hydra -np 12 abinip < input.files > output.log
```

allows you to run on 12 cores using MPI. You don't need to explicitely state the
full path to the binary if it is in your $PATH.

For the last part of the ABINIT GW tutorial, running on 12 cores takes 432.3
seconds running on one core, 109.7 seconds running in on ten cores and 125.2
seconds running on four. Calculation speed does not increase linearly with the
number of cores or processors.


### DP/EXC in parallel

We can run DP/EXC in parallel via MPI,

```sh
mpiexec.hydra -np 12 dp-5.3.99-mpi -i input.in -k kss_file.kss -s scr_file.scr
```

or OpenMP,

```sh
export OMP_NUM_THREADS=12
export OMP_STACKSIZE=1G
dp-5.3.99-openmp -i input.in -k kss_file.kss -s scr_file.scr
```

To check your stack size and other system defaults, you can run
```sh
ulimit -H -a (for hard-wired limits)
ulimit -S -a (for soft-wired limits)
```

The first part of the DP Tutorial takes 20.64 seconds in sequential mode, 6.24
seconds using MPI, and 6.41 seconds using OpenMP.

DP works fastest when running with OpenMP. It is also faster when diagonalizing
the Hamiltonian with the iterative Haydock scheme. Constructing the Hamiltonian
with excitonic effects will be faster using MPI. You can calculate the memory
usage with

```sh
(kx * ky * kz * nv * nc)^2 * 8 (Bytes) / 1024^(2[MB],3[GB],etc.)
```

For example,

```sh
(12x12x4x8x12)^2*8/1024^3 = 22 GB of memory.
```
