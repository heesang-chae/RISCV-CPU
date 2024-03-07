 0:   INST=32'h00000513;              //  li      a0,0
           4:   INST=32'h00100293;              //  li      t0,1
           8:   INST=32'h00a00613;              //  li      a2,10
        
        //0000000c <LOOP>:
          12:   INST=32'h04c2dc63;              //  bge     t0,a2,64 <EXIT>
          16:   INST=32'h00229e93;              //  sll     t4,t0,0x2
          20:   INST=32'h00ae8eb3;              //  add     t4,t4,a0
          24:   INST=32'h000ea383;              //  lw      t2,0(t4)
          28:   INST=32'hfff28313;              //  add     t1,t0,-1
        
        //00000020 <L1>:
          32:   INST=32'h02034663;              //  bltz    t1,4c <L2>
          36:   INST=32'h00231e93;              //  sll     t4,t1,0x2
          40:   INST=32'h00ae8eb3;              //  add     t4,t4,a0
          44:   INST=32'h000eaf83;              //  lw      t6,0(t4)
          48:   INST=32'h01f3de63;              //  bge     t2,t6,4c <L2>
          52:   INST=32'h00130f13;              //  add     t5,t1,1
          56:   INST=32'h002f1f13;              //  sll     t5,t5,0x2
          60:   INST=32'h00af0f33;              //  add     t5,t5,a0
          64:   INST=32'h01ff2023;              //  sw      t6,0(t5)
          68:   INST=32'hfff30313;              //  add     t1,t1,-1
          72:   INST=32'hfc000ce3;              //  beqz    zero,20 <L1>
        
        //0000004c <L2>:
          76:   INST=32'h00130f13;              //  add     t5,t1,1
          80:   INST=32'h002f1f13;              //  sll     t5,t5,0x2
          84:   INST=32'h00af0f33;              //  add     t5,t5,a0
          88:   INST=32'h007f2023;              //  sw      t2,0(t5)
          92:   INST=32'h00128293;              //  add     t0,t0,1
          96:   INST=32'hfa0006e3;              //  beqz    zero,c <LOOP>