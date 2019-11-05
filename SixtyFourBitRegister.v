module SixtyFourBitRegister(d, clk, en, clr, q);
   
   //Inputs
   input clk, en, clr;
	input [63:0] d;
	output [63:0] q;
	
	genvar i;
	generate
	for (i=0; i<64; i=i+1)
	begin: register
		dflipflop dff(d[i], clk, ~clr, 1'b0, en, q[i]);
	end
	endgenerate
endmodule
