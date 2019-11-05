module multdiv(data_operandA, data_operandB, ctrl_MULT, ctrl_DIV, clock, data_result, data_exception, data_resultRDY);
    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;

	 wire mul_ready, div_ready, mul_exception, div_exception;
	 wire [31:0] mul_result, div_result;
	 
	 wire is_mul, next_is_mul;
	 assign next_is_mul = ctrl_MULT ? 1'b1 : ctrl_DIV ? 1'b0 : is_mul;
	 dflipflop REG_op(next_is_mul, clock, 1'b1, 1'b0, 1'b1, is_mul);
	 
	 ThirtyTwoBitMultiply2 multiply(data_operandA, data_operandB, ctrl_MULT, clock, mul_ready, mul_exception, mul_result);
	 ThirtyTwoBitDivide divide(data_operandA, data_operandB, ctrl_DIV, clock, div_ready, div_exception, div_result);

	 wire latch_resultRDY, latch_exception;
	 wire [31:0] latch_result;
	 assign latch_resultRDY = (mul_ready & is_mul) | (div_ready & ~is_mul);
	 assign latch_exception = (mul_exception | div_exception) & latch_resultRDY;
	 assign latch_result = (mul_ready & is_mul) ? mul_result : (div_ready & ~is_mul)? div_result : 32'd0;
	 
	 ThirtyTwoBitRegisterMultdiv result_latch(latch_result, clock, 1'b1, 1'b0, data_result);
	 dflipflop exception_latch(latch_exception, clock, 1'b1, 1'b0, 1'b1, data_exception);
	 dflipflop ready_latch(latch_resultRDY, clock, 1'b1, 1'b0, 1'b1, data_resultRDY);
	 
//	 assign data_resultRDY = (mul_ready & is_mul) | (div_ready & ~is_mul);
//	 assign data_exception = (mul_exception | div_exception) & data_resultRDY;
//	 assign data_result = (mul_ready & is_mul) ? mul_result : (div_ready & ~is_mul) ? div_result : 32'd0;

//	 ThirtyTwoBitMultiply2 multiply(data_operandA, data_operandB, ctrl_MULT|ctrl_DIV, clock, data_resultRDY, data_exception, data_result);
//	 ThirtyTwoBitDivide divide(data_operandA, data_operandB, ctrl_DIV|ctrl_MULT, clock, data_resultRDY, data_exception, data_result);
endmodule
