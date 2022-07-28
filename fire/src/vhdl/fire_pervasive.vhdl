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
use work.axi_pkg.all;

entity fire_pervasive is
  port (
    ---------------------------------------------------------------------------
    -- Clocking & Reset
    ---------------------------------------------------------------------------
    -- Raw clocks and reset from chip pin
    raw_resetn                     : in std_ulogic;
    raw_sysclk_n                   : in std_ulogic;
    raw_sysclk_p                   : in std_ulogic;

    -- Synchronized clock and reset
    sys_resetn                     : out std_ulogic;
    sysclk                         : out std_ulogic;
    cresetn_a                      : out std_ulogic;
    cresetn_b                      : out std_ulogic;
    cresetn_c                      : out std_ulogic;
    cresetn_d                      : out std_ulogic;
    cclk_a                         : in std_ulogic;
    cclk_b                         : in std_ulogic;
    cclk_c                         : in std_ulogic;
    cclk_d                         : in std_ulogic;
    pll_locked                     : out std_ulogic;

    ---------------------------------------------------------------------------
    -- I2C Pins
    ---------------------------------------------------------------------------
    scl_io                         : inout std_logic;
    sda_io                         : inout std_logic;

    ---------------------------------------------------------------------------
    -- AXI Register Interfaces
    ---------------------------------------------------------------------------
    oc_memory0_axis_aclk           : out std_ulogic;
    oc_memory0_axis_i              : out t_AXI3_SLAVE_INPUT;
    oc_memory0_axis_o              : in t_AXI3_SLAVE_OUTPUT;
    oc_mmio0_axis_aclk             : out std_ulogic;
    oc_mmio0_axis_i                : out t_AXI3_SLAVE_INPUT;
    oc_mmio0_axis_o                : in t_AXI3_SLAVE_OUTPUT;
    oc_cfg0_axis_aclk              : out std_ulogic;
    oc_cfg0_axis_i                 : out t_AXI3_SLAVE_INPUT;
    oc_cfg0_axis_o                 : in t_AXI3_SLAVE_OUTPUT;
    oc_memory1_axis_aclk           : out std_ulogic;
    oc_memory1_axis_i              : out t_AXI3_SLAVE_INPUT;
    oc_memory1_axis_o              : in t_AXI3_SLAVE_OUTPUT;
    oc_mmio1_axis_aclk             : out std_ulogic;
    oc_mmio1_axis_i                : out t_AXI3_SLAVE_INPUT;
    oc_mmio1_axis_o                : in t_AXI3_SLAVE_OUTPUT;
    oc_cfg1_axis_aclk              : out std_ulogic;
    oc_cfg1_axis_i                 : out t_AXI3_SLAVE_INPUT;
    oc_cfg1_axis_o                 : in t_AXI3_SLAVE_OUTPUT;
    oc_memory2_axis_aclk           : out std_ulogic;
    oc_memory2_axis_i              : out t_AXI3_SLAVE_INPUT;
    oc_memory2_axis_o              : in t_AXI3_SLAVE_OUTPUT;
    oc_mmio2_axis_aclk             : out std_ulogic;
    oc_mmio2_axis_i                : out t_AXI3_SLAVE_INPUT;
    oc_mmio2_axis_o                : in t_AXI3_SLAVE_OUTPUT;
    oc_cfg2_axis_aclk              : out std_ulogic;
    oc_cfg2_axis_i                 : out t_AXI3_SLAVE_INPUT;
    oc_cfg2_axis_o                 : in t_AXI3_SLAVE_OUTPUT;
    oc_memory3_axis_aclk           : out std_ulogic;
    oc_memory3_axis_i              : out t_AXI3_SLAVE_INPUT;
    oc_memory3_axis_o              : in t_AXI3_SLAVE_OUTPUT;
    oc_mmio3_axis_aclk             : out std_ulogic;
    oc_mmio3_axis_i                : out t_AXI3_SLAVE_INPUT;
    oc_mmio3_axis_o                : in t_AXI3_SLAVE_OUTPUT;
    oc_cfg3_axis_aclk              : out std_ulogic;
    oc_cfg3_axis_i                 : out t_AXI3_SLAVE_INPUT;
    oc_cfg3_axis_o                 : in t_AXI3_SLAVE_OUTPUT;
    c3s_dlx0_axis_aclk             : out std_ulogic;
    c3s_dlx0_axis_i                : out t_AXI4_LITE_SLAVE_INPUT;
    c3s_dlx0_axis_o                : in t_AXI4_LITE_SLAVE_OUTPUT;
    c3s_dlx1_axis_aclk             : out std_ulogic;
    c3s_dlx1_axis_i                : out t_AXI4_LITE_SLAVE_INPUT;
    c3s_dlx1_axis_o                : in t_AXI4_LITE_SLAVE_OUTPUT;
    c3s_dlx2_axis_aclk             : out std_ulogic;
    c3s_dlx2_axis_i                : out t_AXI4_LITE_SLAVE_INPUT;
    c3s_dlx2_axis_o                : in t_AXI4_LITE_SLAVE_OUTPUT;
    c3s_dlx3_axis_aclk             : out std_ulogic;
    c3s_dlx3_axis_i                : out t_AXI4_LITE_SLAVE_INPUT;
    c3s_dlx3_axis_o                : in t_AXI4_LITE_SLAVE_OUTPUT;
    fbist0_axis_aclk               : out std_ulogic;
    fbist0_axis_i                  : out t_AXI4_LITE_SLAVE_INPUT;
    fbist0_axis_o                  : in t_AXI4_LITE_SLAVE_OUTPUT;
    fbist1_axis_aclk               : out std_ulogic;
    fbist1_axis_i                  : out t_AXI4_LITE_SLAVE_INPUT;
    fbist1_axis_o                  : in t_AXI4_LITE_SLAVE_OUTPUT;
    fbist2_axis_aclk               : out std_ulogic;
    fbist2_axis_i                  : out t_AXI4_LITE_SLAVE_INPUT;
    fbist2_axis_o                  : in t_AXI4_LITE_SLAVE_OUTPUT;
    fbist3_axis_aclk               : out std_ulogic;
    fbist3_axis_i                  : out t_AXI4_LITE_SLAVE_INPUT;
    fbist3_axis_o                  : in t_AXI4_LITE_SLAVE_OUTPUT;
    oc_host_cfg0_axis_aclk         : out std_ulogic;
    oc_host_cfg0_axis_i            : out t_AXI4_LITE_SLAVE_INPUT;
    oc_host_cfg0_axis_o            : in t_AXI4_LITE_SLAVE_OUTPUT;
    oc_host_cfg1_axis_aclk         : out std_ulogic;
    oc_host_cfg1_axis_i            : out t_AXI4_LITE_SLAVE_INPUT;
    oc_host_cfg1_axis_o            : in t_AXI4_LITE_SLAVE_OUTPUT;
    oc_host_cfg2_axis_aclk         : out std_ulogic;
    oc_host_cfg2_axis_i            : out t_AXI4_LITE_SLAVE_INPUT;
    oc_host_cfg2_axis_o            : in t_AXI4_LITE_SLAVE_OUTPUT;
    oc_host_cfg3_axis_aclk         : out std_ulogic;
    oc_host_cfg3_axis_i            : out t_AXI4_LITE_SLAVE_INPUT;
    oc_host_cfg3_axis_o            : in t_AXI4_LITE_SLAVE_OUTPUT;
    fml_axis_aclk                  : out std_ulogic;
    fml_axis_i                     : out t_AXI4_LITE_SLAVE_INPUT;
    fml_axis_o                     : in t_AXI4_LITE_SLAVE_OUTPUT
    );

  attribute BLOCK_TYPE of fire_pervasive : entity is SOFT;
  attribute BTR_NAME of fire_pervasive : entity is "FIRE_PERVASIVE";
  attribute RECURSIVE_SYNTHESIS of fire_pervasive : entity is 2;
end fire_pervasive;

architecture fire_pervasive of fire_pervasive is

  SIGNAL pll_locked_int : STD_LOGIC;
  SIGNAL sys_resetn_int : STD_LOGIC;
  SIGNAL sysclk_int     : STD_LOGIC;

  SIGNAL jtag_m0_axi_awid    : STD_LOGIC_VECTOR (0 downto 0);
  SIGNAL jtag_m0_axi_awaddr  : STD_LOGIC_VECTOR (63 downto 0);
  SIGNAL jtag_m0_axi_awlen   : STD_LOGIC_VECTOR (7 downto 0);
  SIGNAL jtag_m0_axi_awsize  : STD_LOGIC_VECTOR (2 downto 0);
  SIGNAL jtag_m0_axi_awburst : STD_LOGIC_VECTOR (1 downto 0);
  SIGNAL jtag_m0_axi_awlock  : STD_LOGIC;
  SIGNAL jtag_m0_axi_awcache : STD_LOGIC_VECTOR (3 downto 0);
  SIGNAL jtag_m0_axi_awprot  : STD_LOGIC_VECTOR (2 downto 0);
  SIGNAL jtag_m0_axi_awvalid : STD_LOGIC;
  SIGNAL jtag_m0_axi_awready : STD_LOGIC;
  SIGNAL jtag_m0_axi_wdata   : STD_LOGIC_VECTOR (31 downto 0);
  SIGNAL jtag_m0_axi_wstrb   : STD_LOGIC_VECTOR (3 downto 0);
  SIGNAL jtag_m0_axi_wlast   : STD_LOGIC;
  SIGNAL jtag_m0_axi_wvalid  : STD_LOGIC;
  SIGNAL jtag_m0_axi_wready  : STD_LOGIC;
  SIGNAL jtag_m0_axi_bid     : STD_LOGIC_VECTOR (0 downto 0);
  SIGNAL jtag_m0_axi_bresp   : STD_LOGIC_VECTOR (1 downto 0);
  SIGNAL jtag_m0_axi_bvalid  : STD_LOGIC;
  SIGNAL jtag_m0_axi_bready  : STD_LOGIC;
  SIGNAL jtag_m0_axi_arid    : STD_LOGIC_VECTOR (0 downto 0);
  SIGNAL jtag_m0_axi_araddr  : STD_LOGIC_VECTOR (63 downto 0);
  SIGNAL jtag_m0_axi_arlen   : STD_LOGIC_VECTOR (7 downto 0);
  SIGNAL jtag_m0_axi_arsize  : STD_LOGIC_VECTOR (2 downto 0);
  SIGNAL jtag_m0_axi_arburst : STD_LOGIC_VECTOR (1 downto 0);
  SIGNAL jtag_m0_axi_arlock  : STD_LOGIC;
  SIGNAL jtag_m0_axi_arcache : STD_LOGIC_VECTOR (3 downto 0);
  SIGNAL jtag_m0_axi_arprot  : STD_LOGIC_VECTOR (2 downto 0);
  SIGNAL jtag_m0_axi_arvalid : STD_LOGIC;
  SIGNAL jtag_m0_axi_arready : STD_LOGIC;
  SIGNAL jtag_m0_axi_rid     : STD_LOGIC_VECTOR (0 downto 0);
  SIGNAL jtag_m0_axi_rdata   : STD_LOGIC_VECTOR (31 downto 0);
  SIGNAL jtag_m0_axi_rresp   : STD_LOGIC_VECTOR (1 downto 0);
  SIGNAL jtag_m0_axi_rlast   : STD_LOGIC;
  SIGNAL jtag_m0_axi_rvalid  : STD_LOGIC;
  SIGNAL jtag_m0_axi_rready  : STD_LOGIC;

  SIGNAL axi_iic_s0_axi_awaddr  : STD_LOGIC_VECTOR (63 downto 0);
  SIGNAL axi_iic_s0_axi_awprot  : STD_LOGIC_VECTOR (2 downto 0);
  SIGNAL axi_iic_s0_axi_awvalid : STD_LOGIC;
  SIGNAL axi_iic_s0_axi_awready : STD_LOGIC;
  SIGNAL axi_iic_s0_axi_wdata   : STD_LOGIC_VECTOR (31 downto 0);
  SIGNAL axi_iic_s0_axi_wstrb   : STD_LOGIC_VECTOR (3 downto 0);
  SIGNAL axi_iic_s0_axi_wvalid  : STD_LOGIC;
  SIGNAL axi_iic_s0_axi_wready  : STD_LOGIC;
  SIGNAL axi_iic_s0_axi_bresp   : STD_LOGIC_VECTOR (1 downto 0);
  SIGNAL axi_iic_s0_axi_bvalid  : STD_LOGIC;
  SIGNAL axi_iic_s0_axi_bready  : STD_LOGIC;
  SIGNAL axi_iic_s0_axi_araddr  : STD_LOGIC_VECTOR (63 downto 0);
  SIGNAL axi_iic_s0_axi_arprot  : STD_LOGIC_VECTOR (2 downto 0);
  SIGNAL axi_iic_s0_axi_arvalid : STD_LOGIC;
  SIGNAL axi_iic_s0_axi_arready : STD_LOGIC;
  SIGNAL axi_iic_s0_axi_rdata   : STD_LOGIC_VECTOR (31 downto 0);
  SIGNAL axi_iic_s0_axi_rresp   : STD_LOGIC_VECTOR (1 downto 0);
  SIGNAL axi_iic_s0_axi_rvalid  : STD_LOGIC;
  SIGNAL axi_iic_s0_axi_rready  : STD_LOGIC;

  SIGNAL jtag_m0_axi_i            : t_AXI4_MASTER_INPUT;
  SIGNAL jtag_m0_axi_o            : t_AXI4_MASTER_OUTPUT;
  SIGNAL jtag_s0_axi_o_int        : t_AXI4_SLAVE_OUTPUT;
  SIGNAL i2c_control_m0_axi_i     : t_AXI3_64_MASTER_INPUT;
  SIGNAL i2c_control_m0_axi_o     : t_AXI3_64_MASTER_OUTPUT;
  SIGNAL i2c_control_s0_axi_o_int : t_AXI3_64_SLAVE_OUTPUT;
  SIGNAL mb_m0_axi_i              : t_AXI3_MASTER_INPUT;
  SIGNAL mb_m0_axi_o              : t_AXI3_MASTER_OUTPUT;
  SIGNAL mb_s0_axi_o_int          : t_AXI3_SLAVE_OUTPUT;

  SIGNAL ddimm0_memory_s0_axi_i          : t_AXI3_SLAVE_INPUT;
  SIGNAL ddimm0_memory_s0_axi_o          : t_AXI3_SLAVE_OUTPUT;
  SIGNAL ddimm0_memory_m0_axi_o_int      : t_AXI3_MASTER_OUTPUT;
  SIGNAL ddimm0_mmio_s0_axi_i            : t_AXI3_SLAVE_INPUT;
  SIGNAL ddimm0_mmio_s0_axi_o            : t_AXI3_SLAVE_OUTPUT;
  SIGNAL ddimm0_mmio_m0_axi_o_int        : t_AXI3_MASTER_OUTPUT;
  SIGNAL ddimm0_cfg_s0_axi_i             : t_AXI3_SLAVE_INPUT;
  SIGNAL ddimm0_cfg_s0_axi_o             : t_AXI3_SLAVE_OUTPUT;
  SIGNAL ddimm0_cfg_m0_axi_o_int         : t_AXI3_MASTER_OUTPUT;
  SIGNAL ddimm1_memory_s0_axi_i          : t_AXI3_SLAVE_INPUT;
  SIGNAL ddimm1_memory_s0_axi_o          : t_AXI3_SLAVE_OUTPUT;
  SIGNAL ddimm1_memory_m0_axi_o_int      : t_AXI3_MASTER_OUTPUT;
  SIGNAL ddimm1_mmio_s0_axi_i            : t_AXI3_SLAVE_INPUT;
  SIGNAL ddimm1_mmio_s0_axi_o            : t_AXI3_SLAVE_OUTPUT;
  SIGNAL ddimm1_mmio_m0_axi_o_int        : t_AXI3_MASTER_OUTPUT;
  SIGNAL ddimm1_cfg_s0_axi_i             : t_AXI3_SLAVE_INPUT;
  SIGNAL ddimm1_cfg_s0_axi_o             : t_AXI3_SLAVE_OUTPUT;
  SIGNAL ddimm1_cfg_m0_axi_o_int         : t_AXI3_MASTER_OUTPUT;
  SIGNAL ddimm2_memory_s0_axi_i          : t_AXI3_SLAVE_INPUT;
  SIGNAL ddimm2_memory_s0_axi_o          : t_AXI3_SLAVE_OUTPUT;
  SIGNAL ddimm2_memory_m0_axi_o_int      : t_AXI3_MASTER_OUTPUT;
  SIGNAL ddimm2_mmio_s0_axi_i            : t_AXI3_SLAVE_INPUT;
  SIGNAL ddimm2_mmio_s0_axi_o            : t_AXI3_SLAVE_OUTPUT;
  SIGNAL ddimm2_mmio_m0_axi_o_int        : t_AXI3_MASTER_OUTPUT;
  SIGNAL ddimm2_cfg_s0_axi_i             : t_AXI3_SLAVE_INPUT;
  SIGNAL ddimm2_cfg_s0_axi_o             : t_AXI3_SLAVE_OUTPUT;
  SIGNAL ddimm2_cfg_m0_axi_o_int         : t_AXI3_MASTER_OUTPUT;
  SIGNAL ddimm3_memory_s0_axi_i          : t_AXI3_SLAVE_INPUT;
  SIGNAL ddimm3_memory_s0_axi_o          : t_AXI3_SLAVE_OUTPUT;
  SIGNAL ddimm3_memory_m0_axi_o_int      : t_AXI3_MASTER_OUTPUT;
  SIGNAL ddimm3_mmio_s0_axi_i            : t_AXI3_SLAVE_INPUT;
  SIGNAL ddimm3_mmio_s0_axi_o            : t_AXI3_SLAVE_OUTPUT;
  SIGNAL ddimm3_mmio_m0_axi_o_int        : t_AXI3_MASTER_OUTPUT;
  SIGNAL ddimm3_cfg_s0_axi_i             : t_AXI3_SLAVE_INPUT;
  SIGNAL ddimm3_cfg_s0_axi_o             : t_AXI3_SLAVE_OUTPUT;
  SIGNAL ddimm3_cfg_m0_axi_o_int         : t_AXI3_MASTER_OUTPUT;
  SIGNAL fml_s0_axi_i                    : t_AXI4_LITE_SLAVE_INPUT;
  SIGNAL fml_s0_axi_o                    : t_AXI4_LITE_SLAVE_OUTPUT;
  SIGNAL fml_m0_axi_o_int                : t_AXI4_LITE_MASTER_OUTPUT;
  SIGNAL c3s0_s0_axi_i                   : t_AXI4_LITE_SLAVE_INPUT;
  SIGNAL c3s0_s0_axi_o                   : t_AXI4_LITE_SLAVE_OUTPUT;
  SIGNAL c3s0_m0_axi_o_int               : t_AXI4_LITE_MASTER_OUTPUT;
  SIGNAL c3s1_s0_axi_i                   : t_AXI4_LITE_SLAVE_INPUT;
  SIGNAL c3s1_s0_axi_o                   : t_AXI4_LITE_SLAVE_OUTPUT;
  SIGNAL c3s1_m0_axi_o_int               : t_AXI4_LITE_MASTER_OUTPUT;
  SIGNAL c3s2_s0_axi_i                   : t_AXI4_LITE_SLAVE_INPUT;
  SIGNAL c3s2_s0_axi_o                   : t_AXI4_LITE_SLAVE_OUTPUT;
  SIGNAL c3s2_m0_axi_o_int               : t_AXI4_LITE_MASTER_OUTPUT;
  SIGNAL c3s3_s0_axi_i                   : t_AXI4_LITE_SLAVE_INPUT;
  SIGNAL c3s3_s0_axi_o                   : t_AXI4_LITE_SLAVE_OUTPUT;
  SIGNAL c3s3_m0_axi_o_int               : t_AXI4_LITE_MASTER_OUTPUT;
  SIGNAL fbist0_s0_axi_i                 : t_AXI4_LITE_SLAVE_INPUT;
  SIGNAL fbist0_s0_axi_o                 : t_AXI4_LITE_SLAVE_OUTPUT;
  SIGNAL fbist0_m0_axi_o_int             : t_AXI4_LITE_MASTER_OUTPUT;
  SIGNAL fbist1_s0_axi_i                 : t_AXI4_LITE_SLAVE_INPUT;
  SIGNAL fbist1_s0_axi_o                 : t_AXI4_LITE_SLAVE_OUTPUT;
  SIGNAL fbist1_m0_axi_o_int             : t_AXI4_LITE_MASTER_OUTPUT;
  SIGNAL fbist2_s0_axi_i                 : t_AXI4_LITE_SLAVE_INPUT;
  SIGNAL fbist2_s0_axi_o                 : t_AXI4_LITE_SLAVE_OUTPUT;
  SIGNAL fbist2_m0_axi_o_int             : t_AXI4_LITE_MASTER_OUTPUT;
  SIGNAL fbist3_s0_axi_i                 : t_AXI4_LITE_SLAVE_INPUT;
  SIGNAL fbist3_s0_axi_o                 : t_AXI4_LITE_SLAVE_OUTPUT;
  SIGNAL fbist3_m0_axi_o_int             : t_AXI4_LITE_MASTER_OUTPUT;
  SIGNAL axi_iic_s0_axi_i                : t_AXI4_LITE_SLAVE_INPUT;
  SIGNAL axi_iic_s0_axi_o                : t_AXI4_LITE_SLAVE_OUTPUT;
  SIGNAL axi_iic_m0_axi_o_int            : t_AXI4_LITE_MASTER_OUTPUT;
  SIGNAL ddimm0_host_config_s0_axi_i     : t_AXI4_LITE_SLAVE_INPUT;
  SIGNAL ddimm0_host_config_s0_axi_o     : t_AXI4_LITE_SLAVE_OUTPUT;
  SIGNAL ddimm0_host_config_m0_axi_o_int : t_AXI4_LITE_MASTER_OUTPUT;
  SIGNAL ddimm1_host_config_s0_axi_i     : t_AXI4_LITE_SLAVE_INPUT;
  SIGNAL ddimm1_host_config_s0_axi_o     : t_AXI4_LITE_SLAVE_OUTPUT;
  SIGNAL ddimm1_host_config_m0_axi_o_int : t_AXI4_LITE_MASTER_OUTPUT;
  SIGNAL ddimm2_host_config_s0_axi_i     : t_AXI4_LITE_SLAVE_INPUT;
  SIGNAL ddimm2_host_config_s0_axi_o     : t_AXI4_LITE_SLAVE_OUTPUT;
  SIGNAL ddimm2_host_config_m0_axi_o_int : t_AXI4_LITE_MASTER_OUTPUT;
  SIGNAL ddimm3_host_config_s0_axi_i     : t_AXI4_LITE_SLAVE_INPUT;
  SIGNAL ddimm3_host_config_s0_axi_o     : t_AXI4_LITE_SLAVE_OUTPUT;
  SIGNAL ddimm3_host_config_m0_axi_o_int : t_AXI4_LITE_MASTER_OUTPUT;
  SIGNAL sysmon_s0_axi_i                 : t_AXI4_LITE_SLAVE_INPUT;
  SIGNAL sysmon_s0_axi_o                 : t_AXI4_LITE_SLAVE_OUTPUT;
  SIGNAL sysmon_m0_axi_o_int             : t_AXI4_LITE_MASTER_OUTPUT;

  SIGNAL axi3_axi4lite_slr0_s0_axi_i     : t_AXI4_LITE_SLAVE_OUTPUT;
  SIGNAL axi3_axi4lite_slr0_s0_axi_o     : t_AXI4_LITE_SLAVE_INPUT;
  SIGNAL axi3_axi4lite_slr0_s0_axi_o_int : t_AXI4_LITE_MASTER_OUTPUT;
  SIGNAL axi3_axi4lite_slr1_s0_axi_i     : t_AXI4_LITE_SLAVE_OUTPUT;
  SIGNAL axi3_axi4lite_slr1_s0_axi_o     : t_AXI4_LITE_SLAVE_INPUT;
  SIGNAL axi3_axi4lite_slr1_s0_axi_o_int : t_AXI4_LITE_MASTER_OUTPUT;

  SIGNAL axi3_slr_crossing_m0_axi_i : t_AXI3_SLAVE_OUTPUT;
  SIGNAL axi3_slr_crossing_m0_axi_o : t_AXI3_MASTER_OUTPUT;

  SIGNAL scl_o : STD_LOGIC;
  SIGNAL scl_i : STD_LOGIC;
  SIGNAL scl_t : STD_LOGIC;
  SIGNAL sda_o : STD_LOGIC;
  SIGNAL sda_i : STD_LOGIC;
  SIGNAL sda_t : STD_LOGIC;



  COMPONENT clk_wiz_sysclk
    PORT (
      clk_out1      : OUT STD_LOGIC;
      resetn        : IN  STD_LOGIC;
      locked        : OUT STD_LOGIC;
      clk_in1_p     : IN  STD_LOGIC;
      clk_in1_n     : IN  STD_LOGIC
      );
  END COMPONENT;

  COMPONENT proc_sys_reset_0
    PORT (
      slowest_sync_clk     : IN  STD_LOGIC;
      ext_reset_in         : IN  STD_LOGIC;
      aux_reset_in         : IN  STD_LOGIC;
      mb_debug_sys_rst     : IN  STD_LOGIC;
      dcm_locked           : IN  STD_LOGIC;
      mb_reset             : OUT STD_LOGIC;
      bus_struct_reset     : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      peripheral_reset     : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      interconnect_aresetn : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      peripheral_aresetn   : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
      );
  END COMPONENT;

  COMPONENT jtag_axi_0
    PORT (
      aclk          : IN  STD_LOGIC;
      aresetn       : IN  STD_LOGIC;
      m_axi_awid    : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      m_axi_awaddr  : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
      m_axi_awlen   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      m_axi_awsize  : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      m_axi_awburst : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      m_axi_awlock  : OUT STD_LOGIC;
      m_axi_awcache : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axi_awprot  : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      m_axi_awqos   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axi_awvalid : OUT STD_LOGIC;
      m_axi_awready : IN  STD_LOGIC;
      m_axi_wdata   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      m_axi_wstrb   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axi_wlast   : OUT STD_LOGIC;
      m_axi_wvalid  : OUT STD_LOGIC;
      m_axi_wready  : IN  STD_LOGIC;
      m_axi_bid     : IN  STD_LOGIC_VECTOR(0 DOWNTO 0);
      m_axi_bresp   : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
      m_axi_bvalid  : IN  STD_LOGIC;
      m_axi_bready  : OUT STD_LOGIC;
      m_axi_arid    : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      m_axi_araddr  : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
      m_axi_arlen   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      m_axi_arsize  : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      m_axi_arburst : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      m_axi_arlock  : OUT STD_LOGIC;
      m_axi_arcache : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axi_arprot  : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      m_axi_arqos   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axi_arvalid : OUT STD_LOGIC;
      m_axi_arready : IN  STD_LOGIC;
      m_axi_rid     : IN  STD_LOGIC_VECTOR(0 DOWNTO 0);
      m_axi_rdata   : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      m_axi_rresp   : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
      m_axi_rlast   : IN  STD_LOGIC;
      m_axi_rvalid  : IN  STD_LOGIC;
      m_axi_rready  : OUT STD_LOGIC
      );
  END COMPONENT;

  COMPONENT axi_iic_0
    PORT (
      s_axi_aclk : IN STD_LOGIC;
      s_axi_aresetn : IN STD_LOGIC;
      iic2intc_irpt : OUT STD_LOGIC;
      s_axi_awaddr : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
      s_axi_awvalid : IN STD_LOGIC;
      s_axi_awready : OUT STD_LOGIC;
      s_axi_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      s_axi_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axi_wvalid : IN STD_LOGIC;
      s_axi_wready : OUT STD_LOGIC;
      s_axi_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      s_axi_bvalid : OUT STD_LOGIC;
      s_axi_bready : IN STD_LOGIC;
      s_axi_araddr : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
      s_axi_arvalid : IN STD_LOGIC;
      s_axi_arready : OUT STD_LOGIC;
      s_axi_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      s_axi_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      s_axi_rvalid : OUT STD_LOGIC;
      s_axi_rready : IN STD_LOGIC;
      sda_i : IN STD_LOGIC;
      sda_o : OUT STD_LOGIC;
      sda_t : OUT STD_LOGIC;
      scl_i : IN STD_LOGIC;
      scl_o : OUT STD_LOGIC;
      scl_t : OUT STD_LOGIC;
      gpo : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)
      );
  END COMPONENT;

  COMPONENT iobuf
    PORT (
      i : IN STD_LOGIC;
      o : OUT STD_LOGIC;
      t : IN STD_LOGIC;
      io : INOUT STD_LOGIC
      );
  END COMPONENT;

begin

  ---------------------------------------------------------------------------
  -- AXI Clocks & Resets
  ---------------------------------------------------------------------------
  sysclk                 <= sysclk_int;
  sys_resetn             <= sys_resetn_int;
  c3s_dlx0_axis_aclk     <= sysclk_int;
  c3s_dlx1_axis_aclk     <= sysclk_int;
  c3s_dlx2_axis_aclk     <= sysclk_int;
  c3s_dlx3_axis_aclk     <= sysclk_int;
  oc_memory0_axis_aclk   <= sysclk_int;
  oc_mmio0_axis_aclk     <= sysclk_int;
  oc_cfg0_axis_aclk      <= sysclk_int;
  oc_memory1_axis_aclk   <= sysclk_int;
  oc_mmio1_axis_aclk     <= sysclk_int;
  oc_cfg1_axis_aclk      <= sysclk_int;
  oc_memory2_axis_aclk   <= sysclk_int;
  oc_mmio2_axis_aclk     <= sysclk_int;
  oc_cfg2_axis_aclk      <= sysclk_int;
  oc_memory3_axis_aclk   <= sysclk_int;
  oc_mmio3_axis_aclk     <= sysclk_int;
  oc_cfg3_axis_aclk      <= sysclk_int;
  fbist0_axis_aclk       <= sysclk_int;
  fbist1_axis_aclk       <= sysclk_int;
  fbist2_axis_aclk       <= sysclk_int;
  fbist3_axis_aclk       <= sysclk_int;
  oc_host_cfg0_axis_aclk <= sysclk_int;
  oc_host_cfg1_axis_aclk <= sysclk_int;
  oc_host_cfg2_axis_aclk <= sysclk_int;
  oc_host_cfg3_axis_aclk <= sysclk_int;
  fml_axis_aclk          <= sysclk_int;
  pll_locked             <= pll_locked_int;

  clk_wiz : clk_wiz_sysclk
    PORT MAP(
      clk_out1  => sysclk_int,
      resetn    => raw_resetn,
      locked    => pll_locked_int,
      clk_in1_p => raw_sysclk_p,
      clk_in1_n => raw_sysclk_n
      );

  proc_sys_reset_sysclk : proc_sys_reset_0
    PORT MAP (
      slowest_sync_clk      => sysclk_int,
      ext_reset_in          => raw_resetn,
      aux_reset_in          => '1',
      mb_debug_sys_rst      => '0',
      dcm_locked            => pll_locked_int,
      mb_reset              => open,
      bus_struct_reset      => open,
      peripheral_reset      => open,
      interconnect_aresetn  => open,
      peripheral_aresetn(0) => sys_resetn_int
      );

  proc_sys_resetcclk_a : proc_sys_reset_0
    PORT MAP (
      slowest_sync_clk      => cclk_a,
      ext_reset_in          => raw_resetn,
      aux_reset_in          => '1',
      mb_debug_sys_rst      => '0',
      dcm_locked            => '1', -- TODO is there a locked signal to pick up?
      mb_reset              => open,
      bus_struct_reset      => open,
      peripheral_reset      => open,
      interconnect_aresetn  => open,
      peripheral_aresetn(0) => cresetn_a
      );

  proc_sys_resetcclk_b : proc_sys_reset_0
    PORT MAP (
      slowest_sync_clk      => cclk_b,
      ext_reset_in          => raw_resetn,
      aux_reset_in          => '1',
      mb_debug_sys_rst      => '0',
      dcm_locked            => '1', -- TODO is there a locked signal to pick up?
      mb_reset              => open,
      bus_struct_reset      => open,
      peripheral_reset      => open,
      interconnect_aresetn  => open,
      peripheral_aresetn(0) => cresetn_b
      );

  proc_sys_resetcclk_c : proc_sys_reset_0
    PORT MAP (
      slowest_sync_clk      => cclk_c,
      ext_reset_in          => raw_resetn,
      aux_reset_in          => '1',
      mb_debug_sys_rst      => '0',
      dcm_locked            => '1', -- TODO is there a locked signal to pick up?
      mb_reset              => open,
      bus_struct_reset      => open,
      peripheral_reset      => open,
      interconnect_aresetn  => open,
      peripheral_aresetn(0) => cresetn_c
      );

  proc_sys_resetcclk_d : proc_sys_reset_0
    PORT MAP (
      slowest_sync_clk      => cclk_d,
      ext_reset_in          => raw_resetn,
      aux_reset_in          => '1',
      mb_debug_sys_rst      => '0',
      dcm_locked            => '1', -- TODO is there a locked signal to pick up?
      mb_reset              => open,
      bus_struct_reset      => open,
      peripheral_reset      => open,
      interconnect_aresetn  => open,
      peripheral_aresetn(0) => cresetn_d
      );

  ---------------------------------------------------------------------------
  -- AXI Crossbars
  ---------------------------------------------------------------------------
  -- Vivado doesn't let us use functions on the left side of
  -- assignments, so call functions with intermediate signal.
  -- AXI3 Masters
  jtag_m0_axi_i               <= axi4_master_slave_connect(jtag_s0_axi_o_int);
  i2c_control_m0_axi_i        <= axi3_master_slave_connect(i2c_control_s0_axi_o_int);
  mb_m0_axi_i                 <= axi3_master_slave_connect(mb_s0_axi_o_int);

  -- AXI3 Slaves
  ddimm0_memory_s0_axi_i <= axi3_master_slave_connect(ddimm0_memory_m0_axi_o_int);
  ddimm0_mmio_s0_axi_i   <= axi3_master_slave_connect(ddimm0_mmio_m0_axi_o_int);
  ddimm0_cfg_s0_axi_i    <= axi3_master_slave_connect(ddimm0_cfg_m0_axi_o_int);
  ddimm1_memory_s0_axi_i <= axi3_master_slave_connect(ddimm1_memory_m0_axi_o_int);
  ddimm1_mmio_s0_axi_i   <= axi3_master_slave_connect(ddimm1_mmio_m0_axi_o_int);
  ddimm1_cfg_s0_axi_i    <= axi3_master_slave_connect(ddimm1_cfg_m0_axi_o_int);
  ddimm2_memory_s0_axi_i <= axi3_master_slave_connect(ddimm2_memory_m0_axi_o_int);
  ddimm2_mmio_s0_axi_i   <= axi3_master_slave_connect(ddimm2_mmio_m0_axi_o_int);
  ddimm2_cfg_s0_axi_i    <= axi3_master_slave_connect(ddimm2_cfg_m0_axi_o_int);
  ddimm3_memory_s0_axi_i <= axi3_master_slave_connect(ddimm3_memory_m0_axi_o_int);
  ddimm3_mmio_s0_axi_i   <= axi3_master_slave_connect(ddimm3_mmio_m0_axi_o_int);
  ddimm3_cfg_s0_axi_i    <= axi3_master_slave_connect(ddimm3_cfg_m0_axi_o_int);

  -- AXI4-Lite Slaves
  fml_s0_axi_i                <= axi4lite_master_slave_connect(fml_m0_axi_o_int);
  c3s0_s0_axi_i               <= axi4lite_master_slave_connect(c3s0_m0_axi_o_int);
  c3s1_s0_axi_i               <= axi4lite_master_slave_connect(c3s1_m0_axi_o_int);
  c3s2_s0_axi_i               <= axi4lite_master_slave_connect(c3s2_m0_axi_o_int);
  c3s3_s0_axi_i               <= axi4lite_master_slave_connect(c3s3_m0_axi_o_int);
  fbist0_s0_axi_i             <= axi4lite_master_slave_connect(fbist0_m0_axi_o_int);
  fbist1_s0_axi_i             <= axi4lite_master_slave_connect(fbist1_m0_axi_o_int);
  fbist2_s0_axi_i             <= axi4lite_master_slave_connect(fbist2_m0_axi_o_int);
  fbist3_s0_axi_i             <= axi4lite_master_slave_connect(fbist3_m0_axi_o_int);
  axi_iic_s0_axi_i            <= axi4lite_master_slave_connect(axi_iic_m0_axi_o_int);
  ddimm0_host_config_s0_axi_i <= axi4lite_master_slave_connect(ddimm0_host_config_m0_axi_o_int);
  ddimm1_host_config_s0_axi_i <= axi4lite_master_slave_connect(ddimm1_host_config_m0_axi_o_int);
  ddimm2_host_config_s0_axi_i <= axi4lite_master_slave_connect(ddimm2_host_config_m0_axi_o_int);
  ddimm3_host_config_s0_axi_i <= axi4lite_master_slave_connect(ddimm3_host_config_m0_axi_o_int);
  sysmon_s0_axi_i             <= axi4lite_master_slave_connect(sysmon_m0_axi_o_int);

  -- AXI3/AXI4-Lite Connection
  axi3_axi4lite_slr0_s0_axi_o <= axi4lite_master_slave_connect(axi3_axi4lite_slr0_s0_axi_o_int);
  axi3_axi4lite_slr1_s0_axi_o <= axi4lite_master_slave_connect(axi3_axi4lite_slr1_s0_axi_o_int);

  axi3_crossbar_slr0_top : entity work.axi3_crossbar_slr0_top
    PORT MAP (
      aclk      => sysclk_int,
      aresetn   => sys_resetn_int,
      s0_axi_i  => axi4_master_slave_connect(jtag_m0_axi_o),
      s0_axi_o  => jtag_s0_axi_o_int,
      s1_axi_i  => axi3_master_slave_connect(i2c_control_m0_axi_o),
      s1_axi_o  => i2c_control_s0_axi_o_int,
      s2_axi_i  => axi3_master_slave_connect(mb_m0_axi_o),
      s2_axi_o  => mb_s0_axi_o_int,
      m0_axi_i  => axi4lite_master_slave_connect(axi3_axi4lite_slr0_s0_axi_i),
      m0_axi_o  => axi3_axi4lite_slr0_s0_axi_o_int,
      m1_axi_i  => axi3_master_slave_connect(ddimm1_memory_s0_axi_o),
      m1_axi_o  => ddimm1_memory_m0_axi_o_int,
      m2_axi_i  => axi3_master_slave_connect(ddimm1_cfg_s0_axi_o),
      m2_axi_o  => ddimm1_cfg_m0_axi_o_int,
      m3_axi_i  => axi3_master_slave_connect(ddimm1_mmio_s0_axi_o),
      m3_axi_o  => ddimm1_mmio_m0_axi_o_int,
      m4_axi_i  => axi3_master_slave_connect(ddimm3_memory_s0_axi_o),
      m4_axi_o  => ddimm3_memory_m0_axi_o_int,
      m5_axi_i  => axi3_master_slave_connect(ddimm3_cfg_s0_axi_o),
      m5_axi_o  => ddimm3_cfg_m0_axi_o_int,
      m6_axi_i  => axi3_master_slave_connect(ddimm3_mmio_s0_axi_o),
      m6_axi_o  => ddimm3_mmio_m0_axi_o_int,
      m7_axi_i  => axi3_master_slave_connect(axi3_slr_crossing_m0_axi_i),
      m7_axi_o  => axi3_slr_crossing_m0_axi_o
      );

  axi3_crossbar_slr1_top : entity work.axi3_crossbar_slr1_top
    PORT MAP (
      aclk      => sysclk_int,
      aresetn   => sys_resetn_int,
      s0_axi_i  => axi3_master_slave_connect(axi3_slr_crossing_m0_axi_o),
      s0_axi_o  => axi3_slr_crossing_m0_axi_i,
      m0_axi_i  => axi4lite_master_slave_connect(axi3_axi4lite_slr1_s0_axi_i),
      m0_axi_o  => axi3_axi4lite_slr1_s0_axi_o_int,
      m1_axi_i  => axi3_master_slave_connect(ddimm0_memory_s0_axi_o),
      m1_axi_o  => ddimm0_memory_m0_axi_o_int,
      m2_axi_i  => axi3_master_slave_connect(ddimm0_cfg_s0_axi_o),
      m2_axi_o  => ddimm0_cfg_m0_axi_o_int,
      m3_axi_i  => axi3_master_slave_connect(ddimm0_mmio_s0_axi_o),
      m3_axi_o  => ddimm0_mmio_m0_axi_o_int,
      m4_axi_i  => axi3_master_slave_connect(ddimm2_memory_s0_axi_o),
      m4_axi_o  => ddimm2_memory_m0_axi_o_int,
      m5_axi_i  => axi3_master_slave_connect(ddimm2_cfg_s0_axi_o),
      m5_axi_o  => ddimm2_cfg_m0_axi_o_int,
      m6_axi_i  => axi3_master_slave_connect(ddimm2_mmio_s0_axi_o),
      m6_axi_o  => ddimm2_mmio_m0_axi_o_int
      );

  axi4lite_crossbar_slr0_top : entity work.axi4lite_crossbar_slr0_top
    PORT MAP (
      aclk     => sysclk_int,
      aresetn  => sys_resetn_int,
      s0_axi_i => axi3_axi4lite_slr0_s0_axi_o,
      s0_axi_o => axi3_axi4lite_slr0_s0_axi_i,
      m0_axi_i => axi4lite_master_slave_connect(c3s1_s0_axi_o),
      m0_axi_o => c3s1_m0_axi_o_int,
      m1_axi_i => axi4lite_master_slave_connect(fbist1_s0_axi_o),
      m1_axi_o => fbist1_m0_axi_o_int,
      m2_axi_i => axi4lite_master_slave_connect(ddimm1_host_config_s0_axi_o),
      m2_axi_o => ddimm1_host_config_m0_axi_o_int,
      m3_axi_i => axi4lite_master_slave_connect(c3s3_s0_axi_o),
      m3_axi_o => c3s3_m0_axi_o_int,
      m4_axi_i => axi4lite_master_slave_connect(fbist3_s0_axi_o),
      m4_axi_o => fbist3_m0_axi_o_int,
      m5_axi_i => axi4lite_master_slave_connect(ddimm3_host_config_s0_axi_o),
      m5_axi_o => ddimm3_host_config_m0_axi_o_int,
      m6_axi_i => axi4lite_master_slave_connect(fml_s0_axi_o),
      m6_axi_o => fml_m0_axi_o_int,
      m7_axi_i => axi4lite_master_slave_connect(axi_iic_s0_axi_o),
      m7_axi_o => axi_iic_m0_axi_o_int,
      m8_axi_i => axi4lite_master_slave_connect(sysmon_s0_axi_o),
      m8_axi_o => sysmon_m0_axi_o_int
      );

  axi4lite_crossbar_slr1_top : entity work.axi4lite_crossbar_slr1_top
    PORT MAP (
      aclk      => sysclk_int,
      aresetn   => sys_resetn_int,
      s0_axi_i  => axi3_axi4lite_slr1_s0_axi_o,
      s0_axi_o  => axi3_axi4lite_slr1_s0_axi_i,
      m0_axi_i  => axi4lite_master_slave_connect(c3s0_s0_axi_o),
      m0_axi_o  => c3s0_m0_axi_o_int,
      m1_axi_i  => axi4lite_master_slave_connect(fbist0_s0_axi_o),
      m1_axi_o  => fbist0_m0_axi_o_int,
      m2_axi_i  => axi4lite_master_slave_connect(ddimm0_host_config_s0_axi_o),
      m2_axi_o  => ddimm0_host_config_m0_axi_o_int,
      m3_axi_i => axi4lite_master_slave_connect(c3s2_s0_axi_o),
      m3_axi_o => c3s2_m0_axi_o_int,
      m4_axi_i => axi4lite_master_slave_connect(fbist2_s0_axi_o),
      m4_axi_o => fbist2_m0_axi_o_int,
      m5_axi_i  => axi4lite_master_slave_connect(ddimm2_host_config_s0_axi_o),
      m5_axi_o  => ddimm2_host_config_m0_axi_o_int
      );

  ---------------------------------------------------------------------------
  -- JTAG to AXI
  ---------------------------------------------------------------------------
  jtag_axi : jtag_axi_0
    PORT MAP (
      aclk          => sysclk_int,
      aresetn       => sys_resetn_int,
      m_axi_awid    => jtag_m0_axi_awid,
      m_axi_awaddr  => jtag_m0_axi_awaddr,
      m_axi_awlen   => jtag_m0_axi_awlen,
      m_axi_awsize  => jtag_m0_axi_awsize,
      m_axi_awburst => jtag_m0_axi_awburst,
      m_axi_awlock  => jtag_m0_axi_awlock,
      m_axi_awcache => jtag_m0_axi_awcache,
      m_axi_awprot  => jtag_m0_axi_awprot,
      m_axi_awqos   => open,
      m_axi_awvalid => jtag_m0_axi_awvalid,
      m_axi_awready => jtag_m0_axi_awready,
      m_axi_wdata   => jtag_m0_axi_wdata,
      m_axi_wstrb   => jtag_m0_axi_wstrb,
      m_axi_wlast   => jtag_m0_axi_wlast,
      m_axi_wvalid  => jtag_m0_axi_wvalid,
      m_axi_wready  => jtag_m0_axi_wready,
      m_axi_bid     => jtag_m0_axi_bid,
      m_axi_bresp   => jtag_m0_axi_bresp,
      m_axi_bvalid  => jtag_m0_axi_bvalid,
      m_axi_bready  => jtag_m0_axi_bready,
      m_axi_arid    => jtag_m0_axi_arid,
      m_axi_araddr  => jtag_m0_axi_araddr,
      m_axi_arlen   => jtag_m0_axi_arlen,
      m_axi_arsize  => jtag_m0_axi_arsize,
      m_axi_arburst => jtag_m0_axi_arburst,
      m_axi_arlock  => jtag_m0_axi_arlock,
      m_axi_arcache => jtag_m0_axi_arcache,
      m_axi_arprot  => jtag_m0_axi_arprot,
      m_axi_arqos   => open,
      m_axi_arvalid => jtag_m0_axi_arvalid,
      m_axi_arready => jtag_m0_axi_arready,
      m_axi_rid     => jtag_m0_axi_rid,
      m_axi_rdata   => jtag_m0_axi_rdata,
      m_axi_rresp   => jtag_m0_axi_rresp,
      m_axi_rlast   => jtag_m0_axi_rlast,
      m_axi_rvalid  => jtag_m0_axi_rvalid,
      m_axi_rready  => jtag_m0_axi_rready
      );

  jtag_m0_axi_o.m0_axi_aresetn <= sys_resetn_int;
  jtag_m0_axi_o.m0_axi_awid    <= To_StdULogicVector(jtag_m0_axi_awid);
  jtag_m0_axi_o.m0_axi_awaddr  <= To_StdULogicVector(jtag_m0_axi_awaddr);
  jtag_m0_axi_o.m0_axi_awlen   <= To_StdULogicVector(jtag_m0_axi_awlen);
  jtag_m0_axi_o.m0_axi_awsize  <= To_StdULogicVector(jtag_m0_axi_awsize);
  jtag_m0_axi_o.m0_axi_awburst <= To_StdULogicVector(jtag_m0_axi_awburst);
  jtag_m0_axi_o.m0_axi_awlock  <= (0 => jtag_m0_axi_awlock);
  jtag_m0_axi_o.m0_axi_awcache <= To_StdULogicVector(jtag_m0_axi_awcache);
  jtag_m0_axi_o.m0_axi_awprot  <= To_StdULogicVector(jtag_m0_axi_awprot);
  jtag_m0_axi_o.m0_axi_awvalid <= jtag_m0_axi_awvalid;
  jtag_m0_axi_awready          <= jtag_m0_axi_i.m0_axi_awready;
  jtag_m0_axi_o.m0_axi_wdata   <= To_StdULogicVector(jtag_m0_axi_wdata);
  jtag_m0_axi_o.m0_axi_wstrb   <= To_StdULogicVector(jtag_m0_axi_wstrb);
  jtag_m0_axi_o.m0_axi_wlast   <= jtag_m0_axi_wlast;
  jtag_m0_axi_o.m0_axi_wvalid  <= jtag_m0_axi_wvalid;
  jtag_m0_axi_wready           <= jtag_m0_axi_i.m0_axi_wready;
  jtag_m0_axi_bid              <= To_StdLogicVector(jtag_m0_axi_i.m0_axi_bid);
  jtag_m0_axi_bresp            <= To_StdLogicVector(jtag_m0_axi_i.m0_axi_bresp);
  jtag_m0_axi_bvalid           <= jtag_m0_axi_i.m0_axi_bvalid;
  jtag_m0_axi_o.m0_axi_bready  <= jtag_m0_axi_bready;
  jtag_m0_axi_o.m0_axi_arid    <= To_StdULogicVector(jtag_m0_axi_arid);
  jtag_m0_axi_o.m0_axi_araddr  <= To_StdULogicVector(jtag_m0_axi_araddr);
  jtag_m0_axi_o.m0_axi_arlen   <= To_StdULogicVector(jtag_m0_axi_arlen);
  jtag_m0_axi_o.m0_axi_arsize  <= To_StdULogicVector(jtag_m0_axi_arsize);
  jtag_m0_axi_o.m0_axi_arburst <= To_StdULogicVector(jtag_m0_axi_arburst);
  jtag_m0_axi_o.m0_axi_arlock  <= (0 => jtag_m0_axi_arlock);
  jtag_m0_axi_o.m0_axi_arcache <= To_StdULogicVector(jtag_m0_axi_arcache);
  jtag_m0_axi_o.m0_axi_arprot  <= To_StdULogicVector(jtag_m0_axi_arprot);
  jtag_m0_axi_o.m0_axi_arvalid <= jtag_m0_axi_arvalid;
  jtag_m0_axi_arready          <= jtag_m0_axi_i.m0_axi_arready;
  jtag_m0_axi_rid              <= To_StdLogicVector(jtag_m0_axi_i.m0_axi_rid);
  jtag_m0_axi_rdata            <= To_StdLogicVector(jtag_m0_axi_i.m0_axi_rdata);
  jtag_m0_axi_rresp            <= To_StdLogicVector(jtag_m0_axi_i.m0_axi_rresp);
  jtag_m0_axi_rlast            <= jtag_m0_axi_i.m0_axi_rlast;
  jtag_m0_axi_rvalid           <= jtag_m0_axi_i.m0_axi_rvalid;
  jtag_m0_axi_o.m0_axi_rready  <= jtag_m0_axi_rready;

  ---------------------------------------------------------------------------
  -- I2C Control
  ---------------------------------------------------------------------------
  i2c_control : entity work.i2c_control_mac
    GENERIC MAP (
      axi_iic_offset => X"0103000000000000"
      )
    PORT MAP (
      sysclk         => sysclk_int,
      sys_resetn     => sys_resetn_int,
      m0_axi_i       => i2c_control_m0_axi_i,
      m0_axi_o       => i2c_control_m0_axi_o
      );

  ---------------------------------------------------------------------------
  -- MicroBlaze
  ---------------------------------------------------------------------------
  -- TODO Attach
  mb_m0_axi_o.m0_axi_aresetn <= '1';
  mb_m0_axi_o.m0_axi_awid    <= (others => '0');
  mb_m0_axi_o.m0_axi_awaddr  <= (others => '0');
  mb_m0_axi_o.m0_axi_awlen   <= (others => '0');
  mb_m0_axi_o.m0_axi_awsize  <= (others => '0');
  mb_m0_axi_o.m0_axi_awburst <= (others => '0');
  mb_m0_axi_o.m0_axi_awlock  <= (others => '0');
  mb_m0_axi_o.m0_axi_awcache <= (others => '0');
  mb_m0_axi_o.m0_axi_awprot  <= (others => '0');
  mb_m0_axi_o.m0_axi_awvalid <= '0';
  mb_m0_axi_o.m0_axi_wid     <= (others => '0');
  mb_m0_axi_o.m0_axi_wdata   <= (others => '0');
  mb_m0_axi_o.m0_axi_wstrb   <= (others => '0');
  mb_m0_axi_o.m0_axi_wlast   <= '0';
  mb_m0_axi_o.m0_axi_wvalid  <= '0';
  mb_m0_axi_o.m0_axi_bready  <= '0';
  mb_m0_axi_o.m0_axi_arid    <= (others => '0');
  mb_m0_axi_o.m0_axi_araddr  <= (others => '0');
  mb_m0_axi_o.m0_axi_arlen   <= (others => '0');
  mb_m0_axi_o.m0_axi_arsize  <= (others => '0');
  mb_m0_axi_o.m0_axi_arburst <= (others => '0');
  mb_m0_axi_o.m0_axi_arlock  <= (others => '0');
  mb_m0_axi_o.m0_axi_arcache <= (others => '0');
  mb_m0_axi_o.m0_axi_arprot  <= (others => '0');
  mb_m0_axi_o.m0_axi_arvalid <= '0';
  mb_m0_axi_o.m0_axi_rready  <= '0';

  ---------------------------------------------------------------------------
  -- DDIMM MEMORY
  ---------------------------------------------------------------------------
  -- DDIMM 0
  oc_memory0_axis_i      <= ddimm0_memory_s0_axi_i;
  ddimm0_memory_s0_axi_o <= oc_memory0_axis_o;
  -- DDIMM 1
  oc_memory1_axis_i      <= ddimm1_memory_s0_axi_i;
  ddimm1_memory_s0_axi_o <= oc_memory1_axis_o;
  -- DDIMM 2
  oc_memory2_axis_i      <= ddimm2_memory_s0_axi_i;
  ddimm2_memory_s0_axi_o <= oc_memory2_axis_o;
  -- DDIMM 3
  oc_memory3_axis_i      <= ddimm3_memory_s0_axi_i;
  ddimm3_memory_s0_axi_o <= oc_memory3_axis_o;

  ---------------------------------------------------------------------------
  -- DDIMM MMIO
  ---------------------------------------------------------------------------
  -- DDIMM 0
  oc_mmio0_axis_i      <= ddimm0_mmio_s0_axi_i;
  ddimm0_mmio_s0_axi_o <= oc_mmio0_axis_o;
  -- DDIMM 1
  oc_mmio1_axis_i      <= ddimm1_mmio_s0_axi_i;
  ddimm1_mmio_s0_axi_o <= oc_mmio1_axis_o;
  -- DDIMM 2
  oc_mmio2_axis_i      <= ddimm2_mmio_s0_axi_i;
  ddimm2_mmio_s0_axi_o <= oc_mmio2_axis_o;
  -- DDIMM 3
  oc_mmio3_axis_i      <= ddimm3_mmio_s0_axi_i;
  ddimm3_mmio_s0_axi_o <= oc_mmio3_axis_o;

  ---------------------------------------------------------------------------
  -- DDIMM CFG
  ---------------------------------------------------------------------------
  -- DDIMM 0
  oc_cfg0_axis_i      <= ddimm0_cfg_s0_axi_i;
  ddimm0_cfg_s0_axi_o <= oc_cfg0_axis_o;
  -- DDIMM 1
  oc_cfg1_axis_i      <= ddimm1_cfg_s0_axi_i;
  ddimm1_cfg_s0_axi_o <= oc_cfg1_axis_o;
  -- DDIMM 2
  oc_cfg2_axis_i      <= ddimm2_cfg_s0_axi_i;
  ddimm2_cfg_s0_axi_o <= oc_cfg2_axis_o;
  -- DDIMM 3
  oc_cfg3_axis_i      <= ddimm3_cfg_s0_axi_i;
  ddimm3_cfg_s0_axi_o <= oc_cfg3_axis_o;

  ---------------------------------------------------------------------------
  -- FML
  ---------------------------------------------------------------------------
  fml_axis_i   <= fml_s0_axi_i;
  fml_s0_axi_o <= fml_axis_o;

  ---------------------------------------------------------------------------
  -- C3S
  ---------------------------------------------------------------------------
  -- DDIMM 0
  c3s_dlx0_axis_i <= c3s0_s0_axi_i;
  c3s0_s0_axi_o   <= c3s_dlx0_axis_o;
  -- DDIMM 1
  c3s_dlx1_axis_i <= c3s1_s0_axi_i;
  c3s1_s0_axi_o   <= c3s_dlx1_axis_o;
  -- DDIMM 2
  c3s_dlx2_axis_i <= c3s2_s0_axi_i;
  c3s2_s0_axi_o   <= c3s_dlx2_axis_o;
  -- DDIMM 3
  c3s_dlx3_axis_i <= c3s3_s0_axi_i;
  c3s3_s0_axi_o   <= c3s_dlx3_axis_o;

  ---------------------------------------------------------------------------
  -- FBIST
  ---------------------------------------------------------------------------
  -- DDIMM 0
  fbist0_axis_i   <= fbist0_s0_axi_i;
  fbist0_s0_axi_o <= fbist0_axis_o;
  -- DDIMM 1
  fbist1_axis_i   <= fbist1_s0_axi_i;
  fbist1_s0_axi_o <= fbist1_axis_o;
  -- DDIMM 2
  fbist2_axis_i   <= fbist2_s0_axi_i;
  fbist2_s0_axi_o <= fbist2_axis_o;
  -- DDIMM 3
  fbist3_axis_i   <= fbist3_s0_axi_i;
  fbist3_s0_axi_o <= fbist3_axis_o;

  ---------------------------------------------------------------------------
  -- AXI / IIC
  ---------------------------------------------------------------------------
  axi_iic : axi_iic_0
    PORT MAP (
      s_axi_aclk    => sysclk_int,
      s_axi_aresetn => sys_resetn_int,
      iic2intc_irpt => open,
      s_axi_awaddr  => axi_iic_s0_axi_awaddr(8 downto 0),
      s_axi_awvalid => axi_iic_s0_axi_awvalid,
      s_axi_awready => axi_iic_s0_axi_awready,
      s_axi_wdata   => axi_iic_s0_axi_wdata,
      s_axi_wstrb   => axi_iic_s0_axi_wstrb,
      s_axi_wvalid  => axi_iic_s0_axi_wvalid,
      s_axi_wready  => axi_iic_s0_axi_wready,
      s_axi_bresp   => axi_iic_s0_axi_bresp,
      s_axi_bvalid  => axi_iic_s0_axi_bvalid,
      s_axi_bready  => axi_iic_s0_axi_bready,
      s_axi_araddr  => axi_iic_s0_axi_araddr(8 downto 0),
      s_axi_arvalid => axi_iic_s0_axi_arvalid,
      s_axi_arready => axi_iic_s0_axi_arready,
      s_axi_rdata   => axi_iic_s0_axi_rdata,
      s_axi_rresp   => axi_iic_s0_axi_rresp,
      s_axi_rvalid  => axi_iic_s0_axi_rvalid,
      s_axi_rready  => axi_iic_s0_axi_rready,
      sda_i         => sda_i,
      sda_o         => sda_o,
      sda_t         => sda_t,
      scl_i         => scl_i,
      scl_o         => scl_o,
      scl_t         => scl_t,
      gpo           => open
      );

  axi_iic_s0_axi_awvalid          <= axi_iic_s0_axi_i.s0_axi_awvalid;
  axi_iic_s0_axi_awaddr           <= To_StdLogicVector(axi_iic_s0_axi_i.s0_axi_awaddr);
  axi_iic_s0_axi_awprot           <= To_StdLogicVector(axi_iic_s0_axi_i.s0_axi_awprot);
  axi_iic_s0_axi_wvalid           <= axi_iic_s0_axi_i.s0_axi_wvalid;
  axi_iic_s0_axi_wdata            <= To_StdLogicVector(axi_iic_s0_axi_i.s0_axi_wdata);
  axi_iic_s0_axi_wstrb            <= To_StdLogicVector(axi_iic_s0_axi_i.s0_axi_wstrb);
  axi_iic_s0_axi_bready           <= axi_iic_s0_axi_i.s0_axi_bready;
  axi_iic_s0_axi_arvalid          <= axi_iic_s0_axi_i.s0_axi_arvalid;
  axi_iic_s0_axi_araddr           <= To_StdLogicVector(axi_iic_s0_axi_i.s0_axi_araddr);
  axi_iic_s0_axi_arprot           <= To_StdLogicVector(axi_iic_s0_axi_i.s0_axi_arprot);
  axi_iic_s0_axi_rready           <= axi_iic_s0_axi_i.s0_axi_rready;
  axi_iic_s0_axi_o.s0_axi_awready <= axi_iic_s0_axi_awready;
  axi_iic_s0_axi_o.s0_axi_wready  <= axi_iic_s0_axi_wready;
  axi_iic_s0_axi_o.s0_axi_bvalid  <= axi_iic_s0_axi_bvalid;
  axi_iic_s0_axi_o.s0_axi_bresp   <= To_StdULogicVector(axi_iic_s0_axi_bresp);
  axi_iic_s0_axi_o.s0_axi_arready <= axi_iic_s0_axi_arready;
  axi_iic_s0_axi_o.s0_axi_rvalid  <= axi_iic_s0_axi_rvalid;
  axi_iic_s0_axi_o.s0_axi_rdata   <= To_StdULogicVector(axi_iic_s0_axi_rdata);
  axi_iic_s0_axi_o.s0_axi_rresp   <= To_StdULogicVector(axi_iic_s0_axi_rresp);

  i2c_scl_iobuf : iobuf
    PORT MAP (
      I  => scl_o,
      IO => scl_io,
      O  => scl_i,
      T  => scl_t
      );

  i2c_sda_iobuf : iobuf
    PORT MAP (
      I  => sda_o,
      IO => sda_io,
      O  => sda_i,
      T  => sda_t
      );

  ---------------------------------------------------------------------------
  -- DDIMM Host Configuration
  ---------------------------------------------------------------------------
  -- DDIMM 0
  oc_host_cfg0_axis_i         <= ddimm0_host_config_s0_axi_i;
  ddimm0_host_config_s0_axi_o <= oc_host_cfg0_axis_o;
  -- DDIMM 1
  oc_host_cfg1_axis_i         <= ddimm1_host_config_s0_axi_i;
  ddimm1_host_config_s0_axi_o <= oc_host_cfg1_axis_o;
  -- DDIMM 2
  oc_host_cfg2_axis_i         <= ddimm2_host_config_s0_axi_i;
  ddimm2_host_config_s0_axi_o <= oc_host_cfg2_axis_o;
  -- DDIMM 3
  oc_host_cfg3_axis_i         <= ddimm3_host_config_s0_axi_i;
  ddimm3_host_config_s0_axi_o <= oc_host_cfg3_axis_o;

  ---------------------------------------------------------------------------
  -- System Monitor
  ---------------------------------------------------------------------------
  -- TODO Attach
  sysmon_s0_axi_o.s0_axi_awready <= '0';
  sysmon_s0_axi_o.s0_axi_wready  <= '0';
  sysmon_s0_axi_o.s0_axi_bvalid  <= '0';
  sysmon_s0_axi_o.s0_axi_bresp   <= (others => '0');
  sysmon_s0_axi_o.s0_axi_arready <= '0';
  sysmon_s0_axi_o.s0_axi_rvalid  <= '0';
  sysmon_s0_axi_o.s0_axi_rdata   <= (others => '0');
  sysmon_s0_axi_o.s0_axi_rresp   <= (others => '0');

end fire_pervasive;
