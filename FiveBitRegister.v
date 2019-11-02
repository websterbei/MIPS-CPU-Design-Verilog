module FiveBitRegister(d, clk, en, clr, q);
   
   //Inputs
   input clk, en, clr;
	input [4:0] d;
	output [4:0] q;
	
	genvar i;
	generate
	for (i=0; i<5; i=i+1)
	begin: register
		dffe_ref dff(q[i], d[i], clk, en, clr);
	end
	endgenerate
endmodule