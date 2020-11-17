module synchronizer_sram (
	input [31:0] D_in,
	input [11:0] addr,
	input [1:0] conf,
	input csb,
	input web,
	
	output [31:0] D_in_sync,
	output [11:0] addr_sync,
	output [1:0] conf_sync,
	output csb_sync,
	output web_sync,
	
	input sram_clk
);

	reg [31:0] D_in_int, D_in_reg;
	reg [11:0] addr_int, addr_reg;
	reg [1:0] conf_int, conf_reg;
	reg csb_int, csb_reg;
	reg web_int, web_reg;
	
	assign D_in_sync = D_in_reg;
	assign addr_sync = addr_reg;
	assign conf_sync = conf_reg;
	assign csb_sync = csb_reg;
	assign web_sync = web_reg;
	
	always @(posedge sram_clk) begin
		D_in_int <= D_in;
		addr_int <= addr;
		conf_int <= conf;
		csb_int <= csb;
		web_int <= web;
		
		D_in_reg <= D_in_int;
		addr_reg <= addr_int;
		conf_reg <= conf_int;
		csb_reg <= csb_int;
		web_reg <= web_int;
	end

endmodule
