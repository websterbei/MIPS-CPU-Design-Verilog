module ThirtyTwoBitMultiply3(A,B,do_mul,clk,value_ready, exception, out, result);
	input  [31:0] A,B;
	input  clk, do_mul;
	output [31:0] out;
	output value_ready, exception;
	
	wire [31:0] read_multiplicand;
	wire [31:0] read_multiplier, next_multiplier;
	wire [63:0] read_result, next_result;
	wire [33:0] read_cycle, next_cycle;
	wire [33:0] cycle;
	wire [31:0] multiplicand;
	wire [31:0] multiplier;
	output [63:0] result;
	
	assign out = result[31:0];
	
	// Setup cycle counter
	ThirtyFourBitTSB tsb_c1(34'b1000000000000000000000000000000000, cycle, do_mul);
	ThirtyFourBitTSB tsb_c2(read_cycle, cycle, ~do_mul);
//	assign cycle = do_mul ? 33'b100000000000000000000000000000000 : read_cycle;
	assign next_cycle = cycle >> 1;
	ThirtyFourBitRegister counter(next_cycle, clk, 1'b1, 1'b0, read_cycle);
	
	wire zeroth_cycle = cycle[33];
	wire first_cycle = cycle[32];
	
	ThirtyTwoBitTSB tsb1(A, multiplicand, zeroth_cycle);
	ThirtyTwoBitTSB tbs2(read_multiplicand, multiplicand, ~zeroth_cycle);
//	assign multiplicand = zeroth_cycle ? A : read_multiplicand;
	
	ThirtyTwoBitTSB tsb3(B, multiplier, zeroth_cycle);
	ThirtyTwoBitTSB tbs4(read_multiplier, multiplier, ~zeroth_cycle);
//	assign multiplier = zeroth_cycle ? B : read_multiplier;

	SixtyFourBitTSB tsb5(64'd0, result, zeroth_cycle);
	SixtyFourBitTSB tbs6(read_result, result, ~zeroth_cycle);
//	assign result = zeroth_cycle ? 64'd0 : read_result;
	
	wire [1:0] booth_code = first_cycle ? {multiplier[0], 1'b0} : multiplier[1:0];
	wire booth_nothing = (booth_code == 2'b00) | (booth_code == 2'b11);
	wire booth_sub = (booth_code == 2'b10);
	
	wire [31:0] add_result;
	
	wire [31:0] operandA = result[63:32];
	wire [31:0] operandB;
	ThirtyTwoBitTSB tsb7(~multiplicand, operandB, booth_sub);
	ThirtyTwoBitTSB tsb8(multiplicand, operandB, ~booth_sub);
//	wire [31:0] operandB = booth_sub ? ~multiplicand : multiplicand;
	wire next_overflow, read_overflow;
	wire overflow;
	
	ThirtyTwoBitAdder adder(operandA, operandB, booth_sub, add_result, overflow);
	assign next_overflow = read_overflow | overflow;
	dflipflop overflow_flip_flop(next_overflow, clk, ~do_mul, 1'b0, 1'b1, read_overflow);

//	wire signed [31:0] operandA = result[63:32];
//	wire signed [31:0] operandB = multiplicand;
//	assign add_result = booth_sub ? operandA-operandB : operandA+operandB;
	
	wire [63:0] new_result;
	SixtyFourBitTSB tsb9(result, new_result, (booth_nothing | zeroth_cycle));
	SixtyFourBitTSB tbs10({add_result, result[31:0]}, new_result, ~(booth_nothing | zeroth_cycle));
//	wire [63:0] new_result = (booth_nothing | zeroth_cycle) ? result : {add_result, result[31:0]};

	SixtyFourBitTSB tsb11(64'd0, next_result, zeroth_cycle);
	SixtyFourBitTSB tbs12({new_result[63], new_result[63:1]}, next_result, ~zeroth_cycle);
//	assign next_result = zeroth_cycle ? 64'd0 : {new_result[63], new_result[63:1]};
	
	ThirtyTwoBitTSB tsb13(multiplier, next_multiplier, (zeroth_cycle | first_cycle));
	ThirtyTwoBitTSB tsb14({multiplier[31], multiplier[31:1]}, next_multiplier, ~(zeroth_cycle | first_cycle));
//	assign next_multiplier = (zeroth_cycle | first_cycle) ? multiplier : {multiplier[31], multiplier[31:1]};
	ThirtyTwoBitRegister currentMultiplicand(multiplicand, clk, do_mul, 1'b0, read_multiplicand);
	ThirtyTwoBitRegister currentMultiplier(next_multiplier, clk, 1'b1, 1'b0, read_multiplier);
	
	SixtyFourBitRegister currentResult(next_result, clk, 1'b1, 1'b0, read_result);
	
	assign value_ready = cycle[0] == 1'b1;
	assign exception = value_ready & (read_overflow | (~((read_result[63:31]==33'b000000000000000000000000000000000) | (read_result[63:31]==33'b111111111111111111111111111111111))));
	
endmodule
	
	