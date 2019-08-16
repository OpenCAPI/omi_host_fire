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

    fbist_cfg_pool0_stats_num_reads       : in std_ulogic_vector(31 downto 0);
    fbist_cfg_pool0_stats_num_writes      : in std_ulogic_vector(31 downto 0);
    fbist_cfg_pool0_stats_num_read_bytes  : in std_ulogic_vector(31 downto 0);
    fbist_cfg_pool0_stats_num_write_bytes : in std_ulogic_vector(31 downto 0);
    fbist_cfg_pool0_stats_run_time        : in std_ulogic_vector(31 downto 0);

    fbist_cfg_chk_error_valid             : in std_ulogic;
    exp_rd_valid                          : out std_ulogic;
    exp_rd_address                        : out std_ulogic_vector(31 downto 0);
    exp_rd_data                           : in  std_ulogic_vector(31 downto 0);
    exp_rd_data_valid                     : in  std_ulogic;
    exp_wr_valid                          : out std_ulogic;
    exp_wr_address                        : out std_ulogic_vector(31 downto 0)
    );
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
  SIGNAL fbist_cfg_status_ip_int : std_ulogic;
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
  SIGNAL fbist_cfg_pool0_data : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_cfg_user_data_0_high : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_cfg_user_data_0_low : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_cfg_user_data_1_high : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_cfg_user_data_1_low : std_ulogic_vector(31 downto 0);
  SIGNAL fbist_cfg_chk_error_valid_n1_d : std_ulogic;
  SIGNAL fbist_cfg_chk_error_valid_n1_q : std_ulogic;
  SIGNAL fbist_cfg_chk_error_valid_n2_d : std_ulogic;
  SIGNAL fbist_cfg_chk_error_valid_n2_q : std_ulogic;

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

  fbist_cfg_status_ip_int <= fbist_cfg_status(0);
  fbist_cfg_status_ip     <= fbist_cfg_status_ip_int;

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

  fbist_cfg_error <= "0000000000000000000000000000000" & fbist_cfg_chk_error_valid_n2_q;

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
      REG_0A_WE_MASK => x"00000001",
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
      REG_24_WE_MASK => x"00000001",
      REG_25_WE_MASK => x"FFFFFFFF",
      REG_26_WE_MASK => x"FFFFFFFF",
      REG_27_WE_MASK => x"FFFFFFFF",
      REG_28_WE_MASK => x"FFFFFFFF",
      REG_29_WE_MASK => x"FFFFFFFF",

      REG_1F_HWWE_MASK => x"FFFFFFFF",
      REG_20_HWWE_MASK => x"FFFFFFFF",
      REG_21_HWWE_MASK => x"FFFFFFFF",
      REG_22_HWWE_MASK => x"FFFFFFFF",
      REG_23_HWWE_MASK => x"FFFFFFFF",
      REG_24_HWWE_MASK => x"00000001",

      REG_24_STICKY_MASK => x"00000001"
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
      reg_1F_update_i  => fbist_cfg_pool0_stats_num_reads,
      reg_20_update_i  => fbist_cfg_pool0_stats_num_writes,
      reg_21_update_i  => fbist_cfg_pool0_stats_num_read_bytes,
      reg_22_update_i  => fbist_cfg_pool0_stats_num_write_bytes,
      reg_23_update_i  => fbist_cfg_pool0_stats_run_time,
      reg_24_update_i  => fbist_cfg_error,
      reg_1F_hwwe_i    => fbist_cfg_status_ip_int,
      reg_20_hwwe_i    => fbist_cfg_status_ip_int,
      reg_21_hwwe_i    => fbist_cfg_status_ip_int,
      reg_22_hwwe_i    => fbist_cfg_status_ip_int,
      reg_23_hwwe_i    => fbist_cfg_status_ip_int,
      reg_24_hwwe_i    => fbist_cfg_chk_error_valid_n2_q,
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
      else
        fbist_cfg_chk_error_valid_n1_q <= fbist_cfg_chk_error_valid_n1_d;
        fbist_cfg_chk_error_valid_n2_q <= fbist_cfg_chk_error_valid_n2_d;
      end if;
    end if;
  end process;

end fbist_cfg;
