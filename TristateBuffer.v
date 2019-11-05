module TristateBuffer(a,b,enable);
	input [31:0] a;
	output [31:0] b;
	input enable;
	
	assign b = enable ? a : 32'bz;
endmodule 