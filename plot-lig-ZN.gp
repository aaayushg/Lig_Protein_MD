set output 'Ligand#20.eps'
set terminal postscript eps enhanced color solid 'Helvetica' 24 size 6.000000,4.000000
set xlabel 'Time (ns)'
set ylabel 'Distance between Ligand and ZN (Angstrom)'
set title 'Ligand#20'
unset key
plot 'center_distance.dat' using ($1/100):($2) w l 
