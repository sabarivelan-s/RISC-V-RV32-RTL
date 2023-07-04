module msrv32_store_unit_tb;

  reg [1:0] funct3_tb;
  reg [31:0] iadder_tb;
  reg [31:0] rs2_tb;
  reg mem_wr_req_tb;
  reg ahb_ready_tb;
  
  wire [31:0] ms_riscv32_mp_dmaddr_tb;
  wire [31:0] ms_riscv32_mp_dmdata_tb;
  wire [3:0] ms_riscv32_mp_dmwr_mask_tb;
  wire ms_riscv32_mp_dmwr_req_tb;
  wire [1:0] ahb_htrans_tb;
  
  msrv32_store_unit dut (
    .funct3_in(funct3_tb),
    .iadder_in(iadder_tb),
    .rs2_in(rs2_tb),
    .mem_wr_req_in(mem_wr_req_tb),
    .ahb_ready_in(ahb_ready_tb),
    .ms_riscv32_mp_dmaddr_out(ms_riscv32_mp_dmaddr_tb),
    .ms_riscv32_mp_dmdata_out(ms_riscv32_mp_dmdata_tb),
    .ms_riscv32_mp_dmwr_mask_out(ms_riscv32_mp_dmwr_mask_tb),
    .ms_riscv32_mp_dmwr_req_out(ms_riscv32_mp_dmwr_req_tb),
    .ahb_htrans_out(ahb_htrans_tb)
  );
  
  initial begin
    
    // Test Case 1
    funct3_tb = 2'b00;
    iadder_tb = 32'h12345678;
    rs2_tb = 32'hABCDEF01;
    mem_wr_req_tb = 1'b1;
    ahb_ready_tb = 1'b1;
    
    #10;
    $display("Test Case 1");
    $display("ms_riscv32_mp_dmaddr_tb = %h", ms_riscv32_mp_dmaddr_tb);
    $display("ms_riscv32_mp_dmdata_tb = %h", ms_riscv32_mp_dmdata_tb);
    $display("ms_riscv32_mp_dmwr_mask_tb = %b", ms_riscv32_mp_dmwr_mask_tb);
    $display("ms_riscv32_mp_dmwr_req_tb = %b", ms_riscv32_mp_dmwr_req_tb);
    $display("ahb_htrans_tb = %b", ahb_htrans_tb);
    
    // Test Case 2
    funct3_tb = 2'b01;
    iadder_tb = 32'h87654321;
    rs2_tb = 32'hFEDCBA09;
    mem_wr_req_tb = 1'b1;
    ahb_ready_tb = 1'b1;
    
    #10;
    $display("Test Case 2");
    $display("ms_riscv32_mp_dmaddr_tb = %h", ms_riscv32_mp_dmaddr_tb);
    $display("ms_riscv32_mp_dmdata_tb = %h", ms_riscv32_mp_dmdata_tb);
    $display("ms_riscv32_mp_dmwr_mask_tb = %b", ms_riscv32_mp_dmwr_mask_tb);
    $display("ms_riscv32_mp_dmwr_req_tb = %b", ms_riscv32_mp_dmwr_req_tb);
    $display("ahb_htrans_tb = %b", ahb_htrans_tb);
    
    // Test Case 3
    funct3_tb = 2'b10;
    iadder_tb = 32'h54321098;
    rs2_tb = 32'h98765432;
    mem_wr_req_tb = 1'b1;
    ahb_ready_tb = 1'b1;
    
    #10;
    $display("Test Case 3");
    $display("ms_riscv32_mp_dmaddr_tb = %h", ms_riscv32_mp_dmaddr_tb);
    $display("ms_riscv32_mp_dmdata_tb = %h", ms_riscv32_mp_dmdata_tb);
    $display("ms_riscv32_mp_dmwr_mask_tb = %b", ms_riscv32_mp_dmwr_mask_tb);
    $display("ms_riscv32_mp_dmwr_req_tb = %b", ms_riscv32_mp_dmwr_req_tb);
    $display("ahb_htrans_tb = %b", ahb_htrans_tb);
    
    // Test Case 4
    funct3_tb = 2'b11;
    iadder_tb = 32'h10293847;
    rs2_tb = 32'h62573920;
    mem_wr_req_tb = 1'b1;
    ahb_ready_tb = 1'b1;
    
    #10;
    $display("Test Case 4");
    $display("ms_riscv32_mp_dmaddr_tb = %h", ms_riscv32_mp_dmaddr_tb);
    $display("ms_riscv32_mp_dmdata_tb = %h", ms_riscv32_mp_dmdata_tb);
    $display("ms_riscv32_mp_dmwr_mask_tb = %b", ms_riscv32_mp_dmwr_mask_tb);
    $display("ms_riscv32_mp_dmwr_req_tb = %b", ms_riscv32_mp_dmwr_req_tb);
    $display("ahb_htrans_tb = %b", ahb_htrans_tb);
    
    // Test Case 5 (ahb_ready_in = 0)
    funct3_tb = 2'b00;
    iadder_tb = 32'h87654321;
    rs2_tb = 32'hFEDCBA09;
    mem_wr_req_tb = 1'b1;
    ahb_ready_tb = 1'b0;
    
    #10;
    $display("Test Case 5");
    $display("ms_riscv32_mp_dmaddr_tb = %h", ms_riscv32_mp_dmaddr_tb);
    $display("ms_riscv32_mp_dmdata_tb = %h", ms_riscv32_mp_dmdata_tb);
    $display("ms_riscv32_mp_dmwr_mask_tb = %b", ms_riscv32_mp_dmwr_mask_tb);
    $display("ms_riscv32_mp_dmwr_req_tb = %b", ms_riscv32_mp_dmwr_req_tb);
    $display("ahb_htrans_tb = %b", ahb_htrans_tb);
    
    #10;
    $finish;
  end

endmodule
