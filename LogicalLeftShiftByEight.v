module LogicalLeftShiftByEight(A, OUT);
input [31:0] A;
output [31:0] OUT;
assign OUT[31:8] = A[23:0];
assign OUT[7:0] = {1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
endmodule 