###########################################################################
# Clocking & Reset
###########################################################################
#set_property PACKAGE_PIN AT17 [get_ports RAW_RESETN]
set_property PACKAGE_PIN AR13 [get_ports PLL_LOCKED]
#set_property PACKAGE_PIN AP13 [get_ports OCDE]
set_property PACKAGE_PIN P24 [get_ports OCDE]
set_property PACKAGE_PIN AY34 [get_ports RAW_SYSCLK_P]
set_property PACKAGE_PIN AY35 [get_ports RAW_SYSCLK_N]
set_property PACKAGE_PIN AV33 [get_ports RAW_RCLK_P]
set_property PACKAGE_PIN AV34 [get_ports RAW_RCLK_N]
set_property PACKAGE_PIN N29 [get_ports DDIMMA_RESETN]
set_property PACKAGE_PIN K26 [get_ports DDIMMB_RESETN]
set_property PACKAGE_PIN K16 [get_ports DDIMMC_RESETN]
set_property PACKAGE_PIN M16 [get_ports DDIMMD_RESETN]
set_property PACKAGE_PIN G26 [get_ports DDIMMW_RESETN]
set_property PACKAGE_PIN G20 [get_ports DDIMMS_RESETN]
set_property IOSTANDARD LVCMOS18 [get_ports DDIMMA_RESETN]
set_property IOSTANDARD LVCMOS18 [get_ports DDIMMB_RESETN]
set_property IOSTANDARD LVCMOS18 [get_ports DDIMMC_RESETN]
set_property IOSTANDARD LVCMOS18 [get_ports DDIMMD_RESETN]
set_property IOSTANDARD LVCMOS18 [get_ports DDIMMW_RESETN]
set_property IOSTANDARD LVCMOS18 [get_ports DDIMMS_RESETN]
#set_property IOSTANDARD LVCMOS18 [get_ports RAW_RESETN]
set_property IOSTANDARD LVCMOS18 [get_ports PLL_LOCKED]
set_property IOSTANDARD LVCMOS18 [get_ports OCDE]
set_property IOSTANDARD LVDS [get_ports SYSCLK_PROBE0_N]
set_property IOSTANDARD LVDS [get_ports SYSCLK_PROBE0_P]
set_property PACKAGE_PIN AV14 [get_ports SYSCLK_PROBE0_P]
set_property PACKAGE_PIN AV13 [get_ports SYSCLK_PROBE0_N]
set_property IOSTANDARD LVDS [get_ports SYSCLK_PROBE1_N]
set_property IOSTANDARD LVDS [get_ports SYSCLK_PROBE1_P]
set_property PACKAGE_PIN H23 [get_ports SYSCLK_PROBE1_P]
set_property PACKAGE_PIN G23 [get_ports SYSCLK_PROBE1_N]
set_property IOSTANDARD LVDS [get_ports RAW_SYSCLK_N]
set_property IOSTANDARD LVDS [get_ports RAW_SYSCLK_P]
set_property IOSTANDARD LVDS [get_ports RAW_RCLK_N]
set_property IOSTANDARD LVDS [get_ports RAW_RCLK_P]
set_property DIFF_TERM_ADV TERM_100 [get_ports RAW_SYSCLK_N]
set_property DIFF_TERM_ADV TERM_100 [get_ports RAW_SYSCLK_P]
set_property DIFF_TERM_ADV TERM_100 [get_ports RAW_RCLK_N]
set_property DIFF_TERM_ADV TERM_100 [get_ports RAW_RCLK_P]

###########################################################################
# I2C
###########################################################################
set_property PACKAGE_PIN AR14 [get_ports SCL_IO]
set_property PACKAGE_PIN AR15 [get_ports SDA_IO]
set_property IOSTANDARD LVCMOS18 [get_ports SCL_IO]
set_property IOSTANDARD LVCMOS18 [get_ports SDA_IO]
set_property PULLUP true [get_ports SCL_IO]
set_property PULLUP true [get_ports SDA_IO]

###########################################################################
# Input/Output Delays
###########################################################################
#set_input_delay -clock [get_clocks clk_out1_clk_wiz_sysclk] -min -add_delay 0.000 [get_ports SCL_IO]
#set_input_delay -clock [get_clocks clk_out1_clk_wiz_sysclk] -max -add_delay 0.000 [get_ports SCL_IO]
#set_input_delay -clock [get_clocks clk_out1_clk_wiz_sysclk] -min -add_delay 0.000 [get_ports SDA_IO]
#set_input_delay -clock [get_clocks clk_out1_clk_wiz_sysclk] -max -add_delay 0.000 [get_ports SDA_IO]
#set_output_delay -clock [get_clocks clk_out1_clk_wiz_sysclk] -min -add_delay 0.000 [get_ports SYSCLK_PROBE0_P]
#set_output_delay -clock [get_clocks clk_out1_clk_wiz_sysclk] -max -add_delay 0.000 [get_ports SYSCLK_PROBE0_P]
#set_output_delay -clock [get_clocks clk_out1_clk_wiz_sysclk] -min -add_delay 0.000 [get_ports SYSCLK_PROBE1_P]
#set_output_delay -clock [get_clocks clk_out1_clk_wiz_sysclk] -max -add_delay 0.000 [get_ports SYSCLK_PROBE1_P]
#set_output_delay -clock [get_clocks clk_out1_clk_wiz_sysclk] -min -add_delay 0.000 [get_ports SCL_IO]
#set_output_delay -clock [get_clocks clk_out1_clk_wiz_sysclk] -max -add_delay 0.000 [get_ports SCL_IO]
#set_output_delay -clock [get_clocks clk_out1_clk_wiz_sysclk] -min -add_delay 0.000 [get_ports SDA_IO]
#set_output_delay -clock [get_clocks clk_out1_clk_wiz_sysclk] -max -add_delay 0.000 [get_ports SDA_IO]

#set_multicycle_path -to [get_ports SDA_IO] 4
#set_multicycle_path -to [get_ports SCL_IO] 4
#set_multicycle_path -to [get_ports SYSCLK_PROBE0_P] 4
#set_multicycle_path -to [get_ports SYSCLK_PROBE1_P] 4

###########################################################################
# Physical Constraints
###########################################################################
#resize_pblock [get_pblock opencapi] -add {CLOCKREGION_X0Y9:CLOCKREGION_X2Y5}; # SLR 1

#resize_pblock [get_pblock counter] -add {CLOCKREGION_X3Y5:CLOCKREGION_X5Y5}; # SLR 1

###########################################################################
# Miscellaneous IO
###########################################################################
# LEDs
set_property package_pin N32 [get_ports LED_DDIMMA_RED]
set_property package_pin L31 [get_ports LED_DDIMMA_GREEN]
set_property package_pin B27 [get_ports LED_DDIMMB_RED]
set_property package_pin J32 [get_ports LED_DDIMMB_GREEN]
set_property package_pin C25 [get_ports LED_DDIMMC_RED]
set_property package_pin A25 [get_ports LED_DDIMMC_GREEN]
set_property package_pin A23 [get_ports LED_DDIMMD_RED]
set_property package_pin C24 [get_ports LED_DDIMMD_GREEN]
set_property package_pin N30 [get_ports LED_DDIMMW_RED]
set_property package_pin M27 [get_ports LED_DDIMMW_GREEN]

set_property iostandard LVCMOS18 [get_ports LED_DDIMMA_RED]
set_property iostandard LVCMOS18 [get_ports LED_DDIMMA_GREEN]
set_property iostandard LVCMOS18 [get_ports LED_DDIMMB_RED]
set_property iostandard LVCMOS18 [get_ports LED_DDIMMB_GREEN]
set_property iostandard LVCMOS18 [get_ports LED_DDIMMC_RED]
set_property iostandard LVCMOS18 [get_ports LED_DDIMMC_GREEN]
set_property iostandard LVCMOS18 [get_ports LED_DDIMMD_RED]
set_property iostandard LVCMOS18 [get_ports LED_DDIMMD_GREEN]
set_property iostandard LVCMOS18 [get_ports LED_DDIMMW_RED]
set_property iostandard LVCMOS18 [get_ports LED_DDIMMW_GREEN]

# JTAG - Input
set_property PACKAGE_PIN A24 [get_ports jjtag_fpga_tck_i]
set_property PACKAGE_PIN D25 [get_ports jjtag_fpga_tms_i]
set_property PACKAGE_PIN B25 [get_ports jjtag_fpga_tdi_i]
set_property PACKAGE_PIN C23 [get_ports fpga_jjtag_tdo_o]
set_property PACKAGE_PIN C22 [get_ports jjtag_fpga_trst_i]
set_property PACKAGE_PIN D24 [get_ports jjtag_fpga_rst_i]
set_property IOSTANDARD LVCMOS18 [get_ports jjtag_fpga_tck_i]
set_property IOSTANDARD LVCMOS18 [get_ports jjtag_fpga_tms_i]
set_property IOSTANDARD LVCMOS18 [get_ports jjtag_fpga_tdi_i]
set_property IOSTANDARD LVCMOS18 [get_ports fpga_jjtag_tdo_o]
set_property IOSTANDARD LVCMOS18 [get_ports jjtag_fpga_trst_i]
set_property IOSTANDARD LVCMOS18 [get_ports jjtag_fpga_rst_i]
set_property OFFCHIP_TERM NONE [get_ports fpga_jjtag_tdo_o]
set_property SLEW SLOW [get_ports fpga_jjtag_tdo_o]

# JTAG - DDIMMA
set_property PACKAGE_PIN N28 [get_ports fpga_ddimma_tck_o]
set_property PACKAGE_PIN N27 [get_ports fpga_ddimma_tms_o]
set_property PACKAGE_PIN L28 [get_ports fpga_ddimma_tdi_o]
set_property PACKAGE_PIN L29 [get_ports ddimma_fpga_tdo_i]
set_property IOSTANDARD LVCMOS18 [get_ports fpga_ddimma_tck_o]
set_property IOSTANDARD LVCMOS18 [get_ports fpga_ddimma_tms_o]
set_property IOSTANDARD LVCMOS18 [get_ports fpga_ddimma_tdi_o]
set_property IOSTANDARD LVCMOS18 [get_ports ddimma_fpga_tdo_i]
set_property PULLUP true [get_ports fpga_ddimma_tms_o]

# JTAG - DDIMMB
set_property PACKAGE_PIN H28 [get_ports fpga_ddimmb_tck_o]
set_property PACKAGE_PIN J27 [get_ports fpga_ddimmb_tms_o]
set_property PACKAGE_PIN G28 [get_ports fpga_ddimmb_tdi_o]
set_property PACKAGE_PIN F28 [get_ports ddimmb_fpga_tdo_i]
set_property IOSTANDARD LVCMOS18 [get_ports fpga_ddimmb_tck_o]
set_property IOSTANDARD LVCMOS18 [get_ports fpga_ddimmb_tms_o]
set_property IOSTANDARD LVCMOS18 [get_ports fpga_ddimmb_tdi_o]
set_property IOSTANDARD LVCMOS18 [get_ports ddimmb_fpga_tdo_i]
set_property PULLUP true [get_ports fpga_ddimmb_tms_o]

# JTAG - DDIMMC
set_property PACKAGE_PIN J20 [get_ports fpga_ddimmc_tck_o]
set_property PACKAGE_PIN H20 [get_ports fpga_ddimmc_tms_o]
set_property PACKAGE_PIN F19 [get_ports fpga_ddimmc_tdi_o]
set_property PACKAGE_PIN F18 [get_ports ddimmc_fpga_tdo_i]
set_property IOSTANDARD LVCMOS18 [get_ports fpga_ddimmc_tck_o]
set_property IOSTANDARD LVCMOS18 [get_ports fpga_ddimmc_tms_o]
set_property IOSTANDARD LVCMOS18 [get_ports fpga_ddimmc_tdi_o]
set_property IOSTANDARD LVCMOS18 [get_ports ddimmc_fpga_tdo_i]
set_property PULLUP true [get_ports fpga_ddimmc_tms_o]

# JTAG - DDIMMD
set_property PACKAGE_PIN K17 [get_ports fpga_ddimmd_tck_o]
set_property PACKAGE_PIN L16 [get_ports fpga_ddimmd_tms_o]
set_property PACKAGE_PIN M20 [get_ports fpga_ddimmd_tdi_o]
set_property PACKAGE_PIN L20 [get_ports ddimmd_fpga_tdo_i]
set_property IOSTANDARD LVCMOS18 [get_ports fpga_ddimmd_tck_o]
set_property IOSTANDARD LVCMOS18 [get_ports fpga_ddimmd_tms_o]
set_property IOSTANDARD LVCMOS18 [get_ports fpga_ddimmd_tdi_o]
set_property IOSTANDARD LVCMOS18 [get_ports ddimmd_fpga_tdo_i]
set_property PULLUP true [get_ports fpga_ddimmd_tms_o]

# JTAG - DDIMMW
set_property PACKAGE_PIN D26 [get_ports fpga_ddimmw_tck_o]
set_property PACKAGE_PIN A28 [get_ports fpga_ddimmw_tms_o]
set_property PACKAGE_PIN C27 [get_ports fpga_ddimmw_tdi_o]
set_property PACKAGE_PIN C28 [get_ports ddimmw_fpga_tdo_i]
set_property IOSTANDARD LVCMOS18 [get_ports fpga_ddimmw_tck_o]
set_property IOSTANDARD LVCMOS18 [get_ports fpga_ddimmw_tms_o]
set_property IOSTANDARD LVCMOS18 [get_ports fpga_ddimmw_tdi_o]
set_property IOSTANDARD LVCMOS18 [get_ports ddimmw_fpga_tdo_i]
set_property PULLUP true [get_ports fpga_ddimmw_tms_o]

# JTAG - DDIMMS
set_property PACKAGE_PIN C20 [get_ports fpga_ocmb_tck_o]
set_property PACKAGE_PIN D20 [get_ports fpga_ocmb_tms_o]
set_property PACKAGE_PIN B21 [get_ports fpga_ocmb_tdi_o]
set_property PACKAGE_PIN A21 [get_ports ocmb_fpga_tdo_i]
set_property IOSTANDARD LVCMOS18 [get_ports fpga_ocmb_tck_o]
set_property IOSTANDARD LVCMOS18 [get_ports fpga_ocmb_tms_o]
set_property IOSTANDARD LVCMOS18 [get_ports fpga_ocmb_tdi_o]
set_property IOSTANDARD LVCMOS18 [get_ports ocmb_fpga_tdo_i]
set_property PULLUP true [get_ports fpga_ocmb_tck_o]
set_property PULLUP true [get_ports fpga_ocmb_tms_o]
set_property PULLUP true [get_ports fpga_ocmb_tdi_o]
set_property SLEW SLOW [get_ports fpga_ocmb_tck_o]
set_property OFFCHIP_TERM NONE [get_ports fpga_ocmb_tck_o]
set_property OFFCHIP_TERM NONE [get_ports fpga_ocmb_tms_o]
set_property OFFCHIP_TERM NONE [get_ports fpga_ocmb_tdi_o]

# TAP Select
set_property PACKAGE_PIN J26 [get_ports fpga_ddimma_mfg_tapsel_i]
set_property PACKAGE_PIN F26 [get_ports fpga_ddimmb_mfg_tapsel_i]
set_property PACKAGE_PIN G18 [get_ports fpga_ddimmc_mfg_tapsel_i]
set_property PACKAGE_PIN J16 [get_ports fpga_ddimmd_mfg_tapsel_i]
set_property PACKAGE_PIN B28 [get_ports fpga_ddimmw_mfg_tapsel_i]
set_property PACKAGE_PIN E18 [get_ports fpga_ocmb_tapsel_o]
set_property IOSTANDARD LVCMOS18 [get_ports fpga_ddimma_mfg_tapsel_i]
set_property IOSTANDARD LVCMOS18 [get_ports fpga_ddimmb_mfg_tapsel_i]
set_property IOSTANDARD LVCMOS18 [get_ports fpga_ddimmc_mfg_tapsel_i]
set_property IOSTANDARD LVCMOS18 [get_ports fpga_ddimmd_mfg_tapsel_i]
set_property IOSTANDARD LVCMOS18 [get_ports fpga_ddimmw_mfg_tapsel_i]
set_property IOSTANDARD LVCMOS18 [get_ports fpga_ocmb_tapsel_o]
set_property PULLUP true [get_ports fpga_ocmb_tapsel_o]

# Bootstrap Pins
set_property PACKAGE_PIN F20 [get_ports exp_cpu_boot_0_o]
set_property PACKAGE_PIN H18 [get_ports exp_cpu_boot_1_o]
set_property IOSTANDARD LVCMOS18 [get_ports exp_cpu_boot_0_o]
set_property IOSTANDARD LVCMOS18 [get_ports exp_cpu_boot_1_o]
set_property PULLUP true [get_ports exp_cpu_boot_0_o]
set_property PULLDOWN true [get_ports exp_cpu_boot_1_o]

# UART
set_property PACKAGE_PIN AR17 [get_ports cp2105_fpga_rout2_i]
set_property PACKAGE_PIN AP17 [get_ports fpga_cp2105_din2_o]
set_property PACKAGE_PIN AV16 [get_ports fpga_trs3122_din0_o]
set_property PACKAGE_PIN AN15 [get_ports fpga_trs3122_din1_o]
set_property PACKAGE_PIN AN16 [get_ports fpga_usb_minib_rst_o]
set_property PACKAGE_PIN AV15 [get_ports trs3122_fpga_rout0_i]
set_property PACKAGE_PIN AP15 [get_ports trs3122_fpga_rout1_i]
set_property IOSTANDARD LVCMOS18 [get_ports cp2105_fpga_rout2_i]
set_property IOSTANDARD LVCMOS18 [get_ports fpga_cp2105_din2_o]
set_property IOSTANDARD LVCMOS18 [get_ports fpga_trs3122_din0_o]
set_property IOSTANDARD LVCMOS18 [get_ports fpga_trs3122_din1_o]
set_property IOSTANDARD LVCMOS18 [get_ports fpga_usb_minib_rst_o]
set_property IOSTANDARD LVCMOS18 [get_ports trs3122_fpga_rout0_i]
set_property IOSTANDARD LVCMOS18 [get_ports trs3122_fpga_rout1_i]
set_property OFFCHIP_TERM NONE [get_ports fpga_cp2105_din2_o]
set_property OFFCHIP_TERM NONE [get_ports fpga_trs3122_din0_o]
set_property OFFCHIP_TERM NONE [get_ports fpga_trs3122_din1_o]
set_property OFFCHIP_TERM NONE [get_ports fpga_usb_minib_rst_o]

# Debug Connector
set_property PACKAGE_PIN B26 [get_ports fpga_jdebug_trstb_abw_o]
set_property PACKAGE_PIN B18 [get_ports fpga_jdebug_trstb_cd_o]
set_property PACKAGE_PIN A26 [get_ports fpga_jdebug_usin_abw_o]
set_property PACKAGE_PIN A18 [get_ports fpga_jdebug_usin_cd_o]
set_property PACKAGE_PIN D29 [get_ports fpga_jdebug_usout_abw_i]
set_property PACKAGE_PIN A20 [get_ports fpga_jdebug_usout_cd_i]
set_property PACKAGE_PIN C18 [get_ports fpga_ocmb_trstb_o]
set_property PACKAGE_PIN B20 [get_ports fpga_ocmb_usin_o]
set_property PACKAGE_PIN E19 [get_ports ocmb_fpga_usout_sa2_i]
set_property IOSTANDARD LVCMOS18 [get_ports fpga_jdebug_trstb_abw_o]
set_property IOSTANDARD LVCMOS18 [get_ports fpga_jdebug_trstb_cd_o]
set_property IOSTANDARD LVCMOS18 [get_ports fpga_jdebug_usin_abw_o]
set_property IOSTANDARD LVCMOS18 [get_ports fpga_jdebug_usin_cd_o]
set_property IOSTANDARD LVCMOS18 [get_ports fpga_jdebug_usout_abw_i]
set_property IOSTANDARD LVCMOS18 [get_ports fpga_jdebug_usout_cd_i]
set_property IOSTANDARD LVCMOS18 [get_ports fpga_ocmb_trstb_o]
set_property IOSTANDARD LVCMOS18 [get_ports fpga_ocmb_usin_o]
set_property IOSTANDARD LVCMOS18 [get_ports ocmb_fpga_usout_sa2_i]
set_property PULLUP true [get_ports fpga_jdebug_trstb_abw_o]
set_property PULLUP true [get_ports fpga_jdebug_trstb_cd_o]
set_property OFFCHIP_TERM NONE [get_ports fpga_ocmb_usin_o]

###########################################################################
# OCMB OpenCAPI Channels
###########################################################################
# DDIMM A
set_property package_pin H43 [get_ports DDIMMA_FPGA_LANE_P[7]] ; # Quad X0Y6, Channel X0Y27
set_property package_pin H44 [get_ports DDIMMA_FPGA_LANE_N[7]] ; # Quad X0Y6, Channel X0Y27
set_property package_pin H38 [get_ports FPGA_DDIMMA_LANE_P[7]] ; # Quad X0Y6, Channel X0Y27
set_property package_pin H39 [get_ports FPGA_DDIMMA_LANE_N[7]] ; # Quad X0Y6, Channel X0Y27
set_property package_pin J45 [get_ports DDIMMA_FPGA_LANE_P[6]] ; # Quad X0Y6, Channel X0Y26
set_property package_pin J46 [get_ports DDIMMA_FPGA_LANE_N[6]] ; # Quad X0Y6, Channel X0Y26
set_property package_pin J40 [get_ports FPGA_DDIMMA_LANE_P[6]] ; # Quad X0Y6, Channel X0Y26
set_property package_pin J41 [get_ports FPGA_DDIMMA_LANE_N[6]] ; # Quad X0Y6, Channel X0Y26
set_property package_pin K43 [get_ports DDIMMA_FPGA_LANE_P[5]] ; # Quad X0Y6, Channel X0Y25
set_property package_pin K44 [get_ports DDIMMA_FPGA_LANE_N[5]] ; # Quad X0Y6, Channel X0Y25
set_property package_pin K38 [get_ports FPGA_DDIMMA_LANE_P[5]] ; # Quad X0Y6, Channel X0Y25
set_property package_pin K39 [get_ports FPGA_DDIMMA_LANE_N[5]] ; # Quad X0Y6, Channel X0Y25
set_property package_pin L45 [get_ports DDIMMA_FPGA_LANE_P[4]] ; # Quad X0Y6, Channel X0Y24
set_property package_pin L46 [get_ports DDIMMA_FPGA_LANE_N[4]] ; # Quad X0Y6, Channel X0Y24
set_property package_pin L40 [get_ports FPGA_DDIMMA_LANE_P[4]] ; # Quad X0Y6, Channel X0Y24
set_property package_pin L41 [get_ports FPGA_DDIMMA_LANE_N[4]] ; # Quad X0Y6, Channel X0Y24
set_property package_pin M43 [get_ports DDIMMA_FPGA_LANE_P[3]] ; # Quad X0Y5, Channel X0Y23
set_property package_pin M44 [get_ports DDIMMA_FPGA_LANE_N[3]] ; # Quad X0Y5, Channel X0Y23
set_property package_pin M38 [get_ports FPGA_DDIMMA_LANE_P[3]] ; # Quad X0Y5, Channel X0Y23
set_property package_pin M39 [get_ports FPGA_DDIMMA_LANE_N[3]] ; # Quad X0Y5, Channel X0Y23
set_property package_pin N45 [get_ports DDIMMA_FPGA_LANE_P[2]] ; # Quad X0Y5, Channel X0Y22
set_property package_pin N46 [get_ports DDIMMA_FPGA_LANE_N[2]] ; # Quad X0Y5, Channel X0Y22
set_property package_pin N40 [get_ports FPGA_DDIMMA_LANE_P[2]] ; # Quad X0Y5, Channel X0Y22
set_property package_pin N41 [get_ports FPGA_DDIMMA_LANE_N[2]] ; # Quad X0Y5, Channel X0Y22
set_property package_pin P43 [get_ports DDIMMA_FPGA_LANE_P[1]] ; # Quad X0Y5, Channel X0Y21
set_property package_pin P44 [get_ports DDIMMA_FPGA_LANE_N[1]] ; # Quad X0Y5, Channel X0Y21
set_property package_pin P38 [get_ports FPGA_DDIMMA_LANE_P[1]] ; # Quad X0Y5, Channel X0Y21
set_property package_pin P39 [get_ports FPGA_DDIMMA_LANE_N[1]] ; # Quad X0Y5, Channel X0Y21
set_property package_pin R45 [get_ports DDIMMA_FPGA_LANE_P[0]] ; # Quad X0Y5, Channel X0Y20
set_property package_pin R46 [get_ports DDIMMA_FPGA_LANE_N[0]] ; # Quad X0Y5, Channel X0Y20
set_property package_pin R40 [get_ports FPGA_DDIMMA_LANE_P[0]] ; # Quad X0Y5, Channel X0Y20
set_property package_pin R41 [get_ports FPGA_DDIMMA_LANE_N[0]] ; # Quad X0Y5, Channel X0Y20
set_property package_pin R36 [get_ports DDIMMA_FPGA_REFCLK_P[1]] ; # Quad X0Y6
set_property package_pin R37 [get_ports DDIMMA_FPGA_REFCLK_N[1]] ; # Quad X0Y6
set_property package_pin U36 [get_ports DDIMMA_FPGA_REFCLK_P[0]] ; # Quad X0Y5
set_property package_pin U37 [get_ports DDIMMA_FPGA_REFCLK_N[0]] ; # Quad X0Y5

# DDIMM B
set_property package_pin AH43 [get_ports DDIMMB_FPGA_LANE_P[7]] ; # Quad X0Y1, Channel X0Y7
set_property package_pin AH44 [get_ports DDIMMB_FPGA_LANE_N[7]] ; # Quad X0Y1, Channel X0Y7
set_property package_pin AH38 [get_ports FPGA_DDIMMB_LANE_P[7]] ; # Quad X0Y1, Channel X0Y7
set_property package_pin AH39 [get_ports FPGA_DDIMMB_LANE_N[7]] ; # Quad X0Y1, Channel X0Y7
set_property package_pin AJ45 [get_ports DDIMMB_FPGA_LANE_P[6]] ; # Quad X0Y1, Channel X0Y6
set_property package_pin AJ46 [get_ports DDIMMB_FPGA_LANE_N[6]] ; # Quad X0Y1, Channel X0Y6
set_property package_pin AJ40 [get_ports FPGA_DDIMMB_LANE_P[6]] ; # Quad X0Y1, Channel X0Y6
set_property package_pin AJ41 [get_ports FPGA_DDIMMB_LANE_N[6]] ; # Quad X0Y1, Channel X0Y6
set_property package_pin AK43 [get_ports DDIMMB_FPGA_LANE_P[5]] ; # Quad X0Y1, Channel X0Y5
set_property package_pin AK44 [get_ports DDIMMB_FPGA_LANE_N[5]] ; # Quad X0Y1, Channel X0Y5
set_property package_pin AK38 [get_ports FPGA_DDIMMB_LANE_P[5]] ; # Quad X0Y1, Channel X0Y5
set_property package_pin AK39 [get_ports FPGA_DDIMMB_LANE_N[5]] ; # Quad X0Y1, Channel X0Y5
set_property package_pin AL45 [get_ports DDIMMB_FPGA_LANE_P[4]] ; # Quad X0Y1, Channel X0Y4
set_property package_pin AL46 [get_ports DDIMMB_FPGA_LANE_N[4]] ; # Quad X0Y1, Channel X0Y4
set_property package_pin AL40 [get_ports FPGA_DDIMMB_LANE_P[4]] ; # Quad X0Y1, Channel X0Y4
set_property package_pin AL41 [get_ports FPGA_DDIMMB_LANE_N[4]] ; # Quad X0Y1, Channel X0Y4
set_property package_pin AM43 [get_ports DDIMMB_FPGA_LANE_P[3]] ; # Quad X0Y0, Channel X0Y3
set_property package_pin AM44 [get_ports DDIMMB_FPGA_LANE_N[3]] ; # Quad X0Y0, Channel X0Y3
set_property package_pin AM38 [get_ports FPGA_DDIMMB_LANE_P[3]] ; # Quad X0Y0, Channel X0Y3
set_property package_pin AM39 [get_ports FPGA_DDIMMB_LANE_N[3]] ; # Quad X0Y0, Channel X0Y3
set_property package_pin AN45 [get_ports DDIMMB_FPGA_LANE_P[2]] ; # Quad X0Y0, Channel X0Y2
set_property package_pin AN46 [get_ports DDIMMB_FPGA_LANE_N[2]] ; # Quad X0Y0, Channel X0Y2
set_property package_pin AN40 [get_ports FPGA_DDIMMB_LANE_P[2]] ; # Quad X0Y0, Channel X0Y2
set_property package_pin AN41 [get_ports FPGA_DDIMMB_LANE_N[2]] ; # Quad X0Y0, Channel X0Y2
set_property package_pin AP43 [get_ports DDIMMB_FPGA_LANE_P[1]] ; # Quad X0Y0, Channel X0Y1
set_property package_pin AP44 [get_ports DDIMMB_FPGA_LANE_N[1]] ; # Quad X0Y0, Channel X0Y1
set_property package_pin AP38 [get_ports FPGA_DDIMMB_LANE_P[1]] ; # Quad X0Y0, Channel X0Y1
set_property package_pin AP39 [get_ports FPGA_DDIMMB_LANE_N[1]] ; # Quad X0Y0, Channel X0Y1
set_property package_pin AR45 [get_ports DDIMMB_FPGA_LANE_P[0]] ; # Quad X0Y0, Channel X0Y0
set_property package_pin AR46 [get_ports DDIMMB_FPGA_LANE_N[0]] ; # Quad X0Y0, Channel X0Y0
set_property package_pin AR40 [get_ports FPGA_DDIMMB_LANE_P[0]] ; # Quad X0Y0, Channel X0Y0
set_property package_pin AR41 [get_ports FPGA_DDIMMB_LANE_N[0]] ; # Quad X0Y0, Channel X0Y0
set_property package_pin AE36 [get_ports DDIMMB_FPGA_REFCLK_P[1]] ; # Quad X0Y1
set_property package_pin AE37 [get_ports DDIMMB_FPGA_REFCLK_N[1]] ; # Quad X0Y1
set_property package_pin AG36 [get_ports DDIMMB_FPGA_REFCLK_P[0]] ; # Quad X0Y0
set_property package_pin AG37 [get_ports DDIMMB_FPGA_REFCLK_N[0]] ; # Quad X0Y0

# DDIMM C
set_property package_pin H4 [get_ports DDIMMC_FPGA_LANE_P[7]] ; # Quad X1Y6, Channel X1Y27
set_property package_pin H3 [get_ports DDIMMC_FPGA_LANE_N[7]] ; # Quad X1Y6, Channel X1Y27
set_property package_pin H9 [get_ports FPGA_DDIMMC_LANE_P[7]] ; # Quad X1Y6, Channel X1Y27
set_property package_pin H8 [get_ports FPGA_DDIMMC_LANE_N[7]] ; # Quad X1Y6, Channel X1Y27
set_property package_pin J2 [get_ports DDIMMC_FPGA_LANE_P[6]] ; # Quad X1Y6, Channel X1Y26
set_property package_pin J1 [get_ports DDIMMC_FPGA_LANE_N[6]] ; # Quad X1Y6, Channel X1Y26
set_property package_pin J7 [get_ports FPGA_DDIMMC_LANE_P[6]] ; # Quad X1Y6, Channel X1Y26
set_property package_pin J6 [get_ports FPGA_DDIMMC_LANE_N[6]] ; # Quad X1Y6, Channel X1Y26
set_property package_pin K4 [get_ports DDIMMC_FPGA_LANE_P[5]] ; # Quad X1Y6, Channel X1Y25
set_property package_pin K3 [get_ports DDIMMC_FPGA_LANE_N[5]] ; # Quad X1Y6, Channel X1Y25
set_property package_pin K9 [get_ports FPGA_DDIMMC_LANE_P[5]] ; # Quad X1Y6, Channel X1Y25
set_property package_pin K8 [get_ports FPGA_DDIMMC_LANE_N[5]] ; # Quad X1Y6, Channel X1Y25
set_property package_pin L2 [get_ports DDIMMC_FPGA_LANE_P[4]] ; # Quad X1Y6, Channel X1Y24
set_property package_pin L1 [get_ports DDIMMC_FPGA_LANE_N[4]] ; # Quad X1Y6, Channel X1Y24
set_property package_pin L7 [get_ports FPGA_DDIMMC_LANE_P[4]] ; # Quad X1Y6, Channel X1Y24
set_property package_pin L6 [get_ports FPGA_DDIMMC_LANE_N[4]] ; # Quad X1Y6, Channel X1Y24
set_property package_pin M4 [get_ports DDIMMC_FPGA_LANE_P[3]] ; # Quad X1Y5, Channel X1Y23
set_property package_pin M3 [get_ports DDIMMC_FPGA_LANE_N[3]] ; # Quad X1Y5, Channel X1Y23
set_property package_pin M9 [get_ports FPGA_DDIMMC_LANE_P[3]] ; # Quad X1Y5, Channel X1Y23
set_property package_pin M8 [get_ports FPGA_DDIMMC_LANE_N[3]] ; # Quad X1Y5, Channel X1Y23
set_property package_pin N2 [get_ports DDIMMC_FPGA_LANE_P[2]] ; # Quad X1Y5, Channel X1Y22
set_property package_pin N1 [get_ports DDIMMC_FPGA_LANE_N[2]] ; # Quad X1Y5, Channel X1Y22
set_property package_pin N7 [get_ports FPGA_DDIMMC_LANE_P[2]] ; # Quad X1Y5, Channel X1Y22
set_property package_pin N6 [get_ports FPGA_DDIMMC_LANE_N[2]] ; # Quad X1Y5, Channel X1Y22
set_property package_pin P4 [get_ports DDIMMC_FPGA_LANE_P[1]] ; # Quad X1Y5, Channel X1Y21
set_property package_pin P3 [get_ports DDIMMC_FPGA_LANE_N[1]] ; # Quad X1Y5, Channel X1Y21
set_property package_pin P9 [get_ports FPGA_DDIMMC_LANE_P[1]] ; # Quad X1Y5, Channel X1Y21
set_property package_pin P8 [get_ports FPGA_DDIMMC_LANE_N[1]] ; # Quad X1Y5, Channel X1Y21
set_property package_pin R2 [get_ports DDIMMC_FPGA_LANE_P[0]] ; # Quad X1Y5, Channel X1Y20
set_property package_pin R1 [get_ports DDIMMC_FPGA_LANE_N[0]] ; # Quad X1Y5, Channel X1Y20
set_property package_pin R7 [get_ports FPGA_DDIMMC_LANE_P[0]] ; # Quad X1Y5, Channel X1Y20
set_property package_pin R6 [get_ports FPGA_DDIMMC_LANE_N[0]] ; # Quad X1Y5, Channel X1Y20
set_property package_pin R11 [get_ports DDIMMC_FPGA_REFCLK_P[1]] ; # Quad X1Y6
set_property package_pin R10 [get_ports DDIMMC_FPGA_REFCLK_N[1]] ; # Quad X1Y6
set_property package_pin U11 [get_ports DDIMMC_FPGA_REFCLK_P[0]] ; # Quad X1Y5
set_property package_pin U10 [get_ports DDIMMC_FPGA_REFCLK_N[0]] ; # Quad X1Y5

# DDIMM D
set_property package_pin AH4 [get_ports DDIMMD_FPGA_LANE_P[7]] ; # Quad X1Y1, Channel X1Y7
set_property package_pin AH3 [get_ports DDIMMD_FPGA_LANE_N[7]] ; # Quad X1Y1, Channel X1Y7
set_property package_pin AH9 [get_ports FPGA_DDIMMD_LANE_P[7]] ; # Quad X1Y1, Channel X1Y7
set_property package_pin AH8 [get_ports FPGA_DDIMMD_LANE_N[7]] ; # Quad X1Y1, Channel X1Y7
set_property package_pin AJ2 [get_ports DDIMMD_FPGA_LANE_P[6]] ; # Quad X1Y1, Channel X1Y6
set_property package_pin AJ1 [get_ports DDIMMD_FPGA_LANE_N[6]] ; # Quad X1Y1, Channel X1Y6
set_property package_pin AJ7 [get_ports FPGA_DDIMMD_LANE_P[6]] ; # Quad X1Y1, Channel X1Y6
set_property package_pin AJ6 [get_ports FPGA_DDIMMD_LANE_N[6]] ; # Quad X1Y1, Channel X1Y6
set_property package_pin AK4 [get_ports DDIMMD_FPGA_LANE_P[5]] ; # Quad X1Y1, Channel X1Y5
set_property package_pin AK3 [get_ports DDIMMD_FPGA_LANE_N[5]] ; # Quad X1Y1, Channel X1Y5
set_property package_pin AK9 [get_ports FPGA_DDIMMD_LANE_P[5]] ; # Quad X1Y1, Channel X1Y5
set_property package_pin AK8 [get_ports FPGA_DDIMMD_LANE_N[5]] ; # Quad X1Y1, Channel X1Y5
set_property package_pin AL2 [get_ports DDIMMD_FPGA_LANE_P[4]] ; # Quad X1Y1, Channel X1Y4
set_property package_pin AL1 [get_ports DDIMMD_FPGA_LANE_N[4]] ; # Quad X1Y1, Channel X1Y4
set_property package_pin AL7 [get_ports FPGA_DDIMMD_LANE_P[4]] ; # Quad X1Y1, Channel X1Y4
set_property package_pin AL6 [get_ports FPGA_DDIMMD_LANE_N[4]] ; # Quad X1Y1, Channel X1Y4
set_property package_pin AM4 [get_ports DDIMMD_FPGA_LANE_P[3]] ; # Quad X1Y0, Channel X1Y3
set_property package_pin AM3 [get_ports DDIMMD_FPGA_LANE_N[3]] ; # Quad X1Y0, Channel X1Y3
set_property package_pin AM9 [get_ports FPGA_DDIMMD_LANE_P[3]] ; # Quad X1Y0, Channel X1Y3
set_property package_pin AM8 [get_ports FPGA_DDIMMD_LANE_N[3]] ; # Quad X1Y0, Channel X1Y3
set_property package_pin AN2 [get_ports DDIMMD_FPGA_LANE_P[2]] ; # Quad X1Y0, Channel X1Y2
set_property package_pin AN1 [get_ports DDIMMD_FPGA_LANE_N[2]] ; # Quad X1Y0, Channel X1Y2
set_property package_pin AN7 [get_ports FPGA_DDIMMD_LANE_P[2]] ; # Quad X1Y0, Channel X1Y2
set_property package_pin AN6 [get_ports FPGA_DDIMMD_LANE_N[2]] ; # Quad X1Y0, Channel X1Y2
set_property package_pin AP4 [get_ports DDIMMD_FPGA_LANE_P[1]] ; # Quad X1Y0, Channel X1Y1
set_property package_pin AP3 [get_ports DDIMMD_FPGA_LANE_N[1]] ; # Quad X1Y0, Channel X1Y1
set_property package_pin AP9 [get_ports FPGA_DDIMMD_LANE_P[1]] ; # Quad X1Y0, Channel X1Y1
set_property package_pin AP8 [get_ports FPGA_DDIMMD_LANE_N[1]] ; # Quad X1Y0, Channel X1Y1
set_property package_pin AR2 [get_ports DDIMMD_FPGA_LANE_P[0]] ; # Quad X1Y0, Channel X1Y0
set_property package_pin AR1 [get_ports DDIMMD_FPGA_LANE_N[0]] ; # Quad X1Y0, Channel X1Y0
set_property package_pin AR7 [get_ports FPGA_DDIMMD_LANE_P[0]] ; # Quad X1Y0, Channel X1Y0
set_property package_pin AR6 [get_ports FPGA_DDIMMD_LANE_N[0]] ; # Quad X1Y0, Channel X1Y0
set_property package_pin AE11 [get_ports DDIMMD_FPGA_REFCLK_P[1]] ; # Quad X1Y1
set_property package_pin AE10 [get_ports DDIMMD_FPGA_REFCLK_N[1]] ; # Quad X1Y1
set_property package_pin AG11 [get_ports DDIMMD_FPGA_REFCLK_P[0]] ; # Quad X1Y0
set_property package_pin AG10 [get_ports DDIMMD_FPGA_REFCLK_N[0]] ; # Quad X1Y0

###########################################################################
# Attached DDR4
###########################################################################
#set_property package_pin H9  [get_ports FPGA_DDR4_DIMM_A[17]]
#set_property package_pin K12 [get_ports FPGA_DDR4_DIMM_A[16]]
#set_property package_pin B11 [get_ports FPGA_DDR4_DIMM_A[15]]
#set_property package_pin C9  [get_ports FPGA_DDR4_DIMM_A[14]]
#set_property package_pin J11 [get_ports FPGA_DDR4_DIMM_A[13]]
#set_property package_pin E8  [get_ports FPGA_DDR4_DIMM_A[12]]
#set_property package_pin H11 [get_ports FPGA_DDR4_DIMM_A[11]]
#set_property package_pin D9  [get_ports FPGA_DDR4_DIMM_A[10]]
#set_property package_pin F12 [get_ports FPGA_DDR4_DIMM_A[9]]
#set_property package_pin J8  [get_ports FPGA_DDR4_DIMM_A[8]]
#set_property package_pin J9  [get_ports FPGA_DDR4_DIMM_A[7]]
#set_property package_pin F10 [get_ports FPGA_DDR4_DIMM_A[6]]
#set_property package_pin G10 [get_ports FPGA_DDR4_DIMM_A[5]]
#set_property package_pin E12 [get_ports FPGA_DDR4_DIMM_A[4]]
#set_property package_pin D11 [get_ports FPGA_DDR4_DIMM_A[3]]
#set_property package_pin G11 [get_ports FPGA_DDR4_DIMM_A[2]]
#set_property package_pin G9  [get_ports FPGA_DDR4_DIMM_A[1]]
#set_property package_pin F9  [get_ports FPGA_DDR4_DIMM_A[0]]
#set_property package_pin C12 [get_ports FPGA_DDR4_DIMM_ACT_N]
#set_property package_pin H8  [get_ports FPGA_DDR4_DIMM_BA[1]]
#set_property package_pin F8  [get_ports FPGA_DDR4_DIMM_BA[0]]
#set_property package_pin E11 [get_ports FPGA_DDR4_DIMM_BG[1]]
#set_property package_pin D10 [get_ports FPGA_DDR4_DIMM_BG[0]]
#set_property package_pin A9  [get_ports FPGA_DDR4_DIMM_C[2]]
#set_property package_pin C11 [get_ports FPGA_DDR4_DIMM_C[1]]
#set_property package_pin B10 [get_ports FPGA_DDR4_DIMM_C[0]]
#set_property package_pin B9  [get_ports FPGA_DDR4_DIMM_CKE]
#set_property package_pin G12 [get_ports FPGA_DDR4_DIMM_CLK_N]
#set_property package_pin H12 [get_ports FPGA_DDR4_DIMM_CLK_P]
#set_property package_pin E10 [get_ports FPGA_DDR4_DIMM_CS_N]
#set_property package_pin J15 [get_ports FPGA_DDR4_DIMM_DQ[71]]
#set_property package_pin H14 [get_ports FPGA_DDR4_DIMM_DQ[70]]
#set_property package_pin L13 [get_ports FPGA_DDR4_DIMM_DQ[69]]
#set_property package_pin K13 [get_ports FPGA_DDR4_DIMM_DQ[68]]
#set_property package_pin J14 [get_ports FPGA_DDR4_DIMM_DQ[67]]
#set_property package_pin J16 [get_ports FPGA_DDR4_DIMM_DQ[66]]
#set_property package_pin K15 [get_ports FPGA_DDR4_DIMM_DQ[65]]
#set_property package_pin H16 [get_ports FPGA_DDR4_DIMM_DQ[64]]
#set_property package_pin M20 [get_ports FPGA_DDR4_DIMM_DQ[63]]
#set_property package_pin L19 [get_ports FPGA_DDR4_DIMM_DQ[62]]
#set_property package_pin M22 [get_ports FPGA_DDR4_DIMM_DQ[61]]
#set_property package_pin M19 [get_ports FPGA_DDR4_DIMM_DQ[60]]
#set_property package_pin M21 [get_ports FPGA_DDR4_DIMM_DQ[59]]
#set_property package_pin N19 [get_ports FPGA_DDR4_DIMM_DQ[58]]
#set_property package_pin L18 [get_ports FPGA_DDR4_DIMM_DQ[57]]
#set_property package_pin L20 [get_ports FPGA_DDR4_DIMM_DQ[56]]
#set_property package_pin K18 [get_ports FPGA_DDR4_DIMM_DQ[55]]
#set_property package_pin G21 [get_ports FPGA_DDR4_DIMM_DQ[54]]
#set_property package_pin J18 [get_ports FPGA_DDR4_DIMM_DQ[53]]
#set_property package_pin H18 [get_ports FPGA_DDR4_DIMM_DQ[52]]
#set_property package_pin J19 [get_ports FPGA_DDR4_DIMM_DQ[51]]
#set_property package_pin H19 [get_ports FPGA_DDR4_DIMM_DQ[50]]
#set_property package_pin J20 [get_ports FPGA_DDR4_DIMM_DQ[49]]
#set_property package_pin G22 [get_ports FPGA_DDR4_DIMM_DQ[48]]
#set_property package_pin C18 [get_ports FPGA_DDR4_DIMM_DQ[47]]
#set_property package_pin A22 [get_ports FPGA_DDR4_DIMM_DQ[46]]
#set_property package_pin B19 [get_ports FPGA_DDR4_DIMM_DQ[45]]
#set_property package_pin C19 [get_ports FPGA_DDR4_DIMM_DQ[44]]
#set_property package_pin A18 [get_ports FPGA_DDR4_DIMM_DQ[43]]
#set_property package_pin A19 [get_ports FPGA_DDR4_DIMM_DQ[42]]
#set_property package_pin B22 [get_ports FPGA_DDR4_DIMM_DQ[41]]
#set_property package_pin D18 [get_ports FPGA_DDR4_DIMM_DQ[40]]
#set_property package_pin G20 [get_ports FPGA_DDR4_DIMM_DQ[39]]
#set_property package_pin E21 [get_ports FPGA_DDR4_DIMM_DQ[38]]
#set_property package_pin G19 [get_ports FPGA_DDR4_DIMM_DQ[37]]
#set_property package_pin E18 [get_ports FPGA_DDR4_DIMM_DQ[36]]
#set_property package_pin D21 [get_ports FPGA_DDR4_DIMM_DQ[35]]
#set_property package_pin F19 [get_ports FPGA_DDR4_DIMM_DQ[34]]
#set_property package_pin F20 [get_ports FPGA_DDR4_DIMM_DQ[33]]
#set_property package_pin F18 [get_ports FPGA_DDR4_DIMM_DQ[32]]
#set_property package_pin D15 [get_ports FPGA_DDR4_DIMM_DQ[31]]
#set_property package_pin D16 [get_ports FPGA_DDR4_DIMM_DQ[30]]
#set_property package_pin B14 [get_ports FPGA_DDR4_DIMM_DQ[29]]
#set_property package_pin B17 [get_ports FPGA_DDR4_DIMM_DQ[28]]
#set_property package_pin A14 [get_ports FPGA_DDR4_DIMM_DQ[27]]
#set_property package_pin B16 [get_ports FPGA_DDR4_DIMM_DQ[26]]
#set_property package_pin C16 [get_ports FPGA_DDR4_DIMM_DQ[25]]
#set_property package_pin A17 [get_ports FPGA_DDR4_DIMM_DQ[24]]
#set_property package_pin G17 [get_ports FPGA_DDR4_DIMM_DQ[23]]
#set_property package_pin E15 [get_ports FPGA_DDR4_DIMM_DQ[22]]
#set_property package_pin F17 [get_ports FPGA_DDR4_DIMM_DQ[21]]
#set_property package_pin G16 [get_ports FPGA_DDR4_DIMM_DQ[20]]
#set_property package_pin E17 [get_ports FPGA_DDR4_DIMM_DQ[19]]
#set_property package_pin F14 [get_ports FPGA_DDR4_DIMM_DQ[18]]
#set_property package_pin E16 [get_ports FPGA_DDR4_DIMM_DQ[17]]
#set_property package_pin F15 [get_ports FPGA_DDR4_DIMM_DQ[16]]
#set_property package_pin N17 [get_ports FPGA_DDR4_DIMM_DQ[15]]
#set_property package_pin N16 [get_ports FPGA_DDR4_DIMM_DQ[14]]
#set_property package_pin N18 [get_ports FPGA_DDR4_DIMM_DQ[13]]
#set_property package_pin M14 [get_ports FPGA_DDR4_DIMM_DQ[12]]
#set_property package_pin M17 [get_ports FPGA_DDR4_DIMM_DQ[11]]
#set_property package_pin M15 [get_ports FPGA_DDR4_DIMM_DQ[10]]
#set_property package_pin M16 [get_ports FPGA_DDR4_DIMM_DQ[9]]
#set_property package_pin L17 [get_ports FPGA_DDR4_DIMM_DQ[8]]
#set_property package_pin K10 [get_ports FPGA_DDR4_DIMM_DQ[7]]
#set_property package_pin M11 [get_ports FPGA_DDR4_DIMM_DQ[6]]
#set_property package_pin K11 [get_ports FPGA_DDR4_DIMM_DQ[5]]
#set_property package_pin M10 [get_ports FPGA_DDR4_DIMM_DQ[4]]
#set_property package_pin M9  [get_ports FPGA_DDR4_DIMM_DQ[3]]
#set_property package_pin N9  [get_ports FPGA_DDR4_DIMM_DQ[2]]
#set_property package_pin L9  [get_ports FPGA_DDR4_DIMM_DQ[1]]
#set_property package_pin L10 [get_ports FPGA_DDR4_DIMM_DQ[0]]
#set_property package_pin K16 [get_ports FPGA_DDR4_DIMM_DQS_N[8]]
#set_property package_pin K22 [get_ports FPGA_DDR4_DIMM_DQS_N[7]]
#set_property package_pin K20 [get_ports FPGA_DDR4_DIMM_DQS_N[6]]
#set_property package_pin B21 [get_ports FPGA_DDR4_DIMM_DQS_N[5]]
#set_property package_pin E22 [get_ports FPGA_DDR4_DIMM_DQS_N[4]]
#set_property package_pin A15 [get_ports FPGA_DDR4_DIMM_DQS_N[3]]
#set_property package_pin E13 [get_ports FPGA_DDR4_DIMM_DQS_N[2]]
#set_property package_pin L14 [get_ports FPGA_DDR4_DIMM_DQS_N[1]]
#set_property package_pin L12 [get_ports FPGA_DDR4_DIMM_DQS_N[0]]
#set_property package_pin K17 [get_ports FPGA_DDR4_DIMM_DQS_P[8]]
#set_property package_pin L22 [get_ports FPGA_DDR4_DIMM_DQS_P[7]]
#set_property package_pin K21 [get_ports FPGA_DDR4_DIMM_DQS_P[6]]
#set_property package_pin C21 [get_ports FPGA_DDR4_DIMM_DQS_P[5]]
#set_property package_pin F22 [get_ports FPGA_DDR4_DIMM_DQS_P[4]]
#set_property package_pin B15 [get_ports FPGA_DDR4_DIMM_DQS_P[3]]
#set_property package_pin F13 [get_ports FPGA_DDR4_DIMM_DQS_P[2]]
#set_property package_pin L15 [get_ports FPGA_DDR4_DIMM_DQS_P[1]]
#set_property package_pin M12 [get_ports FPGA_DDR4_DIMM_DQS_P[0]]
#set_property package_pin A10 [get_ports FPGA_DDR4_DIMM_ODT]
#set_property package_pin G7  [get_ports FPGA_DDR4_DIMM_PAR]
#set_property package_pin F7  [get_ports FPGA_DDR4_DIMM_RESET_N]
#
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_A[17]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_A[16]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_A[15]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_A[14]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_A[13]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_A[12]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_A[11]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_A[10]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_A[9]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_A[8]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_A[7]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_A[6]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_A[5]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_A[4]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_A[3]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_A[2]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_A[1]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_A[0]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_ACT_N]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_BA[1]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_BA[0]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_BG[1]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_BG[0]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_C[2]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_C[1]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_C[0]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_CKE]
#set_property iostandard DIFF_POD12 [get_ports FPGA_DDR4_DIMM_CLK_N]
#set_property iostandard DIFF_POD12 [get_ports FPGA_DDR4_DIMM_CLK_P]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_CS_N]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[71]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[70]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[69]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[68]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[67]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[66]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[65]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[64]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[63]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[62]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[61]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[60]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[59]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[58]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[57]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[56]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[55]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[54]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[53]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[52]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[51]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[50]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[49]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[48]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[47]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[46]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[45]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[44]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[43]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[42]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[41]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[40]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[39]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[38]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[37]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[36]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[35]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[34]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[33]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[32]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[31]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[30]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[29]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[28]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[27]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[26]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[25]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[24]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[23]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[22]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[21]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[20]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[19]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[18]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[17]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[16]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[15]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[14]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[13]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[12]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[11]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[10]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[9]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[8]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[7]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[6]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[5]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[4]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[3]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[2]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[1]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_DQ[0]]
#set_property iostandard DIFF_POD12 [get_ports FPGA_DDR4_DIMM_DQS_N[8]]
#set_property iostandard DIFF_POD12 [get_ports FPGA_DDR4_DIMM_DQS_N[7]]
#set_property iostandard DIFF_POD12 [get_ports FPGA_DDR4_DIMM_DQS_N[6]]
#set_property iostandard DIFF_POD12 [get_ports FPGA_DDR4_DIMM_DQS_N[5]]
#set_property iostandard DIFF_POD12 [get_ports FPGA_DDR4_DIMM_DQS_N[4]]
#set_property iostandard DIFF_POD12 [get_ports FPGA_DDR4_DIMM_DQS_N[3]]
#set_property iostandard DIFF_POD12 [get_ports FPGA_DDR4_DIMM_DQS_N[2]]
#set_property iostandard DIFF_POD12 [get_ports FPGA_DDR4_DIMM_DQS_N[1]]
#set_property iostandard DIFF_POD12 [get_ports FPGA_DDR4_DIMM_DQS_N[0]]
#set_property iostandard DIFF_POD12 [get_ports FPGA_DDR4_DIMM_DQS_P[8]]
#set_property iostandard DIFF_POD12 [get_ports FPGA_DDR4_DIMM_DQS_P[7]]
#set_property iostandard DIFF_POD12 [get_ports FPGA_DDR4_DIMM_DQS_P[6]]
#set_property iostandard DIFF_POD12 [get_ports FPGA_DDR4_DIMM_DQS_P[5]]
#set_property iostandard DIFF_POD12 [get_ports FPGA_DDR4_DIMM_DQS_P[4]]
#set_property iostandard DIFF_POD12 [get_ports FPGA_DDR4_DIMM_DQS_P[3]]
#set_property iostandard DIFF_POD12 [get_ports FPGA_DDR4_DIMM_DQS_P[2]]
#set_property iostandard DIFF_POD12 [get_ports FPGA_DDR4_DIMM_DQS_P[1]]
#set_property iostandard DIFF_POD12 [get_ports FPGA_DDR4_DIMM_DQS_P[0]]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_ODT]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_PAR]
#set_property iostandard LVCMOS12 [get_ports FPGA_DDR4_DIMM_RESET_N]

#derive_pll_clocks
#derive_clock_uncertainty


#check crossing

#set_clock_groups -asynchronous -group RAW_SYSCLK_P
#set_clock_groups -asynchronous -group clk_out1_clk_wiz_sysclk
#set_clock_groups -asynchronous -group txoutclk_out[0]_1

###########################################################################
# Flash settings
###########################################################################
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 10.6 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property BITSTREAM.CONFIG.SPI_FALL_EDGE YES [current_design]
set_property BITSTREAM.CONFIG.D02 PULLNONE [current_design]
set_property BITSTREAM.CONFIG.D03 PULLNONE [current_design]
set_property BITSTREAM.CONFIG.DONEPIN PULLNONE [current_design]
set_property BITSTREAM.CONFIG.INITPIN PULLNONE [current_design]
set_property BITSTREAM.CONFIG.M0PIN PULLNONE [current_design]
set_property BITSTREAM.CONFIG.M1PIN PULLNONE [current_design]
set_property BITSTREAM.CONFIG.M2PIN PULLNONE [current_design]
set_property BITSTREAM.CONFIG.PROGPIN PULLNONE [current_design]
set_property BITSTREAM.CONFIG.PUDC_B PULLNONE [current_design]
set_property BITSTREAM.CONFIG.RDWR_B_FCS_B PULLNONE [current_design]
