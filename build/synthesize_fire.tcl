################################################################################
# Project Settings
################################################################################

# Target FPGA
variable XILINX_PART $::env(XILINX_PART)

# Top Level Block
#  Name of vhdl file with top level of design
variable TOP_LEVEL $::env(TOP_LEVEL)

# Source Directory
#  Path to source directory containing vhdl/ and verilog/ directories
#  DLX files are stored separately because they are shared
variable SRC_DIR $::env(SRC_DIR)
variable DLX_DIR $::env(DLX_DIR)

# Output Directory
variable OUTPUT_DIR $::env(OUTPUT_PREFIX)/synth_1

################################################################################
# Procedures
################################################################################

# Assemble a list of library paths and files used from those
# libraries, and then read them in to the respective library.
proc setup_lib {} {
    #variable GLIB_VERSION
    set cwd [file dirname [file normalize [info script]]]

    # Set library path(s)
    dict set libraries ibm [list $cwd/../ibm]
    dict set libraries support [list $cwd/../support]

    # Loop through the list of desired library files and pull them into their namespace
    foreach { library filename } [ list \
                                       ibm synthesis_support \
                                       ibm std_ulogic_support \
                                       ibm std_ulogic_function_support \
                                       ibm std_ulogic_unsigned \
                                       support logic_support_pkg \
                                      ] {
        set path_list [dict get $libraries $library]
        set found 0
        foreach path $path_list {
            if { [file exists $path/$filename.vhdl] } {
                read_vhdl -library $library [ glob $path/$filename.vhdl ]
                set found 1
            }
        }
        if { $found == 0 } {
            puts "ERROR: Couldn't find $filename in library $library"
            exit 1
        }
    }
}

################################################################################
# Create Project
################################################################################
file mkdir $OUTPUT_DIR
create_project -in_memory -part $XILINX_PART

################################################################################
# Add Design Sources
################################################################################
# Generate version information
set cwd [file dirname [file normalize [info script]]]
puts [exec $cwd/write_git_meta.sh]

setup_lib
read_vhdl [ glob $SRC_DIR/vhdl/*.vhdl ]
read_verilog [ glob $SRC_DIR/headers/*.v ]
set_property file_type "Verilog Header" [ get_files [ glob $SRC_DIR/headers/*.v ] ]
read_verilog [ glob $DLX_DIR/*.v ]
read_verilog [ glob $SRC_DIR/verilog/*.v ]
read_ip [ glob $SRC_DIR/ip_2133/*/*.xci ]
read_xdc [ glob $SRC_DIR/xdc/timing.xdc ]

################################################################################
# Run Synthesis & Generate Reports
################################################################################
# Out-Of-Context synthesis for IPs
foreach ip [get_ips] {
    set ip_filename [get_property IP_FILE $ip]
    set ip_dcp [file rootname $ip_filename]
    append ip_dcp ".dcp"
    set ip_xml [file rootname $ip_filename]
    append ip_xml ".xml"

    if {([file exists $ip_dcp] == 0) || [expr {[file mtime $ip_filename ] > [file mtime $ip_dcp ]}]} {

        # remove old files of IP, if still existing
        reset_target all $ip
        file delete $ip_xml

        # re-generate the IP
        generate_target all $ip
        set_property generate_synth_checkpoint true [get_files $ip_filename]
        synth_ip $ip
    }
}

# Settings from Flow_PerfOptimized_high strategy
synth_design -top $TOP_LEVEL -part $XILINX_PART -fanout_limit 400 -fsm_extraction one_hot -shreg_min_size 5

# For some reason this doesn't show up in the output directory automatically
if {[file exists fsm_encoding.os]} {
    file rename -force fsm_encoding.os $OUTPUT_DIR/fsm_encoding.os
}

# ILA sometimes causes problems, so checkpoint here for easier debug
write_checkpoint -force $OUTPUT_DIR/pre_ila

source "$cwd/insert_ila.tcl"
insert_ila

write_checkpoint -force $OUTPUT_DIR/post_synth
report_timing_summary -file $OUTPUT_DIR/post_synth_timing_summary.rpt
report_power -file $OUTPUT_DIR/post_synth_power.rpt
