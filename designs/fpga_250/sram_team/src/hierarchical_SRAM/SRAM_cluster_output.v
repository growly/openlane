module SRAM_cluster_output (
	input [7:0] d_sram_A, d_sram_B, d_sram_C, d_sram_D,
	input csb_out_A, csb_out_B, csb_out_C, csb_out_D,
	
	output [31:0] d_fabric
);

	reg [31:0] d_fabric_reg;

	always @(*) begin
		case ({csb_out_A, csb_out_B, csb_out_C, csb_out_D})
			4'b0001	:	d_fabric_reg[7:0] = d_sram_D;
			4'b0010	:	d_fabric_reg[7:0] = d_sram_C;
			4'b0100	:	d_fabric_reg[7:0] = d_sram_B;
			4'b1000	:	d_fabric_reg[7:0] = d_sram_A;
			4'b0011	:	d_fabric_reg[15:0] = {d_sram_C, d_sram_D};
			4'b1100	:	d_fabric_reg[15:0] = {d_sram_A, d_sram_B};
			default	:	d_fabric_reg = {d_sram_A, d_sram_B, d_sram_C, d_sram_D};
		endcase
	end
	
	assign d_fabric = d_fabric_reg;

endmodule
