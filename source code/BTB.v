module BTB(
	input								clk,
	input								rst,          
	input								br_update,      //signal for informing updating in BTB
	input			[31:0]			target_pc,      //target address after execute state 
	input			[31:0]			pc_in,          //input address to BTB
	input			[31:0]			pc_ex,          //address of the branch instruction 
	output      [31:0]			target_predict, //predict address from BTB when having input address
	output       					hit             //signal for identifying stored address in BTB
);
//Parameters
parameter BTB_TAG_LENGTH = 22;
parameter PC_LENGTH=32;

//Declaration
reg [BTB_TAG_LENGTH+PC_LENGTH-1:0] BTB_array [0:255];  
reg [0:255] valid;
wire avai_bit;
wire valid_bit;

//Program
always @ (posedge clk or posedge rst)
	begin
	   if (rst)
			begin
			    valid <= 0;
			end
		else if ((pc_ex[1:0]==2'b00)&&(br_update))
			begin
				 valid[pc_ex[9:2]]<=1;
			end
	end
always @ (posedge clk)
	begin
		if ((pc_ex[1:0]==2'b00)&&(br_update))
		begin
		    BTB_array[pc_ex[9:2]] <= {pc_ex[31:10],target_pc};
		end
	end
assign target_predict = BTB_array[pc_in[9:2]][31:0];
assign avai_bit = ~|(BTB_array[pc_in[9:2]][53:32] ^ pc_in[31:10]);
assign valid_bit = valid[pc_in[9:2]];
assign hit = valid_bit & avai_bit; 
endmodule
