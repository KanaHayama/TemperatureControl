module SimpleCore(clock, reset, dest, curr, level, neg);
	input clock;
	input reset;
	input [7:0] dest, curr;
	output reg [7:0] level;
	output reg neg;
	
	initial begin
		level = 8'b0;
		neg = 1'b0;
	end
	
	always @(negedge reset or posedge clock) begin
		if (!reset) begin
			level = 8'b0;
			neg = 1'b0;
		end else begin
			neg = 1'b0;
			if (dest == curr) begin
				level = 8'h80;
			end else if (dest > curr) begin
				level = 8'hFF;
			end else if (dest < curr) begin
				level = 8'h00;
				if (curr - dest > 2) begin
					neg = 1'b1;
				end
			end
		end
	end

endmodule