`include "/home/adhiraj/sram_team/src/decoder/bl_mask_8_32_2.v"

`timescale 1ns/1ns

`define SECOND 1000000000
`define MS 1000000

module bl_mask_tb_2 (

);

	reg [1:0] addr;
	reg [1:0] conf;
	wire [31:0] bl_mask;
	
	bl_mask_8_32_2 bl_mask_2 (
		.addr(addr),
		.conf(conf),
		.bl_mask(bl_mask)
	);
	
	initial begin
		$dumpfile("bl_mask_2.vcd");
		$dumpvars(0,bl_mask_tb_2);
		
		#(5);
		
		conf = 2'b00;
		addr = 2'b00;
		#(10);
		
		conf = 2'b01;
		addr = 2'b00;
		#(10);
		
		addr = 2'b01;
		#(10);
		
		conf = 2'b10;
		addr = 2'b00;
		#(10);
		
		addr = 2'b01;
		#(10);
		
		addr = 2'b10;
		#(10);
		
		addr = 2'b11;
		#(10);
		
		$finish();
	end

endmodule
