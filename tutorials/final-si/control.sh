#!/bin/bash
export OMP_NUM_THREADS=12
export OMP_STACKSIZE=1G

# RPA (~3 GB, 40.69 s @ 12 core) RPA doesn't work with openMP?
cd rpa/
mpiexec.hydra -np 12 ~/bin-2013/dp-5.2.99-r1883/bin/dp-5.3.99-mpi -i rpa.in -k si.kss 2>&1 | tee rpa.out
printf "0\n0\n0\n0.030\n" | ~/bin-2013/dp-5.2.99-r1883/bin/broad outlf.mdf 0.030gr_chi.mdf
rm log_* mem_* out.kdotp_* tree_*
cd ..

# GWRPA (~2 GB, 40.69 s @ 12 core)
cd gwrpa/
mpiexec.hydra -np 12 ~/bin-2013/dp-5.2.99-r1883/bin/dp-5.3.99-mpi -i gwrpa.in -k si.kss 2>&1 | tee gwrpa.out
printf "0\n0\n0\n0.030\n" | ~/bin-2013/dp-5.2.99-r1883/bin/broad outlf.mdf 0.030gr_chi.mdf
rm log_* mem_* out.kdotp_* tree_*
cd ..

# Exciton with Tamm-Dancoff and Haydock diagonalization (~3 GB, 289.59 s @ 64 cores)
#                                                       (~3 GB, 602.35 s @ 12 cores)
cd exc/
~/bin-2013/dp-5.2.99-r1883/bin/dp-5.3.99-openmp -i exc.in -k si.kss -s si.scr 2>&1 | tee exc.out
printf "0\n0\n0\n0.030\n" | ~/bin-2013/dp-5.2.99-r1883/bin/broad outexc.mdf 0.030gr_chi.mdf
cd ..

