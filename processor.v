/**
 * READ THIS DESCRIPTION!
 *
 * The processor takes in several inputs from a skeleton file.
 *
 * Inputs
 * clock: this is the clock for your processor at 50 MHz
 * reset: we should be able to assert a reset to start your pc from 0 (sync or
 * async is fine)
 *
 * Imem: input data from imem
 * Dmem: input data from dmem
 * Regfile: input data from regfile
 *
 * Outputs
 * Imem: output control signals to interface with imem
 * Dmem: output control signals and data to interface with dmem
 * Regfile: output control signals and data to interface with regfile
 *
 * Notes
 *
 * Ultimately, your processor will be tested by subsituting a master skeleton, imem, dmem, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file acts as a small wrapper around your processor for this purpose.
 *
 * You will need to figure out how to instantiate two memory elements, called
 * "syncram," in Quartus: one for imem and one for dmem. Each should take in a
 * 12-bit address and allow for storing a 32-bit value at each address. Each
 * should have a single clock.
 *
 * Each memory element should have a corresponding .mif file that initializes
 * the memory element to certain value on start up. These should be named
 * imem.mif and dmem.mif respectively.
 *
 * Importantly, these .mif files should be placed at the top level, i.e. there
 * should be an imem.mif and a dmem.mif at the same level as process.v. You
 * should figure out how to point your generated imem.v and dmem.v files at
 * these MIF files.
 *
 * imem
 * Inputs:  12-bit address, 1-bit clock enable, and a clock
 * Outputs: 32-bit instruction
 *
 * dmem
 * Inputs:  12-bit address, 1-bit clock, 32-bit data, 1-bit write enable
 * Outputs: 32-bit data at the given address
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for regfile
    ctrl_writeReg,                  // O: Register to write to in regfile
    ctrl_readRegA,                  // O: Register to read from port A of regfile
    ctrl_readRegB,                  // O: Register to read from port B of regfile
    data_writeReg,                  // O: Data to write to for regfile
    data_readRegA,                  // I: Data from port A of regfile
    data_readRegB                   // I: Data from port B of regfile
);
    // Control signals
    input clock, reset;

    // Imem
    output [11:0] address_imem;
    input [31:0] q_imem;

    // Dmem
    output [11:0] address_dmem;
    output [31:0] data;
    output wren;
    input [31:0] q_dmem;

    // Regfile
    output ctrl_writeEnable;
    output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    output [31:0] data_writeReg;
    input [31:0] data_readRegA, data_readRegB;

    /* YOUR CODE STARTS HERE */
	 
	 wire global_stall = multdiv_stall;
	 
	 // PC update
	 wire [31:0] next_PC, current_PC;
	 wire unused_isNotEqual, unused_isLessThan, unused_overflow;
	 alu PC_adder(current_PC, 32'd1, 5'b00000, 5'b00000,
						  next_PC, unused_isNotEqual, unused_isLessThan, unused_overflow);
	 ThirtyTwoBitRegister PC_register(next_PC, clock, ~global_stall, reset, current_PC);
	 assign address_imem = current_PC;
	 
	 // Fetch stage
	 
	 // F/D stage
	 wire [31:0] instruction_at_D;
	 ThirtyTwoBitRegister FD_instruction_Latch(q_imem, clock, ~global_stall, reset, instruction_at_D);
	 
	 // Decode stage
	 wire [4:0] opcode = instruction_at_D[31:27];
	 wire R_type = (opcode == 5'b00000);
	 wire I_type = (opcode == 5'b00101) | (opcode == 5'b00111) | (opcode == 5'b00010) | (opcode == 5'b00110) | (opcode == 5'b01000);
	 wire JI_type = (opcode == 5'b00001) | (opcode == 5'b00011) | (opcode == 5'b10110) | (opcode == 5'b10101);
	 wire JII_type = (opcode == 5'b00100);
	 
	 wire [4:0] R_type_ALU_op = instruction_at_D[6:2];
	 wire [4:0] shamt = instruction_at_D[11:7];
	 wire [4:0] ALU_op = R_type ? R_type_ALU_op : 5'b00000;
	
	 assign ctrl_readRegA = instruction_at_D[21:17]; //RS_register
	 assign ctrl_readRegB = instruction_at_D[16:12]; //RT_register
	 
	 wire [4:0] rd_register = instruction_at_D[26:22];
	 
	 wire [31:0] rs_val = data_readRegA;
	 wire [31:0] rt_val = data_readRegB;
	 wire [16:0] immediate_val = instruction_at_D[16:0];
	 wire [31:0] sign_extended_immediate_val = {{15{immediate_val[16]}}, immediate_val};
	 
	 wire [31:0] operandA = rs_val;
	 wire [31:0] operandB = R_type ? rt_val : sign_extended_immediate_val;
	 
	 // D/X stage
	 wire [31:0] operandA_at_X, operandB_at_X, instruction_at_X;
	 wire [4:0] ALU_op_at_X, shamt_at_X, rd_register_at_X;
	 
	 ThirtyTwoBitRegister DX_RS_Latch(operandA, clock, ~global_stall, reset, operandA_at_X);
	 ThirtyTwoBitRegister DX_RT_Latch(operandB, clock, ~global_stall, reset, operandB_at_X);
	 FiveBitRegister DX_ALU_op_Latch(ALU_op, clock, ~global_stall, reset, ALU_op_at_X);
	 FiveBitRegister DX_shamt_Latch(shamt, clock, ~global_stall, reset, shamt_at_X);
	 FiveBitRegister DX_RD_register_Latch(rd_register, clock, ~global_stall, reset, rd_register_at_X);
	 ThirtyTwoBitRegister DX_instruction_Latch(instruction_at_D, clock, ~global_stall, reset, instruction_at_X);
	
	 // Execute stage
	 wire is_add = (instruction_at_X[31:27] == 5'b00000) & (instruction_at_X[6:2] == 5'b00000);
	 wire is_addi = (instruction_at_X[31:27] == 5'b00101);
	 wire is_sub = (instruction_at_X[31:27] == 5'b00000) & (instruction_at_X[6:2] == 5'b00001);
	 wire is_mul = (instruction_at_X[31:27] == 5'b00000) & (instruction_at_X[6:2] == 5'b00110);
	 wire is_div = (instruction_at_X[31:27] == 5'b00000) & (instruction_at_X[6:2] == 5'b00111);
	 
	 wire [31:0] ALU_output;
	 wire isNotEqual, isLessThan, overflow;
	 alu X_stage_ALU(operandA_at_X, operandB_at_X, ALU_op_at_X, shamt_at_X,
						  ALU_output, isNotEqual, isLessThan, overflow);
	 
	 wire waiting_for_multdiv, waiting_for_multdiv_next;
	 wire ctrl_Mult = is_mul & (~waiting_for_multdiv); //currently not waiting for multdiv and need to do mult this cycle
	 wire ctrl_Div = is_div & (~waiting_for_multdiv); //currently not waiting for multdiv and need to do div this cycle

	 assign waiting_for_multdiv_next = ctrl_Mult | ctrl_Div | (waiting_for_multdiv & (~multdiv_ready)); //mul/div instruction entering the current cycle
	 dffe_ref multdiv_status_Latch(waiting_for_multdiv, waiting_for_multdiv_next, clock, is_mul|is_div, reset);
	 
	 wire multdiv_exception, multdiv_ready;
	 wire multdiv_stall = waiting_for_multdiv_next;
	 
	 wire [31:0] multdiv_output;
	 multdiv X_stage_Multdiv(operandA_at_X, operandB_at_X, ctrl_Mult, ctrl_Div, clock, multdiv_output, multdiv_exception, multdiv_ready);
	 wire ALU_exception_occurred = (is_add | is_addi | is_sub) & overflow;
	 wire multdiv_exception_occurred = waiting_for_multdiv & multdiv_ready & multdiv_exception;
	 wire exception_occurred = ALU_exception_occurred | multdiv_exception_occurred;
	 wire [4:0] register_to_write = exception_occurred ? 5'b11110 : rd_register_at_X;
	 
	 wire [31:0] rstatus_val = (is_add & overflow) ? 32'd1 : 
										(is_addi & overflow) ? 32'd2 :
										(is_sub & overflow) ? 32'd3 :
										(multdiv_exception_occurred & is_mul) ? 32'd4 :
										(multdiv_exception_occurred & is_div) ? 32'd5 : 32'd0;
	 wire [31:0] compute_unit_output = exception_occurred ? rstatus_val : multdiv_ready ? multdiv_output : ALU_output;

	 // X/M stage
	 wire [31:0] compute_unit_output_at_M, instruction_at_M;
	 wire [4:0] register_to_write_at_M;
	 ThirtyTwoBitRegister XM_instruction_Latch(instruction_at_X, clock, ~global_stall, reset, instruction_at_M);
	 ThirtyTwoBitRegister XM_ALU_output_Latch(compute_unit_output, clock, ~global_stall, reset, compute_unit_output_at_M);
	 FiveBitRegister XM_register_to_write_Latch(register_to_write, clock, ~global_stall, reset, register_to_write_at_M);

	 // Memory stage
	 assign address_dmem = 32'd0;
	 assign data = 32'd0;
	 assign wren = 1'b0;
	 wire [31:0] data_to_write = compute_unit_output_at_M;
	 
	 // M/W stage
	 wire [31:0] data_to_write_at_W, instruction_at_W;
	 wire [4:0] register_to_write_at_W;
	 ThirtyTwoBitRegister MW_instruction_Latch(instruction_at_M, clock, ~global_stall, reset, instruction_at_W);
	 ThirtyTwoBitRegister MW_data_to_write_Latch(data_to_write, clock, ~global_stall, reset, data_to_write_at_W);
	 FiveBitRegister MW_register_to_write_Latch(register_to_write_at_M, clock, ~global_stall, reset, register_to_write_at_W);
	 
	 // Write stage
	 assign ctrl_writeReg = register_to_write_at_W;
	 assign data_writeReg = data_to_write_at_W;
	 assign ctrl_writeEnable = 1'b1;
	 
endmodule 