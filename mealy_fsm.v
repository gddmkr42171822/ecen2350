/* This code is a Mealy FSM that recongnizes the sequence ABBAC 
 * created by pushing buttons on a DE0
*/


/* Module that creates the button pulses */
module flipflop(Button, Clock, Q);
input Button;
input Clock;
reg Q1, Q2, Q3;
output Q;

always@(posedge Clock)
begin
Q1 <= Button;
Q2 <= Q1;
Q3 <= Q2;
end

assign Q = Q2&~Q3;
endmodule

module mealy(Clock, Resetn, Button, z, z0, z1, z2, z3, z4, z5);
input Clock, Resetn;
input [2:0] Button;
output z0, z1, z2, z3, z4, z5;
output reg z;
wire A, B, C;
reg [2:0] y;
reg [2:0] r;
parameter [2:0] S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100, S5 = 3'b101;

initial begin
y <= S0;
end

always@(posedge Clock)
begin
	case(Button)
		3'b011: r = 3'b011;
		3'b101: r = 3'b101;
		3'b110: r = 3'b110;
		default: r = 3'b111;
	endcase
end

/* Button pulses */
flipflop one(r[2], Clock, A);
flipflop two(r[1], Clock, B);
flipflop three(r[0], Clock, C);

/* State transition logic */
always@(posedge Clock or negedge Resetn)
begin
	if(Resetn == 0)
	begin
		y <= S0;
		z <= 0;
	end
	else
		case(y)
			S0:
				if(A)
				begin
					y <= S1;
					z <= 0;
				end
				else if(B||C)
				begin
					y <= S0;
					z <= 0;
				end
			S1:
				if(B)
				begin
					y <= S2;
					z <= 0;
				end
				else if(A)
				begin
					y <= S1;
					z <= 0;
				end
				else if(C)
				begin
					y <= S0;
					z <= 0;
				end
			S2:
				if(B)
				begin	
					y <= S3;
					z <= 0;
				end
				else if(C)
				begin
					y <= S0;
					z <= 0;
				end
				else if(A)
				begin
					y <= S1;
					z <= 0;
				end
			S3:
				if(A)
				begin
					y <= S4;
					z <= 0;
				end
				else if(B||C)
				begin
					y <= S0;
					z <= 0;
				end
			S4:
				if(C)
				begin
					y <= S0;
					z <= 1;
				end
				else if(A)
				begin
					y <= S1;
					z <= 0;
				end
				else if(B)
				begin
					y <= S2;
					z <= 0;
				end
		endcase
end

/* Led outputs for the different states */
assign z0 = (y == S0);
assign z1 = (y == S1);
assign z2 = (y == S2);
assign z3 = (y == S3);
assign z4 = (y == S4);
assign z5 = (y == S5);

endmodule