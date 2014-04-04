/* Code that adds bcd digits with by pressing or holding down the pushbuttons on the de0 and outputs it to the 
 * seven seg display
*/

module bcd_assign(de0_clk, clear, led, btn, y0, y1, y2, y3);
	input clear, de0_clk;
	input [2:0] btn;
	reg [3:0] btn0, btn1, btn2; 
	wire[3:0] S0, S1, S2, S3;
	output [0:6] y0, y1, y2, y3;
	output reg led;
	wire Cout0, Cout1, Cout2, Cout3;
	wire clk;

counter c(de0_clk, clk);
	
always@(posedge de0_clk or posedge clear)	
begin
	if(clear==1)
	begin
		led=0;
	end
	else if (Cout2==1)
		led=1;
end

always@(posedge de0_clk or negedge (&btn))
begin
if(&btn == 0)
case(btn)
3'b110:
	begin
		btn0=4'b0001;
		btn1=4'b0000;
		btn2=4'b0000;
	end
3'b101:
	begin
		btn0=4'b0000;
		btn1=4'b0001;
		btn2=4'b0000;
	end
3'b011:
	begin
		btn0=4'b0000;
		btn1=4'b0000;
		btn2=4'b0001;
	end
default:
	begin
		btn0=4'b0000;
		btn1=4'b0000;
		btn2=4'b0000;
	end
endcase
else
begin
	btn0=4'b0000;
	btn1=4'b0000;
	btn2=4'b0000;
end
end
	

bcdadd d0 (clk, 0, btn0, S0, Cout0, clear);
bcdadd d1 (clk, Cout0, btn1, S1, Cout1, clear);
bcdadd d2 (clk,  Cout1, btn2, S2, Cout2, clear);
bcdadd d3 (clk,  Cout2, 4'b0000, S3, Cout3, clear);

hexdisplay ss0 (S0,y0 );
hexdisplay ss1 (S1,y1 );
hexdisplay ss2 (S2,y2 );
hexdisplay ss3 (S3,y3 );

endmodule


module bcdadd( clk, Cin, X, S, Cout, clear);
	input Cin, clear, clk;
	input [3:0] X;
	output reg [3:0] S;
	output reg Cout; 
	reg [4:0] Z;
		
	always@( posedge clk or posedge clear )
	begin 
		if(clear==1)
		{Cout,S}=5'b00000;
		else if (clear==0)
		begin
			Z=S+X+Cin;
			if (Z<10)
			{Cout,S}=Z;
			else	
			{Cout,S}=Z+6;
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

		
	 
module counter (de0_clk, q);
 input de0_clk;
 output reg q;
 reg [24:0] tmp;
 always@(posedge de0_clk)
 begin
	tmp=tmp+1'b1;
	q=&tmp;
 end
 endmodule
