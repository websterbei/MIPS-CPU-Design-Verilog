module ThirtyTwoBitDivide(A,B,do_div,clk, value_ready, exception, out, operandA, operandB, im_A, im_B, pos_A, pos_B);
	input [31:0] A, B;
	input clk, do_div;
	output value_ready, exception;
	output [31:0] out;
	
	output [31:0] operandA, operandB;
	
	output [31:0] im_A, im_B, pos_A, pos_B;
	wire overflow_A, overflow_B;
	
	ThirtyTwoBitAdder adder_posA(A, 32'hffffffff, 1'b0, im_A, overflow_A);
	ThirtyTwoBitAdder adder_posB(B, 32'hffffffff, 1'b0, im_B, overflow_B);
	
	ThirtyTwoBitTSB tsb_op_A1(~im_A, pos_A, A[31]);
	ThirtyTwoBitTSB tsb_op_A2(A, pos_A, ~A[31]);
	ThirtyTwoBitTSB tsb_op_B1(~im_B, pos_B, B[31]);
	ThirtyTwoBitTSB tsb_op_B2(B, pos_B, ~B[31]);
//	assign pos_A = A[31] ? ~im_A : A;
//	assign pos_B = B[31] ? ~im_B : B;
	
	ThirtyTwoBitRegisterMultdiv REG_A(pos_A, clk, do_div, 1'b0, operandA);
	ThirtyTwoBitRegisterMultdiv REG_B(pos_B, clk, do_div, 1'b0, operandB);
	
	wire [31:0] M;
	wire [63:0] read_AQ, AQ, next_AQ;
	wire [33:0] read_cycle, next_cycle;
	wire [33:0] cycle;
	
	wire read_flip_sign;
	wire flip_sign = do_div ? A[31] ^ B[31] : read_flip_sign;
	wire next_flip_sign = flip_sign;
	dflipflop REG_flip_sign(next_flip_sign, clk, 1'b1, 1'b0, 1'b1, read_flip_sign);
	
	ThirtyFourBitTSB tsb_c1(34'b1000000000000000000000000000000000, cycle, do_div);
	ThirtyFourBitTSB tsb_c2(read_cycle, cycle, ~do_div);
//	assign cycle = do_div ? 34'b1000000000000000000000000000000000 : read_cycle;
	assign next_cycle = cycle >> 1;
	ThirtyFourBitRegister counter(next_cycle, clk, 1'b1, 1'b0, read_cycle);
	
	wire first_cycle = read_cycle[32];
	
	SixtyFourBitTSB tsb1({32'd0, operandA}, AQ, first_cycle);
	SixtyFourBitTSB tsb2(read_AQ, AQ, ~first_cycle);
//	assign AQ = do_div ? {32'd0, pos_A} : read_AQ;
//	ThirtyTwoBitTSB tsb3(operandB, M, first_cycle);
//	ThirtyTwoBitTSB tsb4(read_M, M, ~first_cycle);
	assign M = operandB;
	
	wire [63:0] shifted_AQ = AQ << 1;
	wire overflow;
	wire [31:0] A_M;
	ThirtyTwoBitAdder adder0(shifted_AQ[63:32], ~M, 1'b1, A_M, overflow);
//	wire [31:0] next_A = A_M[31] ? shifted_AQ[63:32] : A_M;
//	wire [31:0] next_Q = A_M[31] ? {shifted_AQ[31:1], 1'b0} : {shifted_AQ[31:1], 1'b1};
	
	
	SixtyFourBitTSB tsb5({shifted_AQ[63:32], shifted_AQ[31:1], 1'b0}, next_AQ, A_M[31]);
	SixtyFourBitTSB tsb6({A_M, shifted_AQ[31:1], 1'b1}, next_AQ, ~A_M[31]);
//	assign next_AQ = A_M[31] ? {shifted_AQ[63:32], shifted_AQ[31:1], 1'b0} : {A_M, shifted_AQ[31:1], 1'b1};
//	assign next_M = M;
	SixtyFourBitRegister REG_AQ(next_AQ, clk, 1'b1, 1'b0, read_AQ);
//	ThirtyTwoBitRegisterMultdiv REG_M(next_M, clk, 1'b1, 1'b0, read_M);
	wire [31:0] res = AQ[31:0];
	wire [31:0] neg_res;
	wire overflow2;
	ThirtyTwoBitAdder adder1(~res, 32'd0, 1'b1, neg_res, overflow2);
	
	ThirtyTwoBitTSB tsb7(neg_res, out, flip_sign);
	ThirtyTwoBitTSB tsb8(res, out, ~flip_sign);
	
//	assign out = flip_sign ? neg_res : res;
	assign value_ready = cycle[0] == 1'b1;
	assign exception = (M == 32'd0) & value_ready;
endmodule 