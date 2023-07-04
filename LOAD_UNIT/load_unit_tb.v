
module msrv32_load_unit_tb;

  // Inputs
  reg ahb_resp_in;
  reg [31:0] ms_riscv32_mp_dmdata_in;
  reg [1:0] iadder_out_1_to_0_in;
  reg load_unsigned_in;
  reg [1:0] load_size_in;

  // Outputs
  wire [31:0] lu_output_out;

  // Instantiate the module under test
  msrv32_load_unit dut (
    .ahb_resp_in(ahb_resp_in),
    .ms_riscv32_mp_dmdata_in(ms_riscv32_mp_dmdata_in),
    .iadder_out_1_to_0_in(iadder_out_1_to_0_in),
    .load_unsigned_in(load_unsigned_in),
    .load_size_in(load_size_in),
    .lu_output_out(lu_output_out)
  );

  // Clock
  reg clk=0;
  always #5 clk = ~clk; // 10ns period clock

  // Initialize inputs
  initial begin
    ahb_resp_in = 0;
    ms_riscv32_mp_dmdata_in = 0;
    iadder_out_1_to_0_in = 0;
    load_unsigned_in = 0;
    load_size_in = 0;
    #10;
    
    // Test case 1
    ahb_resp_in = 0;
    ms_riscv32_mp_dmdata_in = 32'h12345678;
    iadder_out_1_to_0_in = 2'b01;
    load_unsigned_in = 1;
    load_size_in = 2'b01;
    #10;
    
    // Test case 2
    ahb_resp_in = 0;
    ms_riscv32_mp_dmdata_in = 32'hABCDEF12;
    iadder_out_1_to_0_in = 2'b10;
    load_unsigned_in = 0;
    load_size_in = 2'b00;
    #10;
    
    // Test case 3
    ahb_resp_in = 1;
    ms_riscv32_mp_dmdata_in = 32'h00000000;
    iadder_out_1_to_0_in = 2'b11;
    load_unsigned_in = 1;
    load_size_in = 2'b10;
    #10;
    
    $finish;
  end

  // Monitor
  always @(posedge clk) begin
    $display("lu_output_out = %h", lu_output_out);
  end

endmodule
