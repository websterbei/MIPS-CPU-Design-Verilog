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
    data_readRegB,                   // I: Data from port B of regfile
	 global_debug_out
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
	 output [31:0] global_debug_out;
	 
	 
	 wire global_stall = multdiv_stall | (sw_lw_stall & (~nop_at_D));
	 
	 // Stall for read after lw
	 wire R_type_at_pre = (q_imem[31:27] == 5'b00000);
	 wire is_sw_at_pre = (q_imem[31:27] == 5'b00111);
	 wire is_lw_at_pre = (q_imem[31:27] == 5'b01000);
	 wire is_addi_at_pre = (q_imem[31:27] == 5'b00101);
	 wire read_first_register_at_pre = (R_type_at_pre | is_addi_at_pre | is_lw_at_pre | is_sw_at_pre | is_bne_at_pre | is_blt_at_pre); // All instructions that uses RS
	 wire read_second_register_at_pre = (R_type_at_pre | is_bne_at_pre | is_blt_at_pre | is_bex_at_pre | is_sw_at_X | is_jr_at_X); // All instructions that uses RD or RT
	 wire [4:0] first_register_read_at_pre = (R_type_at_pre | is_addi_at_pre | is_lw_at_pre | is_sw_at_pre | is_bne_at_pre | is_blt_at_pre) ? q_imem[21:17] : 5'b00000;
	 wire [4:0] second_register_read_at_pre = R_type_at_pre ? q_imem[16:12] :
												         (is_sw_at_pre | is_bne_at_pre | is_blt_at_pre | is_sw_at_X | is_jr_at_X) ? q_imem[26:22] :
												         is_bex_at_pre ? 5'b11110 : 5'b00000;	 
	 
	 wire read_after_lw_stall = is_lw_at_D & ((read_first_register_at_pre & (first_register_read_at_pre == instruction_at_D[26:22])) |
										 (read_second_register_at_pre & (second_register_read_at_pre == instruction_at_D[26:22]))) ;
	 
	 // Fetch stage
	 wire is_j_at_pre = (q_imem[31:27] == 5'b00001);
	 wire is_bne_at_pre = (q_imem[31:27] == 5'b00010);
	 wire is_jal_at_pre = (q_imem[31:27] == 5'b00011);
	 wire is_jr_at_pre = (q_imem[31:27] == 5'b00100);
	 wire is_blt_at_pre = (q_imem[31:27] == 5'b00110);
	 wire is_bex_at_pre = (q_imem[31:27] == 5'b10110);
	 wire is_setx_at_pre = (q_imem[31:27] == 5'b10101);
	 
	 wire jump_instruction_at_pre = is_j_at_pre | is_bne_at_pre | is_jal_at_pre | is_jr_at_pre | is_blt_at_pre | is_bex_at_pre;
	 
	 wire jump_instruction_in_pipeline_DXMW = jump_instruction_at_D | jump_instruction_at_X | jump_instruction_at_M | jump_instruction_at_W; 
	 wire [31:0] instruction_at_F = ((jump_instruction_in_pipeline_DXMW & jump_instruction_at_pre) | read_after_lw_stall) ? 32'd0 : q_imem;
	 
	 wire is_j_at_F = (instruction_at_F[31:27] == 5'b00001);
	 wire is_bne_at_F = (instruction_at_F[31:27] == 5'b00010);
	 wire is_jal_at_F = (instruction_at_F[31:27] == 5'b00011);
	 wire is_jr_at_F = (instruction_at_F[31:27] == 5'b00100);
	 wire is_blt_at_F = (instruction_at_F[31:27] == 5'b00110);
	 wire is_bex_at_F = (instruction_at_F[31:27] == 5'b10110);
	 wire is_setx_at_F = (instruction_at_F[31:27] == 5'b10101);
	 
	 wire jump_instruction_at_F = is_j_at_F | is_bne_at_F | is_jal_at_F | is_jr_at_F | is_blt_at_F | is_bex_at_F;
	 
	 // F/D stage
	 wire nop_at_D = (instruction_at_D == 32'd0);
	 
	 wire [31:0] instruction_at_D, current_PC_at_D;
	 ThirtyTwoBitRegister FD_instruction_Latch(instruction_at_F, clock, ~global_stall, reset, instruction_at_D);
	 ThirtyTwoBitRegister FD_PC_Latch(address_imem, clock, ~global_stall, reset, current_PC_at_D);
	 
	 // Decode stage
	 wire is_j_at_D = (instruction_at_D[31:27] == 5'b00001);
	 wire is_bne_at_D = (instruction_at_D[31:27] == 5'b00010);
	 wire is_jal_at_D = (instruction_at_D[31:27] == 5'b00011);
	 wire is_jr_at_D = (instruction_at_D[31:27] == 5'b00100);
	 wire is_blt_at_D = (instruction_at_D[31:27] == 5'b00110);
	 wire is_bex_at_D = (instruction_at_D[31:27] == 5'b10110);
	 wire is_setx_at_D = (instruction_at_D[31:27] == 5'b10101);
	 
	 wire jump_instruction_at_D = is_j_at_D | is_bne_at_D | is_jal_at_D | is_jr_at_D | is_blt_at_D | is_bex_at_D;
	 
	 wire is_lw_at_D = (instruction_at_D[31:27] == 5'b01000);
	 
	 wire [4:0] opcode = instruction_at_D[31:27];
	 wire R_type = (opcode == 5'b00000);
	 wire I_type = (opcode == 5'b00101) | (opcode == 5'b00111) | (opcode == 5'b00010) | (opcode == 5'b00110) | (opcode == 5'b01000);
	 wire JII_type = (opcode == 5'b00100);
	
	 wire [4:0] R_type_ALU_op = instruction_at_D[6:2];
	 wire [4:0] shamt = instruction_at_D[11:7];
	 wire [4:0] ALU_op = R_type ? R_type_ALU_op : 5'b00000;
	
	 wire [4:0] rd_register = instruction_at_D[26:22];
	 
	 assign ctrl_readRegA = instruction_at_D[21:17]; //RS_register
	 assign ctrl_readRegB = is_bex_at_D ? 5'b11110 : R_type ? instruction_at_D[16:12] : rd_register; //RT_register
	 
	 wire [31:0] rs_val = data_readRegA;
	 wire [31:0] rt_or_rd_val = data_readRegB;
	 wire [16:0] immediate_val = instruction_at_D[16:0];
	 wire [31:0] sign_extended_immediate_val = {{15{immediate_val[16]}}, immediate_val};
	 
	 wire [31:0] operandA = rs_val;
	 wire [31:0] operandB = R_type ? rt_or_rd_val : sign_extended_immediate_val;
	 wire [31:0] rd_val = rt_or_rd_val; //take care of the sw, jr, bne, blt instruction, need to load rd; when instruction is bex, this value is rstatus value
	 
	 
	 // D/X stage
	 wire [31:0] raw_operandA_at_X, raw_operandB_at_X, instruction_at_X, rd_val_at_X, current_PC_at_X;
	 wire [4:0] ALU_op_at_X, shamt_at_X, rd_register_at_X;
	 
	 ThirtyTwoBitRegister DX_RS_Latch(operandA, clock, ~global_stall, reset, raw_operandA_at_X);
	 ThirtyTwoBitRegister DX_RT_Latch(operandB, clock, ~global_stall, reset, raw_operandB_at_X);
	 FiveBitRegister DX_ALU_op_Latch(ALU_op, clock, ~global_stall, reset, ALU_op_at_X);
	 FiveBitRegister DX_shamt_Latch(shamt, clock, ~global_stall, reset, shamt_at_X);
	 FiveBitRegister DX_RD_register_Latch(rd_register, clock, ~global_stall, reset, rd_register_at_X);
	 ThirtyTwoBitRegister DX_instruction_Latch(instruction_at_D, clock, ~global_stall, reset, instruction_at_X);
	 ThirtyTwoBitRegister DX_RD_val_Latch(rd_val, clock, ~global_stall, reset, rd_val_at_X);
	 ThirtyTwoBitRegister DX_PC_Latch(current_PC_at_D, clock, ~global_stall, reset, current_PC_at_X);
	
	 // Execute stage
	 
	 //Bypass logic
	 wire nop_at_X = (instruction_at_X == 32'd0);
	 
	 wire R_type_at_X = (instruction_at_X[31:27] == 5'b00000);
	 wire is_sw_at_X = (instruction_at_X[31:27] == 5'b00111);
	 wire is_lw_at_X = (instruction_at_X[31:27] == 5'b01000);
	 wire read_first_register = (R_type_at_X | is_addi | is_lw_at_X | is_sw_at_X | is_bne_at_X | is_blt_at_X); // All instructions that uses RS
	 wire read_second_register = (R_type_at_X | is_bne_at_X | is_blt_at_X | is_bex_at_X | is_sw_at_X | is_jr_at_X); // All instructions that uses RD or RT
	 wire [4:0] first_register_read = (R_type_at_X | is_addi | is_lw_at_X | is_sw_at_X | is_bne_at_X | is_blt_at_X) ? instruction_at_X[21:17] : 5'b00000;
	 wire [4:0] second_register_read = R_type_at_X ? instruction_at_X[16:12] :
												  (is_sw_at_X | is_bne_at_X | is_blt_at_X | is_sw_at_X | is_jr_at_X) ? instruction_at_X[26:22] :
												  is_bex_at_X ? 5'b11110 : 5'b00000;	 
	 
	 wire [31:0] operandA_at_X = (read_first_register & (first_register_read == register_to_write_at_M) & write_enable_at_M & (~is_lw)) ? compute_unit_output_at_M :
										  (read_first_register & (first_register_read == register_to_write_at_W) & ctrl_writeEnable) ? data_to_write_at_W : raw_operandA_at_X;
	 wire [31:0] operandB_at_X = (read_second_register & (second_register_read == register_to_write_at_M) & write_enable_at_M & (~is_lw)) ? compute_unit_output_at_M :
										  (read_second_register & (second_register_read == register_to_write_at_W) & ctrl_writeEnable) ? data_to_write_at_W : raw_operandB_at_X;
	 
	 wire is_j_at_X = (instruction_at_X[31:27] == 5'b00001);
	 wire is_bne_at_X = (instruction_at_X[31:27] == 5'b00010);
	 wire is_jal_at_X = (instruction_at_X[31:27] == 5'b00011);
	 wire is_jr_at_X = (instruction_at_X[31:27] == 5'b00100);
	 wire is_blt_at_X = (instruction_at_X[31:27] == 5'b00110);
	 wire is_bex_at_X = (instruction_at_X[31:27] == 5'b10110);
	 wire is_setx_at_X = (instruction_at_X[31:27] == 5'b10101);
	 
	 wire jump_instruction_at_X = is_j_at_X | is_bne_at_X | is_jal_at_X | is_jr_at_X | is_blt_at_X | is_bex_at_X;
	 
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
	 wire [4:0] register_to_write = (exception_occurred | is_setx_at_X) ? 5'b11110 : is_jal_at_X ? 5'b11111 : rd_register_at_X;
	 
	 wire [31:0] rstatus_val = (is_add & overflow) ? 32'd1 : 
										(is_addi & overflow) ? 32'd2 :
										(is_sub & overflow) ? 32'd3 :
										(multdiv_exception_occurred & is_mul) ? 32'd4 :
										(multdiv_exception_occurred & is_div) ? 32'd5 : 32'd0;
	 wire [31:0] compute_unit_output = is_jal_at_X ? current_PC_at_X :
												  exception_occurred ? rstatus_val :
												  is_setx_at_X ? {5'd0, instruction_at_X[26:0]} :
												  multdiv_ready ? multdiv_output : ALU_output;

	 //Bypass logic for rd_val								  
    //	 wire [31:0] bypass_rd_val_at_X =((read_second_register | is_sw_at_X | is_jr_at_X) & (second_register_read == register_to_write_at_M) & write_enable_at_M & (~is_lw)) ? compute_unit_output_at_M :
    //												((read_second_register | is_sw_at_X | is_jr_at_X) & (second_register_read == register_to_write_at_W) & ctrl_writeEnable) ? data_to_write_at_W : rd_val_at_X;
	 
	 // X/M stage
	 wire [31:0] compute_unit_output_at_M, instruction_at_M, rd_val_at_M, rs_val_at_M, current_PC_at_M;
	 wire [4:0] register_to_write_at_M;
	 ThirtyTwoBitRegister XM_instruction_Latch(instruction_at_X, clock, ~global_stall, reset, instruction_at_M);
	 ThirtyTwoBitRegister XM_ALU_output_Latch(compute_unit_output, clock, ~global_stall, reset, compute_unit_output_at_M);
	 FiveBitRegister XM_register_to_write_Latch(register_to_write, clock, ~global_stall, reset, register_to_write_at_M);
	 ThirtyTwoBitRegister XM_RD_val_Latch(operandB_at_X, clock, ~global_stall, reset, rd_val_at_M);
	 ThirtyTwoBitRegister XM_RS_val_Latch(operandA_at_X, clock, ~global_stall, reset, rs_val_at_M);
	 ThirtyTwoBitRegister XM_PC_Latch(current_PC_at_X, clock, ~global_stall, reset, current_PC_at_M);
	 
	 // Memory stage
	 wire nop_at_M = (instruction_at_M == 32'd0);
	 assign write_enable_at_M = ((instruction_at_M[31:27] == 5'b00000) |
									    (instruction_at_M[31:27] == 5'b00101) |
										 (instruction_at_M[31:27] == 5'b01000) |
										 (instruction_at_M[31:27] == 5'b00011) |
										 (instruction_at_M[31:27] == 5'b10101)) &
										(~nop_at_M);
	 
	 wire is_j_at_M = (instruction_at_M[31:27] == 5'b00001);
	 wire is_bne_at_M = (instruction_at_M[31:27] == 5'b00010);
	 wire is_jal_at_M = (instruction_at_M[31:27] == 5'b00011);
	 wire is_jr_at_M = (instruction_at_M[31:27] == 5'b00100);
	 wire is_blt_at_M = (instruction_at_M[31:27] == 5'b00110);
	 wire is_bex_at_M = (instruction_at_M[31:27] == 5'b10110);
	 wire is_setx_at_M = (instruction_at_M[31:27] == 5'b10101);
	 
	 wire jump_instruction_at_M = is_j_at_M | is_bne_at_M | is_jal_at_M | is_jr_at_M | is_blt_at_M | is_bex_at_M;
	 
	 wire is_sw = (instruction_at_M[31:27] == 5'b00111);
	 wire is_lw = (instruction_at_M[31:27] == 5'b01000);
	 assign wren = is_sw;
	 assign address_dmem = compute_unit_output_at_M[11:0];
	 //Bypass logic, WM bypass
	 wire [4:0] register_from_which_data_stored_at_current_sw = instruction_at_M[26:22];
	 assign data = (register_to_write_at_W == register_from_which_data_stored_at_current_sw) ? data_to_write_at_W : rd_val_at_M;
	 
	 wire waiting_for_sw_lw_next, waiting_for_sw_lw;
	 assign waiting_for_sw_lw_next = (~waiting_for_sw_lw) & (is_sw | is_lw);
	 dffe_ref sw_lw_status_Latch(waiting_for_sw_lw, waiting_for_sw_lw_next, clock, is_sw|is_lw, reset);
	 
	 wire sw_lw_stall = waiting_for_sw_lw_next;
	 wire [31:0] data_to_write = is_lw ? q_dmem : compute_unit_output_at_M;
	 
	 // M/W stage
	 wire [31:0] data_to_write_at_W, instruction_at_W, rs_val_at_W, rd_val_at_W, current_PC_at_W;
	 wire [4:0] register_to_write_at_W;
	 ThirtyTwoBitRegister MW_instruction_Latch(instruction_at_M, clock, ~global_stall, reset, instruction_at_W);
	 ThirtyTwoBitRegister MW_data_to_write_Latch(data_to_write, clock, ~global_stall, reset, data_to_write_at_W);
	 FiveBitRegister MW_register_to_write_Latch(register_to_write_at_M, clock, ~global_stall, reset, register_to_write_at_W);
	 ThirtyTwoBitRegister MW_RS_val_Latch(rs_val_at_M, clock, ~global_stall, reset, rs_val_at_W);
	 ThirtyTwoBitRegister MW_RD_val_Latch(rd_val_at_M, clock, ~global_stall, reset, rd_val_at_W);
	 ThirtyTwoBitRegister MW_PC_Latch(current_PC_at_M, clock, ~global_stall, reset, current_PC_at_W);
	 
	 // Write stage
	 wire is_lw_at_W = (instruction_at_W[31:27] == 5'b01000);
	 
	 assign ctrl_writeReg = register_to_write_at_W;
	 assign data_writeReg = data_to_write_at_W;
	 wire nop_at_W = (instruction_at_W == 32'd0);
	 assign ctrl_writeEnable = ((instruction_at_W[31:27] == 5'b00000) |
									    (instruction_at_W[31:27] == 5'b00101) |
										 (instruction_at_W[31:27] == 5'b01000) |
										 (instruction_at_W[31:27] == 5'b00011) |
										 (instruction_at_W[31:27] == 5'b10101)) &
										(~nop_at_W);
	 
	 // PC update
	 wire is_j_at_W = (instruction_at_W[31:27] == 5'b00001);
	 wire is_bne_at_W = (instruction_at_W[31:27] == 5'b00010);
	 wire is_jal_at_W = (instruction_at_W[31:27] == 5'b00011);
	 wire is_jr_at_W = (instruction_at_W[31:27] == 5'b00100);
	 wire is_blt_at_W = (instruction_at_W[31:27] == 5'b00110);
	 wire is_bex_at_W = (instruction_at_W[31:27] == 5'b10110);
	 wire is_setx_at_W = (instruction_at_W[31:27] == 5'b10101);
	 
	 wire jump_instruction_at_W = is_j_at_W | is_bne_at_W | is_jal_at_W | is_jr_at_W | is_blt_at_W | is_bex_at_W;
	 
	 wire is_rd_less_than_rs, is_rd_not_equal_rs, unused_overflow3;
	 wire [31:0] unused_result;
	 alu val_comparator(rd_val_at_W, rs_val_at_W, 5'b00000, 5'b00000,
						       unused_result, is_rd_not_equal_rs, is_rd_less_than_rs, unused_overflow3);
	 
	 wire [31:0] PC_plus_one, PC_plus_one_plus_N, next_PC, current_PC;
	 wire unused_overflow1, unused_overflow2;
	 ThirtyTwoBitAdder PC_adder(current_PC, 32'd0, 1'b1, PC_plus_one, unused_overflow1);
	 wire [31:0] immediate_N = {{15{instruction_at_W[16]}}, instruction_at_W[16:0]};
	 ThirtyTwoBitAdder PC_adder_jump(current_PC_at_W, immediate_N, 1'b1, PC_plus_one_plus_N, unused_overflow2);
	 
	 wire rstatus_val_is_not_zero = ~(rd_val_at_W == 32'd0); // In the case that it is a bex instruciton, rd_val_at_W stores rstatus value
	 
	 assign next_PC = (is_j_at_W|is_jal_at_W|(is_bex_at_W & rstatus_val_is_not_zero)) ? instruction_at_W : is_jr_at_W ? rd_val_at_W :
	                  ((is_bne_at_W & is_rd_not_equal_rs)|(is_blt_at_W & is_rd_less_than_rs)) ? PC_plus_one_plus_N : PC_plus_one;
							
	 wire jump_instruction_in_pipeline_FDXM = jump_instruction_at_F | jump_instruction_at_D | jump_instruction_at_X | jump_instruction_at_M;
	 wire jump_stall = jump_instruction_in_pipeline_FDXM;
	 ThirtyTwoBitRegister PC_register(address_imem, clock, ~(global_stall | jump_stall | read_after_lw_stall), reset, current_PC);
	 assign address_imem = reset ? 12'd0 : (jump_stall | multdiv_stall | read_after_lw_stall) ? current_PC[11:0] : next_PC[11:0];
	 assign global_debug_out = instruction_at_D;
	 
endmodule 