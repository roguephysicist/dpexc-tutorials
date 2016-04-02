#!/usr/local/Cellar/gnuplot/5.0.3/bin/gnuplot -persist
#
#    
#    	G N U P L O T
#    	Version 5.0 patchlevel 3    last modified 2016-02-21 
#    
#    	Copyright (C) 1986-1993, 1998, 2004, 2007-2016
#    	Thomas Williams, Colin Kelley and many others
#    
#    	gnuplot home:     http://www.gnuplot.info
#    	faq, bugs, etc:   type "help FAQ"
#    	immediate help:   type "help"  (plot window: hit 'h')
set terminal pngcairo  background "#ffffff" enhanced fontscale 1.0 size 800, 600 
set output 'benchmark-dp.png'
set key title "" center
set key inside right top vertical Right noreverse enhanced autotitle nobox
set key noinvert samplen 4 spacing 1 width 0 height 0 
set key maxcolumns 0 maxrows 0
set key noopaque
set arrow 1 from 1.00000, 70.0000, 0.00000 to 64.0000, 70.0000, 0.00000 nohead back nofilled lt black linewidth 2.000 dashtype solid
set arrow 2 from 1.00000, 90.0000, 0.00000 to 64.0000, 90.0000, 0.00000 nohead back nofilled lt black linewidth 2.000 dashtype solid
set title "Time vs Cores used for exc02-exciton, Part 3" 
set title  font "" norotate
set xlabel "\# of Cores" 
set xlabel  font "" textcolor lt -1 norotate
set xrange [ 1.00000 : 64.0000 ] noreverse nowriteback
set xtics 4
set ylabel "Seconds" 
set ylabel  font "" textcolor lt -1 rotate by -270
set yrange [ 40 : 200 ] noreverse nowriteback
set y2range [ 40 : 200 ] noreverse nowriteback
set ytics nomirror
set y2tics ("70" 70, "90" 90)
set grid
set locale "en_US.UTF-8"
p "dp-openmp.dat" u 1:2 t 'openMP' lw 1.5 w lp,\
  "dp-mpi.dat" u 1:2 t 'MPI' lw 1.5 w lp
#    EOF
