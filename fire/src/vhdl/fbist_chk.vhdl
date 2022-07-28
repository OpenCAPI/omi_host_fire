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

library ieee,ibm,support,work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ibm.synthesis_support.all;
use support.logic_support_pkg.all;
use ibm.std_ulogic_support.all;
use ibm.std_ulogic_function_support.all;
use ibm.std_ulogic_unsigned.all;
use work.fbist_pkg.all;

entity fbist_chk is
  port (
    sysclk    : in std_ulogic;
    sys_reset : in std_ulogic;
    cclk      : in std_ulogic;
    creset    : in std_ulogic;

    fbist_cfg_status_ip : in std_ulogic;

    agen_chk_command           : in std_ulogic_vector(7 downto 0);
    agen_chk_command_valid     : in std_ulogic;
    agen_chk_command_engine    : in std_ulogic_vector(2 downto 0);
    agen_chk_command_tag       : in std_ulogic_vector(15 downto 0);
    agen_chk_command_address   : in std_ulogic_vector(63 downto 0);

    axi_chk_response           : in std_ulogic_vector(7 downto 0);          -- 0 to 4 is nop wr_ok wr_fail rd_ok rd_fail
    axi_chk_response_valid     : in std_ulogic;
    axi_chk_response_tag       : in std_ulogic_vector(15 downto 0);
    axi_chk_response_dpart     : in std_ulogic_vector(1 downto 0);
    axi_chk_response_ow        : in std_ulogic;
    axi_chk_response_data      : in std_ulogic_vector(511 downto 0);

    chk_error_valid            : out std_ulogic;
    chk_error_expected_command : out std_ulogic_vector(7 downto 0);
    chk_error_actual_response  : out std_ulogic_vector(7 downto 0);
    chk_error_expected_valid   : out std_ulogic;
    chk_error_actual_valid     : out std_ulogic;
    chk_error_expected_data    : out std_ulogic_vector(511 downto 0);
    chk_error_actual_data      : out std_ulogic_vector(511 downto 0);
    chk_error_response_hang    : out std_ulogic;

    fbist_chk_outstanding_tags_valid : out std_ulogic_vector(127 downto 0);

    chk_cfg_engine0_total_latency : out std_ulogic_vector(63 downto 0);
    chk_cfg_engine1_total_latency : out std_ulogic_vector(63 downto 0);
    chk_cfg_engine2_total_latency : out std_ulogic_vector(63 downto 0);
    chk_cfg_engine3_total_latency : out std_ulogic_vector(63 downto 0);
    chk_cfg_engine4_total_latency : out std_ulogic_vector(63 downto 0);
    chk_cfg_engine5_total_latency : out std_ulogic_vector(63 downto 0);
    chk_cfg_engine6_total_latency : out std_ulogic_vector(63 downto 0);
    chk_cfg_engine7_total_latency : out std_ulogic_vector(63 downto 0);

    fbist_cfg_stats_run_time     : in std_ulogic_vector(47 downto 0);
    fbist_cfg_addrmod0_data_mode : in std_ulogic_vector(3 downto 0);
    fbist_cfg_addrmod1_data_mode : in std_ulogic_vector(3 downto 0);
    fbist_cfg_addrmod2_data_mode : in std_ulogic_vector(3 downto 0);
    fbist_cfg_addrmod3_data_mode : in std_ulogic_vector(3 downto 0);
    fbist_cfg_addrmod4_data_mode : in std_ulogic_vector(3 downto 0);
    fbist_cfg_addrmod5_data_mode : in std_ulogic_vector(3 downto 0);
    fbist_cfg_addrmod6_data_mode : in std_ulogic_vector(3 downto 0);
    fbist_cfg_addrmod7_data_mode : in std_ulogic_vector(3 downto 0);
    fbist_cfg_user_data_0        : in std_ulogic_vector(63 downto 0);
    fbist_cfg_user_data_1        : in std_ulogic_vector(63 downto 0);
-- outputs to fes_buffer
    chk_fesbuff_we               : out std_ulogic;
    chk_fesbuff_data             : out std_ulogic_vector(543 downto 0)
    );

  attribute BLOCK_TYPE of fbist_chk : entity is SUPERRLM;
  attribute BTR_NAME of fbist_chk : entity is "FBIST_CHK";
  attribute RECURSIVE_SYNTHESIS of fbist_chk : entity is 2;
  attribute PIN_DATA of sysclk : signal is "PIN_FUNCTION=/G_CLK/";
  attribute PIN_DEFAULT_GROUND_DOMAIN of fbist_chk : entity is "GND";
  attribute PIN_DEFAULT_POWER_DOMAIN of fbist_chk : entity is "VDD";
end fbist_chk;

architecture fbist_chk of fbist_chk is
  SIGNAL lut_fetch_addr : std_ulogic_vector(7 downto 0);
  SIGNAL lut_fetch_data : std_ulogic_vector(127 downto 0);
  SIGNAL lut_fetch_valid : std_ulogic;
  SIGNAL lut_store_addr : std_ulogic_vector(7 downto 0);
  SIGNAL lut_store_data : std_ulogic_vector(127 downto 0);
  SIGNAL lut_store_valid : std_ulogic;
  SIGNAL lut_store_valid_v : std_ulogic_vector(3 downto 0);
  SIGNAL lut_store_unused : std_ulogic_vector(127 downto 0);
  SIGNAL lut_command : std_ulogic_vector(7 downto 0);
  SIGNAL lut_valid : std_ulogic;
  SIGNAL lut_engine : std_ulogic_vector(2 downto 0);
  SIGNAL lut_tag : std_ulogic_vector(15 downto 0);
  SIGNAL lut_address : std_ulogic_vector(63 downto 0);
  SIGNAL expected_command : std_ulogic_vector(7 downto 0);
  SIGNAL expected_command_d : std_ulogic_vector(7 downto 0);
  SIGNAL expected_command_q : std_ulogic_vector(7 downto 0);
  SIGNAL expected_address : std_ulogic_vector(63 downto 0);
  SIGNAL expected_data : std_ulogic_vector(511 downto 0);
  SIGNAL expected_data_d : std_ulogic_vector(511 downto 0);
  SIGNAL expected_data_q : std_ulogic_vector(511 downto 0);
  SIGNAL expected_engine,expected_engine_q : std_ulogic_vector(2 downto 0);
  SIGNAL expected_tag : std_ulogic_vector(15 downto 0);
  SIGNAL expected_valid : std_ulogic;
  SIGNAL expected_valid_d : std_ulogic;
  SIGNAL expected_valid_q : std_ulogic;
  SIGNAL response_stg1_d : std_ulogic_vector(7 downto 0);
  SIGNAL response_stg1_q : std_ulogic_vector(7 downto 0);
  SIGNAL response_valid_stg1_d : std_ulogic;
  SIGNAL response_valid_stg1_q : std_ulogic;
  SIGNAL response_tag_stg1_d : std_ulogic_vector(15 downto 0);
  SIGNAL response_tag_stg1_q : std_ulogic_vector(15 downto 0);
  SIGNAL response_dpart_stg1_d : std_ulogic_vector(1 downto 0);
  SIGNAL response_dpart_stg1_q : std_ulogic_vector(1 downto 0);
  SIGNAL response_ow_stg1_d : std_ulogic;
  SIGNAL response_ow_stg1_q : std_ulogic;
  SIGNAL response_data_stg1_d : std_ulogic_vector(511 downto 0);
  SIGNAL response_data_stg1_q : std_ulogic_vector(511 downto 0);
  SIGNAL response_stg2_d : std_ulogic_vector(7 downto 0);
  SIGNAL response_stg2_q : std_ulogic_vector(7 downto 0);
  SIGNAL response_valid_stg2_d : std_ulogic;
  SIGNAL response_valid_stg2_q : std_ulogic;
  SIGNAL response_tag_stg2_d : std_ulogic_vector(15 downto 0);
  SIGNAL response_tag_stg2_q : std_ulogic_vector(15 downto 0);
  SIGNAL response_dpart_stg2_d : std_ulogic_vector(1 downto 0);
  SIGNAL response_dpart_stg2_q : std_ulogic_vector(1 downto 0);
  SIGNAL response_ow_stg2_d : std_ulogic;
  SIGNAL response_ow_stg2_q : std_ulogic;
  SIGNAL response_data_stg2_d : std_ulogic_vector(511 downto 0);
  SIGNAL response_data_stg2_q : std_ulogic_vector(511 downto 0);
  SIGNAL response_stg3_d : std_ulogic_vector(7 downto 0);
  SIGNAL response_stg3_q : std_ulogic_vector(7 downto 0);
  SIGNAL response_valid_stg3_d : std_ulogic;
  SIGNAL response_valid_stg3_q : std_ulogic;
  SIGNAL response_tag_stg3_d : std_ulogic_vector(15 downto 0);
  SIGNAL response_tag_stg3_q : std_ulogic_vector(15 downto 0);
  SIGNAL response_dpart_stg3_d : std_ulogic_vector(1 downto 0);
  SIGNAL response_dpart_stg3_q : std_ulogic_vector(1 downto 0);
  SIGNAL response_ow_stg3_d : std_ulogic;
  SIGNAL response_ow_stg3_q : std_ulogic;
  SIGNAL response_data_stg3_d : std_ulogic_vector(511 downto 0);
  SIGNAL response_data_stg3_q : std_ulogic_vector(511 downto 0);
  SIGNAL actual_response : std_ulogic_vector(7 downto 0);
  SIGNAL actual_response_d : std_ulogic_vector(7 downto 0);
  SIGNAL actual_response_q : std_ulogic_vector(7 downto 0);
  SIGNAL actual_valid : std_ulogic;
  SIGNAL actual_valid_d : std_ulogic;
  SIGNAL actual_valid_q : std_ulogic;
  SIGNAL actual_tag : std_ulogic_vector(15 downto 0);
  SIGNAL actual_dpart : std_ulogic_vector(1 downto 0);
  SIGNAL actual_ow : std_ulogic;
  SIGNAL actual_data : std_ulogic_vector(511 downto 0);
  SIGNAL actual_data_d : std_ulogic_vector(511 downto 0);
  SIGNAL actual_data_q : std_ulogic_vector(511 downto 0);
  SIGNAL mismatch_data_d : std_ulogic_vector(31 downto 0);
  SIGNAL mismatch_data_q : std_ulogic_vector(31 downto 0);
  SIGNAL mismatch_data_masked : std_ulogic_vector(31 downto 0);
  SIGNAL data_mask : std_ulogic_vector(31 downto 0);
  SIGNAL wrong_response : std_ulogic;
  SIGNAL outstanding_tags_valid : std_ulogic_vector(127 downto 0);
  SIGNAL chk_fesbuff_we_d,chk_error_valid_int   : std_ulogic;
  SIGNAL chk_fesbuff_data_d                     : std_ulogic_vector(543 downto 0);
  SIGNAL wrong_data  : std_ulogic;
  SIGNAL lut_store_time : std_ulogic_vector(47 downto 0);
  SIGNAL command_diff_d : std_ulogic_vector(47 downto 0);
  SIGNAL command_diff_q : std_ulogic_vector(47 downto 0);
  SIGNAL engine_0_total_latency_d : std_ulogic_vector(63 downto 0);
  SIGNAL engine_1_total_latency_d : std_ulogic_vector(63 downto 0);
  SIGNAL engine_2_total_latency_d : std_ulogic_vector(63 downto 0);
  SIGNAL engine_3_total_latency_d : std_ulogic_vector(63 downto 0);
  SIGNAL engine_4_total_latency_d : std_ulogic_vector(63 downto 0);
  SIGNAL engine_5_total_latency_d : std_ulogic_vector(63 downto 0);
  SIGNAL engine_6_total_latency_d : std_ulogic_vector(63 downto 0);
  SIGNAL engine_7_total_latency_d : std_ulogic_vector(63 downto 0);
  SIGNAL engine_0_total_latency_q : std_ulogic_vector(63 downto 0);
  SIGNAL engine_1_total_latency_q : std_ulogic_vector(63 downto 0);
  SIGNAL engine_2_total_latency_q : std_ulogic_vector(63 downto 0);
  SIGNAL engine_3_total_latency_q : std_ulogic_vector(63 downto 0);
  SIGNAL engine_4_total_latency_q : std_ulogic_vector(63 downto 0);
  SIGNAL engine_5_total_latency_q : std_ulogic_vector(63 downto 0);
  SIGNAL engine_6_total_latency_q : std_ulogic_vector(63 downto 0);
  SIGNAL engine_7_total_latency_q : std_ulogic_vector(63 downto 0);
  SIGNAL chk_error_response_hang_int : std_ulogic;
  SIGNAL cycles_since_last_response_d : std_ulogic_vector(31 downto 0);
  SIGNAL cycles_since_last_response_q : std_ulogic_vector(31 downto 0);
  SIGNAL lut_engine_d : std_ulogic_vector(2 downto 0);
  SIGNAL lut_engine_q : std_ulogic_vector(2 downto 0);
  SIGNAL lut_valid_d : std_ulogic;
  SIGNAL lut_valid_q : std_ulogic;

  --debug latches--
  signal chk_error_valid_d   : std_ulogic;
  signal chk_error_valid_1_d : std_ulogic;
  signal chk_error_valid_2_d : std_ulogic;
  signal chk_error_valid_q   : std_ulogic;
  signal chk_error_valid_1_q : std_ulogic;
  signal chk_error_valid_2_q : std_ulogic;

  signal wrong_data_d   : std_ulogic;
  signal wrong_data_1_d : std_ulogic;
  signal wrong_data_2_d : std_ulogic;
  signal wrong_data_q   : std_ulogic;
  signal wrong_data_1_q : std_ulogic;
  signal wrong_data_2_q : std_ulogic;

  signal wrong_response_d   : std_ulogic;
  signal wrong_response_1_d : std_ulogic;
  signal wrong_response_2_d : std_ulogic;
  signal wrong_response_q   : std_ulogic;
  signal wrong_response_1_q : std_ulogic;
  signal wrong_response_2_q : std_ulogic;

  signal offset_valids_d   : std_ulogic;
  signal offset_valids_1_d : std_ulogic;
  signal offset_valids_2_d : std_ulogic;
  signal offset_valids_q   : std_ulogic;
  signal offset_valids_1_q : std_ulogic;
  signal offset_valids_2_q : std_ulogic;

  signal error_count_d : std_ulogic_vector(16 downto 0);
  signal error_count_q : std_ulogic_vector(16 downto 0);
  signal error_count_1_d : std_ulogic_vector(16 downto 0);
  signal error_count_1_q : std_ulogic_vector(16 downto 0);
  signal error_count_2_d : std_ulogic_vector(16 downto 0);
  signal error_count_2_q : std_ulogic_vector(16 downto 0);
  
  

begin

  -- Assemble the information we store into the LUT for later comparison
  -- Needs to be a multiple of 32
  lut_store_data(63 downto 0)    <= agen_chk_command_address;
  lut_store_data(71 downto 64)   <= agen_chk_command;
  lut_store_data(74 downto 72)   <= agen_chk_command_engine;
  lut_store_data(122 downto 75)  <= fbist_cfg_stats_run_time;
  lut_store_data(126 downto 123) <= (others => '0');
  lut_store_data(127)            <= agen_chk_command_valid;

  --------------------------------------------------------------------------------------------------
  -- debug
  --------------------------------------------------------------------------------------------------
  wrong_data_d <= wrong_data;
  wrong_data_1_d <= wrong_data_q;
  wrong_data_2_d <= wrong_data_1_q;

  wrong_response_d <= wrong_response and actual_valid_q;
  wrong_response_1_d <= wrong_response_q;
  wrong_response_2_d <= wrong_response_1_q;

  chk_error_valid_d <= chk_error_valid_int;
  chk_error_valid_1_d <= chk_error_valid_q;
  chk_error_valid_2_d <= chk_error_valid_1_q;

  offset_valids_d <= (actual_valid_q xor expected_valid_q);
  offset_valids_1_d <= offset_valids_q;
  offset_valids_2_d <= offset_valids_1_q;

  error_count_d <= gate(error_count_q + 1,          chk_error_valid_int) OR
                   gate(error_count_q,          not chk_error_valid_int);
  error_count_1_d <= error_count_q;
  error_count_2_d <= error_count_1_q;

  --------------------------------------------------------------------------------------------------
  lut_store_addr <= agen_chk_command_tag(7 downto 0);

  lut_store_valid   <= agen_chk_command_valid and (agen_chk_command /= FBIST_COMMAND_WRITE_128_SECOND_DATA);
  lut_store_valid_v <= lut_store_valid & lut_store_valid & lut_store_valid & lut_store_valid;

lut : entity work.bram_wrap      -- assuming this stores data for checking responses, at an address that is the bottom 8 bits of the tag
generic map (
    C_DATA_WIDTH               => 128,
    C_ADDRESS_WIDTH            => 8
)
port map (
    bram_addr_a (7 downto 0)   => lut_store_addr (7 downto 0)    ,  -- OVR: bram_wrap(lut)
    bram_addr_b (7 downto 0)   => lut_fetch_addr (7 downto 0)    ,  -- OVR: bram_wrap(lut)

    bram_din_a (127 downto 0)  => lut_store_unused (127 downto 0),  -- OVD: bram_wrap(lut) this is an output from bram_wrap - effectively "open"
    bram_din_b (127 downto 0)  => lut_fetch_data (127 downto 0)  ,  -- OVD: bram_wrap(lut) this is an output from bram_wr

    bram_dout_a (127 downto 0) => lut_store_data (127 downto 0)  ,  -- OVR: bram_wrap(lut)
    bram_dout_b (127 downto 0) => (others => '0')                ,  -- OVR: bram_wrap(lut)

    bram_wen_a (3 downto 0)    => lut_store_valid_v              ,  -- OVR: bram_wrap(lut)
    bram_wen_b (3 downto 0)    => "0000"                         ,  -- OVR: bram_wrap(lut)

    clock                      => cclk                           ,  -- MSR: bram_wrap(lut)
    reset                      => sys_reset                         -- MSR: bram_wrap(lut)
);

  -- Hang detection
  cycles_since_last_response_d <= (others => '0') when (axi_chk_response_valid = '1' or fbist_cfg_status_ip = '0') else
                                  (others => '0') when chk_error_response_hang_int = '1'                           else
                                  cycles_since_last_response_q + 1;
  chk_error_response_hang_int  <= cycles_since_last_response_q(31);
  chk_error_response_hang      <= chk_error_response_hang_int;

  -- Keep track of what tags are still outstanding
  -- Now that we have 12 tag bits, we can assume we won't overlap
  outstanding_tags_valid <= (others => '0');

  fbist_chk_outstanding_tags_valid <= outstanding_tags_valid;

  -- Regenerate data for commands in LUT
  lut_fetch_addr  <= axi_chk_response_tag(7 downto 0);
  lut_fetch_valid <= axi_chk_response_valid;

  -- If we're accessing the second half of a 128B operation, increment
  -- the address to generate the correct data.
  lut_address    <= gate(lut_fetch_data(63 downto 0),                       not ((response_ow_stg1_q = '1' and response_dpart_stg1_q = "10") or
                                                                                 (response_ow_stg1_q = '1' and response_dpart_stg1_q = "11") or
                                                                                 (response_ow_stg1_q = '0' and response_dpart_stg1_q = "01"))) or
                    gate(lut_fetch_data(63 downto 0) + x"0000000000000040",     ((response_ow_stg1_q = '1' and response_dpart_stg1_q = "10") or
                                                                                 (response_ow_stg1_q = '1' and response_dpart_stg1_q = "11") or
                                                                                 (response_ow_stg1_q = '0' and response_dpart_stg1_q = "01")));
  lut_command    <= lut_fetch_data(71 downto 64);
  lut_engine     <= lut_fetch_data(74 downto 72);
  lut_store_time <= lut_fetch_data(122 downto 75);
  lut_valid      <= lut_fetch_data(127) and response_valid_stg1_q;

  lut_tag <= x"00" & lut_fetch_addr;

  lut_valid_d  <= lut_valid;
  lut_engine_d <= lut_engine;

  -- Calculate how long the command was in the LUT for latency purposes
  command_diff_d           <= fbist_cfg_stats_run_time - lut_store_time;
  engine_0_total_latency_d <= x"0000000000000000"                       when fbist_cfg_status_ip = '0'                  else
                              engine_0_total_latency_q + command_diff_q when lut_valid_q = '1' and lut_engine_q = "000" else
                              engine_0_total_latency_q;
  engine_1_total_latency_d <= x"0000000000000000"                       when fbist_cfg_status_ip = '0'                  else
                              engine_1_total_latency_q + command_diff_q when lut_valid_q = '1' and lut_engine_q = "001" else
                              engine_1_total_latency_q;
  engine_2_total_latency_d <= x"0000000000000000"                       when fbist_cfg_status_ip = '0'                  else
                              engine_2_total_latency_q + command_diff_q when lut_valid_q = '1' and lut_engine_q = "010" else
                              engine_2_total_latency_q;
  engine_3_total_latency_d <= x"0000000000000000"                       when fbist_cfg_status_ip = '0'                  else
                              engine_3_total_latency_q + command_diff_q when lut_valid_q = '1' and lut_engine_q = "011" else
                              engine_3_total_latency_q;
  engine_4_total_latency_d <= x"0000000000000000"                       when fbist_cfg_status_ip = '0'                  else
                              engine_4_total_latency_q + command_diff_q when lut_valid_q = '1' and lut_engine_q = "100" else
                              engine_4_total_latency_q;
  engine_5_total_latency_d <= x"0000000000000000"                       when fbist_cfg_status_ip = '0'                  else
                              engine_5_total_latency_q + command_diff_q when lut_valid_q = '1' and lut_engine_q = "101" else
                              engine_5_total_latency_q;
  engine_6_total_latency_d <= x"0000000000000000"                       when fbist_cfg_status_ip = '0'                  else
                              engine_6_total_latency_q + command_diff_q when lut_valid_q = '1' and lut_engine_q = "110" else
                              engine_6_total_latency_q;
  engine_7_total_latency_d <= x"0000000000000000"                       when fbist_cfg_status_ip = '0'                  else
                              engine_7_total_latency_q + command_diff_q when lut_valid_q = '1' and lut_engine_q = "111" else
                              engine_7_total_latency_q;

  chk_cfg_engine0_total_latency <= engine_0_total_latency_q;
  chk_cfg_engine1_total_latency <= engine_1_total_latency_q;
  chk_cfg_engine2_total_latency <= engine_2_total_latency_q;
  chk_cfg_engine3_total_latency <= engine_3_total_latency_q;
  chk_cfg_engine4_total_latency <= engine_4_total_latency_q;
  chk_cfg_engine5_total_latency <= engine_5_total_latency_q;
  chk_cfg_engine6_total_latency <= engine_6_total_latency_q;
  chk_cfg_engine7_total_latency <= engine_7_total_latency_q;

dgen : entity work.fbist_dgen
port map (
    agen_dgen_command (7 downto 0)            => lut_command                              , -- OVR: fbist_dgen(dgen)
    agen_dgen_command_address (63 downto 0)   => lut_address                              , -- OVR: fbist_dgen(dgen)
    agen_dgen_command_engine (2 downto 0)     => lut_engine                               , -- OVR: fbist_dgen(dgen)
    agen_dgen_command_tag (15 downto 0)       => lut_tag                                  , -- OVR: fbist_dgen(dgen)
    agen_dgen_command_valid                   => lut_valid                                , -- OVR: fbist_dgen(dgen)
    sysclk                                    => cclk                                     , -- MSR: fbist_dgen(dgen)
    dgen_axi_command (7 downto 0)             => expected_command (7 downto 0)            , -- OVD: fbist_dgen(dgen)
    dgen_axi_command_address (63 downto 0)    => expected_address (63 downto 0)           , -- OVD: fbist_dgen(dgen)
    dgen_axi_command_data (511 downto 0)      => expected_data (511 downto 0)             , -- OVD: fbist_dgen(dgen)
    dgen_axi_command_engine (2 downto 0)      => expected_engine(2 downto 0)              , -- OVD: fbist_dgen(dgen)
    dgen_axi_command_tag (15 downto 0)        => expected_tag (15 downto 0)               , -- OVD: fbist_dgen(dgen)
    dgen_axi_command_valid                    => expected_valid                           , -- OVD: fbist_dgen(dgen)
    fbist_cfg_addrmod0_data_mode (3 downto 0) => fbist_cfg_addrmod0_data_mode (3 downto 0), -- MSR: fbist_dgen(dgen)
    fbist_cfg_addrmod1_data_mode (3 downto 0) => fbist_cfg_addrmod1_data_mode (3 downto 0), -- MSR: fbist_dgen(dgen)
    fbist_cfg_addrmod2_data_mode (3 downto 0) => fbist_cfg_addrmod2_data_mode (3 downto 0), -- MSR: fbist_dgen(dgen)
    fbist_cfg_addrmod3_data_mode (3 downto 0) => fbist_cfg_addrmod3_data_mode (3 downto 0), -- MSR: fbist_dgen(dgen)
    fbist_cfg_addrmod4_data_mode (3 downto 0) => fbist_cfg_addrmod4_data_mode (3 downto 0), -- MSR: fbist_dgen(dgen)
    fbist_cfg_addrmod5_data_mode (3 downto 0) => fbist_cfg_addrmod5_data_mode (3 downto 0), -- MSR: fbist_dgen(dgen)
    fbist_cfg_addrmod6_data_mode (3 downto 0) => fbist_cfg_addrmod6_data_mode (3 downto 0), -- MSR: fbist_dgen(dgen)
    fbist_cfg_addrmod7_data_mode (3 downto 0) => fbist_cfg_addrmod7_data_mode (3 downto 0), -- MSR: fbist_dgen(dgen)
    fbist_cfg_user_data_0 (63 downto 0)       => fbist_cfg_user_data_0 (63 downto 0)      , -- MSR: fbist_dgen(dgen)
    fbist_cfg_user_data_1 (63 downto 0)       => fbist_cfg_user_data_1 (63 downto 0)      , -- MSR: fbist_dgen(dgen)
    fbist_freeze                              => '0'                                      , -- OVR: fbist_dgen(dgen)
    sys_reset                                 => creset                                     -- MSR: fbist_dgen(dgen)
);

  -- While we're off regenerating data, pipeline the response we're
  -- getting so the 2 paths are aligned. Number of stages depends on
  -- the pipeline depth of dgen.
  response_stg1_d       <= axi_chk_response;
  response_valid_stg1_d <= axi_chk_response_valid;
  response_tag_stg1_d   <= axi_chk_response_tag;
  response_dpart_stg1_d <= axi_chk_response_dpart;
  response_ow_stg1_d    <= axi_chk_response_ow;
  response_data_stg1_d  <= axi_chk_response_data;

  response_stg2_d       <= response_stg1_q;
  response_valid_stg2_d <= response_valid_stg1_q;
  response_tag_stg2_d   <= response_tag_stg1_q;
  response_dpart_stg2_d <= response_dpart_stg1_q;
  response_ow_stg2_d    <= response_ow_stg1_q;
  response_data_stg2_d  <= response_data_stg1_q;

  response_stg3_d       <= response_stg2_q;
  response_valid_stg3_d <= response_valid_stg2_q;
  response_tag_stg3_d   <= response_tag_stg2_q;
  response_dpart_stg3_d <= response_dpart_stg2_q;
  response_ow_stg3_d    <= response_ow_stg2_q;
  response_data_stg3_d  <= response_data_stg2_q;

  actual_response <= response_stg3_q;
  actual_valid    <= response_valid_stg3_q;
  actual_tag      <= response_tag_stg3_q;
  actual_dpart    <= response_dpart_stg3_q;
  actual_ow       <= response_ow_stg3_q;
  actual_data     <= response_data_stg3_q;

  -- Now we actually check the results
  -- Pipeline this calculation so we're not doing a 512-bit OR in a single cycle.
  mismatch_data : for i in 0 to 31 generate
    mismatch_data_d(i) <= or_reduce(actual_data(i*16 + 15 downto i*16) xor expected_data(i*16 + 15 downto i*16));
  end generate mismatch_data;

  -- Depending on the responses we get for different parts of
  -- commands, we need to mask off various parts of the mismatch
  -- because we don't have data for that part. We only compare with
  -- one data flit at a time, and we switch which data we generate
  -- before the dgen. We also note when we know we get the last
  -- response for a tag, for reference only, which we actually use to
  -- retire the tag from outstanding_tags_valid.
  data_mask <= gate(x"0000FFFF", expected_command_q = FBIST_COMMAND_READ_32                                             ) or
               gate(x"0000FFFF", expected_command_q = FBIST_COMMAND_READ_64  and actual_ow = '1' and actual_dpart = "00") or -- First Data Flit                             read64 = 5
               gate(x"FFFF0000", expected_command_q = FBIST_COMMAND_READ_64  and actual_ow = '1' and actual_dpart = "01") or -- First Data Flit, last response
               gate(x"FFFFFFFF", expected_command_q = FBIST_COMMAND_READ_64  and actual_ow = '0'                        ) or -- First Data Flit, last response
               gate(x"0000FFFF", expected_command_q = FBIST_COMMAND_READ_128 and actual_ow = '1' and actual_dpart = "00") or -- First Data Flit                             read128 = 4
               gate(x"FFFF0000", expected_command_q = FBIST_COMMAND_READ_128 and actual_ow = '1' and actual_dpart = "01") or -- First Data Flit
               gate(x"0000FFFF", expected_command_q = FBIST_COMMAND_READ_128 and actual_ow = '1' and actual_dpart = "10") or -- Second Data Flit
               gate(x"FFFF0000", expected_command_q = FBIST_COMMAND_READ_128 and actual_ow = '1' and actual_dpart = "11") or -- Second Data Flit, last response
               gate(x"FFFFFFFF", expected_command_q = FBIST_COMMAND_READ_128 and actual_ow = '0' and actual_dpart = "00") or -- First Data Flit
               gate(x"FFFFFFFF", expected_command_q = FBIST_COMMAND_READ_128 and actual_ow = '0' and actual_dpart = "01");   -- Second Data Flit, last response

  mismatch_data_masked <= mismatch_data_q and data_mask;

  expected_command_d <= expected_command;
  actual_response_d <= actual_response;
  expected_valid_d <= expected_valid;
  actual_valid_d <= actual_valid;
  expected_data_d <= expected_data;
  actual_data_d <= actual_data;

  wrong_response <= not (((expected_command_q = FBIST_COMMAND_WRITE_128) and (actual_response_q = FBIST_RESPONSE_WRITE_OK)) or           -- 1 vs 1
                         ((expected_command_q = FBIST_COMMAND_WRITE_64)  and (actual_response_q = FBIST_RESPONSE_WRITE_OK)) or           -- 2 vs 1
                         ((expected_command_q = FBIST_COMMAND_WRITE_32)  and (actual_response_q = FBIST_RESPONSE_WRITE_OK)) or           -- 3 vs 1
                         ((expected_command_q = FBIST_COMMAND_READ_128)  and (actual_response_q = FBIST_RESPONSE_READ_OK)) or            -- 4    3
                         ((expected_command_q = FBIST_COMMAND_READ_64)   and (actual_response_q = FBIST_RESPONSE_READ_OK)) or            -- 5    3
                         ((expected_command_q = FBIST_COMMAND_READ_32)   and (actual_response_q = FBIST_RESPONSE_READ_OK)));             -- 6    3

  wrong_data <=  actual_valid_q and (or_reduce(mismatch_data_masked) and actual_response_q = FBIST_RESPONSE_READ_OK);
  chk_error_valid_int <= (actual_valid_q xor expected_valid_q) or    -- this looks like the write strobe for errors
                         wrong_data                            or    -- actual_valid_q means there is something to check  this cycle
                         (actual_valid_q and wrong_response) ;

  chk_error_valid  <= chk_error_valid_q;

  chk_error_expected_command <= expected_command_q;
  chk_error_actual_response <= actual_response_q;
  chk_error_expected_valid <= expected_valid_q;
  chk_error_actual_valid <= actual_valid_q;
  chk_error_expected_data <= expected_data_q;
  chk_error_actual_data <= actual_data_q;

-- make outputs for error buffer (latch the whole lot too)
  chk_fesbuff_we_d            <= chk_error_valid_int and not creset;
  chk_fesbuff_data_d          <=   actual_response_q(7 downto 0)                                   &  -- 8 bits  only 3 used  543 downto 536
                                   '0'                                                             &  -- 1 as a filler        535
                                   expected_engine_q                                               &  -- 3                    534 downto 532
                                   actual_tag                                                      &  --16                    531 downto 516
                                   actual_dpart                                                    &  -- 2 bits               515 downto 514
                                   actual_ow                                                       &  -- 1 bit                513
                                   wrong_data                                                      &  -- 1 data wrong bit     512
                                   actual_data_q;                                                     --                      511 downto 0

  -----------------------------------------------------------------------------
  -- Latches
  -----------------------------------------------------------------------------
  process (cclk) is
  begin
    if rising_edge(cclk) then

      chk_error_valid_q   <= chk_error_valid_d;
      chk_error_valid_1_q <= chk_error_valid_1_d;
      chk_error_valid_2_q <= chk_error_valid_2_d;

      offset_valids_q   <= offset_valids_d;
      offset_valids_1_q <= offset_valids_1_d;
      offset_valids_2_q <= offset_valids_2_d;
      
      wrong_data_q   <= wrong_data_d;
      wrong_data_1_q <= wrong_data_1_d;
      wrong_data_2_q <= wrong_data_2_d;

      wrong_response_q   <= wrong_response_d;
      wrong_response_1_q <= wrong_response_1_d;
      wrong_response_2_q <= wrong_response_2_d;

      engine_0_total_latency_q <= engine_0_total_latency_d;
      engine_1_total_latency_q <= engine_1_total_latency_d;
      engine_2_total_latency_q <= engine_2_total_latency_d;
      engine_3_total_latency_q <= engine_3_total_latency_d;
      engine_4_total_latency_q <= engine_4_total_latency_d;
      engine_5_total_latency_q <= engine_5_total_latency_d;
      engine_6_total_latency_q <= engine_6_total_latency_d;
      engine_7_total_latency_q <= engine_7_total_latency_d;

      cycles_since_last_response_q <= cycles_since_last_response_d;

      if (creset = '1') then
        response_valid_stg1_q <= '0';
        response_valid_stg2_q <= '0';
        response_valid_stg3_q <= '0';
        expected_valid_q      <= '0';
        actual_valid_q        <= '0';

        error_count_q         <= (others => '0');
        error_count_1_q <=  (others => '0');
        error_count_2_q <= (others => '0');
        
      else
        response_stg1_q       <= response_stg1_d;
        response_valid_stg1_q <= response_valid_stg1_d;
        response_tag_stg1_q   <= response_tag_stg1_d;
        response_dpart_stg1_q <= response_dpart_stg1_d;
        response_ow_stg1_q    <= response_ow_stg1_d;
        response_data_stg1_q  <= response_data_stg1_d;

        response_stg2_q       <= response_stg2_d;
        response_valid_stg2_q <= response_valid_stg2_d;
        response_tag_stg2_q   <= response_tag_stg2_d;
        response_dpart_stg2_q <= response_dpart_stg2_d;
        response_ow_stg2_q    <= response_ow_stg2_d;
        response_data_stg2_q  <= response_data_stg2_d;

        response_stg3_q       <= response_stg3_d;
        response_valid_stg3_q <= response_valid_stg3_d;
        response_tag_stg3_q   <= response_tag_stg3_d;
        response_dpart_stg3_q <= response_dpart_stg3_d;
        response_ow_stg3_q    <= response_ow_stg3_d;
        response_data_stg3_q  <= response_data_stg3_d;

        mismatch_data_q    <= mismatch_data_d;
        expected_command_q <= expected_command;
        expected_engine_q  <= expected_engine;
        actual_response_q  <= actual_response;
        expected_valid_q   <= expected_valid_d;
        actual_valid_q     <= actual_valid_d;
        expected_data_q    <= expected_data_d;
        actual_data_q      <= actual_data_d;

        chk_fesbuff_we     <=  chk_fesbuff_we_d;
        chk_fesbuff_data   <=  chk_fesbuff_data_d;

        error_count_q   <= error_count_d;  
        error_count_1_q <= error_count_1_d;
        error_count_2_q <= error_count_2_d;

        command_diff_q <= command_diff_d;
        lut_engine_q   <= lut_engine_d;
        lut_valid_q   <= lut_valid_d;
      end if;
    end if;
  end process;

end fbist_chk;
