module decoder_tb;

    logic [31:0] instruction;

    logic [6:0] opcode;
    logic [4:0] rd;
    logic [4:0] rs1;
    logic [4:0] rs2;
    logic [2:0] funct3;
    logic [6:0] funct7;

    decoder dut (
        .instruction(instruction),
        .opcode(opcode),
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2),
        .funct3(funct3),
        .funct7(funct7)
    );

    initial begin

        instruction = 32'h00100093;

        #1;

        $display("Instruction = %h", instruction);
        $display("opcode       = %b", opcode);
        $display("rd           = %d", rd);
        $display("rs1          = %d", rs1);
        $display("rs2          = %d", rs2);
        $display("funct3       = %b", funct3);
        $display("funct7       = %b", funct7);

        $finish;

    end

endmodule