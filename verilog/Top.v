module Top (originalClock, clock, reset, clockAD, nCS, SDATA, clockDA, nSYNC, DIN, power, displayMode, coreSelect, pwm, nPwm, fan, led, tube0, tube1, tube2, tube2Com, key);
	
	input originalClock;
	output clock;
	input reset;
	output clockAD;
	output nCS;
	input SDATA;
	output clockDA;
	output nSYNC;
	output DIN;
	input power;
	input displayMode;
	input coreSelect;
	output pwm;
	output nPwm;
	wire pidFan, simpleFan;
	output fan;
	output [7:0] led;
	output [7:0] tube0, tube1, tube2;
	output [3:0] tube2Com;
	input [7:0] key;
	wire [7:0] pidOutputLevel, simpleOutputLevel, outputLevel;
	wire [7:0] destinationTemperature, currentTemperature;
	wire destChanged;
	
	ClockGenerator #(.UPPER(12000)) (.clock(originalClock), .newClock(clock));
	DestSetting(.clock(clock), .key(key), .dest(destinationTemperature), .changed(destChanged));
	PidCore(.clock(clock), .reset(power & reset & (!destChanged)), .dest(destinationTemperature), .curr(currentTemperature), .level(pidOutputLevel), .neg(pidFan));
	SimpleCore(.clock(clock), .reset(power & reset & (!destChanged)), .dest(destinationTemperature), .curr(currentTemperature), .level(simpleOutputLevel), .neg(simpleFan));
	FixFreqPwmGen(.clock(clock), .level(outputLevel), .pwm(pwm));
	AD(.clock(clock), .level(currentTemperature), .SDATA(SDATA), .nCS(nCS));
	DA(.clock(clock), .level(outputLevel), .nSYNC(nSYNC), .DIN(DIN));
	DisplayDifference(.displayMode(displayMode), .dest(destinationTemperature), .curr(currentTemperature), .tube0(tube0), .tube1(tube1));
	DisplayDestAndCurr(.clock(clock), .displayMode(displayMode), .dest(destinationTemperature), .curr(currentTemperature), .tube(tube2), .com(tube2Com));
	
	assign clockAD = clock;
	assign clockDA = clock;
	assign led = ~currentTemperature;
	assign nPwm = !pwm;
	assign outputLevel = coreSelect ? pidOutputLevel : simpleOutputLevel;
	assign fan = coreSelect ? pidFan : simpleFan;
endmodule