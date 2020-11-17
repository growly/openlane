// SRAM behavioral model
// enables, data and addr are registered on positive sram clock edge
// read, write occurs on negative sram clock edge

// Ports:
// d_in : 32 bit bus with data integers
// addr : 15 bit address bus. MSBs dropped for word widths > 1 (see below)
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

module unit_sram (
		input sram_clk, wen, ren, reg_out,
		input [14:0] addr,
		input [31:0] d_in,
		input [2:0] c,

		output [31:0] d_out
	);

	parameter RAM_DEPTH = 1 << 15; 
	reg [RAM_DEPTH-1:0] mem;

	reg [31:0] d_in_reg, d_out_reg, d_out_registered;
	reg wen_reg, ren_reg;
	reg [2:0] c_reg;
	reg [14:0] addr_reg;

	reg address_obs;

	always @(posedge sram_clk) begin
		wen_reg <= wen;
		ren_reg <= ren;
		addr_reg <= addr;
		d_in_reg <= d_in;
		c_reg <= c;
		d_out_registered <= d_out_reg;
		d_out_reg <= 32'bx;
	end

	always @(negedge sram_clk)
	begin : MEM_WRITE
		if (wen_reg) begin
			case (c_reg)
				3'b000 : mem[addr_reg[9:0] << 5 +: 32] <= d_in_reg[31:0];
				3'b001 : mem[addr_reg[10:0] << 4 +: 16] <= d_in_reg[15:0];
				3'b010 : mem[addr_reg[11:0] << 3 +: 8] <= d_in_reg[7:0];
				3'b011 : mem[addr_reg[12:0] << 2 +: 4] <= d_in_reg[3:0];
				3'b100 : mem[addr_reg[13:0] << 1 +: 2] <= d_in_reg[1:0];
				default : mem[addr_reg[14:0]] <= d_in_reg[0];
			endcase
		end
	end

	always @(negedge sram_clk)
	begin : MEM_READ
		if (ren_reg) begin
			case (c)
				3'b000 : d_out_reg <= mem[addr_reg[9:0] << 5 +: 32];
				3'b001 : d_out_reg <= mem[addr_reg[10:0] << 4 +: 16];
				3'b010 : d_out_reg <= mem[addr_reg[11:0] << 3 +: 8];
				3'b011 : d_out_reg <= mem[addr_reg[12:0] << 2 +: 4];
				3'b100 : d_out_reg <= mem[addr_reg[13:0] << 1 +: 2];
				default : d_out_reg <= mem[addr_reg[14:0]];
			endcase
		end
	end

	assign d_out = (reg_out == 1) ? d_out_registered : d_out_reg;

endmodule


