# 
# OPENLANE CONFIGURATION FILE
#

# User config
set ::env(DESIGN_NAME) mac_cluster
set ::env(PDK_VARIANT) sky130_fd_sc_hd

set mac_dir $::env(OPENLANE_ROOT)/designs/250/mac_team
set src_dir $mac_dir/src
set cells_dir $mac_dir/arithmetic_cells/src

# Design config
set ::env(CLOCK_PERIOD) 10
set ::env(VERILOG_FILES) [concat [glob $src_dir/*.v] [glob $cells_dir/*.v]]
set ::env(CLOCK_PORT) "clk"
set ::env(CLOCK_NET) $::env(CLOCK_PORT)

set filename $::env(DESIGN_DIR)/$::env(PDK)_$::env(STD_CELL_LIBRARY)_config.tcl
puts $filename
if { [file exists $filename] == 1} {
	source $filename
}

# Synthesis config
set ::env(SYNTH_STRATEGY) 2  ;# 1 fails

set ::env(SYNTH_READ_BLACKBOX_LIB) 1

set ::env(FP_SIZING) absolute
# I think this goes LL_X LL_Y UR_X UR_Y, where LL=lower left, UR=upper right
# Units probably microns
set ::env(DIE_AREA) [list 0 0 650 650]

# Floorplan config
#set ::env(FP_CORE_UTIL) 5
# Placement config
set ::env(PL_TARGET_DENSITY) 0.3

# CTS config
# Routing config
#set ::env(ROUTING_STRATEGY) 14 ;# run TritonRoute14
#set ::env(GLB_RT_ADJUSTMENT) 0
# Flow control config

# # threads for supporting tools
set ::env(ROUTING_CORES) 4

set ::env(PDN_CFG) $::env(DESIGN_DIR)/pdn.tcl

#set ::env(CLOCK_TREE_SYNTH) 0
#set ::env(SYNTH_BUFFERING) 0
#set ::env(SYNTH_SIZING) 0
#set ::env(CELL_PAD) 8
#set ::env(SYNTH_MAX_FANOUT) 6