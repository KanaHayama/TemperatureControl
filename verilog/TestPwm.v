module TestPwm(clock, clockAD, nCS, SDATA, pwm, led);
	input clock;
	output clockAD;
	output nCS;
	input SDATA;
	output pwm;
	output [7:0] led;
	
	wire [7:0] level;
	assign clockAD = clock;
	AD(.clock(clock), .level(level), .SDATA(SDATA), .nCS(nCS));
	FixFreqPwmGen(.clock(clock), .level(level), .pwm(pwm));
	assign led[00] = !level[00];
	assign led[01] = !level[01];
	assign led[02] = !level[02];
	assign led[03] = !level[03];
	assign led[04] = !level[04];
	assign led[05] = !level[05];
	assign led[06] = !level[06];
	assign led[07] = !level[07];
endmodule