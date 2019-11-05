module SixtyFiveBitTSB(a,b,enable);
	input [64:0] a;
	output [64:0] b;
	input enable;
	
	assign b = enable ? a : 65'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
endmodule 