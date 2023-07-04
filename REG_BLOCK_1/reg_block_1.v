module msrv32_reg_block_1 (
  input [31:0] pc_mux_in,
  input clk_in, rst_in,
  output reg [31:0] pc_out
);
  
  always @(posedge clk_in or posedge rst_in)
  begin
    if (rst_in)
      pc_out <= 32'b0;
    else
      pc_out <= pc_mux_in;
  end
  
endmodule
