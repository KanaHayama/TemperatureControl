module ClockGenerator #(UPPER = 1) (clock, newClock);
	input clock;
	output reg newClock;
	reg [31:0] counter;
	
	initial begin
		counter = 32'b0;
		newClock = 1'b0;
	end
	
	always @(posedge clock) begin
		counter = counter + 1;
		if (counter >= UPPER) begin
			counter = 32'b0;
			newClock = !newClock;
		end
	end
endmodule