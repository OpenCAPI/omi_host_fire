library ieee,ibm,support;
use ieee.std_logic_1164.all;
use ibm.synthesis_support.all;
use support.logic_support_pkg.all;

entity hss_phy_wrap1 is
  port (
    -- Differential reference clock inputs
    mgtrefclk0_x0y0_p : in std_ulogic;
    mgtrefclk0_x0y0_n : in std_ulogic;
    mgtrefclk0_x0y1_p : in std_ulogic;
    mgtrefclk0_x0y1_n : in std_ulogic;

    -- Clocking
    cclk       : out std_ulogic;
    rclk       : out std_ulogic;
    hb_gtwiz_reset_clk_freerun_buf_int : in  std_ulogic;

    -- Serial data ports for transceiver channel 0
    ch0_gtyrxn_in  : in  std_ulogic;
    ch0_gtyrxp_in  : in  std_ulogic;
    ch0_gtytxn_out : out std_ulogic;
    ch0_gtytxp_out : out std_ulogic;

    -- Serial data ports for transceiver channel 1
    ch1_gtyrxn_in  : in  std_ulogic;
    ch1_gtyrxp_in  : in  std_ulogic;
    ch1_gtytxn_out : out std_ulogic;
    ch1_gtytxp_out : out std_ulogic;

    -- Serial data ports for transceiver channel 2
    ch2_gtyrxn_in  : in  std_ulogic;
    ch2_gtyrxp_in  : in  std_ulogic;
    ch2_gtytxn_out : out std_ulogic;
    ch2_gtytxp_out : out std_ulogic;

    -- Serial data ports for transceiver channel 3
    ch3_gtyrxn_in  : in  std_ulogic;
    ch3_gtyrxp_in  : in  std_ulogic;
    ch3_gtytxn_out : out std_ulogic;
    ch3_gtytxp_out : out std_ulogic;

    -- Serial data ports for transceiver channel 4
    ch4_gtyrxn_in  : in  std_ulogic;
    ch4_gtyrxp_in  : in  std_ulogic;
    ch4_gtytxn_out : out std_ulogic;
    ch4_gtytxp_out : out std_ulogic;

    -- Serial data ports for transceiver channel 5
    ch5_gtyrxn_in  : in  std_ulogic;
    ch5_gtyrxp_in  : in  std_ulogic;
    ch5_gtytxn_out : out std_ulogic;
    ch5_gtytxp_out : out std_ulogic;

    -- Serial data ports for transceiver channel 6
    ch6_gtyrxn_in  : in  std_ulogic;
    ch6_gtyrxp_in  : in  std_ulogic;
    ch6_gtytxn_out : out std_ulogic;
    ch6_gtytxp_out : out std_ulogic;

    -- Serial data ports for transceiver channel 7
    ch7_gtyrxn_in  : in  std_ulogic;
    ch7_gtyrxp_in  : in  std_ulogic;
    ch7_gtytxn_out : out std_ulogic;
    ch7_gtytxp_out : out std_ulogic;

    -- TX Interface
    ch0_txheader          : in std_ulogic_vector(1 downto 0);
    ch1_txheader          : in std_ulogic_vector(1 downto 0);
    ch2_txheader          : in std_ulogic_vector(1 downto 0);
    ch3_txheader          : in std_ulogic_vector(1 downto 0);
    ch4_txheader          : in std_ulogic_vector(1 downto 0);
    ch5_txheader          : in std_ulogic_vector(1 downto 0);
    ch6_txheader          : in std_ulogic_vector(1 downto 0);
    ch7_txheader          : in std_ulogic_vector(1 downto 0);
    ch0_txsequence        : in std_ulogic_vector(5 downto 0);
    ch1_txsequence        : in std_ulogic_vector(5 downto 0);
    ch2_txsequence        : in std_ulogic_vector(5 downto 0);
    ch3_txsequence        : in std_ulogic_vector(5 downto 0);
    ch4_txsequence        : in std_ulogic_vector(5 downto 0);
    ch5_txsequence        : in std_ulogic_vector(5 downto 0);
    ch6_txsequence        : in std_ulogic_vector(5 downto 0);
    ch7_txsequence        : in std_ulogic_vector(5 downto 0);
    hb0_gtwiz_userdata_tx : in std_ulogic_vector(63 downto 0);
    hb1_gtwiz_userdata_tx : in std_ulogic_vector(63 downto 0);
    hb2_gtwiz_userdata_tx : in std_ulogic_vector(63 downto 0);
    hb3_gtwiz_userdata_tx : in std_ulogic_vector(63 downto 0);
    hb4_gtwiz_userdata_tx : in std_ulogic_vector(63 downto 0);
    hb5_gtwiz_userdata_tx : in std_ulogic_vector(63 downto 0);
    hb6_gtwiz_userdata_tx : in std_ulogic_vector(63 downto 0);
    hb7_gtwiz_userdata_tx : in std_ulogic_vector(63 downto 0);

    -- RX Interface
    ch0_rxdatavalid       : out std_ulogic_vector(0 downto 0);
    ch1_rxdatavalid       : out std_ulogic_vector(0 downto 0);
    ch2_rxdatavalid       : out std_ulogic_vector(0 downto 0);
    ch3_rxdatavalid       : out std_ulogic_vector(0 downto 0);
    ch4_rxdatavalid       : out std_ulogic_vector(0 downto 0);
    ch5_rxdatavalid       : out std_ulogic_vector(0 downto 0);
    ch6_rxdatavalid       : out std_ulogic_vector(0 downto 0);
    ch7_rxdatavalid       : out std_ulogic_vector(0 downto 0);
    ch0_rxheader          : out std_ulogic_vector(1 downto 0);
    ch1_rxheader          : out std_ulogic_vector(1 downto 0);
    ch2_rxheader          : out std_ulogic_vector(1 downto 0);
    ch3_rxheader          : out std_ulogic_vector(1 downto 0);
    ch4_rxheader          : out std_ulogic_vector(1 downto 0);
    ch5_rxheader          : out std_ulogic_vector(1 downto 0);
    ch6_rxheader          : out std_ulogic_vector(1 downto 0);
    ch7_rxheader          : out std_ulogic_vector(1 downto 0);
    ch0_rxgearboxslip     : in  std_ulogic_vector(0 downto 0);
    ch1_rxgearboxslip     : in  std_ulogic_vector(0 downto 0);
    ch2_rxgearboxslip     : in  std_ulogic_vector(0 downto 0);
    ch3_rxgearboxslip     : in  std_ulogic_vector(0 downto 0);
    ch4_rxgearboxslip     : in  std_ulogic_vector(0 downto 0);
    ch5_rxgearboxslip     : in  std_ulogic_vector(0 downto 0);
    ch6_rxgearboxslip     : in  std_ulogic_vector(0 downto 0);
    ch7_rxgearboxslip     : in  std_ulogic_vector(0 downto 0);
    hb0_gtwiz_userdata_rx : out std_ulogic_vector(63 downto 0);
    hb1_gtwiz_userdata_rx : out std_ulogic_vector(63 downto 0);
    hb2_gtwiz_userdata_rx : out std_ulogic_vector(63 downto 0);
    hb3_gtwiz_userdata_rx : out std_ulogic_vector(63 downto 0);
    hb4_gtwiz_userdata_rx : out std_ulogic_vector(63 downto 0);
    hb5_gtwiz_userdata_rx : out std_ulogic_vector(63 downto 0);
    hb6_gtwiz_userdata_rx : out std_ulogic_vector(63 downto 0);
    hb7_gtwiz_userdata_rx : out std_ulogic_vector(63 downto 0);

    -- User-provided ports for reset helper block(s)
    gtwiz_buffbypass_rx_done_in   : out std_ulogic;
    gtwiz_buffbypass_tx_done_in   : out std_ulogic;
    gtwiz_reset_all_out           : in std_ulogic;
    gtwiz_reset_rx_datapath_out   : in std_ulogic;
    gtwiz_reset_rx_done_in        : out std_ulogic;
    gtwiz_reset_tx_done_in        : out std_ulogic;
    gtwiz_userclk_rx_active_in    : out std_ulogic;
    gtwiz_userclk_tx_active_in    : out std_ulogic;
    hb_gtwiz_reset_all_in         : out std_ulogic
    );

  attribute BLOCK_TYPE of hss_phy_wrap1 : entity is SOFT;
  attribute BTR_NAME of hss_phy_wrap1 : entity is "HSS_PHY_WRAP1";
  attribute RECURSIVE_SYNTHESIS of hss_phy_wrap1 : entity is 2;
end hss_phy_wrap1;

architecture hss_phy_wrap1 of hss_phy_wrap1 is

  component dlx_phy_wrap1
    port (
      -- Differential reference clock inputs
      mgtrefclk0_x0y0_p : in std_ulogic;
      mgtrefclk0_x0y0_n : in std_ulogic;
      mgtrefclk0_x0y1_p : in std_ulogic;
      mgtrefclk0_x0y1_n : in std_ulogic;

      -- Clocking
      cclk       : out std_ulogic;
      rclk       : out std_ulogic;
      hb_gtwiz_reset_clk_freerun_buf_int : in  std_ulogic;

      -- Serial data ports for transceiver channel 0
      ch0_gtyrxn_in  : in  std_ulogic;
      ch0_gtyrxp_in  : in  std_ulogic;
      ch0_gtytxn_out : out std_ulogic;
      ch0_gtytxp_out : out std_ulogic;

      -- Serial data ports for transceiver channel 1
      ch1_gtyrxn_in  : in  std_ulogic;
      ch1_gtyrxp_in  : in  std_ulogic;
      ch1_gtytxn_out : out std_ulogic;
      ch1_gtytxp_out : out std_ulogic;

      -- Serial data ports for transceiver channel 2
      ch2_gtyrxn_in  : in  std_ulogic;
      ch2_gtyrxp_in  : in  std_ulogic;
      ch2_gtytxn_out : out std_ulogic;
      ch2_gtytxp_out : out std_ulogic;

      -- Serial data ports for transceiver channel 3
      ch3_gtyrxn_in  : in  std_ulogic;
      ch3_gtyrxp_in  : in  std_ulogic;
      ch3_gtytxn_out : out std_ulogic;
      ch3_gtytxp_out : out std_ulogic;

      -- Serial data ports for transceiver channel 4
      ch4_gtyrxn_in  : in  std_ulogic;
      ch4_gtyrxp_in  : in  std_ulogic;
      ch4_gtytxn_out : out std_ulogic;
      ch4_gtytxp_out : out std_ulogic;

      -- Serial data ports for transceiver channel 5
      ch5_gtyrxn_in  : in  std_ulogic;
      ch5_gtyrxp_in  : in  std_ulogic;
      ch5_gtytxn_out : out std_ulogic;
      ch5_gtytxp_out : out std_ulogic;

      -- Serial data ports for transceiver channel 6
      ch6_gtyrxn_in  : in  std_ulogic;
      ch6_gtyrxp_in  : in  std_ulogic;
      ch6_gtytxn_out : out std_ulogic;
      ch6_gtytxp_out : out std_ulogic;

      -- Serial data ports for transceiver channel 7
      ch7_gtyrxn_in  : in  std_ulogic;
      ch7_gtyrxp_in  : in  std_ulogic;
      ch7_gtytxn_out : out std_ulogic;
      ch7_gtytxp_out : out std_ulogic;

      -- TX Interface
      ch0_txheader          : in std_ulogic_vector(1 downto 0);
      ch1_txheader          : in std_ulogic_vector(1 downto 0);
      ch2_txheader          : in std_ulogic_vector(1 downto 0);
      ch3_txheader          : in std_ulogic_vector(1 downto 0);
      ch4_txheader          : in std_ulogic_vector(1 downto 0);
      ch5_txheader          : in std_ulogic_vector(1 downto 0);
      ch6_txheader          : in std_ulogic_vector(1 downto 0);
      ch7_txheader          : in std_ulogic_vector(1 downto 0);
      ch0_txsequence        : in std_ulogic_vector(5 downto 0);
      ch1_txsequence        : in std_ulogic_vector(5 downto 0);
      ch2_txsequence        : in std_ulogic_vector(5 downto 0);
      ch3_txsequence        : in std_ulogic_vector(5 downto 0);
      ch4_txsequence        : in std_ulogic_vector(5 downto 0);
      ch5_txsequence        : in std_ulogic_vector(5 downto 0);
      ch6_txsequence        : in std_ulogic_vector(5 downto 0);
      ch7_txsequence        : in std_ulogic_vector(5 downto 0);
      hb0_gtwiz_userdata_tx : in std_ulogic_vector(63 downto 0);
      hb1_gtwiz_userdata_tx : in std_ulogic_vector(63 downto 0);
      hb2_gtwiz_userdata_tx : in std_ulogic_vector(63 downto 0);
      hb3_gtwiz_userdata_tx : in std_ulogic_vector(63 downto 0);
      hb4_gtwiz_userdata_tx : in std_ulogic_vector(63 downto 0);
      hb5_gtwiz_userdata_tx : in std_ulogic_vector(63 downto 0);
      hb6_gtwiz_userdata_tx : in std_ulogic_vector(63 downto 0);
      hb7_gtwiz_userdata_tx : in std_ulogic_vector(63 downto 0);

      -- RX Interface
      ch0_rxdatavalid       : out std_ulogic_vector(0 downto 0);
      ch1_rxdatavalid       : out std_ulogic_vector(0 downto 0);
      ch2_rxdatavalid       : out std_ulogic_vector(0 downto 0);
      ch3_rxdatavalid       : out std_ulogic_vector(0 downto 0);
      ch4_rxdatavalid       : out std_ulogic_vector(0 downto 0);
      ch5_rxdatavalid       : out std_ulogic_vector(0 downto 0);
      ch6_rxdatavalid       : out std_ulogic_vector(0 downto 0);
      ch7_rxdatavalid       : out std_ulogic_vector(0 downto 0);
      ch0_rxheader          : out std_ulogic_vector(1 downto 0);
      ch1_rxheader          : out std_ulogic_vector(1 downto 0);
      ch2_rxheader          : out std_ulogic_vector(1 downto 0);
      ch3_rxheader          : out std_ulogic_vector(1 downto 0);
      ch4_rxheader          : out std_ulogic_vector(1 downto 0);
      ch5_rxheader          : out std_ulogic_vector(1 downto 0);
      ch6_rxheader          : out std_ulogic_vector(1 downto 0);
      ch7_rxheader          : out std_ulogic_vector(1 downto 0);
      ch0_rxgearboxslip     : in  std_ulogic_vector(0 downto 0);
      ch1_rxgearboxslip     : in  std_ulogic_vector(0 downto 0);
      ch2_rxgearboxslip     : in  std_ulogic_vector(0 downto 0);
      ch3_rxgearboxslip     : in  std_ulogic_vector(0 downto 0);
      ch4_rxgearboxslip     : in  std_ulogic_vector(0 downto 0);
      ch5_rxgearboxslip     : in  std_ulogic_vector(0 downto 0);
      ch6_rxgearboxslip     : in  std_ulogic_vector(0 downto 0);
      ch7_rxgearboxslip     : in  std_ulogic_vector(0 downto 0);
      hb0_gtwiz_userdata_rx : out std_ulogic_vector(63 downto 0);
      hb1_gtwiz_userdata_rx : out std_ulogic_vector(63 downto 0);
      hb2_gtwiz_userdata_rx : out std_ulogic_vector(63 downto 0);
      hb3_gtwiz_userdata_rx : out std_ulogic_vector(63 downto 0);
      hb4_gtwiz_userdata_rx : out std_ulogic_vector(63 downto 0);
      hb5_gtwiz_userdata_rx : out std_ulogic_vector(63 downto 0);
      hb6_gtwiz_userdata_rx : out std_ulogic_vector(63 downto 0);
      hb7_gtwiz_userdata_rx : out std_ulogic_vector(63 downto 0);

      -- User-provided ports for reset helper block(s)
      gtwiz_buffbypass_rx_done_in   : out std_ulogic;
      gtwiz_buffbypass_tx_done_in   : out std_ulogic;
      gtwiz_reset_all_out           : in std_ulogic;
      gtwiz_reset_rx_datapath_out   : in std_ulogic;
      gtwiz_reset_rx_done_in        : out std_ulogic;
      gtwiz_reset_tx_done_in        : out std_ulogic;
      gtwiz_userclk_rx_active_in    : out std_ulogic;
      gtwiz_userclk_tx_active_in    : out std_ulogic;
      hb_gtwiz_reset_all_in         : out std_ulogic;
     -- // IBERT Logic
      drpaddr_in                    : IN  STD_ULOGIC_VECTOR(79 DOWNTO 0);
      drpclk_in                     : IN  STD_ULOGIC_VECTOR(7 DOWNTO 0);
      drpdi_in                      : IN  STD_ULOGIC_VECTOR(127 DOWNTO 0);
      drpen_in                      : IN  STD_ULOGIC_VECTOR(7 DOWNTO 0);
      drpwe_in                      : IN  STD_ULOGIC_VECTOR(7 DOWNTO 0);
      eyescanreset_in               : IN  STD_ULOGIC_VECTOR(7 DOWNTO 0);
      rxlpmen_in                    : IN  STD_ULOGIC_VECTOR(7 DOWNTO 0);
      rxrate_in                     : IN  STD_ULOGIC_VECTOR(23 DOWNTO 0);
      txdiffctrl_in                 : IN  STD_ULOGIC_VECTOR(39 DOWNTO 0);
      txpostcursor_in               : IN  STD_ULOGIC_VECTOR(39 DOWNTO 0);
      txprecursor_in                : IN  STD_ULOGIC_VECTOR(39 DOWNTO 0);
      drpdo_out                     : OUT STD_ULOGIC_VECTOR(127 DOWNTO 0);
      drprdy_out                    : OUT STD_ULOGIC_VECTOR(7 DOWNTO 0)
    );
  end component;

begin

  hss_phy : component dlx_phy_wrap1
    port map (

   -- // IBERT Logic
      drpaddr_in      => x"00000000000000000000", --drpaddr_int,                     -- [IN  STD_ULOGIC_VECTOR(79 DOWNTO 0)]
      drpclk_in       => x"00", --To_StduLogicVector(drpclk_int),  -- [IN  STD_ULOGIC_VECTOR(7 DOWNTO 0)]
      drpdi_in        => x"00000000000000000000000000000000", --drpdi_int,                       -- [IN  STD_ULOGIC_VECTOR(127 DOWNTO 0)]
      drpen_in        => x"00", --drpen_int,                       -- [IN  STD_ULOGIC_VECTOR(7 DOWNTO 0)]
      drpwe_in        => x"00", --drpwe_int,                       -- [IN  STD_ULOGIC_VECTOR(7 DOWNTO 0)]

      eyescanreset_in => x"00", --To_StduLogicVector(eyescanreset_int),  -- [IN  STD_ULOGIC_VECTOR(7 DOWNTO 0)]
      rxrate_in       => x"000000",         --To_StduLogicVector(rxrate_int),        -- [IN  STD_ULOGIC_VECTOR(23 DOWNTO 0)]
      txdiffctrl_in   => x"8C6318C631",    --To_StduLogicVector(txdiffctrl_int),    -- [IN  STD_ULOGIC_VECTOR(39 DOWNTO 0)]
      txpostcursor_in => x"0000000000",    --To_StduLogicVector(txpostcursor_int),  -- [IN  STD_ULOGIC_VECTOR(39 DOWNTO 0)]
      txprecursor_in  => x"0000000000",    --To_StduLogicVector(txprecursor_int),   -- [IN  STD_ULOGIC_VECTOR(39 DOWNTO 0)]
      rxlpmen_in      => x"FF", --To_StduLogicVector(rxlpmen_int),       -- [IN  STD_ULOGIC_VECTOR(7 DOWNTO 0)]

      drpdo_out  => open, --drpdo_int,          -- [OUT STD_ULOGIC_VECTOR(127 DOWNTO 0)]
      drprdy_out => open, --drprdy_int);        -- [OUT STD_ULOGIC_VECTOR(7 DOWNTO 0)]
      -- Differential reference clock inputs
      mgtrefclk0_x0y0_p => mgtrefclk0_x0y0_p,
      mgtrefclk0_x0y0_n => mgtrefclk0_x0y0_n,
      mgtrefclk0_x0y1_p => mgtrefclk0_x0y1_p,
      mgtrefclk0_x0y1_n => mgtrefclk0_x0y1_n,

      -- Clocking
      cclk       => cclk,
      rclk       => rclk,
      hb_gtwiz_reset_clk_freerun_buf_int => hb_gtwiz_reset_clk_freerun_buf_int,

      -- Serial data ports for transceiver channel 0
      ch0_gtyrxn_in  => ch0_gtyrxn_in,
      ch0_gtyrxp_in  => ch0_gtyrxp_in,
      ch0_gtytxn_out => ch0_gtytxn_out,
      ch0_gtytxp_out => ch0_gtytxp_out,

      -- Serial data ports for transceiver channel 1
      ch1_gtyrxn_in  => ch1_gtyrxn_in,
      ch1_gtyrxp_in  => ch1_gtyrxp_in,
      ch1_gtytxn_out => ch1_gtytxn_out,
      ch1_gtytxp_out => ch1_gtytxp_out,

      -- Serial data ports for transceiver channel 2
      ch2_gtyrxn_in  => ch2_gtyrxn_in,
      ch2_gtyrxp_in  => ch2_gtyrxp_in,
      ch2_gtytxn_out => ch2_gtytxn_out,
      ch2_gtytxp_out => ch2_gtytxp_out,

      -- Serial data ports for transceiver channel 3
      ch3_gtyrxn_in  => ch3_gtyrxn_in,
      ch3_gtyrxp_in  => ch3_gtyrxp_in,
      ch3_gtytxn_out => ch3_gtytxn_out,
      ch3_gtytxp_out => ch3_gtytxp_out,

      -- Serial data ports for transceiver channel 4
      ch4_gtyrxn_in  => ch4_gtyrxn_in,
      ch4_gtyrxp_in  => ch4_gtyrxp_in,
      ch4_gtytxn_out => ch4_gtytxn_out,
      ch4_gtytxp_out => ch4_gtytxp_out,

      -- Serial data ports for transceiver channel 5
      ch5_gtyrxn_in  => ch5_gtyrxn_in,
      ch5_gtyrxp_in  => ch5_gtyrxp_in,
      ch5_gtytxn_out => ch5_gtytxn_out,
      ch5_gtytxp_out => ch5_gtytxp_out,

      -- Serial data ports for transceiver channel 6
      ch6_gtyrxn_in  => ch6_gtyrxn_in,
      ch6_gtyrxp_in  => ch6_gtyrxp_in,
      ch6_gtytxn_out => ch6_gtytxn_out,
      ch6_gtytxp_out => ch6_gtytxp_out,

      -- Serial data ports for transceiver channel 7
      ch7_gtyrxn_in  => ch7_gtyrxn_in,
      ch7_gtyrxp_in  => ch7_gtyrxp_in,
      ch7_gtytxn_out => ch7_gtytxn_out,
      ch7_gtytxp_out => ch7_gtytxp_out,

      -- TX Interface
      ch0_txheader          => ch0_txheader,
      ch1_txheader          => ch1_txheader,
      ch2_txheader          => ch2_txheader,
      ch3_txheader          => ch3_txheader,
      ch4_txheader          => ch4_txheader,
      ch5_txheader          => ch5_txheader,
      ch6_txheader          => ch6_txheader,
      ch7_txheader          => ch7_txheader,
      ch0_txsequence        => ch0_txsequence,
      ch1_txsequence        => ch1_txsequence,
      ch2_txsequence        => ch2_txsequence,
      ch3_txsequence        => ch3_txsequence,
      ch4_txsequence        => ch4_txsequence,
      ch5_txsequence        => ch5_txsequence,
      ch6_txsequence        => ch6_txsequence,
      ch7_txsequence        => ch7_txsequence,
      hb0_gtwiz_userdata_tx => hb0_gtwiz_userdata_tx,
      hb1_gtwiz_userdata_tx => hb1_gtwiz_userdata_tx,
      hb2_gtwiz_userdata_tx => hb2_gtwiz_userdata_tx,
      hb3_gtwiz_userdata_tx => hb3_gtwiz_userdata_tx,
      hb4_gtwiz_userdata_tx => hb4_gtwiz_userdata_tx,
      hb5_gtwiz_userdata_tx => hb5_gtwiz_userdata_tx,
      hb6_gtwiz_userdata_tx => hb6_gtwiz_userdata_tx,
      hb7_gtwiz_userdata_tx => hb7_gtwiz_userdata_tx,

      -- RX Interface
      ch0_rxdatavalid       => ch0_rxdatavalid,
      ch1_rxdatavalid       => ch1_rxdatavalid,
      ch2_rxdatavalid       => ch2_rxdatavalid,
      ch3_rxdatavalid       => ch3_rxdatavalid,
      ch4_rxdatavalid       => ch4_rxdatavalid,
      ch5_rxdatavalid       => ch5_rxdatavalid,
      ch6_rxdatavalid       => ch6_rxdatavalid,
      ch7_rxdatavalid       => ch7_rxdatavalid,
      ch0_rxheader          => ch0_rxheader,
      ch1_rxheader          => ch1_rxheader,
      ch2_rxheader          => ch2_rxheader,
      ch3_rxheader          => ch3_rxheader,
      ch4_rxheader          => ch4_rxheader,
      ch5_rxheader          => ch5_rxheader,
      ch6_rxheader          => ch6_rxheader,
      ch7_rxheader          => ch7_rxheader,
      ch0_rxgearboxslip     => ch0_rxgearboxslip,
      ch1_rxgearboxslip     => ch1_rxgearboxslip,
      ch2_rxgearboxslip     => ch2_rxgearboxslip,
      ch3_rxgearboxslip     => ch3_rxgearboxslip,
      ch4_rxgearboxslip     => ch4_rxgearboxslip,
      ch5_rxgearboxslip     => ch5_rxgearboxslip,
      ch6_rxgearboxslip     => ch6_rxgearboxslip,
      ch7_rxgearboxslip     => ch7_rxgearboxslip,
      hb0_gtwiz_userdata_rx => hb0_gtwiz_userdata_rx,
      hb1_gtwiz_userdata_rx => hb1_gtwiz_userdata_rx,
      hb2_gtwiz_userdata_rx => hb2_gtwiz_userdata_rx,
      hb3_gtwiz_userdata_rx => hb3_gtwiz_userdata_rx,
      hb4_gtwiz_userdata_rx => hb4_gtwiz_userdata_rx,
      hb5_gtwiz_userdata_rx => hb5_gtwiz_userdata_rx,
      hb6_gtwiz_userdata_rx => hb6_gtwiz_userdata_rx,
      hb7_gtwiz_userdata_rx => hb7_gtwiz_userdata_rx,

      -- User-provided ports for reset helper block(s)
      gtwiz_buffbypass_rx_done_in   => gtwiz_buffbypass_rx_done_in,
      gtwiz_buffbypass_tx_done_in   => gtwiz_buffbypass_tx_done_in,
      gtwiz_reset_all_out           => gtwiz_reset_all_out,
      gtwiz_reset_rx_datapath_out   => gtwiz_reset_rx_datapath_out,
      gtwiz_reset_rx_done_in        => gtwiz_reset_rx_done_in,
      gtwiz_reset_tx_done_in        => gtwiz_reset_tx_done_in,
      gtwiz_userclk_rx_active_in    => gtwiz_userclk_rx_active_in,
      gtwiz_userclk_tx_active_in    => gtwiz_userclk_tx_active_in,
      hb_gtwiz_reset_all_in         => hb_gtwiz_reset_all_in
    );

end hss_phy_wrap1;
