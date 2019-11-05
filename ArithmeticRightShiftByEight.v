module ArithmeticRightShiftByEight(A, OUT);
input [31:0] A;
output [31:0] OUT;
assign OUT[23:0] = A[31:8];
assign OUT[31:24] = {A[31],A[31],A[31],A[31],A[31],A[31],A[31],A[31]};
endmodule 