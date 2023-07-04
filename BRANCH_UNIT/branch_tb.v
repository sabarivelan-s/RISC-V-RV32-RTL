module msrv32_branch_unit_tb;
    reg [31:0] rs1_in, rs2_in;
    reg [4:0] opcode_in;
    reg [2:0] funct3_in;
    wire branch_taken_out;
    
    msrv32_branch_unit dut (
        .rs1_in(rs1_in),
        .rs2_in(rs2_in),
        .opcode_in(opcode_in),
        .funct3_in(funct3_in),
        .branch_taken_out(branch_taken_out)
    );
    
    initial begin
        // Test case 1
        rs1_in = 10;
        rs2_in = 10;
        opcode_in = 5'b110_00;
        funct3_in = 3'b000;
        #10;
        //$display("rs1_in = %d, rs2_in = %d, opcode_in = %b, funct3_in = %b, branch_taken_out = %b", rs1_in, rs2_in, opcode_in, funct3_in, branch_taken_out);
        
        // Test case 2
        rs1_in = 8;
        rs2_in = 8;
        opcode_in = 5'b110_00;
        funct3_in = 3'b001;
        #10;
        //$display("rs1_in = %d, rs2_in = %d, opcode_in = %b, funct3_in = %b, branch_taken_out = %b", rs1_in, rs2_in, opcode_in, funct3_in, branch_taken_out);
        
        // Test case 3
        rs1_in = 1234;
        rs2_in = 5678;
        opcode_in = 5'b110_01;
        funct3_in = 3'b100;
        #10;
        $monitor("rs1_in = %d, rs2_in = %d, opcode_in = %b, funct3_in = %b, branch_taken_out = %b", rs1_in, rs2_in, opcode_in, funct3_in, branch_taken_out);
        
        // Add more test cases as needed
        
        // End simulation
        #10;
        $finish;
    end
endmodule

