
module msrv32_reg_block_2_tb;

  // Inputs
  reg [4:0] rd_addr_in;
  reg [11:0] csr_addr_in;
  reg [31:0] rs1_in, rs2_in, pc_in, pc_plus_4_in;
  reg [3:0] alu_opcode_in;
  reg [1:0] load_size_in;
  reg load_unsigned_in, alu_src_in, csr_wr_en_in, rf_wr_en_in;
  reg [2:0] wb_mux_sel_in, csr_op_in;
  reg [31:0] imm_in, iadder_out_in;
  reg branch_taken_in, rst_in;
  reg clk_in = 0;

  // Outputs
  wire [4:0] rd_addr_reg_out;
  wire [11:0] csr_addr_reg_out;
  wire [31:0] rs1_reg_out, rs2_reg_out, pc_reg_out, pc_plus_4_reg_out;
  wire [3:0] alu_opcode_reg_out;
  wire [1:0] load_size_reg_out;
  wire load_unsigned_reg_out, alu_src_reg_out, csr_wr_en_reg_out, rf_wr_en_reg_out;
  wire [2:0] wb_mux_sel_reg_out, csr_op_reg_out;
  wire [31:0] imm_reg_out, iadder_out_reg_out;

  // Instantiate the module
  msrv32_reg_block_2 dut (
    .rd_addr_in(rd_addr_in),
    .csr_addr_in(csr_addr_in),
    .rs1_in(rs1_in),
    .rs2_in(rs2_in),
    .pc_in(pc_in),
    .pc_plus_4_in(pc_plus_4_in),
    .alu_opcode_in(alu_opcode_in),
    .load_size_in(load_size_in),
    .load_unsigned_in(load_unsigned_in),
    .alu_src_in(alu_src_in),
    .csr_wr_en_in(csr_wr_en_in),
    .rf_wr_en_in(rf_wr_en_in),
    .wb_mux_sel_in(wb_mux_sel_in),
    .csr_op_in(csr_op_in),
    .imm_in(imm_in),
    .iadder_out_in(iadder_out_in),
    .branch_taken_in(branch_taken_in),
    .rst_in(rst_in),
    .clk_in(clk_in),
    .rd_addr_reg_out(rd_addr_reg_out),
    .csr_addr_reg_out(csr_addr_reg_out),
    .rs1_reg_out(rs1_reg_out),
    .rs2_reg_out(rs2_reg_out),
    .pc_reg_out(pc_reg_out),
    .pc_plus_4_reg_out(pc_plus_4_reg_out),
    .alu_opcode_reg_out(alu_opcode_reg_out),
    .load_size_reg_out(load_size_reg_out),
    .load_unsigned_reg_out(load_unsigned_reg_out),
    .alu_src_reg_out(alu_src_reg_out),
    .csr_wr_en_reg_out(csr_wr_en_reg_out),
    .rf_wr_en_reg_out(rf_wr_en_reg_out),
    .wb_mux_sel_reg_out(wb_mux_sel_reg_out),
    .csr_op_reg_out(csr_op_reg_out),
    .imm_reg_out(imm_reg_out),
    .iadder_out_reg_out(iadder_out_reg_out)
  );

  // Clock generator
  reg clk = 0;
  always #5 clk_in = ~clk_in;

  initial begin
    // Initialize inputs
    rd_addr_in = 5'b00100;
    csr_addr_in = 12'b110011000110;
    rs1_in = 32'b01010101010101010101010101010101;
    rs2_in = 32'b10101010101010101010101010101010;
    pc_in = 32'b00110011001100110011001100110011;
    pc_plus_4_in = 32'b01010101010101010101010101010101;
    alu_opcode_in = 4'b1010;
    load_size_in = 2'b11;
    load_unsigned_in = 1'b1;
    alu_src_in = 1'b1;
    csr_wr_en_in = 1'b0;
    rf_wr_en_in = 1'b1;
    wb_mux_sel_in = 3'b001;
    csr_op_in = 3'b010;
    imm_in = 32'b11110000111100001111000011110000;
    iadder_out_in = 32'b11001100110011001100110011001100;
    branch_taken_in = 1'b0;
    rst_in = 1'b0;
    
    // Reset
    rst_in = 1'b1;	
    #10;
    rst_in = 1'b0;
    // Apply inputs
    #5;

    // Print outputs
    #5;
    $display("rd_addr_reg_out = %b", rd_addr_reg_out);
    $display("csr_addr_reg_out = %b", csr_addr_reg_out);
    $display("rs1_reg_out = %b", rs1_reg_out);
    $display("rs2_reg_out = %b", rs2_reg_out);
    $display("pc_reg_out = %b", pc_reg_out);
    $display("pc_plus_4_reg_out = %b", pc_plus_4_reg_out);
    $display("alu_opcode_reg_out = %b", alu_opcode_reg_out);
    $display("load_size_reg_out = %b", load_size_reg_out);
    $display("load_unsigned_reg_out = %b", load_unsigned_reg_out);
    $display("alu_src_reg_out = %b", alu_src_reg_out);
    $display("csr_wr_en_reg_out = %b", csr_wr_en_reg_out);
    $display("rf_wr_en_reg_out = %b", rf_wr_en_reg_out);
    $display("wb_mux_sel_reg_out = %b", wb_mux_sel_reg_out);
    $display("csr_op_reg_out = %b", csr_op_reg_out);
    $display("imm_reg_out = %b", imm_reg_out);
    $display("iadder_out_reg_out = %b", iadder_out_reg_out);

    // Finish simulation
    #5;
    $finish;
  end

endmodule
