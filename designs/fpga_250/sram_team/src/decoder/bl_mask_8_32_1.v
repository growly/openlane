module bl_mask_8_32_1 (
	input [1:0] addr,
	input [1:0] conf,
	
	output [3:0] bl_mask
);

	wire addr1_b, addr0_b;
	not a0_b (addr0_b, addr[0]);
	not a1_b (addr1_b, addr[1]);

	wire conf0_b, conf1_b;
	not c0_b (conf0_b, conf[0]);
	not c1_b (conf1_b, conf[1]);
	
	wire c32, c16_b, c8_b;
	nor c32_g1 (c32, conf[1], conf[0]);
	nand c16_g1 (c16_b, conf1_b, conf[0]);
	nand c8_g1 (c8_b, conf[1], conf0_b);
	
	wire c16_h1_en, c16_h2_en;
	nor c16_h1_g1 (c16_h1_en, c16_b, addr[0]);
	nor c16_h2_g1 (c16_h2_en, c16_b, addr0_b);
	
	wire h1_en_b, h2_en_b;
	wire h1_en, h2_en;
	nor (h1_en_b, c32, c16_h1_en);
	nor (h2_en_b, c32, c16_h2_en);
	not (h1_en, h1_en_b);
	not (h2_en, h2_en_b);
	
	wire c8_q1_en, c8_q2_en, c8_q3_en, q8_q4_en;
	nor c8_q1_g1 (c8_q1_en, c8_b, addr[1], addr[0]);
	nor c8_q2_g1 (c8_q2_en, c8_b, addr[1], addr0_b);
	nor c8_q3_g1 (c8_q3_en, c8_b, addr1_b, addr[0]);
	nor c8_q4_g1 (c8_q4_en, c8_b, addr1_b, addr0_b);
	
	wire q1_en_b, q2_en_b, q3_en_b, q4_en_b;
	nor q1_g1 (q1_en_b, h1_en, c8_q1_en);
	nor q2_g1 (q2_en_b, h1_en, c8_q2_en);
	nor q3_g1 (q3_en_b, h2_en, c8_q3_en);
	nor q4_g1 (q4_en_b, h2_en, c8_q4_en);
	
	assign bl_mask = { q4_en_b, q3_en_b, q2_en_b, q1_en_b };
	
endmodule
