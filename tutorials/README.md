Tutorial Notes
===============

Basic Usage
-------------
```bash
dp -i input_file.in -k case.kss -g case.gw -s case.scr
```

EXC runs with the same DP binary. To enable it, you must put `exciton` in your input file. Then you can run RPA, GW-RPA, and exciton calculations. Running the EXC code will often take considerably longer since it is done in transition-space.

A GW file from ABINIT can be used if it is done over exactly the same number of bands and k-points as the kss file. Since it is usually only generated for a single k-point (typically gamma), you can use the GW correction value for a scissors correction.

EXC Tutorials
--------------
Each tutorial directory contains relevant README files.

### Tutorial 1 - Preparation of the ground-state and screening files in order to solve the Bethe-Salpeter equation using EXC.

This tutorial basically summarises all the ABINIT lessons and details how to create the necessary files in order to use EXC and the BSE. This tutorial is more relevant to real-world scenarios using ABINIT than the previous lessons. You will produce the files to be used in the second tutorial.

### Tutorial 2 - Using the Bethe-Salpeter equation to calculate the absorption spectra of solids.

This tutorial shows how to use the EXC code to reproduce and improve on previously obtained results. You will calculate RPA and GW-RPA absorption spectra and then move on to full excitonic calculations that are much more precise but also time consuming.

DP Tutorials 
-------------
Each tutorial directory contains relevant README files.

### Tutorial 1 - RPA calculation with and without local fields.

This tutorial teaches the difference between a simple sum over states calculation  (where only the knowledge of \chi_0 is required) and a full RPA calculation where also local field effects (i.e. variations of the classical Hartree potential) are considered. 

### Tutorial 2 - TDLDA absorption and electron energy loss (EEL) spectrum of silicon. 

This tutorial shows how to perform calculations using the adiabatic local density approximation for the exchange-correlation (xc) kernel (i.e. variations of the exchange and correlation potential at the adiabatic LDA level). Both the optical absorption and the electron energy loss function are calculated. 
   
### Tutorial 3 - Absorption spectrum of silicon using a long-range model kernel.   
   
This tutorial shows how to use the simple model long-range xc kernel f_xc= alpha/q^2 to account for excitonic effects in the absorption spectra of semiconductors.

ABINIT Tutorials
-----------------
Included are two ABINIT tutorials to get the user started with convergence calculations and the creation of the Kohn-Sham structure, GW correction, and screening files.

These tutorials are the [Abinit Tutorial #3](http://www.abinit.org/documentation/helpfiles/for-v6.6/tutorial/lesson_3.html) and the [first Abinit GW Tutorial](http://www.abinit.org/documentation/helpfiles/for-v6.6/tutorial/lesson_gw1.html).

