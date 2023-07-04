
module msrv32_alu_tb;
    reg [31:0] op1_in, op2_in;
    reg [3:0] opcode_in;
    wire [31:0] result_out;
    
    msrv32_alu dut (
        .op1_in(op1_in),
        .op2_in(op2_in),
        .opcode_in(opcode_in),
        .result_out(result_out)
    );
    
    initial begin
        // Test case 1
        op1_in = 10;
        op2_in = 5;
        opcode_in = 4'b0000;
        #10;
        $display("op1_in = %d, op2_in = %d, opcode_in = %b, result_out = %d", op1_in, op2_in, opcode_in, result_out);
        
        // Test case 2
        op1_in = 8;
        op2_in = 3;
        opcode_in = 4'b1000;
        #10;
        $display("op1_in = %d, op2_in = %d, opcode_in = %b, result_out = %d", op1_in, op2_in, opcode_in, result_out);
        
        // Test case 3
        op1_in = 1234;
        op2_in = 5678;
        opcode_in = 4'b0111;
        #10;
        $display("op1_in = %d, op2_in = %d, opcode_in = %b, result_out = %d", op1_in, op2_in, opcode_in, result_out);
        
        // Add more test cases as needed
        
        // End simulation
        #10;
        $finish;
    end
endmodule
