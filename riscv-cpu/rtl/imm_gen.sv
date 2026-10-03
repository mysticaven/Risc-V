module imm_gen (
	input  logic [31:0] instruction,
	output logic [31:0] immediate
);

	assign immediate = {{20{instruction[31]}}, instruction[31:20]};

endmodule


