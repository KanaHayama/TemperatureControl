module DisplayDifference (displayMode, dest, curr, tube0, tube1);
	input displayMode;
	input [7:0] dest, curr;
	output reg [7:0] tube0, tube1;
	reg [7:0] difference, display;
	reg neg;
	
	initial begin
		difference = 8'd0;
		neg = 1'b0;
		tube0 = 8'hFF;
		tube1 = 8'hFF;
	end
	
	function [7:0] segment;
		input [3:0] dig;
		input dot;
		begin
			case (dig)
				0: segment = {dot, 7'b0111111}; // 0
				1: segment = {dot, 7'b0000110}; // 1
				2: segment = {dot, 7'b1011011}; // 2
				3: segment = {dot, 7'b1001111}; // 3
				4: segment = {dot, 7'b1100110}; // 4
				5: segment = {dot, 7'b1101101}; // 5
				6: segment = {dot, 7'b1111101}; // 6
				7: segment = {dot, 7'b0100111}; // 7
				8: segment = {dot, 7'b1111111}; // 8
				9: segment = {dot, 7'b1100111}; // 9
				10: segment = {dot, 7'b1110111}; // A
				11: segment = {dot, 7'b1111100}; // b
				12: segment = {dot, 7'b0111001}; // c
				13: segment = {dot, 7'b1011110}; // d
				14: segment = {dot, 7'b1111001}; // E
				15: segment = {dot, 7'b1110001}; // F
				default: segment = {dot, 7'b0000000};
			endcase
		end
	endfunction
	
	function [7:0] convertToDec;
		input [7:0] hex;
		reg [15:0] temp;
		begin
			temp = hex * 50;
			if (temp[7]) begin
				temp = (temp >> 8) + 1;
			end else begin
				temp = temp >> 8;
			end
			convertToDec = ((temp / 10) << 4) | (temp % 10);
		end
	endfunction
	
	always@(*) begin
		if (dest >= curr) begin
			difference = dest - curr;
			neg = 1'b0;
		end else begin
			difference = curr - dest;
			neg = 1'b1;
		end
		if (displayMode) begin
			display = convertToDec(difference);
		end else begin
			display = difference;
		end
		tube0 = segment(display, 1'b0);
		tube1 = segment(display >> 4, 1'b0);
		if (!neg) begin
			tube0 = ~tube0;
			tube1 = ~tube1;
		end
	end
endmodule