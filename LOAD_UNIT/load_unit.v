module msrv32_load_unit (
  input ahb_resp_in,
  input [31:0] ms_riscv32_mp_dmdata_in,
  input [1:0] iadder_out_1_to_0_in,
  input load_unsigned_in,
  input [1:0] load_size_in,
  output reg [31:0] lu_output_out
);
  
  wire [15:0] half_ext;
  wire [23:0] byte_ext;
  reg [7:0] data_byte;
  reg [15:0] data_half;
	
  always @(*)
  begin
    if (!ahb_resp_in)
    begin
      case (load_size_in)
        2'b00: lu_output_out = {byte_ext, data_byte};
        2'b01: lu_output_out = {half_ext, data_half};
        default: lu_output_out = ms_riscv32_mp_dmdata_in;
      endcase
    end
    else
      lu_output_out = 32'dZ;
  end
  
  always @(*)
  begin
    case (iadder_out_1_to_0_in)
      2'b00: data_byte = ms_riscv32_mp_dmdata_in[7:0];
      2'b01: data_byte = ms_riscv32_mp_dmdata_in[15:8];
      2'b10: data_byte = ms_riscv32_mp_dmdata_in[23:16];
      2'b11: data_byte = ms_riscv32_mp_dmdata_in[31:24];
    endcase
  end
  
  always @(*)
  begin
    case (iadder_out_1_to_0_in[1])
      1'b0: data_half = ms_riscv32_mp_dmdata_in[15:0];
      1'b1: data_half = ms_riscv32_mp_dmdata_in[31:16];
    endcase
  end
  
  assign byte_ext = load_unsigned_in ? 24'b0 : {24{data_byte[7]}};
  assign half_ext = load_unsigned_in ? 16'b0 : {16{data_half[15]}};
  
endmodule
