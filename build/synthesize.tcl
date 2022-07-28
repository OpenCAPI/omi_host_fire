################################################################################
# Project Settings
################################################################################

# Target FPGA
variable XILINX_PART $::env(XILINX_PART)
puts "XILINX_PART is $XILINX_PART"
# current design
variable OMI_FREQ $::env(OMI_FREQ)
variable DESIGN $::env(DESIGN)

# Top Level Block
#  Name of vhdl file with top level of design
variable TOP_LEVEL $::env(TOP_LEVEL)

# Source Directory
#  Path to source directory containing vhdl/ and verilog/ directories
#  DLX files are stored separately because they are shared
variable SRC_DIR $::env(SRC_DIR)
variable DLX_DIR $::env(DLX_DIR)

# GLIB Version
#   Version of IBM glib library to use
variable GLIB_VERSION "1.1.35"

# Output Directory
variable OUTPUT_DIR $::env(OUTPUT_PREFIX)/synth_1

################################################################################
# Procedures
################################################################################

# Assemble a list of library paths and files used from those
# libraries, and then read them in to the respective library.
proc setup_lib {} {
    variable GLIB_VERSION
    set cwd [file dirname [file normalize [info script]]]

    # Set library path(s)
    #dict set libraries ibm [list /afs/apd/func/vlsi/eclipz/common/libs/vhdl_pkg_as/$GLIB_VERSION/src/ibm]
    #dict set libraries latches [list \
    #                                /afs/apd/func/vlsi/eclipz/common/libs/vhdl_pkg_as/$GLIB_VERSION/src/morph \
    #                                /afs/apd/func/vlsi/eclipz/common/libs/vhdl_pkg_as/$GLIB_VERSION/src/latches \
                                   ]
    #dict set libraries support [list /afs/apd/func/vlsi/eclipz/common/libs/vhdl_pkg_as/$GLIB_VERSION/src/support]

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


proc yesNoPrompt {} {
  set data ""
  set valid 0 
  while {!$valid} {
    gets stdin data
    set valid [expr {($data == y) || ($data == n)}]
    if {!$valid} {
        puts "Choose either y or n"
    }
  }

  if {$data == y} {
          return 1
  } elseif {$data == n} {
          return 0
  }
}

variable DESIGN

################################################################################
# Create Project
################################################################################
file mkdir $OUTPUT_DIR
if {( $DESIGN == "fire")} {
  create_project fire_2018_3 -force -part $XILINX_PART
} else {
  create_project ice_2018_3 -force -part $XILINX_PART
}
#create_project -in_memory -part $XILINX_PART

################################################################################
# Add Design Sources
################################################################################
# Generate version information
set cwd [file dirname [file normalize [info script]]]
puts [exec $cwd/write_git_meta.sh]
set ip_dir   $cwd/../ip_created_for_$DESIGN

#get vivado release
set vivado_major_release [exec vivado -nolog -nojournal -version | grep "Vivado v" | cut -d "." -f1 | tr -d "Vivado "]
set vivado_minor_release [exec vivado -nolog -nojournal -version | grep "Vivado v" | cut -d "." -f2 | tr -d "Vivado "]
set vivado_release $vivado_major_release.$vivado_minor_release
#puts "vivado_release is $vivado_release"


puts "======================================================"
puts "== CONFIGURATION parameters used to build the image =="
puts " Design is   : $DESIGN"
puts " Vivado used : $vivado_release"
puts " Frequency   : $OMI_FREQ MHz"
puts " Xilinx FPGA : $XILINX_PART"
puts " Is it ok to start the build process? (y/n)"
flush stdout
#if { [yesNoPrompt] == 1} {
#  puts "Start building process"
#} else {
#  exit
#}

if {( $DESIGN == "fire")} {
  #unused for ice 
  setup_lib 
}

# Rather than using xci files, regenerate the xci depending on the OMI frequency and the vivado release
#read_ip [ glob $SRC_DIR/ip/*/*/*.xci ]
set OMI_IPs_exist_filename [concat .OMI_IPs_$DESIGN\_$vivado_release\_$OMI_FREQ\MHZ\_$XILINX_PART]
#puts "looking for file $OMI_IPs_exist_filename"
set previous_OMI_IPs [glob -types f -nocomplain exists .OMI_IPs_$DESIGN\_* ]

if { [file exists $OMI_IPs_exist_filename] } {
  puts "OMI IPs are already created - reading them (in $ip_dir)"
  read_ip [ glob $ip_dir/*/*.xci ]
} else {
  #if { [glob -types f -nocomplain exists .OMI_IPs_$DESIGN\_* ] != "" } 
  if { $previous_OMI_IPs != "" } {
    puts "OMI IPs have been created for a different frequency or vivado release ($previous_OMI_IPs)"
    puts "Do you want to delete these old IP generated ? (y/n)"
    flush stdout
    if { [yesNoPrompt] == 1} {
      file delete -force $ip_dir 
      file delete {*}[glob .OMI_IPs_$DESIGN\_*]
      puts "Recreating IPs"
    } else {
      puts "OK keeping IPs in $ip_dir. Exiting"
      exit
    }
  } else {
    puts "OMI IPs have not been created yet - creating them (in $ip_dir)"
  }
  if {( $DESIGN == "ice")} {
    source ./create_ip_ice.tcl
    create_ICE_IPs
  } else {
    source ./create_ip_fire.tcl
    create_FIRE_IPs
  }

  exec touch $OMI_IPs_exist_filename

}

read_vhdl [ glob $SRC_DIR/vhdl/*.vhdl ]
if {( $DESIGN == "ice")} {
  set_property file_type {VHDL 2008} [get_files  $SRC_DIR/vhdl/ice_gmc_arb.vhdl]
  set_property file_type {VHDL 2008} [get_files  $SRC_DIR/vhdl/ice_gmc_xfifo.vhdl]
}
read_verilog [ glob $SRC_DIR/headers/*.v ]
set_property file_type "Verilog Header" [ get_files [ glob $SRC_DIR/headers/*.v ] ]
read_verilog [ glob $DLX_DIR/*.v ]
read_verilog [ glob $SRC_DIR/verilog/*.v ]
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
set_property strategy Flow_PerfOptimized_high [get_runs synth_1]
# set_property strategy Performance_ExtraTimingOpt [get_runs impl_1]
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
