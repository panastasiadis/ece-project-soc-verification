`timescale 1ns/10ps


module wishbone_master_pwm (
//Wishbone Master Interface

    input             wb_clk_i,
    input             wb_rst_i,

    output reg [15:0]      wbm_adr_o,
    output reg          wbm_we_o,
    output reg          wbm_cyc_o,
    output reg         wbm_stb_o,
    output reg [31:0]    wbm_dat_o,
    input            wbm_ack_i,

    input [31:0]  period_input,


    input [31:0]  pid_output,
    input         pid_valid
    );

    reg ack_flag;
    reg [2:0] state;
    reg [31:0] period_data,adjusted_dcycle;
   	wire [31:0] ctrl_data;


    assign  ctrl_data = 32'h16;

    //adress parameters
parameter 

         adr_control =  0,
         adr_period  =  4,
         adr_dcycle =   6,

         state_registers = 0,
         state_period = 1,
         state_control = 2,
         state_dcycle = 3;

always@(posedge wb_clk_i or posedge wb_rst_i)
   if(wb_rst_i)begin
      period_data <= 0;
      state <= 0;
      ack_flag <= 0;
      wbm_stb_o <= 0;
      wbm_cyc_o <= 0;
      wbm_we_o <=  0;
      wbm_adr_o <= 0;
      wbm_dat_o <= 0;
      state <= 0;

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

                     period_data <= period_input;
                     state <= state + 1;
  

         end
         state_period: begin

                  if (!wbm_ack_i) begin
                     wbm_adr_o <= adr_period;
                     wbm_dat_o <= period_data;
                     wbm_we_o <= 1;
                     wbm_stb_o <= 1;
                     wbm_cyc_o <= 1;
                     state <= state + 1;
                     ack_flag <= 1;

                  end

         end
         state_control: begin

                  if (!wbm_ack_i) begin
                     wbm_adr_o <= adr_control;
                     wbm_dat_o <= ctrl_data;
                     wbm_we_o <= 1;
                     wbm_stb_o <= 1;
                     wbm_cyc_o <= 1;
                     state <= state + 1;
                     ack_flag <= 1;
                  end

         end
      state_dcycle: begin


                  if ((!wbm_ack_i) && pid_valid) begin

                     wbm_adr_o <= adr_dcycle;
                     wbm_dat_o <= adjusted_dcycle;
                     wbm_we_o  <= 1;
                     wbm_stb_o <= 1;
                     wbm_cyc_o <= 1;
                     state <= 0;
                     ack_flag <= 1;
                  end
         end        
      endcase
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
endmodule
