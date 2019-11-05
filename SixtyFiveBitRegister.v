module SixtyFiveBitRegister(d, clk, en, clr, q);
   
   //Inputs
   input clk, en, clr;
	input [64:0] d;
	output [64:0] q;
	
	genvar i;
	generate
	for (i=0; i<65; i=i+1)
	begin: register
		dflipflop dff(d[i], clk, ~clr, 1'b0, en, q[i]);
	end
	endgenerate
endmodule
