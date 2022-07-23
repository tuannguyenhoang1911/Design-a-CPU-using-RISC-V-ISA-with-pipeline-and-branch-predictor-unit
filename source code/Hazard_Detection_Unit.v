module Hazard_Detection_Unit (
      //input              clk            ,
      //input              rst            ,
      input  wire[4:0]   id_rs1         , // From Reg IF_ID 
      input  wire[4:0]   id_rs2         , // From Reg IF_ID  
		input  wire[4:0]   id_rd          , // From Reg IF_ID 
      input  wire[4:0]   ex_rd          , // From Reg_ID_EX 
      input              ex_MemRd       , // From Reg_ID_EX 
      output reg         PC_remain      , // -> PC
		output reg         Reg_IF_ID_remain,// -> Reg_IF_ID
		output reg         zero_control     // -> Control Unit    
);
//Instrucion type
parameter NoP     = 7'b0000000;
parameter R       = 7'b0110011;
parameter addi    = 7'b0010011;
parameter lw      = 7'b0000011;
parameter sw      = 7'b0100011;
parameter SB      = 7'b1100011;
parameter jalr    = 7'b1100111;
parameter jal     = 7'b1101111;
parameter auipc   = 7'b0010111;

/*  reg [1:0] cnt0    ;
  reg [1:0] cnt1    ;
  wire      cnt_en0 ;
  reg       cnt_en1 ;
  wire      PCWrite0;
  wire      PCWrite1;*/
//  assign PCWrite = PCWrite0 || PCWrite1;
/*  assign cnt_en0 = ((opcode == SB) || (opcode == jalr)) ? 1 : 0;
  assign PCWrite0= ((cnt0 == 1) || (cnt0 == 2)) ? 0 : 1;
  assign PCWrite1= (cnt1 == 1) ? 0 : 1;
  assign Reg_IF_ID_Data = ((cnt0 == 1) || (cnt0 == 2)) ? 0 : 1;
  always @(posedge clk or posedge rst) begin
    if(rst) begin
      cnt0 <= 0;
    end else begin
      if (cnt_en0) begin
        if (cnt0 < 2) begin
          cnt0 <= cnt0 +1;
        end else cnt0 <= 0;
      end 
      else cnt0 <= 0;
    end
  end
  always @(posedge clk or posedge rst) begin
    if(rst) begin
      cnt1 <= 0;
    end else begin
      if (cnt_en1) begin
        if (cnt1 < 1) begin
          cnt1 <= cnt1 +1;
        end else cnt1 <= 0;
      end 
      else cnt1 <= 0;
    end
  end*/
  always @(*) 
  begin
    if((ex_MemRd) && (ex_rd != 0) && ((ex_rd == id_rs1) || (ex_rd == id_rs2) || (ex_rd == id_rd)))
	   begin
        PC_remain        <= 1'b1; 
		  Reg_IF_ID_remain <= 1'b1;
		  zero_control     <= 1'b1;   
      end
    else  
	   begin
        PC_remain        <= 1'b0; 
		  Reg_IF_ID_remain <= 1'b0;
		  zero_control     <= 1'b0;
      end
  end
endmodule
