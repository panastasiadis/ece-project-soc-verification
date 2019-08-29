`timescale 1ns/10ps 

module topmodule (
	input clk,
	input rst,
	input extclk,
	input  [31:0]input_zero,
	output o_pwm

);

   parameter
         state_input = 0,
         state_kp = 1,
         state_ki = 2,
         state_kd = 3,
         state_sp = 4,
         state_period = 5,
         state_registers = 6;

wire [15:0] m2s_address1;
wire m2s_we1;
wire m2s_cyc1;
wire m2s_stb1;
wire [31:0] m2s_data1;
wire  s2m_ack1;

wire [15:0] m2s_address2;
wire m2s_we2;
wire m2s_cyc2;
wire m2s_stb2;
wire [31:0] m2s_data2;
wire  s2m_ack2;



wire [31:0]un;
wire valid;
wire ack_flag;

reg [31:0]kp;
reg [31:0]ki;
reg [31:0]kd;
reg [31:0]sp;
reg [31:0]period;
reg [2:0] state;

reg [31:0]kp_data;
reg [31:0]ki_data;
reg [31:0]kd_data;
reg [31:0]sp_data;
reg [31:0]period_data;




 always@(posedge clk or posedge rst) 
   if(rst)begin
      kp <= 0;
      ki <= 0;
      kd <= 0;
      sp <= 0;
      period <= 0;
      
      state <= 0;
      
      kp_data <= 0;
      ki_data <= 0;
      kd_data <= 0;
      sp_data <= 0;
      period_data <=0;

   end

   else begin
         case (state)
            state_input: begin
                state <= state + 1;
                end
            state_kp: begin
                kp_data <= input_zero;
                state <= state + 1;

            end
            
            state_ki: begin
                ki_data <= input_zero;
                state <= state + 1;

            end
            
            state_kd: begin
                kd_data <= input_zero;
                state <= state + 1;

            end

            state_sp: begin
                sp_data <= input_zero;
                state <= state + 1;
            end
            state_period: begin
                period_data <= input_zero;
                state <= state + 1 ;
            end
            state_registers: begin
                state <= state + 1;
                kp <= kp_data;
                ki <= ki_data;
                kd <= kd_data;
                sp <= sp_data;
                period <= period_data;
            end
        endcase
   end












wishbone_master_pid wishbone_master_pid_0   (clk
									  ,rst
									  ,extclk
									  ,m2s_address1
									  ,m2s_we1
									  ,m2s_cyc1
									  ,m2s_stb1
									  ,m2s_data1
									  ,s2m_ack1
									  ,kp
									  ,ki
									  ,kd
									  ,sp
									  ,period
									  ,un
									  ,valid			
);



PID PID0 (clk,
		  rst,
		  m2s_cyc1,
		  m2s_stb1,
		  m2s_we1,
		  m2s_address1,
		  m2s_data1,
		  s2m_ack1,
		  un,
		  valid
);




wishbone_master_pwm wishbone_master_pwm_0	 (clk,
									  rst,
									  m2s_address2,
									  m2s_we2,
									  m2s_cyc2,
									  m2s_stb2,
									  m2s_data2,
									  s2m_ack2,
									  period,
									  un,
									  valid
);


PWM PWM_0 (clk,
		   rst,
		   m2s_cyc2,
		   m2s_stb2,
		   m2s_we2,
		   m2s_address2,
		   m2s_data2,
		   s2m_ack2,
		   o_pwm
);




endmodule
