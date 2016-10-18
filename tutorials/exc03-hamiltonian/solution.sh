#!/bin/bash
# Simple Si test cases for testing different features of DP/EXC

# Program binaries
ABINIP="/opt/science/bin/abinit-5.7.3_etsf-intel13.1.117/bin/abinip"
EXC_OMP="/opt/science/bin/dp-5.2.99-r1883-intel13.1.117/bin/dp-5.3.99-openmp"
EXC_MPI="/opt/science/bin/dp-5.2.99-r1883-intel13.1.117/bin/dp-5.3.99-mpi"
BROAD="/opt/science/bin/dp-5.2.99-r1883-intel13.1.117/bin/broad"

# OpenMP variables
export OMP_STACKSIZE=1G
export OMP_NUM_THREADS=64

# MPI variables
MPI_PROCS=192
MPI_HOSTS="fat1,fat2,fat3"

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
    mpiexec.hydra -np ${MPI_PROCS} -hosts ${MPI_HOSTS} \
    $EXC_MPI -i ${CASE}.in -k si.kss -s si.scr 2>&1 | tee ${CASE}.out
    if [ -e "outexc.mdf" ]; then broad outexc.mdf 0.05; fi
    rm tree_* log_* mem_* out.kdotp_*
    mv mem tree out*.mdf ${CASE}.out ${CASE}/
}


abinit_mpi abinit # Create the KSS and SCR files with ABINIT (~1 min, 12 cores)
ln -sf abinit/si_o_DS2_KSS si.kss # Link the KSS and SCR files generated 
ln -sf abinit/si_o_DS3_SCR si.scr # with ABINIT in the previous step

exc_openmp exc01-TD_FD # Tamm-Dancoff, serial diagonalization (~5 min, 64 cores)

exc_openmp exc02-TD_HY # Tamm-Dancoff, parallel Haydock (~0.5 min, 64 cores)

# exc_openmp exc03-FH_HY # BAD! Coupling, parallel Haydock (~1 min, 64 cores)

exc_openmp exc04a-FH_FD # Coupling, creation of hamiltonian (~2 min, 64 cores)
                        # Step 1: creation of the hamiltonian and write to disk

mv exc04a-FH_FD/out.exh out.exh     # Dumb move command, read below
mv exc04a-FH_FD/out.exc out.exc     # Dumb move command, read below
mv exc04a-FH_FD/out.kdotp out.kdotp # Dumb move command, read below
ln -sf out.exh in.exh       # Linking output from previous step for 
ln -sf out.exc in.exc       # MPI diagonalization. Files must be in the same
ln -sf out.kdotp in.kdotp   # directory as links

exc_mpi exc04b-FH_FD # Coupling, diagonalization of hamiltonian 
                     # Step 2: full MPI diagonalization (~1 hour, 192 cores)

mv out.* exc04a-FH_FD   # Move hamiltonian back
rm si.{kss,scr}         # Get rid of links
rm in.{exc,exh,kdotp}   # Get rid of links
