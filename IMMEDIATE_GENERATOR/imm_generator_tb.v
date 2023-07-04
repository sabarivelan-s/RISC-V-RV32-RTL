
module msrv32_imm_generator_tb;

  // Inputs
  reg [31:7] instr_in;
  reg [2:0] imm_type_in;

  // Outputs
  wire [31:0] imm_out;

  // Instantiate the DUT
  msrv32_imm_generator dut (
    .instr_in(instr_in),
    .imm_type_in(imm_type_in),
    .imm_out(imm_out)
  );

  // Initialize testbench
  initial begin
    // Test case 1
    instr_in = 32'h00123456;
    imm_type_in = 3'b010;
    #10;
    // Expected imm_out = {20{instr_in[31]}}, instr_in[31:25], instr_in[11:7]
    $display("Test case 1: imm_out = %h", imm_out);

    // Test case 2
    instr_in = 32'h01234567;
    imm_type_in = 3'b100;
    #10;
    // Expected imm_out = instr_in[31:12], 12'h000
    $display("Test case 2: imm_out = %h", imm_out);

    // Add more test cases as needed

    // End simulation
    $finish;
  end

endmodule
