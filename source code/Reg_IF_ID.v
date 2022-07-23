module Reg_IF_ID (
  input  wire        clk    ,
  input  wire        rst    ,
  input  wire        Reg_IF_ID_remain,
  input  wire        if_predicted_bit,
  input  wire [31:0] if_pc  ,
  input  wire [31:0] if_inst,
  output reg  [31:0] id_pc  ,
  output reg         id_predicted_bit,
  output reg  [31:0] id_inst 
);
  always @ (posedge clk) 
  begin
    if (rst) begin
      id_pc   <= 0;
      id_inst <= 0;
		id_predicted_bit <= 0;
    end 
	 else if (Reg_IF_ID_remain) 
	   begin
	     id_pc   <= id_pc;  // remain
        id_inst <= id_inst;// remain
		  //o_predicted_bit <= o_predicted_bit
		end
	 else begin
      id_pc   <= if_pc;
      id_inst <= if_inst;
		id_predicted_bit <= if_predicted_bit;
		end  
  end
endmodule 