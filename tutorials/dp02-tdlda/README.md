DP Tutorial 2 - TDLDA absorption and electron energy loss (EEL) spectrum of silicon.
======================================================================================

Adiabatic local density approximation ( TDLDA, also called ALDA) calculation.

```
|html \eps^(-1) = 1 + v * \chi
|html \chi = chi_0 + \chi_0 (v+f_xc) \chi
|latex $\varepsilon^{-1} = 1 + v \chi$
|latex $\chi = \chi^0 + \chi^0 ( v + f_{xc}) \chi$
```

f_xc is the frequency-independent (i.e. adiabatic) functional derivative of the static LDA exchange-correlation (xc) potential

Objectives
-------------

1. Compare the spectra obtained within RPA and with a TDLDA xc kernel.
2. Understand the origin of the peaks through the comparison with the bandstructure and density of state plots.
3. Calculate an EELS spectrum within the TDLDA.

Tasks
------------

### 1. Calculation of a TDLDA absorption spectrum. 

Move to the directory ~/Tutorial_dp/input/response/Si/TDLDA/. 

Create an input file (dp.in) to run the TDLDA calculation of the optical response. You can use as an example the input file for the RPA calculation. Check the page list_of_variables to get all the information you need. Remind that the value of matsh needs a convergence check.

Link the KSS file created by ABINIT to a file "si.kss" in the directory where you want to run dp.

Then run the program

```bash
dp -i dp.in -k si.kss > dp-abs-TDLDA.log
```

#### Results

In the file dp.log you can find a summary of the input information (from dp.in and si.kss) and a description of the main steps of the calculation. The dielectric function is in the files "ou*.mdf".

Analyze attentively all the output files and plot the real and imaginary part of the dielectric function.

#### Questions

Can you answer these questions:

1. Is it necessary to make the dielectric matrix larger to get a converged spectrum?
	Compare the TDLDA absorption spectrum with the RPA one. 
2. What can you conclude about the effect of the TDLDA xc kernel for the spectrum of silicon?
3. Can you understand which transitions contribute to the peaks by inspecting the plots of the bandstructure and the density of states?

### 2. Calculation of the EEL spectrum at q=0.

Move to the directory ~/Tutorial_dp/input/response/Si/EELS/. The input file "dp-eels.in" is already there. The convergence parameters have been increased with respect to the absorption spectrum calculation. In particular, the number of bands is increased, as the plasmon peak appears at about 17 eV.

Perform both a RPA and a TDLDA calculation.

Run DP as usual
```bash
dp -i dp-eels.in -k si.kss > dp-eels.log &
```

#### Results

All the information necessary to calculate the EELS is inside the complex dielectric function. 

To transform the dielectric function contained in "outlf.mdf" to the EELS function, use the utility "mdf2eel".

```bash
mdf2eel outlf.mdf
```

#### Results

The new file "outlf.eel" contains the EELS. You can broaden the curve with the utility "broad" as usual.

```bash
broad outlf.eel
````

#### Questions

4. How do the RPA and TDLDA EELS spectra compare to the experiment?
	(You find can find the experimental curves in ~/Tutorial_dp/input/response/Si/graphs-results-to-compare).

 
### 3. From silicon to other semiconductors and insulators. 

In the directories ~/Tutorial_dp/input/response/"other material" input files for other simple semiconductors are available. In the directory ~/Tutorial_dp/input/create-extra-kss input files to create kss files for other simple semiconductors are also available.

Choose another material and calculate its TDLDA absorption spectrum.
