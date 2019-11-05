module LogicalLeftShiftByOne(A, OUT);
input [31:0] A;
output [31:0] OUT;
assign OUT[31:1] = A[30:0];
assign OUT[0] = 1'b0;
endmodule 