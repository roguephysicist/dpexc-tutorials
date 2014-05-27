EXC Tutorial 1
======================

Introduction
--------------

It is your duty now to prepare the ground-state and screening files in order to solve the Bethe-Salpeter equation using EXC.

The EXC code firstly creates the excitonic Hamiltonian

```latex
He−h=[(ε +∆ −ε +∆)δ ′ ′ +2<<v>>−<<W>>]
```

with ∆n being the GW correction (or a scissor operator shift)
```latex
<< v >>= φv(r)φc(r)v(r,r′)φv′(r′)φc′(r′) and << W >>= φv(r)φv′(r)W(r,r′)φc(r′)φc′(r′)
```

where `W(r,r′) = ε−1(r,r′)`. So EXC needs a KSS file (for ε and φ ), a GW file (for ∆ ) or |r−r′| simply a scissor shift, and a screening file SCR (for the ε−1).

Tasks
-----------------
1. Create the “∗ KSS” file containing complete information on the Kohn-Sham bandstructure (use the usual Monkorst-Pack 4x444 k-grid).
2. Create the “∗ SCR” file containing the RPA screening function (this should contain 19 q-points).
3. Create the “∗ GW” file containing the GW corrections to the DFT eigenvalues.
4. Create now another “∗ KSS” file, using these shifts in the abinit input file:
```bash
     nshiftk 4
     shiftk
     0.6 0.7 0.8
     0.6 0.2 0.3
     0.1 0.7 0.3
     0.1 0.2 0.8
```

Notes
------------
Due to limitations in Abinit, the screening file cannot be calculated with assymetrically shifted k--points even if they match the grid for the kss calculation. We need to look into this.

nband and nbandkss are related due to the the calculation of the gradient. nband should be slightly larger than nbandkss in order to include all the bands.

Very important : for the time being, istwfk must be 1 for all the k-points in order to generate a _KSS file.

Commands
--------------------
```bash
mpiexec -np 12 -env I_MPI_DEVICE rdssm  /home/sma/abinit-5.7.3_etsf/src/main/abinip < si_gen.files > si_gen.log; rm *_LOG* fort.7
```

Questions
-------------
1. What is the difference between the two KSS files ? (hint: look at the symmetries)
2. How many k-points are contained in the two KSS files ?
