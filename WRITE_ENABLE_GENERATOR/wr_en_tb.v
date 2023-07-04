
module msrv32_wr_en_generator_tb;

  // Inputs
  reg flush_in;
  reg rf_wr_en_reg_in;
  reg csr_wr_en_reg_in;

  // Outputs
  wire wr_en_int_file_out;
  wire wr_en_csr_file_out;

  // Instantiate the DUT
  msrv32_wr_en_generator dut (
    .flush_in(flush_in),
    .rf_wr_en_reg_in(rf_wr_en_reg_in),
    .csr_wr_en_reg_in(csr_wr_en_reg_in),
    .wr_en_int_file_out(wr_en_int_file_out),
    .wr_en_csr_file_out(wr_en_csr_file_out)
  );

  // Initialize testbench
  initial begin
    // Test case 1
    flush_in = 1;
    rf_wr_en_reg_in = 0;
    csr_wr_en_reg_in = 0;
    #5;
    // Expected output: wr_en_int_file_out = 0, wr_en_csr_file_out = 0
    $display("Test case 1: wr_en_int_file_out = %b, wr_en_csr_file_out = %b",
      wr_en_int_file_out, wr_en_csr_file_out);

    // Test case 2
    flush_in = 0;
    rf_wr_en_reg_in = 1;
    csr_wr_en_reg_in = 0;
    #5;
    // Expected output: wr_en_int_file_out = 1, wr_en_csr_file_out = 0
    $display("Test case 2: wr_en_int_file_out = %b, wr_en_csr_file_out = %b",
      wr_en_int_file_out, wr_en_csr_file_out);

    // Test case 3
    flush_in = 0;
    rf_wr_en_reg_in = 0;
    csr_wr_en_reg_in = 1;
    #5;
    // Expected output: wr_en_int_file_out = 0, wr_en_csr_file_out = 1
    $display("Test case 3: wr_en_int_file_out = %b, wr_en_csr_file_out = %b",
      wr_en_int_file_out, wr_en_csr_file_out);

    // Add more test cases as needed

    // End simulation
    $finish;
  end

endmodule
