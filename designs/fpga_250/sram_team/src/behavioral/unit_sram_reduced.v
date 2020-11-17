`include "unit_sram.v"

// SRAM behavioral model
// enables, data and addr are registered on positive sram clock edge
// read, write occurs on negative sram clock edge

// Ports:
// d_in : 32 bit bus with data integers
// addr : 10 bit address bus
//		for word widths > 1, d_in[31:27] used as 5 address MSBs
// sram_clk : SRAM clock. Inputs registered on posedge. R/W occurs on negedge
// wen : Write enable. Registers on posedge
// ren : Read enable. Registers on posedge
// reg_out : determined whether to direct registered or direct output to d_out (1 for registered)
// c : config bits. See below for mapping.
// d_out : output data port.

// config mapping:
//		000: 32 bit word, 10 LSB of address used
//		001: 16 bit word, 11 LSB of address used
//		010: 8 bit word, 12 LSB of address used
//		011: 4 bit word, 13 LSB of address used
//		100: 2 bit word, 14 LSB of address used
//		101: 1 bit word, 15 LSB of address used

module unit_sram_reduced (
		input sram_clk, wen, ren, reg_out,
		input [9:0] addr,
		input [31:0] d_in,
		input [2:0] c,

		output [31:0] d_out
	);

	unit_sram sram (
		.sram_clk(sram_clk),
		.wen(wen),
		.ren(ren),
		.d_in(d_in),
		.reg_out(reg_out),
		.addr({d_in[31:27],addr}),
		.c(c),
		.d_out(d_out)
	);

endmodule