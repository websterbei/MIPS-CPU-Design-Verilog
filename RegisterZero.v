module RegisterZero(data_in, clk, en, clr, data_out);
	input [31:0] data_in;
	input clk, en, clr;
	output [31:0] data_out;
	
	assign data_out = 32'b0;
endmodule 