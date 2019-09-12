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

entity oc_host_cfg is
  port (
    ---------------------------------------------------------------------------
    -- Clocking & Power
    ---------------------------------------------------------------------------
    cclk                           : in std_ulogic;
    creset                         : in std_ulogic;

    ---------------------------------------------------------------------------
    -- Register Interface (AXI4-Lite Slave)
    ---------------------------------------------------------------------------
    oc_host_cfg0_axis_aclk         : in std_ulogic;
    oc_host_cfg0_axis_i            : in t_AXI4_LITE_SLAVE_INPUT;
    oc_host_cfg0_axis_o            : out t_AXI4_LITE_SLAVE_OUTPUT;

    ---------------------------------------------------------------------------
    -- Function
    ---------------------------------------------------------------------------
    cfg_tlx_xmit_tmpl_config       : out std_ulogic_vector(31 downto 0);
    reg_01_update_i                : in  std_ulogic_vector(31 downto 0);
    reg_01_hwwe_i                  : in  std_ulogic;
    reg_01_o                       : out std_ulogic_vector(31 downto 0);
    reg_02_update_i                : in  std_ulogic_vector(31 downto 0);
    reg_02_hwwe_i                  : in  std_ulogic;
    reg_02_o                       : out std_ulogic_vector(31 downto 0);
    reg_03_o                       : out std_ulogic_vector(31 downto 0);
    reg_04_o                       : out std_ulogic_vector(31 downto 0);
    reg_04_update_i                : in  std_ulogic_vector(31 downto 0);
    reg_04_hwwe_i                  : in  std_ulogic;
    reg_05_update_i                : in  std_ulogic_vector(31 downto 0);
    reg_05_hwwe_i                  : in  std_ulogic;
    reg_06_update_i                : in  std_ulogic_vector(31 downto 0);
    reg_06_hwwe_i                  : in  std_ulogic;
    reg_07_update_i                : in  std_ulogic_vector(31 downto 0);
    reg_07_hwwe_i                  : in  std_ulogic
    );
end oc_host_cfg;

architecture oc_host_cfg of oc_host_cfg is

begin

  host_cfg_regs : entity work.axi_regs_32
    generic map (
      REG_00_RESET       => x"00000001",
      REG_03_RESET       => x"FFFFFFF8",
      REG_04_RESET       => x"04000045",
      REG_00_WE_MASK     => x"FFFFFFFF",
      REG_01_HWWE_MASK   => x"FFFFFFF7", -- this is the interrupt logging register
      REG_02_HWWE_MASK   => x"FF90000F", -- this is the mem_cntl register
      REG_02_WE_MASK     => x"FF1FFFFF",
      REG_03_WE_MASK     => x"FFFFFFF8", -- this is the BAR
      REG_04_HWWE_MASK   => x"C3FFFF00", -- this is dlctl
      REG_04_WE_MASK     => x"FE00FF7F",
      REG_05_HWWE_MASK   => x"FFFFFFFF", -- this is edplmaxcnt0
      REG_05_WE_MASK     => x"00000000",
      REG_06_HWWE_MASK   => x"FFFFFFFF", -- this is edplmaxcnt1
      REG_06_WE_MASK     => x"00000000",
      REG_07_HWWE_MASK   => x"000000FF", -- this is edplerr
      REG_07_WE_MASK     => x"000000FF",
      REG_07_STICKY_MASK => x"000000FF"
      )

    port map (
      s0_axi_aclk       => oc_host_cfg0_axis_aclk,
      s0_axi_i          => oc_host_cfg0_axis_i,
      s0_axi_o          => oc_host_cfg0_axis_o,
      reg_00_o          => cfg_tlx_xmit_tmpl_config,
      reg_01_update_i   => reg_01_update_i,
      reg_01_hwwe_i     => reg_01_hwwe_i,
      reg_01_o          => reg_01_o,
      reg_02_update_i   => reg_02_update_i,
      reg_02_hwwe_i     => reg_02_hwwe_i,
      reg_02_o          => reg_02_o,
      reg_03_o          => reg_03_o,
      reg_04_o          => reg_04_o,
      reg_04_update_i   => reg_04_update_i,
      reg_04_hwwe_i     => reg_04_hwwe_i,
      reg_05_update_i   => reg_05_update_i,
      reg_05_hwwe_i     => reg_05_hwwe_i,
      reg_06_update_i   => reg_06_update_i,
      reg_06_hwwe_i     => reg_06_hwwe_i,
      reg_07_update_i   => reg_07_update_i,
      reg_07_hwwe_i     => reg_07_hwwe_i
      );

end oc_host_cfg;
