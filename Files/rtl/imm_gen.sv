module imm_gen(
input  logic [31:0] instruction,
input  logic [2:0]  immediate;

);
assingn immediate = {{20{instruction[31]}}, instruction[31:20]}; // Sign-extend the immediate value
endmodule1


