module msrv32_imm_generator(input [31:7]instr_in,
				input [2:0]imm_type_in,
				output reg [31:0] imm_out);

wire [31:0] i_type,s_type, b_type, u_type, j_type, csr_type;

assign i_type = {{20{instr_in[31]}},instr_in[31:20]};
assign s_type = {{20{instr_in[31]}},instr_in[31:25],instr_in[11:7]};
assign b_type = {{20{instr_in[31]}},instr_in[7],instr_in[30:25],instr_in[11:8],1'b0};
assign u_type = {instr_in[31:12],12'h000};
assign j_type =  {{12{instr_in[31]}},instr_in[19:12],instr_in[20],instr_in[30:21],1'b0};
assign csr_type = {27'b0,instr_in[19:15]};

always @(*)
begin
case(imm_type_in)
3'b000: imm_out = i_type;
3'b001: imm_out = i_type;
3'b010: imm_out = s_type;
3'b011: imm_out = b_type;
3'b100: imm_out = u_type;
3'b101: imm_out = j_type;
3'b110: imm_out = csr_type;
3'b111: imm_out = i_type;
default: imm_out = i_type;
endcase
end

endmodule 