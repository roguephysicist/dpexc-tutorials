#!/bin/bash
# Simple Si test cases for testing different features of DP/EXC

# Program binaries
ABINIP="/opt/science/bin/abinit-5.7.3_etsf-intel13.1.117/bin/abinip"
EXC_OMP="/opt/science/bin/dp-5.2.99-r1883-intel13.1.117/bin/dp-5.3.99-openmp"
EXC_MPI="/opt/science/bin/dp-5.2.99-r1883-intel13.1.117/bin/dp-5.3.99-mpi"
BROAD="/opt/science/bin/dp-5.2.99-r1883-intel13.1.117/bin/broad"

# Necessary OMP variables
export OMP_STACKSIZE=1G
export OMP_NUM_THREADS=64

abinit_mpi () {
    local CASE=${1}
    mkdir -p ${CASE}
    mpiexec.hydra -np 12 $ABINIP < ${CASE}.files 2>&1 | tee ${CASE}.log
    rm *_LOG_* fort.7
    mv si_o_* ${CASE}
    mv ${CASE}.out ${CASE}
    mv ${CASE}.log ${CASE}
}

broad () {
    local FILE=${1}
    local AMOUNT=${2}
    printf "0\n0\n0\n${AMOUNT}\n" | ${BROAD} ${FILE}
    echo
}

exc_openmp () {
    local CASE=${1}
    mkdir -p ${CASE}
    $EXC_OMP -i ${CASE}.in -k si.kss -s si.scr 2>&1 | tee ${CASE}.out
    if [ -e "outexc.mdf" ]; then broad outexc.mdf 0.05; fi
    mv mem tree out* ${CASE}.out ${CASE}/
}

exc_mpi () {
    local CASE=${1}
    mkdir -p ${CASE}
    mpiexec.hydra -np 192 -hosts fat1,fat2,fat3 \
    $EXC_MPI -i ${CASE}.in -k si.kss -s si.scr 2>&1 | tee ${CASE}.out
    if [ -e "outexc.mdf" ]; then broad outexc.mdf 0.05; fi
    rm tree_* log_* mem_* out.kdotp_*
    mv mem tree ${CASE}.out out*.mdf ${CASE}/
}


# Creating the KSS and SCR files with ABINIT (~1 min)
abinit_mpi si_gen

# Link the KSS and SCR files generated with ABINIT in the previous step
ln -sf si_gen/si_o_DS2_KSS si.kss
ln -sf si_gen/si_o_DS3_SCR si.scr

# Tamm-Dancoff, full diagonalization, serial (~5 min)
exc_openmp exc01-TD_FD

# Tamm-Dancoff, Haydock diagonalization, parallel (~0.5 min)
exc_openmp exc02-TD_HY

# DOES NOT WORK! Coupling, Haydock diagonalization, parallel (~1 min)
#exc_openmp exc03-FH_HY

# Coupling, full diagonalization, parallel (creation of the hamiltonian, ~2 min)
exc_openmp exc04a-FH_FD

# Linking output from previous step for MPI diagonalization. Must be in same
# directory, hence the dumb move commands
mv exc04a-FH_FD/out.exh out.exh
mv exc04a-FH_FD/out.exc out.exc
mv exc04a-FH_FD/out.kdotp out.kdotp
ln -sf out.exh in.exh
ln -sf out.exc in.exc
ln -sf out.kdotp in.kdotp

# Coupling, MPI full diagonalization (inverting the hamiltonian, ~1 hour)
exc_mpi exc04b-FH_FD 

# Moce shit around and clean, all finished!
unlink si.kss
unlink si.scr
unlink in.exc
unlink in.exh
unlink in.kdotp
mv out.* exc04a-FH_FD
