#!/bin/bash
for i in `seq 1 64`; do
    mpiexec.hydra -np $i abinip < tgw1_9.files | grep "individual time" >> times
    rm -f tgw1o_* *.out* *_LOG_* *_STATUS_*
done
