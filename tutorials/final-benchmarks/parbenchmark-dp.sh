#!/bin/bash
mode="mpi"
for i in `seq 1 64`; do
    if [[ $mode == "openmp" ]]; then
        export OMP_NUM_THREADS=${i}
        dp-5.3.99-openmp -i exc03_exc.in -k si.kss -s si.scr > test
        linenumber=`grep -n "timing point number   200" test | cut -f1 -d:`
        new=$((linenumber + 1))
        sed -n ${new}p test >> times.dat
        rm *out* tree mem test
    elif [[ $mode == "mpi" ]]; then
        mpiexec.hydra -np ${i} dp-5.3.99-mpi -i exc03_exc.in -k si.kss -s si.scr > test
        linenumber=`grep -n "timing point number   200" test | cut -f1 -d:`
        new=$((linenumber + 1))
        sed -n ${new}p test >> times.dat
        rm *out* tree mem test
    fi
done
