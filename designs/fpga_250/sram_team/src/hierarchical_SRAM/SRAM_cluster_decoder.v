module SRAM_cluster_decoder (
	input [31:0] d_fabric,
	input [1:0] unit_2_4_dec_sel,
	input c32, c16, c8, c4, c2, c1,
	
	output [7:0] d_A, d_B, d_C, d_D,
	output csb_A, csb_B, csb_C, csb_D
);

	assign d_A = (c32) ? d_fabric[31:24] : ( (c16) ? d_fabric[15:8] : d_fabric[7:0] );
	assign d_B = (c32) ? d_fabric[23:16] : d_fabric[7:0];
	assign d_C = (c32 || c16) ? d_fabric[15:8] : d_fabric[7:0];
	assign d_D = d_fabric[7:0];
	
	wire c16_h1, c16_h2;
	assign c16_h1 = c16 && !unit_2_4_dec_sel[0];
	assign c16_h2 = c16 && unit_2_4_dec_sel[0];
	
	assign csb_A = !((c32) || (c16_h1) || (!unit_2_4_dec_sel[1] && !unit_2_4_dec_sel[0]));
	assign csb_B = !((c32) || (c16_h1) || (!unit_2_4_dec_sel[1] && unit_2_4_dec_sel[0]));
	assign csb_C = !((c32) || (c16_h2) || (unit_2_4_dec_sel[1] && !unit_2_4_dec_sel[0]));
	assign csb_D = !((c32) || (c16_h2) || (unit_2_4_dec_sel[1] && unit_2_4_dec_sel[0]));

endmodule
