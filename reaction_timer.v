
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
			10: y=7'b0001000;
			11: y=7'b1100000;
			12: y=7'b0110001;
			13: y=7'b1000010;
			14: y=7'b0110000;
			15: y=7'b0111000;
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
		
module reactiontimer(Clock, Reset, Reactiontimer_Start, counter_start, Button, Right_LED, Left_LED, y0, y1, y2, y3);
input [1:0] Button;
input Clock, Reset, Reactiontimer_Start, counter_start;
wire right_button, left_button;
reg [6:0] counter;
reg [11:0] left_count, right_count, rightmilli_counter, leftmilli_counter;
reg [3:0] rightone_millisecond, leftone_millisecond;
reg [3:0] BCD0, BCD1, BCD2, BCD3;
reg en_right, en_left;
output reg Right_LED, Left_LED;
output [0:6] y0, y1, y2, y3;

initial begin
BCD0 <= 4'b0000;
BCD1 <= 4'b0000;
BCD2 <= 4'b0000;
BCD3 <= 4'b0000;
end

newPress one (Clock, Button[0], right_button);
newPress two (Clock, Button[1], left_button);

reg [9:0] usecond_cntr;
reg [9:0] msecond_cntr;

parameter CLOCK_MHZ = 50;

reg [7:0] tick_cntr;
reg tick_cntr_max;

always @(posedge Clock) begin
	if (Reset) begin
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
	if (Reset) begin
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
	if (Reset) begin
		msecond_cntr <= 0;
		msecond_cntr_max <= 0;
	end
	else if (usecond_cntr_max & tick_cntr_max) begin
		if (msecond_cntr_max) msecond_cntr <= 1'b0;
		else msecond_cntr <= msecond_cntr + 1'b1;
		msecond_cntr_max <= (msecond_cntr == 10'd998);
	end
end

initial begin
en_right <= 1'b1;
en_left <= 1'b1;
end

/* Assign random count values to each LED to get the random time between 500 and 3000ms to light up later */
always@(posedge Clock)
begin
	if(counter_start)
	begin
		if(Reactiontimer_Start)
		begin
			if(right_button||Reset||left_button)
			begin
				right_count <= 0;
				left_count <= 0;
			end
			else
			begin
				right_count <=  25 * (100 - counter) + 500;
				left_count <= 25 * (counter) + 500;
			end
		end
		else
		begin
			if(counter == 100)
			begin
				counter <= 0;
			end
			else 
			begin
				counter <= counter + 1'b1;
			end
		end
	end
	else
	begin
		counter <= 0;
	end
end

/* Light right LED after counting up to time from counter */
always@(posedge Clock)
begin
	if(Reset)
	begin
		en_right <= 1'b1;
		Right_LED <= 1'b0;
		rightmilli_counter <= 0;
	end
	else if(Reactiontimer_Start)
		begin
			if(right_button)
			begin
				Right_LED <= 1'b0;
			end
			else
			begin
				if((usecond_cntr_max & tick_cntr_max) && counter_start && en_right)
				begin
					if(rightmilli_counter == right_count)
					begin
						rightmilli_counter <= 0;
						Right_LED <= 1'b1;
						en_right <= 1'b0;
					end
					else
					begin
						rightmilli_counter <= rightmilli_counter + 1'b1;
					end
				end
			end
		end
	else
	begin
		Right_LED <= 1'b0;
	end
end

/* Seven segment out for right button and LED */
always@(posedge Clock)
begin
	if(Reset)
	begin
		BCD0 <= 4'b0000;
		BCD1 <= 4'b0000;
		rightone_millisecond <= 4'b0000;
	end
	else if(Right_LED)
	begin
		if(usecond_cntr_max & tick_cntr_max)
		begin
			if(rightone_millisecond == 4'b1001)
			begin
				rightone_millisecond = 4'b0000;
				if(BCD0 == 4'b1001)
				begin
					BCD0 <= 4'b0000;
					if(BCD1 == 4'b1001)
					begin
						BCD1 <= 4'b0000;
					end
					else
					begin
						BCD1 <= BCD1 + 1'b1;
					end
				end
				else
				begin
					BCD0 <= BCD0 + 1'b1;
				end
			end
			else
			begin
				rightone_millisecond <= rightone_millisecond + 1'b1;
			end
		end
	end
end


/* Light left LED after counting up to time from counter */
always@(posedge Clock)
begin
	if(Reset)
	begin
		en_left <= 1'b1;
		Left_LED <= 1'b0;
		leftmilli_counter <= 0;
	end
	else if(Reactiontimer_Start)
		begin
			if(left_button)
			begin
				Left_LED <= 1'b0;
			end
			else
			begin
				if((usecond_cntr_max & tick_cntr_max) && counter_start && en_left)
				begin
					if(leftmilli_counter == left_count)
					begin
						leftmilli_counter <= 0;
						Left_LED <= 1'b1;
						en_left <= 1'b0;
					end
					else
					begin
						leftmilli_counter <= leftmilli_counter + 1'b1;
					end
				end
			end
		end
	else
	begin
		Left_LED <= 1'b0;
	end
end

/* Seven segment out for right button and LED */
always@(posedge Clock)
begin
	if(Reset)
	begin
		BCD2 <= 4'b0000;
		BCD3 <= 4'b0000;
		leftone_millisecond <= 4'b0000;
	end
	else if(Left_LED)
	begin
		if(usecond_cntr_max & tick_cntr_max)
		begin
			if(leftone_millisecond == 4'b1001)
			begin
				leftone_millisecond = 4'b0000;
				if(BCD2 == 4'b1001)
				begin
					BCD2 <= 4'b0000;
					if(BCD3 == 4'b1001)
					begin
						BCD3 <= 4'b0000;
					end
					else
					begin
						BCD3 <= BCD3 + 1'b1;
					end
				end
				else
				begin
					BCD2 <= BCD2 + 1'b1;
				end
			end
			else
			begin
				leftone_millisecond <= leftone_millisecond + 1'b1;
			end
		end
	end
end

hexdisplay ss0 (BCD0, y0);
hexdisplay ss1 (BCD1, y1);
hexdisplay ss2 (BCD2, y2);
hexdisplay ss3 (BCD3, y3);


endmodule