module SRAM_unit_input_shifter (
	input [7:0] d_in,
	input c8, c4, c2, c1,
	
	output [7:0] d_sram
);

	assign d_sram[7] = (c1) ? d_in[0] : ( (c2) ? d_in[1] : ( (c4) ? d_in[3] : d_in[7] ) );
	assign d_sram[6] = (c1 || c2) ? d_in[0] : ( (c4) ? d_in[2] : d_in[6] );
	assign d_sram[5] = (c1) ? d_in[0] : ( (c2 || c4) ? d_in[1] : d_in[5] );
	assign d_sram[4] = (c1 || c2 || c4) ? d_in[0] : d_in[4];
	
	assign d_sram[3] = (c1) ? d_in[0] : ( (c2) ? d_in[1] : d_in[3] );
	assign d_sram[2] = (c1 || c2) ? d_in[0] : d_in[2];
	assign d_sram[1] = (c1) ? d_in[0] : d_in[1];
	assign d_sram[0] = d_in[0];

endmodule
