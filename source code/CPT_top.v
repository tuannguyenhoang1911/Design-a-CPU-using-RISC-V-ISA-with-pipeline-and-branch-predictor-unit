//`default_nettype none
module CPT_top(
  // Global Signals
  input  clk,
  input  rst,
  input  taken,
  input  Gshare,
  input  Local,
  input  [9:0]  GPT_index,
  input  [9:0]  GPT_index_update,
  //input  [31:0] pc_in,
  input         update,
  input  [31:0] pc_ex,
  output        GshareBP_or_LocalBP
);
wire [1:0] pred_state;

CPT
(
    //.pc_in (pc_in),
	 .clk (clk),
	 .rst (rst),
	 .pc_ex (pc_ex),
	 .CPT_predict_update (pred_state),
	 .update (update),
	 .GPT_index (GPT_index),
	 .GPT_index_update (GPT_index_update),
	 .CPT_predict (GshareBP_or_LocalBP)
);

CPT_FSM(
    // Globel signal
    .clk (clk),
    .rst (rst),
    .branch (update),
    // Inputs
    .Gshare (Gshare), // from Gshare_predict (output of Gshare unit
    .Local (Local), // from LBP_predict
    .taken (taken),
    // Outputs
    .o_CPT_predict (pred_state)  
);
endmodule

module CPT
(
    //input  [31:0] pc_in,
	 input         clk,
	 input         rst,
	 input  [31:0] pc_ex,
	 input  [1:0]  CPT_predict_update,
	 input         update,
    //input         actual,
	 input  [9:0]  GPT_index,
	 input  [9:0]  GPT_index_update,
	 output        CPT_predict
);

/////// Gshare Parameter /////////
parameter GSHARE_HISTORY_LENGTH = 12;
parameter GSHARE_GPT_INDEX = 10;

//reg [GSHARE_HISTORY_LENGTH-1:0]	CPT_index; // 1D array
reg [1:0]	CPT	[2**GSHARE_GPT_INDEX-1:0];
wire [GSHARE_GPT_INDEX-1:0] CPT_index;
//wire [GSHARE_HISTORY_LENGTH-1:0] GBHR_old;
wire [1:0]  CPT_predict_temp;
//wire update,GBP_predict_update, actual;

assign CPT_index = GPT_index;						// 	use same of Gshare
//assign GPT_index_update = pc_ex[GSHARE_GPT_INDEX+1:2] ^ GBHR_old; 
//assign byte_index_mem = pc_ex[1:0];

/*always @(posedge clk or posedge rst)
  begin
		if(rst)
			CPT <= 1'b0;	
		else if((byte_index_mem == 2'b00)&&(update))
			CPT[GPT_index_update] <= CPT_predict_update;
		else 
			GBHR <= GBHR;
  end*/
 
always @ (negedge clk) 
  begin
      if((pc_ex[1:0] == 2'b00)&&(update))
		    CPT[GPT_index_update] <= CPT_predict_update; // from FSM
  end
  
assign	CPT_predict_temp = CPT[CPT_index];	
assign   CPT_predict = CPT_predict_temp[1];  

endmodule 

module CPT_FSM(
    // Globel signal
    input  clk,
    input  rst,
    input  branch,
    // Inputs
    input  Gshare,
    input  Local,
    input  taken,
    // Outputs
    output [1:0] o_CPT_predict
    //output [1:0] pred_state
);

// Local parameters
localparam SGshare = 2'b11;
localparam WGshare = 2'b10;
localparam WLocal = 2'b01;
localparam SLocal = 2'b00;

// Local Signals
reg [1:0] state;
reg [1:0] next_state;
reg o_CPT;
wire [1:0] o_CPT_predict_temp;

// Combinational Logic
always begin
    next_state = state;

    case(state)
        SGshare: begin
            if ((Gshare ^ taken) & (~(Local ^ taken)))
                next_state = WGshare;
        end
        WGshare: begin
            if ((Gshare ^ taken) & (~(Local ^ taken)))
                next_state = WLocal;
            else if (~(Gshare ^ taken) & (Local ^ taken))
                next_state = SGshare;
        end
        WLocal: begin
            if ((Gshare ^ taken) & (~(Local ^ taken)))
                next_state = SLocal;
            else if (~(Gshare ^ taken) & (Local ^ taken))
                next_state = WGshare;
        end
        SLocal: begin
            if (~(Gshare ^ taken) & (Local ^ taken))
                next_state = WLocal;
        end
    endcase
end

// Sequential Logic
always @(negedge clk or posedge rst) begin
    if (rst)
        state <= SLocal;
    else
        state <= next_state;
end

// Select predict_bit from Gshare (or Local) depend on FSM
/*always begin
	if (state == 2'b11 || state == 2'b10)
			o_CPT = Gshare;
	else
			o_CPT = Local;
end*/

//Wiring Outputs
//assign o_CPT_predict_temp = state;
//assign o_CPT_predict = o_CPT_predict_temp[1];
assign o_CPT_predict = state;
endmodule 