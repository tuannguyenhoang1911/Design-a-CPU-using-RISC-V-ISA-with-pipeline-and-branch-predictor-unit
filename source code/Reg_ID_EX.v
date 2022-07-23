module Reg_ID_EX (
  //Input 
  input  wire        clk         ,
  input  wire        rst         ,
  //input  wire [31:0] id_inst     ,  // output of reg IF/ID
  input  wire [31:0] id_pc       ,  // output of reg IF/ID
  input  wire [31:0] id_DataA    ,  // output of Register File: readdata1
  input  wire [31:0] id_DataB    ,  // output of Register File: readdata2
  input  wire [4:0]  id_rd       ,  // output of Instruction Decode
  input  wire [4:0]  id_rs1      ,  // output of Instruction Decode
  input  wire [4:0]  id_rs2      ,  // output of Instruction Decode
  //input       [2:0]  id_type     ,  // output of Instruction Decode
  input              id_Branch   ,  // output of Control Unit to notify B-type instruction
  input              id_Jump     ,  // output of Control Unit to notify J-type instruction
  input              id_PCspecial,  // output of Control Unit to notify jalr instruction
  input       [1:0]  id_ALUSrc   ,  // output of Control Unit to select 2nd operand of ALU
  input       [1:0]  id_Asel     ,  // output of Control Unit to select 1st operand of ALU
  input              id_MemRd    ,  // output of Control Unit to read from DataMem
  input              id_MemWr    ,  // output of Control Unit to write to DataMem
  input              id_RegWr    ,  // output of Control Unit to write to Register File
  input              id_MemtoReg ,  // output of Control Unit to control Mux after DataMem
  input       [3:0]  id_ALUOp    ,  // output of Control Unit to select ALU
  input       [1:0]  id_BrOp     ,  // output of Control Unit to select type of Branch
  input       [2:0]  id_Load_sel ,  // output of Control Unit to select type of Load
  input       [1:0]  id_Store_sel,  // output of Control Unit to select type of Store
  input       [31:0] id_imm      ,  // output of ImmGen
  input              id_predicted_bit,
  //output                       
  //output reg  [31:0] ex_inst     ,
  output reg  [31:0] ex_pc       ,
  output reg  [31:0] ex_DataA    ,
  output reg  [31:0] ex_DataB    ,
  output reg  [4:0]  ex_rd       ,
  output reg  [4:0]  ex_rs1      ,
  output reg  [4:0]  ex_rs2      ,
  //output reg  [2:0]  ex_type     ,
  output reg         ex_Branch   ,
  output reg         ex_Jump     ,
  output reg         ex_PCspecial,
  output reg  [1:0]  ex_ALUSrc   ,
  output reg  [1:0]  ex_Asel     ,
  output reg         ex_MemRd    ,
  output reg         ex_MemWr    ,
  output reg         ex_RegWr    ,
  output reg         ex_MemtoReg , 
  output reg  [3:0]  ex_ALUOp    ,
  output reg  [1:0]  ex_BrOp     , 
  output reg  [2:0]  ex_Load_sel , 
  output reg  [1:0]  ex_Store_sel,
  output reg  [31:0] ex_imm,     
  output reg         ex_predicted_bit
);

  always @ (negedge clk) begin
    if (rst) begin
      //ex_inst   	 <= 0;
      ex_pc  	 	 <= id_pc;
      ex_DataA  	 <= 0;
      ex_DataB  	 <= 0;
      ex_rd 	 	 <= 0;
      ex_rs1  	 <= 0;
      ex_rs2  	 <= 0;
      //ex_type    <= 0;
		ex_Branch 	 <= 0;
		ex_Jump		 <= 0;
		ex_PCspecial <= 0;
		ex_ALUSrc 	 <= 0;
		ex_Asel      <= 0;
      ex_MemRd  	 <= 0;
		ex_MemWr  	 <= 0;
      ex_RegWr  	 <= 0;
      ex_MemtoReg  <= 0;
      ex_ALUOp     <= 0;
      ex_BrOp		 <= 0;
		ex_Load_sel  <= 0;
		ex_Store_sel <= 0;
		ex_imm 		 <= 0;
		ex_predicted_bit <= 0;
    end else begin
      //ex_inst   	 <= id_inst;
      ex_pc  	 	 <= id_pc;
      ex_DataA  	 <= id_DataA;
      ex_DataB  	 <= id_DataB;
      ex_rd 	 	 <= id_rd;
      ex_rs1  	 <= id_rs1;
      ex_rs2  	 <= id_rs2;
      //ex_type    <= id_type;
		ex_Branch 	 <= id_Branch;
		ex_Jump		 <= id_Jump;
		ex_PCspecial <= id_PCspecial;
		ex_ALUSrc 	 <= id_ALUSrc;
		ex_Asel		 <= id_Asel;
      ex_MemRd  	 <= id_MemRd;
		ex_MemWr  	 <= id_MemWr;
      ex_RegWr  	 <= id_RegWr;
      ex_MemtoReg  <= id_MemtoReg;
      ex_ALUOp     <= id_ALUOp;
      ex_BrOp		 <= id_BrOp;
		ex_Load_sel  <= id_Load_sel;
		ex_Store_sel <= id_Store_sel;
		ex_imm 		 <= id_imm;
		ex_predicted_bit <= id_predicted_bit;
    end
  end
endmodule 