################################################################################
# Project Settings
################################################################################

# Target FPGA
variable XILINX_PART $::env(XILINX_PART)

# Output Directory
variable OUTPUT_DIR $::env(SRC_DIR)/ip

################################################################################
# Create Project
################################################################################
create_project managed_ip_project $OUTPUT_DIR/managed_ip_project -part $XILINX_PART -ip -force
add_files -norecurse [ glob $OUTPUT_DIR/*/*/*.xci ]
start_gui
