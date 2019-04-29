mol load psf not-water.psf dcd not-water.dcd
package require pbctools
pbc unwrap -sel all
#selecting the two domains region where you will calculate the center of mass distance between two domains

set sel1 [atomselect top "resname LIG"]
set sel2 [atomselect top "type ZN"]
set nf [molinfo top get numframes]

set outfile [open "center_distance.dat" w]

for {set i 5000} {$i<$nf} {incr i} {
	puts "frame $i of $nf"
	$sel1 frame $i
	$sel2 frame $i
	set com1 [measure center $sel1 weight mass]
	set com2 [measure center $sel2 weight mass]
	set simdata($i.r) [veclength [vecsub $com1 $com2]]
	puts $outfile "$i $simdata($i.r)"
}
close $outfile

exit 
