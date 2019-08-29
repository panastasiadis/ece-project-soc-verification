`timescale 1ns/10ps 
/*Author: Zhuxu 
	m99a1@yahoo.cn
Pulse Width Generators/timers with 16-bit main counter.
Period or timers target number is controlled by register [15:0]period.
Duty cycle is controlled by register [15:0]DC.
Clock used for PWM signal generation can be switched between Wishbone Bus clock and external clock. It is down clocked first.
o_pwm outputs PWM signal or timers interrupt.

control register [7:0]ctrl:
bit 0:	When set, external clock is chosen for PWM/timer. When cleared, wb clock is used for PWM/timer.
bit 1:	When set,  PWM is enabled. When cleared,  timer is enabled.
bit 2:	When set,  PWM/timer starts. When cleared, PWM/timer stops.
bit 3:	When set, timer runs continuously. When cleared, timer runs one time.
bit 4:	When set, o_pwm enabled.
bit 5:	timer interrupt bit	When it is written with 0, interrupt request is cleared. 
bit 6:	When set, a 16-bit external signal i_DC is used as duty cycle. When cleared, register DC is used.
bit 7:	When set, counter reset for PWM/timer, it's output and bit 5 will also be cleared. When changing from PWM mode to timer mode reset is needed before timer starts.
*/
module	PWM(
//wishbone slave interface
input	i_wb_clk,
input	i_wb_rst,
input	i_wb_cyc,
input	i_wb_stb,
input	i_wb_we,
input	[15:0]i_wb_adr,
input	[31:0]i_wb_data,
output	reg o_wb_ack,
output	o_pwm

);

////////////////////control logic////////////////////////////
parameter	adr_ctrl=0,
		adr_divisor=2,
		adr_period= 4,
		adr_DC=6;

reg	[7:0]ctrl;
reg	[31:0]period;
reg	[31:0]DC;
reg	[31:0]divisor;	//for down clocking. If(divisor==0)To=Ti;	else To=Ti/divisor;
reg ack_flag;

wire	write;
assign	write=i_wb_cyc&i_wb_stb&i_wb_we;
always@(posedge i_wb_clk or posedge i_wb_rst)
	if(i_wb_rst)begin
		ctrl[4:0]<=0;
		ctrl[7:6]<=0;
		DC<=0;
		period<=0;
		divisor<=0;
		o_wb_ack <= 0;
		ack_flag <=0; 
	end
	else if(ack_flag) begin
		o_wb_ack <=0;
		ack_flag <=0;
	end
	else if(write && (!ack_flag))begin
		o_wb_ack<=1;
		ack_flag <=1;
		case(i_wb_adr)
			adr_ctrl:begin
				ctrl[4:0]<=i_wb_data[4:0];
				ctrl[7:6]<=i_wb_data[7:6];
			end
			adr_divisor:divisor<=i_wb_data;
			adr_period:period<=i_wb_data;
			adr_DC:DC<=i_wb_data;
		endcase
	end


wire	pwm;
assign	pwm=ctrl[1];

/////////////////main counter //////////////////////////
reg	[31:0]ct;
reg	pts;	//PWM signal or timer interrupt signal
wire	[31:0]period_1;
assign	period_1=(period==0)?0:(period-1);
always@(posedge i_wb_clk or posedge i_wb_rst)
	if(i_wb_rst)begin
		ctrl[5]<=0;
		pts<=0;
		ct<=0;
	end
	else begin
	if(ctrl[2])begin
		case(pwm)
			1:begin
				if(ct>=period_1)ct<=0;
				else ct<=ct+1;

				if(ct<DC)pts<=1;
				else pts<=0;
			end
			0:begin

				if(ct>=period_1)begin
					pts<=1;
				end
				else ct<=ct+1;
			end
		endcase
	end
end
//////////////////////////////////////////////////////////

assign	o_pwm=ctrl[4]?pts:0;



endmodule
