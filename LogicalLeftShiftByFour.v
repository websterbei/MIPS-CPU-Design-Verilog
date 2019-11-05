module LogicalLeftShiftByFour(A, OUT);
input [31:0] A;
output [31:0] OUT;
assign OUT[31:4] = A[27:0];
assign OUT[3:0] = {1'b0,1'b0,1'b0,1'b0};
endmodule 