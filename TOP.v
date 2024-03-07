module TOP(
RST,CLK,ARR0, ARR1, ARR2, ARR3, ARR4, ARR5, ARR6, ARR7, ARR8, ARR9
);
    
    input RST, CLK;
    output [31:0] ARR0, ARR1, ARR2, ARR3, ARR4, ARR5, ARR6, ARR7, ARR8, ARR9;

    wire [9:0] CTRL;
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
    wire [31:0]  REG_MUX_OUT;
    wire [3:0] ALU_CTRL;
    wire [1:0] JMP_SIG;

    Vr_PC Prog_Counter
    (
        CLK,
        RST,
        IN_PC,
        C_PC
    );

   Vr_PC_ADD Prog_Counter_ADD 
    (
        CTRL[2:0],
        Imm_Exten,      
        C_PC,
        ALU_RESULT,   
        IN_PC
    );
   Vr_inst_mem Instruction_MEM 
    (
        C_PC                   , 
        INST
    );
   
    Vr_CTRL control_Unit
    (
        INST[6:0], 
        ZERO, 
        CTRL
    );
   
   Vr_Data_MUX D_MUX 
    (
        RD_OUT,
        ALU_RESULT,
        C_PC,
        CTRL [4:3],
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
        CTRL[9], 
        RD1,
        RD2
    );

   Vr_IMM_GEN Imm_G
    (
        INST ,
        Imm_Exten
    );   

   Vr_Reg_MUX R_MUX 
    (
        RD2,
        Imm_Exten,
        CTRL[8],
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
        CTRL[6:5],
        ALU_CTRL
    );

    Vr_data_mem data_Mem
    (
        CLK, 
        ALU_RESULT , 
        CTRL[7] , 
        RD2,  
        RD_OUT,
        ARR0, ARR1, ARR2, ARR3, ARR4, ARR5, ARR6, ARR7, ARR8, ARR9
    );

endmodule