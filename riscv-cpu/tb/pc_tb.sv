module pc_tb;

    logic        clk;
    logic        reset;
    logic [31:0] next_pc;
    logic [31:0] current_pc;

    pc dut (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .current_pc(current_pc)
    );

    always #5 clk = ~clk;

    initial begin

        clk = 0;
        reset = 1;
        next_pc = 0;

        // Reset PC
        #10;

        $display("After reset: PC = %d", current_pc);

        // Normal operation
        reset = 0;

        next_pc = 10;
        #10;

        $display("PC = %d", current_pc);

        next_pc = 23;
        #10;

        $display("PC = %d", current_pc);

        next_pc = 112;
        #10;

        $display("PC = %d", current_pc);

        $finish;

    end

endmodule