-- *!***************************************************************************
-- *! (C) Copyright International Business Machines Corp. 2018
-- *!           All Rights Reserved -- Property of IBM
-- *!                   *** IBM Confidential ***
-- *!***************************************************************************
-- *! FILENAME    : fire_emulate.vhdl
-- *! TITLE       : Fire Emulation Top Level
-- *! DESCRIPTION : Contains fire core and PHY gearbox model
-- *!
-- *! OWNER  NAME : Ryan King (rpking@us.ibm.com)
-- *! BACKUP NAME : Kevin McIlvain
-- *!
-- *!***************************************************************************
-- MR_PARAMS -clk gckn
-- MR_B SOFT
-- MS_REC 2

--          <macro name>          <instance name>   <port map renames>
-- MS_INST  fire_core             fire0             dlx_l0_tx_data(63 downto 0) dlx0_l0_tx_data(63 downto 0)  dlx_l0_tx_header(1 downto 0) dlx0_l0_tx_header(1 downto 0)  dlx_l0_tx_seq(5 downto 0) dlx0_l0_tx_seq(5 downto 0)
-- MS_INST  fire_core             fire0             dlx_l1_tx_data(63 downto 0) dlx0_l1_tx_data(63 downto 0)  dlx_l1_tx_header(1 downto 0) dlx0_l1_tx_header(1 downto 0)  dlx_l1_tx_seq(5 downto 0) dlx0_l1_tx_seq(5 downto 0)
-- MS_INST  fire_core             fire0             dlx_l2_tx_data(63 downto 0) dlx0_l2_tx_data(63 downto 0)  dlx_l2_tx_header(1 downto 0) dlx0_l2_tx_header(1 downto 0)  dlx_l2_tx_seq(5 downto 0) dlx0_l2_tx_seq(5 downto 0)
-- MS_INST  fire_core             fire0             dlx_l3_tx_data(63 downto 0) dlx0_l3_tx_data(63 downto 0)  dlx_l3_tx_header(1 downto 0) dlx0_l3_tx_header(1 downto 0)  dlx_l3_tx_seq(5 downto 0) dlx0_l3_tx_seq(5 downto 0)
-- MS_INST  fire_core             fire0             dlx_l4_tx_data(63 downto 0) dlx0_l4_tx_data(63 downto 0)  dlx_l4_tx_header(1 downto 0) dlx0_l4_tx_header(1 downto 0)  dlx_l4_tx_seq(5 downto 0) dlx0_l4_tx_seq(5 downto 0)
-- MS_INST  fire_core             fire0             dlx_l5_tx_data(63 downto 0) dlx0_l5_tx_data(63 downto 0)  dlx_l5_tx_header(1 downto 0) dlx0_l5_tx_header(1 downto 0)  dlx_l5_tx_seq(5 downto 0) dlx0_l5_tx_seq(5 downto 0)
-- MS_INST  fire_core             fire0             dlx_l6_tx_data(63 downto 0) dlx0_l6_tx_data(63 downto 0)  dlx_l6_tx_header(1 downto 0) dlx0_l6_tx_header(1 downto 0)  dlx_l6_tx_seq(5 downto 0) dlx0_l6_tx_seq(5 downto 0)
-- MS_INST  fire_core             fire0             dlx_l7_tx_data(63 downto 0) dlx0_l7_tx_data(63 downto 0)  dlx_l7_tx_header(1 downto 0) dlx0_l7_tx_header(1 downto 0)  dlx_l7_tx_seq(5 downto 0) dlx0_l7_tx_seq(5 downto 0)
-- MS_INST  fire_core             fire0             ln0_rx_data(63 downto 0) dlx0_ln0_rx_data(63 downto 0)  ln0_rx_header(1 downto 0) dlx0_ln0_rx_header(1 downto 0)  ln0_rx_slip dlx0_ln0_rx_slip  ln0_rx_valid dlx0_ln0_rx_valid
-- MS_INST  fire_core             fire0             ln1_rx_data(63 downto 0) dlx0_ln1_rx_data(63 downto 0)  ln1_rx_header(1 downto 0) dlx0_ln1_rx_header(1 downto 0)  ln1_rx_slip dlx0_ln1_rx_slip  ln1_rx_valid dlx0_ln1_rx_valid
-- MS_INST  fire_core             fire0             ln2_rx_data(63 downto 0) dlx0_ln2_rx_data(63 downto 0)  ln2_rx_header(1 downto 0) dlx0_ln2_rx_header(1 downto 0)  ln2_rx_slip dlx0_ln2_rx_slip  ln2_rx_valid dlx0_ln2_rx_valid
-- MS_INST  fire_core             fire0             ln3_rx_data(63 downto 0) dlx0_ln3_rx_data(63 downto 0)  ln3_rx_header(1 downto 0) dlx0_ln3_rx_header(1 downto 0)  ln3_rx_slip dlx0_ln3_rx_slip  ln3_rx_valid dlx0_ln3_rx_valid
-- MS_INST  fire_core             fire0             ln4_rx_data(63 downto 0) dlx0_ln4_rx_data(63 downto 0)  ln4_rx_header(1 downto 0) dlx0_ln4_rx_header(1 downto 0)  ln4_rx_slip dlx0_ln4_rx_slip  ln4_rx_valid dlx0_ln4_rx_valid
-- MS_INST  fire_core             fire0             ln5_rx_data(63 downto 0) dlx0_ln5_rx_data(63 downto 0)  ln5_rx_header(1 downto 0) dlx0_ln5_rx_header(1 downto 0)  ln5_rx_slip dlx0_ln5_rx_slip  ln5_rx_valid dlx0_ln5_rx_valid
-- MS_INST  fire_core             fire0             ln6_rx_data(63 downto 0) dlx0_ln6_rx_data(63 downto 0)  ln6_rx_header(1 downto 0) dlx0_ln6_rx_header(1 downto 0)  ln6_rx_slip dlx0_ln6_rx_slip  ln6_rx_valid dlx0_ln6_rx_valid
-- MS_INST  fire_core             fire0             ln7_rx_data(63 downto 0) dlx0_ln7_rx_data(63 downto 0)  ln7_rx_header(1 downto 0) dlx0_ln7_rx_header(1 downto 0)  ln7_rx_slip dlx0_ln7_rx_slip  ln7_rx_valid dlx0_ln7_rx_valid

-- TX
-- MS_INST  tb_ln_dly1to4         dly0_00           lane_in_data(0 to 63) dlx0_ln0_tx_data(0 to 63)  lane_in_header(0 to 1) dlx0_ln0_tx_header(0 to 1)  lane_in_seq(0 to 5) dlx0_ln0_tx_seq(0 to 5)  lane_out(0 to 15) dlx0_phy_lane_0(0 to 15)  clock_in opt_gckn_4x
-- MS_INST  tb_ln_dly1to4         dly0_01           lane_in_data(0 to 63) dlx0_ln1_tx_data(0 to 63)  lane_in_header(0 to 1) dlx0_ln1_tx_header(0 to 1)  lane_in_seq(0 to 5) dlx0_ln1_tx_seq(0 to 5)  lane_out(0 to 15) dlx0_phy_lane_1(0 to 15)  clock_in opt_gckn_4x
-- MS_INST  tb_ln_dly1to4         dly0_02           lane_in_data(0 to 63) dlx0_ln2_tx_data(0 to 63)  lane_in_header(0 to 1) dlx0_ln2_tx_header(0 to 1)  lane_in_seq(0 to 5) dlx0_ln2_tx_seq(0 to 5)  lane_out(0 to 15) dlx0_phy_lane_2(0 to 15)  clock_in opt_gckn_4x
-- MS_INST  tb_ln_dly1to4         dly0_03           lane_in_data(0 to 63) dlx0_ln3_tx_data(0 to 63)  lane_in_header(0 to 1) dlx0_ln3_tx_header(0 to 1)  lane_in_seq(0 to 5) dlx0_ln3_tx_seq(0 to 5)  lane_out(0 to 15) dlx0_phy_lane_3(0 to 15)  clock_in opt_gckn_4x
-- MS_INST  tb_ln_dly1to4         dly0_04           lane_in_data(0 to 63) dlx0_ln4_tx_data(0 to 63)  lane_in_header(0 to 1) dlx0_ln4_tx_header(0 to 1)  lane_in_seq(0 to 5) dlx0_ln4_tx_seq(0 to 5)  lane_out(0 to 15) dlx0_phy_lane_4(0 to 15)  clock_in opt_gckn_4x
-- MS_INST  tb_ln_dly1to4         dly0_05           lane_in_data(0 to 63) dlx0_ln5_tx_data(0 to 63)  lane_in_header(0 to 1) dlx0_ln5_tx_header(0 to 1)  lane_in_seq(0 to 5) dlx0_ln5_tx_seq(0 to 5)  lane_out(0 to 15) dlx0_phy_lane_5(0 to 15)  clock_in opt_gckn_4x
-- MS_INST  tb_ln_dly1to4         dly0_06           lane_in_data(0 to 63) dlx0_ln6_tx_data(0 to 63)  lane_in_header(0 to 1) dlx0_ln6_tx_header(0 to 1)  lane_in_seq(0 to 5) dlx0_ln6_tx_seq(0 to 5)  lane_out(0 to 15) dlx0_phy_lane_6(0 to 15)  clock_in opt_gckn_4x
-- MS_INST  tb_ln_dly1to4         dly0_07           lane_in_data(0 to 63) dlx0_ln7_tx_data(0 to 63)  lane_in_header(0 to 1) dlx0_ln7_tx_header(0 to 1)  lane_in_seq(0 to 5) dlx0_ln7_tx_seq(0 to 5)  lane_out(0 to 15) dlx0_phy_lane_7(0 to 15)  clock_in opt_gckn_4x

-- RX
-- MS_INST  tb_ln_dly4to1         dly1_00           lane_in(0 to 15) phy_dlx0_lane_0(0 to 15)  lane_out(63 downto 0) dlx0_ln0_data(63 downto 0)  clock_out dlx0_ln0_rx_clk  ln_rx_data(63 downto 0) dlx0_ln0_rx_data(63 downto 0)  ln_rx_header(1 downto 0) dlx0_ln0_rx_header(1 downto 0)  ln_rx_slip dlx0_ln0_rx_slip  ln_rx_valid dlx0_ln0_rx_valid
-- MS_INST  tb_ln_dly4to1         dly1_01           lane_in(0 to 15) phy_dlx0_lane_1(0 to 15)  lane_out(63 downto 0) dlx0_ln1_data(63 downto 0)  clock_out dlx0_ln1_rx_clk  ln_rx_data(63 downto 0) dlx0_ln1_rx_data(63 downto 0)  ln_rx_header(1 downto 0) dlx0_ln1_rx_header(1 downto 0)  ln_rx_slip dlx0_ln1_rx_slip  ln_rx_valid dlx0_ln1_rx_valid
-- MS_INST  tb_ln_dly4to1         dly1_02           lane_in(0 to 15) phy_dlx0_lane_2(0 to 15)  lane_out(63 downto 0) dlx0_ln2_data(63 downto 0)  clock_out dlx0_ln2_rx_clk  ln_rx_data(63 downto 0) dlx0_ln2_rx_data(63 downto 0)  ln_rx_header(1 downto 0) dlx0_ln2_rx_header(1 downto 0)  ln_rx_slip dlx0_ln2_rx_slip  ln_rx_valid dlx0_ln2_rx_valid
-- MS_INST  tb_ln_dly4to1         dly1_03           lane_in(0 to 15) phy_dlx0_lane_3(0 to 15)  lane_out(63 downto 0) dlx0_ln3_data(63 downto 0)  clock_out dlx0_ln3_rx_clk  ln_rx_data(63 downto 0) dlx0_ln3_rx_data(63 downto 0)  ln_rx_header(1 downto 0) dlx0_ln3_rx_header(1 downto 0)  ln_rx_slip dlx0_ln3_rx_slip  ln_rx_valid dlx0_ln3_rx_valid
-- MS_INST  tb_ln_dly4to1         dly1_04           lane_in(0 to 15) phy_dlx0_lane_4(0 to 15)  lane_out(63 downto 0) dlx0_ln4_data(63 downto 0)  clock_out dlx0_ln4_rx_clk  ln_rx_data(63 downto 0) dlx0_ln4_rx_data(63 downto 0)  ln_rx_header(1 downto 0) dlx0_ln4_rx_header(1 downto 0)  ln_rx_slip dlx0_ln4_rx_slip  ln_rx_valid dlx0_ln4_rx_valid
-- MS_INST  tb_ln_dly4to1         dly1_05           lane_in(0 to 15) phy_dlx0_lane_5(0 to 15)  lane_out(63 downto 0) dlx0_ln5_data(63 downto 0)  clock_out dlx0_ln5_rx_clk  ln_rx_data(63 downto 0) dlx0_ln5_rx_data(63 downto 0)  ln_rx_header(1 downto 0) dlx0_ln5_rx_header(1 downto 0)  ln_rx_slip dlx0_ln5_rx_slip  ln_rx_valid dlx0_ln5_rx_valid
-- MS_INST  tb_ln_dly4to1         dly1_06           lane_in(0 to 15) phy_dlx0_lane_6(0 to 15)  lane_out(63 downto 0) dlx0_ln6_data(63 downto 0)  clock_out dlx0_ln6_rx_clk  ln_rx_data(63 downto 0) dlx0_ln6_rx_data(63 downto 0)  ln_rx_header(1 downto 0) dlx0_ln6_rx_header(1 downto 0)  ln_rx_slip dlx0_ln6_rx_slip  ln_rx_valid dlx0_ln6_rx_valid
-- MS_INST  tb_ln_dly4to1         dly1_07           lane_in(0 to 15) phy_dlx0_lane_7(0 to 15)  lane_out(63 downto 0) dlx0_ln7_data(63 downto 0)  clock_out dlx0_ln7_rx_clk  ln_rx_data(63 downto 0) dlx0_ln7_rx_data(63 downto 0)  ln_rx_header(1 downto 0) dlx0_ln7_rx_header(1 downto 0)  ln_rx_slip dlx0_ln7_rx_slip  ln_rx_valid dlx0_ln7_rx_valid

library ieee,ibm,support;
use ieee.std_logic_1164.all;
use ibm.synthesis_support.all;
use support.logic_support_pkg.all;
use work.axi_pkg.all;

entity fire_emulate is
  port (
    ---------------------------------------------------------------------------
    -- Clocking
    ---------------------------------------------------------------------------
    opt_gckn                       : in std_ulogic;
    opt_gckn_4x                    : in std_ulogic;
    reset                          : in std_ulogic;
    gtwiz_done                     : in std_ulogic;

    ---------------------------------------------------------------------------
    -- DLX -> PHY
    ---------------------------------------------------------------------------
    dlx0_phy_lane_0                : out std_ulogic_vector(0 to 15);
    dlx0_phy_lane_1                : out std_ulogic_vector(0 to 15);
    dlx0_phy_lane_2                : out std_ulogic_vector(0 to 15);
    dlx0_phy_lane_3                : out std_ulogic_vector(0 to 15);
    dlx0_phy_lane_4                : out std_ulogic_vector(0 to 15);
    dlx0_phy_lane_5                : out std_ulogic_vector(0 to 15);
    dlx0_phy_lane_6                : out std_ulogic_vector(0 to 15);
    dlx0_phy_lane_7                : out std_ulogic_vector(0 to 15);
    phy_dlx0_lane_0                : in std_ulogic_vector(0 to 15);
    phy_dlx0_lane_1                : in std_ulogic_vector(0 to 15);
    phy_dlx0_lane_2                : in std_ulogic_vector(0 to 15);
    phy_dlx0_lane_3                : in std_ulogic_vector(0 to 15);
    phy_dlx0_lane_4                : in std_ulogic_vector(0 to 15);
    phy_dlx0_lane_5                : in std_ulogic_vector(0 to 15);
    phy_dlx0_lane_6                : in std_ulogic_vector(0 to 15);
    phy_dlx0_lane_7                : in std_ulogic_vector(0 to 15);

    ---------------------------------------------------------------------------
    -- Registers
    ---------------------------------------------------------------------------
    oc_memory0_axis_aclk    : in  std_ulogic;
    oc_memory0_axis_aresetn : in  std_ulogic;
    oc_memory0_axis_awid    : in  std_ulogic_vector(6 downto 0);
    oc_memory0_axis_awaddr  : in  std_ulogic_vector(63 downto 0);
    oc_memory0_axis_awlen   : in  std_ulogic_vector(7 downto 0);
    oc_memory0_axis_awsize  : in  std_ulogic_vector(2 downto 0);
    oc_memory0_axis_awburst : in  std_ulogic_vector(1 downto 0);
    oc_memory0_axis_awlock  : in  std_ulogic_vector(1 downto 0);
    oc_memory0_axis_awcache : in  std_ulogic_vector(3 downto 0);
    oc_memory0_axis_awprot  : in  std_ulogic_vector(2 downto 0);
    oc_memory0_axis_awvalid : in  std_ulogic;
    oc_memory0_axis_awready : out std_ulogic;
    oc_memory0_axis_wid     : in  std_ulogic_vector(6 downto 0);
    oc_memory0_axis_wdata   : in  std_ulogic_vector(31 downto 0);
    oc_memory0_axis_wstrb   : in  std_ulogic_vector(3 downto 0);
    oc_memory0_axis_wlast   : in  std_ulogic;
    oc_memory0_axis_wvalid  : in  std_ulogic;
    oc_memory0_axis_wready  : out std_ulogic;
    oc_memory0_axis_bid     : out std_ulogic_vector(6 downto 0);
    oc_memory0_axis_bresp   : out std_ulogic_vector(1 downto 0);
    oc_memory0_axis_bvalid  : out std_ulogic;
    oc_memory0_axis_bready  : in  std_ulogic;
    oc_memory0_axis_arid    : in  std_ulogic_vector(6 downto 0);
    oc_memory0_axis_araddr  : in  std_ulogic_vector(63 downto 0);
    oc_memory0_axis_arlen   : in  std_ulogic_vector(7 downto 0);
    oc_memory0_axis_arsize  : in  std_ulogic_vector(2 downto 0);
    oc_memory0_axis_arburst : in  std_ulogic_vector(1 downto 0);
    oc_memory0_axis_arlock  : in  std_ulogic_vector(1 downto 0);
    oc_memory0_axis_arcache : in  std_ulogic_vector(3 downto 0);
    oc_memory0_axis_arprot  : in  std_ulogic_vector(2 downto 0);
    oc_memory0_axis_arvalid : in  std_ulogic;
    oc_memory0_axis_arready : out std_ulogic;
    oc_memory0_axis_rid     : out std_ulogic_vector(6 downto 0);
    oc_memory0_axis_rdata   : out std_ulogic_vector(31 downto 0);
    oc_memory0_axis_rresp   : out std_ulogic_vector(1 downto 0);
    oc_memory0_axis_rlast   : out std_ulogic;
    oc_memory0_axis_rvalid  : out std_ulogic;
    oc_memory0_axis_rready  : in  std_ulogic;

    oc_mmio0_axis_aclk    : in  std_ulogic;
    oc_mmio0_axis_aresetn : in  std_ulogic;
    oc_mmio0_axis_awid    : in  std_ulogic_vector(6 downto 0);
    oc_mmio0_axis_awaddr  : in  std_ulogic_vector(63 downto 0);
    oc_mmio0_axis_awlen   : in  std_ulogic_vector(7 downto 0);
    oc_mmio0_axis_awsize  : in  std_ulogic_vector(2 downto 0);
    oc_mmio0_axis_awburst : in  std_ulogic_vector(1 downto 0);
    oc_mmio0_axis_awlock  : in  std_ulogic_vector(1 downto 0);
    oc_mmio0_axis_awcache : in  std_ulogic_vector(3 downto 0);
    oc_mmio0_axis_awprot  : in  std_ulogic_vector(2 downto 0);
    oc_mmio0_axis_awvalid : in  std_ulogic;
    oc_mmio0_axis_awready : out std_ulogic;
    oc_mmio0_axis_wid     : in  std_ulogic_vector(6 downto 0);
    oc_mmio0_axis_wdata   : in  std_ulogic_vector(31 downto 0);
    oc_mmio0_axis_wstrb   : in  std_ulogic_vector(3 downto 0);
    oc_mmio0_axis_wlast   : in  std_ulogic;
    oc_mmio0_axis_wvalid  : in  std_ulogic;
    oc_mmio0_axis_wready  : out std_ulogic;
    oc_mmio0_axis_bid     : out std_ulogic_vector(6 downto 0);
    oc_mmio0_axis_bresp   : out std_ulogic_vector(1 downto 0);
    oc_mmio0_axis_bvalid  : out std_ulogic;
    oc_mmio0_axis_bready  : in  std_ulogic;
    oc_mmio0_axis_arid    : in  std_ulogic_vector(6 downto 0);
    oc_mmio0_axis_araddr  : in  std_ulogic_vector(63 downto 0);
    oc_mmio0_axis_arlen   : in  std_ulogic_vector(7 downto 0);
    oc_mmio0_axis_arsize  : in  std_ulogic_vector(2 downto 0);
    oc_mmio0_axis_arburst : in  std_ulogic_vector(1 downto 0);
    oc_mmio0_axis_arlock  : in  std_ulogic_vector(1 downto 0);
    oc_mmio0_axis_arcache : in  std_ulogic_vector(3 downto 0);
    oc_mmio0_axis_arprot  : in  std_ulogic_vector(2 downto 0);
    oc_mmio0_axis_arvalid : in  std_ulogic;
    oc_mmio0_axis_arready : out std_ulogic;
    oc_mmio0_axis_rid     : out std_ulogic_vector(6 downto 0);
    oc_mmio0_axis_rdata   : out std_ulogic_vector(31 downto 0);
    oc_mmio0_axis_rresp   : out std_ulogic_vector(1 downto 0);
    oc_mmio0_axis_rlast   : out std_ulogic;
    oc_mmio0_axis_rvalid  : out std_ulogic;
    oc_mmio0_axis_rready  : in  std_ulogic;

    oc_cfg0_axis_aclk    : in  std_ulogic;
    oc_cfg0_axis_aresetn : in  std_ulogic;
    oc_cfg0_axis_awid    : in  std_ulogic_vector(6 downto 0);
    oc_cfg0_axis_awaddr  : in  std_ulogic_vector(63 downto 0);
    oc_cfg0_axis_awlen   : in  std_ulogic_vector(7 downto 0);
    oc_cfg0_axis_awsize  : in  std_ulogic_vector(2 downto 0);
    oc_cfg0_axis_awburst : in  std_ulogic_vector(1 downto 0);
    oc_cfg0_axis_awlock  : in  std_ulogic_vector(1 downto 0);
    oc_cfg0_axis_awcache : in  std_ulogic_vector(3 downto 0);
    oc_cfg0_axis_awprot  : in  std_ulogic_vector(2 downto 0);
    oc_cfg0_axis_awvalid : in  std_ulogic;
    oc_cfg0_axis_awready : out std_ulogic;
    oc_cfg0_axis_wid     : in  std_ulogic_vector(6 downto 0);
    oc_cfg0_axis_wdata   : in  std_ulogic_vector(31 downto 0);
    oc_cfg0_axis_wstrb   : in  std_ulogic_vector(3 downto 0);
    oc_cfg0_axis_wlast   : in  std_ulogic;
    oc_cfg0_axis_wvalid  : in  std_ulogic;
    oc_cfg0_axis_wready  : out std_ulogic;
    oc_cfg0_axis_bid     : out std_ulogic_vector(6 downto 0);
    oc_cfg0_axis_bresp   : out std_ulogic_vector(1 downto 0);
    oc_cfg0_axis_bvalid  : out std_ulogic;
    oc_cfg0_axis_bready  : in  std_ulogic;
    oc_cfg0_axis_arid    : in  std_ulogic_vector(6 downto 0);
    oc_cfg0_axis_araddr  : in  std_ulogic_vector(63 downto 0);
    oc_cfg0_axis_arlen   : in  std_ulogic_vector(7 downto 0);
    oc_cfg0_axis_arsize  : in  std_ulogic_vector(2 downto 0);
    oc_cfg0_axis_arburst : in  std_ulogic_vector(1 downto 0);
    oc_cfg0_axis_arlock  : in  std_ulogic_vector(1 downto 0);
    oc_cfg0_axis_arcache : in  std_ulogic_vector(3 downto 0);
    oc_cfg0_axis_arprot  : in  std_ulogic_vector(2 downto 0);
    oc_cfg0_axis_arvalid : in  std_ulogic;
    oc_cfg0_axis_arready : out std_ulogic;
    oc_cfg0_axis_rid     : out std_ulogic_vector(6 downto 0);
    oc_cfg0_axis_rdata   : out std_ulogic_vector(31 downto 0);
    oc_cfg0_axis_rresp   : out std_ulogic_vector(1 downto 0);
    oc_cfg0_axis_rlast   : out std_ulogic;
    oc_cfg0_axis_rvalid  : out std_ulogic;
    oc_cfg0_axis_rready  : in  std_ulogic;

    c3s_dlx0_axis_aclk    : in  std_ulogic;
    c3s_dlx0_axis_aresetn : in  std_ulogic;
    c3s_dlx0_axis_awvalid : in  std_ulogic;
    c3s_dlx0_axis_awready : out std_ulogic;
    c3s_dlx0_axis_awaddr  : in  std_ulogic_vector(63 downto 0);
    c3s_dlx0_axis_awprot  : in  std_ulogic_vector(2 downto 0);
    c3s_dlx0_axis_wvalid  : in  std_ulogic;
    c3s_dlx0_axis_wready  : out std_ulogic;
    c3s_dlx0_axis_wdata   : in  std_ulogic_vector(31 downto 0);
    c3s_dlx0_axis_wstrb   : in  std_ulogic_vector(3 downto 0);
    c3s_dlx0_axis_bvalid  : out std_ulogic;
    c3s_dlx0_axis_bready  : in  std_ulogic;
    c3s_dlx0_axis_bresp   : out std_ulogic_vector(1 downto 0);
    c3s_dlx0_axis_arvalid : in  std_ulogic;
    c3s_dlx0_axis_arready : out std_ulogic;
    c3s_dlx0_axis_araddr  : in  std_ulogic_vector(63 downto 0);
    c3s_dlx0_axis_arprot  : in  std_ulogic_vector(2 downto 0);
    c3s_dlx0_axis_rvalid  : out std_ulogic;
    c3s_dlx0_axis_rready  : in  std_ulogic;
    c3s_dlx0_axis_rdata   : out std_ulogic_vector(31 downto 0);
    c3s_dlx0_axis_rresp   : out std_ulogic_vector(1 downto 0);

    fbist_axis_aclk    : in  std_ulogic;
    fbist_axis_aresetn : in  std_ulogic;
    fbist_axis_awvalid : in  std_ulogic;
    fbist_axis_awready : out std_ulogic;
    fbist_axis_awaddr  : in  std_ulogic_vector(63 downto 0);
    fbist_axis_awprot  : in  std_ulogic_vector(2 downto 0);
    fbist_axis_wvalid  : in  std_ulogic;
    fbist_axis_wready  : out std_ulogic;
    fbist_axis_wdata   : in  std_ulogic_vector(31 downto 0);
    fbist_axis_wstrb   : in  std_ulogic_vector(3 downto 0);
    fbist_axis_bvalid  : out std_ulogic;
    fbist_axis_bready  : in  std_ulogic;
    fbist_axis_bresp   : out std_ulogic_vector(1 downto 0);
    fbist_axis_arvalid : in  std_ulogic;
    fbist_axis_arready : out std_ulogic;
    fbist_axis_araddr  : in  std_ulogic_vector(63 downto 0);
    fbist_axis_arprot  : in  std_ulogic_vector(2 downto 0);
    fbist_axis_rvalid  : out std_ulogic;
    fbist_axis_rready  : in  std_ulogic;
    fbist_axis_rdata   : out std_ulogic_vector(31 downto 0);
    fbist_axis_rresp   : out std_ulogic_vector(1 downto 0);

    oc_host_cfg0_axis_aclk    : in  std_ulogic;
    oc_host_cfg0_axis_aresetn : in  std_ulogic;
    oc_host_cfg0_axis_awvalid : in  std_ulogic;
    oc_host_cfg0_axis_awready : out std_ulogic;
    oc_host_cfg0_axis_awaddr  : in  std_ulogic_vector(63 downto 0);
    oc_host_cfg0_axis_awprot  : in  std_ulogic_vector(2 downto 0);
    oc_host_cfg0_axis_wvalid  : in  std_ulogic;
    oc_host_cfg0_axis_wready  : out std_ulogic;
    oc_host_cfg0_axis_wdata   : in  std_ulogic_vector(31 downto 0);
    oc_host_cfg0_axis_wstrb   : in  std_ulogic_vector(3 downto 0);
    oc_host_cfg0_axis_bvalid  : out std_ulogic;
    oc_host_cfg0_axis_bready  : in  std_ulogic;
    oc_host_cfg0_axis_bresp   : out std_ulogic_vector(1 downto 0);
    oc_host_cfg0_axis_arvalid : in  std_ulogic;
    oc_host_cfg0_axis_arready : out std_ulogic;
    oc_host_cfg0_axis_araddr  : in  std_ulogic_vector(63 downto 0);
    oc_host_cfg0_axis_arprot  : in  std_ulogic_vector(2 downto 0);
    oc_host_cfg0_axis_rvalid  : out std_ulogic;
    oc_host_cfg0_axis_rready  : in  std_ulogic;
    oc_host_cfg0_axis_rdata   : out std_ulogic_vector(31 downto 0);
    oc_host_cfg0_axis_rresp   : out std_ulogic_vector(1 downto 0)
    );

  attribute BLOCK_TYPE of fire_emulate : entity is SOFT;
  attribute BTR_NAME of fire_emulate : entity is "FIRE_EMULATE";
  attribute RECURSIVE_SYNTHESIS of fire_emulate : entity is 2;
end fire_emulate;

architecture fire_emulate of fire_emulate is
  SIGNAL rclk : std_ulogic;
  SIGNAL clk_in_phase : std_ulogic;
  SIGNAL delay : std_ulogic_vector(0 to 7);
  SIGNAL inject_crc : std_ulogic;
  SIGNAL dlx0_ln0_tx_data : std_ulogic_vector(0 to 63);
  SIGNAL dlx0_l0_tx_data : std_ulogic_vector(63 downto 0);
  SIGNAL dlx0_ln0_tx_header : std_ulogic_vector(0 to 1);
  SIGNAL dlx0_l0_tx_header : std_ulogic_vector(1 downto 0);
  SIGNAL dlx0_ln0_tx_seq : std_ulogic_vector(0 to 5);
  SIGNAL dlx0_l0_tx_seq : std_ulogic_vector(5 downto 0);
  SIGNAL dlx0_ln1_tx_data : std_ulogic_vector(0 to 63);
  SIGNAL dlx0_l1_tx_data : std_ulogic_vector(63 downto 0);
  SIGNAL dlx0_ln1_tx_header : std_ulogic_vector(0 to 1);
  SIGNAL dlx0_l1_tx_header : std_ulogic_vector(1 downto 0);
  SIGNAL dlx0_ln1_tx_seq : std_ulogic_vector(0 to 5);
  SIGNAL dlx0_l1_tx_seq : std_ulogic_vector(5 downto 0);
  SIGNAL dlx0_ln2_tx_data : std_ulogic_vector(0 to 63);
  SIGNAL dlx0_l2_tx_data : std_ulogic_vector(63 downto 0);
  SIGNAL dlx0_ln2_tx_header : std_ulogic_vector(0 to 1);
  SIGNAL dlx0_l2_tx_header : std_ulogic_vector(1 downto 0);
  SIGNAL dlx0_ln2_tx_seq : std_ulogic_vector(0 to 5);
  SIGNAL dlx0_l2_tx_seq : std_ulogic_vector(5 downto 0);
  SIGNAL dlx0_ln3_tx_data : std_ulogic_vector(0 to 63);
  SIGNAL dlx0_l3_tx_data : std_ulogic_vector(63 downto 0);
  SIGNAL dlx0_ln3_tx_header : std_ulogic_vector(0 to 1);
  SIGNAL dlx0_l3_tx_header : std_ulogic_vector(1 downto 0);
  SIGNAL dlx0_ln3_tx_seq : std_ulogic_vector(0 to 5);
  SIGNAL dlx0_l3_tx_seq : std_ulogic_vector(5 downto 0);
  SIGNAL dlx0_ln4_tx_data : std_ulogic_vector(0 to 63);
  SIGNAL dlx0_l4_tx_data : std_ulogic_vector(63 downto 0);
  SIGNAL dlx0_ln4_tx_header : std_ulogic_vector(0 to 1);
  SIGNAL dlx0_l4_tx_header : std_ulogic_vector(1 downto 0);
  SIGNAL dlx0_ln4_tx_seq : std_ulogic_vector(0 to 5);
  SIGNAL dlx0_l4_tx_seq : std_ulogic_vector(5 downto 0);
  SIGNAL dlx0_ln5_tx_data : std_ulogic_vector(0 to 63);
  SIGNAL dlx0_l5_tx_data : std_ulogic_vector(63 downto 0);
  SIGNAL dlx0_ln5_tx_header : std_ulogic_vector(0 to 1);
  SIGNAL dlx0_l5_tx_header : std_ulogic_vector(1 downto 0);
  SIGNAL dlx0_ln5_tx_seq : std_ulogic_vector(0 to 5);
  SIGNAL dlx0_l5_tx_seq : std_ulogic_vector(5 downto 0);
  SIGNAL dlx0_ln6_tx_data : std_ulogic_vector(0 to 63);
  SIGNAL dlx0_l6_tx_data : std_ulogic_vector(63 downto 0);
  SIGNAL dlx0_ln6_tx_header : std_ulogic_vector(0 to 1);
  SIGNAL dlx0_l6_tx_header : std_ulogic_vector(1 downto 0);
  SIGNAL dlx0_ln6_tx_seq : std_ulogic_vector(0 to 5);
  SIGNAL dlx0_l6_tx_seq : std_ulogic_vector(5 downto 0);
  SIGNAL dlx0_ln7_tx_data : std_ulogic_vector(0 to 63);
  SIGNAL dlx0_l7_tx_data : std_ulogic_vector(63 downto 0);
  SIGNAL dlx0_ln7_tx_header : std_ulogic_vector(0 to 1);
  SIGNAL dlx0_l7_tx_header : std_ulogic_vector(1 downto 0);
  SIGNAL dlx0_ln7_tx_seq : std_ulogic_vector(0 to 5);
  SIGNAL dlx0_l7_tx_seq : std_ulogic_vector(5 downto 0);
  SIGNAL dlx0_ln0_data : std_ulogic_vector(63 downto 0);
  SIGNAL dlx0_ln0_rx_clk : std_ulogic;
  SIGNAL dlx0_ln0_rx_data : std_ulogic_vector(63 downto 0);
  SIGNAL dlx0_ln0_rx_header : std_ulogic_vector(1 downto 0);
  SIGNAL dlx0_ln0_rx_slip : std_ulogic;
  SIGNAL dlx0_ln0_rx_valid : std_ulogic;
  SIGNAL dlx0_ln1_data : std_ulogic_vector(63 downto 0);
  SIGNAL dlx0_ln1_rx_clk : std_ulogic;
  SIGNAL dlx0_ln1_rx_data : std_ulogic_vector(63 downto 0);
  SIGNAL dlx0_ln1_rx_header : std_ulogic_vector(1 downto 0);
  SIGNAL dlx0_ln1_rx_slip : std_ulogic;
  SIGNAL dlx0_ln1_rx_valid : std_ulogic;
  SIGNAL dlx0_ln2_data : std_ulogic_vector(63 downto 0);
  SIGNAL dlx0_ln2_rx_clk : std_ulogic;
  SIGNAL dlx0_ln2_rx_data : std_ulogic_vector(63 downto 0);
  SIGNAL dlx0_ln2_rx_header : std_ulogic_vector(1 downto 0);
  SIGNAL dlx0_ln2_rx_slip : std_ulogic;
  SIGNAL dlx0_ln2_rx_valid : std_ulogic;
  SIGNAL dlx0_ln3_data : std_ulogic_vector(63 downto 0);
  SIGNAL dlx0_ln3_rx_clk : std_ulogic;
  SIGNAL dlx0_ln3_rx_data : std_ulogic_vector(63 downto 0);
  SIGNAL dlx0_ln3_rx_header : std_ulogic_vector(1 downto 0);
  SIGNAL dlx0_ln3_rx_slip : std_ulogic;
  SIGNAL dlx0_ln3_rx_valid : std_ulogic;
  SIGNAL dlx0_ln4_data : std_ulogic_vector(63 downto 0);
  SIGNAL dlx0_ln4_rx_clk : std_ulogic;
  SIGNAL dlx0_ln4_rx_data : std_ulogic_vector(63 downto 0);
  SIGNAL dlx0_ln4_rx_header : std_ulogic_vector(1 downto 0);
  SIGNAL dlx0_ln4_rx_slip : std_ulogic;
  SIGNAL dlx0_ln4_rx_valid : std_ulogic;
  SIGNAL dlx0_ln5_data : std_ulogic_vector(63 downto 0);
  SIGNAL dlx0_ln5_rx_clk : std_ulogic;
  SIGNAL dlx0_ln5_rx_data : std_ulogic_vector(63 downto 0);
  SIGNAL dlx0_ln5_rx_header : std_ulogic_vector(1 downto 0);
  SIGNAL dlx0_ln5_rx_slip : std_ulogic;
  SIGNAL dlx0_ln5_rx_valid : std_ulogic;
  SIGNAL dlx0_ln6_data : std_ulogic_vector(63 downto 0);
  SIGNAL dlx0_ln6_rx_clk : std_ulogic;
  SIGNAL dlx0_ln6_rx_data : std_ulogic_vector(63 downto 0);
  SIGNAL dlx0_ln6_rx_header : std_ulogic_vector(1 downto 0);
  SIGNAL dlx0_ln6_rx_slip : std_ulogic;
  SIGNAL dlx0_ln6_rx_valid : std_ulogic;
  SIGNAL dlx0_ln7_data : std_ulogic_vector(63 downto 0);
  SIGNAL dlx0_ln7_rx_clk : std_ulogic;
  SIGNAL dlx0_ln7_rx_data : std_ulogic_vector(63 downto 0);
  SIGNAL dlx0_ln7_rx_header : std_ulogic_vector(1 downto 0);
  SIGNAL dlx0_ln7_rx_slip : std_ulogic;
  SIGNAL dlx0_ln7_rx_valid : std_ulogic;
  SIGNAL sysclk : std_ulogic;
  SIGNAL c3s_dlx0_axis_i : t_AXI4_LITE_SLAVE_INPUT;
  SIGNAL c3s_dlx0_axis_o : t_AXI4_LITE_SLAVE_OUTPUT;
  SIGNAL sys_resetn : std_ulogic;
  SIGNAL gtwiz_buffbypass_rx_done_in : std_ulogic;
  SIGNAL gtwiz_buffbypass_tx_done_in : std_ulogic;
  SIGNAL gtwiz_reset_all_out : std_ulogic;
  SIGNAL gtwiz_reset_rx_datapath_out : std_ulogic;
  SIGNAL gtwiz_reset_rx_done_in : std_ulogic;
  SIGNAL gtwiz_reset_tx_done_in : std_ulogic;
  SIGNAL gtwiz_userclk_rx_active_in : std_ulogic;
  SIGNAL gtwiz_userclk_tx_active_in : std_ulogic;
  SIGNAL hb_gtwiz_reset_all_in : std_ulogic;
  SIGNAL oc_memory0_axis_i : t_AXI3_SLAVE_INPUT;
  SIGNAL oc_memory0_axis_o : t_AXI3_SLAVE_OUTPUT;
  SIGNAL oc_mmio0_axis_i : t_AXI3_SLAVE_INPUT;
  SIGNAL oc_mmio0_axis_o : t_AXI3_SLAVE_OUTPUT;
  SIGNAL oc_cfg0_axis_i : t_AXI3_SLAVE_INPUT;
  SIGNAL oc_cfg0_axis_o : t_AXI3_SLAVE_OUTPUT;
  SIGNAL fbist_axis_i : t_AXI4_LITE_SLAVE_INPUT;
  SIGNAL fbist_axis_o : t_AXI4_LITE_SLAVE_OUTPUT;
  SIGNAL oc_host_cfg0_axis_i : t_AXI4_LITE_SLAVE_INPUT;
  SIGNAL oc_host_cfg0_axis_o : t_AXI4_LITE_SLAVE_OUTPUT;
  SIGNAL cclk_a : std_ulogic;
  SIGNAL cresetn_a : std_ulogic;
  SIGNAL ocde : std_ulogic;
  signal tsm_state6_to_1 : std_ulogic;

begin

  -----------------------------------------------------------------------------
  -- Clocking & Configuration
  -----------------------------------------------------------------------------
  rclk          <= NOT opt_gckn_4x;
  cclk_a        <= NOT opt_gckn_4x;
  sysclk        <= NOT opt_gckn_4x;
  sys_resetn    <= not reset;
  cresetn_a     <= not reset;

  gtwiz_buffbypass_rx_done_in <= gtwiz_done;
  gtwiz_buffbypass_tx_done_in <= gtwiz_done;
  gtwiz_reset_rx_done_in      <= gtwiz_done;
  gtwiz_reset_tx_done_in      <= gtwiz_done;
  gtwiz_userclk_rx_active_in  <= gtwiz_done;
  gtwiz_userclk_tx_active_in  <= gtwiz_done;
  hb_gtwiz_reset_all_in       <= '0';
  ocde                        <= '1';

  -----------------------------------------------------------------------------
  -- AXI Interfaces
  -----------------------------------------------------------------------------
  -- OpenCAPI Memory
  oc_memory0_axis_i.s0_axi_aresetn             <= oc_memory0_axis_aresetn;
  oc_memory0_axis_i.s0_axi_awid(6 downto 0)    <= oc_memory0_axis_awid(6 downto 0);
  oc_memory0_axis_i.s0_axi_awaddr(63 downto 0) <= oc_memory0_axis_awaddr(63 downto 0);
  oc_memory0_axis_i.s0_axi_awlen(3 downto 0)   <= oc_memory0_axis_awlen(3 downto 0);
  oc_memory0_axis_i.s0_axi_awsize(2 downto 0)  <= oc_memory0_axis_awsize(2 downto 0);
  oc_memory0_axis_i.s0_axi_awburst(1 downto 0) <= oc_memory0_axis_awburst(1 downto 0);
  oc_memory0_axis_i.s0_axi_awlock(1 downto 0)  <= oc_memory0_axis_awlock(1 downto 0);
  oc_memory0_axis_i.s0_axi_awcache(3 downto 0) <= oc_memory0_axis_awcache(3 downto 0);
  oc_memory0_axis_i.s0_axi_awprot(2 downto 0)  <= oc_memory0_axis_awprot(2 downto 0);
  oc_memory0_axis_i.s0_axi_awvalid             <= oc_memory0_axis_awvalid;
  oc_memory0_axis_awready                      <= oc_memory0_axis_o.s0_axi_awready;
  oc_memory0_axis_i.s0_axi_wid(6 downto 0)     <= oc_memory0_axis_wid(6 downto 0);
  oc_memory0_axis_i.s0_axi_wdata(31 downto 0)  <= oc_memory0_axis_wdata(31 downto 0);
  oc_memory0_axis_i.s0_axi_wstrb(3 downto 0)   <= oc_memory0_axis_wstrb(3 downto 0);
  oc_memory0_axis_i.s0_axi_wlast               <= oc_memory0_axis_wlast;
  oc_memory0_axis_i.s0_axi_wvalid              <= oc_memory0_axis_wvalid;
  oc_memory0_axis_wready                       <= oc_memory0_axis_o.s0_axi_wready;
  oc_memory0_axis_bid(6 downto 0)              <= oc_memory0_axis_o.s0_axi_bid(6 downto 0);
  oc_memory0_axis_bresp(1 downto 0)            <= oc_memory0_axis_o.s0_axi_bresp(1 downto 0);
  oc_memory0_axis_bvalid                       <= oc_memory0_axis_o.s0_axi_bvalid;
  oc_memory0_axis_i.s0_axi_bready              <= oc_memory0_axis_bready;
  oc_memory0_axis_i.s0_axi_arid(6 downto 0)    <= oc_memory0_axis_arid(6 downto 0);
  oc_memory0_axis_i.s0_axi_araddr(63 downto 0) <= oc_memory0_axis_araddr(63 downto 0);
  oc_memory0_axis_i.s0_axi_arlen(3 downto 0)   <= oc_memory0_axis_arlen(3 downto 0);
  oc_memory0_axis_i.s0_axi_arsize(2 downto 0)  <= oc_memory0_axis_arsize(2 downto 0);
  oc_memory0_axis_i.s0_axi_arburst(1 downto 0) <= oc_memory0_axis_arburst(1 downto 0);
  oc_memory0_axis_i.s0_axi_arlock(1 downto 0)  <= oc_memory0_axis_arlock(1 downto 0);
  oc_memory0_axis_i.s0_axi_arcache(3 downto 0) <= oc_memory0_axis_arcache(3 downto 0);
  oc_memory0_axis_i.s0_axi_arprot(2 downto 0)  <= oc_memory0_axis_arprot(2 downto 0);
  oc_memory0_axis_i.s0_axi_arvalid             <= oc_memory0_axis_arvalid;
  oc_memory0_axis_arready                      <= oc_memory0_axis_o.s0_axi_arready;
  oc_memory0_axis_rid(6 downto 0)              <= oc_memory0_axis_o.s0_axi_rid(6 downto 0);
  oc_memory0_axis_rdata(31 downto 0)           <= oc_memory0_axis_o.s0_axi_rdata(31 downto 0);
  oc_memory0_axis_rresp(1 downto 0)            <= oc_memory0_axis_o.s0_axi_rresp(1 downto 0);
  oc_memory0_axis_rlast                        <= oc_memory0_axis_o.s0_axi_rlast;
  oc_memory0_axis_rvalid                       <= oc_memory0_axis_o.s0_axi_rvalid;
  oc_memory0_axis_i.s0_axi_rready              <= oc_memory0_axis_rready;

  -- OpenCAPI MMIO
  oc_mmio0_axis_i.s0_axi_aresetn             <= oc_mmio0_axis_aresetn;
  oc_mmio0_axis_i.s0_axi_awid(6 downto 0)    <= oc_mmio0_axis_awid(6 downto 0);
  oc_mmio0_axis_i.s0_axi_awaddr(63 downto 0) <= oc_mmio0_axis_awaddr(63 downto 0);
  oc_mmio0_axis_i.s0_axi_awlen(3 downto 0)   <= oc_mmio0_axis_awlen(3 downto 0);
  oc_mmio0_axis_i.s0_axi_awsize(2 downto 0)  <= oc_mmio0_axis_awsize(2 downto 0);
  oc_mmio0_axis_i.s0_axi_awburst(1 downto 0) <= oc_mmio0_axis_awburst(1 downto 0);
  oc_mmio0_axis_i.s0_axi_awlock(1 downto 0)  <= oc_mmio0_axis_awlock(1 downto 0);
  oc_mmio0_axis_i.s0_axi_awcache(3 downto 0) <= oc_mmio0_axis_awcache(3 downto 0);
  oc_mmio0_axis_i.s0_axi_awprot(2 downto 0)  <= oc_mmio0_axis_awprot(2 downto 0);
  oc_mmio0_axis_i.s0_axi_awvalid             <= oc_mmio0_axis_awvalid;
  oc_mmio0_axis_awready                      <= oc_mmio0_axis_o.s0_axi_awready;
  oc_mmio0_axis_i.s0_axi_wid(6 downto 0)     <= oc_mmio0_axis_wid(6 downto 0);
  oc_mmio0_axis_i.s0_axi_wdata(31 downto 0)  <= oc_mmio0_axis_wdata(31 downto 0);
  oc_mmio0_axis_i.s0_axi_wstrb(3 downto 0)   <= oc_mmio0_axis_wstrb(3 downto 0);
  oc_mmio0_axis_i.s0_axi_wlast               <= oc_mmio0_axis_wlast;
  oc_mmio0_axis_i.s0_axi_wvalid              <= oc_mmio0_axis_wvalid;
  oc_mmio0_axis_wready                       <= oc_mmio0_axis_o.s0_axi_wready;
  oc_mmio0_axis_bid(6 downto 0)              <= oc_mmio0_axis_o.s0_axi_bid(6 downto 0);
  oc_mmio0_axis_bresp(1 downto 0)            <= oc_mmio0_axis_o.s0_axi_bresp(1 downto 0);
  oc_mmio0_axis_bvalid                       <= oc_mmio0_axis_o.s0_axi_bvalid;
  oc_mmio0_axis_i.s0_axi_bready              <= oc_mmio0_axis_bready;
  oc_mmio0_axis_i.s0_axi_arid(6 downto 0)    <= oc_mmio0_axis_arid(6 downto 0);
  oc_mmio0_axis_i.s0_axi_araddr(63 downto 0) <= oc_mmio0_axis_araddr(63 downto 0);
  oc_mmio0_axis_i.s0_axi_arlen(3 downto 0)   <= oc_mmio0_axis_arlen(3 downto 0);
  oc_mmio0_axis_i.s0_axi_arsize(2 downto 0)  <= oc_mmio0_axis_arsize(2 downto 0);
  oc_mmio0_axis_i.s0_axi_arburst(1 downto 0) <= oc_mmio0_axis_arburst(1 downto 0);
  oc_mmio0_axis_i.s0_axi_arlock(1 downto 0)  <= oc_mmio0_axis_arlock(1 downto 0);
  oc_mmio0_axis_i.s0_axi_arcache(3 downto 0) <= oc_mmio0_axis_arcache(3 downto 0);
  oc_mmio0_axis_i.s0_axi_arprot(2 downto 0)  <= oc_mmio0_axis_arprot(2 downto 0);
  oc_mmio0_axis_i.s0_axi_arvalid             <= oc_mmio0_axis_arvalid;
  oc_mmio0_axis_arready                      <= oc_mmio0_axis_o.s0_axi_arready;
  oc_mmio0_axis_rid(6 downto 0)              <= oc_mmio0_axis_o.s0_axi_rid(6 downto 0);
  oc_mmio0_axis_rdata(31 downto 0)           <= oc_mmio0_axis_o.s0_axi_rdata(31 downto 0);
  oc_mmio0_axis_rresp(1 downto 0)            <= oc_mmio0_axis_o.s0_axi_rresp(1 downto 0);
  oc_mmio0_axis_rlast                        <= oc_mmio0_axis_o.s0_axi_rlast;
  oc_mmio0_axis_rvalid                       <= oc_mmio0_axis_o.s0_axi_rvalid;
  oc_mmio0_axis_i.s0_axi_rready              <= oc_mmio0_axis_rready;

  -- OpenCAPI Config Space
  oc_cfg0_axis_i.s0_axi_aresetn             <= oc_cfg0_axis_aresetn;
  oc_cfg0_axis_i.s0_axi_awid(6 downto 0)    <= oc_cfg0_axis_awid(6 downto 0);
  oc_cfg0_axis_i.s0_axi_awaddr(63 downto 0) <= oc_cfg0_axis_awaddr(63 downto 0);
  oc_cfg0_axis_i.s0_axi_awlen(3 downto 0)   <= oc_cfg0_axis_awlen(3 downto 0);
  oc_cfg0_axis_i.s0_axi_awsize(2 downto 0)  <= oc_cfg0_axis_awsize(2 downto 0);
  oc_cfg0_axis_i.s0_axi_awburst(1 downto 0) <= oc_cfg0_axis_awburst(1 downto 0);
  oc_cfg0_axis_i.s0_axi_awlock(1 downto 0)  <= oc_cfg0_axis_awlock(1 downto 0);
  oc_cfg0_axis_i.s0_axi_awcache(3 downto 0) <= oc_cfg0_axis_awcache(3 downto 0);
  oc_cfg0_axis_i.s0_axi_awprot(2 downto 0)  <= oc_cfg0_axis_awprot(2 downto 0);
  oc_cfg0_axis_i.s0_axi_awvalid             <= oc_cfg0_axis_awvalid;
  oc_cfg0_axis_awready                      <= oc_cfg0_axis_o.s0_axi_awready;
  oc_cfg0_axis_i.s0_axi_wid(6 downto 0)     <= oc_cfg0_axis_wid(6 downto 0);
  oc_cfg0_axis_i.s0_axi_wdata(31 downto 0)  <= oc_cfg0_axis_wdata(31 downto 0);
  oc_cfg0_axis_i.s0_axi_wstrb(3 downto 0)   <= oc_cfg0_axis_wstrb(3 downto 0);
  oc_cfg0_axis_i.s0_axi_wlast               <= oc_cfg0_axis_wlast;
  oc_cfg0_axis_i.s0_axi_wvalid              <= oc_cfg0_axis_wvalid;
  oc_cfg0_axis_wready                       <= oc_cfg0_axis_o.s0_axi_wready;
  oc_cfg0_axis_bid(6 downto 0)              <= oc_cfg0_axis_o.s0_axi_bid(6 downto 0);
  oc_cfg0_axis_bresp(1 downto 0)            <= oc_cfg0_axis_o.s0_axi_bresp(1 downto 0);
  oc_cfg0_axis_bvalid                       <= oc_cfg0_axis_o.s0_axi_bvalid;
  oc_cfg0_axis_i.s0_axi_bready              <= oc_cfg0_axis_bready;
  oc_cfg0_axis_i.s0_axi_arid(6 downto 0)    <= oc_cfg0_axis_arid(6 downto 0);
  oc_cfg0_axis_i.s0_axi_araddr(63 downto 0) <= oc_cfg0_axis_araddr(63 downto 0);
  oc_cfg0_axis_i.s0_axi_arlen(3 downto 0)   <= oc_cfg0_axis_arlen(3 downto 0);
  oc_cfg0_axis_i.s0_axi_arsize(2 downto 0)  <= oc_cfg0_axis_arsize(2 downto 0);
  oc_cfg0_axis_i.s0_axi_arburst(1 downto 0) <= oc_cfg0_axis_arburst(1 downto 0);
  oc_cfg0_axis_i.s0_axi_arlock(1 downto 0)  <= oc_cfg0_axis_arlock(1 downto 0);
  oc_cfg0_axis_i.s0_axi_arcache(3 downto 0) <= oc_cfg0_axis_arcache(3 downto 0);
  oc_cfg0_axis_i.s0_axi_arprot(2 downto 0)  <= oc_cfg0_axis_arprot(2 downto 0);
  oc_cfg0_axis_i.s0_axi_arvalid             <= oc_cfg0_axis_arvalid;
  oc_cfg0_axis_arready                      <= oc_cfg0_axis_o.s0_axi_arready;
  oc_cfg0_axis_rid(6 downto 0)              <= oc_cfg0_axis_o.s0_axi_rid(6 downto 0);
  oc_cfg0_axis_rdata(31 downto 0)           <= oc_cfg0_axis_o.s0_axi_rdata(31 downto 0);
  oc_cfg0_axis_rresp(1 downto 0)            <= oc_cfg0_axis_o.s0_axi_rresp(1 downto 0);
  oc_cfg0_axis_rlast                        <= oc_cfg0_axis_o.s0_axi_rlast;
  oc_cfg0_axis_rvalid                       <= oc_cfg0_axis_o.s0_axi_rvalid;
  oc_cfg0_axis_i.s0_axi_rready              <= oc_cfg0_axis_rready;

  -- C3S
  c3s_dlx0_axis_i.s0_axi_aresetn             <= c3s_dlx0_axis_aresetn;
  c3s_dlx0_axis_i.s0_axi_awvalid             <= c3s_dlx0_axis_awvalid;
  c3s_dlx0_axis_awready                      <= c3s_dlx0_axis_o.s0_axi_awready;
  c3s_dlx0_axis_i.s0_axi_awaddr(63 downto 0) <= c3s_dlx0_axis_awaddr(63 downto 0);
  c3s_dlx0_axis_i.s0_axi_awprot(2 downto 0)  <= c3s_dlx0_axis_awprot(2 downto 0);
  c3s_dlx0_axis_i.s0_axi_wvalid              <= c3s_dlx0_axis_wvalid;
  c3s_dlx0_axis_wready                       <= c3s_dlx0_axis_o.s0_axi_wready;
  c3s_dlx0_axis_i.s0_axi_wdata(31 downto 0)  <= c3s_dlx0_axis_wdata(31 downto 0);
  c3s_dlx0_axis_i.s0_axi_wstrb(3 downto 0)   <= c3s_dlx0_axis_wstrb(3 downto 0);
  c3s_dlx0_axis_bvalid                       <= c3s_dlx0_axis_o.s0_axi_bvalid;
  c3s_dlx0_axis_i.s0_axi_bready              <= c3s_dlx0_axis_bready;
  c3s_dlx0_axis_bresp(1 downto 0)            <= c3s_dlx0_axis_o.s0_axi_bresp(1 downto 0);
  c3s_dlx0_axis_i.s0_axi_arvalid             <= c3s_dlx0_axis_arvalid;
  c3s_dlx0_axis_arready                      <= c3s_dlx0_axis_o.s0_axi_arready;
  c3s_dlx0_axis_i.s0_axi_araddr(63 downto 0) <= c3s_dlx0_axis_araddr(63 downto 0);
  c3s_dlx0_axis_i.s0_axi_arprot(2 downto 0)  <= c3s_dlx0_axis_arprot(2 downto 0);
  c3s_dlx0_axis_rvalid                       <= c3s_dlx0_axis_o.s0_axi_rvalid;
  c3s_dlx0_axis_i.s0_axi_rready              <= c3s_dlx0_axis_rready;
  c3s_dlx0_axis_rdata(31 downto 0)           <= c3s_dlx0_axis_o.s0_axi_rdata(31 downto 0);
  c3s_dlx0_axis_rresp(1 downto 0)            <= c3s_dlx0_axis_o.s0_axi_rresp(1 downto 0);

  -- FBIST
  fbist_axis_i.s0_axi_aresetn             <= fbist_axis_aresetn;
  fbist_axis_i.s0_axi_awvalid             <= fbist_axis_awvalid;
  fbist_axis_awready                      <= fbist_axis_o.s0_axi_awready;
  fbist_axis_i.s0_axi_awaddr(63 downto 0) <= fbist_axis_awaddr(63 downto 0);
  fbist_axis_i.s0_axi_awprot(2 downto 0)  <= fbist_axis_awprot(2 downto 0);
  fbist_axis_i.s0_axi_wvalid              <= fbist_axis_wvalid;
  fbist_axis_wready                       <= fbist_axis_o.s0_axi_wready;
  fbist_axis_i.s0_axi_wdata(31 downto 0)  <= fbist_axis_wdata(31 downto 0);
  fbist_axis_i.s0_axi_wstrb(3 downto 0)   <= fbist_axis_wstrb(3 downto 0);
  fbist_axis_bvalid                       <= fbist_axis_o.s0_axi_bvalid;
  fbist_axis_i.s0_axi_bready              <= fbist_axis_bready;
  fbist_axis_bresp(1 downto 0)            <= fbist_axis_o.s0_axi_bresp(1 downto 0);
  fbist_axis_i.s0_axi_arvalid             <= fbist_axis_arvalid;
  fbist_axis_arready                      <= fbist_axis_o.s0_axi_arready;
  fbist_axis_i.s0_axi_araddr(63 downto 0) <= fbist_axis_araddr(63 downto 0);
  fbist_axis_i.s0_axi_arprot(2 downto 0)  <= fbist_axis_arprot(2 downto 0);
  fbist_axis_rvalid                       <= fbist_axis_o.s0_axi_rvalid;
  fbist_axis_i.s0_axi_rready              <= fbist_axis_rready;
  fbist_axis_rdata(31 downto 0)           <= fbist_axis_o.s0_axi_rdata(31 downto 0);
  fbist_axis_rresp(1 downto 0)            <= fbist_axis_o.s0_axi_rresp(1 downto 0);

  -- OpenCAPI Host Configuration
  oc_host_cfg0_axis_i.s0_axi_aresetn             <= oc_host_cfg0_axis_aresetn;
  oc_host_cfg0_axis_i.s0_axi_awvalid             <= oc_host_cfg0_axis_awvalid;
  oc_host_cfg0_axis_awready                      <= oc_host_cfg0_axis_o.s0_axi_awready;
  oc_host_cfg0_axis_i.s0_axi_awaddr(63 downto 0) <= oc_host_cfg0_axis_awaddr(63 downto 0);
  oc_host_cfg0_axis_i.s0_axi_awprot(2 downto 0)  <= oc_host_cfg0_axis_awprot(2 downto 0);
  oc_host_cfg0_axis_i.s0_axi_wvalid              <= oc_host_cfg0_axis_wvalid;
  oc_host_cfg0_axis_wready                       <= oc_host_cfg0_axis_o.s0_axi_wready;
  oc_host_cfg0_axis_i.s0_axi_wdata(31 downto 0)  <= oc_host_cfg0_axis_wdata(31 downto 0);
  oc_host_cfg0_axis_i.s0_axi_wstrb(3 downto 0)   <= oc_host_cfg0_axis_wstrb(3 downto 0);
  oc_host_cfg0_axis_bvalid                       <= oc_host_cfg0_axis_o.s0_axi_bvalid;
  oc_host_cfg0_axis_i.s0_axi_bready              <= oc_host_cfg0_axis_bready;
  oc_host_cfg0_axis_bresp(1 downto 0)            <= oc_host_cfg0_axis_o.s0_axi_bresp(1 downto 0);
  oc_host_cfg0_axis_i.s0_axi_arvalid             <= oc_host_cfg0_axis_arvalid;
  oc_host_cfg0_axis_arready                      <= oc_host_cfg0_axis_o.s0_axi_arready;
  oc_host_cfg0_axis_i.s0_axi_araddr(63 downto 0) <= oc_host_cfg0_axis_araddr(63 downto 0);
  oc_host_cfg0_axis_i.s0_axi_arprot(2 downto 0)  <= oc_host_cfg0_axis_arprot(2 downto 0);
  oc_host_cfg0_axis_rvalid                       <= oc_host_cfg0_axis_o.s0_axi_rvalid;
  oc_host_cfg0_axis_i.s0_axi_rready              <= oc_host_cfg0_axis_rready;
  oc_host_cfg0_axis_rdata(31 downto 0)           <= oc_host_cfg0_axis_o.s0_axi_rdata(31 downto 0);
  oc_host_cfg0_axis_rresp(1 downto 0)            <= oc_host_cfg0_axis_o.s0_axi_rresp(1 downto 0);

  -----------------------------------------------------------------------------
  -- Testbench Configuration
  -----------------------------------------------------------------------------
  -- Between DLX TX and PHY
  -- dly0_## : entity work.tb_ln_dly1to4
  clk_in_phase  <= '0';
  delay(0 to 7) <= x"00";
  inject_crc    <= '0';
  -- opt_gckn      <= opt_gckn

  -----------------------------------------------------------------------------
  -- Data Routing
  -----------------------------------------------------------------------------
  -- Switch endianness
  dlx0_ln0_tx_data(0 to 63)  <= dlx0_l0_tx_data(63 downto 0);
  dlx0_ln0_tx_header(0 to 1) <= dlx0_l0_tx_header(1 downto 0);
  dlx0_ln0_tx_seq(0 to 5)    <= dlx0_l0_tx_seq(5 downto 0);
  dlx0_ln1_tx_data(0 to 63)  <= dlx0_l1_tx_data(63 downto 0);
  dlx0_ln1_tx_header(0 to 1) <= dlx0_l1_tx_header(1 downto 0);
  dlx0_ln1_tx_seq(0 to 5)    <= dlx0_l1_tx_seq(5 downto 0);
  dlx0_ln2_tx_data(0 to 63)  <= dlx0_l2_tx_data(63 downto 0);
  dlx0_ln2_tx_header(0 to 1) <= dlx0_l2_tx_header(1 downto 0);
  dlx0_ln2_tx_seq(0 to 5)    <= dlx0_l2_tx_seq(5 downto 0);
  dlx0_ln3_tx_data(0 to 63)  <= dlx0_l3_tx_data(63 downto 0);
  dlx0_ln3_tx_header(0 to 1) <= dlx0_l3_tx_header(1 downto 0);
  dlx0_ln3_tx_seq(0 to 5)    <= dlx0_l3_tx_seq(5 downto 0);
  dlx0_ln4_tx_data(0 to 63)  <= dlx0_l4_tx_data(63 downto 0);
  dlx0_ln4_tx_header(0 to 1) <= dlx0_l4_tx_header(1 downto 0);
  dlx0_ln4_tx_seq(0 to 5)    <= dlx0_l4_tx_seq(5 downto 0);
  dlx0_ln5_tx_data(0 to 63)  <= dlx0_l5_tx_data(63 downto 0);
  dlx0_ln5_tx_header(0 to 1) <= dlx0_l5_tx_header(1 downto 0);
  dlx0_ln5_tx_seq(0 to 5)    <= dlx0_l5_tx_seq(5 downto 0);
  dlx0_ln6_tx_data(0 to 63)  <= dlx0_l6_tx_data(63 downto 0);
  dlx0_ln6_tx_header(0 to 1) <= dlx0_l6_tx_header(1 downto 0);
  dlx0_ln6_tx_seq(0 to 5)    <= dlx0_l6_tx_seq(5 downto 0);
  dlx0_ln7_tx_data(0 to 63)  <= dlx0_l7_tx_data(63 downto 0);
  dlx0_ln7_tx_header(0 to 1) <= dlx0_l7_tx_header(1 downto 0);
  dlx0_ln7_tx_seq(0 to 5)    <= dlx0_l7_tx_seq(5 downto 0);

  counter : entity work.counter
    port map (
      clock => cclk_a,
      reset => reset,
      tsm_state6_to_1 => tsm_state6_to_1
      );

fire : entity work.fire_core
port map (
    c3s_dlx_axis_aclk                   => c3s_dlx0_axis_aclk                  , -- OVD: fire_core(fire)
    c3s_dlx_axis_i                      => c3s_dlx0_axis_i                     , -- OVD: fire_core(fire)
    c3s_dlx_axis_o                      => c3s_dlx0_axis_o                     , -- OVR: fire_core(fire)
    cclk                                => cclk_a                              , -- MSR: fire_core(fire)
    cresetn                             => cresetn_a                           , -- MSR: fire_core(fire)
    dlx_l0_tx_data(63 downto 0)         => dlx0_l0_tx_data(63 downto 0)        , -- OVD: fire_core(fire)
    dlx_l0_tx_header(1 downto 0)        => dlx0_l0_tx_header(1 downto 0)       , -- OVD: fire_core(fire)
    dlx_l0_tx_seq(5 downto 0)           => dlx0_l0_tx_seq(5 downto 0)          , -- OVD: fire_core(fire)
    dlx_l1_tx_data(63 downto 0)         => dlx0_l1_tx_data(63 downto 0)        , -- OVD: fire_core(fire)
    dlx_l1_tx_header(1 downto 0)        => dlx0_l1_tx_header(1 downto 0)       , -- OVD: fire_core(fire)
    dlx_l1_tx_seq(5 downto 0)           => dlx0_l1_tx_seq(5 downto 0)          , -- OVD: fire_core(fire)
    dlx_l2_tx_data(63 downto 0)         => dlx0_l2_tx_data(63 downto 0)        , -- OVD: fire_core(fire)
    dlx_l2_tx_header(1 downto 0)        => dlx0_l2_tx_header(1 downto 0)       , -- OVD: fire_core(fire)
    dlx_l2_tx_seq(5 downto 0)           => dlx0_l2_tx_seq(5 downto 0)          , -- OVD: fire_core(fire)
    dlx_l3_tx_data(63 downto 0)         => dlx0_l3_tx_data(63 downto 0)        , -- OVD: fire_core(fire)
    dlx_l3_tx_header(1 downto 0)        => dlx0_l3_tx_header(1 downto 0)       , -- OVD: fire_core(fire)
    dlx_l3_tx_seq(5 downto 0)           => dlx0_l3_tx_seq(5 downto 0)          , -- OVD: fire_core(fire)
    dlx_l4_tx_data(63 downto 0)         => dlx0_l4_tx_data(63 downto 0)        , -- OVD: fire_core(fire)
    dlx_l4_tx_header(1 downto 0)        => dlx0_l4_tx_header(1 downto 0)       , -- OVD: fire_core(fire)
    dlx_l4_tx_seq(5 downto 0)           => dlx0_l4_tx_seq(5 downto 0)          , -- OVD: fire_core(fire)
    dlx_l5_tx_data(63 downto 0)         => dlx0_l5_tx_data(63 downto 0)        , -- OVD: fire_core(fire)
    dlx_l5_tx_header(1 downto 0)        => dlx0_l5_tx_header(1 downto 0)       , -- OVD: fire_core(fire)
    dlx_l5_tx_seq(5 downto 0)           => dlx0_l5_tx_seq(5 downto 0)          , -- OVD: fire_core(fire)
    dlx_l6_tx_data(63 downto 0)         => dlx0_l6_tx_data(63 downto 0)        , -- OVD: fire_core(fire)
    dlx_l6_tx_header(1 downto 0)        => dlx0_l6_tx_header(1 downto 0)       , -- OVD: fire_core(fire)
    dlx_l6_tx_seq(5 downto 0)           => dlx0_l6_tx_seq(5 downto 0)          , -- OVD: fire_core(fire)
    dlx_l7_tx_data(63 downto 0)         => dlx0_l7_tx_data(63 downto 0)        , -- OVD: fire_core(fire)
    dlx_l7_tx_header(1 downto 0)        => dlx0_l7_tx_header(1 downto 0)       , -- OVD: fire_core(fire)
    dlx_l7_tx_seq(5 downto 0)           => dlx0_l7_tx_seq(5 downto 0)          , -- OVD: fire_core(fire)
    fbist_axis_aclk                     => fbist_axis_aclk                     , -- MSD: fire_core(fire)
    fbist_axis_i                        => fbist_axis_i                        , -- MSD: fire_core(fire)
    fbist_axis_o                        => fbist_axis_o                        , -- MSR: fire_core(fire)
    gtwiz_buffbypass_rx_done_in         => gtwiz_buffbypass_rx_done_in         , -- MSR: fire_core(fire)
    gtwiz_buffbypass_tx_done_in         => gtwiz_buffbypass_tx_done_in         , -- MSR: fire_core(fire)
    gtwiz_reset_all_out                 => gtwiz_reset_all_out                 , -- MSD: fire_core(fire)
    gtwiz_reset_rx_datapath_out         => gtwiz_reset_rx_datapath_out         , -- MSD: fire_core(fire)
    gtwiz_reset_rx_done_in              => gtwiz_reset_rx_done_in              , -- MSR: fire_core(fire)
    gtwiz_reset_tx_done_in              => gtwiz_reset_tx_done_in              , -- MSR: fire_core(fire)
    gtwiz_userclk_rx_active_in          => gtwiz_userclk_rx_active_in          , -- MSR: fire_core(fire)
    gtwiz_userclk_tx_active_in          => gtwiz_userclk_tx_active_in          , -- MSR: fire_core(fire)
    hb_gtwiz_reset_all_in               => hb_gtwiz_reset_all_in               , -- MSR: fire_core(fire)
    ln0_rx_data(63 downto 0)            => dlx0_ln0_rx_data(63 downto 0)       , -- OVR: fire_core(fire)
    ln0_rx_header(1 downto 0)           => dlx0_ln0_rx_header(1 downto 0)      , -- OVR: fire_core(fire)
    ln0_rx_slip                         => dlx0_ln0_rx_slip                    , -- OVD: fire_core(fire)
    ln0_rx_valid                        => dlx0_ln0_rx_valid                   , -- OVR: fire_core(fire)
    ln1_rx_data(63 downto 0)            => dlx0_ln1_rx_data(63 downto 0)       , -- OVR: fire_core(fire)
    ln1_rx_header(1 downto 0)           => dlx0_ln1_rx_header(1 downto 0)      , -- OVR: fire_core(fire)
    ln1_rx_slip                         => dlx0_ln1_rx_slip                    , -- OVD: fire_core(fire)
    ln1_rx_valid                        => dlx0_ln1_rx_valid                   , -- OVR: fire_core(fire)
    ln2_rx_data(63 downto 0)            => dlx0_ln2_rx_data(63 downto 0)       , -- OVR: fire_core(fire)
    ln2_rx_header(1 downto 0)           => dlx0_ln2_rx_header(1 downto 0)      , -- OVR: fire_core(fire)
    ln2_rx_slip                         => dlx0_ln2_rx_slip                    , -- OVD: fire_core(fire)
    ln2_rx_valid                        => dlx0_ln2_rx_valid                   , -- OVR: fire_core(fire)
    ln3_rx_data(63 downto 0)            => dlx0_ln3_rx_data(63 downto 0)       , -- OVR: fire_core(fire)
    ln3_rx_header(1 downto 0)           => dlx0_ln3_rx_header(1 downto 0)      , -- OVR: fire_core(fire)
    ln3_rx_slip                         => dlx0_ln3_rx_slip                    , -- OVD: fire_core(fire)
    ln3_rx_valid                        => dlx0_ln3_rx_valid                   , -- OVR: fire_core(fire)
    ln4_rx_data(63 downto 0)            => dlx0_ln4_rx_data(63 downto 0)       , -- OVR: fire_core(fire)
    ln4_rx_header(1 downto 0)           => dlx0_ln4_rx_header(1 downto 0)      , -- OVR: fire_core(fire)
    ln4_rx_slip                         => dlx0_ln4_rx_slip                    , -- OVD: fire_core(fire)
    ln4_rx_valid                        => dlx0_ln4_rx_valid                   , -- OVR: fire_core(fire)
    ln5_rx_data(63 downto 0)            => dlx0_ln5_rx_data(63 downto 0)       , -- OVR: fire_core(fire)
    ln5_rx_header(1 downto 0)           => dlx0_ln5_rx_header(1 downto 0)      , -- OVR: fire_core(fire)
    ln5_rx_slip                         => dlx0_ln5_rx_slip                    , -- OVD: fire_core(fire)
    ln5_rx_valid                        => dlx0_ln5_rx_valid                   , -- OVR: fire_core(fire)
    ln6_rx_data(63 downto 0)            => dlx0_ln6_rx_data(63 downto 0)       , -- OVR: fire_core(fire)
    ln6_rx_header(1 downto 0)           => dlx0_ln6_rx_header(1 downto 0)      , -- OVR: fire_core(fire)
    ln6_rx_slip                         => dlx0_ln6_rx_slip                    , -- OVD: fire_core(fire)
    ln6_rx_valid                        => dlx0_ln6_rx_valid                   , -- OVR: fire_core(fire)
    ln7_rx_data(63 downto 0)            => dlx0_ln7_rx_data(63 downto 0)       , -- OVR: fire_core(fire)
    ln7_rx_header(1 downto 0)           => dlx0_ln7_rx_header(1 downto 0)      , -- OVR: fire_core(fire)
    ln7_rx_slip                         => dlx0_ln7_rx_slip                    , -- OVD: fire_core(fire)
    ln7_rx_valid                        => dlx0_ln7_rx_valid                   , -- OVR: fire_core(fire)
    oc_cfg0_axis_aclk                   => oc_cfg0_axis_aclk                   , -- MSD: fire_core(fire)
    oc_cfg0_axis_i                      => oc_cfg0_axis_i                      , -- MSD: fire_core(fire)
    oc_cfg0_axis_o                      => oc_cfg0_axis_o                      , -- MSR: fire_core(fire)
    oc_host_cfg0_axis_aclk              => oc_host_cfg0_axis_aclk              , -- MSD: fire_core(fire)
    oc_host_cfg0_axis_i                 => oc_host_cfg0_axis_i                 , -- MSD: fire_core(fire)
    oc_host_cfg0_axis_o                 => oc_host_cfg0_axis_o                 , -- MSR: fire_core(fire)
    oc_memory0_axis_aclk                => oc_memory0_axis_aclk                , -- MSR: fire_core(fire)
    oc_memory0_axis_i                   => oc_memory0_axis_i                   , -- MSD: fire_core(fire)
    oc_memory0_axis_o                   => oc_memory0_axis_o                   , -- MSR: fire_core(fire)
    oc_mmio0_axis_aclk                  => oc_mmio0_axis_aclk                  , -- MSR: fire_core(fire)
    oc_mmio0_axis_i                     => oc_mmio0_axis_i                     , -- MSD: fire_core(fire)
    oc_mmio0_axis_o                     => oc_mmio0_axis_o                     , -- MSR: fire_core(fire)
    ocde                                => ocde                                , -- MSR: fire_core(fire)
    rclk                                => rclk                                , -- MSR: fire_core(fire)
    sys_resetn                          => sys_resetn                          , -- MSR: fire_core(fire)
    sysclk                              => sysclk,                                -- MSR: fire_core(fire)
    tsm_state2_to_3 => '1',
    tsm_state6_to_1 => tsm_state6_to_1,
    tsm_state4_to_5 => '1',
    tsm_state5_to_6 => '1',
    lane_force_unlock => x"00"
);

dly0_00 : entity work.tb_ln_dly1to4
port map (
    clk_in_phase           => clk_in_phase              , -- MSR: tb_ln_dly1to4(dly0_00)
    clock_in               => opt_gckn_4x               , -- OVR: tb_ln_dly1to4(dly0_00)
    delay (0 to 7)         => delay (0 to 7)            , -- MSR: tb_ln_dly1to4(dly0_00)
    inject_crc             => inject_crc                , -- MSR: tb_ln_dly1to4(dly0_00)
    lane_in_data(0 to 63)  => dlx0_ln0_tx_data(0 to 63) , -- OVR: tb_ln_dly1to4(dly0_00)
    lane_in_header(0 to 1) => dlx0_ln0_tx_header(0 to 1), -- OVR: tb_ln_dly1to4(dly0_00)
    lane_in_seq(0 to 5)    => dlx0_ln0_tx_seq(0 to 5)   , -- OVR: tb_ln_dly1to4(dly0_00)
    lane_out(0 to 15)      => dlx0_phy_lane_0(0 to 15)  , -- OVD: tb_ln_dly1to4(dly0_00)
    opt_gckn               => opt_gckn                    -- MSR: tb_ln_dly1to4(dly0_00)
);

dly0_01 : entity work.tb_ln_dly1to4
port map (
    clk_in_phase           => clk_in_phase              , -- MSR: tb_ln_dly1to4(dly0_01)
    clock_in               => opt_gckn_4x               , -- OVR: tb_ln_dly1to4(dly0_01)
    delay (0 to 7)         => delay (0 to 7)            , -- MSR: tb_ln_dly1to4(dly0_01)
    inject_crc             => inject_crc                , -- MSR: tb_ln_dly1to4(dly0_01)
    lane_in_data(0 to 63)  => dlx0_ln1_tx_data(0 to 63) , -- OVR: tb_ln_dly1to4(dly0_01)
    lane_in_header(0 to 1) => dlx0_ln1_tx_header(0 to 1), -- OVR: tb_ln_dly1to4(dly0_01)
    lane_in_seq(0 to 5)    => dlx0_ln1_tx_seq(0 to 5)   , -- OVR: tb_ln_dly1to4(dly0_01)
    lane_out(0 to 15)      => dlx0_phy_lane_1(0 to 15)  , -- OVD: tb_ln_dly1to4(dly0_01)
    opt_gckn               => opt_gckn                    -- MSR: tb_ln_dly1to4(dly0_01)
);

dly0_02 : entity work.tb_ln_dly1to4
port map (
    clk_in_phase           => clk_in_phase              , -- MSR: tb_ln_dly1to4(dly0_02)
    clock_in               => opt_gckn_4x               , -- OVR: tb_ln_dly1to4(dly0_02)
    delay (0 to 7)         => delay (0 to 7)            , -- MSR: tb_ln_dly1to4(dly0_02)
    inject_crc             => inject_crc                , -- MSR: tb_ln_dly1to4(dly0_02)
    lane_in_data(0 to 63)  => dlx0_ln2_tx_data(0 to 63) , -- OVR: tb_ln_dly1to4(dly0_02)
    lane_in_header(0 to 1) => dlx0_ln2_tx_header(0 to 1), -- OVR: tb_ln_dly1to4(dly0_02)
    lane_in_seq(0 to 5)    => dlx0_ln2_tx_seq(0 to 5)   , -- OVR: tb_ln_dly1to4(dly0_02)
    lane_out(0 to 15)      => dlx0_phy_lane_2(0 to 15)  , -- OVD: tb_ln_dly1to4(dly0_02)
    opt_gckn               => opt_gckn                    -- MSR: tb_ln_dly1to4(dly0_02)
);

dly0_03 : entity work.tb_ln_dly1to4
port map (
    clk_in_phase           => clk_in_phase              , -- MSR: tb_ln_dly1to4(dly0_03)
    clock_in               => opt_gckn_4x               , -- OVR: tb_ln_dly1to4(dly0_03)
    delay (0 to 7)         => delay (0 to 7)            , -- MSR: tb_ln_dly1to4(dly0_03)
    inject_crc             => inject_crc                , -- MSR: tb_ln_dly1to4(dly0_03)
    lane_in_data(0 to 63)  => dlx0_ln3_tx_data(0 to 63) , -- OVR: tb_ln_dly1to4(dly0_03)
    lane_in_header(0 to 1) => dlx0_ln3_tx_header(0 to 1), -- OVR: tb_ln_dly1to4(dly0_03)
    lane_in_seq(0 to 5)    => dlx0_ln3_tx_seq(0 to 5)   , -- OVR: tb_ln_dly1to4(dly0_03)
    lane_out(0 to 15)      => dlx0_phy_lane_3(0 to 15)  , -- OVD: tb_ln_dly1to4(dly0_03)
    opt_gckn               => opt_gckn                    -- MSR: tb_ln_dly1to4(dly0_03)
);

dly0_04 : entity work.tb_ln_dly1to4
port map (
    clk_in_phase           => clk_in_phase              , -- MSR: tb_ln_dly1to4(dly0_04)
    clock_in               => opt_gckn_4x               , -- OVR: tb_ln_dly1to4(dly0_04)
    delay (0 to 7)         => delay (0 to 7)            , -- MSR: tb_ln_dly1to4(dly0_04)
    inject_crc             => inject_crc                , -- MSR: tb_ln_dly1to4(dly0_04)
    lane_in_data(0 to 63)  => dlx0_ln4_tx_data(0 to 63) , -- OVR: tb_ln_dly1to4(dly0_04)
    lane_in_header(0 to 1) => dlx0_ln4_tx_header(0 to 1), -- OVR: tb_ln_dly1to4(dly0_04)
    lane_in_seq(0 to 5)    => dlx0_ln4_tx_seq(0 to 5)   , -- OVR: tb_ln_dly1to4(dly0_04)
    lane_out(0 to 15)      => dlx0_phy_lane_4(0 to 15)  , -- OVD: tb_ln_dly1to4(dly0_04)
    opt_gckn               => opt_gckn                    -- MSR: tb_ln_dly1to4(dly0_04)
);

dly0_05 : entity work.tb_ln_dly1to4
port map (
    clk_in_phase           => clk_in_phase              , -- MSR: tb_ln_dly1to4(dly0_05)
    clock_in               => opt_gckn_4x               , -- OVR: tb_ln_dly1to4(dly0_05)
    delay (0 to 7)         => delay (0 to 7)            , -- MSR: tb_ln_dly1to4(dly0_05)
    inject_crc             => inject_crc                , -- MSR: tb_ln_dly1to4(dly0_05)
    lane_in_data(0 to 63)  => dlx0_ln5_tx_data(0 to 63) , -- OVR: tb_ln_dly1to4(dly0_05)
    lane_in_header(0 to 1) => dlx0_ln5_tx_header(0 to 1), -- OVR: tb_ln_dly1to4(dly0_05)
    lane_in_seq(0 to 5)    => dlx0_ln5_tx_seq(0 to 5)   , -- OVR: tb_ln_dly1to4(dly0_05)
    lane_out(0 to 15)      => dlx0_phy_lane_5(0 to 15)  , -- OVD: tb_ln_dly1to4(dly0_05)
    opt_gckn               => opt_gckn                    -- MSR: tb_ln_dly1to4(dly0_05)
);

dly0_06 : entity work.tb_ln_dly1to4
port map (
    clk_in_phase           => clk_in_phase              , -- MSR: tb_ln_dly1to4(dly0_06)
    clock_in               => opt_gckn_4x               , -- OVR: tb_ln_dly1to4(dly0_06)
    delay (0 to 7)         => delay (0 to 7)            , -- MSR: tb_ln_dly1to4(dly0_06)
    inject_crc             => inject_crc                , -- MSR: tb_ln_dly1to4(dly0_06)
    lane_in_data(0 to 63)  => dlx0_ln6_tx_data(0 to 63) , -- OVR: tb_ln_dly1to4(dly0_06)
    lane_in_header(0 to 1) => dlx0_ln6_tx_header(0 to 1), -- OVR: tb_ln_dly1to4(dly0_06)
    lane_in_seq(0 to 5)    => dlx0_ln6_tx_seq(0 to 5)   , -- OVR: tb_ln_dly1to4(dly0_06)
    lane_out(0 to 15)      => dlx0_phy_lane_6(0 to 15)  , -- OVD: tb_ln_dly1to4(dly0_06)
    opt_gckn               => opt_gckn                    -- MSR: tb_ln_dly1to4(dly0_06)
);

dly0_07 : entity work.tb_ln_dly1to4
port map (
    clk_in_phase           => clk_in_phase              , -- MSR: tb_ln_dly1to4(dly0_07)
    clock_in               => opt_gckn_4x               , -- OVR: tb_ln_dly1to4(dly0_07)
    delay (0 to 7)         => delay (0 to 7)            , -- MSR: tb_ln_dly1to4(dly0_07)
    inject_crc             => inject_crc                , -- MSR: tb_ln_dly1to4(dly0_07)
    lane_in_data(0 to 63)  => dlx0_ln7_tx_data(0 to 63) , -- OVR: tb_ln_dly1to4(dly0_07)
    lane_in_header(0 to 1) => dlx0_ln7_tx_header(0 to 1), -- OVR: tb_ln_dly1to4(dly0_07)
    lane_in_seq(0 to 5)    => dlx0_ln7_tx_seq(0 to 5)   , -- OVR: tb_ln_dly1to4(dly0_07)
    lane_out(0 to 15)      => dlx0_phy_lane_7(0 to 15)  , -- OVD: tb_ln_dly1to4(dly0_07)
    opt_gckn               => opt_gckn                    -- MSR: tb_ln_dly1to4(dly0_07)
);

dly1_00 : entity work.tb_ln_dly4to1
port map (
    clock_out                => dlx0_ln0_rx_clk               , -- OVD: tb_ln_dly4to1(dly1_00)
    delay (0 to 7)           => delay (0 to 7)                , -- MSR: tb_ln_dly4to1(dly1_00)
    inject_crc               => inject_crc                    , -- MSR: tb_ln_dly4to1(dly1_00)
    lane_in(0 to 15)         => phy_dlx0_lane_0(0 to 15)      , -- OVR: tb_ln_dly4to1(dly1_00)
    lane_out(63 downto 0)    => dlx0_ln0_data(63 downto 0)    , -- OVD: tb_ln_dly4to1(dly1_00)
    ln_rx_data(63 downto 0)  => dlx0_ln0_rx_data(63 downto 0) , -- OVD: tb_ln_dly4to1(dly1_00)
    ln_rx_header(1 downto 0) => dlx0_ln0_rx_header(1 downto 0), -- OVD: tb_ln_dly4to1(dly1_00)
    ln_rx_slip               => dlx0_ln0_rx_slip              , -- OVR: tb_ln_dly4to1(dly1_00)
    ln_rx_valid              => dlx0_ln0_rx_valid             , -- OVD: tb_ln_dly4to1(dly1_00)
    opt_gckn                 => opt_gckn                        -- MSR: tb_ln_dly4to1(dly1_00)
);

dly1_01 : entity work.tb_ln_dly4to1
port map (
    clock_out                => dlx0_ln1_rx_clk               , -- OVD: tb_ln_dly4to1(dly1_01)
    delay (0 to 7)           => delay (0 to 7)                , -- MSR: tb_ln_dly4to1(dly1_01)
    inject_crc               => inject_crc                    , -- MSR: tb_ln_dly4to1(dly1_01)
    lane_in(0 to 15)         => phy_dlx0_lane_1(0 to 15)      , -- OVR: tb_ln_dly4to1(dly1_01)
    lane_out(63 downto 0)    => dlx0_ln1_data(63 downto 0)    , -- OVD: tb_ln_dly4to1(dly1_01)
    ln_rx_data(63 downto 0)  => dlx0_ln1_rx_data(63 downto 0) , -- OVD: tb_ln_dly4to1(dly1_01)
    ln_rx_header(1 downto 0) => dlx0_ln1_rx_header(1 downto 0), -- OVD: tb_ln_dly4to1(dly1_01)
    ln_rx_slip               => dlx0_ln1_rx_slip              , -- OVR: tb_ln_dly4to1(dly1_01)
    ln_rx_valid              => dlx0_ln1_rx_valid             , -- OVD: tb_ln_dly4to1(dly1_01)
    opt_gckn                 => opt_gckn                        -- MSR: tb_ln_dly4to1(dly1_01)
);

dly1_02 : entity work.tb_ln_dly4to1
port map (
    clock_out                => dlx0_ln2_rx_clk               , -- OVD: tb_ln_dly4to1(dly1_02)
    delay (0 to 7)           => delay (0 to 7)                , -- MSR: tb_ln_dly4to1(dly1_02)
    inject_crc               => inject_crc                    , -- MSR: tb_ln_dly4to1(dly1_02)
    lane_in(0 to 15)         => phy_dlx0_lane_2(0 to 15)      , -- OVR: tb_ln_dly4to1(dly1_02)
    lane_out(63 downto 0)    => dlx0_ln2_data(63 downto 0)    , -- OVD: tb_ln_dly4to1(dly1_02)
    ln_rx_data(63 downto 0)  => dlx0_ln2_rx_data(63 downto 0) , -- OVD: tb_ln_dly4to1(dly1_02)
    ln_rx_header(1 downto 0) => dlx0_ln2_rx_header(1 downto 0), -- OVD: tb_ln_dly4to1(dly1_02)
    ln_rx_slip               => dlx0_ln2_rx_slip              , -- OVR: tb_ln_dly4to1(dly1_02)
    ln_rx_valid              => dlx0_ln2_rx_valid             , -- OVD: tb_ln_dly4to1(dly1_02)
    opt_gckn                 => opt_gckn                        -- MSR: tb_ln_dly4to1(dly1_02)
);

dly1_03 : entity work.tb_ln_dly4to1
port map (
    clock_out                => dlx0_ln3_rx_clk               , -- OVD: tb_ln_dly4to1(dly1_03)
    delay (0 to 7)           => delay (0 to 7)                , -- MSR: tb_ln_dly4to1(dly1_03)
    inject_crc               => inject_crc                    , -- MSR: tb_ln_dly4to1(dly1_03)
    lane_in(0 to 15)         => phy_dlx0_lane_3(0 to 15)      , -- OVR: tb_ln_dly4to1(dly1_03)
    lane_out(63 downto 0)    => dlx0_ln3_data(63 downto 0)    , -- OVD: tb_ln_dly4to1(dly1_03)
    ln_rx_data(63 downto 0)  => dlx0_ln3_rx_data(63 downto 0) , -- OVD: tb_ln_dly4to1(dly1_03)
    ln_rx_header(1 downto 0) => dlx0_ln3_rx_header(1 downto 0), -- OVD: tb_ln_dly4to1(dly1_03)
    ln_rx_slip               => dlx0_ln3_rx_slip              , -- OVR: tb_ln_dly4to1(dly1_03)
    ln_rx_valid              => dlx0_ln3_rx_valid             , -- OVD: tb_ln_dly4to1(dly1_03)
    opt_gckn                 => opt_gckn                        -- MSR: tb_ln_dly4to1(dly1_03)
);

dly1_04 : entity work.tb_ln_dly4to1
port map (
    clock_out                => dlx0_ln4_rx_clk               , -- OVD: tb_ln_dly4to1(dly1_04)
    delay (0 to 7)           => delay (0 to 7)                , -- MSR: tb_ln_dly4to1(dly1_04)
    inject_crc               => inject_crc                    , -- MSR: tb_ln_dly4to1(dly1_04)
    lane_in(0 to 15)         => phy_dlx0_lane_4(0 to 15)      , -- OVR: tb_ln_dly4to1(dly1_04)
    lane_out(63 downto 0)    => dlx0_ln4_data(63 downto 0)    , -- OVD: tb_ln_dly4to1(dly1_04)
    ln_rx_data(63 downto 0)  => dlx0_ln4_rx_data(63 downto 0) , -- OVD: tb_ln_dly4to1(dly1_04)
    ln_rx_header(1 downto 0) => dlx0_ln4_rx_header(1 downto 0), -- OVD: tb_ln_dly4to1(dly1_04)
    ln_rx_slip               => dlx0_ln4_rx_slip              , -- OVR: tb_ln_dly4to1(dly1_04)
    ln_rx_valid              => dlx0_ln4_rx_valid             , -- OVD: tb_ln_dly4to1(dly1_04)
    opt_gckn                 => opt_gckn                        -- MSR: tb_ln_dly4to1(dly1_04)
);

dly1_05 : entity work.tb_ln_dly4to1
port map (
    clock_out                => dlx0_ln5_rx_clk               , -- OVD: tb_ln_dly4to1(dly1_05)
    delay (0 to 7)           => delay (0 to 7)                , -- MSR: tb_ln_dly4to1(dly1_05)
    inject_crc               => inject_crc                    , -- MSR: tb_ln_dly4to1(dly1_05)
    lane_in(0 to 15)         => phy_dlx0_lane_5(0 to 15)      , -- OVR: tb_ln_dly4to1(dly1_05)
    lane_out(63 downto 0)    => dlx0_ln5_data(63 downto 0)    , -- OVD: tb_ln_dly4to1(dly1_05)
    ln_rx_data(63 downto 0)  => dlx0_ln5_rx_data(63 downto 0) , -- OVD: tb_ln_dly4to1(dly1_05)
    ln_rx_header(1 downto 0) => dlx0_ln5_rx_header(1 downto 0), -- OVD: tb_ln_dly4to1(dly1_05)
    ln_rx_slip               => dlx0_ln5_rx_slip              , -- OVR: tb_ln_dly4to1(dly1_05)
    ln_rx_valid              => dlx0_ln5_rx_valid             , -- OVD: tb_ln_dly4to1(dly1_05)
    opt_gckn                 => opt_gckn                        -- MSR: tb_ln_dly4to1(dly1_05)
);

dly1_06 : entity work.tb_ln_dly4to1
port map (
    clock_out                => dlx0_ln6_rx_clk               , -- OVD: tb_ln_dly4to1(dly1_06)
    delay (0 to 7)           => delay (0 to 7)                , -- MSR: tb_ln_dly4to1(dly1_06)
    inject_crc               => inject_crc                    , -- MSR: tb_ln_dly4to1(dly1_06)
    lane_in(0 to 15)         => phy_dlx0_lane_6(0 to 15)      , -- OVR: tb_ln_dly4to1(dly1_06)
    lane_out(63 downto 0)    => dlx0_ln6_data(63 downto 0)    , -- OVD: tb_ln_dly4to1(dly1_06)
    ln_rx_data(63 downto 0)  => dlx0_ln6_rx_data(63 downto 0) , -- OVD: tb_ln_dly4to1(dly1_06)
    ln_rx_header(1 downto 0) => dlx0_ln6_rx_header(1 downto 0), -- OVD: tb_ln_dly4to1(dly1_06)
    ln_rx_slip               => dlx0_ln6_rx_slip              , -- OVR: tb_ln_dly4to1(dly1_06)
    ln_rx_valid              => dlx0_ln6_rx_valid             , -- OVD: tb_ln_dly4to1(dly1_06)
    opt_gckn                 => opt_gckn                        -- MSR: tb_ln_dly4to1(dly1_06)
);

dly1_07 : entity work.tb_ln_dly4to1
port map (
    clock_out                => dlx0_ln7_rx_clk               , -- OVD: tb_ln_dly4to1(dly1_07)
    delay (0 to 7)           => delay (0 to 7)                , -- MSR: tb_ln_dly4to1(dly1_07)
    inject_crc               => inject_crc                    , -- MSR: tb_ln_dly4to1(dly1_07)
    lane_in(0 to 15)         => phy_dlx0_lane_7(0 to 15)      , -- OVR: tb_ln_dly4to1(dly1_07)
    lane_out(63 downto 0)    => dlx0_ln7_data(63 downto 0)    , -- OVD: tb_ln_dly4to1(dly1_07)
    ln_rx_data(63 downto 0)  => dlx0_ln7_rx_data(63 downto 0) , -- OVD: tb_ln_dly4to1(dly1_07)
    ln_rx_header(1 downto 0) => dlx0_ln7_rx_header(1 downto 0), -- OVD: tb_ln_dly4to1(dly1_07)
    ln_rx_slip               => dlx0_ln7_rx_slip              , -- OVR: tb_ln_dly4to1(dly1_07)
    ln_rx_valid              => dlx0_ln7_rx_valid             , -- OVD: tb_ln_dly4to1(dly1_07)
    opt_gckn                 => opt_gckn                        -- MSR: tb_ln_dly4to1(dly1_07)
);
end fire_emulate;
