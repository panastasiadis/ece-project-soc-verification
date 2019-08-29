`timescale 1ns/10ps

module wishbone_master_pid (
//Wishbone Master Interface

    input             wb_clk_i,
    input             wb_rst_i,
    input             extclk,

    output reg [15:0]      wbm_adr_o,
    output reg          wbm_we_o,
    output reg          wbm_cyc_o,
    output reg         wbm_stb_o,
    output reg [31:0]    wbm_dat_o,
    input            wbm_ack_i,
    input [31:0]  kp_input,
    input [31:0]  ki_input,
    input [31:0]  kd_input,
    input [31:0]  sp_input,
    input [31:0]  period_input,

    input [31:0]  pid_output,
    input         pid_valid
    );

    reg ack_flag;
    reg [2:0] state;
    reg [31:0] kp_data, ki_data, kd_data, sp_data, pv_data, period_data,adjusted_dcycle;

    parameter 

         adr_kp      =  0,
         adr_ki      =  4,
         adr_kd      =  8,
         adr_sp      =  12,
         adr_pv      =  16,
         state_registers = 0,
         state_kp = 1,
         state_ki = 2,
         state_kd = 3,
         state_sp = 4,
         state_pv = 5;

 always@(posedge wb_clk_i or posedge wb_rst_i)
   if(wb_rst_i)begin
      kp_data <= 0;
      ki_data <= 0;
      kd_data <= 0;
      sp_data <= 0;
      period_data <= 0;
      state <= 0;
      ack_flag <= 0;
      wbm_stb_o <= 0;
      wbm_cyc_o <= 0;
      wbm_we_o <=  0;
      wbm_adr_o <= 0;
      wbm_dat_o <= 0;

   end
   else if (ack_flag) begin
        wbm_stb_o <= 0;
        wbm_cyc_o <= 0;
        wbm_we_o <=  0;
        ack_flag <=  0;
   end
   else if ((!ack_flag))begin
         case (state)
         state_registers: begin        //masters register their inputs
                   
                     kp_data <= kp_input;
                     ki_data <= ki_input;
                     kd_data <= kd_input;
                     sp_data <= sp_input;
 					 period_data <= period_input;
                     state <= state + 1;

         end
         state_kp: begin


                  if (!wbm_ack_i) begin
                     wbm_adr_o <= adr_kp;
                     wbm_dat_o <= kp_data;
                     wbm_we_o <= 1;
                     wbm_stb_o <= 1;
                     wbm_cyc_o <= 1;
                     state <= state + 1;
                     ack_flag <= 1;
                  end
		 end
         state_ki: begin

                  if (!wbm_ack_i) begin
                     wbm_adr_o <= adr_ki;
                     wbm_dat_o <= ki_data;
                     wbm_we_o <= 1;
                     wbm_stb_o <= 1;
                     wbm_cyc_o <= 1;
                     state <= state + 1;
                     ack_flag <= 1;

                  end
         end
         state_kd: begin

                  if (!wbm_ack_i) begin
                     wbm_adr_o <= adr_kd;
                     wbm_dat_o <= kd_data;
                     wbm_we_o <= 1;
                     wbm_stb_o <= 1;
                     wbm_cyc_o <= 1;
                     state <= state + 1;
                     ack_flag <= 1;
                  end

         end
      state_sp: begin
                  if (!wbm_ack_i) begin
                     wbm_adr_o <= adr_sp;
                     wbm_dat_o <= sp_data;
                     wbm_we_o <= 1;
                     wbm_stb_o <= 1;
                     wbm_cyc_o <= 1;
                     state <= state + 1;
                     ack_flag <= 1;
                  end
         end
      state_pv: begin
                  if (!wbm_ack_i) begin
                     wbm_adr_o <= adr_pv;
                     wbm_dat_o <= pv_data;
                     wbm_we_o  <= 1;
                     wbm_stb_o <= 1;
                     wbm_cyc_o <= 1;
                     state 	   <= 0;
                     ack_flag  <= 1;
                  end
        	end         
      endcase
   end


wire [31:0]result;
wire [31:0]D;
wire [31:0]R;
wire ok;

always @(posedge extclk or posedge wb_rst_i) begin
	if (wb_rst_i) begin
		// reset
		pv_data <= 0;
	end
	else if (ok) begin
		pv_data <= D;

	end
end


always @(posedge wb_clk_i or posedge wb_rst_i) begin
     if (wb_rst_i) begin
        adjusted_dcycle <= 0;
     end
     else if (pid_output[31] == 1) begin
          adjusted_dcycle <= 0;
        
     end
     else if (period_input < pid_output) begin
          adjusted_dcycle <=period_input;
    end
    else begin
          adjusted_dcycle <= pid_output;
    end
end
wire err;
multiplier multiplier_0(adjusted_dcycle[15:0],16'd100,result);
Divide Divide_0 (extclk,wb_rst_i,1'b1,result,period_input,D,R,ok,err);

endmodule
