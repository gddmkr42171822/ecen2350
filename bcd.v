module BCDcount(Clock, Pushbutton1, Pushbutton2, Pushbutton3, Clear, BCD0, BCD1, BCD2, BCD3, LED);
input Clear, Clock;
input Pushbutton1, Pushbutton2, Pushbutton3;
reg [24:0]clock_count;
output reg [3:0] BCD1, BCD0, BCD2, BCD3;
output reg LED;

always@(posedge Clock)
begin
	if(Clear)
		begin
		BCD0 <= 0;
		BCD1 <= 0;
		BCD2 <= 0;
		BCD3 <= 0;
		LED <= 0;
		clock_count <= 0;
		end
	else if (clock_count == 25000000)// Divide clock to 1hz/1 sec cycle
		begin
			clock_count <= 0;
			if (Pushbutton1==0)// pushbutton 1
			begin
				if(BCD0 == 4'b1001)
					begin
					BCD0 <= 0;
					if(BCD1 == 4'b1001)
						begin
						BCD1 <= 0;
						if(BCD2 == 4'b1001)
							begin
							BCD2 <= 0;
							if(BCD3 ==4'b1001)
								begin
								BCD3 <= 0;
								LED <= 1;
								end
							else
								BCD3 <= BCD3 +1;
							end
						else
						BCD2 <= BCD2+1;
						end
					else
						BCD1 <= BCD1 +1;
					end
				else
					begin
					BCD0 <= BCD0+1;
					end
			end
			else if (Pushbutton2==0)//pushbutton 2
			begin
				if(BCD1 == 4'b1001)
					begin
					BCD1 <= 0;
					if(BCD2 == 4'b1001)
						begin
						BCD2 <= 0;
						if(BCD3 == 4'b1001)
							begin
							BCD3 <= 0;
							LED <= 1;
							end
						else
							BCD3 <= BCD3 +1;
						end
					else
						BCD2 <= BCD2+1;
					end
				else
					begin
					BCD1 <= BCD1+1;
					end
			end
			else if (Pushbutton3 == 0)//pushbutton 3
			begin
				if(BCD2 == 4'b1001)
					begin
					BCD2 <= 0;
					if(BCD3 == 4'b1001)
						begin
						BCD3 <= 0;
						LED <= 1;
						end
					else
						BCD3 <= BCD3 +1;
					end
				else
					begin
					BCD2 <= BCD2 +1;
					end
			end	
		end
	else
		begin 
			clock_count <= clock_count+1;
		end
end

endmodule

/*
module BCDadder(Clear, Button, BCD0, BCD1, BCD2, BCD3, LED);
	input Clear, Button;
	output reg [3:0] BCD0, BCD1, BCD2, BCD3;
	output reg LED;
	
	

	always@(posedge Clear, posedge Button)
		if(Clear == 1)
			begin
			BCD0 <= 0;
			BCD1 <= 0;
			BCD2 <= 0;
			BCD3 <= 0;
			LED <= 0;
			end
		else if (Button==1)
			begin
				if(BCD0 == 4'b1001)
					begin
					BCD0 <= 0;
					if(BCD1 == 4'b1001)
						begin
						BCD1 <= 0;
						if(BCD2 == 4'b1001)
							begin
							BCD2 <= 0;
							if(BCD3 ==4'b1001)
								begin
								BCD3 <= 0;
								LED <= 1;
								end
							else
								BCD3 <= BCD3 +1;
							end
						else
						BCD2 <= BCD2+1;
						end
					else
						BCD1 <= BCD1 +1;
					end
				else
					begin
					BCD0 <= BCD0+1;
					end
			end
			
			
endmodule
*/


module seg7(bcd,leds);
input [3:0] bcd;
output reg [7:1] leds;

always@(bcd)
case(bcd)
0: leds = 7'b1000000;
1: leds = 7'b1111001;
2: leds = 7'b0100100;
3: leds = 7'b0110000;
4: leds = 7'b0011001;
5: leds = 7'b0010010;
6: leds = 7'b0000010;
7: leds = 7'b1111000;
8: leds = 7'b0000000;
9: leds = 7'b0010000;
default: leds = 7'b1000000;
endcase
endmodule

module bcd(Clock, Reset, Pushbutton1, Pushbutton2, Pushbutton3, Digit0, Digit1, Digit2, Digit3, LED);
input Reset, Clock;
input Pushbutton1, Pushbutton2, Pushbutton3;
output wire LED;
output wire[7:1] Digit0, Digit1, Digit2, Digit3;
wire [3:0] BCD1, BCD0, BCD2, BCD3;

BCDcount counter(Clock, Pushbutton1, Pushbutton2, Pushbutton3, Reset, BCD0, BCD1, BCD2, BCD3, LED);


seg7 seg0(BCD0, Digit0);
seg7 seg1(BCD1, Digit1);
seg7 seg2(BCD2, Digit2);
seg7 seg3(BCD3, Digit3);



endmodule
