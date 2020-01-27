module DA (clock, level, nSYNC, DIN);
	input clock;
	input [7:0] level;
	output reg nSYNC;
	output reg DIN;
	reg [5:0] state;
	reg [7:0] tempLevel;
	
	initial begin
		nSYNC = 1'b1;
		state = 5'd0;
	end
	
	always @(posedge clock) begin
		if (state <= 5'd15) begin
			if (state == 5'd0) begin
				nSYNC = 1'b0;
				DIN = 1'b0;
			end else if (state == 5'd3) begin
				tempLevel = level;
			end else if (5'd4 <= state && state <= 5'd11) begin
				DIN = tempLevel[7];
				tempLevel = tempLevel << 1;
			end
			state = state + 5'd1;
		end else begin
			nSYNC = 1'b1;
			state = 5'd0;
		end
	end
endmodule