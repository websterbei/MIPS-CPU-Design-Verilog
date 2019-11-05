module ThirtyTwoBitDivide2(A,B,do_div,clk, value_ready, exception, out);
	input [31:0] A, B;
	input clk, do_div;
	output value_ready, exception;
	output [31:0] out;
	
	wire [31:0] read_M, M;
	wire [63:0] read_AQ, AQ, next_AQ;
	wire [32:0] read_cycle, next_cycle;
	wire [32:0] cycle;
	
	assign cycle = do_div ? 33'b100000000000000000000000000000000 : read_cycle;
	assign next_cycle = cycle >> 1;
	ThirtyThreeBitRegister counter(next_cycle, clk, 1'b1, 1'b0, read_cycle);
	
	assign AQ = do_div ? {32'd0, A} : read_AQ;
	assign M = do_div ? B : read_M;
	
	wire [63:0] shifted_AQ = AQ << 1;
	wire overflow1, overflow2;
	wire [31:0] AMM;
	wire [31:0] APM;
	ThirtyTwoBitAdder adder0(shifted_AQ[63:32], ~M, 1'b1, AMM, overflow1);
	ThirtyTwoBitAdder adder1(shifted_AQ[63:32], M, 1'b0, APM, overflow2);
	wire [31:0] next_A = AQ[63] ? APM : AMM;
	wire [31:0] next_Q = next_A[31] ? {shifted_AQ[31:1], 1'b0} : {shifted_AQ[31:1], 1'b1};
	
	assign next_AQ = {next_A, next_Q};
	
	SixtyFourBitRegister REG_AQ(next_AQ, clk, 1'b1, 1'b0, read_AQ);
	ThirtyTwoBitRegister REG_M(M, clk, do_div, 1'b0, read_M);
	assign out = AQ[31:0];
	assign value_ready = cycle[0] == 1'b1;
	assign exception = (M == 32'd0) & value_ready;
endmodule 