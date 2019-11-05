module ThirtyTwoBitMultiply(A,B,do_mul,clk,value_ready, exception, out, overflow);
	input  [31:0] A,B;
	input  clk, do_mul;
	output [31:0] out;
	output value_ready, exception;
	
	wire [31:0] read_multiplicand, next_multiplicand;
	wire [64:0] read_result, next_result;
	wire [32:0] read_cycle, next_cycle;
	wire [32:0] cycle;
	wire [31:0] multiplicand;
	wire [64:0] result;
	
	assign out = result[32:1];
	
	// Setup cycle counter
	ThirtyThreeBitTSB tsb_c1(33'b100000000000000000000000000000000, cycle, do_mul);
	ThirtyThreeBitTSB tsb_c2(read_cycle, cycle, ~do_mul);
//	assign cycle = do_mul ? 33'b100000000000000000000000000000000 : read_cycle;
	assign next_cycle = cycle >> 1;
	ThirtyThreeBitRegister counter(next_cycle, clk, 1'b1, 1'b0, read_cycle);
	
	
//	SixtyFiveBitTSB tsb1({32'd0, B, 1'b0}, result, do_mul);
//	SixtyFiveBitTSB tbs2(read_result, result, ~do_mul);
	assign result = do_mul ? {32'd0, B, 1'b0} : read_result;
	wire [1:0] booth_code = result[1:0];
	wire booth_nothing = (booth_code == 2'b00) | (booth_code == 2'b11);
	wire booth_sub = (booth_code == 2'b10);
	
	wire [31:0] add_result;
	
//	ThirtyTwoBitTSB tsb3(A, multiplicand, do_mul);
//	ThirtyTwoBitTSB tsb4(read_multiplicand, multiplicand, ~do_mul);
	assign multiplicand = do_mul ? A : read_multiplicand;
	assign next_multiplicand = multiplicand;
	
	wire [31:0] operandA = result[64:33];
//	wire [31:0] operandB;
//	ThirtyTwoBitTSB tsb5(~multiplicand, operandB, booth_sub);
//	ThirtyTwoBitTSB tsb6(multiplicand, operandB, ~booth_sub);
	wire [31:0] operandB = booth_sub ? ~multiplicand : multiplicand;
	wire read_overflow, next_overflow;
	output overflow;
	
	ThirtyTwoBitAdder adder(operandA, operandB, booth_sub, add_result, overflow);
	assign next_overflow = do_mul ? overflow : read_overflow | overflow;
	dflipflop overflow_flip_flop(next_overflow, clk, ~do_mul, 1'b1, 1'b1, read_overflow);
	
//	wire [64:0] new_result;
//	SixtyFiveBitTSB tsb7(result, new_result, booth_nothing);
//	SixtyFiveBitTSB tsb8({add_result, result[32:0]}, new_result, ~booth_nothing);
	wire [64:0] new_result = booth_nothing ? result : {add_result, result[32:0]};
	assign next_result = {new_result[64], new_result[64:1]};
	
	ThirtyTwoBitRegister currentMultiplicand(next_multiplicand, clk, do_mul, 1'b0, read_multiplicand);
	
	SixtyFiveBitRegister currentResult(next_result, clk, 1'b1, 1'b0, read_result);
	
	assign value_ready = cycle[0] == 1'b1;
	assign exception = value_ready & (read_overflow | (~((result[64:32]==33'b000000000000000000000000000000000) | (result[64:32]==33'b111111111111111111111111111111111))));
	
endmodule
	
	