module msrv32_store_unit (
  input [1:0] funct3_in,
  input [31:0] iadder_in, rs2_in,
  input mem_wr_req_in, ahb_ready_in,
  output [31:0] ms_riscv32_mp_dmaddr_out,
  output reg [31:0] ms_riscv32_mp_dmdata_out,
  output reg [3:0] ms_riscv32_mp_dmwr_mask_out,
  output ms_riscv32_mp_dmwr_req_out,
  output reg [1:0] ahb_htrans_out
);
  
  reg [31:0] byte_ad, half_ad;
  reg [3:0] byte_mask, half_mask;

  assign ms_riscv32_mp_dmaddr_out = {iadder_in[31:2], 2'b00};
  assign ms_riscv32_mp_dmwr_req_out = mem_wr_req_in;
  
  always @(*)
  begin
    case (iadder_in[1:0])
      2'b00: byte_ad = {24'b0, rs2_in[7:0]};
      2'b01: byte_ad = {16'b0, rs2_in[7:0], 8'b0};
      2'b10: byte_ad = {8'b0, rs2_in[7:0], 16'b0};
      2'b11: byte_ad = {rs2_in[7:0], 24'b0};
      default: byte_ad = 32'b0; 
    endcase
  end
  
  always @(*)
  begin
    case (iadder_in[1])
      1'b0: half_ad = {16'b0, rs2_in[15:0]};
      1'b1: half_ad = {rs2_in[15:0], 16'b0};
      default: half_ad = 32'b0; 
    endcase
  end
  
  always @(*)
  begin
    if (ahb_ready_in)
    begin
      case (funct3_in)
        2'b00: ms_riscv32_mp_dmdata_out = byte_ad;
        2'b01: ms_riscv32_mp_dmdata_out = half_ad;
        default: ms_riscv32_mp_dmdata_out = rs2_in;
      endcase
      ahb_htrans_out = 2'b10;
    end
    else
      ahb_htrans_out = 2'b00; 
  end
  
  always @(*)
  begin
    case (iadder_in[1:0])
      2'b00: byte_mask = {3'b0, mem_wr_req_in};
      2'b01: byte_mask = {2'b0, mem_wr_req_in, 1'b0};
      2'b10: byte_mask = {1'b0, mem_wr_req_in, 2'b0};
      2'b11: byte_mask = {mem_wr_req_in, 3'b0};
      default: byte_mask = {4{mem_wr_req_in}};
    endcase 
  end
  
  always @(*)
  begin
    case (iadder_in[1])
      1'b0: half_mask = {2'b0, {2{mem_wr_req_in}}};
      1'b1: half_mask = {{2{mem_wr_req_in}}, 2'b0};
      default: half_mask = {4{mem_wr_req_in}}; 
    endcase
  end
  
  always @(*)
  begin
    case (funct3_in)
      2'b00: ms_riscv32_mp_dmwr_mask_out = byte_mask;
      2'b01: ms_riscv32_mp_dmwr_mask_out = half_mask;
      default: ms_riscv32_mp_dmwr_mask_out = {4{mem_wr_req_in}};
    endcase
  end
  
endmodule
