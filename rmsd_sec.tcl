mol load psf not-water.psf dcd not-water.dcd
package require pbctools
pbc unwrap -sel all

set sel [atomselect top "type CA"]
set n [molinfo top get numframes]

# Align only type CA
set ref [atomselect 0 "type CA" frame 0]
set all [atomselect 0 all]
for { set i 1 } { $i < $n } { incr i } {
    $sel frame $i   
    $all frame $i
    $all move [measure fit $sel $ref]
  }

# Align only secondary structure
set sel2 [atomselect top "structure E H and type CA"]
set ref [atomselect 0 "structure E H and type CA" frame 0]
set all [atomselect 0 all]
for { set i 1 } { $i < $n } { incr i } {
    $sel2 frame $i   
    $all frame $i
    $all move [measure fit $sel2 $ref]
    }


#RMSD of Ligand
set outfile [open "rmsd_LIG_wrt_sec.dat" w]
set ref [atomselect 0 "resname LIG" frame 0]
set sel [atomselect 0 "resname LIG"]
for { set i 1 } { $i < $n } { incr i } {
    $sel frame $i
    set rms [ measure rmsd $sel $ref ]
    puts $outfile "$rms"
}   
$sel delete
$ref delete

exit
