module SixtyFourBitTSB(a,b,enable);
	input [63:0] a;
	output [63:0] b;
	input enable;
	
	assign b = enable ? a : 64'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
endmodule 