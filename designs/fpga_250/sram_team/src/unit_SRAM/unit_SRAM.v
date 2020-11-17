`include "/home/adhiraj/sram_team/src/behavioral/sram_32_1024_scn4m_subm.v"
`include "/home/adhiraj/sram_team/src/decoder/bl_mask_8_32_1.v"
`include "/home/adhiraj/sram_team/src/decoder/data_in_mux_8_32_1.v"
`include "/home/adhiraj/sram_team/src/decoder/data_out_mux_8_32_1.v"
`include "/home/adhiraj/sram_team/src/input/synchronizer_sram.v"

module unit_SRAM (
	input sram_clk,
	
	input [31:0] D_in,
	output [31:0] D_out,
	
	input [11:0] addr,
	
	input [1:0] conf,
	
	input csb,
	input web
);

	wire [31:0] D_in_sync;
	wire [1:0] conf_sync;
	wire [11:0] addr_sync;
	wire csb_sync, web_sync;

	synchronizer_sram sync (
		.D_in(D_in),
		.addr(addr),
		.conf(conf),
		.csb(csb),
		.web(web),
		
		.D_in_sync(D_in_sync),
		.conf_sync(conf_sync),
		.addr_sync(addr_sync),
		.csb_sync(csb_sync),
		.web_sync(web_sync),
		
		.sram_clk(sram_clk)
	);
	
	reg [1:0] conf_registered;
	reg [1:0] addr_overflow_registered;
	always @(posedge sram_clk) begin
		conf_registered <= conf_sync;
		addr_overflow_registered <= addr_sync[11:10];
	end
	
	wire [31:0] D_in_sram;
	
	data_in_mux_8_32_1 data_in_mux (
		.D(D_in_sync),
		.conf(conf_sync),
		
		.data_in(D_in_sram)
	);
	
	wire [3:0] write_mask;
	
	bl_mask_8_32_1 bl_mask_8_32 (
		.addr(addr_sync[11:10]),
		.conf(conf_sync),
		
		.bl_mask(write_mask)	
	);
	
	wire [31:0] D_out_sram;
	
	sram_32_1024_scn4m_subm sram (
		.clk0(sram_clk),
		.csb0(csb_sync),
		.web0(web_sync),
		.wmask0(write_mask),
		.addr0(addr_sync[9:0]),
		.din0(D_in_sram),
		.dout0(D_out_sram)
	);
	
	data_out_mux_8_32_1 data_out_mux (
		.D(D_out_sram),
		.conf(conf_registered),
		.addr(addr_overflow_registered),
		
		.data_out(D_out)
	);

endmodule
