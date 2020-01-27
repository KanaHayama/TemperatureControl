module AD (clock, level, nCS, SDATA);
	input clock;
	output reg [7:0] level;
	output reg nCS;
	input SDATA;
	
	reg [7:0] tempLevel;
	reg [4:0] state;
	
	initial begin
		nCS = 1'b1;
		state = 5'd0;
		level = 8'd0;
	end
	
	always @(posedge clock) begin
		if (state <= 5'd11) begin
			if (state == 5'd0) begin
				nCS = 1'b0;
			end else if (5'd4 <= state && state <= 5'd11) begin
				tempLevel[5'd11 - state] = SDATA;
			end
			state = state + 5'd1;
		end else begin
			nCS = 1'b1;
			level = tempLevel;
			state = 5'd0;
		end
	end
endmodule