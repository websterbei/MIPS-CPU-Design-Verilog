module ThirtyTwoBitMultiply2(A,B,do_mul,clk,value_ready, exception, out, result);
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
	
	assign multiplicand = zeroth_cycle ? A : read_multiplicand;
	assign multiplier = zeroth_cycle ? B : read_multiplier;
	assign result = zeroth_cycle ? 64'd0 : read_result;
	
	wire [1:0] booth_code = first_cycle ? {multiplier[0], 1'b0} : multiplier[1:0];
	wire booth_nothing = (booth_code == 2'b00) | (booth_code == 2'b11);
	wire booth_sub = (booth_code == 2'b10);
	
	wire [31:0] add_result;
	
	wire [31:0] operandA = result[63:32];
	wire [31:0] operandB = booth_sub ? ~multiplicand : multiplicand;
	wire next_overflow, read_overflow;
	wire overflow;
	
	ThirtyTwoBitAdder adder(operandA, operandB, booth_sub, add_result, overflow);
	assign next_overflow = read_overflow | overflow;
	dflipflop overflow_flip_flop(next_overflow, clk, ~do_mul, 1'b0, 1'b1, read_overflow);
	
	wire multiplier_one, read_multiplier_one;
	assign multiplier_one = zeroth_cycle ? multiplier == 32'd1 : read_multiplier_one;
	dflipflop multiplier_one_dff(multiplier_one, clk, 1'b1, 1'b0, 1'b1, read_multiplier_one);

//	wire signed [31:0] operandA = result[63:32];
//	wire signed [31:0] operandB = multiplicand;
//	assign add_result = booth_sub ? operandA-operandB : operandA+operandB;
	
	wire [63:0] new_result = (booth_nothing | zeroth_cycle) ? result : {add_result, result[31:0]};
	assign next_result = zeroth_cycle ? 64'd0 : {new_result[63], new_result[63:1]};
	
	assign next_multiplier = (zeroth_cycle | first_cycle) ? multiplier : {multiplier[31], multiplier[31:1]};
	ThirtyTwoBitRegisterMultdiv currentMultiplicand(multiplicand, clk, do_mul, 1'b0, read_multiplicand);
	ThirtyTwoBitRegisterMultdiv currentMultiplier(next_multiplier, clk, 1'b1, 1'b0, read_multiplier);
	
	SixtyFourBitRegister currentResult(next_result, clk, 1'b1, 1'b0, read_result);
	
	assign value_ready = cycle[0] == 1'b1;
	assign exception = value_ready & (~read_multiplier_one) &(read_overflow | (~((read_result[63:31]==33'b000000000000000000000000000000000) | (read_result[63:31]==33'b111111111111111111111111111111111))));
	
endmodule
	
	