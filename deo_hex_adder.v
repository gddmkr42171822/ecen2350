module deo_hex_adder(X, Y, SevenSX, SevenSY, Sum1, Sum2, SevenSS1, SevenSS2);
    input [3:0] X, Y;
	 output reg [3:0] Sum1, Sum2;
    output reg [6:0] SevenSX, SevenSY, SevenSS1, SevenSS2;

    
	 always @(X)
    begin
      case (X) 
        0: SevenSX = 7'b1000000;
        1: SevenSX = 7'b1111001;
        2: SevenSX = 7'b0100100;
        3: SevenSX = 7'b0110000;
        4: SevenSX = 7'b0011001;
        5: SevenSX = 7'b0010010;
        6: SevenSX = 7'b0000010;
        7: SevenSX = 7'b1111000;
        8: SevenSX = 7'b0000000;
        9: SevenSX = 7'b0010000;
        10: SevenSX = 7'b0001000;//A
        11: SevenSX = 7'b0000011;//B
        12: SevenSX = 7'b1000110;//C
        13: SevenSX = 7'b0100001;//D
        14: SevenSX = 7'b0000110;//E
        15: SevenSX = 7'b0001110;//F
		  default: SevenSX = 7'b1000000;
      endcase
    end
	 
	 
	 always @(Y)
    begin
      case (Y) 
        0: SevenSY = 7'b1000000;
        1: SevenSY = 7'b1111001;
        2: SevenSY = 7'b0100100;
        3: SevenSY = 7'b0110000;
        4: SevenSY = 7'b0011001;
        5: SevenSY = 7'b0010010;
        6: SevenSY = 7'b0000010;
        7: SevenSY = 7'b1111000;
        8: SevenSY = 7'b0000000;
        9: SevenSY = 7'b0010000;
        10: SevenSY = 7'b0001000;//A
        11: SevenSY = 7'b0000011;//B
        12: SevenSY = 7'b1000110;//C
        13: SevenSY = 7'b0100001;//D
        14: SevenSY = 7'b0000110;//E
        15: SevenSY = 7'b0001110;//F
		  default: SevenSY = 7'b1000000;
      endcase
    end
	
	always@(Y, X)
	begin
		{Sum2, Sum1} = Y+X;
	end
	
	always @(Sum1)
    begin
      case (Sum1) 
        0: SevenSS1 = 7'b1000000;
        1: SevenSS1 = 7'b1111001;
        2: SevenSS1 = 7'b0100100;
        3: SevenSS1 = 7'b0110000;
        4: SevenSS1 = 7'b0011001;
        5: SevenSS1 = 7'b0010010;
        6: SevenSS1 = 7'b0000010;
        7: SevenSS1 = 7'b1111000;
        8: SevenSS1 = 7'b0000000;
        9: SevenSS1 = 7'b0010000;
        10: SevenSS1 = 7'b0001000;//A
        11: SevenSS1 = 7'b0000011;//B
        12: SevenSS1 = 7'b1000110;//C
        13: SevenSS1 = 7'b0100001;//D
        14: SevenSS1 = 7'b0000110;//E
        15: SevenSS1 = 7'b0001110;//F
		  default: SevenSS1 = 7'b1000000;
      endcase
    end
	 
	 always @(Sum2)
    begin
      case (Sum2) 
        0: SevenSS2 = 7'b1000000;
        1: SevenSS2 = 7'b1111001;
        2: SevenSS2 = 7'b0100100;
        3: SevenSS2 = 7'b0110000;
        4: SevenSS2 = 7'b0011001;
        5: SevenSS2 = 7'b0010010;
        6: SevenSS2 = 7'b0000010;
        7: SevenSS2 = 7'b1111000;
        8: SevenSS2 = 7'b0000000;
        9: SevenSS2 = 7'b0010000;
        10: SevenSS2 = 7'b0001000;//A
        11: SevenSS2 = 7'b0000011;//B
        12: SevenSS2 = 7'b1000110;//C
        13: SevenSS2 = 7'b0100001;//D
        14: SevenSS2 = 7'b0000110;//E
        15: SevenSS2 = 7'b0001110;//F
		  default: SevenSS2 = 7'b1000000;
      endcase
    end
	 

	 
endmodule

