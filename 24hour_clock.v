/* Displays a 24-hour clock on the 7segement display on a DE0 
*	Borrowed code from stx_cookbook system_timer.v
*/

module hexdisplay (x,y);
	input [3:0] x;
	output reg [0:6] y;

	always@(x)
	begin
		case(x)
			0: y=7'b0000001;
			1: y=7'b1001111;
			2: y=7'b0010010;
			3: y=7'b0000110;
			4: y=7'b1001100;
			5: y=7'b0100100;
			6: y=7'b0100000;
			7: y=7'b0001111;
			8: y=7'b0000000;
			9: y=7'b0000100;
			default: y=7'b0000001;
		endcase
	end

endmodule	

module newPress(Clock, Btn, oNewPress);
input Clock;
input Btn;
output oNewPress;
reg [1:0] press;
	always@(posedge Clock)
	begin
	press <= {press[0], Btn};
	end
assign oNewPress = ~press[1]&press[0];
endmodule

module twentyfourhour_clock(Clock, clock_set, display_switch, Buttons, y0, y1, y2, y3);
input [1:0] Buttons;
input clock_set, display_switch, Clock;
wire hours, minutes;
reg [3:0] BCD0, BCD1, BCD2, BCD3;
reg [3:0] second_cntr1, second_cntr2, minute_cntr1, minute_cntr2, hour_cntr1, hour_cntr2;

output [0:6] y0, y1, y2, y3;

initial begin
	BCD0 <= 4'b0000;
	BCD1 <= 4'b0000;
	BCD2 <= 4'b0000;
	BCD3 <= 4'b0000;
	second_cntr1 <= 4'b0000;  
	second_cntr2 <= 4'b0000;
	minute_cntr1 <= 4'b0000;
	minute_cntr2 <= 4'b0000; 
	hour_cntr1 <= 4'b0000; 
	hour_cntr2 <= 4'b0000;
end

/* Button pulses */
newPress one (Clock, Buttons[0], minutes);
newPress two (Clock, Buttons[1], hours);

	reg [9:0] usecond_cntr;
	reg [9:0] msecond_cntr;
	reg [5:0] second_cntr;
	reg [5:0] minute_cntr;
	reg [4:0] hour_cntr;
	reg [9:0] day_cntr;

parameter CLOCK_MHZ = 50;

reg [7:0] tick_cntr;
reg tick_cntr_max;

// review tick counter design if leaving this range
// initial assert (CLOCK_MHZ > 64 && CLOCK_MHZ < 250);

always @(posedge Clock) begin
	if (clock_set) begin
		tick_cntr <= 0;
		tick_cntr_max <= 0;
	end
	else begin
		if (tick_cntr_max) tick_cntr <= 1'b0;
		else tick_cntr <= tick_cntr + 1'b1;
		tick_cntr_max <= (tick_cntr == (CLOCK_MHZ - 2'd2));
	end
end

/////////////////////////////////
// Count off 1000 us to form 1 ms
/////////////////////////////////
reg usecond_cntr_max;

always @(posedge Clock) begin
	if (clock_set) begin
		usecond_cntr <= 0;
		usecond_cntr_max <= 0;
	end
	else if (tick_cntr_max) begin
		if (usecond_cntr_max) usecond_cntr <= 1'b0;
		else usecond_cntr <= usecond_cntr + 1'b1;
		usecond_cntr_max <= (usecond_cntr == 10'd998);
	end
end

/////////////////////////////////
// Count off 1000 ms to form 1 s
/////////////////////////////////
reg msecond_cntr_max;

always @(posedge Clock) begin
	if (clock_set) begin
		msecond_cntr <= 0;
		msecond_cntr_max <= 0;
	end
	else if (usecond_cntr_max & tick_cntr_max) begin
		if (msecond_cntr_max) msecond_cntr <= 1'b0;
		else msecond_cntr <= msecond_cntr + 1'b1;
		msecond_cntr_max <= (msecond_cntr == 10'd998);
	end
end

/////////////////////////////////
// Count off 60s to form 1 m
/////////////////////////////////
reg second_cntr_max;

always @(posedge Clock) begin
	if (clock_set) begin
		second_cntr1 <= 4'b0000;
		second_cntr2 <= 4'b0000;
		second_cntr_max <= 1'b0;
	end
	else if (msecond_cntr_max & usecond_cntr_max & tick_cntr_max) begin
		if (second_cntr_max) 
		begin
			second_cntr1 <= 4'b0000;
			second_cntr2 <= 4'b0000;
			second_cntr_max <= 1'b0;
		end
		else
		begin	
			if(second_cntr1 == 4'b1001)
			begin
				second_cntr1 <= 4'b0000;
				if(second_cntr2 == 4'b0101)
				begin
					second_cntr2 <= 4'b0000;
				end
				else
				begin
					second_cntr2 <= second_cntr2 + 1'b1;
				end
			end
			else
			begin
				second_cntr1 <= second_cntr1 + 1'b1;
			end
		end
	end
	second_cntr_max <= (second_cntr2 == 4'b0101 && second_cntr1 == 4'b1001);
end

/////////////////////////////////
// Count off 60m to form 1hr
/////////////////////////////////
reg minute_cntr_max;

always @(posedge Clock) begin
	if (clock_set) begin
		if(minutes)
		begin
			if(minute_cntr1 == 4'b1001)
			begin
				minute_cntr1 <= 4'b0000;
				if(minute_cntr2 == 4'b0101)
				begin
					minute_cntr2 <= 4'b0000;
				end
				else
				begin
					minute_cntr2 <= minute_cntr2 + 1'b1;
				end
			end
			else
			begin
				minute_cntr1 <= minute_cntr1 + 1'b1;
			end
		end
	end
	else if (second_cntr_max & msecond_cntr_max & 
			usecond_cntr_max & tick_cntr_max) begin
		if (minute_cntr_max)
			begin
			minute_cntr1 <= 4'b0000;
			minute_cntr2 <= 4'b0000;
			minute_cntr_max <= 1'b0;
			end
		else 
		begin
			if(minute_cntr1 == 4'b1001)
			begin
				minute_cntr1 <= 4'b0000;
				if(minute_cntr2 == 4'b0101)
				begin
					minute_cntr2 <= 4'b0000;
				end
				else
				begin
					minute_cntr2 <= minute_cntr2 + 1'b1;
				end
			end
			else
			begin
				minute_cntr1 <= minute_cntr1 + 1'b1;
			end
		end
	end
	minute_cntr_max <= (minute_cntr1 == 4'b1001 && minute_cntr2 == 4'b0101);
end

/////////////////////////////////
// Count off 24h to form 1day
/////////////////////////////////
reg hour_cntr_max;

always @(posedge Clock) begin
	if (clock_set) begin
		if(hours)
		begin
			if(hour_cntr2 == 4'b0010 && hour_cntr1 == 4'b0011)
			begin
				hour_cntr2 <= 4'b0000;
				hour_cntr1 <= 4'b0000;
				hour_cntr_max <= 1'b0;
			end
			else
			begin
				if(hour_cntr1 == 4'b1001)
				begin
					hour_cntr1 <= 4'b0000;
					hour_cntr2 <= hour_cntr2 + 1'b1;
				end
				else
				begin
					hour_cntr1 <= hour_cntr1 + 1'b1;
				end
			end
		end
	end
	else if (minute_cntr_max & second_cntr_max & msecond_cntr_max &
			 usecond_cntr_max & tick_cntr_max) begin
		if (hour_cntr_max)
		begin
			hour_cntr1 <= 4'b0000;
			hour_cntr2 <= 4'b0000;
			hour_cntr_max <= 1'b0;
		end 
		else
		begin
			if(hour_cntr1 == 4'b1001)
			begin
				hour_cntr1 <= 4'b0000;
				hour_cntr2 <= hour_cntr2 + 1'b1;
			end
			else
			begin
				hour_cntr1 <= hour_cntr1 + 1'b1;
			end
		end
	end
	hour_cntr_max <= (hour_cntr1 == 4'b0011 && hour_cntr2 == 4'b0010);
end

/* Switches the 7segment between Min:Sec and Hr:Min */
always@(posedge Clock)
begin
	if(display_switch == 0)
	begin
		BCD0 <= second_cntr1;
		BCD1 <= second_cntr2;
		BCD2 <= minute_cntr1;
		BCD3 <= minute_cntr2;
	end
	else if(display_switch == 1)
	begin
		BCD0 <= minute_cntr1;
		BCD1 <= minute_cntr2;
		BCD2 <= hour_cntr1;
		BCD3 <= hour_cntr2;
	end
end

hexdisplay ss0 (BCD0, y0);
hexdisplay ss1 (BCD1, y1);
hexdisplay ss2 (BCD2, y2);
hexdisplay ss3 (BCD3, y3);

endmodule
