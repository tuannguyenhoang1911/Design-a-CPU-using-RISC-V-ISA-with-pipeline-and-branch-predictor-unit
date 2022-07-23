// R-format and I-format basic data hazard resolve by using Forwarding unit
module Forwarding_Unit (
      input  wire [4:0]  ex_rs1     , // from Reg_ID_EX
      input  wire [4:0]  ex_rs2     , // from Reg_ID_EX
      input  wire [4:0]  mem_rd     , // from Reg_EX_MEM
      input  wire [4:0]  wb_rd      , // from Reg_MEM_WB
      input              mem_RegWr  , // from Reg_EX_MEM
      input              wb_RegWr   , // from Reg_MEM_WB
      input              mem_MemRd  , // from Reg_EX_MEM
		input              wb_MemRd   , // from Reg_EX_MEM
		input              extra_MemRd, // from Reg_After_MEM_WB
		input  wire [4:0]  extra_rd   , // from Reg_After_MEM_WB
		input              extra_RegWr, // from Reg_After_MEM_WB
		input              mem_MemWr  , // from Reg_EX_MEM
      output reg  [1:0]  ForwardASel,
      output reg  [1:0]  ForwardBSel 
  );
  
wire w_hazard1a = (mem_RegWr)&&(mem_rd != 5'b00000)&&(mem_rd==ex_rs1);
wire w_hazard2a = (wb_RegWr)&&(wb_rd!= 5'b00000)&&(wb_rd==ex_rs1);
wire w_hazard1b = (mem_RegWr)&&(mem_rd != 5'b00000)&&(mem_rd==ex_rs2);
wire w_hazard2b = (wb_RegWr)&&(wb_rd!= 5'b00000)&&(wb_rd==ex_rs2);
wire w_hazard_ld_extra1 = (extra_RegWr)&&(extra_rd!= 5'b00000)&&(extra_rd==ex_rs1);
wire w_hazard_ld_extra2 = (extra_RegWr)&&(extra_rd!= 5'b00000)&&(extra_rd==ex_rs2);

always @(*)
  begin
   // First ALU
    if (w_hazard1a || (w_hazard1a && mem_MemWr))   // EX hazard
      begin
        ForwardASel = 2'b10; // The first ALU operand is forwarded from the prior ALU result; type 1a p.296
      end
    else if (w_hazard2a || (w_hazard2a && wb_MemRd) /*|| (w_hazard_ld_extra1 && extra_MemRd)*/)       // MEM hazard
      begin
        ForwardASel = 2'b01; // The first ALU operand is forwarded from DataMem or an earlier ALU result; type 2a p.296
      end
    else ForwardASel = 2'b00; // The first ALU operand comes from the Register File: no data hazard occurs
	 
   // Second ALU
	 if (w_hazard1b || (w_hazard1b && mem_MemWr))   // EX hazard
      begin
        ForwardBSel = 2'b10; // The second ALU operand is forwarded from the prior ALU result; type 1b p.296
      end
    else if (w_hazard2b || (w_hazard2b && wb_MemRd) /*|| (w_hazard_ld_extra2 && extra_MemRd)*/)       // MEM hazard
      begin
        ForwardBSel = 2'b01; // The second ALU operand is forwarded from DataMem or an earlier ALU result; type 2b p.296
      end
    else ForwardBSel = 2'b00; // The second ALU operand comes from the Register File: no data hazard occurs
  end
endmodule
