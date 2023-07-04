module msrv32_wr_en_generator (
  input flush_in,
  input rf_wr_en_reg_in,
  input csr_wr_en_reg_in,
  output wr_en_int_file_out,
  output wr_en_csr_file_out
);

  assign wr_en_int_file_out = flush_in ? 1'b0 : rf_wr_en_reg_in;
  assign wr_en_csr_file_out = flush_in ? 1'b0 : csr_wr_en_reg_in;

endmodule
