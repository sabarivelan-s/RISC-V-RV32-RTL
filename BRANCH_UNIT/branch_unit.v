module msrv32_branch_unit(input [31:0]rs1_in,rs2_in,
			input [4:0]opcode_in,
			input [2:0]funct3_in,
			output reg branch_taken_out);
parameter jal    = 5'b110_11;
parameter jalr   = 5'b110_01;
parameter branch = 5'b110_00;
reg t;
always @(*)
begin
case(opcode_in)
jal: branch_taken_out=1'b1;
jalr: branch_taken_out=1'b1;
branch: branch_taken_out = t;
default: branch_taken_out=1'b0;
endcase
end

always @(*)
begin
if (opcode_in==branch)
begin
case(funct3_in)
3'b000: t=(rs1_in==rs2_in)?1'b1:1'b0;
3'b001: t=(rs1_in!=rs2_in)?1'b1:1'b0;
3'b100: t=(rs1_in[31]^rs2_in[31])? rs1_in[31]:rs1_in<rs2_in;
3'b101: t=(rs1_in[31]^rs2_in[31])?!(rs1_in[31]):!(rs1_in<rs2_in);
3'b110: t=(rs1_in<rs2_in)?1'b1:1'b0;
3'b111: t=(rs1_in>=rs2_in)?1'b1:1'b0;
default: t=1'b0;
endcase
end
else
t = 1'b0;
end
endmodule

