module SRAM_unit_output_shifter (
	input [7:0] d_sram,
	input [2:0] addr,
	input c8, c4, c2, c1,
	
	output [7:0] d_fabric
);

	assign d_fabric[7] = d_sram[7];
	assign d_fabric[6] = d_sram[6];
	assign d_fabric[5] = d_sram[5];
	assign d_fabric[4] = d_sram[4];
	
	assign d_fabric[3] = (c4 && addr[0]) ? d_sram[7] : d_sram[3];
	assign d_fabric[2] = (c4 && addr[0]) ? d_sram[6] : d_sram[2];
	
	reg d_fabric_1, d_fabric_0;
	always @(*) begin
		case ({c2, addr[1], addr[0]})
			3'b111 : d_fabric_1 = d_sram[7];
			3'b110 : d_fabric_1 = d_sram[5];
			3'b101 : d_fabric_1 = d_sram[3];
			default : d_fabric_1 = d_sram[1];
		endcase
	
		case ({c1, addr})
			4'b1111 : d_fabric_0 = d_sram[7];
			4'b1110 : d_fabric_0 = d_sram[6];
			4'b1101 : d_fabric_0 = d_sram[5];
			4'b1100 : d_fabric_0 = d_sram[4];
			4'b1011 : d_fabric_0 = d_sram[3];
			4'b1010 : d_fabric_0 = d_sram[2];
			4'b1001 : d_fabric_0 = d_sram[1];
			default : d_fabric_0 = d_sram[0];
		endcase
	end
	assign d_fabric[1] = d_fabric_1;
	assign d_fabric[0] = d_fabric_0;

endmodule
