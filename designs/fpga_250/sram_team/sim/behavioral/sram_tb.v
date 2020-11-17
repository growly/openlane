`include "unit_sram_reduced.v"

`timescale 1ns/1ns

`define SECOND 1000000000
`define MS 1000000
`define SAMPLE_PERIOD 22675.7

module sram_tb();
    reg clock, wen, ren, reg_out;
    reg [31:0] d_in;
    reg [14:0] addr;
    reg [2:0] conf;

    wire [31:0] d_out;

    initial clock = 0;
    always #(4) clock <= ~clock;

    unit_sram_reduced sram (
    	.sram_clk(clock),
    	.addr(addr),
    	.d_in(d_in),
    	.c(conf),
    	.wen(wen),
    	.ren(ren),
    	.reg_out(reg_out),
    	.d_out(d_out)
    );

    initial begin
        $dumpfile("sram_tb.vcd");
        $dumpvars(0,sram_tb);
        conf = 3'b000;
        reg_out = 0;

        #(3);
        d_in = 32'h0005FFAB;
        addr = 15'b00000000000000;
        ren = 1'b0;
        wen = 1'b1;

        #(8);
        d_in = 32'h0005FFAB;
        addr = 15'b00000000000000;
        ren = 1'b1;
        wen = 1'b0;

        #(8);
        conf = 3'b001;
        ren = 1'b0;
        wen = 1'b0;

        #(8);
        d_in = 32'h0000;
        addr = 15'b00000000000000;
        ren = 1'b0;
        wen = 1'b1;

        #(8);
        conf = 3'b000;
        d_in = 32'h0000;
        addr = 15'b00000000000000;
        ren = 1'b1;
        wen = 1'b0;

        #(8);
        conf = 3'b010;
        ren = 1'b0;
        wen = 1'b0;

        #(8);
        d_in = 32'hB2;
        addr = 15'b00000000000010;
        ren = 1'b0;
        wen = 1'b1;

        #(8);
        conf = 3'b000;
        reg_out = 1'b1;
        d_in = 32'h0000;
        addr = 15'b00000000000000;
        ren = 1'b1;
        wen = 1'b0;

        #(8);
        conf = 3'b011;
        ren = 1'b0;
        wen = 1'b0;

        #(8);
        d_in = 32'hF;
        addr = 15'b00000000001100;
        ren = 1'b0;
        wen = 1'b1;

        #(8);
        conf = 3'b000;
        d_in = 32'h0000;
        addr = 15'b000000000000001;
        ren = 1'b1;
        wen = 1'b0;

        #(8);
        ren = 1'b0;
        wen = 1'b0;

        #(20);
        $finish();
        
    end

endmodule