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
create_project -in_memory -part $XILINX_PART
read_ip [ glob $OUTPUT_DIR/*/*.xci ]
foreach ip [get_ips] {
   reset_target simulation $ip
   generate_target simulation $ip
}
