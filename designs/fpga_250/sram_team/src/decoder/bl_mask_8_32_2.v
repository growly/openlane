module bl_mask_8_32_2 (
	input [1:0] addr,
	input [1:0] conf,
	
	output [31:0] bl_mask
);

	wire c32, c16, c8;
	assign c32 = !conf[1] && !conf[0];
	assign c16 = !conf[1] && conf[0];
	assign c8 = conf[1] && !conf[0];
	
	wire q1_en, q2_en, q3_en, q4_en;
	assign q1_en = ((c32) || (c16 && !addr[0]) || (c8 && !addr[1] && !addr[0]));
	assign q2_en = ((c32) || (c16 && !addr[0]) || (c8 && !addr[1] && addr[0]));
	assign q3_en = ((c32) || (c16 && addr[0]) || (c8 && addr[1] && !addr[0]));
	assign q4_en = ((c32) || (c16 && addr[0]) || (c8 && addr[1] && addr[0]));
	
	assign bl_mask = { {8{!q4_en}}, {8{!q3_en}}, {8{!q2_en}}, {8{!q1_en}} };

endmodule
