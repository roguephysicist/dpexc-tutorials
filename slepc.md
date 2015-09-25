Installing DP for using the PETSc and SLEPc Libraries
=====================================================

This version of DP is MPI enabled for parallelization. Version 3.4.3 of both the PETSc and SLEPc libraries are supported. To configure PETSc:

```
./configure --prefix=/home/sma/bin/petsc-3.4.3 --with-blas-lapack-dir=/home/intel/mkl/8.1.1 --with-cc=mpiicc --with-cxx=mpicxx --with-fc=mpiifort --with-scalar-type=complex --with-precision=single --with-fortran-kernels=generic --with-debugging=0
```

then follow the on-screen instructions. To install SLEPc, first export the following variables:

```
export PETSC_DIR=/home/sma/src/petsc-3.4.3
export PETSC_ARCH=arch-linux2-c-opt
export SLEPC_DIR=/home/sma/src/slepc-3.4.3
```

then follow the on-screen instructions. With those same variables exported, configure DP with

```
./configure --prefix=/home/sma/bin MPI_F90=mpiifort MPI_CC=mpiicc CC=icc F90=ifort F90FLAGS=-O2 LDFLAGS=-nofor_main --with-fftw3=/home/sma/src/fftw-3.3.4/ --with-blas='-L/home/sma/src/lapack-3.5.0/ -lrefblas' --enable-mpi --enable-slepc
```

then run `make clean`, `make`, and optionally `make install`.
