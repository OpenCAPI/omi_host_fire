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

entity fbist_mac is
  port (
    ---------------------------------------------------------------------------
    -- Clocking & Power
    ---------------------------------------------------------------------------
    sysclk                         : in std_ulogic;
    cclk                           : in std_ulogic;
    sys_reset                      : in std_ulogic;
    creset                         : in std_ulogic;

    ---------------------------------------------------------------------------
    -- Register Interface (AXI4-Lite Slave)
    ---------------------------------------------------------------------------
    fbist_axis_aclk                : in std_ulogic;
    fbist_axis_i                   : in t_AXI4_LITE_SLAVE_INPUT;
    fbist_axis_o                   : out t_AXI4_LITE_SLAVE_OUTPUT;

    ---------------------------------------------------------------------------
    -- Functional Interface
    ---------------------------------------------------------------------------
    fbist_oc_axim_aclk             : out std_ulogic;
    fbist_oc_axim_i                : in t_AXI3_512_MASTER_INPUT;
    fbist_oc_axim_o                : out t_AXI3_512_MASTER_OUTPUT
    );

  attribute BLOCK_TYPE of fbist_mac : entity is SUPERRLM;
  attribute BTR_NAME of fbist_mac : entity is "FBIST_MAC";
  attribute RECURSIVE_SYNTHESIS of fbist_mac : entity is 2;
  attribute PIN_DATA of sysclk : signal is "PIN_FUNCTION=/G_CLK/";
  attribute PIN_DEFAULT_GROUND_DOMAIN of fbist_mac : entity is "GND";
  attribute PIN_DEFAULT_POWER_DOMAIN of fbist_mac : entity is "VDD";
end fbist_mac;

architecture fbist_mac of fbist_mac is
  SIGNAL axi_fifo_full_gate : std_ulogic;
  SIGNAL agen_chk_command : std_ulogic_vector(7 downto 0);
  SIGNAL agen_chk_command_address : std_ulogic_vector(63 downto 0);
  SIGNAL agen_chk_command_engine : std_ulogic_vector(2 downto 0);
  SIGNAL agen_chk_command_tag : std_ulogic_vector(15 downto 0);
  SIGNAL agen_chk_command_valid : std_ulogic;
  SIGNAL agen_dgen_command : std_ulogic_vector(7 downto 0);
  SIGNAL agen_dgen_command_address : std_ulogic_vector(63 downto 0);
  SIGNAL agen_dgen_command_engine : std_ulogic_vector(2 downto 0);
  SIGNAL agen_dgen_command_tag : std_ulogic_vector(15 downto 0);
  SIGNAL agen_dgen_command_valid : std_ulogic;
  SIGNAL axi_chk_response : std_ulogic_vector(7 downto 0);
  SIGNAL axi_chk_response_data : std_ulogic_vector(511 downto 0);
  SIGNAL axi_chk_response_tag : std_ulogic_vector(15 downto 0);
  SIGNAL axi_chk_response_dpart : std_ulogic_vector(1 downto 0);
  SIGNAL axi_chk_response_ow : std_ulogic;
  SIGNAL axi_chk_response_valid : std_ulogic;
  SIGNAL cgen_agen_command : std_ulogic_vector(7 downto 0);
  SIGNAL cgen_agen_command_engine : std_ulogic_vector(2 downto 0);
  SIGNAL cgen_agen_command_valid : std_ulogic;
  SIGNAL chk_error_actual_data : std_ulogic_vector(511 downto 0);
  SIGNAL chk_error_actual_response : std_ulogic_vector(7 downto 0);
  SIGNAL chk_error_actual_valid : std_ulogic;
  SIGNAL chk_error_expected_command : std_ulogic_vector(7 downto 0);
  SIGNAL chk_error_expected_data : std_ulogic_vector(511 downto 0);
  SIGNAL chk_error_expected_valid : std_ulogic;
  SIGNAL chk_error_valid : std_ulogic;
  SIGNAL dgen_axi_command : std_ulogic_vector(7 downto 0);
  SIGNAL dgen_axi_command_address : std_ulogic_vector(63 downto 0);
  SIGNAL dgen_axi_command_data : std_ulogic_vector(511 downto 0);
  SIGNAL dgen_axi_command_engine : std_ulogic_vector(2 downto 0);
  SIGNAL dgen_axi_command_tag : std_ulogic_vector(15 downto 0);
  SIGNAL dgen_axi_command_valid : std_ulogic;
  SIGNAL fbist_cfg_pool0_arb_scheme : std_ulogic_vector(3 downto 0);
  SIGNAL fbist_cfg_status_ip : std_ulogic;
  SIGNAL fbist_cfg_pool0_engine0_address_mode : std_ulogic_vector(7 downto 0);
  SIGNAL fbist_cfg_pool0_engine0_command : std_ulogic_vector(7 downto 0);
  SIGNAL fbist_cfg_pool0_engine1_address_mode : std_ulogic_vector(7 downto 0);
  SIGNAL fbist_cfg_pool0_engine1_command : std_ulogic_vector(7 downto 0);
  SIGNAL fbist_cfg_pool0_engine2_address_mode : std_ulogic_vector(7 downto 0);
  SIGNAL fbist_cfg_pool0_engine2_command : std_ulogic_vector(7 downto 0);
  SIGNAL fbist_cfg_pool0_engine3_address_mode : std_ulogic_vector(7 downto 0);
  SIGNAL fbist_cfg_pool0_engine3_command : std_ulogic_vector(7 downto 0);
  SIGNAL fbist_cfg_pool0_engine4_address_mode : std_ulogic_vector(7 downto 0);
  SIGNAL fbist_cfg_pool0_engine4_command : std_ulogic_vector(7 downto 0);
  SIGNAL fbist_cfg_pool0_engine5_address_mode : std_ulogic_vector(7 downto 0);
  SIGNAL fbist_cfg_pool0_engine5_command : std_ulogic_vector(7 downto 0);
  SIGNAL fbist_cfg_pool0_engine6_address_mode : std_ulogic_vector(7 downto 0);
  SIGNAL fbist_cfg_pool0_engine6_command : std_ulogic_vector(7 downto 0);
  SIGNAL fbist_cfg_pool0_engine7_address_mode : std_ulogic_vector(7 downto 0);
  SIGNAL fbist_cfg_pool0_engine7_command : std_ulogic_vector(7 downto 0);
  SIGNAL fbist_cfg_pool0_spacing_count : std_ulogic_vector(15 downto 0);
  SIGNAL fbist_cfg_pool0_engine0_address_start : std_ulogic_vector(63 downto 0);
  SIGNAL fbist_cfg_pool0_engine1_address_start : std_ulogic_vector(63 downto 0);
  SIGNAL fbist_cfg_pool0_engine2_address_start : std_ulogic_vector(63 downto 0);
  SIGNAL fbist_cfg_pool0_engine3_address_start : std_ulogic_vector(63 downto 0);
  SIGNAL fbist_cfg_pool0_engine4_address_start : std_ulogic_vector(63 downto 0);
  SIGNAL fbist_cfg_pool0_engine5_address_start : std_ulogic_vector(63 downto 0);
  SIGNAL fbist_cfg_pool0_engine6_address_start : std_ulogic_vector(63 downto 0);
  SIGNAL fbist_cfg_pool0_engine7_address_start : std_ulogic_vector(63 downto 0);
  SIGNAL fbist_cfg_pool0_address_and_mask : std_ulogic_vector(63 downto 0);
  SIGNAL fbist_cfg_pool0_address_or_mask : std_ulogic_vector(63 downto 0);
  SIGNAL fbist_cfg_pool0_spacing_scheme : std_ulogic_vector(3 downto 0);
  SIGNAL fbist_cfg_pool0_stats_num_read_bytes : std_ulogic_vector(47 downto 0);
  SIGNAL fbist_cfg_pool0_stats_num_reads : std_ulogic_vector(47 downto 0);
  SIGNAL fbist_cfg_pool0_stats_num_write_bytes : std_ulogic_vector(47 downto 0);
  SIGNAL fbist_cfg_pool0_stats_num_writes : std_ulogic_vector(47 downto 0);
  SIGNAL fbist_cfg_pool0_stats_run_time : std_ulogic_vector(47 downto 0);
  SIGNAL fbist_cfg_chk_error_valid : std_ulogic;
  SIGNAL fbist_cfg_pool0_addrmod0_data_mode : std_ulogic_vector(3 downto 0);
  SIGNAL fbist_cfg_pool0_addrmod1_data_mode : std_ulogic_vector(3 downto 0);
  SIGNAL fbist_cfg_pool0_addrmod2_data_mode : std_ulogic_vector(3 downto 0);
  SIGNAL fbist_cfg_pool0_addrmod3_data_mode : std_ulogic_vector(3 downto 0);
  SIGNAL fbist_cfg_pool0_addrmod4_data_mode : std_ulogic_vector(3 downto 0);
  SIGNAL fbist_cfg_pool0_addrmod5_data_mode : std_ulogic_vector(3 downto 0);
  SIGNAL fbist_cfg_pool0_addrmod6_data_mode : std_ulogic_vector(3 downto 0);
  SIGNAL fbist_cfg_pool0_addrmod7_data_mode : std_ulogic_vector(3 downto 0);
  SIGNAL fbist_cfg_user_data_0 : std_ulogic_vector(63 downto 0);
  SIGNAL fbist_cfg_user_data_1 : std_ulogic_vector(63 downto 0);
  SIGNAL fbist_chk_outstanding_tags_valid : std_ulogic_vector(127 downto 0);
  SIGNAL fbist_freeze        : std_ulogic;
  SIGNAL chk_lut_full_gate   : std_ulogic;
  SIGNAL exp_rd_valid        : std_ulogic;
  SIGNAL exp_rd_address      : std_ulogic_vector(31 downto 0);
  SIGNAL exp_rd_data         : std_ulogic_vector(31 downto 0);
  SIGNAL exp_rd_data_valid   : std_ulogic;
  SIGNAL exp_wr_valid        : std_ulogic;  --  (data don't care)
  SIGNAL exp_wr_address      : std_ulogic_vector(31 downto 0);
  SIGNAL chk_fesbuff_we      : std_ulogic;
  SIGNAL chk_fesbuff_data    : std_ulogic_vector(543 downto 0);
  SIGNAL chk_cfg_engine0_total_latency : std_ulogic_vector(63 downto 0);
  SIGNAL chk_cfg_engine1_total_latency : std_ulogic_vector(63 downto 0);
  SIGNAL chk_cfg_engine2_total_latency : std_ulogic_vector(63 downto 0);
  SIGNAL chk_cfg_engine3_total_latency : std_ulogic_vector(63 downto 0);
  SIGNAL chk_cfg_engine4_total_latency : std_ulogic_vector(63 downto 0);
  SIGNAL chk_cfg_engine5_total_latency : std_ulogic_vector(63 downto 0);
  SIGNAL chk_cfg_engine6_total_latency : std_ulogic_vector(63 downto 0);
  SIGNAL chk_cfg_engine7_total_latency : std_ulogic_vector(63 downto 0);
  SIGNAL cfg_axi_address_inject_enable : std_ulogic;
  SIGNAL cfg_axi_data_inject_enable : std_ulogic;
  SIGNAL cfg_axi_address_inject_done : std_ulogic;
  SIGNAL cfg_axi_data_inject_done : std_ulogic;
  SIGNAL fbist_cfg_chk_error_response_hang : std_ulogic;
  signal fbist_axis_i_stage : t_AXI4_LITE_SLAVE_INPUT;
  signal fbist_axis_o_stage : t_AXI4_LITE_SLAVE_OUTPUT;

begin

  fbist_cfg_chk_error_valid <= chk_error_valid;

  -- Tee off the AGEN/DGEN interface to send to the checker
  agen_chk_command         <= agen_dgen_command;
  agen_chk_command_valid   <= agen_dgen_command_valid;
  agen_chk_command_engine  <= agen_dgen_command_engine;
  agen_chk_command_tag     <= agen_dgen_command_tag;
  agen_chk_command_address <= agen_dgen_command_address;

  -- Combine the various backpressure mechanisms into 1
  fbist_freeze <= not axi_fifo_full_gate or not chk_lut_full_gate;

agen : entity work.fbist_agen
port map (
    agen_dgen_command (7 downto 0)                  => agen_dgen_command (7 downto 0)                    , -- MSD: fbist_agen(agen)
    agen_dgen_command_address (63 downto 0)         => agen_dgen_command_address (63 downto 0)           , -- MSD: fbist_agen(agen)
    agen_dgen_command_engine (2 downto 0)           => agen_dgen_command_engine (2 downto 0)             , -- MSD: fbist_agen(agen)
    agen_dgen_command_tag (15 downto 0)             => agen_dgen_command_tag (15 downto 0)               , -- MSD: fbist_agen(agen)
    agen_dgen_command_valid                         => agen_dgen_command_valid                           , -- MSD: fbist_agen(agen)
    fbist_freeze                                    => fbist_freeze                                      , -- MSR: fbist_agen(agen)
    cgen_agen_command (7 downto 0)                  => cgen_agen_command (7 downto 0)                    , -- MSR: fbist_agen(agen)
    cgen_agen_command_engine (2 downto 0)           => cgen_agen_command_engine (2 downto 0)             , -- MSR: fbist_agen(agen)
    cgen_agen_command_valid                         => cgen_agen_command_valid                           , -- MSR: fbist_agen(agen)
    sysclk                                          => sysclk                                            , -- MSR: fbist_agen(agen)
    chk_lut_full_gate                               => chk_lut_full_gate                                 , -- MSD: fbist_agen(agen)
    fbist_cfg_address_and_mask(63 downto 0)         => fbist_cfg_pool0_address_and_mask(63 downto 0)     , -- OVR: fbist_agen(agen)
    fbist_cfg_address_or_mask(63 downto 0)          => fbist_cfg_pool0_address_or_mask(63 downto 0)      , -- OVR: fbist_agen(agen)
    fbist_cfg_engine0_address_mode(7 downto 0)      => fbist_cfg_pool0_engine0_address_mode(7 downto 0)  , -- OVR: fbist_agen(agen)
    fbist_cfg_engine0_address_start(63 downto 0)    => fbist_cfg_pool0_engine0_address_start(63 downto 0), -- OVR: fbist_agen(agen)
    fbist_cfg_engine1_address_mode(7 downto 0)      => fbist_cfg_pool0_engine1_address_mode(7 downto 0)  , -- OVR: fbist_agen(agen)
    fbist_cfg_engine1_address_start(63 downto 0)    => fbist_cfg_pool0_engine1_address_start(63 downto 0), -- OVR: fbist_agen(agen)
    fbist_cfg_engine2_address_mode(7 downto 0)      => fbist_cfg_pool0_engine2_address_mode(7 downto 0)  , -- OVR: fbist_agen(agen)
    fbist_cfg_engine2_address_start(63 downto 0)    => fbist_cfg_pool0_engine2_address_start(63 downto 0), -- OVR: fbist_agen(agen)
    fbist_cfg_engine3_address_mode(7 downto 0)      => fbist_cfg_pool0_engine3_address_mode(7 downto 0)  , -- OVR: fbist_agen(agen)
    fbist_cfg_engine3_address_start(63 downto 0)    => fbist_cfg_pool0_engine3_address_start(63 downto 0), -- OVR: fbist_agen(agen)
    fbist_cfg_engine4_address_mode(7 downto 0)      => fbist_cfg_pool0_engine4_address_mode(7 downto 0)  , -- OVR: fbist_agen(agen)
    fbist_cfg_engine4_address_start(63 downto 0)    => fbist_cfg_pool0_engine4_address_start(63 downto 0), -- OVR: fbist_agen(agen)
    fbist_cfg_engine5_address_mode(7 downto 0)      => fbist_cfg_pool0_engine5_address_mode(7 downto 0)  , -- OVR: fbist_agen(agen)
    fbist_cfg_engine5_address_start(63 downto 0)    => fbist_cfg_pool0_engine5_address_start(63 downto 0), -- OVR: fbist_agen(agen)
    fbist_cfg_engine6_address_mode(7 downto 0)      => fbist_cfg_pool0_engine6_address_mode(7 downto 0)  , -- OVR: fbist_agen(agen)
    fbist_cfg_engine6_address_start(63 downto 0)    => fbist_cfg_pool0_engine6_address_start(63 downto 0), -- OVR: fbist_agen(agen)
    fbist_cfg_engine7_address_mode(7 downto 0)      => fbist_cfg_pool0_engine7_address_mode(7 downto 0)  , -- OVR: fbist_agen(agen)
    fbist_cfg_engine7_address_start(63 downto 0)    => fbist_cfg_pool0_engine7_address_start(63 downto 0), -- OVR: fbist_agen(agen)
    fbist_cfg_status_ip                             => fbist_cfg_status_ip                               , -- MSR: fbist_agen(agen)
    fbist_chk_outstanding_tags_valid (127 downto 0) => fbist_chk_outstanding_tags_valid (127 downto 0)   , -- MSR: fbist_agen(agen)
    sys_reset                                       => sys_reset                                           -- MSR: fbist_agen(agen)
);

axi : entity work.fbist_axi
port map (
    axi_chk_response (7 downto 0)          => axi_chk_response (7 downto 0)         , -- MSD: fbist_axi(axi)
    axi_chk_response_data (511 downto 0)   => axi_chk_response_data (511 downto 0)  , -- MSD: fbist_axi(axi)
    axi_chk_response_tag (15 downto 0)     => axi_chk_response_tag (15 downto 0)    , -- MSD: fbist_axi(axi)
    axi_chk_response_dpart (1 downto 0)    => axi_chk_response_dpart (1 downto 0)   , -- MSD: fbist_axi(axi)
    axi_chk_response_ow                    => axi_chk_response_ow                   , -- MSD: fbist_axi(axi)
    axi_chk_response_valid                 => axi_chk_response_valid                , -- MSD: fbist_axi(axi)
    axi_fifo_full_gate                     => axi_fifo_full_gate                    , -- MSD: fbist_axi(axi)
    cclk                                   => cclk                                  , -- MSR: fbist_axi(axi)
    creset                                 => creset                                , -- MSR: fbist_axi(axi)
    cfg_axi_address_inject_enable          => cfg_axi_address_inject_enable         , -- MSR: fbist_axi(axi)
    cfg_axi_data_inject_enable             => cfg_axi_data_inject_enable            , -- MSR: fbist_axi(axi)
    cfg_axi_address_inject_done            => cfg_axi_address_inject_done           , -- MSD: fbist_axi(axi)
    cfg_axi_data_inject_done               => cfg_axi_data_inject_done              , -- MSD: fbist_axi(axi)
    sysclk                                 => sysclk                                , -- MSR: fbist_axi(axi)
    dgen_axi_command (7 downto 0)          => dgen_axi_command (7 downto 0)         , -- MSR: fbist_axi(axi)
    dgen_axi_command_address (63 downto 0) => dgen_axi_command_address (63 downto 0), -- MSR: fbist_axi(axi)
    dgen_axi_command_data (511 downto 0)   => dgen_axi_command_data (511 downto 0)  , -- MSR: fbist_axi(axi)
    dgen_axi_command_engine (2 downto 0)   => dgen_axi_command_engine (2 downto 0)  , -- MSR: fbist_axi(axi)
    dgen_axi_command_tag (15 downto 0)     => dgen_axi_command_tag (15 downto 0)    , -- MSR: fbist_axi(axi)
    dgen_axi_command_valid                 => dgen_axi_command_valid                , -- MSR: fbist_axi(axi)
    fbist_freeze                           => fbist_freeze                          , -- MSR: fbist_axi(axi)
    fbist_oc_axim_aclk                     => fbist_oc_axim_aclk                    , -- MSD: fbist_axi(axi)
    fbist_oc_axim_i                        => fbist_oc_axim_i                       , -- MSR: fbist_axi(axi)
    fbist_oc_axim_o                        => fbist_oc_axim_o                       , -- MSD: fbist_axi(axi)
    sys_reset                              => sys_reset                               -- MSR: fbist_axi(axi)
);

cfg : entity work.fbist_cfg
port map (
    sysclk                                              => sysclk                                             , -- MSR: fbist_cfg(cfg)
    cfg_axi_address_inject_enable                       => cfg_axi_address_inject_enable                      , -- MSD: fbist_axi(axi)
    cfg_axi_data_inject_enable                          => cfg_axi_data_inject_enable                         , -- MSD: fbist_axi(axi)
    cfg_axi_address_inject_done                         => cfg_axi_address_inject_done                        , -- MSR: fbist_axi(axi)
    cfg_axi_data_inject_done                            => cfg_axi_data_inject_done                           , -- MSR: fbist_axi(axi)
    fbist_axis_aclk                                     => fbist_axis_aclk                                    , -- MSR: fbist_cfg(cfg)
    fbist_axis_i                                        => fbist_axis_i_stage                                 , -- MSR: fbist_cfg(cfg)
    fbist_axis_o                                        => fbist_axis_o_stage                                 , -- MSD: fbist_cfg(cfg)
    fbist_cfg_chk_error_valid                           => fbist_cfg_chk_error_valid                          , -- MSR: fbist_cfg(cfg)
    fbist_cfg_chk_error_response_hang                   => fbist_cfg_chk_error_response_hang                  , -- MSR: fbist_cfg(cfg)
    fbist_cfg_pool0_address_and_mask (63 downto 0)      => fbist_cfg_pool0_address_and_mask (63 downto 0)     , -- MSD: fbist_cfg(cfg)
    fbist_cfg_pool0_address_or_mask (63 downto 0)       => fbist_cfg_pool0_address_or_mask (63 downto 0)      , -- MSD: fbist_cfg(cfg)
    fbist_cfg_pool0_addrmod0_data_mode (3 downto 0)     => fbist_cfg_pool0_addrmod0_data_mode (3 downto 0)    , -- MSR: fbist_cfg(cfg)
    fbist_cfg_pool0_addrmod1_data_mode (3 downto 0)     => fbist_cfg_pool0_addrmod1_data_mode (3 downto 0)    , -- MSR: fbist_cfg(cfg)
    fbist_cfg_pool0_addrmod2_data_mode (3 downto 0)     => fbist_cfg_pool0_addrmod2_data_mode (3 downto 0)    , -- MSR: fbist_cfg(cfg)
    fbist_cfg_pool0_addrmod3_data_mode (3 downto 0)     => fbist_cfg_pool0_addrmod3_data_mode (3 downto 0)    , -- MSR: fbist_cfg(cfg)
    fbist_cfg_pool0_addrmod4_data_mode (3 downto 0)     => fbist_cfg_pool0_addrmod4_data_mode (3 downto 0)    , -- MSR: fbist_cfg(cfg)
    fbist_cfg_pool0_addrmod5_data_mode (3 downto 0)     => fbist_cfg_pool0_addrmod5_data_mode (3 downto 0)    , -- MSR: fbist_cfg(cfg)
    fbist_cfg_pool0_addrmod6_data_mode (3 downto 0)     => fbist_cfg_pool0_addrmod6_data_mode (3 downto 0)    , -- MSR: fbist_cfg(cfg)
    fbist_cfg_pool0_addrmod7_data_mode (3 downto 0)     => fbist_cfg_pool0_addrmod7_data_mode (3 downto 0)    , -- MSR: fbist_cfg(cfg)
    fbist_cfg_pool0_arb_scheme (3 downto 0)             => fbist_cfg_pool0_arb_scheme (3 downto 0)            , -- MSD: fbist_cfg(cfg)
    fbist_cfg_pool0_engine0_address_mode (7 downto 0)   => fbist_cfg_pool0_engine0_address_mode (7 downto 0)  , -- MSD: fbist_cfg(cfg)
    fbist_cfg_pool0_engine0_address_start (63 downto 0) => fbist_cfg_pool0_engine0_address_start (63 downto 0), -- MSD: fbist_cfg(cfg)
    fbist_cfg_pool0_engine0_command (7 downto 0)        => fbist_cfg_pool0_engine0_command (7 downto 0)       , -- MSD: fbist_cfg(cfg)
    fbist_cfg_pool0_engine1_address_mode (7 downto 0)   => fbist_cfg_pool0_engine1_address_mode (7 downto 0)  , -- MSD: fbist_cfg(cfg)
    fbist_cfg_pool0_engine1_address_start (63 downto 0) => fbist_cfg_pool0_engine1_address_start (63 downto 0), -- MSD: fbist_cfg(cfg)
    fbist_cfg_pool0_engine1_command (7 downto 0)        => fbist_cfg_pool0_engine1_command (7 downto 0)       , -- MSD: fbist_cfg(cfg)
    fbist_cfg_pool0_engine2_address_mode (7 downto 0)   => fbist_cfg_pool0_engine2_address_mode (7 downto 0)  , -- MSD: fbist_cfg(cfg)
    fbist_cfg_pool0_engine2_address_start (63 downto 0) => fbist_cfg_pool0_engine2_address_start (63 downto 0), -- MSD: fbist_cfg(cfg)
    fbist_cfg_pool0_engine2_command (7 downto 0)        => fbist_cfg_pool0_engine2_command (7 downto 0)       , -- MSD: fbist_cfg(cfg)
    fbist_cfg_pool0_engine3_address_mode (7 downto 0)   => fbist_cfg_pool0_engine3_address_mode (7 downto 0)  , -- MSD: fbist_cfg(cfg)
    fbist_cfg_pool0_engine3_address_start (63 downto 0) => fbist_cfg_pool0_engine3_address_start (63 downto 0), -- MSD: fbist_cfg(cfg)
    fbist_cfg_pool0_engine3_command (7 downto 0)        => fbist_cfg_pool0_engine3_command (7 downto 0)       , -- MSD: fbist_cfg(cfg)
    fbist_cfg_pool0_engine4_address_mode (7 downto 0)   => fbist_cfg_pool0_engine4_address_mode (7 downto 0)  , -- MSD: fbist_cfg(cfg)
    fbist_cfg_pool0_engine4_address_start (63 downto 0) => fbist_cfg_pool0_engine4_address_start (63 downto 0), -- MSD: fbist_cfg(cfg)
    fbist_cfg_pool0_engine4_command (7 downto 0)        => fbist_cfg_pool0_engine4_command (7 downto 0)       , -- MSD: fbist_cfg(cfg)
    fbist_cfg_pool0_engine5_address_mode (7 downto 0)   => fbist_cfg_pool0_engine5_address_mode (7 downto 0)  , -- MSD: fbist_cfg(cfg)
    fbist_cfg_pool0_engine5_address_start (63 downto 0) => fbist_cfg_pool0_engine5_address_start (63 downto 0), -- MSD: fbist_cfg(cfg)
    fbist_cfg_pool0_engine5_command (7 downto 0)        => fbist_cfg_pool0_engine5_command (7 downto 0)       , -- MSD: fbist_cfg(cfg)
    fbist_cfg_pool0_engine6_address_mode (7 downto 0)   => fbist_cfg_pool0_engine6_address_mode (7 downto 0)  , -- MSD: fbist_cfg(cfg)
    fbist_cfg_pool0_engine6_address_start (63 downto 0) => fbist_cfg_pool0_engine6_address_start (63 downto 0), -- MSD: fbist_cfg(cfg)
    fbist_cfg_pool0_engine6_command (7 downto 0)        => fbist_cfg_pool0_engine6_command (7 downto 0)       , -- MSD: fbist_cfg(cfg)
    fbist_cfg_pool0_engine7_address_mode (7 downto 0)   => fbist_cfg_pool0_engine7_address_mode (7 downto 0)  , -- MSD: fbist_cfg(cfg)
    fbist_cfg_pool0_engine7_address_start (63 downto 0) => fbist_cfg_pool0_engine7_address_start (63 downto 0), -- MSD: fbist_cfg(cfg)
    fbist_cfg_pool0_engine7_command (7 downto 0)        => fbist_cfg_pool0_engine7_command (7 downto 0)       , -- MSD: fbist_cfg(cfg)
    fbist_cfg_pool0_spacing_count (15 downto 0)         => fbist_cfg_pool0_spacing_count (15 downto 0)        , -- MSD: fbist_cfg(cfg)
    fbist_cfg_pool0_spacing_scheme (3 downto 0)         => fbist_cfg_pool0_spacing_scheme (3 downto 0)        , -- MSD: fbist_cfg(cfg)
    fbist_cfg_pool0_stats_num_read_bytes (47 downto 0)  => fbist_cfg_pool0_stats_num_read_bytes (47 downto 0) , -- MSR: fbist_cfg(cfg)
    fbist_cfg_pool0_stats_num_reads (47 downto 0)       => fbist_cfg_pool0_stats_num_reads (47 downto 0)      , -- MSR: fbist_cfg(cfg)
    fbist_cfg_pool0_stats_num_write_bytes (47 downto 0) => fbist_cfg_pool0_stats_num_write_bytes (47 downto 0), -- MSR: fbist_cfg(cfg)
    fbist_cfg_pool0_stats_num_writes (47 downto 0)      => fbist_cfg_pool0_stats_num_writes (47 downto 0)     , -- MSR: fbist_cfg(cfg)
    fbist_cfg_pool0_stats_run_time (47 downto 0)        => fbist_cfg_pool0_stats_run_time (47 downto 0)       , -- MSR: fbist_cfg(cfg)
    fbist_cfg_user_data_0 (63 downto 0)                 => fbist_cfg_user_data_0 (63 downto 0)                , -- MSR: fbist_cfg(cfg)
    fbist_cfg_user_data_1 (63 downto 0)                 => fbist_cfg_user_data_1 (63 downto 0)                , -- MSR: fbist_cfg(cfg)
    fbist_cfg_status_ip                                 => fbist_cfg_status_ip                                , -- MSD: fbist_cfg(cfg)
    chk_cfg_engine0_total_latency (63 downto 0)         => chk_cfg_engine0_total_latency (63 downto 0)        , -- MSR: fbist_chk(chk)
    chk_cfg_engine1_total_latency (63 downto 0)         => chk_cfg_engine1_total_latency (63 downto 0)        , -- MSR: fbist_chk(chk)
    chk_cfg_engine2_total_latency (63 downto 0)         => chk_cfg_engine2_total_latency (63 downto 0)        , -- MSR: fbist_chk(chk)
    chk_cfg_engine3_total_latency (63 downto 0)         => chk_cfg_engine3_total_latency (63 downto 0)        , -- MSR: fbist_chk(chk)
    chk_cfg_engine4_total_latency (63 downto 0)         => chk_cfg_engine4_total_latency (63 downto 0)        , -- MSR: fbist_chk(chk)
    chk_cfg_engine5_total_latency (63 downto 0)         => chk_cfg_engine5_total_latency (63 downto 0)        , -- MSR: fbist_chk(chk)
    chk_cfg_engine6_total_latency (63 downto 0)         => chk_cfg_engine6_total_latency (63 downto 0)        , -- MSR: fbist_chk(chk)
    chk_cfg_engine7_total_latency (63 downto 0)         => chk_cfg_engine7_total_latency (63 downto 0)        , -- MSR: fbist_chk(chk)
    sys_reset                                           => sys_reset                                          , -- MSR: fbist_cfg(cfg)
    exp_rd_valid                                        => exp_rd_valid,
    exp_rd_address                                      => exp_rd_address,
    exp_rd_data                                         => exp_rd_data,
    exp_rd_data_valid                                   => exp_rd_data_valid,
    exp_wr_valid                                        => exp_wr_valid,
    exp_wr_address                                      => exp_wr_address
);

cgen : entity work.fbist_cgen
port map (
    fbist_freeze                                 => fbist_freeze                                       , -- MSR: fbist_cgen(cgen)
    cgen_agen_command (7 downto 0)               => cgen_agen_command (7 downto 0)                     , -- MSD: fbist_cgen(cgen)
    cgen_agen_command_engine (2 downto 0)        => cgen_agen_command_engine (2 downto 0)              , -- MSD: fbist_cgen(cgen)
    cgen_agen_command_valid                      => cgen_agen_command_valid                            , -- MSD: fbist_cgen(cgen)
    sysclk                                       => sysclk                                             , -- MSR: fbist_cgen(cgen)
    fbist_cfg_arb_scheme(3 downto 0)             => fbist_cfg_pool0_arb_scheme(3 downto 0)             , -- OVR: fbist_cgen(cgen)
    fbist_cfg_engine0_command(7 downto 0)        => fbist_cfg_pool0_engine0_command(7 downto 0)        , -- OVR: fbist_cgen(cgen)
    fbist_cfg_engine1_command(7 downto 0)        => fbist_cfg_pool0_engine1_command(7 downto 0)        , -- OVR: fbist_cgen(cgen)
    fbist_cfg_engine2_command(7 downto 0)        => fbist_cfg_pool0_engine2_command(7 downto 0)        , -- OVR: fbist_cgen(cgen)
    fbist_cfg_engine3_command(7 downto 0)        => fbist_cfg_pool0_engine3_command(7 downto 0)        , -- OVR: fbist_cgen(cgen)
    fbist_cfg_engine4_command(7 downto 0)        => fbist_cfg_pool0_engine4_command(7 downto 0)        , -- OVR: fbist_cgen(cgen)
    fbist_cfg_engine5_command(7 downto 0)        => fbist_cfg_pool0_engine5_command(7 downto 0)        , -- OVR: fbist_cgen(cgen)
    fbist_cfg_engine6_command(7 downto 0)        => fbist_cfg_pool0_engine6_command(7 downto 0)        , -- OVR: fbist_cgen(cgen)
    fbist_cfg_engine7_command(7 downto 0)        => fbist_cfg_pool0_engine7_command(7 downto 0)        , -- OVR: fbist_cgen(cgen)
    fbist_cfg_spacing_count(15 downto 0)         => fbist_cfg_pool0_spacing_count(15 downto 0)         , -- OVR: fbist_cgen(cgen)
    fbist_cfg_spacing_scheme(3 downto 0)         => fbist_cfg_pool0_spacing_scheme(3 downto 0)         , -- OVR: fbist_cgen(cgen)
    fbist_cfg_stats_num_read_bytes(47 downto 0)  => fbist_cfg_pool0_stats_num_read_bytes (47 downto 0) , -- OVD: fbist_cgen(cgen)
    fbist_cfg_stats_num_reads(47 downto 0)       => fbist_cfg_pool0_stats_num_reads (47 downto 0)      , -- OVD: fbist_cgen(cgen)
    fbist_cfg_stats_num_write_bytes(47 downto 0) => fbist_cfg_pool0_stats_num_write_bytes (47 downto 0), -- OVD: fbist_cgen(cgen)
    fbist_cfg_stats_num_writes(47 downto 0)      => fbist_cfg_pool0_stats_num_writes (47 downto 0)     , -- OVD: fbist_cgen(cgen)
    fbist_cfg_stats_run_time(47 downto 0)        => fbist_cfg_pool0_stats_run_time (47 downto 0)       , -- OVD: fbist_cgen(cgen)
    fbist_cfg_status_ip                          => fbist_cfg_status_ip                                , -- MSR: fbist_cgen(cgen)
    sys_reset                                    => sys_reset                                            -- MSR: fbist_cgen(cgen)
);

chk : entity work.fbist_chk
port map (
    agen_chk_command (7 downto 0)                   => agen_chk_command (7 downto 0)                  , -- MSR: fbist_chk(chk)
    agen_chk_command_address (63 downto 0)          => agen_chk_command_address (63 downto 0)         , -- MSR: fbist_chk(chk)
    agen_chk_command_engine (2 downto 0)            => agen_chk_command_engine (2 downto 0)           , -- MSR: fbist_chk(chk)
    agen_chk_command_tag (15 downto 0)              => agen_chk_command_tag (15 downto 0)             , -- MSR: fbist_chk(chk)
    agen_chk_command_valid                          => agen_chk_command_valid                         , -- MSR: fbist_chk(chk)
    axi_chk_response (7 downto 0)                   => axi_chk_response (7 downto 0)                  , -- MSR: fbist_chk(chk)
    axi_chk_response_data (511 downto 0)            => axi_chk_response_data (511 downto 0)           , -- MSR: fbist_chk(chk)
    axi_chk_response_tag (15 downto 0)              => axi_chk_response_tag (15 downto 0)             , -- MSR: fbist_chk(chk)
    axi_chk_response_dpart (1 downto 0)             => axi_chk_response_dpart (1 downto 0)            , -- MSR: fbist_chk(chk)
    axi_chk_response_ow                             => axi_chk_response_ow                            , -- MSR: fbist_chk(chk)
    axi_chk_response_valid                          => axi_chk_response_valid                         , -- MSR: fbist_chk(chk)
    chk_error_actual_data (511 downto 0)            => chk_error_actual_data (511 downto 0)           , -- MSD: fbist_chk(chk)
    chk_error_actual_response (7 downto 0)          => chk_error_actual_response (7 downto 0)         , -- MSD: fbist_chk(chk)
    chk_error_actual_valid                          => chk_error_actual_valid                         , -- MSD: fbist_chk(chk)
    chk_error_expected_command (7 downto 0)         => chk_error_expected_command (7 downto 0)        , -- MSD: fbist_chk(chk)
    chk_error_expected_data (511 downto 0)          => chk_error_expected_data (511 downto 0)         , -- MSD: fbist_chk(chk)
    chk_error_expected_valid                        => chk_error_expected_valid                       , -- MSD: fbist_chk(chk)
    chk_error_valid                                 => chk_error_valid                                , -- MSD: fbist_chk(chk)
    chk_error_response_hang                         => fbist_cfg_chk_error_response_hang              , -- MSD: fbist_chk(chk)
    cclk                                            => cclk                                           , -- MSR: fbist_chk(chk)
    sysclk                                          => sysclk                                         , -- MSR: fbist_chk(chk)
    fbist_cfg_stats_run_time (47 downto 0)          => fbist_cfg_pool0_stats_run_time (47 downto 0)   , -- MSR: fbist_chk(chk)
    fbist_cfg_addrmod0_data_mode(3 downto 0)        => fbist_cfg_pool0_addrmod0_data_mode(3 downto 0) , -- OVR: fbist_chk(chk)
    fbist_cfg_addrmod1_data_mode(3 downto 0)        => fbist_cfg_pool0_addrmod1_data_mode(3 downto 0) , -- OVR: fbist_chk(chk)
    fbist_cfg_addrmod2_data_mode(3 downto 0)        => fbist_cfg_pool0_addrmod2_data_mode(3 downto 0) , -- OVR: fbist_chk(chk)
    fbist_cfg_addrmod3_data_mode(3 downto 0)        => fbist_cfg_pool0_addrmod3_data_mode(3 downto 0) , -- OVR: fbist_chk(chk)
    fbist_cfg_addrmod4_data_mode(3 downto 0)        => fbist_cfg_pool0_addrmod4_data_mode(3 downto 0) , -- OVR: fbist_chk(chk)
    fbist_cfg_addrmod5_data_mode(3 downto 0)        => fbist_cfg_pool0_addrmod5_data_mode(3 downto 0) , -- OVR: fbist_chk(chk)
    fbist_cfg_addrmod6_data_mode(3 downto 0)        => fbist_cfg_pool0_addrmod6_data_mode(3 downto 0) , -- OVR: fbist_chk(chk)
    fbist_cfg_addrmod7_data_mode(3 downto 0)        => fbist_cfg_pool0_addrmod7_data_mode(3 downto 0) , -- OVR: fbist_chk(chk)
    chk_cfg_engine0_total_latency (63 downto 0)     => chk_cfg_engine0_total_latency (63 downto 0)    , -- MSD: fbist_chk(chk)
    chk_cfg_engine1_total_latency (63 downto 0)     => chk_cfg_engine1_total_latency (63 downto 0)    , -- MSD: fbist_chk(chk)
    chk_cfg_engine2_total_latency (63 downto 0)     => chk_cfg_engine2_total_latency (63 downto 0)    , -- MSD: fbist_chk(chk)
    chk_cfg_engine3_total_latency (63 downto 0)     => chk_cfg_engine3_total_latency (63 downto 0)    , -- MSD: fbist_chk(chk)
    chk_cfg_engine4_total_latency (63 downto 0)     => chk_cfg_engine4_total_latency (63 downto 0)    , -- MSD: fbist_chk(chk)
    chk_cfg_engine5_total_latency (63 downto 0)     => chk_cfg_engine5_total_latency (63 downto 0)    , -- MSD: fbist_chk(chk)
    chk_cfg_engine6_total_latency (63 downto 0)     => chk_cfg_engine6_total_latency (63 downto 0)    , -- MSD: fbist_chk(chk)
    chk_cfg_engine7_total_latency (63 downto 0)     => chk_cfg_engine7_total_latency (63 downto 0)    , -- MSD: fbist_chk(chk)
    fbist_cfg_user_data_0 (63 downto 0)             => fbist_cfg_user_data_0 (63 downto 0)            , -- MSR: fbist_chk(chk)
    fbist_cfg_user_data_1 (63 downto 0)             => fbist_cfg_user_data_1 (63 downto 0)            , -- MSR: fbist_chk(chk)
    fbist_chk_outstanding_tags_valid (127 downto 0) => fbist_chk_outstanding_tags_valid (127 downto 0), -- MSD: fbist_chk(chk)
    sys_reset                                       => sys_reset                                      , -- MSR: fbist_chk(chk)
    creset                                          => creset                                         , -- MSR: fbist_chk(chk)
    fbist_cfg_status_ip                             => fbist_cfg_status_ip                            ,
    chk_fesbuff_we                                  => chk_fesbuff_we                                 ,
    chk_fesbuff_data                                => chk_fesbuff_data
);

dgen : entity work.fbist_dgen
port map (
    agen_dgen_command (7 downto 0)           => agen_dgen_command (7 downto 0)                , -- MSR: fbist_dgen(dgen)
    agen_dgen_command_address (63 downto 0)  => agen_dgen_command_address (63 downto 0)       , -- MSR: fbist_dgen(dgen)
    agen_dgen_command_engine (2 downto 0)    => agen_dgen_command_engine (2 downto 0)         , -- MSR: fbist_dgen(dgen)
    agen_dgen_command_tag (15 downto 0)      => agen_dgen_command_tag (15 downto 0)           , -- MSR: fbist_dgen(dgen)
    agen_dgen_command_valid                  => agen_dgen_command_valid                       , -- MSR: fbist_dgen(dgen)
    fbist_freeze                             => fbist_freeze                                  , -- MSR: fbist_dgen(dgen)
    sysclk                                   => sysclk                                        , -- MSR: fbist_dgen(dgen)
    dgen_axi_command (7 downto 0)            => dgen_axi_command (7 downto 0)                 , -- MSD: fbist_dgen(dgen)
    dgen_axi_command_address (63 downto 0)   => dgen_axi_command_address (63 downto 0)        , -- MSD: fbist_dgen(dgen)
    dgen_axi_command_data (511 downto 0)     => dgen_axi_command_data (511 downto 0)          , -- MSD: fbist_dgen(dgen)
    dgen_axi_command_engine (2 downto 0)     => dgen_axi_command_engine (2 downto 0)          , -- MSD: fbist_dgen(dgen)
    dgen_axi_command_tag (15 downto 0)       => dgen_axi_command_tag (15 downto 0)            , -- MSD: fbist_dgen(dgen)
    dgen_axi_command_valid                   => dgen_axi_command_valid                        , -- MSD: fbist_dgen(dgen)
    fbist_cfg_addrmod0_data_mode(3 downto 0) => fbist_cfg_pool0_addrmod0_data_mode(3 downto 0), -- OVR: fbist_dgen(dgen)
    fbist_cfg_addrmod1_data_mode(3 downto 0) => fbist_cfg_pool0_addrmod1_data_mode(3 downto 0), -- OVR: fbist_dgen(dgen)
    fbist_cfg_addrmod2_data_mode(3 downto 0) => fbist_cfg_pool0_addrmod2_data_mode(3 downto 0), -- OVR: fbist_dgen(dgen)
    fbist_cfg_addrmod3_data_mode(3 downto 0) => fbist_cfg_pool0_addrmod3_data_mode(3 downto 0), -- OVR: fbist_dgen(dgen)
    fbist_cfg_addrmod4_data_mode(3 downto 0) => fbist_cfg_pool0_addrmod4_data_mode(3 downto 0), -- OVR: fbist_dgen(dgen)
    fbist_cfg_addrmod5_data_mode(3 downto 0) => fbist_cfg_pool0_addrmod5_data_mode(3 downto 0), -- OVR: fbist_dgen(dgen)
    fbist_cfg_addrmod6_data_mode(3 downto 0) => fbist_cfg_pool0_addrmod6_data_mode(3 downto 0), -- OVR: fbist_dgen(dgen)
    fbist_cfg_addrmod7_data_mode(3 downto 0) => fbist_cfg_pool0_addrmod7_data_mode(3 downto 0), -- OVR: fbist_dgen(dgen)
    fbist_cfg_user_data_0 (63 downto 0)      => fbist_cfg_user_data_0 (63 downto 0)           , -- MSR: fbist_dgen(dgen)
    fbist_cfg_user_data_1 (63 downto 0)      => fbist_cfg_user_data_1 (63 downto 0)           , -- MSR: fbist_dgen(dgen)
    sys_reset                                => sys_reset                                       -- MSR: fbist_dgen(dgen)
);

fesbuff : entity work.fbist_fes_buffer
    PORT MAP (
      CCLK                              =>  cclk,                -- in  std_ulogic;
      SYSCLK                            =>  sysclk,                -- in  std_ulogic;
      CRESET                            =>  creset,
      SYS_RESET                         =>  sys_reset,                -- in  std_ulogic;
      FBIST_CFG_STATUS_IP               =>  fbist_cfg_status_ip,
   -- expansion interface to axi_regs_32_large reads
      EXP_RD_VALID                      =>  exp_rd_valid,         -- in  std_ulogic;
      EXP_RD_ADDRESS                    =>  exp_rd_address,       -- in  std_ulogic_vector(31 downto 0);
      EXP_RD_DATA                       =>  exp_rd_data,          -- out std_ulogic_vector(31 downto 0);
      EXP_RD_DATA_VALID                 =>  exp_rd_data_valid,    -- out std_ulogic;
    -- expansion interface to axi_regs_32_large writes (only used for pointer reset)
      EXP_WR_VALID                      =>  exp_wr_valid,         -- in std_ulogic
      EXP_WR_ADDRESS                    =>  exp_wr_address,       -- in std_ulogic_vector(31 downto 0)
    -- error collection interface
      WRITE                             => chk_fesbuff_we,        -- write strobe
      DATA_IN                           => chk_fesbuff_data       -- in std_ulogic_vector(512 downto 0)
   );

fbist_axi_stage : entity work.axi_sync
  port map (
    s0_axi_aclk => fbist_axis_aclk,
    s0_axi_i_a  => fbist_axis_i,
    s0_axi_i_b  => fbist_axis_i_stage,
    s0_axi_o_a  => fbist_axis_o,
    s0_axi_o_b  => fbist_axis_o_stage
    );

end fbist_mac;
