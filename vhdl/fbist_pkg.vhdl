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

-- LFSR Polynomials from https://www.xilinx.com/support/documentation/application_notes/xapp052.pdf

library ieee;
use ieee.std_logic_1164.all;

package fbist_pkg is

  constant FBIST_COMMAND_NOP                   : std_ulogic_vector(7 downto 0) := x"00";
  constant FBIST_COMMAND_WRITE_128             : std_ulogic_vector(7 downto 0) := x"01";
  constant FBIST_COMMAND_WRITE_64              : std_ulogic_vector(7 downto 0) := x"02";
  constant FBIST_COMMAND_WRITE_32              : std_ulogic_vector(7 downto 0) := x"03";
  constant FBIST_COMMAND_READ_128              : std_ulogic_vector(7 downto 0) := x"04";
  constant FBIST_COMMAND_READ_64               : std_ulogic_vector(7 downto 0) := x"05";
  constant FBIST_COMMAND_READ_32               : std_ulogic_vector(7 downto 0) := x"06";
  -- 0xE0 and higher reserved for internal use only
  constant FBIST_COMMAND_WRITE_128_SECOND_DATA : std_ulogic_vector(7 downto 0) := x"E0";

  constant FBIST_SPACING_FIXED   : std_ulogic_vector(3 downto 0) := x"0";
  constant FBIST_SPACING_LFSR_18 : std_ulogic_vector(3 downto 0) := x"1";

  constant FBIST_ARB_ROUND_ROBIN : std_ulogic_vector(3 downto 0) := x"0";
  constant FBIST_ARB_LFSR_6      : std_ulogic_vector(3 downto 0) := x"1";
  constant FBIST_ARB_LFSR_18     : std_ulogic_vector(3 downto 0) := x"2";

  constant FBIST_ADDRESS_CONSTANT : std_ulogic_vector(7 downto 0) := x"00";
  constant FBIST_ADDRESS_INCR     : std_ulogic_vector(7 downto 0) := x"01";
  constant FBIST_ADDRESS_DECR     : std_ulogic_vector(7 downto 0) := x"02";
  constant FBIST_ADDRESS_LFSR     : std_ulogic_vector(7 downto 0) := x"03";

  constant FBIST_DATA_EQUALS_ADDRESS : std_ulogic_vector(3 downto 0) := x"0";
  constant FBIST_DATA_0              : std_ulogic_vector(3 downto 0) := x"1";
  constant FBIST_DATA_F              : std_ulogic_vector(3 downto 0) := x"2";
  constant FBIST_DATA_A              : std_ulogic_vector(3 downto 0) := x"3";
  constant FBIST_DATA_C              : std_ulogic_vector(3 downto 0) := x"4";
  constant FBIST_DATA_6              : std_ulogic_vector(3 downto 0) := x"5";
  constant FBIST_DATA_F0             : std_ulogic_vector(3 downto 0) := x"6";
  constant FBIST_DATA_RANDOM         : std_ulogic_vector(3 downto 0) := x"7";
  constant FBIST_DATA_USER0          : std_ulogic_vector(3 downto 0) := x"8";
  constant FBIST_DATA_USER1          : std_ulogic_vector(3 downto 0) := x"9";

  constant FBIST_RESPONSE_NOP        : std_ulogic_vector(7 downto 0) := x"00";
  constant FBIST_RESPONSE_WRITE_OK   : std_ulogic_vector(7 downto 0) := x"01";
  constant FBIST_RESPONSE_WRITE_FAIL : std_ulogic_vector(7 downto 0) := x"02";
  constant FBIST_RESPONSE_READ_OK    : std_ulogic_vector(7 downto 0) := x"03";
  constant FBIST_RESPONSE_READ_FAIL  : std_ulogic_vector(7 downto 0) := x"04";

  -- We use the "first" and "last" value to inject a 0 in the stream
  -- in the logic. "first" and "last" are arbitrary sequential values.
  -- Depending on the starting value, they may not appear at the start
  -- or end of the sequence. The LAST value was chosen at random, with
  -- the FIRST value being the next one in the sequenceq.
  constant LFSR_6_LAST  : std_ulogic_vector(5 downto 0) := "010110";
  constant LFSR_6_FIRST : std_ulogic_vector(5 downto 0) := "101011";
  constant LFSR_18_LAST  : std_ulogic_vector(17 downto 0) := "00" & x"81A2";
  constant LFSR_18_FIRST : std_ulogic_vector(17 downto 0) := "01" & x"40D1";
  constant LFSR_42_LAST  : std_ulogic_vector(41 downto 0) := "00" & x"5990D4B6C4";
  constant LFSR_42_FIRST : std_ulogic_vector(41 downto 0) := "00" & x"2CC86A5B62";

  function lfsr_42_next (
    cur_lfsr : std_ulogic_vector(41 downto 0)
    ) return std_ulogic_vector;

  function lfsr_6_next (
    cur_lfsr : std_ulogic_vector(5 downto 0)
    ) return std_ulogic_vector;

  function lfsr_18_next (
    cur_lfsr : std_ulogic_vector(17 downto 0)
    ) return std_ulogic_vector;

end package fbist_pkg;

package body fbist_pkg is

  -- LFSRs shouldn't really use the entire state as the output, but we do

  -- x^6 + x^5 + 1
  function lfsr_6_next (
    cur_lfsr : std_ulogic_vector(5 downto 0)
    ) return std_ulogic_vector is
    variable next_lfsr: std_ulogic_vector(5 downto 0);

  begin
    if cur_lfsr = "000000" then
      next_lfsr := LFSR_6_FIRST;
    elsif cur_lfsr = LFSR_6_LAST then
      next_lfsr := "000000";
    else
      next_lfsr := (cur_lfsr(0) xor cur_lfsr(1))
                   & cur_lfsr(5 downto 1);
    end if;
    return next_lfsr;
  end;

  -- x^18 + x^11 + 1
  function lfsr_18_next (
    cur_lfsr : std_ulogic_vector(17 downto 0)
    ) return std_ulogic_vector is
    variable next_lfsr: std_ulogic_vector(17 downto 0);

  begin
    if cur_lfsr = "000000000000000000" then
      next_lfsr := LFSR_18_FIRST;
    elsif cur_lfsr = LFSR_18_LAST then
      next_lfsr := "000000000000000000";
    else
      next_lfsr := (cur_lfsr(0) xor cur_lfsr(7))
                   & cur_lfsr(17 downto 1);
    end if;
    return next_lfsr;
  end;

  -- x^42 + x^41 + x^20 + x^19 + 1
  function lfsr_42_next (
    cur_lfsr : std_ulogic_vector(41 downto 0)
    ) return std_ulogic_vector is
    variable next_lfsr: std_ulogic_vector(41 downto 0);

  begin
    if cur_lfsr = "00" & x"0000000000" then
      next_lfsr := LFSR_42_FIRST;
    elsif cur_lfsr = LFSR_42_LAST then
      next_lfsr := "00" & x"0000000000";
    else
      next_lfsr := (cur_lfsr(0) xor cur_lfsr(1) xor cur_lfsr(22) xor cur_lfsr(23))
                   & cur_lfsr(41 downto 1);
    end if;
    return next_lfsr;
  end;

end package body fbist_pkg;
