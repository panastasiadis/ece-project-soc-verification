################################################## placement of I/O Pads in Netlist


  inbufs3_16 period_0 (.di(period), .pad(period_pad_0));
  inbufs3_16 kp_0 (.di(kp), .pad(kp_pad_0));
  inbufs3_16 ki_0 (.di(ki), .pad(ki_pad_0));
  inbufs3_16 kd_0 (.di(kd), .pad(kd_pad_0));
  inbufs3_16 sp_0 (.di(sp), .pad(sp_pad_0));
  inbufs3_16 clk_0 (.di(clk), .pad(clk_pad_0));
  inbufs3_16 extclk_0 (.di(extclk), .pad(extclk_pad_0));
  inbufs3_16 test_si1_0 (.di(test_si1), .pad(test_si1_pad_0));
  inbufs3_16 test_si2_0 (.di(test_si2), .pad(test_si2_pad_0));
  inbufs3_16 test_se_0 (.di(test_se), .pad(test_se_pad_0));
  
  iobuf3_16_4 o_pwm_0 (.do(o_pwm), .pad(o_pwm_pad_0), .en(1'b1));
  iobuf3_16_4 test_so1_0 (.do(test_so1), .pad(test_so1_pad_0), .en(1'b1));
  iobuf3_16_4 test_so2_0 (.do(test_so2), .pad(test_so2_pad_0), .en(1'b1));
  
