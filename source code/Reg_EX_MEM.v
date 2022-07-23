module Reg_EX_MEM (
  //Input from EX
  input  wire        clk           ,
  input  wire        rst           ,
  input  wire        ex_MemRd      , // Control Unit -> Reg_EX_MEM
  input  wire        ex_RegWr      , // Control Unit -> Reg_EX_MEM
  input  wire        ex_MemWr      , // Control Unit -> Reg_EX_MEM
  input  wire        ex_MemtoReg   , // Control Unit -> Reg_EX_MEM
  input  wire        ex_zero       , // ALU -> Reg_EX_MEM
  input  wire        ex_lt         , // ALU -> Reg_EX_MEM
  input  wire [4:0]  ex_rd         , // ID block     -> Reg_EX_MEM
  input  wire [4:0]  ex_rs2        , // Reg ID_EX    -> Reg_EX_MEM
  input  wire [31:0] ex_pc         , // result of 1st CLA
  input  wire [31:0] ex_pc_ori     , // current PC
  input  wire [31:0] ex_readdata2  , // Reg file     -> Reg ID_EX  -> Reg_EX_MEM
  input  wire [1:0]  ex_BrOp       , // Control Unit -> Reg ID_EX  -> Reg_EX_MEM
  input  wire        ex_Branch     , // Control Unit -> Reg ID_EX  -> Reg_EX_MEM
  input  wire        ex_Jump       , // Control Unit -> Reg ID_EX  -> Reg_EX_MEM
  //input  wire        ex_PCspecial  , // Control Unit -> Reg ID_EX 
  input  wire [2:0]  ex_Load_sel   , // Control Unit -> Reg ID_EX  -> Reg_EX_MEM -> Reg Mem/WB
  input  wire [1:0]  ex_Store_sel  , // Control Unit -> Reg ID_EX  -> Reg_EX_MEM -> DataMem
  input  wire [31:0] ex_ALU_result ,
  input  wire        ex_predicted_bit ,
  //Output to MEM                
  output reg         mem_MemRd     ,
  output reg         mem_RegWr     ,
  output reg         mem_MemWr     ,
  output reg         mem_MemtoReg  ,
  output reg         mem_zero      ,
  output reg         mem_lt        ,
  output reg  [4:0]  mem_rd        ,
  output reg  [4:0]  mem_rs2       ,
  output reg  [31:0] mem_pc		  ,
  output reg  [31:0] mem_pc_ori	  ,  
  output reg  [31:0] mem_readdata2 ,
  output reg  [1:0]  mem_BrOp      ,
  output reg         mem_Branch    ,
  output reg         mem_Jump      ,
  //output reg         mem_PCspecial ,
  output reg  [2:0]  mem_Load_sel  , 
  output reg  [1:0]  mem_Store_sel , 
  output reg  [31:0] mem_ALU_result,
  output reg         mem_predicted_bit 
);

  always @ (negedge clk) begin
    if (rst) begin
      mem_MemRd      <= 0;
		mem_RegWr      <= 0;
      mem_MemWr      <= 0;
      mem_MemtoReg   <= 0;
		mem_zero       <= 0;
		mem_lt         <= 0;
      mem_rd         <= 0;
		mem_rs2			<= 0;
      mem_pc         <= ex_pc;
      mem_readdata2  <= 0;
		mem_BrOp       <= 0;
		mem_Branch     <= 0;
		mem_Jump       <= 0;
		//mem_PCspecial  <= 0;
		mem_Load_sel   <= 0;
		mem_Store_sel  <= 0;
      mem_ALU_result <= 0;
    end else if (1) begin
      mem_MemRd      <= ex_MemRd;
		mem_RegWr      <= ex_RegWr;
      mem_MemWr      <= ex_MemWr;
      mem_MemtoReg   <= ex_MemtoReg;
		mem_zero       <= ex_zero;
		mem_lt         <= ex_lt;
      mem_rd         <= ex_rd;
		mem_rs2        <= ex_rs2;
      mem_pc         <= ex_pc;
		mem_pc_ori     <= ex_pc_ori;
      mem_readdata2  <= ex_readdata2;
		mem_BrOp       <= ex_BrOp;
		mem_Branch     <= ex_Branch;
		mem_Jump       <= ex_Jump;
		//mem_PCspecial  <= ex_PCspecial ;
		mem_Load_sel   <= ex_Load_sel  ;
		mem_Store_sel  <= ex_Store_sel ;
      mem_ALU_result <= ex_ALU_result;
		mem_predicted_bit <= ex_predicted_bit;
    end
  end
endmodule
