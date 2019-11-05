module ArithmeticRightShiftByFour(A, OUT);
input [31:0] A;
output [31:0] OUT;
assign OUT[27:0] = A[31:4];
assign OUT[31:28] = {A[31],A[31],A[31],A[31]};
endmodule 