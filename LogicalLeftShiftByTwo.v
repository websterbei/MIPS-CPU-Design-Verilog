module LogicalLeftShiftByTwo(A, OUT);
input [31:0] A;
output [31:0] OUT;
assign OUT[31:2] = A[29:0];
assign OUT[1:0] = {1'b0,1'b0};
endmodule 