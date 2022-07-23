//module readmemh_tb (
//`default_nettype none
module Gshare_BP(
  input  clk,
  input  rst,
  input  taken,          // taken or not bit
  input  [31:0] pc_in,
  input         update,  // inform B,J type
  input  [31:0] pc_ex,
  output [9:0]  o_GPT_index,
  output [9:0]  o_GPT_index_update,
  output        Gshare_predict
);
wire [1:0] pred_state;

Gshare
(
    .pc_in (pc_in),
	 .clk (clk),
	 .rst (rst),
	 .pc_ex (pc_ex),
	 .GBP_predict_update (pred_state),
	 .update (update),
    .actual (taken),
	 .Gshare_predict (Gshare_predict)
);

LPT_GPT_2bitPredictor_FSM
(
    .clk (clk),
    .rst (rst),
	 .branch (update),
    .i_taken (taken),
    .o_pred_state (pred_state)
);
endmodule

//----------------------------- Gshare---------------------------------------------------------------
module Gshare
(
    input  [31:0] pc_in,
	 input         clk,
	 input         rst,
	 input  [31:0] pc_ex,
	 input  [1:0]  GBP_predict_update,
	 input         update,
    input         actual,
	 output        Gshare_predict
);

/////// Gshare Parameter /////////
parameter GSHARE_HISTORY_LENGTH = 12;
parameter GSHARE_GPT_INDEX = 10;

reg [GSHARE_HISTORY_LENGTH-1:0]	GBHR, GBHR_reg1, GBHR_reg2; // 1D array
reg [1:0]	GPT	[2**GSHARE_GPT_INDEX-1:0];
wire [GSHARE_GPT_INDEX-1:0] GPT_index, GPT_index_update;
wire [GSHARE_HISTORY_LENGTH-1:0] GBHR_old;
wire [1:0]  GPT_predict_temp;
//wire update,GBP_predict_update, actual;

assign GPT_index = pc_in[GSHARE_GPT_INDEX+1:2] ^ GBHR;						// 	ignore 2 LSB bit (Byte index)
assign GPT_index_update = pc_ex[GSHARE_GPT_INDEX+1:2] ^ GBHR_old; 
//assign byte_index_mem = pc_ex[1:0];

always @(negedge clk or posedge rst)
  begin
		if(rst)
			GBHR <= 1'b0;	
		else if((pc_ex[1:0] == 2'b00)&&(update))
			GBHR <= {GBHR_old[GSHARE_HISTORY_LENGTH-2:0], actual};
		else 
			GBHR <= GBHR;
  end
 
always @ (negedge clk) 
  begin
      if((pc_ex[1:0] == 2'b00)&&(update))
		    GPT[GPT_index_update] <= GBP_predict_update; // from FSM
  end

always @(negedge clk)
  begin
	   GBHR_reg1 <= GBHR; 
  end
always @(negedge clk)
  begin
	   GBHR_reg2 <= GBHR_reg1; 
  end
  
assign	GPT_predict_temp = GPT[GPT_index];	
assign   Gshare_predict = GPT_predict_temp[1];  
assign   GBHR_old = GBHR_reg2;
endmodule 

