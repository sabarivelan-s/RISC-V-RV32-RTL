module msrv32_immediate_adder(input [31:0]pc_in,
				input [31:0]rs1_in,
				input iadder_src_in,
				input [31:0]imm_in,
				output reg [31:0]iadder_out);

//assign iadder_out = iadder_src_in?(rs1_in+imm_in):(pc_in+imm_in);
always@(*)
begin
if(iadder_src_in)
iadder_out=imm_in+rs1_in;
else
iadder_out=imm_in+pc_in;
end

endmodule 
