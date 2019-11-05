module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
input [31:0] data_operandA, data_operandB;
input [4:0] ctrl_ALUopcode, ctrl_shiftamt;
output [31:0] data_result;
output isNotEqual, isLessThan, overflow;

wire isAdd, isSubtract, isAnd, isOr, isSll, isSra;

// Inverting all the control bits
wire [4:0] inverse_ctrl_ALUopcode;
not not0(inverse_ctrl_ALUopcode[0], ctrl_ALUopcode[0]);
not not1(inverse_ctrl_ALUopcode[1], ctrl_ALUopcode[1]);
not not2(inverse_ctrl_ALUopcode[2], ctrl_ALUopcode[2]);
not not3(inverse_ctrl_ALUopcode[3], ctrl_ALUopcode[3]);
not not4(inverse_ctrl_ALUopcode[4], ctrl_ALUopcode[4]);

// Determine operation type
and and0(isAdd, inverse_ctrl_ALUopcode[2], inverse_ctrl_ALUopcode[1], inverse_ctrl_ALUopcode[0]);
and and1(isSubtract, inverse_ctrl_ALUopcode[2], inverse_ctrl_ALUopcode[1], ctrl_ALUopcode[0]);
and and2(isAnd, inverse_ctrl_ALUopcode[2], inverse_ctrl_ALUopcode[0], ctrl_ALUopcode[1]);
and and3(isOr, inverse_ctrl_ALUopcode[2], ctrl_ALUopcode[1], ctrl_ALUopcode[0]);
and and4(isSll, ctrl_ALUopcode[2], inverse_ctrl_ALUopcode[1], inverse_ctrl_ALUopcode[0]);
and and5(isSra, ctrl_ALUopcode[2], ctrl_ALUopcode[0], inverse_ctrl_ALUopcode[1]);


// ADD / SUBTRACT result
wire cin;
assign cin = isSubtract ? 1'b1 : 1'b0;
// Inverting operand B
wire [31:0] add_subtract_result, inverse_data_operandB, actual_data_operandB;
not not5(inverse_data_operandB[0], data_operandB[0]);
not not6(inverse_data_operandB[1], data_operandB[1]);
not not7(inverse_data_operandB[2], data_operandB[2]);
not not8(inverse_data_operandB[3], data_operandB[3]);
not not9(inverse_data_operandB[4], data_operandB[4]);
not not10(inverse_data_operandB[5], data_operandB[5]);
not not11(inverse_data_operandB[6], data_operandB[6]);
not not12(inverse_data_operandB[7], data_operandB[7]);
not not13(inverse_data_operandB[8], data_operandB[8]);
not not14(inverse_data_operandB[9], data_operandB[9]);
not not15(inverse_data_operandB[10], data_operandB[10]);
not not16(inverse_data_operandB[11], data_operandB[11]);
not not17(inverse_data_operandB[12], data_operandB[12]);
not not18(inverse_data_operandB[13], data_operandB[13]);
not not19(inverse_data_operandB[14], data_operandB[14]);
not not20(inverse_data_operandB[15], data_operandB[15]);
not not21(inverse_data_operandB[16], data_operandB[16]);
not not22(inverse_data_operandB[17], data_operandB[17]);
not not23(inverse_data_operandB[18], data_operandB[18]);
not not24(inverse_data_operandB[19], data_operandB[19]);
not not25(inverse_data_operandB[20], data_operandB[20]);
not not26(inverse_data_operandB[21], data_operandB[21]);
not not27(inverse_data_operandB[22], data_operandB[22]);
not not28(inverse_data_operandB[23], data_operandB[23]);
not not29(inverse_data_operandB[24], data_operandB[24]);
not not30(inverse_data_operandB[25], data_operandB[25]);
not not31(inverse_data_operandB[26], data_operandB[26]);
not not32(inverse_data_operandB[27], data_operandB[27]);
not not33(inverse_data_operandB[28], data_operandB[28]);
not not34(inverse_data_operandB[29], data_operandB[29]);
not not35(inverse_data_operandB[30], data_operandB[30]);
not not36(inverse_data_operandB[31], data_operandB[31]);
assign actual_data_operandB = isSubtract ? inverse_data_operandB : data_operandB;
ThirtyTwoBitAdder adder0(data_operandA, actual_data_operandB, cin, add_subtract_result, overflow);

wire [31:0] sameDigit;
xnor xnor0(sameDigit[0],data_operandA[0],data_operandB[0]);
xnor xnor1(sameDigit[1],data_operandA[1],data_operandB[1]);
xnor xnor2(sameDigit[2],data_operandA[2],data_operandB[2]);
xnor xnor3(sameDigit[3],data_operandA[3],data_operandB[3]);
xnor xnor4(sameDigit[4],data_operandA[4],data_operandB[4]);
xnor xnor5(sameDigit[5],data_operandA[5],data_operandB[5]);
xnor xnor6(sameDigit[6],data_operandA[6],data_operandB[6]);
xnor xnor7(sameDigit[7],data_operandA[7],data_operandB[7]);
xnor xnor8(sameDigit[8],data_operandA[8],data_operandB[8]);
xnor xnor9(sameDigit[9],data_operandA[9],data_operandB[9]);
xnor xnor10(sameDigit[10],data_operandA[10],data_operandB[10]);
xnor xnor11(sameDigit[11],data_operandA[11],data_operandB[11]);
xnor xnor12(sameDigit[12],data_operandA[12],data_operandB[12]);
xnor xnor13(sameDigit[13],data_operandA[13],data_operandB[13]);
xnor xnor14(sameDigit[14],data_operandA[14],data_operandB[14]);
xnor xnor15(sameDigit[15],data_operandA[15],data_operandB[15]);
xnor xnor16(sameDigit[16],data_operandA[16],data_operandB[16]);
xnor xnor17(sameDigit[17],data_operandA[17],data_operandB[17]);
xnor xnor18(sameDigit[18],data_operandA[18],data_operandB[18]);
xnor xnor19(sameDigit[19],data_operandA[19],data_operandB[19]);
xnor xnor20(sameDigit[20],data_operandA[20],data_operandB[20]);
xnor xnor21(sameDigit[21],data_operandA[21],data_operandB[21]);
xnor xnor22(sameDigit[22],data_operandA[22],data_operandB[22]);
xnor xnor23(sameDigit[23],data_operandA[23],data_operandB[23]);
xnor xnor24(sameDigit[24],data_operandA[24],data_operandB[24]);
xnor xnor25(sameDigit[25],data_operandA[25],data_operandB[25]);
xnor xnor26(sameDigit[26],data_operandA[26],data_operandB[26]);
xnor xnor27(sameDigit[27],data_operandA[27],data_operandB[27]);
xnor xnor28(sameDigit[28],data_operandA[28],data_operandB[28]);
xnor xnor29(sameDigit[29],data_operandA[29],data_operandB[29]);
xnor xnor30(sameDigit[30],data_operandA[30],data_operandB[30]);
xnor xnor31(sameDigit[31],data_operandA[31],data_operandB[31]);

// Check if equal
wire isEqual;
and isEqualAnd(isEqual,sameDigit[0],sameDigit[1],sameDigit[2],sameDigit[3],sameDigit[4],sameDigit[5],sameDigit[6],sameDigit[7],sameDigit[8],sameDigit[9],sameDigit[10],sameDigit[11],sameDigit[12],sameDigit[13],sameDigit[14],sameDigit[15],sameDigit[16],sameDigit[17],sameDigit[18],sameDigit[19],sameDigit[20],sameDigit[21],sameDigit[22],sameDigit[23],sameDigit[24],sameDigit[25],sameDigit[26],sameDigit[27],sameDigit[28],sameDigit[29],sameDigit[30],sameDigit[31]);
not isNotEqualNot(isNotEqual, isEqual);

wire isAPos, isBPos;
not aPos(isAPos, data_operandA[31]);
not bPos(isBPos, data_operandB[31]);
wire APosBNeg, ANegBPos;
and posneg0(APosBNeg, isAPos, data_operandB[31]);
and posneg1(ANegBPos, isBPos, data_operandA[31]);

assign isLessThan = ANegBPos ? 1'b1 : APosBNeg ? 1'b0 : add_subtract_result[31];

// AND result
wire [31:0] and_result;
and and6(and_result[0], data_operandA[0], data_operandB[0]);
and and7(and_result[1], data_operandA[1], data_operandB[1]);
and and8(and_result[2], data_operandA[2], data_operandB[2]);
and and9(and_result[3], data_operandA[3], data_operandB[3]);
and and10(and_result[4], data_operandA[4], data_operandB[4]);
and and11(and_result[5], data_operandA[5], data_operandB[5]);
and and12(and_result[6], data_operandA[6], data_operandB[6]);
and and13(and_result[7], data_operandA[7], data_operandB[7]);
and and14(and_result[8], data_operandA[8], data_operandB[8]);
and and15(and_result[9], data_operandA[9], data_operandB[9]);
and and16(and_result[10], data_operandA[10], data_operandB[10]);
and and17(and_result[11], data_operandA[11], data_operandB[11]);
and and18(and_result[12], data_operandA[12], data_operandB[12]);
and and19(and_result[13], data_operandA[13], data_operandB[13]);
and and20(and_result[14], data_operandA[14], data_operandB[14]);
and and21(and_result[15], data_operandA[15], data_operandB[15]);
and and22(and_result[16], data_operandA[16], data_operandB[16]);
and and23(and_result[17], data_operandA[17], data_operandB[17]);
and and24(and_result[18], data_operandA[18], data_operandB[18]);
and and25(and_result[19], data_operandA[19], data_operandB[19]);
and and26(and_result[20], data_operandA[20], data_operandB[20]);
and and27(and_result[21], data_operandA[21], data_operandB[21]);
and and28(and_result[22], data_operandA[22], data_operandB[22]);
and and29(and_result[23], data_operandA[23], data_operandB[23]);
and and30(and_result[24], data_operandA[24], data_operandB[24]);
and and31(and_result[25], data_operandA[25], data_operandB[25]);
and and32(and_result[26], data_operandA[26], data_operandB[26]);
and and33(and_result[27], data_operandA[27], data_operandB[27]);
and and34(and_result[28], data_operandA[28], data_operandB[28]);
and and35(and_result[29], data_operandA[29], data_operandB[29]);
and and36(and_result[30], data_operandA[30], data_operandB[30]);
and and37(and_result[31], data_operandA[31], data_operandB[31]);

// OR result
wire [31:0] or_result;
or or0(or_result[0], data_operandA[0], data_operandB[0]);
or or1(or_result[1], data_operandA[1], data_operandB[1]);
or or2(or_result[2], data_operandA[2], data_operandB[2]);
or or3(or_result[3], data_operandA[3], data_operandB[3]);
or or4(or_result[4], data_operandA[4], data_operandB[4]);
or or5(or_result[5], data_operandA[5], data_operandB[5]);
or or6(or_result[6], data_operandA[6], data_operandB[6]);
or or7(or_result[7], data_operandA[7], data_operandB[7]);
or or8(or_result[8], data_operandA[8], data_operandB[8]);
or or9(or_result[9], data_operandA[9], data_operandB[9]);
or or10(or_result[10], data_operandA[10], data_operandB[10]);
or or11(or_result[11], data_operandA[11], data_operandB[11]);
or or12(or_result[12], data_operandA[12], data_operandB[12]);
or or13(or_result[13], data_operandA[13], data_operandB[13]);
or or14(or_result[14], data_operandA[14], data_operandB[14]);
or or15(or_result[15], data_operandA[15], data_operandB[15]);
or or16(or_result[16], data_operandA[16], data_operandB[16]);
or or17(or_result[17], data_operandA[17], data_operandB[17]);
or or18(or_result[18], data_operandA[18], data_operandB[18]);
or or19(or_result[19], data_operandA[19], data_operandB[19]);
or or20(or_result[20], data_operandA[20], data_operandB[20]);
or or21(or_result[21], data_operandA[21], data_operandB[21]);
or or22(or_result[22], data_operandA[22], data_operandB[22]);
or or23(or_result[23], data_operandA[23], data_operandB[23]);
or or24(or_result[24], data_operandA[24], data_operandB[24]);
or or25(or_result[25], data_operandA[25], data_operandB[25]);
or or26(or_result[26], data_operandA[26], data_operandB[26]);
or or27(or_result[27], data_operandA[27], data_operandB[27]);
or or28(or_result[28], data_operandA[28], data_operandB[28]);
or or29(or_result[29], data_operandA[29], data_operandB[29]);
or or30(or_result[30], data_operandA[30], data_operandB[30]);
or or31(or_result[31], data_operandA[31], data_operandB[31]);

// SLL result
wire [31:0] sll_result;
LogicalLeftShift shiftLeft(data_operandA, ctrl_shiftamt, sll_result);

// SRA result
wire [31:0] sra_result;
ArithmeticRightShift shiftRight(data_operandA,ctrl_shiftamt, sra_result);

// Get final result
assign data_result = isAnd ? and_result : isOr ? or_result : isSll ? sll_result : isSra ? sra_result : add_subtract_result;
endmodule