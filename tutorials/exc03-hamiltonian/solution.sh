#!/bin/bash
# solution.sh
ABINIP="/home/sma/bin-2013/abinit-5.7.3/abinit/5.7/bin/abinip"
EXC_OMP="/home/sma/bin-2013/dp-5.2.99-r1883/bin/dp-5.3.99-openmp"
EXC_MPI="/home/sma/bin-2013/dp-5.2.99-r1883/bin/dp-5.3.99-mpi"

# Creating the KSS and SCR files with ABINIT
mpiexec.hydra -np 24 $ABINIP < si_gen.files 2>&1 | tee si_gen.log
rm *_LOG_* fort.7
mkdir -p KSS_SCR
mv si_o_* KSS_SCR/
mv si_gen.out KSS_SCR/
mv si_gen.log KSS_SCR/
ln -sf KSS_SCR/si_o_DS2_KSS si.kss
ln -sf KSS_SCR/si_o_DS3_SCR si.scr

# Necessary OMP variables
export OMP_STACKSIZE=1G
export OMP_NUM_THREADS=64

# Tamm-Dancoff, full diagonalization, serial (very long!)
CASE1="exc01-TD_FD"
mkdir -p ${CASE1}
$EXC_OMP -i ${CASE1}.in -k si.kss -s si.scr 2>&1 | tee ${CASE1}.out
mv mem tree out* ${CASE1}.out ${CASE1}/

# Tamm-Dancoff, Haydock diagonalization, parallel
CASE2="exc02-TD_HY"
mkdir -p ${CASE2}
$EXC_OMP -i ${CASE2}.in -k si.kss -s si.scr 2>&1 | tee ${CASE2}.out
mv mem tree out* ${CASE2}.out ${CASE2}/

# Coupling, Haydock diagonalization, parallel
CASE3="exc03-FH_HY"
mkdir -p ${CASE3}
$EXC_OMP -i ${CASE3}.in -k si.kss -s si.scr 2>&1 | tee ${CASE3}.out
mv mem tree out* ${CASE3}.out ${CASE3}/

# Coupling, full diagonalization, parallel (stage 1, creation of the hamiltonian)
CASE4a="exc04a-FH_FD"
mkdir -p ${CASE4a}
$EXC_OMP -i ${CASE4a}.in -k si.kss -s si.scr 2>&1 | tee ${CASE4a}.out
mv mem tree ${CASE4a}.out ${CASE4a}/

# Coupling, full diagonalization, parallel (stage 2, inverting the hamiltonian)
CASE4b="exc04b-FH_FD"
mkdir -p ${CASE4b}
ln -sf out.exh in.exh
ln -sf out.exc in.exc
ln -sf out.kdotp in.kdotp
mpiexec.hydra -np 192 -hosts fat1,fat2,fat3 $EXC_MPI -i ${CASE4b}.in -k si.kss -s si.scr 2>&1 | tee ${CASE4b}.out
mv out.exc out.exh out.kdotp ${CASE4a}/
mv mem tree ${CASE4b}.out out* ${CASE4b}/
rm tree_* log_* mem_* out.kdotp_*

unlink si.kss
unlink si.scr
unlink in.exc
unlink in.exh
unlink in.kdotp
