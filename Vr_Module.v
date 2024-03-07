module Vr_PC(
    input CLK,
    input RST,
    input [31:0] IN_PC,
    output [31:0] C_PC
    );
    reg [31:0] PC;
    always @ (posedge CLK) begin
      if (RST) begin
         PC <= 0;
       end
      else begin
         PC <= IN_PC;
      end
   end
   assign C_PC = PC;
endmodule


module Vr_PC_ADD(
   input [2:0]B_AND_ALU,
   input [31:0] Imm_Exten,      
   input [31:0] C_PC,
   input [31:0] JALR,    
   output [31:0] NEXT_PC
   );
   reg [31:0] NEXT_PC_REG;
   always @ (B_AND_ALU, Imm_Exten, JALR, C_PC) begin 
      if (B_AND_ALU[0] == 1) begin
            NEXT_PC_REG <= C_PC + (Imm_Exten);
      end
      else begin
         if (B_AND_ALU[2:1] == 2'b11)   NEXT_PC_REG <= JALR;
         else if (B_AND_ALU[2:1] == 2'b10) NEXT_PC_REG <= C_PC + (Imm_Exten);
         else  NEXT_PC_REG <= C_PC + 4;
      end
   end

   assign NEXT_PC = NEXT_PC_REG;

endmodule
    
module Vr_IMM_GEN(
    input [31:0] Inst,
    output [31:0] Imm_OUT
    );
    reg [31:0] Imm_OUT_REG;
    reg [1:0]  JMP_SIG_REG;    
   always @ (Inst) begin
      case (Inst[6:0])
         7'b1100011 :              Imm_OUT_REG = {{20{Inst[31]}},Inst[7],Inst[30:25],Inst[11:8],1'b0}; //branch
         7'b0000011 , 7'b0010011 : Imm_OUT_REG = {{20{Inst[31]}}, Inst[31:20]}; //  LW ADDI
         7'b1100111 :              Imm_OUT_REG = {{20{Inst[31]}}, Inst[31:20]};     //JALR
         7'b0100011:               Imm_OUT_REG = {{20{Inst[31]}}, Inst[31:25], Inst[11:7]};        //SW
         7'b1101111:               Imm_OUT_REG = {{12{Inst[31]}}, Inst[19:12], Inst[20], Inst[30:21], 1'b0}; //jal
         default : Imm_OUT_REG = {32{1'bx}};
      endcase
   end
    assign JMP_SIG = JMP_SIG_REG;
    assign Imm_OUT = Imm_OUT_REG;
endmodule

module Vr_Reg_MUX(
    input [31:0] RD2,
    input [31:0] Imm_Exten,
    input ALUSrc,
    output [31:0] REG_MUX_OUT
    );
   reg [31:0] REG_MUX_REG;
   always @ (RD2, Imm_Exten, ALUSrc) begin
      if (ALUSrc) begin
              REG_MUX_REG = Imm_Exten;   
      end
      else  begin
            REG_MUX_REG = RD2;
      end
   end
   assign REG_MUX_OUT = REG_MUX_REG;
endmodule

module Vr_ALU(
    input [31:0] RD1,
    input [31:0] REG_MUX_SEL,
    input [3:0] ALU_CTRL,
    output ZERO,
    output [31:0] ALU_OUT
    );
   reg [31:0] ALU_REG;
   reg ZERO_REG;
   always @ (RD1, REG_MUX_SEL, ALU_CTRL) begin
       case (ALU_CTRL)
          4'b0000 : begin
            ALU_REG = RD1 & REG_MUX_SEL;
            ZERO_REG = 0;
          end//AND
         4'b0001 : begin
           ALU_REG = RD1 | REG_MUX_SEL;
           ZERO_REG = 0;
         end//OR
         4'b0010 :  begin
           ALU_REG = RD1 + REG_MUX_SEL;
           ZERO_REG = 0;
         end//Add
         4'b0110 :  begin
           ALU_REG = RD1 - REG_MUX_SEL;
           ZERO_REG = (ALU_REG == 0) ? 1 : 0;
         end//Sub
         4'b0111 :  begin
           ALU_REG = RD1 << REG_MUX_SEL[4:0];
           ZERO_REG = 1;           
         end//Shift left
         4'b1010 :  begin
           ALU_REG = 32'b0;
           ZERO_REG = ($signed(RD1) < $signed(REG_MUX_SEL)) ? 1 : 0;        
         end//BLT
         4'b1011 :  begin
           ALU_REG = 32'b0;
           ZERO_REG = ($signed(RD1) >= $signed(REG_MUX_SEL)) ? 1 : 0;        
         end//BGE
         default :  begin
           ZERO_REG =  0;        
         end//BGE
      endcase
   end
   assign ZERO = ZERO_REG;
   assign ALU_OUT = ALU_REG;
endmodule

module Vr_ALU_CTRL(
    input [31:0] Inst,
    input [1:0] ALU_OP,
    output [3:0] ALU_SEL_OUT
    );
   reg [31:0] ALU_SEL_REG;
   always @ (Inst, ALU_OP) begin
       case (ALU_OP)
          2'b00 : ALU_SEL_REG = 4'b0010;
         //LW, SW, JALR
          2'b01 : begin
                    if(Inst[14:12] == 3'b000) begin
                      ALU_SEL_REG = 4'b0110; // BEQ
                  end 
                  else if(Inst[14:12] == 3'b100) begin
                      ALU_SEL_REG = 4'b1010; // BLT
                  end
                  else if(Inst[14:12] == 3'b101) begin
                      ALU_SEL_REG = 4'b1011; // BGE
                  end
                  else begin
                      ALU_SEL_REG = 4'bxxxx;
                  end 
         end
         //Branch
         2'b10 : begin //R-Type
              if(Inst[31:25] != 0) begin
                  ALU_SEL_REG = 4'b0110;
              end
              else begin
                  if(Inst[14:12] == 0) begin
                      ALU_SEL_REG = 4'b0010;
                  end //ADD
                  else if(Inst[14:12] == 7) begin
                      ALU_SEL_REG = 4'b0000;
                  end //AND
                  else begin
                      ALU_SEL_REG = 4'b0001;
                  end //OR
              end
         end//Add
         2'b11 : begin //R-Type
                 if(Inst[14:12] == 0) begin
                      ALU_SEL_REG = 4'b0010;
                  end //ADD
                  else if(Inst[14:12] == 1) begin
                      ALU_SEL_REG = 4'b0111;
                  end //SHIFT
         end
         default : ALU_SEL_REG = 4'b1111;
         //Sub
      endcase
   end
   assign ALU_SEL_OUT = ALU_SEL_REG;
endmodule

module Vr_Data_MUX(
    input [31:0] RD_OUT,
    input [31:0] ALU_RESULT,
    input [31:0] C_PC,
    input [1:0] MW,
    output [31:0] WD
    );
   reg [31:0] WD_REG;
   always @ (RD_OUT, ALU_RESULT, MW) begin
      if (MW[1] == 0) begin
            if (MW[0] == 1) begin
                  WD_REG = RD_OUT;
            end
            else  begin
                  WD_REG = ALU_RESULT;
            end
        end
      else begin
                  WD_REG = C_PC + 4;
      end
   end
   
   assign WD = WD_REG;
endmodule

module Vr_CTRL(
    input [6:0] Inst_CTRL,
    input ALU_ZERO,
    output [9:0] CTRL
    );
   reg [9:0] CTRL_REG;
   reg AND_REG;
   reg CTRL0;
   always @ (Inst_CTRL) begin
   //RegWirte / ALU Src / MW / ALUOp(2) / MemDataSel(2) / JMP /Branch 
      case(Inst_CTRL)
         7'b1101111 : CTRL_REG = 10'b1x0xx10100;  //JAL
         7'b1100111 : CTRL_REG = 10'b1100010110;  //JALR
         7'b1100011 : CTRL_REG = 10'b00001xx0x1;  //Branch
         7'b0000011 : CTRL_REG = 10'b11000010x0;  //LW
         7'b0100011 : CTRL_REG = 10'b01100000x0;  //SW
         7'b0010011 : CTRL_REG = 10'b11011000x0;  //ADDi / SLLi
         7'b0110011 : CTRL_REG = 10'b10010000x0;  //ADD (R-type)
         default    : CTRL_REG = 10'bxxxxxxxxxx;
      endcase
      
   end
   
   assign CTRL[9:1] = CTRL_REG[9:1];
   assign CTRL[0] = ALU_ZERO & CTRL_REG[0];
endmodule