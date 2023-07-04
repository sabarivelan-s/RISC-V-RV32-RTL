module msrv32_pc (
  input rst_in,
  input [1:0] pc_src_in,
  input [31:0] epc_in,
  input trap_address_in,
  input branch_taken_in,
  input [31:1] iaddr_in,
  input ahb_ready_in,
  input [31:0] pc_in,
  output reg [31:0] iaddr_out,
  output [31:0] pc_plus_4_out,
  output misaligned_instr_logic_out,
  output reg [31:0] pc_mux_out
);

  parameter BOOT_ADDRESS = 32'b0;

  wire [31:0] next_pc;

  assign pc_plus_4_out = pc_in + 32'h00000004;
  assign next_pc = (branch_taken_in) ? {iaddr_in[31:1], 1'b0} : pc_plus_4_out;
  assign misaligned_instr_logic_out = branch_taken_in & next_pc[1];

  always @*
  begin
    case (pc_src_in)
      2'b00: pc_mux_out = BOOT_ADDRESS;
      2'b01: pc_mux_out = epc_in;
      2'b10: pc_mux_out = trap_address_in;
      2'b11: pc_mux_out = next_pc;
      default: pc_mux_out = next_pc;
    endcase
  end

  always @*
  begin
    if (rst_in)
      iaddr_out = BOOT_ADDRESS;
    else if (ahb_ready_in)
      iaddr_out = pc_mux_out;
  end

endmodule
