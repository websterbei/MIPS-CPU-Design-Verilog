module ArithmeticRightShiftByOne(A, OUT);
input [31:0] A;
output [31:0] OUT;
assign OUT[30:0] = A[31:1];
assign OUT[31] = A[31];
endmodule 