
create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 4 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER true [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 4096 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 1 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list fml_axis_aclk]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 3 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {fire_core_0/dl/dlx/xlx_if/xtsm_q[0]} {fire_core_0/dl/dlx/xlx_if/xtsm_q[1]} {fire_core_0/dl/dlx/xlx_if/xtsm_q[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 3 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {fire_core_0/dl/dlx/tx/ctl/tsm_q[0]} {fire_core_0/dl/dlx/tx/ctl/tsm_q[1]} {fire_core_0/dl/dlx/tx/ctl/tsm_q[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 3 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {fire_core_1/dl/dlx/tx/ctl/tsm_q[0]} {fire_core_1/dl/dlx/tx/ctl/tsm_q[1]} {fire_core_1/dl/dlx/tx/ctl/tsm_q[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 3 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {fire_core_1/dl/dlx/xlx_if/xtsm_q[0]} {fire_core_1/dl/dlx/xlx_if/xtsm_q[1]} {fire_core_1/dl/dlx/xlx_if/xtsm_q[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 64 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {fire_pervasive/i2c_control/address_from_i2c[0]} {fire_pervasive/i2c_control/address_from_i2c[1]} {fire_pervasive/i2c_control/address_from_i2c[2]} {fire_pervasive/i2c_control/address_from_i2c[3]} {fire_pervasive/i2c_control/address_from_i2c[4]} {fire_pervasive/i2c_control/address_from_i2c[5]} {fire_pervasive/i2c_control/address_from_i2c[6]} {fire_pervasive/i2c_control/address_from_i2c[7]} {fire_pervasive/i2c_control/address_from_i2c[8]} {fire_pervasive/i2c_control/address_from_i2c[9]} {fire_pervasive/i2c_control/address_from_i2c[10]} {fire_pervasive/i2c_control/address_from_i2c[11]} {fire_pervasive/i2c_control/address_from_i2c[12]} {fire_pervasive/i2c_control/address_from_i2c[13]} {fire_pervasive/i2c_control/address_from_i2c[14]} {fire_pervasive/i2c_control/address_from_i2c[15]} {fire_pervasive/i2c_control/address_from_i2c[16]} {fire_pervasive/i2c_control/address_from_i2c[17]} {fire_pervasive/i2c_control/address_from_i2c[18]} {fire_pervasive/i2c_control/address_from_i2c[19]} {fire_pervasive/i2c_control/address_from_i2c[20]} {fire_pervasive/i2c_control/address_from_i2c[21]} {fire_pervasive/i2c_control/address_from_i2c[22]} {fire_pervasive/i2c_control/address_from_i2c[23]} {fire_pervasive/i2c_control/address_from_i2c[24]} {fire_pervasive/i2c_control/address_from_i2c[25]} {fire_pervasive/i2c_control/address_from_i2c[26]} {fire_pervasive/i2c_control/address_from_i2c[27]} {fire_pervasive/i2c_control/address_from_i2c[28]} {fire_pervasive/i2c_control/address_from_i2c[29]} {fire_pervasive/i2c_control/address_from_i2c[30]} {fire_pervasive/i2c_control/address_from_i2c[31]} {fire_pervasive/i2c_control/address_from_i2c[32]} {fire_pervasive/i2c_control/address_from_i2c[33]} {fire_pervasive/i2c_control/address_from_i2c[34]} {fire_pervasive/i2c_control/address_from_i2c[35]} {fire_pervasive/i2c_control/address_from_i2c[36]} {fire_pervasive/i2c_control/address_from_i2c[37]} {fire_pervasive/i2c_control/address_from_i2c[38]} {fire_pervasive/i2c_control/address_from_i2c[39]} {fire_pervasive/i2c_control/address_from_i2c[40]} {fire_pervasive/i2c_control/address_from_i2c[41]} {fire_pervasive/i2c_control/address_from_i2c[42]} {fire_pervasive/i2c_control/address_from_i2c[43]} {fire_pervasive/i2c_control/address_from_i2c[44]} {fire_pervasive/i2c_control/address_from_i2c[45]} {fire_pervasive/i2c_control/address_from_i2c[46]} {fire_pervasive/i2c_control/address_from_i2c[47]} {fire_pervasive/i2c_control/address_from_i2c[48]} {fire_pervasive/i2c_control/address_from_i2c[49]} {fire_pervasive/i2c_control/address_from_i2c[50]} {fire_pervasive/i2c_control/address_from_i2c[51]} {fire_pervasive/i2c_control/address_from_i2c[52]} {fire_pervasive/i2c_control/address_from_i2c[53]} {fire_pervasive/i2c_control/address_from_i2c[54]} {fire_pervasive/i2c_control/address_from_i2c[55]} {fire_pervasive/i2c_control/address_from_i2c[56]} {fire_pervasive/i2c_control/address_from_i2c[57]} {fire_pervasive/i2c_control/address_from_i2c[58]} {fire_pervasive/i2c_control/address_from_i2c[59]} {fire_pervasive/i2c_control/address_from_i2c[60]} {fire_pervasive/i2c_control/address_from_i2c[61]} {fire_pervasive/i2c_control/address_from_i2c[62]} {fire_pervasive/i2c_control/address_from_i2c[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 3 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {fire_pervasive/i2c_control/axi_read_state[0]} {fire_pervasive/i2c_control/axi_read_state[1]} {fire_pervasive/i2c_control/axi_read_state[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 3 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {fire_pervasive/i2c_control/axi_write_state[0]} {fire_pervasive/i2c_control/axi_write_state[1]} {fire_pervasive/i2c_control/axi_write_state[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 5 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {fire_pervasive/i2c_control/control_state[0]} {fire_pervasive/i2c_control/control_state[1]} {fire_pervasive/i2c_control/control_state[2]} {fire_pervasive/i2c_control/control_state[3]} {fire_pervasive/i2c_control/control_state[4]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 64 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {fire_pervasive/i2c_control/data_from_i2c[0]} {fire_pervasive/i2c_control/data_from_i2c[1]} {fire_pervasive/i2c_control/data_from_i2c[2]} {fire_pervasive/i2c_control/data_from_i2c[3]} {fire_pervasive/i2c_control/data_from_i2c[4]} {fire_pervasive/i2c_control/data_from_i2c[5]} {fire_pervasive/i2c_control/data_from_i2c[6]} {fire_pervasive/i2c_control/data_from_i2c[7]} {fire_pervasive/i2c_control/data_from_i2c[8]} {fire_pervasive/i2c_control/data_from_i2c[9]} {fire_pervasive/i2c_control/data_from_i2c[10]} {fire_pervasive/i2c_control/data_from_i2c[11]} {fire_pervasive/i2c_control/data_from_i2c[12]} {fire_pervasive/i2c_control/data_from_i2c[13]} {fire_pervasive/i2c_control/data_from_i2c[14]} {fire_pervasive/i2c_control/data_from_i2c[15]} {fire_pervasive/i2c_control/data_from_i2c[16]} {fire_pervasive/i2c_control/data_from_i2c[17]} {fire_pervasive/i2c_control/data_from_i2c[18]} {fire_pervasive/i2c_control/data_from_i2c[19]} {fire_pervasive/i2c_control/data_from_i2c[20]} {fire_pervasive/i2c_control/data_from_i2c[21]} {fire_pervasive/i2c_control/data_from_i2c[22]} {fire_pervasive/i2c_control/data_from_i2c[23]} {fire_pervasive/i2c_control/data_from_i2c[24]} {fire_pervasive/i2c_control/data_from_i2c[25]} {fire_pervasive/i2c_control/data_from_i2c[26]} {fire_pervasive/i2c_control/data_from_i2c[27]} {fire_pervasive/i2c_control/data_from_i2c[28]} {fire_pervasive/i2c_control/data_from_i2c[29]} {fire_pervasive/i2c_control/data_from_i2c[30]} {fire_pervasive/i2c_control/data_from_i2c[31]} {fire_pervasive/i2c_control/data_from_i2c[32]} {fire_pervasive/i2c_control/data_from_i2c[33]} {fire_pervasive/i2c_control/data_from_i2c[34]} {fire_pervasive/i2c_control/data_from_i2c[35]} {fire_pervasive/i2c_control/data_from_i2c[36]} {fire_pervasive/i2c_control/data_from_i2c[37]} {fire_pervasive/i2c_control/data_from_i2c[38]} {fire_pervasive/i2c_control/data_from_i2c[39]} {fire_pervasive/i2c_control/data_from_i2c[40]} {fire_pervasive/i2c_control/data_from_i2c[41]} {fire_pervasive/i2c_control/data_from_i2c[42]} {fire_pervasive/i2c_control/data_from_i2c[43]} {fire_pervasive/i2c_control/data_from_i2c[44]} {fire_pervasive/i2c_control/data_from_i2c[45]} {fire_pervasive/i2c_control/data_from_i2c[46]} {fire_pervasive/i2c_control/data_from_i2c[47]} {fire_pervasive/i2c_control/data_from_i2c[48]} {fire_pervasive/i2c_control/data_from_i2c[49]} {fire_pervasive/i2c_control/data_from_i2c[50]} {fire_pervasive/i2c_control/data_from_i2c[51]} {fire_pervasive/i2c_control/data_from_i2c[52]} {fire_pervasive/i2c_control/data_from_i2c[53]} {fire_pervasive/i2c_control/data_from_i2c[54]} {fire_pervasive/i2c_control/data_from_i2c[55]} {fire_pervasive/i2c_control/data_from_i2c[56]} {fire_pervasive/i2c_control/data_from_i2c[57]} {fire_pervasive/i2c_control/data_from_i2c[58]} {fire_pervasive/i2c_control/data_from_i2c[59]} {fire_pervasive/i2c_control/data_from_i2c[60]} {fire_pervasive/i2c_control/data_from_i2c[61]} {fire_pervasive/i2c_control/data_from_i2c[62]} {fire_pervasive/i2c_control/data_from_i2c[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 64 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {fire_pervasive/i2c_control/data_to_i2c[0]} {fire_pervasive/i2c_control/data_to_i2c[1]} {fire_pervasive/i2c_control/data_to_i2c[2]} {fire_pervasive/i2c_control/data_to_i2c[3]} {fire_pervasive/i2c_control/data_to_i2c[4]} {fire_pervasive/i2c_control/data_to_i2c[5]} {fire_pervasive/i2c_control/data_to_i2c[6]} {fire_pervasive/i2c_control/data_to_i2c[7]} {fire_pervasive/i2c_control/data_to_i2c[8]} {fire_pervasive/i2c_control/data_to_i2c[9]} {fire_pervasive/i2c_control/data_to_i2c[10]} {fire_pervasive/i2c_control/data_to_i2c[11]} {fire_pervasive/i2c_control/data_to_i2c[12]} {fire_pervasive/i2c_control/data_to_i2c[13]} {fire_pervasive/i2c_control/data_to_i2c[14]} {fire_pervasive/i2c_control/data_to_i2c[15]} {fire_pervasive/i2c_control/data_to_i2c[16]} {fire_pervasive/i2c_control/data_to_i2c[17]} {fire_pervasive/i2c_control/data_to_i2c[18]} {fire_pervasive/i2c_control/data_to_i2c[19]} {fire_pervasive/i2c_control/data_to_i2c[20]} {fire_pervasive/i2c_control/data_to_i2c[21]} {fire_pervasive/i2c_control/data_to_i2c[22]} {fire_pervasive/i2c_control/data_to_i2c[23]} {fire_pervasive/i2c_control/data_to_i2c[24]} {fire_pervasive/i2c_control/data_to_i2c[25]} {fire_pervasive/i2c_control/data_to_i2c[26]} {fire_pervasive/i2c_control/data_to_i2c[27]} {fire_pervasive/i2c_control/data_to_i2c[28]} {fire_pervasive/i2c_control/data_to_i2c[29]} {fire_pervasive/i2c_control/data_to_i2c[30]} {fire_pervasive/i2c_control/data_to_i2c[31]} {fire_pervasive/i2c_control/data_to_i2c[32]} {fire_pervasive/i2c_control/data_to_i2c[33]} {fire_pervasive/i2c_control/data_to_i2c[34]} {fire_pervasive/i2c_control/data_to_i2c[35]} {fire_pervasive/i2c_control/data_to_i2c[36]} {fire_pervasive/i2c_control/data_to_i2c[37]} {fire_pervasive/i2c_control/data_to_i2c[38]} {fire_pervasive/i2c_control/data_to_i2c[39]} {fire_pervasive/i2c_control/data_to_i2c[40]} {fire_pervasive/i2c_control/data_to_i2c[41]} {fire_pervasive/i2c_control/data_to_i2c[42]} {fire_pervasive/i2c_control/data_to_i2c[43]} {fire_pervasive/i2c_control/data_to_i2c[44]} {fire_pervasive/i2c_control/data_to_i2c[45]} {fire_pervasive/i2c_control/data_to_i2c[46]} {fire_pervasive/i2c_control/data_to_i2c[47]} {fire_pervasive/i2c_control/data_to_i2c[48]} {fire_pervasive/i2c_control/data_to_i2c[49]} {fire_pervasive/i2c_control/data_to_i2c[50]} {fire_pervasive/i2c_control/data_to_i2c[51]} {fire_pervasive/i2c_control/data_to_i2c[52]} {fire_pervasive/i2c_control/data_to_i2c[53]} {fire_pervasive/i2c_control/data_to_i2c[54]} {fire_pervasive/i2c_control/data_to_i2c[55]} {fire_pervasive/i2c_control/data_to_i2c[56]} {fire_pervasive/i2c_control/data_to_i2c[57]} {fire_pervasive/i2c_control/data_to_i2c[58]} {fire_pervasive/i2c_control/data_to_i2c[59]} {fire_pervasive/i2c_control/data_to_i2c[60]} {fire_pervasive/i2c_control/data_to_i2c[61]} {fire_pervasive/i2c_control/data_to_i2c[62]} {fire_pervasive/i2c_control/data_to_i2c[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 4 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {fire_pervasive/i2c_control/i2c_write_state[0]} {fire_pervasive/i2c_control/i2c_write_state[1]} {fire_pervasive/i2c_control/i2c_write_state[2]} {fire_pervasive/i2c_control/i2c_write_state[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 4 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {fire_pervasive/i2c_control/i2c_read_state[0]} {fire_pervasive/i2c_control/i2c_read_state[1]} {fire_pervasive/i2c_control/i2c_read_state[2]} {fire_pervasive/i2c_control/i2c_read_state[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 1 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list fire_core_0/dl/dlx/tx/ctl/block_locked]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 1 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list fire_core_1/dl/dlx/tx/ctl/block_locked]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 1 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list fire_core_1/dl/dlx/tx/ctl/pat_a_done]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 1 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list fire_core_0/dl/dlx/tx/ctl/pat_a_done]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 1 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list fire_core_0/dl/dlx/tx/ctl/pat_b_done]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 1 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list fire_core_1/dl/dlx/tx/ctl/pat_b_done]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 1 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list fire_core_0/dl/dlx/xlx_if/rec_first_xtsm_din]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 1 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list fire_core_1/dl/dlx/xlx_if/rec_first_xtsm_din]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 1 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list fire_core_1/dl/dlx/tx/ctl/sync_done]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 1 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list fire_core_0/dl/dlx/tx/ctl/sync_done]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 1 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list fire_core_0/dl/dlx/tx/ctl/ts1_done]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 1 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list fire_core_1/dl/dlx/tx/ctl/ts1_done]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 1 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list fire_core_1/dl/dlx/tx/ctl/ts2_done]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe25]
set_property port_width 1 [get_debug_ports u_ila_0/probe25]
connect_debug_port u_ila_0/probe25 [get_nets [list fire_core_0/dl/dlx/tx/ctl/ts2_done]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe26]
set_property port_width 1 [get_debug_ports u_ila_0/probe26]
connect_debug_port u_ila_0/probe26 [get_nets [list fire_core_0/dl/dlx/tx/ctl/ts3_done]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe27]
set_property port_width 1 [get_debug_ports u_ila_0/probe27]
connect_debug_port u_ila_0/probe27 [get_nets [list fire_core_1/dl/dlx/tx/ctl/ts3_done]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe28]
set_property port_width 1 [get_debug_ports u_ila_0/probe28]
connect_debug_port u_ila_0/probe28 [get_nets [list fire_core_1/dl/dlx/tx/ctl/ts4_done]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe29]
set_property port_width 1 [get_debug_ports u_ila_0/probe29]
connect_debug_port u_ila_0/probe29 [get_nets [list fire_core_0/dl/dlx/tx/ctl/ts4_done]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets fml_axis_aclk]






