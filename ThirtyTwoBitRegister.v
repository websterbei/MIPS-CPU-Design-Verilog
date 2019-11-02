module ThirtyTwoBitRegister(d, clk, en, clr, q);
   
   //Inputs
   input clk, en, clr;
	input [31:0] d;
	output [31:0] q;
	
	genvar i;
	generate
	for (i=0; i<32; i=i+1)
	begin: register
		dffe_ref dff(q[i], d[i], clk, en, clr);
	end
	endgenerate
endmodule