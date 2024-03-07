module Vr_data_mem(
   input CLK,
   input [31:0] ADDR,
   input 	RW, /* 0: Read, 1: Write */
   input [31:0] WD,
   output [31:0] RD, 
   output [31:0] ARR0, ARR1, ARR2, ARR3, ARR4, ARR5, ARR6, ARR7, ARR8, ARR9
   );
   wire [9:0] 	 word_addr;
   
   reg [31:0] 	 mem_cell [0:1023];
   reg [31:0] ARR0_REG, ARR1_REG, ARR2_REG, ARR3_REG, ARR4_REG, ARR5_REG, ARR6_REG, ARR7_REG, ARR8_REG, ARR9_REG;
   assign word_addr = ADDR[11:2];
  
   /*
    This block is for debugging purpose.
    Do not use initial block for initilization in your production code
    */
   initial
     begin
	/* Put your initial data */
        mem_cell[0] = 1;
        mem_cell[1] = 9;
        mem_cell[2] = 2;
        mem_cell[3] = 3;
        mem_cell[4] = 5;
        mem_cell[5] = 10;
        mem_cell[6] = 7;
        mem_cell[7] = 6;
        mem_cell[8] = 4;
        mem_cell[9] = 8;
     end // initial begin

   // Dumpvars does not dump array entries
   // To detour the limitation, assign each register entry to a temporal wire.
   generate
      genvar 		 idx;
      for (idx = 0; idx < 1024; idx = idx+1) begin: datamem
	 wire [31:0] tmp;
	 assign tmp = mem_cell[idx];
      end
   endgenerate

   /* write */
   always @ (posedge CLK)
     begin
	if (ADDR <1024)
	  if (RW)
            mem_cell[$unsigned(word_addr)] = WD;
     end

   /* read */
   assign RD = RW ? 32'hz : mem_cell[$unsigned(word_addr)];
   
   assign ARR0 = mem_cell[0];
   assign ARR1 = mem_cell[1];
   assign ARR2 = mem_cell[2];
   assign ARR3 = mem_cell[3];
   assign ARR4 = mem_cell[4];
   assign ARR5 = mem_cell[5];
   assign ARR6 = mem_cell[6];
   assign ARR7 = mem_cell[7];
   assign ARR8 = mem_cell[8];
   assign ARR9 = mem_cell[9];
   
   
endmodule
