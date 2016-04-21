Installation Guide and Tutorials for DP and EXC
===============================================

This is the complete set of DP and EXC Tutorials offered by the European
Theoretical Spectroscopy Facility [(ETSF)](http://www.etsf.eu). It covers the
basics of the [DP](http://dp-code.org) and
[EXC](http://etsf.polytechnique.fr/exc/) codes.

These tutorials and code were created and coordinated by [Matteo Gatti]
(mailto:matteo.gatti@polytechnique.edu), [Francesco Sottile]
(mailto:francesco.sottile@polytechnique.edu), and many others in the ETSF. They 
are owed many thanks for the all the help provided for these tutorials and for 
creating and maintaning such excellent code.

This guide covers DP v5.2.99-r1883. Additionally, we will apply 
a patch developed by [Igor Reshetnyak](igor.reshetnyak@epfl.ch) that enables the
use of MPI for diagonalizing the complete excitonic Hamiltonian.


Introduction
-----------------------------------------------
![](DPNotes/plot.png)

From the website:

### DP
The DP code is an ab initio linear response TDDFT code implemented on a
plane-wave basis set and NC pseudopotentials. It works in the frequency domain
calculating in real space the basic quantities (the Kohn-Sham polarizability and
the exchange-correlation kernel) and solving the fundamental TDDFT equations in
reciprocal space. The approximations range from the most used RPA and TDLDA, to
non-local (and/or non-adiabatic) kernels. Bulk systems are particularly well
suited, but the code can be applied also to surfaces, 1D (tubes, wires) and 0D
(clusters, molecules) systems.

Main purposes:

* Calculate EELS (Electron Energy-Loss Spectroscopy)
* IXSS (Inelastic X-ray Scattering Spectroscopy) at large transferred momentum Q
* Optical properties

### EXC
EXC is an ab initio Bethe-Salpeter Equation code working in reciprocal space, in
the frequency domain, and using a plane-wave basis set. Its purpose is to
calculate dielectric and optical properties, like

* optical absorption, reflectivity, refraction index
* EELS (Electron Energy-Loss Spectroscopy)
* IXSS (Inelastic X-ray Scattering Spectroscopy)

It can be used on a large variety of systems, ranging from bulk systems,
surfaces, to clusters or atoms (using the supercell method). Full coupling
(beyond Tamm-Dancoff approximation) calculations are possible, as well as the
possibility to speed up using the Haydock iterative scheme.


Installation
-----------------------------------------------
You can get the DP/EXC combined source code directly from the ETSF. These
instructions are for our particular cluster but you should be able to modify and
apply them to any computer. Please note that we use Intel compilers and Intel
MPI. If you do not have these, then you will need to change the compiler flags
accordingly.

### Requirements
To install and use the code, you will need the following software:

* ABINIT 5.7.3 ETSF, available from [Matteo Gatti]
    (mailto:matteo.gatti@polytechnique.edu)
* the [FFTW library](http://www.fftw.org) (FFTW 3.3.4 used here),
* the [PETSc library](https://www.mcs.anl.gov/petsc/) (3.4.3 **only**)
* the [SLEPc library](http://slepc.upv.es) (3.4.3 **only**)
* an Intel Math Kernel Library (MKL) installation (13.1.117 used here), or 
* the LAPACK/BLAS Libraries if you do not have the Intel MKL.

If your calculation with DP/EXC does not use the electron screening, such as an
RPA calculation, you can use standard, more recent versions of ABINIT with
identical results. This is useful for people who already have a working version
of ABINIT already installed on their system.


### Pre-installation

Our system makes use of the `modules` [package](http://modules.sourceforge.net),
which makes it easy to configure and load the proper paths and libraries. For
the remainder of the guide, I will assume the use of this tool to load the
appropriate modules. However, it isn't a problem if you do not have this
configured on your system. Simply use the full paths to the appropriate
compilers, libraries, and binaries, or load them into your $PATH and compile as
below. **The instructions below cover the entire installation process in case
you wish to build the programs for yourself.** Most end-users will simply wish
to load the program using the `module` command.

If you intend to install the programs system-wide, make sure you have the
necessary privileges or switch to `root`. You will want to load the following
modules as they will be necessary throughout the build process, with

```sh
module load intel-compilers/13.1.117 intel-mkl/13.1.117 intel-mpi/4.1.0.024
```

Confirm that they loaded corrected with `module list`. Again, if you do not have
the `modules` package configured, just make sure you have the appropriate paths
in your $PATH. It is also convenient to setup the installation directory
beforehand, I use the variable `${INSTALL_PRE}` here. There are also common
compiler flags used in all programs, so I will also define `${COMP_FLAGS}`. We
can export both easily:

```sh
export INSTALL_PRE=$HOME/bin
export COMP_FLAGS="-axCORE-AVX2,-axSSE4.2"

export INSTALL_PRE=$HOME/bin-2013
export COMP_FLAGS="-O3"
```


### FFTW 3.3.4

I recommend installing FFTW first so that it is available to use with both
ABINIT 5.7.3 (optional) and DP/EXC.

```sh
./configure --prefix=${INSTALL_PRE}/fftw-3.3.4 CC=icc F77=ifort CPP='icpc -E' CFLAGS=${COMP_FLAGS} CPPFLAGS=${COMP_FLAGS} FFLAGS=${COMP_FLAGS} && make && make install

./configure --prefix=${INSTALL_PRE}/fftw-3.3.4 CC=icc F77=ifort CPP='icpc -E' CFLAGS=${COMP_FLAGS} CPPFLAGS=${COMP_FLAGS} FFLAGS=${COMP_FLAGS} --enable-single --enable-openmp --enable-threads && make && make install

./configure --prefix=${INSTALL_PRE}/fftw-3.3.4 CC=icc F77=ifort CPP='icpc -E' MPICC=mpiicc CFLAGS=${COMP_FLAGS} CPPFLAGS=${COMP_FLAGS} FFLAGS=${COMP_FLAGS} --enable-single --enable-mpi && make && make install
```

Each one of these builds takes less than 5 minutes to complete. You should test
your installation after each build with `make check`. You can clean everything
and start over with `make clean`.


### LAPACK 3.6.0 (Optional)

The LAPACK install includes the appropriate BLAS library. This is only necessary
if you don't have an Intel MKL installation.

We need to modify the included make.inc file to use the appropriate C and
FORTRAN compilers (`icc` and `ifort`), the appropriate flags for each
(`${COMP_FLAGS}`), and uncomment the `TIMER = EXT_ETIME` line and comment the
`TIMER = INT_ETIME` line in exchange.

`make blaslib` and `make lapacklib` wil build the libraries in the same
directory. Both of these should take around 4 minutes total. You should test
your build by running `make blas_testing` and `make lapack_testing`. Finally,
you can clean everything and start over with `make cleanall`.


### ABINIT 5.7.3

Next we compile ABINIT as follows,

```sh
./configure --prefix=${INSTALL_PRE}/abinit-5.7.3 FC=mpiifort CC=mpiicc CXX=mpiicpc FCFLAGS=${COMP_FLAGS} CFLAGS=${COMP_FLAGS} CXXFLAGS=${COMP_FLAGS} --disable-all-plugins --enable-64bit-flags --enable-gw-dpc --with-mpi-level=1 --enable-mpi-trace --enable-mpi="yes" MPI_RUNNER=mpiexec.hydra && make mj4 && make install
```

This takes around 6 minutes to complete with 4 cores. This produces two
binaries, the parallel version, `abinip`, and the serial version, `abinis`. You
can clean everything and start over with `make clean`.


### PETSC 3.4.3

This version of DP is MPI enabled for parallelizing the full excitonic
Hamiltonian, enabled through the PETSc library. Version 3.4.3 of PETSc is
supported. To configure:

ODDLY ENOUGH, THE MKL AT /home/intel/mkl/8.1.1 DOES WORK WITH SINGLE PRECISION!!

```sh
./configure PETSC_ARCH=intel-2013.2.181 --with-cc=mpiicc --with-cxx=mpiicpc --with-fc=mpiifort COPTFLAGS=${COMP_FLAGS} CXXOPTFLAGS=${COMP_FLAGS} FOPTFLAGS=${COMP_FLAGS} --with-mpiexec=mpiexec.hydra --with-blas-lapack-dir=${MKLROOT} --with-debugging=0 --with-scalar-type=complex --with-fortran-kernels=generic --with-large-file-io

Missing: --with-precision=single
```

then follow the on-screen instructions. The whole process takes under 3 minutes
to complete. Take careful note of the `PETSC_DIR` and `PETSC_ARCH` variables, as
they are needed for configuring SLEPc. You can clean everything and start over
with `make allclean`.


### SLEPc 3.4.3

The version of SLEPc needs to match the version of PETSc, in this case, 3.4.3.
To install SLEPc, first export the following variables using the correct values
from the PETSc installation:

```sh
export PETSC_DIR=<from PETSc installation>
export PETSC_ARCH=<from PETSc installation>
export SLEPC_DIR=<path to SLEPc source>


export PETSC_DIR=/HOMES/home/sma/src/petsc-3.4.3
export PETSC_ARCH=intel-2013.2.181
export SLEPC_DIR=/home/sma/src/slepc-3.4.3
```

Run `./configure` and then simply follow the on-screen instructions. This
process should take under a minute.


### DP 5.2.99-r1883:

Talk about applying the patch, then three versions

`touch COPYING CONTRIBUTORS NEWS`

To run the tests, you need to run `export F_UFMTENDIAN=big` to account for the
endianness of the system. You can then run the tests with `make test` and 
`make testexc` from the base directory, or just `make` in the `tests/` and 
`testsexc/` directories.

REMEMBER `export OMP_STACKSIZE=1G`!!!!
AND

```sh
export PETSC_DIR=/HOMES/home/sma/src/petsc-3.4.3
export PETSC_ARCH=intel-2013.2.181
export SLEPC_DIR=/home/sma/src/slepc-3.4.3
```

ALSO `testsexc/t16a.in` and `testsexc/t16b.in` ARE INDEED WHAT WE NEED TO DO!!!

IF YOU WANT TO USE LAPACK OR MKL THEN: BLA BLA BLA

* For sequential use:

```sh
./configure --prefix=${INSTALL_PRE}/dp-5.2.99-r1883 CC=icc F90=ifort F90FLAGS="${COMP_FLAGS} -nofor_main" CFLAGS="${COMP_FLAGS}" --with-fftw3=${INSTALL_PRE}/fftw-3.3.4/ --with-blas="-L${MKLROOT}/lib/intel64 -lmkl_intel_lp64 -lmkl_sequential -lmkl_core -lpthread -lm" && make && make install

./configure --prefix=${INSTALL_PRE}/dp-5.2.99-r1883 CC=icc F90=ifort F90FLAGS="${COMP_FLAGS} -nofor_main" CFLAGS="${COMP_FLAGS}" --with-fftw3=${INSTALL_PRE}/fftw-3.3.4/ --with-blas="-L/home/sma/src/lapack-3.6.0/ -lrefblas"
```

This takes around 2.5 minutes to complete.


OPENMP

SMA

```sh
./configure --prefix=${INSTALL_PRE}/dp-5.2.99-r1883 CC=icc F90=ifort F90FLAGS="${COMP_FLAGS} -nofor_main -openmp" CFLAGS="${COMP_FLAGS}" --with-fftw3=${INSTALL_PRE}/fftw-3.3.4/ --with-blas="-L${MKLROOT}/lib/intel64 -lmkl_intel_lp64 -lmkl_sequential -lmkl_core -lpthread -lm" --enable-openmp && make && make install

./configure --prefix=${INSTALL_PRE}/dp-5.2.99-r1883 CC=icc F90=ifort F90FLAGS="${COMP_FLAGS} -nofor_main -openmp" CFLAGS="${COMP_FLAGS}" --with-fftw3=${INSTALL_PRE}/fftw-3.3.4/ --with-blas="-L/home/sma/src/lapack-3.6.0/ -lrefblas" --enable-openmp && make && make install
```

PEDRO

```sh
./configure --prefix=${INSTALL_PRE}/dp-5.2.99-r1883 CC=icc F90=ifort LDFLAGS="-nofor_main" F90FLAGS="-O3 -I$MKLROOT/include -axAVX -qopenmp" --with-fftw3=${INSTALL_PRE}/fftw-3.3.4/ --with-blas="-L$MKLROOT/lib/intel64 -lmkl_intel_lp64 -lmkl_sequential -lmkl_core -lpthread -lm" --enable-openmp
```



MPI

SMA

```sh
./configure --prefix=${INSTALL_PRE}/dp-5.2.99-r1883 CC=icc F90=ifort MPI_F90=mpiifort MPI_CC=mpiicc MPIRUN_PRE=mpiexec.hydra F90FLAGS="${COMP_FLAGS} -nofor_main" CFLAGS="${COMP_FLAGS}" --with-fftw3=${INSTALL_PRE}/fftw-3.3.4/ --with-blas="-L${MKLROOT}/lib/intel64 -lmkl_intel_lp64 -lmkl_sequential -lmkl_core -lpthread -lm" --enable-mpi --enable-slepc && make && make install
```

PEDRO

```sh
./configure --prefix=/opt/bin/dpforexc/5.2.99-r1883_${INTEL_COMPVER}-mpi CC=icc F90=ifort LDFLAGS="-nofor_main" F90FLAGS="-O3 -I${MKLROOT}/include -axAVX" --with-fftw3=$FFTW_ROOT --with-blas="-L${MKLROOT}/lib/intel64 -lmkl_intel_lp64 -lmkl_sequential -lmkl_core -lpthread -lm" MPI_F90=mpiifort MPI_CC=mpiicc --enable-mpi 
```

Lastly, `make cleanall`, `make`, and optionally `make install`.



For VNL

```sh
./configure CC=icc F90=ifort F90FLAGS="-O3 -nofor_main" CFLAGS="-O3" --with-fftw3=/home/sma/bin-2013/fftw-3.3.4/ --with-blas="-L${MKLROOT}/lib/intel64 -lmkl_intel_lp64 -lmkl_sequential -lmkl_core -lpthread -lm" && make && make install

```




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
