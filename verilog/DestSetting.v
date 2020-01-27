module DestSetting (clock, key, dest, changed);
	parameter MIN_DEST = 8'd178;
	parameter MAX_DEST = 8'd245;
	
	input clock;
	input [7:0] key;
	output reg [7:0] dest;
	output reg changed;
	reg [7:0] preDest;
	reg pressed;
	
	parameter INIT_DEST = 8'd204;
	
	initial begin
		preDest = INIT_DEST;
		dest = INIT_DEST;
		pressed = 1'b0;
		changed = 1'b0;
	end
	
	always @(posedge clock) begin
		preDest = dest;
		case (key)
			8'b11111111: pressed = 1'b0;
			8'b11111110: dest = 8'd204;
			8'b11111101: dest = 8'd209;
			8'b11111011: dest = 8'd214;
			8'b11110111: dest = 8'd219;
			8'b11101111: dest = 8'd224;
			8'b11011111: dest = 8'd229;
			8'b10111111: if (!pressed && dest < MAX_DEST) begin dest = dest + 1; pressed = 1'b1; end
			8'b01111111: if (!pressed && dest > MIN_DEST) begin dest = dest - 1; pressed = 1'b1; end
		endcase
		changed = preDest != dest;
	end
endmodule