# Abinit 5.7.3
AB5 = Abinit 5.7.3 ETSF

1. Compile FFTW for AB5 with same compiler. Needs both non-float and float
   libraries.
10. module will need to load intel-mpi


# DP/EXC
1. Untar dp-5.2.99-r1883.tgz
2. Untar dppatch_sma.tar.gz 
3. Copy contents of dppatch into dpforexc/src
4. Apply patch with `patch < files.patch`

## To-Do
Interesting tests:
* Run dp-openmp-mkl compiled with 2013 vs 2016
* Run dp-openmp-blas vs dp-openmp-mkl

# Compiling shit (needs to be checked, updated, and finalized)

# DP and related (these try to use the new 2016 compilers, old instructions on github that need to updated with newest instrucctions when completed.)
## ABINIT 5.7.3 (ETSF)
./configure --prefix=/home/sma/bin/abinit-5.7.3/ FC=mpiifort CC=mpiicc CXX=mpiicpc --disable-all-plugins --enable-mpi MPI_RUNNER=mpiexec.hydra --enable-64bit-flags --enable-gw-dpc --host=x86_64 CFLAGS_EXTRA="-axCORE-AVX2,-axSSE4.2 -ip" --with-mpi-level=1
## LAPACK
make blaslib; make lapacklib
## PETSC
./configure --prefix=/home/sma/bin/petsc-3.4.3 --with-scalar-type=complex --with-precision=single --with-fortran-kernels=generic --with-debugging=0 --with-cc=mpiicc --CFLAGS=-axCORE-AVX2,-axSSE4.2 --with-cxx=mpiicpc --CXXFLAGS=-axCORE-AVX2,-axSSE4.2 --with-fc=mpiifort --FFLAGS=-axCORE-AVX2,-axSSE4.2 --with-large-file-io --with-blas-lib="-Wl,-rpath,/opt/intel/mkl/lib/intel64 -L/opt/intel/mkl/lib/intel64 -lmkl_intel_ilp64 -lmkl_sequential -lmkl_core -lpthread -lm" --with-lapack-lib="-Wl,-rpath,/opt/intel/mkl/lib/intel64 -L/opt/intel/mkl/lib/intel64 -lmkl_intel_lp64 -lmkl_sequential -lmkl_core -lpthread -lm" --with-mpiexec=mpiexec.hydra
## DP
### FOR VNL
./configure CC=icc F90=ifort MPI_F90=mpiifort MPI_CC=mpiicc F90FLAGS="-axCORE-AVX2,-axSSE4.2 -ip" LDFLAGS="-nofor_main" --with-fftw3="/home/sma/bin/fftw-3.3.4/" --with-blas="-L/home/sma/src/lapack-3.5.0/ -lrefblas"
### OpenMP
./configure --prefix=/home/sma/bin/dpforexc-5.2.99-r1883 CC=icc --with-fftw3=/home/sma/bin/fftw-3.3.4 --with-blas="-L/opt/intel/compilers_and_libraries_2016.1.150/linux/mkl/lib/intel64 -lmkl_intel_ilp64 -lmkl_core -lmkl_sequential -lm" F90FLAGS="-i8 -I/opt/intel/compilers_and_libraries_2016.1.150/linux/mkl/include -openmp -nofor_main -axCORE-AVX2,-axSSE4.2" CFLAGS="-axCORE-AVX2,-axSSE4.2" --enable-openmp
./configure --prefix=/home/sma/bin/dpforexc-5.2.99-r1883 CC=icc --with-fftw3=/home/sma/bin/fftw-3.3.4 --with-blas="-L/home/sma/src/lapack-3.5.0/ -lrefblas" F90FLAGS="-openmp -nofor_main -axCORE-AVX2,-axSSE4.2" CFLAGS="-axCORE-AVX2,-axSSE4.2" --enable-openmp
### MPI
./configure --prefix=/home/sma/bin/dpforexc-5.2.99-r1883 MPI_F90=mpiifort MPI_CC=mpiicc CC=icc F90=ifort --with-fftw3=/home/sma/bin/fftw-3.3.4 --enable-mpi --with-blas="-L/home/sma/src/lapack-3.5.0/ -lrefblas" F90FLAGS="-i8 -nofor_main -axCORE-AVX2,-axSSE4.2"  CFLAGS="-axCORE-AVX2,-axSSE4.2" --enable-slepc
./configure --prefix=/home/sma/bin/dpforexc-5.2.99-r1883 MPI_F90=mpiifort MPI_CC=mpiicc CC=icc F90=ifort --with-fftw3=/home/sma/bin/fftw-3.3.4 --enable-mpi --with-blas="-L/opt/intel/compilers_and_libraries_2016.1.150/linux/mkl/lib/intel64 -lmkl_intel_ilp64 -lmkl_core -lmkl_sequential -lm" F90FLAGS="-i8 -I/opt/intel/compilers_and_libraries_2016.1.150/linux/mkl/include -nofor_main -axCORE-AVX2,-axSSE4.2"  CFLAGS="-axCORE-AVX2,-axSSE4.2"
./configure --prefix=/home/sma/bin/dpforexc-5.2.99-r1883 MPI_F90=mpiifort MPI_CC=mpiicc CC=icc F90=ifort --with-fftw3=/home/sma/bin/fftw-3.3.4 --enable-mpi --with-blas="-L/opt/intel/compilers_and_libraries_2016.1.150/linux/mkl/lib/intel64 -lmkl_intel_ilp64 -lmkl_core -lmkl_sequential -lm" F90FLAGS="-i8 -I/opt/intel/compilers_and_libraries_2016.1.150/linux/mkl/include -nofor_main -axCORE-AVX2,-axSSE4.2"  CFLAGS="-axCORE-AVX2,-axSSE4.2" --enable-slepc
