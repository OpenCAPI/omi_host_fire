-- *!***************************************************************************
-- *! (C) Copyright International Business Machines Corp. 2018
-- *!           All Rights Reserved -- Property of IBM
-- *!                   *** IBM Confidential ***
-- *!***************************************************************************
-- *! FILENAME    : fire_fire_tb.vhdl
-- *! TITLE       : TL to TL Testbench
-- *! DESCRIPTION : Testbench containing 2 fire_emulate blocks
-- *!
-- *! OWNER  NAME : Ryan King (rpking@us.ibm.com)
-- *! BACKUP NAME : Kevin McIlvain
-- *!
-- *!***************************************************************************
-- MR_PARAMS -clk gckn
-- MR_B SOFT
-- MS_REC 2

library ieee,ibm,support;
use ieee.std_logic_1164.all;
use ibm.synthesis_support.all;
use support.logic_support_pkg.all;
use support.syn_util_functions_pkg.ALL;
use work.axi_pkg.all;

entity fire_fire_tb is
  port (
    ---------------------------------------------------------------------------
    -- Clocking
    ---------------------------------------------------------------------------
    dummy_gckn                     : in std_ulogic
    );

  attribute BLOCK_TYPE of fire_fire_tb : entity is SOFT;
  attribute BTR_NAME of fire_fire_tb : entity is "FIRE_FIRE_TB";
  attribute RECURSIVE_SYNTHESIS of fire_fire_tb : entity is 2;
  attribute PIN_DATA of dummy_gckn : signal is "PIN_FUNCTION=/G_CLK/";
end fire_fire_tb;

architecture fire_fire_tb of fire_fire_tb is

  SIGNAL phy_dlx1_lane_0                   : std_ulogic_vector(0 to 15);
  SIGNAL dlx0_phy_lane_0                   : std_ulogic_vector(0 to 15);
  SIGNAL phy_dlx1_lane_1                   : std_ulogic_vector(0 to 15);
  SIGNAL dlx0_phy_lane_1                   : std_ulogic_vector(0 to 15);
  SIGNAL phy_dlx1_lane_2                   : std_ulogic_vector(0 to 15);
  SIGNAL dlx0_phy_lane_2                   : std_ulogic_vector(0 to 15);
  SIGNAL phy_dlx1_lane_3                   : std_ulogic_vector(0 to 15);
  SIGNAL dlx0_phy_lane_3                   : std_ulogic_vector(0 to 15);
  SIGNAL phy_dlx1_lane_4                   : std_ulogic_vector(0 to 15);
  SIGNAL dlx0_phy_lane_4                   : std_ulogic_vector(0 to 15);
  SIGNAL phy_dlx1_lane_5                   : std_ulogic_vector(0 to 15);
  SIGNAL dlx0_phy_lane_5                   : std_ulogic_vector(0 to 15);
  SIGNAL phy_dlx1_lane_6                   : std_ulogic_vector(0 to 15);
  SIGNAL dlx0_phy_lane_6                   : std_ulogic_vector(0 to 15);
  SIGNAL phy_dlx1_lane_7                   : std_ulogic_vector(0 to 15);
  SIGNAL dlx0_phy_lane_7                   : std_ulogic_vector(0 to 15);
  SIGNAL phy_dlx0_lane_0                   : std_ulogic_vector(0 to 15);
  SIGNAL dlx1_phy_lane_0                   : std_ulogic_vector(0 to 15);
  SIGNAL phy_dlx0_lane_1                   : std_ulogic_vector(0 to 15);
  SIGNAL dlx1_phy_lane_1                   : std_ulogic_vector(0 to 15);
  SIGNAL phy_dlx0_lane_2                   : std_ulogic_vector(0 to 15);
  SIGNAL dlx1_phy_lane_2                   : std_ulogic_vector(0 to 15);
  SIGNAL phy_dlx0_lane_3                   : std_ulogic_vector(0 to 15);
  SIGNAL dlx1_phy_lane_3                   : std_ulogic_vector(0 to 15);
  SIGNAL phy_dlx0_lane_4                   : std_ulogic_vector(0 to 15);
  SIGNAL dlx1_phy_lane_4                   : std_ulogic_vector(0 to 15);
  SIGNAL phy_dlx0_lane_5                   : std_ulogic_vector(0 to 15);
  SIGNAL dlx1_phy_lane_5                   : std_ulogic_vector(0 to 15);
  SIGNAL phy_dlx0_lane_6                   : std_ulogic_vector(0 to 15);
  SIGNAL dlx1_phy_lane_6                   : std_ulogic_vector(0 to 15);
  SIGNAL phy_dlx0_lane_7                   : std_ulogic_vector(0 to 15);
  SIGNAL dlx1_phy_lane_7                   : std_ulogic_vector(0 to 15);
  SIGNAL c3s_dlx0_axis_aclk                : std_ulogic;
  SIGNAL c3s_dlx0_axis_aresetn             : std_ulogic;
  SIGNAL c3s_dlx0_axis_awvalid             : std_ulogic;
  SIGNAL c3s_dlx0_axis_awready             : std_ulogic;
  SIGNAL c3s_dlx0_axis_awaddr              : std_ulogic_vector(31 downto 0);
  SIGNAL c3s_dlx0_axis_awprot              : std_ulogic_vector(2 downto 0);
  SIGNAL c3s_dlx0_axis_wvalid              : std_ulogic;
  SIGNAL c3s_dlx0_axis_wready              : std_ulogic;
  SIGNAL c3s_dlx0_axis_wdata               : std_ulogic_vector(31 downto 0);
  SIGNAL c3s_dlx0_axis_wstrb               : std_ulogic_vector(3 downto 0);
  SIGNAL c3s_dlx0_axis_bvalid              : std_ulogic;
  SIGNAL c3s_dlx0_axis_bready              : std_ulogic;
  SIGNAL c3s_dlx0_axis_bresp               : std_ulogic_vector(1 downto 0);
  SIGNAL c3s_dlx0_axis_arvalid             : std_ulogic;
  SIGNAL c3s_dlx0_axis_arready             : std_ulogic;
  SIGNAL c3s_dlx0_axis_araddr              : std_ulogic_vector(31 downto 0);
  SIGNAL c3s_dlx0_axis_arprot              : std_ulogic_vector(2 downto 0);
  SIGNAL c3s_dlx0_axis_rvalid              : std_ulogic;
  SIGNAL c3s_dlx0_axis_rready              : std_ulogic;
  SIGNAL c3s_dlx0_axis_rdata               : std_ulogic_vector(31 downto 0);
  SIGNAL c3s_dlx0_axis_rresp               : std_ulogic_vector(1 downto 0);
  SIGNAL c3s_dlx1_axis_aclk                : std_ulogic;
  SIGNAL c3s_dlx1_axis_aresetn             : std_ulogic;
  SIGNAL c3s_dlx1_axis_awvalid             : std_ulogic;
  SIGNAL c3s_dlx1_axis_awready             : std_ulogic;
  SIGNAL c3s_dlx1_axis_awaddr              : std_ulogic_vector(31 downto 0);
  SIGNAL c3s_dlx1_axis_awprot              : std_ulogic_vector(2 downto 0);
  SIGNAL c3s_dlx1_axis_wvalid              : std_ulogic;
  SIGNAL c3s_dlx1_axis_wready              : std_ulogic;
  SIGNAL c3s_dlx1_axis_wdata               : std_ulogic_vector(31 downto 0);
  SIGNAL c3s_dlx1_axis_wstrb               : std_ulogic_vector(3 downto 0);
  SIGNAL c3s_dlx1_axis_bvalid              : std_ulogic;
  SIGNAL c3s_dlx1_axis_bready              : std_ulogic;
  SIGNAL c3s_dlx1_axis_bresp               : std_ulogic_vector(1 downto 0);
  SIGNAL c3s_dlx1_axis_arvalid             : std_ulogic;
  SIGNAL c3s_dlx1_axis_arready             : std_ulogic;
  SIGNAL c3s_dlx1_axis_araddr              : std_ulogic_vector(31 downto 0);
  SIGNAL c3s_dlx1_axis_arprot              : std_ulogic_vector(2 downto 0);
  SIGNAL c3s_dlx1_axis_rvalid              : std_ulogic;
  SIGNAL c3s_dlx1_axis_rready              : std_ulogic;
  SIGNAL c3s_dlx1_axis_rdata               : std_ulogic_vector(31 downto 0);
  SIGNAL c3s_dlx1_axis_rresp               : std_ulogic_vector(1 downto 0);
  SIGNAL fire0_gtwiz_done                  : std_ulogic;
  SIGNAL fire1_gtwiz_done                  : std_ulogic;
  SIGNAL opt_gckn                          : std_ulogic;
  SIGNAL opt_gckn_4x                       : std_ulogic;
  SIGNAL reset                             : std_ulogic;

begin

  -----------------------------------------------------------------------------
  -- Clocking
  -----------------------------------------------------------------------------
  opt_gckn    <= NOT td_oscillator(16, 8, 0);
  opt_gckn_4x <= NOT td_oscillator(64, 32, 0);  -- 4x the period, not the frequency
  reset       <= '0';

  -----------------------------------------------------------------------------
  -- Xilinx Transceiver Reset Signals
  -----------------------------------------------------------------------------
  fire0_gtwiz_done <= '0';
  fire1_gtwiz_done <= '0';

  -----------------------------------------------------------------------------
  -- AXI Registers
  -----------------------------------------------------------------------------
  c3s_dlx0_axis_aclk    <= NOT opt_gckn_4x;
  c3s_dlx0_axis_aresetn <= NOT reset;
  c3s_dlx0_axis_awvalid <= '0';
  c3s_dlx0_axis_awaddr  <= (others => '0');
  c3s_dlx0_axis_awprot  <= (others => '0');
  c3s_dlx0_axis_wvalid  <= '0';
  c3s_dlx0_axis_wdata   <= (others => '0');
  c3s_dlx0_axis_wstrb   <= (others => '0');
  c3s_dlx0_axis_bready  <= '0';
  c3s_dlx0_axis_arvalid <= '0';
  c3s_dlx0_axis_araddr  <= (others => '0');
  c3s_dlx0_axis_arprot  <= (others => '0');
  c3s_dlx0_axis_rready  <= '0';

  c3s_dlx1_axis_aclk    <= NOT opt_gckn_4x;
  c3s_dlx1_axis_aresetn <= NOT reset;
  c3s_dlx1_axis_awvalid <= '0';
  c3s_dlx1_axis_awaddr  <= (others => '0');
  c3s_dlx1_axis_awprot  <= (others => '0');
  c3s_dlx1_axis_wvalid  <= '0';
  c3s_dlx1_axis_wdata   <= (others => '0');
  c3s_dlx1_axis_wstrb   <= (others => '0');
  c3s_dlx1_axis_bready  <= '0';
  c3s_dlx1_axis_arvalid <= '0';
  c3s_dlx1_axis_araddr  <= (others => '0');
  c3s_dlx1_axis_arprot  <= (others => '0');
  c3s_dlx1_axis_rready  <= '0';

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

  fire0 : entity work.fire_emulate
    port map (
    opt_gckn                    => opt_gckn,
    opt_gckn_4x                 => opt_gckn_4x,
    reset                       => reset,
    gtwiz_done                  => fire0_gtwiz_done,
    dlx0_phy_lane_0             => dlx0_phy_lane_0,
    dlx0_phy_lane_1             => dlx0_phy_lane_1,
    dlx0_phy_lane_2             => dlx0_phy_lane_2,
    dlx0_phy_lane_3             => dlx0_phy_lane_3,
    dlx0_phy_lane_4             => dlx0_phy_lane_4,
    dlx0_phy_lane_5             => dlx0_phy_lane_5,
    dlx0_phy_lane_6             => dlx0_phy_lane_6,
    dlx0_phy_lane_7             => dlx0_phy_lane_7,
    phy_dlx0_lane_0             => phy_dlx0_lane_0,
    phy_dlx0_lane_1             => phy_dlx0_lane_1,
    phy_dlx0_lane_2             => phy_dlx0_lane_2,
    phy_dlx0_lane_3             => phy_dlx0_lane_3,
    phy_dlx0_lane_4             => phy_dlx0_lane_4,
    phy_dlx0_lane_5             => phy_dlx0_lane_5,
    phy_dlx0_lane_6             => phy_dlx0_lane_6,
    phy_dlx0_lane_7             => phy_dlx0_lane_7,
    c3s_dlx0_axis_aclk          => c3s_dlx0_axis_aclk,
    c3s_dlx0_axis_aresetn       => c3s_dlx0_axis_aresetn,
    c3s_dlx0_axis_awvalid       => c3s_dlx0_axis_awvalid,
    c3s_dlx0_axis_awready       => c3s_dlx0_axis_awready,
    c3s_dlx0_axis_awaddr        => c3s_dlx0_axis_awaddr,
    c3s_dlx0_axis_awprot        => c3s_dlx0_axis_awprot,
    c3s_dlx0_axis_wvalid        => c3s_dlx0_axis_wvalid,
    c3s_dlx0_axis_wready        => c3s_dlx0_axis_wready,
    c3s_dlx0_axis_wdata         => c3s_dlx0_axis_wdata,
    c3s_dlx0_axis_wstrb         => c3s_dlx0_axis_wstrb,
    c3s_dlx0_axis_bvalid        => c3s_dlx0_axis_bvalid,
    c3s_dlx0_axis_bready        => c3s_dlx0_axis_bready,
    c3s_dlx0_axis_bresp         => c3s_dlx0_axis_bresp,
    c3s_dlx0_axis_arvalid       => c3s_dlx0_axis_arvalid,
    c3s_dlx0_axis_arready       => c3s_dlx0_axis_arready,
    c3s_dlx0_axis_araddr        => c3s_dlx0_axis_araddr,
    c3s_dlx0_axis_arprot        => c3s_dlx0_axis_arprot,
    c3s_dlx0_axis_rvalid        => c3s_dlx0_axis_rvalid,
    c3s_dlx0_axis_rready        => c3s_dlx0_axis_rready,
    c3s_dlx0_axis_rdata         => c3s_dlx0_axis_rdata,
    c3s_dlx0_axis_rresp         => c3s_dlx0_axis_rresp
    );

  fire1 : entity work.fire_emulate
    port map (
    opt_gckn                    => opt_gckn,
    opt_gckn_4x                 => opt_gckn_4x,
    reset                       => reset,
    gtwiz_done                  => fire1_gtwiz_done,
    dlx0_phy_lane_0             => dlx1_phy_lane_0,
    dlx0_phy_lane_1             => dlx1_phy_lane_1,
    dlx0_phy_lane_2             => dlx1_phy_lane_2,
    dlx0_phy_lane_3             => dlx1_phy_lane_3,
    dlx0_phy_lane_4             => dlx1_phy_lane_4,
    dlx0_phy_lane_5             => dlx1_phy_lane_5,
    dlx0_phy_lane_6             => dlx1_phy_lane_6,
    dlx0_phy_lane_7             => dlx1_phy_lane_7,
    phy_dlx0_lane_0             => phy_dlx1_lane_0,
    phy_dlx0_lane_1             => phy_dlx1_lane_1,
    phy_dlx0_lane_2             => phy_dlx1_lane_2,
    phy_dlx0_lane_3             => phy_dlx1_lane_3,
    phy_dlx0_lane_4             => phy_dlx1_lane_4,
    phy_dlx0_lane_5             => phy_dlx1_lane_5,
    phy_dlx0_lane_6             => phy_dlx1_lane_6,
    phy_dlx0_lane_7             => phy_dlx1_lane_7,
    c3s_dlx0_axis_aclk          => c3s_dlx1_axis_aclk,
    c3s_dlx0_axis_aresetn       => c3s_dlx1_axis_aresetn,
    c3s_dlx0_axis_awvalid       => c3s_dlx1_axis_awvalid,
    c3s_dlx0_axis_awready       => c3s_dlx1_axis_awready,
    c3s_dlx0_axis_awaddr        => c3s_dlx1_axis_awaddr,
    c3s_dlx0_axis_awprot        => c3s_dlx1_axis_awprot,
    c3s_dlx0_axis_wvalid        => c3s_dlx1_axis_wvalid,
    c3s_dlx0_axis_wready        => c3s_dlx1_axis_wready,
    c3s_dlx0_axis_wdata         => c3s_dlx1_axis_wdata,
    c3s_dlx0_axis_wstrb         => c3s_dlx1_axis_wstrb,
    c3s_dlx0_axis_bvalid        => c3s_dlx1_axis_bvalid,
    c3s_dlx0_axis_bready        => c3s_dlx1_axis_bready,
    c3s_dlx0_axis_bresp         => c3s_dlx1_axis_bresp,
    c3s_dlx0_axis_arvalid       => c3s_dlx1_axis_arvalid,
    c3s_dlx0_axis_arready       => c3s_dlx1_axis_arready,
    c3s_dlx0_axis_araddr        => c3s_dlx1_axis_araddr,
    c3s_dlx0_axis_arprot        => c3s_dlx1_axis_arprot,
    c3s_dlx0_axis_rvalid        => c3s_dlx1_axis_rvalid,
    c3s_dlx0_axis_rready        => c3s_dlx1_axis_rready,
    c3s_dlx0_axis_rdata         => c3s_dlx1_axis_rdata,
    c3s_dlx0_axis_rresp         => c3s_dlx1_axis_rresp
    );

end fire_fire_tb;
