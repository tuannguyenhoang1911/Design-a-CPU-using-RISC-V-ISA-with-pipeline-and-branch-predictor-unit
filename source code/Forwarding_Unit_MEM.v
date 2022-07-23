// resolve data hazard when storing data into DataMem
module Forwarding_Unit_MEM (
      //input  wire [4:0]  ex_rs1     , // from Reg_ID_EX
      input  wire [4:0]  mem_rs2    , // from Reg_EX_MEM
      //input  wire [4:0]  mem_rd     , // from Reg_EX_MEM
      input  wire [4:0]  wb_rd      , // from Reg_MEM_WB
      //input              mem_RegWr  , // from Reg_EX_MEM
      //input              wb_RegWr   , // from Reg_MEM_WB
      input              mem_MemRd  , // from Reg_EX_MEM
		input              mem_MemWr  , // from Reg_EX_MEM
      output reg     ForwardStoreSel
      //output reg  [1:0]  ForwardBSel 
  );
  
wire w_hazard = (wb_rd != 5'b00000) && (wb_rd==mem_rs2) && mem_MemWr;

always @(*)
  begin
   // First ALU
    if (w_hazard)   
      begin
        ForwardStoreSel = 1'b1; 
      end
    else        
      begin
        ForwardStoreSel = 1'b0; // No Data Hazard
      end
  end
endmodule
