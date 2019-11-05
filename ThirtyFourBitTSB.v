module ThirtyFourBitTSB(a,b,enable);
	input [33:0] a;
	output [33:0] b;
	input enable;
	
	assign b = enable ? a : 34'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
endmodule 