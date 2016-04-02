#!/usr/local/Cellar/gnuplot/5.0.3/bin/gnuplot -persist
#
#    
#       G N U P L O T
#       Version 5.0 patchlevel 3    last modified 2016-02-21 
#    
#       Copyright (C) 1986-1993, 1998, 2004, 2007-2016
#       Thomas Williams, Colin Kelley and many others
#    
#       gnuplot home:     http://www.gnuplot.info
#       faq, bugs, etc:   type "help FAQ"
#       immediate help:   type "help"  (plot window: hit 'h')
set terminal pngcairo  background "#ffffff" enhanced fontscale 1.0 size 800, 600 
set output 'benchmark-abinit.png'
set key title "" center
set key inside right top vertical Right noreverse enhanced autotitle nobox
set key noinvert samplen 4 spacing 1 width 0 height 0 
set key maxcolumns 0 maxrows 0
set key noopaque
unset arrow
set arrow 1 from 1.00000, 25.0000, 0.00000 to 64.0000, 25.0000, 0.00000 nohead back nofilled lt black linewidth 2.000 dashtype solid
set title "Time vs Cores used for abinitgw01, Step 9" 
set title  font "" norotate
set xlabel "\# of Cores" 
set xlabel  font "" textcolor lt -1 norotate
set xrange [ 1.00000 : 64.0000 ] noreverse nowriteback
set x2range [ 1.00000 : 64.0000 ] noreverse nowriteback
set ylabel "Seconds" 
set ylabel  font "" textcolor lt -1 rotate by -270
set y2label "" 
set y2label  font "" textcolor lt -1 rotate by -270
set yrange [ 0 : 300 ] noreverse nowriteback
set y2range [ 0 : 300 ] noreverse nowriteback
set xtics 4
set ytics 50
set y2tics ("25" 25)
set grid
set locale "en_US.UTF-8"
p "abinit-mpi.dat" u 1:2 t 'tgw1\_9' lw 2 ps 1.5 w lp
#    EOF
