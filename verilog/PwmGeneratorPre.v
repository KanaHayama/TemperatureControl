module PwmGenerator #(MAX_LEVEL = 32'd8) (clock, up, down, pwm, level);
	input clock;
	input up;
	input down;
	output reg pwm;
	output reg [31:0] level;
	
	reg [31:0] counter;
	
	initial begin
		pwm = 1'b0;
		level = 32'b0;
		counter = 32'b0;
	end
	
	always @(posedge clock) begin
		if (down == 1'b1 && level > 32'd0) begin
			level = level - 1;
		end else if (up == 1'b1 && level < MAX_LEVEL) begin
			level = level + 1;
		end
		if (counter >= MAX_LEVEL - 1) begin
			counter = 32'h0;
		end else begin
			counter = counter + 1;
		end
		if (counter < level) begin
			pwm = 1'b1;
		end else  begin
			pwm = 1'b0;
		end
	end
endmodule
