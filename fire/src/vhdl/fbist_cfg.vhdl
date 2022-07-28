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

library ieee, ibm, support;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ibm.std_ulogic_support.all;
use ibm.std_ulogic_unsigned.all;
use ibm.std_ulogic_function_support.all;
use ibm.synthesis_support.all;
use support.logic_support_pkg.all;
use work.axi_pkg.all;

entity fbist_cfg is
  port (
    ---------------------------------------------------------------------------
    -- Clocking & Power
    ---------------------------------------------------------------------------
    sysclk                         : in std_ulogic;
    sys_reset                      : in std_ulogic;

    ---------------------------------------------------------------------------
    -- Register Interface (AXI4-Lite Slave)
    ---------------------------------------------------------------------------
    fbist_axis_aclk                : in std_ulogic;
    fbist_axis_i                   : in t_AXI4_LITE_SLAVE_INPUT;
    fbist_axis_o                   : out t_AXI4_LITE_SLAVE_OUTPUT;

    ---------------------------------------------------------------------------
    -- Function
    ---------------------------------------------------------------------------
    fbist_cfg_status_ip                   : out std_ulogic;
    fbist_cfg_pool0_engine0_command       : out std_ulogic_vector(7 downto 0);
    fbist_cfg_pool0_engine1_command       : out std_ulogic_vector(7 downto 0);
    fbist_cfg_pool0_engine2_command       : out std_ulogic_vector(7 downto 0);
    fbist_cfg_pool0_engine3_command       : out std_ulogic_vector(7 downto 0);
    fbist_cfg_pool0_engine4_command       : out std_ulogic_vector(7 downto 0);
    fbist_cfg_pool0_engine5_command       : out std_ulogic_vector(7 downto 0);
    fbist_cfg_pool0_engine6_command       : out std_ulogic_vector(7 downto 0);
    fbist_cfg_pool0_engine7_command       : out std_ulogic_vector(7 downto 0);
    fbist_cfg_pool0_engine0_address_mode  : out std_ulogic_vector(7 downto 0);
    fbist_cfg_pool0_engine1_address_mode  : out std_ulogic_vector(7 downto 0);
    fbist_cfg_pool0_engine2_address_mode  : out std_ulogic_vector(7 downto 0);
    fbist_cfg_pool0_engine3_address_mode  : out std_ulogic_vector(7 downto 0);
    fbist_cfg_pool0_engine4_address_mode  : out std_ulogic_vector(7 downto 0);
    fbist_cfg_pool0_engine5_address_mode  : out std_ulogic_vector(7 downto 0);
    fbist_cfg_pool0_engine6_address_mode  : out std_ulogic_vector(7 downto 0);
    fbist_cfg_pool0_engine7_address_mode  : out std_ulogic_vector(7 downto 0);
    fbist_cfg_pool0_spacing_count         : out std_ulogic_vector(15 downto 0);
    fbist_cfg_pool0_spacing_scheme        : out std_ulogic_vector(3 downto 0);
    fbist_cfg_pool0_arb_scheme            : out std_ulogic_vector(3 downto 0);
    fbist_cfg_pool0_engine0_address_start : out std_ulogic_vector(63 downto 0);
    fbist_cfg_pool0_engine1_address_start : out std_ulogic_vector(63 downto 0);
    fbist_cfg_pool0_engine2_address_start : out std_ulogic_vector(63 downto 0);
    fbist_cfg_pool0_engine3_address_start : out std_ulogic_vector(63 downto 0);
    fbist_cfg_pool0_engine4_address_start : out std_ulogic_vector(63 downto 0);
    fbist_cfg_pool0_engine5_address_start : out std_ulogic_vector(63 downto 0);
    fbist_cfg_pool0_engine6_address_start : out std_ulogic_vector(63 downto 0);
    fbist_cfg_pool0_engine7_address_start : out std_ulogic_vector(63 downto 0);
    fbist_cfg_pool0_address_and_mask      : out std_ulogic_vector(63 downto 0);
    fbist_cfg_pool0_address_or_mask       : out std_ulogic_vector(63 downto 0);
    fbist_cfg_pool0_addrmod0_data_mode    : out std_ulogic_vector(3 downto 0);
    fbist_cfg_pool0_addrmod1_data_mode    : out std_ulogic_vector(3 downto 0);
    fbist_cfg_pool0_addrmod2_data_mode    : out std_ulogic_vector(3 downto 0);
    fbist_cfg_pool0_addrmod3_data_mode    : out std_ulogic_vector(3 downto 0);
    fbist_cfg_pool0_addrmod4_data_mode    : out std_ulogic_vector(3 downto 0);
    fbist_cfg_pool0_addrmod5_data_mode    : out std_ulogic_vector(3 downto 0);
    fbist_cfg_pool0_addrmod6_data_mode    : out std_ulogic_vector(3 downto 0);
    fbist_cfg_pool0_addrmod7_data_mode    : out std_ulogic_vector(3 downto 0);
    fbist_cfg_user_data_0                 : out std_ulogic_vector(63 downto 0);
    fbist_cfg_user_data_1                 : out std_ulogic_vector(63 downto 0);

    fbist_cfg_pool0_stats_num_reads       : in std_ulogic_vector(47 downto 0);
    fbist_cfg_pool0_stats_num_writes      : in std_ulogic_vector(47 downto 0);
    fbist_cfg_pool0_stats_num_read_bytes  : in std_ulogic_vector(47 downto 0);
    fbist_cfg_pool0_stats_num_write_bytes : in std_ulogic_vector(47 downto 0);
    fbist_cfg_pool0_stats_run_time        : in std_ulogic_vector(47 downto 0);

    chk_cfg_engine0_total_latency         : in std_ulogic_vector(63 downto 0);
    chk_cfg_engine1_total_latency         : in std_ulogic_vector(63 downto 0);
    chk_cfg_engine2_total_latency         : in std_ulogic_vector(63 downto 0);
    chk_cfg_engine3_total_latency         : in std_ulogic_vector(63 downto 0);
    chk_cfg_engine4_total_latency         : in std_ulogic_vector(63 downto 0);
    chk_cfg_engine5_total_latency         : in std_ulogic_vector(63 downto 0);
    chk_cfg_engine6_total_latency         : in std_ulogic_vector(63 downto 0);
    chk_cfg_engine7_total_latency         : in std_ulogic_vector(63 downto 0);

    cfg_axi_address_inject_enable         : out std_ulogic;
    cfg_axi_data_inject_enable            : out std_ulogic;
    cfg_axi_address_inject_done           : in std_ulogic;
    cfg_axi_data_inject_done              : in std_ulogic;

    fbist_cfg_chk_error_valid             : in std_ulogic;
    fbist_cfg_chk_error_response_hang     : in std_ulogic;
    exp_rd_valid                          : out std_ulogic;
    exp_rd_address                        : out std_ulogic_vector(31 downto 0);
    exp_rd_data                           : in  std_ulogic_vector(31 downto 0);
    exp_rd_data_valid                     : in  std_ulogic;
    exp_wr_valid                          : out std_ulogic;
    exp_wr_address                        : out std_ulogic_vector(31 downto 0)
    );

  attribute BLOCK_TYPE of fbist_cfg : entity is LEAF;
  attribute BTR_NAME of fbist_cfg : entity is "FBIST_CFG";
  attribute RECURSIVE_SYNTHESIS of fbist_cfg : entity is 2;
  attribute PIN_DATA of sysclk : signal is "PIN_FUNCTION=/G_CLK/";
  attribute PIN_DEFAULT_GROUND_DOMAIN of fbist_cfg : entity is "GND";
  attribute PIN_DEFAULT_POWER_DOMAIN of fbist_cfg : entity is "VDD";
end fbist_cfg;

architecture fbist_cfg of fbist_cfg is
  SIGNAL fbist_cfg_pool0_engine0 : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_cfg_pool0_engine1 : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_cfg_pool0_engine2 : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_cfg_pool0_engine3 : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_cfg_pool0_engine4 : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_cfg_pool0_engine5 : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_cfg_pool0_engine6 : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_cfg_pool0_engine7 : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_cfg_pool0_spacing : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_cfg_pool0_arb : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_cfg_status : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_cfg_pool0_engine0_address_start_low : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_cfg_pool0_engine0_address_start_high : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_cfg_pool0_engine1_address_start_low : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_cfg_pool0_engine1_address_start_high : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_cfg_pool0_engine2_address_start_low : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_cfg_pool0_engine2_address_start_high : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_cfg_pool0_engine3_address_start_low : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_cfg_pool0_engine3_address_start_high : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_cfg_pool0_engine4_address_start_low : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_cfg_pool0_engine4_address_start_high : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_cfg_pool0_engine5_address_start_low : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_cfg_pool0_engine5_address_start_high : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_cfg_pool0_engine6_address_start_low : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_cfg_pool0_engine6_address_start_high : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_cfg_pool0_engine7_address_start_low : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_cfg_pool0_engine7_address_start_high : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_cfg_pool0_address_and_mask_low : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_cfg_pool0_address_and_mask_high : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_cfg_pool0_address_or_mask_low : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_cfg_pool0_address_or_mask_high : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_cfg_error : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_error_store : std_ulogic;
  SIGNAL fbist_cfg_pool0_data : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_cfg_user_data_0_high : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_cfg_user_data_0_low : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_cfg_user_data_1_high : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_cfg_user_data_1_low : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_cfg_chk_error_valid_n1_d : std_ulogic;
  SIGNAL fbist_cfg_chk_error_valid_n1_q : std_ulogic;
  SIGNAL fbist_cfg_chk_error_valid_n2_d : std_ulogic;
  SIGNAL fbist_cfg_chk_error_valid_n2_q : std_ulogic;
  SIGNAL fbist_cfg_status_update : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_cfg_status_hwwe : std_ulogic;
  SIGNAL fbist_cfg_status_done : std_ulogic;
  SIGNAL fbist_cfg_status_ip_d : std_ulogic;
  SIGNAL fbist_cfg_status_ip_q : std_ulogic;
  SIGNAL fbist_cfg_stop_on_error : std_ulogic;
  SIGNAL fbist_inject_update : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_inject_hwwe : std_ulogic;
  SIGNAL fbist_inject : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_cfg_dont_flag_hang : std_ulogic;

begin

  fbist_cfg_pool0_engine0_command <= fbist_cfg_pool0_engine0(7 downto 0);
  fbist_cfg_pool0_engine1_command <= fbist_cfg_pool0_engine1(7 downto 0);
  fbist_cfg_pool0_engine2_command <= fbist_cfg_pool0_engine2(7 downto 0);
  fbist_cfg_pool0_engine3_command <= fbist_cfg_pool0_engine3(7 downto 0);
  fbist_cfg_pool0_engine4_command <= fbist_cfg_pool0_engine4(7 downto 0);
  fbist_cfg_pool0_engine5_command <= fbist_cfg_pool0_engine5(7 downto 0);
  fbist_cfg_pool0_engine6_command <= fbist_cfg_pool0_engine6(7 downto 0);
  fbist_cfg_pool0_engine7_command <= fbist_cfg_pool0_engine7(7 downto 0);

  fbist_cfg_pool0_engine0_address_mode <= fbist_cfg_pool0_engine0(15 downto 8);
  fbist_cfg_pool0_engine1_address_mode <= fbist_cfg_pool0_engine1(15 downto 8);
  fbist_cfg_pool0_engine2_address_mode <= fbist_cfg_pool0_engine2(15 downto 8);
  fbist_cfg_pool0_engine3_address_mode <= fbist_cfg_pool0_engine3(15 downto 8);
  fbist_cfg_pool0_engine4_address_mode <= fbist_cfg_pool0_engine4(15 downto 8);
  fbist_cfg_pool0_engine5_address_mode <= fbist_cfg_pool0_engine5(15 downto 8);
  fbist_cfg_pool0_engine6_address_mode <= fbist_cfg_pool0_engine6(15 downto 8);
  fbist_cfg_pool0_engine7_address_mode <= fbist_cfg_pool0_engine7(15 downto 8);

  fbist_cfg_pool0_spacing_scheme <= fbist_cfg_pool0_spacing(19 downto 16);
  fbist_cfg_pool0_spacing_count  <= fbist_cfg_pool0_spacing(15 downto 0);

  fbist_cfg_pool0_arb_scheme <= fbist_cfg_pool0_arb(3 downto 0);

  fbist_cfg_stop_on_error  <= fbist_cfg_status(31);
  fbist_cfg_dont_flag_hang <= fbist_cfg_status(30);
  fbist_cfg_status_ip     <= fbist_cfg_status_ip_q;
  fbist_cfg_status_ip_d   <= '0' when fbist_cfg_status(1) = '1' or (fbist_cfg_stop_on_error = '1' and fbist_error_store = '1') else
                             '1' when fbist_cfg_status(0) = '1'                                                                else
                             fbist_cfg_status_ip_q;
  fbist_cfg_status_done   <= fbist_cfg_status_ip_q and (fbist_cfg_stop_on_error and fbist_error_store = '1');  -- Conditions where HW will end test

  fbist_cfg_status_update <= x"0000000" & fbist_cfg_status_done & fbist_cfg_status_ip_q & "00";
  fbist_cfg_status_hwwe <= fbist_cfg_status(0) or fbist_cfg_status(1) or -- Self clearing bits
                           fbist_cfg_status_done or -- sticky bit
                           (fbist_cfg_status_ip_q xor fbist_cfg_status(2)); -- IP needs updating

  fbist_cfg_pool0_engine0_address_start <= fbist_cfg_pool0_engine0_address_start_high & fbist_cfg_pool0_engine0_address_start_low;
  fbist_cfg_pool0_engine1_address_start <= fbist_cfg_pool0_engine1_address_start_high & fbist_cfg_pool0_engine1_address_start_low;
  fbist_cfg_pool0_engine2_address_start <= fbist_cfg_pool0_engine2_address_start_high & fbist_cfg_pool0_engine2_address_start_low;
  fbist_cfg_pool0_engine3_address_start <= fbist_cfg_pool0_engine3_address_start_high & fbist_cfg_pool0_engine3_address_start_low;
  fbist_cfg_pool0_engine4_address_start <= fbist_cfg_pool0_engine4_address_start_high & fbist_cfg_pool0_engine4_address_start_low;
  fbist_cfg_pool0_engine5_address_start <= fbist_cfg_pool0_engine5_address_start_high & fbist_cfg_pool0_engine5_address_start_low;
  fbist_cfg_pool0_engine6_address_start <= fbist_cfg_pool0_engine6_address_start_high & fbist_cfg_pool0_engine6_address_start_low;
  fbist_cfg_pool0_engine7_address_start <= fbist_cfg_pool0_engine7_address_start_high & fbist_cfg_pool0_engine7_address_start_low;

  fbist_cfg_pool0_address_and_mask <= fbist_cfg_pool0_address_and_mask_high & fbist_cfg_pool0_address_and_mask_low;
  fbist_cfg_pool0_address_or_mask  <= fbist_cfg_pool0_address_or_mask_high & fbist_cfg_pool0_address_or_mask_low;

  fbist_cfg_error   <= "0000000000000000000000000000" &
                     (fbist_cfg_chk_error_response_hang and not fbist_cfg_dont_flag_hang) &
                     "0" &
                     fbist_cfg_chk_error_valid_n2_q &
                     (fbist_cfg_chk_error_valid_n2_q or (fbist_cfg_chk_error_response_hang and not fbist_cfg_dont_flag_hang));
  fbist_error_store <= or_reduce(fbist_cfg_error);

  fbist_cfg_pool0_addrmod0_data_mode <= fbist_cfg_pool0_data(3 downto 0);
  fbist_cfg_pool0_addrmod1_data_mode <= fbist_cfg_pool0_data(7 downto 4);
  fbist_cfg_pool0_addrmod2_data_mode <= fbist_cfg_pool0_data(11 downto 8);
  fbist_cfg_pool0_addrmod3_data_mode <= fbist_cfg_pool0_data(15 downto 12);
  fbist_cfg_pool0_addrmod4_data_mode <= fbist_cfg_pool0_data(19 downto 16);
  fbist_cfg_pool0_addrmod5_data_mode <= fbist_cfg_pool0_data(23 downto 20);
  fbist_cfg_pool0_addrmod6_data_mode <= fbist_cfg_pool0_data(27 downto 24);
  fbist_cfg_pool0_addrmod7_data_mode <= fbist_cfg_pool0_data(31 downto 28);
  fbist_cfg_user_data_0 <= fbist_cfg_user_data_0_high & fbist_cfg_user_data_0_low;
  fbist_cfg_user_data_1 <= fbist_cfg_user_data_1_high & fbist_cfg_user_data_1_low;

  cfg_axi_address_inject_enable <= fbist_inject(3);
  cfg_axi_data_inject_enable    <= fbist_inject(1);
  fbist_inject_update           <= (2 => cfg_axi_address_inject_done or fbist_inject(2), 0 => cfg_axi_data_inject_done or fbist_inject(0), others => '0');
  fbist_inject_hwwe             <= cfg_axi_address_inject_done or cfg_axi_data_inject_done;

  -- This signal is coming from the cclk domain and latch launched, so
  -- stabilize it.
  fbist_cfg_chk_error_valid_n1_d <= fbist_cfg_chk_error_valid;
  fbist_cfg_chk_error_valid_n2_d <= fbist_cfg_chk_error_valid_n1_q;

  fbist_cfg_regs : entity work.axi_regs_32_large
    generic map (
      offset         => 16#00000#,
      REG_1B_RESET   => x"FFFFFFFF",
      REG_1C_RESET   => x"FFFFFFFF",
      REG_00_WE_MASK => x"FFFFFFFF",
      REG_01_WE_MASK => x"FFFFFFFF",
      REG_02_WE_MASK => x"FFFFFFFF",
      REG_03_WE_MASK => x"FFFFFFFF",
      REG_04_WE_MASK => x"FFFFFFFF",
      REG_05_WE_MASK => x"FFFFFFFF",
      REG_06_WE_MASK => x"FFFFFFFF",
      REG_07_WE_MASK => x"FFFFFFFF",
      REG_08_WE_MASK => x"FFFFFFFF",
      REG_09_WE_MASK => x"FFFFFFFF",
      REG_0A_WE_MASK => x"C000000B",
      REG_0B_WE_MASK => x"FFFFFFFF",
      REG_0C_WE_MASK => x"FFFFFFFF",
      REG_0D_WE_MASK => x"FFFFFFFF",
      REG_0E_WE_MASK => x"FFFFFFFF",
      REG_0F_WE_MASK => x"FFFFFFFF",
      REG_10_WE_MASK => x"FFFFFFFF",
      REG_11_WE_MASK => x"FFFFFFFF",
      REG_12_WE_MASK => x"FFFFFFFF",
      REG_13_WE_MASK => x"FFFFFFFF",
      REG_14_WE_MASK => x"FFFFFFFF",
      REG_15_WE_MASK => x"FFFFFFFF",
      REG_16_WE_MASK => x"FFFFFFFF",
      REG_17_WE_MASK => x"FFFFFFFF",
      REG_18_WE_MASK => x"FFFFFFFF",
      REG_19_WE_MASK => x"FFFFFFFF",
      REG_1A_WE_MASK => x"FFFFFFFF",
      REG_1B_WE_MASK => x"FFFFFFFF",
      REG_1C_WE_MASK => x"FFFFFFFF",
      REG_1D_WE_MASK => x"FFFFFFFF",
      REG_1E_WE_MASK => x"FFFFFFFF",
      REG_1F_WE_MASK => x"00000000",
      REG_20_WE_MASK => x"00000000",
      REG_21_WE_MASK => x"00000000",
      REG_22_WE_MASK => x"00000000",
      REG_23_WE_MASK => x"00000000",
      REG_24_WE_MASK => x"0000000F",
      REG_25_WE_MASK => x"FFFFFFFF",
      REG_26_WE_MASK => x"FFFFFFFF",
      REG_27_WE_MASK => x"FFFFFFFF",
      REG_28_WE_MASK => x"FFFFFFFF",
      REG_29_WE_MASK => x"FFFFFFFF",
      REG_2A_WE_MASK => x"00000000",
      REG_2B_WE_MASK => x"00000000",
      REG_2C_WE_MASK => x"00000000",
      REG_2D_WE_MASK => x"00000000",
      REG_2E_WE_MASK => x"00000000",
      REG_2F_WE_MASK => x"00000000",
      REG_33_WE_MASK => x"00000000",
      REG_34_WE_MASK => x"00000000",
      REG_35_WE_MASK => x"00000000",
      REG_36_WE_MASK => x"00000000",
      REG_37_WE_MASK => x"00000000",
      REG_38_WE_MASK => x"00000000",
      REG_39_WE_MASK => x"00000000",
      REG_3A_WE_MASK => x"00000000",
      REG_3B_WE_MASK => x"00000000",
      REG_3C_WE_MASK => x"00000000",
      REG_3D_WE_MASK => x"00000000",
      REG_3E_WE_MASK => x"00000000",
      REG_3F_WE_MASK => x"00000000",
      REG_40_WE_MASK => x"0000000F",

      REG_0A_HWWE_MASK => x"0000000F",
      REG_1F_HWWE_MASK => x"FFFFFFFF",
      REG_20_HWWE_MASK => x"FFFFFFFF",
      REG_21_HWWE_MASK => x"FFFFFFFF",
      REG_22_HWWE_MASK => x"FFFFFFFF",
      REG_23_HWWE_MASK => x"FFFFFFFF",
      REG_24_HWWE_MASK => x"0000000F",
      REG_2A_HWWE_MASK => x"FFFFFFFF",
      REG_2B_HWWE_MASK => x"FFFFFFFF",
      REG_2C_HWWE_MASK => x"FFFFFFFF",
      REG_2D_HWWE_MASK => x"FFFFFFFF",
      REG_2E_HWWE_MASK => x"FFFFFFFF",
      REG_2F_HWWE_MASK => x"FFFFFFFF",
      REG_33_HWWE_MASK => x"FFFFFFFF",
      REG_34_HWWE_MASK => x"FFFFFFFF",
      REG_35_HWWE_MASK => x"FFFFFFFF",
      REG_36_HWWE_MASK => x"FFFFFFFF",
      REG_37_HWWE_MASK => x"FFFFFFFF",
      REG_38_HWWE_MASK => x"FFFFFFFF",
      REG_39_HWWE_MASK => x"FFFFFFFF",
      REG_3A_HWWE_MASK => x"FFFFFFFF",
      REG_3B_HWWE_MASK => x"FFFFFFFF",
      REG_3C_HWWE_MASK => x"FFFFFFFF",
      REG_3D_HWWE_MASK => x"FFFFFFFF",
      REG_3E_HWWE_MASK => x"FFFFFFFF",
      REG_3F_HWWE_MASK => x"FFFFFFFF",
      REG_40_HWWE_MASK => x"00000005",

      REG_0A_STICKY_MASK => x"00000008",
      REG_24_STICKY_MASK => x"0000000F",
      REG_40_STICKY_MASK => x"00000005"
      )
    port map (
      s0_axi_aclk      => fbist_axis_aclk,
      s0_axi_i         => fbist_axis_i,
      s0_axi_o         => fbist_axis_o,
      reg_00_o         => fbist_cfg_pool0_engine0,
      reg_01_o         => fbist_cfg_pool0_engine1,
      reg_02_o         => fbist_cfg_pool0_engine2,
      reg_03_o         => fbist_cfg_pool0_engine3,
      reg_04_o         => fbist_cfg_pool0_engine4,
      reg_05_o         => fbist_cfg_pool0_engine5,
      reg_06_o         => fbist_cfg_pool0_engine6,
      reg_07_o         => fbist_cfg_pool0_engine7,
      reg_08_o         => fbist_cfg_pool0_spacing,
      reg_09_o         => fbist_cfg_pool0_arb,
      reg_0A_o         => fbist_cfg_status,
      reg_0B_o         => fbist_cfg_pool0_engine0_address_start_low,
      reg_0C_o         => fbist_cfg_pool0_engine0_address_start_high,
      reg_0D_o         => fbist_cfg_pool0_engine1_address_start_low,
      reg_0E_o         => fbist_cfg_pool0_engine1_address_start_high,
      reg_0F_o         => fbist_cfg_pool0_engine2_address_start_low,
      reg_10_o         => fbist_cfg_pool0_engine2_address_start_high,
      reg_11_o         => fbist_cfg_pool0_engine3_address_start_low,
      reg_12_o         => fbist_cfg_pool0_engine3_address_start_high,
      reg_13_o         => fbist_cfg_pool0_engine4_address_start_low,
      reg_14_o         => fbist_cfg_pool0_engine4_address_start_high,
      reg_15_o         => fbist_cfg_pool0_engine5_address_start_low,
      reg_16_o         => fbist_cfg_pool0_engine5_address_start_high,
      reg_17_o         => fbist_cfg_pool0_engine6_address_start_low,
      reg_18_o         => fbist_cfg_pool0_engine6_address_start_high,
      reg_19_o         => fbist_cfg_pool0_engine7_address_start_low,
      reg_1A_o         => fbist_cfg_pool0_engine7_address_start_high,
      reg_1B_o         => fbist_cfg_pool0_address_and_mask_low,
      reg_1C_o         => fbist_cfg_pool0_address_and_mask_high,
      reg_1D_o         => fbist_cfg_pool0_address_or_mask_low,
      reg_1E_o         => fbist_cfg_pool0_address_or_mask_high,
      reg_1F_o         => open,
      reg_20_o         => open,
      reg_21_o         => open,
      reg_22_o         => open,
      reg_23_o         => open,
      reg_24_o         => open,
      reg_25_o         => fbist_cfg_pool0_data,
      reg_26_o         => fbist_cfg_user_data_0_high,
      reg_27_o         => fbist_cfg_user_data_0_low,
      reg_28_o         => fbist_cfg_user_data_1_high,
      reg_29_o         => fbist_cfg_user_data_1_low,
      reg_2A_o         => open,
      reg_2B_o         => open,
      reg_2C_o         => open,
      reg_40_o         => fbist_inject,
      reg_0A_update_i  => fbist_cfg_status_update,
      reg_1F_update_i  => fbist_cfg_pool0_stats_num_reads(31 downto 0),
      reg_20_update_i  => fbist_cfg_pool0_stats_num_writes(31 downto 0),
      reg_21_update_i  => fbist_cfg_pool0_stats_num_read_bytes(31 downto 0),
      reg_22_update_i  => fbist_cfg_pool0_stats_num_write_bytes(31 downto 0),
      reg_23_update_i  => fbist_cfg_pool0_stats_run_time(31 downto 0),
      reg_24_update_i  => fbist_cfg_error,
      reg_2A_update_i  => fbist_cfg_pool0_stats_num_writes(47 downto 32) & fbist_cfg_pool0_stats_num_reads(47 downto 32),
      reg_2B_update_i  => fbist_cfg_pool0_stats_num_write_bytes(47 downto 32) & fbist_cfg_pool0_stats_num_read_bytes(47 downto 32),
      reg_2C_update_i  => x"0000" & fbist_cfg_pool0_stats_run_time(47 downto 32),
      reg_2D_update_i  => chk_cfg_engine0_total_latency(31 downto 0),
      reg_2E_update_i  => chk_cfg_engine0_total_latency(63 downto 32),
      reg_2F_update_i  => chk_cfg_engine1_total_latency(31 downto 0),
      -- reg_30 to _32 used by exp_interface
      reg_33_update_i  => chk_cfg_engine1_total_latency(63 downto 32),
      reg_34_update_i  => chk_cfg_engine2_total_latency(31 downto 0),
      reg_35_update_i  => chk_cfg_engine2_total_latency(63 downto 32),
      reg_36_update_i  => chk_cfg_engine3_total_latency(31 downto 0),
      reg_37_update_i  => chk_cfg_engine3_total_latency(63 downto 32),
      reg_38_update_i  => chk_cfg_engine4_total_latency(31 downto 0),
      reg_39_update_i  => chk_cfg_engine4_total_latency(63 downto 32),
      reg_3A_update_i  => chk_cfg_engine5_total_latency(31 downto 0),
      reg_3B_update_i  => chk_cfg_engine5_total_latency(63 downto 32),
      reg_3C_update_i  => chk_cfg_engine6_total_latency(31 downto 0),
      reg_3D_update_i  => chk_cfg_engine6_total_latency(63 downto 32),
      reg_3E_update_i  => chk_cfg_engine7_total_latency(31 downto 0),
      reg_3F_update_i  => chk_cfg_engine7_total_latency(63 downto 32),
      reg_40_update_i  => fbist_inject_update,
      reg_0A_hwwe_i    => fbist_cfg_status_hwwe,
      reg_1F_hwwe_i    => fbist_cfg_status_ip_q,
      reg_20_hwwe_i    => fbist_cfg_status_ip_q,
      reg_21_hwwe_i    => fbist_cfg_status_ip_q,
      reg_22_hwwe_i    => fbist_cfg_status_ip_q,
      reg_23_hwwe_i    => fbist_cfg_status_ip_q,
      reg_24_hwwe_i    => fbist_error_store,
      reg_2A_hwwe_i    => fbist_cfg_status_ip_q,
      reg_2B_hwwe_i    => fbist_cfg_status_ip_q,
      reg_2C_hwwe_i    => fbist_cfg_status_ip_q,
      reg_2D_hwwe_i    => fbist_cfg_status_ip_q,
      reg_2E_hwwe_i    => fbist_cfg_status_ip_q,
      reg_2F_hwwe_i    => fbist_cfg_status_ip_q,
      reg_33_hwwe_i    => fbist_cfg_status_ip_q,
      reg_34_hwwe_i    => fbist_cfg_status_ip_q,
      reg_35_hwwe_i    => fbist_cfg_status_ip_q,
      reg_36_hwwe_i    => fbist_cfg_status_ip_q,
      reg_37_hwwe_i    => fbist_cfg_status_ip_q,
      reg_38_hwwe_i    => fbist_cfg_status_ip_q,
      reg_39_hwwe_i    => fbist_cfg_status_ip_q,
      reg_3A_hwwe_i    => fbist_cfg_status_ip_q,
      reg_3B_hwwe_i    => fbist_cfg_status_ip_q,
      reg_3C_hwwe_i    => fbist_cfg_status_ip_q,
      reg_3D_hwwe_i    => fbist_cfg_status_ip_q,
      reg_3E_hwwe_i    => fbist_cfg_status_ip_q,
      reg_3F_hwwe_i    => fbist_cfg_status_ip_q,
      reg_40_hwwe_i    => fbist_inject_hwwe,
--
      exp_rd_valid      =>  exp_rd_valid,
      exp_rd_address    =>  exp_rd_address,
      exp_rd_data       =>  exp_rd_data,
      exp_rd_data_valid =>  exp_rd_data_valid,
      exp_wr_valid      =>  exp_wr_valid,
      exp_wr_address    =>  exp_wr_address
      );

  process (sysclk) is
  begin
    if rising_edge(sysclk) then
      if (sys_reset = '1') then
        fbist_cfg_chk_error_valid_n1_q <= '0';
        fbist_cfg_chk_error_valid_n2_q <= '0';
        fbist_cfg_status_ip_q          <= '0';
      else
        fbist_cfg_chk_error_valid_n1_q <= fbist_cfg_chk_error_valid_n1_d;
        fbist_cfg_chk_error_valid_n2_q <= fbist_cfg_chk_error_valid_n2_d;
        fbist_cfg_status_ip_q          <= fbist_cfg_status_ip_d;
      end if;
    end if;
  end process;

end fbist_cfg;
