module regfile_tb;

    // Testbench signals
    logic        clk;
    logic        reset;

    logic [4:0]  rs1;
    logic [4:0]  rs2;

    logic [4:0]  rd;
    logic [31:0] write_data;
    logic        reg_write;

    logic [31:0] read_data1;
    logic [31:0] read_data2;

    // Instantiate the register file
    regfile dut (
        .clk(clk),
        .reset(reset),

        .rs1(rs1),
        .rs2(rs2),

        .rd(rd),
        .write_data(write_data),
        .reg_write(reg_write),

        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin

        // Start with known values
        clk = 0;
        reset = 1;

        rs1 = 0;
        rs2 = 0;
        rd = 0;
        write_data = 0;
        reg_write = 0;

        // Keep reset active for one clock cycle
        #10;

        reset = 0;

        // --------------------------------
        // Test 1: Write 100 to x5
        // --------------------------------

        rd = 5;
        write_data = 100;
        reg_write = 1;

        #10;

        reg_write = 0;

        // Read x5
        rs1 = 5;

        #1;

        $display("Test 1: x5 = %d", read_data1);

        // --------------------------------
        // Test 2: Write 200 to x6
        // --------------------------------

        rd = 6;
        write_data = 200;
        reg_write = 1;

        #10;

        reg_write = 0;

        // Read x5 and x6 simultaneously
        rs1 = 5;
        rs2 = 6;

        #1;

        $display("Test 2: x5 = %d, x6 = %d",
                 read_data1, read_data2);

        // --------------------------------
        // Test 3: x0 must always be zero
        // --------------------------------

        rs1 = 0;

        #1;

        $display("Test 3: x0 = %d", read_data1);

        // --------------------------------
        // Test 4: Try writing to x0
        // --------------------------------

        rd = 0;
        write_data = 999;
        reg_write = 1;

        #10;

        reg_write = 0;

        rs1 = 0;

        #1;

        $display("Test 4: x0 after write attempt = %d",
                 read_data1);

        // --------------------------------
        // End simulation
        // --------------------------------

        #10;

        $finish;
    end

endmodule