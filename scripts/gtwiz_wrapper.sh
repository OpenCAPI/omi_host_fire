#!/bin/bash

# First we generate a reference file, that will be used to create a wrapper for each DDIMM port
# Before output, removing the comma helps avoiding misinterpretation
# We also need to escape : "," "[" with an "\" otherwise we can't replace the desired lines.
# when appending, before the appended string a "\" is required to take into account the space of the line beginning
# firt we make a general replacement
# then we "append" (a)  the clk3 line
# comment the rx section
# remove the gtpowergood "wire" line
# we use " instead of ' when we already use ' in strings !
# finally save created fil into a reference wrapper file.

echo "Creating DLx_phy_example_wrapper_ref.v"
sed -e 's/gtwizard_ultrascale_0/DLx_phy/g' \
    -e '/output wire \[0\:0\] gtwiz_userclk_tx_usrclk2_out/a\ ,output wire \[0\:0\] gtwiz_userclk_tx_usrclk3_out'\
    -e '/output wire \[0\:0\] gtwiz_userclk_rx_usrclk_out/s/^/\/\//'\
    -e '/output wire \[0\:0\] gtwiz_userclk_rx_usrclk2_out/s/^/\/\//'\
    -e '/output wire \[7\:0\] gtpowergood_out/d'\
    -e '/output wire \[7\:0\] txprgdivresetdone_out/s/^/\/\//'\
    -e '/example_gtwiz_userclk_rx/,+6 s/^/\/\//' \
    -e "s/.*localparam \[191\:0\] P_CHANNEL_ENABLE = 192.*/  localparam \[191\:0\] P_CHANNEL_ENABLE = 192\'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111000000000000;/"\
    -e 's/calc_pk_mc_idx(31)/calc_pk_mc_idx(16)/'\
    -e "/wire \[7\:0\] txoutclk_int/a\  wire gtwiz_userclk_tx_active_int;"\
    -e "/gtwiz_userclk_tx_usrclk2_out (gtwiz_userclk_tx_usrclk2_out),/a\    .gtwiz_userclk_tx_usrclk3_out (gtwiz_userclk_tx_usrclk3_out),\n    .gtwiz_userclk_tx_active_out  (gtwiz_userclk_tx_active_int)"\
    -e '/gtwiz_userclk_tx_active_out  (gtwiz_userclk_tx_active_out)/d'\
    -e '/.gtwiz_userclk_tx_usrclk3_out (gtwiz_userclk_tx_usrclk3_out),/c\    .gtwiz_userclk_tx_active_out  (gtwiz_userclk_tx_active_int)/'\
    -e "/assign txusrclk2_int = {8{gtwiz_userclk_tx_usrclk2_out}}/a\  assign gtwiz_userclk_tx_active_out = gtwiz_userclk_tx_active_int;"\
    -e 's/rxoutclk_int\[P_RX_MASTER_CH_PACKED_IDX\]/txoutclk_int\[P_RX_MASTER_CH_PACKED_IDX\]/'\
    -e '/Drive RXUSRCLK and RXUSRCLK2/a \  /*'\
    -e "/= {8{gtwiz_userclk_rx_usrclk2_out}}/a\  *\/\n\
  assign rxusrclk_int  = \{8\{1\'b0\}\}; \n\
  assign rxusrclk2_int = \{8\{1\'b0\}\}; \n\
  assign gtwiz_userclk_rx_active_out = gtwiz_userclk_tx_active_int;\n\n"\
    -e '/Required assignment to expose the GTPOWERGOOD/,+1 s/^/\/\//' \
    -e "/wire \[7\:\0] gtpowergood_int;/a\  wire [7:0] txprgdivresetdone_out;"\
    -e "/,.gtwiz_userclk_tx_active_in /a\    ,.gtpowergood_out                         (gtpowergood_out)"\
    -e "s/active_in              (gtwiz_userclk_rx_active_out)/active_in              (gtwiz_userclk_tx_active_int)/"\
    -e '/gtpowergood_out                         (gtpowergood_int)/d'\
    -e 's/(rxusrclk/(txusrclk/'\
    -e '/txprgdivresetdone_out                   (txprgdivresetdone_out)/d'\
  ./gtwizard_ultrascale_0_example_wrapper.v  > DLx_phy_example_wrapper_ref.v

#    -e '/(rxrate_in)/ s/^/\/\//' \
#    -e "/,.gtwiz_userclk_rx_active_in              (gtwiz_userclk_rx_active_out)/s/^/\/\//"\
#    -e '/txprgdivresetdone_out                   (txprgdivresetdone_out)/d';a\,.rxpolarity_in                           (rxpolarity_in)\

sed -i '/assign gtwiz_userclk_rx_active_out = gtwiz_userclk_tx_active_int;/r adding1' DLx_phy_example_wrapper_ref.v
echo "ref wrapper written"

#    -e "/txoutclk_int/a  wire gtwiz_userclk_tx_active_int"\    
# Tuning the reference wrapper for port 0
sed -e 's/module DLx_phy_example_wrapper/module DLx_phy_example_wrapper0/'\
    -e 's/DLx_phy DLx_phy_inst (/gtwizard_ultrascale_0 DLx_phy_inst (/g' \
     DLx_phy_example_wrapper_ref.v > ./DLx_phy_example_wrapper0.v

# Tuning the reference wrapper for port 1
sed -e 's/module DLx_phy_example_wrapper/module DLx_phy_example_wrapper1/'\
    -e 's/DLx_phy DLx_phy_inst (/gtwizard_ultrascale_1 DLx_phy_inst (/g' \
     DLx_phy_example_wrapper_ref.v > ./DLx_phy_example_wrapper1.v

# Tuning the reference wrapper for port 2
if [ -d "../../../ip_created_for_fire/gtwizard_ultrascale_2" ]; then 
sed -e 's/module DLx_phy_example_wrapper/module DLx_phy_example_wrapper2/'\
    -e 's/DLx_phy DLx_phy_inst (/gtwizard_ultrascale_2 DLx_phy_inst (/g' \
     DLx_phy_example_wrapper_ref.v > ./DLx_phy_example_wrapper2.v
fi
# Tuning the reference wrapper for port 3
if [ -d "../../../ip_created_for_fire/gtwizard_ultrascale_3" ]; then 
sed -e 's/module DLx_phy_example_wrapper/module DLx_phy_example_wrapper3/'\
    -e 's/DLx_phy DLx_phy_inst (/gtwizard_ultrascale_3 DLx_phy_inst (/g' \
     DLx_phy_example_wrapper_ref.v > ./DLx_phy_example_wrapper3.v
fi

# AC : the following is actually just a simple copy
sed -e 's/gtwizard_ultrascale_0/DLx_phy/g' \
     ./gtwizard_ultrascale_0_example_wrapper_functions.v  > DLx_phy_example_wrapper_functions.v
