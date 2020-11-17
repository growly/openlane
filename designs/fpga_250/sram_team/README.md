# sram_team

unit_sram.v : 32k SRAM with 31:0 data bus and 15:0 addr bus
see file header for more details

unit_sram_reduced.v : 32k SRAM with 31:0 data bus and 9:0 dedicated addr bus
for larger word lengths, data_in[31:27] double as addr[14:10]
see file header for more details

simple tb to test dynamic reconfiguration, RW and output registering in sim/behavioral/

Config map:
000: 1k x 32
001: 2k x 16
010: 4k x 8
011: 8k x 4
100: 16k x 2
101: 32k x 1
default: 32k x 1
