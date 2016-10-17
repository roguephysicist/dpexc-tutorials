Installation Guide and Tutorials for DP and EXC
===============================================

This is the complete set of DP and EXC Tutorials offered by the European
Theoretical Spectroscopy Facility [(ETSF)](http://www.etsf.eu). It covers the
basics of the [DP](http://dp-code.org) and
[EXC](http://etsf.polytechnique.fr/exc/) codes.

These tutorials and code were created and coordinated by [Matteo Gatti]
(mailto:matteo.gatti@polytechnique.edu), [Francesco Sottile]
(mailto:francesco.sottile@polytechnique.edu), and many others in the ETSF. They 
are owed many thanks for the all the help provided for these tutorials and for 
creating and maintaning such excellent code.

This guide covers DP v5.2.99-r1883. Additionally, we will apply 
a patch developed by [Igor Reshetnyak](igor.reshetnyak@epfl.ch) that enables the
use of MPI for diagonalizing the complete excitonic Hamiltonian.


Introduction
-----------------------------------------------
![](DPNotes/plot.png)

From the website:

### DP
The DP code is an ab initio linear response TDDFT code implemented on a
plane-wave basis set and NC pseudopotentials. It works in the frequency domain
calculating in real space the basic quantities (the Kohn-Sham polarizability and
the exchange-correlation kernel) and solving the fundamental TDDFT equations in
reciprocal space. The approximations range from the most used RPA and TDLDA, to
non-local (and/or non-adiabatic) kernels. Bulk systems are particularly well
suited, but the code can be applied also to surfaces, 1D (tubes, wires) and 0D
(clusters, molecules) systems.

Main purposes:

* Calculate EELS (Electron Energy-Loss Spectroscopy)
* IXSS (Inelastic X-ray Scattering Spectroscopy) at large transferred momentum Q
* Optical properties

### EXC
EXC is an ab initio Bethe-Salpeter Equation code working in reciprocal space, in
the frequency domain, and using a plane-wave basis set. Its purpose is to
calculate dielectric and optical properties, like

* optical absorption, reflectivity, refraction index
* EELS (Electron Energy-Loss Spectroscopy)
* IXSS (Inelastic X-ray Scattering Spectroscopy)

It can be used on a large variety of systems, ranging from bulk systems,
surfaces, to clusters or atoms (using the supercell method). Full coupling
(beyond Tamm-Dancoff approximation) calculations are possible, as well as the
possibility to speed up using the Haydock iterative scheme.
