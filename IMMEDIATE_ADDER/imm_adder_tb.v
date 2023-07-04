module msrv32_immediate_adder_tb;

  // Inputs
  reg [31:0] pc_in;
  reg [31:0] rs1_in;
  reg iadder_src_in;
  reg [31:0] imm_in;

  // Outputs
  wire [31:0] iadder_out;

  // Instantiate the DUT
  msrv32_immediate_adder dut (
    .pc_in(pc_in),
    .rs1_in(rs1_in),
    .iadder_src_in(iadder_src_in),
    .imm_in(imm_in),
    .iadder_out(iadder_out)
  );

  // Clock
  reg clk = 0;
  always #5 clk = ~clk;

  // Testbench logic
  initial begin
    // Initialize inputs
    pc_in = 0;
    rs1_in = 0;
    iadder_src_in = 0;
    imm_in = 0;

    // Test case 1
    #5;
    pc_in = 100;
    rs1_in = 50;
    imm_in = 30;
    iadder_src_in = 1;
    #10;
    // Expected iadder_out = rs1_in + imm_in = 50 + 30 = 80
    $display("Test case 1: iadder_out = %d", iadder_out);
    
    // Test case 2
    #5;
    pc_in = 200;
    rs1_in = 150;
    imm_in = 20;
    iadder_src_in = 0;
    #10;
    // Expected iadder_out = pc_in + imm_in = 200 + 20 = 220
    $display("Test case 2: iadder_out = %d", iadder_out);

    // Add more test cases as needed

    // End simulation
    $finish;
  end

  // Toggle clock
  always #1 clk = ~clk;

endmodule

