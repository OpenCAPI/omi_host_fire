-- *!***************************************************************************
-- *! (C) Copyright International Business Machines Corp. 2018
-- *!           All Rights Reserved -- Property of IBM
-- *!                   *** IBM Confidential ***
-- *!***************************************************************************

--          <macro name>          <instance name>   <port map renames>
-- MS_INST  fire_core             fire_core
-- MS_INST  fire_pervasive        fire_pervasive
-- MS_INST  hss_phy_wrap          hss0

library ieee,ibm,support,unisim;
use ieee.std_logic_1164.all;
use ibm.synthesis_support.all;
use support.logic_support_pkg.all;
use work.axi_pkg.all;
use unisim.vcomponents.all;

entity fire_top is
  port (
    ---------------------------------------------------------------------------
    -- Clocking & Reset
    ---------------------------------------------------------------------------
    --RAW_RESETN                     : in std_ulogic;
    RAW_SYSCLK_N                   : in std_ulogic;
    RAW_SYSCLK_P                   : in std_ulogic;
    RAW_RCLK_N                     : in std_ulogic;
    RAW_RCLK_P                     : in std_ulogic;
    PLL_LOCKED                     : out std_ulogic;
    OCDE                           : in std_ulogic;
    DDIMMA_RESETN                  : out std_ulogic;
    DDIMMB_RESETN                  : out std_ulogic;
    DDIMMC_RESETN                  : out std_ulogic;
    DDIMMD_RESETN                  : out std_ulogic;
    DDIMMW_RESETN                  : out std_ulogic;
    DDIMMS_RESETN                  : out std_ulogic;
    SYSCLK_PROBE0_N                : out std_ulogic;
    SYSCLK_PROBE0_P                : out std_ulogic;
    SYSCLK_PROBE1_N                : out std_ulogic;
    SYSCLK_PROBE1_P                : out std_ulogic;

    ---------------------------------------------------------------------------
    -- I2C
    ---------------------------------------------------------------------------
    SCL_IO                         : inout std_logic;
    SDA_IO                         : inout std_logic;

    ---------------------------------------------------------------------------
    -- Miscellaneous IO
    ---------------------------------------------------------------------------
    LED_DDIMMA_RED                 : out std_ulogic;
    LED_DDIMMA_GREEN               : out std_ulogic;
    LED_DDIMMB_RED                 : out std_ulogic;
    LED_DDIMMB_GREEN               : out std_ulogic;
    LED_DDIMMC_RED                 : out std_ulogic;
    LED_DDIMMC_GREEN               : out std_ulogic;
    LED_DDIMMD_RED                 : out std_ulogic;
    LED_DDIMMD_GREEN               : out std_ulogic;
    LED_DDIMMW_RED                 : out std_ulogic;
    LED_DDIMMW_GREEN               : out std_ulogic;

    ---------------------------------------------------------------------------
    -- OCMB OpenCAPI Channels
    ---------------------------------------------------------------------------
    -- DDIMM A
    DDIMMA_FPGA_LANE_N             : in std_ulogic_vector(7 downto 0);
    DDIMMA_FPGA_LANE_P             : in std_ulogic_vector(7 downto 0);
    FPGA_DDIMMA_LANE_N             : out std_ulogic_vector(7 downto 0);
    FPGA_DDIMMA_LANE_P             : out std_ulogic_vector(7 downto 0);
    DDIMMA_FPGA_REFCLK_N           : in std_ulogic_vector(1 downto 0);
    DDIMMA_FPGA_REFCLK_P           : in std_ulogic_vector(1 downto 0);

    -- DDIMM B
    DDIMMB_FPGA_LANE_N             : in std_ulogic_vector(7 downto 0);
    DDIMMB_FPGA_LANE_P             : in std_ulogic_vector(7 downto 0);
    FPGA_DDIMMB_LANE_N             : out std_ulogic_vector(7 downto 0);
    FPGA_DDIMMB_LANE_P             : out std_ulogic_vector(7 downto 0);
    DDIMMB_FPGA_REFCLK_N           : in std_ulogic_vector(1 downto 0);
    DDIMMB_FPGA_REFCLK_P           : in std_ulogic_vector(1 downto 0);

    -- DDIMM C
    DDIMMC_FPGA_LANE_N             : in std_ulogic_vector(7 downto 0);
    DDIMMC_FPGA_LANE_P             : in std_ulogic_vector(7 downto 0);
    FPGA_DDIMMC_LANE_N             : out std_ulogic_vector(7 downto 0);
    FPGA_DDIMMC_LANE_P             : out std_ulogic_vector(7 downto 0);
    DDIMMC_FPGA_REFCLK_N           : in std_ulogic_vector(1 downto 0);
    DDIMMC_FPGA_REFCLK_P           : in std_ulogic_vector(1 downto 0);

    -- DDIMM D
    DDIMMD_FPGA_LANE_N             : in std_ulogic_vector(7 downto 0);
    DDIMMD_FPGA_LANE_P             : in std_ulogic_vector(7 downto 0);
    FPGA_DDIMMD_LANE_N             : out std_ulogic_vector(7 downto 0);
    FPGA_DDIMMD_LANE_P             : out std_ulogic_vector(7 downto 0);
    DDIMMD_FPGA_REFCLK_N           : in std_ulogic_vector(1 downto 0);
    DDIMMD_FPGA_REFCLK_P           : in std_ulogic_vector(1 downto 0);

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
    ocmb_fpga_usout_sa2_i           : in std_ulogic

    ---------------------------------------------------------------------------
    -- Attached DDR4
    ---------------------------------------------------------------------------
    --FPGA_DDR4_DIMM_A               : out std_ulogic_vector(17 downto 0);
    --FPGA_DDR4_DIMM_ACT_N           : out std_ulogic;
    --FPGA_DDR4_DIMM_BA              : out std_ulogic_vector(1 downto 0);
    --FPGA_DDR4_DIMM_BG              : out std_ulogic_vector(1 downto 0);
    --FPGA_DDR4_DIMM_C               : out std_ulogic_vector(2 downto 0);
    --FPGA_DDR4_DIMM_CKE             : out std_ulogic;
    --FPGA_DDR4_DIMM_CLK_N           : out std_ulogic;
    --FPGA_DDR4_DIMM_CLK_P           : out std_ulogic;
    --FPGA_DDR4_DIMM_CS_N            : out std_ulogic;
    --FPGA_DDR4_DIMM_DQ              : inout std_ulogic_vector(71 downto 0);
    --FPGA_DDR4_DIMM_DQS_N           : inout std_ulogic_vector(17 downto 0);
    --FPGA_DDR4_DIMM_DQS_P           : inout std_ulogic_vector(17 downto 0);
    --FPGA_DDR4_DIMM_ODT             : out std_ulogic;
    --FPGA_DDR4_DIMM_PAR             : out std_ulogic;
    --FPGA_DDR4_DIMM_RESET_N         : out std_ulogic
    );

  attribute BLOCK_TYPE of fire_top : entity is SOFT;
  attribute BTR_NAME of fire_top : entity is "FIRE_TOP";
  attribute RECURSIVE_SYNTHESIS of fire_top : entity is 2;
end fire_top;

architecture fire_top of fire_top is
  SIGNAL oc_memory0_axis_aclk : std_ulogic;
  SIGNAL oc_memory0_axis_i : t_AXI3_SLAVE_INPUT;
  SIGNAL oc_memory0_axis_o : t_AXI3_SLAVE_OUTPUT;
  SIGNAL oc_memory1_axis_aclk : std_ulogic;
  SIGNAL oc_memory1_axis_i : t_AXI3_SLAVE_INPUT;
  SIGNAL oc_memory1_axis_o : t_AXI3_SLAVE_OUTPUT;
  SIGNAL oc_memory2_axis_aclk : std_ulogic;
  SIGNAL oc_memory2_axis_i : t_AXI3_SLAVE_INPUT;
  SIGNAL oc_memory2_axis_o : t_AXI3_SLAVE_OUTPUT;
  SIGNAL oc_memory3_axis_aclk : std_ulogic;
  SIGNAL oc_memory3_axis_i : t_AXI3_SLAVE_INPUT;
  SIGNAL oc_memory3_axis_o : t_AXI3_SLAVE_OUTPUT;
  SIGNAL c3s_dlx0_axis_aclk : std_ulogic;
  SIGNAL c3s_dlx0_axis_i : t_AXI4_LITE_SLAVE_INPUT;
  SIGNAL c3s_dlx0_axis_o : t_AXI4_LITE_SLAVE_OUTPUT;
  SIGNAL c3s_dlx1_axis_aclk : std_ulogic;
  SIGNAL c3s_dlx1_axis_i : t_AXI4_LITE_SLAVE_INPUT;
  SIGNAL c3s_dlx1_axis_o : t_AXI4_LITE_SLAVE_OUTPUT;
  SIGNAL c3s_dlx2_axis_aclk : std_ulogic;
  SIGNAL c3s_dlx2_axis_i : t_AXI4_LITE_SLAVE_INPUT;
  SIGNAL c3s_dlx2_axis_o : t_AXI4_LITE_SLAVE_OUTPUT;
  SIGNAL c3s_dlx3_axis_aclk : std_ulogic;
  SIGNAL c3s_dlx3_axis_i : t_AXI4_LITE_SLAVE_INPUT;
  SIGNAL c3s_dlx3_axis_o : t_AXI4_LITE_SLAVE_OUTPUT;
  SIGNAL oc_mmio0_axis_aclk : std_ulogic;
  SIGNAL oc_mmio0_axis_i : t_AXI3_SLAVE_INPUT;
  SIGNAL oc_mmio0_axis_o : t_AXI3_SLAVE_OUTPUT;
  SIGNAL oc_mmio1_axis_aclk : std_ulogic;
  SIGNAL oc_mmio1_axis_i : t_AXI3_SLAVE_INPUT;
  SIGNAL oc_mmio1_axis_o : t_AXI3_SLAVE_OUTPUT;
  SIGNAL oc_mmio2_axis_aclk : std_ulogic;
  SIGNAL oc_mmio2_axis_i : t_AXI3_SLAVE_INPUT;
  SIGNAL oc_mmio2_axis_o : t_AXI3_SLAVE_OUTPUT;
  SIGNAL oc_mmio3_axis_aclk : std_ulogic;
  SIGNAL oc_mmio3_axis_i : t_AXI3_SLAVE_INPUT;
  SIGNAL oc_mmio3_axis_o : t_AXI3_SLAVE_OUTPUT;
  SIGNAL oc_cfg0_axis_aclk : std_ulogic;
  SIGNAL oc_cfg0_axis_i : t_AXI3_SLAVE_INPUT;
  SIGNAL oc_cfg0_axis_o : t_AXI3_SLAVE_OUTPUT;
  SIGNAL oc_cfg1_axis_aclk : std_ulogic;
  SIGNAL oc_cfg1_axis_i : t_AXI3_SLAVE_INPUT;
  SIGNAL oc_cfg1_axis_o : t_AXI3_SLAVE_OUTPUT;
  SIGNAL oc_cfg2_axis_aclk : std_ulogic;
  SIGNAL oc_cfg2_axis_i : t_AXI3_SLAVE_INPUT;
  SIGNAL oc_cfg2_axis_o : t_AXI3_SLAVE_OUTPUT;
  SIGNAL oc_cfg3_axis_aclk : std_ulogic;
  SIGNAL oc_cfg3_axis_i : t_AXI3_SLAVE_INPUT;
  SIGNAL oc_cfg3_axis_o : t_AXI3_SLAVE_OUTPUT;
  SIGNAL fbist0_axis_aclk : std_ulogic;
  SIGNAL fbist0_axis_i : t_AXI4_LITE_SLAVE_INPUT;
  SIGNAL fbist0_axis_o : t_AXI4_LITE_SLAVE_OUTPUT;
  SIGNAL fbist1_axis_aclk : std_ulogic;
  SIGNAL fbist1_axis_i : t_AXI4_LITE_SLAVE_INPUT;
  SIGNAL fbist1_axis_o : t_AXI4_LITE_SLAVE_OUTPUT;
  SIGNAL fbist2_axis_aclk : std_ulogic;
  SIGNAL fbist2_axis_i : t_AXI4_LITE_SLAVE_INPUT;
  SIGNAL fbist2_axis_o : t_AXI4_LITE_SLAVE_OUTPUT;
  SIGNAL fbist3_axis_aclk : std_ulogic;
  SIGNAL fbist3_axis_i : t_AXI4_LITE_SLAVE_INPUT;
  SIGNAL fbist3_axis_o : t_AXI4_LITE_SLAVE_OUTPUT;
  SIGNAL oc_host_cfg0_axis_aclk : std_ulogic;
  SIGNAL oc_host_cfg0_axis_i : t_AXI4_LITE_SLAVE_INPUT;
  SIGNAL oc_host_cfg0_axis_o : t_AXI4_LITE_SLAVE_OUTPUT;
  SIGNAL oc_host_cfg1_axis_aclk : std_ulogic;
  SIGNAL oc_host_cfg1_axis_i : t_AXI4_LITE_SLAVE_INPUT;
  SIGNAL oc_host_cfg1_axis_o : t_AXI4_LITE_SLAVE_OUTPUT;
  SIGNAL oc_host_cfg2_axis_aclk : std_ulogic;
  SIGNAL oc_host_cfg2_axis_i : t_AXI4_LITE_SLAVE_INPUT;
  SIGNAL oc_host_cfg2_axis_o : t_AXI4_LITE_SLAVE_OUTPUT;
  SIGNAL oc_host_cfg3_axis_aclk : std_ulogic;
  SIGNAL oc_host_cfg3_axis_i : t_AXI4_LITE_SLAVE_INPUT;
  SIGNAL oc_host_cfg3_axis_o : t_AXI4_LITE_SLAVE_OUTPUT;
  SIGNAL sysclk : std_ulogic;
  SIGNAL cclk_a : std_ulogic;
  SIGNAL cclk_b : std_ulogic;
  SIGNAL cclk_c : std_ulogic;
  SIGNAL cclk_d : std_ulogic;
  SIGNAL rclk : std_ulogic;
  SIGNAL sys_resetn : std_ulogic;
--  SIGNAL sys_resetn_int : std_ulogic;
  SIGNAL ocde_int : std_ulogic;
  signal sys_resetn_vio : std_ulogic;
  signal dlx_reset0 : std_ulogic;
  signal dlx_reset1 : std_ulogic;
  signal dlx_reset2 : std_ulogic;
  signal dlx_reset3 : std_ulogic;
  SIGNAL raw_resetn_int : std_ulogic;
  SIGNAL cresetn_a : std_ulogic;
  SIGNAL cresetn_b : std_ulogic;
  SIGNAL cresetn_c : std_ulogic;
  SIGNAL cresetn_d : std_ulogic;
  SIGNAL dlx_l0_tx_data0 : std_ulogic_vector(63 downto 0);
  SIGNAL dlx_l0_tx_header0 : std_ulogic_vector(1 downto 0);
  SIGNAL dlx_l0_tx_seq0 : std_ulogic_vector(5 downto 0);
  SIGNAL dlx_l1_tx_data0 : std_ulogic_vector(63 downto 0);
  SIGNAL dlx_l1_tx_header0 : std_ulogic_vector(1 downto 0);
  SIGNAL dlx_l1_tx_seq0 : std_ulogic_vector(5 downto 0);
  SIGNAL dlx_l2_tx_data0 : std_ulogic_vector(63 downto 0);
  SIGNAL dlx_l2_tx_header0 : std_ulogic_vector(1 downto 0);
  SIGNAL dlx_l2_tx_seq0 : std_ulogic_vector(5 downto 0);
  SIGNAL dlx_l3_tx_data0 : std_ulogic_vector(63 downto 0);
  SIGNAL dlx_l3_tx_header0 : std_ulogic_vector(1 downto 0);
  SIGNAL dlx_l3_tx_seq0 : std_ulogic_vector(5 downto 0);
  SIGNAL dlx_l4_tx_data0 : std_ulogic_vector(63 downto 0);
  SIGNAL dlx_l4_tx_header0 : std_ulogic_vector(1 downto 0);
  SIGNAL dlx_l4_tx_seq0 : std_ulogic_vector(5 downto 0);
  SIGNAL dlx_l5_tx_data0 : std_ulogic_vector(63 downto 0);
  SIGNAL dlx_l5_tx_header0 : std_ulogic_vector(1 downto 0);
  SIGNAL dlx_l5_tx_seq0 : std_ulogic_vector(5 downto 0);
  SIGNAL dlx_l6_tx_data0 : std_ulogic_vector(63 downto 0);
  SIGNAL dlx_l6_tx_header0 : std_ulogic_vector(1 downto 0);
  SIGNAL dlx_l6_tx_seq0 : std_ulogic_vector(5 downto 0);
  SIGNAL dlx_l7_tx_data0 : std_ulogic_vector(63 downto 0);
  SIGNAL dlx_l7_tx_header0 : std_ulogic_vector(1 downto 0);
  SIGNAL dlx_l7_tx_seq0 : std_ulogic_vector(5 downto 0);
  SIGNAL dlx_l0_tx_data1 : std_ulogic_vector(63 downto 0);
  SIGNAL dlx_l0_tx_header1 : std_ulogic_vector(1 downto 0);
  SIGNAL dlx_l0_tx_seq1 : std_ulogic_vector(5 downto 0);
  SIGNAL dlx_l1_tx_data1 : std_ulogic_vector(63 downto 0);
  SIGNAL dlx_l1_tx_header1 : std_ulogic_vector(1 downto 0);
  SIGNAL dlx_l1_tx_seq1 : std_ulogic_vector(5 downto 0);
  SIGNAL dlx_l2_tx_data1 : std_ulogic_vector(63 downto 0);
  SIGNAL dlx_l2_tx_header1 : std_ulogic_vector(1 downto 0);
  SIGNAL dlx_l2_tx_seq1 : std_ulogic_vector(5 downto 0);
  SIGNAL dlx_l3_tx_data1 : std_ulogic_vector(63 downto 0);
  SIGNAL dlx_l3_tx_header1 : std_ulogic_vector(1 downto 0);
  SIGNAL dlx_l3_tx_seq1 : std_ulogic_vector(5 downto 0);
  SIGNAL dlx_l4_tx_data1 : std_ulogic_vector(63 downto 0);
  SIGNAL dlx_l4_tx_header1 : std_ulogic_vector(1 downto 0);
  SIGNAL dlx_l4_tx_seq1 : std_ulogic_vector(5 downto 0);
  SIGNAL dlx_l5_tx_data1 : std_ulogic_vector(63 downto 0);
  SIGNAL dlx_l5_tx_header1 : std_ulogic_vector(1 downto 0);
  SIGNAL dlx_l5_tx_seq1 : std_ulogic_vector(5 downto 0);
  SIGNAL dlx_l6_tx_data1 : std_ulogic_vector(63 downto 0);
  SIGNAL dlx_l6_tx_header1 : std_ulogic_vector(1 downto 0);
  SIGNAL dlx_l6_tx_seq1 : std_ulogic_vector(5 downto 0);
  SIGNAL dlx_l7_tx_data1 : std_ulogic_vector(63 downto 0);
  SIGNAL dlx_l7_tx_header1 : std_ulogic_vector(1 downto 0);
  SIGNAL dlx_l7_tx_seq1 : std_ulogic_vector(5 downto 0);
  SIGNAL dlx_l0_tx_data2 : std_ulogic_vector(63 downto 0);
  SIGNAL dlx_l0_tx_header2 : std_ulogic_vector(1 downto 0);
  SIGNAL dlx_l0_tx_seq2 : std_ulogic_vector(5 downto 0);
  SIGNAL dlx_l1_tx_data2 : std_ulogic_vector(63 downto 0);
  SIGNAL dlx_l1_tx_header2 : std_ulogic_vector(1 downto 0);
  SIGNAL dlx_l1_tx_seq2 : std_ulogic_vector(5 downto 0);
  SIGNAL dlx_l2_tx_data2 : std_ulogic_vector(63 downto 0);
  SIGNAL dlx_l2_tx_header2 : std_ulogic_vector(1 downto 0);
  SIGNAL dlx_l2_tx_seq2 : std_ulogic_vector(5 downto 0);
  SIGNAL dlx_l3_tx_data2 : std_ulogic_vector(63 downto 0);
  SIGNAL dlx_l3_tx_header2 : std_ulogic_vector(1 downto 0);
  SIGNAL dlx_l3_tx_seq2 : std_ulogic_vector(5 downto 0);
  SIGNAL dlx_l4_tx_data2 : std_ulogic_vector(63 downto 0);
  SIGNAL dlx_l4_tx_header2 : std_ulogic_vector(1 downto 0);
  SIGNAL dlx_l4_tx_seq2 : std_ulogic_vector(5 downto 0);
  SIGNAL dlx_l5_tx_data2 : std_ulogic_vector(63 downto 0);
  SIGNAL dlx_l5_tx_header2 : std_ulogic_vector(1 downto 0);
  SIGNAL dlx_l5_tx_seq2 : std_ulogic_vector(5 downto 0);
  SIGNAL dlx_l6_tx_data2 : std_ulogic_vector(63 downto 0);
  SIGNAL dlx_l6_tx_header2 : std_ulogic_vector(1 downto 0);
  SIGNAL dlx_l6_tx_seq2 : std_ulogic_vector(5 downto 0);
  SIGNAL dlx_l7_tx_data2 : std_ulogic_vector(63 downto 0);
  SIGNAL dlx_l7_tx_header2 : std_ulogic_vector(1 downto 0);
  SIGNAL dlx_l7_tx_seq2 : std_ulogic_vector(5 downto 0);
  SIGNAL dlx_l0_tx_data3 : std_ulogic_vector(63 downto 0);
  SIGNAL dlx_l0_tx_header3 : std_ulogic_vector(1 downto 0);
  SIGNAL dlx_l0_tx_seq3 : std_ulogic_vector(5 downto 0);
  SIGNAL dlx_l1_tx_data3 : std_ulogic_vector(63 downto 0);
  SIGNAL dlx_l1_tx_header3 : std_ulogic_vector(1 downto 0);
  SIGNAL dlx_l1_tx_seq3 : std_ulogic_vector(5 downto 0);
  SIGNAL dlx_l2_tx_data3 : std_ulogic_vector(63 downto 0);
  SIGNAL dlx_l2_tx_header3 : std_ulogic_vector(1 downto 0);
  SIGNAL dlx_l2_tx_seq3 : std_ulogic_vector(5 downto 0);
  SIGNAL dlx_l3_tx_data3 : std_ulogic_vector(63 downto 0);
  SIGNAL dlx_l3_tx_header3 : std_ulogic_vector(1 downto 0);
  SIGNAL dlx_l3_tx_seq3 : std_ulogic_vector(5 downto 0);
  SIGNAL dlx_l4_tx_data3 : std_ulogic_vector(63 downto 0);
  SIGNAL dlx_l4_tx_header3 : std_ulogic_vector(1 downto 0);
  SIGNAL dlx_l4_tx_seq3 : std_ulogic_vector(5 downto 0);
  SIGNAL dlx_l5_tx_data3 : std_ulogic_vector(63 downto 0);
  SIGNAL dlx_l5_tx_header3 : std_ulogic_vector(1 downto 0);
  SIGNAL dlx_l5_tx_seq3 : std_ulogic_vector(5 downto 0);
  SIGNAL dlx_l6_tx_data3 : std_ulogic_vector(63 downto 0);
  SIGNAL dlx_l6_tx_header3 : std_ulogic_vector(1 downto 0);
  SIGNAL dlx_l6_tx_seq3 : std_ulogic_vector(5 downto 0);
  SIGNAL dlx_l7_tx_data3 : std_ulogic_vector(63 downto 0);
  SIGNAL dlx_l7_tx_header3 : std_ulogic_vector(1 downto 0);
  SIGNAL dlx_l7_tx_seq3 : std_ulogic_vector(5 downto 0);
  SIGNAL gtwiz_buffbypass_rx_done_in0 : std_ulogic;
  SIGNAL gtwiz_buffbypass_tx_done_in0 : std_ulogic;
  SIGNAL gtwiz_reset_all_out0 : std_ulogic;
  SIGNAL gtwiz_reset_rx_datapath_out0 : std_ulogic;
  SIGNAL gtwiz_reset_rx_done_in0 : std_ulogic;
  SIGNAL gtwiz_reset_tx_done_in0 : std_ulogic;
  SIGNAL gtwiz_userclk_rx_active_in0 : std_ulogic;
  SIGNAL gtwiz_userclk_tx_active_in0 : std_ulogic;
  SIGNAL hb_gtwiz_reset_all_in0 : std_ulogic;
  SIGNAL gtwiz_buffbypass_rx_done_in1 : std_ulogic;
  SIGNAL gtwiz_buffbypass_tx_done_in1 : std_ulogic;
  SIGNAL gtwiz_reset_all_out1 : std_ulogic;
  SIGNAL gtwiz_reset_rx_datapath_out1 : std_ulogic;
  SIGNAL gtwiz_reset_rx_done_in1 : std_ulogic;
  SIGNAL gtwiz_reset_tx_done_in1 : std_ulogic;
  SIGNAL gtwiz_userclk_rx_active_in1 : std_ulogic;
  SIGNAL gtwiz_userclk_tx_active_in1 : std_ulogic;
  SIGNAL hb_gtwiz_reset_all_in1 : std_ulogic;
  SIGNAL gtwiz_buffbypass_rx_done_in2 : std_ulogic;
  SIGNAL gtwiz_buffbypass_tx_done_in2 : std_ulogic;
  SIGNAL gtwiz_reset_all_out2 : std_ulogic;
  SIGNAL gtwiz_reset_rx_datapath_out2 : std_ulogic;
  SIGNAL gtwiz_reset_rx_done_in2 : std_ulogic;
  SIGNAL gtwiz_reset_tx_done_in2 : std_ulogic;
  SIGNAL gtwiz_userclk_rx_active_in2 : std_ulogic;
  SIGNAL gtwiz_userclk_tx_active_in2 : std_ulogic;
  SIGNAL hb_gtwiz_reset_all_in2 : std_ulogic;
  SIGNAL gtwiz_buffbypass_rx_done_in3 : std_ulogic;
  SIGNAL gtwiz_buffbypass_tx_done_in3 : std_ulogic;
  SIGNAL gtwiz_reset_all_out3 : std_ulogic;
  SIGNAL gtwiz_reset_rx_datapath_out3 : std_ulogic;
  SIGNAL gtwiz_reset_rx_done_in3 : std_ulogic;
  SIGNAL gtwiz_reset_tx_done_in3 : std_ulogic;
  SIGNAL gtwiz_userclk_rx_active_in3 : std_ulogic;
  SIGNAL gtwiz_userclk_tx_active_in3 : std_ulogic;
  SIGNAL hb_gtwiz_reset_all_in3 : std_ulogic;
  SIGNAL ln0_rx_data0 : std_ulogic_vector(63 downto 0);
  SIGNAL ln0_rx_header0 : std_ulogic_vector(1 downto 0);
  SIGNAL ln0_rx_slip0 : std_ulogic;
  SIGNAL ln0_rx_valid0 : std_ulogic;
  SIGNAL ln1_rx_data0 : std_ulogic_vector(63 downto 0);
  SIGNAL ln1_rx_header0 : std_ulogic_vector(1 downto 0);
  SIGNAL ln1_rx_slip0 : std_ulogic;
  SIGNAL ln1_rx_valid0 : std_ulogic;
  SIGNAL ln2_rx_data0 : std_ulogic_vector(63 downto 0);
  SIGNAL ln2_rx_header0 : std_ulogic_vector(1 downto 0);
  SIGNAL ln2_rx_slip0 : std_ulogic;
  SIGNAL ln2_rx_valid0 : std_ulogic;
  SIGNAL ln3_rx_data0 : std_ulogic_vector(63 downto 0);
  SIGNAL ln3_rx_header0 : std_ulogic_vector(1 downto 0);
  SIGNAL ln3_rx_slip0 : std_ulogic;
  SIGNAL ln3_rx_valid0 : std_ulogic;
  SIGNAL ln4_rx_data0 : std_ulogic_vector(63 downto 0);
  SIGNAL ln4_rx_header0 : std_ulogic_vector(1 downto 0);
  SIGNAL ln4_rx_slip0 : std_ulogic;
  SIGNAL ln4_rx_valid0 : std_ulogic;
  SIGNAL ln5_rx_data0 : std_ulogic_vector(63 downto 0);
  SIGNAL ln5_rx_header0 : std_ulogic_vector(1 downto 0);
  SIGNAL ln5_rx_slip0 : std_ulogic;
  SIGNAL ln5_rx_valid0 : std_ulogic;
  SIGNAL ln6_rx_data0 : std_ulogic_vector(63 downto 0);
  SIGNAL ln6_rx_header0 : std_ulogic_vector(1 downto 0);
  SIGNAL ln6_rx_slip0 : std_ulogic;
  SIGNAL ln6_rx_valid0 : std_ulogic;
  SIGNAL ln7_rx_data0 : std_ulogic_vector(63 downto 0);
  SIGNAL ln7_rx_header0 : std_ulogic_vector(1 downto 0);
  SIGNAL ln7_rx_slip0 : std_ulogic;
  SIGNAL ln7_rx_valid0 : std_ulogic;
  SIGNAL ln0_rx_data1 : std_ulogic_vector(63 downto 0);
  SIGNAL ln0_rx_header1 : std_ulogic_vector(1 downto 0);
  SIGNAL ln0_rx_slip1 : std_ulogic;
  SIGNAL ln0_rx_valid1 : std_ulogic;
  SIGNAL ln1_rx_data1 : std_ulogic_vector(63 downto 0);
  SIGNAL ln1_rx_header1 : std_ulogic_vector(1 downto 0);
  SIGNAL ln1_rx_slip1 : std_ulogic;
  SIGNAL ln1_rx_valid1 : std_ulogic;
  SIGNAL ln2_rx_data1 : std_ulogic_vector(63 downto 0);
  SIGNAL ln2_rx_header1 : std_ulogic_vector(1 downto 0);
  SIGNAL ln2_rx_slip1 : std_ulogic;
  SIGNAL ln2_rx_valid1 : std_ulogic;
  SIGNAL ln3_rx_data1 : std_ulogic_vector(63 downto 0);
  SIGNAL ln3_rx_header1 : std_ulogic_vector(1 downto 0);
  SIGNAL ln3_rx_slip1 : std_ulogic;
  SIGNAL ln3_rx_valid1 : std_ulogic;
  SIGNAL ln4_rx_data1 : std_ulogic_vector(63 downto 0);
  SIGNAL ln4_rx_header1 : std_ulogic_vector(1 downto 0);
  SIGNAL ln4_rx_slip1 : std_ulogic;
  SIGNAL ln4_rx_valid1 : std_ulogic;
  SIGNAL ln5_rx_data1 : std_ulogic_vector(63 downto 0);
  SIGNAL ln5_rx_header1 : std_ulogic_vector(1 downto 0);
  SIGNAL ln5_rx_slip1 : std_ulogic;
  SIGNAL ln5_rx_valid1 : std_ulogic;
  SIGNAL ln6_rx_data1 : std_ulogic_vector(63 downto 0);
  SIGNAL ln6_rx_header1 : std_ulogic_vector(1 downto 0);
  SIGNAL ln6_rx_slip1 : std_ulogic;
  SIGNAL ln6_rx_valid1 : std_ulogic;
  SIGNAL ln7_rx_data1 : std_ulogic_vector(63 downto 0);
  SIGNAL ln7_rx_header1 : std_ulogic_vector(1 downto 0);
  SIGNAL ln7_rx_slip1 : std_ulogic;
  SIGNAL ln7_rx_valid1 : std_ulogic;
  SIGNAL ln0_rx_data2 : std_ulogic_vector(63 downto 0);
  SIGNAL ln0_rx_header2 : std_ulogic_vector(1 downto 0);
  SIGNAL ln0_rx_slip2 : std_ulogic;
  SIGNAL ln0_rx_valid2 : std_ulogic;
  SIGNAL ln1_rx_data2 : std_ulogic_vector(63 downto 0);
  SIGNAL ln1_rx_header2 : std_ulogic_vector(1 downto 0);
  SIGNAL ln1_rx_slip2 : std_ulogic;
  SIGNAL ln1_rx_valid2 : std_ulogic;
  SIGNAL ln2_rx_data2 : std_ulogic_vector(63 downto 0);
  SIGNAL ln2_rx_header2 : std_ulogic_vector(1 downto 0);
  SIGNAL ln2_rx_slip2 : std_ulogic;
  SIGNAL ln2_rx_valid2 : std_ulogic;
  SIGNAL ln3_rx_data2 : std_ulogic_vector(63 downto 0);
  SIGNAL ln3_rx_header2 : std_ulogic_vector(1 downto 0);
  SIGNAL ln3_rx_slip2 : std_ulogic;
  SIGNAL ln3_rx_valid2 : std_ulogic;
  SIGNAL ln4_rx_data2 : std_ulogic_vector(63 downto 0);
  SIGNAL ln4_rx_header2 : std_ulogic_vector(1 downto 0);
  SIGNAL ln4_rx_slip2 : std_ulogic;
  SIGNAL ln4_rx_valid2 : std_ulogic;
  SIGNAL ln5_rx_data2 : std_ulogic_vector(63 downto 0);
  SIGNAL ln5_rx_header2 : std_ulogic_vector(1 downto 0);
  SIGNAL ln5_rx_slip2 : std_ulogic;
  SIGNAL ln5_rx_valid2 : std_ulogic;
  SIGNAL ln6_rx_data2 : std_ulogic_vector(63 downto 0);
  SIGNAL ln6_rx_header2 : std_ulogic_vector(1 downto 0);
  SIGNAL ln6_rx_slip2 : std_ulogic;
  SIGNAL ln6_rx_valid2 : std_ulogic;
  SIGNAL ln7_rx_data2 : std_ulogic_vector(63 downto 0);
  SIGNAL ln7_rx_header2 : std_ulogic_vector(1 downto 0);
  SIGNAL ln7_rx_slip2 : std_ulogic;
  SIGNAL ln7_rx_valid2 : std_ulogic;
  SIGNAL ln0_rx_data3 : std_ulogic_vector(63 downto 0);
  SIGNAL ln0_rx_header3 : std_ulogic_vector(1 downto 0);
  SIGNAL ln0_rx_slip3 : std_ulogic;
  SIGNAL ln0_rx_valid3 : std_ulogic;
  SIGNAL ln1_rx_data3 : std_ulogic_vector(63 downto 0);
  SIGNAL ln1_rx_header3 : std_ulogic_vector(1 downto 0);
  SIGNAL ln1_rx_slip3 : std_ulogic;
  SIGNAL ln1_rx_valid3 : std_ulogic;
  SIGNAL ln2_rx_data3 : std_ulogic_vector(63 downto 0);
  SIGNAL ln2_rx_header3 : std_ulogic_vector(1 downto 0);
  SIGNAL ln2_rx_slip3 : std_ulogic;
  SIGNAL ln2_rx_valid3 : std_ulogic;
  SIGNAL ln3_rx_data3 : std_ulogic_vector(63 downto 0);
  SIGNAL ln3_rx_header3 : std_ulogic_vector(1 downto 0);
  SIGNAL ln3_rx_slip3 : std_ulogic;
  SIGNAL ln3_rx_valid3 : std_ulogic;
  SIGNAL ln4_rx_data3 : std_ulogic_vector(63 downto 0);
  SIGNAL ln4_rx_header3 : std_ulogic_vector(1 downto 0);
  SIGNAL ln4_rx_slip3 : std_ulogic;
  SIGNAL ln4_rx_valid3 : std_ulogic;
  SIGNAL ln5_rx_data3 : std_ulogic_vector(63 downto 0);
  SIGNAL ln5_rx_header3 : std_ulogic_vector(1 downto 0);
  SIGNAL ln5_rx_slip3 : std_ulogic;
  SIGNAL ln5_rx_valid3 : std_ulogic;
  SIGNAL ln6_rx_data3 : std_ulogic_vector(63 downto 0);
  SIGNAL ln6_rx_header3 : std_ulogic_vector(1 downto 0);
  SIGNAL ln6_rx_slip3 : std_ulogic;
  SIGNAL ln6_rx_valid3 : std_ulogic;
  SIGNAL ln7_rx_data3 : std_ulogic_vector(63 downto 0);
  SIGNAL ln7_rx_header3 : std_ulogic_vector(1 downto 0);
  SIGNAL ln7_rx_slip3 : std_ulogic;
  SIGNAL ln7_rx_valid3 : std_ulogic;
  SIGNAL mgtrefclk0_x0y0_p : std_ulogic;
  SIGNAL mgtrefclk0_x0y0_n : std_ulogic;
  SIGNAL mgtrefclk0_x0y1_p : std_ulogic;
  SIGNAL mgtrefclk0_x0y1_n : std_ulogic;
  SIGNAL mgtrefclk1_x0y0_p : std_ulogic;
  SIGNAL mgtrefclk1_x0y0_n : std_ulogic;
  SIGNAL mgtrefclk1_x0y1_p : std_ulogic;
  SIGNAL mgtrefclk1_x0y1_n : std_ulogic;
  SIGNAL mgtrefclk2_x0y0_p : std_ulogic;
  SIGNAL mgtrefclk2_x0y0_n : std_ulogic;
  SIGNAL mgtrefclk2_x0y1_p : std_ulogic;
  SIGNAL mgtrefclk2_x0y1_n : std_ulogic;
  SIGNAL mgtrefclk3_x0y0_p : std_ulogic;
  SIGNAL mgtrefclk3_x0y0_n : std_ulogic;
  SIGNAL mgtrefclk3_x0y1_p : std_ulogic;
  SIGNAL mgtrefclk3_x0y1_n : std_ulogic;
  SIGNAL ch0_gtyrxn0_in : std_ulogic;
  SIGNAL ch0_gtyrxp0_in : std_ulogic;
  SIGNAL ch0_gtytxn0_out : std_ulogic;
  SIGNAL ch0_gtytxp0_out : std_ulogic;
  SIGNAL ch1_gtyrxn0_in : std_ulogic;
  SIGNAL ch1_gtyrxp0_in : std_ulogic;
  SIGNAL ch1_gtytxn0_out : std_ulogic;
  SIGNAL ch1_gtytxp0_out : std_ulogic;
  SIGNAL ch2_gtyrxn0_in : std_ulogic;
  SIGNAL ch2_gtyrxp0_in : std_ulogic;
  SIGNAL ch2_gtytxn0_out : std_ulogic;
  SIGNAL ch2_gtytxp0_out : std_ulogic;
  SIGNAL ch3_gtyrxn0_in : std_ulogic;
  SIGNAL ch3_gtyrxp0_in : std_ulogic;
  SIGNAL ch3_gtytxn0_out : std_ulogic;
  SIGNAL ch3_gtytxp0_out : std_ulogic;
  SIGNAL ch4_gtyrxn0_in : std_ulogic;
  SIGNAL ch4_gtyrxp0_in : std_ulogic;
  SIGNAL ch4_gtytxn0_out : std_ulogic;
  SIGNAL ch4_gtytxp0_out : std_ulogic;
  SIGNAL ch5_gtyrxn0_in : std_ulogic;
  SIGNAL ch5_gtyrxp0_in : std_ulogic;
  SIGNAL ch5_gtytxn0_out : std_ulogic;
  SIGNAL ch5_gtytxp0_out : std_ulogic;
  SIGNAL ch6_gtyrxn0_in : std_ulogic;
  SIGNAL ch6_gtyrxp0_in : std_ulogic;
  SIGNAL ch6_gtytxn0_out : std_ulogic;
  SIGNAL ch6_gtytxp0_out : std_ulogic;
  SIGNAL ch7_gtyrxn0_in : std_ulogic;
  SIGNAL ch7_gtyrxp0_in : std_ulogic;
  SIGNAL ch7_gtytxn0_out : std_ulogic;
  SIGNAL ch7_gtytxp0_out : std_ulogic;
  SIGNAL ch0_gtyrxn1_in : std_ulogic;
  SIGNAL ch0_gtyrxp1_in : std_ulogic;
  SIGNAL ch0_gtytxn1_out : std_ulogic;
  SIGNAL ch0_gtytxp1_out : std_ulogic;
  SIGNAL ch1_gtyrxn1_in : std_ulogic;
  SIGNAL ch1_gtyrxp1_in : std_ulogic;
  SIGNAL ch1_gtytxn1_out : std_ulogic;
  SIGNAL ch1_gtytxp1_out : std_ulogic;
  SIGNAL ch2_gtyrxn1_in : std_ulogic;
  SIGNAL ch2_gtyrxp1_in : std_ulogic;
  SIGNAL ch2_gtytxn1_out : std_ulogic;
  SIGNAL ch2_gtytxp1_out : std_ulogic;
  SIGNAL ch3_gtyrxn1_in : std_ulogic;
  SIGNAL ch3_gtyrxp1_in : std_ulogic;
  SIGNAL ch3_gtytxn1_out : std_ulogic;
  SIGNAL ch3_gtytxp1_out : std_ulogic;
  SIGNAL ch4_gtyrxn1_in : std_ulogic;
  SIGNAL ch4_gtyrxp1_in : std_ulogic;
  SIGNAL ch4_gtytxn1_out : std_ulogic;
  SIGNAL ch4_gtytxp1_out : std_ulogic;
  SIGNAL ch5_gtyrxn1_in : std_ulogic;
  SIGNAL ch5_gtyrxp1_in : std_ulogic;
  SIGNAL ch5_gtytxn1_out : std_ulogic;
  SIGNAL ch5_gtytxp1_out : std_ulogic;
  SIGNAL ch6_gtyrxn1_in : std_ulogic;
  SIGNAL ch6_gtyrxp1_in : std_ulogic;
  SIGNAL ch6_gtytxn1_out : std_ulogic;
  SIGNAL ch6_gtytxp1_out : std_ulogic;
  SIGNAL ch7_gtyrxn1_in : std_ulogic;
  SIGNAL ch7_gtyrxp1_in : std_ulogic;
  SIGNAL ch7_gtytxn1_out : std_ulogic;
  SIGNAL ch7_gtytxp1_out : std_ulogic;
  SIGNAL ch0_gtyrxn2_in : std_ulogic;
  SIGNAL ch0_gtyrxp2_in : std_ulogic;
  SIGNAL ch0_gtytxn2_out : std_ulogic;
  SIGNAL ch0_gtytxp2_out : std_ulogic;
  SIGNAL ch1_gtyrxn2_in : std_ulogic;
  SIGNAL ch1_gtyrxp2_in : std_ulogic;
  SIGNAL ch1_gtytxn2_out : std_ulogic;
  SIGNAL ch1_gtytxp2_out : std_ulogic;
  SIGNAL ch2_gtyrxn2_in : std_ulogic;
  SIGNAL ch2_gtyrxp2_in : std_ulogic;
  SIGNAL ch2_gtytxn2_out : std_ulogic;
  SIGNAL ch2_gtytxp2_out : std_ulogic;
  SIGNAL ch3_gtyrxn2_in : std_ulogic;
  SIGNAL ch3_gtyrxp2_in : std_ulogic;
  SIGNAL ch3_gtytxn2_out : std_ulogic;
  SIGNAL ch3_gtytxp2_out : std_ulogic;
  SIGNAL ch4_gtyrxn2_in : std_ulogic;
  SIGNAL ch4_gtyrxp2_in : std_ulogic;
  SIGNAL ch4_gtytxn2_out : std_ulogic;
  SIGNAL ch4_gtytxp2_out : std_ulogic;
  SIGNAL ch5_gtyrxn2_in : std_ulogic;
  SIGNAL ch5_gtyrxp2_in : std_ulogic;
  SIGNAL ch5_gtytxn2_out : std_ulogic;
  SIGNAL ch5_gtytxp2_out : std_ulogic;
  SIGNAL ch6_gtyrxn2_in : std_ulogic;
  SIGNAL ch6_gtyrxp2_in : std_ulogic;
  SIGNAL ch6_gtytxn2_out : std_ulogic;
  SIGNAL ch6_gtytxp2_out : std_ulogic;
  SIGNAL ch7_gtyrxn2_in : std_ulogic;
  SIGNAL ch7_gtyrxp2_in : std_ulogic;
  SIGNAL ch7_gtytxn2_out : std_ulogic;
  SIGNAL ch7_gtytxp2_out : std_ulogic;
  SIGNAL ch0_gtyrxn3_in : std_ulogic;
  SIGNAL ch0_gtyrxp3_in : std_ulogic;
  SIGNAL ch0_gtytxn3_out : std_ulogic;
  SIGNAL ch0_gtytxp3_out : std_ulogic;
  SIGNAL ch1_gtyrxn3_in : std_ulogic;
  SIGNAL ch1_gtyrxp3_in : std_ulogic;
  SIGNAL ch1_gtytxn3_out : std_ulogic;
  SIGNAL ch1_gtytxp3_out : std_ulogic;
  SIGNAL ch2_gtyrxn3_in : std_ulogic;
  SIGNAL ch2_gtyrxp3_in : std_ulogic;
  SIGNAL ch2_gtytxn3_out : std_ulogic;
  SIGNAL ch2_gtytxp3_out : std_ulogic;
  SIGNAL ch3_gtyrxn3_in : std_ulogic;
  SIGNAL ch3_gtyrxp3_in : std_ulogic;
  SIGNAL ch3_gtytxn3_out : std_ulogic;
  SIGNAL ch3_gtytxp3_out : std_ulogic;
  SIGNAL ch4_gtyrxn3_in : std_ulogic;
  SIGNAL ch4_gtyrxp3_in : std_ulogic;
  SIGNAL ch4_gtytxn3_out : std_ulogic;
  SIGNAL ch4_gtytxp3_out : std_ulogic;
  SIGNAL ch5_gtyrxn3_in : std_ulogic;
  SIGNAL ch5_gtyrxp3_in : std_ulogic;
  SIGNAL ch5_gtytxn3_out : std_ulogic;
  SIGNAL ch5_gtytxp3_out : std_ulogic;
  SIGNAL ch6_gtyrxn3_in : std_ulogic;
  SIGNAL ch6_gtyrxp3_in : std_ulogic;
  SIGNAL ch6_gtytxn3_out : std_ulogic;
  SIGNAL ch6_gtytxp3_out : std_ulogic;
  SIGNAL ch7_gtyrxn3_in : std_ulogic;
  SIGNAL ch7_gtyrxp3_in : std_ulogic;
  SIGNAL ch7_gtytxn3_out : std_ulogic;
  SIGNAL ch7_gtytxp3_out : std_ulogic;
  SIGNAL ch0_txheader0 : std_ulogic_vector(1 downto 0);
  SIGNAL ch1_txheader0 : std_ulogic_vector(1 downto 0);
  SIGNAL ch2_txheader0 : std_ulogic_vector(1 downto 0);
  SIGNAL ch3_txheader0 : std_ulogic_vector(1 downto 0);
  SIGNAL ch4_txheader0 : std_ulogic_vector(1 downto 0);
  SIGNAL ch5_txheader0 : std_ulogic_vector(1 downto 0);
  SIGNAL ch6_txheader0 : std_ulogic_vector(1 downto 0);
  SIGNAL ch7_txheader0 : std_ulogic_vector(1 downto 0);
  SIGNAL ch0_txsequence0 : std_ulogic_vector(5 downto 0);
  SIGNAL ch1_txsequence0 : std_ulogic_vector(5 downto 0);
  SIGNAL ch2_txsequence0 : std_ulogic_vector(5 downto 0);
  SIGNAL ch3_txsequence0 : std_ulogic_vector(5 downto 0);
  SIGNAL ch4_txsequence0 : std_ulogic_vector(5 downto 0);
  SIGNAL ch5_txsequence0 : std_ulogic_vector(5 downto 0);
  SIGNAL ch6_txsequence0 : std_ulogic_vector(5 downto 0);
  SIGNAL ch7_txsequence0 : std_ulogic_vector(5 downto 0);
  SIGNAL ch0_txheader1 : std_ulogic_vector(1 downto 0);
  SIGNAL ch1_txheader1 : std_ulogic_vector(1 downto 0);
  SIGNAL ch2_txheader1 : std_ulogic_vector(1 downto 0);
  SIGNAL ch3_txheader1 : std_ulogic_vector(1 downto 0);
  SIGNAL ch4_txheader1 : std_ulogic_vector(1 downto 0);
  SIGNAL ch5_txheader1 : std_ulogic_vector(1 downto 0);
  SIGNAL ch6_txheader1 : std_ulogic_vector(1 downto 0);
  SIGNAL ch7_txheader1 : std_ulogic_vector(1 downto 0);
  SIGNAL ch0_txsequence1 : std_ulogic_vector(5 downto 0);
  SIGNAL ch1_txsequence1 : std_ulogic_vector(5 downto 0);
  SIGNAL ch2_txsequence1 : std_ulogic_vector(5 downto 0);
  SIGNAL ch3_txsequence1 : std_ulogic_vector(5 downto 0);
  SIGNAL ch4_txsequence1 : std_ulogic_vector(5 downto 0);
  SIGNAL ch5_txsequence1 : std_ulogic_vector(5 downto 0);
  SIGNAL ch6_txsequence1 : std_ulogic_vector(5 downto 0);
  SIGNAL ch7_txsequence1 : std_ulogic_vector(5 downto 0);
  SIGNAL ch0_txheader2 : std_ulogic_vector(1 downto 0);
  SIGNAL ch1_txheader2 : std_ulogic_vector(1 downto 0);
  SIGNAL ch2_txheader2 : std_ulogic_vector(1 downto 0);
  SIGNAL ch3_txheader2 : std_ulogic_vector(1 downto 0);
  SIGNAL ch4_txheader2 : std_ulogic_vector(1 downto 0);
  SIGNAL ch5_txheader2 : std_ulogic_vector(1 downto 0);
  SIGNAL ch6_txheader2 : std_ulogic_vector(1 downto 0);
  SIGNAL ch7_txheader2 : std_ulogic_vector(1 downto 0);
  SIGNAL ch0_txsequence2 : std_ulogic_vector(5 downto 0);
  SIGNAL ch1_txsequence2 : std_ulogic_vector(5 downto 0);
  SIGNAL ch2_txsequence2 : std_ulogic_vector(5 downto 0);
  SIGNAL ch3_txsequence2 : std_ulogic_vector(5 downto 0);
  SIGNAL ch4_txsequence2 : std_ulogic_vector(5 downto 0);
  SIGNAL ch5_txsequence2 : std_ulogic_vector(5 downto 0);
  SIGNAL ch6_txsequence2 : std_ulogic_vector(5 downto 0);
  SIGNAL ch7_txsequence2 : std_ulogic_vector(5 downto 0);
  SIGNAL ch0_txheader3 : std_ulogic_vector(1 downto 0);
  SIGNAL ch1_txheader3 : std_ulogic_vector(1 downto 0);
  SIGNAL ch2_txheader3 : std_ulogic_vector(1 downto 0);
  SIGNAL ch3_txheader3 : std_ulogic_vector(1 downto 0);
  SIGNAL ch4_txheader3 : std_ulogic_vector(1 downto 0);
  SIGNAL ch5_txheader3 : std_ulogic_vector(1 downto 0);
  SIGNAL ch6_txheader3 : std_ulogic_vector(1 downto 0);
  SIGNAL ch7_txheader3 : std_ulogic_vector(1 downto 0);
  SIGNAL ch0_txsequence3 : std_ulogic_vector(5 downto 0);
  SIGNAL ch1_txsequence3 : std_ulogic_vector(5 downto 0);
  SIGNAL ch2_txsequence3 : std_ulogic_vector(5 downto 0);
  SIGNAL ch3_txsequence3 : std_ulogic_vector(5 downto 0);
  SIGNAL ch4_txsequence3 : std_ulogic_vector(5 downto 0);
  SIGNAL ch5_txsequence3 : std_ulogic_vector(5 downto 0);
  SIGNAL ch6_txsequence3 : std_ulogic_vector(5 downto 0);
  SIGNAL ch7_txsequence3 : std_ulogic_vector(5 downto 0);
  SIGNAL hb0_gtwiz_userdata_tx0 : std_ulogic_vector(63 downto 0);
  SIGNAL hb1_gtwiz_userdata_tx0 : std_ulogic_vector(63 downto 0);
  SIGNAL hb2_gtwiz_userdata_tx0 : std_ulogic_vector(63 downto 0);
  SIGNAL hb3_gtwiz_userdata_tx0 : std_ulogic_vector(63 downto 0);
  SIGNAL hb4_gtwiz_userdata_tx0 : std_ulogic_vector(63 downto 0);
  SIGNAL hb5_gtwiz_userdata_tx0 : std_ulogic_vector(63 downto 0);
  SIGNAL hb6_gtwiz_userdata_tx0 : std_ulogic_vector(63 downto 0);
  SIGNAL hb7_gtwiz_userdata_tx0 : std_ulogic_vector(63 downto 0);
  SIGNAL hb0_gtwiz_userdata_tx1 : std_ulogic_vector(63 downto 0);
  SIGNAL hb1_gtwiz_userdata_tx1 : std_ulogic_vector(63 downto 0);
  SIGNAL hb2_gtwiz_userdata_tx1 : std_ulogic_vector(63 downto 0);
  SIGNAL hb3_gtwiz_userdata_tx1 : std_ulogic_vector(63 downto 0);
  SIGNAL hb4_gtwiz_userdata_tx1 : std_ulogic_vector(63 downto 0);
  SIGNAL hb5_gtwiz_userdata_tx1 : std_ulogic_vector(63 downto 0);
  SIGNAL hb6_gtwiz_userdata_tx1 : std_ulogic_vector(63 downto 0);
  SIGNAL hb7_gtwiz_userdata_tx1 : std_ulogic_vector(63 downto 0);
  SIGNAL hb0_gtwiz_userdata_tx2 : std_ulogic_vector(63 downto 0);
  SIGNAL hb1_gtwiz_userdata_tx2 : std_ulogic_vector(63 downto 0);
  SIGNAL hb2_gtwiz_userdata_tx2 : std_ulogic_vector(63 downto 0);
  SIGNAL hb3_gtwiz_userdata_tx2 : std_ulogic_vector(63 downto 0);
  SIGNAL hb4_gtwiz_userdata_tx2 : std_ulogic_vector(63 downto 0);
  SIGNAL hb5_gtwiz_userdata_tx2 : std_ulogic_vector(63 downto 0);
  SIGNAL hb6_gtwiz_userdata_tx2 : std_ulogic_vector(63 downto 0);
  SIGNAL hb7_gtwiz_userdata_tx2 : std_ulogic_vector(63 downto 0);
  SIGNAL hb0_gtwiz_userdata_tx3 : std_ulogic_vector(63 downto 0);
  SIGNAL hb1_gtwiz_userdata_tx3 : std_ulogic_vector(63 downto 0);
  SIGNAL hb2_gtwiz_userdata_tx3 : std_ulogic_vector(63 downto 0);
  SIGNAL hb3_gtwiz_userdata_tx3 : std_ulogic_vector(63 downto 0);
  SIGNAL hb4_gtwiz_userdata_tx3 : std_ulogic_vector(63 downto 0);
  SIGNAL hb5_gtwiz_userdata_tx3 : std_ulogic_vector(63 downto 0);
  SIGNAL hb6_gtwiz_userdata_tx3 : std_ulogic_vector(63 downto 0);
  SIGNAL hb7_gtwiz_userdata_tx3 : std_ulogic_vector(63 downto 0);
  SIGNAL ch0_rxdatavalid0 : std_ulogic_vector(0 downto 0);
  SIGNAL ch1_rxdatavalid0 : std_ulogic_vector(0 downto 0);
  SIGNAL ch2_rxdatavalid0 : std_ulogic_vector(0 downto 0);
  SIGNAL ch3_rxdatavalid0 : std_ulogic_vector(0 downto 0);
  SIGNAL ch4_rxdatavalid0 : std_ulogic_vector(0 downto 0);
  SIGNAL ch5_rxdatavalid0 : std_ulogic_vector(0 downto 0);
  SIGNAL ch6_rxdatavalid0 : std_ulogic_vector(0 downto 0);
  SIGNAL ch7_rxdatavalid0 : std_ulogic_vector(0 downto 0);
  SIGNAL ch0_rxheader0 : std_ulogic_vector(1 downto 0);
  SIGNAL ch1_rxheader0 : std_ulogic_vector(1 downto 0);
  SIGNAL ch2_rxheader0 : std_ulogic_vector(1 downto 0);
  SIGNAL ch3_rxheader0 : std_ulogic_vector(1 downto 0);
  SIGNAL ch4_rxheader0 : std_ulogic_vector(1 downto 0);
  SIGNAL ch5_rxheader0 : std_ulogic_vector(1 downto 0);
  SIGNAL ch6_rxheader0 : std_ulogic_vector(1 downto 0);
  SIGNAL ch7_rxheader0 : std_ulogic_vector(1 downto 0);
  SIGNAL ch0_rxgearboxslip0 : std_ulogic_vector(0 downto 0);
  SIGNAL ch1_rxgearboxslip0 : std_ulogic_vector(0 downto 0);
  SIGNAL ch2_rxgearboxslip0 : std_ulogic_vector(0 downto 0);
  SIGNAL ch3_rxgearboxslip0 : std_ulogic_vector(0 downto 0);
  SIGNAL ch4_rxgearboxslip0 : std_ulogic_vector(0 downto 0);
  SIGNAL ch5_rxgearboxslip0 : std_ulogic_vector(0 downto 0);
  SIGNAL ch6_rxgearboxslip0 : std_ulogic_vector(0 downto 0);
  SIGNAL ch7_rxgearboxslip0 : std_ulogic_vector(0 downto 0);
  SIGNAL ch0_rxdatavalid1 : std_ulogic_vector(0 downto 0);
  SIGNAL ch1_rxdatavalid1 : std_ulogic_vector(0 downto 0);
  SIGNAL ch2_rxdatavalid1 : std_ulogic_vector(0 downto 0);
  SIGNAL ch3_rxdatavalid1 : std_ulogic_vector(0 downto 0);
  SIGNAL ch4_rxdatavalid1 : std_ulogic_vector(0 downto 0);
  SIGNAL ch5_rxdatavalid1 : std_ulogic_vector(0 downto 0);
  SIGNAL ch6_rxdatavalid1 : std_ulogic_vector(0 downto 0);
  SIGNAL ch7_rxdatavalid1 : std_ulogic_vector(0 downto 0);
  SIGNAL ch0_rxheader1 : std_ulogic_vector(1 downto 0);
  SIGNAL ch1_rxheader1 : std_ulogic_vector(1 downto 0);
  SIGNAL ch2_rxheader1 : std_ulogic_vector(1 downto 0);
  SIGNAL ch3_rxheader1 : std_ulogic_vector(1 downto 0);
  SIGNAL ch4_rxheader1 : std_ulogic_vector(1 downto 0);
  SIGNAL ch5_rxheader1 : std_ulogic_vector(1 downto 0);
  SIGNAL ch6_rxheader1 : std_ulogic_vector(1 downto 0);
  SIGNAL ch7_rxheader1 : std_ulogic_vector(1 downto 0);
  SIGNAL ch0_rxgearboxslip1 : std_ulogic_vector(0 downto 0);
  SIGNAL ch1_rxgearboxslip1 : std_ulogic_vector(0 downto 0);
  SIGNAL ch2_rxgearboxslip1 : std_ulogic_vector(0 downto 0);
  SIGNAL ch3_rxgearboxslip1 : std_ulogic_vector(0 downto 0);
  SIGNAL ch4_rxgearboxslip1 : std_ulogic_vector(0 downto 0);
  SIGNAL ch5_rxgearboxslip1 : std_ulogic_vector(0 downto 0);
  SIGNAL ch6_rxgearboxslip1 : std_ulogic_vector(0 downto 0);
  SIGNAL ch7_rxgearboxslip1 : std_ulogic_vector(0 downto 0);
  SIGNAL ch0_rxdatavalid2 : std_ulogic_vector(0 downto 0);
  SIGNAL ch1_rxdatavalid2 : std_ulogic_vector(0 downto 0);
  SIGNAL ch2_rxdatavalid2 : std_ulogic_vector(0 downto 0);
  SIGNAL ch3_rxdatavalid2 : std_ulogic_vector(0 downto 0);
  SIGNAL ch4_rxdatavalid2 : std_ulogic_vector(0 downto 0);
  SIGNAL ch5_rxdatavalid2 : std_ulogic_vector(0 downto 0);
  SIGNAL ch6_rxdatavalid2 : std_ulogic_vector(0 downto 0);
  SIGNAL ch7_rxdatavalid2 : std_ulogic_vector(0 downto 0);
  SIGNAL ch0_rxheader2 : std_ulogic_vector(1 downto 0);
  SIGNAL ch1_rxheader2 : std_ulogic_vector(1 downto 0);
  SIGNAL ch2_rxheader2 : std_ulogic_vector(1 downto 0);
  SIGNAL ch3_rxheader2 : std_ulogic_vector(1 downto 0);
  SIGNAL ch4_rxheader2 : std_ulogic_vector(1 downto 0);
  SIGNAL ch5_rxheader2 : std_ulogic_vector(1 downto 0);
  SIGNAL ch6_rxheader2 : std_ulogic_vector(1 downto 0);
  SIGNAL ch7_rxheader2 : std_ulogic_vector(1 downto 0);
  SIGNAL ch0_rxgearboxslip2 : std_ulogic_vector(0 downto 0);
  SIGNAL ch1_rxgearboxslip2 : std_ulogic_vector(0 downto 0);
  SIGNAL ch2_rxgearboxslip2 : std_ulogic_vector(0 downto 0);
  SIGNAL ch3_rxgearboxslip2 : std_ulogic_vector(0 downto 0);
  SIGNAL ch4_rxgearboxslip2 : std_ulogic_vector(0 downto 0);
  SIGNAL ch5_rxgearboxslip2 : std_ulogic_vector(0 downto 0);
  SIGNAL ch6_rxgearboxslip2 : std_ulogic_vector(0 downto 0);
  SIGNAL ch7_rxgearboxslip2 : std_ulogic_vector(0 downto 0);
  SIGNAL ch0_rxdatavalid3 : std_ulogic_vector(0 downto 0);
  SIGNAL ch1_rxdatavalid3 : std_ulogic_vector(0 downto 0);
  SIGNAL ch2_rxdatavalid3 : std_ulogic_vector(0 downto 0);
  SIGNAL ch3_rxdatavalid3 : std_ulogic_vector(0 downto 0);
  SIGNAL ch4_rxdatavalid3 : std_ulogic_vector(0 downto 0);
  SIGNAL ch5_rxdatavalid3 : std_ulogic_vector(0 downto 0);
  SIGNAL ch6_rxdatavalid3 : std_ulogic_vector(0 downto 0);
  SIGNAL ch7_rxdatavalid3 : std_ulogic_vector(0 downto 0);
  SIGNAL ch0_rxheader3 : std_ulogic_vector(1 downto 0);
  SIGNAL ch1_rxheader3 : std_ulogic_vector(1 downto 0);
  SIGNAL ch2_rxheader3 : std_ulogic_vector(1 downto 0);
  SIGNAL ch3_rxheader3 : std_ulogic_vector(1 downto 0);
  SIGNAL ch4_rxheader3 : std_ulogic_vector(1 downto 0);
  SIGNAL ch5_rxheader3 : std_ulogic_vector(1 downto 0);
  SIGNAL ch6_rxheader3 : std_ulogic_vector(1 downto 0);
  SIGNAL ch7_rxheader3 : std_ulogic_vector(1 downto 0);
  SIGNAL ch0_rxgearboxslip3 : std_ulogic_vector(0 downto 0);
  SIGNAL ch1_rxgearboxslip3 : std_ulogic_vector(0 downto 0);
  SIGNAL ch2_rxgearboxslip3 : std_ulogic_vector(0 downto 0);
  SIGNAL ch3_rxgearboxslip3 : std_ulogic_vector(0 downto 0);
  SIGNAL ch4_rxgearboxslip3 : std_ulogic_vector(0 downto 0);
  SIGNAL ch5_rxgearboxslip3 : std_ulogic_vector(0 downto 0);
  SIGNAL ch6_rxgearboxslip3 : std_ulogic_vector(0 downto 0);
  SIGNAL ch7_rxgearboxslip3 : std_ulogic_vector(0 downto 0);
  SIGNAL hb0_gtwiz_userdata_rx0 : std_ulogic_vector(63 downto 0);
  SIGNAL hb1_gtwiz_userdata_rx0 : std_ulogic_vector(63 downto 0);
  SIGNAL hb2_gtwiz_userdata_rx0 : std_ulogic_vector(63 downto 0);
  SIGNAL hb3_gtwiz_userdata_rx0 : std_ulogic_vector(63 downto 0);
  SIGNAL hb4_gtwiz_userdata_rx0 : std_ulogic_vector(63 downto 0);
  SIGNAL hb5_gtwiz_userdata_rx0 : std_ulogic_vector(63 downto 0);
  SIGNAL hb6_gtwiz_userdata_rx0 : std_ulogic_vector(63 downto 0);
  SIGNAL hb7_gtwiz_userdata_rx0 : std_ulogic_vector(63 downto 0);
  SIGNAL hb0_gtwiz_userdata_rx1 : std_ulogic_vector(63 downto 0);
  SIGNAL hb1_gtwiz_userdata_rx1 : std_ulogic_vector(63 downto 0);
  SIGNAL hb2_gtwiz_userdata_rx1 : std_ulogic_vector(63 downto 0);
  SIGNAL hb3_gtwiz_userdata_rx1 : std_ulogic_vector(63 downto 0);
  SIGNAL hb4_gtwiz_userdata_rx1 : std_ulogic_vector(63 downto 0);
  SIGNAL hb5_gtwiz_userdata_rx1 : std_ulogic_vector(63 downto 0);
  SIGNAL hb6_gtwiz_userdata_rx1 : std_ulogic_vector(63 downto 0);
  SIGNAL hb7_gtwiz_userdata_rx1 : std_ulogic_vector(63 downto 0);
  SIGNAL hb0_gtwiz_userdata_rx2 : std_ulogic_vector(63 downto 0);
  SIGNAL hb1_gtwiz_userdata_rx2 : std_ulogic_vector(63 downto 0);
  SIGNAL hb2_gtwiz_userdata_rx2 : std_ulogic_vector(63 downto 0);
  SIGNAL hb3_gtwiz_userdata_rx2 : std_ulogic_vector(63 downto 0);
  SIGNAL hb4_gtwiz_userdata_rx2 : std_ulogic_vector(63 downto 0);
  SIGNAL hb5_gtwiz_userdata_rx2 : std_ulogic_vector(63 downto 0);
  SIGNAL hb6_gtwiz_userdata_rx2 : std_ulogic_vector(63 downto 0);
  SIGNAL hb7_gtwiz_userdata_rx2 : std_ulogic_vector(63 downto 0);
  SIGNAL hb0_gtwiz_userdata_rx3 : std_ulogic_vector(63 downto 0);
  SIGNAL hb1_gtwiz_userdata_rx3 : std_ulogic_vector(63 downto 0);
  SIGNAL hb2_gtwiz_userdata_rx3 : std_ulogic_vector(63 downto 0);
  SIGNAL hb3_gtwiz_userdata_rx3 : std_ulogic_vector(63 downto 0);
  SIGNAL hb4_gtwiz_userdata_rx3 : std_ulogic_vector(63 downto 0);
  SIGNAL hb5_gtwiz_userdata_rx3 : std_ulogic_vector(63 downto 0);
  SIGNAL hb6_gtwiz_userdata_rx3 : std_ulogic_vector(63 downto 0);
  SIGNAL hb7_gtwiz_userdata_rx3 : std_ulogic_vector(63 downto 0);
  SIGNAL led_ddimma_red_hw_i : std_ulogic;
  SIGNAL led_ddimma_green_hw_i : std_ulogic;
  SIGNAL led_ddimmb_red_hw_i : std_ulogic;
  SIGNAL led_ddimmb_green_hw_i : std_ulogic;
  SIGNAL led_ddimmc_red_hw_i : std_ulogic;
  SIGNAL led_ddimmc_green_hw_i : std_ulogic;
  SIGNAL led_ddimmd_red_hw_i : std_ulogic;
  SIGNAL led_ddimmd_green_hw_i : std_ulogic;
  SIGNAL led_ddimmw_red_hw_i : std_ulogic;
  SIGNAL led_ddimmw_green_hw_i : std_ulogic;
  SIGNAL fml_axis_aclk : std_ulogic;
  SIGNAL fml_axis_i : t_AXI4_LITE_SLAVE_INPUT;
  SIGNAL fml_axis_o : t_AXI4_LITE_SLAVE_OUTPUT;
  SIGNAL sysclk_probe0 : std_ulogic;
  SIGNAL sysclk_probe1 : std_ulogic;
 signal tsm_state2_to_3 : std_ulogic;
  signal tsm_state6_to_1_0 : std_ulogic;
  signal tsm_state6_to_1_1 : std_ulogic;
  signal tsm_state6_to_1_2 : std_ulogic;
  signal tsm_state6_to_1_3 : std_ulogic;
  signal tsm_state4_to_5 : std_ulogic;
  signal tsm_state5_to_6 : std_ulogic;
  signal dut_resetn_vio : std_ulogic;
  signal fpga_resetn_vio : std_ulogic;
  signal lane_force_unlock : std_logic_vector(7 downto 0);
  signal phy_freerun_clk : std_ulogic;
  signal hb_gtwiz_reset_clk_freerun_buf_int : std_ulogic;


  --COMPONENT vio_0
  --  PORT (
  --    clk        : IN  STD_LOGIC;
  --    probe_out0 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
  --    probe_out1 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
  --    probe_out2 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
  --    probe_out3 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
  --    probe_out4 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
  --    probe_out5 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
  --    probe_out6 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  --    --probe_out7 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
  --    --probe_out8 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
  --    --probe_out9 : OUT STD_LOGIC_VECTOR(255 DOWNTO 0);
  --    --probe_out10 : OUT STD_LOGIC_VECTOR(255 DOWNTO 0)
  --    );
  --END COMPONENT;

begin

--       vio : vio_0
--          PORT MAP (
--            clk                            => cclk_b,
--            --probe_out0(0)                  => tsm_state6_to_1,
--            probe_out0                     => open,
--            probe_out1                     => open,            -- [OUT STD_LOGIC_VECTOR(0 DOWNTO 0 ]
--            probe_out2                     => open,            -- [OUT STD_LOGIC_VECTOR(0 DOWNTO 0 ]
--            probe_out3                     => open,
--            probe_out4                     => open,
--            probe_out5                     => open,
--            probe_out6                     => open);
--            probe_out4(0)                  => flit_valid,             -- [OUT STD_LOGIC_VECTOR(0 DOWNTO 0 ]
 --           probe_out5                     => flit_16,
 --           probe_out6(0)                  => rxbufreset_in,
 --           probe_out7                     => flit_16_tl_template,
 --           probe_out8(0)                  => flit_16_data_run_length,
 --           probe_out9                     => data_flit_msb,
 --           probe_out10                    => data_flit_lsb);
 
 sys_resetn_vio <= '1';
 tsm_state4_to_5 <= '1';
 tsm_state2_to_3 <= '1';
 tsm_state5_to_6 <= '1';
 dut_resetn_vio <= '1';
 fpga_resetn_vio <= '1';
 lane_force_unlock <= (others => '0');

 --sys_resetn_int   <= sys_resetn AND sys_resetn_vio;
 ocde_int         <= ocde and sys_resetn_vio and fpga_resetn_vio;
 --ocde_int         <= sys_resetn_vio;
 --ice_resetn        <= sys_resetn_vio;
 --ice_resetn        <= ocde and sys_resetn_vio and dut_resetn_vio;
 --raw_resetn_int   <= raw_resetn AND NOT dlx_reset;
 raw_resetn_int   <= NOT dlx_reset3;

  counter0 : entity work.counter
    port map (
      clock => cclk_a,
      reset => dlx_reset0,
      tsm_state6_to_1 => tsm_state6_to_1_0
      );

  counter1 : entity work.counter
    port map (
      clock => cclk_b,
      reset => dlx_reset1,
      tsm_state6_to_1 => tsm_state6_to_1_1
      );

  counter2 : entity work.counter
    port map (
      clock => cclk_c,
      reset => dlx_reset2,
      tsm_state6_to_1 => tsm_state6_to_1_2
      );

  counter3 : entity work.counter
    port map (
      clock => cclk_d,
      reset => dlx_reset3,
      tsm_state6_to_1 => tsm_state6_to_1_3
      );

  -- Probe for sysclk
  oddre1_sysclk0_p : oddre1
    generic map (
      IS_C_INVERTED  => '0', -- Optional inversion for C
      IS_D1_INVERTED => '0', -- Optional inversion for D1
      IS_D2_INVERTED => '0', -- Optional inversion for D2
      SRVAL          => '0'  -- Initializes the ODDRE1 Flip-Flops to the specified value (1'b0, 1'b1)
      )
    port map (
      Q              => sysclk_probe0, -- 1-bit output: Data output to IOB
      C              => sysclk,        -- 1-bit input: High-speed clock input
      D1             => '0',           -- 1-bit input: Parallel data input 1
      D2             => '1',           -- 1-bit input: Parallel data input 2
      SR             => '0'            -- 1-bit input: Active High Async Reset
      );

  iobuf_sysclk_probe0 : obufds
    PORT MAP (
      I  => sysclk_probe0,
      O  => sysclk_probe0_p,
      OB => sysclk_probe0_n
      );

  oddre1_sysclk1_p : oddre1
    generic map (
      IS_C_INVERTED  => '0', -- Optional inversion for C
      IS_D1_INVERTED => '0', -- Optional inversion for D1
      IS_D2_INVERTED => '0', -- Optional inversion for D2
      SRVAL          => '0'  -- Initializes the ODDRE1 Flip-Flops to the specified value (1'b0, 1'b1)
      )
    port map (
      Q              => sysclk_probe1, -- 1-bit output: Data output to IOB
      C              => sysclk,        -- 1-bit input: High-speed clock input
      D1             => '0',           -- 1-bit input: Parallel data input 1
      D2             => '1',           -- 1-bit input: Parallel data input 2
      SR             => '0'            -- 1-bit input: Active High Async Reset
      );

  iobuf_sysclk_probe1 : obufds
    PORT MAP (
      I  => sysclk_probe1,
      O  => sysclk_probe1_p,
      OB => sysclk_probe1_n
      );

  -- Assemble OpenCAPI Lanes
  mgtrefclk0_x0y0_n <= DDIMMA_FPGA_REFCLK_N(0);
  mgtrefclk0_x0y1_n <= DDIMMA_FPGA_REFCLK_N(1);
  mgtrefclk0_x0y0_p <= DDIMMA_FPGA_REFCLK_P(0);
  mgtrefclk0_x0y1_p <= DDIMMA_FPGA_REFCLK_P(1);
  mgtrefclk1_x0y0_n <= DDIMMB_FPGA_REFCLK_N(0);
  mgtrefclk1_x0y1_n <= DDIMMB_FPGA_REFCLK_N(1);
  mgtrefclk1_x0y0_p <= DDIMMB_FPGA_REFCLK_P(0);
  mgtrefclk1_x0y1_p <= DDIMMB_FPGA_REFCLK_P(1);
  mgtrefclk2_x0y0_n <= DDIMMC_FPGA_REFCLK_N(0);
  mgtrefclk2_x0y1_n <= DDIMMC_FPGA_REFCLK_N(1);
  mgtrefclk2_x0y0_p <= DDIMMC_FPGA_REFCLK_P(0);
  mgtrefclk2_x0y1_p <= DDIMMC_FPGA_REFCLK_P(1);
  mgtrefclk3_x0y0_n <= DDIMMD_FPGA_REFCLK_N(0);
  mgtrefclk3_x0y1_n <= DDIMMD_FPGA_REFCLK_N(1);
  mgtrefclk3_x0y0_p <= DDIMMD_FPGA_REFCLK_P(0);
  mgtrefclk3_x0y1_p <= DDIMMD_FPGA_REFCLK_P(1);

  ch7_gtyrxn0_in <= DDIMMA_FPGA_LANE_N(7);
  ch6_gtyrxn0_in <= DDIMMA_FPGA_LANE_N(6);
  ch5_gtyrxn0_in <= DDIMMA_FPGA_LANE_N(5);
  ch4_gtyrxn0_in <= DDIMMA_FPGA_LANE_N(4);
  ch3_gtyrxn0_in <= DDIMMA_FPGA_LANE_N(3);
  ch2_gtyrxn0_in <= DDIMMA_FPGA_LANE_N(2);
  ch1_gtyrxn0_in <= DDIMMA_FPGA_LANE_N(1);
  ch0_gtyrxn0_in <= DDIMMA_FPGA_LANE_N(0);
  ch7_gtyrxp0_in <= DDIMMA_FPGA_LANE_P(7);
  ch6_gtyrxp0_in <= DDIMMA_FPGA_LANE_P(6);
  ch5_gtyrxp0_in <= DDIMMA_FPGA_LANE_P(5);
  ch4_gtyrxp0_in <= DDIMMA_FPGA_LANE_P(4);
  ch3_gtyrxp0_in <= DDIMMA_FPGA_LANE_P(3);
  ch2_gtyrxp0_in <= DDIMMA_FPGA_LANE_P(2);
  ch1_gtyrxp0_in <= DDIMMA_FPGA_LANE_P(1);
  ch0_gtyrxp0_in <= DDIMMA_FPGA_LANE_P(0);
  FPGA_DDIMMA_LANE_N(7 downto 0) <= ch7_gtytxn0_out &
                                    ch6_gtytxn0_out &
                                    ch5_gtytxn0_out &
                                    ch4_gtytxn0_out &
                                    ch3_gtytxn0_out &
                                    ch2_gtytxn0_out &
                                    ch1_gtytxn0_out &
                                    ch0_gtytxn0_out;
  FPGA_DDIMMA_LANE_P(7 downto 0) <= ch7_gtytxp0_out &
                                    ch6_gtytxp0_out &
                                    ch5_gtytxp0_out &
                                    ch4_gtytxp0_out &
                                    ch3_gtytxp0_out &
                                    ch2_gtytxp0_out &
                                    ch1_gtytxp0_out &
                                    ch0_gtytxp0_out;
  ch7_gtyrxn1_in <= DDIMMB_FPGA_LANE_N(7);
  ch6_gtyrxn1_in <= DDIMMB_FPGA_LANE_N(6);
  ch5_gtyrxn1_in <= DDIMMB_FPGA_LANE_N(5);
  ch4_gtyrxn1_in <= DDIMMB_FPGA_LANE_N(4);
  ch3_gtyrxn1_in <= DDIMMB_FPGA_LANE_N(3);
  ch2_gtyrxn1_in <= DDIMMB_FPGA_LANE_N(2);
  ch1_gtyrxn1_in <= DDIMMB_FPGA_LANE_N(1);
  ch0_gtyrxn1_in <= DDIMMB_FPGA_LANE_N(0);
  ch7_gtyrxp1_in <= DDIMMB_FPGA_LANE_P(7);
  ch6_gtyrxp1_in <= DDIMMB_FPGA_LANE_P(6);
  ch5_gtyrxp1_in <= DDIMMB_FPGA_LANE_P(5);
  ch4_gtyrxp1_in <= DDIMMB_FPGA_LANE_P(4);
  ch3_gtyrxp1_in <= DDIMMB_FPGA_LANE_P(3);
  ch2_gtyrxp1_in <= DDIMMB_FPGA_LANE_P(2);
  ch1_gtyrxp1_in <= DDIMMB_FPGA_LANE_P(1);
  ch0_gtyrxp1_in <= DDIMMB_FPGA_LANE_P(0);
  FPGA_DDIMMB_LANE_N(7 downto 0) <= ch7_gtytxn1_out &
                                    ch6_gtytxn1_out &
                                    ch5_gtytxn1_out &
                                    ch4_gtytxn1_out &
                                    ch3_gtytxn1_out &
                                    ch2_gtytxn1_out &
                                    ch1_gtytxn1_out &
                                    ch0_gtytxn1_out;
  FPGA_DDIMMB_LANE_P(7 downto 0) <= ch7_gtytxp1_out &
                                    ch6_gtytxp1_out &
                                    ch5_gtytxp1_out &
                                    ch4_gtytxp1_out &
                                    ch3_gtytxp1_out &
                                    ch2_gtytxp1_out &
                                    ch1_gtytxp1_out &
                                    ch0_gtytxp1_out;
  ch7_gtyrxn2_in <= DDIMMC_FPGA_LANE_N(7);
  ch6_gtyrxn2_in <= DDIMMC_FPGA_LANE_N(6);
  ch5_gtyrxn2_in <= DDIMMC_FPGA_LANE_N(5);
  ch4_gtyrxn2_in <= DDIMMC_FPGA_LANE_N(4);
  ch3_gtyrxn2_in <= DDIMMC_FPGA_LANE_N(3);
  ch2_gtyrxn2_in <= DDIMMC_FPGA_LANE_N(2);
  ch1_gtyrxn2_in <= DDIMMC_FPGA_LANE_N(1);
  ch0_gtyrxn2_in <= DDIMMC_FPGA_LANE_N(0);
  ch7_gtyrxp2_in <= DDIMMC_FPGA_LANE_P(7);
  ch6_gtyrxp2_in <= DDIMMC_FPGA_LANE_P(6);
  ch5_gtyrxp2_in <= DDIMMC_FPGA_LANE_P(5);
  ch4_gtyrxp2_in <= DDIMMC_FPGA_LANE_P(4);
  ch3_gtyrxp2_in <= DDIMMC_FPGA_LANE_P(3);
  ch2_gtyrxp2_in <= DDIMMC_FPGA_LANE_P(2);
  ch1_gtyrxp2_in <= DDIMMC_FPGA_LANE_P(1);
  ch0_gtyrxp2_in <= DDIMMC_FPGA_LANE_P(0);
  FPGA_DDIMMC_LANE_N(7 downto 0) <= ch7_gtytxn2_out &
                                    ch6_gtytxn2_out &
                                    ch5_gtytxn2_out &
                                    ch4_gtytxn2_out &
                                    ch3_gtytxn2_out &
                                    ch2_gtytxn2_out &
                                    ch1_gtytxn2_out &
                                    ch0_gtytxn2_out;
  FPGA_DDIMMC_LANE_P(7 downto 0) <= ch7_gtytxp2_out &
                                    ch6_gtytxp2_out &
                                    ch5_gtytxp2_out &
                                    ch4_gtytxp2_out &
                                    ch3_gtytxp2_out &
                                    ch2_gtytxp2_out &
                                    ch1_gtytxp2_out &
                                    ch0_gtytxp2_out;
  ch7_gtyrxn3_in <= DDIMMD_FPGA_LANE_N(7);
  ch6_gtyrxn3_in <= DDIMMD_FPGA_LANE_N(6);
  ch5_gtyrxn3_in <= DDIMMD_FPGA_LANE_N(5);
  ch4_gtyrxn3_in <= DDIMMD_FPGA_LANE_N(4);
  ch3_gtyrxn3_in <= DDIMMD_FPGA_LANE_N(3);
  ch2_gtyrxn3_in <= DDIMMD_FPGA_LANE_N(2);
  ch1_gtyrxn3_in <= DDIMMD_FPGA_LANE_N(1);
  ch0_gtyrxn3_in <= DDIMMD_FPGA_LANE_N(0);
  ch7_gtyrxp3_in <= DDIMMD_FPGA_LANE_P(7);
  ch6_gtyrxp3_in <= DDIMMD_FPGA_LANE_P(6);
  ch5_gtyrxp3_in <= DDIMMD_FPGA_LANE_P(5);
  ch4_gtyrxp3_in <= DDIMMD_FPGA_LANE_P(4);
  ch3_gtyrxp3_in <= DDIMMD_FPGA_LANE_P(3);
  ch2_gtyrxp3_in <= DDIMMD_FPGA_LANE_P(2);
  ch1_gtyrxp3_in <= DDIMMD_FPGA_LANE_P(1);
  ch0_gtyrxp3_in <= DDIMMD_FPGA_LANE_P(0);
  FPGA_DDIMMD_LANE_N(7 downto 0) <= ch7_gtytxn3_out &
                                    ch6_gtytxn3_out &
                                    ch5_gtytxn3_out &
                                    ch4_gtytxn3_out &
                                    ch3_gtytxn3_out &
                                    ch2_gtytxn3_out &
                                    ch1_gtytxn3_out &
                                    ch0_gtytxn3_out;
  FPGA_DDIMMD_LANE_P(7 downto 0) <= ch7_gtytxp3_out &
                                    ch6_gtytxp3_out &
                                    ch5_gtytxp3_out &
                                    ch4_gtytxp3_out &
                                    ch3_gtytxp3_out &
                                    ch2_gtytxp3_out &
                                    ch1_gtytxp3_out &
                                    ch0_gtytxp3_out;

  -- DDIMM B Data Path is swizzled to compensate for the swizling on the board. DL lane 0 is connected to PHY lane 7, 1 to 6, etc.
  ln7_rx_valid0              <= ch0_rxdatavalid0(0);
  ln6_rx_valid0              <= ch1_rxdatavalid0(0);
  ln5_rx_valid0              <= ch2_rxdatavalid0(0);
  ln4_rx_valid0              <= ch3_rxdatavalid0(0);
  ln3_rx_valid0              <= ch4_rxdatavalid0(0);
  ln2_rx_valid0              <= ch5_rxdatavalid0(0);
  ln1_rx_valid0              <= ch6_rxdatavalid0(0);
  ln0_rx_valid0              <= ch7_rxdatavalid0(0);
  ln7_rx_header0(1 downto 0) <= ch0_rxheader0(1 downto 0);
  ln6_rx_header0(1 downto 0) <= ch1_rxheader0(1 downto 0);
  ln5_rx_header0(1 downto 0) <= ch2_rxheader0(1 downto 0);
  ln4_rx_header0(1 downto 0) <= ch3_rxheader0(1 downto 0);
  ln3_rx_header0(1 downto 0) <= ch4_rxheader0(1 downto 0);
  ln2_rx_header0(1 downto 0) <= ch5_rxheader0(1 downto 0);
  ln1_rx_header0(1 downto 0) <= ch6_rxheader0(1 downto 0);
  ln0_rx_header0(1 downto 0) <= ch7_rxheader0(1 downto 0);
  ch7_rxgearboxslip0(0)      <= ln0_rx_slip0;
  ch6_rxgearboxslip0(0)      <= ln1_rx_slip0;
  ch5_rxgearboxslip0(0)      <= ln2_rx_slip0;
  ch4_rxgearboxslip0(0)      <= ln3_rx_slip0;
  ch3_rxgearboxslip0(0)      <= ln4_rx_slip0;
  ch2_rxgearboxslip0(0)      <= ln5_rx_slip0;
  ch1_rxgearboxslip0(0)      <= ln6_rx_slip0;
  ch0_rxgearboxslip0(0)      <= ln7_rx_slip0;
  ln7_rx_data0(63 downto 0)  <= hb0_gtwiz_userdata_rx0(63 downto 0);
  ln6_rx_data0(63 downto 0)  <= hb1_gtwiz_userdata_rx0(63 downto 0);
  ln5_rx_data0(63 downto 0)  <= hb2_gtwiz_userdata_rx0(63 downto 0);
  ln4_rx_data0(63 downto 0)  <= hb3_gtwiz_userdata_rx0(63 downto 0);
  ln3_rx_data0(63 downto 0)  <= hb4_gtwiz_userdata_rx0(63 downto 0);
  ln2_rx_data0(63 downto 0)  <= hb5_gtwiz_userdata_rx0(63 downto 0);
  ln1_rx_data0(63 downto 0)  <= hb6_gtwiz_userdata_rx0(63 downto 0);
  ln0_rx_data0(63 downto 0)  <= hb7_gtwiz_userdata_rx0(63 downto 0);
  ln7_rx_valid1              <= ch0_rxdatavalid1(0);
  ln6_rx_valid1              <= ch1_rxdatavalid1(0);
  ln5_rx_valid1              <= ch2_rxdatavalid1(0);
  ln4_rx_valid1              <= ch3_rxdatavalid1(0);
  ln3_rx_valid1              <= ch4_rxdatavalid1(0);
  ln2_rx_valid1              <= ch5_rxdatavalid1(0);
  ln1_rx_valid1              <= ch6_rxdatavalid1(0);
  ln0_rx_valid1              <= ch7_rxdatavalid1(0);
  ln7_rx_header1(1 downto 0) <= ch0_rxheader1(1 downto 0);
  ln6_rx_header1(1 downto 0) <= ch1_rxheader1(1 downto 0);
  ln5_rx_header1(1 downto 0) <= ch2_rxheader1(1 downto 0);
  ln4_rx_header1(1 downto 0) <= ch3_rxheader1(1 downto 0);
  ln3_rx_header1(1 downto 0) <= ch4_rxheader1(1 downto 0);
  ln2_rx_header1(1 downto 0) <= ch5_rxheader1(1 downto 0);
  ln1_rx_header1(1 downto 0) <= ch6_rxheader1(1 downto 0);
  ln0_rx_header1(1 downto 0) <= ch7_rxheader1(1 downto 0);
  ch7_rxgearboxslip1(0)      <= ln0_rx_slip1;
  ch6_rxgearboxslip1(0)      <= ln1_rx_slip1;
  ch5_rxgearboxslip1(0)      <= ln2_rx_slip1;
  ch4_rxgearboxslip1(0)      <= ln3_rx_slip1;
  ch3_rxgearboxslip1(0)      <= ln4_rx_slip1;
  ch2_rxgearboxslip1(0)      <= ln5_rx_slip1;
  ch1_rxgearboxslip1(0)      <= ln6_rx_slip1;
  ch0_rxgearboxslip1(0)      <= ln7_rx_slip1;
  ln7_rx_data1(63 downto 0)  <= hb0_gtwiz_userdata_rx1(63 downto 0);
  ln6_rx_data1(63 downto 0)  <= hb1_gtwiz_userdata_rx1(63 downto 0);
  ln5_rx_data1(63 downto 0)  <= hb2_gtwiz_userdata_rx1(63 downto 0);
  ln4_rx_data1(63 downto 0)  <= hb3_gtwiz_userdata_rx1(63 downto 0);
  ln3_rx_data1(63 downto 0)  <= hb4_gtwiz_userdata_rx1(63 downto 0);
  ln2_rx_data1(63 downto 0)  <= hb5_gtwiz_userdata_rx1(63 downto 0);
  ln1_rx_data1(63 downto 0)  <= hb6_gtwiz_userdata_rx1(63 downto 0);
  ln0_rx_data1(63 downto 0)  <= hb7_gtwiz_userdata_rx1(63 downto 0);
  ln7_rx_valid2              <= ch0_rxdatavalid2(0);
  ln6_rx_valid2              <= ch1_rxdatavalid2(0);
  ln5_rx_valid2              <= ch2_rxdatavalid2(0);
  ln4_rx_valid2              <= ch3_rxdatavalid2(0);
  ln3_rx_valid2              <= ch4_rxdatavalid2(0);
  ln2_rx_valid2              <= ch5_rxdatavalid2(0);
  ln1_rx_valid2              <= ch6_rxdatavalid2(0);
  ln0_rx_valid2              <= ch7_rxdatavalid2(0);
  ln7_rx_header2(1 downto 0) <= ch0_rxheader2(1 downto 0);
  ln6_rx_header2(1 downto 0) <= ch1_rxheader2(1 downto 0);
  ln5_rx_header2(1 downto 0) <= ch2_rxheader2(1 downto 0);
  ln4_rx_header2(1 downto 0) <= ch3_rxheader2(1 downto 0);
  ln3_rx_header2(1 downto 0) <= ch4_rxheader2(1 downto 0);
  ln2_rx_header2(1 downto 0) <= ch5_rxheader2(1 downto 0);
  ln1_rx_header2(1 downto 0) <= ch6_rxheader2(1 downto 0);
  ln0_rx_header2(1 downto 0) <= ch7_rxheader2(1 downto 0);
  ch7_rxgearboxslip2(0)      <= ln0_rx_slip2;
  ch6_rxgearboxslip2(0)      <= ln1_rx_slip2;
  ch5_rxgearboxslip2(0)      <= ln2_rx_slip2;
  ch4_rxgearboxslip2(0)      <= ln3_rx_slip2;
  ch3_rxgearboxslip2(0)      <= ln4_rx_slip2;
  ch2_rxgearboxslip2(0)      <= ln5_rx_slip2;
  ch1_rxgearboxslip2(0)      <= ln6_rx_slip2;
  ch0_rxgearboxslip2(0)      <= ln7_rx_slip2;
  ln7_rx_data2(63 downto 0)  <= hb0_gtwiz_userdata_rx2(63 downto 0);
  ln6_rx_data2(63 downto 0)  <= hb1_gtwiz_userdata_rx2(63 downto 0);
  ln5_rx_data2(63 downto 0)  <= hb2_gtwiz_userdata_rx2(63 downto 0);
  ln4_rx_data2(63 downto 0)  <= hb3_gtwiz_userdata_rx2(63 downto 0);
  ln3_rx_data2(63 downto 0)  <= hb4_gtwiz_userdata_rx2(63 downto 0);
  ln2_rx_data2(63 downto 0)  <= hb5_gtwiz_userdata_rx2(63 downto 0);
  ln1_rx_data2(63 downto 0)  <= hb6_gtwiz_userdata_rx2(63 downto 0);
  ln0_rx_data2(63 downto 0)  <= hb7_gtwiz_userdata_rx2(63 downto 0);
  ln7_rx_valid3              <= ch0_rxdatavalid3(0);
  ln6_rx_valid3              <= ch1_rxdatavalid3(0);
  ln5_rx_valid3              <= ch2_rxdatavalid3(0);
  ln4_rx_valid3              <= ch3_rxdatavalid3(0);
  ln3_rx_valid3              <= ch4_rxdatavalid3(0);
  ln2_rx_valid3              <= ch5_rxdatavalid3(0);
  ln1_rx_valid3              <= ch6_rxdatavalid3(0);
  ln0_rx_valid3              <= ch7_rxdatavalid3(0);
  ln7_rx_header3(1 downto 0) <= ch0_rxheader3(1 downto 0);
  ln6_rx_header3(1 downto 0) <= ch1_rxheader3(1 downto 0);
  ln5_rx_header3(1 downto 0) <= ch2_rxheader3(1 downto 0);
  ln4_rx_header3(1 downto 0) <= ch3_rxheader3(1 downto 0);
  ln3_rx_header3(1 downto 0) <= ch4_rxheader3(1 downto 0);
  ln2_rx_header3(1 downto 0) <= ch5_rxheader3(1 downto 0);
  ln1_rx_header3(1 downto 0) <= ch6_rxheader3(1 downto 0);
  ln0_rx_header3(1 downto 0) <= ch7_rxheader3(1 downto 0);
  ch7_rxgearboxslip3(0)      <= ln0_rx_slip3;
  ch6_rxgearboxslip3(0)      <= ln1_rx_slip3;
  ch5_rxgearboxslip3(0)      <= ln2_rx_slip3;
  ch4_rxgearboxslip3(0)      <= ln3_rx_slip3;
  ch3_rxgearboxslip3(0)      <= ln4_rx_slip3;
  ch2_rxgearboxslip3(0)      <= ln5_rx_slip3;
  ch1_rxgearboxslip3(0)      <= ln6_rx_slip3;
  ch0_rxgearboxslip3(0)      <= ln7_rx_slip3;
  ln7_rx_data3(63 downto 0)  <= hb0_gtwiz_userdata_rx3(63 downto 0);
  ln6_rx_data3(63 downto 0)  <= hb1_gtwiz_userdata_rx3(63 downto 0);
  ln5_rx_data3(63 downto 0)  <= hb2_gtwiz_userdata_rx3(63 downto 0);
  ln4_rx_data3(63 downto 0)  <= hb3_gtwiz_userdata_rx3(63 downto 0);
  ln3_rx_data3(63 downto 0)  <= hb4_gtwiz_userdata_rx3(63 downto 0);
  ln2_rx_data3(63 downto 0)  <= hb5_gtwiz_userdata_rx3(63 downto 0);
  ln1_rx_data3(63 downto 0)  <= hb6_gtwiz_userdata_rx3(63 downto 0);
  ln0_rx_data3(63 downto 0)  <= hb7_gtwiz_userdata_rx3(63 downto 0);

  ch0_txheader0(1 downto 0)           <= dlx_l7_tx_header0(1 downto 0);
  ch1_txheader0(1 downto 0)           <= dlx_l6_tx_header0(1 downto 0);
  ch2_txheader0(1 downto 0)           <= dlx_l5_tx_header0(1 downto 0);
  ch3_txheader0(1 downto 0)           <= dlx_l4_tx_header0(1 downto 0);
  ch4_txheader0(1 downto 0)           <= dlx_l3_tx_header0(1 downto 0);
  ch5_txheader0(1 downto 0)           <= dlx_l2_tx_header0(1 downto 0);
  ch6_txheader0(1 downto 0)           <= dlx_l1_tx_header0(1 downto 0);
  ch7_txheader0(1 downto 0)           <= dlx_l0_tx_header0(1 downto 0);
  ch0_txsequence0(5 downto 0)         <= dlx_l7_tx_seq0(5 downto 0);
  ch1_txsequence0(5 downto 0)         <= dlx_l6_tx_seq0(5 downto 0);
  ch2_txsequence0(5 downto 0)         <= dlx_l5_tx_seq0(5 downto 0);
  ch3_txsequence0(5 downto 0)         <= dlx_l4_tx_seq0(5 downto 0);
  ch4_txsequence0(5 downto 0)         <= dlx_l3_tx_seq0(5 downto 0);
  ch5_txsequence0(5 downto 0)         <= dlx_l2_tx_seq0(5 downto 0);
  ch6_txsequence0(5 downto 0)         <= dlx_l1_tx_seq0(5 downto 0);
  ch7_txsequence0(5 downto 0)         <= dlx_l0_tx_seq0(5 downto 0);
  hb0_gtwiz_userdata_tx0(63 downto 0) <= dlx_l7_tx_data0(63 downto 0);
  hb1_gtwiz_userdata_tx0(63 downto 0) <= dlx_l6_tx_data0(63 downto 0);
  hb2_gtwiz_userdata_tx0(63 downto 0) <= dlx_l5_tx_data0(63 downto 0);
  hb3_gtwiz_userdata_tx0(63 downto 0) <= dlx_l4_tx_data0(63 downto 0);
  hb4_gtwiz_userdata_tx0(63 downto 0) <= dlx_l3_tx_data0(63 downto 0);
  hb5_gtwiz_userdata_tx0(63 downto 0) <= dlx_l2_tx_data0(63 downto 0);
  hb6_gtwiz_userdata_tx0(63 downto 0) <= dlx_l1_tx_data0(63 downto 0);
  hb7_gtwiz_userdata_tx0(63 downto 0) <= dlx_l0_tx_data0(63 downto 0);
  ch0_txheader1(1 downto 0)           <= dlx_l7_tx_header1(1 downto 0);
  ch1_txheader1(1 downto 0)           <= dlx_l6_tx_header1(1 downto 0);
  ch2_txheader1(1 downto 0)           <= dlx_l5_tx_header1(1 downto 0);
  ch3_txheader1(1 downto 0)           <= dlx_l4_tx_header1(1 downto 0);
  ch4_txheader1(1 downto 0)           <= dlx_l3_tx_header1(1 downto 0);
  ch5_txheader1(1 downto 0)           <= dlx_l2_tx_header1(1 downto 0);
  ch6_txheader1(1 downto 0)           <= dlx_l1_tx_header1(1 downto 0);
  ch7_txheader1(1 downto 0)           <= dlx_l0_tx_header1(1 downto 0);
  ch0_txsequence1(5 downto 0)         <= dlx_l7_tx_seq1(5 downto 0);
  ch1_txsequence1(5 downto 0)         <= dlx_l6_tx_seq1(5 downto 0);
  ch2_txsequence1(5 downto 0)         <= dlx_l5_tx_seq1(5 downto 0);
  ch3_txsequence1(5 downto 0)         <= dlx_l4_tx_seq1(5 downto 0);
  ch4_txsequence1(5 downto 0)         <= dlx_l3_tx_seq1(5 downto 0);
  ch5_txsequence1(5 downto 0)         <= dlx_l2_tx_seq1(5 downto 0);
  ch6_txsequence1(5 downto 0)         <= dlx_l1_tx_seq1(5 downto 0);
  ch7_txsequence1(5 downto 0)         <= dlx_l0_tx_seq1(5 downto 0);
  hb0_gtwiz_userdata_tx1(63 downto 0) <= dlx_l7_tx_data1(63 downto 0);
  hb1_gtwiz_userdata_tx1(63 downto 0) <= dlx_l6_tx_data1(63 downto 0);
  hb2_gtwiz_userdata_tx1(63 downto 0) <= dlx_l5_tx_data1(63 downto 0);
  hb3_gtwiz_userdata_tx1(63 downto 0) <= dlx_l4_tx_data1(63 downto 0);
  hb4_gtwiz_userdata_tx1(63 downto 0) <= dlx_l3_tx_data1(63 downto 0);
  hb5_gtwiz_userdata_tx1(63 downto 0) <= dlx_l2_tx_data1(63 downto 0);
  hb6_gtwiz_userdata_tx1(63 downto 0) <= dlx_l1_tx_data1(63 downto 0);
  hb7_gtwiz_userdata_tx1(63 downto 0) <= dlx_l0_tx_data1(63 downto 0);
  ch0_txheader2(1 downto 0)           <= dlx_l7_tx_header2(1 downto 0);
  ch1_txheader2(1 downto 0)           <= dlx_l6_tx_header2(1 downto 0);
  ch2_txheader2(1 downto 0)           <= dlx_l5_tx_header2(1 downto 0);
  ch3_txheader2(1 downto 0)           <= dlx_l4_tx_header2(1 downto 0);
  ch4_txheader2(1 downto 0)           <= dlx_l3_tx_header2(1 downto 0);
  ch5_txheader2(1 downto 0)           <= dlx_l2_tx_header2(1 downto 0);
  ch6_txheader2(1 downto 0)           <= dlx_l1_tx_header2(1 downto 0);
  ch7_txheader2(1 downto 0)           <= dlx_l0_tx_header2(1 downto 0);
  ch0_txsequence2(5 downto 0)         <= dlx_l7_tx_seq2(5 downto 0);
  ch1_txsequence2(5 downto 0)         <= dlx_l6_tx_seq2(5 downto 0);
  ch2_txsequence2(5 downto 0)         <= dlx_l5_tx_seq2(5 downto 0);
  ch3_txsequence2(5 downto 0)         <= dlx_l4_tx_seq2(5 downto 0);
  ch4_txsequence2(5 downto 0)         <= dlx_l3_tx_seq2(5 downto 0);
  ch5_txsequence2(5 downto 0)         <= dlx_l2_tx_seq2(5 downto 0);
  ch6_txsequence2(5 downto 0)         <= dlx_l1_tx_seq2(5 downto 0);
  ch7_txsequence2(5 downto 0)         <= dlx_l0_tx_seq2(5 downto 0);
  hb0_gtwiz_userdata_tx2(63 downto 0) <= dlx_l7_tx_data2(63 downto 0);
  hb1_gtwiz_userdata_tx2(63 downto 0) <= dlx_l6_tx_data2(63 downto 0);
  hb2_gtwiz_userdata_tx2(63 downto 0) <= dlx_l5_tx_data2(63 downto 0);
  hb3_gtwiz_userdata_tx2(63 downto 0) <= dlx_l4_tx_data2(63 downto 0);
  hb4_gtwiz_userdata_tx2(63 downto 0) <= dlx_l3_tx_data2(63 downto 0);
  hb5_gtwiz_userdata_tx2(63 downto 0) <= dlx_l2_tx_data2(63 downto 0);
  hb6_gtwiz_userdata_tx2(63 downto 0) <= dlx_l1_tx_data2(63 downto 0);
  hb7_gtwiz_userdata_tx2(63 downto 0) <= dlx_l0_tx_data2(63 downto 0);
  ch0_txheader3(1 downto 0)           <= dlx_l7_tx_header3(1 downto 0);
  ch1_txheader3(1 downto 0)           <= dlx_l6_tx_header3(1 downto 0);
  ch2_txheader3(1 downto 0)           <= dlx_l5_tx_header3(1 downto 0);
  ch3_txheader3(1 downto 0)           <= dlx_l4_tx_header3(1 downto 0);
  ch4_txheader3(1 downto 0)           <= dlx_l3_tx_header3(1 downto 0);
  ch5_txheader3(1 downto 0)           <= dlx_l2_tx_header3(1 downto 0);
  ch6_txheader3(1 downto 0)           <= dlx_l1_tx_header3(1 downto 0);
  ch7_txheader3(1 downto 0)           <= dlx_l0_tx_header3(1 downto 0);
  ch0_txsequence3(5 downto 0)         <= dlx_l7_tx_seq3(5 downto 0);
  ch1_txsequence3(5 downto 0)         <= dlx_l6_tx_seq3(5 downto 0);
  ch2_txsequence3(5 downto 0)         <= dlx_l5_tx_seq3(5 downto 0);
  ch3_txsequence3(5 downto 0)         <= dlx_l4_tx_seq3(5 downto 0);
  ch4_txsequence3(5 downto 0)         <= dlx_l3_tx_seq3(5 downto 0);
  ch5_txsequence3(5 downto 0)         <= dlx_l2_tx_seq3(5 downto 0);
  ch6_txsequence3(5 downto 0)         <= dlx_l1_tx_seq3(5 downto 0);
  ch7_txsequence3(5 downto 0)         <= dlx_l0_tx_seq3(5 downto 0);
  hb0_gtwiz_userdata_tx3(63 downto 0) <= dlx_l7_tx_data3(63 downto 0);
  hb1_gtwiz_userdata_tx3(63 downto 0) <= dlx_l6_tx_data3(63 downto 0);
  hb2_gtwiz_userdata_tx3(63 downto 0) <= dlx_l5_tx_data3(63 downto 0);
  hb3_gtwiz_userdata_tx3(63 downto 0) <= dlx_l4_tx_data3(63 downto 0);
  hb4_gtwiz_userdata_tx3(63 downto 0) <= dlx_l3_tx_data3(63 downto 0);
  hb5_gtwiz_userdata_tx3(63 downto 0) <= dlx_l2_tx_data3(63 downto 0);
  hb6_gtwiz_userdata_tx3(63 downto 0) <= dlx_l1_tx_data3(63 downto 0);
  hb7_gtwiz_userdata_tx3(63 downto 0) <= dlx_l0_tx_data3(63 downto 0);

fire_core_0 : entity work.fire_core
port map (
    tsm_state2_to_3                => tsm_state2_to_3,
    tsm_state6_to_1              => tsm_state6_to_1_0,
    tsm_state4_to_5              => tsm_state4_to_5,
    tsm_state5_to_6              => tsm_state5_to_6,
    o_dlx_reset                  => dlx_reset0,
    cclk                          => cclk_a                       , -- MSR: fire_core(fire_core)
    cresetn                       => cresetn_a                    , -- MSR: fire_core(fire_core)
    c3s_dlx_axis_aclk             => c3s_dlx0_axis_aclk            , -- MSR: fire_core(fire_core)
    c3s_dlx_axis_i                => c3s_dlx0_axis_i               , -- MSR: fire_core(fire_core)
    c3s_dlx_axis_o                => c3s_dlx0_axis_o               , -- MSD: fire_core(fire_core)
    dlx_l0_tx_data (63 downto 0)  => dlx_l0_tx_data0 (63 downto 0) , -- MSD: fire_core(fire_core)
    dlx_l0_tx_header (1 downto 0) => dlx_l0_tx_header0 (1 downto 0), -- MSD: fire_core(fire_core)
    dlx_l0_tx_seq (5 downto 0)    => dlx_l0_tx_seq0 (5 downto 0)   , -- MSD: fire_core(fire_core)
    dlx_l1_tx_data (63 downto 0)  => dlx_l1_tx_data0 (63 downto 0) , -- MSD: fire_core(fire_core)
    dlx_l1_tx_header (1 downto 0) => dlx_l1_tx_header0 (1 downto 0), -- MSD: fire_core(fire_core)
    dlx_l1_tx_seq (5 downto 0)    => dlx_l1_tx_seq0 (5 downto 0)   , -- MSD: fire_core(fire_core)
    dlx_l2_tx_data (63 downto 0)  => dlx_l2_tx_data0 (63 downto 0) , -- MSD: fire_core(fire_core)
    dlx_l2_tx_header (1 downto 0) => dlx_l2_tx_header0 (1 downto 0), -- MSD: fire_core(fire_core)
    dlx_l2_tx_seq (5 downto 0)    => dlx_l2_tx_seq0 (5 downto 0)   , -- MSD: fire_core(fire_core)
    dlx_l3_tx_data (63 downto 0)  => dlx_l3_tx_data0 (63 downto 0) , -- MSD: fire_core(fire_core)
    dlx_l3_tx_header (1 downto 0) => dlx_l3_tx_header0 (1 downto 0), -- MSD: fire_core(fire_core)
    dlx_l3_tx_seq (5 downto 0)    => dlx_l3_tx_seq0 (5 downto 0)   , -- MSD: fire_core(fire_core)
    dlx_l4_tx_data (63 downto 0)  => dlx_l4_tx_data0 (63 downto 0) , -- MSD: fire_core(fire_core)
    dlx_l4_tx_header (1 downto 0) => dlx_l4_tx_header0 (1 downto 0), -- MSD: fire_core(fire_core)
    dlx_l4_tx_seq (5 downto 0)    => dlx_l4_tx_seq0 (5 downto 0)   , -- MSD: fire_core(fire_core)
    dlx_l5_tx_data (63 downto 0)  => dlx_l5_tx_data0 (63 downto 0) , -- MSD: fire_core(fire_core)
    dlx_l5_tx_header (1 downto 0) => dlx_l5_tx_header0 (1 downto 0), -- MSD: fire_core(fire_core)
    dlx_l5_tx_seq (5 downto 0)    => dlx_l5_tx_seq0 (5 downto 0)   , -- MSD: fire_core(fire_core)
    dlx_l6_tx_data (63 downto 0)  => dlx_l6_tx_data0 (63 downto 0) , -- MSD: fire_core(fire_core)
    dlx_l6_tx_header (1 downto 0) => dlx_l6_tx_header0 (1 downto 0), -- MSD: fire_core(fire_core)
    dlx_l6_tx_seq (5 downto 0)    => dlx_l6_tx_seq0 (5 downto 0)   , -- MSD: fire_core(fire_core)
    dlx_l7_tx_data (63 downto 0)  => dlx_l7_tx_data0 (63 downto 0) , -- MSD: fire_core(fire_core)
    dlx_l7_tx_header (1 downto 0) => dlx_l7_tx_header0 (1 downto 0), -- MSD: fire_core(fire_core)
    dlx_l7_tx_seq (5 downto 0)    => dlx_l7_tx_seq0 (5 downto 0)   , -- MSD: fire_core(fire_core)
    fbist_axis_aclk               => fbist0_axis_aclk              , -- MSR: fire_core(fire_core)
    fbist_axis_i                  => fbist0_axis_i                 , -- MSR: fire_core(fire_core)
    fbist_axis_o                  => fbist0_axis_o                 , -- MSD: fire_core(fire_core)
    gtwiz_buffbypass_rx_done_in   => gtwiz_buffbypass_rx_done_in0  , -- MSR: fire_core(fire_core)
    gtwiz_buffbypass_tx_done_in   => gtwiz_buffbypass_tx_done_in0  , -- MSR: fire_core(fire_core)
    gtwiz_reset_all_out           => gtwiz_reset_all_out0          , -- MSD: fire_core(fire_core)
    gtwiz_reset_rx_datapath_out   => gtwiz_reset_rx_datapath_out0  , -- MSD: fire_core(fire_core)
    gtwiz_reset_rx_done_in        => gtwiz_reset_rx_done_in0       , -- MSR: fire_core(fire_core)
    gtwiz_reset_tx_done_in        => gtwiz_reset_tx_done_in0       , -- MSR: fire_core(fire_core)
    gtwiz_userclk_rx_active_in    => gtwiz_userclk_rx_active_in0   , -- MSR: fire_core(fire_core)
    gtwiz_userclk_tx_active_in    => gtwiz_userclk_tx_active_in0   , -- MSR: fire_core(fire_core)
    hb_gtwiz_reset_all_in         => hb_gtwiz_reset_all_in0        , -- MSR: fire_core(fire_core)
    ln0_rx_data (63 downto 0)     => ln0_rx_data0 (63 downto 0)    , -- MSR: fire_core(fire_core)
    ln0_rx_header (1 downto 0)    => ln0_rx_header0 (1 downto 0)   , -- MSR: fire_core(fire_core)
    ln0_rx_slip                   => ln0_rx_slip0                  , -- MSD: fire_core(fire_core)
    ln0_rx_valid                  => ln0_rx_valid0                 , -- MSR: fire_core(fire_core)
    ln1_rx_data (63 downto 0)     => ln1_rx_data0 (63 downto 0)    , -- MSR: fire_core(fire_core)
    ln1_rx_header (1 downto 0)    => ln1_rx_header0 (1 downto 0)   , -- MSR: fire_core(fire_core)
    ln1_rx_slip                   => ln1_rx_slip0                  , -- MSD: fire_core(fire_core)
    ln1_rx_valid                  => ln1_rx_valid0                 , -- MSR: fire_core(fire_core)
    ln2_rx_data (63 downto 0)     => ln2_rx_data0 (63 downto 0)    , -- MSR: fire_core(fire_core)
    ln2_rx_header (1 downto 0)    => ln2_rx_header0 (1 downto 0)   , -- MSR: fire_core(fire_core)
    ln2_rx_slip                   => ln2_rx_slip0                  , -- MSD: fire_core(fire_core)
    ln2_rx_valid                  => ln2_rx_valid0                 , -- MSR: fire_core(fire_core)
    ln3_rx_data (63 downto 0)     => ln3_rx_data0 (63 downto 0)    , -- MSR: fire_core(fire_core)
    ln3_rx_header (1 downto 0)    => ln3_rx_header0 (1 downto 0)   , -- MSR: fire_core(fire_core)
    ln3_rx_slip                   => ln3_rx_slip0                  , -- MSD: fire_core(fire_core)
    ln3_rx_valid                  => ln3_rx_valid0                 , -- MSR: fire_core(fire_core)
    ln4_rx_data (63 downto 0)     => ln4_rx_data0 (63 downto 0)    , -- MSR: fire_core(fire_core)
    ln4_rx_header (1 downto 0)    => ln4_rx_header0 (1 downto 0)   , -- MSR: fire_core(fire_core)
    ln4_rx_slip                   => ln4_rx_slip0                  , -- MSD: fire_core(fire_core)
    ln4_rx_valid                  => ln4_rx_valid0                 , -- MSR: fire_core(fire_core)
    ln5_rx_data (63 downto 0)     => ln5_rx_data0 (63 downto 0)    , -- MSR: fire_core(fire_core)
    ln5_rx_header (1 downto 0)    => ln5_rx_header0 (1 downto 0)   , -- MSR: fire_core(fire_core)
    ln5_rx_slip                   => ln5_rx_slip0                  , -- MSD: fire_core(fire_core)
    ln5_rx_valid                  => ln5_rx_valid0                 , -- MSR: fire_core(fire_core)
    ln6_rx_data (63 downto 0)     => ln6_rx_data0 (63 downto 0)    , -- MSR: fire_core(fire_core)
    ln6_rx_header (1 downto 0)    => ln6_rx_header0 (1 downto 0)   , -- MSR: fire_core(fire_core)
    ln6_rx_slip                   => ln6_rx_slip0                  , -- MSD: fire_core(fire_core)
    ln6_rx_valid                  => ln6_rx_valid0                 , -- MSR: fire_core(fire_core)
    ln7_rx_data (63 downto 0)     => ln7_rx_data0 (63 downto 0)    , -- MSR: fire_core(fire_core)
    ln7_rx_header (1 downto 0)    => ln7_rx_header0 (1 downto 0)   , -- MSR: fire_core(fire_core)
    ln7_rx_slip                   => ln7_rx_slip0                  , -- MSD: fire_core(fire_core)
    ln7_rx_valid                  => ln7_rx_valid0                 , -- MSR: fire_core(fire_core)
    oc_host_cfg0_axis_aclk        => oc_host_cfg0_axis_aclk       , -- MSR: fire_core(fire_core)
    oc_host_cfg0_axis_i           => oc_host_cfg0_axis_i          , -- MSR: fire_core(fire_core)
    oc_host_cfg0_axis_o           => oc_host_cfg0_axis_o          , -- MSD: fire_core(fire_core)
    oc_memory0_axis_aclk          => oc_memory0_axis_aclk         , -- MSR: fire_core(fire_core)
    oc_memory0_axis_i             => oc_memory0_axis_i            , -- MSR: fire_core(fire_core)
    oc_memory0_axis_o             => oc_memory0_axis_o            , -- MSD: fire_core(fire_core)
    oc_mmio0_axis_aclk            => oc_mmio0_axis_aclk           , -- MSR: fire_core(fire_core)
    oc_mmio0_axis_i               => oc_mmio0_axis_i              , -- MSR: fire_core(fire_core)
    oc_mmio0_axis_o               => oc_mmio0_axis_o              , -- MSD: fire_core(fire_core)
    oc_cfg0_axis_aclk             => oc_cfg0_axis_aclk            , -- MSR: fire_core(fire_core)
    oc_cfg0_axis_i                => oc_cfg0_axis_i               , -- MSR: fire_core(fire_core)
    oc_cfg0_axis_o                => oc_cfg0_axis_o               , -- MSD: fire_core(fire_core)
    ocde                          => ocde_int                         , -- MSR: fire_core(fire_core)
    lane_force_unlock             => std_ulogic_vector(lane_force_unlock)            ,
    rclk                          => rclk                         , -- MSR: fire_core(fire_core)
    sys_resetn                    => sys_resetn               , -- MSR: fire_core(fire_core)
    sysclk                        => sysclk                         -- MSR: fire_core(fire_core)
);

fire_core_1 : entity work.fire_core
port map (
    tsm_state2_to_3                => tsm_state2_to_3,
    tsm_state6_to_1              => tsm_state6_to_1_1,
    tsm_state4_to_5              => tsm_state4_to_5,
    tsm_state5_to_6              => tsm_state5_to_6,
    o_dlx_reset                  => dlx_reset1,
    cclk                          => cclk_b                       , -- MSR: fire_core(fire_core)
    cresetn                       => cresetn_b                    , -- MSR: fire_core(fire_core)
    c3s_dlx_axis_aclk             => c3s_dlx1_axis_aclk            , -- MSR: fire_core(fire_core)
    c3s_dlx_axis_i                => c3s_dlx1_axis_i               , -- MSR: fire_core(fire_core)
    c3s_dlx_axis_o                => c3s_dlx1_axis_o               , -- MSD: fire_core(fire_core)
    dlx_l0_tx_data (63 downto 0)  => dlx_l0_tx_data1 (63 downto 0) , -- MSD: fire_core(fire_core)
    dlx_l0_tx_header (1 downto 0) => dlx_l0_tx_header1 (1 downto 0), -- MSD: fire_core(fire_core)
    dlx_l0_tx_seq (5 downto 0)    => dlx_l0_tx_seq1 (5 downto 0)   , -- MSD: fire_core(fire_core)
    dlx_l1_tx_data (63 downto 0)  => dlx_l1_tx_data1 (63 downto 0) , -- MSD: fire_core(fire_core)
    dlx_l1_tx_header (1 downto 0) => dlx_l1_tx_header1 (1 downto 0), -- MSD: fire_core(fire_core)
    dlx_l1_tx_seq (5 downto 0)    => dlx_l1_tx_seq1 (5 downto 0)   , -- MSD: fire_core(fire_core)
    dlx_l2_tx_data (63 downto 0)  => dlx_l2_tx_data1 (63 downto 0) , -- MSD: fire_core(fire_core)
    dlx_l2_tx_header (1 downto 0) => dlx_l2_tx_header1 (1 downto 0), -- MSD: fire_core(fire_core)
    dlx_l2_tx_seq (5 downto 0)    => dlx_l2_tx_seq1 (5 downto 0)   , -- MSD: fire_core(fire_core)
    dlx_l3_tx_data (63 downto 0)  => dlx_l3_tx_data1 (63 downto 0) , -- MSD: fire_core(fire_core)
    dlx_l3_tx_header (1 downto 0) => dlx_l3_tx_header1 (1 downto 0), -- MSD: fire_core(fire_core)
    dlx_l3_tx_seq (5 downto 0)    => dlx_l3_tx_seq1 (5 downto 0)   , -- MSD: fire_core(fire_core)
    dlx_l4_tx_data (63 downto 0)  => dlx_l4_tx_data1 (63 downto 0) , -- MSD: fire_core(fire_core)
    dlx_l4_tx_header (1 downto 0) => dlx_l4_tx_header1 (1 downto 0), -- MSD: fire_core(fire_core)
    dlx_l4_tx_seq (5 downto 0)    => dlx_l4_tx_seq1 (5 downto 0)   , -- MSD: fire_core(fire_core)
    dlx_l5_tx_data (63 downto 0)  => dlx_l5_tx_data1 (63 downto 0) , -- MSD: fire_core(fire_core)
    dlx_l5_tx_header (1 downto 0) => dlx_l5_tx_header1 (1 downto 0), -- MSD: fire_core(fire_core)
    dlx_l5_tx_seq (5 downto 0)    => dlx_l5_tx_seq1 (5 downto 0)   , -- MSD: fire_core(fire_core)
    dlx_l6_tx_data (63 downto 0)  => dlx_l6_tx_data1 (63 downto 0) , -- MSD: fire_core(fire_core)
    dlx_l6_tx_header (1 downto 0) => dlx_l6_tx_header1 (1 downto 0), -- MSD: fire_core(fire_core)
    dlx_l6_tx_seq (5 downto 0)    => dlx_l6_tx_seq1 (5 downto 0)   , -- MSD: fire_core(fire_core)
    dlx_l7_tx_data (63 downto 0)  => dlx_l7_tx_data1 (63 downto 0) , -- MSD: fire_core(fire_core)
    dlx_l7_tx_header (1 downto 0) => dlx_l7_tx_header1 (1 downto 0), -- MSD: fire_core(fire_core)
    dlx_l7_tx_seq (5 downto 0)    => dlx_l7_tx_seq1 (5 downto 0)   , -- MSD: fire_core(fire_core)
    fbist_axis_aclk               => fbist1_axis_aclk              , -- MSR: fire_core(fire_core)
    fbist_axis_i                  => fbist1_axis_i                 , -- MSR: fire_core(fire_core)
    fbist_axis_o                  => fbist1_axis_o                 , -- MSD: fire_core(fire_core)
    gtwiz_buffbypass_rx_done_in   => gtwiz_buffbypass_rx_done_in1  , -- MSR: fire_core(fire_core)
    gtwiz_buffbypass_tx_done_in   => gtwiz_buffbypass_tx_done_in1  , -- MSR: fire_core(fire_core)
    gtwiz_reset_all_out           => gtwiz_reset_all_out1          , -- MSD: fire_core(fire_core)
    gtwiz_reset_rx_datapath_out   => gtwiz_reset_rx_datapath_out1  , -- MSD: fire_core(fire_core)
    gtwiz_reset_rx_done_in        => gtwiz_reset_rx_done_in1       , -- MSR: fire_core(fire_core)
    gtwiz_reset_tx_done_in        => gtwiz_reset_tx_done_in1       , -- MSR: fire_core(fire_core)
    gtwiz_userclk_rx_active_in    => gtwiz_userclk_rx_active_in1   , -- MSR: fire_core(fire_core)
    gtwiz_userclk_tx_active_in    => gtwiz_userclk_tx_active_in1   , -- MSR: fire_core(fire_core)
    hb_gtwiz_reset_all_in         => hb_gtwiz_reset_all_in1        , -- MSR: fire_core(fire_core)
    ln0_rx_data (63 downto 0)     => ln0_rx_data1 (63 downto 0)    , -- MSR: fire_core(fire_core)
    ln0_rx_header (1 downto 0)    => ln0_rx_header1 (1 downto 0)   , -- MSR: fire_core(fire_core)
    ln0_rx_slip                   => ln0_rx_slip1                  , -- MSD: fire_core(fire_core)
    ln0_rx_valid                  => ln0_rx_valid1                 , -- MSR: fire_core(fire_core)
    ln1_rx_data (63 downto 0)     => ln1_rx_data1 (63 downto 0)    , -- MSR: fire_core(fire_core)
    ln1_rx_header (1 downto 0)    => ln1_rx_header1 (1 downto 0)   , -- MSR: fire_core(fire_core)
    ln1_rx_slip                   => ln1_rx_slip1                  , -- MSD: fire_core(fire_core)
    ln1_rx_valid                  => ln1_rx_valid1                 , -- MSR: fire_core(fire_core)
    ln2_rx_data (63 downto 0)     => ln2_rx_data1 (63 downto 0)    , -- MSR: fire_core(fire_core)
    ln2_rx_header (1 downto 0)    => ln2_rx_header1 (1 downto 0)   , -- MSR: fire_core(fire_core)
    ln2_rx_slip                   => ln2_rx_slip1                  , -- MSD: fire_core(fire_core)
    ln2_rx_valid                  => ln2_rx_valid1                 , -- MSR: fire_core(fire_core)
    ln3_rx_data (63 downto 0)     => ln3_rx_data1 (63 downto 0)    , -- MSR: fire_core(fire_core)
    ln3_rx_header (1 downto 0)    => ln3_rx_header1 (1 downto 0)   , -- MSR: fire_core(fire_core)
    ln3_rx_slip                   => ln3_rx_slip1                  , -- MSD: fire_core(fire_core)
    ln3_rx_valid                  => ln3_rx_valid1                 , -- MSR: fire_core(fire_core)
    ln4_rx_data (63 downto 0)     => ln4_rx_data1 (63 downto 0)    , -- MSR: fire_core(fire_core)
    ln4_rx_header (1 downto 0)    => ln4_rx_header1 (1 downto 0)   , -- MSR: fire_core(fire_core)
    ln4_rx_slip                   => ln4_rx_slip1                  , -- MSD: fire_core(fire_core)
    ln4_rx_valid                  => ln4_rx_valid1                 , -- MSR: fire_core(fire_core)
    ln5_rx_data (63 downto 0)     => ln5_rx_data1 (63 downto 0)    , -- MSR: fire_core(fire_core)
    ln5_rx_header (1 downto 0)    => ln5_rx_header1 (1 downto 0)   , -- MSR: fire_core(fire_core)
    ln5_rx_slip                   => ln5_rx_slip1                  , -- MSD: fire_core(fire_core)
    ln5_rx_valid                  => ln5_rx_valid1                 , -- MSR: fire_core(fire_core)
    ln6_rx_data (63 downto 0)     => ln6_rx_data1 (63 downto 0)    , -- MSR: fire_core(fire_core)
    ln6_rx_header (1 downto 0)    => ln6_rx_header1 (1 downto 0)   , -- MSR: fire_core(fire_core)
    ln6_rx_slip                   => ln6_rx_slip1                  , -- MSD: fire_core(fire_core)
    ln6_rx_valid                  => ln6_rx_valid1                 , -- MSR: fire_core(fire_core)
    ln7_rx_data (63 downto 0)     => ln7_rx_data1 (63 downto 0)    , -- MSR: fire_core(fire_core)
    ln7_rx_header (1 downto 0)    => ln7_rx_header1 (1 downto 0)   , -- MSR: fire_core(fire_core)
    ln7_rx_slip                   => ln7_rx_slip1                  , -- MSD: fire_core(fire_core)
    ln7_rx_valid                  => ln7_rx_valid1                 , -- MSR: fire_core(fire_core)
    oc_host_cfg0_axis_aclk        => oc_host_cfg1_axis_aclk       , -- MSR: fire_core(fire_core)
    oc_host_cfg0_axis_i           => oc_host_cfg1_axis_i          , -- MSR: fire_core(fire_core)
    oc_host_cfg0_axis_o           => oc_host_cfg1_axis_o          , -- MSD: fire_core(fire_core)
    oc_memory0_axis_aclk          => oc_memory1_axis_aclk         , -- MSR: fire_core(fire_core)
    oc_memory0_axis_i             => oc_memory1_axis_i            , -- MSR: fire_core(fire_core)
    oc_memory0_axis_o             => oc_memory1_axis_o            , -- MSD: fire_core(fire_core)
    oc_mmio0_axis_aclk            => oc_mmio1_axis_aclk           , -- MSR: fire_core(fire_core)
    oc_mmio0_axis_i               => oc_mmio1_axis_i              , -- MSR: fire_core(fire_core)
    oc_mmio0_axis_o               => oc_mmio1_axis_o              , -- MSD: fire_core(fire_core)
    oc_cfg0_axis_aclk             => oc_cfg1_axis_aclk            , -- MSR: fire_core(fire_core)
    oc_cfg0_axis_i                => oc_cfg1_axis_i               , -- MSR: fire_core(fire_core)
    oc_cfg0_axis_o                => oc_cfg1_axis_o               , -- MSD: fire_core(fire_core)
    ocde                          => ocde_int                         , -- MSR: fire_core(fire_core)
    lane_force_unlock             => std_ulogic_vector(lane_force_unlock)            ,
    rclk                          => rclk                         , -- MSR: fire_core(fire_core)
    sys_resetn                    => sys_resetn               , -- MSR: fire_core(fire_core)
    sysclk                        => sysclk                         -- MSR: fire_core(fire_core)
);

fire_core_2 : entity work.fire_core
port map (
    tsm_state2_to_3                => tsm_state2_to_3,
    tsm_state6_to_1              => tsm_state6_to_1_2,
    tsm_state4_to_5              => tsm_state4_to_5,
    tsm_state5_to_6              => tsm_state5_to_6,
    o_dlx_reset                  => dlx_reset2,
    cclk                          => cclk_c                       , -- MSR: fire_core(fire_core)
    cresetn                       => cresetn_c                    , -- MSR: fire_core(fire_core)
    c3s_dlx_axis_aclk             => c3s_dlx2_axis_aclk            , -- MSR: fire_core(fire_core)
    c3s_dlx_axis_i                => c3s_dlx2_axis_i               , -- MSR: fire_core(fire_core)
    c3s_dlx_axis_o                => c3s_dlx2_axis_o               , -- MSD: fire_core(fire_core)
    dlx_l0_tx_data (63 downto 0)  => dlx_l0_tx_data2 (63 downto 0) , -- MSD: fire_core(fire_core)
    dlx_l0_tx_header (1 downto 0) => dlx_l0_tx_header2 (1 downto 0), -- MSD: fire_core(fire_core)
    dlx_l0_tx_seq (5 downto 0)    => dlx_l0_tx_seq2 (5 downto 0)   , -- MSD: fire_core(fire_core)
    dlx_l1_tx_data (63 downto 0)  => dlx_l1_tx_data2 (63 downto 0) , -- MSD: fire_core(fire_core)
    dlx_l1_tx_header (1 downto 0) => dlx_l1_tx_header2 (1 downto 0), -- MSD: fire_core(fire_core)
    dlx_l1_tx_seq (5 downto 0)    => dlx_l1_tx_seq2 (5 downto 0)   , -- MSD: fire_core(fire_core)
    dlx_l2_tx_data (63 downto 0)  => dlx_l2_tx_data2 (63 downto 0) , -- MSD: fire_core(fire_core)
    dlx_l2_tx_header (1 downto 0) => dlx_l2_tx_header2 (1 downto 0), -- MSD: fire_core(fire_core)
    dlx_l2_tx_seq (5 downto 0)    => dlx_l2_tx_seq2 (5 downto 0)   , -- MSD: fire_core(fire_core)
    dlx_l3_tx_data (63 downto 0)  => dlx_l3_tx_data2 (63 downto 0) , -- MSD: fire_core(fire_core)
    dlx_l3_tx_header (1 downto 0) => dlx_l3_tx_header2 (1 downto 0), -- MSD: fire_core(fire_core)
    dlx_l3_tx_seq (5 downto 0)    => dlx_l3_tx_seq2 (5 downto 0)   , -- MSD: fire_core(fire_core)
    dlx_l4_tx_data (63 downto 0)  => dlx_l4_tx_data2 (63 downto 0) , -- MSD: fire_core(fire_core)
    dlx_l4_tx_header (1 downto 0) => dlx_l4_tx_header2 (1 downto 0), -- MSD: fire_core(fire_core)
    dlx_l4_tx_seq (5 downto 0)    => dlx_l4_tx_seq2 (5 downto 0)   , -- MSD: fire_core(fire_core)
    dlx_l5_tx_data (63 downto 0)  => dlx_l5_tx_data2 (63 downto 0) , -- MSD: fire_core(fire_core)
    dlx_l5_tx_header (1 downto 0) => dlx_l5_tx_header2 (1 downto 0), -- MSD: fire_core(fire_core)
    dlx_l5_tx_seq (5 downto 0)    => dlx_l5_tx_seq2 (5 downto 0)   , -- MSD: fire_core(fire_core)
    dlx_l6_tx_data (63 downto 0)  => dlx_l6_tx_data2 (63 downto 0) , -- MSD: fire_core(fire_core)
    dlx_l6_tx_header (1 downto 0) => dlx_l6_tx_header2 (1 downto 0), -- MSD: fire_core(fire_core)
    dlx_l6_tx_seq (5 downto 0)    => dlx_l6_tx_seq2 (5 downto 0)   , -- MSD: fire_core(fire_core)
    dlx_l7_tx_data (63 downto 0)  => dlx_l7_tx_data2 (63 downto 0) , -- MSD: fire_core(fire_core)
    dlx_l7_tx_header (1 downto 0) => dlx_l7_tx_header2 (1 downto 0), -- MSD: fire_core(fire_core)
    dlx_l7_tx_seq (5 downto 0)    => dlx_l7_tx_seq2 (5 downto 0)   , -- MSD: fire_core(fire_core)
    fbist_axis_aclk               => fbist2_axis_aclk              , -- MSR: fire_core(fire_core)
    fbist_axis_i                  => fbist2_axis_i                 , -- MSR: fire_core(fire_core)
    fbist_axis_o                  => fbist2_axis_o                 , -- MSD: fire_core(fire_core)
    gtwiz_buffbypass_rx_done_in   => gtwiz_buffbypass_rx_done_in2  , -- MSR: fire_core(fire_core)
    gtwiz_buffbypass_tx_done_in   => gtwiz_buffbypass_tx_done_in2  , -- MSR: fire_core(fire_core)
    gtwiz_reset_all_out           => gtwiz_reset_all_out2          , -- MSD: fire_core(fire_core)
    gtwiz_reset_rx_datapath_out   => gtwiz_reset_rx_datapath_out2  , -- MSD: fire_core(fire_core)
    gtwiz_reset_rx_done_in        => gtwiz_reset_rx_done_in2       , -- MSR: fire_core(fire_core)
    gtwiz_reset_tx_done_in        => gtwiz_reset_tx_done_in2       , -- MSR: fire_core(fire_core)
    gtwiz_userclk_rx_active_in    => gtwiz_userclk_rx_active_in2   , -- MSR: fire_core(fire_core)
    gtwiz_userclk_tx_active_in    => gtwiz_userclk_tx_active_in2   , -- MSR: fire_core(fire_core)
    hb_gtwiz_reset_all_in         => hb_gtwiz_reset_all_in2        , -- MSR: fire_core(fire_core)
    ln0_rx_data (63 downto 0)     => ln0_rx_data2 (63 downto 0)    , -- MSR: fire_core(fire_core)
    ln0_rx_header (1 downto 0)    => ln0_rx_header2 (1 downto 0)   , -- MSR: fire_core(fire_core)
    ln0_rx_slip                   => ln0_rx_slip2                  , -- MSD: fire_core(fire_core)
    ln0_rx_valid                  => ln0_rx_valid2                 , -- MSR: fire_core(fire_core)
    ln1_rx_data (63 downto 0)     => ln1_rx_data2 (63 downto 0)    , -- MSR: fire_core(fire_core)
    ln1_rx_header (1 downto 0)    => ln1_rx_header2 (1 downto 0)   , -- MSR: fire_core(fire_core)
    ln1_rx_slip                   => ln1_rx_slip2                  , -- MSD: fire_core(fire_core)
    ln1_rx_valid                  => ln1_rx_valid2                 , -- MSR: fire_core(fire_core)
    ln2_rx_data (63 downto 0)     => ln2_rx_data2 (63 downto 0)    , -- MSR: fire_core(fire_core)
    ln2_rx_header (1 downto 0)    => ln2_rx_header2 (1 downto 0)   , -- MSR: fire_core(fire_core)
    ln2_rx_slip                   => ln2_rx_slip2                  , -- MSD: fire_core(fire_core)
    ln2_rx_valid                  => ln2_rx_valid2                 , -- MSR: fire_core(fire_core)
    ln3_rx_data (63 downto 0)     => ln3_rx_data2 (63 downto 0)    , -- MSR: fire_core(fire_core)
    ln3_rx_header (1 downto 0)    => ln3_rx_header2 (1 downto 0)   , -- MSR: fire_core(fire_core)
    ln3_rx_slip                   => ln3_rx_slip2                  , -- MSD: fire_core(fire_core)
    ln3_rx_valid                  => ln3_rx_valid2                 , -- MSR: fire_core(fire_core)
    ln4_rx_data (63 downto 0)     => ln4_rx_data2 (63 downto 0)    , -- MSR: fire_core(fire_core)
    ln4_rx_header (1 downto 0)    => ln4_rx_header2 (1 downto 0)   , -- MSR: fire_core(fire_core)
    ln4_rx_slip                   => ln4_rx_slip2                  , -- MSD: fire_core(fire_core)
    ln4_rx_valid                  => ln4_rx_valid2                 , -- MSR: fire_core(fire_core)
    ln5_rx_data (63 downto 0)     => ln5_rx_data2 (63 downto 0)    , -- MSR: fire_core(fire_core)
    ln5_rx_header (1 downto 0)    => ln5_rx_header2 (1 downto 0)   , -- MSR: fire_core(fire_core)
    ln5_rx_slip                   => ln5_rx_slip2                  , -- MSD: fire_core(fire_core)
    ln5_rx_valid                  => ln5_rx_valid2                 , -- MSR: fire_core(fire_core)
    ln6_rx_data (63 downto 0)     => ln6_rx_data2 (63 downto 0)    , -- MSR: fire_core(fire_core)
    ln6_rx_header (1 downto 0)    => ln6_rx_header2 (1 downto 0)   , -- MSR: fire_core(fire_core)
    ln6_rx_slip                   => ln6_rx_slip2                  , -- MSD: fire_core(fire_core)
    ln6_rx_valid                  => ln6_rx_valid2                 , -- MSR: fire_core(fire_core)
    ln7_rx_data (63 downto 0)     => ln7_rx_data2 (63 downto 0)    , -- MSR: fire_core(fire_core)
    ln7_rx_header (1 downto 0)    => ln7_rx_header2 (1 downto 0)   , -- MSR: fire_core(fire_core)
    ln7_rx_slip                   => ln7_rx_slip2                  , -- MSD: fire_core(fire_core)
    ln7_rx_valid                  => ln7_rx_valid2                 , -- MSR: fire_core(fire_core)
    oc_host_cfg0_axis_aclk        => oc_host_cfg2_axis_aclk       , -- MSR: fire_core(fire_core)
    oc_host_cfg0_axis_i           => oc_host_cfg2_axis_i          , -- MSR: fire_core(fire_core)
    oc_host_cfg0_axis_o           => oc_host_cfg2_axis_o          , -- MSD: fire_core(fire_core)
    oc_memory0_axis_aclk          => oc_memory2_axis_aclk         , -- MSR: fire_core(fire_core)
    oc_memory0_axis_i             => oc_memory2_axis_i            , -- MSR: fire_core(fire_core)
    oc_memory0_axis_o             => oc_memory2_axis_o            , -- MSD: fire_core(fire_core)
    oc_mmio0_axis_aclk            => oc_mmio2_axis_aclk           , -- MSR: fire_core(fire_core)
    oc_mmio0_axis_i               => oc_mmio2_axis_i              , -- MSR: fire_core(fire_core)
    oc_mmio0_axis_o               => oc_mmio2_axis_o              , -- MSD: fire_core(fire_core)
    oc_cfg0_axis_aclk             => oc_cfg2_axis_aclk            , -- MSR: fire_core(fire_core)
    oc_cfg0_axis_i                => oc_cfg2_axis_i               , -- MSR: fire_core(fire_core)
    oc_cfg0_axis_o                => oc_cfg2_axis_o               , -- MSD: fire_core(fire_core)
    ocde                          => ocde_int                         , -- MSR: fire_core(fire_core)
    lane_force_unlock             => std_ulogic_vector(lane_force_unlock)            ,
    rclk                          => rclk                         , -- MSR: fire_core(fire_core)
    sys_resetn                    => sys_resetn               , -- MSR: fire_core(fire_core)
    sysclk                        => sysclk                         -- MSR: fire_core(fire_core)
);

fire_core_3 : entity work.fire_core
port map (
    tsm_state2_to_3                => tsm_state2_to_3,
    tsm_state6_to_1              => tsm_state6_to_1_3,
    tsm_state4_to_5              => tsm_state4_to_5,
    tsm_state5_to_6              => tsm_state5_to_6,
    o_dlx_reset                  => dlx_reset3,
    cclk                          => cclk_d                       , -- MSR: fire_core(fire_core)
    cresetn                       => cresetn_d                    , -- MSR: fire_core(fire_core)
    c3s_dlx_axis_aclk             => c3s_dlx3_axis_aclk            , -- MSR: fire_core(fire_core)
    c3s_dlx_axis_i                => c3s_dlx3_axis_i               , -- MSR: fire_core(fire_core)
    c3s_dlx_axis_o                => c3s_dlx3_axis_o               , -- MSD: fire_core(fire_core)
    dlx_l0_tx_data (63 downto 0)  => dlx_l0_tx_data3 (63 downto 0) , -- MSD: fire_core(fire_core)
    dlx_l0_tx_header (1 downto 0) => dlx_l0_tx_header3 (1 downto 0), -- MSD: fire_core(fire_core)
    dlx_l0_tx_seq (5 downto 0)    => dlx_l0_tx_seq3 (5 downto 0)   , -- MSD: fire_core(fire_core)
    dlx_l1_tx_data (63 downto 0)  => dlx_l1_tx_data3 (63 downto 0) , -- MSD: fire_core(fire_core)
    dlx_l1_tx_header (1 downto 0) => dlx_l1_tx_header3 (1 downto 0), -- MSD: fire_core(fire_core)
    dlx_l1_tx_seq (5 downto 0)    => dlx_l1_tx_seq3 (5 downto 0)   , -- MSD: fire_core(fire_core)
    dlx_l2_tx_data (63 downto 0)  => dlx_l2_tx_data3 (63 downto 0) , -- MSD: fire_core(fire_core)
    dlx_l2_tx_header (1 downto 0) => dlx_l2_tx_header3 (1 downto 0), -- MSD: fire_core(fire_core)
    dlx_l2_tx_seq (5 downto 0)    => dlx_l2_tx_seq3 (5 downto 0)   , -- MSD: fire_core(fire_core)
    dlx_l3_tx_data (63 downto 0)  => dlx_l3_tx_data3 (63 downto 0) , -- MSD: fire_core(fire_core)
    dlx_l3_tx_header (1 downto 0) => dlx_l3_tx_header3 (1 downto 0), -- MSD: fire_core(fire_core)
    dlx_l3_tx_seq (5 downto 0)    => dlx_l3_tx_seq3 (5 downto 0)   , -- MSD: fire_core(fire_core)
    dlx_l4_tx_data (63 downto 0)  => dlx_l4_tx_data3 (63 downto 0) , -- MSD: fire_core(fire_core)
    dlx_l4_tx_header (1 downto 0) => dlx_l4_tx_header3 (1 downto 0), -- MSD: fire_core(fire_core)
    dlx_l4_tx_seq (5 downto 0)    => dlx_l4_tx_seq3 (5 downto 0)   , -- MSD: fire_core(fire_core)
    dlx_l5_tx_data (63 downto 0)  => dlx_l5_tx_data3 (63 downto 0) , -- MSD: fire_core(fire_core)
    dlx_l5_tx_header (1 downto 0) => dlx_l5_tx_header3 (1 downto 0), -- MSD: fire_core(fire_core)
    dlx_l5_tx_seq (5 downto 0)    => dlx_l5_tx_seq3 (5 downto 0)   , -- MSD: fire_core(fire_core)
    dlx_l6_tx_data (63 downto 0)  => dlx_l6_tx_data3 (63 downto 0) , -- MSD: fire_core(fire_core)
    dlx_l6_tx_header (1 downto 0) => dlx_l6_tx_header3 (1 downto 0), -- MSD: fire_core(fire_core)
    dlx_l6_tx_seq (5 downto 0)    => dlx_l6_tx_seq3 (5 downto 0)   , -- MSD: fire_core(fire_core)
    dlx_l7_tx_data (63 downto 0)  => dlx_l7_tx_data3 (63 downto 0) , -- MSD: fire_core(fire_core)
    dlx_l7_tx_header (1 downto 0) => dlx_l7_tx_header3 (1 downto 0), -- MSD: fire_core(fire_core)
    dlx_l7_tx_seq (5 downto 0)    => dlx_l7_tx_seq3 (5 downto 0)   , -- MSD: fire_core(fire_core)
    fbist_axis_aclk               => fbist3_axis_aclk              , -- MSR: fire_core(fire_core)
    fbist_axis_i                  => fbist3_axis_i                 , -- MSR: fire_core(fire_core)
    fbist_axis_o                  => fbist3_axis_o                 , -- MSD: fire_core(fire_core)
    gtwiz_buffbypass_rx_done_in   => gtwiz_buffbypass_rx_done_in3  , -- MSR: fire_core(fire_core)
    gtwiz_buffbypass_tx_done_in   => gtwiz_buffbypass_tx_done_in3  , -- MSR: fire_core(fire_core)
    gtwiz_reset_all_out           => gtwiz_reset_all_out3          , -- MSD: fire_core(fire_core)
    gtwiz_reset_rx_datapath_out   => gtwiz_reset_rx_datapath_out3  , -- MSD: fire_core(fire_core)
    gtwiz_reset_rx_done_in        => gtwiz_reset_rx_done_in3       , -- MSR: fire_core(fire_core)
    gtwiz_reset_tx_done_in        => gtwiz_reset_tx_done_in3       , -- MSR: fire_core(fire_core)
    gtwiz_userclk_rx_active_in    => gtwiz_userclk_rx_active_in3   , -- MSR: fire_core(fire_core)
    gtwiz_userclk_tx_active_in    => gtwiz_userclk_tx_active_in3   , -- MSR: fire_core(fire_core)
    hb_gtwiz_reset_all_in         => hb_gtwiz_reset_all_in3        , -- MSR: fire_core(fire_core)
    ln0_rx_data (63 downto 0)     => ln0_rx_data3 (63 downto 0)    , -- MSR: fire_core(fire_core)
    ln0_rx_header (1 downto 0)    => ln0_rx_header3 (1 downto 0)   , -- MSR: fire_core(fire_core)
    ln0_rx_slip                   => ln0_rx_slip3                  , -- MSD: fire_core(fire_core)
    ln0_rx_valid                  => ln0_rx_valid3                 , -- MSR: fire_core(fire_core)
    ln1_rx_data (63 downto 0)     => ln1_rx_data3 (63 downto 0)    , -- MSR: fire_core(fire_core)
    ln1_rx_header (1 downto 0)    => ln1_rx_header3 (1 downto 0)   , -- MSR: fire_core(fire_core)
    ln1_rx_slip                   => ln1_rx_slip3                  , -- MSD: fire_core(fire_core)
    ln1_rx_valid                  => ln1_rx_valid3                 , -- MSR: fire_core(fire_core)
    ln2_rx_data (63 downto 0)     => ln2_rx_data3 (63 downto 0)    , -- MSR: fire_core(fire_core)
    ln2_rx_header (1 downto 0)    => ln2_rx_header3 (1 downto 0)   , -- MSR: fire_core(fire_core)
    ln2_rx_slip                   => ln2_rx_slip3                  , -- MSD: fire_core(fire_core)
    ln2_rx_valid                  => ln2_rx_valid3                 , -- MSR: fire_core(fire_core)
    ln3_rx_data (63 downto 0)     => ln3_rx_data3 (63 downto 0)    , -- MSR: fire_core(fire_core)
    ln3_rx_header (1 downto 0)    => ln3_rx_header3 (1 downto 0)   , -- MSR: fire_core(fire_core)
    ln3_rx_slip                   => ln3_rx_slip3                  , -- MSD: fire_core(fire_core)
    ln3_rx_valid                  => ln3_rx_valid3                 , -- MSR: fire_core(fire_core)
    ln4_rx_data (63 downto 0)     => ln4_rx_data3 (63 downto 0)    , -- MSR: fire_core(fire_core)
    ln4_rx_header (1 downto 0)    => ln4_rx_header3 (1 downto 0)   , -- MSR: fire_core(fire_core)
    ln4_rx_slip                   => ln4_rx_slip3                  , -- MSD: fire_core(fire_core)
    ln4_rx_valid                  => ln4_rx_valid3                 , -- MSR: fire_core(fire_core)
    ln5_rx_data (63 downto 0)     => ln5_rx_data3 (63 downto 0)    , -- MSR: fire_core(fire_core)
    ln5_rx_header (1 downto 0)    => ln5_rx_header3 (1 downto 0)   , -- MSR: fire_core(fire_core)
    ln5_rx_slip                   => ln5_rx_slip3                  , -- MSD: fire_core(fire_core)
    ln5_rx_valid                  => ln5_rx_valid3                 , -- MSR: fire_core(fire_core)
    ln6_rx_data (63 downto 0)     => ln6_rx_data3 (63 downto 0)    , -- MSR: fire_core(fire_core)
    ln6_rx_header (1 downto 0)    => ln6_rx_header3 (1 downto 0)   , -- MSR: fire_core(fire_core)
    ln6_rx_slip                   => ln6_rx_slip3                  , -- MSD: fire_core(fire_core)
    ln6_rx_valid                  => ln6_rx_valid3                 , -- MSR: fire_core(fire_core)
    ln7_rx_data (63 downto 0)     => ln7_rx_data3 (63 downto 0)    , -- MSR: fire_core(fire_core)
    ln7_rx_header (1 downto 0)    => ln7_rx_header3 (1 downto 0)   , -- MSR: fire_core(fire_core)
    ln7_rx_slip                   => ln7_rx_slip3                  , -- MSD: fire_core(fire_core)
    ln7_rx_valid                  => ln7_rx_valid3                 , -- MSR: fire_core(fire_core)
    oc_host_cfg0_axis_aclk        => oc_host_cfg3_axis_aclk       , -- MSR: fire_core(fire_core)
    oc_host_cfg0_axis_i           => oc_host_cfg3_axis_i          , -- MSR: fire_core(fire_core)
    oc_host_cfg0_axis_o           => oc_host_cfg3_axis_o          , -- MSD: fire_core(fire_core)
    oc_memory0_axis_aclk          => oc_memory3_axis_aclk         , -- MSR: fire_core(fire_core)
    oc_memory0_axis_i             => oc_memory3_axis_i            , -- MSR: fire_core(fire_core)
    oc_memory0_axis_o             => oc_memory3_axis_o            , -- MSD: fire_core(fire_core)
    oc_mmio0_axis_aclk            => oc_mmio3_axis_aclk           , -- MSR: fire_core(fire_core)
    oc_mmio0_axis_i               => oc_mmio3_axis_i              , -- MSR: fire_core(fire_core)
    oc_mmio0_axis_o               => oc_mmio3_axis_o              , -- MSD: fire_core(fire_core)
    oc_cfg0_axis_aclk             => oc_cfg3_axis_aclk            , -- MSR: fire_core(fire_core)
    oc_cfg0_axis_i                => oc_cfg3_axis_i               , -- MSR: fire_core(fire_core)
    oc_cfg0_axis_o                => oc_cfg3_axis_o               , -- MSD: fire_core(fire_core)
    ocde                          => ocde_int                         , -- MSR: fire_core(fire_core)
    lane_force_unlock             => std_ulogic_vector(lane_force_unlock)            ,
    rclk                          => rclk                         , -- MSR: fire_core(fire_core)
    sys_resetn                    => sys_resetn               , -- MSR: fire_core(fire_core)
    sysclk                        => sysclk                         -- MSR: fire_core(fire_core)
);

       led_ddimma_red_hw_i   <= '0';
       led_ddimma_green_hw_i <= '0';
       led_ddimmb_red_hw_i   <= '0';
       led_ddimmb_green_hw_i <= '0';
       led_ddimmc_red_hw_i   <= '0';
       led_ddimmc_green_hw_i <= '0';
       led_ddimmd_red_hw_i   <= '0';
       led_ddimmd_green_hw_i <= '0';
       led_ddimmw_red_hw_i   <= '0';
       led_ddimmw_green_hw_i <= '0';

fire_fml_mac : entity work.fire_fml_mac
port map (
    sysclk                   => sysclk                ,
    sys_resetn               => sys_resetn            ,
    ddimma_resetn            => ddimma_resetn         ,
    ddimmb_resetn            => ddimmb_resetn         ,
    ddimmc_resetn            => ddimmc_resetn         ,
    ddimmd_resetn            => ddimmd_resetn         ,
    ddimmw_resetn            => ddimmw_resetn         ,
    ddimms_resetn            => ddimms_resetn         ,
    fml_axis_aclk            => fml_axis_aclk         ,
    fml_axis_i               => fml_axis_i            ,
    fml_axis_o               => fml_axis_o            ,
    led_ddimma_red_hw_i      => led_ddimma_red_hw_i   ,
    led_ddimma_green_hw_i    => led_ddimma_green_hw_i ,
    led_ddimmb_red_hw_i      => led_ddimmb_red_hw_i   ,
    led_ddimmb_green_hw_i    => led_ddimmb_green_hw_i ,
    led_ddimmc_red_hw_i      => led_ddimmc_red_hw_i   ,
    led_ddimmc_green_hw_i    => led_ddimmc_green_hw_i ,
    led_ddimmd_red_hw_i      => led_ddimmd_red_hw_i   ,
    led_ddimmd_green_hw_i    => led_ddimmd_green_hw_i ,
    led_ddimmw_red_hw_i      => led_ddimmw_red_hw_i   ,
    led_ddimmw_green_hw_i    => led_ddimmw_green_hw_i ,
    led_ddimma_red           => led_ddimma_red        ,
    led_ddimma_green         => led_ddimma_green      ,
    led_ddimmb_red           => led_ddimmb_red        ,
    led_ddimmb_green         => led_ddimmb_green      ,
    led_ddimmc_red           => led_ddimmc_red        ,
    led_ddimmc_green         => led_ddimmc_green      ,
    led_ddimmd_red           => led_ddimmd_red        ,
    led_ddimmd_green         => led_ddimmd_green      ,
    led_ddimmw_red           => led_ddimmw_red        ,
    led_ddimmw_green         => led_ddimmw_green,
    fpga_ocmb_tapsel_o       => fpga_ocmb_tapsel_o,              --out
    fpga_ddimma_mfg_tapsel_i => fpga_ddimma_mfg_tapsel_i,        --in --Pulled high on the DDIMMs, make this a receiver
    fpga_ddimmb_mfg_tapsel_i => fpga_ddimmb_mfg_tapsel_i,        --in --Pulled high on the DDIMMs, make this a receiver
    fpga_ddimmc_mfg_tapsel_i => fpga_ddimmc_mfg_tapsel_i,        --in --Pulled high on the DDIMMs, make this a receiver
    fpga_ddimmd_mfg_tapsel_i => fpga_ddimmd_mfg_tapsel_i,        --in --Pulled high on the DDIMMs, make this a receiver
    fpga_ddimmw_mfg_tapsel_i => fpga_ddimmw_mfg_tapsel_i,        --in --Pulled high on the DDIMMs, make this a receiver
    exp_cpu_boot_0_o         => exp_cpu_boot_0_o,                --out
    exp_cpu_boot_1_o         => exp_cpu_boot_1_o,                --out
    jjtag_fpga_trst_i        => jjtag_fpga_trst_i,               --in
    jjtag_fpga_tck_i         => jjtag_fpga_tck_i,                --in
    jjtag_fpga_tms_i         => jjtag_fpga_tms_i,                --in
    jjtag_fpga_tdi_i         => jjtag_fpga_tdi_i,                --in
    jjtag_fpga_rst_i         => jjtag_fpga_rst_i,                --in
    fpga_jjtag_tdo_o         => fpga_jjtag_tdo_o,                --out
    fpga_jdebug_trstb_abw_o  => fpga_jdebug_trstb_abw_o,         --out --this reset when driven by the jjtag will override the edge connector reset on DDIMM connectors (unless a 0 Ohm resistor is depopulated from the DDIMM)
    fpga_jdebug_usin_abw_o   => fpga_jdebug_usin_abw_o,          --out
    fpga_jdebug_usout_abw_i  => fpga_jdebug_usout_abw_i,         --in
    fpga_jdebug_trstb_cd_o   => fpga_jdebug_trstb_cd_o,          --out
    fpga_jdebug_usin_cd_o    => fpga_jdebug_usin_cd_o,           --out
    fpga_jdebug_usout_cd_i   => fpga_jdebug_usout_cd_i,          --in
    fpga_ocmb_trstb_o        => fpga_ocmb_trstb_o,               --out
    fpga_ocmb_tck_o          => fpga_ocmb_tck_o,                 --out
    fpga_ocmb_tms_o          => fpga_ocmb_tms_o,                 --out
    fpga_ocmb_tdi_o          => fpga_ocmb_tdi_o,                 --out
    ocmb_fpga_tdo_i          => ocmb_fpga_tdo_i,                 --in
    fpga_ddimmw_tck_o        => fpga_ddimmw_tck_o,               --out
    fpga_ddimmw_tms_o        => fpga_ddimmw_tms_o,               --out
    fpga_ddimmw_tdi_o        => fpga_ddimmw_tdi_o,               --out
    ddimmw_fpga_tdo_i        => ddimmw_fpga_tdo_i,               --in
    fpga_ddimma_tck_o        => fpga_ddimma_tck_o,               --out
    fpga_ddimma_tms_o        => fpga_ddimma_tms_o,               --out
    fpga_ddimma_tdi_o        => fpga_ddimma_tdi_o,               --out
    ddimma_fpga_tdo_i        => ddimma_fpga_tdo_i,               --in
    fpga_ddimmb_tck_o        => fpga_ddimmb_tck_o,               --out
    fpga_ddimmb_tms_o        => fpga_ddimmb_tms_o,               --out
    fpga_ddimmb_tdi_o        => fpga_ddimmb_tdi_o,               --out
    ddimmb_fpga_tdo_i        => ddimmb_fpga_tdo_i,               --in
    fpga_ddimmc_tck_o        => fpga_ddimmc_tck_o,               --out
    fpga_ddimmc_tms_o        => fpga_ddimmc_tms_o,               --out
    fpga_ddimmc_tdi_o        => fpga_ddimmc_tdi_o,               --out
    ddimmc_fpga_tdo_i        => ddimmc_fpga_tdo_i,               --in
    fpga_ddimmd_tck_o        => fpga_ddimmd_tck_o,               --out
    fpga_ddimmd_tms_o        => fpga_ddimmd_tms_o,               --out
    fpga_ddimmd_tdi_o        => fpga_ddimmd_tdi_o,               --out
    ddimmd_fpga_tdo_i        => ddimmd_fpga_tdo_i,               --in
    fpga_usb_minib_rst_o     => fpga_usb_minib_rst_o,            --out
    fpga_cp2105_din2_o       => fpga_cp2105_din2_o,              --out
    fpga_trs3122_din1_o      => fpga_trs3122_din1_o,             --out
    fpga_trs3122_din0_o      => fpga_trs3122_din0_o,             --out
    cp2105_fpga_rout2_i      => cp2105_fpga_rout2_i,             --in
    trs3122_fpga_rout1_i     => trs3122_fpga_rout1_i,            --in
    trs3122_fpga_rout0_i     => trs3122_fpga_rout0_i,            --in
    fpga_ocmb_usin_o         => fpga_ocmb_usin_o,                --out
    ocmb_fpga_usout_sa2_i    => ocmb_fpga_usout_sa2_i            --in
 );

fire_pervasive : entity work.fire_pervasive
port map (
    c3s_dlx0_axis_aclk     => c3s_dlx0_axis_aclk    , -- MSD: fire_pervasive(fire_pervasive)
    c3s_dlx0_axis_i        => c3s_dlx0_axis_i       , -- MSD: fire_pervasive(fire_pervasive)
    c3s_dlx0_axis_o        => c3s_dlx0_axis_o       , -- MSR: fire_pervasive(fire_pervasive)
    c3s_dlx1_axis_aclk     => c3s_dlx1_axis_aclk    , -- MSD: fire_pervasive(fire_pervasive)
    c3s_dlx1_axis_i        => c3s_dlx1_axis_i       , -- MSD: fire_pervasive(fire_pervasive)
    c3s_dlx1_axis_o        => c3s_dlx1_axis_o       , -- MSR: fire_pervasive(fire_pervasive)
    c3s_dlx2_axis_aclk     => c3s_dlx2_axis_aclk    , -- MSD: fire_pervasive(fire_pervasive)
    c3s_dlx2_axis_i        => c3s_dlx2_axis_i       , -- MSD: fire_pervasive(fire_pervasive)
    c3s_dlx2_axis_o        => c3s_dlx2_axis_o       , -- MSR: fire_pervasive(fire_pervasive)
    c3s_dlx3_axis_aclk     => c3s_dlx3_axis_aclk    , -- MSD: fire_pervasive(fire_pervasive)
    c3s_dlx3_axis_i        => c3s_dlx3_axis_i       , -- MSD: fire_pervasive(fire_pervasive)
    c3s_dlx3_axis_o        => c3s_dlx3_axis_o       , -- MSR: fire_pervasive(fire_pervasive)
    cclk_a                 => cclk_a                , -- MSR: fire_pervasive(fire_pervasive)
    cresetn_a              => cresetn_a             , -- MSD: fire_pervasive(fire_pervasive)
    cclk_b                 => cclk_b                , -- MSR: fire_pervasive(fire_pervasive)
    cresetn_b              => cresetn_b             , -- MSD: fire_pervasive(fire_pervasive)
    cclk_c                 => cclk_c                , -- MSR: fire_pervasive(fire_pervasive)
    cresetn_c              => cresetn_c             , -- MSD: fire_pervasive(fire_pervasive)
    cclk_d                 => cclk_d                , -- MSR: fire_pervasive(fire_pervasive)
    cresetn_d              => cresetn_d             , -- MSD: fire_pervasive(fire_pervasive)
    oc_memory0_axis_aclk   => oc_memory0_axis_aclk  , -- MSD: fire_pervasive(fire_pervasive)
    oc_memory0_axis_i      => oc_memory0_axis_i     , -- MSD: fire_pervasive(fire_pervasive)
    oc_memory0_axis_o      => oc_memory0_axis_o     , -- MSR: fire_pervasive(fire_pervasive)
    oc_mmio0_axis_aclk     => oc_mmio0_axis_aclk    , -- MSD: fire_pervasive(fire_pervasive)
    oc_mmio0_axis_i        => oc_mmio0_axis_i       , -- MSD: fire_pervasive(fire_pervasive)
    oc_mmio0_axis_o        => oc_mmio0_axis_o       , -- MSR: fire_pervasive(fire_pervasive)
    oc_cfg0_axis_aclk      => oc_cfg0_axis_aclk     , -- MSD: fire_pervasive(fire_pervasive)
    oc_cfg0_axis_i         => oc_cfg0_axis_i        , -- MSD: fire_pervasive(fire_pervasive)
    oc_cfg0_axis_o         => oc_cfg0_axis_o        , -- MSR: fire_pervasive(fire_pervasive)
    oc_memory1_axis_aclk   => oc_memory1_axis_aclk  , -- MSD: fire_pervasive(fire_pervasive)
    oc_memory1_axis_i      => oc_memory1_axis_i     , -- MSD: fire_pervasive(fire_pervasive)
    oc_memory1_axis_o      => oc_memory1_axis_o     , -- MSR: fire_pervasive(fire_pervasive)
    oc_mmio1_axis_aclk     => oc_mmio1_axis_aclk    , -- MSD: fire_pervasive(fire_pervasive)
    oc_mmio1_axis_i        => oc_mmio1_axis_i       , -- MSD: fire_pervasive(fire_pervasive)
    oc_mmio1_axis_o        => oc_mmio1_axis_o       , -- MSR: fire_pervasive(fire_pervasive)
    oc_cfg1_axis_aclk      => oc_cfg1_axis_aclk     , -- MSD: fire_pervasive(fire_pervasive)
    oc_cfg1_axis_i         => oc_cfg1_axis_i        , -- MSD: fire_pervasive(fire_pervasive)
    oc_cfg1_axis_o         => oc_cfg1_axis_o        , -- MSR: fire_pervasive(fire_pervasive)
    oc_memory2_axis_aclk   => oc_memory2_axis_aclk  , -- MSD: fire_pervasive(fire_pervasive)
    oc_memory2_axis_i      => oc_memory2_axis_i     , -- MSD: fire_pervasive(fire_pervasive)
    oc_memory2_axis_o      => oc_memory2_axis_o     , -- MSR: fire_pervasive(fire_pervasive)
    oc_mmio2_axis_aclk     => oc_mmio2_axis_aclk    , -- MSD: fire_pervasive(fire_pervasive)
    oc_mmio2_axis_i        => oc_mmio2_axis_i       , -- MSD: fire_pervasive(fire_pervasive)
    oc_mmio2_axis_o        => oc_mmio2_axis_o       , -- MSR: fire_pervasive(fire_pervasive)
    oc_cfg2_axis_aclk      => oc_cfg2_axis_aclk     , -- MSD: fire_pervasive(fire_pervasive)
    oc_cfg2_axis_i         => oc_cfg2_axis_i        , -- MSD: fire_pervasive(fire_pervasive)
    oc_cfg2_axis_o         => oc_cfg2_axis_o        , -- MSR: fire_pervasive(fire_pervasive)
    oc_memory3_axis_aclk   => oc_memory3_axis_aclk  , -- MSD: fire_pervasive(fire_pervasive)
    oc_memory3_axis_i      => oc_memory3_axis_i     , -- MSD: fire_pervasive(fire_pervasive)
    oc_memory3_axis_o      => oc_memory3_axis_o     , -- MSR: fire_pervasive(fire_pervasive)
    oc_mmio3_axis_aclk     => oc_mmio3_axis_aclk    , -- MSD: fire_pervasive(fire_pervasive)
    oc_mmio3_axis_i        => oc_mmio3_axis_i       , -- MSD: fire_pervasive(fire_pervasive)
    oc_mmio3_axis_o        => oc_mmio3_axis_o       , -- MSR: fire_pervasive(fire_pervasive)
    oc_cfg3_axis_aclk      => oc_cfg3_axis_aclk     , -- MSD: fire_pervasive(fire_pervasive)
    oc_cfg3_axis_i         => oc_cfg3_axis_i        , -- MSD: fire_pervasive(fire_pervasive)
    oc_cfg3_axis_o         => oc_cfg3_axis_o        , -- MSR: fire_pervasive(fire_pervasive)
    fbist0_axis_aclk       => fbist0_axis_aclk      , -- MSD: fire_pervasive(fire_pervasive)
    fbist0_axis_i          => fbist0_axis_i         , -- MSD: fire_pervasive(fire_pervasive)
    fbist0_axis_o          => fbist0_axis_o         , -- MSR: fire_pervasive(fire_pervasive)
    fbist1_axis_aclk       => fbist1_axis_aclk      , -- MSD: fire_pervasive(fire_pervasive)
    fbist1_axis_i          => fbist1_axis_i         , -- MSD: fire_pervasive(fire_pervasive)
    fbist1_axis_o          => fbist1_axis_o         , -- MSR: fire_pervasive(fire_pervasive)
    fbist2_axis_aclk       => fbist2_axis_aclk      , -- MSD: fire_pervasive(fire_pervasive)
    fbist2_axis_i          => fbist2_axis_i         , -- MSD: fire_pervasive(fire_pervasive)
    fbist2_axis_o          => fbist2_axis_o         , -- MSR: fire_pervasive(fire_pervasive)
    fbist3_axis_aclk       => fbist3_axis_aclk      , -- MSD: fire_pervasive(fire_pervasive)
    fbist3_axis_i          => fbist3_axis_i         , -- MSD: fire_pervasive(fire_pervasive)
    fbist3_axis_o          => fbist3_axis_o         , -- MSR: fire_pervasive(fire_pervasive)
    oc_host_cfg0_axis_aclk => oc_host_cfg0_axis_aclk, -- MSD: fire_pervasive(fire_pervasive)
    oc_host_cfg0_axis_i    => oc_host_cfg0_axis_i   , -- MSD: fire_pervasive(fire_pervasive)
    oc_host_cfg0_axis_o    => oc_host_cfg0_axis_o   , -- MSR: fire_pervasive(fire_pervasive)
    oc_host_cfg1_axis_aclk => oc_host_cfg1_axis_aclk, -- MSD: fire_pervasive(fire_pervasive)
    oc_host_cfg1_axis_i    => oc_host_cfg1_axis_i   , -- MSD: fire_pervasive(fire_pervasive)
    oc_host_cfg1_axis_o    => oc_host_cfg1_axis_o   , -- MSR: fire_pervasive(fire_pervasive)
    oc_host_cfg2_axis_aclk => oc_host_cfg2_axis_aclk, -- MSD: fire_pervasive(fire_pervasive)
    oc_host_cfg2_axis_i    => oc_host_cfg2_axis_i   , -- MSD: fire_pervasive(fire_pervasive)
    oc_host_cfg2_axis_o    => oc_host_cfg2_axis_o   , -- MSR: fire_pervasive(fire_pervasive)
    oc_host_cfg3_axis_aclk => oc_host_cfg3_axis_aclk, -- MSD: fire_pervasive(fire_pervasive)
    oc_host_cfg3_axis_i    => oc_host_cfg3_axis_i   , -- MSD: fire_pervasive(fire_pervasive)
    oc_host_cfg3_axis_o    => oc_host_cfg3_axis_o   , -- MSR: fire_pervasive(fire_pervasive)
    fml_axis_aclk          => fml_axis_aclk         , -- MSD: fire_pervasive(fire_pervasive)
    fml_axis_i             => fml_axis_i            , -- MSD: fire_pervasive(fire_pervasive)
    fml_axis_o             => fml_axis_o            , -- MSR: fire_pervasive(fire_pervasive)
    scl_io                 => scl_io                , -- MSB: fire_pervasive(fire_pervasive)
    sda_io                 => sda_io                , -- MSB: fire_pervasive(fire_pervasive)
    pll_locked             => pll_locked            , -- MSD: fire_pervasive(fire_pervasive)
    raw_resetn             => raw_resetn_int        , -- MSR: fire_pervasive(fire_pervasive)
    raw_sysclk_n           => raw_sysclk_n          , -- MSR: fire_pervasive(fire_pervasive)
    raw_sysclk_p           => raw_sysclk_p          , -- MSR: fire_pervasive(fire_pervasive)
    sys_resetn             => sys_resetn            , -- MSD: fire_pervasive(fire_pervasive)
    sysclk                 => sysclk                  -- MSD: fire_pervasive(fire_pervasive)
);

hss0 : entity work.hss_phy_wrap0
port map (
    mgtrefclk0_x0y0_p             => mgtrefclk0_x0y0_p             , -- MSR: hss_phy_wrap(hss0)
    mgtrefclk0_x0y0_n             => mgtrefclk0_x0y0_n             , -- MSR: hss_phy_wrap(hss0)
    mgtrefclk0_x0y1_p             => mgtrefclk0_x0y1_p             , -- MSR: hss_phy_wrap(hss0)
    mgtrefclk0_x0y1_n             => mgtrefclk0_x0y1_n             , -- MSR: hss_phy_wrap(hss0)
    ch0_gtyrxn_in                 => ch0_gtyrxn0_in                , -- MSR: hss_phy_wrap(hss0)
    ch0_gtyrxp_in                 => ch0_gtyrxp0_in                , -- MSR: hss_phy_wrap(hss0)
    ch0_gtytxn_out                => ch0_gtytxn0_out               , -- MSD: hss_phy_wrap(hss0)
    ch0_gtytxp_out                => ch0_gtytxp0_out               , -- MSD: hss_phy_wrap(hss0)
    ch1_gtyrxn_in                 => ch1_gtyrxn0_in                , -- MSR: hss_phy_wrap(hss0)
    ch1_gtyrxp_in                 => ch1_gtyrxp0_in                , -- MSR: hss_phy_wrap(hss0)
    ch1_gtytxn_out                => ch1_gtytxn0_out               , -- MSD: hss_phy_wrap(hss0)
    ch1_gtytxp_out                => ch1_gtytxp0_out               , -- MSD: hss_phy_wrap(hss0)
    ch2_gtyrxn_in                 => ch2_gtyrxn0_in                , -- MSR: hss_phy_wrap(hss0)
    ch2_gtyrxp_in                 => ch2_gtyrxp0_in                , -- MSR: hss_phy_wrap(hss0)
    ch2_gtytxn_out                => ch2_gtytxn0_out               , -- MSD: hss_phy_wrap(hss0)
    ch2_gtytxp_out                => ch2_gtytxp0_out               , -- MSD: hss_phy_wrap(hss0)
    ch3_gtyrxn_in                 => ch3_gtyrxn0_in                , -- MSR: hss_phy_wrap(hss0)
    ch3_gtyrxp_in                 => ch3_gtyrxp0_in                , -- MSR: hss_phy_wrap(hss0)
    ch3_gtytxn_out                => ch3_gtytxn0_out               , -- MSD: hss_phy_wrap(hss0)
    ch3_gtytxp_out                => ch3_gtytxp0_out               , -- MSD: hss_phy_wrap(hss0)
    ch4_gtyrxn_in                 => ch4_gtyrxn0_in                , -- MSR: hss_phy_wrap(hss0)
    ch4_gtyrxp_in                 => ch4_gtyrxp0_in                , -- MSR: hss_phy_wrap(hss0)
    ch4_gtytxn_out                => ch4_gtytxn0_out               , -- MSD: hss_phy_wrap(hss0)
    ch4_gtytxp_out                => ch4_gtytxp0_out               , -- MSD: hss_phy_wrap(hss0)
    ch5_gtyrxn_in                 => ch5_gtyrxn0_in                , -- MSR: hss_phy_wrap(hss0)
    ch5_gtyrxp_in                 => ch5_gtyrxp0_in                , -- MSR: hss_phy_wrap(hss0)
    ch5_gtytxn_out                => ch5_gtytxn0_out               , -- MSD: hss_phy_wrap(hss0)
    ch5_gtytxp_out                => ch5_gtytxp0_out               , -- MSD: hss_phy_wrap(hss0)
    ch6_gtyrxn_in                 => ch6_gtyrxn0_in                , -- MSR: hss_phy_wrap(hss0)
    ch6_gtyrxp_in                 => ch6_gtyrxp0_in                , -- MSR: hss_phy_wrap(hss0)
    ch6_gtytxn_out                => ch6_gtytxn0_out               , -- MSD: hss_phy_wrap(hss0)
    ch6_gtytxp_out                => ch6_gtytxp0_out               , -- MSD: hss_phy_wrap(hss0)
    ch7_gtyrxn_in                 => ch7_gtyrxn0_in                , -- MSR: hss_phy_wrap(hss0)
    ch7_gtyrxp_in                 => ch7_gtyrxp0_in                , -- MSR: hss_phy_wrap(hss0)
    ch7_gtytxn_out                => ch7_gtytxn0_out               , -- MSD: hss_phy_wrap(hss0)
    ch7_gtytxp_out                => ch7_gtytxp0_out               , -- MSD: hss_phy_wrap(hss0)
    ch0_txheader                  => ch0_txheader0                 , -- MSR: hss_phy_wrap(hss0)
    ch1_txheader                  => ch1_txheader0                 , -- MSR: hss_phy_wrap(hss0)
    ch2_txheader                  => ch2_txheader0                 , -- MSR: hss_phy_wrap(hss0)
    ch3_txheader                  => ch3_txheader0                 , -- MSR: hss_phy_wrap(hss0)
    ch4_txheader                  => ch4_txheader0                 , -- MSR: hss_phy_wrap(hss0)
    ch5_txheader                  => ch5_txheader0                 , -- MSR: hss_phy_wrap(hss0)
    ch6_txheader                  => ch6_txheader0                 , -- MSR: hss_phy_wrap(hss0)
    ch7_txheader                  => ch7_txheader0                 , -- MSR: hss_phy_wrap(hss0)
    ch0_txsequence                => ch0_txsequence0               , -- MSR: hss_phy_wrap(hss0)
    ch1_txsequence                => ch1_txsequence0               , -- MSR: hss_phy_wrap(hss0)
    ch2_txsequence                => ch2_txsequence0               , -- MSR: hss_phy_wrap(hss0)
    ch3_txsequence                => ch3_txsequence0               , -- MSR: hss_phy_wrap(hss0)
    ch4_txsequence                => ch4_txsequence0               , -- MSR: hss_phy_wrap(hss0)
    ch5_txsequence                => ch5_txsequence0               , -- MSR: hss_phy_wrap(hss0)
    ch6_txsequence                => ch6_txsequence0               , -- MSR: hss_phy_wrap(hss0)
    ch7_txsequence                => ch7_txsequence0               , -- MSR: hss_phy_wrap(hss0)
    hb0_gtwiz_userdata_tx         => hb0_gtwiz_userdata_tx0        , -- MSR: hss_phy_wrap(hss0)
    hb1_gtwiz_userdata_tx         => hb1_gtwiz_userdata_tx0        , -- MSR: hss_phy_wrap(hss0)
    hb2_gtwiz_userdata_tx         => hb2_gtwiz_userdata_tx0        , -- MSR: hss_phy_wrap(hss0)
    hb3_gtwiz_userdata_tx         => hb3_gtwiz_userdata_tx0        , -- MSR: hss_phy_wrap(hss0)
    hb4_gtwiz_userdata_tx         => hb4_gtwiz_userdata_tx0        , -- MSR: hss_phy_wrap(hss0)
    hb5_gtwiz_userdata_tx         => hb5_gtwiz_userdata_tx0        , -- MSR: hss_phy_wrap(hss0)
    hb6_gtwiz_userdata_tx         => hb6_gtwiz_userdata_tx0        , -- MSR: hss_phy_wrap(hss0)
    hb7_gtwiz_userdata_tx         => hb7_gtwiz_userdata_tx0        , -- MSR: hss_phy_wrap(hss0)
    ch0_rxdatavalid               => ch0_rxdatavalid0              , -- MSD: hss_phy_wrap(hss0)
    ch1_rxdatavalid               => ch1_rxdatavalid0              , -- MSD: hss_phy_wrap(hss0)
    ch2_rxdatavalid               => ch2_rxdatavalid0              , -- MSD: hss_phy_wrap(hss0)
    ch3_rxdatavalid               => ch3_rxdatavalid0              , -- MSD: hss_phy_wrap(hss0)
    ch4_rxdatavalid               => ch4_rxdatavalid0              , -- MSD: hss_phy_wrap(hss0)
    ch5_rxdatavalid               => ch5_rxdatavalid0              , -- MSD: hss_phy_wrap(hss0)
    ch6_rxdatavalid               => ch6_rxdatavalid0              , -- MSD: hss_phy_wrap(hss0)
    ch7_rxdatavalid               => ch7_rxdatavalid0              , -- MSD: hss_phy_wrap(hss0)
    ch0_rxheader                  => ch0_rxheader0                 , -- MSD: hss_phy_wrap(hss0)
    ch1_rxheader                  => ch1_rxheader0                 , -- MSD: hss_phy_wrap(hss0)
    ch2_rxheader                  => ch2_rxheader0                 , -- MSD: hss_phy_wrap(hss0)
    ch3_rxheader                  => ch3_rxheader0                 , -- MSD: hss_phy_wrap(hss0)
    ch4_rxheader                  => ch4_rxheader0                 , -- MSD: hss_phy_wrap(hss0)
    ch5_rxheader                  => ch5_rxheader0                 , -- MSD: hss_phy_wrap(hss0)
    ch6_rxheader                  => ch6_rxheader0                 , -- MSD: hss_phy_wrap(hss0)
    ch7_rxheader                  => ch7_rxheader0                 , -- MSD: hss_phy_wrap(hss0)
    ch0_rxgearboxslip             => ch0_rxgearboxslip0            , -- MSR: hss_phy_wrap(hss0)
    ch1_rxgearboxslip             => ch1_rxgearboxslip0            , -- MSR: hss_phy_wrap(hss0)
    ch2_rxgearboxslip             => ch2_rxgearboxslip0            , -- MSR: hss_phy_wrap(hss0)
    ch3_rxgearboxslip             => ch3_rxgearboxslip0            , -- MSR: hss_phy_wrap(hss0)
    ch4_rxgearboxslip             => ch4_rxgearboxslip0            , -- MSR: hss_phy_wrap(hss0)
    ch5_rxgearboxslip             => ch5_rxgearboxslip0            , -- MSR: hss_phy_wrap(hss0)
    ch6_rxgearboxslip             => ch6_rxgearboxslip0            , -- MSR: hss_phy_wrap(hss0)
    ch7_rxgearboxslip             => ch7_rxgearboxslip0            , -- MSR: hss_phy_wrap(hss0)
    gtwiz_buffbypass_rx_done_in   => gtwiz_buffbypass_rx_done_in0  , -- MSD: hss_phy_wrap(hss0)
    gtwiz_buffbypass_tx_done_in   => gtwiz_buffbypass_tx_done_in0  , -- MSD: hss_phy_wrap(hss0)
    gtwiz_reset_all_out           => gtwiz_reset_all_out0          , -- MSR: hss_phy_wrap(hss0)
    gtwiz_reset_rx_datapath_out   => gtwiz_reset_rx_datapath_out0  , -- MSR: hss_phy_wrap(hss0)
    gtwiz_reset_rx_done_in        => gtwiz_reset_rx_done_in0       , -- MSD: hss_phy_wrap(hss0)
    gtwiz_reset_tx_done_in        => gtwiz_reset_tx_done_in0       , -- MSD: hss_phy_wrap(hss0)
    gtwiz_userclk_rx_active_in    => gtwiz_userclk_rx_active_in0   , -- MSD: hss_phy_wrap(hss0)
    gtwiz_userclk_tx_active_in    => gtwiz_userclk_tx_active_in0   , -- MSD: hss_phy_wrap(hss0)
    hb0_gtwiz_userdata_rx         => hb0_gtwiz_userdata_rx0        , -- MSD: hss_phy_wrap(hss0)
    hb1_gtwiz_userdata_rx         => hb1_gtwiz_userdata_rx0        , -- MSD: hss_phy_wrap(hss0)
    hb2_gtwiz_userdata_rx         => hb2_gtwiz_userdata_rx0        , -- MSD: hss_phy_wrap(hss0)
    hb3_gtwiz_userdata_rx         => hb3_gtwiz_userdata_rx0        , -- MSD: hss_phy_wrap(hss0)
    hb4_gtwiz_userdata_rx         => hb4_gtwiz_userdata_rx0        , -- MSD: hss_phy_wrap(hss0)
    hb5_gtwiz_userdata_rx         => hb5_gtwiz_userdata_rx0        , -- MSD: hss_phy_wrap(hss0)
    hb6_gtwiz_userdata_rx         => hb6_gtwiz_userdata_rx0        , -- MSD: hss_phy_wrap(hss0)
    hb7_gtwiz_userdata_rx         => hb7_gtwiz_userdata_rx0        , -- MSD: hss_phy_wrap(hss0)
    hb_gtwiz_reset_all_in         => hb_gtwiz_reset_all_in0        , -- MSD: hss_phy_wrap(hss0)
    cclk                          => cclk_a                        , -- MSD: hss_phy_wrap(hss0)
    hb_gtwiz_reset_clk_freerun_buf_int                    => hb_gtwiz_reset_clk_freerun_buf_int                    , -- MSR: hss_phy_wrap(hss0)
    rclk                          => rclk                            -- MSD: hss_phy_wrap(hss0)
);
-- hss1 was calling hss_phy_wrap - renamed to hss_phy_wrap1
hss1 : entity work.hss_phy_wrap1
port map (
    mgtrefclk0_x0y0_p             => mgtrefclk1_x0y0_p             , -- MSR: hss_phy_wrap(hss0)
    mgtrefclk0_x0y0_n             => mgtrefclk1_x0y0_n             , -- MSR: hss_phy_wrap(hss0)
    mgtrefclk0_x0y1_p             => mgtrefclk1_x0y1_p             , -- MSR: hss_phy_wrap(hss0)
    mgtrefclk0_x0y1_n             => mgtrefclk1_x0y1_n             , -- MSR: hss_phy_wrap(hss0)
    ch0_gtyrxn_in                 => ch0_gtyrxn1_in                , -- MSR: hss_phy_wrap(hss0)
    ch0_gtyrxp_in                 => ch0_gtyrxp1_in                , -- MSR: hss_phy_wrap(hss0)
    ch0_gtytxn_out                => ch0_gtytxn1_out               , -- MSD: hss_phy_wrap(hss0)
    ch0_gtytxp_out                => ch0_gtytxp1_out               , -- MSD: hss_phy_wrap(hss0)
    ch1_gtyrxn_in                 => ch1_gtyrxn1_in                , -- MSR: hss_phy_wrap(hss0)
    ch1_gtyrxp_in                 => ch1_gtyrxp1_in                , -- MSR: hss_phy_wrap(hss0)
    ch1_gtytxn_out                => ch1_gtytxn1_out               , -- MSD: hss_phy_wrap(hss0)
    ch1_gtytxp_out                => ch1_gtytxp1_out               , -- MSD: hss_phy_wrap(hss0)
    ch2_gtyrxn_in                 => ch2_gtyrxn1_in                , -- MSR: hss_phy_wrap(hss0)
    ch2_gtyrxp_in                 => ch2_gtyrxp1_in                , -- MSR: hss_phy_wrap(hss0)
    ch2_gtytxn_out                => ch2_gtytxn1_out               , -- MSD: hss_phy_wrap(hss0)
    ch2_gtytxp_out                => ch2_gtytxp1_out               , -- MSD: hss_phy_wrap(hss0)
    ch3_gtyrxn_in                 => ch3_gtyrxn1_in                , -- MSR: hss_phy_wrap(hss0)
    ch3_gtyrxp_in                 => ch3_gtyrxp1_in                , -- MSR: hss_phy_wrap(hss0)
    ch3_gtytxn_out                => ch3_gtytxn1_out               , -- MSD: hss_phy_wrap(hss0)
    ch3_gtytxp_out                => ch3_gtytxp1_out               , -- MSD: hss_phy_wrap(hss0)
    ch4_gtyrxn_in                 => ch4_gtyrxn1_in                , -- MSR: hss_phy_wrap(hss0)
    ch4_gtyrxp_in                 => ch4_gtyrxp1_in                , -- MSR: hss_phy_wrap(hss0)
    ch4_gtytxn_out                => ch4_gtytxn1_out               , -- MSD: hss_phy_wrap(hss0)
    ch4_gtytxp_out                => ch4_gtytxp1_out               , -- MSD: hss_phy_wrap(hss0)
    ch5_gtyrxn_in                 => ch5_gtyrxn1_in                , -- MSR: hss_phy_wrap(hss0)
    ch5_gtyrxp_in                 => ch5_gtyrxp1_in                , -- MSR: hss_phy_wrap(hss0)
    ch5_gtytxn_out                => ch5_gtytxn1_out               , -- MSD: hss_phy_wrap(hss0)
    ch5_gtytxp_out                => ch5_gtytxp1_out               , -- MSD: hss_phy_wrap(hss0)
    ch6_gtyrxn_in                 => ch6_gtyrxn1_in                , -- MSR: hss_phy_wrap(hss0)
    ch6_gtyrxp_in                 => ch6_gtyrxp1_in                , -- MSR: hss_phy_wrap(hss0)
    ch6_gtytxn_out                => ch6_gtytxn1_out               , -- MSD: hss_phy_wrap(hss0)
    ch6_gtytxp_out                => ch6_gtytxp1_out               , -- MSD: hss_phy_wrap(hss0)
    ch7_gtyrxn_in                 => ch7_gtyrxn1_in                , -- MSR: hss_phy_wrap(hss0)
    ch7_gtyrxp_in                 => ch7_gtyrxp1_in                , -- MSR: hss_phy_wrap(hss0)
    ch7_gtytxn_out                => ch7_gtytxn1_out               , -- MSD: hss_phy_wrap(hss0)
    ch7_gtytxp_out                => ch7_gtytxp1_out               , -- MSD: hss_phy_wrap(hss0)
    ch0_txheader                  => ch0_txheader1                 , -- MSR: hss_phy_wrap(hss0)
    ch1_txheader                  => ch1_txheader1                 , -- MSR: hss_phy_wrap(hss0)
    ch2_txheader                  => ch2_txheader1                 , -- MSR: hss_phy_wrap(hss0)
    ch3_txheader                  => ch3_txheader1                 , -- MSR: hss_phy_wrap(hss0)
    ch4_txheader                  => ch4_txheader1                 , -- MSR: hss_phy_wrap(hss0)
    ch5_txheader                  => ch5_txheader1                 , -- MSR: hss_phy_wrap(hss0)
    ch6_txheader                  => ch6_txheader1                 , -- MSR: hss_phy_wrap(hss0)
    ch7_txheader                  => ch7_txheader1                 , -- MSR: hss_phy_wrap(hss0)
    ch0_txsequence                => ch0_txsequence1               , -- MSR: hss_phy_wrap(hss0)
    ch1_txsequence                => ch1_txsequence1               , -- MSR: hss_phy_wrap(hss0)
    ch2_txsequence                => ch2_txsequence1               , -- MSR: hss_phy_wrap(hss0)
    ch3_txsequence                => ch3_txsequence1               , -- MSR: hss_phy_wrap(hss0)
    ch4_txsequence                => ch4_txsequence1               , -- MSR: hss_phy_wrap(hss0)
    ch5_txsequence                => ch5_txsequence1               , -- MSR: hss_phy_wrap(hss0)
    ch6_txsequence                => ch6_txsequence1               , -- MSR: hss_phy_wrap(hss0)
    ch7_txsequence                => ch7_txsequence1               , -- MSR: hss_phy_wrap(hss0)
    hb0_gtwiz_userdata_tx         => hb0_gtwiz_userdata_tx1        , -- MSR: hss_phy_wrap(hss0)
    hb1_gtwiz_userdata_tx         => hb1_gtwiz_userdata_tx1        , -- MSR: hss_phy_wrap(hss0)
    hb2_gtwiz_userdata_tx         => hb2_gtwiz_userdata_tx1        , -- MSR: hss_phy_wrap(hss0)
    hb3_gtwiz_userdata_tx         => hb3_gtwiz_userdata_tx1        , -- MSR: hss_phy_wrap(hss0)
    hb4_gtwiz_userdata_tx         => hb4_gtwiz_userdata_tx1        , -- MSR: hss_phy_wrap(hss0)
    hb5_gtwiz_userdata_tx         => hb5_gtwiz_userdata_tx1        , -- MSR: hss_phy_wrap(hss0)
    hb6_gtwiz_userdata_tx         => hb6_gtwiz_userdata_tx1        , -- MSR: hss_phy_wrap(hss0)
    hb7_gtwiz_userdata_tx         => hb7_gtwiz_userdata_tx1        , -- MSR: hss_phy_wrap(hss0)
    ch0_rxdatavalid               => ch0_rxdatavalid1              , -- MSD: hss_phy_wrap(hss0)
    ch1_rxdatavalid               => ch1_rxdatavalid1              , -- MSD: hss_phy_wrap(hss0)
    ch2_rxdatavalid               => ch2_rxdatavalid1              , -- MSD: hss_phy_wrap(hss0)
    ch3_rxdatavalid               => ch3_rxdatavalid1              , -- MSD: hss_phy_wrap(hss0)
    ch4_rxdatavalid               => ch4_rxdatavalid1              , -- MSD: hss_phy_wrap(hss0)
    ch5_rxdatavalid               => ch5_rxdatavalid1              , -- MSD: hss_phy_wrap(hss0)
    ch6_rxdatavalid               => ch6_rxdatavalid1              , -- MSD: hss_phy_wrap(hss0)
    ch7_rxdatavalid               => ch7_rxdatavalid1              , -- MSD: hss_phy_wrap(hss0)
    ch0_rxheader                  => ch0_rxheader1                 , -- MSD: hss_phy_wrap(hss0)
    ch1_rxheader                  => ch1_rxheader1                 , -- MSD: hss_phy_wrap(hss0)
    ch2_rxheader                  => ch2_rxheader1                 , -- MSD: hss_phy_wrap(hss0)
    ch3_rxheader                  => ch3_rxheader1                 , -- MSD: hss_phy_wrap(hss0)
    ch4_rxheader                  => ch4_rxheader1                 , -- MSD: hss_phy_wrap(hss0)
    ch5_rxheader                  => ch5_rxheader1                 , -- MSD: hss_phy_wrap(hss0)
    ch6_rxheader                  => ch6_rxheader1                 , -- MSD: hss_phy_wrap(hss0)
    ch7_rxheader                  => ch7_rxheader1                 , -- MSD: hss_phy_wrap(hss0)
    ch0_rxgearboxslip             => ch0_rxgearboxslip1            , -- MSR: hss_phy_wrap(hss0)
    ch1_rxgearboxslip             => ch1_rxgearboxslip1            , -- MSR: hss_phy_wrap(hss0)
    ch2_rxgearboxslip             => ch2_rxgearboxslip1            , -- MSR: hss_phy_wrap(hss0)
    ch3_rxgearboxslip             => ch3_rxgearboxslip1            , -- MSR: hss_phy_wrap(hss0)
    ch4_rxgearboxslip             => ch4_rxgearboxslip1            , -- MSR: hss_phy_wrap(hss0)
    ch5_rxgearboxslip             => ch5_rxgearboxslip1            , -- MSR: hss_phy_wrap(hss0)
    ch6_rxgearboxslip             => ch6_rxgearboxslip1            , -- MSR: hss_phy_wrap(hss0)
    ch7_rxgearboxslip             => ch7_rxgearboxslip1            , -- MSR: hss_phy_wrap(hss0)
    gtwiz_buffbypass_rx_done_in   => gtwiz_buffbypass_rx_done_in1  , -- MSD: hss_phy_wrap(hss0)
    gtwiz_buffbypass_tx_done_in   => gtwiz_buffbypass_tx_done_in1  , -- MSD: hss_phy_wrap(hss0)
    gtwiz_reset_all_out           => gtwiz_reset_all_out1          , -- MSR: hss_phy_wrap(hss0)
    gtwiz_reset_rx_datapath_out   => gtwiz_reset_rx_datapath_out1  , -- MSR: hss_phy_wrap(hss0)
    gtwiz_reset_rx_done_in        => gtwiz_reset_rx_done_in1       , -- MSD: hss_phy_wrap(hss0)
    gtwiz_reset_tx_done_in        => gtwiz_reset_tx_done_in1       , -- MSD: hss_phy_wrap(hss0)
    gtwiz_userclk_rx_active_in    => gtwiz_userclk_rx_active_in1   , -- MSD: hss_phy_wrap(hss0)
    gtwiz_userclk_tx_active_in    => gtwiz_userclk_tx_active_in1   , -- MSD: hss_phy_wrap(hss0)
    hb0_gtwiz_userdata_rx         => hb0_gtwiz_userdata_rx1        , -- MSD: hss_phy_wrap(hss0)
    hb1_gtwiz_userdata_rx         => hb1_gtwiz_userdata_rx1        , -- MSD: hss_phy_wrap(hss0)
    hb2_gtwiz_userdata_rx         => hb2_gtwiz_userdata_rx1        , -- MSD: hss_phy_wrap(hss0)
    hb3_gtwiz_userdata_rx         => hb3_gtwiz_userdata_rx1        , -- MSD: hss_phy_wrap(hss0)
    hb4_gtwiz_userdata_rx         => hb4_gtwiz_userdata_rx1        , -- MSD: hss_phy_wrap(hss0)
    hb5_gtwiz_userdata_rx         => hb5_gtwiz_userdata_rx1        , -- MSD: hss_phy_wrap(hss0)
    hb6_gtwiz_userdata_rx         => hb6_gtwiz_userdata_rx1        , -- MSD: hss_phy_wrap(hss0)
    hb7_gtwiz_userdata_rx         => hb7_gtwiz_userdata_rx1        , -- MSD: hss_phy_wrap(hss0)
    hb_gtwiz_reset_all_in         => hb_gtwiz_reset_all_in1        , -- MSD: hss_phy_wrap(hss0)
    cclk                          => cclk_b                        , -- MSD: hss_phy_wrap(hss0)
    hb_gtwiz_reset_clk_freerun_buf_int                    => hb_gtwiz_reset_clk_freerun_buf_int                    , -- MSR: hss_phy_wrap(hss0)
    rclk                          => rclk                            -- MSD: hss_phy_wrap(hss0)
);

hss2 : entity work.hss_phy_wrap2
port map (
    mgtrefclk0_x0y0_p             => mgtrefclk2_x0y0_p             , -- MSR: hss_phy_wrap(hss0)
    mgtrefclk0_x0y0_n             => mgtrefclk2_x0y0_n             , -- MSR: hss_phy_wrap(hss0)
    mgtrefclk0_x0y1_p             => mgtrefclk2_x0y1_p             , -- MSR: hss_phy_wrap(hss0)
    mgtrefclk0_x0y1_n             => mgtrefclk2_x0y1_n             , -- MSR: hss_phy_wrap(hss0)
    ch0_gtyrxn_in                 => ch0_gtyrxn2_in                , -- MSR: hss_phy_wrap(hss0)
    ch0_gtyrxp_in                 => ch0_gtyrxp2_in                , -- MSR: hss_phy_wrap(hss0)
    ch0_gtytxn_out                => ch0_gtytxn2_out               , -- MSD: hss_phy_wrap(hss0)
    ch0_gtytxp_out                => ch0_gtytxp2_out               , -- MSD: hss_phy_wrap(hss0)
    ch1_gtyrxn_in                 => ch1_gtyrxn2_in                , -- MSR: hss_phy_wrap(hss0)
    ch1_gtyrxp_in                 => ch1_gtyrxp2_in                , -- MSR: hss_phy_wrap(hss0)
    ch1_gtytxn_out                => ch1_gtytxn2_out               , -- MSD: hss_phy_wrap(hss0)
    ch1_gtytxp_out                => ch1_gtytxp2_out               , -- MSD: hss_phy_wrap(hss0)
    ch2_gtyrxn_in                 => ch2_gtyrxn2_in                , -- MSR: hss_phy_wrap(hss0)
    ch2_gtyrxp_in                 => ch2_gtyrxp2_in                , -- MSR: hss_phy_wrap(hss0)
    ch2_gtytxn_out                => ch2_gtytxn2_out               , -- MSD: hss_phy_wrap(hss0)
    ch2_gtytxp_out                => ch2_gtytxp2_out               , -- MSD: hss_phy_wrap(hss0)
    ch3_gtyrxn_in                 => ch3_gtyrxn2_in                , -- MSR: hss_phy_wrap(hss0)
    ch3_gtyrxp_in                 => ch3_gtyrxp2_in                , -- MSR: hss_phy_wrap(hss0)
    ch3_gtytxn_out                => ch3_gtytxn2_out               , -- MSD: hss_phy_wrap(hss0)
    ch3_gtytxp_out                => ch3_gtytxp2_out               , -- MSD: hss_phy_wrap(hss0)
    ch4_gtyrxn_in                 => ch4_gtyrxn2_in                , -- MSR: hss_phy_wrap(hss0)
    ch4_gtyrxp_in                 => ch4_gtyrxp2_in                , -- MSR: hss_phy_wrap(hss0)
    ch4_gtytxn_out                => ch4_gtytxn2_out               , -- MSD: hss_phy_wrap(hss0)
    ch4_gtytxp_out                => ch4_gtytxp2_out               , -- MSD: hss_phy_wrap(hss0)
    ch5_gtyrxn_in                 => ch5_gtyrxn2_in                , -- MSR: hss_phy_wrap(hss0)
    ch5_gtyrxp_in                 => ch5_gtyrxp2_in                , -- MSR: hss_phy_wrap(hss0)
    ch5_gtytxn_out                => ch5_gtytxn2_out               , -- MSD: hss_phy_wrap(hss0)
    ch5_gtytxp_out                => ch5_gtytxp2_out               , -- MSD: hss_phy_wrap(hss0)
    ch6_gtyrxn_in                 => ch6_gtyrxn2_in                , -- MSR: hss_phy_wrap(hss0)
    ch6_gtyrxp_in                 => ch6_gtyrxp2_in                , -- MSR: hss_phy_wrap(hss0)
    ch6_gtytxn_out                => ch6_gtytxn2_out               , -- MSD: hss_phy_wrap(hss0)
    ch6_gtytxp_out                => ch6_gtytxp2_out               , -- MSD: hss_phy_wrap(hss0)
    ch7_gtyrxn_in                 => ch7_gtyrxn2_in                , -- MSR: hss_phy_wrap(hss0)
    ch7_gtyrxp_in                 => ch7_gtyrxp2_in                , -- MSR: hss_phy_wrap(hss0)
    ch7_gtytxn_out                => ch7_gtytxn2_out               , -- MSD: hss_phy_wrap(hss0)
    ch7_gtytxp_out                => ch7_gtytxp2_out               , -- MSD: hss_phy_wrap(hss0)
    ch0_txheader                  => ch0_txheader2                 , -- MSR: hss_phy_wrap(hss0)
    ch1_txheader                  => ch1_txheader2                 , -- MSR: hss_phy_wrap(hss0)
    ch2_txheader                  => ch2_txheader2                 , -- MSR: hss_phy_wrap(hss0)
    ch3_txheader                  => ch3_txheader2                 , -- MSR: hss_phy_wrap(hss0)
    ch4_txheader                  => ch4_txheader2                 , -- MSR: hss_phy_wrap(hss0)
    ch5_txheader                  => ch5_txheader2                 , -- MSR: hss_phy_wrap(hss0)
    ch6_txheader                  => ch6_txheader2                 , -- MSR: hss_phy_wrap(hss0)
    ch7_txheader                  => ch7_txheader2                 , -- MSR: hss_phy_wrap(hss0)
    ch0_txsequence                => ch0_txsequence2               , -- MSR: hss_phy_wrap(hss0)
    ch1_txsequence                => ch1_txsequence2               , -- MSR: hss_phy_wrap(hss0)
    ch2_txsequence                => ch2_txsequence2               , -- MSR: hss_phy_wrap(hss0)
    ch3_txsequence                => ch3_txsequence2               , -- MSR: hss_phy_wrap(hss0)
    ch4_txsequence                => ch4_txsequence2               , -- MSR: hss_phy_wrap(hss0)
    ch5_txsequence                => ch5_txsequence2               , -- MSR: hss_phy_wrap(hss0)
    ch6_txsequence                => ch6_txsequence2               , -- MSR: hss_phy_wrap(hss0)
    ch7_txsequence                => ch7_txsequence2               , -- MSR: hss_phy_wrap(hss0)
    hb0_gtwiz_userdata_tx         => hb0_gtwiz_userdata_tx2        , -- MSR: hss_phy_wrap(hss0)
    hb1_gtwiz_userdata_tx         => hb1_gtwiz_userdata_tx2        , -- MSR: hss_phy_wrap(hss0)
    hb2_gtwiz_userdata_tx         => hb2_gtwiz_userdata_tx2        , -- MSR: hss_phy_wrap(hss0)
    hb3_gtwiz_userdata_tx         => hb3_gtwiz_userdata_tx2        , -- MSR: hss_phy_wrap(hss0)
    hb4_gtwiz_userdata_tx         => hb4_gtwiz_userdata_tx2        , -- MSR: hss_phy_wrap(hss0)
    hb5_gtwiz_userdata_tx         => hb5_gtwiz_userdata_tx2        , -- MSR: hss_phy_wrap(hss0)
    hb6_gtwiz_userdata_tx         => hb6_gtwiz_userdata_tx2        , -- MSR: hss_phy_wrap(hss0)
    hb7_gtwiz_userdata_tx         => hb7_gtwiz_userdata_tx2        , -- MSR: hss_phy_wrap(hss0)
    ch0_rxdatavalid               => ch0_rxdatavalid2              , -- MSD: hss_phy_wrap(hss0)
    ch1_rxdatavalid               => ch1_rxdatavalid2              , -- MSD: hss_phy_wrap(hss0)
    ch2_rxdatavalid               => ch2_rxdatavalid2              , -- MSD: hss_phy_wrap(hss0)
    ch3_rxdatavalid               => ch3_rxdatavalid2              , -- MSD: hss_phy_wrap(hss0)
    ch4_rxdatavalid               => ch4_rxdatavalid2              , -- MSD: hss_phy_wrap(hss0)
    ch5_rxdatavalid               => ch5_rxdatavalid2              , -- MSD: hss_phy_wrap(hss0)
    ch6_rxdatavalid               => ch6_rxdatavalid2              , -- MSD: hss_phy_wrap(hss0)
    ch7_rxdatavalid               => ch7_rxdatavalid2              , -- MSD: hss_phy_wrap(hss0)
    ch0_rxheader                  => ch0_rxheader2                 , -- MSD: hss_phy_wrap(hss0)
    ch1_rxheader                  => ch1_rxheader2                 , -- MSD: hss_phy_wrap(hss0)
    ch2_rxheader                  => ch2_rxheader2                 , -- MSD: hss_phy_wrap(hss0)
    ch3_rxheader                  => ch3_rxheader2                 , -- MSD: hss_phy_wrap(hss0)
    ch4_rxheader                  => ch4_rxheader2                 , -- MSD: hss_phy_wrap(hss0)
    ch5_rxheader                  => ch5_rxheader2                 , -- MSD: hss_phy_wrap(hss0)
    ch6_rxheader                  => ch6_rxheader2                 , -- MSD: hss_phy_wrap(hss0)
    ch7_rxheader                  => ch7_rxheader2                 , -- MSD: hss_phy_wrap(hss0)
    ch0_rxgearboxslip             => ch0_rxgearboxslip2            , -- MSR: hss_phy_wrap(hss0)
    ch1_rxgearboxslip             => ch1_rxgearboxslip2            , -- MSR: hss_phy_wrap(hss0)
    ch2_rxgearboxslip             => ch2_rxgearboxslip2            , -- MSR: hss_phy_wrap(hss0)
    ch3_rxgearboxslip             => ch3_rxgearboxslip2            , -- MSR: hss_phy_wrap(hss0)
    ch4_rxgearboxslip             => ch4_rxgearboxslip2            , -- MSR: hss_phy_wrap(hss0)
    ch5_rxgearboxslip             => ch5_rxgearboxslip2            , -- MSR: hss_phy_wrap(hss0)
    ch6_rxgearboxslip             => ch6_rxgearboxslip2            , -- MSR: hss_phy_wrap(hss0)
    ch7_rxgearboxslip             => ch7_rxgearboxslip2            , -- MSR: hss_phy_wrap(hss0)
    gtwiz_buffbypass_rx_done_in   => gtwiz_buffbypass_rx_done_in2  , -- MSD: hss_phy_wrap(hss0)
    gtwiz_buffbypass_tx_done_in   => gtwiz_buffbypass_tx_done_in2  , -- MSD: hss_phy_wrap(hss0)
    gtwiz_reset_all_out           => gtwiz_reset_all_out2          , -- MSR: hss_phy_wrap(hss0)
    gtwiz_reset_rx_datapath_out   => gtwiz_reset_rx_datapath_out2  , -- MSR: hss_phy_wrap(hss0)
    gtwiz_reset_rx_done_in        => gtwiz_reset_rx_done_in2       , -- MSD: hss_phy_wrap(hss0)
    gtwiz_reset_tx_done_in        => gtwiz_reset_tx_done_in2       , -- MSD: hss_phy_wrap(hss0)
    gtwiz_userclk_rx_active_in    => gtwiz_userclk_rx_active_in2   , -- MSD: hss_phy_wrap(hss0)
    gtwiz_userclk_tx_active_in    => gtwiz_userclk_tx_active_in2   , -- MSD: hss_phy_wrap(hss0)
    hb0_gtwiz_userdata_rx         => hb0_gtwiz_userdata_rx2        , -- MSD: hss_phy_wrap(hss0)
    hb1_gtwiz_userdata_rx         => hb1_gtwiz_userdata_rx2        , -- MSD: hss_phy_wrap(hss0)
    hb2_gtwiz_userdata_rx         => hb2_gtwiz_userdata_rx2        , -- MSD: hss_phy_wrap(hss0)
    hb3_gtwiz_userdata_rx         => hb3_gtwiz_userdata_rx2        , -- MSD: hss_phy_wrap(hss0)
    hb4_gtwiz_userdata_rx         => hb4_gtwiz_userdata_rx2        , -- MSD: hss_phy_wrap(hss0)
    hb5_gtwiz_userdata_rx         => hb5_gtwiz_userdata_rx2        , -- MSD: hss_phy_wrap(hss0)
    hb6_gtwiz_userdata_rx         => hb6_gtwiz_userdata_rx2        , -- MSD: hss_phy_wrap(hss0)
    hb7_gtwiz_userdata_rx         => hb7_gtwiz_userdata_rx2        , -- MSD: hss_phy_wrap(hss0)
    hb_gtwiz_reset_all_in         => hb_gtwiz_reset_all_in2        , -- MSD: hss_phy_wrap(hss0)
    cclk                          => cclk_c                        , -- MSD: hss_phy_wrap(hss0)
    hb_gtwiz_reset_clk_freerun_buf_int                    => hb_gtwiz_reset_clk_freerun_buf_int                    , -- MSR: hss_phy_wrap(hss0)
    rclk                          => rclk                            -- MSD: hss_phy_wrap(hss0)
);

-- hss3 was calling hss_phy_wrap1 - renamed to hss_phy_wrap3
hss3 : entity work.hss_phy_wrap3
port map (
    mgtrefclk0_x0y0_p             => mgtrefclk3_x0y0_p             , -- MSR: hss_phy_wrap(hss0)
    mgtrefclk0_x0y0_n             => mgtrefclk3_x0y0_n             , -- MSR: hss_phy_wrap(hss0)
    mgtrefclk0_x0y1_p             => mgtrefclk3_x0y1_p             , -- MSR: hss_phy_wrap(hss0)
    mgtrefclk0_x0y1_n             => mgtrefclk3_x0y1_n             , -- MSR: hss_phy_wrap(hss0)
    ch0_gtyrxn_in                 => ch0_gtyrxn3_in                , -- MSR: hss_phy_wrap(hss0)
    ch0_gtyrxp_in                 => ch0_gtyrxp3_in                , -- MSR: hss_phy_wrap(hss0)
    ch0_gtytxn_out                => ch0_gtytxn3_out               , -- MSD: hss_phy_wrap(hss0)
    ch0_gtytxp_out                => ch0_gtytxp3_out               , -- MSD: hss_phy_wrap(hss0)
    ch1_gtyrxn_in                 => ch1_gtyrxn3_in                , -- MSR: hss_phy_wrap(hss0)
    ch1_gtyrxp_in                 => ch1_gtyrxp3_in                , -- MSR: hss_phy_wrap(hss0)
    ch1_gtytxn_out                => ch1_gtytxn3_out               , -- MSD: hss_phy_wrap(hss0)
    ch1_gtytxp_out                => ch1_gtytxp3_out               , -- MSD: hss_phy_wrap(hss0)
    ch2_gtyrxn_in                 => ch2_gtyrxn3_in                , -- MSR: hss_phy_wrap(hss0)
    ch2_gtyrxp_in                 => ch2_gtyrxp3_in                , -- MSR: hss_phy_wrap(hss0)
    ch2_gtytxn_out                => ch2_gtytxn3_out               , -- MSD: hss_phy_wrap(hss0)
    ch2_gtytxp_out                => ch2_gtytxp3_out               , -- MSD: hss_phy_wrap(hss0)
    ch3_gtyrxn_in                 => ch3_gtyrxn3_in                , -- MSR: hss_phy_wrap(hss0)
    ch3_gtyrxp_in                 => ch3_gtyrxp3_in                , -- MSR: hss_phy_wrap(hss0)
    ch3_gtytxn_out                => ch3_gtytxn3_out               , -- MSD: hss_phy_wrap(hss0)
    ch3_gtytxp_out                => ch3_gtytxp3_out               , -- MSD: hss_phy_wrap(hss0)
    ch4_gtyrxn_in                 => ch4_gtyrxn3_in                , -- MSR: hss_phy_wrap(hss0)
    ch4_gtyrxp_in                 => ch4_gtyrxp3_in                , -- MSR: hss_phy_wrap(hss0)
    ch4_gtytxn_out                => ch4_gtytxn3_out               , -- MSD: hss_phy_wrap(hss0)
    ch4_gtytxp_out                => ch4_gtytxp3_out               , -- MSD: hss_phy_wrap(hss0)
    ch5_gtyrxn_in                 => ch5_gtyrxn3_in                , -- MSR: hss_phy_wrap(hss0)
    ch5_gtyrxp_in                 => ch5_gtyrxp3_in                , -- MSR: hss_phy_wrap(hss0)
    ch5_gtytxn_out                => ch5_gtytxn3_out               , -- MSD: hss_phy_wrap(hss0)
    ch5_gtytxp_out                => ch5_gtytxp3_out               , -- MSD: hss_phy_wrap(hss0)
    ch6_gtyrxn_in                 => ch6_gtyrxn3_in                , -- MSR: hss_phy_wrap(hss0)
    ch6_gtyrxp_in                 => ch6_gtyrxp3_in                , -- MSR: hss_phy_wrap(hss0)
    ch6_gtytxn_out                => ch6_gtytxn3_out               , -- MSD: hss_phy_wrap(hss0)
    ch6_gtytxp_out                => ch6_gtytxp3_out               , -- MSD: hss_phy_wrap(hss0)
    ch7_gtyrxn_in                 => ch7_gtyrxn3_in                , -- MSR: hss_phy_wrap(hss0)
    ch7_gtyrxp_in                 => ch7_gtyrxp3_in                , -- MSR: hss_phy_wrap(hss0)
    ch7_gtytxn_out                => ch7_gtytxn3_out               , -- MSD: hss_phy_wrap(hss0)
    ch7_gtytxp_out                => ch7_gtytxp3_out               , -- MSD: hss_phy_wrap(hss0)
    ch0_txheader                  => ch0_txheader3                 , -- MSR: hss_phy_wrap(hss0)
    ch1_txheader                  => ch1_txheader3                 , -- MSR: hss_phy_wrap(hss0)
    ch2_txheader                  => ch2_txheader3                 , -- MSR: hss_phy_wrap(hss0)
    ch3_txheader                  => ch3_txheader3                 , -- MSR: hss_phy_wrap(hss0)
    ch4_txheader                  => ch4_txheader3                 , -- MSR: hss_phy_wrap(hss0)
    ch5_txheader                  => ch5_txheader3                 , -- MSR: hss_phy_wrap(hss0)
    ch6_txheader                  => ch6_txheader3                 , -- MSR: hss_phy_wrap(hss0)
    ch7_txheader                  => ch7_txheader3                 , -- MSR: hss_phy_wrap(hss0)
    ch0_txsequence                => ch0_txsequence3               , -- MSR: hss_phy_wrap(hss0)
    ch1_txsequence                => ch1_txsequence3               , -- MSR: hss_phy_wrap(hss0)
    ch2_txsequence                => ch2_txsequence3               , -- MSR: hss_phy_wrap(hss0)
    ch3_txsequence                => ch3_txsequence3               , -- MSR: hss_phy_wrap(hss0)
    ch4_txsequence                => ch4_txsequence3               , -- MSR: hss_phy_wrap(hss0)
    ch5_txsequence                => ch5_txsequence3               , -- MSR: hss_phy_wrap(hss0)
    ch6_txsequence                => ch6_txsequence3               , -- MSR: hss_phy_wrap(hss0)
    ch7_txsequence                => ch7_txsequence3               , -- MSR: hss_phy_wrap(hss0)
    hb0_gtwiz_userdata_tx         => hb0_gtwiz_userdata_tx3        , -- MSR: hss_phy_wrap(hss0)
    hb1_gtwiz_userdata_tx         => hb1_gtwiz_userdata_tx3        , -- MSR: hss_phy_wrap(hss0)
    hb2_gtwiz_userdata_tx         => hb2_gtwiz_userdata_tx3        , -- MSR: hss_phy_wrap(hss0)
    hb3_gtwiz_userdata_tx         => hb3_gtwiz_userdata_tx3        , -- MSR: hss_phy_wrap(hss0)
    hb4_gtwiz_userdata_tx         => hb4_gtwiz_userdata_tx3        , -- MSR: hss_phy_wrap(hss0)
    hb5_gtwiz_userdata_tx         => hb5_gtwiz_userdata_tx3        , -- MSR: hss_phy_wrap(hss0)
    hb6_gtwiz_userdata_tx         => hb6_gtwiz_userdata_tx3        , -- MSR: hss_phy_wrap(hss0)
    hb7_gtwiz_userdata_tx         => hb7_gtwiz_userdata_tx3        , -- MSR: hss_phy_wrap(hss0)
    ch0_rxdatavalid               => ch0_rxdatavalid3              , -- MSD: hss_phy_wrap(hss0)
    ch1_rxdatavalid               => ch1_rxdatavalid3              , -- MSD: hss_phy_wrap(hss0)
    ch2_rxdatavalid               => ch2_rxdatavalid3              , -- MSD: hss_phy_wrap(hss0)
    ch3_rxdatavalid               => ch3_rxdatavalid3              , -- MSD: hss_phy_wrap(hss0)
    ch4_rxdatavalid               => ch4_rxdatavalid3              , -- MSD: hss_phy_wrap(hss0)
    ch5_rxdatavalid               => ch5_rxdatavalid3              , -- MSD: hss_phy_wrap(hss0)
    ch6_rxdatavalid               => ch6_rxdatavalid3              , -- MSD: hss_phy_wrap(hss0)
    ch7_rxdatavalid               => ch7_rxdatavalid3              , -- MSD: hss_phy_wrap(hss0)
    ch0_rxheader                  => ch0_rxheader3                 , -- MSD: hss_phy_wrap(hss0)
    ch1_rxheader                  => ch1_rxheader3                 , -- MSD: hss_phy_wrap(hss0)
    ch2_rxheader                  => ch2_rxheader3                 , -- MSD: hss_phy_wrap(hss0)
    ch3_rxheader                  => ch3_rxheader3                 , -- MSD: hss_phy_wrap(hss0)
    ch4_rxheader                  => ch4_rxheader3                 , -- MSD: hss_phy_wrap(hss0)
    ch5_rxheader                  => ch5_rxheader3                 , -- MSD: hss_phy_wrap(hss0)
    ch6_rxheader                  => ch6_rxheader3                 , -- MSD: hss_phy_wrap(hss0)
    ch7_rxheader                  => ch7_rxheader3                 , -- MSD: hss_phy_wrap(hss0)
    ch0_rxgearboxslip             => ch0_rxgearboxslip3            , -- MSR: hss_phy_wrap(hss0)
    ch1_rxgearboxslip             => ch1_rxgearboxslip3            , -- MSR: hss_phy_wrap(hss0)
    ch2_rxgearboxslip             => ch2_rxgearboxslip3            , -- MSR: hss_phy_wrap(hss0)
    ch3_rxgearboxslip             => ch3_rxgearboxslip3            , -- MSR: hss_phy_wrap(hss0)
    ch4_rxgearboxslip             => ch4_rxgearboxslip3            , -- MSR: hss_phy_wrap(hss0)
    ch5_rxgearboxslip             => ch5_rxgearboxslip3            , -- MSR: hss_phy_wrap(hss0)
    ch6_rxgearboxslip             => ch6_rxgearboxslip3            , -- MSR: hss_phy_wrap(hss0)
    ch7_rxgearboxslip             => ch7_rxgearboxslip3            , -- MSR: hss_phy_wrap(hss0)
    gtwiz_buffbypass_rx_done_in   => gtwiz_buffbypass_rx_done_in3  , -- MSD: hss_phy_wrap(hss0)
    gtwiz_buffbypass_tx_done_in   => gtwiz_buffbypass_tx_done_in3  , -- MSD: hss_phy_wrap(hss0)
    gtwiz_reset_all_out           => gtwiz_reset_all_out3          , -- MSR: hss_phy_wrap(hss0)
    gtwiz_reset_rx_datapath_out   => gtwiz_reset_rx_datapath_out3  , -- MSR: hss_phy_wrap(hss0)
    gtwiz_reset_rx_done_in        => gtwiz_reset_rx_done_in3       , -- MSD: hss_phy_wrap(hss0)
    gtwiz_reset_tx_done_in        => gtwiz_reset_tx_done_in3       , -- MSD: hss_phy_wrap(hss0)
    gtwiz_userclk_rx_active_in    => gtwiz_userclk_rx_active_in3   , -- MSD: hss_phy_wrap(hss0)
    gtwiz_userclk_tx_active_in    => gtwiz_userclk_tx_active_in3   , -- MSD: hss_phy_wrap(hss0)
    hb0_gtwiz_userdata_rx         => hb0_gtwiz_userdata_rx3        , -- MSD: hss_phy_wrap(hss0)
    hb1_gtwiz_userdata_rx         => hb1_gtwiz_userdata_rx3        , -- MSD: hss_phy_wrap(hss0)
    hb2_gtwiz_userdata_rx         => hb2_gtwiz_userdata_rx3        , -- MSD: hss_phy_wrap(hss0)
    hb3_gtwiz_userdata_rx         => hb3_gtwiz_userdata_rx3        , -- MSD: hss_phy_wrap(hss0)
    hb4_gtwiz_userdata_rx         => hb4_gtwiz_userdata_rx3        , -- MSD: hss_phy_wrap(hss0)
    hb5_gtwiz_userdata_rx         => hb5_gtwiz_userdata_rx3        , -- MSD: hss_phy_wrap(hss0)
    hb6_gtwiz_userdata_rx         => hb6_gtwiz_userdata_rx3        , -- MSD: hss_phy_wrap(hss0)
    hb7_gtwiz_userdata_rx         => hb7_gtwiz_userdata_rx3        , -- MSD: hss_phy_wrap(hss0)
    hb_gtwiz_reset_all_in         => hb_gtwiz_reset_all_in3        , -- MSD: hss_phy_wrap(hss0)
    cclk                          => cclk_d                        , -- MSD: hss_phy_wrap(hss0)
    hb_gtwiz_reset_clk_freerun_buf_int                    => hb_gtwiz_reset_clk_freerun_buf_int                    , -- MSR: hss_phy_wrap(hss0)
    rclk                          => open                            -- MSD: hss_phy_wrap(hss0)
);

IBUFDS_freerun : IBUFDS
port map (
   O  => phy_freerun_clk,   -- 1-bit output: Buffer output
   I  => raw_rclk_p, -- 1-bit input: Diff_p buffer input (connect directly to top-level port)
   IB => raw_rclk_n  -- 1-bit input: Diff_n buffer input (connect directly to top-level port)
);

BUFGCE_DIV_inst : BUFGCE_DIV
generic map (
   BUFGCE_DIVIDE => 2,      -- 1-8
   -- Programmable Inversion Attributes: Specifies built-in programmable inversion on specific pins
   IS_CE_INVERTED  => '0',  -- Optional inversion for CE
   IS_CLR_INVERTED => '0', -- Optional inversion for CLR
   IS_I_INVERTED   => '0'    -- Optional inversion for I
)
port map (
   O   => hb_gtwiz_reset_clk_freerun_buf_int, -- 1-bit output: Buffer
   CE  => '1',                                -- 1-bit input: Buffer enable
   CLR => '0',                                -- 1-bit input: Asynchronous clear
   I   => phy_freerun_clk                         -- 1-bit input: Buffer
);
end fire_top;
