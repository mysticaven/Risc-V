module instruction_memory (
    input  logic [31:0] address,
    output logic [31:0] instruction
);

    logic [31:0] memory [0:255]; // 256 x 32-bit instruction memory
    initial begin
        // Initialize instruction memory with some instructions
        memory[0] = 32'h00000013; // NOP (ADDI x0, x0, 0)
        memory[1] = 32'h00100093; // ADDI x1, x0, 1
        memory[2] = 32'h00200113; // ADDI x2, x0, 2
        memory[3] = 32'h00308193; // ADDI x3, x1, 3
        memory[4] = 32'h00410213; // ADDI x4, x2, 4
        memory[5] = 32'h00518293; // ADDI x5, x3, 5
        memory[6] = 32'h00620313; // ADDI x6, x4, 6
        memory[7] = 32'h00728393; // ADDI x7, x5, 7
        memory[8] = 32'h00830413; // ADDI x8, x6, 8
        memory[9] = 32'h00938493; // ADDI x9, x7, 9
    end
    assign instruction = memory[address[9:2]]; // Use bits [9:2] of the address to index the memory
endmodule