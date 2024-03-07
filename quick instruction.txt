//quick_sort
         
           0:   INST=32'h00000593;              //  li      a1,0
           4:   INST=32'h00000613;              //  li      a2,0
           8:   INST=32'h00a00693;              //  li      a3,10
          12:   INST=32'h3fa10113;              //  add     sp,sp,1018
          16:   INST=32'hfff68693;              //  add     a3,a3,-1
        
        //00000014 <quick>:
          20:   INST=32'h04d65a63;              //  bge     a2,a3,68 <EXIT_quick>
          24:   INST=32'hff010113;              //  add     sp,sp,-16
          28:   INST=32'h00112623;              //  sw      ra,12(sp)
          32:   INST=32'h01212423;              //  sw      s2,8(sp)
          36:   INST=32'h01312223;              //  sw      s3,4(sp)
          40:   INST=32'h01412023;              //  sw      s4,0(sp)
          44:   INST=32'h00060913;              //  mv      s2,a2
          48:   INST=32'h00068993;              //  mv      s3,a3
          52:   INST=32'h038000ef;              //  jal     6c <partition>
          56:   INST=32'h00050a13;              //  mv      s4,a0
          60:   INST=32'hfffa0693;              //  add     a3,s4,-1
          64:   INST=32'h00090613;              //  mv      a2,s2
          68:   INST=32'hfd1ff0ef;              //  jal     14 <quick>
          72:   INST=32'h001a0613;              //  add     a2,s4,1
          76:   INST=32'h00098693;              //  mv      a3,s3
          80:   INST=32'hfc5ff0ef;              //  jal     14 <quick>
          84:   INST=32'h00c12083;              //  lw      ra,12(sp)
          88:   INST=32'h00812903;              //  lw      s2,8(sp)
          92:   INST=32'h00412983;              //  lw      s3,4(sp)
          96:   INST=32'h00012a03;              //  lw      s4,0(sp)
          100:   INST=32'h01010113;              //  add     sp,sp,16
        
        //00000068 <EXIT_quick>:
          104:   INST=32'h00008067;              //  ret
        
        //0000006c <partition>:
          108:   INST=32'hff410113;              //  add     sp,sp,-12
          112:   INST=32'h00112423;              //  sw      ra,8(sp)
          116:   INST=32'h01212223;              //  sw      s2,4(sp)
          120:   INST=32'h01312023;              //  sw      s3,0(sp)
          124:   INST=32'h00060913;              //  mv      s2,a2
          128:   INST=32'h00168993;              //  add     s3,a3,1
          132:   INST=32'h00261e13;              //  sll     t3,a2,0x2
          136:   INST=32'h00be0e33;              //  add     t3,t3,a1
          140:   INST=32'h000e2283;              //  lw      t0,0(t3)
        
        //00000090 <L1>:
          144:   INST=32'h00190913;              //  add     s2,s2,1
          148:   INST=32'h0126cc63;              //  blt     a3,s2,ac <L2>
          152:   INST=32'h00291f13;              //  sll     t5,s2,0x2
          156:   INST=32'h00bf0f33;              //  add     t5,t5,a1
          160:   INST=32'h000f2f03;              //  lw      t5,0(t5)
          164:   INST=32'h005f5463;              //  bge     t5,t0,ac <L2>
          168:   INST=32'hfe0004e3;              //  beqz    zero,90 <L1>
        
        //000000ac <L2>:
          172:   INST=32'hfff98993;              //  add     s3,s3,-1
          176:   INST=32'h00c9cc63;              //  blt     s3,a2,c8 <L3>
          180:   INST=32'h00299f93;              //  sll     t6,s3,0x2
          184:   INST=32'h00bf8fb3;              //  add     t6,t6,a1
          188:   INST=32'h000faf83;              //  lw      t6,0(t6)
          192:   INST=32'h01f2d463;              //  bge     t0,t6,c8 <L3>
          196:   INST=32'hfe0004e3;              //  beqz    zero,ac <L2>
        
        //000000c8 <L3>:
          200:   INST=32'h03395263;              //  bge     s2,s3,ec <SKIP_SWAP>
          204:   INST=32'h00291313;              //  sll     t1,s2,0x2
          208:   INST=32'h00b30333;              //  add     t1,t1,a1
          212:   INST=32'h00032f03;              //  lw      t5,0(t1)
          216:   INST=32'h00299393;              //  sll     t2,s3,0x2
          220:   INST=32'h00b383b3;              //  add     t2,t2,a1
          224:   INST=32'h0003af83;              //  lw      t6,0(t2)
          228:   INST=32'h01f32023;              //  sw      t6,0(t1)
          232:   INST=32'h01e3a023;              //  sw      t5,0(t2)
        
        //000000ec <SKIP_SWAP>:
          236:   INST=32'hfb3942e3;              //  blt     s2,s3,90 <L1>
          240:   INST=32'h00261313;              //  sll     t1,a2,0x2
          244:   INST=32'h00b30333;              //  add     t1,t1,a1
          248:   INST=32'h00032f03;              //  lw      t5,0(t1)
          252:   INST=32'h00299393;              //  sll     t2,s3,0x2
         256:   INST=32'h00b383b3;              //  add     t2,t2,a1
         260:   INST=32'h0003af83;              //  lw      t6,0(t2)
         264:   INST=32'h01f32023;              //  sw      t6,0(t1)
         268:   INST=32'h01e3a023;              //  sw      t5,0(t2)
         272:   INST=32'h00098513;              //  mv      a0,s3
         276:   INST=32'h00812083;              //  lw      ra,8(sp)
         280:   INST=32'h00412903;              //  lw      s2,4(sp)
         284:   INST=32'h00012983;              //  lw      s3,0(sp)
         288:   INST=32'h00c10113;              //  add     sp,sp,12
        
        //00000124 <EXIT_part>:
         292:   INST=32'h00008067;              //  ret