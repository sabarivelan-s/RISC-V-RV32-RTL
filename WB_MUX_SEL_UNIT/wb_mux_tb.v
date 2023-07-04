
module msrv32_wb_mux_sel_unit_tb;

  // Inputs
  reg alu_src_reg_in;
  reg [2:0] wb_mux_sel_reg_in;
  reg [31:0] alu_result_in, lu_output, imm_reg_in;
  reg [31:0] iadder_out_reg_in, csr_data_in;
  reg [31:0] pc_plus_4_reg_in, rs2_reg_in;

  // Outputs
  wire [31:0] wb_mux_out;
  wire [31:0] alu_2nd_src_mux_out;

  // Instantiate the msrv32_wb_mux_sel_unit module
  msrv32_wb_mux_sel_unit uut(
    .alu_src_reg_in(alu_src_reg_in),
    .wb_mux_sel_reg_in(wb_mux_sel_reg_in),
    .alu_result_in(alu_result_in),
    .lu_output(lu_output),
    .imm_reg_in(imm_reg_in),
    .iadder_out_reg_in(iadder_out_reg_in),
    .csr_data_in(csr_data_in),
    .pc_plus_4_reg_in(pc_plus_4_reg_in),
    .rs2_reg_in(rs2_reg_in),
    .wb_mux_out(wb_mux_out),
    .alu_2nd_src_mux_out(alu_2nd_src_mux_out)
  );

  // Stimulus
  initial begin
    // Set initial values
    alu_src_reg_in = 0;
    wb_mux_sel_reg_in = 0;
    alu_result_in = 0;
    lu_output = 0;
    imm_reg_in = 0;
    iadder_out_reg_in = 0;
    csr_data_in = 0;
    pc_plus_4_reg_in = 0;
    rs2_reg_in = 0;

    // Wait for a few cycles
    #10;

    // Test case 1
    alu_src_reg_in = 0;
    wb_mux_sel_reg_in = 3'b000;
    alu_result_in = 32'h12345678;
    lu_output = 32'h0000ABCD;
    imm_reg_in = 32'h98765432;
    iadder_out_reg_in = 32'hFEDCBA98;
    csr_data_in = 32'h55555555;
    pc_plus_4_reg_in = 32'h1234ABCD;
    rs2_reg_in = 32'hAABBCCDD;

    // Wait for a few cycles
    #10;

    // Test case 2
    alu_src_reg_in = 1;
    wb_mux_sel_reg_in = 3'b101;
    alu_result_in = 32'h87654321;
    lu_output = 32'h0000FFFF;
    imm_reg_in = 32'h11223344;
    iadder_out_reg_in = 32'h55667788;
    csr_data_in = 32'hAAAAAAAA;
    pc_plus_4_reg_in = 32'hFEDCBA98;
    rs2_reg_in = 32'h12345678;

    // Wait for a few cycles
    #10;

    // Add more test cases as needed

    // End the simulation
    $finish;
  end

endmodule
