module alu_tb;

    logic [31:0] a;
    logic [31:0] b;
    logic [3:0]  alu_control;
    logic [31:0] result;

    alu dut (
        .a(a),
        .b(b),
        .alu_control(alu_control),
        .result(result)
    );

    initial begin

        // ADD
        a = 500;
        b = 123;
        alu_control = 4'b0000;
        #1;

        $display("ADD: %0d", result);

        // SUB
        a = 10;
        b = 5;
        alu_control = 4'b0001;
        #1;

        $display("SUB: %0d", result);

        // AND
        a = 32'b1100;
        b = 32'b1010;
        alu_control = 4'b0010;
        #1;

        $display("AND: %b", result);

        // OR
        a = 32'b1100;
        b = 32'b1010;
        alu_control = 4'b0011;
        #1;

        $display("OR:  %b", result);

        // XOR
        a = 32'b1100;
        b = 32'b1010;
        alu_control = 4'b0100;
        #1;

           $display("XOR: %b", result);

           // NOT
        a = 500;
        b = 123;
        alu_control = 4'b0101;
        #1;

        $display("NOT: %b", result);
        $finish;
    end

endmodule