###########################################################################
# VCU128 Xilinx evaluation board
###########################################################################
# Clocking & Reset
###########################################################################
set_property PACKAGE_PIN BM29 [get_ports OCDE]
set_property PACKAGE_PIN BH51 [get_ports RAW_SYSCLK_P]
set_property PACKAGE_PIN BJ51 [get_ports RAW_SYSCLK_N]
set_property PACKAGE_PIN BJ4 [get_ports RAW_RCLK_P]
set_property PACKAGE_PIN BK3 [get_ports RAW_RCLK_N]
set_property PACKAGE_PIN G27 [get_ports DDIMMA_RESETN]
set_property PACKAGE_PIN F25 [get_ports DDIMMB_RESETN]

set_property PACKAGE_PIN BH24 [get_ports GPIO_LED_0]
set_property PACKAGE_PIN BG24 [get_ports GPIO_LED_1]
set_property PACKAGE_PIN BG25 [get_ports GPIO_LED_2]
set_property PACKAGE_PIN BF25 [get_ports GPIO_LED_3]
set_property PACKAGE_PIN BF26 [get_ports GPIO_LED_4]
set_property PACKAGE_PIN BF27 [get_ports GPIO_LED_5]
set_property PACKAGE_PIN BG27 [get_ports GPIO_LED_6]
set_property PACKAGE_PIN BG28 [get_ports GPIO_LED_7]


set_property PACKAGE_PIN H27 [get_ports fpga_ddimma_mfg_tapsel_i]
set_property PACKAGE_PIN F26 [get_ports fpga_ddimmb_mfg_tapsel_i]

###########################################################################
# I2C - One coming from Tormem card and one from VCU128
###########################################################################
#set_property PACKAGE_PIN BP42 [get_ports SCL_IO]        ; #TORMEM_SCL is connected on G20 FMC-H38 - VCU rework on BP42
#set_property PACKAGE_PIN BE41 [get_ports SDA_IO]        ; #TORMEM_SDA is connected on H20 FMC-H37 - VCU rework on BE41
set_property PACKAGE_PIN G20 [get_ports SCL_IO]
set_property PACKAGE_PIN H20 [get_ports SDA_IO]


###########################################################################
# OCMB OpenCAPI Channels
###########################################################################
# DDIMM A for VCU128 - GTY declared on purpose in gtwizard_ultracsale_00 in Bank 128-129, but xdc below retargets the pins to Bank 126-127
# Indeed the GTY automatic assignement in Bank 126-127 connects the lanes in reverse order for the OMI DDIMM through the Tormem board
# This trick is the only way found until now to circumvent the issue

set_property PACKAGE_PIN AL41 [get_ports {DDIMMA_FPGA_REFCLK_N[0]}]
set_property PACKAGE_PIN AL40 [get_ports {DDIMMA_FPGA_REFCLK_P[0]}]
set_property PACKAGE_PIN AN41 [get_ports {DDIMMA_FPGA_REFCLK_N[1]}]
set_property PACKAGE_PIN AN40 [get_ports {DDIMMA_FPGA_REFCLK_P[1]}]
# following assignmenet is sufficent for _P, _N Rx and Tx lanes
set_property PACKAGE_PIN AL53 [get_ports {DDIMMA_FPGA_LANE_P[0]}]
set_property PACKAGE_PIN AM51 [get_ports {DDIMMA_FPGA_LANE_P[1]}]
set_property PACKAGE_PIN AN49 [get_ports {DDIMMA_FPGA_LANE_P[2]}]
set_property PACKAGE_PIN AN53 [get_ports {DDIMMA_FPGA_LANE_P[3]}]
set_property PACKAGE_PIN AP51 [get_ports {DDIMMA_FPGA_LANE_P[4]}]
set_property PACKAGE_PIN AR53 [get_ports {DDIMMA_FPGA_LANE_P[5]}]
set_property PACKAGE_PIN AT51 [get_ports {DDIMMA_FPGA_LANE_P[6]}]
set_property PACKAGE_PIN AU53 [get_ports {DDIMMA_FPGA_LANE_P[7]}]

# DDIMM B for VCU128 - GTY declared on purpose in gtwizard_ultracsale_00 in Bank 130-131, but xdc below retargets the pins to Bank 124-125
# Indeed the GTY automatic assignement in Bank 124-125 connects the lanes in reverse order for the OMI DDIMM through the Tormem board
# This trick is the only way found until now to circumvent the issue

set_property PACKAGE_PIN AR41 [get_ports {DDIMMB_FPGA_REFCLK_N[0]}]
set_property PACKAGE_PIN AR40 [get_ports {DDIMMB_FPGA_REFCLK_P[0]}]
set_property PACKAGE_PIN AV43 [get_ports {DDIMMB_FPGA_REFCLK_N[1]}]
set_property PACKAGE_PIN AV42 [get_ports {DDIMMB_FPGA_REFCLK_P[1]}]

# following assignmenet is sufficent for _P, _N Rx and Tx lanes
set_property PACKAGE_PIN AV51 [get_ports {DDIMMB_FPGA_LANE_P[0]}]
set_property PACKAGE_PIN AW49 [get_ports {DDIMMB_FPGA_LANE_P[1]}]
set_property PACKAGE_PIN AW53 [get_ports {DDIMMB_FPGA_LANE_P[2]}]
set_property PACKAGE_PIN AY51 [get_ports {DDIMMB_FPGA_LANE_P[3]}]
set_property PACKAGE_PIN BA49 [get_ports {DDIMMB_FPGA_LANE_P[4]}]
set_property PACKAGE_PIN BA53 [get_ports {DDIMMB_FPGA_LANE_P[5]}]
set_property PACKAGE_PIN BB51 [get_ports {DDIMMB_FPGA_LANE_P[6]}]
set_property PACKAGE_PIN BC53 [get_ports {DDIMMB_FPGA_LANE_P[7]}]



set_property IOSTANDARD LVCMOS18 [get_ports DDIMMA_RESETN]
set_property DRIVE 12 [get_ports DDIMMA_RESETN]
set_property SLEW SLOW [get_ports DDIMMA_RESETN]
set_property IOSTANDARD LVCMOS18 [get_ports DDIMMB_RESETN]
set_property DRIVE 12 [get_ports DDIMMB_RESETN]
set_property SLEW SLOW [get_ports DDIMMB_RESETN]
set_property IOSTANDARD LVCMOS18 [get_ports GPIO_LED_0]
set_property DRIVE 12 [get_ports GPIO_LED_0]
set_property SLEW SLOW [get_ports GPIO_LED_0]
set_property IOSTANDARD LVDS [get_ports RAW_SYSCLK_P]
set_property EQUALIZATION EQ_NONE [get_ports RAW_SYSCLK_P]
set_property DIFF_TERM_ADV TERM_100 [get_ports RAW_SYSCLK_P]
set_property LVDS_PRE_EMPHASIS FALSE [get_ports RAW_SYSCLK_P]
set_property IOSTANDARD LVDS [get_ports RAW_SYSCLK_N]
set_property EQUALIZATION EQ_NONE [get_ports RAW_SYSCLK_N]
set_property DIFF_TERM_ADV TERM_100 [get_ports RAW_SYSCLK_N]
set_property LVDS_PRE_EMPHASIS FALSE [get_ports RAW_SYSCLK_N]
set_property IOSTANDARD LVCMOS12 [get_ports OCDE]
set_property IOSTANDARD LVCMOS18 [get_ports GPIO_LED_1]
set_property DRIVE 12 [get_ports GPIO_LED_1]
set_property SLEW SLOW [get_ports GPIO_LED_1]
set_property IOSTANDARD LVCMOS18 [get_ports GPIO_LED_2]
set_property DRIVE 12 [get_ports GPIO_LED_2]
set_property SLEW SLOW [get_ports GPIO_LED_2]
set_property IOSTANDARD LVCMOS18 [get_ports GPIO_LED_3]
set_property DRIVE 12 [get_ports GPIO_LED_3]
set_property SLEW SLOW [get_ports GPIO_LED_3]
set_property IOSTANDARD LVCMOS18 [get_ports GPIO_LED_4]
set_property DRIVE 12 [get_ports GPIO_LED_4]
set_property SLEW SLOW [get_ports GPIO_LED_4]
set_property IOSTANDARD LVCMOS18 [get_ports GPIO_LED_5]
set_property DRIVE 12 [get_ports GPIO_LED_5]
set_property SLEW SLOW [get_ports GPIO_LED_5]
set_property IOSTANDARD LVCMOS18 [get_ports GPIO_LED_6]
set_property DRIVE 12 [get_ports GPIO_LED_6]
set_property SLEW SLOW [get_ports GPIO_LED_6]
set_property IOSTANDARD LVCMOS18 [get_ports GPIO_LED_7]
set_property DRIVE 12 [get_ports GPIO_LED_7]
set_property SLEW SLOW [get_ports GPIO_LED_7]
set_property IOSTANDARD LVDS [get_ports RAW_RCLK_N]
set_property EQUALIZATION EQ_NONE [get_ports RAW_RCLK_N]
set_property DIFF_TERM_ADV TERM_100 [get_ports RAW_RCLK_N]
set_property LVDS_PRE_EMPHASIS FALSE [get_ports RAW_RCLK_N]
set_property IOSTANDARD LVDS [get_ports RAW_RCLK_P]
set_property DIFF_TERM_ADV TERM_100 [get_ports RAW_RCLK_P]
set_property LVDS_PRE_EMPHASIS FALSE [get_ports RAW_RCLK_P]

set_property IOSTANDARD LVCMOS18 [get_ports fpga_ddimma_mfg_tapsel_i]
set_property IOSTANDARD LVCMOS18 [get_ports fpga_ddimmb_mfg_tapsel_i]

set_property IOSTANDARD LVCMOS18 [get_ports SCL_IO]
set_property DRIVE 12 [get_ports SCL_IO]
set_property SLEW SLOW [get_ports SCL_IO]
set_property PULLUP true [get_ports SCL_IO]
set_property IOSTANDARD LVCMOS18 [get_ports SDA_IO]
set_property DRIVE 12 [get_ports SDA_IO]
set_property SLEW SLOW [get_ports SDA_IO]
set_property PULLUP true [get_ports SDA_IO]

###########################################################################
# Flash settings
###########################################################################
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]

