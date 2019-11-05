module regfile (
    clock,
    ctrl_writeEnable,
    ctrl_reset, ctrl_writeReg,
    ctrl_readRegA, ctrl_readRegB, data_writeReg,
    data_readRegA, data_readRegB
);

   input clock, ctrl_writeEnable, ctrl_reset;
   input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
   input [31:0] data_writeReg;

   output [31:0] data_readRegA, data_readRegB;

	wire [31:0] onehot_writeReg, onehot_readRegA, onehot_readRegB;
	FiveToThirtyTwoDecoder write_decoder(ctrl_writeReg, onehot_writeReg);
	FiveToThirtyTwoDecoder read_decoderA(ctrl_readRegA, onehot_readRegA);
	FiveToThirtyTwoDecoder read_decoderB(ctrl_readRegB, onehot_readRegB);
	
	wire [31:0] data_out_reg0,data_out_reg1,data_out_reg2,data_out_reg3,data_out_reg4,data_out_reg5,data_out_reg6,data_out_reg7,data_out_reg8,data_out_reg9,data_out_reg10,data_out_reg11,data_out_reg12,data_out_reg13,data_out_reg14,data_out_reg15,data_out_reg16,data_out_reg17,data_out_reg18,data_out_reg19,data_out_reg20,data_out_reg21,data_out_reg22,data_out_reg23,data_out_reg24,data_out_reg25,data_out_reg26,data_out_reg27,data_out_reg28,data_out_reg29,data_out_reg30,data_out_reg31;
	
	wire [31:0] write_Enable;
	
	and and0(write_Enable[0],onehot_writeReg[0],ctrl_writeEnable);
	RegisterZero register0(data_writeReg, clock, write_Enable[0], ctrl_reset, data_out_reg0);
	and and1(write_Enable[1],onehot_writeReg[1],ctrl_writeEnable);
	Register register1(data_writeReg, clock, write_Enable[1], ctrl_reset, data_out_reg1);
	and and2(write_Enable[2],onehot_writeReg[2],ctrl_writeEnable);
	Register register2(data_writeReg, clock, write_Enable[2], ctrl_reset, data_out_reg2);
	and and3(write_Enable[3],onehot_writeReg[3],ctrl_writeEnable);
	Register register3(data_writeReg, clock, write_Enable[3], ctrl_reset, data_out_reg3);
	and and4(write_Enable[4],onehot_writeReg[4],ctrl_writeEnable);
	Register register4(data_writeReg, clock, write_Enable[4], ctrl_reset, data_out_reg4);
	and and5(write_Enable[5],onehot_writeReg[5],ctrl_writeEnable);
	Register register5(data_writeReg, clock, write_Enable[5], ctrl_reset, data_out_reg5);
	and and6(write_Enable[6],onehot_writeReg[6],ctrl_writeEnable);
	Register register6(data_writeReg, clock, write_Enable[6], ctrl_reset, data_out_reg6);
	and and7(write_Enable[7],onehot_writeReg[7],ctrl_writeEnable);
	Register register7(data_writeReg, clock, write_Enable[7], ctrl_reset, data_out_reg7);
	and and8(write_Enable[8],onehot_writeReg[8],ctrl_writeEnable);
	Register register8(data_writeReg, clock, write_Enable[8], ctrl_reset, data_out_reg8);
	and and9(write_Enable[9],onehot_writeReg[9],ctrl_writeEnable);
	Register register9(data_writeReg, clock, write_Enable[9], ctrl_reset, data_out_reg9);
	and and10(write_Enable[10],onehot_writeReg[10],ctrl_writeEnable);
	Register register10(data_writeReg, clock, write_Enable[10], ctrl_reset, data_out_reg10);
	and and11(write_Enable[11],onehot_writeReg[11],ctrl_writeEnable);
	Register register11(data_writeReg, clock, write_Enable[11], ctrl_reset, data_out_reg11);
	and and12(write_Enable[12],onehot_writeReg[12],ctrl_writeEnable);
	Register register12(data_writeReg, clock, write_Enable[12], ctrl_reset, data_out_reg12);
	and and13(write_Enable[13],onehot_writeReg[13],ctrl_writeEnable);
	Register register13(data_writeReg, clock, write_Enable[13], ctrl_reset, data_out_reg13);
	and and14(write_Enable[14],onehot_writeReg[14],ctrl_writeEnable);
	Register register14(data_writeReg, clock, write_Enable[14], ctrl_reset, data_out_reg14);
	and and15(write_Enable[15],onehot_writeReg[15],ctrl_writeEnable);
	Register register15(data_writeReg, clock, write_Enable[15], ctrl_reset, data_out_reg15);
	and and16(write_Enable[16],onehot_writeReg[16],ctrl_writeEnable);
	Register register16(data_writeReg, clock, write_Enable[16], ctrl_reset, data_out_reg16);
	and and17(write_Enable[17],onehot_writeReg[17],ctrl_writeEnable);
	Register register17(data_writeReg, clock, write_Enable[17], ctrl_reset, data_out_reg17);
	and and18(write_Enable[18],onehot_writeReg[18],ctrl_writeEnable);
	Register register18(data_writeReg, clock, write_Enable[18], ctrl_reset, data_out_reg18);
	and and19(write_Enable[19],onehot_writeReg[19],ctrl_writeEnable);
	Register register19(data_writeReg, clock, write_Enable[19], ctrl_reset, data_out_reg19);
	and and20(write_Enable[20],onehot_writeReg[20],ctrl_writeEnable);
	Register register20(data_writeReg, clock, write_Enable[20], ctrl_reset, data_out_reg20);
	and and21(write_Enable[21],onehot_writeReg[21],ctrl_writeEnable);
	Register register21(data_writeReg, clock, write_Enable[21], ctrl_reset, data_out_reg21);
	and and22(write_Enable[22],onehot_writeReg[22],ctrl_writeEnable);
	Register register22(data_writeReg, clock, write_Enable[22], ctrl_reset, data_out_reg22);
	and and23(write_Enable[23],onehot_writeReg[23],ctrl_writeEnable);
	Register register23(data_writeReg, clock, write_Enable[23], ctrl_reset, data_out_reg23);
	and and24(write_Enable[24],onehot_writeReg[24],ctrl_writeEnable);
	Register register24(data_writeReg, clock, write_Enable[24], ctrl_reset, data_out_reg24);
	and and25(write_Enable[25],onehot_writeReg[25],ctrl_writeEnable);
	Register register25(data_writeReg, clock, write_Enable[25], ctrl_reset, data_out_reg25);
	and and26(write_Enable[26],onehot_writeReg[26],ctrl_writeEnable);
	Register register26(data_writeReg, clock, write_Enable[26], ctrl_reset, data_out_reg26);
	and and27(write_Enable[27],onehot_writeReg[27],ctrl_writeEnable);
	Register register27(data_writeReg, clock, write_Enable[27], ctrl_reset, data_out_reg27);
	and and28(write_Enable[28],onehot_writeReg[28],ctrl_writeEnable);
	Register register28(data_writeReg, clock, write_Enable[28], ctrl_reset, data_out_reg28);
	and and29(write_Enable[29],onehot_writeReg[29],ctrl_writeEnable);
	Register register29(data_writeReg, clock, write_Enable[29], ctrl_reset, data_out_reg29);
	and and30(write_Enable[30],onehot_writeReg[30],ctrl_writeEnable);
	Register register30(data_writeReg, clock, write_Enable[30], ctrl_reset, data_out_reg30);
	and and31(write_Enable[31],onehot_writeReg[31],ctrl_writeEnable);
	Register register31(data_writeReg, clock, write_Enable[31], ctrl_reset, data_out_reg31);
	
		TristateBuffer tsbA0(data_out_reg0,data_readRegA,onehot_readRegA[0]);
	TristateBuffer tsbA1(data_out_reg1,data_readRegA,onehot_readRegA[1]);
	TristateBuffer tsbA2(data_out_reg2,data_readRegA,onehot_readRegA[2]);
	TristateBuffer tsbA3(data_out_reg3,data_readRegA,onehot_readRegA[3]);
	TristateBuffer tsbA4(data_out_reg4,data_readRegA,onehot_readRegA[4]);
	TristateBuffer tsbA5(data_out_reg5,data_readRegA,onehot_readRegA[5]);
	TristateBuffer tsbA6(data_out_reg6,data_readRegA,onehot_readRegA[6]);
	TristateBuffer tsbA7(data_out_reg7,data_readRegA,onehot_readRegA[7]);
	TristateBuffer tsbA8(data_out_reg8,data_readRegA,onehot_readRegA[8]);
	TristateBuffer tsbA9(data_out_reg9,data_readRegA,onehot_readRegA[9]);
	TristateBuffer tsbA10(data_out_reg10,data_readRegA,onehot_readRegA[10]);
	TristateBuffer tsbA11(data_out_reg11,data_readRegA,onehot_readRegA[11]);
	TristateBuffer tsbA12(data_out_reg12,data_readRegA,onehot_readRegA[12]);
	TristateBuffer tsbA13(data_out_reg13,data_readRegA,onehot_readRegA[13]);
	TristateBuffer tsbA14(data_out_reg14,data_readRegA,onehot_readRegA[14]);
	TristateBuffer tsbA15(data_out_reg15,data_readRegA,onehot_readRegA[15]);
	TristateBuffer tsbA16(data_out_reg16,data_readRegA,onehot_readRegA[16]);
	TristateBuffer tsbA17(data_out_reg17,data_readRegA,onehot_readRegA[17]);
	TristateBuffer tsbA18(data_out_reg18,data_readRegA,onehot_readRegA[18]);
	TristateBuffer tsbA19(data_out_reg19,data_readRegA,onehot_readRegA[19]);
	TristateBuffer tsbA20(data_out_reg20,data_readRegA,onehot_readRegA[20]);
	TristateBuffer tsbA21(data_out_reg21,data_readRegA,onehot_readRegA[21]);
	TristateBuffer tsbA22(data_out_reg22,data_readRegA,onehot_readRegA[22]);
	TristateBuffer tsbA23(data_out_reg23,data_readRegA,onehot_readRegA[23]);
	TristateBuffer tsbA24(data_out_reg24,data_readRegA,onehot_readRegA[24]);
	TristateBuffer tsbA25(data_out_reg25,data_readRegA,onehot_readRegA[25]);
	TristateBuffer tsbA26(data_out_reg26,data_readRegA,onehot_readRegA[26]);
	TristateBuffer tsbA27(data_out_reg27,data_readRegA,onehot_readRegA[27]);
	TristateBuffer tsbA28(data_out_reg28,data_readRegA,onehot_readRegA[28]);
	TristateBuffer tsbA29(data_out_reg29,data_readRegA,onehot_readRegA[29]);
	TristateBuffer tsbA30(data_out_reg30,data_readRegA,onehot_readRegA[30]);
	TristateBuffer tsbA31(data_out_reg31,data_readRegA,onehot_readRegA[31]);
	
	TristateBuffer tsbB0(data_out_reg0,data_readRegB,onehot_readRegB[0]);
	TristateBuffer tsbB1(data_out_reg1,data_readRegB,onehot_readRegB[1]);
	TristateBuffer tsbB2(data_out_reg2,data_readRegB,onehot_readRegB[2]);
	TristateBuffer tsbB3(data_out_reg3,data_readRegB,onehot_readRegB[3]);
	TristateBuffer tsbB4(data_out_reg4,data_readRegB,onehot_readRegB[4]);
	TristateBuffer tsbB5(data_out_reg5,data_readRegB,onehot_readRegB[5]);
	TristateBuffer tsbB6(data_out_reg6,data_readRegB,onehot_readRegB[6]);
	TristateBuffer tsbB7(data_out_reg7,data_readRegB,onehot_readRegB[7]);
	TristateBuffer tsbB8(data_out_reg8,data_readRegB,onehot_readRegB[8]);
	TristateBuffer tsbB9(data_out_reg9,data_readRegB,onehot_readRegB[9]);
	TristateBuffer tsbB10(data_out_reg10,data_readRegB,onehot_readRegB[10]);
	TristateBuffer tsbB11(data_out_reg11,data_readRegB,onehot_readRegB[11]);
	TristateBuffer tsbB12(data_out_reg12,data_readRegB,onehot_readRegB[12]);
	TristateBuffer tsbB13(data_out_reg13,data_readRegB,onehot_readRegB[13]);
	TristateBuffer tsbB14(data_out_reg14,data_readRegB,onehot_readRegB[14]);
	TristateBuffer tsbB15(data_out_reg15,data_readRegB,onehot_readRegB[15]);
	TristateBuffer tsbB16(data_out_reg16,data_readRegB,onehot_readRegB[16]);
	TristateBuffer tsbB17(data_out_reg17,data_readRegB,onehot_readRegB[17]);
	TristateBuffer tsbB18(data_out_reg18,data_readRegB,onehot_readRegB[18]);
	TristateBuffer tsbB19(data_out_reg19,data_readRegB,onehot_readRegB[19]);
	TristateBuffer tsbB20(data_out_reg20,data_readRegB,onehot_readRegB[20]);
	TristateBuffer tsbB21(data_out_reg21,data_readRegB,onehot_readRegB[21]);
	TristateBuffer tsbB22(data_out_reg22,data_readRegB,onehot_readRegB[22]);
	TristateBuffer tsbB23(data_out_reg23,data_readRegB,onehot_readRegB[23]);
	TristateBuffer tsbB24(data_out_reg24,data_readRegB,onehot_readRegB[24]);
	TristateBuffer tsbB25(data_out_reg25,data_readRegB,onehot_readRegB[25]);
	TristateBuffer tsbB26(data_out_reg26,data_readRegB,onehot_readRegB[26]);
	TristateBuffer tsbB27(data_out_reg27,data_readRegB,onehot_readRegB[27]);
	TristateBuffer tsbB28(data_out_reg28,data_readRegB,onehot_readRegB[28]);
	TristateBuffer tsbB29(data_out_reg29,data_readRegB,onehot_readRegB[29]);
	TristateBuffer tsbB30(data_out_reg30,data_readRegB,onehot_readRegB[30]);
	TristateBuffer tsbB31(data_out_reg31,data_readRegB,onehot_readRegB[31]);
endmodule
