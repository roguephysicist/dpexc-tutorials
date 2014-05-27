#!/bin/bash
##
## Super quick starting script to run everything in one swift move.
## Definitely not educational but useful for the impatient and/or
## experienced user. Uses MPI and OpenMP with 12 cores for super 
## fast speed.
## 
## Deletes a variety of files so run ar your own risk! 
##

ulimit -s unlimited
export OMP_STACKSIZE=1G
export OMP_NUM_THREADS=12
mpdboot -v -r ssh -f NODE -n 1 > /dev/null

cd dp01-rpa_si/
printf "Running DP Tutorial 1\n"
mpiexec -np 12 -env I_MPI_DEVICE rdssm  abinip < si_kss_gen.files > si_kss_gen.log
rm *_DDB *_DEN *_EIG *_WFK *_LOG*
ln -sf sio_DS2_KSS si.kss
dp-5.3.99-openmp -i dp_rpa.in -k si.kss > dp_rpa.log
rm gmon.out mem* tree* *.kdotp*
cd ..

cd dp02-tdlda/
printf "Running DP Tutorial 2\n"
ln -sf ../dp01-rpa_si/sio_DS2_KSS si.kss
dp-5.3.99-openmp -i dp_tdlda.in -k si.kss > dp_tdlda.log
rm gmon.out *.kdotp* fort.*
cd ..

cd dp03-alpha/
printf "Running DP Tutorial 3\n"
ln -sf ../dp01-rpa_si/sio_DS2_KSS si.kss
dp-5.3.99-openmp -i dp_alpha.in -k si.kss > dp_alpha.log
rm gmon.out *.kdotp* fort.*
cd ..

cd exc01-prep/
printf "Running EXC Tutorial 1\n"
mpiexec -np 12 -env I_MPI_DEVICE rdssm  abinip < si_gen.files > si_gen.log
rm *_DDB *_DEN *_EIG *_WFK *_LOG* *_EM* *_SUS *_SGR *_SIG fort.*
cd ..

cd exc02-exciton/
printf "Running EXC Tutorial 2\n"
ln -sf ../exc01-prep/si1o_DS5_KSS si_converged.kss
ln -sf ../exc01-prep/si1o_DS2_KSS si.kss
ln -sf ../exc01-prep/si1o_DS3_SCR si.scr
printf "\tEXC RPA calculation\n"
dp-5.3.99-openmp -i exc01_rpa.in -k si_converged.kss > exc01_rpa.log
mv out.exeig exc01_rpa_out.exeig
mv out.exh exc01_rpa_out.exh
mv outexc.mdf exc01_rpa_outexc.mdf
mv outgwnlf.mdf exc01_rpa_outgwnlf.mdf
mv outrpanlf.mdf exc01_rpa_outrpanlf.mdf
printf "\tEXC GW-RPA calculation\n"
dp-5.3.99-openmp -i exc02_gwrpa.in -k si_converged.kss > exc02_gwrpa.log
mv out.exeig exc02_gwrpa_out.exeig
mv out.exh exc02_gwrpa_out.exh
mv outexc.mdf exc02_gwrpa_outexc.mdf
mv outgwnlf.mdf exc02_gwrpa_outgwnlf.mdf
mv outrpanlf.mdf exc02_gwrpa_outrpanlf.mdf
printf "\tEXC full exciton calculation\n"
dp-5.3.99-openmp -i exc03_exc.in -k si.kss -s si.scr > exc03_exc.log
mv out.exeig exc03_exc_out.exeig
mv out.exh exc03_exc_out.exh
mv outexc.mdf exc03_exc_outexc.mdf
mv outgwnlf.mdf exc03_exc_outgwnlf.mdf
mv outrpanlf.mdf exc03_exc_outrpanlf.mdf
rm gmon.out *mem* *tree* *.kdotp* *.rhotw*
cd ..

mpdallexit

printf "All done.\n"
exit 1
