module module_32_D_FF (
    input i_clr,
    input PC_remain,
    input [31:0] i_D,
	 input i_clk,
	 output [31:0] o_Q
);
wire [31:0] w_Q;
genvar             m;
  generate 
      for (m=0; m<=31; m=m+1) 
      begin : D_FF
          mini_D_FF blk( 
              .clr (i_clr),
              .PC_remain (PC_remain),
				  .D (i_D[m]),
				  .clk (i_clk),
			     .Q (w_Q[m])	  
              );
      end
  endgenerate
assign o_Q = w_Q;
endmodule

module mini_D_FF (
    input clr,
    input PC_remain,
    input D,
	 input clk,
	 output Q
);
reg r_Q, PC_remain_reg;

/*always @(negedge clk) begin
PC_remain_reg <= PC_remain;
end*/

always @(posedge clk or posedge clr)
begin
    
    if (clr) r_Q <= 0;
	 else
	 begin
	     if (PC_remain) r_Q <= r_Q;
		  else r_Q <= D;
    end	
end
assign Q = r_Q;
endmodule
