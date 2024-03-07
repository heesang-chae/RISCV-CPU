`timescale 1ns / 1ps

module Vr_cpu_TOP(
    input RST, 
	input CLK
	);
    
    wire [7:0] CTRL;
    wire [31:0] IN_PC;
    wire [31:0] C_PC;
    wire [31:0] Imm_Exten;
    wire [31:0] INST;
    wire ZERO;
    wire [31:0] RD_OUT;
    wire [31:0] ALU_RESULT;
    wire [31:0] WD;
    wire [31:0] RD1;
    wire [31:0] RD2;
    wire [31:0] Imm_OUT;
    wire [31:0]  REG_MUX_OUT;
    wire [3:0] ALU_CTRL;
    
    Vr_PC Prog_Counter
    (
        CLK,
        RST,
        IN_PC,
        C_PC
    );

	Vr_PC_ADD Prog_Counter_ADD 
    (
        CTRL[7],
	    Imm_Exten,		
	    C_PC,	
        IN_PC
    );

	Vr_inst_mem Instruction_MEM 
    (
        C_PC                   , 
        iNST
    );
	
    Vr_CTRL control_Unit
    (
        INST[6:0], 
        ZERO , 
        CTRL
    );
	
	Vr_Data_MUX D_MUX 
    (
        RD_OUT,
        ALU_RESULT,
        CTRL [6:5],
        WD
    );
	
	Vr_register_file RF
    (
        CLK , 
        RST , 
        INST[19:15], 
        INST[24:20], 
        INST[11:7] , 
        WD , 
        CTRL[0], 
        RD1,
        RD2
    );

	Vr_IMM_GEN Imm_G
    (
        INST ,
        Imm_OUT
    );	

	Vr_Reg_MUX R_MUX 
    (
        RD2,
        Imm_Exten,
        CTRL[1],
        REG_MUX_OUT
    );
	
    Vr_ALU ALUUU 
    (
        RD1,
        REG_MUX_OUT , 
        ALU_CTRL,
        ZERO,
        ALU_RESULT
    );
	
    Vr_ALU_CTRL ALUUU_CTRL 
    (
        INST,
        CTRL[4:3],
        ALU_CTRL
    );
	
    Vr_data_mem data_Mem
    (
        CLK, 
        ALU_RESULT , 
        CTRL[2] , 
        RD2,                , 
        RD_OUT
    );

endmodule
