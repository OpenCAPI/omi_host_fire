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
set_property PACKAGE_PIN AL40 [get_ports {DDIMMA_FPGA_REFCLK_P[0]}] ;  # MGTREFCLK0N_127 FMCP_HSPC_GBTCLK3_M2C_N1 L9 - QUAD_127_REFCLK_P
set_property PACKAGE_PIN AN41 [get_ports {DDIMMA_FPGA_REFCLK_N[1]}] 
set_property PACKAGE_PIN AN40 [get_ports {DDIMMA_FPGA_REFCLK_P[1]}] ; # MGTREFCLK0N_126 FMCP_HSPC_GBTCLK2_M2C_N1 L13 - QUAD_126_REFCLK_P
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
set_property PACKAGE_PIN AR40 [get_ports {DDIMMB_FPGA_REFCLK_P[0]}]  ;  # MGTREFCLK0N_125 FMCP_HSPC_GBTCLK1_M2C_N B21 - QUAD_125_REFCLK_P
set_property PACKAGE_PIN AV43 [get_ports {DDIMMB_FPGA_REFCLK_N[1]}]
set_property PACKAGE_PIN AV42 [get_ports {DDIMMB_FPGA_REFCLK_P[1]}]  ; # MGTREFCLK0N_124 FMCP_HSPC_GBTCLK0_M2C_N D5 - QUAD_124_REFCLK_P

# following assignmenet is sufficent for _P, _N Rx and Tx lanes
set_property PACKAGE_PIN AV51 [get_ports {DDIMMB_FPGA_LANE_P[0]}]
set_property PACKAGE_PIN AW49 [get_ports {DDIMMB_FPGA_LANE_P[1]}]
set_property PACKAGE_PIN AW53 [get_ports {DDIMMB_FPGA_LANE_P[2]}]
set_property PACKAGE_PIN AY51 [get_ports {DDIMMB_FPGA_LANE_P[3]}]
set_property PACKAGE_PIN BA49 [get_ports {DDIMMB_FPGA_LANE_P[4]}]
set_property PACKAGE_PIN BA53 [get_ports {DDIMMB_FPGA_LANE_P[5]}]
set_property PACKAGE_PIN BB51 [get_ports {DDIMMB_FPGA_LANE_P[6]}]
set_property PACKAGE_PIN BC53 [get_ports {DDIMMB_FPGA_LANE_P[7]}]


# DDIMM A:  Should be the following with OMI DDIMM to be in the right order for VCU128
#set_property PACKAGE_PIN AL53 [get_ports {DDIMMA_FPGA_LANE_P[7]}] ; # MGTYRXP3_127 FMCP_HSPC_DP15_M2C_P Y22 - DDIMM0_RX7_P
#set_property PACKAGE_PIN AL54 [get_ports {DDIMMA_FPGA_LANE_N[7]}]
#set_property PACKAGE_PIN AL44 [get_ports {FPGA_DDIMMA_LANE_P[7]}] ; # MGTYTXP3_127 FMCP_HSPC_DP15_C2M_P M22
#set_property PACKAGE_PIN AL45 [get_ports {FPGA_DDIMMA_LANE_N[7]}]
#set_property PACKAGE_PIN AM51 [get_ports {DDIMMA_FPGA_LANE_P[6]}] ; # MGTYRXP2_127 FMCP_HSPC_DP14_M2C_P Y18
#set_property PACKAGE_PIN AM52 [get_ports {DDIMMA_FPGA_LANE_N[6]}]
#set_property PACKAGE_PIN AM46 [get_ports {FPGA_DDIMMA_LANE_P[6]}] ; # MGTYTXP2_127 FMCP_HSPC_DP14_C2M_P M18
#set_property PACKAGE_PIN AM47 [get_ports {FPGA_DDIMMA_LANE_N[6]}]
#set_property PACKAGE_PIN AN49 [get_ports {DDIMMA_FPGA_LANE_P[5]}] ; # MGTYRXP1_127 FMCP_HSPC_DP13_M2C_P Z16
#set_property PACKAGE_PIN AN50 [get_ports {DDIMMA_FPGA_LANE_N[5]}]
#set_property PACKAGE_PIN AN44 [get_ports {FPGA_DDIMMA_LANE_P[5]}] ; # MGTYTXP1_127 FMCP_HSPC_DP13_C2M_P Y30
#set_property PACKAGE_PIN AN45 [get_ports {FPGA_DDIMMA_LANE_N[5]}]
#set_property PACKAGE_PIN AN53 [get_ports {DDIMMA_FPGA_LANE_P[4]}] ; # MGTYRXP0_127 FMCP_HSPC_DP12_M2C_P Y14
#set_property PACKAGE_PIN AN54 [get_ports {DDIMMA_FPGA_LANE_N[4]}]
#set_property PACKAGE_PIN AP46 [get_ports {FPGA_DDIMMA_LANE_P[4]}] ; # MGTYTXP0_127 FMCP_HSPC_DP12_C2M_P Z28
#set_property PACKAGE_PIN AP47 [get_ports {FPGA_DDIMMA_LANE_N[4]}]
#set_property PACKAGE_PIN AP51 [get_ports {DDIMMA_FPGA_LANE_P[3]}] ; # MGTYRXP3_126 FMCP_HSPC_DP11_M2C_P Z12 - DDIMM0_RX3_P
#set_property PACKAGE_PIN AP52 [get_ports {DDIMMA_FPGA_LANE_N[3]}]
#set_property PACKAGE_PIN AR44 [get_ports {FPGA_DDIMMA_LANE_P[3]}] ; # MGTYTXP3_126 FMCP_HSPC_DP11_C2M_P Y26
#set_property PACKAGE_PIN AR45 [get_ports {FPGA_DDIMMA_LANE_N[3]}]
#set_property PACKAGE_PIN AR53 [get_ports {DDIMMA_FPGA_LANE_P[2]}] ; # MGTYRXP2_126 FMCP_HSPC_DP10_M2C_P Y10
#set_property PACKAGE_PIN AR54 [get_ports {DDIMMA_FPGA_LANE_N[2]}]
#set_property PACKAGE_PIN AR48 [get_ports {FPGA_DDIMMA_LANE_P[2]}] ; # MGTYTXP2_126 FMCP_HSPC_DP10_C2M_P Z24
#set_property PACKAGE_PIN AR49 [get_ports {FPGA_DDIMMA_LANE_N[2]}]
#set_property PACKAGE_PIN AT51 [get_ports {DDIMMA_FPGA_LANE_P[1]}] ; # MGTYRXP1_126 FMCP_HSPC_DP9_M2C_P B4
#set_property PACKAGE_PIN AT52 [get_ports {DDIMMA_FPGA_LANE_N[1]}]
#set_property PACKAGE_PIN AT46 [get_ports {FPGA_DDIMMA_LANE_P[1]}] ; # MGTYTXP1_126 FMCP_HSPC_DP9_C2M_P B24
#set_property PACKAGE_PIN AT47 [get_ports {FPGA_DDIMMA_LANE_N[1]}]
#set_property PACKAGE_PIN AU53 [get_ports {DDIMMA_FPGA_LANE_P[0]}] ; # MGTYRXP0_126 FMCP_HSPC_DP8_M2C_P B8
#set_property PACKAGE_PIN AU54 [get_ports {DDIMMA_FPGA_LANE_N[0]}]
#set_property PACKAGE_PIN AU48 [get_ports {FPGA_DDIMMA_LANE_P[0]}] ; # MGTYTXP0_126 FMCP_HSPC_DP8_C2M_P B28
#set_property PACKAGE_PIN AU49 [get_ports {FPGA_DDIMMA_LANE_N[0]}]
#set_property PACKAGE_PIN AL41 [get_ports {DDIMMA_FPGA_REFCLK_N[1]}] ; # MGTREFCLK0N_127 FMCP_HSPC_GBTCLK3_M2C_N1 L9 - QUAD_127_REFCLK_P
#set_property PACKAGE_PIN AL40 [get_ports {DDIMMA_FPGA_REFCLK_P[1]}]
#set_property PACKAGE_PIN AN41 [get_ports {DDIMMA_FPGA_REFCLK_N[0]}] ; # MGTREFCLK0N_126 FMCP_HSPC_GBTCLK2_M2C_N1 L13 - QUAD_126_REFCLK_P
#set_property PACKAGE_PIN AN40 [get_ports {DDIMMA_FPGA_REFCLK_P[0]}]

# DDIMM B:  Should be the following with OMI DDIMM to be in the right order for VCU128
#set_property PACKAGE_PIN AV51 [get_ports {DDIMMB_FPGA_LANE_P[7]}] ; # MGTYRXP3_125 FMCP_HSPC_DP7_M2C_P B12 - DDIMM1_RX7_P
#set_property PACKAGE_PIN AV52 [get_ports {DDIMMB_FPGA_LANE_N[7]}]
#set_property PACKAGE_PIN AU44 [get_ports {FPGA_DDIMMB_LANE_P[7]}] ; # MGTYTXP3_125 FMCP_HSPC_DP7_C2M_P B32
#set_property PACKAGE_PIN AU45 [get_ports {FPGA_DDIMMB_LANE_N[7]}]
#set_property PACKAGE_PIN AW49 [get_ports {DDIMMB_FPGA_LANE_P[6]}] ; # MGTYRXP2_125 FMCP_HSPC_DP6_M2C_P B16
#set_property PACKAGE_PIN AW50 [get_ports {DDIMMB_FPGA_LANE_N[6]}]
#set_property PACKAGE_PIN AV46 [get_ports {FPGA_DDIMMB_LANE_P[6]}] ; # MGTYTXP2_125 FMCP_HSPC_DP6_C2M_P B36
#set_property PACKAGE_PIN AV47 [get_ports {FPGA_DDIMMB_LANE_N[6]}]
#set_property PACKAGE_PIN AW53 [get_ports {DDIMMB_FPGA_LANE_P[5]}] ; # MGTYRXP1_125 FMCP_HSPC_DP5_M2C_P A18
#set_property PACKAGE_PIN AW54 [get_ports {DDIMMB_FPGA_LANE_N[5]}]
#set_property PACKAGE_PIN AW44 [get_ports {FPGA_DDIMMB_LANE_P[5]}] ; # MGTYTXP1_125 FMCP_HSPC_DP5_C2M_P A38
#set_property PACKAGE_PIN AW45 [get_ports {FPGA_DDIMMB_LANE_N[5]}]
#set_property PACKAGE_PIN AY51 [get_ports {DDIMMB_FPGA_LANE_P[4]}] ; # MGTYRXP0_125 FMCP_HSPC_DP4_M2C_P A14
#set_property PACKAGE_PIN AY52 [get_ports {DDIMMB_FPGA_LANE_N[4]}]
#set_property PACKAGE_PIN AY46 [get_ports {FPGA_DDIMMB_LANE_P[4]}] ; # MGTYTXP0_125 FMCP_HSPC_DP4_C2M_P A34
#set_property PACKAGE_PIN AY47 [get_ports {FPGA_DDIMMB_LANE_N[4]}]
#set_property PACKAGE_PIN BA49 [get_ports {DDIMMB_FPGA_LANE_P[3]}] ; # MGTYRXP3_124 FMCP_HSPC_DP3_M2C_P A10 - DDIMM1_RX3_P
#set_property PACKAGE_PIN BA50 [get_ports {DDIMMB_FPGA_LANE_N[3]}]
#set_property PACKAGE_PIN BA44 [get_ports {FPGA_DDIMMB_LANE_P[3]}] ; # MGTYTXP3_124 FMCP_HSPC_DP3_C2M_P A30
#set_property PACKAGE_PIN BA45 [get_ports {FPGA_DDIMMB_LANE_N[3]}]
#set_property PACKAGE_PIN BA53 [get_ports {DDIMMB_FPGA_LANE_P[2]}] ; # MGTYRXP2_124 FMCP_HSPC_DP2_M2C_P A6
#set_property PACKAGE_PIN BA54 [get_ports {DDIMMB_FPGA_LANE_N[2]}]
#set_property PACKAGE_PIN BB46 [get_ports {FPGA_DDIMMB_LANE_P[2]}] ; # MGTYTXP2_124 FMCP_HSPC_DP2_C2M_P A26
#set_property PACKAGE_PIN BB47 [get_ports {FPGA_DDIMMB_LANE_N[2]}]
#set_property PACKAGE_PIN BB51 [get_ports {DDIMMB_FPGA_LANE_P[1]}] ; # MGTYRXP1_124 FMCP_HSPC_DP1_M2C_P A2
#set_property PACKAGE_PIN BB52 [get_ports {DDIMMB_FPGA_LANE_N[1]}]
#set_property PACKAGE_PIN BC44 [get_ports {FPGA_DDIMMB_LANE_P[1]}] ; # MGTYTXP1_124 FMCP_HSPC_DP1_C2M_P A22
#set_property PACKAGE_PIN BC45 [get_ports {FPGA_DDIMMB_LANE_N[1]}]
#set_property PACKAGE_PIN BC53 [get_ports {DDIMMB_FPGA_LANE_P[0]}] ; # MGTYRXP0_124 FMCP_HSPC_DP0_M2C_P C6
#set_property PACKAGE_PIN BC54 [get_ports {DDIMMB_FPGA_LANE_N[0]}]
#set_property PACKAGE_PIN BC48 [get_ports {FPGA_DDIMMB_LANE_P[0]}] ; # MGTYTXP0_124 FMCP_HSPC_DP0_C2M_P
#set_property PACKAGE_PIN BC49 [get_ports {FPGA_DDIMMB_LANE_N[0]}]
#set_property PACKAGE_PIN AR41 [get_ports {DDIMMB_FPGA_REFCLK_N[1]}] ; # MGTREFCLK0N_125 FMCP_HSPC_GBTCLK1_M2C_N B21 - QUAD_125_REFCLK_P
#set_property PACKAGE_PIN AR40 [get_ports {DDIMMB_FPGA_REFCLK_P[1]}]
#set_property PACKAGE_PIN AV43 [get_ports {DDIMMB_FPGA_REFCLK_N[0]}] ; # MGTREFCLK0N_124 FMCP_HSPC_GBTCLK0_M2C_N D5 - QUAD_124_REFCLK_P
#set_property PACKAGE_PIN AV42 [get_ports {DDIMMB_FPGA_REFCLK_P[0]}]


## DDIMM C for VCU128 - Bank 226-227
#set_property package_pin AL2 [get_ports DDIMMC_FPGA_LANE_P[7]] ; # Bank 227
#set_property package_pin AL1 [get_ports DDIMMC_FPGA_LANE_N[7]] ; #
#set_property package_pin AL11 [get_ports FPGA_DDIMMC_LANE_P[7]] ; #
#set_property package_pin AL10 [get_ports FPGA_DDIMMC_LANE_N[7]] ; #
#set_property package_pin AM4 [get_ports DDIMMC_FPGA_LANE_P[6]] ; #
#set_property package_pin AM3 [get_ports DDIMMC_FPGA_LANE_N[6]] ; #
#set_property package_pin AM9 [get_ports FPGA_DDIMMC_LANE_P[6]] ; #
#set_property package_pin AM8 [get_ports FPGA_DDIMMC_LANE_N[6]] ; #
#set_property package_pin AN6 [get_ports DDIMMC_FPGA_LANE_P[5]] ; #
#set_property package_pin AN5 [get_ports DDIMMC_FPGA_LANE_N[5]] ; #
#set_property package_pin AN11 [get_ports FPGA_DDIMMC_LANE_P[5]] ; #
#set_property package_pin AN10 [get_ports FPGA_DDIMMC_LANE_N[5]] ; #
#set_property package_pin AN2 [get_ports DDIMMC_FPGA_LANE_P[4]] ; #
#set_property package_pin AN1 [get_ports DDIMMC_FPGA_LANE_N[4]] ; #
#set_property package_pin AP9 [get_ports FPGA_DDIMMC_LANE_P[4]] ; #
#set_property package_pin AP8 [get_ports FPGA_DDIMMC_LANE_N[4]] ; #
#set_property package_pin AP4 [get_ports DDIMMC_FPGA_LANE_P[3]] ; #Bank 226
#set_property package_pin AP3 [get_ports DDIMMC_FPGA_LANE_N[3]] ; #
#set_property package_pin AR11 [get_ports FPGA_DDIMMC_LANE_P[3]] ; #
#set_property package_pin AR10 [get_ports FPGA_DDIMMC_LANE_N[3]] ; #
#set_property package_pin AR2 [get_ports DDIMMC_FPGA_LANE_P[2]] ; #
#set_property package_pin AR1 [get_ports DDIMMC_FPGA_LANE_N[2]] ; #
#set_property package_pin AR7 [get_ports FPGA_DDIMMC_LANE_P[2]] ; #
#set_property package_pin AR6 [get_ports FPGA_DDIMMC_LANE_N[2]] ; #
#set_property package_pin AT4 [get_ports DDIMMC_FPGA_LANE_P[1]] ; #
#set_property package_pin AT3 [get_ports DDIMMC_FPGA_LANE_N[1]] ; #
#set_property package_pin AT9 [get_ports FPGA_DDIMMC_LANE_P[1]] ; #
#set_property package_pin AT8 [get_ports FPGA_DDIMMC_LANE_N[1]] ; #
#set_property package_pin AU2  [get_ports DDIMMC_FPGA_LANE_P[0]] ; #
#set_property package_pin AU1  [get_ports DDIMMC_FPGA_LANE_N[0]] ; #
#set_property package_pin AU11 [get_ports FPGA_DDIMMC_LANE_P[0]] ; #
#set_property package_pin AU10 [get_ports FPGA_DDIMMC_LANE_N[0]] ; #
#set_property package_pin AL15 [get_ports DDIMMC_FPGA_REFCLK_P[1]] ; # Bank 227
#set_property package_pin AL14 [get_ports DDIMMC_FPGA_REFCLK_N[1]] ; # Bank 227
#set_property package_pin AN15 [get_ports DDIMMC_FPGA_REFCLK_P[0]] ; # Bank 226
#set_property package_pin AN14 [get_ports DDIMMC_FPGA_REFCLK_N[0]] ; # Bank226

## DDIMM D VCU128 - Bank 224-225
#set_property package_pin AV4 [get_ports DDIMMD_FPGA_LANE_P[7]] ;  # Bank 225
#set_property package_pin AV3 [get_ports DDIMMD_FPGA_LANE_N[7]] ;
#set_property package_pin AU7 [get_ports FPGA_DDIMMD_LANE_P[7]] ;
#set_property package_pin AU6 [get_ports FPGA_DDIMMD_LANE_N[7]] ;
#set_property package_pin AW6 [get_ports DDIMMD_FPGA_LANE_P[6]] ;
#set_property package_pin AW5 [get_ports DDIMMD_FPGA_LANE_N[6]] ;
#set_property package_pin AV9 [get_ports FPGA_DDIMMD_LANE_P[6]] ;
#set_property package_pin AV8 [get_ports FPGA_DDIMMD_LANE_N[6]] ;
#set_property package_pin AW2 [get_ports DDIMMD_FPGA_LANE_P[5]] ;
#set_property package_pin AW1 [get_ports DDIMMD_FPGA_LANE_N[5]] ;
#set_property package_pin AW11 [get_ports FPGA_DDIMMD_LANE_P[5]] ;
#set_property package_pin AW10 [get_ports FPGA_DDIMMD_LANE_N[5]] ;
#set_property package_pin AY4 [get_ports DDIMMD_FPGA_LANE_P[4]] ;
#set_property package_pin AY3 [get_ports DDIMMD_FPGA_LANE_N[4]] ;
#set_property package_pin AY9 [get_ports FPGA_DDIMMD_LANE_P[4]] ;
#set_property package_pin AY8 [get_ports FPGA_DDIMMD_LANE_N[4]] ;
#set_property package_pin BA6 [get_ports DDIMMD_FPGA_LANE_P[3]] ;  # Bank 224
#set_property package_pin BA5 [get_ports DDIMMD_FPGA_LANE_N[3]] ;
#set_property package_pin BA11 [get_ports FPGA_DDIMMD_LANE_P[3]] ;
#set_property package_pin BA10 [get_ports FPGA_DDIMMD_LANE_N[3]] ;
#set_property package_pin BA2 [get_ports DDIMMD_FPGA_LANE_P[2]] ;
#set_property package_pin BA1 [get_ports DDIMMD_FPGA_LANE_N[2]] ;
#set_property package_pin BB9 [get_ports FPGA_DDIMMD_LANE_P[2]] ;
#set_property package_pin BB8 [get_ports FPGA_DDIMMD_LANE_N[2]] ;
#set_property package_pin BB4 [get_ports DDIMMD_FPGA_LANE_P[1]] ;
#set_property package_pin BB3 [get_ports DDIMMD_FPGA_LANE_N[1]] ;
#set_property package_pin BC11 [get_ports FPGA_DDIMMD_LANE_P[1]] ;
#set_property package_pin BC10 [get_ports FPGA_DDIMMD_LANE_N[1]] ;
#set_property package_pin BC2 [get_ports DDIMMD_FPGA_LANE_P[0]] ;
#set_property package_pin BC1 [get_ports DDIMMD_FPGA_LANE_N[0]] ;
#set_property package_pin BC7 [get_ports FPGA_DDIMMD_LANE_P[0]] ;
#set_property package_pin BC6 [get_ports FPGA_DDIMMD_LANE_N[0]] ;
#set_property package_pin AR15 [get_ports DDIMMD_FPGA_REFCLK_P[1]] ; # Bank 225
#set_property package_pin AR14 [get_ports DDIMMD_FPGA_REFCLK_N[1]] ; # Bank 225
#set_property package_pin AV13 [get_ports DDIMMD_FPGA_REFCLK_P[0]] ; # Bank 224
#set_property package_pin AV12 [get_ports DDIMMD_FPGA_REFCLK_N[0]] ; # Bank 224

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
#set_property DIFF_TERM_ADV=TERM_100 [get_ports RAW_SYSCLK_P]
set_property EQUALIZATION EQ_NONE [get_ports RAW_SYSCLK_P]
set_property DIFF_TERM_ADV TERM_100 [get_ports RAW_SYSCLK_P]
set_property LVDS_PRE_EMPHASIS FALSE [get_ports RAW_SYSCLK_P]
set_property IOSTANDARD LVDS [get_ports RAW_SYSCLK_N]
#set_property DIFF_TERM_ADV=TERM_100 [get_ports RAW_SYSCLK_N]
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
#set_property DIFF_TERM_ADV=TERM_100 [get_ports RAW_RCLK_N]
set_property EQUALIZATION EQ_NONE [get_ports RAW_RCLK_N]
set_property DIFF_TERM_ADV TERM_100 [get_ports RAW_RCLK_N]
set_property LVDS_PRE_EMPHASIS FALSE [get_ports RAW_RCLK_N]
set_property IOSTANDARD LVDS [get_ports RAW_RCLK_P]
#set_property EQUALIZATION EQ_NONE [get_ports RAW_RCLK_P]
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
#set_property BITSTREAM.CONFIG.CONFIGRATE 10.6 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
#set_property BITSTREAM.CONFIG.SPI_FALL_EDGE YES [current_design]
#set_property BITSTREAM.CONFIG.D02 PULLNONE [current_design]
#set_property BITSTREAM.CONFIG.D03 PULLNONE [current_design]
#set_property BITSTREAM.CONFIG.DONEPIN PULLNONE [current_design]
#set_property BITSTREAM.CONFIG.INITPIN PULLNONE [current_design]
#set_property BITSTREAM.CONFIG.M0PIN PULLNONE [current_design]
#set_property BITSTREAM.CONFIG.M1PIN PULLNONE [current_design]
#set_property BITSTREAM.CONFIG.M2PIN PULLNONE [current_design]
#set_property BITSTREAM.CONFIG.PROGPIN PULLNONE [current_design]
#set_property BITSTREAM.CONFIG.PUDC_B PULLNONE [current_design]
#set_property BITSTREAM.CONFIG.RDWR_B_FCS_B PULLNONE [current_design]
