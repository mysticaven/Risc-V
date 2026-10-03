module alu (
    input logic [31:0] a,
    input logic [31:0] b,
    input logic [3:0] alu_control,
    output logic [31:0] result
);

    always_comb begin
        case (alu_control)

            4'b0000: result = a + b;  // ADD
            4'b0001: result = a - b;  // SUB
            4'b0010: result = a & b;  // AND
            4'b0011: result = a | b;  // OR
            4'b0100: result = a ^ b;  // XOR
            4'b0101: result = ~a;     // NOT
            4'b1010: result = a << b; // SLL
            4'b1011: result = a >> b; // SRL

            default: result = 32'b0;

        endcase
    end

endmodule

//iverilog -g2012 -Wall -o alu_sim rtl/alu.sv tb/alu_tb.sv
//vvp alu_sim