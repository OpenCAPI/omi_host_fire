set_property SRC_FILE_INFO {cfile:/afs/rchland.ibm.com/rel/common/proj/surelock/usr/allison/fire_build_git/omi_host_fire/ip_2133/clk_wiz_sysclk/clk_wiz_sysclk.xdc rfile:../../ip_2133/clk_wiz_sysclk/clk_wiz_sysclk.xdc id:1 order:EARLY scoped_inst:inst} [current_design]
current_instance inst
set_property src_info {type:SCOPED_XDC file:1 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports clk_in1_p]] 0.025
