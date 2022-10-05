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

entity c3s_staging is
  generic (
    C_STAGING_CYCLES               : positive range 1 to 7 := 2
    );
  port (
    ---------------------------------------------------------------------------
    -- Clocking & Power
    ---------------------------------------------------------------------------
    cclk                           : in std_ulogic;
    creset                         : in std_ulogic;

    ---------------------------------------------------------------------------
    -- Functional Interface
    ---------------------------------------------------------------------------
    c3s_tl_gate_bit_stg_in         : in std_ulogic;
    c3s_tl_gate_bit_stg_out         : OUT std_ulogic;
    c3s_command_stg_in             : in std_ulogic_vector(511 downto 0);
    c3s_command_valid_stg_in       : in std_ulogic;
    c3s_command_sel_stg_in         : in std_ulogic;
    c3s_command_stg_out            : out std_ulogic_vector(511 downto 0);
    c3s_command_valid_stg_out      : out std_ulogic;
    c3s_command_sel_stg_out        : out std_ulogic;
    c3s_response_stg_in            : in std_ulogic_vector(511 downto 0);
    c3s_response_valid_stg_in      : in std_ulogic;
    c3s_response_stg_out           : out std_ulogic_vector(511 downto 0);
    c3s_response_valid_stg_out     : out std_ulogic
    );

  attribute BLOCK_TYPE of c3s_staging : entity is SUPERRLM;
  attribute BTR_NAME of c3s_staging : entity is "C3S_STAGING";
  attribute RECURSIVE_SYNTHESIS of c3s_staging : entity is 2;
  attribute PIN_DATA of cclk : signal is "PIN_FUNCTION=/G_CLK/";
end c3s_staging;

architecture c3s_staging of c3s_staging is

  type reg_array_512 is array(C_STAGING_CYCLES - 1 downto 0) of std_ulogic_vector(511 downto 0);

  signal command_reg_d        : reg_array_512;
  signal command_reg_q        : reg_array_512;
  signal command_valid_reg_d  : std_ulogic_vector(C_STAGING_CYCLES - 1 downto 0);
  signal command_valid_reg_q  : std_ulogic_vector(C_STAGING_CYCLES - 1 downto 0);
  signal command_sel_reg_d    : std_ulogic_vector(C_STAGING_CYCLES - 1 downto 0);
  signal command_sel_reg_q    : std_ulogic_vector(C_STAGING_CYCLES - 1 downto 0);
  signal c3s_tl_gate_reg_d    : std_ulogic_vector(C_STAGING_CYCLES - 1 downto 0);
  signal c3s_tl_gate_reg_q    : std_ulogic_vector(C_STAGING_CYCLES - 1 downto 0);
  signal response_reg_d       : reg_array_512;
  signal response_reg_q       : reg_array_512;
  signal response_valid_reg_d : std_ulogic_vector(C_STAGING_CYCLES - 1 downto 0);
  signal response_valid_reg_q : std_ulogic_vector(C_STAGING_CYCLES - 1 downto 0);

begin

  command_reg_d(0)        <= c3s_command_stg_in;
  command_valid_reg_d(0)  <= c3s_command_valid_stg_in;
  command_sel_reg_d(0)    <= c3s_command_sel_stg_in;
  c3s_tl_gate_reg_d(0)    <= c3s_tl_gate_bit_stg_in;
  response_reg_d(0)       <= c3s_response_stg_in;
  response_valid_reg_d(0) <= c3s_response_valid_stg_in;

  reg_gen : for i in 1 to C_STAGING_CYCLES - 1 generate
    command_reg_d(i)        <= command_reg_q(i - 1);
    command_valid_reg_d(i)  <= command_valid_reg_q(i - 1);
    command_sel_reg_d(i)    <= command_sel_reg_q(i - 1);
    response_reg_d(i)       <= response_reg_q(i - 1);
    response_valid_reg_d(i) <= response_valid_reg_q(i - 1);
    c3s_tl_gate_reg_d(i)    <= c3s_tl_gate_reg_q(i - 1);
  end generate;

  c3s_command_stg_out        <= command_reg_q(C_STAGING_CYCLES - 1);
  c3s_command_valid_stg_out  <= command_valid_reg_q(C_STAGING_CYCLES - 1);
  c3s_command_sel_stg_out    <= command_sel_reg_q(C_STAGING_CYCLES - 1);
  c3s_response_stg_out       <= response_reg_q(C_STAGING_CYCLES - 1);
  c3s_response_valid_stg_out <= response_valid_reg_q(C_STAGING_CYCLES - 1);
  c3s_tl_gate_bit_stg_out    <= c3s_tl_gate_reg_q(C_STAGING_CYCLES - 1);

  
  process (cclk) is
  begin
    if rising_edge(cclk) then
      if (creset = '1') then
        command_valid_reg_q  <= (others => '0');
        command_sel_reg_q    <= (others => '0');
        response_valid_reg_q <= (others => '0');
        c3s_tl_gate_reg_q    <= (others => '0');
      else
        command_valid_reg_q  <= command_valid_reg_d;
        command_sel_reg_q    <= command_sel_reg_d;
        response_valid_reg_q <= response_valid_reg_d;
        c3s_tl_gate_reg_q    <= c3s_tl_gate_reg_d;
      end if;
      command_reg_q <= command_reg_d;
      response_reg_q <= response_reg_d;
    end if;
  end process;

end c3s_staging;
