# Select water or other ions to remove
set psf "ionized.psf"
set dcd "rpn3.dcd"
set j "not water and not resname SOD"

# Load psf and dcd file
mol load psf $psf dcd $dcd 

# Get number of frames
set nf [molinfo top get numframes] 
#set nf 10 

#Generate pdbs for each frame without water
for {set i 0 } {$i < $nf } {incr i } { 
  set sel [atomselect top $j frame $i]
  $sel writepdb $i.pdb 
}

# Write psf without water
set sel1 [atomselect top $j]
$sel1 writepsf not-water.psf 
$sel1 writepdb not-water.pdb

# Combine all frames and delete pdbs
mol load psf not-water.psf
for {set i 0 } {$i < $nf } {incr i } { 
  animate read pdb $i.pdb } 
animate write dcd not-water.dcd waitfor all top
for {set i 0 } {$i < $nf } {incr i } { 
file delete $i.pdb
puts "Removing file $i.pdb" 
}

mol delete all

mol load psf not-water.psf dcd not-water.dcd
package require pbctools
pbc unwrap -sel "resname LIG"
pbc unwrap -sel "protein"
pbc unwrap -sel "type ZN"
#selecting the two domains region where you will calculate the center of mass distance between two domains

set sel1 [atomselect top "resname LIG"]
set sel2 [atomselect top "type ZN"]
set nf [molinfo top get numframes]

set outfile [open "center_distance.dat" w]

for {set i 0} {$i<$nf} {incr i} {
        puts "frame $i of $nf"
        $sel1 frame $i
        $sel2 frame $i
        set com1 [measure center $sel1 weight mass]
        set com2 [measure center $sel2 weight mass]
        set simdata($i.r) [veclength [vecsub $com1 $com2]]
        puts $outfile "$i $simdata($i.r)"
} 
exit
