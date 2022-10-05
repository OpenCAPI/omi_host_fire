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
use ibm.std_ulogic_support.all;
use ibm.std_ulogic_unsigned.all;
use ibm.std_ulogic_function_support.all;
use support.logic_support_pkg.all;
use work.fbist_pkg.all;

entity fbist_agen is
  port (
    sysclk    : in std_ulogic;
    sys_reset : in std_ulogic;

    fbist_cfg_status_ip : in std_ulogic;

    cgen_agen_command        : in std_ulogic_vector(7 downto 0);
    cgen_agen_command_valid  : in std_ulogic;
    cgen_agen_command_engine : in std_ulogic_vector(2 downto 0);

    agen_dgen_command         : out std_ulogic_vector(7 downto 0);
    agen_dgen_command_valid   : out std_ulogic;
    agen_dgen_command_engine  : out std_ulogic_vector(2 downto 0);
    agen_dgen_command_tag     : out std_ulogic_vector(15 downto 0);
    agen_dgen_command_address : out std_ulogic_vector(63 downto 0);
 
    fbist_chk_outstanding_tags_valid : in  std_ulogic_vector(127 downto 0);
    chk_lut_full_gate                : out std_ulogic;

    fbist_freeze                    : in std_ulogic;
    fbist_cfg_engine0_address_mode  : in std_ulogic_vector(7 downto 0);
    fbist_cfg_engine1_address_mode  : in std_ulogic_vector(7 downto 0);
    fbist_cfg_engine2_address_mode  : in std_ulogic_vector(7 downto 0);
    fbist_cfg_engine3_address_mode  : in std_ulogic_vector(7 downto 0);
    fbist_cfg_engine4_address_mode  : in std_ulogic_vector(7 downto 0);
    fbist_cfg_engine5_address_mode  : in std_ulogic_vector(7 downto 0);
    fbist_cfg_engine6_address_mode  : in std_ulogic_vector(7 downto 0);
    fbist_cfg_engine7_address_mode  : in std_ulogic_vector(7 downto 0);
    fbist_cfg_engine0_address_start : in std_ulogic_vector(63 downto 0);
    fbist_cfg_engine1_address_start : in std_ulogic_vector(63 downto 0);
    fbist_cfg_engine2_address_start : in std_ulogic_vector(63 downto 0);
    fbist_cfg_engine3_address_start : in std_ulogic_vector(63 downto 0);
    fbist_cfg_engine4_address_start : in std_ulogic_vector(63 downto 0);
    fbist_cfg_engine5_address_start : in std_ulogic_vector(63 downto 0);
    fbist_cfg_engine6_address_start : in std_ulogic_vector(63 downto 0);
    fbist_cfg_engine7_address_start : in std_ulogic_vector(63 downto 0);
    fbist_cfg_address_and_mask      : in std_ulogic_vector(63 downto 0);
    fbist_cfg_address_or_mask       : in std_ulogic_vector(63 downto 0)
    );

  attribute BLOCK_TYPE of fbist_agen : entity is LEAF;
  attribute BTR_NAME of fbist_agen : entity is "FBIST_AGEN";
  attribute RECURSIVE_SYNTHESIS of fbist_agen : entity is 2;
  attribute PIN_DATA of sysclk : signal is "PIN_FUNCTION=/G_CLK/";
end fbist_agen;

architecture fbist_agen of fbist_agen is

  SIGNAL cgen_agen_command_valid_d : std_ulogic;
  SIGNAL cgen_agen_command_valid_q : std_ulogic;
  SIGNAL cgen_agen_command_d : std_ulogic_vector(7 downto 0);
  SIGNAL cgen_agen_command_q : std_ulogic_vector(7 downto 0);
  SIGNAL cgen_agen_command_engine_d : std_ulogic_vector(2 downto 0);
  SIGNAL cgen_agen_command_engine_q : std_ulogic_vector(2 downto 0);
  SIGNAL agen_dgen_command_valid_d : std_ulogic;
  SIGNAL agen_dgen_command_valid_q : std_ulogic;
  SIGNAL agen_dgen_command_d : std_ulogic_vector(7 downto 0);
  SIGNAL agen_dgen_command_q : std_ulogic_vector(7 downto 0);
  SIGNAL agen_dgen_command_engine_d : std_ulogic_vector(2 downto 0);
  SIGNAL agen_dgen_command_engine_q : std_ulogic_vector(2 downto 0);
  SIGNAL agen_dgen_command_tag_d : std_ulogic_vector(15 downto 0);
  SIGNAL agen_dgen_command_tag_q : std_ulogic_vector(15 downto 0);
  SIGNAL agen_dgen_command_address_d : std_ulogic_vector(63 downto 0);
  SIGNAL agen_dgen_command_address_q : std_ulogic_vector(63 downto 0);
  SIGNAL capi_tag_d : std_ulogic_vector(15 downto 0);
  SIGNAL capi_tag_q : std_ulogic_vector(15 downto 0);
  SIGNAL capi_address_0_d : std_ulogic_vector(63 downto 0);
  SIGNAL capi_address_0_q : std_ulogic_vector(63 downto 0);
  SIGNAL capi_address_1_d : std_ulogic_vector(63 downto 0);
  SIGNAL capi_address_1_q : std_ulogic_vector(63 downto 0);
  SIGNAL capi_address_2_d : std_ulogic_vector(63 downto 0);
  SIGNAL capi_address_2_q : std_ulogic_vector(63 downto 0);
  SIGNAL capi_address_3_d : std_ulogic_vector(63 downto 0);
  SIGNAL capi_address_3_q : std_ulogic_vector(63 downto 0);
  SIGNAL capi_address_4_d : std_ulogic_vector(63 downto 0);
  SIGNAL capi_address_4_q : std_ulogic_vector(63 downto 0);
  SIGNAL capi_address_5_d : std_ulogic_vector(63 downto 0);
  SIGNAL capi_address_5_q : std_ulogic_vector(63 downto 0);
  SIGNAL capi_address_6_d : std_ulogic_vector(63 downto 0);
  SIGNAL capi_address_6_q : std_ulogic_vector(63 downto 0);
  SIGNAL capi_address_7_d : std_ulogic_vector(63 downto 0);
  SIGNAL capi_address_7_q : std_ulogic_vector(63 downto 0);
  SIGNAL capi_address_0_new_lfsr : std_ulogic_vector(41 downto 0);
  SIGNAL capi_address_1_new_lfsr : std_ulogic_vector(41 downto 0);
  SIGNAL capi_address_2_new_lfsr : std_ulogic_vector(41 downto 0);
  SIGNAL capi_address_3_new_lfsr : std_ulogic_vector(41 downto 0);
  SIGNAL capi_address_4_new_lfsr : std_ulogic_vector(41 downto 0);
  SIGNAL capi_address_5_new_lfsr : std_ulogic_vector(41 downto 0);
  SIGNAL capi_address_6_new_lfsr : std_ulogic_vector(41 downto 0);
  SIGNAL capi_address_7_new_lfsr : std_ulogic_vector(41 downto 0);
  SIGNAL capi_address_sel : std_ulogic_vector(63 downto 0);
  SIGNAL addr_incr_amount : std_ulogic_vector(63 downto 0);
  SIGNAL address_alignment_mask : std_ulogic_vector(63 downto 0);

begin

  -----------------------------------------------------------------------------
  -- Latch Inputs
  -----------------------------------------------------------------------------
  cgen_agen_command_d        <= cgen_agen_command;
  cgen_agen_command_valid_d  <= cgen_agen_command_valid;
  cgen_agen_command_engine_d <= cgen_agen_command_engine;

  -----------------------------------------------------------------------------
  -- Latch Outputs
  -----------------------------------------------------------------------------
  agen_dgen_command_d         <= cgen_agen_command_q;
  agen_dgen_command           <= agen_dgen_command_q;
  agen_dgen_command_valid_d   <= cgen_agen_command_valid_q;
  agen_dgen_command_valid     <= agen_dgen_command_valid_q;
  agen_dgen_command_engine_d  <= cgen_agen_command_engine_q;
  agen_dgen_command_engine    <= agen_dgen_command_engine_q;
  agen_dgen_command_tag_d     <= capi_tag_q;
  agen_dgen_command_tag       <= agen_dgen_command_tag_q;
  agen_dgen_command_address_d <= gate(capi_address_sel,                                  cgen_agen_command_q /= FBIST_COMMAND_WRITE_128_SECOND_DATA) or
                                 gate(agen_dgen_command_address_q + x"0000000000000040", cgen_agen_command_q  = FBIST_COMMAND_WRITE_128_SECOND_DATA);
                                 -- For the second cycle of a 128B write operation, increment the
                                 -- address as if it's a 64B operation. This allows the data to be
                                 -- generated as if it is 2 64B ops.
  agen_dgen_command_address   <= agen_dgen_command_address_q;

  -----------------------------------------------------------------------------
  -- Address Generation
  -----------------------------------------------------------------------------
  -- For FBIST_COMMAND_WRITE_128_SECOND_DATA commands, hold the old
  -- address. We add in the correct offset at the output stage. We
  -- don't want to store it in the capi_address_*_q register because
  -- that would change the order of addresses being generated in LFSR
  -- mode, which we'd prefer not to do.

  -- Incremement the address for each new command. When we increment,
  -- we roll over to all 64 bits, even though we'd never use 64 bits
  -- of memory. The higher bits are masked off by default anyways.
  addr_incr_amount <= gate(x"0000000000000080", cgen_agen_command_q = FBIST_COMMAND_WRITE_128 or cgen_agen_command_q = FBIST_COMMAND_READ_128) or
                      gate(x"0000000000000040", cgen_agen_command_q = FBIST_COMMAND_WRITE_64 or cgen_agen_command_q = FBIST_COMMAND_READ_64) or
                      gate(x"0000000000000020", cgen_agen_command_q = FBIST_COMMAND_WRITE_32 or cgen_agen_command_q = FBIST_COMMAND_READ_32) or
                      gate(x"0000000000000000", cgen_agen_command_q = FBIST_COMMAND_WRITE_128_SECOND_DATA);

  -- Generate the next value for the LFSR, including 0. Only 42 bits
  -- come from the LFSR, because a 64-bit LFSR would be insane. 42 bit
  -- was chosen to fill up the entire address space, plus a bit of
  -- overhead to expand.
  capi_address_0_new_lfsr <= gate(lfsr_42_next(capi_address_0_q(41 downto 0)), cgen_agen_command_q /= FBIST_COMMAND_WRITE_128_SECOND_DATA) or
                             gate(             capi_address_0_q(41 downto 0) , cgen_agen_command_q  = FBIST_COMMAND_WRITE_128_SECOND_DATA);
  capi_address_1_new_lfsr <= gate(lfsr_42_next(capi_address_1_q(41 downto 0)), cgen_agen_command_q /= FBIST_COMMAND_WRITE_128_SECOND_DATA) or
                             gate(             capi_address_1_q(41 downto 0) , cgen_agen_command_q  = FBIST_COMMAND_WRITE_128_SECOND_DATA);
  capi_address_2_new_lfsr <= gate(lfsr_42_next(capi_address_2_q(41 downto 0)), cgen_agen_command_q /= FBIST_COMMAND_WRITE_128_SECOND_DATA) or
                             gate(             capi_address_2_q(41 downto 0) , cgen_agen_command_q  = FBIST_COMMAND_WRITE_128_SECOND_DATA);
  capi_address_3_new_lfsr <= gate(lfsr_42_next(capi_address_3_q(41 downto 0)), cgen_agen_command_q /= FBIST_COMMAND_WRITE_128_SECOND_DATA) or
                             gate(             capi_address_3_q(41 downto 0) , cgen_agen_command_q  = FBIST_COMMAND_WRITE_128_SECOND_DATA);
  capi_address_4_new_lfsr <= gate(lfsr_42_next(capi_address_4_q(41 downto 0)), cgen_agen_command_q /= FBIST_COMMAND_WRITE_128_SECOND_DATA) or
                             gate(             capi_address_4_q(41 downto 0) , cgen_agen_command_q  = FBIST_COMMAND_WRITE_128_SECOND_DATA);
  capi_address_5_new_lfsr <= gate(lfsr_42_next(capi_address_5_q(41 downto 0)), cgen_agen_command_q /= FBIST_COMMAND_WRITE_128_SECOND_DATA) or
                             gate(             capi_address_5_q(41 downto 0) , cgen_agen_command_q  = FBIST_COMMAND_WRITE_128_SECOND_DATA);
  capi_address_6_new_lfsr <= gate(lfsr_42_next(capi_address_6_q(41 downto 0)), cgen_agen_command_q /= FBIST_COMMAND_WRITE_128_SECOND_DATA) or
                             gate(             capi_address_6_q(41 downto 0) , cgen_agen_command_q  = FBIST_COMMAND_WRITE_128_SECOND_DATA);
  capi_address_7_new_lfsr <= gate(lfsr_42_next(capi_address_7_q(41 downto 0)), cgen_agen_command_q /= FBIST_COMMAND_WRITE_128_SECOND_DATA) or
                             gate(             capi_address_7_q(41 downto 0) , cgen_agen_command_q  = FBIST_COMMAND_WRITE_128_SECOND_DATA);

  -- Store the new address that will be next time for this engine.
  capi_address_0_d <= gate(fbist_cfg_engine0_address_start,                                                                                                                                                  not fbist_cfg_status_ip) or
                      gate(capi_address_0_q,                          not (cgen_agen_command_engine_q = "000" and cgen_agen_command_valid_q) and                                                                 fbist_cfg_status_ip) or
                      gate(capi_address_0_q,                              (cgen_agen_command_engine_q = "000" and cgen_agen_command_valid_q) and fbist_cfg_engine0_address_mode = FBIST_ADDRESS_CONSTANT and     fbist_cfg_status_ip) or
                      gate(capi_address_0_q + addr_incr_amount,           (cgen_agen_command_engine_q = "000" and cgen_agen_command_valid_q) and fbist_cfg_engine0_address_mode = FBIST_ADDRESS_INCR     and     fbist_cfg_status_ip) or
                      gate(capi_address_0_q - addr_incr_amount,           (cgen_agen_command_engine_q = "000" and cgen_agen_command_valid_q) and fbist_cfg_engine0_address_mode = FBIST_ADDRESS_DECR     and     fbist_cfg_status_ip) or
                      gate(x"00000" & "00" & capi_address_0_new_lfsr,     (cgen_agen_command_engine_q = "000" and cgen_agen_command_valid_q) and fbist_cfg_engine0_address_mode = FBIST_ADDRESS_LFSR     and     fbist_cfg_status_ip);

  capi_address_1_d <= gate(fbist_cfg_engine1_address_start,                                                                                                                                                  not fbist_cfg_status_ip) or
                      gate(capi_address_1_q,                          not (cgen_agen_command_engine_q = "001" and cgen_agen_command_valid_q) and                                                                 fbist_cfg_status_ip) or
                      gate(capi_address_1_q,                              (cgen_agen_command_engine_q = "001" and cgen_agen_command_valid_q) and fbist_cfg_engine1_address_mode = FBIST_ADDRESS_CONSTANT and     fbist_cfg_status_ip) or
                      gate(capi_address_1_q + addr_incr_amount,           (cgen_agen_command_engine_q = "001" and cgen_agen_command_valid_q) and fbist_cfg_engine1_address_mode = FBIST_ADDRESS_INCR     and     fbist_cfg_status_ip) or
                      gate(capi_address_1_q - addr_incr_amount,           (cgen_agen_command_engine_q = "001" and cgen_agen_command_valid_q) and fbist_cfg_engine1_address_mode = FBIST_ADDRESS_DECR     and     fbist_cfg_status_ip) or
                      gate(x"00000" & "00" & capi_address_1_new_lfsr,     (cgen_agen_command_engine_q = "001" and cgen_agen_command_valid_q) and fbist_cfg_engine1_address_mode = FBIST_ADDRESS_LFSR     and     fbist_cfg_status_ip);

  capi_address_2_d <= gate(fbist_cfg_engine2_address_start,                                                                                                                                                  not fbist_cfg_status_ip) or
                      gate(capi_address_2_q,                          not (cgen_agen_command_engine_q = "010" and cgen_agen_command_valid_q) and                                                                 fbist_cfg_status_ip) or
                      gate(capi_address_2_q,                              (cgen_agen_command_engine_q = "010" and cgen_agen_command_valid_q) and fbist_cfg_engine2_address_mode = FBIST_ADDRESS_CONSTANT and     fbist_cfg_status_ip) or
                      gate(capi_address_2_q + addr_incr_amount,           (cgen_agen_command_engine_q = "010" and cgen_agen_command_valid_q) and fbist_cfg_engine2_address_mode = FBIST_ADDRESS_INCR     and     fbist_cfg_status_ip) or
                      gate(capi_address_2_q - addr_incr_amount,           (cgen_agen_command_engine_q = "010" and cgen_agen_command_valid_q) and fbist_cfg_engine2_address_mode = FBIST_ADDRESS_DECR     and     fbist_cfg_status_ip) or
                      gate(x"00000" & "00" & capi_address_2_new_lfsr,     (cgen_agen_command_engine_q = "010" and cgen_agen_command_valid_q) and fbist_cfg_engine2_address_mode = FBIST_ADDRESS_LFSR     and     fbist_cfg_status_ip);

  capi_address_3_d <= gate(fbist_cfg_engine3_address_start,                                                                                                                                                  not fbist_cfg_status_ip) or
                      gate(capi_address_3_q,                          not (cgen_agen_command_engine_q = "011" and cgen_agen_command_valid_q) and                                                                 fbist_cfg_status_ip) or
                      gate(capi_address_3_q,                              (cgen_agen_command_engine_q = "011" and cgen_agen_command_valid_q) and fbist_cfg_engine3_address_mode = FBIST_ADDRESS_CONSTANT and     fbist_cfg_status_ip) or
                      gate(capi_address_3_q + addr_incr_amount,           (cgen_agen_command_engine_q = "011" and cgen_agen_command_valid_q) and fbist_cfg_engine3_address_mode = FBIST_ADDRESS_INCR     and     fbist_cfg_status_ip) or
                      gate(capi_address_3_q - addr_incr_amount,           (cgen_agen_command_engine_q = "011" and cgen_agen_command_valid_q) and fbist_cfg_engine3_address_mode = FBIST_ADDRESS_DECR     and     fbist_cfg_status_ip) or
                      gate(x"00000" & "00" & capi_address_3_new_lfsr,     (cgen_agen_command_engine_q = "011" and cgen_agen_command_valid_q) and fbist_cfg_engine3_address_mode = FBIST_ADDRESS_LFSR     and     fbist_cfg_status_ip);

  capi_address_4_d <= gate(fbist_cfg_engine4_address_start,                                                                                                                                                  not fbist_cfg_status_ip) or
                      gate(capi_address_4_q,                          not (cgen_agen_command_engine_q = "100" and cgen_agen_command_valid_q) and                                                                 fbist_cfg_status_ip) or
                      gate(capi_address_4_q,                              (cgen_agen_command_engine_q = "100" and cgen_agen_command_valid_q) and fbist_cfg_engine4_address_mode = FBIST_ADDRESS_CONSTANT and     fbist_cfg_status_ip) or
                      gate(capi_address_4_q + addr_incr_amount,           (cgen_agen_command_engine_q = "100" and cgen_agen_command_valid_q) and fbist_cfg_engine4_address_mode = FBIST_ADDRESS_INCR     and     fbist_cfg_status_ip) or
                      gate(capi_address_4_q - addr_incr_amount,           (cgen_agen_command_engine_q = "100" and cgen_agen_command_valid_q) and fbist_cfg_engine4_address_mode = FBIST_ADDRESS_DECR     and     fbist_cfg_status_ip) or
                      gate(x"00000" & "00" & capi_address_4_new_lfsr,     (cgen_agen_command_engine_q = "100" and cgen_agen_command_valid_q) and fbist_cfg_engine4_address_mode = FBIST_ADDRESS_LFSR     and     fbist_cfg_status_ip);

  capi_address_5_d <= gate(fbist_cfg_engine5_address_start,                                                                                                                                                  not fbist_cfg_status_ip) or
                      gate(capi_address_5_q,                          not (cgen_agen_command_engine_q = "101" and cgen_agen_command_valid_q) and                                                                 fbist_cfg_status_ip) or
                      gate(capi_address_5_q,                              (cgen_agen_command_engine_q = "101" and cgen_agen_command_valid_q) and fbist_cfg_engine5_address_mode = FBIST_ADDRESS_CONSTANT and     fbist_cfg_status_ip) or
                      gate(capi_address_5_q + addr_incr_amount,           (cgen_agen_command_engine_q = "101" and cgen_agen_command_valid_q) and fbist_cfg_engine5_address_mode = FBIST_ADDRESS_INCR     and     fbist_cfg_status_ip) or
                      gate(capi_address_5_q - addr_incr_amount,           (cgen_agen_command_engine_q = "101" and cgen_agen_command_valid_q) and fbist_cfg_engine5_address_mode = FBIST_ADDRESS_DECR     and     fbist_cfg_status_ip) or
                      gate(x"00000" & "00" & capi_address_5_new_lfsr,     (cgen_agen_command_engine_q = "101" and cgen_agen_command_valid_q) and fbist_cfg_engine5_address_mode = FBIST_ADDRESS_LFSR     and     fbist_cfg_status_ip);

  capi_address_6_d <= gate(fbist_cfg_engine6_address_start,                                                                                                                                                  not fbist_cfg_status_ip) or
                      gate(capi_address_6_q,                          not (cgen_agen_command_engine_q = "110" and cgen_agen_command_valid_q) and                                                                 fbist_cfg_status_ip) or
                      gate(capi_address_6_q,                              (cgen_agen_command_engine_q = "110" and cgen_agen_command_valid_q) and fbist_cfg_engine6_address_mode = FBIST_ADDRESS_CONSTANT and     fbist_cfg_status_ip) or
                      gate(capi_address_6_q + addr_incr_amount,           (cgen_agen_command_engine_q = "110" and cgen_agen_command_valid_q) and fbist_cfg_engine6_address_mode = FBIST_ADDRESS_INCR     and     fbist_cfg_status_ip) or
                      gate(capi_address_6_q - addr_incr_amount,           (cgen_agen_command_engine_q = "110" and cgen_agen_command_valid_q) and fbist_cfg_engine6_address_mode = FBIST_ADDRESS_DECR     and     fbist_cfg_status_ip) or
                      gate(x"00000" & "00" & capi_address_6_new_lfsr,     (cgen_agen_command_engine_q = "110" and cgen_agen_command_valid_q) and fbist_cfg_engine6_address_mode = FBIST_ADDRESS_LFSR     and     fbist_cfg_status_ip);

  capi_address_7_d <= gate(fbist_cfg_engine7_address_start,                                                                                                                                                  not fbist_cfg_status_ip) or
                      gate(capi_address_7_q,                          not (cgen_agen_command_engine_q = "111" and cgen_agen_command_valid_q) and                                                                 fbist_cfg_status_ip) or
                      gate(capi_address_7_q,                              (cgen_agen_command_engine_q = "111" and cgen_agen_command_valid_q) and fbist_cfg_engine7_address_mode = FBIST_ADDRESS_CONSTANT and     fbist_cfg_status_ip) or
                      gate(capi_address_7_q + addr_incr_amount,           (cgen_agen_command_engine_q = "111" and cgen_agen_command_valid_q) and fbist_cfg_engine7_address_mode = FBIST_ADDRESS_INCR     and     fbist_cfg_status_ip) or
                      gate(capi_address_7_q - addr_incr_amount,           (cgen_agen_command_engine_q = "111" and cgen_agen_command_valid_q) and fbist_cfg_engine7_address_mode = FBIST_ADDRESS_DECR     and     fbist_cfg_status_ip) or
                      gate(x"00000" & "00" & capi_address_7_new_lfsr,     (cgen_agen_command_engine_q = "111" and cgen_agen_command_valid_q) and fbist_cfg_engine7_address_mode = FBIST_ADDRESS_LFSR     and     fbist_cfg_status_ip);

  -- We don't want to select invalid addresses, so mask off address
  -- bits that cause non-alignment. For the second address in a 128B
  -- write, we already use the 128B mask so we're good when we add
  -- later.
  address_alignment_mask <= gate(x"FFFFFFFFFFFFFF80", cgen_agen_command_q = FBIST_COMMAND_WRITE_128 or cgen_agen_command_q = FBIST_COMMAND_READ_128) or
                            gate(x"FFFFFFFFFFFFFFC0", cgen_agen_command_q = FBIST_COMMAND_WRITE_64  or cgen_agen_command_q = FBIST_COMMAND_READ_64) or
                            gate(x"FFFFFFFFFFFFFFE0", cgen_agen_command_q = FBIST_COMMAND_WRITE_32  or cgen_agen_command_q = FBIST_COMMAND_READ_32);

  -- Select the valid address for this command engine
  capi_address_sel <= fbist_cfg_address_or_mask or
                      (fbist_cfg_address_and_mask and address_alignment_mask and
                       (gate(capi_address_0_q, cgen_agen_command_engine_q = "000") or
                        gate(capi_address_1_q, cgen_agen_command_engine_q = "001") or
                        gate(capi_address_2_q, cgen_agen_command_engine_q = "010") or
                        gate(capi_address_3_q, cgen_agen_command_engine_q = "011") or
                        gate(capi_address_4_q, cgen_agen_command_engine_q = "100") or
                        gate(capi_address_5_q, cgen_agen_command_engine_q = "101") or
                        gate(capi_address_6_q, cgen_agen_command_engine_q = "110") or
                        gate(capi_address_7_q, cgen_agen_command_engine_q = "111")
                        )
                       );

  -----------------------------------------------------------------------------
  -- Tag Generation
  -----------------------------------------------------------------------------
  -- Incremement the tag for each new command
  -- FBIST only gets the tags that start with 0
  capi_tag_d(15)          <= '0';
  capi_tag_d(14 downto 0) <= gate("000000000000000",                                                                                                            not fbist_cfg_status_ip) or
                             gate(capi_tag_q(14 downto 0),     not (cgen_agen_command_valid_q and cgen_agen_command /= FBIST_COMMAND_WRITE_128_SECOND_DATA) and     fbist_cfg_status_ip) or
                             gate(capi_tag_q(14 downto 0) + 1,     (cgen_agen_command_valid_q and cgen_agen_command /= FBIST_COMMAND_WRITE_128_SECOND_DATA) and     fbist_cfg_status_ip);

  -- Freeze the FBIST pipeline if we're about to reuse a tag. Ideally
  -- this isn't required with more tags, but this is a quick fix for
  -- an issue we're seeing.
  chk_lut_full_gate <= '1';

  -----------------------------------------------------------------------------
  -- Latches
  -----------------------------------------------------------------------------
  process (sysclk) is
  begin
    if rising_edge(sysclk) then
      if (sys_reset = '1') then
        cgen_agen_command_q           <= x"00";
        cgen_agen_command_valid_q     <= '0';
        cgen_agen_command_engine_q    <= "000";
        agen_dgen_command_q           <= x"00";
        agen_dgen_command_valid_q     <= '0';
        agen_dgen_command_engine_q    <= "000";
        agen_dgen_command_tag_q       <= x"0000";
        agen_dgen_command_address_q   <= x"0000000000000000";
        capi_tag_q                    <= x"0000";
        capi_address_0_q              <= x"0000000000000000";
        capi_address_1_q              <= x"0000000000000000";
        capi_address_2_q              <= x"0000000000000000";
        capi_address_3_q              <= x"0000000000000000";
        capi_address_4_q              <= x"0000000000000000";
        capi_address_5_q              <= x"0000000000000000";
        capi_address_6_q              <= x"0000000000000000";
        capi_address_7_q              <= x"0000000000000000";
      else
        if (fbist_freeze = '0') then
          cgen_agen_command_q         <= cgen_agen_command_d;
          cgen_agen_command_valid_q   <= cgen_agen_command_valid_d;
          cgen_agen_command_engine_q  <= cgen_agen_command_engine_d;
          agen_dgen_command_q         <= agen_dgen_command_d;
          agen_dgen_command_valid_q   <= agen_dgen_command_valid_d;
          agen_dgen_command_engine_q  <= agen_dgen_command_engine_d;
          agen_dgen_command_tag_q     <= agen_dgen_command_tag_d;
          agen_dgen_command_address_q <= agen_dgen_command_address_d;
          capi_tag_q                  <= x"0FFF" and capi_tag_d;
          capi_address_0_q            <= capi_address_0_d;
          capi_address_1_q            <= capi_address_1_d;
          capi_address_2_q            <= capi_address_2_d;
          capi_address_3_q            <= capi_address_3_d;
          capi_address_4_q            <= capi_address_4_d;
          capi_address_5_q            <= capi_address_5_d;
          capi_address_6_q            <= capi_address_6_d;
          capi_address_7_q            <= capi_address_7_d;
        end if;
      end if;
    end if;
  end process;
  
end fbist_agen;
