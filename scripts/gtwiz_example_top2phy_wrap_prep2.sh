#!/bin/bash
# the following already appears later in the file
# sed -i "/bit_synchronizer_vio_gtwiz_reset_tx_done_0_inst/{N;N;N;N; a \ \n\
#  \/\/ Synchronize gtwiz_buffbypass_rx_done into the free-running clock domain for VIO usage\n\
#  wire [0:0] gtwiz_buffbypass_rx_done_vio_sync;\n\
#\n\
#  DLx_phy_example_bit_synchronizer bit_synchronizer_vio_gtwiz_buffbypass_rx_done_0_inst (\n\
#   \.clk_in (hb_gtwiz_reset_clk_freerun_buf_int),\n\
#   \.i_in  (gtwiz_reset_rx_done_int[0]),\n\
#   \.o_out  (gtwiz_buffbypass_rx_done_vio_sync[0])\n\
#  );\n
#} " dlx_phy_wrap_ref.v

# Preparing first DDIMM attachment
sed -e 's/DLx_phy_example_wrapper/DLx_phy_example_wrapper0/' \
    -e 's/module DLx_phy_example_top /module dlx_phy_wrap0/'   ./dlx_phy_wrap_ref.v > dlx_phy_wrap0.v
 
# Preparing second DDIMM attachment
sed -e 's/DLx_phy_example_wrapper/DLx_phy_example_wrapper1/' \
    -e 's/module DLx_phy_example_top /module dlx_phy_wrap1/' ./dlx_phy_wrap_ref.v > dlx_phy_wrap1.v
