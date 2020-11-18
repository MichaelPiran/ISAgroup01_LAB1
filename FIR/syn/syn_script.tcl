#source initialization script
#source /software/scripts/init_synopsys_64.18

#prepare Setup for Design Compiler
#define_design_lib WORK -path ./work

#set search_path [list ./software/synopsys/syn_current_64.18/libraries/syn/software/dk/nangate45/synopsys]

#set link_library [list "*" "NangateOpenCellLibrary_typical_ecsm.db" "dw_foundation.sldb"]

#set target_library [list "NangateOpenCellLibrary_typical_ecsm.db"]

#set synthetic_library [list "dw_foundation.sldb"]

#mkdir work

#dc_shell-xg-t

#Reading VHDL source files
analyze -f vhdl -lib work ../src/fir_package.vhd
analyze -f vhdl -lib work ../src/reg.vhd
analyze -f vhdl -lib work ../src/behavioral_filter.vhd

set power_preserve_rtl_hier_names true

elaborate FIR -arch BEHAVIOR -lib work > ./elaborate.txt

#Applying constraints

#clock
create_clock -name MY_CLK -period 4.48 CLK
set_dont_touch_network MY_CLK
set_clock_uncertainty 0.07 [get_clocks MY_CLK]

#Delay input signal w.r.t. clock
set_input_delay 0.5 -max -clock MY_CLK [remove_from_collection [all_inputs] CLK]
set_output_delay 0.5 -max -clock MY_CLK [all_outputs]

#Insert output loads
set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
set_load $OLOAD [all_outputs]

compile

report_timing > report_timing_file_fm4.txt

report_area > report_area_file_fm4.txt

#Save data required
ungroup -all -flatten
change_names -hierarchy -rules verilog
write_sdf ../netlist/FIR.sdf
write -f verilog -hierarchy -output ../netlist/FIR.v
write_sdc ../netlist/FIR.sdc

quit
