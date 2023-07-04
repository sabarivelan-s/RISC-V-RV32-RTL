module ms_riscv32_mp(	input ms_riscv32_mp_clk_in,
			input ms_riscv32_mp_rst_in,
			input ms_riscv32_mp_instr_hready_in,
			input [31:0]ms_riscv32_mp_dmdata_in, ms_riscv32_mp_instr_in,
			input [3:0]ms_riscv32_mp_dmwr_mask_in,
			input ms_riscv32_mp_hresp_in,
			input [63:0]ms_riscv32_mp_rc_in,
			input ms_riscv32_mp_data_hready_in,
			input ms_riscv32_mp_eirq_in, ms_riscv32_mp_tirq_in, ms_riscv32_mp_sirq_in,
			output ms_riscv32_mp_dmwr_req_out,
			output [31:0] ms_riscv32_mp_imaddr_out, ms_riscv32_mp_dmaddr_out, ms_riscv32_mp_dmdata_out,
			output [1:0] ms_riscv32_mp_data_htrans_out,
			output [3:0] ms_riscv32_mp_dmwr_mask_out    
	            );

wire [1:0] pc_src_inw;
wire [31:0] pc_inw, epc_inw,trap_address_inw;
wire branch_taken_inw;
wire iaddr_inw;
wire [31:0]pc_plus_4_inw;
wire misaligned_load_inw;
wire [31:0]pc_mux_inw;
wire flush_inw;
wire [6:0]opcode_inw;
wire [2:0] funct3_inw;
wire [6:0] funct7_5_inw1;
wire [4:0] rs1_addr_inw,rs2_addr_inw,rd_addr_inw;
wire [11:0] csr_addr_inw;
wire [24:0] instr_inw;
wire [2:0] imm_type_inw;
wire [31:0] imm_inw;
wire rf_wr_en_reg_inw, csr_wr_en_reg_inw;
wire wr_en_inw;
wire csr_wr_inw;
wire rd_inw;
wire [31:0]rs1w,rs2w;
wire iadder_src_inw;
wire [31:0]iadder_outw;
wire [4:0]opcodew = opcode_inw[6:2];
wire trap_taken_inw;
wire [1:0]iadder_outw10 = iadder_outw[1:0];
wire [2:0]wb_mux_sel_inw,csr_op_inw;
wire [3:0] alu_opcode_inw;
wire mem_wr_req_inw;
wire [1:0]load_size_inw;
wire load_unsigned_inw,alu_src_inw;
wire csr_wr_en_inw;
wire rf_wr_en_inw;
wire illegal_instr_inw;
wire misaligned_load_inw1;
wire misaligned_store_inw;
wire funct7_5_inw = funct7_5_inw1[5];
wire funct3_inw1 = funct3_inw[1:0];
wire mie_inw, meie_inw, mtie_inw, msie_inw, meip_inw, mtip_inw, msip_inw;
wire i_e_inw, set_epcw, set_causew;
wire [3:0] cause_inw;
wire instret_incw, mie_clearw, mie_setw;
wire misalignedexception_w;
wire [11:0]csr_addr_in1w;
wire [2:0]csr_op_in1w;
wire [31:0]immregw;
wire [4:0]csr_uimm_w=immregw[4:0];
wire [31:0]rs1regw,pc1_inw,iadderout1w;
wire [31:0]csr_wb_w;
wire rf_wr_enw;
wire [2:0]wb_mux_selw;
wire alusrcw,loadunw;
wire [4:0]rd_addr_in1w;
wire [31:0]rs2wbw,pcplus4wbw;
wire [3:0]aluopcodew;
wire [1:0]loadsw;
wire [31:0]alu2ndw,aluresultw;
wire [1:0]iadder10w = iadderout1w[1:0];
wire [31:0]luoutw;

msrv32_pc PC(.rst_in(ms_riscv32_mp_rst_in),
	    	.pc_src_in(pc_src_inw),
		.pc_in(pc_inw),
		.epc_in(epc_inw),
		.trap_address_in(trap_address_inw),
		.branch_taken_in(branch_taken_inw),
		.iaddr_in(iaddr_inw),
		.ahb_ready_in(ms_riscv32_mp_instr_hready_in),
		.pc_plus_4_out(pc_plus_4_inw),
		.misaligned_instr_logic_out(misaligned_load_inw),
		.pc_mux_out(pc_mux_inw),
		.iaddr_out(ms_riscv32_mp_imaddr_out)
);

msrv32_reg_block_1 REG1(.pc_mux_in(pc_mux_inw),
			.clk_in(ms_riscv32_mp_clk_in),
			.rst_in(ms_riscv32_mp_rst_in),
			.pc_out(pc_inw)
);

msrv32_instruction_mux INSTMUX(.flush_in(flush_inw),
				.instr_in(ms_riscv32_mp_instr_in),
				.opcode_out(opcode_inw),
				.funct3_out(funct3_inw),
				.funct7_out(funct7_5_inw1),
				.rs1addr_out(rs1_addr_inw),
				.rs2addr_out(rs2_addr_inw),
				.rdaddr_out(rd_addr_inw),
				.csr_addr_out(csr_addr_inw),
				.instr_31_7_out(instr_inw)	
);

msrv32_imm_generator IMMGEN(.instr_in(instr_inw),
				.imm_type_in(imm_type_inw),
				.imm_out(imm_inw)
);


msrv32_wr_en_generator WRENG(.flush_in(flush_inw),
			.rf_wr_en_reg_in(rf_wr_en_reg_inw),
			.csr_wr_en_reg_in(csr_wr_en_reg_inw),
			.wr_en_int_file_out(wr_en_inw),
			.wr_en_csr_file_out(csr_wr_inw)
);

msrv32_integer_file INTFILE(.clk_in(ms_riscv32_mp_clk_in),
			.rst_in(ms_riscv32_mp_rst_in),
			.rs_2_addr_in(rs2_addr_inw),
			.rd_addr_in(rd_addr_in1w),
			.wr_en_in(wr_en_inw),
			.rd_in(rd_inw),
			.rs_1_addr_in(rs1_addr_inw),
			.rs_1_out(rs1w),
			.rs_2_out(rs2w)

);

msrv32_immediate_adder IMMADD(.pc_in(pc_inw),
				.rs1_in(rs1w),
				.iadder_src_in(iadder_src_inw),
				.imm_in(imm_inw),
				.iadder_out(iadder_outw)	
);

msrv32_branch_unit BRUNIT(.rs1_in(rs1w),
				.rs2_in(rs2w),
				.opcode_in(opcodew),
				.funct3_in(funct3_inw),
				.branch_taken_out(branch_taken_inw)
);


msrv32_decoder DECOR(.trap_taken_in(trap_taken_inw),
			.funct7_5_in(funct7_5_inw),
			.opcode_in(opcode_inw),
			.funct3_in(funct3_inw),
			.iadder_out_1_to_0_in(iadder_outw10),
			.wb_mux_sel_out(wb_mux_sel_inw),
			.imm_type_out(imm_type_inw),
			.csr_op_out(csr_op_inw),
			.mem_wr_req_out(mem_wr_req_inw),
			.alu_opcode_out(alu_opcode_inw),
			.load_size_out(load_size_inw),
			.load_unsigned_out(load_unsigned_inw),
			.alu_src_out(alu_src_inw),
			.iadder_src_out(iadder_src_inw),
			.csr_wr_en_out(csr_wr_en_inw),
			.rf_wr_en_out(rf_wr_en_inw),
			.illegal_instr_out(illegal_instr_inw),
			.misaligned_load_out(misaligned_load_inw1),
			.misaligned_store_out(misaligned_store_inw)

);

msrv32_store_unit STR(.funct3_in(funct3_inw1),
			.iadder_in(iadder_outw),
			.rs2_in(rs2w),
			.mem_wr_req_in(mem_wr_req_inw),
			.ahb_ready_in(ms_riscv32_mp_instr_hready_in),
			.ms_riscv32_mp_dmaddr_out(ms_riscv32_mp_dmaddr_out),
			.ms_riscv32_mp_dmdata_out(ms_riscv32_mp_dmdata_out),
			.ms_riscv32_mp_dmwr_mask_out(ms_riscv32_mp_dmwr_mask_out),
			.ms_riscv32_mp_dmwr_req_out(ms_riscv32_mp_dmwr_req_out),
			.ahb_htrans_out(ms_riscv32_mp_data_htrans_out)
);

msrv32_machine_control MACOT(.clk_in(ms_riscv32_mp_clk_in),
				.reset_in(ms_riscv32_mp_rst_in),
				.illegal_instr_in(illegal_instr_inw),
				.misaligned_load_in(misaligned_load_inw1),
				.misaligned_store_in(misaligned_store_inw),
				.misaligned_instr_in(misaligned_load_inw),
				.opcode_6_to_2_in(opcodew),
				.funct3_in(funct3_inw), .funct7_in(funct7_5_inw1),
				.rs1_addr_in(rs1_addr_inw), .rs2_addr_in(rs2_addr_inw), .rd_addr_in(rd_addr_inw),
				.e_irq_in(ms_riscv32_mp_eirq_in), .t_irq_in(ms_riscv32_mp_tirq_in), .s_irq_in(ms_riscv32_mp_sirq_in),
				.mie_in(mie_inw), .meie_in(meie_inw),.mtie_in(mtie_inw),
				.msie_in(msie_inw), .meip_in(meip_inw),
				.mtip_in(mtip_inw), .msip_in(msip_inw),
				.i_or_e_out(i_e_inw), .set_epc_out(set_epcw), .set_cause_out(set_causew),
				.cause_out(cause_inw), .instret_inc_out(instret_incw), .mie_clear_out(mie_clearw), .mie_set_out(mie_setw),
				.misaligned_exception_out(misalignedexception_w), .pc_src_out(pc_src_inw),
				.flush_out(flush_inw), .trap_taken_out(trap_taken_inw)
);

msrv32_csr_file CSRF(.clk_in(ms_riscv32_mp_clk_in), .rst_in(ms_riscv32_mp_rst_in),
			.wr_en_in(csr_wr_inw), .csr_addr_in(csr_addr_in1w), .csr_op_in(csr_op_in1w),
			.csr_uimm_in(csr_uimm_w), .csr_data_in(rs1regw),
			.pc_in(pc1_inw), .iadder_in(iadderout1w),
			.e_irq_in(ms_riscv32_mp_eirq_in), .s_irq_in(ms_riscv32_mp_sirq_in), .t_irq_in(ms_riscv32_mp_tirq_in),
			.i_or_e_in(i_e_inw), .set_cause_in(set_causew), .set_epc_in(set_epcw), 
			.instret_inc_in(instret_incw), .mie_clear_in(mie_clearw), .mie_set_in(mie_setw),
			.cause_in(cause_inw), .real_time_in(ms_riscv32_mp_rc_in), .misaligned_exception_in(misalignedexception_w),
			.csr_data_out(csr_wb_w), .mie_out(mie_inw),
			.epc_out(epc_inw), .trap_address_out(trap_address_inw),
			.meie_out(meie_inw), .mtie_out(mtie_inw), .msie_out(msie_inw),
			.meip_out(meip_inw), .mtip_out(mtip_inw), .msip_out(msip_inw)
			
);

msrv32_reg_block_2 REG2(.rd_addr_in(rd_addr_inw),
			.csr_addr_in(csr_addr_inw), .rs1_in(rs1w), .rs2_in(rs2w),
			.pc_in(pc_inw), .pc_plus_4_in(pc_plus_4_inw), .alu_opcode_in(alu_opcode_inw),
			.load_size_in(load_size_inw), .load_unsigned_in(load_unsigned_inw), .alu_src_in(alu_src_inw),
			.csr_wr_en_in(csr_wr_en_inw), .rf_wr_en_in(rf_wr_en_inw),
			.wb_mux_sel_in(wb_mux_sel_inw), .csr_op_in(csr_op_inw),
			.imm_in(imm_inw), .iadder_out_in(iadder_outw),
			.branch_taken_in(branch_taken_inw), .rst_in(ms_riscv32_mp_rst_in), .clk_in(ms_riscv32_mp_clk_in),

			.rd_addr_reg_out(rd_addr_in1w), .csr_addr_reg_out(csr_addr_in1w),
			.rs1_reg_out(rs1regw), .rs2_reg_out(rs2wbw),
			.pc_reg_out(pc1_inw), .pc_plus_4_reg_out(pcplus4wbw),
			.alu_opcode_reg_out(aluopcodew), .load_size_reg_out(loadsw),
			.load_unsigned_reg_out(loadunw), .alu_src_reg_out(alusrcw), .csr_wr_en_reg_out(csr_wr_en_reg_inw),
	  		.rf_wr_en_reg_out(rf_wr_en_reg_inw), .wb_mux_sel_reg_out(wb_mux_selw), .csr_op_reg_out(csr_op_in1w),
			.imm_reg_out(immregw), .iadder_out_reg_out(iadderout1w) 

);

msrv32_alu ALU(.op1_in(rs1regw),
		.op2_in(alu2ndw),
		.opcode_in(aluopcodew),
		.result_out(aluresultw)
);


msrv32_load_unit LDU(.ahb_resp_in(ms_riscv32_mp_hresp_in),
			.ms_riscv32_mp_dmdata_in(ms_riscv32_mp_dmdata_in),
			.iadder_out_1_to_0_in(iadder10w),
			.load_unsigned_in(loadunw),
			.load_size_in(loadsw),
			.lu_output_out(luoutw)			
);

msrv32_wb_mux_sel_unit WBSEL(.alu_src_reg_in(alusrcw),
				.wb_mux_sel_reg_in(wb_mux_selw),
				.alu_result_in(aluresultw), .lu_output(luoutw), .imm_reg_in(immregw),
				.iadder_out_reg_in(iadderout1w), .csr_data_in(csr_wb_w),
				.pc_plus_4_reg_in(pcplus4wbw), .rs2_reg_in(rs2wbw),
				.wb_mux_out(rd_inw), .alu_2nd_src_mux_out(alu2ndw)
);
endmodule
