module LogicalLeftShift(A, ShiftAmount, OUT);
	input [31:0] A;
	input [4:0] ShiftAmount;
	output [31:0] OUT;
	wire [31:0] reg0, reg1, reg2, reg3, reg4, regm0, regm1, regm2, regm3;
	
	LogicalLeftShiftBySixteen shift0(A, reg0);
	assign regm0[31:0] = ShiftAmount[4] ? reg0[31:0] : A[31:0];
	
	LogicalLeftShiftByEight shift1(regm0, reg1);
	assign regm1[31:0] = ShiftAmount[3] ? reg1[31:0] : regm0[31:0];
	
	LogicalLeftShiftByFour shift2(regm1, reg2);
	assign regm2[31:0] = ShiftAmount[2] ? reg2[31:0] : regm1[31:0];
	
	LogicalLeftShiftByTwo shift3(regm2, reg3);
	assign regm3[31:0] = ShiftAmount[1] ? reg3[31:0] : regm2[31:0];
	
	LogicalLeftShiftByOne shift4(regm3, reg4);
	assign OUT[31:0] = ShiftAmount[0] ? reg4[31:0] : regm3[31:0];
endmodule 