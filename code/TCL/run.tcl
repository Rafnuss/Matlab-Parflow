#---------------------------------------------------------
# TCL Script initialize
#---------------------------------------------------------
#set env(PARFLOW_DIR) /home/raphael/parflow/parflow

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
set runname [gets $fileId]
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




#-----------------------------------------------------------------------------
# Prepare stuff before
#-----------------------------------------------------------------------------

set dem [pfload dem.sa]
set perm [pfload perm.sa]

eval [format "pfsetgrid { %d %d %d } { %f %f %f } { %f %f %f } %s " $NX $NY $NZ $LowerX $LowerY $LowerZ $DX $DY $DZ {$dem}]
eval [format "pfsetgrid { %d %d %d } { %f %f %f } { %f %f %f } %s " $NX $NY $NZ $LowerX $LowerY $LowerZ $DX $DY $DZ {$perm}]

set slopex 		[pfslopex $dem]
set slopey		[pfslopey $dem]



pfsave $dem 	-pfb dem.pfb
pfsave $perm 	-pfb perm.pfb
pfsave $slopex 	-pfb slopex.pfb
pfsave $slopey 	-pfb slopey.pfb
pfsave $dem 	-sa dem.txt
pfsave $perm 	-sa perm.txt

#-----------------------------------------------------------------------------
# Computational Grid
#-----------------------------------------------------------------------------
pfset ComputationalGrid.Lower.X		$LowerX
pfset ComputationalGrid.Lower.Y		$LowerY
pfset ComputationalGrid.Lower.Z		$LowerZ

pfset ComputationalGrid.NX		$NX
pfset ComputationalGrid.NY		$NY
pfset ComputationalGrid.NZ		$NZ

pfset ComputationalGrid.DX		$DX
pfset ComputationalGrid.DY		$DY
pfset ComputationalGrid.DZ		$DZ

#-----------------------------------------------------------------------------
# The Names of the GeomInputs
#-----------------------------------------------------------------------------
pfset GeomInput.Names				"solidinput backgroundinput"
pfset GeomInput.solidinput.InputType  		SolidFile
pfset GeomInput.solidinput.GeomNames  		solid
pfset GeomInput.solidinput.FileName   		shape.pfsol 

pfset GeomInput.backgroundinput.InputType  	Box
pfset GeomInput.backgroundinput.GeomName   	background

pfset Geom.background.Lower.X			$LowerX 
pfset Geom.background.Lower.Y			$LowerY
pfset Geom.background.Lower.Z			$LowerZ
pfset Geom.background.Upper.X			$UpperX
pfset Geom.background.Upper.Y			$UpperY
pfset Geom.background.Upper.Z			$UpperZ

pfset Geom.solid.Patches             		"z-upper z-lower x-lower \
						x-upper y-lower y-upper"
#-----------------------------------------------------------------------------
# Domain
#-----------------------------------------------------------------------------
pfset Domain.GeomName 			solid


#-----------------------------------------------------------------------------
# Perm
#-----------------------------------------------------------------------------
pfset Geom.Perm.Names                 	background

pfset Geom.background.Perm.Type        	PFBFile
pfset Geom.background.Perm.FileName 	perm.pfb
#pfset Geom.background.Perm.Type 		Constant
#pfset Geom.background.Perm.Value		0.0150

pfset Perm.TensorType               	TensorByGeom
pfset Geom.Perm.TensorByGeom.Names  	solid

pfset Geom.solid.Perm.TensorValX  	1.0
pfset Geom.solid.Perm.TensorValY  	1.0
pfset Geom.solid.Perm.TensorValZ  	1.0

#-----------------------------------------------------------------------------
# Specific Storage
#-----------------------------------------------------------------------------

pfset SpecificStorage.Type            	Constant
pfset SpecificStorage.GeomNames       	solid
pfset Geom.solid.SpecificStorage.Value $Ss

#-----------------------------------------------------------------------------
# Phases
#-----------------------------------------------------------------------------
pfset Phase.Names "water"
pfset Phase.water.Density.Type	        Constant
pfset Phase.water.Density.Value	        1.0
pfset Phase.water.Viscosity.Type	Constant
pfset Phase.water.Viscosity.Value	1.0

#-----------------------------------------------------------------------------
# Contaminants
#-----------------------------------------------------------------------------
pfset Contaminants.Names		""

#-----------------------------------------------------------------------------
# Retardation
#-----------------------------------------------------------------------------
pfset Geom.Retardation.GeomNames	""

#-----------------------------------------------------------------------------
# Gravity
#-----------------------------------------------------------------------------
pfset Gravity				1.0
 
#-----------------------------------------------------------------------------
# Porosity
#-----------------------------------------------------------------------------
pfset Geom.Porosity.GeomNames          	"solid"
pfset Geom.solid.Porosity.Type          Constant
pfset Geom.solid.Porosity.Value         $porosity

#-----------------------------------------------------------------------------
# Relative Permeability
#-----------------------------------------------------------------------------
pfset Phase.RelPerm.Type               		VanGenuchten
pfset Phase.RelPerm.GeomNames          		"solid"
#pfset Phase.RelPerm.VanGenuchten.File		1

#pfset Geom.solid.RelPerm.Alpha.Filename	alphas.pfb
#pfset Geom.solid.RelPerm.N.Filename        	Ns.pfb
pfset Geom.solid.RelPerm.Alpha			$alpha
pfset Geom.solid.RelPerm.N	        	$N


#-----------------------------------------------------------------------------
# Saturation
#-----------------------------------------------------------------------------
pfset Phase.Saturation.Type              	VanGenuchten
pfset Phase.Saturation.GeomNames         	"solid"
#pfset Phase.Saturation.VanGenuchten.File	1

#pfset Geom.solid.Saturation.Alpha.Filename	alphas.pfb
#pfset Geom.solid.Saturation.N.Filename        	Ns.pfb
#pfset Geom.solid.Saturation.SRes.Filename	SRes.pfb
#pfset Geom.solid.Saturation.SSat.Filename	SSat.pfb
pfset Geom.solid.Saturation.Alpha		$alpha
pfset Geom.solid.Saturation.N			$N
pfset Geom.solid.Saturation.SRes		$SRes
pfset Geom.solid.Saturation.SSat		$SSat


#-----------------------------------------------------------------------------
# Wells
#-----------------------------------------------------------------------------
pfset Wells.Names			""

#-----------------------------------------------------------------------------
# Setup timing info
#-----------------------------------------------------------------------------
pfset TimingInfo.BaseUnit        	1.0
pfset TimingInfo.StartCount      	$starttime
pfset TimingInfo.StartTime       	0.0
pfset TimingInfo.StopTime        	$stoptime
pfset TimingInfo.DumpInterval    	$dumptime
pfset TimeStep.Type              	Constant
pfset TimeStep.Value             	$steptime

#-----------------------------------------------------------------------------
# Time Cycles
#-----------------------------------------------------------------------------
pfset Cycle.Names			"constant"
# vary"
pfset Cycle.constant.Names		"alltime"
pfset Cycle.constant.alltime.Length	1
pfset Cycle.constant.Repeat		-1
    

#---------------------------------------------------------
# Topo slopes in x-direction
#---------------------------------------------------------
pfset TopoSlopesX.Type 				PFBFile
pfset TopoSlopesX.GeomNames 			"solid"
pfset TopoSlopesX.FileName			slopex.pfb
#pfset TopoSlopesX.Geom.solid.Value 		0.010000000000000000000

#---------------------------------------------------------
# Topo slopes in y-direction
#---------------------------------------------------------
pfset TopoSlopesY.Type 				PFBFile
pfset TopoSlopesY.GeomNames 			"solid"
pfset TopoSlopesY.FileName			slopey.pfb
#pfset TopoSlopesY.Geom.solid.Value 			0.010000000000

#---------------------------------------------------------
# Mannings coefficient 
#---------------------------------------------------------
pfset Mannings.Type				Constant
pfset Mannings.GeomNames 			"solid"
#pfset Mannings.FileName	 			manning.pfb
pfset Mannings.Geom.solid.Value 	$manning

#-----------------------------------------------------------------------------
# Phase sources:
#-----------------------------------------------------------------------------

pfset PhaseSources.water.Type			Constant
pfset PhaseSources.water.GeomNames		solid
pfset PhaseSources.water.Geom.solid.Value	0.0

#-----------------------------------------------------------------------------
# Exact solution specification for error calculations
#-----------------------------------------------------------------------------

pfset KnownSolution                                    NoKnownSolution


#-----------------------------------------------------------------------------
# Boundary Conditions: Pressure
#-----------------------------------------------------------------------------
pfset BCPressure.PatchNames				[pfget Geom.solid.Patches]

pfset Patch.x-lower.BCPressure.Type			FluxConst
pfset Patch.x-lower.BCPressure.Cycle			"constant"
pfset Patch.x-lower.BCPressure.alltime.Value		0.0

pfset Patch.y-lower.BCPressure.Type			FluxConst
pfset Patch.y-lower.BCPressure.Cycle			"constant"
pfset Patch.y-lower.BCPressure.alltime.Value		0.0

pfset Patch.z-lower.BCPressure.Type			FluxConst
pfset Patch.z-lower.BCPressure.Cycle			"constant"
pfset Patch.z-lower.BCPressure.alltime.Value		0.0

pfset Patch.x-upper.BCPressure.Type			FluxConst
pfset Patch.x-upper.BCPressure.Cycle			"constant"
pfset Patch.x-upper.BCPressure.alltime.Value		0.0

pfset Patch.y-upper.BCPressure.Type			FluxConst
pfset Patch.y-upper.BCPressure.Cycle			"constant"
pfset Patch.y-upper.BCPressure.alltime.Value		0.0

pfset Patch.z-upper.BCPressure.Type			OverlandFlow
pfset Patch.z-upper.BCPressure.Cycle			"constant"
pfset Patch.z-upper.BCPressure.alltime.Value		0.00	 


#---------------------------------------------------------
# Initial conditions: water pressure
#---------------------------------------------------------

if {$ICPressVal == 0} {
	pfset ICPressure.Type                                   PFBFile
	pfset ICPressure.GeomNames                              "solid"
	pfset Geom.domain.ICPressure.FileName         	"ic_pressure.pfb"
} elseif {$starttime > 0} {
	pfset ICPressure.Type                                   PFBFile
	pfset ICPressure.GeomNames                              "solid"
	pfset Geom.domain.ICPressure.FileName              $ICpressurefilname
} else {
pfset ICPressure.Type                                   HydroStaticPatch
pfset ICPressure.GeomNames                              solid
pfset Geom.solid.ICPressure.Value                      	$ICPressVal
pfset Geom.solid.ICPressure.RefGeom                    	solid
pfset Geom.solid.ICPressure.RefPatch                   	z-lower
}




#-----------------------------------------------------------------------------
# Set solver parameters
#-----------------------------------------------------------------------------

pfset Solver                                            Richards
#pfset Solver.TerrainFollowingGrid						False
#pfset Solver.MaxIter                       			2500
#pfset Solver.Drop                          			1E-20
#pfset Solver.AbsTol									1E-12
pfset Solver.MaxConvergenceFailures 			5
pfset Solver.Nonlinear.MaxIter              		50
pfset Solver.Nonlinear.StepTol				1e-4
pfset Solver.Nonlinear.ResidualTol			1e-6

#pfset Solver.Nonlinear.EtaChoice                        EtaConstant
#pfset Solver.Nonlinear.EtaValue                         0.001
#pfset Solver.Nonlinear.UseJacobian                       True

#pfset Solver.Nonlinear.DerivativeEpsilon                1e-6

#pfset Solver.Nonlinear.Globalization                    LineSearch
pfset Solver.Linear.KrylovDimension                    20
pfset Solver.Linear.MaxRestarts				2
#pfset Solver.Linear.Preconditioner                       SMG
#PFMG
#pfset Solver.Linear.Preconditioner.PCMatrixType		FullJacobian

#CLM
pfset Solver.LSM					CLM
pfset Solver.PrintLSMSink 				True
pfset Solver.CLM.MetForcing				1D
pfset Solver.WriteSiloCLM				True
pfset Solver.CLM.Print1dOut				True
pfset Solver.WriteCLMBinary				False
pfset Solver.CLM.BinaryOutDir				False
pfset Solver.CLM.MetFileName                    	met.0.txt
pfset Solver.CLM.CLMDumpInterval			$dumptime
#pfset Solver.CLM.CLMFileDir				./CLM_output/
if {$starttime != 0} {
	pfset Solver.CLM.IstepStart 				[expr $starttime+1]
}


#WriteSilo
#pfset Solver.WriteSiloPressure 				True
#pfset Solver.WriteSiloSaturation 			True
pfset Solver.WriteSiloSubsurfData			True
#pfset Solver.WriteSiloSlopes				True
#pfset Solver.WriteSiloMask				True
pfset Solver.WriteSiloMannings				True
pfset Solver.WriteSiloSpecificStorage			True
pfset Solver.WriteSiloVelocities			True
pfset Solver.WriteSiloEvapTrans			  	True
pfset Solver.WriteSiloEvapTransSum			True
pfset Solver.WriteSiloOverlandSum			True
pfset Solver.WriteSiloOverlandBCFlux			True

#-----------------------------------------------------------------------------
# Run and Unload the ParFlow output files
#-----------------------------------------------------------------------------

set num_processors [expr [pfget Process.Topology.P] * [pfget Process.Topology.Q] * [pfget Process.Topology.R]]
for {set i 0} { $i <= $num_processors } {incr i} {
    file delete drv_vegm.dat.$i
    file copy  drv_vegm.dat drv_vegm.dat.$i
    file delete drv_clmin.dat.$i
    file copy drv_clmin.dat drv_clmin.dat.$i
}

pfset ComputationalGrid.NZ		1
pfdist 		slopex.pfb
pfdist 		slopey.pfb
#pfdist 		manning.pfb

pfset ComputationalGrid.NZ		$NZ
pfdist 		perm.pfb
if {$starttime != 0} {pfdist $ICpressurefilname}
if {$ICPressVal == 0} {pfdist 		ic_pressure.pfb}
#pfdist 	Ns.pfb
#pfdist 	alphas.pfb
#pfdist 	SRes.pfb
#pfdist 	SSat.pfb

pfrun $runname
pfundist $runname

#pfundist 	SSat.pfb
#pfundist 	SRes.pfb
#pfundist 	alphas.pfb
#pfundist 	Ns.pfb
pfundist 	perm.pfb
if {$ICPressVal == 0} {pfundist 	ic_pressure.pfb}
if {$starttime != 0} {pfundist $ICpressurefilname}
pfundist 	slopex.pfb
pfundist 	slopey.pfb
#pfundist 	manning.pfb



#-----------------------------------------------------------------------------
# Create more intresting data
#-----------------------------------------------------------------------------
set mask 		[pfload $runname.out.mask.pfb]
set mannings		[pfload $runname.out.mannings.silo]
set specific_storage	[pfload $runname.out.specific_storage.silo]
set porosity		[pfload $runname.out.porosity.silo]

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

    set saturation		[pfload $runname.out.satur.$i_string.pfb]
    set pressure		[pfload $runname.out.press.$i_string.pfb]
    set head 			[pfhhead $pressure]
    set flux			[pfflux $perm $head]

    set top_pressure [pfextracttop $top $pressure]
    set top_head [pfextracttop $top $head] 
    set top_saturation [pfextracttop $top $saturation]

    set depth [pfwatertabledepth $top $saturation]

    set subsurface_storage [pfsubsurfacestorage $mask $porosity $pressure $saturation $specific_storage]
    set surface_storage [pfsurfacestorage $top $pressure]
    set surface_runoff [pfsurfacerunoff $top $slopex $slopey $mannings $pressure]

    set tsubsurface_storage [pfsum $subsurface_storage]
    set tsurface_storage [pfsum $surface_storage]
    set tsurface_runoff [ expr [pfsum $surface_runoff] ]
  
	
	set fileId [open "storage.txt" "a"]
    puts -nonewline $fileId $tsubsurface_storage
    puts -nonewline $fileId "\t"
    puts -nonewline $fileId $tsurface_storage
    puts -nonewline $fileId "\t"
    puts $fileId $tsurface_runoff
    close $fileId

    cd ./TXT

    pfsave $pressure 		-sa pressure.$i_string.txt
    pfsave $saturation 		-sa saturation.$i_string.txt
    pfsave $head 			-sa head.$i_string.txt
	pfsave $flux 			-sa flux.$i_string.txt
    
    pfsave $top_pressure 	-sa top_pressure.$i_string.txt
    pfsave $top_saturation 	-sa top_saturation.$i_string.txt
    pfsave $top_head 		-sa top_head.$i_string.txt
    
    pfsave $depth  		-sa depth.$i_string.txt

    pfsave $subsurface_storage 	-sa subsurface_storage.$i_string.txt
    pfsave $surface_storage 	-sa surface_storage.$i_string.txt
    pfsave $surface_runoff 	-sa surface_runoff.$i_string.txt

    cd ..
}


for {set i 1} { $i <= $timei } {incr i} {
    set i_string [format "%05d" $i]    
    
    set eflx_lh_tot [pfload $runname.out.eflx_lh_tot.$i_string.silo]
    set eflx_lwrad_out [pfload $runname.out.eflx_lwrad_out.$i_string.silo]
    set eflx_soil_grnd [pfload $runname.out.eflx_soil_grnd.$i_string.silo]
    set eflx_sh_tot [pfload $runname.out.eflx_sh_tot.$i_string.silo]
    set qflx_evap_grnd [pfload $runname.out.qflx_evap_grnd.$i_string.silo]
    set qflx_evap_soi [pfload $runname.out.qflx_evap_soi.$i_string.silo]
    set qflx_evap_tot [pfload $runname.out.qflx_evap_tot.$i_string.silo]
    set qflx_evap_veg [pfload $runname.out.qflx_evap_veg.$i_string.silo]
    set qflx_infl [pfload $runname.out.qflx_infl.$i_string.silo]
    set qflx_tran_veg [pfload $runname.out.qflx_tran_veg.$i_string.silo]
    set swe_out [pfload $runname.out.swe_out.$i_string.silo]
    set t_grnd [pfload $runname.out.t_grnd.$i_string.silo]
    set t_soil [pfload $runname.out.t_soil.$i_string.silo]

    set et              [pfextracttop $top [pfload $runname.out.et.$i_string.pfb]]
    set evaptrans       [pfextracttop $top [pfload $runname.out.evaptrans.$i_string.silo]]
    set evaptranssum    [pfextracttop $top [pfload $runname.out.evaptranssum.$i_string.silo]]
    set obf             [pfload $runname.out.obf.$i_string.pfb]
    set overland_bcflux [pfload $runname.out.overland_bc_flux.obf.$i_string.silo]
    set overlandsum [pfload $runname.out.overlandsum.$i_string.silo]

    cd ./TXT

    pfsave $eflx_lh_tot -sa eflx_lh_tot.$i_string.txt
    pfsave $eflx_lwrad_out -sa eflx_lwrad_out.$i_string.txt
    pfsave $eflx_soil_grnd -sa eflx_soil_grnd.$i_string.txt
    pfsave $eflx_sh_tot -sa eflx_sh_tot.$i_string.txt
    pfsave $qflx_evap_grnd -sa qflx_evap_grnd.$i_string.txt
    pfsave $qflx_evap_soi -sa qflx_evap_soi.$i_string.txt
    pfsave $qflx_evap_tot -sa qflx_evap_tot.$i_string.txt
    pfsave $qflx_evap_veg -sa qflx_evap_veg.$i_string.txt
    pfsave $qflx_infl -sa qflx_infl.$i_string.txt
    pfsave $qflx_tran_veg -sa qflx_tran_veg.$i_string.txt
    pfsave $swe_out -sa swe_out.$i_string.txt
    pfsave $t_grnd -sa t_grnd.$i_string.txt
    pfsave $t_soil -sa t_soil.$i_string.txt

    pfsave $et              -sa et.$i_string.txt
    pfsave $evaptrans       -sa evaptrans.$i_string.txt
    pfsave $evaptranssum   -sa evaptranssum.$i_string.txt
    pfsave $obf             -sa obf.$i_string.txt
    pfsave $overland_bcflux -sa overland_bcflux.obf.$i_string.txt
    pfsave $overlandsum     -sa overlandsum.$i_string.txt
	
    cd ..	
}


