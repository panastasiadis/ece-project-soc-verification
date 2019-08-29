############################################## read RTL and elaborate topmodule 
analyze -library WORK -format verilog {/home/inf2015/paanastasiadis/Beta/DC_Beta/booth.v /home/inf2015/paanastasiadis/Beta/DC_Beta/16x16bit_multiplier_pipelined.v /home/inf2015/paanastasiadis/Beta/DC_Beta/CLA_fixed.v /home/inf2015/paanastasiadis/Beta/DC_Beta/divider.v /home/inf2015/paanastasiadis/Beta/DC_Beta/dok_pwm.v /home/inf2015/paanastasiadis/Beta/DC_Beta/eudoxus_multiplier.v /home/inf2015/paanastasiadis/Beta/DC_Beta/PID.v /home/inf2015/paanastasiadis/Beta/DC_Beta/topmodule.v /home/inf2015/paanastasiadis/Beta/DC_Beta/wb_master_pid.v /home/inf2015/paanastasiadis/Beta/DC_Beta/wb_master_pwm.v}

elaborate topmodule -architecture verilog -library WORK

############################################### clocks, false path , drive & load 
create_clock clk -period 50
create_clock extclk -period 25
set_false_path -from rst
set_drive 3.1117 [all_inputs]
set_load 0.006109 [all_outputs]

############################################### create_test_protocol for dft
create_test_protocol -infer_asynch -infer_clock

############################################### compile for setup analysis
compile -map_effort high -scan
check_design
report_timing

############################################### write netlist and sdf without scans for behavioral simulation
uniquify
write -h -f verilog -output output/no_scan_netlist.v
write_sdf -version 1.0 output/no_scan_setup.sdf
write_sdc output/timing_constraints_before_dft.sdc
#write_sdf -version 1.0 hold.sdf

############################################### compile for hold-time analysis 
#compile - map_effort high -scan -only_hold_time
#report_timing -delay_type min

# ############################################### dft_drc + scan chain insertion + dft coverage + report_timing
     dft_drc
     insert_dft
     dft_drc -coverage_estimate
     report_timing
     compile -incremental_mapping 
  
# ############################################### files needed for TetraMAX and Incisive
 uniquify
 write -h -f verilog -output output/scan_netlist.v
 write_sdf -version 1.0 output/scan_setup.sdf
 #write_sdf -version 1.0 scan_hold.sdf
 
# ############################################### file needed for TetraMAX
# change_names -hierarchy -rule verilog
 write_test_protocol -output output/scan_protocol.stil
# 
# ###############################################write sdc for innovus
write_sdc output/timing_constraints_after_dft.sdc

# read_saif -input /home/inf2015/paanastasiadis/Beta/DC_Beta/power_panag.saif -instance topmodule_tb/topmodule_0 -verbose
# report_power -analysis_effort high 

