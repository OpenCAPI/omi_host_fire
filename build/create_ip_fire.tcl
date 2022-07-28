#############################################################################
# create_FIRE_IPs was coded to get rid of xci calls too dependent on frequency and vivado release
# IPs are configured as in astra_5cd07be_333 and astra_b20b168_400
#############################################################################
proc create_FIRE_IPs {} {
    variable OMI_FREQ
    variable DESIGN
    set cwd [file dirname [file normalize [info script]]]
    set ip_dir   $cwd/../ip_created_for_$DESIGN
    if {[catch {file mkdir $ip_dir} err opts] != 0} {
        puts $err
    }
    set log_file $cwd/create_ip.log

  puts "                        generating IP axi_iic_0"
  create_ip -name axi_iic -vendor xilinx.com -library ip -version 2.0 -module_name axi_iic_0 -dir $ip_dir >> $log_file
  set_property -dict [list                                 \
                      CONFIG.AXI_ACLK_FREQ_MHZ {200}       \
                      CONFIG.C_SCL_INERTIAL_DELAY {8}      \
                      CONFIG.C_SDA_INERTIAL_DELAY {8}      \
                      ] [get_ips axi_iic_0]

  set_property generate_synth_checkpoint false [get_files $ip_dir/axi_iic_0/axi_iic_0.xci]   
  generate_target {instantiation_template}     [get_files $ip_dir/axi_iic_0/axi_iic_0.xci] >> $log_file  
  generate_target all                          [get_files $ip_dir/axi_iic_0/axi_iic_0.xci] >> $log_file  
  export_ip_user_files -of_objects             [get_files $ip_dir/axi_iic_0/axi_iic_0.xci] -no_script  >> $log_file  
  export_simulation    -of_objects             [get_files $ip_dir/axi_iic_0/axi_iic_0.xci] -directory ip_dir/ip_user_files/sim_scripts -force >> $log_file


  puts "                        generating IP jtag_axi_0"
  create_ip -name jtag_axi -vendor xilinx.com -library ip -version 1.2 -module_name jtag_axi_0 -dir $ip_dir >> $log_file
  set_property -dict [list                                \
                      CONFIG.M_HAS_BURST {0}              \
                      CONFIG.M_AXI_ADDR_WIDTH {64}        \
                      ] [get_ips jtag_axi_0]

  set_property generate_synth_checkpoint false [get_files $ip_dir/jtag_axi_0/jtag_axi_0.xci] 
  generate_target {instantiation_template}     [get_files $ip_dir/jtag_axi_0/jtag_axi_0.xci] >> $log_file  
  generate_target all                          [get_files $ip_dir/jtag_axi_0/jtag_axi_0.xci] >> $log_file  
  export_ip_user_files -of_objects             [get_files $ip_dir/jtag_axi_0/jtag_axi_0.xci] -no_script >> $log_file  
  export_simulation    -of_objects             [get_files $ip_dir/jtag_axi_0/jtag_axi_0.xci] -directory ip_dir/ip_user_files/sim_scripts -force >> $log_file


#  puts "                        generating IP in_system_ibert_0"
#  create_ip -name in_system_ibert -vendor xilinx.com -library ip -version 1.0 -module_name in_system_ibert_0 -dir $ip_dir >> $log_file
#  set_property -dict [list                                                           \
#                      CONFIG.C_GT_TYPE {GTY}                                         \
#                      CONFIG.C_GTS_USED { X0Y8  X0Y9  X0Y10 X0Y11 X0Y12 X0Y13 X0Y14 X0Y15} \
#                      CONFIG.C_ENABLE_INPUT_PORTS {true}                             \
#                      ] [get_ips in_system_ibert_0]
#
#  set_property generate_synth_checkpoint false [get_files $ip_dir/in_system_ibert_0/in_system_ibert_0.xci] 
#  generate_target {instantiation_template}     [get_files $ip_dir/in_system_ibert_0/in_system_ibert_0.xci] >> $log_file  
#  generate_target all                          [get_files $ip_dir/in_system_ibert_0/in_system_ibert_0.xci] >> $log_file  
#  export_ip_user_files -of_objects             [get_files $ip_dir/in_system_ibert_0/in_system_ibert_0.xci] -no_script >> $log_file  
#  export_simulation    -of_objects             [get_files $ip_dir/in_system_ibert_0/in_system_ibert_0.xci] -directory ip_dir/ip_user_files/sim_scripts -force >> $log_file
#
#
#  puts "                        generating IP in_system_ibert_1"
#  create_ip -name in_system_ibert -vendor xilinx.com -library ip -version 1.0 -module_name in_system_ibert_1 -dir $ip_dir >> $log_file
#  set_property -dict [list                                                           \
#                      CONFIG.C_GT_TYPE {GTY}                                         \
#                      CONFIG.C_GTS_USED { X0Y0  X0Y1  X0Y2  X0Y3  X0Y4  X0Y5  X0Y6  X0Y7 } \
#                      CONFIG.C_ENABLE_INPUT_PORTS {true}                             \
#                      ] [get_ips in_system_ibert_1]
#
#  set_property generate_synth_checkpoint false [get_files $ip_dir/in_system_ibert_1/in_system_ibert_1.xci] 
#  generate_target {instantiation_template}     [get_files $ip_dir/in_system_ibert_1/in_system_ibert_1.xci] >> $log_file  
#  generate_target all                          [get_files $ip_dir/in_system_ibert_1/in_system_ibert_1.xci] >> $log_file  
#  export_ip_user_files -of_objects             [get_files $ip_dir/in_system_ibert_1/in_system_ibert_1.xci] -no_script >> $log_file  
#  export_simulation    -of_objects             [get_files $ip_dir/in_system_ibert_1/in_system_ibert_1.xci] -directory ip_dir/ip_user_files/sim_scripts -force >> $log_file


  if { $OMI_FREQ == "333" } {
     puts "                        generating IP gtwizard_ultrascale_0  for 333MHz (w/ workaround)"
  } elseif { $OMI_FREQ == "400" } {
     puts "                        generating IP gtwizard_ultrascale_0  for 400MHz (w/ workaround)"
  } else {
     puts "ERROR:                  unrecognized frequency for IP gtwizard_ultrascale_0"
     exit
  }
  create_ip -name gtwizard_ultrascale -vendor xilinx.com -library ip -version 1.7 -module_name gtwizard_ultrascale_0 -dir $ip_dir >> $log_file
  set_property -dict [list                                                               \
                      CONFIG.GT_TYPE {GTY}                                               \
                      CONFIG.CHANNEL_ENABLE {X0Y31 X0Y30 X0Y29 X0Y28 X0Y27 X0Y26 X0Y25 X0Y24}    \
                      CONFIG.TX_MASTER_CHANNEL {X0Y31}                                    \
                      CONFIG.RX_MASTER_CHANNEL {X0Y31}                                    \
                      CONFIG.TX_DATA_ENCODING {64B66B}                                   \
                      CONFIG.TX_USER_DATA_WIDTH {64}                                     \
                      CONFIG.TX_INT_DATA_WIDTH {64}                                      \
                      CONFIG.RX_DATA_DECODING {64B66B}                                   \
                      CONFIG.RX_USER_DATA_WIDTH {64}                                     \
                      CONFIG.RX_INT_DATA_WIDTH {64}                                      \
                      CONFIG.RX_JTOL_FC {10}                                             \
                      CONFIG.RX_CB_MAX_LEVEL {4}                                         \
                      CONFIG.LOCATE_IN_SYSTEM_IBERT_CORE {EXAMPLE_DESIGN}                \
                      CONFIG.TX_OUTCLK_SOURCE {TXPROGDIVCLK}                             \
                      CONFIG.ENABLE_OPTIONAL_PORTS {rxpolarity_in}                       \
                      ] [get_ips gtwizard_ultrascale_0]
  if { $OMI_FREQ == "333" } {
    set_property -dict [list                                                             \
                      CONFIG.TX_LINE_RATE {21.333333328}                                 \
                      CONFIG.TX_REFCLK_FREQUENCY {133.3333333}                           \
                      CONFIG.RX_LINE_RATE {21.333333328}                                 \
                      CONFIG.RX_REFCLK_FREQUENCY {133.3333333}                           \
                      CONFIG.TXPROGDIV_FREQ_VAL {333.3333333}                            \
                      CONFIG.RX_REFCLK_SOURCE {}                                         \
                      CONFIG.TX_REFCLK_SOURCE {}                                         \
                      CONFIG.TX_BUFFER_MODE {0}                                          \
                      ] [get_ips gtwizard_ultrascale_0]

  } elseif { $OMI_FREQ == "400" } {
    set_property -dict [list                                                             \
                      CONFIG.TX_LINE_RATE {25.6}                                         \
                      CONFIG.TX_REFCLK_FREQUENCY {133.3333333}                           \
                      CONFIG.RX_LINE_RATE {25.6}                                         \
                      CONFIG.RX_REFCLK_FREQUENCY {133.3333333}                           \
                      CONFIG.TXPROGDIV_FREQ_VAL {400}                                    \
                      CONFIG.RX_REFCLK_SOURCE {}                                         \
                      CONFIG.TX_REFCLK_SOURCE {}                                         \
                      CONFIG.TX_BUFFER_MODE {0}                                          \
                      ] [get_ips gtwizard_ultrascale_0]
  }

  set_property generate_synth_checkpoint false [get_files $ip_dir/gtwizard_ultrascale_0/gtwizard_ultrascale_0.xci] 
  generate_target {instantiation_template}     [get_files $ip_dir/gtwizard_ultrascale_0/gtwizard_ultrascale_0.xci] >> $log_file  
  generate_target all                          [get_files $ip_dir/gtwizard_ultrascale_0/gtwizard_ultrascale_0.xci] >> $log_file  
  export_ip_user_files -of_objects             [get_files $ip_dir/gtwizard_ultrascale_0/gtwizard_ultrascale_0.xci] -no_script >> $log_file  
  export_simulation    -of_objects             [get_files $ip_dir/gtwizard_ultrascale_0/gtwizard_ultrascale_0.xci] -directory ip_dir/ip_user_files/sim_scripts -force >> $log_file




  if { $OMI_FREQ == "333" } {
     puts "                        generating IP gtwizard_ultrascale_1  for 333MHz (w/ workaround)"
  } elseif { $OMI_FREQ == "400" } {
     puts "                        generating IP gtwizard_ultrascale_1  for 400MHz (w/ workaround)"
  } else {
     puts "ERROR:                  unrecognized frequency for IP gtwizard_ultrascale_1"
     exit
  }
  create_ip -name gtwizard_ultrascale -vendor xilinx.com -library ip -version 1.7 -module_name gtwizard_ultrascale_1 -dir $ip_dir >> $log_file
  set_property -dict [list                                                               \
                      CONFIG.GT_TYPE {GTY}                                               \
                      CONFIG.CHANNEL_ENABLE {X0Y23 X0Y22 X0Y21 X0Y20 X0Y19 X0Y18 X0Y17 X0Y16} \
                      CONFIG.TX_MASTER_CHANNEL {X0Y23}                                   \
                      CONFIG.RX_MASTER_CHANNEL {X0Y23}                                   \
                      CONFIG.TX_DATA_ENCODING {64B66B}                                   \
                      CONFIG.TX_USER_DATA_WIDTH {64}                                     \
                      CONFIG.TX_INT_DATA_WIDTH {64}                                      \
                      CONFIG.RX_DATA_DECODING {64B66B}                                   \
                      CONFIG.RX_USER_DATA_WIDTH {64}                                     \
                      CONFIG.RX_INT_DATA_WIDTH {64}                                      \
                      CONFIG.RX_JTOL_FC {10}                                             \
                      CONFIG.RX_CB_MAX_LEVEL {4}                                         \
                      CONFIG.LOCATE_IN_SYSTEM_IBERT_CORE {EXAMPLE_DESIGN}                \
                      CONFIG.TX_OUTCLK_SOURCE {TXPROGDIVCLK}                             \
                      CONFIG.ENABLE_OPTIONAL_PORTS {rxpolarity_in}                       \
                      ] [get_ips gtwizard_ultrascale_1]

  if { $OMI_FREQ == "333" } {
    set_property -dict [list                                                             \
                      CONFIG.TX_LINE_RATE {21.333333328}                                 \
                      CONFIG.TX_REFCLK_FREQUENCY {133.3333333}                           \
                      CONFIG.RX_LINE_RATE {21.333333328}                                 \
                      CONFIG.RX_REFCLK_FREQUENCY {133.3333333}                           \
                      CONFIG.TXPROGDIV_FREQ_VAL {333.3333333}                            \
                      CONFIG.RX_REFCLK_SOURCE {}                                         \
                      CONFIG.TX_REFCLK_SOURCE {}                                         \
                      CONFIG.TX_BUFFER_MODE {0}                                          \
                      ] [get_ips gtwizard_ultrascale_1]

  } elseif { $OMI_FREQ == "400" } {
    set_property -dict [list                                                             \
                      CONFIG.TX_LINE_RATE {25.6}                                         \
                      CONFIG.TX_REFCLK_FREQUENCY {133.3333333}                           \
                      CONFIG.RX_LINE_RATE {25.6}                                         \
                      CONFIG.RX_REFCLK_FREQUENCY {133.3333333}                           \
                      CONFIG.TXPROGDIV_FREQ_VAL {400}                                    \
                      CONFIG.RX_REFCLK_SOURCE {}                                         \
                      CONFIG.TX_REFCLK_SOURCE {}                                         \
                      CONFIG.TX_BUFFER_MODE {0}                                          \
                      ] [get_ips gtwizard_ultrascale_1]
  }

  set_property generate_synth_checkpoint false [get_files $ip_dir/gtwizard_ultrascale_1/gtwizard_ultrascale_1.xci] 
  generate_target {instantiation_template}     [get_files $ip_dir/gtwizard_ultrascale_1/gtwizard_ultrascale_1.xci] >> $log_file  
  generate_target all                          [get_files $ip_dir/gtwizard_ultrascale_1/gtwizard_ultrascale_1.xci] >> $log_file  
  export_ip_user_files -of_objects             [get_files $ip_dir/gtwizard_ultrascale_1/gtwizard_ultrascale_1.xci] -no_script >> $log_file  
  export_simulation    -of_objects             [get_files $ip_dir/gtwizard_ultrascale_1/gtwizard_ultrascale_1.xci] -directory ip_dir/ip_user_files/sim_scripts -force >> $log_file


puts "                        Creating a projet example based on gtwizard_ultrascale ..."
open_example_project -force -dir $ip_dir [get_ips  gtwizard_ultrascale_0]
puts "                        Preparing DLx Files from gtwizard_ultrascale_0_ex project ..."
exec bash -c "cp $ip_dir/../scripts/* $ip_dir/gtwizard_ultrascale_0_ex/imports"
exec bash -c "cd $ip_dir/gtwizard_ultrascale_0_ex/imports; ./all_shells.sh"
exec bash -c "rm $ip_dir/gtwizard_ultrascale_0_ex/imports/dlx_phy_wrap_ref.v"
exec bash -c "rm $ip_dir/gtwizard_ultrascale_0_ex/imports/DLx_phy_example_wrapper_ref.v"
puts "                        Copying verilog DLx files into fire/src/verilog/ ..."
exec bash -c "cp $ip_dir/gtwizard_ultrascale_0_ex/imports/DLx_phy_example* $ip_dir/../fire/src/verilog/"
puts "                        Copying verilog top files into fire/src/verilog/dlx_phy_wrapxx"
exec bash -c "cp $ip_dir/gtwizard_ultrascale_0_ex/imports/dlx_phy* $ip_dir/../fire/src/verilog/"

puts "                        Moving wrapper functions into newly created directory: fire/src/headers/ ..."
exec bash -c "mkdir -p $ip_dir/../fire/src/headers/"
exec bash -c "mv $ip_dir/../fire/src/verilog/DLx_phy_example_wrapper_functions.v $ip_dir/../fire/src/headers/"




  if { $OMI_FREQ == "333" } {
     puts "                        generating IP clk_wiz_sysclk         for 333MHz"
  } elseif { $OMI_FREQ == "400" } {
     puts "                        generating IP clk_wiz_sysclk         for 400MHz"
  } else {
     puts "ERROR:                  unrecognized frequency for IP clk_wiz_sysclk"
     exit
  }
  create_ip -name clk_wiz -vendor xilinx.com -library ip -version 6.0 -module_name clk_wiz_sysclk  -dir $ip_dir >> $log_file

  set_property -dict [list                                                \
                    CONFIG.PRIMITIVE {Auto}                                 \
                    CONFIG.PRIM_SOURCE {Differential_clock_capable_pin}     \
                    CONFIG.USE_LOCKED {true}                                \
                    CONFIG.USE_RESET {true}                                 \
                    CONFIG.RESET_TYPE {ACTIVE_LOW}                          \
                    CONFIG.CLKOUT1_DRIVES {Buffer}                          \
                    CONFIG.CLKOUT2_DRIVES {Buffer}                          \
                    CONFIG.CLKOUT3_DRIVES {Buffer}                          \
                    CONFIG.CLKOUT4_DRIVES {Buffer}                          \
                    CONFIG.CLKOUT5_DRIVES {Buffer}                          \
                    CONFIG.CLKOUT6_DRIVES {Buffer}                          \
                    CONFIG.CLKOUT7_DRIVES {Buffer}                          \
                    CONFIG.FEEDBACK_SOURCE {FDBK_AUTO}                      \
                    CONFIG.RESET_PORT {resetn}                              \
                    CONFIG.AUTO_PRIMITIVE {PLL}                             \
                    ] [get_ips clk_wiz_sysclk]

  if { $OMI_FREQ == "333" } {
    set_property -dict [list                                                \
                    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {333.33333325}        \
                    CONFIG.MMCM_DIVCLK_DIVIDE {1}                           \
                    CONFIG.MMCM_CLKFBOUT_MULT_F {10}                        \
                    CONFIG.MMCM_COMPENSATION {AUTO}                         \
                    CONFIG.MMCM_CLKOUT0_DIVIDE_F {3}                        \
                    CONFIG.CLKOUT1_JITTER {104.542}                         \
                    CONFIG.CLKOUT1_PHASE_ERROR {98.575}                     \
                    ] [get_ips clk_wiz_sysclk]

  } elseif { $OMI_FREQ == "400" } {
    set_property -dict [list                                                \
                    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {400.000}             \
                    CONFIG.MMCM_DIVCLK_DIVIDE {1}                           \
                    CONFIG.MMCM_CLKFBOUT_MULT_F {8}                         \
                    CONFIG.MMCM_COMPENSATION {AUTO}                         \
                    CONFIG.MMCM_CLKOUT0_DIVIDE_F {2}                        \
                    CONFIG.CLKOUT1_JITTER {111.164}                         \
                    CONFIG.CLKOUT1_PHASE_ERROR {114.212}                    \
                    ] [get_ips clk_wiz_sysclk]
  }
  set_property generate_synth_checkpoint false [get_files $ip_dir/clk_wiz_sysclk/clk_wiz_sysclk.xci] 
  generate_target {instantiation_template}     [get_files $ip_dir/clk_wiz_sysclk/clk_wiz_sysclk.xci] >> $log_file  
  generate_target all                          [get_files $ip_dir/clk_wiz_sysclk/clk_wiz_sysclk.xci] >> $log_file  
  export_ip_user_files -of_objects             [get_files $ip_dir/clk_wiz_sysclk/clk_wiz_sysclk.xci] -no_script >> $log_file  
  export_simulation    -of_objects             [get_files $ip_dir/clk_wiz_sysclk/clk_wiz_sysclk.xci] -directory ip_dir/ip_user_files/sim_scripts -force >> $log_file


  puts "                        generating IP axi4lite_register_slice_0"
  create_ip -name axi_register_slice -vendor xilinx.com -library ip -version 2.1 -module_name axi4lite_register_slice_0 -dir $ip_dir >> $log_file
  set_property -dict [list                                    \
                     CONFIG.PROTOCOL {AXI4LITE}               \
                     CONFIG.ADDR_WIDTH {64}                   \
                     CONFIG.REG_AW {1}                        \
                     CONFIG.REG_AR {1}                        \
                     CONFIG.REG_W {1}                         \
                     CONFIG.REG_R {1}                         \
                     CONFIG.REG_B {1}                         \
                     ] [get_ips axi4lite_register_slice_0]

  set_property generate_synth_checkpoint false [get_files $ip_dir/axi4lite_register_slice_0/axi4lite_register_slice_0.xci] 
  generate_target {instantiation_template}     [get_files $ip_dir/axi4lite_register_slice_0/axi4lite_register_slice_0.xci] >> $log_file  
  generate_target all                          [get_files $ip_dir/axi4lite_register_slice_0/axi4lite_register_slice_0.xci] >> $log_file  
  export_ip_user_files -of_objects             [get_files $ip_dir/axi4lite_register_slice_0/axi4lite_register_slice_0.xci] -no_script >> $log_file  
  export_simulation    -of_objects             [get_files $ip_dir/axi4lite_register_slice_0/axi4lite_register_slice_0.xci] -directory ip_dir/ip_user_files/sim_scripts -force >> $log_file


  puts "                        generating IP axi3_register_slice_0"
  create_ip -name axi_register_slice -vendor xilinx.com -library ip -version 2.1 -module_name axi3_register_slice_0 -dir $ip_dir >> $log_file
  set_property -dict [list                                    \
                     CONFIG.PROTOCOL {AXI3}                   \
                     CONFIG.ADDR_WIDTH {64}                   \
                     CONFIG.ID_WIDTH {7}                      \
                     CONFIG.REG_AW {1}                        \
                     CONFIG.REG_AR {1}                        \
                     CONFIG.REG_B {1}                         \
                     ] [get_ips axi3_register_slice_0]

  set_property generate_synth_checkpoint false [get_files $ip_dir/axi3_register_slice_0/axi3_register_slice_0.xci] 
  generate_target {instantiation_template}     [get_files $ip_dir/axi3_register_slice_0/axi3_register_slice_0.xci] >> $log_file  
  generate_target all                          [get_files $ip_dir/axi3_register_slice_0/axi3_register_slice_0.xci] >> $log_file  
  export_ip_user_files -of_objects             [get_files $ip_dir/axi3_register_slice_0/axi3_register_slice_0.xci] -no_script >> $log_file  
  export_simulation    -of_objects             [get_files $ip_dir/axi3_register_slice_0/axi3_register_slice_0.xci] -directory ip_dir/ip_user_files/sim_scripts -force >> $log_file


  puts "                        generating IP axi3_register_slice_slr_0"
  create_ip -name axi_register_slice -vendor xilinx.com -library ip -version 2.1 -module_name axi3_register_slice_slr_0 -dir $ip_dir >> $log_file
  set_property -dict [list                                    \
                     CONFIG.PROTOCOL {AXI3}                   \
                     CONFIG.ID_WIDTH {7}                      \
                     CONFIG.ADDR_WIDTH {64}                   \
                     CONFIG.REG_AW {10}                       \
                     CONFIG.REG_AR {10}                       \
                     CONFIG.REG_W {10}                        \
                     CONFIG.REG_R {10}                        \
                     CONFIG.REG_B {10}                        \
                     ] [get_ips axi3_register_slice_slr_0]

  set_property generate_synth_checkpoint false [get_files $ip_dir/axi3_register_slice_slr_0/axi3_register_slice_slr_0.xci] 
  generate_target {instantiation_template}     [get_files $ip_dir/axi3_register_slice_slr_0/axi3_register_slice_slr_0.xci] >> $log_file  
  generate_target all                          [get_files $ip_dir/axi3_register_slice_slr_0/axi3_register_slice_slr_0.xci] >> $log_file  
  export_ip_user_files -of_objects             [get_files $ip_dir/axi3_register_slice_slr_0/axi3_register_slice_slr_0.xci] -no_script >> $log_file  
  export_simulation    -of_objects             [get_files $ip_dir/axi3_register_slice_slr_0/axi3_register_slice_slr_0.xci] -directory ip_dir/ip_user_files/sim_scripts -force >> $log_file


  puts "                        generating IP axi4lite_crossbar_0"
  create_ip -name axi_crossbar -vendor xilinx.com -library ip -version 2.1 -module_name axi4lite_crossbar_0 -dir $ip_dir >> $log_file
  set_property -dict [list                                                       \
                    CONFIG.NUM_MI {9}                                            \
                    CONFIG.ADDR_WIDTH {64}                                       \
                    CONFIG.PROTOCOL {AXI4LITE}                                   \
                    CONFIG.CONNECTIVITY_MODE {SASD}                              \
                    CONFIG.R_REGISTER {1}                                        \
                    CONFIG.S00_WRITE_ACCEPTANCE {1} CONFIG.S01_WRITE_ACCEPTANCE {1} CONFIG.S02_WRITE_ACCEPTANCE {1} CONFIG.S03_WRITE_ACCEPTANCE {1} \
                    CONFIG.S04_WRITE_ACCEPTANCE {1} CONFIG.S05_WRITE_ACCEPTANCE {1} CONFIG.S06_WRITE_ACCEPTANCE {1} CONFIG.S07_WRITE_ACCEPTANCE {1} \
                    CONFIG.S08_WRITE_ACCEPTANCE {1} CONFIG.S09_WRITE_ACCEPTANCE {1} CONFIG.S10_WRITE_ACCEPTANCE {1} CONFIG.S11_WRITE_ACCEPTANCE {1} \
                    CONFIG.S12_WRITE_ACCEPTANCE {1} CONFIG.S13_WRITE_ACCEPTANCE {1} CONFIG.S14_WRITE_ACCEPTANCE {1} CONFIG.S15_WRITE_ACCEPTANCE {1} \
                    CONFIG.S00_READ_ACCEPTANCE {1}  CONFIG.S01_READ_ACCEPTANCE {1}  CONFIG.S02_READ_ACCEPTANCE {1}  CONFIG.S03_READ_ACCEPTANCE {1}  \
                    CONFIG.S04_READ_ACCEPTANCE {1}  CONFIG.S05_READ_ACCEPTANCE {1}  CONFIG.S06_READ_ACCEPTANCE {1}  CONFIG.S07_READ_ACCEPTANCE {1}  \
                    CONFIG.S08_READ_ACCEPTANCE {1}  CONFIG.S09_READ_ACCEPTANCE {1}  CONFIG.S10_READ_ACCEPTANCE {1}  CONFIG.S11_READ_ACCEPTANCE {1}  \
                    CONFIG.S12_READ_ACCEPTANCE {1}  CONFIG.S13_READ_ACCEPTANCE {1}  CONFIG.S14_READ_ACCEPTANCE {1}  CONFIG.S15_READ_ACCEPTANCE {1}  \
                    CONFIG.M00_WRITE_ISSUING {1}    CONFIG.M01_WRITE_ISSUING {1}    CONFIG.M02_WRITE_ISSUING {1}    CONFIG.M03_WRITE_ISSUING {1}    \
                    CONFIG.M04_WRITE_ISSUING {1}    CONFIG.M05_WRITE_ISSUING {1}    CONFIG.M06_WRITE_ISSUING {1}    CONFIG.M07_WRITE_ISSUING {1}    \
                    CONFIG.M08_WRITE_ISSUING {1}    CONFIG.M09_WRITE_ISSUING {1}    CONFIG.M10_WRITE_ISSUING {1}    CONFIG.M11_WRITE_ISSUING {1}    \
                    CONFIG.M12_WRITE_ISSUING {1}    CONFIG.M13_WRITE_ISSUING {1}    CONFIG.M14_WRITE_ISSUING {1}    CONFIG.M15_WRITE_ISSUING {1}    \
                    CONFIG.M00_READ_ISSUING {1}     CONFIG.M01_READ_ISSUING {1}     CONFIG.M02_READ_ISSUING {1}     CONFIG.M03_READ_ISSUING {1}     \
                    CONFIG.M04_READ_ISSUING {1}     CONFIG.M05_READ_ISSUING {1}     CONFIG.M06_READ_ISSUING {1}     CONFIG.M07_READ_ISSUING {1}     \
                    CONFIG.M08_READ_ISSUING {1}     CONFIG.M09_READ_ISSUING {1}     CONFIG.M10_READ_ISSUING {1}     CONFIG.M11_READ_ISSUING {1}     \
                    CONFIG.M12_READ_ISSUING {1}     CONFIG.M13_READ_ISSUING {1}     CONFIG.M14_READ_ISSUING {1}     CONFIG.M15_READ_ISSUING {1}     \
                    CONFIG.S00_SINGLE_THREAD {1}                                 \
                    CONFIG.M00_A00_BASE_ADDR {0x101040000000000}                 \
                    CONFIG.M01_A00_BASE_ADDR {0x102040000000000}                 \
                    CONFIG.M02_A00_BASE_ADDR {0x0104040000000000}                \
                    CONFIG.M03_A00_BASE_ADDR {0x01010C0000000000}                \
                    CONFIG.M04_A00_BASE_ADDR {0x01020C0000000000}                \
                    CONFIG.M05_A00_BASE_ADDR {0x01040C0000000000}                \
                    CONFIG.M06_A00_BASE_ADDR {0x0100000000000000}                \
                    CONFIG.M07_A00_BASE_ADDR {0x0103000000000000}                \
                    CONFIG.M08_A00_BASE_ADDR {0x0105000000000000}                \
                    CONFIG.M00_A00_ADDR_WIDTH {24}  CONFIG.M01_A00_ADDR_WIDTH {24}  CONFIG.M02_A00_ADDR_WIDTH {24}  \
                    CONFIG.M03_A00_ADDR_WIDTH {24}  CONFIG.M04_A00_ADDR_WIDTH {24}  CONFIG.M05_A00_ADDR_WIDTH {24}  \
                    CONFIG.M06_A00_ADDR_WIDTH {24}  CONFIG.M07_A00_ADDR_WIDTH {24}  CONFIG.M08_A00_ADDR_WIDTH {24}  \
                   ] [get_ips axi4lite_crossbar_0]

  set_property generate_synth_checkpoint false [get_files $ip_dir/axi4lite_crossbar_0/axi4lite_crossbar_0.xci] 
  generate_target {instantiation_template}     [get_files $ip_dir/axi4lite_crossbar_0/axi4lite_crossbar_0.xci] >> $log_file  
  generate_target all                          [get_files $ip_dir/axi4lite_crossbar_0/axi4lite_crossbar_0.xci] >> $log_file  
  export_ip_user_files -of_objects             [get_files $ip_dir/axi4lite_crossbar_0/axi4lite_crossbar_0.xci] -no_script >> $log_file  
  export_simulation    -of_objects             [get_files $ip_dir/axi4lite_crossbar_0/axi4lite_crossbar_0.xci] -directory ip_dir/ip_user_files/sim_scripts -force >> $log_file


  puts "                        generating IP axi4lite_crossbar_1"
  create_ip -name axi_crossbar -vendor xilinx.com -library ip -version 2.1 -module_name axi4lite_crossbar_1 -dir $ip_dir >> $log_file
  set_property -dict [list                                                         \
                   CONFIG.NUM_MI {6}                                             \
                   CONFIG.ADDR_WIDTH {64}                                        \
                   CONFIG.PROTOCOL {AXI4LITE}                                    \
                   CONFIG.CONNECTIVITY_MODE {SASD}                               \
                   CONFIG.R_REGISTER {1}                                         \
                   CONFIG.S00_WRITE_ACCEPTANCE {1} CONFIG.S01_WRITE_ACCEPTANCE {1} CONFIG.S02_WRITE_ACCEPTANCE {1} CONFIG.S03_WRITE_ACCEPTANCE {1} \
                   CONFIG.S04_WRITE_ACCEPTANCE {1} CONFIG.S05_WRITE_ACCEPTANCE {1} CONFIG.S06_WRITE_ACCEPTANCE {1} CONFIG.S07_WRITE_ACCEPTANCE {1} \
                   CONFIG.S08_WRITE_ACCEPTANCE {1} CONFIG.S09_WRITE_ACCEPTANCE {1} CONFIG.S10_WRITE_ACCEPTANCE {1} CONFIG.S11_WRITE_ACCEPTANCE {1} \
                   CONFIG.S12_WRITE_ACCEPTANCE {1} CONFIG.S13_WRITE_ACCEPTANCE {1} CONFIG.S14_WRITE_ACCEPTANCE {1} CONFIG.S15_WRITE_ACCEPTANCE {1} \
                   CONFIG.S00_READ_ACCEPTANCE {1}  CONFIG.S01_READ_ACCEPTANCE {1}  CONFIG.S02_READ_ACCEPTANCE {1}  CONFIG.S03_READ_ACCEPTANCE {1}  \
                   CONFIG.S04_READ_ACCEPTANCE {1}  CONFIG.S05_READ_ACCEPTANCE {1}  CONFIG.S06_READ_ACCEPTANCE {1}  CONFIG.S07_READ_ACCEPTANCE {1}  \
                   CONFIG.S08_READ_ACCEPTANCE {1}  CONFIG.S09_READ_ACCEPTANCE {1}  CONFIG.S10_READ_ACCEPTANCE {1}  CONFIG.S11_READ_ACCEPTANCE {1}  \
                   CONFIG.S12_READ_ACCEPTANCE {1}  CONFIG.S13_READ_ACCEPTANCE {1}  CONFIG.S14_READ_ACCEPTANCE {1}  CONFIG.S15_READ_ACCEPTANCE {1}  \
                   CONFIG.M00_WRITE_ISSUING {1}    CONFIG.M01_WRITE_ISSUING {1}    CONFIG.M02_WRITE_ISSUING {1}    CONFIG.M03_WRITE_ISSUING {1}    \
                   CONFIG.M04_WRITE_ISSUING {1}    CONFIG.M05_WRITE_ISSUING {1}    CONFIG.M06_WRITE_ISSUING {1}    CONFIG.M07_WRITE_ISSUING {1}    \
                   CONFIG.M08_WRITE_ISSUING {1}    CONFIG.M09_WRITE_ISSUING {1}    CONFIG.M10_WRITE_ISSUING {1}    CONFIG.M11_WRITE_ISSUING {1}    \
                   CONFIG.M12_WRITE_ISSUING {1}    CONFIG.M13_WRITE_ISSUING {1}    CONFIG.M14_WRITE_ISSUING {1}    CONFIG.M15_WRITE_ISSUING {1}    \
                   CONFIG.M00_READ_ISSUING {1}     CONFIG.M01_READ_ISSUING {1}     CONFIG.M02_READ_ISSUING {1}     CONFIG.M03_READ_ISSUING {1}     \
                   CONFIG.M04_READ_ISSUING {1}     CONFIG.M05_READ_ISSUING {1}     CONFIG.M06_READ_ISSUING {1}     CONFIG.M07_READ_ISSUING {1}     \
                   CONFIG.M08_READ_ISSUING {1}     CONFIG.M09_READ_ISSUING {1}     CONFIG.M10_READ_ISSUING {1}     CONFIG.M11_READ_ISSUING {1}     \
                   CONFIG.M12_READ_ISSUING {1}     CONFIG.M13_READ_ISSUING {1}     CONFIG.M14_READ_ISSUING {1}     CONFIG.M15_READ_ISSUING {1}     \
                   CONFIG.S00_SINGLE_THREAD {1}                                  \
                   CONFIG.M00_A00_BASE_ADDR {0x0101000000000000}                 \
                   CONFIG.M01_A00_BASE_ADDR {0x0102000000000000}                 \
                   CONFIG.M02_A00_BASE_ADDR {0x0104000000000000}                 \
                   CONFIG.M03_A00_BASE_ADDR {0x0101080000000000}                 \
                   CONFIG.M04_A00_BASE_ADDR {0x0102080000000000}                 \
                   CONFIG.M05_A00_BASE_ADDR {0x0104080000000000}                 \
                   CONFIG.M00_A00_ADDR_WIDTH {24} CONFIG.M01_A00_ADDR_WIDTH {24} CONFIG.M02_A00_ADDR_WIDTH {24}     \
                   CONFIG.M03_A00_ADDR_WIDTH {24} CONFIG.M04_A00_ADDR_WIDTH {24} CONFIG.M05_A00_ADDR_WIDTH {24}     \
                   ] [get_ips axi4lite_crossbar_1]

  set_property generate_synth_checkpoint false [get_files $ip_dir/axi4lite_crossbar_1/axi4lite_crossbar_1.xci] 
  generate_target {instantiation_template}     [get_files $ip_dir/axi4lite_crossbar_1/axi4lite_crossbar_1.xci] >> $log_file  
  generate_target all                          [get_files $ip_dir/axi4lite_crossbar_1/axi4lite_crossbar_1.xci] >> $log_file  
  export_ip_user_files -of_objects             [get_files $ip_dir/axi4lite_crossbar_1/axi4lite_crossbar_1.xci] -no_script >> $log_file  
  export_simulation    -of_objects             [get_files $ip_dir/axi4lite_crossbar_1/axi4lite_crossbar_1.xci] -directory ip_dir/ip_user_files/sim_scripts -force >> $log_file


  puts "                        generating IP axi3_crossbar_0"
  create_ip -name axi_crossbar -vendor xilinx.com -library ip -version 2.1 -module_name axi3_crossbar_0 -dir $ip_dir >> $log_file
  set_property -dict [list                                                                                           \
                     CONFIG.ADDR_RANGES {12}                                                                         \
                     CONFIG.NUM_SI {3}                                                                               \
                     CONFIG.NUM_MI {8}                                                                               \
                     CONFIG.ADDR_WIDTH {64}                                                                          \
                     CONFIG.PROTOCOL {AXI3}                                                                          \
                     CONFIG.ID_WIDTH {7}                                                                             \
                     CONFIG.S00_THREAD_ID_WIDTH {5} CONFIG.S01_THREAD_ID_WIDTH {5} CONFIG.S02_THREAD_ID_WIDTH {5} CONFIG.S03_THREAD_ID_WIDTH {5} \
                     CONFIG.S04_THREAD_ID_WIDTH {5} CONFIG.S05_THREAD_ID_WIDTH {5} CONFIG.S06_THREAD_ID_WIDTH {5} CONFIG.S07_THREAD_ID_WIDTH {5} \
                     CONFIG.S08_THREAD_ID_WIDTH {5} CONFIG.S09_THREAD_ID_WIDTH {5} CONFIG.S10_THREAD_ID_WIDTH {5} CONFIG.S11_THREAD_ID_WIDTH {5} \
                     CONFIG.S12_THREAD_ID_WIDTH {5} CONFIG.S13_THREAD_ID_WIDTH {5} CONFIG.S14_THREAD_ID_WIDTH {5} CONFIG.S15_THREAD_ID_WIDTH {5} \
                     CONFIG.S01_BASE_ID {0x00000020} CONFIG.S02_BASE_ID {0x00000040} CONFIG.S03_BASE_ID {0x00000060} \
                     CONFIG.S04_BASE_ID {0x00000080} CONFIG.S05_BASE_ID {0x000000a0} CONFIG.S06_BASE_ID {0x000000c0} \
                     CONFIG.S07_BASE_ID {0x000000e0} CONFIG.S08_BASE_ID {0x00000100} CONFIG.S09_BASE_ID {0x00000120} \
                     CONFIG.S10_BASE_ID {0x00000140} CONFIG.S11_BASE_ID {0x00000160} CONFIG.S12_BASE_ID {0x00000180} \
                     CONFIG.S13_BASE_ID {0x000001a0} CONFIG.S14_BASE_ID {0x000001c0} CONFIG.S15_BASE_ID {0x000001e0} \
                     CONFIG.M00_A00_BASE_ADDR {0x00101040000000000}                                                  \
                     CONFIG.M00_A01_BASE_ADDR {0x00102040000000000}                                                  \
                     CONFIG.M00_A02_BASE_ADDR {0x0104040000000000}                                                   \
                     CONFIG.M00_A03_BASE_ADDR {0x01010C0000000000}                                                   \
                     CONFIG.M00_A04_BASE_ADDR {0x01020C0000000000}                                                   \
                     CONFIG.M00_A05_BASE_ADDR {0x01040C0000000000}                                                   \
                     CONFIG.M00_A06_BASE_ADDR {0x0100000000000000}                                                   \
                     CONFIG.M00_A07_BASE_ADDR {0x0103000000000000}                                                   \
                     CONFIG.M00_A08_BASE_ADDR {0x0105000000000000}                                                   \
                     CONFIG.M01_A00_BASE_ADDR {0x0000040000000000}                                                   \
                     CONFIG.M02_A00_BASE_ADDR {0x0001040000000000}                                                   \
                     CONFIG.M03_A00_BASE_ADDR {0x0001040100000000}                                                   \
                     CONFIG.M04_A00_BASE_ADDR {0x00000C0000000000}                                                   \
                     CONFIG.M05_A00_BASE_ADDR {0x00010C0000000000}                                                   \
                     CONFIG.M06_A00_BASE_ADDR {0x00010C0100000000}                                                   \
                     CONFIG.M07_A00_BASE_ADDR {0x0101000000000000}                                                   \
                     CONFIG.M07_A01_BASE_ADDR {0x0102000000000000}                                                   \
                     CONFIG.M07_A02_BASE_ADDR {0x0104000000000000}                                                   \
                     CONFIG.M07_A03_BASE_ADDR {0x0108000000000000}                                                   \
                     CONFIG.M07_A04_BASE_ADDR {0x0102080000000000}                                                   \
                     CONFIG.M07_A05_BASE_ADDR {0x0104080000000000}                                                   \
                     CONFIG.M07_A06_BASE_ADDR {0x0}                                                                  \
                     CONFIG.M07_A07_BASE_ADDR {0x0001000000000000}                                                   \
                     CONFIG.M07_A08_BASE_ADDR {0x0001000100000000}                                                   \
                     CONFIG.M07_A09_BASE_ADDR {0x0000080000000000}                                                   \
                     CONFIG.M07_A10_BASE_ADDR {0x0001080000000000}                                                   \
                     CONFIG.M07_A11_BASE_ADDR {0x0001080100000000}                                                   \
                     CONFIG.M00_A00_ADDR_WIDTH {24} CONFIG.M00_A01_ADDR_WIDTH {24} CONFIG.M00_A02_ADDR_WIDTH {24} CONFIG.M00_A03_ADDR_WIDTH {24} \
                     CONFIG.M00_A04_ADDR_WIDTH {24} CONFIG.M00_A05_ADDR_WIDTH {24} CONFIG.M00_A06_ADDR_WIDTH {24} CONFIG.M00_A07_ADDR_WIDTH {24} \
                     CONFIG.M00_A08_ADDR_WIDTH {24} CONFIG.M01_A00_ADDR_WIDTH {42} CONFIG.M02_A00_ADDR_WIDTH {31} CONFIG.M03_A00_ADDR_WIDTH {31} \
                     CONFIG.M04_A00_ADDR_WIDTH {42} CONFIG.M05_A00_ADDR_WIDTH {31} CONFIG.M06_A00_ADDR_WIDTH {31} CONFIG.M07_A00_ADDR_WIDTH {24} \
                     CONFIG.M07_A01_ADDR_WIDTH {24} CONFIG.M07_A02_ADDR_WIDTH {24} CONFIG.M07_A03_ADDR_WIDTH {24} CONFIG.M07_A04_ADDR_WIDTH {24} \
                     CONFIG.M07_A05_ADDR_WIDTH {24} CONFIG.M07_A06_ADDR_WIDTH {42} CONFIG.M07_A07_ADDR_WIDTH {31} CONFIG.M07_A08_ADDR_WIDTH {31} \
                     CONFIG.M07_A09_ADDR_WIDTH {42} CONFIG.M07_A10_ADDR_WIDTH {31} CONFIG.M07_A11_ADDR_WIDTH {31}   \
                     ] [get_ips axi3_crossbar_0]



  set_property generate_synth_checkpoint false [get_files $ip_dir/axi3_crossbar_0/axi3_crossbar_0.xci] 
  generate_target {instantiation_template}     [get_files $ip_dir/axi3_crossbar_0/axi3_crossbar_0.xci] >> $log_file  
  generate_target all                          [get_files $ip_dir/axi3_crossbar_0/axi3_crossbar_0.xci] >> $log_file  
  export_ip_user_files -of_objects             [get_files $ip_dir/axi3_crossbar_0/axi3_crossbar_0.xci] -no_script >> $log_file  
  export_simulation    -of_objects             [get_files $ip_dir/axi3_crossbar_0/axi3_crossbar_0.xci] -directory ip_dir/ip_user_files/sim_scripts -force >> $log_file


  puts "                        generating IP axi3_crossbar_1"
  create_ip -name axi_crossbar -vendor xilinx.com -library ip -version 2.1 -module_name axi3_crossbar_1 -dir $ip_dir >> $log_file
  set_property -dict [list                                                                                           \
                     CONFIG.ADDR_RANGES {6}                                                                          \
                     CONFIG.NUM_MI {7}                                                                               \
                     CONFIG.ADDR_WIDTH {64}                                                                          \
                     CONFIG.PROTOCOL {AXI3}                                                                          \
                     CONFIG.ID_WIDTH {7}                                                                             \
                     CONFIG.S00_THREAD_ID_WIDTH {7} CONFIG.S01_THREAD_ID_WIDTH {7} CONFIG.S02_THREAD_ID_WIDTH {7} CONFIG.S03_THREAD_ID_WIDTH {7} \
                     CONFIG.S04_THREAD_ID_WIDTH {7} CONFIG.S05_THREAD_ID_WIDTH {7} CONFIG.S06_THREAD_ID_WIDTH {7} CONFIG.S07_THREAD_ID_WIDTH {7} \
                     CONFIG.S08_THREAD_ID_WIDTH {7} CONFIG.S09_THREAD_ID_WIDTH {7} CONFIG.S10_THREAD_ID_WIDTH {7} CONFIG.S11_THREAD_ID_WIDTH {7} \
                     CONFIG.S12_THREAD_ID_WIDTH {7} CONFIG.S13_THREAD_ID_WIDTH {7} CONFIG.S14_THREAD_ID_WIDTH {7} CONFIG.S15_THREAD_ID_WIDTH {7} \
                     CONFIG.S01_BASE_ID {0x00000080} CONFIG.S02_BASE_ID {0x00000100} CONFIG.S03_BASE_ID {0x00000180} \
                     CONFIG.S04_BASE_ID {0x00000200} CONFIG.S05_BASE_ID {0x00000280} CONFIG.S06_BASE_ID {0x00000300} \
                     CONFIG.S07_BASE_ID {0x00000380} CONFIG.S08_BASE_ID {0x00000400} CONFIG.S09_BASE_ID {0x00000480} \
                     CONFIG.S10_BASE_ID {0x00000500} CONFIG.S11_BASE_ID {0x00000580} CONFIG.S12_BASE_ID {0x00000600} \
                     CONFIG.S13_BASE_ID {0x00000680} CONFIG.S14_BASE_ID {0x00000700} CONFIG.S15_BASE_ID {0x00000780} \
                     CONFIG.M00_A00_BASE_ADDR {0x0101000000000000}                                                   \
                     CONFIG.M00_A01_BASE_ADDR {0x0102000000000000}                                                   \
                     CONFIG.M00_A02_BASE_ADDR {0x0104000000000000}                                                   \
                     CONFIG.M00_A03_BASE_ADDR {0x101080000000000}                                                    \
                     CONFIG.M00_A04_BASE_ADDR {0x102080000000000}                                                    \
                     CONFIG.M00_A05_BASE_ADDR {0x0104080000000000}                                                   \
                     CONFIG.M01_A00_BASE_ADDR {0x0000000000000000}                                                   \
                     CONFIG.M02_A00_BASE_ADDR {0x0001000000000000}                                                   \
                     CONFIG.M03_A00_BASE_ADDR {0x0001000100000000}                                                   \
                     CONFIG.M04_A00_BASE_ADDR {0x0000080000000000}                                                   \
                     CONFIG.M05_A00_BASE_ADDR {0x0001080000000000}                                                   \
                     CONFIG.M06_A00_BASE_ADDR {0x0001080100000000}                                                   \
                     CONFIG.M00_A00_ADDR_WIDTH {24} CONFIG.M00_A01_ADDR_WIDTH {24} CONFIG.M00_A02_ADDR_WIDTH {24} CONFIG.M00_A03_ADDR_WIDTH {24} \
                     CONFIG.M00_A04_ADDR_WIDTH {24} CONFIG.M00_A05_ADDR_WIDTH {24} CONFIG.M01_A00_ADDR_WIDTH {42} CONFIG.M02_A00_ADDR_WIDTH {31} \
                     CONFIG.M03_A00_ADDR_WIDTH {31} CONFIG.M04_A00_ADDR_WIDTH {42} CONFIG.M05_A00_ADDR_WIDTH {31} CONFIG.M06_A00_ADDR_WIDTH {31} \
                     ] [get_ips axi3_crossbar_1]


  set_property generate_synth_checkpoint false [get_files $ip_dir/axi3_crossbar_1/axi3_crossbar_1.xci] 
  generate_target {instantiation_template}     [get_files $ip_dir/axi3_crossbar_1/axi3_crossbar_1.xci] >> $log_file  
  generate_target all                          [get_files $ip_dir/axi3_crossbar_1/axi3_crossbar_1.xci] >> $log_file  
  export_ip_user_files -of_objects             [get_files $ip_dir/axi3_crossbar_1/axi3_crossbar_1.xci] -no_script >> $log_file  
  export_simulation    -of_objects             [get_files $ip_dir/axi3_crossbar_1/axi3_crossbar_1.xci] -directory ip_dir/ip_user_files/sim_scripts -force >> $log_file


  puts "                        generating IP axi3_axi4lite_protocol_converter_0"
  create_ip -name axi_protocol_converter -vendor xilinx.com -library ip -version 2.1 -module_name axi3_axi4lite_protocol_converter_0 -dir $ip_dir >> $log_file

  set_property -dict [list                                      \
                      CONFIG.SI_PROTOCOL {AXI3}                 \
                      CONFIG.ADDR_WIDTH {64}                    \
                      CONFIG.ID_WIDTH {7}                       \
                      CONFIG.MI_PROTOCOL {AXI4LITE}             \
                      CONFIG.TRANSLATION_MODE {2}               \
                      CONFIG.DATA_WIDTH {32}                    \
                      ] [get_ips axi3_axi4lite_protocol_converter_0]
 
  set_property generate_synth_checkpoint false [get_files $ip_dir/axi3_axi4lite_protocol_converter_0/axi3_axi4lite_protocol_converter_0.xci] 
  generate_target {instantiation_template}     [get_files $ip_dir/axi3_axi4lite_protocol_converter_0/axi3_axi4lite_protocol_converter_0.xci] >> $log_file  
  generate_target all                          [get_files $ip_dir/axi3_axi4lite_protocol_converter_0/axi3_axi4lite_protocol_converter_0.xci] >> $log_file  
  export_ip_user_files -of_objects             [get_files $ip_dir/axi3_axi4lite_protocol_converter_0/axi3_axi4lite_protocol_converter_0.xci] -no_script >> $log_file  
  export_simulation    -of_objects             [get_files $ip_dir/axi3_axi4lite_protocol_converter_0/axi3_axi4lite_protocol_converter_0.xci] -directory ip_dir/ip_user_files/sim_scripts -force >> $log_file

  puts "                        generating IP axi4_axi3_protocol_converter_0"
  create_ip -name axi_protocol_converter -vendor xilinx.com -library ip -version 2.1 -module_name axi4_axi3_protocol_converter_0 -dir $ip_dir >> $log_file

  set_property -dict [list                                     \
                      CONFIG.MI_PROTOCOL {AXI3}                \
                      CONFIG.ADDR_WIDTH {64}                   \
                      CONFIG.ID_WIDTH {1}                      \
                      CONFIG.TRANSLATION_MODE {2}              \
                      CONFIG.DATA_WIDTH {32}                   \
                      ] [get_ips axi4_axi3_protocol_converter_0]

  set_property generate_synth_checkpoint false [get_files $ip_dir/axi4_axi3_protocol_converter_0/axi4_axi3_protocol_converter_0.xci] 
  generate_target {instantiation_template}     [get_files $ip_dir/axi4_axi3_protocol_converter_0/axi4_axi3_protocol_converter_0.xci] >> $log_file  
  generate_target all                          [get_files $ip_dir/axi4_axi3_protocol_converter_0/axi4_axi3_protocol_converter_0.xci] >> $log_file  
  export_ip_user_files -of_objects             [get_files $ip_dir/axi4_axi3_protocol_converter_0/axi4_axi3_protocol_converter_0.xci] -no_script >> $log_file  
  export_simulation    -of_objects             [get_files $ip_dir/axi4_axi3_protocol_converter_0/axi4_axi3_protocol_converter_0.xci] -directory ip_dir/ip_user_files/sim_scripts -force >> $log_file


  puts "                        generating IP vio_0"
  create_ip -name vio -vendor xilinx.com -library ip -version 3.0 -module_name vio_0 -dir $ip_dir >> $log_file
  set_property -dict [list                                 \
                      CONFIG.C_PROBE_IN7_WIDTH {2}         \
                      CONFIG.C_PROBE_IN6_WIDTH {2}         \
                      CONFIG.C_PROBE_IN5_WIDTH {2}         \
                      CONFIG.C_PROBE_IN4_WIDTH {2}         \
                      CONFIG.C_PROBE_IN3_WIDTH {2}         \
                      CONFIG.C_PROBE_IN2_WIDTH {2}         \
                      CONFIG.C_PROBE_IN1_WIDTH {2}         \
                      CONFIG.C_PROBE_IN0_WIDTH {1}         \
                      CONFIG.C_NUM_PROBE_OUT {0}           \
                      CONFIG.C_EN_PROBE_IN_ACTIVITY {0}    \
                      CONFIG.C_NUM_PROBE_IN {8}            \
                      ] [get_ips vio_0]
 
  set_property generate_synth_checkpoint false [get_files $ip_dir/vio_0/vio_0.xci] 
  generate_target {instantiation_template}     [get_files $ip_dir/vio_0/vio_0.xci] >> $log_file  
  generate_target all                          [get_files $ip_dir/vio_0/vio_0.xci] >> $log_file  
  export_ip_user_files -of_objects             [get_files $ip_dir/vio_0/vio_0.xci] -no_script >> $log_file  
  export_simulation    -of_objects             [get_files $ip_dir/vio_0/vio_0.xci] -directory ip_dir/ip_user_files/sim_scripts -force >> $log_file


  puts "                        generating IP proc_sys_reset_0"
  create_ip -name proc_sys_reset -vendor xilinx.com -library ip -version 5.0 -module_name proc_sys_reset_0 -dir $ip_dir >> $log_file

  set_property -dict [list                                      \
                      CONFIG.C_EXT_RESET_HIGH {0}               \
                      CONFIG.C_AUX_RESET_HIGH {0}               \
                      ] [get_ips proc_sys_reset_0]
 
  set_property generate_synth_checkpoint false [get_files $ip_dir/proc_sys_reset_0/proc_sys_reset_0.xci] 
  generate_target {instantiation_template}     [get_files $ip_dir/proc_sys_reset_0/proc_sys_reset_0.xci] >> $log_file  
  generate_target all                          [get_files $ip_dir/proc_sys_reset_0/proc_sys_reset_0.xci] >> $log_file  
  export_ip_user_files -of_objects             [get_files $ip_dir/proc_sys_reset_0/proc_sys_reset_0.xci] -no_script >> $log_file  
  export_simulation    -of_objects             [get_files $ip_dir/proc_sys_reset_0/proc_sys_reset_0.xci] -directory ip_dir/ip_user_files/sim_scripts -force >> $log_file


}

