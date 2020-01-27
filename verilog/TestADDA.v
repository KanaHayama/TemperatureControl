module TestADDA (originalClock, clockAD, clockDA, nCS, SDATA, nSYNC, DIN, led);
	input originalClock;
	output nCS;
	input SDATA;
	output nSYNC;
	output DIN;
	output clockAD;
	output clockDA;
	output [7:0] led;
	
	wire [7:0] tempLevel;
	
	AD(.clock(originalClock), .level(tempLevel), .SDATA(SDATA), .nCS(nCS));
	DA(.clock(originalClock), .level(tempLevel), .nSYNC(nSYNC), .DIN(DIN));
	assign clockAD = originalClock;
	assign clockDA = originalClock;
	assign led = ~tempLevel;
endmodule