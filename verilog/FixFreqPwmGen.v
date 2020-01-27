module FixFreqPwmGen (clock, level, pwm);
	input clock;
	input [7:0] level;
	output reg pwm;
	reg [7:0] tempLevel;
	reg [7:0] counter;
	
	initial begin
		pwm = 1'b0;
		tempLevel = 8'd0;
		counter = 8'd0;
	end
	
	always @(posedge clock) begin
		counter = counter + 8'd1;
		if (counter == 8'hFF) begin
			tempLevel = level;
			counter = 8'd0;
		end
		if (counter < tempLevel) begin
			pwm = 1'b1;
		end else  begin
			pwm = 1'b0;
		end
	end
endmodule