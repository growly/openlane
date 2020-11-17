module data_out_mux_8_32_1 (
	input [31:0] D,
	input [1:0] conf,
	input [1:0] addr,
	
	output [31:0] data_out
);

	wire c32, c16, c8;
	assign c32 = !conf[1] && !conf[0];
	assign c16 = !conf[1] && conf[0];
	assign c8 = conf[1] && !conf[0];
	
	wire c16_h1, c16_h2;
	wire c8_q1, c8_q2, c8_q3;
	assign c16_h1 = c16 && !addr[0];
	assign c16_h2 = c16 && addr[0];
	assign c8_q1 = c8 && !addr[1] && !addr[0];
	assign c8_q2 = c8 && !addr[1] && addr[0];
	assign c8_q3 = c8 && addr[1] && !addr[0];
	assign c8_q4 = c8 && addr[1] && addr[0];
	
	assign data_out[31:16] = D[31:16];
	assign data_out[15:7] = (c16_h2) ? D[31:24] : D[15:7];
	assign data_out[7:0] = (c16_h2 || c8_q3) ? D[23:16] : 
					((c8_q4) ? D[31:24] :
						((c8_q2) ? D[15:7] :
							D[7:0]						
						)
					); 

endmodule
