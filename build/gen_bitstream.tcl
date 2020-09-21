################################################################################
# Arguments
################################################################################
# Pick results from an implementation strategy
if {$argc > 0} {
    variable strategy_index [lindex $argv 0]
    puts "Running with results from implementation strategy $strategy_index."
} else {
    variable strategy_index 1
    puts "Running with results from default implementation strategy $strategy_index."
}

################################################################################
# Project Settings
################################################################################
# Source Directory
#  Path to source directory containing vhdl/ and verilog/ directories
variable SRC_DIR $::env(SRC_DIR)

# Output Directory
variable OUTPUT_DIR $::env(OUTPUT_PREFIX)

# Design Selected
variable DESIGN $::env(DESIGN)

################################################################################
# Open Routing Checkpoint
################################################################################
open_checkpoint $OUTPUT_DIR/impl_$strategy_index/post_route.dcp

################################################################################
# Generate Bitstream
################################################################################
write_bitstream -force $OUTPUT_DIR/$DESIGN.bit
write_debug_probes -force $OUTPUT_DIR/$DESIGN.ltx
