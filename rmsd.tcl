mol load psf not-water.psf dcd not-water.dcd
package require pbctools
pbc unwrap -sel all

set sel [atomselect top protein]
set n [molinfo top get numframes]

# Align only protein
set ref [atomselect 0 protein frame 0]
set all [atomselect 0 all]
for { set i 1 } { $i < $n } { incr i } {
    $sel frame $i   
    $all frame $i
    $all move [measure fit $sel $ref]
  }

# Align only protein
set ref [atomselect 0 $sel frame 0]
set all [atomselect 0 all]
for { set i 1 } { $i < $n } { incr i } {
    $sel frame $i   
    $all frame $i
    $all move [measure fit $sel2 $ref]
    }


#RMSD of Ligand
set outfile [open "rmsd_LIG.dat" w]
set ref [atomselect 0 "resname LIG" frame 0]
set sel [atomselect 0 "resname LIG"]
for { set i 1 } { $i < $n } { incr i } {
    $sel frame $i
    set rms [ measure rmsd $sel $ref ]
    puts $outfile "$rms"
}   
$sel delete
$ref delete

#RMSD of type CA
#set outfile [open "rmsd_typeCA.dat" w]
#set ref [atomselect 0 "type CA" frame 0]
#set sel [atomselect 0 "type CA"]
#for { set i 1 } { $i < $n } { incr i } {
#    $sel frame $i
#    set rms [ measure rmsd $sel $ref ]
#    puts $outfile "$rms"
#}

#$sel delete 
#$ref delete 

exit
