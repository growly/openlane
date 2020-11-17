module SRAM_unit_bl_mask (
	input [2:0] unit_3_8_dec_sel,
	input c8, c4, c2, c1,
	
	output [7:0] bit_mask
);

	wire h1_en, h2_en;
	assign h1_en = c8 || (c4 && !unit_3_8_dec_sel[0]);
	assign h2_en = c8 || (c4 && unit_3_8_dec_sel[0]);
	
	wire q1_en, q2_en, q3_en, q4_en;
	assign q1_en = h1_en || (c2 && !unit_3_8_dec_sel[1] && !unit_3_8_dec_sel[0]);
	assign q2_en = h1_en || (c2 && !unit_3_8_dec_sel[1] && unit_3_8_dec_sel[0]);
	assign q3_en = h2_en || (c2 && unit_3_8_dec_sel[1] && !unit_3_8_dec_sel[0]);
	assign q4_en = h2_en || (c2 && unit_3_8_dec_sel[1] && unit_3_8_dec_sel[0]);
	
	assign bit_mask[7] = q4_en || (c1 && unit_3_8_dec_sel[2] && unit_3_8_dec_sel[1] && unit_3_8_dec_sel[0]);
	assign bit_mask[6] = q4_en || (c1 && unit_3_8_dec_sel[2] && unit_3_8_dec_sel[1] && !unit_3_8_dec_sel[0]);
	assign bit_mask[5] = q3_en || (c1 && unit_3_8_dec_sel[2] && !unit_3_8_dec_sel[1] && unit_3_8_dec_sel[0]);
	assign bit_mask[4] = q3_en || (c1 && unit_3_8_dec_sel[2] && !unit_3_8_dec_sel[1] && !unit_3_8_dec_sel[0]);
	assign bit_mask[3] = q2_en || (c1 && !unit_3_8_dec_sel[2] && unit_3_8_dec_sel[1] && unit_3_8_dec_sel[0]);
	assign bit_mask[2] = q2_en || (c1 && !unit_3_8_dec_sel[2] && unit_3_8_dec_sel[1] && !unit_3_8_dec_sel[0]);
	assign bit_mask[1] = q1_en || (c1 && !unit_3_8_dec_sel[2] && !unit_3_8_dec_sel[1] && unit_3_8_dec_sel[0]);
	assign bit_mask[0] = q1_en || (c1 && !unit_3_8_dec_sel[2] && !unit_3_8_dec_sel[1] && !unit_3_8_dec_sel[0]);

endmodule
