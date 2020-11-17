`include "/home/adhiraj/sram_team/src/hierarchical_SRAM/SRAM_cluster_decoder.v"
`include "/home/adhiraj/sram_team/src/hierarchical_SRAM/SRAM_unit_bl_mask.v"
`include "/home/adhiraj/sram_team/src/hierarchical_SRAM/SRAM_unit_input_shifter.v"
`include "/home/adhiraj/sram_team/src/hierarchical_SRAM/SRAM_unit_output_shifter.v"
`include "/home/adhiraj/sram_team/src/hierarchical_SRAM/SRAM_cluster_output.v"

module SRAM_interface (
	input [31:0] d_fabric,
	input csb,
	input web,
	input [8:0] addr,
	input [1:0] addr_2_4,
	input [2:0] addr_3_8,
	input [2:0] conf,
	
	output web_sram,
	output csb_sram_A, csb_sram_B, csb_sram_C, csb_sram_D,
	output [7:0] d_sram_in_A, d_sram_in_B, d_sram_in_C, d_sram_in_D,
	output [7:0] bl_mask,
	
	input clk,
	
	input [7:0] d_sram_out_A, d_sram_out_B, d_sram_out_C, d_sram_out_D,
	
	output [31:0] d_out
);

	// sync capture - pipeline stage 1 ---------------
	reg [31:0] d_fabric_sync;
	reg csb_sync;
	reg web_sync;
	reg [8:0] addr_sync;
	reg [1:0] addr_2_4_sync;
	reg [2:0] addr_3_8_sync;
	reg [2:0] conf_sync;
	always @(posedge clk) begin
		d_fabric_sync <= d_fabric;
		csb_sync <= csb;
		web_sync <= web;
		addr_sync <= addr;
		addr_2_4_sync <= addr_2_4;
		addr_3_8_sync <= addr_3_8;
		conf_sync <= conf;
	end
	//------------------------------------------------
	
	wire c32_sync, c16_sync, c8_sync, c4_sync, c2_sync, c1_sync;
	assign c32_sync = conf_sync[2] && !conf_sync[1] && conf_sync[0];
	assign c16_sync = conf_sync[2] && !conf_sync[1] && !conf_sync[0];
	assign c8_sync = !conf_sync[2] && conf_sync[1] && conf_sync[0];
	assign c4_sync = !conf_sync[2] && conf_sync[1] && !conf_sync[0];
	assign c2_sync = !conf_sync[2] && !conf_sync[1] && conf_sync[0];
	assign c1_sync = !conf_sync[2] && !conf_sync[1] && !conf_sync[0];
	
	wire [7:0] d_A, d_B, d_C, d_D; // data assigned to appropriate sub-SRAM but not word aligned
	
	SRAM_cluster_decoder cluster_decode_in (
		.d_fabric(d_fabric_sync),
		.unit_2_4_dec_sel(addr_2_4_sync),
		.c32(c32_sync), .c16(c16_sync), .c8(c8_sync), .c4(c4_sync), .c2(c2_sync), .c1(c1_sync),
		
		.d_A(d_A), .d_B(d_B), .d_C(d_C), .d_D(d_D),
		.csb_A(csb_sram_A), .csb_B(csb_sram_B), .csb_C(csb_sram_C), .csb_D(csb_sram_D)
	);
	
	SRAM_unit_bl_mask bl_mask_gen (
		.unit_3_8_dec_sel(addr_3_8_sync),
		.c8(c8_sync), .c4(c4_sync), .c2(c2_sync), .c1(c1_sync),
		
		.bit_mask(bl_mask)
	);
	
	SRAM_unit_input_shifter shift_in_A (
		.d_in(d_A),
		.c8(c8_sync), .c4(c4_sync), .c2(c2_sync), .c1(c1_sync),
		.d_sram(d_sram_in_A)
	);
	SRAM_unit_input_shifter shift_in_B (
		.d_in(d_B),
		.c8(c8_sync), .c4(c4_sync), .c2(c2_sync), .c1(c1_sync),
		.d_sram(d_sram_in_B)
	);
	SRAM_unit_input_shifter shift_in_C (
		.d_in(d_C),
		.c8(c8_sync), .c4(c4_sync), .c2(c2_sync), .c1(c1_sync),
		.d_sram(d_sram_in_C)
	);
	SRAM_unit_input_shifter shift_in_D (
		.d_in(d_D),
		.c8(c8_sync), .c4(c4_sync), .c2(c2_sync), .c1(c1_sync),
		.d_sram(d_sram_in_D)
	);
	
	assign web_sram = web_sync;
	
	// register required inputs for output stage - used during read operation
	reg [2:0] addr_3_8_out;
	reg c8_out, c4_out, c2_out, c1_out;
	reg csb_A_out, csb_B_out, csb_C_out, csb_D_out;
	always @(posedge clk) begin
		c8_out <= c8_sync;
		c4_out <= c4_sync;
		c2_out <= c2_sync;
		c1_out <= c1_sync;
		
		csb_A_out <= csb_sram_A;
		csb_B_out <= csb_sram_B;
		csb_C_out <= csb_sram_C;
		csb_D_out <= csb_sram_D;
		
		addr_3_8_out <= addr_3_8_sync;
	end
	
	// SRAM output aligner and shifter
	wire [7:0] d_shift_A, d_shift_B, d_shift_C, d_shift_D;
	
	SRAM_unit_output_shifter shift_out_A (
		.d_sram(d_sram_out_A),
		.addr(addr_3_8_out),
		.c8(c8_out), .c4(c4_out), .c2(c2_out), .c1(c1_out),
		.d_fabric(d_shift_A)
	);
	SRAM_unit_output_shifter shift_out_B (
		.d_sram(d_sram_out_B),
		.addr(addr_3_8_out),
		.c8(c8_out), .c4(c4_out), .c2(c2_out), .c1(c1_out),
		.d_fabric(d_shift_B)
	);
	SRAM_unit_output_shifter shift_out_C (
		.d_sram(d_sram_out_C),
		.addr(addr_3_8_out),
		.c8(c8_out), .c4(c4_out), .c2(c2_out), .c1(c1_out),
		.d_fabric(d_shift_C)
	);
	SRAM_unit_output_shifter shift_out_D (
		.d_sram(d_sram_out_D),
		.addr(addr_3_8_out),
		.c8(c8_out), .c4(c4_out), .c2(c2_out), .c1(c1_out),
		.d_fabric(d_shift_D)
	);
	
	SRAM_cluster_output cluster_out (
		.d_sram_A(d_shift_A), .d_sram_B(d_shift_B), .d_sram_C(d_shift_C), .d_sram_D(d_shift_D),
		.csb_out_A(csb_A_out), .csb_out_B(csb_B_out), .csb_out_C(csb_C_out), .csb_out_D(csb_D_out),
		
		.d_fabric(d_out)
	);

endmodule
