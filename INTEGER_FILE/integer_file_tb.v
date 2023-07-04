`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.06.2023 10:57:32
// Design Name: 
// Module Name: msrv32_integer_file_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module msrv32_integer_file_tb;
  // Inputs
  reg clk_in;
  reg rst_in;
  reg [4:0] rs_2_addr_in;
  reg [4:0]rd_addr_in;
  reg wr_en_in;
  reg [31:0] rd_in;
  reg [4:0] rs_1_addr_in;

  // Outputs
  wire [31:0] rs_1_out;
  wire [31:0] rs_2_out;

  // Instantiate the DUT
  msrv32_integer_file dut (
    .clk_in(clk_in),
    .rst_in(rst_in),
    .rs_2_addr_in(rs_2_addr_in),
    .rd_addr_in(rd_addr_in),
    .wr_en_in(wr_en_in),
    .rd_in(rd_in),
    .rs_1_addr_in(rs_1_addr_in),
    .rs_1_out(rs_1_out),
    .rs_2_out(rs_2_out)
  );

initial
  clk_in = 1'b0;
 initial
 forever #5 clk_in = ~clk_in;
  // Initialize testbench
  initial begin
    // Test case 1
    //clk_in = 0;
    rst_in = 1;
    rs_2_addr_in = 5'b11101;
    rd_addr_in = 5'b10110;
    wr_en_in = 0;
    rd_in = 32'h12345678;
    rs_1_addr_in = 5'b01010;
    #10;
    // Expected outputs when rs_1_addr_in is not equal to rd_addr_in and wr_en_in is not asserted:
    // rs_1_out = reg_file[rs_1_addr_in]
    // rs_2_out = reg_file[rs_2_addr_in]
    $display("Test case 1: rs_1_out = %h", rs_1_out);
    $display("Test case 1: rs_2_out = %h", rs_2_out);

    // Test case 2
    //clk_in = 1;
    rst_in = 0;
    rs_2_addr_in = 5'b00010;
    rd_addr_in = 5'b01011;
    wr_en_in = 0;
    rd_in = 32'h98765432;
    rs_1_addr_in =5'b00001;
    #10;
    // Expected outputs when rst_in is asserted:
    // rs_1_out = 32'b0
    // rs_2_out = 32'b0
    $display("Test case 2: rs_1_out = %h", rs_1_out);
    $display("Test case 2: rs_2_out = %h", rs_2_out);

    // Test case 3
    //clk_in = 0;
    rst_in = 0;
    rs_2_addr_in = 10111;
    rd_addr_in = 01111;
    wr_en_in = 1;
    rd_in = 32'hABCDEF01;
    rs_1_addr_in = 01000;
    #10;
    // Expected outputs when rs_1_addr_in is equal to rd_addr_in and wr_en_in is asserted:
    // rs_1_out = rd_in
    // rs_2_out = reg_file[rs_2_addr_in]
    $display("Test case 3: rs_1_out = %h", rs_1_out);
    $display("Test case 3: rs_2_out = %h", rs_2_out);

    // Add more test cases as needed
    
    // End simulation
//    $finish;
  end
//
  
endmodule
