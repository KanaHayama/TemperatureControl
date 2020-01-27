module DisplayDestAndCurr (clock, displayMode, dest, curr, tube, com);
	input clock;
	input displayMode;
	input [7:0] dest, curr;
	output reg [7:0] tube;
	output reg [3:0] com;
	reg [1:0] comState;
	reg [7:0] displayDest, displayCurr;
	wire displayClock;
	
	ClockGenerator #(.UPPER(3)) (.clock(clock), .newClock(displayClock));
	
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
	
	initial begin
		comState = 2'b00;
	end
	
	always @(posedge displayClock) begin
		comState = comState + 2'd1;
		com = 4'b0000;
		if (displayMode) begin
			displayCurr = convertToDec(curr);
			displayDest = convertToDec(dest);
		end else begin
			displayCurr = curr;
			displayDest = dest;
		end
		case (comState)
			0: tube = segment(displayCurr, 1'b1);
			1: tube = segment(displayCurr >> 4, 1'b0);
			2: tube = segment(displayDest, 1'b1);
			3: tube = segment(displayDest >> 4, 1'b0);
		endcase
		tube = ~tube;
		case (comState)
			0: com = 4'b1110;
			1: com = 4'b1101;
			2: com = 4'b1011;
			3: com = 4'b0111;
		endcase
		//com = ~com;
	end

endmodule