# ############################################### dft_drc + scan chain insertion + dft coverage + report_timing
     dft_drc
     insert_dft
     dft_drc -coverage_estimate
     report_timing
     compile -incremental_mapping 
  
# ############################################### files needed for TetraMAX and Incisive
 uniquify
 write -h -f verilog -output scan_netlist.v
 write_sdf -version 1.0 setup.sdf
 #write_sdf -version 1.0 scan_hold.sdf
 
# ############################################### file needed for TetraMAX
# change_names -hierarchy -rule verilog
 write_test_protocol -output scan_protocol.stil
# 
# ###############################################write sdc for innovus
write_sdc timing_constraints_after_dft.sdc

read_saif -input /home/inf2015/paanastasiadis/soc7_new/scan_power_panag.saif -instance topmodule_test/dut -verbose
report_power -analysis_effort high 
