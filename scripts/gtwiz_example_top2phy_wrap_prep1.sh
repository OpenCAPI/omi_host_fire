#!/bin/bash
# This script takes the output of the wizard generating an ultrascale example
#  and tunes it for astra design
# First it changes all names
# Then is looks for 64b66b, gtpowergood, etc blocs and comments them
# Finally it adds bit_synchronizer_vio_gtwiz_buffbypass_rx_error_0_inst 
# instance after bit_synchronizer_vio_gtwiz_buffbypass_tx_error_0_inst 
# When '' can't be used, we use " to avoid escaping "1b'0"
# at the end of the last append (a) command, we need to have a carriage return before the terminating bracket }"
# This is why, we didn't find a way to generate the other one, hence the second script gtwiz_top2.sh (bit_synchronizer_vio_gtwiz_reset_tx_done_0_inst)
# Find a pattern an replace part of the lines to run on hb0, hb1, etc ...: ".*" replaces 0, 1, 2, etc .... and then {s/xx/yy/} replaces on the found line.
# /assign hb.*_gtwiz_userdata_rx_int/{s/_gtwiz_userdata_rx_int/_gtwiz_userdata_rx/}" \
# remove from 868 up to 1142 after "PRBS STIMULUS, CHECKING, AND LINK MANAGEMENT" is found
# When a long text has to be inserted, addingx files associated with r command are used.
# pay attention that when using "{" to group command, it requires a CR. So we decided to move this specific command into separated 
# sed command lines at the end of the script.

sed -e 's/gtwizard_ultrascale_0/DLx_phy/g' \
-e "/DONT_TOUCH/d" \
-e "/input  wire mgtrefclk0_x0y7_n,/a\\
    \n  \/\/ Clocking\n\
  output wire cclk,\n\
  output wire rclk,\n\
  input  wire hb_gtwiz_reset_clk_freerun_buf_int,\n\
  output wire tx_clk_402MHz,\n"  \
-e 's/mgtrefclk0_x0y6/mgtrefclk0_x0y0/g' \
-e 's/mgtrefclk0_x0y7/mgtrefclk0_x0y1/g' \
-e 's/MGTREFCLK0_X0Y6/MGTREFCLK0_X0Y0/g' \
-e 's/MGTREFCLK0_X0Y7/MGTREFCLK0_X0Y1/g' \
-e "/wire \[0\:\0] gtwiz_userclk_rx_usrclk_int/,+2 s/^/\/\//" \
-e "/wire \[0\:\0] hb0_gtwiz_userclk_rx_usrclk2_int/,+1 s/^/\/\//" \
-e "/input  wire hb_gtwiz_reset_clk_freerun_in/,+3 s/^/\/\//" \
-e "/input  wire link_down_latched_reset_in/,+2 s/^/\/\//" \
-e '/bit_synchronizer_vio_gtpowergood_/,+4 s/^/\/\//' \
-e "/wire \[0\:0\] gtwiz_reset_tx_pll_and_datapath_int/{n;s/^/  \/\//;n; s/^/  \/\//}" \
-e "/wire \[0\:0\] gtwiz_reset_tx_datapath_int/{n;s/^/  \/\//;n; s/^/  \/\//}" \
-e "/wire \[63\:0\] hb0_gtwiz_userdata_tx_int/,+7 d" \
-e "/\] = hb.*_gtwiz_userdata_tx_int/{s/_gtwiz_userdata_tx_int/_gtwiz_userdata_tx/}" \
-e "/\] hb.*_gtwiz_userdata_rx_int/d" \
-e "/assign hb.*_gtwiz_userdata_rx_int/{s/_gtwiz_userdata_rx_int/_gtwiz_userdata_rx/}" \
-e "/PRBS STIMULUS, CHECKING, AND LINK MANAGEMENT/,+274 d" \
-e "/wire \[79\:0\] drpaddr_int;/,+23 d" \
-e "/wire \[0\:\0] ch.*_rxgearboxslip_int;/,+7 d" \
-e "/assign rxgearboxslip_int.*_rxgearboxslip_int;/{s/_rxgearboxslip_int/_rxgearboxslip/}" \
-e "/wire \[7\:0\] rxlpmen_int;/,+1 d" \
-e "/wire \[23\:0\] rxrate_int;/,+1 d" \
-e "/wire \[39\:0\] txdiffctrl_int;/,+1 d" \
-e "/wire \[5\:0\] ch.*_txheader_int;/ d" \
-e "/assign txheader_int.* = ch.*_txheader_int/{s/ch/\{4'b0000, ch/};s/txheader_int/txheader\}/2" \
-e "/wire \[39\:0\] txp/,+2 d" \
-e "/wire \[39\:0\] txp/,+2 d" \
-e "/wire \[6\:0\] ch.*_txsequence_int;/ d" \
-e "/assign txsequence_int.* = ch.*_txsequence_int;/{s/ch/\{1'b0, ch/};s/txsequence_int/txsequence\}/2" \
-e "/assign ch7_rxdatavalid_int = rxdatavalid_int\[15\:14\];/a\  assign ch0_rxdatavalid = ch0_rxdatavalid_int\[0\];\n\
  assign ch1_rxdatavalid = ch1_rxdatavalid_int\[0\];\n\
  assign ch2_rxdatavalid = ch2_rxdatavalid_int\[0\];\n\
  assign ch3_rxdatavalid = ch3_rxdatavalid_int\[0\];\n\
  assign ch4_rxdatavalid = ch4_rxdatavalid_int\[0\];\n\
  assign ch5_rxdatavalid = ch5_rxdatavalid_int\[0\];\n\
  assign ch6_rxdatavalid = ch6_rxdatavalid_int\[0\];\n\
  assign ch7_rxdatavalid = ch7_rxdatavalid_int\[0\];" \
-e "/assign ch7_rxheader_int = rxheader_int\[47\:42\];/a\  assign ch0_rxheader = ch0_rxheader_int\[1\:0\];\n\
  assign ch1_rxheader = ch1_rxheader_int\[1\:0\];\n\
  assign ch2_rxheader = ch2_rxheader_int\[1\:0\];\n\
  assign ch3_rxheader = ch3_rxheader_int\[1\:0\];\n\
  assign ch4_rxheader = ch4_rxheader_int\[1\:0\];\n\
  assign ch5_rxheader = ch5_rxheader_int\[1\:0\];\n\
  assign ch6_rxheader = ch6_rxheader_int\[1\:0\];\n\
  assign ch7_rxheader = ch7_rxheader_int\[1\:0\];" \
-e "/wire \[127\:0\] drpdo_int;/,+55 d" \
-e "/wire hb_gtwiz_reset_all_vio_int;/,+1 s/^/  \/\//" \
-e "/IBUF ibuf_hb_gtwiz_reset_all_inst (/,+3 d" \
-e "/wire hb_gtwiz_reset_all_int;/a\ \n  wire hb_gtwiz_reset_all_DLx_reset;" \
-e "/assign hb_gtwiz_reset_all_int = hb_gtwiz_reset_all_buf_int/{s/^/  \/\//}" \
-e "/assign hb_gtwiz_reset_all_int =/a\  assign hb_gtwiz_reset_all_int = hb_gtwiz_reset_all_DLx_reset || hb_gtwiz_reset_all_init_int;" \
-e "/wire hb_gtwiz_reset_clk_freerun_buf_int;/s/^/  \/\//" \
-e "/  wire mgtrefclk0_x0y0_int/a\  wire reset_clk_156_25MHz;\n" \
-e "/  BUFG bufg_clk_freerun_inst (/,+3 s/^/  \/\//" \
-e "/  assign hb0_gtwiz_userclk_tx_reset_int = ~(/s/^/  \/\//" \
-e "/  assign hb0_gtwiz_userclk_tx_reset_int = ~(/a\  assign hb0_gtwiz_userclk_tx_reset_int = ~( &txpmaresetdone_int);  " \
-e "/wire       init_done_int;/,+6 s/^/  \/\//" \
-e "/wire hb_gtwiz_reset_rx_datapath_init_int;/a\  wire hb_gtwiz_reset_rx_datapath_DLx_int; // Josh added to retrain the transceiver's receiver" \
-e "/assign hb_gtwiz_reset_rx_datapath_int = hb_gtwiz_reset_rx_datapath/s/^/  \/\//"  \
-e "/assign hb_gtwiz_reset_rx_datapath_int = hb_gtwiz_reset_rx_datapath/a\  assign hb_gtwiz_reset_rx_datapath_int = hb_gtwiz_reset_rx_datapath_init_int || hb_gtwiz_reset_rx_datapath_DLx_int;" \
-e "s/.rx_data_good_in (sm_link)/    .rx_data_good_in (gtwiz_reset_rx_done_int ), \/\/ if you get through bufferbypasss assume data is good.    /" \
-e "/wire \[7\:0\] gtpowergood_vio_sync;/s/^/  \/\//" \
-e "/.i_in   (txprgdivresetdone_int\[0\]),/s/^/  \/\//"  \
-e "/.i_in   (txprgdivresetdone_int\[0\]),/a\    .i_in   (1\'b0),"  \
-e "/wire \[0\:0\] gtwiz_reset_tx_done_vio_sync/s/^/  \/\//"  \
-e "/wire \[0\:0\] gtwiz_reset_rx_done_vio_sync/s/^/  \/\//"  \
-e "/wire \[0\:0\] gtwiz_buffbypass_tx_done_vio_sync/ s/^/  \/\//" \
-e "/wire \[0\:0\] gtwiz_buffbypass_tx_error_vio_sync/s/^/  \/\//" \
-e "/wire \[0\:0\] gtwiz_buffbypass_rx_error_vio_sync/s/^/  \/\//" \
-e "/.gtwiz_userclk_tx_usrclk2_out            (gtwiz_userclk_tx_usrclk2_int)/a\   ,.gtwiz_userclk_tx_usrclk3_out            (gtwiz_userclk_tx_usrclk3_int)" \
-e "/.gtwiz_userclk_rx_usrclk_out             (gtwiz_userclk_rx_usrclk_int)/,+1 s/^/  \/\//" \
-e "/.gtpowergood_out                         (gtpowergood_int)/s/^/  \/\//" \
-e "/.txprgdivresetdone_out                   (txprgdivresetdone_int)/s/^/  \/\//" \
\
-e '/phy_vio_0/,+20 s/^/\/\//' \
-e '/in_system_ibert_0/,+64 s/^/\/\//' \
-e "/bit_synchronizer_vio_gtwiz_buffbypass_tx_error_0_inst/{N;N;N;N; a \ \n\
  \/\/ Synchronize gtwiz_buffbypass_rx_error into the free-running clock domain for VIO usage\n\
  wire [0:0] gtwiz_buffbypass_rx_error_vio_sync;\n\
\n\
  DLx_phy_example_bit_synchronizer bit_synchronizer_vio_gtwiz_buffbypass_rx_error_0_inst (\n\
   \.clk_in (hb_gtwiz_reset_clk_freerun_buf_int),\n\
    \/\/ \.i_in   (gtwiz_buffbypass_rx_error_int[0]),\n\
   \.i_in   (1'b0),\n\
   \.o_out  (gtwiz_buffbypass_rx_error_vio_sync[0])\n\
  );\n
} " ./gtwizard_ultrascale_0_example_top.v  > dlx_phy_wrap_ref.v

sed -i "s/wire \[0\:0\] gtwiz_reset_tx_pll_and_datapath_int;/wire \[0\:0\] gtwiz_reset_tx_pll_and_datapath_int = 1\'b0;/" dlx_phy_wrap_ref.v

sed -i "s/wire \[0\:0\] gtwiz_reset_tx_datapath_int;/wire \[0\:0\] gtwiz_reset_tx_datapath_int = 1\'b0;/"  dlx_phy_wrap_ref.v

sed -i '/output reg  link_down_latched_out =/r adding2'  dlx_phy_wrap_ref.v

sed -i '/assign hb0_gtwiz_buffbypass_tx_error_int = gtwiz_buffbypass_tx_error_int/r adding3' dlx_phy_wrap_ref.v

sed -i '/.o_out  (gtwiz_buffbypass_tx_done_vio_sync/{n;n;r adding4
}' dlx_phy_wrap_ref.v

sed -i '/o_out  (gtwiz_buffbypass_rx_error_vio_sync/{n;n;r adding5
}' dlx_phy_wrap_ref.v
