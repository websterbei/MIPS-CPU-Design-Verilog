module LogicalLeftShiftBySixteen(A, OUT);
input [31:0] A;
output [31:0] OUT;
assign OUT[31:16] = A[15:0];
assign OUT[15:0] = {1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};
endmodule 