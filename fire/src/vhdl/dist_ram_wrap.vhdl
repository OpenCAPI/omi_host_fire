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
use ibm.synthesis_support.all;
use support.logic_support_pkg.all;

entity dist_ram_wrap is
  generic (
    C_DATA_WIDTH                   : positive := 512;
    C_ADDRESS_WIDTH                : positive := 5
    );
  port (
    ---------------------------------------------------------------------------
    -- Clocking & Power
    ---------------------------------------------------------------------------
    clock                          : in  std_ulogic;
    reset                          : in  std_ulogic;

    ---------------------------------------------------------------------------
    -- Port A
    ---------------------------------------------------------------------------
    bram_addr_a                    : in  std_ulogic_vector(C_ADDRESS_WIDTH - 1 downto 0);
    bram_din_a                     : out std_ulogic_vector(C_DATA_WIDTH - 1 downto 0);
    bram_dout_a                    : in  std_ulogic_vector(C_DATA_WIDTH - 1 downto 0);
    bram_wen_a                     : in  std_ulogic_vector((C_DATA_WIDTH / 32) - 1 downto 0);

    ---------------------------------------------------------------------------
    -- Port B
    ---------------------------------------------------------------------------
    bram_addr_b                    : in  std_ulogic_vector(C_ADDRESS_WIDTH - 1 downto 0);
    bram_din_b                     : out std_ulogic_vector(C_DATA_WIDTH - 1 downto 0);
    bram_dout_b                    : in  std_ulogic_vector(C_DATA_WIDTH - 1 downto 0);
    bram_wen_b                     : in  std_ulogic_vector((C_DATA_WIDTH / 32) - 1 downto 0)
    );

  attribute BLOCK_TYPE of dist_ram_wrap : entity is LEAF;
  attribute BTR_NAME of dist_ram_wrap : entity is "DIST_RAM_WRAP";
  attribute RECURSIVE_SYNTHESIS of dist_ram_wrap : entity is 2;
  attribute PIN_DATA of clock : signal is "PIN_FUNCTION=/G_CLK/";
end dist_ram_wrap;

architecture dist_ram_wrap of dist_ram_wrap is

  constant MY_NUM_COL : natural := (C_DATA_WIDTH / 32);

  component dist_ram
    generic (
      NUM_COL    : natural;
      COL_WIDTH  : natural;
      ADDR_WIDTH : natural
      );

    port (
      clock       : in  std_ulogic;
      bram_wen_a  : in  std_ulogic_vector((C_DATA_WIDTH / 32) - 1 downto 0);
      bram_addr_a : in  std_ulogic_vector(C_ADDRESS_WIDTH - 1 downto 0);
      bram_din_a  : in  std_ulogic_vector(C_DATA_WIDTH - 1 downto 0);
      bram_dout_a : out std_ulogic_vector(C_DATA_WIDTH - 1 downto 0);
      bram_wen_b  : in  std_ulogic_vector((C_DATA_WIDTH / 32) - 1 downto 0);
      bram_addr_b : in  std_ulogic_vector(C_ADDRESS_WIDTH - 1 downto 0);
      bram_din_b  : in  std_ulogic_vector(C_DATA_WIDTH - 1 downto 0);
      bram_dout_b : out std_ulogic_vector(C_DATA_WIDTH - 1 downto 0)
      );
  end component;

begin

  dist_ram_inst : component dist_ram
    generic map (
      NUM_COL    => MY_NUM_COL,
      COL_WIDTH  => 32,
      ADDR_WIDTH => C_ADDRESS_WIDTH
      )

    -- Swizzle in/out to match conventions on both sides
    port map (
      clock       => clock,
      bram_wen_a  => bram_wen_a,
      bram_addr_a => bram_addr_a,
      bram_din_a  => bram_dout_a,
      bram_dout_a => bram_din_a,
      bram_wen_b  => bram_wen_b,
      bram_addr_b => bram_addr_b,
      bram_din_b  => bram_dout_b,
      bram_dout_b => bram_din_b
      );
  
end dist_ram_wrap;
