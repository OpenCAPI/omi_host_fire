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

entity fbist_dgen is
  port (
    sysclk    : in std_ulogic;
    sys_reset : in std_ulogic;

    agen_dgen_command         : in std_ulogic_vector(7 downto 0);
    agen_dgen_command_valid   : in std_ulogic;
    agen_dgen_command_engine  : in std_ulogic_vector(2 downto 0);
    agen_dgen_command_tag     : in std_ulogic_vector(15 downto 0);
    agen_dgen_command_address : in std_ulogic_vector(63 downto 0);

    dgen_axi_command         : out std_ulogic_vector(7 downto 0);
    dgen_axi_command_valid   : out std_ulogic;
    dgen_axi_command_engine  : out std_ulogic_vector(2 downto 0);
    dgen_axi_command_tag     : out std_ulogic_vector(15 downto 0);
    dgen_axi_command_address : out std_ulogic_vector(63 downto 0);
    dgen_axi_command_data    : out std_ulogic_vector(511 downto 0);

    fbist_freeze                 : in std_ulogic;
    fbist_cfg_addrmod0_data_mode : in std_ulogic_vector(3 downto 0);
    fbist_cfg_addrmod1_data_mode : in std_ulogic_vector(3 downto 0);
    fbist_cfg_addrmod2_data_mode : in std_ulogic_vector(3 downto 0);
    fbist_cfg_addrmod3_data_mode : in std_ulogic_vector(3 downto 0);
    fbist_cfg_addrmod4_data_mode : in std_ulogic_vector(3 downto 0);
    fbist_cfg_addrmod5_data_mode : in std_ulogic_vector(3 downto 0);
    fbist_cfg_addrmod6_data_mode : in std_ulogic_vector(3 downto 0);
    fbist_cfg_addrmod7_data_mode : in std_ulogic_vector(3 downto 0);
    fbist_cfg_user_data_0        : in std_ulogic_vector(63 downto 0);
    fbist_cfg_user_data_1        : in std_ulogic_vector(63 downto 0)
    );

  attribute BLOCK_TYPE of fbist_dgen : entity is LEAF;
  attribute BTR_NAME of fbist_dgen : entity is "FBIST_DGEN";
  attribute RECURSIVE_SYNTHESIS of fbist_dgen : entity is 2;
  attribute PIN_DATA of sysclk : signal is "PIN_FUNCTION=/G_CLK/";
end fbist_dgen;

architecture fbist_dgen of fbist_dgen is

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
  SIGNAL dgen_axi_command_valid_d : std_ulogic;
  SIGNAL dgen_axi_command_valid_q : std_ulogic;
  SIGNAL dgen_axi_command_d : std_ulogic_vector(7 downto 0);
  SIGNAL dgen_axi_command_q : std_ulogic_vector(7 downto 0);
  SIGNAL dgen_axi_command_engine_d : std_ulogic_vector(2 downto 0);
  SIGNAL dgen_axi_command_engine_q : std_ulogic_vector(2 downto 0);
  SIGNAL dgen_axi_command_tag_d : std_ulogic_vector(15 downto 0);
  SIGNAL dgen_axi_command_tag_q : std_ulogic_vector(15 downto 0);
  SIGNAL dgen_axi_command_address_d : std_ulogic_vector(63 downto 0);
  SIGNAL dgen_axi_command_address_q : std_ulogic_vector(63 downto 0);
  SIGNAL dgen_axi_command_data_d : std_ulogic_vector(511 downto 0);
  SIGNAL dgen_axi_command_data_q : std_ulogic_vector(511 downto 0);
  SIGNAL capi_data : std_ulogic_vector(63 downto 0);
  SIGNAL selected_data_strategy : std_ulogic_vector(3 downto 0);

begin

  -----------------------------------------------------------------------------
  -- Latch Inputs
  -----------------------------------------------------------------------------
  agen_dgen_command_d         <= agen_dgen_command;
  agen_dgen_command_valid_d   <= agen_dgen_command_valid;
  agen_dgen_command_engine_d  <= agen_dgen_command_engine;
  agen_dgen_command_tag_d     <= agen_dgen_command_tag;
  agen_dgen_command_address_d <= agen_dgen_command_address;

  -----------------------------------------------------------------------------
  -- Latch Outputs
  -----------------------------------------------------------------------------
  dgen_axi_command_d         <= agen_dgen_command_q;
  dgen_axi_command           <= dgen_axi_command_q;
  dgen_axi_command_valid_d   <= agen_dgen_command_valid_q;
  dgen_axi_command_valid     <= dgen_axi_command_valid_q;
  dgen_axi_command_engine_d  <= agen_dgen_command_engine_q;
  dgen_axi_command_engine    <= dgen_axi_command_engine_q;
  dgen_axi_command_tag_d     <= agen_dgen_command_tag_q;
  dgen_axi_command_tag       <= dgen_axi_command_tag_q;
  dgen_axi_command_address_d <= agen_dgen_command_address_q;
  dgen_axi_command_address   <= dgen_axi_command_address_q;
  dgen_axi_command_data_d    <= capi_data & capi_data & capi_data & capi_data &
                                capi_data & capi_data & capi_data & capi_data;
  dgen_axi_command_data      <= dgen_axi_command_data_q;

  -----------------------------------------------------------------------------
  -- Address Generation
  -----------------------------------------------------------------------------
  selected_data_strategy <= gate(fbist_cfg_addrmod0_data_mode, agen_dgen_command_address_q(8 downto 6) = "000") or
                            gate(fbist_cfg_addrmod1_data_mode, agen_dgen_command_address_q(8 downto 6) = "001") or
                            gate(fbist_cfg_addrmod2_data_mode, agen_dgen_command_address_q(8 downto 6) = "010") or
                            gate(fbist_cfg_addrmod3_data_mode, agen_dgen_command_address_q(8 downto 6) = "011") or
                            gate(fbist_cfg_addrmod4_data_mode, agen_dgen_command_address_q(8 downto 6) = "100") or
                            gate(fbist_cfg_addrmod5_data_mode, agen_dgen_command_address_q(8 downto 6) = "101") or
                            gate(fbist_cfg_addrmod6_data_mode, agen_dgen_command_address_q(8 downto 6) = "110") or
                            gate(fbist_cfg_addrmod7_data_mode, agen_dgen_command_address_q(8 downto 6) = "111");
  capi_data <= gate(agen_dgen_command_address_q, selected_data_strategy = FBIST_DATA_EQUALS_ADDRESS) or
               gate(x"0000000000000000",         selected_data_strategy = FBIST_DATA_0) or
               gate(x"FFFFFFFFFFFFFFFF",         selected_data_strategy = FBIST_DATA_F) or
               gate(x"AAAAAAAAAAAAAAAA",         selected_data_strategy = FBIST_DATA_A) or
               gate(x"CCCCCCCCCCCCCCCC",         selected_data_strategy = FBIST_DATA_C) or
               gate(x"6666666666666666",         selected_data_strategy = FBIST_DATA_6) or
               gate(x"F0F0F0F0F0F0F0F0",         selected_data_strategy = FBIST_DATA_F0) or
               gate(fbist_cfg_user_data_0,       selected_data_strategy = FBIST_DATA_USER0) or
               gate(fbist_cfg_user_data_1,       selected_data_strategy = FBIST_DATA_USER1);

  -----------------------------------------------------------------------------
  -- Latches
  -----------------------------------------------------------------------------
  process (sysclk) is
  begin
    if rising_edge(sysclk) then
      if (sys_reset = '1') then
        agen_dgen_command_q         <= x"00";
        agen_dgen_command_valid_q   <= '0';
        agen_dgen_command_engine_q  <= "000";
        agen_dgen_command_tag_q     <= x"0000";
        agen_dgen_command_address_q <= x"0000000000000000";
        dgen_axi_command_q          <= x"00";
        dgen_axi_command_valid_q    <= '0';
        dgen_axi_command_engine_q   <= "000";
        dgen_axi_command_tag_q      <= x"0000";
        dgen_axi_command_address_q  <= x"0000000000000000";
        dgen_axi_command_data_q     <= x"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
      else
        if (fbist_freeze = '0') then
          agen_dgen_command_q         <= agen_dgen_command_d;
          agen_dgen_command_valid_q   <= agen_dgen_command_valid_d;
          agen_dgen_command_engine_q  <= agen_dgen_command_engine_d;
          agen_dgen_command_tag_q     <= agen_dgen_command_tag_d;
          agen_dgen_command_address_q <= agen_dgen_command_address_d;
          dgen_axi_command_q          <= dgen_axi_command_d;
          dgen_axi_command_valid_q    <= dgen_axi_command_valid_d;
          dgen_axi_command_engine_q   <= dgen_axi_command_engine_d;
          dgen_axi_command_tag_q      <= dgen_axi_command_tag_d;
          dgen_axi_command_address_q  <= dgen_axi_command_address_d;
          dgen_axi_command_data_q     <= dgen_axi_command_data_d;
        end if;
      end if;
    end if;
  end process;
  
end fbist_dgen;
