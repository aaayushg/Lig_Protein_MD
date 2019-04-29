#Convert Ligand psf in Xplor format
mol load pdb 22.pdb
package require autopsf
autopsf -mol 0 -top 22.rtf
mol delete all

mol load psf rpn.psf pdb rpn.pdb
mol load psf 22_autopsf.psf pdb 22_autopsf.pdb
set sel1 [atomselect 5 all]
set sel2 [atomselect 6 all]
package require topotools
set sall [::TopoTools::selections2mol "$sel1 $sel2"]
animate write psf combine.psf
animate write pdb combine.pdb

#Solvate with a water box
package require solvate
solvate combine.psf combine.pdb -t 15 -o solvate

#Neutralize with 0.15 M NaCl
package require autoionize
autoionize -psf solvate.psf -pdb solvate.pdb -sc 0.15

#Generate a restraint file
mol load psf ionized.psf pdb ionized.pdb
set all [atomselect top all]
set sel [atomselect top "protein"]
set sel1 [atomselect top "resname LIG"]
set sel2 [atomselect top "type ZN"]
$all set beta 0.0
$sel set beta 1.0
$sel1 set beta 1.0
$sel2 set beta 1.0
$all writepdb restraint.pdb

#Get box size for MD
mol load psf ionized.psf pdb ionized.pdb
proc get_cell {{molid top}} {
 set all [atomselect $molid all]
 set minmax [measure minmax $all]
 set vec [vecsub [lindex $minmax 1] [lindex $minmax 0]]
 puts "cellBasisVector1 [lindex $vec 0] 0 0"
 puts "cellBasisVector2 0 [lindex $vec 1] 0"
 puts "cellBasisVector3 0 0 [lindex $vec 2]"
 set center [measure center $all]
 puts "cellOrigin $center"
 $all delete
}
get_cell
exit


