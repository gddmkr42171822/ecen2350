/* Code that adds bcd digits with by pressing or holding down the pushbuttons on the de0 and outputs it to the 
 * seven seg display
*/

module bcd_assign2(de0_clk, clear, led, btn, y0, y1, y2, y3);
	input clear, de0_clk;
	input [2:0] btn;
	wire [3:0] BCD0, BCD1, BCD2, BCD3;
	output [0:6] y0, y1, y2, y3;
	output reg led;
	wire Cout;	
	wire clk;

always@(posedge de0_clk)	
begin
	if(clear)
		led<=0;
	else if (Cout)
		led<=1;
end 

counter c0(de0_clk, clk);


bcdadd d0 (clk, btn, BCD0, BCD1, BCD2, BCD3, Cout, clear);


hexdisplay ss0 (BCD0,y0 );
hexdisplay ss1 (BCD1,y1 );
hexdisplay ss2 (BCD2,y2 );
hexdisplay ss3 (BCD3,y3 );

endmodule


module bcdadd( clk, X, BCD0, BCD1, BCD2, BCD3, Cout, Clear);
	input  Clear, clk;
	input [2:0] X;
	output reg [3:0] BCD0, BCD1, BCD2, BCD3;
	output reg Cout;
		
	always@( posedge clk)
	begin 
		if(Clear==1)
			begin
				BCD0 <= 0;
				BCD1 <= 0;
				BCD2 <= 0;
				BCD3 <= 0;
				Cout<=0;
			end
		else if(Clear==0)
		begin
			if(X==3'b110)
			begin
				if(BCD0==4'b1001)
				begin
					BCD0<=0;
					if(BCD1==4'b1001)
					begin	
						BCD1<=0;
						if(BCD2==4'b1001)
							begin
								BCD2<=0;
								BCD3<=4'b0001;
								Cout<=1;
							end
						else
							BCD2<=BCD2+1;
					end
					else
						BCD1<=BCD1+1;
				end
				else
					BCD0<=BCD0+1;
			end

			else if (X==3'b101)
			begin
				if(BCD1==4'b1001)
					begin	
						BCD1<=0;
					if(BCD2==4'b1001)
						begin
							BCD2<=0;
							BCD3<=4'b0001;
							Cout<=1;
						end
						else
							BCD2<=BCD2+1;
					end
				else	
					BCD1=BCD1+1;
			end
			else if (X==3'b011)
			begin
				if(BCD2==4'b1001)
				begin
					BCD2<=0;
					BCD3<=4'b0001;
					Cout<=1;
				end
				else
					BCD2<=BCD2+1;
			end
		end
	end
endmodule
	
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
		endcase
	end
	
endmodule	
	
		
	 
module counter (de0_clk, clk);
 input de0_clk;
 reg [25:0] q;
 output reg clk;
 always@(posedge de0_clk)
 begin
 q=q+1'b1;
 clk=&q;
 end
 endmodule
