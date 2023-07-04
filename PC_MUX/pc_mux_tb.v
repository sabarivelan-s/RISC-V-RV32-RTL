module msrv32_pc_tb;

  // Inputs
  reg rst_in;
  reg [1:0] pc_src_in;
  reg [31:0] epc_in;
  reg [31:0]trap_address_in;
  reg branch_taken_in;
  reg [31:1] iaddr_in;
  reg ahb_ready_in;
  reg [31:0] pc_in;

  // Outputs
  wire [31:0] iaddr_out;
  wire [31:0] pc_plus_4_out;
  wire misaligned_instr_logic_out;
  wire [31:0] pc_mux_out;

  // Instantiate the DUT
  msrv32_pc dut (
    .rst_in(rst_in),
    .pc_src_in(pc_src_in),
    .epc_in(epc_in),
    .trap_address_in(trap_address_in),
    .branch_taken_in(branch_taken_in),
    .iaddr_in(iaddr_in),
    .ahb_ready_in(ahb_ready_in),
    .pc_in(pc_in),
    .iaddr_out(iaddr_out),
    .pc_plus_4_out(pc_plus_4_out),
    .misaligned_instr_logic_out(misaligned_instr_logic_out),
    .pc_mux_out(pc_mux_out)
  );

  // Initialize testbench
  initial begin
    // Test case 1
    rst_in = 1;
    pc_src_in = 2'b00;
    epc_in = 32'hABCDEF01;
    trap_address_in = 32'h12345678;
    branch_taken_in = 0;
    iaddr_in = 32'b0;
    ahb_ready_in = 1;
    pc_in = 32'h00000000;
    #10;
    // Expected outputs when pc_src_in is '00':
    // iaddr_out = BOOT_ADDRESS
    // pc_plus_4_out = 32'h00000004
    // misaligned_instr_logic_out = 0
    // pc_mux_out = BOOT_ADDRESS
    $display("Test case 1: iaddr_out = %h", iaddr_out);
    $display("Test case 1: pc_plus_4_out = %h", pc_plus_4_out);
    $display("Test case 1: misaligned_instr_logic_out = %b", misaligned_instr_logic_out);
    $display("Test case 1: pc_mux_out = %h", pc_mux_out);

    // Test case 2
    rst_in = 0;
    pc_src_in = 2'b01;
    epc_in = 32'h12345678;
    trap_address_in = 32'hABCDEF01;
    branch_taken_in = 0;
    iaddr_in = 32'b0;
    ahb_ready_in = 1;
    pc_in = 32'h00000000;
    #10;
    // Expected outputs when pc_src_in is '01':
    // iaddr_out = epc_in
    // pc_plus_4_out = 32'h00000004
    // misaligned_instr_logic_out = 0
    // pc_mux_out = epc_in
    $display("Test case 2: iaddr_out = %h", iaddr_out);
    $display("Test case 2: pc_plus_4_out = %h", pc_plus_4_out);
    $display("Test case 2: misaligned_instr_logic_out = %b", misaligned_instr_logic_out);
    $display("Test case 2: pc_mux_out = %h", pc_mux_out);

    // Test case 3
    rst_in = 0;
    pc_src_in = 2'b10;
    epc_in = 32'hABCDEF01;
    trap_address_in = 32'h87654321;
    branch_taken_in = 0;
    iaddr_in = 32'b0;
    ahb_ready_in = 1;
    pc_in = 32'h00000000;
    #10;
    // Expected outputs when pc_src_in is '10':
    // iaddr_out = trap_address_in
    // pc_plus_4_out = 32'h00000004
    // misaligned_instr_logic_out = 0
    // pc_mux_out = trap_address_in
    $display("Test case 3: iaddr_out = %h", iaddr_out);
    $display("Test case 3: pc_plus_4_out = %h", pc_plus_4_out);
    $display("Test case 3: misaligned_instr_logic_out = %b", misaligned_instr_logic_out);
    $display("Test case 3: pc_mux_out = %h", pc_mux_out);

    // Add more test cases as needed

    // End simulation
    $finish;
  end


endmodule
