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
use work.meta_pkg.all;

entity fire_fml_mac is
  port (
    ---------------------------------------------------------------------------
    -- Clocking & Power
    ---------------------------------------------------------------------------
    sysclk                          : in std_ulogic;
    sys_resetn                      : in std_ulogic;
    ddimma_resetn                   : out std_ulogic;
    ddimmb_resetn                   : out std_ulogic;
    ddimmc_resetn                   : out std_ulogic;
    ddimmd_resetn                   : out std_ulogic;
    ddimmw_resetn                   : out std_ulogic;
    ddimms_resetn                   : out std_ulogic;

    ---------------------------------------------------------------------------
    -- Register Interface (AXI4-Lite Slave)
    ---------------------------------------------------------------------------
    fml_axis_aclk                   : in std_ulogic;
    fml_axis_i                      : in t_AXI4_LITE_SLAVE_INPUT;
    fml_axis_o                      : out t_AXI4_LITE_SLAVE_OUTPUT;

    ---------------------------------------------------------------------------
    -- FML IO and Mux Logic
    ---------------------------------------------------------------------------
    fpga_ocmb_tapsel_o              : out std_ulogic;
    fpga_ddimma_mfg_tapsel_i        : in std_ulogic; --Pulled high on the DDIMMs, make this a receiver
    fpga_ddimmb_mfg_tapsel_i        : in std_ulogic; --Pulled high on the DDIMMs, make this a receiver
    fpga_ddimmc_mfg_tapsel_i        : in std_ulogic; --Pulled high on the DDIMMs, make this a receiver
    fpga_ddimmd_mfg_tapsel_i        : in std_ulogic; --Pulled high on the DDIMMs, make this a receiver
    fpga_ddimmw_mfg_tapsel_i        : in std_ulogic; --Pulled high on the DDIMMs, make this a receiver
    exp_cpu_boot_0_o                : out std_ulogic;
    exp_cpu_boot_1_o                : out std_ulogic;
    jjtag_fpga_trst_i               : in std_ulogic;
    jjtag_fpga_tck_i                : in std_ulogic;
    jjtag_fpga_tms_i                : in std_ulogic;
    jjtag_fpga_tdi_i                : in std_ulogic;
    jjtag_fpga_rst_i                : in std_ulogic;
    fpga_jjtag_tdo_o                : out std_ulogic;
    fpga_jdebug_trstb_abw_o         : out std_ulogic;   --this reset when driven by the jjtag will override the edge connector reset on DDIMM connectors (unless a 0 Ohm resistor is depopulated from the DDIMM)
    fpga_jdebug_usin_abw_o          : out std_ulogic;
    fpga_jdebug_usout_abw_i         : in std_ulogic;
    fpga_jdebug_trstb_cd_o          : out std_ulogic;
    fpga_jdebug_usin_cd_o           : out std_ulogic;
    fpga_jdebug_usout_cd_i          : in std_ulogic;
    fpga_ocmb_trstb_o               : out std_ulogic;
    fpga_ocmb_tck_o                 : out std_ulogic;
    fpga_ocmb_tms_o                 : out std_ulogic;
    fpga_ocmb_tdi_o                 : out std_ulogic;
    ocmb_fpga_tdo_i                 : in std_ulogic;
    fpga_ddimmw_tck_o               : out std_ulogic;
    fpga_ddimmw_tms_o               : out std_ulogic;
    fpga_ddimmw_tdi_o               : out std_ulogic;
    ddimmw_fpga_tdo_i               : in std_ulogic;
    fpga_ddimma_tck_o               : out std_ulogic;
    fpga_ddimma_tms_o               : out std_ulogic;
    fpga_ddimma_tdi_o               : out std_ulogic;
    ddimma_fpga_tdo_i               : in std_ulogic;
    fpga_ddimmb_tck_o               : out std_ulogic;
    fpga_ddimmb_tms_o               : out std_ulogic;
    fpga_ddimmb_tdi_o               : out std_ulogic;
    ddimmb_fpga_tdo_i               : in std_ulogic;
    fpga_ddimmc_tck_o               : out std_ulogic;
    fpga_ddimmc_tms_o               : out std_ulogic;
    fpga_ddimmc_tdi_o               : out std_ulogic;
    ddimmc_fpga_tdo_i               : in std_ulogic;
    fpga_ddimmd_tck_o               : out std_ulogic;
    fpga_ddimmd_tms_o               : out std_ulogic;
    fpga_ddimmd_tdi_o               : out std_ulogic;
    ddimmd_fpga_tdo_i               : in std_ulogic;
    fpga_usb_minib_rst_o            : out std_ulogic;
    fpga_cp2105_din2_o              : out std_ulogic;
    fpga_trs3122_din1_o             : out std_ulogic;
    fpga_trs3122_din0_o             : out std_ulogic;
    cp2105_fpga_rout2_i             : in std_ulogic;
    trs3122_fpga_rout1_i            : in std_ulogic;
    trs3122_fpga_rout0_i            : in std_ulogic;
    fpga_ocmb_usin_o                : out std_ulogic;
    ocmb_fpga_usout_sa2_i           : in std_ulogic;

    ---------------------------------------------------------------------------
    -- Function
    ---------------------------------------------------------------------------
    led_ddimma_red_hw_i             : in std_ulogic;
    led_ddimma_green_hw_i           : in std_ulogic;
    led_ddimmb_red_hw_i             : in std_ulogic;
    led_ddimmb_green_hw_i           : in std_ulogic;
    led_ddimmc_red_hw_i             : in std_ulogic;
    led_ddimmc_green_hw_i           : in std_ulogic;
    led_ddimmd_red_hw_i             : in std_ulogic;
    led_ddimmd_green_hw_i           : in std_ulogic;
    led_ddimmw_red_hw_i             : in std_ulogic;
    led_ddimmw_green_hw_i           : in std_ulogic;
    led_ddimma_red                  : out std_ulogic;
    led_ddimma_green                : out std_ulogic;
    led_ddimmb_red                  : out std_ulogic;
    led_ddimmb_green                : out std_ulogic;
    led_ddimmc_red                  : out std_ulogic;
    led_ddimmc_green                : out std_ulogic;
    led_ddimmd_red                  : out std_ulogic;
    led_ddimmd_green                : out std_ulogic;
    led_ddimmw_red                  : out std_ulogic;
    led_ddimmw_green                : out std_ulogic
    );

  attribute BLOCK_TYPE of fire_fml_mac : entity is LEAF;
  attribute BTR_NAME of fire_fml_mac : entity is "FIRE_FML_MAC";
  attribute RECURSIVE_SYNTHESIS of fire_fml_mac : entity is 2;
  attribute PIN_DATA of sysclk : signal is "PIN_FUNCTION=/G_CLK/";
end fire_fml_mac;

architecture fire_fml_mac of fire_fml_mac is

  signal fire_version               : std_ulogic_vector(31 downto 0);
  signal reset_control              : std_ulogic_vector(31 downto 0);
  signal led_control                : std_ulogic_vector(31 downto 0);
  signal led_override_enable        : std_ulogic_vector(31 downto 0);
  signal jtag_mux_control           : std_ulogic_vector(31 downto 0);
  signal uart_mux_control           : std_ulogic_vector(31 downto 0);
  signal explorer_static_io_control : std_ulogic_vector(31 downto 0);
  signal ddimm_static_io_control    : std_ulogic_vector(31 downto 0);
  signal ddimm_detect               : std_ulogic_vector(31 downto 0);

begin

  ddimma_resetn       <= reset_control(3);
  ddimmb_resetn       <= reset_control(2);
  ddimmc_resetn       <= reset_control(1);
  ddimmd_resetn       <= reset_control(0);
  ddimmw_resetn       <= reset_control(4);
  ddimms_resetn       <= reset_control(5);

  led_ddimma_red   <= led_ddimma_red_hw_i   when led_override_enable(13) = '0' else led_control(13);
  led_ddimma_green <= led_ddimma_green_hw_i when led_override_enable(12) = '0' else led_control(12);
  led_ddimmb_red   <= led_ddimmb_red_hw_i   when led_override_enable(9)  = '0' else led_control(9);
  led_ddimmb_green <= led_ddimmb_green_hw_i when led_override_enable(8)  = '0' else led_control(8);
  led_ddimmc_red   <= led_ddimmc_red_hw_i   when led_override_enable(5)  = '0' else led_control(5);
  led_ddimmc_green <= led_ddimmc_green_hw_i when led_override_enable(4)  = '0' else led_control(4);
  led_ddimmd_red   <= led_ddimmd_red_hw_i   when led_override_enable(1)  = '0' else led_control(1);
  led_ddimmd_green <= led_ddimmd_green_hw_i when led_override_enable(0)  = '0' else led_control(0);
  led_ddimmw_red   <= led_ddimmw_red_hw_i   when led_override_enable(17) = '0' else led_control(17);
  led_ddimmw_green <= led_ddimmw_green_hw_i when led_override_enable(16) = '0' else led_control(16);

  -- #BM add ddimm_detect and ddimm_detect_we
  ddimm_detect <= x"000000" & "000" 
                    & NOT(fpga_ddimmw_mfg_tapsel_i) 
                    & NOT(fpga_ddimma_mfg_tapsel_i)
                    & NOT(fpga_ddimmb_mfg_tapsel_i)
                    & NOT(fpga_ddimmc_mfg_tapsel_i)
                    & NOT(fpga_ddimmd_mfg_tapsel_i); 

  --ddimm_detect_we <= fml_axis_aclk;
  
  fml_regs : entity work.axi_regs_32
    generic map (
      REG_00_RESET       => FIRE_ICE_META_VERSION,
      REG_01_RESET       => x"0000003F",
      REG_04_RESET       => x"00000008",
      REG_05_RESET       => x"00000124",
      REG_06_RESET       => x"00000002",
      REG_07_RESET       => x"00000000",
      REG_08_WE_MASK     => x"00000000", -- readonly regs
      REG_08_HWWE_MASK   => x"0000001F"  -- updated by hardware
   --   REG_08_STICKY_MASK => x"0000001F"  -- keep value - no auto self clear to 0
      )

    port map (
      s0_axi_aclk       => fml_axis_aclk,
      s0_axi_i          => fml_axis_i,
      s0_axi_o          => fml_axis_o,
      reg_00_o          => fire_version,
      reg_01_o          => reset_control,
      reg_02_o          => led_control,
      reg_03_o          => led_override_enable,
      reg_04_o          => jtag_mux_control,
      reg_05_o          => uart_mux_control,
      reg_06_o          => explorer_static_io_control,
      reg_07_o          => ddimm_static_io_control,
      reg_08_update_i   => ddimm_detect,
      reg_08_hwwe_i     => '1'
      );


  fml_mux_io : entity work.fml_mux
    port map (
      clock                         => sysclk,
      reset                         => sys_resetn,                    --need to change this inside the fml_mac to invert
      reg_jtag_mux_cntrl_i          => jtag_mux_control,              --new
      reg_uart_mux_cntrl_i          => uart_mux_control,              --new
      reg_exp_static_io_cntrl_i     => explorer_static_io_control,    --new
      reg_ddimm_static_io_cntrl_i   => ddimm_static_io_control,       --new
      fpga_ocmb_tapsel              => fpga_ocmb_tapsel_o,              --out
      fpga_ddimma_mfg_tapsel        => fpga_ddimma_mfg_tapsel_i,        --in --Pulled high on the DDIMMs, make this a receiver
      fpga_ddimmb_mfg_tapsel        => fpga_ddimmb_mfg_tapsel_i,        --in --Pulled high on the DDIMMs, make this a receiver
      fpga_ddimmc_mfg_tapsel        => fpga_ddimmc_mfg_tapsel_i,        --in --Pulled high on the DDIMMs, make this a receiver
      fpga_ddimmd_mfg_tapsel        => fpga_ddimmd_mfg_tapsel_i,        --in --Pulled high on the DDIMMs, make this a receiver
      fpga_ddimmw_mfg_tapsel        => fpga_ddimmw_mfg_tapsel_i,        --in --Pulled high on the DDIMMs, make this a receiver
      exp_cpu_boot_0                => exp_cpu_boot_0_o,                --out
      exp_cpu_boot_1                => exp_cpu_boot_1_o,                --out
      jjtag_fpga_trst               => jjtag_fpga_trst_i,               --in
      jjtag_fpga_tck                => jjtag_fpga_tck_i,                --in
      jjtag_fpga_tms                => jjtag_fpga_tms_i,                --in
      jjtag_fpga_tdi                => jjtag_fpga_tdi_i,                --in
      jjtag_fpga_rst                => jjtag_fpga_rst_i,                --in
      fpga_jjtag_tdo                => fpga_jjtag_tdo_o,                --out
      fpga_jdebug_trstb_abw         => fpga_jdebug_trstb_abw_o,         --out --this reset when driven by the jjtag will override the edge connector reset on DDIMM connectors (unless a 0 Ohm resistor is depopulated from the DDIMM)
      fpga_jdebug_usin_abw          => fpga_jdebug_usin_abw_o,          --out
      fpga_jdebug_usout_abw         => fpga_jdebug_usout_abw_i,         --in
      fpga_jdebug_trstb_cd          => fpga_jdebug_trstb_cd_o,          --out
      fpga_jdebug_usin_cd           => fpga_jdebug_usin_cd_o,           --out
      fpga_jdebug_usout_cd          => fpga_jdebug_usout_cd_i,          --in
      fpga_ocmb_trstb               => fpga_ocmb_trstb_o,               --out
      fpga_ocmb_tck                 => fpga_ocmb_tck_o,                 --out
      fpga_ocmb_tms                 => fpga_ocmb_tms_o,                 --out
      fpga_ocmb_tdi                 => fpga_ocmb_tdi_o,                 --out
      ocmb_fpga_tdo                 => ocmb_fpga_tdo_i,                 --in
      fpga_ddimmw_tck               => fpga_ddimmw_tck_o,               --out
      fpga_ddimmw_tms               => fpga_ddimmw_tms_o,               --out
      fpga_ddimmw_tdi               => fpga_ddimmw_tdi_o,               --out
      ddimmw_fpga_tdo               => ddimmw_fpga_tdo_i,               --in
      fpga_ddimma_tck               => fpga_ddimma_tck_o,               --out
      fpga_ddimma_tms               => fpga_ddimma_tms_o,               --out
      fpga_ddimma_tdi               => fpga_ddimma_tdi_o,               --out
      ddimma_fpga_tdo               => ddimma_fpga_tdo_i,               --in
      fpga_ddimmb_tck               => fpga_ddimmb_tck_o,               --out
      fpga_ddimmb_tms               => fpga_ddimmb_tms_o,               --out
      fpga_ddimmb_tdi               => fpga_ddimmb_tdi_o,               --out
      ddimmb_fpga_tdo               => ddimmb_fpga_tdo_i,               --in
      fpga_ddimmc_tck               => fpga_ddimmc_tck_o,               --out
      fpga_ddimmc_tms               => fpga_ddimmc_tms_o,               --out
      fpga_ddimmc_tdi               => fpga_ddimmc_tdi_o,               --out
      ddimmc_fpga_tdo               => ddimmc_fpga_tdo_i,               --in
      fpga_ddimmd_tck               => fpga_ddimmd_tck_o,               --out
      fpga_ddimmd_tms               => fpga_ddimmd_tms_o,               --out
      fpga_ddimmd_tdi               => fpga_ddimmd_tdi_o,               --out
      ddimmd_fpga_tdo               => ddimmd_fpga_tdo_i,               --in
      fpga_usb_minib_rst            => fpga_usb_minib_rst_o,            --out
      fpga_cp2105_din2              => fpga_cp2105_din2_o,              --out
      fpga_trs3122_din1             => fpga_trs3122_din1_o,             --out
      fpga_trs3122_din0             => fpga_trs3122_din0_o,             --out
      cp2105_fpga_rout2             => cp2105_fpga_rout2_i,             --in
      trs3122_fpga_rout1            => trs3122_fpga_rout1_i,            --in
      trs3122_fpga_rout0            => trs3122_fpga_rout0_i,            --in
      fpga_ocmb_usin                => fpga_ocmb_usin_o,                --out
      ocmb_fpga_usout_sa2           => ocmb_fpga_usout_sa2_i            --in
      );


end fire_fml_mac;
