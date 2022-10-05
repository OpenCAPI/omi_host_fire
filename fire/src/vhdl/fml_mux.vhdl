
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

-- library ieee,ibm,support,work;
library ieee;
use ieee.std_logic_1164.all;
-- use ibm.synthesis_support.all;
-- use ibm.std_ulogic_support.all;
-- use ibm.std_ulogic_unsigned.all;
-- use ibm.std_ulogic_function_support.all;
-- use support.logic_support_pkg.all;
-- use work.fbist_pkg.all;

entity fml_mux is
  port (
    clock : in std_ulogic;
    reset : in std_ulogic;  --from pca4_qfpga_reset on apollo 1z fpga_reset is the inversion of pca4_qfpga_rese

    --Register Interfaces
    reg_jtag_mux_cntrl_i          : in std_ulogic_vector(31 downto 0);  --new
    reg_uart_mux_cntrl_i          : in std_ulogic_vector(31 downto 0);  --new
    reg_exp_static_io_cntrl_i     : in std_ulogic_vector(31 downto 0);  --new
    reg_ddimm_static_io_cntrl_i   : in std_ulogic_vector(31 downto 0);  --new

    --Temp Location for Boot Strap Pins
    fpga_ocmb_tapsel       : out std_ulogic;                                                      --FPGA IO
    fpga_ddimma_mfg_tapsel : in std_ulogic;  --Pulled high on the DDIMMs, make this a receiver    --FPGA IO
    fpga_ddimmb_mfg_tapsel : in std_ulogic;  --Pulled high on the DDIMMs, make this a receiver    --FPGA IO
    fpga_ddimmc_mfg_tapsel : in std_ulogic;  --Pulled high on the DDIMMs, make this a receiver    --FPGA IO
    fpga_ddimmd_mfg_tapsel : in std_ulogic;  --Pulled high on the DDIMMs, make this a receiver    --FPGA IO
    fpga_ddimmw_mfg_tapsel : in std_ulogic;  --Pulled high on the DDIMMs, make this a receiver    --FPGA IO

    exp_cpu_boot_0      : out std_ulogic;                                                         --FPGA IO
    exp_cpu_boot_1      : out std_ulogic;                                                         --FPGA IO

    --EJTAG Connector JTAG Interface
    jjtag_fpga_trst     : in  std_ulogic;                                                         --FPGA IO
    jjtag_fpga_tck      : in  std_ulogic;                                                         --FPGA IO
    jjtag_fpga_tms      : in  std_ulogic;                                                         --FPGA IO
    jjtag_fpga_tdi      : in  std_ulogic;                                                         --FPGA IO
    jjtag_fpga_rst      : in  std_ulogic;                                                         --FPGA IO
    --jjtag_fpga_dint     : in  std_ulogic;

    fpga_jjtag_tdo      : out std_ulogic;                                                         --FPGA IO

    --DDIMM Debug Connectors
    fpga_jdebug_trstb_abw      : out std_ulogic;     --FPGA IO   --this reset when driven by the jjtag will override the edge connector reset on DDIMM connectors (unless a 0 Ohm resistor is depopulated from the DDIMM)
    --fpga_jdebug_ejtag_rstb_abw : out std_ulogic;   --FPGA IO   --temporay driven using the gpio - see the reset input from pca4_qfpga_reset
    fpga_jdebug_usin_abw       : out std_ulogic;     --FPGA IO
    fpga_jdebug_usout_abw      : in  std_ulogic;     --FPGA IO

    fpga_jdebug_trstb_cd       : out std_ulogic;     --FPGA IO
    --fpga_jdebug_ejtag_rstb_cd  : out std_ulogic;   --FPGA IO
    fpga_jdebug_usin_cd        : out std_ulogic;     --FPGA IO
    fpga_jdebug_usout_cd       : in  std_ulogic;     --FPGA IO

    --Explorer "OCMB" JTAG Interface
    fpga_ocmb_trstb     : out std_ulogic;            --FPGA IO
    fpga_ocmb_tck       : out std_ulogic;            --FPGA IO
    fpga_ocmb_tms       : out std_ulogic;            --FPGA IO
    fpga_ocmb_tdi       : out std_ulogic;            --FPGA IO
    --fpga_ocmb_rst       : out std_ulogic;          --FPGA IO

    ocmb_fpga_tdo       : in  std_ulogic;            --FPGA IO

    --DDIMMW JTAG
    fpga_ddimmw_tck       : out std_ulogic;          --FPGA IO
    fpga_ddimmw_tms       : out std_ulogic;          --FPGA IO
    fpga_ddimmw_tdi       : out std_ulogic;          --FPGA IO
    --fpga_ddimmw_rst       : out std_ulogic;        --FPGA IO

    ddimmw_fpga_tdo       : in  std_ulogic;         --FPGA IO
    --DDIMMA JTAG
    fpga_ddimma_tck       : out std_ulogic;         --FPGA IO
    fpga_ddimma_tms       : out std_ulogic;         --FPGA IO
    fpga_ddimma_tdi       : out std_ulogic;         --FPGA IO
    --fpga_ddimma_rst       : out std_ulogic;       --FPGA IO

    ddimma_fpga_tdo       : in  std_ulogic;         --FPGA IO
    --DDIMMB JTAG
    fpga_ddimmb_tck       : out std_ulogic;         --FPGA IO
    fpga_ddimmb_tms       : out std_ulogic;         --FPGA IO
    fpga_ddimmb_tdi       : out std_ulogic;         --FPGA IO
    --fpga_ddimmb_rst       : out std_ulogic;       --FPGA IO

    ddimmb_fpga_tdo       : in  std_ulogic;         --FPGA IO
    --DDIMMC JTAG
    fpga_ddimmc_tck       : out std_ulogic;         --FPGA IO
    fpga_ddimmc_tms       : out std_ulogic;         --FPGA IO
    fpga_ddimmc_tdi       : out std_ulogic;         --FPGA IO
    --fpga_ddimmc_rst       : out std_ulogic;       --FPGA IO

    ddimmc_fpga_tdo       : in  std_ulogic;         --FPGA IO
    --DDIMMA JTAG
    fpga_ddimmd_tck       : out std_ulogic;         --FPGA IO
    fpga_ddimmd_tms       : out std_ulogic;         --FPGA IO
    fpga_ddimmd_tdi       : out std_ulogic;         --FPGA IO
    --fpga_ddimmd_rst       : out std_ulogic;       --FPGA IO

    ddimmd_fpga_tdo       : in  std_ulogic;         --FPGA IO


    --UART Buffer
    fpga_usb_minib_rst  : out std_ulogic;           --FPGA IO
    fpga_cp2105_din2    : out std_ulogic;           --FPGA IO
    fpga_trs3122_din1   : out std_ulogic;           --FPGA IO
    fpga_trs3122_din0   : out std_ulogic;           --FPGA IO

    cp2105_fpga_rout2   : in  std_ulogic;           --FPGA IO
    trs3122_fpga_rout1  : in  std_ulogic;           --FPGA IO
    trs3122_fpga_rout0  : in  std_ulogic;           --FPGA IO

    fpga_ocmb_usin      : out std_ulogic;           --FPGA IO

    ocmb_fpga_usout_sa2 : in  std_ulogic            --FPGA IO

    );

  -- attribute BLOCK_TYPE of fml_mux : entity is LEAF;
  -- attribute BTR_NAME of fml_mux : entity is "fml_mux";
  -- attribute RECURSIVE_SYNTHESIS of fml_mux : entity is 2;
  -- attribute PIN_DATA of clock : signal is "PIN_FUNCTION=/G_CLK/";
end fml_mux;

architecture fml_mux of fml_mux is

  SIGNAL reg_jtag_mux_cntrl_int        : std_ulogic_vector(31 downto 0);
  SIGNAL reg_uart_mux_cntrl_int        : std_ulogic_vector(31 downto 0);
  SIGNAL reg_exp_static_io_cntrl_int   : std_ulogic_vector(31 downto 0);
  SIGNAL reg_ddimm_static_io_cntrl_int : std_ulogic_vector(31 downto 0);

  SIGNAL jjtag_fpga_tck_d : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_fpga_tck_q : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_ocmb_tck_d : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_ocmb_tck_q : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_ddimmw_tck_d : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_ddimmw_tck_q : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_ddimma_tck_d : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_ddimma_tck_q : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_ddimmb_tck_d : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_ddimmb_tck_q : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_ddimmc_tck_d : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_ddimmc_tck_q : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_ddimmd_tck_d : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_ddimmd_tck_q : std_ulogic_vector(1 downto 0);

  SIGNAL jjtag_fpga_tms_d : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_fpga_tms_q : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_ocmb_tms_d : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_ocmb_tms_q : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_ddimmw_tms_d : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_ddimmw_tms_q : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_ddimma_tms_d : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_ddimma_tms_q : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_ddimmb_tms_d : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_ddimmb_tms_q : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_ddimmc_tms_d : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_ddimmc_tms_q : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_ddimmd_tms_d : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_ddimmd_tms_q : std_ulogic_vector(1 downto 0);

  SIGNAL jjtag_fpga_tdi_d : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_fpga_tdi_q : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_ocmb_tdi_d : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_ocmb_tdi_q : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_ddimmw_tdi_d : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_ddimmw_tdi_q : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_ddimma_tdi_d : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_ddimma_tdi_q : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_ddimmb_tdi_d : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_ddimmb_tdi_q : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_ddimmc_tdi_d : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_ddimmc_tdi_q : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_ddimmd_tdi_d : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_ddimmd_tdi_q : std_ulogic_vector(1 downto 0);

  SIGNAL jjtag_fpga_trst_d : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_fpga_trst_q : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_ocmb_trstb_d : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_ocmb_trstb_q : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_jdebug_trstb_abw_d : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_jdebug_trstb_abw_q : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_jdebug_trstb_cd_d : std_ulogic_vector(1 downto 0);
  SIGNAL jjtag_jdebug_trstb_cd_q : std_ulogic_vector(1 downto 0);


  --SIGNAL jjtag_fpga_rst_d : std_ulogic_vector(1 downto 0);
  --SIGNAL jjtag_fpga_rst_q : std_ulogic_vector(1 downto 0);
  --SIGNAL jjtag_ocmb_rst_d : std_ulogic_vector(1 downto 0);
  --SIGNAL jjtag_ocmb_rst_q : std_ulogic_vector(1 downto 0);
  --SIGNAL jjtag_ddimmw_rst_d : std_ulogic_vector(1 downto 0);
  --SIGNAL jjtag_ddimmw_rst_q : std_ulogic_vector(1 downto 0);
  --SIGNAL jjtag_ddimma_rst_d : std_ulogic_vector(1 downto 0);
  --SIGNAL jjtag_ddimma_rst_q : std_ulogic_vector(1 downto 0);
  --SIGNAL jjtag_ddimmb_rst_d : std_ulogic_vector(1 downto 0);
  --SIGNAL jjtag_ddimmb_rst_q : std_ulogic_vector(1 downto 0);
  --SIGNAL jjtag_ddimmc_rst_d : std_ulogic_vector(1 downto 0);
  --SIGNAL jjtag_ddimmc_rst_q : std_ulogic_vector(1 downto 0);
  --SIGNAL jjtag_ddimmd_rst_d : std_ulogic_vector(1 downto 0);
  --SIGNAL jjtag_ddimmd_rst_q : std_ulogic_vector(1 downto 0);


  SIGNAL fpga_jjtag_tdo_d : std_ulogic_vector(1 downto 0);
  SIGNAL fpga_jjtag_tdo_q : std_ulogic_vector(1 downto 0);
  SIGNAL ocmb_fpga_tdo_d : std_ulogic_vector(1 downto 0);
  SIGNAL ocmb_fpga_tdo_q : std_ulogic_vector(1 downto 0);
  SIGNAL ddimmw_fpga_tdo_d : std_ulogic_vector(1 downto 0);
  SIGNAL ddimmw_fpga_tdo_q : std_ulogic_vector(1 downto 0);
  SIGNAL ddimma_fpga_tdo_d : std_ulogic_vector(1 downto 0);
  SIGNAL ddimma_fpga_tdo_q : std_ulogic_vector(1 downto 0);
  SIGNAL ddimmb_fpga_tdo_d : std_ulogic_vector(1 downto 0);
  SIGNAL ddimmb_fpga_tdo_q : std_ulogic_vector(1 downto 0);
  SIGNAL ddimmc_fpga_tdo_d : std_ulogic_vector(1 downto 0);
  SIGNAL ddimmc_fpga_tdo_q : std_ulogic_vector(1 downto 0);
  SIGNAL ddimmd_fpga_tdo_d : std_ulogic_vector(1 downto 0);
  SIGNAL ddimmd_fpga_tdo_q : std_ulogic_vector(1 downto 0);

  SIGNAL fpga_cp2105_din2_d : std_ulogic_vector(1 downto 0);
  SIGNAL fpga_cp2105_din2_q : std_ulogic_vector(1 downto 0);
  SIGNAL fpga_trs3122_din1_d : std_ulogic_vector(1 downto 0);
  SIGNAL fpga_trs3122_din1_q : std_ulogic_vector(1 downto 0);
  SIGNAL fpga_trs3122_din0_d : std_ulogic_vector(1 downto 0);
  SIGNAL fpga_trs3122_din0_q : std_ulogic_vector(1 downto 0);
  SIGNAL ocmb_fpga_usout_d   : std_ulogic_vector(1 downto 0);
  SIGNAL ocmb_fpga_usout_q   : std_ulogic_vector(1 downto 0);
  SIGNAL fpga_jdebug_usout_abw_d   : std_ulogic_vector(1 downto 0);
  SIGNAL fpga_jdebug_usout_abw_q   : std_ulogic_vector(1 downto 0);
  SIGNAL fpga_jdebug_usout_cd_d    : std_ulogic_vector(1 downto 0);
  SIGNAL fpga_jdebug_usout_cd_q    : std_ulogic_vector(1 downto 0);

  SIGNAL cp2105_fpga_rout2_d  : std_ulogic_vector(1 downto 0);
  SIGNAL cp2105_fpga_rout2_q  : std_ulogic_vector(1 downto 0);
  SIGNAL trs3122_fpga_rout1_d : std_ulogic_vector(1 downto 0);
  SIGNAL trs3122_fpga_rout1_q : std_ulogic_vector(1 downto 0);
  SIGNAL trs3122_fpga_rout0_d : std_ulogic_vector(1 downto 0);
  SIGNAL trs3122_fpga_rout0_q : std_ulogic_vector(1 downto 0);
  SIGNAL fpga_ocmb_usin_d     : std_ulogic_vector(1 downto 0);
  SIGNAL fpga_ocmb_usin_q     : std_ulogic_vector(1 downto 0);
  SIGNAL fpga_jdebug_usin_abw_d     : std_ulogic_vector(1 downto 0);
  SIGNAL fpga_jdebug_usin_abw_q     : std_ulogic_vector(1 downto 0);
  SIGNAL fpga_jdebug_usin_cd_d      : std_ulogic_vector(1 downto 0);
  SIGNAL fpga_jdebug_usin_cd_q      : std_ulogic_vector(1 downto 0);


  SIGNAL fpga_cp2105_din2_gated   : std_ulogic;
  SIGNAL fpga_trs3122_din1_gated  : std_ulogic;
  SIGNAL fpga_trs3122_din0_gated  : std_ulogic;
  SIGNAL fpga_cp2105_2_select  : std_ulogic;
  SIGNAL fpga_trs3122_1_select : std_ulogic;
  SIGNAL fpga_trs3122_0_select : std_ulogic;

  SIGNAL fpga_ocmb_uart_select : std_ulogic;
  SIGNAL fpga_jdebug_abw_uart_select : std_ulogic;
  SIGNAL fpga_jdebug_cd_uart_select : std_ulogic;

  SIGNAL fpga_jdebug_usin_abw_gated     : std_ulogic;
  SIGNAL fpga_jdebug_usin_cd_gated      : std_ulogic;
  SIGNAL fpga_ocmb_usin_gated     : std_ulogic;
  SIGNAL fpga_ocmb_tapsel_int     : std_ulogic;
  SIGNAL fpga_ocmb_tapsel_int_tmp : std_ulogic;
  SIGNAL exp_cpu_boot_0_int       : std_ulogic;
  SIGNAL exp_cpu_boot_1_int       : std_ulogic;
  SIGNAL fpga_reset_invert        : std_ulogic;

  SIGNAL fpga_usin_select         : std_ulogic;
  SIGNAL fpga_usout_select        : std_ulogic;

  SIGNAL ocmb_jtag_select         : std_ulogic;
  SIGNAL ddimmw_jtag_select       : std_ulogic;
  SIGNAL ddimma_jtag_select       : std_ulogic;
  SIGNAL ddimmb_jtag_select       : std_ulogic;
  SIGNAL ddimmc_jtag_select       : std_ulogic;
  SIGNAL ddimmd_jtag_select       : std_ulogic;

  signal reset_int                : std_ulogic;
  --SIGNAL ocmb_reset_select         : std_ulogic;
  --SIGNAL ddimmw_reset_select       : std_ulogic;
  --SIGNAL ddimma_reset_select       : std_ulogic;
  --SIGNAL ddimmb_reset_select       : std_ulogic;
  --SIGNAL ddimmc_reset_select       : std_ulogic;
  --SIGNAL ddimmd_reset_select       : std_ulogic;

begin

  --Map register inputs to internal signals
  reg_jtag_mux_cntrl_int(31 downto 0)         <= reg_jtag_mux_cntrl_i(31 downto 0);
  reg_uart_mux_cntrl_int(31 downto 0)         <= reg_uart_mux_cntrl_i(31 downto 0);
  reg_exp_static_io_cntrl_int(31 downto 0)    <= reg_exp_static_io_cntrl_i(31 downto 0);
  reg_ddimm_static_io_cntrl_int(31 downto 0)  <= reg_ddimm_static_io_cntrl_i(31 downto 0);


  --Invert fpga_reset to match pca4_qfpga_reset on the apollo 1z board
  reset_int         <= reset;
  fpga_reset_invert <= NOT reset_int;


  --Select the UART DUT connections (replace with I2C register control)
  --fpga_jdebug_abw_uart_select <= '1';
  --fpga_jdebug_cd_uart_select  <= '0';
  --fpga_ocmb_uart_select <= '0';
  fpga_ocmb_uart_select       <= (    reg_uart_mux_cntrl_int(6) AND NOT reg_uart_mux_cntrl_int(5) AND NOT reg_uart_mux_cntrl_int(4));
  fpga_jdebug_abw_uart_select <= (NOT reg_uart_mux_cntrl_int(6) AND     reg_uart_mux_cntrl_int(5) AND NOT reg_uart_mux_cntrl_int(4));
  fpga_jdebug_cd_uart_select  <= (NOT reg_uart_mux_cntrl_int(6) AND NOT reg_uart_mux_cntrl_int(5) AND     reg_uart_mux_cntrl_int(4));


  --Select the JTAG target
  --ocmb_jtag_select   <= '0';
  --ddimmw_jtag_select <= '0';
  --ddimma_jtag_select <= '1';
  --ddimmb_jtag_select <= '0';
  --ddimmc_jtag_select <= '0';
  --ddimmd_jtag_select <= '0';
  ocmb_jtag_select   <= (    reg_jtag_mux_cntrl_int(5) AND NOT reg_jtag_mux_cntrl_int(4) AND NOT reg_jtag_mux_cntrl_int(3) AND NOT reg_jtag_mux_cntrl_int(2) AND NOT reg_jtag_mux_cntrl_int(1) AND NOT reg_jtag_mux_cntrl_int(0));
  ddimmw_jtag_select <= (NOT reg_jtag_mux_cntrl_int(5) AND     reg_jtag_mux_cntrl_int(4) AND NOT reg_jtag_mux_cntrl_int(3) AND NOT reg_jtag_mux_cntrl_int(2) AND NOT reg_jtag_mux_cntrl_int(1) AND NOT reg_jtag_mux_cntrl_int(0));
  ddimma_jtag_select <= (NOT reg_jtag_mux_cntrl_int(5) AND NOT reg_jtag_mux_cntrl_int(4) AND     reg_jtag_mux_cntrl_int(3) AND NOT reg_jtag_mux_cntrl_int(2) AND NOT reg_jtag_mux_cntrl_int(1) AND NOT reg_jtag_mux_cntrl_int(0));
  ddimmb_jtag_select <= (NOT reg_jtag_mux_cntrl_int(5) AND NOT reg_jtag_mux_cntrl_int(4) AND NOT reg_jtag_mux_cntrl_int(3) AND     reg_jtag_mux_cntrl_int(2) AND NOT reg_jtag_mux_cntrl_int(1) AND NOT reg_jtag_mux_cntrl_int(0));
  ddimmc_jtag_select <= (NOT reg_jtag_mux_cntrl_int(5) AND NOT reg_jtag_mux_cntrl_int(4) AND NOT reg_jtag_mux_cntrl_int(3) AND NOT reg_jtag_mux_cntrl_int(2) AND     reg_jtag_mux_cntrl_int(1) AND NOT reg_jtag_mux_cntrl_int(0));
  ddimmd_jtag_select <= (NOT reg_jtag_mux_cntrl_int(5) AND NOT reg_jtag_mux_cntrl_int(4) AND NOT reg_jtag_mux_cntrl_int(3) AND NOT reg_jtag_mux_cntrl_int(2) AND NOT reg_jtag_mux_cntrl_int(1) AND     reg_jtag_mux_cntrl_int(0));



  --Select the RESET target
  --ocmb_reset_select   <= '1';
  --ddimmw_reset_select <= '1';
  --ddimma_reset_select <= '1';
  --ddimmb_reset_select <= '1';
  --ddimmc_reset_select <= '1';
  --ddimmd_reset_select <= '1';


  --Select the UART terminal connection (replace with I2C register control)
  --fpga_cp2105_2_select  <= '1';
  --fpga_trs3122_1_select <= '0';
  --fpga_trs3122_0_select <= '0';
  fpga_cp2105_2_select  <= (    reg_uart_mux_cntrl_int(2) AND NOT reg_uart_mux_cntrl_int(1) AND NOT reg_uart_mux_cntrl_int(0));
  fpga_trs3122_1_select <= (NOT reg_uart_mux_cntrl_int(2) AND     reg_uart_mux_cntrl_int(1) AND NOT reg_uart_mux_cntrl_int(0));
  fpga_trs3122_0_select <= (NOT reg_uart_mux_cntrl_int(2) AND NOT reg_uart_mux_cntrl_int(1) AND     reg_uart_mux_cntrl_int(0));

  --Temp drive everyone with the same tapsel value  (tapsel 1 = EJTAG, tapsel 0 = JTAG)
  --fpga_ocmb_tapsel_int   <= '1';
  fpga_ocmb_tapsel_int   <= reg_exp_static_io_cntrl_int(29);  --may need to AND with reset_n to prevent driving high prior to power on of the Explorer
  fpga_ocmb_tapsel <= fpga_ocmb_tapsel_int;

  --These signals are pulled high on the DDIMM, perhaps we will monitor them by updating a register in the future
  fpga_ocmb_tapsel_int_tmp <= fpga_ddimma_mfg_tapsel
                           OR fpga_ddimmb_mfg_tapsel
                           OR fpga_ddimmc_mfg_tapsel
                           OR fpga_ddimmd_mfg_tapsel
                           OR fpga_ddimmw_mfg_tapsel;



  --Need to update with a definition of the cpu_boot decode
  --exp_cpu_boot_0_int    <= '1';
  exp_cpu_boot_0_int    <= reg_exp_static_io_cntrl_int(1);
  --exp_cpu_boot_1_int    <= '0';
  exp_cpu_boot_1_int    <= reg_exp_static_io_cntrl_int(0);
  exp_cpu_boot_0 <= exp_cpu_boot_0_int;
  exp_cpu_boot_1 <= exp_cpu_boot_1_int;


  --fpga_usb_minib_rst <= fpga_reset_invert;
  --fpga_usb_minib_rst <= reset_int;
  fpga_usb_minib_rst <= reset_int AND reg_uart_mux_cntrl_int(8);

  -----------------------------------------------------------------------------
  -- Pipelines
  -----------------------------------------------------------------------------
  --jjtag_fpga_rst_d(3)        <= jjtag_fpga_rst ;  --temporary control of reset using gpio
  --jjtag_fpga_rst_d(1)        <= fpga_reset_invert;
  --jjtag_fpga_rst_d(0)        <= jjtag_fpga_rst_q(1);

  --jjtag_ocmb_rst_d(1)        <= ocmb_reset_select AND jjtag_fpga_rst_q(0);
  --jjtag_ocmb_rst_d(0)        <= jjtag_ocmb_rst_q(1);
  --fpga_ocmb_rst              <= jjtag_ocmb_rst_q(0);
  --jjtag_ddimmw_rst_d(1)      <= ddimmw_reset_select AND jjtag_fpga_rst_q(0);
  --jjtag_ddimmw_rst_d(0)      <= jjtag_ddimmw_rst_q(1);
  --fpga_ddimmw_rst            <= jjtag_ddimmw_rst_q(0);
  --jjtag_ddimma_rst_d(1)      <= ddimma_reset_select AND jjtag_fpga_rst_q(0);
  --jjtag_ddimma_rst_d(0)      <= jjtag_ddimma_rst_q(1);
  --fpga_ddimma_rst            <= jjtag_ddimma_rst_q(0);
  --jjtag_ddimmb_rst_d(1)      <= ddimmb_reset_select AND jjtag_fpga_rst_q(0);
  --jjtag_ddimmb_rst_d(0)      <= jjtag_ddimmb_rst_q(1);
  --fpga_ddimmb_rst            <= jjtag_ddimmb_rst_q(0);
  --jjtag_ddimmc_rst_d(1)      <= ddimmc_reset_select AND jjtag_fpga_rst_q(0);
  --jjtag_ddimmc_rst_d(0)      <= jjtag_ddimmc_rst_q(1);
  --fpga_ddimmc_rst            <= jjtag_ddimmc_rst_q(0);
  --jjtag_ddimmd_rst_d(1)      <= ddimmd_reset_select AND jjtag_fpga_rst_q(0);
  --jjtag_ddimmd_rst_d(0)      <= jjtag_ddimmd_rst_q(1);
  --fpga_ddimmd_rst            <= jjtag_ddimmd_rst_q(0);

  jjtag_fpga_trst_d(1)        <= jjtag_fpga_trst;
  jjtag_fpga_trst_d(0)        <= jjtag_fpga_trst_q(1);
  jjtag_ocmb_trstb_d(1)       <= fpga_ocmb_uart_select AND jjtag_fpga_trst_q(0);
  jjtag_ocmb_trstb_d(0)       <= jjtag_ocmb_trstb_q(1);
  fpga_ocmb_trstb             <= jjtag_ocmb_trstb_q(0);
  jjtag_jdebug_trstb_abw_d(1) <= fpga_jdebug_abw_uart_select AND jjtag_fpga_trst_q(0);
  jjtag_jdebug_trstb_abw_d(0) <= jjtag_jdebug_trstb_abw_q(1);
  fpga_jdebug_trstb_abw       <= jjtag_jdebug_trstb_abw_q(0);
  jjtag_jdebug_trstb_cd_d(1)  <= fpga_jdebug_cd_uart_select AND jjtag_fpga_trst_q(0);
  jjtag_jdebug_trstb_cd_d(0)  <= jjtag_jdebug_trstb_cd_q(1);
  fpga_jdebug_trstb_cd        <= jjtag_jdebug_trstb_cd_q(0);

  jjtag_fpga_tck_d(1)        <= jjtag_fpga_tck;
  jjtag_fpga_tck_d(0)        <= jjtag_fpga_tck_q(1);
  jjtag_ocmb_tck_d(1)        <= ocmb_jtag_select AND jjtag_fpga_tck_q(0);
  jjtag_ocmb_tck_d(0)        <= jjtag_ocmb_tck_q(1);
  fpga_ocmb_tck              <= jjtag_ocmb_tck_q(0);
  jjtag_ddimmw_tck_d(1)      <= ddimmw_jtag_select AND jjtag_fpga_tck_q(0);
  jjtag_ddimmw_tck_d(0)      <= jjtag_ddimmw_tck_q(1);
  fpga_ddimmw_tck            <= jjtag_ddimmw_tck_q(0);
  jjtag_ddimma_tck_d(1)      <= ddimma_jtag_select AND jjtag_fpga_tck_q(0);
  jjtag_ddimma_tck_d(0)      <= jjtag_ddimma_tck_q(1);
  fpga_ddimma_tck            <= jjtag_ddimma_tck_q(0);
  jjtag_ddimmb_tck_d(1)      <= ddimmb_jtag_select AND jjtag_fpga_tck_q(0);
  jjtag_ddimmb_tck_d(0)      <= jjtag_ddimmb_tck_q(1);
  fpga_ddimmb_tck            <= jjtag_ddimmb_tck_q(0);
  jjtag_ddimmc_tck_d(1)      <= ddimmc_jtag_select AND jjtag_fpga_tck_q(0);
  jjtag_ddimmc_tck_d(0)      <= jjtag_ddimmc_tck_q(1);
  fpga_ddimmc_tck            <= jjtag_ddimmc_tck_q(0);
  jjtag_ddimmd_tck_d(1)      <= ddimmd_jtag_select AND jjtag_fpga_tck_q(0);
  jjtag_ddimmd_tck_d(0)      <= jjtag_ddimmd_tck_q(1);
  fpga_ddimmd_tck            <= jjtag_ddimmd_tck_q(0);

  jjtag_fpga_tms_d(1)        <= jjtag_fpga_tms;
  jjtag_fpga_tms_d(0)        <= jjtag_fpga_tms_q(1);
  jjtag_ocmb_tms_d(1)        <= ocmb_jtag_select AND jjtag_fpga_tms_q(0);
  jjtag_ocmb_tms_d(0)        <= jjtag_ocmb_tms_q(1);
  fpga_ocmb_tms              <= jjtag_ocmb_tms_q(0);
  jjtag_ddimmw_tms_d(1)      <= ddimmw_jtag_select AND jjtag_fpga_tms_q(0);
  jjtag_ddimmw_tms_d(0)      <= jjtag_ddimmw_tms_q(1);
  fpga_ddimmw_tms            <= jjtag_ddimmw_tms_q(0);
  jjtag_ddimma_tms_d(1)      <= ddimma_jtag_select AND jjtag_fpga_tms_q(0);
  jjtag_ddimma_tms_d(0)      <= jjtag_ddimma_tms_q(1);
  fpga_ddimma_tms            <= jjtag_ddimma_tms_q(0);
  jjtag_ddimmb_tms_d(1)      <= ddimmb_jtag_select AND jjtag_fpga_tms_q(0);
  jjtag_ddimmb_tms_d(0)      <= jjtag_ddimmb_tms_q(1);
  fpga_ddimmb_tms            <= jjtag_ddimmb_tms_q(0);
  jjtag_ddimmc_tms_d(1)      <= ddimmc_jtag_select AND jjtag_fpga_tms_q(0);
  jjtag_ddimmc_tms_d(0)      <= jjtag_ddimmc_tms_q(1);
  fpga_ddimmc_tms            <= jjtag_ddimmc_tms_q(0);
  jjtag_ddimmd_tms_d(1)      <= ddimmd_jtag_select AND jjtag_fpga_tms_q(0);
  jjtag_ddimmd_tms_d(0)      <= jjtag_ddimmd_tms_q(1);
  fpga_ddimmd_tms            <= jjtag_ddimmd_tms_q(0);

  jjtag_fpga_tdi_d(1)        <= jjtag_fpga_tdi;
  jjtag_fpga_tdi_d(0)        <= jjtag_fpga_tdi_q(1);
  jjtag_ocmb_tdi_d(1)        <= ocmb_jtag_select AND jjtag_fpga_tdi_q(0);
  jjtag_ocmb_tdi_d(0)        <= jjtag_ocmb_tdi_q(1);
  fpga_ocmb_tdi              <= jjtag_ocmb_tdi_q(0);
  jjtag_ddimmw_tdi_d(1)      <= ddimmw_jtag_select AND jjtag_fpga_tdi_q(0);
  jjtag_ddimmw_tdi_d(0)      <= jjtag_ddimmw_tdi_q(1);
  fpga_ddimmw_tdi            <= jjtag_ddimmw_tdi_q(0);
  jjtag_ddimma_tdi_d(1)      <= ddimma_jtag_select AND jjtag_fpga_tdi_q(0);
  jjtag_ddimma_tdi_d(0)      <= jjtag_ddimma_tdi_q(1);
  fpga_ddimma_tdi            <= jjtag_ddimma_tdi_q(0);
  jjtag_ddimmb_tdi_d(1)      <= ddimmb_jtag_select AND jjtag_fpga_tdi_q(0);
  jjtag_ddimmb_tdi_d(0)      <= jjtag_ddimmb_tdi_q(1);
  fpga_ddimmb_tdi            <= jjtag_ddimmb_tdi_q(0);
  jjtag_ddimmc_tdi_d(1)      <= ddimmc_jtag_select AND jjtag_fpga_tdi_q(0);
  jjtag_ddimmc_tdi_d(0)      <= jjtag_ddimmc_tdi_q(1);
  fpga_ddimmc_tdi            <= jjtag_ddimmc_tdi_q(0);
  jjtag_ddimmd_tdi_d(1)      <= ddimmd_jtag_select AND jjtag_fpga_tdi_q(0);
  jjtag_ddimmd_tdi_d(0)      <= jjtag_ddimmd_tdi_q(1);
  fpga_ddimmd_tdi            <= jjtag_ddimmd_tdi_q(0);

  ocmb_fpga_tdo_d(1)        <= ocmb_fpga_tdo;
  ocmb_fpga_tdo_d(0)        <= ocmb_fpga_tdo_q(1);
  ddimmw_fpga_tdo_d(1)      <= ddimmw_fpga_tdo;
  ddimmw_fpga_tdo_d(0)      <= ddimmw_fpga_tdo_q(1);
  ddimma_fpga_tdo_d(1)      <= ddimma_fpga_tdo;
  ddimma_fpga_tdo_d(0)      <= ddimma_fpga_tdo_q(1);
  ddimmb_fpga_tdo_d(1)      <= ddimmb_fpga_tdo;
  ddimmb_fpga_tdo_d(0)      <= ddimmb_fpga_tdo_q(1);
  ddimmc_fpga_tdo_d(1)      <= ddimmc_fpga_tdo;
  ddimmc_fpga_tdo_d(0)      <= ddimmc_fpga_tdo_q(1);
  ddimmd_fpga_tdo_d(1)      <= ddimmd_fpga_tdo;
  ddimmd_fpga_tdo_d(0)      <= ddimmd_fpga_tdo_q(1);

  fpga_jjtag_tdo_d(1)       <= (ddimmw_jtag_select AND ddimmw_fpga_tdo_q(0))
                            OR (ddimma_jtag_select AND ddimma_fpga_tdo_q(0))
                            OR (ddimmb_jtag_select AND ddimmb_fpga_tdo_q(0))
                            OR (ddimmc_jtag_select AND ddimmc_fpga_tdo_q(0))
                            OR (ddimmd_jtag_select AND ddimmd_fpga_tdo_q(0))
                            OR (ocmb_jtag_select   AND ocmb_fpga_tdo_q(0));
  fpga_jjtag_tdo_d(0)       <= fpga_jjtag_tdo_q(1);
  fpga_jjtag_tdo            <= fpga_jjtag_tdo_q(0);

  fpga_cp2105_din2_d(1)     <= fpga_cp2105_din2_gated;
  fpga_cp2105_din2_d(0)     <= fpga_cp2105_din2_q(1);
  fpga_cp2105_din2          <= fpga_cp2105_din2_q(0);

  fpga_trs3122_din1_d(1)     <= fpga_trs3122_din1_gated;
  fpga_trs3122_din1_d(0)     <= fpga_trs3122_din1_q(1);
  fpga_trs3122_din1          <= fpga_trs3122_din1_q(0);

  fpga_trs3122_din0_d(1)     <= fpga_trs3122_din0_gated;
  fpga_trs3122_din0_d(0)     <= fpga_trs3122_din0_q(1);
  fpga_trs3122_din0          <= fpga_trs3122_din0_q(0);

  ocmb_fpga_usout_d(1)       <= ocmb_fpga_usout_sa2;
  ocmb_fpga_usout_d(0)       <= ocmb_fpga_usout_q(1);

  fpga_jdebug_usout_abw_d(1) <= fpga_jdebug_usout_abw;
  fpga_jdebug_usout_abw_d(0) <= fpga_jdebug_usout_abw_q(1);

  fpga_jdebug_usout_cd_d(1) <= fpga_jdebug_usout_cd;
  fpga_jdebug_usout_cd_d(0) <= fpga_jdebug_usout_cd_q(1);

  cp2105_fpga_rout2_d(1)     <= cp2105_fpga_rout2;
  cp2105_fpga_rout2_d(0)     <= cp2105_fpga_rout2_q(1);

  trs3122_fpga_rout1_d(1)     <= trs3122_fpga_rout1;
  trs3122_fpga_rout1_d(0)     <= trs3122_fpga_rout1_q(1);

  trs3122_fpga_rout0_d(1)     <= trs3122_fpga_rout0;
  trs3122_fpga_rout0_d(0)     <= trs3122_fpga_rout0_q(1);

  fpga_ocmb_usin_d(1)     <= fpga_ocmb_usin_gated;
  fpga_ocmb_usin_d(0)     <= fpga_ocmb_usin_q(1);
  fpga_ocmb_usin          <= fpga_ocmb_usin_q(0);

  fpga_jdebug_usin_abw_d(1)     <= fpga_jdebug_usin_abw_gated;
  fpga_jdebug_usin_abw_d(0)     <= fpga_jdebug_usin_abw_q(1);
  fpga_jdebug_usin_abw          <= fpga_jdebug_usin_abw_q(0);

  fpga_jdebug_usin_cd_d(1)     <= fpga_jdebug_usin_cd_gated;
  fpga_jdebug_usin_cd_d(0)     <= fpga_jdebug_usin_cd_q(1);
  fpga_jdebug_usin_cd          <= fpga_jdebug_usin_cd_q(0);



  -----------------------------------------------------------------------------
  -- Mux and gating
  -----------------------------------------------------------------------------

  fpga_usout_select          <= (fpga_ocmb_uart_select       AND ocmb_fpga_usout_q(0))
                             OR (fpga_jdebug_abw_uart_select AND fpga_jdebug_usout_abw_q(0))
                             OR (fpga_jdebug_cd_uart_select  AND fpga_jdebug_usout_cd_q(0));

  fpga_cp2105_din2_gated     <= fpga_cp2105_2_select  AND fpga_usout_select;
  fpga_trs3122_din1_gated    <= fpga_trs3122_1_select AND fpga_usout_select;
  fpga_trs3122_din0_gated    <= fpga_trs3122_0_select AND fpga_usout_select;


  fpga_usin_select           <=  (fpga_cp2105_2_select  AND cp2105_fpga_rout2_q(0))
                             OR  (fpga_trs3122_1_select AND trs3122_fpga_rout1_q(0))
                             OR  (fpga_trs3122_0_select AND trs3122_fpga_rout0_q(0));

  fpga_ocmb_usin_gated       <= fpga_usin_select AND fpga_ocmb_uart_select;

  fpga_jdebug_usin_abw_gated <= fpga_usin_select AND fpga_jdebug_abw_uart_select;

  fpga_jdebug_usin_cd_gated  <= fpga_usin_select AND fpga_jdebug_cd_uart_select;




  --   fpga_cp2105_din2_gated     <= fpga_cp2105_2_select  AND trs3122_fpga_rout0_q(0);

  --   fpga_trs3122_din0_gated    <= fpga_trs3122_0_select  AND cp2105_fpga_rout2_q(0);


  -----------------------------------------------------------------------------
  -- Latches
  -----------------------------------------------------------------------------
  process (clock) is
  begin
    if rising_edge(clock) then
      if (reset_int = '0') then
        --jjtag_fpga_rst_q            <= "00";
        --jjtag_ocmb_rst_q            <= "00";
        --jjtag_ddimmw_rst_q          <= "00";
        --jjtag_ddimma_rst_q          <= "00";
        --jjtag_ddimmb_rst_q          <= "00";
        --jjtag_ddimmc_rst_q          <= "00";
        --jjtag_ddimmd_rst_q          <= "00";
        jjtag_fpga_trst_q           <= "00";
        jjtag_ocmb_trstb_q          <= "00";
        jjtag_jdebug_trstb_abw_q    <= "00";
        jjtag_jdebug_trstb_cd_q     <= "00";
        jjtag_fpga_tck_q            <= "00";
        jjtag_fpga_tms_q            <= "00";
        jjtag_fpga_tdi_q            <= "00";
        ocmb_fpga_tdo_q             <= "00";
        ddimmw_fpga_tdo_q           <= "00";
        ddimma_fpga_tdo_q           <= "00";
        ddimmb_fpga_tdo_q           <= "00";
        ddimmc_fpga_tdo_q           <= "00";
        ddimmd_fpga_tdo_q           <= "00";
        fpga_jjtag_tdo_q            <= "00";
        fpga_cp2105_din2_q          <= "00";
        fpga_trs3122_din1_q         <= "00";
        fpga_trs3122_din0_q         <= "00";
        ocmb_fpga_usout_q           <= "00";
        fpga_jdebug_usout_abw_q     <= "00";
        fpga_jdebug_usout_cd_q      <= "00";
        cp2105_fpga_rout2_q         <= "00";
        trs3122_fpga_rout1_q        <= "00";
        trs3122_fpga_rout0_q        <= "00";
        fpga_ocmb_usin_q            <= "00";
        fpga_jdebug_usin_abw_q      <= "00";
        fpga_jdebug_usin_cd_q       <= "00";
        jjtag_ocmb_tms_q            <= "00";
        jjtag_ddimmw_tms_q          <= "00";
        jjtag_ddimma_tms_q          <= "00";
        jjtag_ddimmb_tms_q          <= "00";
        jjtag_ddimmc_tms_q          <= "00";
        jjtag_ddimmd_tms_q          <= "00";
        jjtag_ocmb_tck_q            <= "00";
        jjtag_ddimmw_tck_q          <= "00";
        jjtag_ddimma_tck_q          <= "00";
        jjtag_ddimmb_tck_q          <= "00";
        jjtag_ddimmc_tck_q          <= "00";
        jjtag_ddimmd_tck_q          <= "00";
        jjtag_ocmb_tdi_q            <= "00";
        jjtag_ddimmw_tdi_q          <= "00";
        jjtag_ddimma_tdi_q          <= "00";
        jjtag_ddimmb_tdi_q          <= "00";
        jjtag_ddimmc_tdi_q          <= "00";
        jjtag_ddimmd_tdi_q          <= "00";

      else
        --jjtag_fpga_rst_q            <= jjtag_fpga_rst_d;
        --jjtag_ocmb_rst_q            <= jjtag_ocmb_rst_d;
        --jjtag_ddimmw_rst_q          <= jjtag_ddimmw_rst_d;
        --jjtag_ddimma_rst_q          <= jjtag_ddimma_rst_d;
        --jjtag_ddimmb_rst_q          <= jjtag_ddimmb_rst_d;
        --jjtag_ddimmc_rst_q          <= jjtag_ddimmc_rst_d;
        --jjtag_ddimmd_rst_q          <= jjtag_ddimmd_rst_d;
        jjtag_fpga_trst_q           <= jjtag_fpga_trst_d;
        jjtag_ocmb_trstb_q          <= jjtag_ocmb_trstb_d;
        jjtag_jdebug_trstb_abw_q    <= jjtag_jdebug_trstb_abw_d;
        jjtag_jdebug_trstb_cd_q     <= jjtag_jdebug_trstb_cd_d;
        jjtag_fpga_tck_q            <= jjtag_fpga_tck_d;
        jjtag_ocmb_tck_q            <= jjtag_ocmb_tck_d;
        jjtag_ddimmw_tck_q          <= jjtag_ddimmw_tck_d;
        jjtag_ddimma_tck_q          <= jjtag_ddimma_tck_d;
        jjtag_ddimmb_tck_q          <= jjtag_ddimmb_tck_d;
        jjtag_ddimmc_tck_q          <= jjtag_ddimmc_tck_d;
        jjtag_ddimmd_tck_q          <= jjtag_ddimmd_tck_d;
        jjtag_fpga_tms_q            <= jjtag_fpga_tms_d;
        jjtag_ocmb_tms_q            <= jjtag_ocmb_tms_d;
        jjtag_ddimmw_tms_q          <= jjtag_ddimmw_tms_d;
        jjtag_ddimma_tms_q          <= jjtag_ddimma_tms_d;
        jjtag_ddimmb_tms_q          <= jjtag_ddimmb_tms_d;
        jjtag_ddimmc_tms_q          <= jjtag_ddimmc_tms_d;
        jjtag_ddimmd_tms_q          <= jjtag_ddimmd_tms_d;
        jjtag_fpga_tdi_q            <= jjtag_fpga_tdi_d;
        jjtag_ocmb_tdi_q            <= jjtag_ocmb_tdi_d;
        jjtag_ddimmw_tdi_q          <= jjtag_ddimmw_tdi_d;
        jjtag_ddimma_tdi_q          <= jjtag_ddimma_tdi_d;
        jjtag_ddimmb_tdi_q          <= jjtag_ddimmb_tdi_d;
        jjtag_ddimmc_tdi_q          <= jjtag_ddimmc_tdi_d;
        jjtag_ddimmd_tdi_q          <= jjtag_ddimmd_tdi_d;
        ocmb_fpga_tdo_q             <= ocmb_fpga_tdo_d;
        ddimmw_fpga_tdo_q           <= ddimmw_fpga_tdo_d;
        ddimma_fpga_tdo_q           <= ddimma_fpga_tdo_d;
        ddimmb_fpga_tdo_q           <= ddimmb_fpga_tdo_d;
        ddimmc_fpga_tdo_q           <= ddimmc_fpga_tdo_d;
        ddimmd_fpga_tdo_q           <= ddimmd_fpga_tdo_d;
        fpga_jjtag_tdo_q            <= fpga_jjtag_tdo_d;
        fpga_cp2105_din2_q          <= fpga_cp2105_din2_d;
        fpga_trs3122_din1_q         <= fpga_trs3122_din1_d;
        fpga_trs3122_din0_q         <= fpga_trs3122_din0_d;
        ocmb_fpga_usout_q           <= ocmb_fpga_usout_d;
        fpga_jdebug_usout_abw_q     <= fpga_jdebug_usout_abw_d;
        fpga_jdebug_usout_cd_q      <= fpga_jdebug_usout_cd_d;
        cp2105_fpga_rout2_q         <= cp2105_fpga_rout2_d;
        trs3122_fpga_rout1_q        <= trs3122_fpga_rout1_d;
        trs3122_fpga_rout0_q        <= trs3122_fpga_rout0_d;
        fpga_ocmb_usin_q            <= fpga_ocmb_usin_d;
        fpga_jdebug_usin_abw_q      <= fpga_jdebug_usin_abw_d;
        fpga_jdebug_usin_cd_q       <= fpga_jdebug_usin_cd_d;
      end if;
    end if;
  end process;

end fml_mux;
