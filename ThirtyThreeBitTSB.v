module ThirtyThreeBitTSB(a,b,enable);
	input [32:0] a;
	output [32:0] b;
	input enable;
	
	assign b = enable ? a : 33'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
endmodule 