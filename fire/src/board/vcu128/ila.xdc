
create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 4 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER true [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 8192 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 1 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list {hss0/hss_phy/example_wrapper_inst/gtwiz_userclk_tx_inst/txusrclk_in[0]}]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 5 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {fire_core_0/c3s_dlx/c3s_cntl/c3s_arr_rd_addr[0]} {fire_core_0/c3s_dlx/c3s_cntl/c3s_arr_rd_addr[1]} {fire_core_0/c3s_dlx/c3s_cntl/c3s_arr_rd_addr[2]} {fire_core_0/c3s_dlx/c3s_cntl/c3s_arr_rd_addr[3]} {fire_core_0/c3s_dlx/c3s_cntl/c3s_arr_rd_addr[4]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 4 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {fire_core_0/c3s_dlx/c3s_cntl/c3s_fsm_q[0]} {fire_core_0/c3s_dlx/c3s_cntl/c3s_fsm_q[1]} {fire_core_0/c3s_dlx/c3s_cntl/c3s_fsm_q[2]} {fire_core_0/c3s_dlx/c3s_cntl/c3s_fsm_q[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 2 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {fire_core_0/dl/dlx/tx/gbx2/out_header_q[0]} {fire_core_0/dl/dlx/tx/gbx2/out_header_q[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 2 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {fire_core_0/dl/dlx/tx/gbx3/out_header_q[0]} {fire_core_0/dl/dlx/tx/gbx3/out_header_q[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 2 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {fire_core_0/dl/dlx/tx/gbx4/out_header_q[0]} {fire_core_0/dl/dlx/tx/gbx4/out_header_q[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 2 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {fire_core_0/dl/dlx/tx/gbx5/out_header_q[0]} {fire_core_0/dl/dlx/tx/gbx5/out_header_q[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 4 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {fire_core_0/c3s_dlx/c3s_cfg/c3s_cfg_regs/axi_rd_state_q[0]} {fire_core_0/c3s_dlx/c3s_cfg/c3s_cfg_regs/axi_rd_state_q[1]} {fire_core_0/c3s_dlx/c3s_cfg/c3s_cfg_regs/axi_rd_state_q[2]} {fire_core_0/c3s_dlx/c3s_cfg/c3s_cfg_regs/axi_rd_state_q[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 5 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {fire_core_0/c3s_dlx/c3s_cfg/c3s_cfg_regs/axi_wr_state_q[0]} {fire_core_0/c3s_dlx/c3s_cfg/c3s_cfg_regs/axi_wr_state_q[1]} {fire_core_0/c3s_dlx/c3s_cfg/c3s_cfg_regs/axi_wr_state_q[2]} {fire_core_0/c3s_dlx/c3s_cfg/c3s_cfg_regs/axi_wr_state_q[3]} {fire_core_0/c3s_dlx/c3s_cfg/c3s_cfg_regs/axi_wr_state_q[4]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 4 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {fire_core_0/fbist/cfg/fbist_cfg_regs/axi_rd_state_q[0]} {fire_core_0/fbist/cfg/fbist_cfg_regs/axi_rd_state_q[1]} {fire_core_0/fbist/cfg/fbist_cfg_regs/axi_rd_state_q[2]} {fire_core_0/fbist/cfg/fbist_cfg_regs/axi_rd_state_q[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 5 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {fire_core_0/fbist/cfg/fbist_cfg_regs/axi_wr_state_q[0]} {fire_core_0/fbist/cfg/fbist_cfg_regs/axi_wr_state_q[1]} {fire_core_0/fbist/cfg/fbist_cfg_regs/axi_wr_state_q[2]} {fire_core_0/fbist/cfg/fbist_cfg_regs/axi_wr_state_q[3]} {fire_core_0/fbist/cfg/fbist_cfg_regs/axi_wr_state_q[4]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 3 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {fire_core_0/fbist/chk/lut_engine_q[0]} {fire_core_0/fbist/chk/lut_engine_q[1]} {fire_core_0/fbist/chk/lut_engine_q[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 5 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {fire_core_0/oc_host_cfg0/host_cfg_regs/axi_wr_state_q[0]} {fire_core_0/oc_host_cfg0/host_cfg_regs/axi_wr_state_q[1]} {fire_core_0/oc_host_cfg0/host_cfg_regs/axi_wr_state_q[2]} {fire_core_0/oc_host_cfg0/host_cfg_regs/axi_wr_state_q[3]} {fire_core_0/oc_host_cfg0/host_cfg_regs/axi_wr_state_q[4]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 4 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {fire_core_0/oc_host_cfg0/host_cfg_regs/axi_rd_state_q[0]} {fire_core_0/oc_host_cfg0/host_cfg_regs/axi_rd_state_q[1]} {fire_core_0/oc_host_cfg0/host_cfg_regs/axi_rd_state_q[2]} {fire_core_0/oc_host_cfg0/host_cfg_regs/axi_rd_state_q[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 512 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {fire_core_0/stage_1/tlx_dlx_flit_q[0]} {fire_core_0/stage_1/tlx_dlx_flit_q[1]} {fire_core_0/stage_1/tlx_dlx_flit_q[2]} {fire_core_0/stage_1/tlx_dlx_flit_q[3]} {fire_core_0/stage_1/tlx_dlx_flit_q[4]} {fire_core_0/stage_1/tlx_dlx_flit_q[5]} {fire_core_0/stage_1/tlx_dlx_flit_q[6]} {fire_core_0/stage_1/tlx_dlx_flit_q[7]} {fire_core_0/stage_1/tlx_dlx_flit_q[8]} {fire_core_0/stage_1/tlx_dlx_flit_q[9]} {fire_core_0/stage_1/tlx_dlx_flit_q[10]} {fire_core_0/stage_1/tlx_dlx_flit_q[11]} {fire_core_0/stage_1/tlx_dlx_flit_q[12]} {fire_core_0/stage_1/tlx_dlx_flit_q[13]} {fire_core_0/stage_1/tlx_dlx_flit_q[14]} {fire_core_0/stage_1/tlx_dlx_flit_q[15]} {fire_core_0/stage_1/tlx_dlx_flit_q[16]} {fire_core_0/stage_1/tlx_dlx_flit_q[17]} {fire_core_0/stage_1/tlx_dlx_flit_q[18]} {fire_core_0/stage_1/tlx_dlx_flit_q[19]} {fire_core_0/stage_1/tlx_dlx_flit_q[20]} {fire_core_0/stage_1/tlx_dlx_flit_q[21]} {fire_core_0/stage_1/tlx_dlx_flit_q[22]} {fire_core_0/stage_1/tlx_dlx_flit_q[23]} {fire_core_0/stage_1/tlx_dlx_flit_q[24]} {fire_core_0/stage_1/tlx_dlx_flit_q[25]} {fire_core_0/stage_1/tlx_dlx_flit_q[26]} {fire_core_0/stage_1/tlx_dlx_flit_q[27]} {fire_core_0/stage_1/tlx_dlx_flit_q[28]} {fire_core_0/stage_1/tlx_dlx_flit_q[29]} {fire_core_0/stage_1/tlx_dlx_flit_q[30]} {fire_core_0/stage_1/tlx_dlx_flit_q[31]} {fire_core_0/stage_1/tlx_dlx_flit_q[32]} {fire_core_0/stage_1/tlx_dlx_flit_q[33]} {fire_core_0/stage_1/tlx_dlx_flit_q[34]} {fire_core_0/stage_1/tlx_dlx_flit_q[35]} {fire_core_0/stage_1/tlx_dlx_flit_q[36]} {fire_core_0/stage_1/tlx_dlx_flit_q[37]} {fire_core_0/stage_1/tlx_dlx_flit_q[38]} {fire_core_0/stage_1/tlx_dlx_flit_q[39]} {fire_core_0/stage_1/tlx_dlx_flit_q[40]} {fire_core_0/stage_1/tlx_dlx_flit_q[41]} {fire_core_0/stage_1/tlx_dlx_flit_q[42]} {fire_core_0/stage_1/tlx_dlx_flit_q[43]} {fire_core_0/stage_1/tlx_dlx_flit_q[44]} {fire_core_0/stage_1/tlx_dlx_flit_q[45]} {fire_core_0/stage_1/tlx_dlx_flit_q[46]} {fire_core_0/stage_1/tlx_dlx_flit_q[47]} {fire_core_0/stage_1/tlx_dlx_flit_q[48]} {fire_core_0/stage_1/tlx_dlx_flit_q[49]} {fire_core_0/stage_1/tlx_dlx_flit_q[50]} {fire_core_0/stage_1/tlx_dlx_flit_q[51]} {fire_core_0/stage_1/tlx_dlx_flit_q[52]} {fire_core_0/stage_1/tlx_dlx_flit_q[53]} {fire_core_0/stage_1/tlx_dlx_flit_q[54]} {fire_core_0/stage_1/tlx_dlx_flit_q[55]} {fire_core_0/stage_1/tlx_dlx_flit_q[56]} {fire_core_0/stage_1/tlx_dlx_flit_q[57]} {fire_core_0/stage_1/tlx_dlx_flit_q[58]} {fire_core_0/stage_1/tlx_dlx_flit_q[59]} {fire_core_0/stage_1/tlx_dlx_flit_q[60]} {fire_core_0/stage_1/tlx_dlx_flit_q[61]} {fire_core_0/stage_1/tlx_dlx_flit_q[62]} {fire_core_0/stage_1/tlx_dlx_flit_q[63]} {fire_core_0/stage_1/tlx_dlx_flit_q[64]} {fire_core_0/stage_1/tlx_dlx_flit_q[65]} {fire_core_0/stage_1/tlx_dlx_flit_q[66]} {fire_core_0/stage_1/tlx_dlx_flit_q[67]} {fire_core_0/stage_1/tlx_dlx_flit_q[68]} {fire_core_0/stage_1/tlx_dlx_flit_q[69]} {fire_core_0/stage_1/tlx_dlx_flit_q[70]} {fire_core_0/stage_1/tlx_dlx_flit_q[71]} {fire_core_0/stage_1/tlx_dlx_flit_q[72]} {fire_core_0/stage_1/tlx_dlx_flit_q[73]} {fire_core_0/stage_1/tlx_dlx_flit_q[74]} {fire_core_0/stage_1/tlx_dlx_flit_q[75]} {fire_core_0/stage_1/tlx_dlx_flit_q[76]} {fire_core_0/stage_1/tlx_dlx_flit_q[77]} {fire_core_0/stage_1/tlx_dlx_flit_q[78]} {fire_core_0/stage_1/tlx_dlx_flit_q[79]} {fire_core_0/stage_1/tlx_dlx_flit_q[80]} {fire_core_0/stage_1/tlx_dlx_flit_q[81]} {fire_core_0/stage_1/tlx_dlx_flit_q[82]} {fire_core_0/stage_1/tlx_dlx_flit_q[83]} {fire_core_0/stage_1/tlx_dlx_flit_q[84]} {fire_core_0/stage_1/tlx_dlx_flit_q[85]} {fire_core_0/stage_1/tlx_dlx_flit_q[86]} {fire_core_0/stage_1/tlx_dlx_flit_q[87]} {fire_core_0/stage_1/tlx_dlx_flit_q[88]} {fire_core_0/stage_1/tlx_dlx_flit_q[89]} {fire_core_0/stage_1/tlx_dlx_flit_q[90]} {fire_core_0/stage_1/tlx_dlx_flit_q[91]} {fire_core_0/stage_1/tlx_dlx_flit_q[92]} {fire_core_0/stage_1/tlx_dlx_flit_q[93]} {fire_core_0/stage_1/tlx_dlx_flit_q[94]} {fire_core_0/stage_1/tlx_dlx_flit_q[95]} {fire_core_0/stage_1/tlx_dlx_flit_q[96]} {fire_core_0/stage_1/tlx_dlx_flit_q[97]} {fire_core_0/stage_1/tlx_dlx_flit_q[98]} {fire_core_0/stage_1/tlx_dlx_flit_q[99]} {fire_core_0/stage_1/tlx_dlx_flit_q[100]} {fire_core_0/stage_1/tlx_dlx_flit_q[101]} {fire_core_0/stage_1/tlx_dlx_flit_q[102]} {fire_core_0/stage_1/tlx_dlx_flit_q[103]} {fire_core_0/stage_1/tlx_dlx_flit_q[104]} {fire_core_0/stage_1/tlx_dlx_flit_q[105]} {fire_core_0/stage_1/tlx_dlx_flit_q[106]} {fire_core_0/stage_1/tlx_dlx_flit_q[107]} {fire_core_0/stage_1/tlx_dlx_flit_q[108]} {fire_core_0/stage_1/tlx_dlx_flit_q[109]} {fire_core_0/stage_1/tlx_dlx_flit_q[110]} {fire_core_0/stage_1/tlx_dlx_flit_q[111]} {fire_core_0/stage_1/tlx_dlx_flit_q[112]} {fire_core_0/stage_1/tlx_dlx_flit_q[113]} {fire_core_0/stage_1/tlx_dlx_flit_q[114]} {fire_core_0/stage_1/tlx_dlx_flit_q[115]} {fire_core_0/stage_1/tlx_dlx_flit_q[116]} {fire_core_0/stage_1/tlx_dlx_flit_q[117]} {fire_core_0/stage_1/tlx_dlx_flit_q[118]} {fire_core_0/stage_1/tlx_dlx_flit_q[119]} {fire_core_0/stage_1/tlx_dlx_flit_q[120]} {fire_core_0/stage_1/tlx_dlx_flit_q[121]} {fire_core_0/stage_1/tlx_dlx_flit_q[122]} {fire_core_0/stage_1/tlx_dlx_flit_q[123]} {fire_core_0/stage_1/tlx_dlx_flit_q[124]} {fire_core_0/stage_1/tlx_dlx_flit_q[125]} {fire_core_0/stage_1/tlx_dlx_flit_q[126]} {fire_core_0/stage_1/tlx_dlx_flit_q[127]} {fire_core_0/stage_1/tlx_dlx_flit_q[128]} {fire_core_0/stage_1/tlx_dlx_flit_q[129]} {fire_core_0/stage_1/tlx_dlx_flit_q[130]} {fire_core_0/stage_1/tlx_dlx_flit_q[131]} {fire_core_0/stage_1/tlx_dlx_flit_q[132]} {fire_core_0/stage_1/tlx_dlx_flit_q[133]} {fire_core_0/stage_1/tlx_dlx_flit_q[134]} {fire_core_0/stage_1/tlx_dlx_flit_q[135]} {fire_core_0/stage_1/tlx_dlx_flit_q[136]} {fire_core_0/stage_1/tlx_dlx_flit_q[137]} {fire_core_0/stage_1/tlx_dlx_flit_q[138]} {fire_core_0/stage_1/tlx_dlx_flit_q[139]} {fire_core_0/stage_1/tlx_dlx_flit_q[140]} {fire_core_0/stage_1/tlx_dlx_flit_q[141]} {fire_core_0/stage_1/tlx_dlx_flit_q[142]} {fire_core_0/stage_1/tlx_dlx_flit_q[143]} {fire_core_0/stage_1/tlx_dlx_flit_q[144]} {fire_core_0/stage_1/tlx_dlx_flit_q[145]} {fire_core_0/stage_1/tlx_dlx_flit_q[146]} {fire_core_0/stage_1/tlx_dlx_flit_q[147]} {fire_core_0/stage_1/tlx_dlx_flit_q[148]} {fire_core_0/stage_1/tlx_dlx_flit_q[149]} {fire_core_0/stage_1/tlx_dlx_flit_q[150]} {fire_core_0/stage_1/tlx_dlx_flit_q[151]} {fire_core_0/stage_1/tlx_dlx_flit_q[152]} {fire_core_0/stage_1/tlx_dlx_flit_q[153]} {fire_core_0/stage_1/tlx_dlx_flit_q[154]} {fire_core_0/stage_1/tlx_dlx_flit_q[155]} {fire_core_0/stage_1/tlx_dlx_flit_q[156]} {fire_core_0/stage_1/tlx_dlx_flit_q[157]} {fire_core_0/stage_1/tlx_dlx_flit_q[158]} {fire_core_0/stage_1/tlx_dlx_flit_q[159]} {fire_core_0/stage_1/tlx_dlx_flit_q[160]} {fire_core_0/stage_1/tlx_dlx_flit_q[161]} {fire_core_0/stage_1/tlx_dlx_flit_q[162]} {fire_core_0/stage_1/tlx_dlx_flit_q[163]} {fire_core_0/stage_1/tlx_dlx_flit_q[164]} {fire_core_0/stage_1/tlx_dlx_flit_q[165]} {fire_core_0/stage_1/tlx_dlx_flit_q[166]} {fire_core_0/stage_1/tlx_dlx_flit_q[167]} {fire_core_0/stage_1/tlx_dlx_flit_q[168]} {fire_core_0/stage_1/tlx_dlx_flit_q[169]} {fire_core_0/stage_1/tlx_dlx_flit_q[170]} {fire_core_0/stage_1/tlx_dlx_flit_q[171]} {fire_core_0/stage_1/tlx_dlx_flit_q[172]} {fire_core_0/stage_1/tlx_dlx_flit_q[173]} {fire_core_0/stage_1/tlx_dlx_flit_q[174]} {fire_core_0/stage_1/tlx_dlx_flit_q[175]} {fire_core_0/stage_1/tlx_dlx_flit_q[176]} {fire_core_0/stage_1/tlx_dlx_flit_q[177]} {fire_core_0/stage_1/tlx_dlx_flit_q[178]} {fire_core_0/stage_1/tlx_dlx_flit_q[179]} {fire_core_0/stage_1/tlx_dlx_flit_q[180]} {fire_core_0/stage_1/tlx_dlx_flit_q[181]} {fire_core_0/stage_1/tlx_dlx_flit_q[182]} {fire_core_0/stage_1/tlx_dlx_flit_q[183]} {fire_core_0/stage_1/tlx_dlx_flit_q[184]} {fire_core_0/stage_1/tlx_dlx_flit_q[185]} {fire_core_0/stage_1/tlx_dlx_flit_q[186]} {fire_core_0/stage_1/tlx_dlx_flit_q[187]} {fire_core_0/stage_1/tlx_dlx_flit_q[188]} {fire_core_0/stage_1/tlx_dlx_flit_q[189]} {fire_core_0/stage_1/tlx_dlx_flit_q[190]} {fire_core_0/stage_1/tlx_dlx_flit_q[191]} {fire_core_0/stage_1/tlx_dlx_flit_q[192]} {fire_core_0/stage_1/tlx_dlx_flit_q[193]} {fire_core_0/stage_1/tlx_dlx_flit_q[194]} {fire_core_0/stage_1/tlx_dlx_flit_q[195]} {fire_core_0/stage_1/tlx_dlx_flit_q[196]} {fire_core_0/stage_1/tlx_dlx_flit_q[197]} {fire_core_0/stage_1/tlx_dlx_flit_q[198]} {fire_core_0/stage_1/tlx_dlx_flit_q[199]} {fire_core_0/stage_1/tlx_dlx_flit_q[200]} {fire_core_0/stage_1/tlx_dlx_flit_q[201]} {fire_core_0/stage_1/tlx_dlx_flit_q[202]} {fire_core_0/stage_1/tlx_dlx_flit_q[203]} {fire_core_0/stage_1/tlx_dlx_flit_q[204]} {fire_core_0/stage_1/tlx_dlx_flit_q[205]} {fire_core_0/stage_1/tlx_dlx_flit_q[206]} {fire_core_0/stage_1/tlx_dlx_flit_q[207]} {fire_core_0/stage_1/tlx_dlx_flit_q[208]} {fire_core_0/stage_1/tlx_dlx_flit_q[209]} {fire_core_0/stage_1/tlx_dlx_flit_q[210]} {fire_core_0/stage_1/tlx_dlx_flit_q[211]} {fire_core_0/stage_1/tlx_dlx_flit_q[212]} {fire_core_0/stage_1/tlx_dlx_flit_q[213]} {fire_core_0/stage_1/tlx_dlx_flit_q[214]} {fire_core_0/stage_1/tlx_dlx_flit_q[215]} {fire_core_0/stage_1/tlx_dlx_flit_q[216]} {fire_core_0/stage_1/tlx_dlx_flit_q[217]} {fire_core_0/stage_1/tlx_dlx_flit_q[218]} {fire_core_0/stage_1/tlx_dlx_flit_q[219]} {fire_core_0/stage_1/tlx_dlx_flit_q[220]} {fire_core_0/stage_1/tlx_dlx_flit_q[221]} {fire_core_0/stage_1/tlx_dlx_flit_q[222]} {fire_core_0/stage_1/tlx_dlx_flit_q[223]} {fire_core_0/stage_1/tlx_dlx_flit_q[224]} {fire_core_0/stage_1/tlx_dlx_flit_q[225]} {fire_core_0/stage_1/tlx_dlx_flit_q[226]} {fire_core_0/stage_1/tlx_dlx_flit_q[227]} {fire_core_0/stage_1/tlx_dlx_flit_q[228]} {fire_core_0/stage_1/tlx_dlx_flit_q[229]} {fire_core_0/stage_1/tlx_dlx_flit_q[230]} {fire_core_0/stage_1/tlx_dlx_flit_q[231]} {fire_core_0/stage_1/tlx_dlx_flit_q[232]} {fire_core_0/stage_1/tlx_dlx_flit_q[233]} {fire_core_0/stage_1/tlx_dlx_flit_q[234]} {fire_core_0/stage_1/tlx_dlx_flit_q[235]} {fire_core_0/stage_1/tlx_dlx_flit_q[236]} {fire_core_0/stage_1/tlx_dlx_flit_q[237]} {fire_core_0/stage_1/tlx_dlx_flit_q[238]} {fire_core_0/stage_1/tlx_dlx_flit_q[239]} {fire_core_0/stage_1/tlx_dlx_flit_q[240]} {fire_core_0/stage_1/tlx_dlx_flit_q[241]} {fire_core_0/stage_1/tlx_dlx_flit_q[242]} {fire_core_0/stage_1/tlx_dlx_flit_q[243]} {fire_core_0/stage_1/tlx_dlx_flit_q[244]} {fire_core_0/stage_1/tlx_dlx_flit_q[245]} {fire_core_0/stage_1/tlx_dlx_flit_q[246]} {fire_core_0/stage_1/tlx_dlx_flit_q[247]} {fire_core_0/stage_1/tlx_dlx_flit_q[248]} {fire_core_0/stage_1/tlx_dlx_flit_q[249]} {fire_core_0/stage_1/tlx_dlx_flit_q[250]} {fire_core_0/stage_1/tlx_dlx_flit_q[251]} {fire_core_0/stage_1/tlx_dlx_flit_q[252]} {fire_core_0/stage_1/tlx_dlx_flit_q[253]} {fire_core_0/stage_1/tlx_dlx_flit_q[254]} {fire_core_0/stage_1/tlx_dlx_flit_q[255]} {fire_core_0/stage_1/tlx_dlx_flit_q[256]} {fire_core_0/stage_1/tlx_dlx_flit_q[257]} {fire_core_0/stage_1/tlx_dlx_flit_q[258]} {fire_core_0/stage_1/tlx_dlx_flit_q[259]} {fire_core_0/stage_1/tlx_dlx_flit_q[260]} {fire_core_0/stage_1/tlx_dlx_flit_q[261]} {fire_core_0/stage_1/tlx_dlx_flit_q[262]} {fire_core_0/stage_1/tlx_dlx_flit_q[263]} {fire_core_0/stage_1/tlx_dlx_flit_q[264]} {fire_core_0/stage_1/tlx_dlx_flit_q[265]} {fire_core_0/stage_1/tlx_dlx_flit_q[266]} {fire_core_0/stage_1/tlx_dlx_flit_q[267]} {fire_core_0/stage_1/tlx_dlx_flit_q[268]} {fire_core_0/stage_1/tlx_dlx_flit_q[269]} {fire_core_0/stage_1/tlx_dlx_flit_q[270]} {fire_core_0/stage_1/tlx_dlx_flit_q[271]} {fire_core_0/stage_1/tlx_dlx_flit_q[272]} {fire_core_0/stage_1/tlx_dlx_flit_q[273]} {fire_core_0/stage_1/tlx_dlx_flit_q[274]} {fire_core_0/stage_1/tlx_dlx_flit_q[275]} {fire_core_0/stage_1/tlx_dlx_flit_q[276]} {fire_core_0/stage_1/tlx_dlx_flit_q[277]} {fire_core_0/stage_1/tlx_dlx_flit_q[278]} {fire_core_0/stage_1/tlx_dlx_flit_q[279]} {fire_core_0/stage_1/tlx_dlx_flit_q[280]} {fire_core_0/stage_1/tlx_dlx_flit_q[281]} {fire_core_0/stage_1/tlx_dlx_flit_q[282]} {fire_core_0/stage_1/tlx_dlx_flit_q[283]} {fire_core_0/stage_1/tlx_dlx_flit_q[284]} {fire_core_0/stage_1/tlx_dlx_flit_q[285]} {fire_core_0/stage_1/tlx_dlx_flit_q[286]} {fire_core_0/stage_1/tlx_dlx_flit_q[287]} {fire_core_0/stage_1/tlx_dlx_flit_q[288]} {fire_core_0/stage_1/tlx_dlx_flit_q[289]} {fire_core_0/stage_1/tlx_dlx_flit_q[290]} {fire_core_0/stage_1/tlx_dlx_flit_q[291]} {fire_core_0/stage_1/tlx_dlx_flit_q[292]} {fire_core_0/stage_1/tlx_dlx_flit_q[293]} {fire_core_0/stage_1/tlx_dlx_flit_q[294]} {fire_core_0/stage_1/tlx_dlx_flit_q[295]} {fire_core_0/stage_1/tlx_dlx_flit_q[296]} {fire_core_0/stage_1/tlx_dlx_flit_q[297]} {fire_core_0/stage_1/tlx_dlx_flit_q[298]} {fire_core_0/stage_1/tlx_dlx_flit_q[299]} {fire_core_0/stage_1/tlx_dlx_flit_q[300]} {fire_core_0/stage_1/tlx_dlx_flit_q[301]} {fire_core_0/stage_1/tlx_dlx_flit_q[302]} {fire_core_0/stage_1/tlx_dlx_flit_q[303]} {fire_core_0/stage_1/tlx_dlx_flit_q[304]} {fire_core_0/stage_1/tlx_dlx_flit_q[305]} {fire_core_0/stage_1/tlx_dlx_flit_q[306]} {fire_core_0/stage_1/tlx_dlx_flit_q[307]} {fire_core_0/stage_1/tlx_dlx_flit_q[308]} {fire_core_0/stage_1/tlx_dlx_flit_q[309]} {fire_core_0/stage_1/tlx_dlx_flit_q[310]} {fire_core_0/stage_1/tlx_dlx_flit_q[311]} {fire_core_0/stage_1/tlx_dlx_flit_q[312]} {fire_core_0/stage_1/tlx_dlx_flit_q[313]} {fire_core_0/stage_1/tlx_dlx_flit_q[314]} {fire_core_0/stage_1/tlx_dlx_flit_q[315]} {fire_core_0/stage_1/tlx_dlx_flit_q[316]} {fire_core_0/stage_1/tlx_dlx_flit_q[317]} {fire_core_0/stage_1/tlx_dlx_flit_q[318]} {fire_core_0/stage_1/tlx_dlx_flit_q[319]} {fire_core_0/stage_1/tlx_dlx_flit_q[320]} {fire_core_0/stage_1/tlx_dlx_flit_q[321]} {fire_core_0/stage_1/tlx_dlx_flit_q[322]} {fire_core_0/stage_1/tlx_dlx_flit_q[323]} {fire_core_0/stage_1/tlx_dlx_flit_q[324]} {fire_core_0/stage_1/tlx_dlx_flit_q[325]} {fire_core_0/stage_1/tlx_dlx_flit_q[326]} {fire_core_0/stage_1/tlx_dlx_flit_q[327]} {fire_core_0/stage_1/tlx_dlx_flit_q[328]} {fire_core_0/stage_1/tlx_dlx_flit_q[329]} {fire_core_0/stage_1/tlx_dlx_flit_q[330]} {fire_core_0/stage_1/tlx_dlx_flit_q[331]} {fire_core_0/stage_1/tlx_dlx_flit_q[332]} {fire_core_0/stage_1/tlx_dlx_flit_q[333]} {fire_core_0/stage_1/tlx_dlx_flit_q[334]} {fire_core_0/stage_1/tlx_dlx_flit_q[335]} {fire_core_0/stage_1/tlx_dlx_flit_q[336]} {fire_core_0/stage_1/tlx_dlx_flit_q[337]} {fire_core_0/stage_1/tlx_dlx_flit_q[338]} {fire_core_0/stage_1/tlx_dlx_flit_q[339]} {fire_core_0/stage_1/tlx_dlx_flit_q[340]} {fire_core_0/stage_1/tlx_dlx_flit_q[341]} {fire_core_0/stage_1/tlx_dlx_flit_q[342]} {fire_core_0/stage_1/tlx_dlx_flit_q[343]} {fire_core_0/stage_1/tlx_dlx_flit_q[344]} {fire_core_0/stage_1/tlx_dlx_flit_q[345]} {fire_core_0/stage_1/tlx_dlx_flit_q[346]} {fire_core_0/stage_1/tlx_dlx_flit_q[347]} {fire_core_0/stage_1/tlx_dlx_flit_q[348]} {fire_core_0/stage_1/tlx_dlx_flit_q[349]} {fire_core_0/stage_1/tlx_dlx_flit_q[350]} {fire_core_0/stage_1/tlx_dlx_flit_q[351]} {fire_core_0/stage_1/tlx_dlx_flit_q[352]} {fire_core_0/stage_1/tlx_dlx_flit_q[353]} {fire_core_0/stage_1/tlx_dlx_flit_q[354]} {fire_core_0/stage_1/tlx_dlx_flit_q[355]} {fire_core_0/stage_1/tlx_dlx_flit_q[356]} {fire_core_0/stage_1/tlx_dlx_flit_q[357]} {fire_core_0/stage_1/tlx_dlx_flit_q[358]} {fire_core_0/stage_1/tlx_dlx_flit_q[359]} {fire_core_0/stage_1/tlx_dlx_flit_q[360]} {fire_core_0/stage_1/tlx_dlx_flit_q[361]} {fire_core_0/stage_1/tlx_dlx_flit_q[362]} {fire_core_0/stage_1/tlx_dlx_flit_q[363]} {fire_core_0/stage_1/tlx_dlx_flit_q[364]} {fire_core_0/stage_1/tlx_dlx_flit_q[365]} {fire_core_0/stage_1/tlx_dlx_flit_q[366]} {fire_core_0/stage_1/tlx_dlx_flit_q[367]} {fire_core_0/stage_1/tlx_dlx_flit_q[368]} {fire_core_0/stage_1/tlx_dlx_flit_q[369]} {fire_core_0/stage_1/tlx_dlx_flit_q[370]} {fire_core_0/stage_1/tlx_dlx_flit_q[371]} {fire_core_0/stage_1/tlx_dlx_flit_q[372]} {fire_core_0/stage_1/tlx_dlx_flit_q[373]} {fire_core_0/stage_1/tlx_dlx_flit_q[374]} {fire_core_0/stage_1/tlx_dlx_flit_q[375]} {fire_core_0/stage_1/tlx_dlx_flit_q[376]} {fire_core_0/stage_1/tlx_dlx_flit_q[377]} {fire_core_0/stage_1/tlx_dlx_flit_q[378]} {fire_core_0/stage_1/tlx_dlx_flit_q[379]} {fire_core_0/stage_1/tlx_dlx_flit_q[380]} {fire_core_0/stage_1/tlx_dlx_flit_q[381]} {fire_core_0/stage_1/tlx_dlx_flit_q[382]} {fire_core_0/stage_1/tlx_dlx_flit_q[383]} {fire_core_0/stage_1/tlx_dlx_flit_q[384]} {fire_core_0/stage_1/tlx_dlx_flit_q[385]} {fire_core_0/stage_1/tlx_dlx_flit_q[386]} {fire_core_0/stage_1/tlx_dlx_flit_q[387]} {fire_core_0/stage_1/tlx_dlx_flit_q[388]} {fire_core_0/stage_1/tlx_dlx_flit_q[389]} {fire_core_0/stage_1/tlx_dlx_flit_q[390]} {fire_core_0/stage_1/tlx_dlx_flit_q[391]} {fire_core_0/stage_1/tlx_dlx_flit_q[392]} {fire_core_0/stage_1/tlx_dlx_flit_q[393]} {fire_core_0/stage_1/tlx_dlx_flit_q[394]} {fire_core_0/stage_1/tlx_dlx_flit_q[395]} {fire_core_0/stage_1/tlx_dlx_flit_q[396]} {fire_core_0/stage_1/tlx_dlx_flit_q[397]} {fire_core_0/stage_1/tlx_dlx_flit_q[398]} {fire_core_0/stage_1/tlx_dlx_flit_q[399]} {fire_core_0/stage_1/tlx_dlx_flit_q[400]} {fire_core_0/stage_1/tlx_dlx_flit_q[401]} {fire_core_0/stage_1/tlx_dlx_flit_q[402]} {fire_core_0/stage_1/tlx_dlx_flit_q[403]} {fire_core_0/stage_1/tlx_dlx_flit_q[404]} {fire_core_0/stage_1/tlx_dlx_flit_q[405]} {fire_core_0/stage_1/tlx_dlx_flit_q[406]} {fire_core_0/stage_1/tlx_dlx_flit_q[407]} {fire_core_0/stage_1/tlx_dlx_flit_q[408]} {fire_core_0/stage_1/tlx_dlx_flit_q[409]} {fire_core_0/stage_1/tlx_dlx_flit_q[410]} {fire_core_0/stage_1/tlx_dlx_flit_q[411]} {fire_core_0/stage_1/tlx_dlx_flit_q[412]} {fire_core_0/stage_1/tlx_dlx_flit_q[413]} {fire_core_0/stage_1/tlx_dlx_flit_q[414]} {fire_core_0/stage_1/tlx_dlx_flit_q[415]} {fire_core_0/stage_1/tlx_dlx_flit_q[416]} {fire_core_0/stage_1/tlx_dlx_flit_q[417]} {fire_core_0/stage_1/tlx_dlx_flit_q[418]} {fire_core_0/stage_1/tlx_dlx_flit_q[419]} {fire_core_0/stage_1/tlx_dlx_flit_q[420]} {fire_core_0/stage_1/tlx_dlx_flit_q[421]} {fire_core_0/stage_1/tlx_dlx_flit_q[422]} {fire_core_0/stage_1/tlx_dlx_flit_q[423]} {fire_core_0/stage_1/tlx_dlx_flit_q[424]} {fire_core_0/stage_1/tlx_dlx_flit_q[425]} {fire_core_0/stage_1/tlx_dlx_flit_q[426]} {fire_core_0/stage_1/tlx_dlx_flit_q[427]} {fire_core_0/stage_1/tlx_dlx_flit_q[428]} {fire_core_0/stage_1/tlx_dlx_flit_q[429]} {fire_core_0/stage_1/tlx_dlx_flit_q[430]} {fire_core_0/stage_1/tlx_dlx_flit_q[431]} {fire_core_0/stage_1/tlx_dlx_flit_q[432]} {fire_core_0/stage_1/tlx_dlx_flit_q[433]} {fire_core_0/stage_1/tlx_dlx_flit_q[434]} {fire_core_0/stage_1/tlx_dlx_flit_q[435]} {fire_core_0/stage_1/tlx_dlx_flit_q[436]} {fire_core_0/stage_1/tlx_dlx_flit_q[437]} {fire_core_0/stage_1/tlx_dlx_flit_q[438]} {fire_core_0/stage_1/tlx_dlx_flit_q[439]} {fire_core_0/stage_1/tlx_dlx_flit_q[440]} {fire_core_0/stage_1/tlx_dlx_flit_q[441]} {fire_core_0/stage_1/tlx_dlx_flit_q[442]} {fire_core_0/stage_1/tlx_dlx_flit_q[443]} {fire_core_0/stage_1/tlx_dlx_flit_q[444]} {fire_core_0/stage_1/tlx_dlx_flit_q[445]} {fire_core_0/stage_1/tlx_dlx_flit_q[446]} {fire_core_0/stage_1/tlx_dlx_flit_q[447]} {fire_core_0/stage_1/tlx_dlx_flit_q[448]} {fire_core_0/stage_1/tlx_dlx_flit_q[449]} {fire_core_0/stage_1/tlx_dlx_flit_q[450]} {fire_core_0/stage_1/tlx_dlx_flit_q[451]} {fire_core_0/stage_1/tlx_dlx_flit_q[452]} {fire_core_0/stage_1/tlx_dlx_flit_q[453]} {fire_core_0/stage_1/tlx_dlx_flit_q[454]} {fire_core_0/stage_1/tlx_dlx_flit_q[455]} {fire_core_0/stage_1/tlx_dlx_flit_q[456]} {fire_core_0/stage_1/tlx_dlx_flit_q[457]} {fire_core_0/stage_1/tlx_dlx_flit_q[458]} {fire_core_0/stage_1/tlx_dlx_flit_q[459]} {fire_core_0/stage_1/tlx_dlx_flit_q[460]} {fire_core_0/stage_1/tlx_dlx_flit_q[461]} {fire_core_0/stage_1/tlx_dlx_flit_q[462]} {fire_core_0/stage_1/tlx_dlx_flit_q[463]} {fire_core_0/stage_1/tlx_dlx_flit_q[464]} {fire_core_0/stage_1/tlx_dlx_flit_q[465]} {fire_core_0/stage_1/tlx_dlx_flit_q[466]} {fire_core_0/stage_1/tlx_dlx_flit_q[467]} {fire_core_0/stage_1/tlx_dlx_flit_q[468]} {fire_core_0/stage_1/tlx_dlx_flit_q[469]} {fire_core_0/stage_1/tlx_dlx_flit_q[470]} {fire_core_0/stage_1/tlx_dlx_flit_q[471]} {fire_core_0/stage_1/tlx_dlx_flit_q[472]} {fire_core_0/stage_1/tlx_dlx_flit_q[473]} {fire_core_0/stage_1/tlx_dlx_flit_q[474]} {fire_core_0/stage_1/tlx_dlx_flit_q[475]} {fire_core_0/stage_1/tlx_dlx_flit_q[476]} {fire_core_0/stage_1/tlx_dlx_flit_q[477]} {fire_core_0/stage_1/tlx_dlx_flit_q[478]} {fire_core_0/stage_1/tlx_dlx_flit_q[479]} {fire_core_0/stage_1/tlx_dlx_flit_q[480]} {fire_core_0/stage_1/tlx_dlx_flit_q[481]} {fire_core_0/stage_1/tlx_dlx_flit_q[482]} {fire_core_0/stage_1/tlx_dlx_flit_q[483]} {fire_core_0/stage_1/tlx_dlx_flit_q[484]} {fire_core_0/stage_1/tlx_dlx_flit_q[485]} {fire_core_0/stage_1/tlx_dlx_flit_q[486]} {fire_core_0/stage_1/tlx_dlx_flit_q[487]} {fire_core_0/stage_1/tlx_dlx_flit_q[488]} {fire_core_0/stage_1/tlx_dlx_flit_q[489]} {fire_core_0/stage_1/tlx_dlx_flit_q[490]} {fire_core_0/stage_1/tlx_dlx_flit_q[491]} {fire_core_0/stage_1/tlx_dlx_flit_q[492]} {fire_core_0/stage_1/tlx_dlx_flit_q[493]} {fire_core_0/stage_1/tlx_dlx_flit_q[494]} {fire_core_0/stage_1/tlx_dlx_flit_q[495]} {fire_core_0/stage_1/tlx_dlx_flit_q[496]} {fire_core_0/stage_1/tlx_dlx_flit_q[497]} {fire_core_0/stage_1/tlx_dlx_flit_q[498]} {fire_core_0/stage_1/tlx_dlx_flit_q[499]} {fire_core_0/stage_1/tlx_dlx_flit_q[500]} {fire_core_0/stage_1/tlx_dlx_flit_q[501]} {fire_core_0/stage_1/tlx_dlx_flit_q[502]} {fire_core_0/stage_1/tlx_dlx_flit_q[503]} {fire_core_0/stage_1/tlx_dlx_flit_q[504]} {fire_core_0/stage_1/tlx_dlx_flit_q[505]} {fire_core_0/stage_1/tlx_dlx_flit_q[506]} {fire_core_0/stage_1/tlx_dlx_flit_q[507]} {fire_core_0/stage_1/tlx_dlx_flit_q[508]} {fire_core_0/stage_1/tlx_dlx_flit_q[509]} {fire_core_0/stage_1/tlx_dlx_flit_q[510]} {fire_core_0/stage_1/tlx_dlx_flit_q[511]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 2 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {fire_core_0/dl/dlx/tx/gbx0/out_header_q[0]} {fire_core_0/dl/dlx/tx/gbx0/out_header_q[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 2 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {fire_core_0/dl/dlx/tx/gbx1/out_header_q[0]} {fire_core_0/dl/dlx/tx/gbx1/out_header_q[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 2 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list {fire_core_0/dl/dlx/rx/phy0/ln_header_q[0]} {fire_core_0/dl/dlx/rx/phy0/ln_header_q[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 2 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list {fire_core_0/dl/dlx/rx/phy1/ln_header_q[0]} {fire_core_0/dl/dlx/rx/phy1/ln_header_q[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 2 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list {fire_core_0/dl/dlx/rx/phy2/ln_header_q[0]} {fire_core_0/dl/dlx/rx/phy2/ln_header_q[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 2 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list {fire_core_0/dl/dlx/rx/phy3/ln_header_q[0]} {fire_core_0/dl/dlx/rx/phy3/ln_header_q[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 2 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list {fire_core_0/dl/dlx/rx/phy4/ln_header_q[0]} {fire_core_0/dl/dlx/rx/phy4/ln_header_q[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 2 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list {fire_core_0/dl/dlx/rx/phy5/ln_header_q[0]} {fire_core_0/dl/dlx/rx/phy5/ln_header_q[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 2 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list {fire_core_0/dl/dlx/rx/phy6/ln_header_q[0]} {fire_core_0/dl/dlx/rx/phy6/ln_header_q[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 2 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list {fire_core_0/dl/dlx/rx/phy7/ln_header_q[0]} {fire_core_0/dl/dlx/rx/phy7/ln_header_q[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 3 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list {fire_core_0/dl/dlx/tx/ctl/tsm_q[0]} {fire_core_0/dl/dlx/tx/ctl/tsm_q[1]} {fire_core_0/dl/dlx/tx/ctl/tsm_q[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe25]
set_property port_width 2 [get_debug_ports u_ila_0/probe25]
connect_debug_port u_ila_0/probe25 [get_nets [list {fire_core_0/dl/dlx/tx/gbx6/out_header_q[0]} {fire_core_0/dl/dlx/tx/gbx6/out_header_q[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe26]
set_property port_width 2 [get_debug_ports u_ila_0/probe26]
connect_debug_port u_ila_0/probe26 [get_nets [list {fire_core_0/dl/dlx/tx/gbx7/out_header_q[0]} {fire_core_0/dl/dlx/tx/gbx7/out_header_q[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe27]
set_property port_width 3 [get_debug_ports u_ila_0/probe27]
connect_debug_port u_ila_0/probe27 [get_nets [list {fire_core_0/dl/dlx/xlx_if/xtsm_q[0]} {fire_core_0/dl/dlx/xlx_if/xtsm_q[1]} {fire_core_0/dl/dlx/xlx_if/xtsm_q[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe28]
set_property port_width 8 [get_debug_ports u_ila_0/probe28]
connect_debug_port u_ila_0/probe28 [get_nets [list {fire_core_0/tl/axi/tlx_afu_resp_opcode_2[0]} {fire_core_0/tl/axi/tlx_afu_resp_opcode_2[1]} {fire_core_0/tl/axi/tlx_afu_resp_opcode_2[2]} {fire_core_0/tl/axi/tlx_afu_resp_opcode_2[3]} {fire_core_0/tl/axi/tlx_afu_resp_opcode_2[4]} {fire_core_0/tl/axi/tlx_afu_resp_opcode_2[5]} {fire_core_0/tl/axi/tlx_afu_resp_opcode_2[6]} {fire_core_0/tl/axi/tlx_afu_resp_opcode_2[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe29]
set_property port_width 4 [get_debug_ports u_ila_0/probe29]
connect_debug_port u_ila_0/probe29 [get_nets [list {fire_core_0/tl/tlx_afu_resp_code[0]} {fire_core_0/tl/tlx_afu_resp_code[1]} {fire_core_0/tl/tlx_afu_resp_code[2]} {fire_core_0/tl/tlx_afu_resp_code[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe30]
set_property port_width 1 [get_debug_ports u_ila_0/probe30]
connect_debug_port u_ila_0/probe30 [get_nets [list fire_core_0/fbist/agen_dgen_command_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe31]
set_property port_width 1 [get_debug_ports u_ila_0/probe31]
connect_debug_port u_ila_0/probe31 [get_nets [list fire_core_0/tl/new_tl_top.TL_TOP/ocx_tl_rcv_top/dl_write]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe32]
set_property port_width 1 [get_debug_ports u_ila_0/probe32]
connect_debug_port u_ila_0/probe32 [get_nets [list fire_core_0/fbist/chk/lut_valid_q]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe33]
set_property port_width 1 [get_debug_ports u_ila_0/probe33]
connect_debug_port u_ila_0/probe33 [get_nets [list fire_core_0/stage_1/tlx_dlx_flit_valid_q]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe34]
set_property port_width 1 [get_debug_ports u_ila_0/probe34]
connect_debug_port u_ila_0/probe34 [get_nets [list fire_core_0/fbist/axi_chk_response_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe35]
set_property port_width 1 [get_debug_ports u_ila_0/probe35]
connect_debug_port u_ila_0/probe35 [get_nets [list fire_core_0/c3s_dlx/c3s_cntl/c3s_ip]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe36]
set_property port_width 1 [get_debug_ports u_ila_0/probe36]
connect_debug_port u_ila_0/probe36 [get_nets [list fire_core_0/dl/dlx/tx/ctl/pat_a_done]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe37]
set_property port_width 1 [get_debug_ports u_ila_0/probe37]
connect_debug_port u_ila_0/probe37 [get_nets [list fire_core_0/fbist/chk/lut_store_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe38]
set_property port_width 1 [get_debug_ports u_ila_0/probe38]
connect_debug_port u_ila_0/probe38 [get_nets [list fire_core_0/fbist/agen_chk_command_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe39]
set_property port_width 1 [get_debug_ports u_ila_0/probe39]
connect_debug_port u_ila_0/probe39 [get_nets [list fire_core_0/dl/dlx/tx/ctl/pat_b_done]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe40]
set_property port_width 1 [get_debug_ports u_ila_0/probe40]
connect_debug_port u_ila_0/probe40 [get_nets [list fire_core_0/fbist/chk/lut_fetch_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe41]
set_property port_width 1 [get_debug_ports u_ila_0/probe41]
connect_debug_port u_ila_0/probe41 [get_nets [list fire_core_0/fbist/dgen_axi_command_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe42]
set_property port_width 1 [get_debug_ports u_ila_0/probe42]
connect_debug_port u_ila_0/probe42 [get_nets [list fire_core_0/dl/dlx/tx/ctl/sync_done]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe43]
set_property port_width 1 [get_debug_ports u_ila_0/probe43]
connect_debug_port u_ila_0/probe43 [get_nets [list fire_core_0/tl/axi/tlx_afu_resp_valid_2]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe44]
set_property port_width 1 [get_debug_ports u_ila_0/probe44]
connect_debug_port u_ila_0/probe44 [get_nets [list fire_core_0/dl/dlx/xlx_if/rec_first_xtsm_din]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe45]
set_property port_width 1 [get_debug_ports u_ila_0/probe45]
connect_debug_port u_ila_0/probe45 [get_nets [list fire_core_0/tl/axi/oc_trans_bvalid_2]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe46]
set_property port_width 1 [get_debug_ports u_ila_0/probe46]
connect_debug_port u_ila_0/probe46 [get_nets [list fire_core_0/fbist/fbist_cfg_status_ip]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe47]
set_property port_width 1 [get_debug_ports u_ila_0/probe47]
connect_debug_port u_ila_0/probe47 [get_nets [list fire_core_0/dl/dlx/tx/ctl/ts1_done]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe48]
set_property port_width 1 [get_debug_ports u_ila_0/probe48]
connect_debug_port u_ila_0/probe48 [get_nets [list fire_core_0/tl/axi/oc_trans_rvalid_2]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe49]
set_property port_width 1 [get_debug_ports u_ila_0/probe49]
connect_debug_port u_ila_0/probe49 [get_nets [list fire_core_0/dl/dlx/tx/ctl/ts2_done]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe50]
set_property port_width 1 [get_debug_ports u_ila_0/probe50]
connect_debug_port u_ila_0/probe50 [get_nets [list fire_core_0/dl/dlx/tx/ctl/ts3_done]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe51]
set_property port_width 1 [get_debug_ports u_ila_0/probe51]
connect_debug_port u_ila_0/probe51 [get_nets [list fire_core_0/dl/dlx/tx/ctl/ts4_done]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe52]
set_property port_width 1 [get_debug_ports u_ila_0/probe52]
connect_debug_port u_ila_0/probe52 [get_nets [list fire_core_0/c3s_dlx/c3s_cntl/c3s_stop_bit]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe53]
set_property port_width 1 [get_debug_ports u_ila_0/probe53]
connect_debug_port u_ila_0/probe53 [get_nets [list fire_core_0/c3s_dlx/c3s_cntl/c3s_start_bit]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe54]
set_property port_width 1 [get_debug_ports u_ila_0/probe54]
connect_debug_port u_ila_0/probe54 [get_nets [list fire_core_0/dl/dlx/tx/ctl/block_locked]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe55]
set_property port_width 1 [get_debug_ports u_ila_0/probe55]
connect_debug_port u_ila_0/probe55 [get_nets [list fire_core_0/tl/new_tl_top.TL_TOP/ocxtlx_framer/send_flit_now]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets fml_axis_aclk]
