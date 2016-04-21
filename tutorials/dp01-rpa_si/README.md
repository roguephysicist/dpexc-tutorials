DP Tutorial 1 - RPA absorption spectrum of silicon with and without local fields.
==================================================================================

Random Phase Approximation (RPA) calculation.
```
|html \eps = 1 - v * \chi0
|latex $\varepsilon = 1 - v \chi_0$
```

Objectives
--------------

1. Prepare an input file for DP defining all the necessary parameters.
2. Output and plot the absorption spectrum.
3. Study the convergence of the spectrum with respect to:
	* the number of bands;
	* the number of plane waves in the wavefunction expansion;
	* the dimension of the G-G' dielectric matrix;
	* (the set of k points has already been tested).

Notes
---------
For the density calculation a small number highly symmetric k-points is sufficient. For the optical calculations a large and shifted k-point mesh is required for faster convergence.

Tasks
------------

### 1. Calculation of a simple RPA spectrum.

Check the page list_of_variables to get all the information you need about the variables to define to create an input file.

Review the `dp_rpa.in` file and check if you understand the meaning of all variables.  

Link the KSS file created by ABINIT to a file "si.kss" in the directory where you are working.

Then run the program

```bash 
dp -i dp_rpa.in -k si.kss > dp.log
````

#### Results
 
In the file dp.log you can find a summary of the input information (from dp.in and si.kss) and a description of the main steps of the calculation. 

The dielectric function (real and imaginary parts) is in the files "ou*.mdf".

Analyze attentively all the output files.
 
#### Questions
 
Can you answer these questions:
 
1. What is the difference between the variables npwmat and matsh? And the variables npwwfn and npwmat?
2. What is the dimension of the dielectric matrix? What happens if you run again the program after setting the dimension of the dielectric matrix in the input file to 1?
3. Is a scissor operator used?
4. Which xc kernel is used?
5. How many k-points are used?

	Consider the two files "outlf.mdf" and "outnlf.mdf". "lf" indicates that LFE are included (according to the value of matsh),while "nlf" means that the result is without local fields.

6. Can you understand by reading the summary included at the beginning of the file what they contain?

	A little hint: "r"1 means "quantity averaged over the 3 reciprocal lattice vector directions" while "c" means "quantity averaged over the 3 Cartesian directions". Every couple of columns contain the real and the imaginary part of a dielectric function. Looking back at question 2: which is the difference between the content of "outlf.mdf" and "outnlf.mdf" when npwmat=1?

The two files "ouclf.mdf" and "oucnlf.mdf" contain only the dielectric funtions averaged over the 3 Cartesian directions. 

### 2. Plot the spectra. 

Plot the imaginary part and the real part of the dielectric function of silicon and compare with the experimental spectrum (you can find the experimental curves in `~/Tutorial_dp/input/response/Si/graphs-results-to-compare`).  

Try to change the artificial broadening of the spectrum using the utility "broad": 
 
```bash
broad outlf.mdf
```

A reasonable broadening is usually about 0.1-0.2 eV.

### 3. Convergence check.

The set of shifted k-points that we are using have already been tested to assure the convergence of the spectra.  

Check the convergence with the number of bands and the number of planewaves in the wavefunction starting from the absorption spectrum without local fields, in the energy range up to 6 eV. 

Once you have found the converged values for nbands and npwwfn/wfnsh, then check the convergence of the local fields, by changing the dimension of the dielectric matrix through npwmat/matsh.
 
#### Questions

7. Were the variables in "dp_rpa.in" large enough to obtain a converged absorption spectrum?

### 4. From silicon to other semiconductors and insulators. 

In the directories `~/Tutorial_dp/input/response/"other material`" input files  for other simple semiconductors are available. In the directory `~/Tutorial_dp/input/create-extra-kss` input files to create kss files for other simple semiconductors are also available.

Choose another material and calculate its RPA optical spectra.
