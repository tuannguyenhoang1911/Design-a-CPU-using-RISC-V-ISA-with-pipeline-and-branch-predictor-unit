module	Branch_Predictor_Unit
(
    input 	clk,
	 input   rst,
	 input   i_update,     // inform B,J type
	 input   i_taken,
	 input 	[PC_LENGTH-1:0]	i_pc_ex,
	 input 	[PC_LENGTH-1:0]   i_pc_in,
	 input 	[PC_LENGTH-1:0]   i_target_pc,	 
	 output 	o_pc_sel,       // PC + 4 or BJ
	 output  [1:0] temp,
	 //output  pc_fix,
	 output	[PC_LENGTH-1:0]	o_target_predict,
   	// output [11:0] w_LPT_index,
	    //output [11:0] w_LPT_index_update,
output [1:0] o_LBP_predict_temp,
	 output  o_predict_bit_BP
);
parameter PC_LENGTH = 32;
parameter GSHARE_GPT_INDEX = 10;
wire [GSHARE_GPT_INDEX-1:0] w_GPT_index, w_GPT_index_update;
wire [1:0] w_LBP_predict;
wire w_Gshare_predict;
wire w_BTB_hit, w_GshareBP_or_LocalBP, w_taken;

BTB(
	.clk            (clk),
	.rst            (rst),          
	.br_update      (i_update),         //signal for informing updating in BTB
	.target_pc      (i_target_pc),      //target address after execute state 
	.pc_in          (i_pc_in),          //input address to BTB
	.pc_ex          (i_pc_ex),          //address of the branch instruction 
	.target_predict (o_target_predict), //predict address from BTB when having input address
	.hit            (w_BTB_hit)         //signal for identifying stored address in BTB
);

Gshare_BP(
  .clk                (clk),
  .rst                (rst),
  .taken              (i_taken),          // taken or not taken
  .pc_in              (i_pc_in),
  .update             (i_update),          // inform B,J type
  .pc_ex              (i_pc_ex),
  .o_GPT_index        (w_GPT_index),
  .o_GPT_index_update (w_GPT_index_update),
  .Gshare_predict     (w_Gshare_predict)
);

Local_BP(
  .clk         (clk),
  .rst         (rst),
  .taken       (i_taken),
  .pc_in       (i_pc_in),
  .update      (i_update),
  .pc_ex       (i_pc_ex),
  .BTB_hit     (w_BTB_hit),
  .temp (temp),
  	  //  .o_LPT_index (w_LPT_index),
	   // .o_LPT_index_update (w_LPT_index_update),
		.o_LBP_predict_temp (o_LBP_predict_temp),
  .o_LBP_predict (w_LBP_predict)
);
//wire [11:0] w_LPT_index,w_LPT_index_update;
CPT_top(
  // Global Signals
  .clk                 (clk),
  .rst                 (rst),
  .taken               (i_taken),
  .Gshare              (w_Gshare_predict),
  .Local               (w_LBP_predict),
  .GPT_index           (w_GPT_index),
  .GPT_index_update    (w_GPT_index_update),
  //input  [31:0] pc_in,
  .update              (i_update),
  .pc_ex               (i_pc_ex),
  .GshareBP_or_LocalBP (w_GshareBP_or_LocalBP)
);
assign w_taken = (w_GshareBP_or_LocalBP)? w_Gshare_predict : w_LBP_predict;
assign o_predict_bit_BP = w_taken;
assign o_pc_sel = w_BTB_hit & w_taken ;
endmodule
