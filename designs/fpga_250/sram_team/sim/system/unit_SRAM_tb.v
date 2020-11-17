`include "/home/adhiraj/sram_team/src/unit_SRAM/unit_SRAM.v"

`timescale 1ns/1ns

`define SECOND 1000000000
`define MS 1000000

module unit_SRAM_tb();
    
	reg clk, csb, web;
	reg [31:0] D_in;
	reg [11:0] addr;
	reg [1:0] conf;
	
	wire [31:0] D_out;
	
	initial clk = 0;
	always #(4) clk = ~clk;
	
	unit_SRAM sram (
		.sram_clk(clk),
		.D_in(D_in),
		.D_out(D_out),
		.addr(addr),
		.conf(conf),
		.csb(csb),
		.web(web)
	);
	
	initial begin
		$dumpfile("unit_SRAM_tb.vcd");
		$dumpvars(0,unit_SRAM_tb);
		
		#(2);
		conf = 2'b00;
		addr = 11'b0;
		D_in = 32'hAABBCCDD;
		csb = 1'b0;
		web = 1'b0;
		
		#(8);
		csb = 1'b1;
		
		#(8);
		csb = 1'b0;
		web = 1'b1;
		
		#(24);
		$finish();
	end

endmodule
