//timescale 1ns/10ps 

module topmodule_tb();


reg clk = 0;
reg rst = 1;
reg extclk = 0;


initial begin
	#60 rst=0;

end

always #50 clk <= ~clk;


always #25 extclk <= ~extclk;

    

reg [31:0] input_zero;



reg [31:0]counter;


reg [14:0]ct = 0;
always @(posedge clk or posedge rst) begin
	if (rst) begin
        input_zero <= 0;
	end
	else if (ct == 0) begin
        ct <= ct+1;
        input_zero <= 32'd30;
    end
    else if (ct == 1) begin
        ct <= ct + 1;
        input_zero <= 32'd13;
    end
    else if (ct == 2) begin
        ct <= ct + 1;
        input_zero <= 32'd5;
    end
    else if (ct == 3) begin
        ct <= ct + 1;
        input_zero <= 32'd20;
    end
       else if (ct == 4) begin
        ct <= ct + 1;
        input_zero <= 32'd8432;
    end
    else if (ct == 30000) begin
			$finish;
    end
    else begin
        ct <= ct + 1;
    end
end

topmodule topmodule_0 (.clk(clk),.rst(rst),.extclk(extclk),.input_zero(input_zero),.o_pwm(o_pwm));

always @(posedge clk or posedge rst) begin
	if (rst) begin
		counter <= 0;
		
	end
	else if (clk)  begin
		if (o_pwm) begin
			counter <= counter + 1;
		end
		else begin
		counter <= 0;
		end
		
	end
end


initial begin
    $sdf_annotate ("setup.sdf",topmodule_0,,,"maximum");
end


endmodule
