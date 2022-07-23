module LPT_GPT_2bitPredictor_FSM(
  // Global Signals
  input  clk,
  input  rst,
  input  branch,
  // Inputs
  input  i_taken,
  
  // Outputs
  output reg [1:0] o_pred_state
);

  // Local parameters
  localparam SNT = 2'b00;
  localparam WNT = 2'b01;
  localparam WTK = 2'b10;
  localparam STK = 2'b11;

  // Local Signals
  reg [1:0] state;
  reg [1:0] next_state;

  // Combinational Logic
  always begin
    next_state = state;

    case (state)
      SNT: begin
		  if (branch)
          if (i_taken)
            next_state = WNT;
      end
      WNT: begin
		  if (branch)
          if (i_taken)
            next_state = WTK;
          else
             next_state = SNT;
      end
      WTK: begin
		  if (branch)
          if (i_taken)
            next_state = STK;
          else
            next_state = WNT;
      end
      STK: begin
		  if (branch)
          if (!i_taken)
            next_state = WTK;
	   end
    endcase
  end

  // Sequential Logic
always @(negedge clk or posedge rst) begin
  if (rst)
    state <= SNT;
  else  
    state <= next_state;
end

  // Wiring Outputs
always @(negedge clk) 
  begin
      o_pred_state = state;
  end
endmodule 
