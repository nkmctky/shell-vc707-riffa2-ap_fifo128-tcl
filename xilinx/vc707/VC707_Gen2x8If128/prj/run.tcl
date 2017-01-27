#
# Usage: vivado -mode batch -source run.tcl
#
#
# implementation.tcl  Tcl script for implementation
#
set     project_directory   [file dirname [info script]]
set     project_name        "VC707_Gen2x8If128"
#
# Open Project
#
open_project [file join $project_directory $project_name]
#
# Run Synthesis
#
launch_runs synth_1
wait_on_run synth_1
#
# Run Implementation
#
launch_runs impl_1
wait_on_run impl_1
open_run    impl_1
report_utilization -file [file join $project_directory "utilization.rpt" ]
report_timing      -file [file join $project_directory "timing.rpt" ]
#
# Write Bitstream File
#
launch_runs impl_1 -to_step write_bitstream -job 4
wait_on_run impl_1
#
# Close Project
#
close_project
