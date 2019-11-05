module FiveToThirtyTwoDecoder(binary_input, onehot_output);
	input [4:0] binary_input;
	output [31:0] onehot_output;
	
	wire [4:0] inverse_binary_input;
	
	not not0(inverse_binary_input[0], binary_input[0]);
	not not1(inverse_binary_input[1], binary_input[1]);
	not not2(inverse_binary_input[2], binary_input[2]);
	not not3(inverse_binary_input[3], binary_input[3]);
	not not4(inverse_binary_input[4], binary_input[4]);
	
	and and0(onehot_output[0],inverse_binary_input[0],inverse_binary_input[1],inverse_binary_input[2],inverse_binary_input[3],inverse_binary_input[4]);
	and and1(onehot_output[1],binary_input[0],inverse_binary_input[1],inverse_binary_input[2],inverse_binary_input[3],inverse_binary_input[4]);
	and and2(onehot_output[2],inverse_binary_input[0],binary_input[1],inverse_binary_input[2],inverse_binary_input[3],inverse_binary_input[4]);
	and and3(onehot_output[3],binary_input[0],binary_input[1],inverse_binary_input[2],inverse_binary_input[3],inverse_binary_input[4]);
	and and4(onehot_output[4],inverse_binary_input[0],inverse_binary_input[1],binary_input[2],inverse_binary_input[3],inverse_binary_input[4]);
	and and5(onehot_output[5],binary_input[0],inverse_binary_input[1],binary_input[2],inverse_binary_input[3],inverse_binary_input[4]);
	and and6(onehot_output[6],inverse_binary_input[0],binary_input[1],binary_input[2],inverse_binary_input[3],inverse_binary_input[4]);
	and and7(onehot_output[7],binary_input[0],binary_input[1],binary_input[2],inverse_binary_input[3],inverse_binary_input[4]);
	and and8(onehot_output[8],inverse_binary_input[0],inverse_binary_input[1],inverse_binary_input[2],binary_input[3],inverse_binary_input[4]);
	and and9(onehot_output[9],binary_input[0],inverse_binary_input[1],inverse_binary_input[2],binary_input[3],inverse_binary_input[4]);
	and and10(onehot_output[10],inverse_binary_input[0],binary_input[1],inverse_binary_input[2],binary_input[3],inverse_binary_input[4]);
	and and11(onehot_output[11],binary_input[0],binary_input[1],inverse_binary_input[2],binary_input[3],inverse_binary_input[4]);
	and and12(onehot_output[12],inverse_binary_input[0],inverse_binary_input[1],binary_input[2],binary_input[3],inverse_binary_input[4]);
	and and13(onehot_output[13],binary_input[0],inverse_binary_input[1],binary_input[2],binary_input[3],inverse_binary_input[4]);
	and and14(onehot_output[14],inverse_binary_input[0],binary_input[1],binary_input[2],binary_input[3],inverse_binary_input[4]);
	and and15(onehot_output[15],binary_input[0],binary_input[1],binary_input[2],binary_input[3],inverse_binary_input[4]);
	and and16(onehot_output[16],inverse_binary_input[0],inverse_binary_input[1],inverse_binary_input[2],inverse_binary_input[3],binary_input[4]);
	and and17(onehot_output[17],binary_input[0],inverse_binary_input[1],inverse_binary_input[2],inverse_binary_input[3],binary_input[4]);
	and and18(onehot_output[18],inverse_binary_input[0],binary_input[1],inverse_binary_input[2],inverse_binary_input[3],binary_input[4]);
	and and19(onehot_output[19],binary_input[0],binary_input[1],inverse_binary_input[2],inverse_binary_input[3],binary_input[4]);
	and and20(onehot_output[20],inverse_binary_input[0],inverse_binary_input[1],binary_input[2],inverse_binary_input[3],binary_input[4]);
	and and21(onehot_output[21],binary_input[0],inverse_binary_input[1],binary_input[2],inverse_binary_input[3],binary_input[4]);
	and and22(onehot_output[22],inverse_binary_input[0],binary_input[1],binary_input[2],inverse_binary_input[3],binary_input[4]);
	and and23(onehot_output[23],binary_input[0],binary_input[1],binary_input[2],inverse_binary_input[3],binary_input[4]);
	and and24(onehot_output[24],inverse_binary_input[0],inverse_binary_input[1],inverse_binary_input[2],binary_input[3],binary_input[4]);
	and and25(onehot_output[25],binary_input[0],inverse_binary_input[1],inverse_binary_input[2],binary_input[3],binary_input[4]);
	and and26(onehot_output[26],inverse_binary_input[0],binary_input[1],inverse_binary_input[2],binary_input[3],binary_input[4]);
	and and27(onehot_output[27],binary_input[0],binary_input[1],inverse_binary_input[2],binary_input[3],binary_input[4]);
	and and28(onehot_output[28],inverse_binary_input[0],inverse_binary_input[1],binary_input[2],binary_input[3],binary_input[4]);
	and and29(onehot_output[29],binary_input[0],inverse_binary_input[1],binary_input[2],binary_input[3],binary_input[4]);
	and and30(onehot_output[30],inverse_binary_input[0],binary_input[1],binary_input[2],binary_input[3],binary_input[4]);
	and and31(onehot_output[31],binary_input[0],binary_input[1],binary_input[2],binary_input[3],binary_input[4]);
endmodule 