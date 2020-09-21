#
#Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
#
set_param power.enableLutRouteBelPower 1
set_param power.enableCarry8RouteBelPower 1
set_param power.enableUnconnectedCarry8PinPower 1
set_param logicopt.enablePowerLopt9Series 0
set_param logicopt.enablePowerLopt8Series 0
set_param power.BramSDPPropagationFix 1
set_param synth.enableIncremental 0
set_param chipscope.flow 0
set part xcvu7p-flvc2104-2-e
set board_part_repo_paths {}
set board_part {}
set board_connections {}
set tool_flow Vivado
set ip_vlnv xilinx.com:ip:ila:6.2
set ip_module_name u_ila_clk_out1_clk_wiz_sysclk
set params {{{PARAM_VALUE.ALL_PROBE_SAME_MU} {true} {PARAM_VALUE.ALL_PROBE_SAME_MU_CNT} {1} {PARAM_VALUE.C_ADV_TRIGGER} {false} {PARAM_VALUE.C_DATA_DEPTH} {2048} {PARAM_VALUE.C_EN_STRG_QUAL} {false} {PARAM_VALUE.C_INPUT_PIPE_STAGES} {2} {PARAM_VALUE.C_NUM_OF_PROBES} {15} {PARAM_VALUE.C_PROBE0_TYPE} {0} {PARAM_VALUE.C_PROBE0_WIDTH} {4} {PARAM_VALUE.C_PROBE10_TYPE} {0} {PARAM_VALUE.C_PROBE10_WIDTH} {64} {PARAM_VALUE.C_PROBE11_TYPE} {0} {PARAM_VALUE.C_PROBE11_WIDTH} {4} {PARAM_VALUE.C_PROBE12_TYPE} {0} {PARAM_VALUE.C_PROBE12_WIDTH} {4} {PARAM_VALUE.C_PROBE13_TYPE} {0} {PARAM_VALUE.C_PROBE13_WIDTH} {1} {PARAM_VALUE.C_PROBE14_TYPE} {0} {PARAM_VALUE.C_PROBE14_WIDTH} {1} {PARAM_VALUE.C_PROBE1_TYPE} {0} {PARAM_VALUE.C_PROBE1_WIDTH} {1} {PARAM_VALUE.C_PROBE2_TYPE} {0} {PARAM_VALUE.C_PROBE2_WIDTH} {1} {PARAM_VALUE.C_PROBE3_TYPE} {0} {PARAM_VALUE.C_PROBE3_WIDTH} {64} {PARAM_VALUE.C_PROBE4_TYPE} {0} {PARAM_VALUE.C_PROBE4_WIDTH} {64} {PARAM_VALUE.C_PROBE5_TYPE} {0} {PARAM_VALUE.C_PROBE5_WIDTH} {3} {PARAM_VALUE.C_PROBE6_TYPE} {0} {PARAM_VALUE.C_PROBE6_WIDTH} {64} {PARAM_VALUE.C_PROBE7_TYPE} {0} {PARAM_VALUE.C_PROBE7_WIDTH} {3} {PARAM_VALUE.C_PROBE8_TYPE} {0} {PARAM_VALUE.C_PROBE8_WIDTH} {5} {PARAM_VALUE.C_PROBE9_TYPE} {0} {PARAM_VALUE.C_PROBE9_WIDTH} {64} {PARAM_VALUE.C_TRIGIN_EN} {0} {PARAM_VALUE.C_TRIGOUT_EN} {0}}}
set output_xci /afs/rchland.ibm.com/rel/common/proj/surelock/usr/allison/fire_build_git/omi_host_fire/build/.Xil/Vivado-29006-rchgl6186.rchland.ibm.com/u_ila_clk_out1_clk_wiz_sysclk_CV.0/out/result.xci
set output_dcp /afs/rchland.ibm.com/rel/common/proj/surelock/usr/allison/fire_build_git/omi_host_fire/build/.Xil/Vivado-29006-rchgl6186.rchland.ibm.com/u_ila_clk_out1_clk_wiz_sysclk_CV.0/out/result.dcp
set output_dir /afs/rchland.ibm.com/rel/common/proj/surelock/usr/allison/fire_build_git/omi_host_fire/build/.Xil/Vivado-29006-rchgl6186.rchland.ibm.com/u_ila_clk_out1_clk_wiz_sysclk_CV.0/out
set ip_repo_paths {}
set ip_output_repo ./.cache/ip
set ip_cache_permissions {read write}

set oopbus_ip_repo_paths [get_param chipscope.oopbus_ip_repo_paths]

set synth_opts {}
set xdc_files {}
