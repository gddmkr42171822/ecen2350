/* This is not my code!
*	This code implements a metronome with the leds visually simulating the beat and the switches changing how fast 
*	the leds change on the de0.
*/

module Metronome(Clock, Button, Switch, Display1, Display2, Display3, Display4, Led);
	input Clock;
	input Button;
	input [7:0] Switch;
	output [0:7] Display1, Display2, Display3, Display4;
	output reg [9:0] Led;
	wire[3:0] Ones, Tens, Hundreds;
	reg NewClock;
	wire Start;
	wire Enable;
	wire [31:0] Step;
	wire [31:0] Timer;
	wire [31:0] CurrentTime;
	wire [15:0] BPMBinary;
	
	
	latchD latch2(Button, Clock, Start);
	
	BPMSelector BPMSet(Clock, Start, Switch, BPMBinary, Timer, Step, Enable);
	
	BCDConverter BCDConv(BPMBinary, Ones, Tens, Hundreds);
	
	SevenSegment SSeg1(Ones, Display1);
	SevenSegment SSeg2(Tens, Display2);
	SevenSegment SSeg3(Hundreds, Display3);
	SevenSegment SSeg4(0, Display4);

	integer i;
	reg [2:0] Y,y;
	parameter [2:0] S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100, S5 = 3'b101, S6 = 3'b110, S7 = 3'b111;
	
	initial begin
		y <= S0;
	end
	
	always@(posedge Clock)
	begin
		y <= Y;
		
		i <= (i + 1);
		if(i >=	Timer)
		begin	
			i <= 0;
			NewClock <= !NewClock;
		end
		
		if(Enable) begin
			case(y)
				S0: begin Led = 10'b0000110000; if(i >= Step) Y = S1; end
				S1: begin Led = 10'b0001111000; if(i >= Timer) Y = S2; end
				S2: begin Led = 10'b0011111100; if(i >= Step) Y = S3; end
				S3: begin Led = 10'b0111111110; if(i >= Timer) Y = S4; end
				S4: begin Led = 10'b1111111111; if(i >= Step) Y = S5; end
				S5: begin Led = 10'b0111111110; if(i >= Timer) Y = S6; end
				S6: begin Led = 10'b0011111100; if(i >= Step) Y = S7; end
				S7: begin Led = 10'b0001111000; if(i >= Timer) Y = S0; end
				default: Y = y;
			endcase
		end
		else begin
			Led = 10'b0000110000;
			Y = S0;
		end		
	end
	
endmodule

module BPMSelector(Clock, Start, Switch, BPMBinary, Timer, Step, Enable);
	input Clock;
	input Start;
	input [7:0] Switch;
	output reg [15:0] BPMBinary;
	output reg [31:0] Timer;
	output reg [31:0] Step;
	output reg Enable;

	always@(posedge Clock)
	begin
		case(Switch)
			8'b00000001: begin Timer = 32'd100000000; BPMBinary = 16'd15; Step = 32'd50000000; Enable = 1'b1; end
			8'b00000010: begin Timer = 32'd50000000; BPMBinary = 16'd30; Step = 32'd25000000; Enable = 1'b1; end
			8'b00000100: begin Timer = 32'd25000000; BPMBinary = 16'd60; Step = 32'd12500000; Enable = 1'b1; end
			8'b00001000: begin Timer = 32'd18750000; BPMBinary = 16'd80; Step = 32'd9375000; Enable = 1'b1; end
			8'b00010000: begin Timer = 32'd15000000; BPMBinary = 16'd100; Step = 32'd7500000; Enable = 1'b1; end
			8'b00100000: begin Timer = 32'd12500000; BPMBinary = 16'd120; Step = 32'd6250000; Enable = 1'b1; end
			8'b01000000: begin Timer = 32'd10000000; BPMBinary = 16'd150; Step = 32'd5000000; Enable = 1'b1; end
			8'b10000000: begin Timer = 32'd8333334; BPMBinary = 16'd180; Step = 32'd4166667; Enable = 1'b1; end
			default: begin Enable = 1'b0; BPMBinary=16'd0;end
		endcase		
	end
	
endmodule
	
module SevenSegment(BCD, Display);
	input [3:0] BCD;
	output reg [7:0] Display;
	
	always@(BCD)
	begin
		case(BCD)
			4'h0 : Display = 8'b00000011;
			4'h1 : Display = 8'b10011111;
			4'h2 : Display = 8'b00100101;
			4'h3 : Display = 8'b00001101;
			4'h4 : Display = 8'b10011001;
			4'h5 : Display = 8'b01001001;
			4'h6 : Display = 8'b01000001;
			4'h7 : Display = 8'b00011111;
			4'h8 : Display = 8'b00000001;
			4'h9 : Display = 8'b00001001; 
			default: Display = 8'b00000011;
		endcase
	end
endmodule

module latchD(D, Clock, Q);
	input D, Clock;
	output Q;
	reg [2:0] S;
	
	always@(posedge Clock)
	begin
		S[0] <= D;
		S[1] <= S[0];
		S[2] <= S[1];
	end
	
	assign Q = S[1]&~S[2];
	
endmodule

module BCDConverter(B, ones, tens, hundreds);
	input [15:0] B;
	output reg [3:0] ones, tens, hundreds;
	integer i;
	always @(B)
	begin
		ones = 4'd0;
		tens = 4'd0;
		hundreds = 4'd0;
		
		for(i = 15; i>=0; i = i - 1)
		begin
			if (hundreds >= 5)
				hundreds = hundreds + 3;
			if (tens >=5)
				tens = tens + 3;
			if (ones >= 5)
				ones = ones + 3;

			hundreds = hundreds << 1;
			hundreds[0] = tens[3];
			tens = tens << 1;
			tens[0] = ones[3];
			ones = ones << 1;
			ones[0] = B[i];
		end
	end
	
endmodule
