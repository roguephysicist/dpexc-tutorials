Installation
===============================================

You can get the DP/EXC combined source code directly from the ETSF. These
instructions are for our particular cluster but you should be able to modify and
apply them to any computer. Please note that we use Intel compilers and Intel
MPI. If you do not have these, then you will need to change the compiler flags
accordingly.

Requirements
-----------------------------------------------

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


Preparing the system
-----------------------------------------------

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
module load intel-compilers/13.1.117 intel-mpi/4.1.0.024 intel-mkl/13.1.117
```

Confirm that they loaded corrected with `module list`. Again, if you do not have
the `modules` package configured, just make sure you have the appropriate paths
in your $PATH. It is also convenient to setup the installation directory
beforehand, I use the variable `${INSTALL_PRE}` here. There are also common
compiler flags used in all programs, so I will also define `${COMP_FLAGS}`. We
can export both easily:

FFTW 3.3.5
-----------------------------------------------

I recommend installing FFTW first so that it is available to use with both
ABINIT 5.7.3 (optional) and DP/EXC. Each one of these builds takes less than 5
minutes to complete. You should test your installation after each build with
`make check`. You can clean everything and start over with `make clean`.

```sh
./configure --prefix=/opt/science/bin/fftw-3.3.5-intel13.1.117 \
            CC=icc F77=ifort CPP='icpc -E' \
            CFLAGS="-O3" CPPFLAGS="-O3" FFLAGS="-O3" \
            && make && make install && make check && make clean
./configure --prefix=/opt/science/bin/fftw-3.3.5-intel13.1.117 \
            CC=icc F77=ifort CPP='icpc -E' \
            CFLAGS="-O3" CPPFLAGS="-O3" FFLAGS="-O3" \
            --enable-single --enable-openmp --enable-threads \
            && make && make install && make check && make clean
./configure --prefix=/opt/science/bin/fftw-3.3.5-intel13.1.117 \
            CC=icc F77=ifort CPP='icpc -E' \
            MPICC=mpiicc CFLAGS="-O3" CPPFLAGS="-O3" FFLAGS="-O3" \
            --enable-single --enable-mpi \
            && make && make install && make check && make clean
```


### LAPACK 3.6.1 (Optional)

The LAPACK install includes the appropriate BLAS library. This is only necessary
if you don't have an Intel MKL installation.

We need to modify the included make.inc file to use the appropriate C and
FORTRAN compilers (`icc` and `ifort`), the appropriate optimization flags, and
uncomment the `TIMER = EXT_ETIME` line and comment the `TIMER = INT_ETIME` line
in exchange.

`make blaslib` and `make lapacklib` will build the libraries in the same
directory. Both of these should take around 4 minutes total. You should test
your build by running `make blas_testing` and `make lapack_testing`. Finally,
you can clean everything and start over with `make cleanall`.


ABINIT 5.7.3
-----------------------------------------------

Prepare the configure script for the Intel compilers,

```sh
sed -i -e 's/mpicc/mpiicc/g' -e 's/mpicxx/mpiicpc/g' -e 's/mpif90/mpiifort/g' configure
```

Next, configure ABINIT:

```sh
./configure --prefix=/opt/science/bin/abinit-5.7.3_etsf-intel13.1.117 \
        FC=ifort CC=icc CXX=icpc FCFLAGS="-O3" CFLAGS="-O3" CXXFLAGS="-O3" \
        --enable-mpi="yes" --with-mpi-level=1 --with-mpi-runner=mpiexec.hydra \
        --with-mpi-prefix="${I_MPI_ROOT}/intel64"  --disable-all-plugins \
        --enable-mpi-trace --enable-64bit-flags --enable-gw-dpc
```

and `make mj4` to compile on 4 cores, then `make install`. This takes around 6
minutes. This produces two binaries, the parallel version, `abinip`, and the
serial version, `abinis`. You can clean everything and start over with `make
clean`.


PETSC 3.4.3
-----------------------------------------------

This version of DP is MPI enabled for parallelizing the full excitonic
Hamiltonian, enabled through the PETSc library. Version 3.4.3 of PETSc is
supported. To configure:

```sh
unset CC; unset FC; unset F77; unset F90; unset CXX
./configure PETSC_ARCH=intel-2013.1.117 --with-mpiexec=mpiexec.hydra \
        --with-cc=mpiicc --with-cxx=mpiicpc --with-fc=mpiifort \
        COPTFLAGS="-O3" CXXOPTFLAGS="-O3" FOPTFLAGS="-O3" \
        --with-blas-lapack-dir="${MKLROOT}" --with-scalar-type=complex \
        --with-fortran-kernels=generic --with-large-file-io --with-debugging=0
```

then follow the on-screen instructions. The whole process takes under 3 minutes
to complete. Take careful note of the `PETSC_DIR` and `PETSC_ARCH` variables, as
they are needed for configuring SLEPc. You can clean everything and start over
with `make allclean`.


SLEPc 3.4.3
-----------------------------------------------

The version of SLEPc needs to match the version of PETSc, in this case, 3.4.3.
To install SLEPc, first export the following variables using the correct values
from the PETSc installation:

```sh
export PETSC_DIR=<from PETSc installation>
export PETSC_ARCH=<from PETSc installation>
export SLEPC_DIR=<path to SLEPc source>
```

For Medusa, these could be:

```sh
export PETSC_DIR=/opt/science/bin/petsc-3.4.3-intel13.1.117
export PETSC_ARCH=intel-2013.1.117
export SLEPC_DIR=/opt/science/bin/slepc-3.4.3-intel13.1.117
```

Run `./configure` and then simply follow the on-screen instructions. This
process should take under a minute.


DP 5.2.99-r1883:
-----------------------------------------------

First, patch.

Create some missing files to avoid some installation errors later.

```sh
touch COPYING CONTRIBUTORS NEWS
```

Prepare the config script:

```sh
sed -i -e 's/-static-libcxa//g' -e 's/ \${fftw} / "\${fftw}" /g' configure
```

### For sequential use:

```sh
./configure --prefix=/opt/science/bin/dp-5.2.99-r1883-intel13.1.117 \
        CC=icc F90=ifort CFLAGS="-g -O3" \
        F90FLAGS="-g -O3 -nofor_main -unroll" \
        --with-fftw3=/opt/science/bin/fftw-3.3.5-intel13.1.117 \
        --with-blas="-L${MKLROOT}/lib/intel64 -lmkl_intel_lp64 -lmkl_sequential -lmkl_core -lpthread -lm"
```

Verify that the configuration script identifies your build system correctly.
`make` the software. You will need to set

```
export F_UFMTENDIAN=big
```

in order to run the internal tests. Execute `make test` and `make testexc` from
the base directory, or just `make` in the `tests/` and `testsexc/` directories.
When satisfied with the tests, install with `make install`.


### For OpenMP parallelization

```sh
./configure --prefix=/opt/science/bin/dp-5.2.99-r1883-intel13.1.117 \
        CC=icc F90=ifort CFLAGS="-g -O3" \
        F90FLAGS="-g -O3 -nofor_main -unroll -openmp" \
        --with-fftw3=/opt/science/bin/fftw-3.3.5-intel13.1.117 \
        --with-blas="-L${MKLROOT}/lib/intel64 -lmkl_intel_lp64 -lmkl_sequential -lmkl_core -lpthread -lm" \
        --enable-openmp
```


### For MPI parallelization

```sh
./configure --prefix=/opt/science/bin/dp-5.2.99-r1883-intel13.1.117 \
        CC=icc F90=ifort MPI_F90=mpiifort MPI_CC=mpiicc MPIRUN_PRE=mpiexec.hydra \
        CFLAGS="-g -O3" F90FLAGS="-g -O3 -nofor_main -unroll" \
        --with-fftw3=/opt/science/bin/fftw-3.3.5-intel13.1.117 \
        --with-blas="-L${MKLROOT}/lib/intel64 -lmkl_intel_lp64 -lmkl_sequential -lmkl_core -lpthread -lm" \
        --enable-mpi --enable-slepc
```

Lastly, `make cleanall`, `make` `make install`.


### For calculating the matrix elements including the nonlocal part of the 
pseudopotentials

```sh
./configure --prefix=/opt/science/bin/dp-vnonlocal \
        CC=icc F90=ifort CFLAGS="-g -O3" \
        F90FLAGS="-g -O3 -nofor_main -unroll" \
        --with-fftw3=/opt/science/bin/fftw-3.3.5-intel13.1.117 \
        --with-blas="-L${MKLROOT}/lib/intel64 -lmkl_intel_lp64 -lmkl_sequential -lmkl_core -lpthread -lm"
```







### TESTING

To run the tests, you need to run `export F_UFMTENDIAN=big` to account for the
endianness of the system. You can then run the tests with `make test` and 
`make testexc` from the base directory, or just `make` in the `tests/` and 
`testsexc/` directories.

REMEMBER `export OMP_STACKSIZE=1G`!!!!





For VNL

```sh
./configure CC=icc F90=ifort F90FLAGS="-O3 -nofor_main" CFLAGS="-O3" --with-fftw3=/home/sma/bin-2013/fftw-3.3.5/ --with-blas="-L${MKLROOT}/lib/intel64 -lmkl_intel_lp64 -lmkl_sequential -lmkl_core -lpthread -lm" && make && make install

```
