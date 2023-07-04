module msrv32_top #(

   parameter BOOT_ADDRESS = 32'h00000000
    
   )(
     input  ms_riscv32_mp_clk_in,
     input  ms_riscv32_mp_rst_in,
      
   // connection with Real Time Counter
     input   [63:0] ms_riscv32_mp_rc_in,
     
   // connections with Instruction Memory
     output  [31:0] ms_riscv32_mp_imaddr_out,
     input   [31:0] ms_riscv32_mp_instr_in,
     input  ms_riscv32_mp_instr_hready_in,           //AHB ready

   // connections with Data Memory
     output  [31:0] ms_riscv32_mp_dmaddr_out,
     output  [31:0] ms_riscv32_mp_dmdata_out,
     output         ms_riscv32_mp_dmwr_req_out,
     output  [3:0 ] ms_riscv32_mp_dmwr_mask_out,
     input   [31:0] ms_riscv32_mp_dmdata_in,
     input  ms_riscv32_mp_data_hready_in,            //AHB ready
     input  ms_riscv32_mp_hresp_in,                  //AHB response
     output [1:0] ms_riscv32_mp_data_htrans_out,     //AHB data trans
     
   //connections with Interrupt Controller
     input  ms_riscv32_mp_eirq_in,
     input  ms_riscv32_mp_tirq_in,
     input  ms_riscv32_mp_sirq_in
    );
    
   //
   // writeback selection
   parameter WB_ALU               =  3'b000;
   parameter WB_LU                =  3'b001;
   parameter WB_IMM               =  3'b010;
   parameter WB_IADDER_OUT        =  3'b011;
   parameter WB_CSR               =  3'b100;
   parameter WB_PC_PLUS           =  3'b101;

   // ---------------------------------
   // Internal wires and registers
   // ---------------------------------
   wire [31:0] iaddr;
   wire [31:0] pc;
   wire [31:0] pc_plus_4;
   wire        misaligned_instr;
   wire [31:0] pc_mux;
   wire [31:0] rs2;
   wire        mem_wr_req;
   
   wire 	   flush;
   wire [6:0 ] opcode;
   wire [2:0 ] funct3;
   wire [6:0 ] funct7;
   wire [4:0 ] rs1_addr;
   wire [4:0 ] rs2_addr;
   wire [4:0 ] rd_addr;
   wire [11:0] csr_addr;
   wire [31:7] instr_31_to_7;
   wire [31:0] rs1;
   wire [31:0] imm;
   wire        iadder_src;
   wire 	   wr_en_csr_file;
   wire 	   wr_en_integer_file;
   wire [11:0] csr_addr_reg;
   wire [2:0] csr_op_reg;
   wire [31:0] imm_reg;
   wire [31:0] rs1_reg;
   wire [31:0] pc_reg2;
   wire i_or_e;
   wire set_cause;
   wire [3:0 ] cause;
      wire set_epc;
   wire instret_inc;
   wire mie_clear;
   wire mie_set;
   wire misaligned_exception;
   wire mie;
   wire meie_out;
   wire mtie_out;
   wire msie_out;
   wire meip_out;
   wire mtip_out;
   wire msip_out;
   wire  rf_wr_en_reg;
   wire csr_wr_en_reg;
   wire csr_wr_en_reg_file;
   wire integer_wr_en_reg_file;
   wire [4:0] rd_addr_reg;
   wire [2:0] wb_mux_sel;
   wire [2:0] wb_mux_sel_reg; 
   wire [31:0] lu_output;
   wire [31:0] alu_result;
   wire [31:0] csr_data;
   wire [31:0] pc_plus_4_reg;
   wire [31:0] iadder_out_reg;
   wire [31:0] rs2_reg;
   wire alu_src_reg;
   wire [31:0] wb_mux_out;
   wire [31:0] alu_2nd_src_mux;
   
   wire illegal_instr;
   wire branch_taken;
   wire [31:0] next_pc;
   reg [31:0] pc_reg;
   wire misaligned_load;
   wire misaligned_store;
   wire [3:0] cause_in;
   wire [1:0] pc_src;
   wire trap_taken;
   wire [1:0] load_size_reg;
   wire [3:0] alu_opcode_reg;
   wire load_unsigned_reg;
/////////////////////////////////////////////////
         
   
   
   
   
   wire [31:0] iadder_out;
   
   wire [31:0] epc;
   wire [31:0] trap_address;
   
   wire [3:0] alu_opcode;
   
   wire [3:0] mem_wr_mask;
   wire [1:0] load_size;
   
   wire load_unsigned;
   
   wire alu_src;
   
   wire csr_wr_en;
   wire rf_wr_en;
   
   
   wire [2:0] imm_type;
   wire [2:0] csr_op;
   
   
   

   
   
   wire [31:0] su_data_out;
   wire [31:0] su_d_addr;
   wire [3:0] su_wr_mask;
   wire su_wr_req;
   
    
   // ---------------------------------
   // PIPELINE STAGE 1
   // ---------------------------------
    
   // PC MUX
    
   msrv32_pc PC(.rst_in(ms_riscv32_mp_rst_in),
                .ahb_ready_in(ms_riscv32_mp_instr_hready_in),
     	        .pc_src_in(pc_src),
    	        .epc_in(epc),
                .trap_address_in(trap_address),
   	        .branch_taken_in(branch_taken),
   	        .iaddr_in(iaddr[31:1]),
    	        .pc_in(pc),
     	        .pc_plus_4_out(pc_plus_4),
	        .misaligned_instr_logic_out(misaligned_instr),
    	        .pc_mux_out(pc_mux),
		.iaddr_out(ms_riscv32_mp_imaddr_out)
               );
			   
   msrv32_reg_block_1 REG1 (.clk_in(ms_riscv32_mp_clk_in),
							.rst_in(ms_riscv32_mp_rst_in),
							.pc_mux_in(pc_mux),
							.pc_out(pc)
							);
     
   // ---------------------------------
   // PIPELINE STAGE 2
   // ---------------------------------       
   //Instruction_decoder
    //complete
   msrv32_instruction_mux ID (.flush_in(flush),
								  .instr_in(ms_riscv32_mp_instr_in),
								  .opcode_out(opcode),
								  .funct3_out(funct3),
								  .funct7_out(funct7),
								  .rs1addr_out(rs1_addr),
								  .rs2addr_out(rs2_addr),
								  .rdaddr_out(rd_addr),
								  .csr_addr_out(csr_addr),
								  .instr_31_7_out(instr_31_to_7)
                                 );
    
    //complete
   msrv32_store_unit SU (
                         .funct3_in(funct3[1:0]), 
                         .ahb_ready_in(ms_riscv32_mp_data_hready_in),
                         .iadder_in(iaddr), 
                         .rs2_in(rs2),
                         .mem_wr_req_in(mem_wr_req),
                         .ms_riscv32_mp_dmdata_out(ms_riscv32_mp_dmdata_out),
                         .ms_riscv32_mp_dmaddr_out(ms_riscv32_mp_dmaddr_out),
                         .ms_riscv32_mp_dmwr_mask_out(ms_riscv32_mp_dmwr_mask_out),
                         .ms_riscv32_mp_dmwr_req_out(ms_riscv32_mp_dmwr_req_out),
                         .ahb_htrans_out(ms_riscv32_mp_data_htrans_out)
                        );
    
    //Decoder

   msrv32_dec DEC (
                   .opcode_in(opcode),
                   .funct7_5_in(funct7[5]),
                   .funct3_in(funct3),
                   .iadder_1_to_0_in(iaddr[1:0]),
                   .trap_taken_in(trap_taken),
                    
                   .alu_opcode_out(alu_opcode),
                   .mem_wr_req_out(mem_wr_req),
                   .load_size_out(load_size),
                   .load_unsigned_out(load_unsigned),
                   .alu_src_out(alu_src),
                   .iadder_src_out(iadder_src),
                   .csr_wr_en_out(csr_wr_en),
                   .rf_wr_en_out(rf_wr_en),
                   .wb_mux_sel_out(wb_mux_sel),
                   .imm_type_out(imm_type),
                   .csr_op_out(csr_op),
                   .illegal_instr_out(illegal_instr),
                   .misaligned_load_out(misaligned_load),
                   .misaligned_store_out(misaligned_store)
                  );
    
   //Immediate Generator

   msrv32_imm_generator IMG (
                   .instr_in(instr_31_to_7),
                   .imm_type_in(imm_type),
                   .imm_out(imm)
                  );
    

   // Immediate Adder
    //complete
   msrv32_immediate_adder IMA(.pc_in(pc),
									.rs1_in(rs1),
									.imm_in(imm),
									.iadder_src_in(iadder_src),
									.iadder_out(iaddr)

   );
    
   //Branch Unit

   msrv32_branch_unit BU (
                 .opcode_in(opcode[6:2]),
                 .funct3_in(funct3),
                 .rs1_in(rs1),
                 .rs2_in(rs2),
                 .branch_taken_out(branch_taken)
                );
    
       
   //Integer File

   msrv32_integer_file IRF(
    
        .clk_in(ms_riscv32_mp_clk_in),
        .rst_in(ms_riscv32_mp_rst_in),
        .rs_1_addr_in(rs1_addr),
        .rs_2_addr_in(rs2_addr),    
        .rs_1_out(rs1),
        .rs_2_out(rs2),
        
        .rd_addr_in(rd_addr_reg),
        .wr_en_in(integer_wr_en_reg_file),
        .rd_in(wb_mux_out)


    );
    
   msrv32_wr_en_generator WREN (.flush_in(flush),
							    .rf_wr_en_reg_in(rf_wr_en_reg),
								.csr_wr_en_reg_in(csr_wr_en_reg),
								.wr_en_int_file_out(integer_wr_en_reg_file),
								.wr_en_csr_file_out(csr_wr_en_reg_file)
							   );
		
   //CSR file

   msrv32_csr_file CSRF(.clk_in(ms_riscv32_mp_clk_in),
						.rst_in(ms_riscv32_mp_rst_in),
						.wr_en_in(csr_wr_en_reg_file),
						.csr_addr_in(csr_addr_reg),
						.csr_op_in(csr_op_reg),
						.csr_uimm_in(imm_reg[4:0]),
						.csr_data_in(rs1_reg),
						.csr_data_out(csr_data),
						.pc_in(pc_reg2),
						.iadder_in(iadder_out_reg),
						.e_irq_in(ms_riscv32_mp_eirq_in),
						.t_irq_in(ms_riscv32_mp_tirq_in),
						.s_irq_in(ms_riscv32_mp_sirq_in),
						.i_or_e_in(i_or_e),
						.set_cause_in(set_cause),
						.cause_in(cause),
						.set_epc_in(set_epc),
						.instret_inc_in(instret_inc),
						.mie_clear_in(mie_clear),
						.mie_set_in(mie_set),
						.misaligned_exception_in(misaligned_exception),
						.mie_out(mie),
						.meie_out(meie),
						.mtie_out(mtie),
						.msie_out(msie),
						.meip_out(meip),
						.mtip_out(mtip),
						.msip_out(msip),
						.real_time_in(ms_riscv32_mp_rc_in),
						.epc_out(epc),
						.trap_address_out(trap_address)

    );
    
    //Machine Control
   
   msrv32_machine_control MC(

        .clk_in(ms_riscv32_mp_clk_in),
        .reset_in(ms_riscv32_mp_rst_in),
        
        .illegal_instr_in(illegal_instr),
        .misaligned_instr_in(misaligned_instr),
        .misaligned_load_in(misaligned_load),
        .misaligned_store_in(misaligned_store),
        
        .opcode_6_to_2_in(opcode[6:2]),
        .funct3_in(funct3),
        .funct7_in(funct7),
        .rs1_addr_in(rs1_addr),
        .rs2_addr_in(rs2_addr),
        .rd_addr_in(rd_addr),
        
        .e_irq_in(ms_riscv32_mp_eirq_in),
        .t_irq_in(ms_riscv32_mp_tirq_in),
        .s_irq_in(ms_riscv32_mp_sirq_in),
        
        .i_or_e_out(i_or_e),   //i_or_e use this local wire
        .set_cause_out(set_cause), //   set_cause use this local wire

        .cause_out(cause),   //cause use this local wire
        .set_epc_out(set_epc), //set_epc use this local wire
        .instret_inc_out(instret_inc), //instret_inc use this local wire
        .mie_clear_out(mie_clear), //mie_clear use this local wire
        .mie_set_out(mie_set), //mie_set use this local wire
        .misaligned_exception_out(misaligned_exception), //misaligned_exception use this local wire
        .mie_in(mie),   //mie use this local wire
        .meie_in(meie),
        .mtie_in(mtie),
        .msie_in(msie),
        .meip_in(meip),
        .mtip_in(mtip),
        .msip_in(msip),
        
        .pc_src_out(pc_src),
        
        .flush_out(flush),
        
        .trap_taken_out(trap_taken)

   );    

    
   // Stages 1/2 interface registers
   msrv32_reg_block_2  REG2 (
                             .rd_addr_in(rd_addr),
	                     .csr_addr_in(csr_addr),
	                     .rs1_in(rs1),
	                     .rs2_in(rs2),
	                     .pc_in(pc),
	                     .pc_plus_4_in(pc_plus_4),
	                     .iadder_out_in(iaddr),
	                     .imm_in(imm),
	                     .alu_opcode_in(alu_opcode),
	                     .load_size_in(load_size),
	                     .wb_mux_sel_in(wb_mux_sel),
	                     .csr_op_in(csr_op),
	                     .load_unsigned_in(load_unsigned),
	                     .alu_src_in(alu_src),
	                     .csr_wr_en_in(csr_wr_en),
	                     .rf_wr_en_in(rf_wr_en),
	                     .branch_taken_in(branch_taken),
	    
		 	     .clk_in(ms_riscv32_mp_clk_in),
	                     .rst_in(ms_riscv32_mp_rst_in),

                             .rd_addr_reg_out(rd_addr_reg),
	                     .csr_addr_reg_out(csr_addr_reg),
	                     .rs1_reg_out(rs1_reg),
                             .rs2_reg_out(rs2_reg),
	                     .pc_reg_out(pc_reg2),
	                     .pc_plus_4_reg_out(pc_plus_4_reg),
	                     .iadder_out_reg_out(iadder_out_reg),
	                     .imm_reg_out(imm_reg),
	                     .alu_opcode_reg_out(alu_opcode_reg),
	                     .load_size_reg_out(load_size_reg),
	                     .wb_mux_sel_reg_out(wb_mux_sel_reg),
	                     .csr_op_reg_out(csr_op_reg),
	                     .load_unsigned_reg_out(load_unsigned_reg),
	                     .alu_src_reg_out(alu_src_reg),   // 
	                     .csr_wr_en_reg_out(csr_wr_en_reg),
	                     .rf_wr_en_reg_out(rf_wr_en_reg)
                            );
    
   // ---------------------------------
   // PIPELINE STAGE 3
   // ---------------------------------
    
   // Load Unit

   msrv32_load_unit LU (
                 .load_size_in(load_size_reg),
                 //.clk_in(ms_riscv32_mp_clk_in),
                 //.misaligned_load_in(misaligned_load),
                 .load_unsigned_in(load_unsigned_reg),
                 .ms_riscv32_mp_dmdata_in(ms_riscv32_mp_dmdata_in),
                 .iadder_out_1_to_0_in(iadder_out_reg[1:0]),
                 .lu_output_out(lu_output),
                 .ahb_resp_in(ms_riscv32_mp_hresp_in)
                );
    
      
   //ALU

   msrv32_alu ALU (
                   .op1_in(rs1_reg),
                   .op2_in(alu_2nd_src_mux),
                   .opcode_in(alu_opcode_reg),
                   .result_out(alu_result)
                  );    
    
   msrv32_wb_mux_sel_unit WBMUX(.wb_mux_sel_reg_in(wb_mux_sel_reg), 
                                .alu_result_in(alu_result),.lu_output(lu_output),.imm_reg_in(imm_reg),
			                    .iadder_out_reg_in(iadder_out_reg),.csr_data_in(csr_data),.pc_plus_4_reg_in(pc_plus_4_reg),.rs2_reg_in(rs2_reg),   
			                    .alu_src_reg_in(alu_src_reg),
			                    .wb_mux_out(wb_mux_out), 
				                .alu_2nd_src_mux_out(alu_2nd_src_mux));   
   
    
endmodule