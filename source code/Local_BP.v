//module readmemh_tb (
//`default_nettype none
module Local_BP(
  input  clk,
  input  rst,
  input  taken,
  input  [31:0] pc_in,
  input         update,
  input  [31:0] pc_ex,
  input         BTB_hit,
  output [1:0]  temp,
     //output [11:0] o_LPT_index,
	  //output [11:0] o_LPT_index_update,
  output [1:0]  o_LBP_predict_temp,
  output        o_LBP_predict
);
wire [1:0] pred_state;
assign temp = pred_state;
Local
(
    .pc_in (pc_in),
	 .clk (clk),
	 .pc_ex (pc_ex),
	 .LBP_predict_update (pred_state),
	 .update (update),
    .actual (taken),
	 .BTB_hit (BTB_hit),
	   // .o_LPT_index (o_LPT_index),
	    //.o_LPT_index_update (o_LPT_index_update),
	 .LBP_predict_temp (o_LBP_predict_temp),
	 .LBP_predict (o_LBP_predict)
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

//----------------------------- Local---------------------------------------------------------------
module Local
(
    input  [31:0] pc_in,
	 input         clk,
	 input  [31:0] pc_ex,
	 input  [1:0]  LBP_predict_update,
	 input         update,
    input         actual,
	 input         BTB_hit,
	 //output [11:0]  o_LPT_index,
	 //output [11:0]  o_LPT_index_update,
	     output [1:0]  LBP_predict_temp,
	 output        LBP_predict
);

/////// Local BP Parameter ////////
parameter LOCAL_LHT_INDEX = 12;
parameter LOCAL_HISTORY_LENGTH = 10;
parameter LOCAL_LPT_INDEX = 10;

reg [LOCAL_HISTORY_LENGTH-1:0]	LHT [2**LOCAL_LHT_INDEX-1:0]; // 2D array
reg [1:0]	LPT	[2**LOCAL_LPT_INDEX-1:0];
wire [LOCAL_LHT_INDEX-1:0] LHT_index, LHT_index_update, LPT_index, LPT_index_update;
wire [LOCAL_HISTORY_LENGTH-1:0]	LBHR, LBHR_old;
reg [LOCAL_HISTORY_LENGTH-1:0]	LBHR_reg1,  LBHR_reg2, LBHR_reg3;
wire [1:0] byte_index_mem;
//wire [1:0] LBP_predict_temp;
//wire update,actual;


//assign LHT_index = pc_in[LOCAL_LHT_INDEX+1:2];
assign LBHR = LHT[pc_in[LOCAL_LHT_INDEX+1:2]];
always @(negedge clk)
  begin
	   LBHR_reg1 <= LBHR; 
  end
always @(negedge clk)
  begin
	   LBHR_reg2 <= LBHR_reg1; 
  end

assign LBHR_old = LBHR_reg2;
assign LHT_index_update = pc_ex[LOCAL_LHT_INDEX+1:2];
assign LPT_index = pc_in[LOCAL_LPT_INDEX+1:2] ^ LBHR;						// 	ignore 2 LSB bit (Byte index)
assign LPT_index_update = pc_ex[LOCAL_LPT_INDEX+1:2] ^ LBHR_old; 
assign byte_index_mem = pc_ex[1:0];

//assign o_LPT_index = LPT_index; 
//assign o_LPT_index_update = LPT_index_update;

always @ (negedge clk) 
  begin
      if((byte_index_mem == 2'b00)&&(update))
		    LHT[LHT_index_update] <= {LBHR_old[LOCAL_HISTORY_LENGTH-2:0], actual};
  end
 
always @(negedge clk)
  begin
      if((byte_index_mem == 2'b00)&&(update))
	       LPT[LPT_index_update] <= LBP_predict_update; // from FSM
  end

/*always @ (negedge clk) 
  begin
    if(update)
		LBP_predict = LPT[LPT_index][1];
		//LBP_predict = LBP_predict_temp[1];
  end*/
 
  /*always @ (negedge clk) 
  begin
    if (BTB_hit)
		LBP_predict = LPT[LPT_index][1];
  end*/
  
  
assign	LBP_predict_temp = LPT[LPT_index];	
assign   LBP_predict = (BTB_hit) ? LBP_predict_temp[1] : 0; 
//assign   LBP_predict = LPT[LPT_index][1];
endmodule 
//--------------------------------------------------------------------------------------------------------

