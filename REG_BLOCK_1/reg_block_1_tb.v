
module msrv32_reg_block_1_tb;

  // Inputs
  reg [31:0] pc_mux_in;
  reg clk_in;
  reg rst_in;

  // Outputs
  wire [31:0] pc_out;

  // Instantiate the DUT
  msrv32_reg_block_1 dut (
    .pc_mux_in(pc_mux_in),
    .clk_in(clk_in),
    .rst_in(rst_in),
    .pc_out(pc_out)
  );

  // Initialize testbench
  initial begin
    // Test case 1
    rst_in = 1;
    clk_in = 0;
    pc_mux_in = 32'hABCDEF01;
    #5;
    // Expected output: pc_out = 0
    $display("Test case 1: pc_out = %h", pc_out);

    // Test case 2
    rst_in = 0;
    clk_in = 0;
    pc_mux_in = 32'h12345678;
    #5;
    // Expected output: pc_out = 0
    $display("Test case 2: pc_out = %h", pc_out);

    // Test case 3
    rst_in = 0;
    clk_in = 1;
    pc_mux_in = 32'h87654321;
    #10;
    // Expected output: pc_out = pc_mux_in
    $display("Test case 3: pc_out = %h", pc_out);

    // Add more test cases as needed

    // End simulation
    $finish;
  end

  always #5 clk_in = ~clk_in;
  always #5 rst_in = ~rst_in;

endmodule
