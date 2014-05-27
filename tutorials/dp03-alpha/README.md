DP Tutorial 3 - Absorption spectrum of silicon using a long-range model kernel.
=================================================================================

alpha/q^2 calculation.

``` 
|html \eps^(-1) = 1 + v * \chi
|html \chi = chi_0 + \chi_0 (v+f_xc) \chi
|latex $\varepsilon^{-1} = 1 + v \chi$
|latex $\chi = \chi^0 + \chi^0 ( v + f_{xc}) \chi$
```

f_xc is alpha/q^2, where alpha is an adjustable parameter.
 
Objectives
----------------------

1. Calculate optical spectra with the alpha/q^2 xc-kernel.
2. Observe the effects of a change of alpha on the absorption spectrum.

Tasks
-------------

### 1. Calculation of optical spectra with the alpha/q^2 kernel.

Move to the directory `~/Tutorial_dp/input/response/Si/ALPHA/.`

Link the KSS file created by ABINIT to a file "si.kss" in this directory.

Create an input file for Dp. You can use as an example the input file for the RPA calculation. 

Remind that the quasiparticle eigenenergies are needed (either in.gw file or a scissor operator must be provided). For simple semiconductor materials the application of a scissor operator is usually sufficient. For Silicon soenergy must be set to 0.65 eV, for GaAs to 0.8 eV, for AlAs to 0.9 eV, for SiC the file ``sic.gw'' containing GW corrections is given in ~/Tutorial_dp/input/create-extra-kss.  

Note that the parameters which give a converged RPA spectrum are good also for this calculation. 
 
Calculate various spectra for different negative values of alpha and compare the imaginary part of the dielectric function to the experimental absorption spectrum.

```bash
dp -i dp.in -k si.kss > dp.log &
```

If you have a file with the GW corrections ("si.gw") it can be used instead of the scissor operator in the following way:

```bash
dp -i dp.in -k si.kss -g si.gw > dp.log &
```

#### Results
 
In the file dp.log you can find a summary of the input information (from dp.in and si.kss) and a description of the main steps of the calculation. 

The dielectric function (real and imaginary parts) is in the files "ou*.mdf".

Analyze attentively all the output files.
 
#### Questions
 
Can you answer these questions:

1. What can you observe when the absolute value of alpha increases from 0 to 2?
2. What is the value which gives the best agreement with the experiment?
3. How does the real part of the dielectric function compare to the experiment for this optimal value of $\alpha$?
 
 
### 2. Scaling of alpha with respect to the dielectric constant.
 
In the directory ~/Tutorial_dp/input/create-extra-kss input files to create kss files for other simple semiconductors are available.

You can play with other materials by calculating the values of alpha which gives the best agreement with experiments.
 
Using the table of dielectric constants below it is possible to establish the dependence of alpha on the dielectric constant.

Experimental dielectric constant of some semiconductors:

Si: 11.4,  GaAs: 10.6, AlAs: 8.2, Diamond: 5.65, SiC: 6.5.

#### Questions

 Q4. Which is the relation between alpha and the dielectric constant? 
