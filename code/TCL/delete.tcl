#---------------------------------------------------------
# TCL Script initialize
#---------------------------------------------------------

lappend auto_path $env(PARFLOW_DIR)/bin 
package require parflow
namespace import Parflow::*

pfset FileVersion 			4
pfset Process.Topology.P        	1
pfset Process.Topology.Q        	1
pfset Process.Topology.R        	1

#---------------------------------------------------------
# Get Initial parameter 
#---------------------------------------------------------

set fileId 	[open runinfo.txt r]
set runname 	[gets $fileId]
set chemin 	[gets $fileId]

set LowerX 	[gets $fileId]
set LowerY 	[gets $fileId]
set LowerZ 	[gets $fileId]
set UpperX 	[gets $fileId]
set UpperY 	[gets $fileId]
set UpperZ 	[gets $fileId]
set NX 		[gets $fileId]
set NY 		[gets $fileId]
set NZ 		[gets $fileId]
set DX 		[gets $fileId]
set DY 		[gets $fileId]
set DZ 		[gets $fileId]

set stoptime 	[gets $fileId]
set dumptime 	[gets $fileId]
set steptime 	[gets $fileId]
set starttime 	[gets $fileId]

set ICPressVal	[gets $fileId]
set ICpressurefilname [gets $fileId]

set SSat	[gets $fileId]
set SRes 	[gets $fileId]
set alpha	[gets $fileId]
set N		[gets $fileId]

set Ss		[gets $fileId]
set porosity	[gets $fileId]
set Ks 		[gets $fileId]
set manning 	[gets $fileId]
close $fileId
puts "Runinfo Loaded (1/4)"


set num_processors [expr [pfget Process.Topology.P] * [pfget Process.Topology.Q] * [pfget Process.Topology.R]]
for {set i 0} { $i <= $num_processors } {incr i} {
    file delete drv_vegm.dat.$i
    file delete drv_clmin.dat.$i
}
file delete drv_vegm.dat
file delete drv_clmin.dat
file delete drv_vegp.dat

#-----------------------------------------------------------------------------
# Create more intresting data
#-----------------------------------------------------------------------------
set mask 		[pfload $runname.out.mask.pfb]
set mannings		[pfload $runname.out.mannings.silo]
set specific_storage	[pfload $runname.out.specific_storage.silo]
set porosity		[pfload $runname.out.porosity.silo]
set slopex 		[pfload slopex.pfb]
set slopey 		[pfload slopey.pfb]
set perm		[pfload perm.pfb]
set dem			[pfload dem.pfb]

set top 		[pfcomputetop $mask]
set top_perm 		[pfextracttop $top $perm]
set upstreamarea	[pfupstreamarea $dem $slopex $slopey]

pfsave $top -sa top.txt
pfsave $perm -sa perm.txt
pfsave $mask -sa mask.txt
pfsave $top_perm -sa top_perm.txt
pfsave $slopex -sa slopex.txt
pfsave $slopey -sa slopey.txt

file mkdir TXT

file delete storage.txt
set timei [expr {$stoptime / $dumptime}]

for {set i 0} { $i <= $timei } {incr i } {
    set i_string [format "%05d" $i]
    file delete 		$runname.out.satur.$i_string.pfb
    file delete 		$runname.out.press.$i_string.pfb
}


for {set i 1} { $i <= $timei } {incr i} {

    file delete $runname.out.eflx_lh_tot.$i_string.silo
    file delete $runname.out.eflx_lwrad_out.$i_string.silo
    file delete $runname.out.eflx_soil_grnd.$i_string.silo
    file delete $runname.out.eflx_sh_tot.$i_string.silo
    file delete pfload $runname.out.qflx_evap_grnd.$i_string.silo
    file delete $runname.out.qflx_evap_soi.$i_string.silo
    file delete $runname.out.qflx_evap_tot.$i_string.silo
    file delete $runname.out.qflx_evap_veg.$i_string.silo
    file delete $runname.out.qflx_infl.$i_string.silo
    file delete $runname.out.qflx_tran_veg.$i_string.silo
    file delete $runname.out.swe_out.$i_string.silo
    file delete $runname.out.t_grnd.$i_string.silo
    file delete $runname.out.t_soil.$i_string.silo

    file delete $runname.out.press_post_clm.$i_string.silo
    file delete $runname.out.press_pre_clm.$i_string.silo

    file delete         $runname.out.et.$i_string.pfb
    file delete         $runname.out.evaptrans.$i_string.silo
    file delete         $runname.out.evaptranssum.$i_string.silo
    file delete         $runname.out.obf.$i_string.pfb
    file delete         $runname.out.overland_bc_flux.obf.$i_string.silo
    file delete         $runname.out.overlandsum.$i_string.silo
	
}


file delete $runname.out.porosity.pfb
file delete $runname.out.perm_x.pfb
file delete $runname.out.perm_x.silo
file delete $runname.out.perm_y.pfb
file delete $runname.out.perm_y.silo
file delete $runname.out.perm_z.pfb
file delete $runname.out.perm_z.silo

