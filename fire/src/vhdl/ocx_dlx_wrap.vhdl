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

entity ocx_dlx_wrap is
  port (
    ---------------------------------------------------------------------------
    -- Clocking
    ---------------------------------------------------------------------------
    tsm_state2_to_3 : in std_ulogic;
    tsm_state6_to_1 : in std_ulogic;
    tsm_state4_to_5 : in std_ulogic;
    --tsm_state5_to_6 : in std_ulogic;
    o_dlx_reset     : OUT std_ulogic;
    opt_gckn        : in std_ulogic;
    ocde            : in std_ulogic;
    lane_force_unlock : in std_ulogic_vector(7 downto 0);
    
    ---------------------------------------------------------------------------
    -- AXI register interface
    ---------------------------------------------------------------------------
    dl_debug_vector                : out std_ulogic_vector(127 downto 0);
    reg_04_val                     : in std_ulogic_vector(31 downto 0);
    reg_04_hwwe                    : out std_ulogic;
    reg_04_update                  : out std_ulogic_vector(31 downto 0);
    reg_05_hwwe                    : out std_ulogic;
    reg_05_update                  : out std_ulogic_vector(31 downto 0);
    reg_06_hwwe                    : out std_ulogic;
    reg_06_update                  : out std_ulogic_vector(31 downto 0);
    reg_07_hwwe                    : out std_ulogic;
    reg_07_update                  : out std_ulogic_vector(31 downto 0);

    ---------------------------------------------------------------------------
    -- Debug
    ---------------------------------------------------------------------------
    tlx_dlx_debug_encode           : in std_ulogic_vector(3 downto 0);
    tlx_dlx_debug_info             : in std_ulogic_vector(31 downto 0);
    ro_dlx_version                 : out std_ulogic_vector(31 downto 0);

    ---------------------------------------------------------------------------
    -- RX Interface
    ---------------------------------------------------------------------------
    -- Interface to TLx
    dlx_tlx_flit_valid             : out std_ulogic;
    dlx_tlx_flit                   : out std_ulogic_vector(511 downto 0);
    dlx_tlx_flit_crc_err           : out std_ulogic;
    dlx_tlx_link_up                : out std_ulogic;
    dlx_config_info                : out std_ulogic_vector(31 downto 0);
    -- Interface to PHY
    ln0_rx_valid                   : in std_ulogic;
    ln0_rx_header                  : in std_ulogic_vector(1 downto 0);
    ln0_rx_data                    : in std_ulogic_vector(63 downto 0);
    ln0_rx_slip                    : out std_ulogic;
    ln1_rx_valid                   : in std_ulogic;
    ln1_rx_header                  : in std_ulogic_vector(1 downto 0);
    ln1_rx_data                    : in std_ulogic_vector(63 downto 0);
    ln1_rx_slip                    : out std_ulogic;
    ln2_rx_valid                   : in std_ulogic;
    ln2_rx_header                  : in std_ulogic_vector(1 downto 0);
    ln2_rx_data                    : in std_ulogic_vector(63 downto 0);
    ln2_rx_slip                    : out std_ulogic;
    ln3_rx_valid                   : in std_ulogic;
    ln3_rx_header                  : in std_ulogic_vector(1 downto 0);
    ln3_rx_data                    : in std_ulogic_vector(63 downto 0);
    ln3_rx_slip                    : out std_ulogic;
    ln4_rx_valid                   : in std_ulogic;
    ln4_rx_header                  : in std_ulogic_vector(1 downto 0);
    ln4_rx_data                    : in std_ulogic_vector(63 downto 0);
    ln4_rx_slip                    : out std_ulogic;
    ln5_rx_valid                   : in std_ulogic;
    ln5_rx_header                  : in std_ulogic_vector(1 downto 0);
    ln5_rx_data                    : in std_ulogic_vector(63 downto 0);
    ln5_rx_slip                    : out std_ulogic;
    ln6_rx_valid                   : in std_ulogic;
    ln6_rx_header                  : in std_ulogic_vector(1 downto 0);
    ln6_rx_data                    : in std_ulogic_vector(63 downto 0);
    ln6_rx_slip                    : out std_ulogic;
    ln7_rx_valid                   : in std_ulogic;
    ln7_rx_header                  : in std_ulogic_vector(1 downto 0);
    ln7_rx_data                    : in std_ulogic_vector(63 downto 0);
    ln7_rx_slip                    : out std_ulogic;

    ---------------------------------------------------------------------------
    -- TX Interface
    ---------------------------------------------------------------------------
    -- Interface to TLx
    dlx_tlx_flit_credit            : out std_ulogic;
    dlx_tlx_init_flit_depth        : out std_ulogic_vector(2 downto 0);
    tlx_dlx_flit_valid             : in std_ulogic;
    tlx_dlx_flit                   : in std_ulogic_vector(511 downto 0);
    -- Interface to PHY
    dlx_l0_tx_data                 : out std_ulogic_vector(63 downto 0);
    dlx_l1_tx_data                 : out std_ulogic_vector(63 downto 0);
    dlx_l2_tx_data                 : out std_ulogic_vector(63 downto 0);
    dlx_l3_tx_data                 : out std_ulogic_vector(63 downto 0);
    dlx_l4_tx_data                 : out std_ulogic_vector(63 downto 0);
    dlx_l5_tx_data                 : out std_ulogic_vector(63 downto 0);
    dlx_l6_tx_data                 : out std_ulogic_vector(63 downto 0);
    dlx_l7_tx_data                 : out std_ulogic_vector(63 downto 0);
    dlx_l0_tx_header               : out std_ulogic_vector(1 downto 0);
    dlx_l1_tx_header               : out std_ulogic_vector(1 downto 0);
    dlx_l2_tx_header               : out std_ulogic_vector(1 downto 0);
    dlx_l3_tx_header               : out std_ulogic_vector(1 downto 0);
    dlx_l4_tx_header               : out std_ulogic_vector(1 downto 0);
    dlx_l5_tx_header               : out std_ulogic_vector(1 downto 0);
    dlx_l6_tx_header               : out std_ulogic_vector(1 downto 0);
    dlx_l7_tx_header               : out std_ulogic_vector(1 downto 0);
    dlx_l0_tx_seq                  : out std_ulogic_vector(5 downto 0);
    dlx_l1_tx_seq                  : out std_ulogic_vector(5 downto 0);
    dlx_l2_tx_seq                  : out std_ulogic_vector(5 downto 0);
    dlx_l3_tx_seq                  : out std_ulogic_vector(5 downto 0);
    dlx_l4_tx_seq                  : out std_ulogic_vector(5 downto 0);
    dlx_l5_tx_seq                  : out std_ulogic_vector(5 downto 0);
    dlx_l6_tx_seq                  : out std_ulogic_vector(5 downto 0);
    dlx_l7_tx_seq                  : out std_ulogic_vector(5 downto 0);

    -------------------------------------------------------------------------------
    -- PHY Configuration Interface
    -------------------------------------------------------------------------------
    clk_156_25MHz                  : in std_ulogic;
    gtwiz_reset_all_out            : out std_ulogic;
    hb_gtwiz_reset_all_in          : in std_ulogic;
    gtwiz_reset_tx_done_in         : in std_ulogic;
    gtwiz_reset_rx_done_in         : in std_ulogic;
    gtwiz_buffbypass_tx_done_in    : in std_ulogic;
    gtwiz_buffbypass_rx_done_in    : in std_ulogic;
    gtwiz_userclk_tx_active_in     : in std_ulogic;
    gtwiz_userclk_rx_active_in     : in std_ulogic;
    send_first                     : in std_ulogic;
    gtwiz_reset_rx_datapath_out    : out std_ulogic   
        );

  attribute BLOCK_TYPE of ocx_dlx_wrap : entity is SOFT;
  attribute BTR_NAME of ocx_dlx_wrap : entity is "OCX_DLX_WRAP";
  attribute RECURSIVE_SYNTHESIS of ocx_dlx_wrap : entity is 2;
end ocx_dlx_wrap;

architecture ocx_dlx_wrap of ocx_dlx_wrap is

  component ocx_dlx_top
    port (
      ---------------------------------------------------------------------------
      -- Clocking
      ---------------------------------------------------------------------------
      tsm_state2_to_3 : in std_ulogic;
      tsm_state6_to_1 : in std_ulogic;
      tsm_state4_to_5 : in std_ulogic;
--      tsm_state5_to_6 : in std_ulogic;
      dlx_reset     : OUT std_ulogic;
      opt_gckn : in    std_ulogic;
      ocde     : in    std_ulogic;
      lane_force_unlock : in std_ulogic_vector(7 downto 0);
--      reg_val     : in    std_ulogic_vector(31 DOWNTO 0);
     --EDPL
      dl_debug_vector             : out std_ulogic_vector(127 downto 0);
      reg_04_val                  : in  STD_ULOGIC_VECTOR(31 DOWNTO 0);
      reg_04_hwwe                 : out STD_ULOGIC;
      reg_04_update               : out STD_ULOGIC_VECTOR(31 DOWNTO 0);
      reg_05_hwwe                 : out STD_ULOGIC;
      reg_05_update               : out STD_ULOGIC_VECTOR(31 DOWNTO 0);
      reg_06_hwwe                 : out STD_ULOGIC;
      reg_06_update               : out STD_ULOGIC_VECTOR(31 DOWNTO 0);
      reg_07_hwwe                 : out STD_ULOGIC;
      reg_07_update               : out STD_ULOGIC_VECTOR(31 DOWNTO 0);
      ---------------------------------------------------------------------------
      -- Debug
      ---------------------------------------------------------------------------
      tlx_dlx_debug_encode : in  std_ulogic_vector(3 downto 0);
      tlx_dlx_debug_info   : in  std_ulogic_vector(31 downto 0);
      ro_dlx_version       : out std_ulogic_vector(31 downto 0);

      ---------------------------------------------------------------------------
      -- RX Interface
      ---------------------------------------------------------------------------
      -- Interface to TLx
      dlx_tlx_flit_valid   : out std_ulogic;
      dlx_tlx_flit         : out std_ulogic_vector(511 downto 0);
      dlx_tlx_flit_crc_err : out std_ulogic;
      dlx_tlx_link_up      : out std_ulogic;
      dlx_config_info      : out std_ulogic_vector(31 downto 0);
      -- Interface to PHY
      ln0_rx_valid         : in  std_ulogic;
      ln0_rx_header        : in  std_ulogic_vector(1 downto 0);
      ln0_rx_data          : in  std_ulogic_vector(63 downto 0);
      ln0_rx_slip          : out std_ulogic;
      ln1_rx_valid         : in  std_ulogic;
      ln1_rx_header        : in  std_ulogic_vector(1 downto 0);
      ln1_rx_data          : in  std_ulogic_vector(63 downto 0);
      ln1_rx_slip          : out std_ulogic;
      ln2_rx_valid         : in  std_ulogic;
      ln2_rx_header        : in  std_ulogic_vector(1 downto 0);
      ln2_rx_data          : in  std_ulogic_vector(63 downto 0);
      ln2_rx_slip          : out std_ulogic;
      ln3_rx_valid         : in  std_ulogic;
      ln3_rx_header        : in  std_ulogic_vector(1 downto 0);
      ln3_rx_data          : in  std_ulogic_vector(63 downto 0);
      ln3_rx_slip          : out std_ulogic;
      ln4_rx_valid         : in  std_ulogic;
      ln4_rx_header        : in  std_ulogic_vector(1 downto 0);
      ln4_rx_data          : in  std_ulogic_vector(63 downto 0);
      ln4_rx_slip          : out std_ulogic;
      ln5_rx_valid         : in  std_ulogic;
      ln5_rx_header        : in  std_ulogic_vector(1 downto 0);
      ln5_rx_data          : in  std_ulogic_vector(63 downto 0);
      ln5_rx_slip          : out std_ulogic;
      ln6_rx_valid         : in  std_ulogic;
      ln6_rx_header        : in  std_ulogic_vector(1 downto 0);
      ln6_rx_data          : in  std_ulogic_vector(63 downto 0);
      ln6_rx_slip          : out std_ulogic;
      ln7_rx_valid         : in  std_ulogic;
      ln7_rx_header        : in  std_ulogic_vector(1 downto 0);
      ln7_rx_data          : in  std_ulogic_vector(63 downto 0);
      ln7_rx_slip          : out std_ulogic;

      ---------------------------------------------------------------------------
      -- TX Interface
      ---------------------------------------------------------------------------
      -- Interface to TLx
      dlx_tlx_flit_credit     : out std_ulogic;
      dlx_tlx_init_flit_depth : out std_ulogic_vector(2 downto 0);
      tlx_dlx_flit_valid      : in  std_ulogic;
      tlx_dlx_flit            : in  std_ulogic_vector(511 downto 0);
      -- Interface to PHY
      dlx_l0_tx_data          : out std_ulogic_vector(63 downto 0);
      dlx_l1_tx_data          : out std_ulogic_vector(63 downto 0);
      dlx_l2_tx_data          : out std_ulogic_vector(63 downto 0);
      dlx_l3_tx_data          : out std_ulogic_vector(63 downto 0);
      dlx_l4_tx_data          : out std_ulogic_vector(63 downto 0);
      dlx_l5_tx_data          : out std_ulogic_vector(63 downto 0);
      dlx_l6_tx_data          : out std_ulogic_vector(63 downto 0);
      dlx_l7_tx_data          : out std_ulogic_vector(63 downto 0);
      dlx_l0_tx_header        : out std_ulogic_vector(1 downto 0);
      dlx_l1_tx_header        : out std_ulogic_vector(1 downto 0);
      dlx_l2_tx_header        : out std_ulogic_vector(1 downto 0);
      dlx_l3_tx_header        : out std_ulogic_vector(1 downto 0);
      dlx_l4_tx_header        : out std_ulogic_vector(1 downto 0);
      dlx_l5_tx_header        : out std_ulogic_vector(1 downto 0);
      dlx_l6_tx_header        : out std_ulogic_vector(1 downto 0);
      dlx_l7_tx_header        : out std_ulogic_vector(1 downto 0);
      dlx_l0_tx_seq           : out std_ulogic_vector(5 downto 0);
      dlx_l1_tx_seq           : out std_ulogic_vector(5 downto 0);
      dlx_l2_tx_seq           : out std_ulogic_vector(5 downto 0);
      dlx_l3_tx_seq           : out std_ulogic_vector(5 downto 0);
      dlx_l4_tx_seq           : out std_ulogic_vector(5 downto 0);
      dlx_l5_tx_seq           : out std_ulogic_vector(5 downto 0);
      dlx_l6_tx_seq           : out std_ulogic_vector(5 downto 0);
      dlx_l7_tx_seq           : out std_ulogic_vector(5 downto 0);

      -------------------------------------------------------------------------------
      -- PHY Configuration Interface
      -------------------------------------------------------------------------------
      clk_156_25MHz               : in  std_ulogic;
      gtwiz_reset_all_out         : out std_ulogic;
      hb_gtwiz_reset_all_in       : in  std_ulogic;
      gtwiz_reset_tx_done_in      : in  std_ulogic;
      gtwiz_reset_rx_done_in      : in  std_ulogic;
      gtwiz_buffbypass_tx_done_in : in  std_ulogic;
      gtwiz_buffbypass_rx_done_in : in  std_ulogic;
      gtwiz_userclk_tx_active_in  : in  std_ulogic;
      gtwiz_userclk_rx_active_in  : in  std_ulogic;
      send_first                  : in  std_ulogic;
      gtwiz_reset_rx_datapath_out : out std_ulogic   
      --hold_credits                : in  std_ulogic;
          );
  end component;

begin

  dlx : ocx_dlx_top
    port map (
      tsm_state2_to_3 => tsm_state2_to_3,
      tsm_state6_to_1 => tsm_state6_to_1,
      tsm_state4_to_5 => tsm_state4_to_5,
--      tsm_state5_to_6 => tsm_state5_to_6,
      dlx_reset       => o_dlx_reset,
      opt_gckn                    => opt_gckn,
      ocde                        => ocde,
      lane_force_unlock           => lane_force_unlock,
      --reg_val                     => x"00000000",
      --EDPL
      dl_debug_vector             => dl_debug_vector,
      reg_04_val                  => reg_04_val,  --    : in  STD_ULOGIC_VECTOR(31 DOWNTO 0);
      reg_04_hwwe                 => reg_04_hwwe,  --   : out STD_ULOGIC;
      reg_04_update               => reg_04_update,  -- : out STD_ULOGIC_VECTOR(31 DOWNTO 0);
      reg_05_hwwe                 => reg_05_hwwe,  --   : out STD_ULOGIC;
      reg_05_update               => reg_05_update,  -- : out STD_ULOGIC_VECTOR(31 DOWNTO 0);
      reg_06_hwwe                 => reg_06_hwwe,  --   : out STD_ULOGIC;
      reg_06_update               => reg_06_update,  -- : out STD_ULOGIC_VECTOR(31 DOWNTO 0);
      reg_07_hwwe                 => reg_07_hwwe,  --   : out STD_ULOGIC;
      reg_07_update               => reg_07_update,  -- : out STD_ULOGIC_VECTOR(31 DOWNTO 0);
      tlx_dlx_debug_encode        => tlx_dlx_debug_encode,
      tlx_dlx_debug_info          => tlx_dlx_debug_info,
      ro_dlx_version              => ro_dlx_version,
      dlx_tlx_flit_valid          => dlx_tlx_flit_valid,
      dlx_tlx_flit                => dlx_tlx_flit,
      dlx_tlx_flit_crc_err        => dlx_tlx_flit_crc_err,
      dlx_tlx_link_up             => dlx_tlx_link_up,
      dlx_config_info             => dlx_config_info,
      ln0_rx_valid                => ln0_rx_valid,
      ln0_rx_header               => ln0_rx_header,
      ln0_rx_data                 => ln0_rx_data,
      ln0_rx_slip                 => ln0_rx_slip,
      ln1_rx_valid                => ln1_rx_valid,
      ln1_rx_header               => ln1_rx_header,
      ln1_rx_data                 => ln1_rx_data,
      ln1_rx_slip                 => ln1_rx_slip,
      ln2_rx_valid                => ln2_rx_valid,
      ln2_rx_header               => ln2_rx_header,
      ln2_rx_data                 => ln2_rx_data,
      ln2_rx_slip                 => ln2_rx_slip,
      ln3_rx_valid                => ln3_rx_valid,
      ln3_rx_header               => ln3_rx_header,
      ln3_rx_data                 => ln3_rx_data,
      ln3_rx_slip                 => ln3_rx_slip,
      ln4_rx_valid                => ln4_rx_valid,
      ln4_rx_header               => ln4_rx_header,
      ln4_rx_data                 => ln4_rx_data,
      ln4_rx_slip                 => ln4_rx_slip,
      ln5_rx_valid                => ln5_rx_valid,
      ln5_rx_header               => ln5_rx_header,
      ln5_rx_data                 => ln5_rx_data,
      ln5_rx_slip                 => ln5_rx_slip,
      ln6_rx_valid                => ln6_rx_valid,
      ln6_rx_header               => ln6_rx_header,
      ln6_rx_data                 => ln6_rx_data,
      ln6_rx_slip                 => ln6_rx_slip,
      ln7_rx_valid                => ln7_rx_valid,
      ln7_rx_header               => ln7_rx_header,
      ln7_rx_data                 => ln7_rx_data,
      ln7_rx_slip                 => ln7_rx_slip,
      dlx_tlx_flit_credit         => dlx_tlx_flit_credit,
      dlx_tlx_init_flit_depth     => dlx_tlx_init_flit_depth,
      tlx_dlx_flit_valid          => tlx_dlx_flit_valid,
      tlx_dlx_flit                => tlx_dlx_flit,
      dlx_l0_tx_data              => dlx_l0_tx_data,
      dlx_l1_tx_data              => dlx_l1_tx_data,
      dlx_l2_tx_data              => dlx_l2_tx_data,
      dlx_l3_tx_data              => dlx_l3_tx_data,
      dlx_l4_tx_data              => dlx_l4_tx_data,
      dlx_l5_tx_data              => dlx_l5_tx_data,
      dlx_l6_tx_data              => dlx_l6_tx_data,
      dlx_l7_tx_data              => dlx_l7_tx_data,
      dlx_l0_tx_header            => dlx_l0_tx_header,
      dlx_l1_tx_header            => dlx_l1_tx_header,
      dlx_l2_tx_header            => dlx_l2_tx_header,
      dlx_l3_tx_header            => dlx_l3_tx_header,
      dlx_l4_tx_header            => dlx_l4_tx_header,
      dlx_l5_tx_header            => dlx_l5_tx_header,
      dlx_l6_tx_header            => dlx_l6_tx_header,
      dlx_l7_tx_header            => dlx_l7_tx_header,
      dlx_l0_tx_seq               => dlx_l0_tx_seq,
      dlx_l1_tx_seq               => dlx_l1_tx_seq,
      dlx_l2_tx_seq               => dlx_l2_tx_seq,
      dlx_l3_tx_seq               => dlx_l3_tx_seq,
      dlx_l4_tx_seq               => dlx_l4_tx_seq,
      dlx_l5_tx_seq               => dlx_l5_tx_seq,
      dlx_l6_tx_seq               => dlx_l6_tx_seq,
      dlx_l7_tx_seq               => dlx_l7_tx_seq,
      clk_156_25MHz               => clk_156_25MHz,
      gtwiz_reset_all_out         => gtwiz_reset_all_out,
      hb_gtwiz_reset_all_in       => hb_gtwiz_reset_all_in,
      gtwiz_reset_tx_done_in      => gtwiz_reset_tx_done_in,
      gtwiz_reset_rx_done_in      => gtwiz_reset_rx_done_in,
      gtwiz_buffbypass_tx_done_in => gtwiz_buffbypass_tx_done_in,
      gtwiz_buffbypass_rx_done_in => gtwiz_buffbypass_rx_done_in,
      gtwiz_userclk_tx_active_in  => gtwiz_userclk_tx_active_in,
      gtwiz_userclk_rx_active_in  => gtwiz_userclk_rx_active_in,
      send_first                  => send_first,
      gtwiz_reset_rx_datapath_out => gtwiz_reset_rx_datapath_out      
        );

end ocx_dlx_wrap;
