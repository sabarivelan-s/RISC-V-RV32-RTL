module msrv32_instruction_mux_tb;

  // Inputs
  reg flush_in;
  reg [31:0] instr_in;

  // Outputs
  wire [6:0] opcode_out;
  wire [2:0] funct3_out;
  wire [6:0] funct7_out;
  wire [4:0] rs1addr_out;
  wire [4:0] rs2addr_out;
  wire [4:0] rdaddr_out;
  wire [11:0] csr_addr_out;
  wire [24:0] instr_31_7_out;

  // Instantiate the DUT
  msrv32_instruction_mux dut (
    .flush_in(flush_in),
    .instr_in(instr_in),
    .opcode_out(opcode_out),
    .funct3_out(funct3_out),
    .funct7_out(funct7_out),
    .rs1addr_out(rs1addr_out),
    .rs2addr_out(rs2addr_out),
    .rdaddr_out(rdaddr_out),
    .csr_addr_out(csr_addr_out),
    .instr_31_7_out(instr_31_7_out)
  );

  // Initialize testbench
  initial begin
    // Test case 1
    flush_in = 0;
    instr_in = 32'h01234567;
    #10;
    // Expected outputs:
    // opcode_out = instr_in[6:0]
    // funct3_out = instr_in[14:12]
    // funct7_out = instr_in[31:25]
    // rs1addr_out = instr_in[19:15]
    // rs2addr_out = instr_in[24:20]
    // rdaddr_out = instr_in[11:7]
    // csr_addr_out = instr_in[31:20]
    // instr_31_7_out = instr_in[31:7]
    $display("Test case 1: opcode_out = %h", opcode_out);
    $display("Test case 1: funct3_out = %h", funct3_out);
    $display("Test case 1: funct7_out = %h", funct7_out);
    $display("Test case 1: rs1addr_out = %h", rs1addr_out);
    $display("Test case 1: rs2addr_out = %h", rs2addr_out);
    $display("Test case 1: rdaddr_out = %h", rdaddr_out);
    $display("Test case 1: csr_addr_out = %h", csr_addr_out);
    $display("Test case 1: instr_31_7_out = %h", instr_31_7_out);

    // Test case 2
    flush_in = 1;
    instr_in = 32'h89ABCDEF;
    #10;
    // Expected outputs when flush_in is asserted:
    // opcode_out = 7'b0000000
    // funct3_out = 3'b000
    // funct7_out = 7'b0000000
    // rs1addr_out = 5'b00000
    // rs2addr_out = 5'b00000
    // rdaddr_out = 5'b00000
    // csr_addr_out = 12'b000000000000
    // instr_31_7_out = 25'b0000000000000000000000000
    $display("Test case 2: opcode_out = %h", opcode_out);
    $display("Test case 2: funct3_out = %h", funct3_out);
    $display("Test case 2: funct7_out = %h", funct7_out);
    $display("Test case 2: rs1addr_out = %h", rs1addr_out);
    $display("Test case 2: rs2addr_out = %h", rs2addr_out);
    $display("Test case 2: rdaddr_out = %h", rdaddr_out);
    $display("Test case 2: csr_addr_out = %h", csr_addr_out);
    $display("Test case 2: instr_31_7_out = %h", instr_31_7_out);

    // Add more test cases as needed

    // End simulation
    $finish;
  end

endmodule
