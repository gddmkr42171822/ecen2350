module adder(carryin, X, Y, S, carryout, overflow);
parameter n = 1;
input carryin;
input [n-1:0] X, Y;
output reg [n-1:0] S;
output reg carryout, overflow;

always @(X, Y, carryin)
begin
{carryout, S} = X+Y+carryin;
overflow = (X[n-1]&Y[n-1]&~S[n-1])|(~X[n-1]&~Y[n-1]&S[n-1]);
end
endmodule

module deo2(carryin, X, Y, S, carryout, overflow);
input carryin;
input [1:0] X, Y;
output [1:0] carryout, S, overflow;

adder bit0 (0, X[0], Y[0], S[0],carryout[0], overflow[0]);
adder bit1 (carryout[0], X[1], Y[1], S[1],carryout[1], overflow[1]);
endmodule
