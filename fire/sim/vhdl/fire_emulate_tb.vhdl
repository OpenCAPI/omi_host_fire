-- *!***************************************************************************
-- *! (C) Copyright International Business Machines Corp. 2018
-- *!           All Rights Reserved -- Property of IBM
-- *!                   *** IBM Confidential ***
-- *!***************************************************************************
-- *! FILENAME    : fire_emulate_tb.vhdl
-- *! TITLE       : DL to DL Testbench
-- *! DESCRIPTION : Testbench containing 2 ocx_dlx_wrap
-- *!
-- *! OWNER  NAME : Ryan King (rpking@us.ibm.com)
-- *! BACKUP NAME : Kevin McIlvain
-- *!
-- *!***************************************************************************
-- MR_PARAMS -clk gckn
-- MR_B SOFT
-- MS_REC 2

--          <macro name>          <instance name>   <port map renames>
-- MS_INST  mb_top                mb_top            dlx_phy_lane_0 dlx1_phy_lane_0
-- MS_INST  mb_top                mb_top            dlx_phy_lane_1 dlx1_phy_lane_1
-- MS_INST  mb_top                mb_top            dlx_phy_lane_2 dlx1_phy_lane_2
-- MS_INST  mb_top                mb_top            dlx_phy_lane_3 dlx1_phy_lane_3
-- MS_INST  mb_top                mb_top            dlx_phy_lane_4 dlx1_phy_lane_4
-- MS_INST  mb_top                mb_top            dlx_phy_lane_5 dlx1_phy_lane_5
-- MS_INST  mb_top                mb_top            dlx_phy_lane_6 dlx1_phy_lane_6
-- MS_INST  mb_top                mb_top            dlx_phy_lane_7 dlx1_phy_lane_7
-- MS_INST  mb_top                mb_top            phy_dlx_lane_0 phy_dlx1_lane_0
-- MS_INST  mb_top                mb_top            phy_dlx_lane_1 phy_dlx1_lane_1
-- MS_INST  mb_top                mb_top            phy_dlx_lane_2 phy_dlx1_lane_2
-- MS_INST  mb_top                mb_top            phy_dlx_lane_3 phy_dlx1_lane_3
-- MS_INST  mb_top                mb_top            phy_dlx_lane_4 phy_dlx1_lane_4
-- MS_INST  mb_top                mb_top            phy_dlx_lane_5 phy_dlx1_lane_5
-- MS_INST  mb_top                mb_top            phy_dlx_lane_6 phy_dlx1_lane_6
-- MS_INST  mb_top                mb_top            phy_dlx_lane_7 phy_dlx1_lane_7

-- MS_INST  fire_emulate          fire0             gtwiz_done fire0_gtwiz_done

library ieee,ibm,support,mb;
use ieee.std_logic_1164.all;
use ibm.synthesis_support.all;
use support.logic_support_pkg.all;
use support.syn_util_functions_pkg.ALL;
use support.power_logic_pkg.all;
use work.axi_pkg.all;

entity fire_emulate_tb is
  port (
    ---------------------------------------------------------------------------
    -- Clocking
    ---------------------------------------------------------------------------
    dummy_gckn                     : in std_ulogic
    );

  attribute BLOCK_TYPE of fire_emulate_tb : entity is SOFT;
  attribute BTR_NAME of fire_emulate_tb : entity is "FIRE_EMULATE_TB";
  attribute RECURSIVE_SYNTHESIS of fire_emulate_tb : entity is 2;
  attribute PIN_DATA of dummy_gckn : signal is "PIN_FUNCTION=/G_CLK/";
end fire_emulate_tb;

architecture fire_emulate_tb of fire_emulate_tb is
  SIGNAL opt_gckn : std_ulogic;
  SIGNAL opt_gckn_4x : std_ulogic;
  SIGNAL reset : std_ulogic;
  SIGNAL gnd : power_logic;
  SIGNAL vdd : power_logic;
  SIGNAL fire0_gtwiz_done : std_ulogic;
  SIGNAL c3s_dlx0_axis_aclk : std_ulogic;
  SIGNAL c3s_dlx0_axis_aresetn : std_ulogic;
  SIGNAL c3s_dlx0_axis_awvalid : std_ulogic;
  SIGNAL c3s_dlx0_axis_awaddr : std_ulogic_vector(63 downto 0);
  SIGNAL c3s_dlx0_axis_awprot : std_ulogic_vector(2 downto 0);
  SIGNAL c3s_dlx0_axis_wvalid : std_ulogic;
  SIGNAL c3s_dlx0_axis_wdata : std_ulogic_vector(31 downto 0);
  SIGNAL c3s_dlx0_axis_wstrb : std_ulogic_vector(3 downto 0);
  SIGNAL c3s_dlx0_axis_bready : std_ulogic;
  SIGNAL c3s_dlx0_axis_arvalid : std_ulogic;
  SIGNAL c3s_dlx0_axis_araddr : std_ulogic_vector(63 downto 0);
  SIGNAL c3s_dlx0_axis_arprot : std_ulogic_vector(2 downto 0);
  SIGNAL c3s_dlx0_axis_rready : std_ulogic;
  SIGNAL phy_dlx1_lane_0 : std_ulogic_vector(0 to 15);
  SIGNAL dlx0_phy_lane_0 : std_ulogic_vector(0 to 15);
  SIGNAL phy_dlx1_lane_1 : std_ulogic_vector(0 to 15);
  SIGNAL dlx0_phy_lane_1 : std_ulogic_vector(0 to 15);
  SIGNAL phy_dlx1_lane_2 : std_ulogic_vector(0 to 15);
  SIGNAL dlx0_phy_lane_2 : std_ulogic_vector(0 to 15);
  SIGNAL phy_dlx1_lane_3 : std_ulogic_vector(0 to 15);
  SIGNAL dlx0_phy_lane_3 : std_ulogic_vector(0 to 15);
  SIGNAL phy_dlx1_lane_4 : std_ulogic_vector(0 to 15);
  SIGNAL dlx0_phy_lane_4 : std_ulogic_vector(0 to 15);
  SIGNAL phy_dlx1_lane_5 : std_ulogic_vector(0 to 15);
  SIGNAL dlx0_phy_lane_5 : std_ulogic_vector(0 to 15);
  SIGNAL phy_dlx1_lane_6 : std_ulogic_vector(0 to 15);
  SIGNAL dlx0_phy_lane_6 : std_ulogic_vector(0 to 15);
  SIGNAL phy_dlx1_lane_7 : std_ulogic_vector(0 to 15);
  SIGNAL dlx0_phy_lane_7 : std_ulogic_vector(0 to 15);
  SIGNAL phy_dlx0_lane_0 : std_ulogic_vector(0 to 15);
  SIGNAL dlx1_phy_lane_0 : std_ulogic_vector(0 to 15);
  SIGNAL phy_dlx0_lane_1 : std_ulogic_vector(0 to 15);
  SIGNAL dlx1_phy_lane_1 : std_ulogic_vector(0 to 15);
  SIGNAL phy_dlx0_lane_2 : std_ulogic_vector(0 to 15);
  SIGNAL dlx1_phy_lane_2 : std_ulogic_vector(0 to 15);
  SIGNAL phy_dlx0_lane_3 : std_ulogic_vector(0 to 15);
  SIGNAL dlx1_phy_lane_3 : std_ulogic_vector(0 to 15);
  SIGNAL phy_dlx0_lane_4 : std_ulogic_vector(0 to 15);
  SIGNAL dlx1_phy_lane_4 : std_ulogic_vector(0 to 15);
  SIGNAL phy_dlx0_lane_5 : std_ulogic_vector(0 to 15);
  SIGNAL dlx1_phy_lane_5 : std_ulogic_vector(0 to 15);
  SIGNAL phy_dlx0_lane_6 : std_ulogic_vector(0 to 15);
  SIGNAL dlx1_phy_lane_6 : std_ulogic_vector(0 to 15);
  SIGNAL phy_dlx0_lane_7 : std_ulogic_vector(0 to 15);
  SIGNAL dlx1_phy_lane_7 : std_ulogic_vector(0 to 15);
  SIGNAL c3s_dlx0_axis_arready : std_ulogic;
  SIGNAL c3s_dlx0_axis_awready : std_ulogic;
  SIGNAL c3s_dlx0_axis_bresp : std_ulogic_vector(1 downto 0);
  SIGNAL c3s_dlx0_axis_bvalid : std_ulogic;
  SIGNAL c3s_dlx0_axis_rdata : std_ulogic_vector(31 downto 0);
  SIGNAL c3s_dlx0_axis_rresp : std_ulogic_vector(1 downto 0);
  SIGNAL c3s_dlx0_axis_rvalid : std_ulogic;
  SIGNAL c3s_dlx0_axis_wready : std_ulogic;
  SIGNAL async_resetb : std_ulogic;
  SIGNAL c4_epow : std_ulogic;
  SIGNAL c4_eventn : std_ulogic;
  SIGNAL c4_saven : std_ulogic;
  SIGNAL dfi_act_n_a : std_ulogic;
  SIGNAL dfi_act_n_b : std_ulogic;
  SIGNAL dfi_address_a : std_ulogic_vector(0 to 17);
  SIGNAL dfi_address_b : std_ulogic_vector(0 to 17);
  SIGNAL dfi_alert_n : std_ulogic;
  SIGNAL dfi_bank_a : std_ulogic_vector(0 to 1);
  SIGNAL dfi_bank_b : std_ulogic_vector(0 to 1);
  SIGNAL dfi_bg_a : std_ulogic_vector(0 to 1);
  SIGNAL dfi_bg_b : std_ulogic_vector(0 to 1);
  SIGNAL dfi_cas_n_a : std_ulogic;
  SIGNAL dfi_cas_n_b : std_ulogic;
  SIGNAL dfi_cid_a : std_ulogic_vector(0 to 1);
  SIGNAL dfi_cid_b : std_ulogic_vector(0 to 1);
  SIGNAL dfi_cke_a : std_ulogic_vector(0 to 1);
  SIGNAL dfi_cke_b : std_ulogic_vector(0 to 1);
  SIGNAL dfi_cs_n_a : std_ulogic_vector(0 to 1);
  SIGNAL dfi_cs_n_b : std_ulogic_vector(0 to 1);
  SIGNAL dfi_ctrlupd_ack : std_ulogic;
  SIGNAL dfi_ctrlupd_req : std_ulogic;
  SIGNAL dfi_dram_clk_disable_a : std_ulogic_vector(0 to 1);
  SIGNAL dfi_dram_clk_disable_b : std_ulogic_vector(0 to 1);
  SIGNAL dfi_freq : std_ulogic_vector(0 to 4);
  SIGNAL dfi_init_complete : std_ulogic;
  SIGNAL dfi_init_start : std_ulogic;
  SIGNAL dfi_lp_ack : std_ulogic;
  SIGNAL dfi_lp_ctrl_req : std_ulogic;
  SIGNAL dfi_lp_data_req : std_ulogic;
  SIGNAL dfi_lp_wakeup : std_ulogic_vector(0 to 3);
  SIGNAL dfi_odt_a : std_ulogic_vector(0 to 1);
  SIGNAL dfi_odt_b : std_ulogic_vector(0 to 1);
  SIGNAL dfi_parity_in_a : std_ulogic;
  SIGNAL dfi_parity_in_b : std_ulogic;
  SIGNAL dfi_ras_n_a : std_ulogic;
  SIGNAL dfi_ras_n_b : std_ulogic;
  SIGNAL dfi_rddata : std_ulogic_vector(0 to 159);
  SIGNAL dfi_rddata_cs_n : std_ulogic_vector(0 to 39);
  SIGNAL dfi_rddata_en : std_ulogic_vector(0 to 9);
  SIGNAL dfi_rddata_valid : std_ulogic_vector(0 to 9);
  SIGNAL dfi_reset_n : std_ulogic;
  SIGNAL dfi_we_n_a : std_ulogic;
  SIGNAL dfi_we_n_b : std_ulogic;
  SIGNAL dfi_wrdata : std_ulogic_vector(0 to 159);
  SIGNAL dfi_wrdata_cs_n : std_ulogic_vector(0 to 39);
  SIGNAL dfi_wrdata_en : std_ulogic_vector(0 to 9);
  SIGNAL dlx_phy_recal_req_0 : std_ulogic;
  SIGNAL dlx_phy_recal_req_1 : std_ulogic;
  SIGNAL dlx_phy_recal_req_2 : std_ulogic;
  SIGNAL dlx_phy_recal_req_3 : std_ulogic;
  SIGNAL dlx_phy_recal_req_4 : std_ulogic;
  SIGNAL dlx_phy_recal_req_5 : std_ulogic;
  SIGNAL dlx_phy_recal_req_6 : std_ulogic;
  SIGNAL dlx_phy_recal_req_7 : std_ulogic;
  SIGNAL dlx_phy_rx_psave_req_0 : std_ulogic;
  SIGNAL dlx_phy_rx_psave_req_1 : std_ulogic;
  SIGNAL dlx_phy_rx_psave_req_2 : std_ulogic;
  SIGNAL dlx_phy_rx_psave_req_3 : std_ulogic;
  SIGNAL dlx_phy_rx_psave_req_4 : std_ulogic;
  SIGNAL dlx_phy_rx_psave_req_5 : std_ulogic;
  SIGNAL dlx_phy_rx_psave_req_6 : std_ulogic;
  SIGNAL dlx_phy_rx_psave_req_7 : std_ulogic;
  SIGNAL dlx_phy_run_lane_0 : std_ulogic;
  SIGNAL dlx_phy_run_lane_1 : std_ulogic;
  SIGNAL dlx_phy_run_lane_2 : std_ulogic;
  SIGNAL dlx_phy_run_lane_3 : std_ulogic;
  SIGNAL dlx_phy_run_lane_4 : std_ulogic;
  SIGNAL dlx_phy_run_lane_5 : std_ulogic;
  SIGNAL dlx_phy_run_lane_6 : std_ulogic;
  SIGNAL dlx_phy_run_lane_7 : std_ulogic;
  SIGNAL dlx_phy_sideband : std_ulogic_vector(7 downto 0);
  SIGNAL dlx_phy_tx_psave_req_0 : std_ulogic;
  SIGNAL dlx_phy_tx_psave_req_1 : std_ulogic;
  SIGNAL dlx_phy_tx_psave_req_2 : std_ulogic;
  SIGNAL dlx_phy_tx_psave_req_3 : std_ulogic;
  SIGNAL dlx_phy_tx_psave_req_4 : std_ulogic;
  SIGNAL dlx_phy_tx_psave_req_5 : std_ulogic;
  SIGNAL dlx_phy_tx_psave_req_6 : std_ulogic;
  SIGNAL dlx_phy_tx_psave_req_7 : std_ulogic;
  SIGNAL dqbypass : std_ulogic_vector(0 to 79);
  SIGNAL fuse_enterprise_dis : std_ulogic;
  SIGNAL gck : std_ulogic;
  SIGNAL gif2pcb_maddr : std_ulogic_vector(31 downto 0);
  SIGNAL gif2pcb_masideband : std_ulogic;
  SIGNAL gif2pcb_mburst : std_ulogic_vector(1 downto 0);
  SIGNAL gif2pcb_mdata : std_ulogic_vector(31 downto 0);
  SIGNAL gif2pcb_mlast : std_ulogic;
  SIGNAL gif2pcb_mlen : std_ulogic_vector(3 downto 0);
  SIGNAL gif2pcb_mread : std_ulogic;
  SIGNAL gif2pcb_mready : std_ulogic;
  SIGNAL gif2pcb_msize : std_ulogic_vector(2 downto 0);
  SIGNAL gif2pcb_mwrite : std_ulogic;
  SIGNAL gif2pcb_mwsideband : std_ulogic_vector(3 downto 0);
  SIGNAL gif2pcb_mwstrb : std_ulogic_vector(3 downto 0);
  SIGNAL gif2pcb_saccept : std_ulogic;
  SIGNAL gif2pcb_sdata : std_ulogic_vector(31 downto 0);
  SIGNAL gif2pcb_slast : std_ulogic;
  SIGNAL gif2pcb_sresp : std_ulogic_vector(1 downto 0);
  SIGNAL gif2pcb_srsideband : std_ulogic_vector(3 downto 0);
  SIGNAL gif2pcb_svalid : std_ulogic;
  SIGNAL gpbc_to_mb_top_error_info : std_ulogic_vector(52 downto 0);
  SIGNAL mb_top_to_gpbc_error_info : std_ulogic_vector(15 downto 0);
  SIGNAL pclk : std_ulogic;
  SIGNAL phy_dlx_clock_0 : std_ulogic;
  SIGNAL phy_dlx_clock_1 : std_ulogic;
  SIGNAL phy_dlx_clock_2 : std_ulogic;
  SIGNAL phy_dlx_clock_3 : std_ulogic;
  SIGNAL phy_dlx_clock_4 : std_ulogic;
  SIGNAL phy_dlx_clock_5 : std_ulogic;
  SIGNAL phy_dlx_clock_6 : std_ulogic;
  SIGNAL phy_dlx_clock_7 : std_ulogic;
  SIGNAL phy_dlx_init_done_0 : std_ulogic;
  SIGNAL phy_dlx_init_done_1 : std_ulogic;
  SIGNAL phy_dlx_init_done_2 : std_ulogic;
  SIGNAL phy_dlx_init_done_3 : std_ulogic;
  SIGNAL phy_dlx_init_done_4 : std_ulogic;
  SIGNAL phy_dlx_init_done_5 : std_ulogic;
  SIGNAL phy_dlx_init_done_6 : std_ulogic;
  SIGNAL phy_dlx_init_done_7 : std_ulogic;
  SIGNAL phy_dlx_recal_done_0 : std_ulogic;
  SIGNAL phy_dlx_recal_done_1 : std_ulogic;
  SIGNAL phy_dlx_recal_done_2 : std_ulogic;
  SIGNAL phy_dlx_recal_done_3 : std_ulogic;
  SIGNAL phy_dlx_recal_done_4 : std_ulogic;
  SIGNAL phy_dlx_recal_done_5 : std_ulogic;
  SIGNAL phy_dlx_recal_done_6 : std_ulogic;
  SIGNAL phy_dlx_recal_done_7 : std_ulogic;
  SIGNAL phy_dlx_rx_psave_sts_0 : std_ulogic;
  SIGNAL phy_dlx_rx_psave_sts_1 : std_ulogic;
  SIGNAL phy_dlx_rx_psave_sts_2 : std_ulogic;
  SIGNAL phy_dlx_rx_psave_sts_3 : std_ulogic;
  SIGNAL phy_dlx_rx_psave_sts_4 : std_ulogic;
  SIGNAL phy_dlx_rx_psave_sts_5 : std_ulogic;
  SIGNAL phy_dlx_rx_psave_sts_6 : std_ulogic;
  SIGNAL phy_dlx_rx_psave_sts_7 : std_ulogic;
  SIGNAL phy_dlx_sideband : std_ulogic_vector(7 downto 0);
  SIGNAL phy_dlx_tx_psave_sts_0 : std_ulogic;
  SIGNAL phy_dlx_tx_psave_sts_1 : std_ulogic;
  SIGNAL phy_dlx_tx_psave_sts_2 : std_ulogic;
  SIGNAL phy_dlx_tx_psave_sts_3 : std_ulogic;
  SIGNAL phy_dlx_tx_psave_sts_4 : std_ulogic;
  SIGNAL phy_dlx_tx_psave_sts_5 : std_ulogic;
  SIGNAL phy_dlx_tx_psave_sts_6 : std_ulogic;
  SIGNAL phy_dlx_tx_psave_sts_7 : std_ulogic;
  SIGNAL pib2gif_maddr : std_ulogic_vector(31 downto 0);
  SIGNAL pib2gif_masideband : std_ulogic;
  SIGNAL pib2gif_mburst : std_ulogic_vector(1 downto 0);
  SIGNAL pib2gif_mcache : std_ulogic_vector(3 downto 0);
  SIGNAL pib2gif_mdata : std_ulogic_vector(31 downto 0);
  SIGNAL pib2gif_mid : std_ulogic_vector(4 downto 0);
  SIGNAL pib2gif_mlast : std_ulogic;
  SIGNAL pib2gif_mlen : std_ulogic_vector(3 downto 0);
  SIGNAL pib2gif_mlock : std_ulogic;
  SIGNAL pib2gif_mprot : std_ulogic_vector(2 downto 0);
  SIGNAL pib2gif_mread : std_ulogic;
  SIGNAL pib2gif_mready : std_ulogic;
  SIGNAL pib2gif_msize : std_ulogic_vector(2 downto 0);
  SIGNAL pib2gif_mwrite : std_ulogic;
  SIGNAL pib2gif_mwsideband : std_ulogic_vector(3 downto 0);
  SIGNAL pib2gif_mwstrb : std_ulogic_vector(3 downto 0);
  SIGNAL pib2gif_saccept : std_ulogic;
  SIGNAL pib2gif_sdata : std_ulogic_vector(31 downto 0);
  SIGNAL pib2gif_sid : std_ulogic_vector(4 downto 0);
  SIGNAL pib2gif_slast : std_ulogic;
  SIGNAL pib2gif_sresp : std_ulogic_vector(2 downto 0);
  SIGNAL pib2gif_srsideband : std_ulogic_vector(3 downto 0);
  SIGNAL pib2gif_svalid : std_ulogic;
  SIGNAL scan_en_o : std_ulogic;
  SIGNAL scanb : std_ulogic;
  SIGNAL spare_input_acx4_a : std_ulogic_vector(0 to 3);
  SIGNAL spare_input_acx4_b : std_ulogic_vector(0 to 3);
  SIGNAL spare_input_dbyte : std_ulogic_vector(0 to 9);
  SIGNAL spare_input_pub : std_ulogic_vector(0 to 3);
  SIGNAL spare_output_acx4_a : std_ulogic_vector(0 to 3);
  SIGNAL spare_output_acx4_b : std_ulogic_vector(0 to 3);
  SIGNAL spare_output_dbyte : std_ulogic_vector(0 to 9);
  SIGNAL spare_output_pub : std_ulogic_vector(0 to 3);
  SIGNAL sw_reset : std_ulogic;
  SIGNAL sw_reset_clock_divider : std_ulogic;
  SIGNAL sync_reset_pclk_out : std_ulogic;
  SIGNAL test_clk_1 : std_ulogic;
  SIGNAL testclk_selb : std_ulogic;
  SIGNAL dbg_dlx_tlxr_flit : std_ulogic_vector(511 downto 0);
  SIGNAL dbg_dlx_tlxr_flit_data : std_ulogic_vector(127 downto 0);
  SIGNAL dbg_dlx_tlxr_flit_data_n1 : std_ulogic_vector(127 downto 0);
  SIGNAL dbg_dlx_tlxr_flit_data_n2 : std_ulogic_vector(127 downto 0);
  SIGNAL dbg_dlx_tlxr_flit_data_n3 : std_ulogic_vector(127 downto 0);
  SIGNAL dbg_dlx_tlxr_flit_data_n4 : std_ulogic_vector(127 downto 0);
  SIGNAL dbg_dlx_tlxr_flit_vld : std_ulogic;
  SIGNAL dbg_dlx_tlxr_flit_error : std_ulogic;
  SIGNAL dbg_dlx_tlxr_partial_flit_cnt : std_ulogic_vector(1 downto 0);
  SIGNAL dbg_dlx_tlxr_flit_valid : std_ulogic;
  SIGNAL dbg_dlx_tlxr_flit_vld_n1 : std_ulogic;
  SIGNAL dbg_dlx_tlxr_flit_valid_full : std_ulogic;
  SIGNAL dbg_dlx_tlxr_flit_valid_n1 : std_ulogic;
  SIGNAL dbg_dlx_tlxr_flit_valid_n2 : std_ulogic;
  SIGNAL dbg_dlx_tlxr_flit_valid_n3 : std_ulogic;
  SIGNAL dbg_dlx_tlxr_flit_full : std_ulogic_vector(511 downto 0);
  SIGNAL oc_memory0_axis_aclk : std_ulogic;
  SIGNAL oc_memory0_axis_aresetn : std_ulogic;
  SIGNAL oc_memory0_axis_awid : std_ulogic_vector(6 downto 0);
  SIGNAL oc_memory0_axis_awaddr : std_ulogic_vector(63 downto 0);
  SIGNAL oc_memory0_axis_awlen : std_ulogic_vector(7 downto 0);
  SIGNAL oc_memory0_axis_awsize : std_ulogic_vector(2 downto 0);
  SIGNAL oc_memory0_axis_awburst : std_ulogic_vector(1 downto 0);
  SIGNAL oc_memory0_axis_awlock : std_ulogic_vector(1 downto 0);
  SIGNAL oc_memory0_axis_awcache : std_ulogic_vector(3 downto 0);
  SIGNAL oc_memory0_axis_awprot : std_ulogic_vector(2 downto 0);
  SIGNAL oc_memory0_axis_awvalid : std_ulogic;
  SIGNAL oc_memory0_axis_awready : std_ulogic;
  SIGNAL oc_memory0_axis_wid : std_ulogic_vector(6 downto 0);
  SIGNAL oc_memory0_axis_wdata : std_ulogic_vector(31 downto 0);
  SIGNAL oc_memory0_axis_wstrb : std_ulogic_vector(3 downto 0);
  SIGNAL oc_memory0_axis_wlast : std_ulogic;
  SIGNAL oc_memory0_axis_wvalid : std_ulogic;
  SIGNAL oc_memory0_axis_wready : std_ulogic;
  SIGNAL oc_memory0_axis_bid : std_ulogic_vector(6 downto 0);
  SIGNAL oc_memory0_axis_bresp : std_ulogic_vector(1 downto 0);
  SIGNAL oc_memory0_axis_bvalid : std_ulogic;
  SIGNAL oc_memory0_axis_bready : std_ulogic;
  SIGNAL oc_memory0_axis_arid : std_ulogic_vector(6 downto 0);
  SIGNAL oc_memory0_axis_araddr : std_ulogic_vector(63 downto 0);
  SIGNAL oc_memory0_axis_arlen : std_ulogic_vector(7 downto 0);
  SIGNAL oc_memory0_axis_arsize : std_ulogic_vector(2 downto 0);
  SIGNAL oc_memory0_axis_arburst : std_ulogic_vector(1 downto 0);
  SIGNAL oc_memory0_axis_arlock : std_ulogic_vector(1 downto 0);
  SIGNAL oc_memory0_axis_arcache : std_ulogic_vector(3 downto 0);
  SIGNAL oc_memory0_axis_arprot : std_ulogic_vector(2 downto 0);
  SIGNAL oc_memory0_axis_arvalid : std_ulogic;
  SIGNAL oc_memory0_axis_arready : std_ulogic;
  SIGNAL oc_memory0_axis_rid : std_ulogic_vector(6 downto 0);
  SIGNAL oc_memory0_axis_rdata : std_ulogic_vector(31 downto 0);
  SIGNAL oc_memory0_axis_rresp : std_ulogic_vector(1 downto 0);
  SIGNAL oc_memory0_axis_rlast : std_ulogic;
  SIGNAL oc_memory0_axis_rvalid : std_ulogic;
  SIGNAL oc_memory0_axis_rready : std_ulogic;
  SIGNAL oc_mmio0_axis_aclk : std_ulogic;
  SIGNAL oc_mmio0_axis_aresetn : std_ulogic;
  SIGNAL oc_mmio0_axis_awid : std_ulogic_vector(6 downto 0);
  SIGNAL oc_mmio0_axis_awaddr : std_ulogic_vector(63 downto 0);
  SIGNAL oc_mmio0_axis_awlen : std_ulogic_vector(7 downto 0);
  SIGNAL oc_mmio0_axis_awsize : std_ulogic_vector(2 downto 0);
  SIGNAL oc_mmio0_axis_awburst : std_ulogic_vector(1 downto 0);
  SIGNAL oc_mmio0_axis_awlock : std_ulogic_vector(1 downto 0);
  SIGNAL oc_mmio0_axis_awcache : std_ulogic_vector(3 downto 0);
  SIGNAL oc_mmio0_axis_awprot : std_ulogic_vector(2 downto 0);
  SIGNAL oc_mmio0_axis_awvalid : std_ulogic;
  SIGNAL oc_mmio0_axis_awready : std_ulogic;
  SIGNAL oc_mmio0_axis_wid : std_ulogic_vector(6 downto 0);
  SIGNAL oc_mmio0_axis_wdata : std_ulogic_vector(31 downto 0);
  SIGNAL oc_mmio0_axis_wstrb : std_ulogic_vector(3 downto 0);
  SIGNAL oc_mmio0_axis_wlast : std_ulogic;
  SIGNAL oc_mmio0_axis_wvalid : std_ulogic;
  SIGNAL oc_mmio0_axis_wready : std_ulogic;
  SIGNAL oc_mmio0_axis_bid : std_ulogic_vector(6 downto 0);
  SIGNAL oc_mmio0_axis_bresp : std_ulogic_vector(1 downto 0);
  SIGNAL oc_mmio0_axis_bvalid : std_ulogic;
  SIGNAL oc_mmio0_axis_bready : std_ulogic;
  SIGNAL oc_mmio0_axis_arid : std_ulogic_vector(6 downto 0);
  SIGNAL oc_mmio0_axis_araddr : std_ulogic_vector(63 downto 0);
  SIGNAL oc_mmio0_axis_arlen : std_ulogic_vector(7 downto 0);
  SIGNAL oc_mmio0_axis_arsize : std_ulogic_vector(2 downto 0);
  SIGNAL oc_mmio0_axis_arburst : std_ulogic_vector(1 downto 0);
  SIGNAL oc_mmio0_axis_arlock : std_ulogic_vector(1 downto 0);
  SIGNAL oc_mmio0_axis_arcache : std_ulogic_vector(3 downto 0);
  SIGNAL oc_mmio0_axis_arprot : std_ulogic_vector(2 downto 0);
  SIGNAL oc_mmio0_axis_arvalid : std_ulogic;
  SIGNAL oc_mmio0_axis_arready : std_ulogic;
  SIGNAL oc_mmio0_axis_rid : std_ulogic_vector(6 downto 0);
  SIGNAL oc_mmio0_axis_rdata : std_ulogic_vector(31 downto 0);
  SIGNAL oc_mmio0_axis_rresp : std_ulogic_vector(1 downto 0);
  SIGNAL oc_mmio0_axis_rlast : std_ulogic;
  SIGNAL oc_mmio0_axis_rvalid : std_ulogic;
  SIGNAL oc_mmio0_axis_rready : std_ulogic;
  SIGNAL oc_cfg0_axis_aclk : std_ulogic;
  SIGNAL oc_cfg0_axis_aresetn : std_ulogic;
  SIGNAL oc_cfg0_axis_awid : std_ulogic_vector(6 downto 0);
  SIGNAL oc_cfg0_axis_awaddr : std_ulogic_vector(63 downto 0);
  SIGNAL oc_cfg0_axis_awlen : std_ulogic_vector(7 downto 0);
  SIGNAL oc_cfg0_axis_awsize : std_ulogic_vector(2 downto 0);
  SIGNAL oc_cfg0_axis_awburst : std_ulogic_vector(1 downto 0);
  SIGNAL oc_cfg0_axis_awlock : std_ulogic_vector(1 downto 0);
  SIGNAL oc_cfg0_axis_awcache : std_ulogic_vector(3 downto 0);
  SIGNAL oc_cfg0_axis_awprot : std_ulogic_vector(2 downto 0);
  SIGNAL oc_cfg0_axis_awvalid : std_ulogic;
  SIGNAL oc_cfg0_axis_awready : std_ulogic;
  SIGNAL oc_cfg0_axis_wid : std_ulogic_vector(6 downto 0);
  SIGNAL oc_cfg0_axis_wdata : std_ulogic_vector(31 downto 0);
  SIGNAL oc_cfg0_axis_wstrb : std_ulogic_vector(3 downto 0);
  SIGNAL oc_cfg0_axis_wlast : std_ulogic;
  SIGNAL oc_cfg0_axis_wvalid : std_ulogic;
  SIGNAL oc_cfg0_axis_wready : std_ulogic;
  SIGNAL oc_cfg0_axis_bid : std_ulogic_vector(6 downto 0);
  SIGNAL oc_cfg0_axis_bresp : std_ulogic_vector(1 downto 0);
  SIGNAL oc_cfg0_axis_bvalid : std_ulogic;
  SIGNAL oc_cfg0_axis_bready : std_ulogic;
  SIGNAL oc_cfg0_axis_arid : std_ulogic_vector(6 downto 0);
  SIGNAL oc_cfg0_axis_araddr : std_ulogic_vector(63 downto 0);
  SIGNAL oc_cfg0_axis_arlen : std_ulogic_vector(7 downto 0);
  SIGNAL oc_cfg0_axis_arsize : std_ulogic_vector(2 downto 0);
  SIGNAL oc_cfg0_axis_arburst : std_ulogic_vector(1 downto 0);
  SIGNAL oc_cfg0_axis_arlock : std_ulogic_vector(1 downto 0);
  SIGNAL oc_cfg0_axis_arcache : std_ulogic_vector(3 downto 0);
  SIGNAL oc_cfg0_axis_arprot : std_ulogic_vector(2 downto 0);
  SIGNAL oc_cfg0_axis_arvalid : std_ulogic;
  SIGNAL oc_cfg0_axis_arready : std_ulogic;
  SIGNAL oc_cfg0_axis_rid : std_ulogic_vector(6 downto 0);
  SIGNAL oc_cfg0_axis_rdata : std_ulogic_vector(31 downto 0);
  SIGNAL oc_cfg0_axis_rresp : std_ulogic_vector(1 downto 0);
  SIGNAL oc_cfg0_axis_rlast : std_ulogic;
  SIGNAL oc_cfg0_axis_rvalid : std_ulogic;
  SIGNAL oc_cfg0_axis_rready : std_ulogic;
  SIGNAL fbist_axis_aclk : std_ulogic;
  SIGNAL fbist_axis_aresetn : std_ulogic;
  SIGNAL fbist_axis_awvalid : std_ulogic;
  SIGNAL fbist_axis_awaddr : std_ulogic_vector(63 downto 0);
  SIGNAL fbist_axis_awprot : std_ulogic_vector(2 downto 0);
  SIGNAL fbist_axis_wvalid : std_ulogic;
  SIGNAL fbist_axis_wdata : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_axis_wstrb : std_ulogic_vector(3 downto 0);
  SIGNAL fbist_axis_bready : std_ulogic;
  SIGNAL fbist_axis_arvalid : std_ulogic;
  SIGNAL fbist_axis_araddr : std_ulogic_vector(63 downto 0);
  SIGNAL fbist_axis_arprot : std_ulogic_vector(2 downto 0);
  SIGNAL fbist_axis_rready : std_ulogic;
  SIGNAL fbist_axis_arready : std_ulogic;
  SIGNAL fbist_axis_awready : std_ulogic;
  SIGNAL fbist_axis_bresp : std_ulogic_vector(1 downto 0);
  SIGNAL fbist_axis_bvalid : std_ulogic;
  SIGNAL fbist_axis_rdata : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_axis_rresp : std_ulogic_vector(1 downto 0);
  SIGNAL fbist_axis_rvalid : std_ulogic;
  SIGNAL fbist_axis_wready : std_ulogic;
  SIGNAL oc_host_cfg0_axis_aclk : std_ulogic;
  SIGNAL oc_host_cfg0_axis_aresetn : std_ulogic;
  SIGNAL oc_host_cfg0_axis_awvalid : std_ulogic;
  SIGNAL oc_host_cfg0_axis_awaddr : std_ulogic_vector(63 downto 0);
  SIGNAL oc_host_cfg0_axis_awprot : std_ulogic_vector(2 downto 0);
  SIGNAL oc_host_cfg0_axis_wvalid : std_ulogic;
  SIGNAL oc_host_cfg0_axis_wdata : std_ulogic_vector(31 downto 0);
  SIGNAL oc_host_cfg0_axis_wstrb : std_ulogic_vector(3 downto 0);
  SIGNAL oc_host_cfg0_axis_bready : std_ulogic;
  SIGNAL oc_host_cfg0_axis_arvalid : std_ulogic;
  SIGNAL oc_host_cfg0_axis_araddr : std_ulogic_vector(63 downto 0);
  SIGNAL oc_host_cfg0_axis_arprot : std_ulogic_vector(2 downto 0);
  SIGNAL oc_host_cfg0_axis_rready : std_ulogic;
  SIGNAL oc_host_cfg0_axis_arready : std_ulogic;
  SIGNAL oc_host_cfg0_axis_awready : std_ulogic;
  SIGNAL oc_host_cfg0_axis_bresp : std_ulogic_vector(1 downto 0);
  SIGNAL oc_host_cfg0_axis_bvalid : std_ulogic;
  SIGNAL oc_host_cfg0_axis_rdata : std_ulogic_vector(31 downto 0);
  SIGNAL oc_host_cfg0_axis_rresp : std_ulogic_vector(1 downto 0);
  SIGNAL oc_host_cfg0_axis_rvalid : std_ulogic;
  SIGNAL oc_host_cfg0_axis_wready : std_ulogic;

begin

  -----------------------------------------------------------------------------
  -- Clocking
  -----------------------------------------------------------------------------
  opt_gckn               <= NOT td_oscillator(16, 8, 0);
  opt_gckn_4x            <= NOT td_oscillator(64, 32, 0);  -- 4x the period, not the frequency
  reset                  <= '0';
  gnd                    <= Tconv('0');
  vdd                    <= Tconv('1');
  gck                    <= opt_gckn;
  pclk                   <= opt_gckn_4x;
  async_resetb           <= not reset;
  sw_reset               <= '0';
  sw_reset_clock_divider <= '0';

  -----------------------------------------------------------------------------
  -- Transceiver Reset Signals
  -----------------------------------------------------------------------------
  fire0_gtwiz_done    <= '0';
  phy_dlx_init_done_0 <= '0';
  phy_dlx_init_done_1 <= '0';
  phy_dlx_init_done_2 <= '0';
  phy_dlx_init_done_3 <= '0';
  phy_dlx_init_done_4 <= '0';
  phy_dlx_init_done_5 <= '0';
  phy_dlx_init_done_6 <= '0';
  phy_dlx_init_done_7 <= '0';

  -----------------------------------------------------------------------------
  -- AXI Registers
  -----------------------------------------------------------------------------
  oc_memory0_axis_aclk    <= NOT td_oscillator(12, 6, 0);
  oc_memory0_axis_aresetn <= NOT reset;
  oc_memory0_axis_awid    <= (others => '0');
  oc_memory0_axis_awaddr  <= (others => '0');
  oc_memory0_axis_awlen   <= (others => '0');
  oc_memory0_axis_awsize  <= (others => '0');
  oc_memory0_axis_awburst <= (others => '0');
  oc_memory0_axis_awlock  <= (others => '0');
  oc_memory0_axis_awcache <= (others => '0');
  oc_memory0_axis_awprot  <= (others => '0');
  oc_memory0_axis_awvalid <= '0';
  oc_memory0_axis_wid     <= (others => '0');
  oc_memory0_axis_wdata   <= (others => '0');
  oc_memory0_axis_wstrb   <= (others => '0');
  oc_memory0_axis_wlast   <= '0';
  oc_memory0_axis_wvalid  <= '0';
  oc_memory0_axis_bready  <= '0';
  oc_memory0_axis_arid    <= (others => '0');
  oc_memory0_axis_araddr  <= (others => '0');
  oc_memory0_axis_arlen   <= (others => '0');
  oc_memory0_axis_arsize  <= (others => '0');
  oc_memory0_axis_arburst <= (others => '0');
  oc_memory0_axis_arlock  <= (others => '0');
  oc_memory0_axis_arcache <= (others => '0');
  oc_memory0_axis_arprot  <= (others => '0');
  oc_memory0_axis_arvalid <= '0';
  oc_memory0_axis_rready  <= '0';

  oc_mmio0_axis_aclk    <= NOT td_oscillator(12, 6, 0);
  oc_mmio0_axis_aresetn <= NOT reset;
  oc_mmio0_axis_awid    <= (others => '0');
  oc_mmio0_axis_awaddr  <= (others => '0');
  oc_mmio0_axis_awlen   <= (others => '0');
  oc_mmio0_axis_awsize  <= (others => '0');
  oc_mmio0_axis_awburst <= (others => '0');
  oc_mmio0_axis_awlock  <= (others => '0');
  oc_mmio0_axis_awcache <= (others => '0');
  oc_mmio0_axis_awprot  <= (others => '0');
  oc_mmio0_axis_awvalid <= '0';
  oc_mmio0_axis_wid     <= (others => '0');
  oc_mmio0_axis_wdata   <= (others => '0');
  oc_mmio0_axis_wstrb   <= (others => '0');
  oc_mmio0_axis_wlast   <= '0';
  oc_mmio0_axis_wvalid  <= '0';
  oc_mmio0_axis_bready  <= '0';
  oc_mmio0_axis_arid    <= (others => '0');
  oc_mmio0_axis_araddr  <= (others => '0');
  oc_mmio0_axis_arlen   <= (others => '0');
  oc_mmio0_axis_arsize  <= (others => '0');
  oc_mmio0_axis_arburst <= (others => '0');
  oc_mmio0_axis_arlock  <= (others => '0');
  oc_mmio0_axis_arcache <= (others => '0');
  oc_mmio0_axis_arprot  <= (others => '0');
  oc_mmio0_axis_arvalid <= '0';
  oc_mmio0_axis_rready  <= '0';

  oc_cfg0_axis_aclk    <= NOT td_oscillator(12, 6, 0);
  oc_cfg0_axis_aresetn <= NOT reset;
  oc_cfg0_axis_awid    <= (others => '0');
  oc_cfg0_axis_awaddr  <= (others => '0');
  oc_cfg0_axis_awlen   <= (others => '0');
  oc_cfg0_axis_awsize  <= (others => '0');
  oc_cfg0_axis_awburst <= (others => '0');
  oc_cfg0_axis_awlock  <= (others => '0');
  oc_cfg0_axis_awcache <= (others => '0');
  oc_cfg0_axis_awprot  <= (others => '0');
  oc_cfg0_axis_awvalid <= '0';
  oc_cfg0_axis_wid     <= (others => '0');
  oc_cfg0_axis_wdata   <= (others => '0');
  oc_cfg0_axis_wstrb   <= (others => '0');
  oc_cfg0_axis_wlast   <= '0';
  oc_cfg0_axis_wvalid  <= '0';
  oc_cfg0_axis_bready  <= '0';
  oc_cfg0_axis_arid    <= (others => '0');
  oc_cfg0_axis_araddr  <= (others => '0');
  oc_cfg0_axis_arlen   <= (others => '0');
  oc_cfg0_axis_arsize  <= (others => '0');
  oc_cfg0_axis_arburst <= (others => '0');
  oc_cfg0_axis_arlock  <= (others => '0');
  oc_cfg0_axis_arcache <= (others => '0');
  oc_cfg0_axis_arprot  <= (others => '0');
  oc_cfg0_axis_arvalid <= '0';
  oc_cfg0_axis_rready  <= '0';

  c3s_dlx0_axis_aclk                <= NOT td_oscillator(12, 6, 0);
  c3s_dlx0_axis_aresetn             <= NOT reset;
  c3s_dlx0_axis_awvalid             <= '0';
  c3s_dlx0_axis_awaddr(63 downto 0) <= (others => '0');
  c3s_dlx0_axis_awprot(2 downto 0)  <= (others => '0');
  c3s_dlx0_axis_wvalid              <= '0';
  c3s_dlx0_axis_wdata(31 downto 0)  <= (others => '0');
  c3s_dlx0_axis_wstrb(3 downto 0)   <= (others => '0');
  c3s_dlx0_axis_bready              <= '0';
  c3s_dlx0_axis_arvalid             <= '0';
  c3s_dlx0_axis_araddr(63 downto 0) <= (others => '0');
  c3s_dlx0_axis_arprot(2 downto 0)  <= (others => '0');
  c3s_dlx0_axis_rready              <= '0';

  fbist_axis_aclk                <= NOT td_oscillator(12, 6, 0);
  fbist_axis_aresetn             <= NOT reset;
  fbist_axis_awvalid             <= '0';
  fbist_axis_awaddr(63 downto 0) <= (others => '0');
  fbist_axis_awprot(2 downto 0)  <= (others => '0');
  fbist_axis_wvalid              <= '0';
  fbist_axis_wdata(31 downto 0)  <= (others => '0');
  fbist_axis_wstrb(3 downto 0)   <= (others => '0');
  fbist_axis_bready              <= '0';
  fbist_axis_arvalid             <= '0';
  fbist_axis_araddr(63 downto 0) <= (others => '0');
  fbist_axis_arprot(2 downto 0)  <= (others => '0');
  fbist_axis_rready              <= '0';

  oc_host_cfg0_axis_aclk                <= NOT td_oscillator(12, 6, 0);
  oc_host_cfg0_axis_aresetn             <= NOT reset;
  oc_host_cfg0_axis_awvalid             <= '0';
  oc_host_cfg0_axis_awaddr(63 downto 0) <= (others => '0');
  oc_host_cfg0_axis_awprot(2 downto 0)  <= (others => '0');
  oc_host_cfg0_axis_wvalid              <= '0';
  oc_host_cfg0_axis_wdata(31 downto 0)  <= (others => '0');
  oc_host_cfg0_axis_wstrb(3 downto 0)   <= (others => '0');
  oc_host_cfg0_axis_bready              <= '0';
  oc_host_cfg0_axis_arvalid             <= '0';
  oc_host_cfg0_axis_araddr(63 downto 0) <= (others => '0');
  oc_host_cfg0_axis_arprot(2 downto 0)  <= (others => '0');
  oc_host_cfg0_axis_rready              <= '0';

  -----------------------------------------------------------------------------
  -- OCMB Pins
  -----------------------------------------------------------------------------
  fuse_enterprise_dis                    <= '0';
  scanb                                  <= '1';
  testclk_selb                           <= '1';
  scan_en_o                              <= '0';
  test_clk_1                             <= '0';
  pib2gif_saccept                        <= '0';
  pib2gif_sdata(31 downto 0)             <= (others => '0');
  pib2gif_sid(4 downto 0)                <= (others => '0');
  pib2gif_slast                          <= '0';
  pib2gif_sresp(2 downto 0)              <= (others => '0');
  pib2gif_srsideband                     <= (others => '0');
  pib2gif_svalid                         <= '0';
  gif2pcb_maddr(31 downto 0)             <= (others => '0');
  gif2pcb_masideband                     <= '0';
  gif2pcb_mburst(1 downto 0)             <= (others => '0');
  gif2pcb_mdata(31 downto 0)             <= (others => '0');
  gif2pcb_mlast                          <= '0';
  gif2pcb_mlen(3 downto 0)               <= (others => '0');
  gif2pcb_mread                          <= '0';
  gif2pcb_mready                         <= '0';
  gif2pcb_msize(2 downto 0)              <= (others => '0');
  gif2pcb_mwrite                         <= '0';
  gif2pcb_mwsideband                     <= (others => '0');
  gif2pcb_mwstrb(3 downto 0)             <= (others => '0');
  gpbc_to_mb_top_error_info(52 downto 0) <= (others => '0');
  phy_dlx_clock_0                        <= opt_gckn_4x;
  phy_dlx_clock_1                        <= opt_gckn_4x;
  phy_dlx_clock_2                        <= opt_gckn_4x;
  phy_dlx_clock_3                        <= opt_gckn_4x;
  phy_dlx_clock_4                        <= opt_gckn_4x;
  phy_dlx_clock_5                        <= opt_gckn_4x;
  phy_dlx_clock_6                        <= opt_gckn_4x;
  phy_dlx_clock_7                        <= opt_gckn_4x;
  phy_dlx_recal_done_0                   <= '0';
  phy_dlx_recal_done_1                   <= '0';
  phy_dlx_recal_done_2                   <= '0';
  phy_dlx_recal_done_3                   <= '0';
  phy_dlx_recal_done_4                   <= '0';
  phy_dlx_recal_done_5                   <= '0';
  phy_dlx_recal_done_6                   <= '0';
  phy_dlx_recal_done_7                   <= '0';
  phy_dlx_rx_psave_sts_0                 <= '0';
  phy_dlx_rx_psave_sts_1                 <= '0';
  phy_dlx_rx_psave_sts_2                 <= '0';
  phy_dlx_rx_psave_sts_3                 <= '0';
  phy_dlx_rx_psave_sts_4                 <= '0';
  phy_dlx_rx_psave_sts_5                 <= '0';
  phy_dlx_rx_psave_sts_6                 <= '0';
  phy_dlx_rx_psave_sts_7                 <= '0';
  phy_dlx_sideband                       <= (others => '0');
  phy_dlx_tx_psave_sts_0                 <= '0';
  phy_dlx_tx_psave_sts_1                 <= '0';
  phy_dlx_tx_psave_sts_2                 <= '0';
  phy_dlx_tx_psave_sts_3                 <= '0';
  phy_dlx_tx_psave_sts_4                 <= '0';
  phy_dlx_tx_psave_sts_5                 <= '0';
  phy_dlx_tx_psave_sts_6                 <= '0';
  phy_dlx_tx_psave_sts_7                 <= '0';
  dfi_rddata(0 to 159)                   <= (others => '0');
  dfi_rddata_valid(0 to 9)               <= (others => '0');
  dfi_ctrlupd_ack                        <= '0';
  dfi_alert_n                            <= '1';
  dfi_init_complete                      <= '0';
  dfi_lp_ack                             <= '0';
  dqbypass(0 to 79)                      <= (others => '0');
  c4_eventn                              <= '1';
  c4_epow                                <= '0';
  spare_output_acx4_a                    <= (others => '0');                                                         
  spare_output_acx4_b                    <= (others => '0');
  spare_output_dbyte                     <= (others => '0');
  spare_output_pub                       <= (others => '0');

  -----------------------------------------------------------------------------
  -- Lane Crossover
  -----------------------------------------------------------------------------
  phy_dlx1_lane_0(0 to 15) <= dlx0_phy_lane_0(0 to 15);
  phy_dlx1_lane_1(0 to 15) <= dlx0_phy_lane_1(0 to 15);
  phy_dlx1_lane_2(0 to 15) <= dlx0_phy_lane_2(0 to 15);
  phy_dlx1_lane_3(0 to 15) <= dlx0_phy_lane_3(0 to 15);
  phy_dlx1_lane_4(0 to 15) <= dlx0_phy_lane_4(0 to 15);
  phy_dlx1_lane_5(0 to 15) <= dlx0_phy_lane_5(0 to 15);
  phy_dlx1_lane_6(0 to 15) <= dlx0_phy_lane_6(0 to 15);
  phy_dlx1_lane_7(0 to 15) <= dlx0_phy_lane_7(0 to 15);
  phy_dlx0_lane_0(0 to 15) <= dlx1_phy_lane_0(0 to 15);
  phy_dlx0_lane_1(0 to 15) <= dlx1_phy_lane_1(0 to 15);
  phy_dlx0_lane_2(0 to 15) <= dlx1_phy_lane_2(0 to 15);
  phy_dlx0_lane_3(0 to 15) <= dlx1_phy_lane_3(0 to 15);
  phy_dlx0_lane_4(0 to 15) <= dlx1_phy_lane_4(0 to 15);
  phy_dlx0_lane_5(0 to 15) <= dlx1_phy_lane_5(0 to 15);
  phy_dlx0_lane_6(0 to 15) <= dlx1_phy_lane_6(0 to 15);
  phy_dlx0_lane_7(0 to 15) <= dlx1_phy_lane_7(0 to 15);

  -----------------------------------------------------------------------------
  -- Debug
  -----------------------------------------------------------------------------
  -- Let us see the entire flit with a valid at the OCMB DLX/TLX interface
  dbg_dlx_tlxr_partial_flit_cnt(1 downto 0) <= << signal MB_TOP.DLX.DLX.OMDL.orx.main.partial_flit_cnt_q : std_ulogic_vector(1 downto 0) >>;
  dbg_dlx_tlxr_flit_data(127 downto 0)      <= << signal MB_TOP.MB_SIM.DLX_TLXR_FLIT_DATA : std_ulogic_vector(127 downto 0) >>;
  dbg_dlx_tlxr_flit_vld                     <= << signal MB_TOP.MB_SIM.DLX_TLXR_FLIT_VLD : std_ulogic >>;
  dbg_dlx_tlxr_flit_error                   <= << signal MB_TOP.MB_SIM.DLX_TLXR_FLIT_ERROR : std_ulogic >>;
  dbg_dlx_tlxr_flit(511 downto 0)           <= dbg_dlx_tlxr_flit_data_n1 &
                                               dbg_dlx_tlxr_flit_data_n2 &
                                               dbg_dlx_tlxr_flit_data_n3 &
                                               dbg_dlx_tlxr_flit_data_n4;
  dbg_dlx_tlxr_flit_valid                   <= dbg_dlx_tlxr_flit_vld_n1 and not dbg_dlx_tlxr_flit_error and (dbg_dlx_tlxr_partial_flit_cnt(1) and dbg_dlx_tlxr_partial_flit_cnt(0));
  dbg_dlx_tlxr_flit_valid_full              <= dbg_dlx_tlxr_flit_valid or dbg_dlx_tlxr_flit_valid_n1 or dbg_dlx_tlxr_flit_valid_n2 or dbg_dlx_tlxr_flit_valid_n3;

  -- Hold the flit for 4 opt_gckn cycles so our monitor can see it
  latch_proc : process (opt_gckn)
  begin
    if opt_gckn'event and opt_gckn = '1' then
      dbg_dlx_tlxr_flit_data_n1(127 downto 0) <= dbg_dlx_tlxr_flit_data(127 downto 0);
      dbg_dlx_tlxr_flit_data_n2(127 downto 0) <= dbg_dlx_tlxr_flit_data_n1(127 downto 0);
      dbg_dlx_tlxr_flit_data_n3(127 downto 0) <= dbg_dlx_tlxr_flit_data_n2(127 downto 0);
      dbg_dlx_tlxr_flit_data_n4(127 downto 0) <= dbg_dlx_tlxr_flit_data_n3(127 downto 0);
      dbg_dlx_tlxr_flit_vld_n1                <= dbg_dlx_tlxr_flit_vld;
      dbg_dlx_tlxr_flit_valid_n1              <= dbg_dlx_tlxr_flit_valid;
      dbg_dlx_tlxr_flit_valid_n2              <= dbg_dlx_tlxr_flit_valid_n1;
      dbg_dlx_tlxr_flit_valid_n3              <= dbg_dlx_tlxr_flit_valid_n2;
    end if;
    -- Latch data when cnt = 3
    if dbg_dlx_tlxr_partial_flit_cnt(1) and dbg_dlx_tlxr_partial_flit_cnt(0) then
      dbg_dlx_tlxr_flit_full(511 downto 0) <= dbg_dlx_tlxr_flit(511 downto 0);
    end if;
  end process;

fire0 : entity work.fire_emulate
port map (
    c3s_dlx0_axis_aclk                     => c3s_dlx0_axis_aclk                    , -- MSR: fire_emulate(fire0)
    c3s_dlx0_axis_araddr (63 downto 0)     => c3s_dlx0_axis_araddr (63 downto 0)    , -- MSR: fire_emulate(fire0)
    c3s_dlx0_axis_aresetn                  => c3s_dlx0_axis_aresetn                 , -- MSR: fire_emulate(fire0)
    c3s_dlx0_axis_arprot (2 downto 0)      => c3s_dlx0_axis_arprot (2 downto 0)     , -- MSR: fire_emulate(fire0)
    c3s_dlx0_axis_arready                  => c3s_dlx0_axis_arready                 , -- MSD: fire_emulate(fire0)
    c3s_dlx0_axis_arvalid                  => c3s_dlx0_axis_arvalid                 , -- MSR: fire_emulate(fire0)
    c3s_dlx0_axis_awaddr (63 downto 0)     => c3s_dlx0_axis_awaddr (63 downto 0)    , -- MSR: fire_emulate(fire0)
    c3s_dlx0_axis_awprot (2 downto 0)      => c3s_dlx0_axis_awprot (2 downto 0)     , -- MSR: fire_emulate(fire0)
    c3s_dlx0_axis_awready                  => c3s_dlx0_axis_awready                 , -- MSD: fire_emulate(fire0)
    c3s_dlx0_axis_awvalid                  => c3s_dlx0_axis_awvalid                 , -- MSR: fire_emulate(fire0)
    c3s_dlx0_axis_bready                   => c3s_dlx0_axis_bready                  , -- MSR: fire_emulate(fire0)
    c3s_dlx0_axis_bresp (1 downto 0)       => c3s_dlx0_axis_bresp (1 downto 0)      , -- MSD: fire_emulate(fire0)
    c3s_dlx0_axis_bvalid                   => c3s_dlx0_axis_bvalid                  , -- MSD: fire_emulate(fire0)
    c3s_dlx0_axis_rdata (31 downto 0)      => c3s_dlx0_axis_rdata (31 downto 0)     , -- MSD: fire_emulate(fire0)
    c3s_dlx0_axis_rready                   => c3s_dlx0_axis_rready                  , -- MSR: fire_emulate(fire0)
    c3s_dlx0_axis_rresp (1 downto 0)       => c3s_dlx0_axis_rresp (1 downto 0)      , -- MSD: fire_emulate(fire0)
    c3s_dlx0_axis_rvalid                   => c3s_dlx0_axis_rvalid                  , -- MSD: fire_emulate(fire0)
    c3s_dlx0_axis_wdata (31 downto 0)      => c3s_dlx0_axis_wdata (31 downto 0)     , -- MSR: fire_emulate(fire0)
    c3s_dlx0_axis_wready                   => c3s_dlx0_axis_wready                  , -- MSD: fire_emulate(fire0)
    c3s_dlx0_axis_wstrb (3 downto 0)       => c3s_dlx0_axis_wstrb (3 downto 0)      , -- MSR: fire_emulate(fire0)
    c3s_dlx0_axis_wvalid                   => c3s_dlx0_axis_wvalid                  , -- MSR: fire_emulate(fire0)
    dlx0_phy_lane_0 (0 to 15)              => dlx0_phy_lane_0 (0 to 15)             , -- MSD: fire_emulate(fire0)
    dlx0_phy_lane_1 (0 to 15)              => dlx0_phy_lane_1 (0 to 15)             , -- MSD: fire_emulate(fire0)
    dlx0_phy_lane_2 (0 to 15)              => dlx0_phy_lane_2 (0 to 15)             , -- MSD: fire_emulate(fire0)
    dlx0_phy_lane_3 (0 to 15)              => dlx0_phy_lane_3 (0 to 15)             , -- MSD: fire_emulate(fire0)
    dlx0_phy_lane_4 (0 to 15)              => dlx0_phy_lane_4 (0 to 15)             , -- MSD: fire_emulate(fire0)
    dlx0_phy_lane_5 (0 to 15)              => dlx0_phy_lane_5 (0 to 15)             , -- MSD: fire_emulate(fire0)
    dlx0_phy_lane_6 (0 to 15)              => dlx0_phy_lane_6 (0 to 15)             , -- MSD: fire_emulate(fire0)
    dlx0_phy_lane_7 (0 to 15)              => dlx0_phy_lane_7 (0 to 15)             , -- MSD: fire_emulate(fire0)
    fbist_axis_aclk                        => fbist_axis_aclk                       , -- MSR: fire_emulate(fire0)
    fbist_axis_araddr (63 downto 0)        => fbist_axis_araddr (63 downto 0)       , -- MSR: fire_emulate(fire0)
    fbist_axis_aresetn                     => fbist_axis_aresetn                    , -- MSR: fire_emulate(fire0)
    fbist_axis_arprot (2 downto 0)         => fbist_axis_arprot (2 downto 0)        , -- MSR: fire_emulate(fire0)
    fbist_axis_arready                     => fbist_axis_arready                    , -- MSD: fire_emulate(fire0)
    fbist_axis_arvalid                     => fbist_axis_arvalid                    , -- MSR: fire_emulate(fire0)
    fbist_axis_awaddr (63 downto 0)        => fbist_axis_awaddr (63 downto 0)       , -- MSR: fire_emulate(fire0)
    fbist_axis_awprot (2 downto 0)         => fbist_axis_awprot (2 downto 0)        , -- MSR: fire_emulate(fire0)
    fbist_axis_awready                     => fbist_axis_awready                    , -- MSD: fire_emulate(fire0)
    fbist_axis_awvalid                     => fbist_axis_awvalid                    , -- MSR: fire_emulate(fire0)
    fbist_axis_bready                      => fbist_axis_bready                     , -- MSR: fire_emulate(fire0)
    fbist_axis_bresp (1 downto 0)          => fbist_axis_bresp (1 downto 0)         , -- MSD: fire_emulate(fire0)
    fbist_axis_bvalid                      => fbist_axis_bvalid                     , -- MSD: fire_emulate(fire0)
    fbist_axis_rdata (31 downto 0)         => fbist_axis_rdata (31 downto 0)        , -- MSD: fire_emulate(fire0)
    fbist_axis_rready                      => fbist_axis_rready                     , -- MSR: fire_emulate(fire0)
    fbist_axis_rresp (1 downto 0)          => fbist_axis_rresp (1 downto 0)         , -- MSD: fire_emulate(fire0)
    fbist_axis_rvalid                      => fbist_axis_rvalid                     , -- MSD: fire_emulate(fire0)
    fbist_axis_wdata (31 downto 0)         => fbist_axis_wdata (31 downto 0)        , -- MSR: fire_emulate(fire0)
    fbist_axis_wready                      => fbist_axis_wready                     , -- MSD: fire_emulate(fire0)
    fbist_axis_wstrb (3 downto 0)          => fbist_axis_wstrb (3 downto 0)         , -- MSR: fire_emulate(fire0)
    fbist_axis_wvalid                      => fbist_axis_wvalid                     , -- MSR: fire_emulate(fire0)
    gtwiz_done                             => fire0_gtwiz_done                      , -- OVR: fire_emulate(fire0)
    oc_cfg0_axis_aclk                      => oc_cfg0_axis_aclk                     , -- MSR: fire_emulate(fire0)
    oc_cfg0_axis_araddr (63 downto 0)      => oc_cfg0_axis_araddr (63 downto 0)     , -- MSR: fire_emulate(fire0)
    oc_cfg0_axis_arburst (1 downto 0)      => oc_cfg0_axis_arburst (1 downto 0)     , -- MSR: fire_emulate(fire0)
    oc_cfg0_axis_arcache (3 downto 0)      => oc_cfg0_axis_arcache (3 downto 0)     , -- MSR: fire_emulate(fire0)
    oc_cfg0_axis_aresetn                   => oc_cfg0_axis_aresetn                  , -- MSR: fire_emulate(fire0)
    oc_cfg0_axis_arid (6 downto 0)         => oc_cfg0_axis_arid (6 downto 0)        , -- MSR: fire_emulate(fire0)
    oc_cfg0_axis_arlen (7 downto 0)        => oc_cfg0_axis_arlen (7 downto 0)       , -- MSR: fire_emulate(fire0)
    oc_cfg0_axis_arlock (1 downto 0)       => oc_cfg0_axis_arlock (1 downto 0)      , -- MSR: fire_emulate(fire0)
    oc_cfg0_axis_arprot (2 downto 0)       => oc_cfg0_axis_arprot (2 downto 0)      , -- MSR: fire_emulate(fire0)
    oc_cfg0_axis_arready                   => oc_cfg0_axis_arready                  , -- MSD: fire_emulate(fire0)
    oc_cfg0_axis_arsize (2 downto 0)       => oc_cfg0_axis_arsize (2 downto 0)      , -- MSR: fire_emulate(fire0)
    oc_cfg0_axis_arvalid                   => oc_cfg0_axis_arvalid                  , -- MSR: fire_emulate(fire0)
    oc_cfg0_axis_awaddr (63 downto 0)      => oc_cfg0_axis_awaddr (63 downto 0)     , -- MSR: fire_emulate(fire0)
    oc_cfg0_axis_awburst (1 downto 0)      => oc_cfg0_axis_awburst (1 downto 0)     , -- MSR: fire_emulate(fire0)
    oc_cfg0_axis_awcache (3 downto 0)      => oc_cfg0_axis_awcache (3 downto 0)     , -- MSR: fire_emulate(fire0)
    oc_cfg0_axis_awid (6 downto 0)         => oc_cfg0_axis_awid (6 downto 0)        , -- MSR: fire_emulate(fire0)
    oc_cfg0_axis_awlen (7 downto 0)        => oc_cfg0_axis_awlen (7 downto 0)       , -- MSR: fire_emulate(fire0)
    oc_cfg0_axis_awlock (1 downto 0)       => oc_cfg0_axis_awlock (1 downto 0)      , -- MSR: fire_emulate(fire0)
    oc_cfg0_axis_awprot (2 downto 0)       => oc_cfg0_axis_awprot (2 downto 0)      , -- MSR: fire_emulate(fire0)
    oc_cfg0_axis_awready                   => oc_cfg0_axis_awready                  , -- MSD: fire_emulate(fire0)
    oc_cfg0_axis_awsize (2 downto 0)       => oc_cfg0_axis_awsize (2 downto 0)      , -- MSR: fire_emulate(fire0)
    oc_cfg0_axis_awvalid                   => oc_cfg0_axis_awvalid                  , -- MSR: fire_emulate(fire0)
    oc_cfg0_axis_bid (6 downto 0)          => oc_cfg0_axis_bid (6 downto 0)         , -- MSD: fire_emulate(fire0)
    oc_cfg0_axis_bready                    => oc_cfg0_axis_bready                   , -- MSR: fire_emulate(fire0)
    oc_cfg0_axis_bresp (1 downto 0)        => oc_cfg0_axis_bresp (1 downto 0)       , -- MSD: fire_emulate(fire0)
    oc_cfg0_axis_bvalid                    => oc_cfg0_axis_bvalid                   , -- MSD: fire_emulate(fire0)
    oc_cfg0_axis_rdata (31 downto 0)       => oc_cfg0_axis_rdata (31 downto 0)      , -- MSD: fire_emulate(fire0)
    oc_cfg0_axis_rid (6 downto 0)          => oc_cfg0_axis_rid (6 downto 0)         , -- MSD: fire_emulate(fire0)
    oc_cfg0_axis_rlast                     => oc_cfg0_axis_rlast                    , -- MSD: fire_emulate(fire0)
    oc_cfg0_axis_rready                    => oc_cfg0_axis_rready                   , -- MSR: fire_emulate(fire0)
    oc_cfg0_axis_rresp (1 downto 0)        => oc_cfg0_axis_rresp (1 downto 0)       , -- MSD: fire_emulate(fire0)
    oc_cfg0_axis_rvalid                    => oc_cfg0_axis_rvalid                   , -- MSD: fire_emulate(fire0)
    oc_cfg0_axis_wdata (31 downto 0)       => oc_cfg0_axis_wdata (31 downto 0)      , -- MSR: fire_emulate(fire0)
    oc_cfg0_axis_wid (6 downto 0)          => oc_cfg0_axis_wid (6 downto 0)         , -- MSR: fire_emulate(fire0)
    oc_cfg0_axis_wlast                     => oc_cfg0_axis_wlast                    , -- MSR: fire_emulate(fire0)
    oc_cfg0_axis_wready                    => oc_cfg0_axis_wready                   , -- MSD: fire_emulate(fire0)
    oc_cfg0_axis_wstrb (3 downto 0)        => oc_cfg0_axis_wstrb (3 downto 0)       , -- MSR: fire_emulate(fire0)
    oc_cfg0_axis_wvalid                    => oc_cfg0_axis_wvalid                   , -- MSR: fire_emulate(fire0)
    oc_host_cfg0_axis_aclk                 => oc_host_cfg0_axis_aclk                , -- MSR: fire_emulate(fire0)
    oc_host_cfg0_axis_araddr (63 downto 0) => oc_host_cfg0_axis_araddr (63 downto 0), -- MSR: fire_emulate(fire0)
    oc_host_cfg0_axis_aresetn              => oc_host_cfg0_axis_aresetn             , -- MSR: fire_emulate(fire0)
    oc_host_cfg0_axis_arprot (2 downto 0)  => oc_host_cfg0_axis_arprot (2 downto 0) , -- MSR: fire_emulate(fire0)
    oc_host_cfg0_axis_arready              => oc_host_cfg0_axis_arready             , -- MSD: fire_emulate(fire0)
    oc_host_cfg0_axis_arvalid              => oc_host_cfg0_axis_arvalid             , -- MSR: fire_emulate(fire0)
    oc_host_cfg0_axis_awaddr (63 downto 0) => oc_host_cfg0_axis_awaddr (63 downto 0), -- MSR: fire_emulate(fire0)
    oc_host_cfg0_axis_awprot (2 downto 0)  => oc_host_cfg0_axis_awprot (2 downto 0) , -- MSR: fire_emulate(fire0)
    oc_host_cfg0_axis_awready              => oc_host_cfg0_axis_awready             , -- MSD: fire_emulate(fire0)
    oc_host_cfg0_axis_awvalid              => oc_host_cfg0_axis_awvalid             , -- MSR: fire_emulate(fire0)
    oc_host_cfg0_axis_bready               => oc_host_cfg0_axis_bready              , -- MSR: fire_emulate(fire0)
    oc_host_cfg0_axis_bresp (1 downto 0)   => oc_host_cfg0_axis_bresp (1 downto 0)  , -- MSD: fire_emulate(fire0)
    oc_host_cfg0_axis_bvalid               => oc_host_cfg0_axis_bvalid              , -- MSD: fire_emulate(fire0)
    oc_host_cfg0_axis_rdata (31 downto 0)  => oc_host_cfg0_axis_rdata (31 downto 0) , -- MSD: fire_emulate(fire0)
    oc_host_cfg0_axis_rready               => oc_host_cfg0_axis_rready              , -- MSR: fire_emulate(fire0)
    oc_host_cfg0_axis_rresp (1 downto 0)   => oc_host_cfg0_axis_rresp (1 downto 0)  , -- MSD: fire_emulate(fire0)
    oc_host_cfg0_axis_rvalid               => oc_host_cfg0_axis_rvalid              , -- MSD: fire_emulate(fire0)
    oc_host_cfg0_axis_wdata (31 downto 0)  => oc_host_cfg0_axis_wdata (31 downto 0) , -- MSR: fire_emulate(fire0)
    oc_host_cfg0_axis_wready               => oc_host_cfg0_axis_wready              , -- MSD: fire_emulate(fire0)
    oc_host_cfg0_axis_wstrb (3 downto 0)   => oc_host_cfg0_axis_wstrb (3 downto 0)  , -- MSR: fire_emulate(fire0)
    oc_host_cfg0_axis_wvalid               => oc_host_cfg0_axis_wvalid              , -- MSR: fire_emulate(fire0)
    oc_memory0_axis_aclk                   => oc_memory0_axis_aclk                  , -- MSR: fire_emulate(fire0)
    oc_memory0_axis_araddr (63 downto 0)   => oc_memory0_axis_araddr (63 downto 0)  , -- MSR: fire_emulate(fire0)
    oc_memory0_axis_arburst (1 downto 0)   => oc_memory0_axis_arburst (1 downto 0)  , -- MSR: fire_emulate(fire0)
    oc_memory0_axis_arcache (3 downto 0)   => oc_memory0_axis_arcache (3 downto 0)  , -- MSR: fire_emulate(fire0)
    oc_memory0_axis_aresetn                => oc_memory0_axis_aresetn               , -- MSR: fire_emulate(fire0)
    oc_memory0_axis_arid (6 downto 0)      => oc_memory0_axis_arid (6 downto 0)     , -- MSR: fire_emulate(fire0)
    oc_memory0_axis_arlen (7 downto 0)     => oc_memory0_axis_arlen (7 downto 0)    , -- MSR: fire_emulate(fire0)
    oc_memory0_axis_arlock (1 downto 0)    => oc_memory0_axis_arlock (1 downto 0)   , -- MSR: fire_emulate(fire0)
    oc_memory0_axis_arprot (2 downto 0)    => oc_memory0_axis_arprot (2 downto 0)   , -- MSR: fire_emulate(fire0)
    oc_memory0_axis_arready                => oc_memory0_axis_arready               , -- MSD: fire_emulate(fire0)
    oc_memory0_axis_arsize (2 downto 0)    => oc_memory0_axis_arsize (2 downto 0)   , -- MSR: fire_emulate(fire0)
    oc_memory0_axis_arvalid                => oc_memory0_axis_arvalid               , -- MSR: fire_emulate(fire0)
    oc_memory0_axis_awaddr (63 downto 0)   => oc_memory0_axis_awaddr (63 downto 0)  , -- MSR: fire_emulate(fire0)
    oc_memory0_axis_awburst (1 downto 0)   => oc_memory0_axis_awburst (1 downto 0)  , -- MSR: fire_emulate(fire0)
    oc_memory0_axis_awcache (3 downto 0)   => oc_memory0_axis_awcache (3 downto 0)  , -- MSR: fire_emulate(fire0)
    oc_memory0_axis_awid (6 downto 0)      => oc_memory0_axis_awid (6 downto 0)     , -- MSR: fire_emulate(fire0)
    oc_memory0_axis_awlen (7 downto 0)     => oc_memory0_axis_awlen (7 downto 0)    , -- MSR: fire_emulate(fire0)
    oc_memory0_axis_awlock (1 downto 0)    => oc_memory0_axis_awlock (1 downto 0)   , -- MSR: fire_emulate(fire0)
    oc_memory0_axis_awprot (2 downto 0)    => oc_memory0_axis_awprot (2 downto 0)   , -- MSR: fire_emulate(fire0)
    oc_memory0_axis_awready                => oc_memory0_axis_awready               , -- MSD: fire_emulate(fire0)
    oc_memory0_axis_awsize (2 downto 0)    => oc_memory0_axis_awsize (2 downto 0)   , -- MSR: fire_emulate(fire0)
    oc_memory0_axis_awvalid                => oc_memory0_axis_awvalid               , -- MSR: fire_emulate(fire0)
    oc_memory0_axis_bid (6 downto 0)       => oc_memory0_axis_bid (6 downto 0)      , -- MSD: fire_emulate(fire0)
    oc_memory0_axis_bready                 => oc_memory0_axis_bready                , -- MSR: fire_emulate(fire0)
    oc_memory0_axis_bresp (1 downto 0)     => oc_memory0_axis_bresp (1 downto 0)    , -- MSD: fire_emulate(fire0)
    oc_memory0_axis_bvalid                 => oc_memory0_axis_bvalid                , -- MSD: fire_emulate(fire0)
    oc_memory0_axis_rdata (31 downto 0)    => oc_memory0_axis_rdata (31 downto 0)   , -- MSD: fire_emulate(fire0)
    oc_memory0_axis_rid (6 downto 0)       => oc_memory0_axis_rid (6 downto 0)      , -- MSD: fire_emulate(fire0)
    oc_memory0_axis_rlast                  => oc_memory0_axis_rlast                 , -- MSD: fire_emulate(fire0)
    oc_memory0_axis_rready                 => oc_memory0_axis_rready                , -- MSR: fire_emulate(fire0)
    oc_memory0_axis_rresp (1 downto 0)     => oc_memory0_axis_rresp (1 downto 0)    , -- MSD: fire_emulate(fire0)
    oc_memory0_axis_rvalid                 => oc_memory0_axis_rvalid                , -- MSD: fire_emulate(fire0)
    oc_memory0_axis_wdata (31 downto 0)    => oc_memory0_axis_wdata (31 downto 0)   , -- MSR: fire_emulate(fire0)
    oc_memory0_axis_wid (6 downto 0)       => oc_memory0_axis_wid (6 downto 0)      , -- MSR: fire_emulate(fire0)
    oc_memory0_axis_wlast                  => oc_memory0_axis_wlast                 , -- MSR: fire_emulate(fire0)
    oc_memory0_axis_wready                 => oc_memory0_axis_wready                , -- MSD: fire_emulate(fire0)
    oc_memory0_axis_wstrb (3 downto 0)     => oc_memory0_axis_wstrb (3 downto 0)    , -- MSR: fire_emulate(fire0)
    oc_memory0_axis_wvalid                 => oc_memory0_axis_wvalid                , -- MSR: fire_emulate(fire0)
    oc_mmio0_axis_aclk                     => oc_mmio0_axis_aclk                    , -- MSR: fire_emulate(fire0)
    oc_mmio0_axis_araddr (63 downto 0)     => oc_mmio0_axis_araddr (63 downto 0)    , -- MSR: fire_emulate(fire0)
    oc_mmio0_axis_arburst (1 downto 0)     => oc_mmio0_axis_arburst (1 downto 0)    , -- MSR: fire_emulate(fire0)
    oc_mmio0_axis_arcache (3 downto 0)     => oc_mmio0_axis_arcache (3 downto 0)    , -- MSR: fire_emulate(fire0)
    oc_mmio0_axis_aresetn                  => oc_mmio0_axis_aresetn                 , -- MSR: fire_emulate(fire0)
    oc_mmio0_axis_arid (6 downto 0)        => oc_mmio0_axis_arid (6 downto 0)       , -- MSR: fire_emulate(fire0)
    oc_mmio0_axis_arlen (7 downto 0)       => oc_mmio0_axis_arlen (7 downto 0)      , -- MSR: fire_emulate(fire0)
    oc_mmio0_axis_arlock (1 downto 0)      => oc_mmio0_axis_arlock (1 downto 0)     , -- MSR: fire_emulate(fire0)
    oc_mmio0_axis_arprot (2 downto 0)      => oc_mmio0_axis_arprot (2 downto 0)     , -- MSR: fire_emulate(fire0)
    oc_mmio0_axis_arready                  => oc_mmio0_axis_arready                 , -- MSD: fire_emulate(fire0)
    oc_mmio0_axis_arsize (2 downto 0)      => oc_mmio0_axis_arsize (2 downto 0)     , -- MSR: fire_emulate(fire0)
    oc_mmio0_axis_arvalid                  => oc_mmio0_axis_arvalid                 , -- MSR: fire_emulate(fire0)
    oc_mmio0_axis_awaddr (63 downto 0)     => oc_mmio0_axis_awaddr (63 downto 0)    , -- MSR: fire_emulate(fire0)
    oc_mmio0_axis_awburst (1 downto 0)     => oc_mmio0_axis_awburst (1 downto 0)    , -- MSR: fire_emulate(fire0)
    oc_mmio0_axis_awcache (3 downto 0)     => oc_mmio0_axis_awcache (3 downto 0)    , -- MSR: fire_emulate(fire0)
    oc_mmio0_axis_awid (6 downto 0)        => oc_mmio0_axis_awid (6 downto 0)       , -- MSR: fire_emulate(fire0)
    oc_mmio0_axis_awlen (7 downto 0)       => oc_mmio0_axis_awlen (7 downto 0)      , -- MSR: fire_emulate(fire0)
    oc_mmio0_axis_awlock (1 downto 0)      => oc_mmio0_axis_awlock (1 downto 0)     , -- MSR: fire_emulate(fire0)
    oc_mmio0_axis_awprot (2 downto 0)      => oc_mmio0_axis_awprot (2 downto 0)     , -- MSR: fire_emulate(fire0)
    oc_mmio0_axis_awready                  => oc_mmio0_axis_awready                 , -- MSD: fire_emulate(fire0)
    oc_mmio0_axis_awsize (2 downto 0)      => oc_mmio0_axis_awsize (2 downto 0)     , -- MSR: fire_emulate(fire0)
    oc_mmio0_axis_awvalid                  => oc_mmio0_axis_awvalid                 , -- MSR: fire_emulate(fire0)
    oc_mmio0_axis_bid (6 downto 0)         => oc_mmio0_axis_bid (6 downto 0)        , -- MSD: fire_emulate(fire0)
    oc_mmio0_axis_bready                   => oc_mmio0_axis_bready                  , -- MSR: fire_emulate(fire0)
    oc_mmio0_axis_bresp (1 downto 0)       => oc_mmio0_axis_bresp (1 downto 0)      , -- MSD: fire_emulate(fire0)
    oc_mmio0_axis_bvalid                   => oc_mmio0_axis_bvalid                  , -- MSD: fire_emulate(fire0)
    oc_mmio0_axis_rdata (31 downto 0)      => oc_mmio0_axis_rdata (31 downto 0)     , -- MSD: fire_emulate(fire0)
    oc_mmio0_axis_rid (6 downto 0)         => oc_mmio0_axis_rid (6 downto 0)        , -- MSD: fire_emulate(fire0)
    oc_mmio0_axis_rlast                    => oc_mmio0_axis_rlast                   , -- MSD: fire_emulate(fire0)
    oc_mmio0_axis_rready                   => oc_mmio0_axis_rready                  , -- MSR: fire_emulate(fire0)
    oc_mmio0_axis_rresp (1 downto 0)       => oc_mmio0_axis_rresp (1 downto 0)      , -- MSD: fire_emulate(fire0)
    oc_mmio0_axis_rvalid                   => oc_mmio0_axis_rvalid                  , -- MSD: fire_emulate(fire0)
    oc_mmio0_axis_wdata (31 downto 0)      => oc_mmio0_axis_wdata (31 downto 0)     , -- MSR: fire_emulate(fire0)
    oc_mmio0_axis_wid (6 downto 0)         => oc_mmio0_axis_wid (6 downto 0)        , -- MSR: fire_emulate(fire0)
    oc_mmio0_axis_wlast                    => oc_mmio0_axis_wlast                   , -- MSR: fire_emulate(fire0)
    oc_mmio0_axis_wready                   => oc_mmio0_axis_wready                  , -- MSD: fire_emulate(fire0)
    oc_mmio0_axis_wstrb (3 downto 0)       => oc_mmio0_axis_wstrb (3 downto 0)      , -- MSR: fire_emulate(fire0)
    oc_mmio0_axis_wvalid                   => oc_mmio0_axis_wvalid                  , -- MSR: fire_emulate(fire0)
    opt_gckn                               => opt_gckn                              , -- MSR: fire_emulate(fire0)
    opt_gckn_4x                            => opt_gckn_4x                           , -- MSR: fire_emulate(fire0)
    phy_dlx0_lane_0 (0 to 15)              => phy_dlx0_lane_0 (0 to 15)             , -- MSR: fire_emulate(fire0)
    phy_dlx0_lane_1 (0 to 15)              => phy_dlx0_lane_1 (0 to 15)             , -- MSR: fire_emulate(fire0)
    phy_dlx0_lane_2 (0 to 15)              => phy_dlx0_lane_2 (0 to 15)             , -- MSR: fire_emulate(fire0)
    phy_dlx0_lane_3 (0 to 15)              => phy_dlx0_lane_3 (0 to 15)             , -- MSR: fire_emulate(fire0)
    phy_dlx0_lane_4 (0 to 15)              => phy_dlx0_lane_4 (0 to 15)             , -- MSR: fire_emulate(fire0)
    phy_dlx0_lane_5 (0 to 15)              => phy_dlx0_lane_5 (0 to 15)             , -- MSR: fire_emulate(fire0)
    phy_dlx0_lane_6 (0 to 15)              => phy_dlx0_lane_6 (0 to 15)             , -- MSR: fire_emulate(fire0)
    phy_dlx0_lane_7 (0 to 15)              => phy_dlx0_lane_7 (0 to 15)             , -- MSR: fire_emulate(fire0)
    reset                                  => reset                                   -- MSR: fire_emulate(fire0)
);

mb_top : entity mb.mb_top
port map (
    async_resetb                            => async_resetb                           , -- MSR: mb_top(mb_top)
    c4_epow                                 => c4_epow                                , -- MSR: mb_top(mb_top)
    c4_eventn                               => c4_eventn                              , -- MSR: mb_top(mb_top)
    c4_saven                                => c4_saven                               , -- MSD: mb_top(mb_top)
    dfi_act_n_a                             => dfi_act_n_a                            , -- MSD: mb_top(mb_top)
    dfi_act_n_b                             => dfi_act_n_b                            , -- MSD: mb_top(mb_top)
    dfi_address_a (0 to 17)                 => dfi_address_a (0 to 17)                , -- MSD: mb_top(mb_top)
    dfi_address_b (0 to 17)                 => dfi_address_b (0 to 17)                , -- MSD: mb_top(mb_top)
    dfi_alert_n                             => dfi_alert_n                            , -- MSR: mb_top(mb_top)
    dfi_bank_a (0 to 1)                     => dfi_bank_a (0 to 1)                    , -- MSD: mb_top(mb_top)
    dfi_bank_b (0 to 1)                     => dfi_bank_b (0 to 1)                    , -- MSD: mb_top(mb_top)
    dfi_bg_a (0 to 1)                       => dfi_bg_a (0 to 1)                      , -- MSD: mb_top(mb_top)
    dfi_bg_b (0 to 1)                       => dfi_bg_b (0 to 1)                      , -- MSD: mb_top(mb_top)
    dfi_cas_n_a                             => dfi_cas_n_a                            , -- MSD: mb_top(mb_top)
    dfi_cas_n_b                             => dfi_cas_n_b                            , -- MSD: mb_top(mb_top)
    dfi_cid_a (0 to 1)                      => dfi_cid_a (0 to 1)                     , -- MSD: mb_top(mb_top)
    dfi_cid_b (0 to 1)                      => dfi_cid_b (0 to 1)                     , -- MSD: mb_top(mb_top)
    dfi_cke_a (0 to 1)                      => dfi_cke_a (0 to 1)                     , -- MSD: mb_top(mb_top)
    dfi_cke_b (0 to 1)                      => dfi_cke_b (0 to 1)                     , -- MSD: mb_top(mb_top)
    dfi_cs_n_a (0 to 1)                     => dfi_cs_n_a (0 to 1)                    , -- MSD: mb_top(mb_top)
    dfi_cs_n_b (0 to 1)                     => dfi_cs_n_b (0 to 1)                    , -- MSD: mb_top(mb_top)
    dfi_ctrlupd_ack                         => dfi_ctrlupd_ack                        , -- MSR: mb_top(mb_top)
    dfi_ctrlupd_req                         => dfi_ctrlupd_req                        , -- MSD: mb_top(mb_top)
    dfi_dram_clk_disable_a (0 to 1)         => dfi_dram_clk_disable_a (0 to 1)        , -- MSD: mb_top(mb_top)
    dfi_dram_clk_disable_b (0 to 1)         => dfi_dram_clk_disable_b (0 to 1)        , -- MSD: mb_top(mb_top)
    dfi_freq (0 to 4)                       => dfi_freq (0 to 4)                      , -- MSD: mb_top(mb_top)
    dfi_init_complete                       => dfi_init_complete                      , -- MSR: mb_top(mb_top)
    dfi_init_start                          => dfi_init_start                         , -- MSD: mb_top(mb_top)
    dfi_lp_ack                              => dfi_lp_ack                             , -- MSR: mb_top(mb_top)
    dfi_lp_ctrl_req                         => dfi_lp_ctrl_req                        , -- MSD: mb_top(mb_top)
    dfi_lp_data_req                         => dfi_lp_data_req                        , -- MSD: mb_top(mb_top)
    dfi_lp_wakeup (0 to 3)                  => dfi_lp_wakeup (0 to 3)                 , -- MSD: mb_top(mb_top)
    dfi_odt_a (0 to 1)                      => dfi_odt_a (0 to 1)                     , -- MSD: mb_top(mb_top)
    dfi_odt_b (0 to 1)                      => dfi_odt_b (0 to 1)                     , -- MSD: mb_top(mb_top)
    dfi_parity_in_a                         => dfi_parity_in_a                        , -- MSD: mb_top(mb_top)
    dfi_parity_in_b                         => dfi_parity_in_b                        , -- MSD: mb_top(mb_top)
    dfi_ras_n_a                             => dfi_ras_n_a                            , -- MSD: mb_top(mb_top)
    dfi_ras_n_b                             => dfi_ras_n_b                            , -- MSD: mb_top(mb_top)
    dfi_rddata (0 to 159)                   => dfi_rddata (0 to 159)                  , -- MSR: mb_top(mb_top)
    dfi_rddata_cs_n (0 to 39)               => dfi_rddata_cs_n (0 to 39)              , -- MSD: mb_top(mb_top)
    dfi_rddata_en (0 to 9)                  => dfi_rddata_en (0 to 9)                 , -- MSD: mb_top(mb_top)
    dfi_rddata_valid (0 to 9)               => dfi_rddata_valid (0 to 9)              , -- MSR: mb_top(mb_top)
    dfi_reset_n                             => dfi_reset_n                            , -- MSD: mb_top(mb_top)
    dfi_we_n_a                              => dfi_we_n_a                             , -- MSD: mb_top(mb_top)
    dfi_we_n_b                              => dfi_we_n_b                             , -- MSD: mb_top(mb_top)
    dfi_wrdata (0 to 159)                   => dfi_wrdata (0 to 159)                  , -- MSD: mb_top(mb_top)
    dfi_wrdata_cs_n (0 to 39)               => dfi_wrdata_cs_n (0 to 39)              , -- MSD: mb_top(mb_top)
    dfi_wrdata_en (0 to 9)                  => dfi_wrdata_en (0 to 9)                 , -- MSD: mb_top(mb_top)
    dlx_phy_lane_0                          => dlx1_phy_lane_0                        , -- OVD: mb_top(mb_top)
    dlx_phy_lane_1                          => dlx1_phy_lane_1                        , -- OVD: mb_top(mb_top)
    dlx_phy_lane_2                          => dlx1_phy_lane_2                        , -- OVD: mb_top(mb_top)
    dlx_phy_lane_3                          => dlx1_phy_lane_3                        , -- OVD: mb_top(mb_top)
    dlx_phy_lane_4                          => dlx1_phy_lane_4                        , -- OVD: mb_top(mb_top)
    dlx_phy_lane_5                          => dlx1_phy_lane_5                        , -- OVD: mb_top(mb_top)
    dlx_phy_lane_6                          => dlx1_phy_lane_6                        , -- OVD: mb_top(mb_top)
    dlx_phy_lane_7                          => dlx1_phy_lane_7                        , -- OVD: mb_top(mb_top)
    dlx_phy_recal_req_0                     => dlx_phy_recal_req_0                    , -- MSD: mb_top(mb_top)
    dlx_phy_recal_req_1                     => dlx_phy_recal_req_1                    , -- MSD: mb_top(mb_top)
    dlx_phy_recal_req_2                     => dlx_phy_recal_req_2                    , -- MSD: mb_top(mb_top)
    dlx_phy_recal_req_3                     => dlx_phy_recal_req_3                    , -- MSD: mb_top(mb_top)
    dlx_phy_recal_req_4                     => dlx_phy_recal_req_4                    , -- MSD: mb_top(mb_top)
    dlx_phy_recal_req_5                     => dlx_phy_recal_req_5                    , -- MSD: mb_top(mb_top)
    dlx_phy_recal_req_6                     => dlx_phy_recal_req_6                    , -- MSD: mb_top(mb_top)
    dlx_phy_recal_req_7                     => dlx_phy_recal_req_7                    , -- MSD: mb_top(mb_top)
    dlx_phy_run_lane_0                      => dlx_phy_run_lane_0                     , -- MSD: mb_top(mb_top)
    dlx_phy_run_lane_1                      => dlx_phy_run_lane_1                     , -- MSD: mb_top(mb_top)
    dlx_phy_run_lane_2                      => dlx_phy_run_lane_2                     , -- MSD: mb_top(mb_top)
    dlx_phy_run_lane_3                      => dlx_phy_run_lane_3                     , -- MSD: mb_top(mb_top)
    dlx_phy_run_lane_4                      => dlx_phy_run_lane_4                     , -- MSD: mb_top(mb_top)
    dlx_phy_run_lane_5                      => dlx_phy_run_lane_5                     , -- MSD: mb_top(mb_top)
    dlx_phy_run_lane_6                      => dlx_phy_run_lane_6                     , -- MSD: mb_top(mb_top)
    dlx_phy_run_lane_7                      => dlx_phy_run_lane_7                     , -- MSD: mb_top(mb_top)
    dlx_phy_rx_psave_req_0                  => dlx_phy_rx_psave_req_0                 , -- MSD: mb_top(mb_top)
    dlx_phy_rx_psave_req_1                  => dlx_phy_rx_psave_req_1                 , -- MSD: mb_top(mb_top)
    dlx_phy_rx_psave_req_2                  => dlx_phy_rx_psave_req_2                 , -- MSD: mb_top(mb_top)
    dlx_phy_rx_psave_req_3                  => dlx_phy_rx_psave_req_3                 , -- MSD: mb_top(mb_top)
    dlx_phy_rx_psave_req_4                  => dlx_phy_rx_psave_req_4                 , -- MSD: mb_top(mb_top)
    dlx_phy_rx_psave_req_5                  => dlx_phy_rx_psave_req_5                 , -- MSD: mb_top(mb_top)
    dlx_phy_rx_psave_req_6                  => dlx_phy_rx_psave_req_6                 , -- MSD: mb_top(mb_top)
    dlx_phy_rx_psave_req_7                  => dlx_phy_rx_psave_req_7                 , -- MSD: mb_top(mb_top)
    dlx_phy_sideband (7 downto 0)           => dlx_phy_sideband (7 downto 0)          , -- MSD: mb_top(mb_top)
    dlx_phy_tx_psave_req_0                  => dlx_phy_tx_psave_req_0                 , -- MSD: mb_top(mb_top)
    dlx_phy_tx_psave_req_1                  => dlx_phy_tx_psave_req_1                 , -- MSD: mb_top(mb_top)
    dlx_phy_tx_psave_req_2                  => dlx_phy_tx_psave_req_2                 , -- MSD: mb_top(mb_top)
    dlx_phy_tx_psave_req_3                  => dlx_phy_tx_psave_req_3                 , -- MSD: mb_top(mb_top)
    dlx_phy_tx_psave_req_4                  => dlx_phy_tx_psave_req_4                 , -- MSD: mb_top(mb_top)
    dlx_phy_tx_psave_req_5                  => dlx_phy_tx_psave_req_5                 , -- MSD: mb_top(mb_top)
    dlx_phy_tx_psave_req_6                  => dlx_phy_tx_psave_req_6                 , -- MSD: mb_top(mb_top)
    dlx_phy_tx_psave_req_7                  => dlx_phy_tx_psave_req_7                 , -- MSD: mb_top(mb_top)
    dqbypass (0 to 79)                      => dqbypass (0 to 79)                     , -- MSR: mb_top(mb_top)
    fuse_enterprise_dis                     => fuse_enterprise_dis                    , -- MSR: mb_top(mb_top)
    gck                                     => gck                                    , -- MSR: mb_top(mb_top)
    gif2pcb_maddr (31 downto 0)             => gif2pcb_maddr (31 downto 0)            , -- MSR: mb_top(mb_top)
    gif2pcb_masideband                      => gif2pcb_masideband                     , -- MSR: mb_top(mb_top)
    gif2pcb_mburst (1 downto 0)             => gif2pcb_mburst (1 downto 0)            , -- MSR: mb_top(mb_top)
    gif2pcb_mdata (31 downto 0)             => gif2pcb_mdata (31 downto 0)            , -- MSR: mb_top(mb_top)
    gif2pcb_mlast                           => gif2pcb_mlast                          , -- MSR: mb_top(mb_top)
    gif2pcb_mlen (3 downto 0)               => gif2pcb_mlen (3 downto 0)              , -- MSR: mb_top(mb_top)
    gif2pcb_mread                           => gif2pcb_mread                          , -- MSR: mb_top(mb_top)
    gif2pcb_mready                          => gif2pcb_mready                         , -- MSR: mb_top(mb_top)
    gif2pcb_msize (2 downto 0)              => gif2pcb_msize (2 downto 0)             , -- MSR: mb_top(mb_top)
    gif2pcb_mwrite                          => gif2pcb_mwrite                         , -- MSR: mb_top(mb_top)
    gif2pcb_mwsideband (3 downto 0)         => gif2pcb_mwsideband (3 downto 0)        , -- MSR: mb_top(mb_top)
    gif2pcb_mwstrb (3 downto 0)             => gif2pcb_mwstrb (3 downto 0)            , -- MSR: mb_top(mb_top)
    gif2pcb_saccept                         => gif2pcb_saccept                        , -- MSD: mb_top(mb_top)
    gif2pcb_sdata (31 downto 0)             => gif2pcb_sdata (31 downto 0)            , -- MSD: mb_top(mb_top)
    gif2pcb_slast                           => gif2pcb_slast                          , -- MSD: mb_top(mb_top)
    gif2pcb_sresp (1 downto 0)              => gif2pcb_sresp (1 downto 0)             , -- MSD: mb_top(mb_top)
    gif2pcb_srsideband (3 downto 0)         => gif2pcb_srsideband (3 downto 0)        , -- MSD: mb_top(mb_top)
    gif2pcb_svalid                          => gif2pcb_svalid                         , -- MSD: mb_top(mb_top)
    gnd                                     => gnd                                    , -- MSB: mb_top(mb_top)
    gpbc_to_mb_top_error_info (52 downto 0) => gpbc_to_mb_top_error_info (52 downto 0), -- MSR: mb_top(mb_top)
    mb_top_to_gpbc_error_info (15 downto 0) => mb_top_to_gpbc_error_info (15 downto 0), -- MSD: mb_top(mb_top)
    pclk                                    => pclk                                   , -- MSR: mb_top(mb_top)
    phy_dlx_clock_0                         => phy_dlx_clock_0                        , -- MSR: mb_top(mb_top)
    phy_dlx_clock_1                         => phy_dlx_clock_1                        , -- MSR: mb_top(mb_top)
    phy_dlx_clock_2                         => phy_dlx_clock_2                        , -- MSR: mb_top(mb_top)
    phy_dlx_clock_3                         => phy_dlx_clock_3                        , -- MSR: mb_top(mb_top)
    phy_dlx_clock_4                         => phy_dlx_clock_4                        , -- MSR: mb_top(mb_top)
    phy_dlx_clock_5                         => phy_dlx_clock_5                        , -- MSR: mb_top(mb_top)
    phy_dlx_clock_6                         => phy_dlx_clock_6                        , -- MSR: mb_top(mb_top)
    phy_dlx_clock_7                         => phy_dlx_clock_7                        , -- MSR: mb_top(mb_top)
    phy_dlx_init_done_0                     => phy_dlx_init_done_0                    , -- MSR: mb_top(mb_top)
    phy_dlx_init_done_1                     => phy_dlx_init_done_1                    , -- MSR: mb_top(mb_top)
    phy_dlx_init_done_2                     => phy_dlx_init_done_2                    , -- MSR: mb_top(mb_top)
    phy_dlx_init_done_3                     => phy_dlx_init_done_3                    , -- MSR: mb_top(mb_top)
    phy_dlx_init_done_4                     => phy_dlx_init_done_4                    , -- MSR: mb_top(mb_top)
    phy_dlx_init_done_5                     => phy_dlx_init_done_5                    , -- MSR: mb_top(mb_top)
    phy_dlx_init_done_6                     => phy_dlx_init_done_6                    , -- MSR: mb_top(mb_top)
    phy_dlx_init_done_7                     => phy_dlx_init_done_7                    , -- MSR: mb_top(mb_top)
    phy_dlx_lane_0 (15 downto 0)            => phy_dlx1_lane_0 (0 to 15)              , -- OVR: mb_top(mb_top)
    phy_dlx_lane_1 (15 downto 0)            => phy_dlx1_lane_1 (0 to 15)              , -- OVR: mb_top(mb_top)
    phy_dlx_lane_2 (15 downto 0)            => phy_dlx1_lane_2 (0 to 15)              , -- OVR: mb_top(mb_top)
    phy_dlx_lane_3 (15 downto 0)            => phy_dlx1_lane_3 (0 to 15)              , -- OVR: mb_top(mb_top)
    phy_dlx_lane_4 (15 downto 0)            => phy_dlx1_lane_4 (0 to 15)              , -- OVR: mb_top(mb_top)
    phy_dlx_lane_5 (15 downto 0)            => phy_dlx1_lane_5 (0 to 15)              , -- OVR: mb_top(mb_top)
    phy_dlx_lane_6 (15 downto 0)            => phy_dlx1_lane_6 (0 to 15)              , -- OVR: mb_top(mb_top)
    phy_dlx_lane_7 (15 downto 0)            => phy_dlx1_lane_7 (0 to 15)              , -- OVR: mb_top(mb_top)
    phy_dlx_recal_done_0                    => phy_dlx_recal_done_0                   , -- MSR: mb_top(mb_top)
    phy_dlx_recal_done_1                    => phy_dlx_recal_done_1                   , -- MSR: mb_top(mb_top)
    phy_dlx_recal_done_2                    => phy_dlx_recal_done_2                   , -- MSR: mb_top(mb_top)
    phy_dlx_recal_done_3                    => phy_dlx_recal_done_3                   , -- MSR: mb_top(mb_top)
    phy_dlx_recal_done_4                    => phy_dlx_recal_done_4                   , -- MSR: mb_top(mb_top)
    phy_dlx_recal_done_5                    => phy_dlx_recal_done_5                   , -- MSR: mb_top(mb_top)
    phy_dlx_recal_done_6                    => phy_dlx_recal_done_6                   , -- MSR: mb_top(mb_top)
    phy_dlx_recal_done_7                    => phy_dlx_recal_done_7                   , -- MSR: mb_top(mb_top)
    phy_dlx_rx_psave_sts_0                  => phy_dlx_rx_psave_sts_0                 , -- MSR: mb_top(mb_top)
    phy_dlx_rx_psave_sts_1                  => phy_dlx_rx_psave_sts_1                 , -- MSR: mb_top(mb_top)
    phy_dlx_rx_psave_sts_2                  => phy_dlx_rx_psave_sts_2                 , -- MSR: mb_top(mb_top)
    phy_dlx_rx_psave_sts_3                  => phy_dlx_rx_psave_sts_3                 , -- MSR: mb_top(mb_top)
    phy_dlx_rx_psave_sts_4                  => phy_dlx_rx_psave_sts_4                 , -- MSR: mb_top(mb_top)
    phy_dlx_rx_psave_sts_5                  => phy_dlx_rx_psave_sts_5                 , -- MSR: mb_top(mb_top)
    phy_dlx_rx_psave_sts_6                  => phy_dlx_rx_psave_sts_6                 , -- MSR: mb_top(mb_top)
    phy_dlx_rx_psave_sts_7                  => phy_dlx_rx_psave_sts_7                 , -- MSR: mb_top(mb_top)
    phy_dlx_sideband (7 downto 0)           => phy_dlx_sideband (7 downto 0)          , -- MSR: mb_top(mb_top)
    phy_dlx_tx_psave_sts_0                  => phy_dlx_tx_psave_sts_0                 , -- MSR: mb_top(mb_top)
    phy_dlx_tx_psave_sts_1                  => phy_dlx_tx_psave_sts_1                 , -- MSR: mb_top(mb_top)
    phy_dlx_tx_psave_sts_2                  => phy_dlx_tx_psave_sts_2                 , -- MSR: mb_top(mb_top)
    phy_dlx_tx_psave_sts_3                  => phy_dlx_tx_psave_sts_3                 , -- MSR: mb_top(mb_top)
    phy_dlx_tx_psave_sts_4                  => phy_dlx_tx_psave_sts_4                 , -- MSR: mb_top(mb_top)
    phy_dlx_tx_psave_sts_5                  => phy_dlx_tx_psave_sts_5                 , -- MSR: mb_top(mb_top)
    phy_dlx_tx_psave_sts_6                  => phy_dlx_tx_psave_sts_6                 , -- MSR: mb_top(mb_top)
    phy_dlx_tx_psave_sts_7                  => phy_dlx_tx_psave_sts_7                 , -- MSR: mb_top(mb_top)
    pib2gif_maddr (31 downto 0)             => pib2gif_maddr (31 downto 0)            , -- MSD: mb_top(mb_top)
    pib2gif_masideband                      => pib2gif_masideband                     , -- MSD: mb_top(mb_top)
    pib2gif_mburst (1 downto 0)             => pib2gif_mburst (1 downto 0)            , -- MSD: mb_top(mb_top)
    pib2gif_mcache (3 downto 0)             => pib2gif_mcache (3 downto 0)            , -- MSD: mb_top(mb_top)
    pib2gif_mdata (31 downto 0)             => pib2gif_mdata (31 downto 0)            , -- MSD: mb_top(mb_top)
    pib2gif_mid (4 downto 0)                => pib2gif_mid (4 downto 0)               , -- MSD: mb_top(mb_top)
    pib2gif_mlast                           => pib2gif_mlast                          , -- MSD: mb_top(mb_top)
    pib2gif_mlen (3 downto 0)               => pib2gif_mlen (3 downto 0)              , -- MSD: mb_top(mb_top)
    pib2gif_mlock                           => pib2gif_mlock                          , -- MSD: mb_top(mb_top)
    pib2gif_mprot (2 downto 0)              => pib2gif_mprot (2 downto 0)             , -- MSD: mb_top(mb_top)
    pib2gif_mread                           => pib2gif_mread                          , -- MSD: mb_top(mb_top)
    pib2gif_mready                          => pib2gif_mready                         , -- MSD: mb_top(mb_top)
    pib2gif_msize (2 downto 0)              => pib2gif_msize (2 downto 0)             , -- MSD: mb_top(mb_top)
    pib2gif_mwrite                          => pib2gif_mwrite                         , -- MSD: mb_top(mb_top)
    pib2gif_mwsideband (3 downto 0)         => pib2gif_mwsideband (3 downto 0)        , -- MSD: mb_top(mb_top)
    pib2gif_mwstrb (3 downto 0)             => pib2gif_mwstrb (3 downto 0)            , -- MSD: mb_top(mb_top)
    pib2gif_saccept                         => pib2gif_saccept                        , -- MSR: mb_top(mb_top)
    pib2gif_sdata (31 downto 0)             => pib2gif_sdata (31 downto 0)            , -- MSR: mb_top(mb_top)
    pib2gif_sid (4 downto 0)                => pib2gif_sid (4 downto 0)               , -- MSR: mb_top(mb_top)
    pib2gif_slast                           => pib2gif_slast                          , -- MSR: mb_top(mb_top)
    pib2gif_sresp (2 downto 0)              => pib2gif_sresp (2 downto 0)             , -- MSR: mb_top(mb_top)
    pib2gif_srsideband (3 downto 0)         => pib2gif_srsideband (3 downto 0)        , -- MSR: mb_top(mb_top)
    pib2gif_svalid                          => pib2gif_svalid                         , -- MSR: mb_top(mb_top)
    scan_en_o                               => scan_en_o                              , -- MSR: mb_top(mb_top)
    scanb                                   => scanb                                  , -- MSR: mb_top(mb_top)
    spare_input_acx4_a (0 to 3)             => spare_input_acx4_a (0 to 3)            , -- MSD: mb_top(mb_top)
    spare_input_acx4_b (0 to 3)             => spare_input_acx4_b (0 to 3)            , -- MSD: mb_top(mb_top)
    spare_input_dbyte (0 to 9)              => spare_input_dbyte (0 to 9)             , -- MSD: mb_top(mb_top)
    spare_input_pub (0 to 3)                => spare_input_pub (0 to 3)               , -- MSD: mb_top(mb_top)
    spare_output_acx4_a (0 to 3)            => spare_output_acx4_a (0 to 3)           , -- MSR: mb_top(mb_top)
    spare_output_acx4_b (0 to 3)            => spare_output_acx4_b (0 to 3)           , -- MSR: mb_top(mb_top)
    spare_output_dbyte (0 to 9)             => spare_output_dbyte (0 to 9)            , -- MSR: mb_top(mb_top)
    spare_output_pub (0 to 3)               => spare_output_pub (0 to 3)              , -- MSR: mb_top(mb_top)
    sw_reset                                => sw_reset                               , -- MSR: mb_top(mb_top)
    sw_reset_clock_divider                  => sw_reset_clock_divider                 , -- MSR: mb_top(mb_top)
    sync_reset_pclk_out                     => sync_reset_pclk_out                    , -- MSD: mb_top(mb_top)
    test_clk_1                              => test_clk_1                             , -- MSR: mb_top(mb_top)
    testclk_selb                            => testclk_selb                           , -- MSR: mb_top(mb_top)
    vdd                                     => vdd                                      -- MSB: mb_top(mb_top)
);
end fire_emulate_tb;
