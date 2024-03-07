module Vr_register_file(CLK, RST, RR1, RR2, WR, WD, WE, RD1, RD2);
   input CLK;
   input RST;
   input [4:0] RR1;
   input [4:0] RR2;
   input [4:0] WR;
   input [31:0] WD;
   input 	WE; //RegWrite
   output [31:0] RD1; // RR1
   output [31:0] RD2; // RR2

   reg [31:0] 	 register_file [0:31];
   assign RD1 = register_file[RR1];
   assign RD2 = register_file[RR2];
   integer 		 i;

   // Dumpvars does not dump array entries
   // To detour the limitation, assign each register entry to a temporal wire.
   generate
      genvar 		 idx;
      for(idx = 0; idx < 32; idx = idx+1) begin: register
	 wire [31:0] tmp;
	 assign tmp = register_file[idx];
      end
   endgenerate

   always @(posedge CLK)
     begin
	if (RST)
	  begin
	     for (i = 0 ; i < 32 ; i = i + 1) begin
	       register_file[i] = i;
	     end
	  end
	else if (WE)
	  register_file[WR] = WD;
     end

endmodule
