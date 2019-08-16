--
-- Copyright 2019 International Business Machines
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- The patent license granted to you in Section 3 of the License, as applied
-- to the "Work," hereby includes implementations of the Work in physical form.
--
-- Unless required by applicable law or agreed to in writing, the reference design
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
-- The background Specification upon which this is based is managed by and available from
-- the OpenCAPI Consortium.  More information can be found at https://opencapi.org.
--

library ieee,ibm,support;
use ieee.std_logic_1164.all;
use ibm.synthesis_support.all;
use support.logic_support_pkg.all;
use work.axi_pkg.all;

entity fire_top is
  port (
    ---------------------------------------------------------------------------
    -- Clocking & Reset
    ---------------------------------------------------------------------------
    --RAW_RESETN                     : in std_ulogic;
    RAW_SYSCLK_N                   : in std_ulogic;
    RAW_SYSCLK_P                   : in std_ulogic;
    RAW_RCLK_N                     : in std_ulogic;
    RAW_RCLK_P                     : in std_ulogic;
    PLL_LOCKED                     : out std_ulogic;
    OCDE                           : in std_ulogic;
    ICE_RESETN                     : out std_ulogic;
    SYSCLK_PROBE0_N                : out std_ulogic;
    SYSCLK_PROBE0_P                : out std_ulogic;
    SYSCLK_PROBE1_N                : out std_ulogic;
    SYSCLK_PROBE1_P                : out std_ulogic;

    ---------------------------------------------------------------------------
    -- I2C
    ---------------------------------------------------------------------------
    SCL_IO                         : inout std_logic;
    SDA_IO                         : inout std_logic;

    ---------------------------------------------------------------------------
    -- OCMB OpenCAPI Channels
    ---------------------------------------------------------------------------
    -- DDIMM A
    DDIMMB_FPGA_LANE_N             : in std_ulogic_vector(7 downto 0);
    DDIMMB_FPGA_LANE_P             : in std_ulogic_vector(7 downto 0);
    FPGA_DDIMMB_LANE_N             : out std_ulogic_vector(7 downto 0);
    FPGA_DDIMMB_LANE_P             : out std_ulogic_vector(7 downto 0);
    DDIMMB_FPGA_REFCLK_N           : in std_ulogic_vector(1 downto 0);
    DDIMMB_FPGA_REFCLK_P           : in std_ulogic_vector(1 downto 0)
    );
end fire_top;

architecture fire_top of fire_top is
  SIGNAL oc_memory0_axis_aclk : std_ulogic;
  SIGNAL oc_memory0_axis_i : t_AXI3_SLAVE_INPUT;
  SIGNAL oc_memory0_axis_o : t_AXI3_SLAVE_OUTPUT;
  SIGNAL c3s_dlx_axis_aclk : std_ulogic;
  SIGNAL c3s_dlx_axis_i : t_AXI4_LITE_SLAVE_INPUT;
  SIGNAL c3s_dlx_axis_o : t_AXI4_LITE_SLAVE_OUTPUT;
  SIGNAL oc_mmio0_axis_aclk : std_ulogic;
  SIGNAL oc_mmio0_axis_i : t_AXI3_SLAVE_INPUT;
  SIGNAL oc_mmio0_axis_o : t_AXI3_SLAVE_OUTPUT;
  SIGNAL oc_cfg0_axis_aclk : std_ulogic;
  SIGNAL oc_cfg0_axis_i : t_AXI3_SLAVE_INPUT;
  SIGNAL oc_cfg0_axis_o : t_AXI3_SLAVE_OUTPUT;
  SIGNAL fbist_axis_aclk : std_ulogic;
  SIGNAL fbist_axis_i : t_AXI4_LITE_SLAVE_INPUT;
  SIGNAL fbist_axis_o : t_AXI4_LITE_SLAVE_OUTPUT;
  SIGNAL oc_host_cfg0_axis_aclk : std_ulogic;
  SIGNAL oc_host_cfg0_axis_i : t_AXI4_LITE_SLAVE_INPUT;
  SIGNAL oc_host_cfg0_axis_o : t_AXI4_LITE_SLAVE_OUTPUT;
  SIGNAL sysclk : std_ulogic;
  SIGNAL cclk_a : std_ulogic;
  SIGNAL rclk : std_ulogic;
  SIGNAL sys_resetn : std_ulogic;
--  SIGNAL sys_resetn_int : std_ulogic;
  SIGNAL ocde_int : std_ulogic;
  signal sys_resetn_vio : std_ulogic;
  signal dlx_reset : std_ulogic;
  SIGNAL raw_resetn_int : std_ulogic;
  SIGNAL cresetn_a : std_ulogic;
  SIGNAL dlx_l0_tx_data : std_ulogic_vector(63 downto 0);
  SIGNAL dlx_l0_tx_header : std_ulogic_vector(1 downto 0);
  SIGNAL dlx_l0_tx_seq : std_ulogic_vector(5 downto 0);
  SIGNAL dlx_l1_tx_data : std_ulogic_vector(63 downto 0);
  SIGNAL dlx_l1_tx_header : std_ulogic_vector(1 downto 0);
  SIGNAL dlx_l1_tx_seq : std_ulogic_vector(5 downto 0);
  SIGNAL dlx_l2_tx_data : std_ulogic_vector(63 downto 0);
  SIGNAL dlx_l2_tx_header : std_ulogic_vector(1 downto 0);
  SIGNAL dlx_l2_tx_seq : std_ulogic_vector(5 downto 0);
  SIGNAL dlx_l3_tx_data : std_ulogic_vector(63 downto 0);
  SIGNAL dlx_l3_tx_header : std_ulogic_vector(1 downto 0);
  SIGNAL dlx_l3_tx_seq : std_ulogic_vector(5 downto 0);
  SIGNAL dlx_l4_tx_data : std_ulogic_vector(63 downto 0);
  SIGNAL dlx_l4_tx_header : std_ulogic_vector(1 downto 0);
  SIGNAL dlx_l4_tx_seq : std_ulogic_vector(5 downto 0);
  SIGNAL dlx_l5_tx_data : std_ulogic_vector(63 downto 0);
  SIGNAL dlx_l5_tx_header : std_ulogic_vector(1 downto 0);
  SIGNAL dlx_l5_tx_seq : std_ulogic_vector(5 downto 0);
  SIGNAL dlx_l6_tx_data : std_ulogic_vector(63 downto 0);
  SIGNAL dlx_l6_tx_header : std_ulogic_vector(1 downto 0);
  SIGNAL dlx_l6_tx_seq : std_ulogic_vector(5 downto 0);
  SIGNAL dlx_l7_tx_data : std_ulogic_vector(63 downto 0);
  SIGNAL dlx_l7_tx_header : std_ulogic_vector(1 downto 0);
  SIGNAL dlx_l7_tx_seq : std_ulogic_vector(5 downto 0);
  SIGNAL gtwiz_buffbypass_rx_done_in : std_ulogic;
  SIGNAL gtwiz_buffbypass_tx_done_in : std_ulogic;
  SIGNAL gtwiz_reset_all_out : std_ulogic;
  SIGNAL gtwiz_reset_rx_datapath_out : std_ulogic;
  SIGNAL gtwiz_reset_rx_done_in : std_ulogic;
  SIGNAL gtwiz_reset_tx_done_in : std_ulogic;
  SIGNAL gtwiz_userclk_rx_active_in : std_ulogic;
  SIGNAL gtwiz_userclk_tx_active_in : std_ulogic;
  SIGNAL hb_gtwiz_reset_all_in : std_ulogic;
  SIGNAL ln0_rx_data : std_ulogic_vector(63 downto 0);
  SIGNAL ln0_rx_header : std_ulogic_vector(1 downto 0);
  SIGNAL ln0_rx_slip : std_ulogic;
  SIGNAL ln0_rx_valid : std_ulogic;
  SIGNAL ln1_rx_data : std_ulogic_vector(63 downto 0);
  SIGNAL ln1_rx_header : std_ulogic_vector(1 downto 0);
  SIGNAL ln1_rx_slip : std_ulogic;
  SIGNAL ln1_rx_valid : std_ulogic;
  SIGNAL ln2_rx_data : std_ulogic_vector(63 downto 0);
  SIGNAL ln2_rx_header : std_ulogic_vector(1 downto 0);
  SIGNAL ln2_rx_slip : std_ulogic;
  SIGNAL ln2_rx_valid : std_ulogic;
  SIGNAL ln3_rx_data : std_ulogic_vector(63 downto 0);
  SIGNAL ln3_rx_header : std_ulogic_vector(1 downto 0);
  SIGNAL ln3_rx_slip : std_ulogic;
  SIGNAL ln3_rx_valid : std_ulogic;
  SIGNAL ln4_rx_data : std_ulogic_vector(63 downto 0);
  SIGNAL ln4_rx_header : std_ulogic_vector(1 downto 0);
  SIGNAL ln4_rx_slip : std_ulogic;
  SIGNAL ln4_rx_valid : std_ulogic;
  SIGNAL ln5_rx_data : std_ulogic_vector(63 downto 0);
  SIGNAL ln5_rx_header : std_ulogic_vector(1 downto 0);
  SIGNAL ln5_rx_slip : std_ulogic;
  SIGNAL ln5_rx_valid : std_ulogic;
  SIGNAL ln6_rx_data : std_ulogic_vector(63 downto 0);
  SIGNAL ln6_rx_header : std_ulogic_vector(1 downto 0);
  SIGNAL ln6_rx_slip : std_ulogic;
  SIGNAL ln6_rx_valid : std_ulogic;
  SIGNAL ln7_rx_data : std_ulogic_vector(63 downto 0);
  SIGNAL ln7_rx_header : std_ulogic_vector(1 downto 0);
  SIGNAL ln7_rx_slip : std_ulogic;
  SIGNAL ln7_rx_valid : std_ulogic;
  SIGNAL mgtrefclk0_x0y0_p : std_ulogic;
  SIGNAL mgtrefclk0_x0y0_n : std_ulogic;
  SIGNAL mgtrefclk0_x0y1_p : std_ulogic;
  SIGNAL mgtrefclk0_x0y1_n : std_ulogic;
  SIGNAL ch0_gtyrxn_in : std_ulogic;
  SIGNAL ch0_gtyrxp_in : std_ulogic;
  SIGNAL ch0_gtytxn_out : std_ulogic;
  SIGNAL ch0_gtytxp_out : std_ulogic;
  SIGNAL ch1_gtyrxn_in : std_ulogic;
  SIGNAL ch1_gtyrxp_in : std_ulogic;
  SIGNAL ch1_gtytxn_out : std_ulogic;
  SIGNAL ch1_gtytxp_out : std_ulogic;
  SIGNAL ch2_gtyrxn_in : std_ulogic;
  SIGNAL ch2_gtyrxp_in : std_ulogic;
  SIGNAL ch2_gtytxn_out : std_ulogic;
  SIGNAL ch2_gtytxp_out : std_ulogic;
  SIGNAL ch3_gtyrxn_in : std_ulogic;
  SIGNAL ch3_gtyrxp_in : std_ulogic;
  SIGNAL ch3_gtytxn_out : std_ulogic;
  SIGNAL ch3_gtytxp_out : std_ulogic;
  SIGNAL ch4_gtyrxn_in : std_ulogic;
  SIGNAL ch4_gtyrxp_in : std_ulogic;
  SIGNAL ch4_gtytxn_out : std_ulogic;
  SIGNAL ch4_gtytxp_out : std_ulogic;
  SIGNAL ch5_gtyrxn_in : std_ulogic;
  SIGNAL ch5_gtyrxp_in : std_ulogic;
  SIGNAL ch5_gtytxn_out : std_ulogic;
  SIGNAL ch5_gtytxp_out : std_ulogic;
  SIGNAL ch6_gtyrxn_in : std_ulogic;
  SIGNAL ch6_gtyrxp_in : std_ulogic;
  SIGNAL ch6_gtytxn_out : std_ulogic;
  SIGNAL ch6_gtytxp_out : std_ulogic;
  SIGNAL ch7_gtyrxn_in : std_ulogic;
  SIGNAL ch7_gtyrxp_in : std_ulogic;
  SIGNAL ch7_gtytxn_out : std_ulogic;
  SIGNAL ch7_gtytxp_out : std_ulogic;
  SIGNAL ch0_txheader : std_ulogic_vector(1 downto 0);
  SIGNAL ch1_txheader : std_ulogic_vector(1 downto 0);
  SIGNAL ch2_txheader : std_ulogic_vector(1 downto 0);
  SIGNAL ch3_txheader : std_ulogic_vector(1 downto 0);
  SIGNAL ch4_txheader : std_ulogic_vector(1 downto 0);
  SIGNAL ch5_txheader : std_ulogic_vector(1 downto 0);
  SIGNAL ch6_txheader : std_ulogic_vector(1 downto 0);
  SIGNAL ch7_txheader : std_ulogic_vector(1 downto 0);
  SIGNAL ch0_txsequence : std_ulogic_vector(5 downto 0);
  SIGNAL ch1_txsequence : std_ulogic_vector(5 downto 0);
  SIGNAL ch2_txsequence : std_ulogic_vector(5 downto 0);
  SIGNAL ch3_txsequence : std_ulogic_vector(5 downto 0);
  SIGNAL ch4_txsequence : std_ulogic_vector(5 downto 0);
  SIGNAL ch5_txsequence : std_ulogic_vector(5 downto 0);
  SIGNAL ch6_txsequence : std_ulogic_vector(5 downto 0);
  SIGNAL ch7_txsequence : std_ulogic_vector(5 downto 0);
  SIGNAL hb0_gtwiz_userdata_tx : std_ulogic_vector(63 downto 0);
  SIGNAL hb1_gtwiz_userdata_tx : std_ulogic_vector(63 downto 0);
  SIGNAL hb2_gtwiz_userdata_tx : std_ulogic_vector(63 downto 0);
  SIGNAL hb3_gtwiz_userdata_tx : std_ulogic_vector(63 downto 0);
  SIGNAL hb4_gtwiz_userdata_tx : std_ulogic_vector(63 downto 0);
  SIGNAL hb5_gtwiz_userdata_tx : std_ulogic_vector(63 downto 0);
  SIGNAL hb6_gtwiz_userdata_tx : std_ulogic_vector(63 downto 0);
  SIGNAL hb7_gtwiz_userdata_tx : std_ulogic_vector(63 downto 0);
  SIGNAL ch0_rxdatavalid : std_ulogic_vector(0 downto 0);
  SIGNAL ch1_rxdatavalid : std_ulogic_vector(0 downto 0);
  SIGNAL ch2_rxdatavalid : std_ulogic_vector(0 downto 0);
  SIGNAL ch3_rxdatavalid : std_ulogic_vector(0 downto 0);
  SIGNAL ch4_rxdatavalid : std_ulogic_vector(0 downto 0);
  SIGNAL ch5_rxdatavalid : std_ulogic_vector(0 downto 0);
  SIGNAL ch6_rxdatavalid : std_ulogic_vector(0 downto 0);
  SIGNAL ch7_rxdatavalid : std_ulogic_vector(0 downto 0);
  SIGNAL ch0_rxheader : std_ulogic_vector(1 downto 0);
  SIGNAL ch1_rxheader : std_ulogic_vector(1 downto 0);
  SIGNAL ch2_rxheader : std_ulogic_vector(1 downto 0);
  SIGNAL ch3_rxheader : std_ulogic_vector(1 downto 0);
  SIGNAL ch4_rxheader : std_ulogic_vector(1 downto 0);
  SIGNAL ch5_rxheader : std_ulogic_vector(1 downto 0);
  SIGNAL ch6_rxheader : std_ulogic_vector(1 downto 0);
  SIGNAL ch7_rxheader : std_ulogic_vector(1 downto 0);
  SIGNAL ch0_rxgearboxslip : std_ulogic_vector(0 downto 0);
  SIGNAL ch1_rxgearboxslip : std_ulogic_vector(0 downto 0);
  SIGNAL ch2_rxgearboxslip : std_ulogic_vector(0 downto 0);
  SIGNAL ch3_rxgearboxslip : std_ulogic_vector(0 downto 0);
  SIGNAL ch4_rxgearboxslip : std_ulogic_vector(0 downto 0);
  SIGNAL ch5_rxgearboxslip : std_ulogic_vector(0 downto 0);
  SIGNAL ch6_rxgearboxslip : std_ulogic_vector(0 downto 0);
  SIGNAL ch7_rxgearboxslip : std_ulogic_vector(0 downto 0);
  SIGNAL hb0_gtwiz_userdata_rx : std_ulogic_vector(63 downto 0);
  SIGNAL hb1_gtwiz_userdata_rx : std_ulogic_vector(63 downto 0);
  SIGNAL hb2_gtwiz_userdata_rx : std_ulogic_vector(63 downto 0);
  SIGNAL hb3_gtwiz_userdata_rx : std_ulogic_vector(63 downto 0);
  SIGNAL hb4_gtwiz_userdata_rx : std_ulogic_vector(63 downto 0);
  SIGNAL hb5_gtwiz_userdata_rx : std_ulogic_vector(63 downto 0);
  SIGNAL hb6_gtwiz_userdata_rx : std_ulogic_vector(63 downto 0);
  SIGNAL hb7_gtwiz_userdata_rx : std_ulogic_vector(63 downto 0);
  SIGNAL sysclk_probe0 : std_ulogic;
  SIGNAL sysclk_probe1 : std_ulogic;
 signal tsm_state2_to_3 : std_ulogic;
  signal tsm_state6_to_1 : std_ulogic;
  signal tsm_state4_to_5 : std_ulogic;
  signal tsm_state5_to_6 : std_ulogic;
  COMPONENT ODDRE1
    GENERIC (
      IS_C_INVERTED  : std_logic;
      IS_D1_INVERTED : std_logic;
      IS_D2_INVERTED : std_logic;
      SRVAL          : std_logic
      );
    PORT (
      Q  : out std_logic;
      C  : in  std_logic;
      D1 : in  std_logic;
      D2 : in  std_logic;
      SR : in  std_logic
      );
  END COMPONENT;

  COMPONENT OBUFDS
    PORT (
      I  : IN  STD_LOGIC;
      O  : OUT STD_LOGIC;
      OB : OUT STD_LOGIC
      );
  END COMPONENT;
  COMPONENT vio_0
    PORT (
      clk        : IN  STD_LOGIC;
      probe_out0 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      probe_out1 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      probe_out2 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      probe_out3 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
      --probe_out4 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      --probe_out5 : OUT STD_LOGIC_VECTOR(167 DOWNTO 0);
      --probe_out6 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      --probe_out7 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      --probe_out8 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      --probe_out9 : OUT STD_LOGIC_VECTOR(255 DOWNTO 0);
      --probe_out10 : OUT STD_LOGIC_VECTOR(255 DOWNTO 0)
      );
  END COMPONENT;

begin
     
       vio : vio_0
          PORT MAP (
            clk                            => cclk_a,
            --probe_out0(0)                  => tsm_state6_to_1,
            probe_out0(0)                  => sys_resetn_vio,
            probe_out1(0)                  => tsm_state4_to_5,             -- [OUT STD_LOGIC_VECTOR(0 DOWNTO 0 ]
            probe_out2(0)                  => tsm_state2_to_3,             -- [OUT STD_LOGIC_VECTOR(0 DOWNTO 0 ]
            probe_out3(0)                  => tsm_state5_to_6);             -- [OUT STD_LOGIC_VECTOR(0 DOWNTO 0 ]
--            probe_out4(0)                  => flit_valid,             -- [OUT STD_LOGIC_VECTOR(0 DOWNTO 0 ]
 --           probe_out5                     => flit_16,
 --           probe_out6(0)                  => rxbufreset_in,
 --           probe_out7                     => flit_16_tl_template,
 --           probe_out8(0)                  => flit_16_data_run_length,
 --           probe_out9                     => data_flit_msb,
 --           probe_out10                    => data_flit_lsb);           

 --sys_resetn_int   <= sys_resetn AND sys_resetn_vio;
 ocde_int         <= ocde and sys_resetn_vio;
 --ocde_int         <= sys_resetn_vio;
 --ice_resetn        <= sys_resetn_vio;
 ice_resetn        <= ocde_int;
 --raw_resetn_int   <= raw_resetn AND NOT dlx_reset;
 raw_resetn_int   <= NOT dlx_reset;

  counter : entity work.counter
    port map (
      clock => cclk_a,
      reset => dlx_reset,
      tsm_state6_to_1 => tsm_state6_to_1
      );

  -- Probe for sysclk
  oddre1_sysclk0_p : oddre1
    generic map (
      IS_C_INVERTED  => '0', -- Optional inversion for C
      IS_D1_INVERTED => '0', -- Optional inversion for D1
      IS_D2_INVERTED => '0', -- Optional inversion for D2
      SRVAL          => '0'  -- Initializes the ODDRE1 Flip-Flops to the specified value (1'b0, 1'b1)
      )
    port map (
      Q              => sysclk_probe0, -- 1-bit output: Data output to IOB
      C              => sysclk,        -- 1-bit input: High-speed clock input
      D1             => '0',           -- 1-bit input: Parallel data input 1
      D2             => '1',           -- 1-bit input: Parallel data input 2
      SR             => '0'            -- 1-bit input: Active High Async Reset
      );

  iobuf_sysclk_probe0 : obufds
    PORT MAP (
      I  => sysclk_probe0,
      O  => sysclk_probe0_p,
      OB => sysclk_probe0_n
      );

  oddre1_sysclk1_p : oddre1
    generic map (
      IS_C_INVERTED  => '0', -- Optional inversion for C
      IS_D1_INVERTED => '0', -- Optional inversion for D1
      IS_D2_INVERTED => '0', -- Optional inversion for D2
      SRVAL          => '0'  -- Initializes the ODDRE1 Flip-Flops to the specified value (1'b0, 1'b1)
      )
    port map (
      Q              => sysclk_probe1, -- 1-bit output: Data output to IOB
      C              => sysclk,        -- 1-bit input: High-speed clock input
      D1             => '0',           -- 1-bit input: Parallel data input 1
      D2             => '1',           -- 1-bit input: Parallel data input 2
      SR             => '0'            -- 1-bit input: Active High Async Reset
      );

  iobuf_sysclk_probe1 : obufds
    PORT MAP (
      I  => sysclk_probe1,
      O  => sysclk_probe1_p,
      OB => sysclk_probe1_n
      );

  -- Assemble OpenCAPI Lanes
  mgtrefclk0_x0y0_n <= DDIMMB_FPGA_REFCLK_N(0);
  mgtrefclk0_x0y1_n <= DDIMMB_FPGA_REFCLK_N(1);
  mgtrefclk0_x0y0_p <= DDIMMB_FPGA_REFCLK_P(0);
  mgtrefclk0_x0y1_p <= DDIMMB_FPGA_REFCLK_P(1);

  ch7_gtyrxn_in <= DDIMMB_FPGA_LANE_N(7);
  ch6_gtyrxn_in <= DDIMMB_FPGA_LANE_N(6);
  ch5_gtyrxn_in <= DDIMMB_FPGA_LANE_N(5);
  ch4_gtyrxn_in <= DDIMMB_FPGA_LANE_N(4);
  ch3_gtyrxn_in <= DDIMMB_FPGA_LANE_N(3);
  ch2_gtyrxn_in <= DDIMMB_FPGA_LANE_N(2);
  ch1_gtyrxn_in <= DDIMMB_FPGA_LANE_N(1);
  ch0_gtyrxn_in <= DDIMMB_FPGA_LANE_N(0);
  ch7_gtyrxp_in <= DDIMMB_FPGA_LANE_P(7);
  ch6_gtyrxp_in <= DDIMMB_FPGA_LANE_P(6);
  ch5_gtyrxp_in <= DDIMMB_FPGA_LANE_P(5);
  ch4_gtyrxp_in <= DDIMMB_FPGA_LANE_P(4);
  ch3_gtyrxp_in <= DDIMMB_FPGA_LANE_P(3);
  ch2_gtyrxp_in <= DDIMMB_FPGA_LANE_P(2);
  ch1_gtyrxp_in <= DDIMMB_FPGA_LANE_P(1);
  ch0_gtyrxp_in <= DDIMMB_FPGA_LANE_P(0);
  FPGA_DDIMMB_LANE_N(7 downto 0) <= ch7_gtytxn_out &
                                    ch6_gtytxn_out &
                                    ch5_gtytxn_out &
                                    ch4_gtytxn_out &
                                    ch3_gtytxn_out &
                                    ch2_gtytxn_out &
                                    ch1_gtytxn_out &
                                    ch0_gtytxn_out;
  FPGA_DDIMMB_LANE_P(7 downto 0) <= ch7_gtytxp_out &
                                    ch6_gtytxp_out &
                                    ch5_gtytxp_out &
                                    ch4_gtytxp_out &
                                    ch3_gtytxp_out &
                                    ch2_gtytxp_out &
                                    ch1_gtytxp_out &
                                    ch0_gtytxp_out;

  -- Data Path is swizzled to compensate for the swizling on the
  -- board. DL lane 0 is connected to PHY lane 7, 1 to 6, etc.
  ln7_rx_valid              <= ch0_rxdatavalid(0);
  ln6_rx_valid              <= ch1_rxdatavalid(0);
  ln5_rx_valid              <= ch2_rxdatavalid(0);
  ln4_rx_valid              <= ch3_rxdatavalid(0);
  ln3_rx_valid              <= ch4_rxdatavalid(0);
  ln2_rx_valid              <= ch5_rxdatavalid(0);
  ln1_rx_valid              <= ch6_rxdatavalid(0);
  ln0_rx_valid              <= ch7_rxdatavalid(0);
  ln7_rx_header(1 downto 0) <= ch0_rxheader(1 downto 0);
  ln6_rx_header(1 downto 0) <= ch1_rxheader(1 downto 0);
  ln5_rx_header(1 downto 0) <= ch2_rxheader(1 downto 0);
  ln4_rx_header(1 downto 0) <= ch3_rxheader(1 downto 0);
  ln3_rx_header(1 downto 0) <= ch4_rxheader(1 downto 0);
  ln2_rx_header(1 downto 0) <= ch5_rxheader(1 downto 0);
  ln1_rx_header(1 downto 0) <= ch6_rxheader(1 downto 0);
  ln0_rx_header(1 downto 0) <= ch7_rxheader(1 downto 0);
  ch7_rxgearboxslip(0)      <= ln0_rx_slip;
  ch6_rxgearboxslip(0)      <= ln1_rx_slip;
  ch5_rxgearboxslip(0)      <= ln2_rx_slip;
  ch4_rxgearboxslip(0)      <= ln3_rx_slip;
  ch3_rxgearboxslip(0)      <= ln4_rx_slip;
  ch2_rxgearboxslip(0)      <= ln5_rx_slip;
  ch1_rxgearboxslip(0)      <= ln6_rx_slip;
  ch0_rxgearboxslip(0)      <= ln7_rx_slip;
  ln7_rx_data(63 downto 0)  <= hb0_gtwiz_userdata_rx(63 downto 0);
  ln6_rx_data(63 downto 0)  <= hb1_gtwiz_userdata_rx(63 downto 0);
  ln5_rx_data(63 downto 0)  <= hb2_gtwiz_userdata_rx(63 downto 0);
  ln4_rx_data(63 downto 0)  <= hb3_gtwiz_userdata_rx(63 downto 0);
  ln3_rx_data(63 downto 0)  <= hb4_gtwiz_userdata_rx(63 downto 0);
  ln2_rx_data(63 downto 0)  <= hb5_gtwiz_userdata_rx(63 downto 0);
  ln1_rx_data(63 downto 0)  <= hb6_gtwiz_userdata_rx(63 downto 0);
  ln0_rx_data(63 downto 0)  <= hb7_gtwiz_userdata_rx(63 downto 0);

  ch0_txheader(1 downto 0)           <= dlx_l7_tx_header(1 downto 0);
  ch1_txheader(1 downto 0)           <= dlx_l6_tx_header(1 downto 0);
  ch2_txheader(1 downto 0)           <= dlx_l5_tx_header(1 downto 0);
  ch3_txheader(1 downto 0)           <= dlx_l4_tx_header(1 downto 0);
  ch4_txheader(1 downto 0)           <= dlx_l3_tx_header(1 downto 0);
  ch5_txheader(1 downto 0)           <= dlx_l2_tx_header(1 downto 0);
  ch6_txheader(1 downto 0)           <= dlx_l1_tx_header(1 downto 0);
  ch7_txheader(1 downto 0)           <= dlx_l0_tx_header(1 downto 0);
  ch0_txsequence(5 downto 0)         <= dlx_l7_tx_seq(5 downto 0);
  ch1_txsequence(5 downto 0)         <= dlx_l6_tx_seq(5 downto 0);
  ch2_txsequence(5 downto 0)         <= dlx_l5_tx_seq(5 downto 0);
  ch3_txsequence(5 downto 0)         <= dlx_l4_tx_seq(5 downto 0);
  ch4_txsequence(5 downto 0)         <= dlx_l3_tx_seq(5 downto 0);
  ch5_txsequence(5 downto 0)         <= dlx_l2_tx_seq(5 downto 0);
  ch6_txsequence(5 downto 0)         <= dlx_l1_tx_seq(5 downto 0);
  ch7_txsequence(5 downto 0)         <= dlx_l0_tx_seq(5 downto 0);
  hb0_gtwiz_userdata_tx(63 downto 0) <= dlx_l7_tx_data(63 downto 0);
  hb1_gtwiz_userdata_tx(63 downto 0) <= dlx_l6_tx_data(63 downto 0);
  hb2_gtwiz_userdata_tx(63 downto 0) <= dlx_l5_tx_data(63 downto 0);
  hb3_gtwiz_userdata_tx(63 downto 0) <= dlx_l4_tx_data(63 downto 0);
  hb4_gtwiz_userdata_tx(63 downto 0) <= dlx_l3_tx_data(63 downto 0);
  hb5_gtwiz_userdata_tx(63 downto 0) <= dlx_l2_tx_data(63 downto 0);
  hb6_gtwiz_userdata_tx(63 downto 0) <= dlx_l1_tx_data(63 downto 0);
  hb7_gtwiz_userdata_tx(63 downto 0) <= dlx_l0_tx_data(63 downto 0);

fire_core : entity work.fire_core
port map (
    tsm_state2_to_3                => tsm_state2_to_3,
    tsm_state6_to_1              => tsm_state6_to_1,
    tsm_state4_to_5              => tsm_state4_to_5,
    tsm_state5_to_6              => tsm_state5_to_6,
    o_dlx_reset                  => dlx_reset,
    cclk_a                        => cclk_a                       , -- MSR: fire_core(fire_core)
    cresetn_a                     => cresetn_a                    , -- MSR: fire_core(fire_core)
    c3s_dlx_axis_aclk             => c3s_dlx_axis_aclk            , -- MSR: fire_core(fire_core)
    c3s_dlx_axis_i                => c3s_dlx_axis_i               , -- MSR: fire_core(fire_core)
    c3s_dlx_axis_o                => c3s_dlx_axis_o               , -- MSD: fire_core(fire_core)
    dlx_l0_tx_data (63 downto 0)  => dlx_l0_tx_data (63 downto 0) , -- MSD: fire_core(fire_core)
    dlx_l0_tx_header (1 downto 0) => dlx_l0_tx_header (1 downto 0), -- MSD: fire_core(fire_core)
    dlx_l0_tx_seq (5 downto 0)    => dlx_l0_tx_seq (5 downto 0)   , -- MSD: fire_core(fire_core)
    dlx_l1_tx_data (63 downto 0)  => dlx_l1_tx_data (63 downto 0) , -- MSD: fire_core(fire_core)
    dlx_l1_tx_header (1 downto 0) => dlx_l1_tx_header (1 downto 0), -- MSD: fire_core(fire_core)
    dlx_l1_tx_seq (5 downto 0)    => dlx_l1_tx_seq (5 downto 0)   , -- MSD: fire_core(fire_core)
    dlx_l2_tx_data (63 downto 0)  => dlx_l2_tx_data (63 downto 0) , -- MSD: fire_core(fire_core)
    dlx_l2_tx_header (1 downto 0) => dlx_l2_tx_header (1 downto 0), -- MSD: fire_core(fire_core)
    dlx_l2_tx_seq (5 downto 0)    => dlx_l2_tx_seq (5 downto 0)   , -- MSD: fire_core(fire_core)
    dlx_l3_tx_data (63 downto 0)  => dlx_l3_tx_data (63 downto 0) , -- MSD: fire_core(fire_core)
    dlx_l3_tx_header (1 downto 0) => dlx_l3_tx_header (1 downto 0), -- MSD: fire_core(fire_core)
    dlx_l3_tx_seq (5 downto 0)    => dlx_l3_tx_seq (5 downto 0)   , -- MSD: fire_core(fire_core)
    dlx_l4_tx_data (63 downto 0)  => dlx_l4_tx_data (63 downto 0) , -- MSD: fire_core(fire_core)
    dlx_l4_tx_header (1 downto 0) => dlx_l4_tx_header (1 downto 0), -- MSD: fire_core(fire_core)
    dlx_l4_tx_seq (5 downto 0)    => dlx_l4_tx_seq (5 downto 0)   , -- MSD: fire_core(fire_core)
    dlx_l5_tx_data (63 downto 0)  => dlx_l5_tx_data (63 downto 0) , -- MSD: fire_core(fire_core)
    dlx_l5_tx_header (1 downto 0) => dlx_l5_tx_header (1 downto 0), -- MSD: fire_core(fire_core)
    dlx_l5_tx_seq (5 downto 0)    => dlx_l5_tx_seq (5 downto 0)   , -- MSD: fire_core(fire_core)
    dlx_l6_tx_data (63 downto 0)  => dlx_l6_tx_data (63 downto 0) , -- MSD: fire_core(fire_core)
    dlx_l6_tx_header (1 downto 0) => dlx_l6_tx_header (1 downto 0), -- MSD: fire_core(fire_core)
    dlx_l6_tx_seq (5 downto 0)    => dlx_l6_tx_seq (5 downto 0)   , -- MSD: fire_core(fire_core)
    dlx_l7_tx_data (63 downto 0)  => dlx_l7_tx_data (63 downto 0) , -- MSD: fire_core(fire_core)
    dlx_l7_tx_header (1 downto 0) => dlx_l7_tx_header (1 downto 0), -- MSD: fire_core(fire_core)
    dlx_l7_tx_seq (5 downto 0)    => dlx_l7_tx_seq (5 downto 0)   , -- MSD: fire_core(fire_core)
    fbist_axis_aclk               => fbist_axis_aclk              , -- MSR: fire_core(fire_core)
    fbist_axis_i                  => fbist_axis_i                 , -- MSR: fire_core(fire_core)
    fbist_axis_o                  => fbist_axis_o                 , -- MSD: fire_core(fire_core)
    gtwiz_buffbypass_rx_done_in   => gtwiz_buffbypass_rx_done_in  , -- MSR: fire_core(fire_core)
    gtwiz_buffbypass_tx_done_in   => gtwiz_buffbypass_tx_done_in  , -- MSR: fire_core(fire_core)
    gtwiz_reset_all_out           => gtwiz_reset_all_out          , -- MSD: fire_core(fire_core)
    gtwiz_reset_rx_datapath_out   => gtwiz_reset_rx_datapath_out  , -- MSD: fire_core(fire_core)
    gtwiz_reset_rx_done_in        => gtwiz_reset_rx_done_in       , -- MSR: fire_core(fire_core)
    gtwiz_reset_tx_done_in        => gtwiz_reset_tx_done_in       , -- MSR: fire_core(fire_core)
    gtwiz_userclk_rx_active_in    => gtwiz_userclk_rx_active_in   , -- MSR: fire_core(fire_core)
    gtwiz_userclk_tx_active_in    => gtwiz_userclk_tx_active_in   , -- MSR: fire_core(fire_core)
    hb_gtwiz_reset_all_in         => hb_gtwiz_reset_all_in        , -- MSR: fire_core(fire_core)
    ln0_rx_data (63 downto 0)     => ln0_rx_data (63 downto 0)    , -- MSR: fire_core(fire_core)
    ln0_rx_header (1 downto 0)    => ln0_rx_header (1 downto 0)   , -- MSR: fire_core(fire_core)
    ln0_rx_slip                   => ln0_rx_slip                  , -- MSD: fire_core(fire_core)
    ln0_rx_valid                  => ln0_rx_valid                 , -- MSR: fire_core(fire_core)
    ln1_rx_data (63 downto 0)     => ln1_rx_data (63 downto 0)    , -- MSR: fire_core(fire_core)
    ln1_rx_header (1 downto 0)    => ln1_rx_header (1 downto 0)   , -- MSR: fire_core(fire_core)
    ln1_rx_slip                   => ln1_rx_slip                  , -- MSD: fire_core(fire_core)
    ln1_rx_valid                  => ln1_rx_valid                 , -- MSR: fire_core(fire_core)
    ln2_rx_data (63 downto 0)     => ln2_rx_data (63 downto 0)    , -- MSR: fire_core(fire_core)
    ln2_rx_header (1 downto 0)    => ln2_rx_header (1 downto 0)   , -- MSR: fire_core(fire_core)
    ln2_rx_slip                   => ln2_rx_slip                  , -- MSD: fire_core(fire_core)
    ln2_rx_valid                  => ln2_rx_valid                 , -- MSR: fire_core(fire_core)
    ln3_rx_data (63 downto 0)     => ln3_rx_data (63 downto 0)    , -- MSR: fire_core(fire_core)
    ln3_rx_header (1 downto 0)    => ln3_rx_header (1 downto 0)   , -- MSR: fire_core(fire_core)
    ln3_rx_slip                   => ln3_rx_slip                  , -- MSD: fire_core(fire_core)
    ln3_rx_valid                  => ln3_rx_valid                 , -- MSR: fire_core(fire_core)
    ln4_rx_data (63 downto 0)     => ln4_rx_data (63 downto 0)    , -- MSR: fire_core(fire_core)
    ln4_rx_header (1 downto 0)    => ln4_rx_header (1 downto 0)   , -- MSR: fire_core(fire_core)
    ln4_rx_slip                   => ln4_rx_slip                  , -- MSD: fire_core(fire_core)
    ln4_rx_valid                  => ln4_rx_valid                 , -- MSR: fire_core(fire_core)
    ln5_rx_data (63 downto 0)     => ln5_rx_data (63 downto 0)    , -- MSR: fire_core(fire_core)
    ln5_rx_header (1 downto 0)    => ln5_rx_header (1 downto 0)   , -- MSR: fire_core(fire_core)
    ln5_rx_slip                   => ln5_rx_slip                  , -- MSD: fire_core(fire_core)
    ln5_rx_valid                  => ln5_rx_valid                 , -- MSR: fire_core(fire_core)
    ln6_rx_data (63 downto 0)     => ln6_rx_data (63 downto 0)    , -- MSR: fire_core(fire_core)
    ln6_rx_header (1 downto 0)    => ln6_rx_header (1 downto 0)   , -- MSR: fire_core(fire_core)
    ln6_rx_slip                   => ln6_rx_slip                  , -- MSD: fire_core(fire_core)
    ln6_rx_valid                  => ln6_rx_valid                 , -- MSR: fire_core(fire_core)
    ln7_rx_data (63 downto 0)     => ln7_rx_data (63 downto 0)    , -- MSR: fire_core(fire_core)
    ln7_rx_header (1 downto 0)    => ln7_rx_header (1 downto 0)   , -- MSR: fire_core(fire_core)
    ln7_rx_slip                   => ln7_rx_slip                  , -- MSD: fire_core(fire_core)
    ln7_rx_valid                  => ln7_rx_valid                 , -- MSR: fire_core(fire_core)
    oc_host_cfg0_axis_aclk        => oc_host_cfg0_axis_aclk       , -- MSR: fire_core(fire_core)
    oc_host_cfg0_axis_i           => oc_host_cfg0_axis_i          , -- MSR: fire_core(fire_core)
    oc_host_cfg0_axis_o           => oc_host_cfg0_axis_o          , -- MSD: fire_core(fire_core)
    oc_memory0_axis_aclk          => oc_memory0_axis_aclk         , -- MSR: fire_core(fire_core)
    oc_memory0_axis_i             => oc_memory0_axis_i            , -- MSR: fire_core(fire_core)
    oc_memory0_axis_o             => oc_memory0_axis_o            , -- MSD: fire_core(fire_core)
    oc_mmio0_axis_aclk            => oc_mmio0_axis_aclk           , -- MSR: fire_core(fire_core)
    oc_mmio0_axis_i               => oc_mmio0_axis_i              , -- MSR: fire_core(fire_core)
    oc_mmio0_axis_o               => oc_mmio0_axis_o              , -- MSD: fire_core(fire_core)
    oc_cfg0_axis_aclk             => oc_cfg0_axis_aclk            , -- MSR: fire_core(fire_core)
    oc_cfg0_axis_i                => oc_cfg0_axis_i               , -- MSR: fire_core(fire_core)
    oc_cfg0_axis_o                => oc_cfg0_axis_o               , -- MSD: fire_core(fire_core)
    ocde                          => ocde_int                         , -- MSR: fire_core(fire_core)
    rclk                          => rclk                         , -- MSR: fire_core(fire_core)
    sys_resetn                    => sys_resetn               , -- MSR: fire_core(fire_core)
    sysclk                        => sysclk                         -- MSR: fire_core(fire_core)
);

fire_pervasive : entity work.fire_pervasive
port map (
    c3s_dlx_axis_aclk      => c3s_dlx_axis_aclk     , -- MSD: fire_pervasive(fire_pervasive)
    c3s_dlx_axis_i         => c3s_dlx_axis_i        , -- MSD: fire_pervasive(fire_pervasive)
    c3s_dlx_axis_o         => c3s_dlx_axis_o        , -- MSR: fire_pervasive(fire_pervasive)
    cclk_a                 => cclk_a                , -- MSR: fire_pervasive(fire_pervasive)
    cresetn_a              => cresetn_a             , -- MSD: fire_pervasive(fire_pervasive)
    oc_memory0_axis_aclk   => oc_memory0_axis_aclk  , -- MSD: fire_pervasive(fire_pervasive)
    oc_memory0_axis_i      => oc_memory0_axis_i     , -- MSD: fire_pervasive(fire_pervasive)
    oc_memory0_axis_o      => oc_memory0_axis_o     , -- MSR: fire_pervasive(fire_pervasive)
    oc_mmio0_axis_aclk     => oc_mmio0_axis_aclk    , -- MSD: fire_pervasive(fire_pervasive)
    oc_mmio0_axis_i        => oc_mmio0_axis_i       , -- MSD: fire_pervasive(fire_pervasive)
    oc_mmio0_axis_o        => oc_mmio0_axis_o       , -- MSR: fire_pervasive(fire_pervasive)
    oc_cfg0_axis_aclk      => oc_cfg0_axis_aclk     , -- MSD: fire_pervasive(fire_pervasive)
    oc_cfg0_axis_i         => oc_cfg0_axis_i        , -- MSD: fire_pervasive(fire_pervasive)
    oc_cfg0_axis_o         => oc_cfg0_axis_o        , -- MSR: fire_pervasive(fire_pervasive)
    fbist_axis_aclk        => fbist_axis_aclk       , -- MSD: fire_pervasive(fire_pervasive)
    fbist_axis_i           => fbist_axis_i          , -- MSD: fire_pervasive(fire_pervasive)
    fbist_axis_o           => fbist_axis_o          , -- MSR: fire_pervasive(fire_pervasive)
    oc_host_cfg0_axis_aclk => oc_host_cfg0_axis_aclk, -- MSD: fire_pervasive(fire_pervasive)
    oc_host_cfg0_axis_i    => oc_host_cfg0_axis_i   , -- MSD: fire_pervasive(fire_pervasive)
    oc_host_cfg0_axis_o    => oc_host_cfg0_axis_o   , -- MSR: fire_pervasive(fire_pervasive)
    scl_io                 => scl_io                , -- MSB: fire_pervasive(fire_pervasive)
    sda_io                 => sda_io                , -- MSB: fire_pervasive(fire_pervasive)
    pll_locked             => pll_locked            , -- MSD: fire_pervasive(fire_pervasive)
    raw_resetn             => raw_resetn_int        , -- MSR: fire_pervasive(fire_pervasive)
    raw_sysclk_n           => raw_sysclk_n          , -- MSR: fire_pervasive(fire_pervasive)
    raw_sysclk_p           => raw_sysclk_p          , -- MSR: fire_pervasive(fire_pervasive)
    sys_resetn             => sys_resetn            , -- MSD: fire_pervasive(fire_pervasive)
    sysclk                 => sysclk                  -- MSD: fire_pervasive(fire_pervasive)
);

hss0 : entity work.hss_phy_wrap
port map (
    mgtrefclk0_x0y0_p             => mgtrefclk0_x0y0_p             , -- MSR: hss_phy_wrap(hss0)
    mgtrefclk0_x0y0_n             => mgtrefclk0_x0y0_n             , -- MSR: hss_phy_wrap(hss0)
    mgtrefclk0_x0y1_p             => mgtrefclk0_x0y1_p             , -- MSR: hss_phy_wrap(hss0)
    mgtrefclk0_x0y1_n             => mgtrefclk0_x0y1_n             , -- MSR: hss_phy_wrap(hss0)
    ch0_gtyrxn_in                 => ch0_gtyrxn_in                 , -- MSR: hss_phy_wrap(hss0)
    ch0_gtyrxp_in                 => ch0_gtyrxp_in                 , -- MSR: hss_phy_wrap(hss0)
    ch0_gtytxn_out                => ch0_gtytxn_out                , -- MSD: hss_phy_wrap(hss0)
    ch0_gtytxp_out                => ch0_gtytxp_out                , -- MSD: hss_phy_wrap(hss0)
    ch1_gtyrxn_in                 => ch1_gtyrxn_in                 , -- MSR: hss_phy_wrap(hss0)
    ch1_gtyrxp_in                 => ch1_gtyrxp_in                 , -- MSR: hss_phy_wrap(hss0)
    ch1_gtytxn_out                => ch1_gtytxn_out                , -- MSD: hss_phy_wrap(hss0)
    ch1_gtytxp_out                => ch1_gtytxp_out                , -- MSD: hss_phy_wrap(hss0)
    ch2_gtyrxn_in                 => ch2_gtyrxn_in                 , -- MSR: hss_phy_wrap(hss0)
    ch2_gtyrxp_in                 => ch2_gtyrxp_in                 , -- MSR: hss_phy_wrap(hss0)
    ch2_gtytxn_out                => ch2_gtytxn_out                , -- MSD: hss_phy_wrap(hss0)
    ch2_gtytxp_out                => ch2_gtytxp_out                , -- MSD: hss_phy_wrap(hss0)
    ch3_gtyrxn_in                 => ch3_gtyrxn_in                 , -- MSR: hss_phy_wrap(hss0)
    ch3_gtyrxp_in                 => ch3_gtyrxp_in                 , -- MSR: hss_phy_wrap(hss0)
    ch3_gtytxn_out                => ch3_gtytxn_out                , -- MSD: hss_phy_wrap(hss0)
    ch3_gtytxp_out                => ch3_gtytxp_out                , -- MSD: hss_phy_wrap(hss0)
    ch4_gtyrxn_in                 => ch4_gtyrxn_in                 , -- MSR: hss_phy_wrap(hss0)
    ch4_gtyrxp_in                 => ch4_gtyrxp_in                 , -- MSR: hss_phy_wrap(hss0)
    ch4_gtytxn_out                => ch4_gtytxn_out                , -- MSD: hss_phy_wrap(hss0)
    ch4_gtytxp_out                => ch4_gtytxp_out                , -- MSD: hss_phy_wrap(hss0)
    ch5_gtyrxn_in                 => ch5_gtyrxn_in                 , -- MSR: hss_phy_wrap(hss0)
    ch5_gtyrxp_in                 => ch5_gtyrxp_in                 , -- MSR: hss_phy_wrap(hss0)
    ch5_gtytxn_out                => ch5_gtytxn_out                , -- MSD: hss_phy_wrap(hss0)
    ch5_gtytxp_out                => ch5_gtytxp_out                , -- MSD: hss_phy_wrap(hss0)
    ch6_gtyrxn_in                 => ch6_gtyrxn_in                 , -- MSR: hss_phy_wrap(hss0)
    ch6_gtyrxp_in                 => ch6_gtyrxp_in                 , -- MSR: hss_phy_wrap(hss0)
    ch6_gtytxn_out                => ch6_gtytxn_out                , -- MSD: hss_phy_wrap(hss0)
    ch6_gtytxp_out                => ch6_gtytxp_out                , -- MSD: hss_phy_wrap(hss0)
    ch7_gtyrxn_in                 => ch7_gtyrxn_in                 , -- MSR: hss_phy_wrap(hss0)
    ch7_gtyrxp_in                 => ch7_gtyrxp_in                 , -- MSR: hss_phy_wrap(hss0)
    ch7_gtytxn_out                => ch7_gtytxn_out                , -- MSD: hss_phy_wrap(hss0)
    ch7_gtytxp_out                => ch7_gtytxp_out                , -- MSD: hss_phy_wrap(hss0)
    ch0_txheader                  => ch0_txheader                  , -- MSR: hss_phy_wrap(hss0)
    ch1_txheader                  => ch1_txheader                  , -- MSR: hss_phy_wrap(hss0)
    ch2_txheader                  => ch2_txheader                  , -- MSR: hss_phy_wrap(hss0)
    ch3_txheader                  => ch3_txheader                  , -- MSR: hss_phy_wrap(hss0)
    ch4_txheader                  => ch4_txheader                  , -- MSR: hss_phy_wrap(hss0)
    ch5_txheader                  => ch5_txheader                  , -- MSR: hss_phy_wrap(hss0)
    ch6_txheader                  => ch6_txheader                  , -- MSR: hss_phy_wrap(hss0)
    ch7_txheader                  => ch7_txheader                  , -- MSR: hss_phy_wrap(hss0)
    ch0_txsequence                => ch0_txsequence                , -- MSR: hss_phy_wrap(hss0)
    ch1_txsequence                => ch1_txsequence                , -- MSR: hss_phy_wrap(hss0)
    ch2_txsequence                => ch2_txsequence                , -- MSR: hss_phy_wrap(hss0)
    ch3_txsequence                => ch3_txsequence                , -- MSR: hss_phy_wrap(hss0)
    ch4_txsequence                => ch4_txsequence                , -- MSR: hss_phy_wrap(hss0)
    ch5_txsequence                => ch5_txsequence                , -- MSR: hss_phy_wrap(hss0)
    ch6_txsequence                => ch6_txsequence                , -- MSR: hss_phy_wrap(hss0)
    ch7_txsequence                => ch7_txsequence                , -- MSR: hss_phy_wrap(hss0)
    hb0_gtwiz_userdata_tx         => hb0_gtwiz_userdata_tx         , -- MSR: hss_phy_wrap(hss0)
    hb1_gtwiz_userdata_tx         => hb1_gtwiz_userdata_tx         , -- MSR: hss_phy_wrap(hss0)
    hb2_gtwiz_userdata_tx         => hb2_gtwiz_userdata_tx         , -- MSR: hss_phy_wrap(hss0)
    hb3_gtwiz_userdata_tx         => hb3_gtwiz_userdata_tx         , -- MSR: hss_phy_wrap(hss0)
    hb4_gtwiz_userdata_tx         => hb4_gtwiz_userdata_tx         , -- MSR: hss_phy_wrap(hss0)
    hb5_gtwiz_userdata_tx         => hb5_gtwiz_userdata_tx         , -- MSR: hss_phy_wrap(hss0)
    hb6_gtwiz_userdata_tx         => hb6_gtwiz_userdata_tx         , -- MSR: hss_phy_wrap(hss0)
    hb7_gtwiz_userdata_tx         => hb7_gtwiz_userdata_tx         , -- MSR: hss_phy_wrap(hss0)
    ch0_rxdatavalid               => ch0_rxdatavalid               , -- MSD: hss_phy_wrap(hss0)
    ch1_rxdatavalid               => ch1_rxdatavalid               , -- MSD: hss_phy_wrap(hss0)
    ch2_rxdatavalid               => ch2_rxdatavalid               , -- MSD: hss_phy_wrap(hss0)
    ch3_rxdatavalid               => ch3_rxdatavalid               , -- MSD: hss_phy_wrap(hss0)
    ch4_rxdatavalid               => ch4_rxdatavalid               , -- MSD: hss_phy_wrap(hss0)
    ch5_rxdatavalid               => ch5_rxdatavalid               , -- MSD: hss_phy_wrap(hss0)
    ch6_rxdatavalid               => ch6_rxdatavalid               , -- MSD: hss_phy_wrap(hss0)
    ch7_rxdatavalid               => ch7_rxdatavalid               , -- MSD: hss_phy_wrap(hss0)
    ch0_rxheader                  => ch0_rxheader                  , -- MSD: hss_phy_wrap(hss0)
    ch1_rxheader                  => ch1_rxheader                  , -- MSD: hss_phy_wrap(hss0)
    ch2_rxheader                  => ch2_rxheader                  , -- MSD: hss_phy_wrap(hss0)
    ch3_rxheader                  => ch3_rxheader                  , -- MSD: hss_phy_wrap(hss0)
    ch4_rxheader                  => ch4_rxheader                  , -- MSD: hss_phy_wrap(hss0)
    ch5_rxheader                  => ch5_rxheader                  , -- MSD: hss_phy_wrap(hss0)
    ch6_rxheader                  => ch6_rxheader                  , -- MSD: hss_phy_wrap(hss0)
    ch7_rxheader                  => ch7_rxheader                  , -- MSD: hss_phy_wrap(hss0)
    ch0_rxgearboxslip             => ch0_rxgearboxslip             , -- MSR: hss_phy_wrap(hss0)
    ch1_rxgearboxslip             => ch1_rxgearboxslip             , -- MSR: hss_phy_wrap(hss0)
    ch2_rxgearboxslip             => ch2_rxgearboxslip             , -- MSR: hss_phy_wrap(hss0)
    ch3_rxgearboxslip             => ch3_rxgearboxslip             , -- MSR: hss_phy_wrap(hss0)
    ch4_rxgearboxslip             => ch4_rxgearboxslip             , -- MSR: hss_phy_wrap(hss0)
    ch5_rxgearboxslip             => ch5_rxgearboxslip             , -- MSR: hss_phy_wrap(hss0)
    ch6_rxgearboxslip             => ch6_rxgearboxslip             , -- MSR: hss_phy_wrap(hss0)
    ch7_rxgearboxslip             => ch7_rxgearboxslip             , -- MSR: hss_phy_wrap(hss0)
    gtwiz_buffbypass_rx_done_in   => gtwiz_buffbypass_rx_done_in   , -- MSD: hss_phy_wrap(hss0)
    gtwiz_buffbypass_tx_done_in   => gtwiz_buffbypass_tx_done_in   , -- MSD: hss_phy_wrap(hss0)
    gtwiz_reset_all_out           => gtwiz_reset_all_out           , -- MSR: hss_phy_wrap(hss0)
    gtwiz_reset_rx_datapath_out   => gtwiz_reset_rx_datapath_out   , -- MSR: hss_phy_wrap(hss0)
    gtwiz_reset_rx_done_in        => gtwiz_reset_rx_done_in        , -- MSD: hss_phy_wrap(hss0)
    gtwiz_reset_tx_done_in        => gtwiz_reset_tx_done_in        , -- MSD: hss_phy_wrap(hss0)
    gtwiz_userclk_rx_active_in    => gtwiz_userclk_rx_active_in    , -- MSD: hss_phy_wrap(hss0)
    gtwiz_userclk_tx_active_in    => gtwiz_userclk_tx_active_in    , -- MSD: hss_phy_wrap(hss0)
    hb0_gtwiz_userdata_rx         => hb0_gtwiz_userdata_rx         , -- MSD: hss_phy_wrap(hss0)
    hb1_gtwiz_userdata_rx         => hb1_gtwiz_userdata_rx         , -- MSD: hss_phy_wrap(hss0)
    hb2_gtwiz_userdata_rx         => hb2_gtwiz_userdata_rx         , -- MSD: hss_phy_wrap(hss0)
    hb3_gtwiz_userdata_rx         => hb3_gtwiz_userdata_rx         , -- MSD: hss_phy_wrap(hss0)
    hb4_gtwiz_userdata_rx         => hb4_gtwiz_userdata_rx         , -- MSD: hss_phy_wrap(hss0)
    hb5_gtwiz_userdata_rx         => hb5_gtwiz_userdata_rx         , -- MSD: hss_phy_wrap(hss0)
    hb6_gtwiz_userdata_rx         => hb6_gtwiz_userdata_rx         , -- MSD: hss_phy_wrap(hss0)
    hb7_gtwiz_userdata_rx         => hb7_gtwiz_userdata_rx         , -- MSD: hss_phy_wrap(hss0)
    hb_gtwiz_reset_all_in         => hb_gtwiz_reset_all_in         , -- MSD: hss_phy_wrap(hss0)
    cclk                          => cclk_a                        , -- MSD: hss_phy_wrap(hss0)
    raw_rclk_n                    => raw_rclk_n                    , -- MSR: hss_phy_wrap(hss0)
    raw_rclk_p                    => raw_rclk_p                    , -- MSR: hss_phy_wrap(hss0)
    rclk                          => rclk                            -- MSD: hss_phy_wrap(hss0)
);
end fire_top;
