EXC Tutorial 2
======================

Introduction
--------------

We are ready to use the Bethe-Salpeter equation to calculate the absorption spectra of solids.

Objectives
-------------

* Calculate the different kind of spectra (RPA, with and without local fields, GW-RPA, BSE)
* Study the convergence of the spectrum with respect to the number of bands, the number of plane waves in the wavefunctions, the dimension of the dielectric matrix, the set of k-points.
    In order to run an exciton calculation, use the same input file as for DP, with the additional variable exciton. Again, in the transition framework, you can do rpa, alda or now exc.

Tasks
-----------------

* Run a RPA calculation, with the EXC code, with and without local fields, and answer the following question.
    1. Is there a difference between a RPA calculation with EXC and DP ? Why?
        Yes. The calculation with EXC is in the transition space and is more precise than the DP calculation.
    2. What is the difference among the files outexc.mdf outrpanlf.mdf outgwnlf.mdf?
        The first is RPA with local fields, the second without local fields, and the third is with the applied GW correction which is 0 in this case (making the latter two identical).
* Perform now a GW-RPA calculation (using a scissor for example). Plot the spectra and consider again the three files outexc.mdf outrpanlf.mdf outgwnlf.mdf.
* Finally perform an exciton calculation (still using a scissor if you wish). Plot the spectra and consider again the three files outexc.mdf outrpanlf.mdf outgwnlf.mdf
* Perform a calculation including coupling (i.e. using the variable coupling).
    1. What is the effect of the coupling on the absorption spectrum ?
    2. And what the effect on the eels (hint: generate smaller kss and scr files for the evaluation of the eels spectra, for the convergence parameters might imply long cal- culations)? (If you have no time to generate new kss files, use the ones included in the `/nfs_home/tutoadmin/spectroscopy lectures/work/Si` directory, but prior to calculation do `export F_UFMTENDIAN=big`).

In the directories `∼/spectroscopy lectures/work/“other material”` input files for other simple semiconductors and insulators are available. Create the .kss and .scr with Abinit and try to obtain the absorption spectra (for example, try LiF).

Commands
--------------------
```bash
ln -s ../exc01-prep/si1o_DS2_KSS si.kss;\
ln -s ../exc01-prep/si1o_DS5_KSS si_converged.kss;\
ln -s ../exc01-prep/si1o_DS3_SCR si.scr;\
mpiexec -np 12 -env I_MPI_DEVICE rdssm  /home/sma/dpforexc/src/dp-5.3.99-mpi -i exc01_rpa.in -k si_converged.kss > exc01_rpa.log;\
mv out.exeig exc01_rpa_out.exeig;\
mv out.exh exc01_rpa_out.exh;\
mv out.kdotp exc01_rpa_out.kdotp;\
mv out.rhotw exc01_rpa_out.rhotw;\
mv outexc.mdf exc01_rpa_outexc.mdf;\
mv outgwnlf.mdf exc01_rpa_outgwnlf.mdf;\
mv outrpanlf.mdf exc01_rpa_outrpanlf.mdf;\
rm log* mem* tree*;\
mpiexec -np 12 -env I_MPI_DEVICE rdssm  /home/sma/dpforexc/src/dp-5.3.99-mpi -i exc02_gwrpa.in -k si_converged.kss > exc02_gwrpa.log;\
mv out.exeig exc02_gwrpa_out.exeig;\
mv out.exh exc02_gwrpa_out.exh;\
mv out.kdotp exc02_gwrpa_out.kdotp;\
mv out.rhotw exc02_gwrpa_out.rhotw;\
mv outexc.mdf exc02_gwrpa_outexc.mdf;\
mv outgwnlf.mdf exc02_gwrpa_outgwnlf.mdf;\
mv outrpanlf.mdf exc02_gwrpa_outrpanlf.mdf;\
rm log* mem* tree*;\
mpiexec -np 12 -env I_MPI_DEVICE rdssm  /home/sma/dpforexc/src/dp-5.3.99-mpi -i exc03_exc.in -k si.kss -s si.scr > exc03_exc.log;\
mv out.exeig exc03_exc_out.exeig;\
mv out.exh exc03_exc_out.exh;\
mv out.kdotp exc03_exc_out.kdotp;\
mv out.rhotw exc03_exc_out.rhotw;\
mv outexc.mdf exc03_exc_outexc.mdf;\
mv outgwnlf.mdf exc03_exc_outgwnlf.mdf;\
mv outrpanlf.mdf exc03_exc_outrpanlf.mdf;\
rm log* mem* tree*
```
