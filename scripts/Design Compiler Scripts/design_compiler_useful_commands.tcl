
#set_false_path -from clk -to extclk

#set_dft_signal -view exist -type ScanClock -timing {45 55} -port clk
#set_dft_signal -view exist -type ScanClock -timing {45 55} -port extclk

#set_dft_configuration -fix_reset enable
#set_dft_configuration -fix_set enable
 
#write_sdc power.sdc
