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
use ibm.synthesis_support.all;
use ibm.std_ulogic_support.all;
use ibm.std_ulogic_unsigned.all;
use ibm.std_ulogic_function_support.all;
use support.logic_support_pkg.all;
use work.fbist_pkg.all;

entity fbist_cgen is
  port (
    sysclk    : in std_ulogic;
    sys_reset : in std_ulogic;

    fbist_cfg_status_ip : in std_ulogic;

    cgen_agen_command        : out std_ulogic_vector(7 downto 0);
    cgen_agen_command_valid  : out std_ulogic;
    cgen_agen_command_engine : out std_ulogic_vector(2 downto 0);

    fbist_freeze              : in std_ulogic;
    fbist_cfg_engine0_command : in std_ulogic_vector(7 downto 0);
    fbist_cfg_engine1_command : in std_ulogic_vector(7 downto 0);
    fbist_cfg_engine2_command : in std_ulogic_vector(7 downto 0);
    fbist_cfg_engine3_command : in std_ulogic_vector(7 downto 0);
    fbist_cfg_engine4_command : in std_ulogic_vector(7 downto 0);
    fbist_cfg_engine5_command : in std_ulogic_vector(7 downto 0);
    fbist_cfg_engine6_command : in std_ulogic_vector(7 downto 0);
    fbist_cfg_engine7_command : in std_ulogic_vector(7 downto 0);
    fbist_cfg_spacing_count   : in std_ulogic_vector(15 downto 0);
    fbist_cfg_spacing_scheme  : in std_ulogic_vector(3 downto 0);
    fbist_cfg_arb_scheme      : in std_ulogic_vector(3 downto 0);

    fbist_cfg_stats_num_reads       : out std_ulogic_vector(47 downto 0);
    fbist_cfg_stats_num_writes      : out std_ulogic_vector(47 downto 0);
    fbist_cfg_stats_num_read_bytes  : out std_ulogic_vector(47 downto 0);
    fbist_cfg_stats_num_write_bytes : out std_ulogic_vector(47 downto 0);
    fbist_cfg_stats_run_time        : out std_ulogic_vector(47 downto 0)
    );

  attribute BLOCK_TYPE of fbist_cgen : entity is LEAF;
  attribute BTR_NAME of fbist_cgen : entity is "FBIST_CGEN";
  attribute RECURSIVE_SYNTHESIS of fbist_cgen : entity is 2;
  attribute PIN_DATA of sysclk : signal is "PIN_FUNCTION=/G_CLK/";
end fbist_cgen;

architecture fbist_cgen of fbist_cgen is

  SIGNAL command_sel_d : std_ulogic_vector(17 downto 0);
  SIGNAL command_sel_q : std_ulogic_vector(17 downto 0);
  SIGNAL next_command_sel : std_ulogic_vector(17 downto 0);
  SIGNAL selected_command : std_ulogic_vector(7 downto 0);
  SIGNAL spacing_count_d : std_ulogic_vector(17 downto 0);
  SIGNAL spacing_count_q : std_ulogic_vector(17 downto 0);
  SIGNAL count_zero : std_ulogic;
  SIGNAL cgen_agen_command_valid_d : std_ulogic;
  SIGNAL cgen_agen_command_valid_q : std_ulogic;
  SIGNAL cgen_agen_command_d : std_ulogic_vector(7 downto 0);
  SIGNAL cgen_agen_command_q : std_ulogic_vector(7 downto 0);
  SIGNAL cgen_agen_command_engine_d : std_ulogic_vector(2 downto 0);
  SIGNAL cgen_agen_command_engine_q : std_ulogic_vector(2 downto 0);
  SIGNAL stats_num_reads_d : std_ulogic_vector(47 downto 0);
  SIGNAL stats_num_reads_q : std_ulogic_vector(47 downto 0);
  SIGNAL stats_num_writes_d : std_ulogic_vector(47 downto 0);
  SIGNAL stats_num_writes_q : std_ulogic_vector(47 downto 0);
  SIGNAL stats_num_read_bytes_d : std_ulogic_vector(47 downto 0);
  SIGNAL stats_num_read_bytes_q : std_ulogic_vector(47 downto 0);
  SIGNAL stats_num_write_bytes_d : std_ulogic_vector(47 downto 0);
  SIGNAL stats_num_write_bytes_q : std_ulogic_vector(47 downto 0);
  SIGNAL stats_run_time_d : std_ulogic_vector(47 downto 0);
  SIGNAL stats_run_time_q : std_ulogic_vector(47 downto 0);
  SIGNAL second_beat_write_data_d : std_ulogic;
  SIGNAL second_beat_write_data_q : std_ulogic;
  SIGNAL next_command : std_ulogic;

begin

  -----------------------------------------------------------------------------
  -- Latch Outputs
  -----------------------------------------------------------------------------
  cgen_agen_command_d        <= selected_command;
  cgen_agen_command          <= cgen_agen_command_q;
  cgen_agen_command_valid_d  <= count_zero or second_beat_write_data_q;
  cgen_agen_command_valid    <= cgen_agen_command_valid_q;
  cgen_agen_command_engine_d <= command_sel_q(2 downto 0);
  cgen_agen_command_engine   <= cgen_agen_command_engine_q;

  -----------------------------------------------------------------------------
  -- Command Arbitration
  -----------------------------------------------------------------------------
  -- Throttle getting a new command until the spacing expires. We only
  -- use 3 bits of this signal for actually selecting a command, but
  -- we store more just to have the info for the LFSR if we use it.
  command_sel_d(17 downto 0) <= gate("000000000000000000",                                not fbist_cfg_status_ip) or
                                gate(command_sel_q(17 downto 0),    not next_command and     fbist_cfg_status_ip) or
                                gate(next_command_sel(17 downto 0),     next_command and     fbist_cfg_status_ip);

  next_command_sel <= gate("000000000000000" & command_sel_q(2 downto 0) + 1,         fbist_cfg_arb_scheme = FBIST_ARB_ROUND_ROBIN) or
                      gate("000000000000" & lfsr_6_next(command_sel_q(5 downto 0)),   fbist_cfg_arb_scheme = FBIST_ARB_LFSR_6) or
                      gate(lfsr_18_next(command_sel_q(17 downto 0)),                  fbist_cfg_arb_scheme = FBIST_ARB_LFSR_18);

  selected_command <= gate(FBIST_COMMAND_WRITE_128_SECOND_DATA,     second_beat_write_data_q                                       ) or
                      gate(fbist_cfg_engine0_command,           not second_beat_write_data_q and command_sel_q(2 downto 0) = "000") or
                      gate(fbist_cfg_engine1_command,           not second_beat_write_data_q and command_sel_q(2 downto 0) = "001") or
                      gate(fbist_cfg_engine2_command,           not second_beat_write_data_q and command_sel_q(2 downto 0) = "010") or
                      gate(fbist_cfg_engine3_command,           not second_beat_write_data_q and command_sel_q(2 downto 0) = "011") or
                      gate(fbist_cfg_engine4_command,           not second_beat_write_data_q and command_sel_q(2 downto 0) = "100") or
                      gate(fbist_cfg_engine5_command,           not second_beat_write_data_q and command_sel_q(2 downto 0) = "101") or
                      gate(fbist_cfg_engine6_command,           not second_beat_write_data_q and command_sel_q(2 downto 0) = "110") or
                      gate(fbist_cfg_engine7_command,           not second_beat_write_data_q and command_sel_q(2 downto 0) = "111");

  -----------------------------------------------------------------------------
  -- Command Spacing
  -----------------------------------------------------------------------------
  -- This "count" register is a bit misleading. It is a counter in
  -- FIXED mode, but it double purposes as an LFSR in LFSR mode. Count
  -- when we're running a test. When we're not running, hold the reset
  -- value.
  spacing_count_d(17 downto 0) <= gate("00" & fbist_cfg_spacing_count(15 downto 0),                                                      not fbist_cfg_status_ip                                           ) or
                                  gate(spacing_count_q(17 downto 0),                                                                         fbist_cfg_status_ip and     count_zero and not next_command) or
                                  gate("00" & fbist_cfg_spacing_count(15 downto 0), fbist_cfg_spacing_scheme = FBIST_SPACING_FIXED   and     fbist_cfg_status_ip and     count_zero and     next_command) or
                                  gate(spacing_count_q(17 downto 0) - 1,            fbist_cfg_spacing_scheme = FBIST_SPACING_FIXED   and     fbist_cfg_status_ip and not count_zero                     ) or
                                  gate(lfsr_18_next(spacing_count_q(17 downto 0)),  fbist_cfg_spacing_scheme = FBIST_SPACING_LFSR_18 and     fbist_cfg_status_ip                                           );

  -- When we send a 128 byte write, we add a command immediately after
  -- as a spot to add the data downstream. We pause the command select
  -- and the counter for this cycle. This means that count_zero is
  -- high for 2 cycles at this point, but next_command is only high
  -- for 1 cycle (either the only cycle or the second cycle of
  -- count_zero being high).
  second_beat_write_data_d <= count_zero and selected_command = FBIST_COMMAND_WRITE_128;
  next_command             <= (count_zero and not (selected_command = FBIST_COMMAND_WRITE_128)) or
                              (second_beat_write_data_q);

  -- For FIXED mode, when we reach 0, we've waited long enough, so
  -- send a new command. For LFSR_18 mode, send a new command when a
  -- configurable number of bits match.
  count_zero <= ((fbist_cfg_spacing_scheme = FBIST_SPACING_FIXED and (spacing_count_q(15 downto 0) = x"0000")) or
                 (fbist_cfg_spacing_scheme = FBIST_SPACING_LFSR_18 and ((fbist_cfg_spacing_count(2 downto 0) = "000" and spacing_count_q(0 downto 0) = "1") or
                                                                        (fbist_cfg_spacing_count(2 downto 0) = "001" and spacing_count_q(1 downto 0) = "11") or
                                                                        (fbist_cfg_spacing_count(2 downto 0) = "010" and spacing_count_q(2 downto 0) = "111") or
                                                                        (fbist_cfg_spacing_count(2 downto 0) = "011" and spacing_count_q(3 downto 0) = "1111") or
                                                                        (fbist_cfg_spacing_count(2 downto 0) = "100" and spacing_count_q(4 downto 0) = "11111") or
                                                                        (fbist_cfg_spacing_count(2 downto 0) = "101" and spacing_count_q(5 downto 0) = "111111") or
                                                                        (fbist_cfg_spacing_count(2 downto 0) = "110" and spacing_count_q(6 downto 0) = "1111111") or
                                                                        (fbist_cfg_spacing_count(2 downto 0) = "111" and spacing_count_q(7 downto 0) = "11111111")
                                                                        )
                  )
                 ) and fbist_cfg_status_ip;

  -----------------------------------------------------------------------------
  -- Command Counting
  -----------------------------------------------------------------------------
  fbist_cfg_stats_num_reads       <= stats_num_reads_q;
  fbist_cfg_stats_num_writes      <= stats_num_writes_q;
  fbist_cfg_stats_num_read_bytes  <= stats_num_read_bytes_q;
  fbist_cfg_stats_num_write_bytes <= stats_num_write_bytes_q;
  fbist_cfg_stats_run_time        <= stats_run_time_q;

  stats_num_reads_d  <= x"000000000000"        when fbist_cfg_status_ip = '0' else
                        stats_num_reads_q + 1  when (cgen_agen_command_valid_q and not fbist_freeze and (cgen_agen_command_q = FBIST_COMMAND_READ_128 or
                                                                                                         cgen_agen_command_q = FBIST_COMMAND_READ_64 or
                                                                                                         cgen_agen_command_q = FBIST_COMMAND_READ_32)) = '1' else
                        stats_num_reads_q;
  stats_num_writes_d <= x"000000000000"        when fbist_cfg_status_ip = '0' else
                        stats_num_writes_q + 1 when (cgen_agen_command_valid_q and not fbist_freeze and (cgen_agen_command_q = FBIST_COMMAND_WRITE_128 or
                                                                                                         cgen_agen_command_q = FBIST_COMMAND_WRITE_64 or
                                                                                                         cgen_agen_command_q = FBIST_COMMAND_WRITE_32)) = '1' else
                        stats_num_writes_q;

  stats_num_read_bytes_d  <= x"000000000000"             when fbist_cfg_status_ip = '0' else
                             stats_num_read_bytes_q + 4  when (cgen_agen_command_valid_q and not fbist_freeze and cgen_agen_command_q = FBIST_COMMAND_READ_128) = '1' else
                             stats_num_read_bytes_q + 2  when (cgen_agen_command_valid_q and not fbist_freeze and cgen_agen_command_q = FBIST_COMMAND_READ_64) = '1' else
                             stats_num_read_bytes_q + 1  when (cgen_agen_command_valid_q and not fbist_freeze and cgen_agen_command_q = FBIST_COMMAND_READ_32) = '1' else
                             stats_num_read_bytes_q;
  stats_num_write_bytes_d <= x"000000000000"             when fbist_cfg_status_ip = '0' else
                             stats_num_write_bytes_q + 4 when (cgen_agen_command_valid_q and not fbist_freeze and cgen_agen_command_q = FBIST_COMMAND_WRITE_128) = '1' else
                             stats_num_write_bytes_q + 2 when (cgen_agen_command_valid_q and not fbist_freeze and cgen_agen_command_q = FBIST_COMMAND_WRITE_64) = '1' else
                             stats_num_write_bytes_q + 1 when (cgen_agen_command_valid_q and not fbist_freeze and cgen_agen_command_q = FBIST_COMMAND_WRITE_32) = '1' else
                             stats_num_write_bytes_q;

  stats_run_time_d <= stats_run_time_q + 1 when fbist_cfg_status_ip = '1' else
                      x"000000000000";

  -----------------------------------------------------------------------------
  -- Latches
  -----------------------------------------------------------------------------
  process (sysclk) is
  begin
    if rising_edge(sysclk) then
      if (sys_reset = '1') then
        command_sel_q                <= "000000000000000000";
        cgen_agen_command_q          <= x"00";
        spacing_count_q              <= "00" & x"0000";
        cgen_agen_command_valid_q    <= '0';
        cgen_agen_command_engine_q   <= "000";
        stats_num_reads_q            <= x"000000000000";
        stats_num_writes_q           <= x"000000000000";
        stats_num_read_bytes_q       <= x"000000000000";
        stats_num_write_bytes_q      <= x"000000000000";
        stats_run_time_q             <= x"000000000000";
        second_beat_write_data_q     <= '0';
      else
        if (fbist_freeze = '0') then
          command_sel_q              <= command_sel_d;
          cgen_agen_command_q        <= cgen_agen_command_d;
          spacing_count_q            <= spacing_count_d;
          cgen_agen_command_valid_q  <= cgen_agen_command_valid_d;
          cgen_agen_command_engine_q <= cgen_agen_command_engine_d;
          second_beat_write_data_q   <= second_beat_write_data_d;
        end if;
        -- These 5 stat registers are purposely not gated by
        -- fbist_freeze. We want them always counting.
        stats_num_reads_q            <= stats_num_reads_d;
        stats_num_writes_q           <= stats_num_writes_d;
        stats_num_read_bytes_q       <= stats_num_read_bytes_d;
        stats_num_write_bytes_q      <= stats_num_write_bytes_d;
        stats_run_time_q             <= stats_run_time_d;
      end if;
    end if;
  end process;

end fbist_cgen;
