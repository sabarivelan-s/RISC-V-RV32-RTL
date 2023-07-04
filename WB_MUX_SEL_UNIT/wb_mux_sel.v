module msrv32_wb_mux_sel_unit (
  input alu_src_reg_in,
  input [2:0] wb_mux_sel_reg_in,
  input [31:0] alu_result_in,
  input lu_output,
  input [31:0] imm_reg_in,
  input [31:0] iadder_out_reg_in,
  input csr_data_in,
  input [31:0] pc_plus_4_reg_in,
  input [31:0] rs2_reg_in,
  output reg [31:0] wb_mux_out,
  output [31:0] alu_2nd_src_mux_out
);
  
  parameter WB_ALU = 3'b000, WB_LU = 3'b001, WB_IMM = 3'b010, WB_IADDER_OUT = 3'b011, WB_CSR = 3'b100, WB_PC_PLUS = 3'b101;
  
  assign alu_2nd_src_mux_out = alu_src_reg_in ? rs2_reg_in : imm_reg_in;
  
  always @(*)
  begin
    case (wb_mux_sel_reg_in)
      WB_ALU:         wb_mux_out = alu_result_in;
      WB_LU:          wb_mux_out = lu_output;
      WB_IMM:         wb_mux_out = imm_reg_in;
      WB_IADDER_OUT:  wb_mux_out = iadder_out_reg_in;
      WB_CSR:         wb_mux_out = csr_data_in;
      WB_PC_PLUS:     wb_mux_out = pc_plus_4_reg_in;
      default:        wb_mux_out = alu_result_in;
    endcase
  end
  
endmodule
