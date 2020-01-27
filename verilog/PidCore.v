module PidCore(clock, reset, dest, curr, level, neg);
/* 可以使用的
	parameter SHIFT = 18;
	parameter P = 700000;//ok
	parameter I = 6;//5 6 7
	parameter D = 0;
	parameter ERROR_SUM_UPPER = (8'hFF << SHIFT) / I;
*/

	parameter SHIFT = 18;
	parameter P = 6000000;
	parameter I = 80;
	parameter D = 2000000;
	parameter ERROR_SUM_UPPER = 348160;
	parameter ERROR_SUM_LOWER = 174080;

	input clock;
	input reset;
	input [7:0] dest, curr;
	output reg [7:0] level;
	output reg neg;
	reg signed [8:0] err0, err1, err2;
	reg signed [9:0] errD;
	reg signed [47:0] errSum;
	reg signed [63:0] tempLevel;
	
	initial begin
		level = 8'b0;
		neg = 1'b0;
		err0 = 8'd0;
		err1 = 8'd0;
		err2 = 8'd0;
		errSum = 0;
	end
	
	always @(negedge reset or posedge clock) begin
		if (!reset) begin
			level = 8'b0;
			neg = 1'b0;
			err0 = 8'd0;
			err1 = 8'd0;
			err2 = 8'd0;
			errSum = 0;
		end else begin
			err0 = dest - curr;
			errSum = errSum + err0;
			errD = err1 - err2;
			err2 = err1;
			err1 = err0;
			
			if (errSum > ERROR_SUM_UPPER) begin
				errSum = ERROR_SUM_UPPER;
			end else if (errSum < -ERROR_SUM_LOWER) begin
				errSum = -ERROR_SUM_LOWER;
			end
			
			tempLevel = P * err0 + I * errSum + D * errD;
			
			if (tempLevel < 0) begin
				tempLevel = tempLevel >> SHIFT;
				level = 8'd0;
				if (tempLevel < -8'hC0) begin
					neg = 1'b1;
				end
			end else begin
				tempLevel = tempLevel >> SHIFT;
				neg = 1'b0;
				if (tempLevel > 8'hff) begin
					level = 8'hFF;
				end else begin
					level = tempLevel;
				end
			end
		end
	end

endmodule