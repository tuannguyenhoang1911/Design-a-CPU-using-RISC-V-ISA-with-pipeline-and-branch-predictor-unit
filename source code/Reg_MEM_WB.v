module Reg_MEM_WB(
	input				   clk,
	input				   rst,
	input				   mem_MemtoReg,  // from the output of Reg EX/MEM to control Mux after DataMem
	input				   mem_RegWr   ,  // from the output of Reg EX/MEM to write to Reg File
	input	     [4:0]	mem_rd      ,  // ID -> IF/ID reg -> ID/EX reg -> EX/MEM Reg -> MEM/WB Reg 
	input             mem_MemRd   ,
	input	     [31:0]	datamem  	,  // from the output of readdata of DataMem 
	input      [31:0] dataALU		,  // ALU result -> EX/MEM Reg -> MEM/WB Reg
	input      [2:0]  mem_Load_sel,  // ALU result -> EX/MEM Reg -> MEM/WB Reg
	output reg [31:0]	wb_dataALU	,
	output reg [31:0]	wb_datamem	,
	output reg			wb_memtoreg	,
	output reg			wb_RegWr  	,
	output reg      	wb_MemRd  	,
	output reg [2:0]	wb_Load_sel	,
	output reg [4:0]	wb_rd
);
always @ (negedge clk) begin
	if (rst) begin
		wb_dataALU  <= 0;
		wb_datamem  <= 0;
		wb_memtoreg <= 0;
		wb_RegWr		<= 0;
		wb_rd			<= 0;
		wb_MemRd    <= 0;
		wb_Load_sel <= 0;
	end
	else begin
		wb_dataALU	<= dataALU;
		wb_datamem	<= datamem;
		wb_memtoreg	<= mem_MemtoReg;
		wb_RegWr		<= mem_RegWr;
		wb_rd			<= mem_rd;
		wb_MemRd    <= mem_MemRd;
		wb_Load_sel <= mem_Load_sel;
	end	
end
endmodule
