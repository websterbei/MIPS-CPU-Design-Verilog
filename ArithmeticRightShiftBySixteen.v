module ArithmeticRightShiftBySixteen(A, OUT);
input [31:0] A;
output [31:0] OUT;
assign OUT[15:0] = A[31:16];
assign OUT[31:16] = {A[31],A[31],A[31],A[31],A[31],A[31],A[31],A[31],A[31],A[31],A[31],A[31],A[31],A[31],A[31],A[31]};
endmodule 