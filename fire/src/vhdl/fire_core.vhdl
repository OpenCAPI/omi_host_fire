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
use ibm.std_ulogic_support.all;
use ibm.std_ulogic_function_support.all;
use support.logic_support_pkg.all;
use work.axi_pkg.all;

entity fire_core is
  port (
    ---------------------------------------------------------------------------
    -- Clocking & Reset
    ---------------------------------------------------------------------------
    sys_resetn                     : in std_ulogic;
    cresetn                        : in std_ulogic;
    sysclk                         : in std_ulogic;
    cclk                           : in std_ulogic;
    rclk                           : in std_ulogic;
    ocde                           : in std_ulogic;
    tsm_state2_to_3 : in std_ulogic;
    tsm_state6_to_1 : in std_ulogic;
    tsm_state4_to_5 : in std_ulogic;
    tsm_state5_to_6 : in std_ulogic;
    o_dlx_reset     : OUT std_ulogic;
    lane_force_unlock : in std_ulogic_vector(7 downto 0);
    ---------------------------------------------------------------------------
    -- Transciever Data
    ---------------------------------------------------------------------------
    -- Port 0
    -- TX
    dlx_l0_tx_data                 : out std_ulogic_vector(63 downto 0);
    dlx_l0_tx_header               : out std_ulogic_vector(1 downto 0);
    dlx_l0_tx_seq                  : out std_ulogic_vector(5 downto 0);
    dlx_l1_tx_data                 : out std_ulogic_vector(63 downto 0);
    dlx_l1_tx_header               : out std_ulogic_vector(1 downto 0);
    dlx_l1_tx_seq                  : out std_ulogic_vector(5 downto 0);
    dlx_l2_tx_data                 : out std_ulogic_vector(63 downto 0);
    dlx_l2_tx_header               : out std_ulogic_vector(1 downto 0);
    dlx_l2_tx_seq                  : out std_ulogic_vector(5 downto 0);
    dlx_l3_tx_data                 : out std_ulogic_vector(63 downto 0);
    dlx_l3_tx_header               : out std_ulogic_vector(1 downto 0);
    dlx_l3_tx_seq                  : out std_ulogic_vector(5 downto 0);
    dlx_l4_tx_data                 : out std_ulogic_vector(63 downto 0);
    dlx_l4_tx_header               : out std_ulogic_vector(1 downto 0);
    dlx_l4_tx_seq                  : out std_ulogic_vector(5 downto 0);
    dlx_l5_tx_data                 : out std_ulogic_vector(63 downto 0);
    dlx_l5_tx_header               : out std_ulogic_vector(1 downto 0);
    dlx_l5_tx_seq                  : out std_ulogic_vector(5 downto 0);
    dlx_l6_tx_data                 : out std_ulogic_vector(63 downto 0);
    dlx_l6_tx_header               : out std_ulogic_vector(1 downto 0);
    dlx_l6_tx_seq                  : out std_ulogic_vector(5 downto 0);
    dlx_l7_tx_data                 : out std_ulogic_vector(63 downto 0);
    dlx_l7_tx_header               : out std_ulogic_vector(1 downto 0);
    dlx_l7_tx_seq                  : out std_ulogic_vector(5 downto 0);
    -- RX
    ln0_rx_data                    : in std_ulogic_vector(63 downto 0);
    ln0_rx_header                  : in std_ulogic_vector(1 downto 0);
    ln0_rx_slip                    : out std_ulogic;
    ln0_rx_valid                   : in std_ulogic;
    ln1_rx_data                    : in std_ulogic_vector(63 downto 0);
    ln1_rx_header                  : in std_ulogic_vector(1 downto 0);
    ln1_rx_slip                    : out std_ulogic;
    ln1_rx_valid                   : in std_ulogic;
    ln2_rx_data                    : in std_ulogic_vector(63 downto 0);
    ln2_rx_header                  : in std_ulogic_vector(1 downto 0);
    ln2_rx_slip                    : out std_ulogic;
    ln2_rx_valid                   : in std_ulogic;
    ln3_rx_data                    : in std_ulogic_vector(63 downto 0);
    ln3_rx_header                  : in std_ulogic_vector(1 downto 0);
    ln3_rx_slip                    : out std_ulogic;
    ln3_rx_valid                   : in std_ulogic;
    ln4_rx_data                    : in std_ulogic_vector(63 downto 0);
    ln4_rx_header                  : in std_ulogic_vector(1 downto 0);
    ln4_rx_slip                    : out std_ulogic;
    ln4_rx_valid                   : in std_ulogic;
    ln5_rx_data                    : in std_ulogic_vector(63 downto 0);
    ln5_rx_header                  : in std_ulogic_vector(1 downto 0);
    ln5_rx_slip                    : out std_ulogic;
    ln5_rx_valid                   : in std_ulogic;
    ln6_rx_data                    : in std_ulogic_vector(63 downto 0);
    ln6_rx_header                  : in std_ulogic_vector(1 downto 0);
    ln6_rx_slip                    : out std_ulogic;
    ln6_rx_valid                   : in std_ulogic;
    ln7_rx_data                    : in std_ulogic_vector(63 downto 0);
    ln7_rx_header                  : in std_ulogic_vector(1 downto 0);
    ln7_rx_slip                    : out std_ulogic;
    ln7_rx_valid                   : in std_ulogic;

    ---------------------------------------------------------------------------
    -- Transciever Reset
    ---------------------------------------------------------------------------
    gtwiz_buffbypass_rx_done_in    : in std_ulogic;
    gtwiz_buffbypass_tx_done_in    : in std_ulogic;
    gtwiz_reset_all_out            : out std_ulogic;
    gtwiz_reset_rx_datapath_out    : out std_ulogic;
    gtwiz_reset_rx_done_in         : in std_ulogic;
    gtwiz_reset_tx_done_in         : in std_ulogic;
    gtwiz_userclk_rx_active_in     : in std_ulogic;
    gtwiz_userclk_tx_active_in     : in std_ulogic;
    hb_gtwiz_reset_all_in          : in std_ulogic;

    ---------------------------------------------------------------------------
    -- Registers
    ---------------------------------------------------------------------------
    oc_memory0_axis_aclk           : in std_ulogic;
    oc_memory0_axis_i              : in t_AXI3_SLAVE_INPUT;
    oc_memory0_axis_o              : out t_AXI3_SLAVE_OUTPUT;
    oc_mmio0_axis_aclk             : in std_ulogic;
    oc_mmio0_axis_i                : in t_AXI3_SLAVE_INPUT;
    oc_mmio0_axis_o                : out t_AXI3_SLAVE_OUTPUT;
    oc_cfg0_axis_aclk              : in std_ulogic;
    oc_cfg0_axis_i                 : in t_AXI3_SLAVE_INPUT;
    oc_cfg0_axis_o                 : out t_AXI3_SLAVE_OUTPUT;
    c3s_dlx_axis_aclk              : in std_ulogic;
    c3s_dlx_axis_i                 : in t_AXI4_LITE_SLAVE_INPUT;
    c3s_dlx_axis_o                 : out t_AXI4_LITE_SLAVE_OUTPUT;
    fbist_axis_aclk                : in std_ulogic;
    fbist_axis_i                   : in t_AXI4_LITE_SLAVE_INPUT;
    fbist_axis_o                   : out t_AXI4_LITE_SLAVE_OUTPUT;
    oc_host_cfg0_axis_aclk         : in std_ulogic;
    oc_host_cfg0_axis_i            : in t_AXI4_LITE_SLAVE_INPUT;
    oc_host_cfg0_axis_o            : out t_AXI4_LITE_SLAVE_OUTPUT
    );

  attribute BLOCK_TYPE of fire_core : entity is SOFT;
  attribute BTR_NAME of fire_core : entity is "FIRE_CORE";
  attribute RECURSIVE_SYNTHESIS of fire_core : entity is 2;
  attribute PIN_DEFAULT_GROUND_DOMAIN of fire_core : entity is "GND";
  attribute PIN_DEFAULT_POWER_DOMAIN of fire_core : entity is "VDD";
end fire_core;

architecture fire_core of fire_core is

  SIGNAL dlx_config_info : std_ulogic_vector(31 downto 0);
  SIGNAL dlx_tlx_flit : std_ulogic_vector(511 downto 0);
  SIGNAL dlx_tlx_flit_crc_err : std_ulogic;
  SIGNAL dlx_tlx_flit_credit : std_ulogic;
  SIGNAL dlx_tlx_flit_valid : std_ulogic;
  SIGNAL dlx_tlx_flit_valid_gate : std_ulogic;
  SIGNAL dlx_tlx_init_flit_depth : std_ulogic_vector(2 downto 0);
  SIGNAL dlx_tlx_link_up : std_ulogic;
  SIGNAL tlx_dlx_debug_encode : std_ulogic_vector(3 downto 0);
  SIGNAL tlx_dlx_debug_info : std_ulogic_vector(31 downto 0);
  SIGNAL tlx_dlx_flit : std_ulogic_vector(511 downto 0);
  SIGNAL tlx_dlx_flit_valid : std_ulogic;
  SIGNAL send_first : std_ulogic;
  SIGNAL c3s_dlx_command_sel : std_ulogic;
  SIGNAL c3s_dlx_command_valid : std_ulogic;
  SIGNAL c3s_dlx_command : std_ulogic_vector(511 downto 0);
  SIGNAL c3s_dlx_response_valid : std_ulogic;
  SIGNAL c3s_dlx_response : std_ulogic_vector(511 downto 0);
  SIGNAL sys_reset : std_ulogic;
  SIGNAL afu_tlx_cmd_credit : std_ulogic;
  SIGNAL afu_tlx_cmd_initial_credit : std_ulogic_vector(6 downto 0);
  SIGNAL afu_tlx_cmd_rd_cnt : std_ulogic_vector(2 downto 0);
  SIGNAL afu_tlx_cmd_rd_req : std_ulogic;
  SIGNAL afu_tlx_rdata_bdi : std_ulogic;
  SIGNAL afu_tlx_rdata_bus : std_ulogic_vector(511 downto 0);
  SIGNAL afu_tlx_rdata_valid : std_ulogic;
  SIGNAL afu_tlx_resp_capptag : std_ulogic_vector(15 downto 0);
  SIGNAL afu_tlx_resp_code : std_ulogic_vector(3 downto 0);
  SIGNAL afu_tlx_resp_dl : std_ulogic_vector(1 downto 0);
  SIGNAL afu_tlx_resp_dp : std_ulogic_vector(1 downto 0);
  SIGNAL afu_tlx_resp_opcode : std_ulogic_vector(7 downto 0);
  SIGNAL afu_tlx_resp_valid : std_ulogic;
  SIGNAL cfg_tlx_credit_return : std_ulogic;
  SIGNAL cfg_tlx_initial_credit : std_ulogic_vector(3 downto 0);
  SIGNAL cfg_tlx_rdata_bdi : std_ulogic;
  SIGNAL cfg_tlx_rdata_bus : std_ulogic_vector(31 downto 0);
  SIGNAL cfg_tlx_rdata_offset : std_ulogic_vector(3 downto 0);
  SIGNAL cfg_tlx_resp_capptag : std_ulogic_vector(15 downto 0);
  SIGNAL cfg_tlx_resp_code : std_ulogic_vector(3 downto 0);
  SIGNAL cfg_tlx_resp_opcode : std_ulogic_vector(7 downto 0);
  SIGNAL cfg_tlx_resp_valid : std_ulogic;
  SIGNAL cfg_tlx_xmit_rate_config_0 : std_ulogic_vector(3 downto 0);
  SIGNAL cfg_tlx_xmit_rate_config_1 : std_ulogic_vector(3 downto 0);
  SIGNAL cfg_tlx_xmit_rate_config_2 : std_ulogic_vector(3 downto 0);
  SIGNAL cfg_tlx_xmit_rate_config_3 : std_ulogic_vector(3 downto 0);
  SIGNAL cfg_tlx_xmit_tmpl_config_0 : std_ulogic;
  SIGNAL cfg_tlx_xmit_tmpl_config_1 : std_ulogic;
  SIGNAL cfg_tlx_xmit_tmpl_config_2 : std_ulogic;
  SIGNAL cfg_tlx_xmit_tmpl_config_3 : std_ulogic;
  SIGNAL tlx_afu_cmd_be : std_ulogic_vector(63 downto 0);
  SIGNAL tlx_afu_cmd_capptag : std_ulogic_vector(15 downto 0);
  SIGNAL tlx_afu_cmd_data_bdi : std_ulogic;
  SIGNAL tlx_afu_cmd_data_bus : std_ulogic_vector(511 downto 0);
  SIGNAL tlx_afu_cmd_data_valid : std_ulogic;
  SIGNAL tlx_afu_cmd_dl : std_ulogic_vector(1 downto 0);
  SIGNAL tlx_afu_cmd_end : std_ulogic;
  SIGNAL tlx_afu_cmd_flag : std_ulogic_vector(3 downto 0);
  SIGNAL tlx_afu_cmd_opcode : std_ulogic_vector(7 downto 0);
  SIGNAL tlx_afu_cmd_os : std_ulogic;
  SIGNAL tlx_afu_cmd_pa : std_ulogic_vector(63 downto 0);
  SIGNAL tlx_afu_cmd_pl : std_ulogic_vector(2 downto 0);
  SIGNAL tlx_afu_cmd_valid : std_ulogic;
  SIGNAL tlx_afu_ready : std_ulogic;
  SIGNAL tlx_afu_resp_credit : std_ulogic;
  SIGNAL tlx_afu_resp_data_credit : std_ulogic;
  SIGNAL tlx_cfg_capptag : std_ulogic_vector(15 downto 0);
  SIGNAL tlx_cfg_data_bdi : std_ulogic;
  SIGNAL tlx_cfg_data_bus : std_ulogic_vector(31 downto 0);
  SIGNAL tlx_cfg_in_rcv_rate_capability_0 : std_ulogic_vector(3 downto 0);
  SIGNAL tlx_cfg_in_rcv_rate_capability_1 : std_ulogic_vector(3 downto 0);
  SIGNAL tlx_cfg_in_rcv_rate_capability_2 : std_ulogic_vector(3 downto 0);
  SIGNAL tlx_cfg_in_rcv_rate_capability_3 : std_ulogic_vector(3 downto 0);
  SIGNAL tlx_cfg_in_rcv_tmpl_capability_0 : std_ulogic;
  SIGNAL tlx_cfg_in_rcv_tmpl_capability_1 : std_ulogic;
  SIGNAL tlx_cfg_in_rcv_tmpl_capability_2 : std_ulogic;
  SIGNAL tlx_cfg_in_rcv_tmpl_capability_3 : std_ulogic;
  SIGNAL tlx_cfg_oc3_tlx_version : std_ulogic_vector(31 downto 0);
  SIGNAL tlx_cfg_opcode : std_ulogic_vector(7 downto 0);
  SIGNAL tlx_cfg_pa : std_ulogic_vector(63 downto 0);
  SIGNAL tlx_cfg_pl : std_ulogic_vector(2 downto 0);
  SIGNAL tlx_cfg_t : std_ulogic;
  SIGNAL tlx_cfg_valid : std_ulogic;
  SIGNAL tlx_dlx_flit_int : std_ulogic_vector(511 downto 0);
  SIGNAL tlx_dlx_flit_valid_int : std_ulogic;
  SIGNAL c3s_dlx_axis_i_pipe_in : t_AXI4_LITE_SLAVE_INPUT;
  SIGNAL c3s_dlx_axis_i_pipe_out : t_AXI4_LITE_SLAVE_INPUT;
  SIGNAL c3s_dlx_axis_o_pipe_in : t_AXI4_LITE_SLAVE_OUTPUT;
  SIGNAL c3s_dlx_axis_o_pipe_out : t_AXI4_LITE_SLAVE_OUTPUT;
  SIGNAL fbist_axis_i_pipe_in : t_AXI4_LITE_SLAVE_INPUT;
  SIGNAL fbist_axis_i_pipe_out : t_AXI4_LITE_SLAVE_INPUT;
  SIGNAL fbist_axis_o_pipe_in : t_AXI4_LITE_SLAVE_OUTPUT;
  SIGNAL fbist_axis_o_pipe_out : t_AXI4_LITE_SLAVE_OUTPUT;
  SIGNAL oc_host_cfg0_axis_i_pipe_in : t_AXI4_LITE_SLAVE_INPUT;
  SIGNAL oc_host_cfg0_axis_i_pipe_out : t_AXI4_LITE_SLAVE_INPUT;
  SIGNAL oc_host_cfg0_axis_o_pipe_in : t_AXI4_LITE_SLAVE_OUTPUT;
  SIGNAL oc_host_cfg0_axis_o_pipe_out : t_AXI4_LITE_SLAVE_OUTPUT;
  SIGNAL oc_mmio0_axis_i_pipe_in : t_AXI3_SLAVE_INPUT;
  SIGNAL oc_mmio0_axis_i_pipe_out : t_AXI3_SLAVE_INPUT;
  SIGNAL oc_mmio0_axis_o_pipe_in : t_AXI3_SLAVE_OUTPUT;
  SIGNAL oc_mmio0_axis_o_pipe_out : t_AXI3_SLAVE_OUTPUT;
  SIGNAL oc_memory0_axis_i_pipe_in : t_AXI3_SLAVE_INPUT;
  SIGNAL oc_memory0_axis_i_pipe_out : t_AXI3_SLAVE_INPUT;
  SIGNAL oc_memory0_axis_o_pipe_in : t_AXI3_SLAVE_OUTPUT;
  SIGNAL oc_memory0_axis_o_pipe_out : t_AXI3_SLAVE_OUTPUT;
  SIGNAL oc_cfg0_axis_i_pipe_in : t_AXI3_SLAVE_INPUT;
  SIGNAL oc_cfg0_axis_i_pipe_out : t_AXI3_SLAVE_INPUT;
  SIGNAL oc_cfg0_axis_o_pipe_in : t_AXI3_SLAVE_OUTPUT;
  SIGNAL oc_cfg0_axis_o_pipe_out : t_AXI3_SLAVE_OUTPUT;
  SIGNAL fbist_oc_axim_aclk : std_ulogic;
  SIGNAL fbist_oc_axim_i : t_AXI3_512_MASTER_INPUT;
  SIGNAL fbist_oc_axim_o : t_AXI3_512_MASTER_OUTPUT;
  SIGNAL oc_fbist_axis_aclk : std_ulogic;
  SIGNAL oc_fbist_axis_i : t_AXI3_512_SLAVE_INPUT;
  SIGNAL oc_fbist_axis_o : t_AXI3_512_SLAVE_OUTPUT;
  SIGNAL cfg_tlx_xmit_tmpl_config : std_ulogic_vector(31 downto 0);
  SIGNAL reg_01_update_i: std_ulogic_vector(31 downto 0);
  SIGNAL reg_01_hwwe_i : std_ulogic;
  SIGNAL reg_01_o      : std_ulogic_vector(31 downto 0);
  SIGNAL reg_02_update_i: std_ulogic_vector(31 downto 0);
  SIGNAL reg_02_hwwe_i : std_ulogic;
  SIGNAL reg_02_o      : std_ulogic_vector(31 downto 0);
  SIGNAL reg_03_o      : std_ulogic_vector(31 downto 0);
  SIGNAL reg_04_value_o : std_ulogic_vector(31 downto 0);
  SIGNAL reg_04_update_i : std_ulogic_vector(31 downto 0);
  SIGNAL reg_04_hwwe_i   : std_ulogic;
  SIGNAL reg_05_update_i : std_ulogic_vector(31 downto 0);
  SIGNAL reg_05_hwwe_i   : std_ulogic;
  SIGNAL reg_06_update_i : std_ulogic_vector(31 downto 0);
  SIGNAL reg_06_hwwe_i   : std_ulogic;
  SIGNAL reg_07_update_i : std_ulogic_vector(31 downto 0);
  SIGNAL reg_07_hwwe_i   : std_ulogic;
  SIGNAL dl_debug_vector : std_ulogic_vector(127 downto 0);
  SIGNAL creset : std_ulogic;
  SIGNAL i_dlx_tlx_flit_valid   : std_ulogic;                       -- [in]
  SIGNAL i_dlx_tlx_flit         : std_ulogic_vector(511 downto 0);  -- [in]
  SIGNAL i_dlx_tlx_flit_crc_err : std_ulogic;                       -- [in]
  SIGNAL i_dlx_tlx_link_up      : std_ulogic;                       -- [in]
  SIGNAL c3s_dlx_command_staged : std_ulogic_vector(511 downto 0);
  SIGNAL c3s_dlx_command_valid_staged : std_ulogic;
  SIGNAL c3s_dlx_command_sel_staged : std_ulogic;
  SIGNAL c3s_dlx_response_staged : std_ulogic_vector(511 downto 0);
  SIGNAL c3s_dlx_response_valid_staged : std_ulogic;

  signal c3s_tl_gate_bit                : std_ulogic;
  signal c3s_tl_gate_bit_staged         : std_ulogic;
 
begin

  
  sys_reset <= not sys_resetn;
  creset  <= not cresetn;

  --reg_04_val(31 DOWNTO 0) <= x"04000045";
                                                   --31:27  reserved
                                                   --26     EDPL enable (enabled by default)
                                                   --25     EDPL Max Counter Reset 
                                                   --24:16  reserved
                                                   --15:8   EDPL Inject per lane
                                                   --7      reserved
                                                   --6:4    EDPL error threshold
                                                            --3'b000 -->  disabled
                                                            --3'b001 -->  2 errors
                                                            --3'b010 -->  4 errors
                                                            --3'b011 -->  8 errors
                                                            --3'b100 --> 16 errors (default)
                                                            --3'b101 --> 32 errors
                                                            --3'b110 --> 64 errors
                                                            --3'b111 -->128 errors   
                                                   --3:0    EDPL Time window      
                                                            --  4'b0000--> no time window 
                                                            --  4'b0001-->   4 us
                                                            --  4'b0010-->  32 us
                                                            --  4'b0011--> 256 us
                                                            --  4'b0100-->   2 ms
                                                            --  4'b0101-->  16 ms (default)
                                                            --  4'b0110--> 128 ms
                                                            --  4'b0111-->   1  s
                                                            --  4'b1000-->   8  s
                                                            --  4'b1001-->  64  s
                                                            --  4'b1010--> 512  s
                                                            --  4'b1011-->   4 ks
                                                            --  4'b1100-->  32 ks
                                                            --  4'b1101--> 256 ks
                                                            --  4'b1110-->   2 Ms
                                                            --  4'b1111-->  16 Ms
  -- AXI Routing
  oc_memory0_axis_i_pipe_in   <= oc_memory0_axis_i;
  oc_memory0_axis_o           <= oc_memory0_axis_o_pipe_out;
  oc_mmio0_axis_i_pipe_in     <= oc_mmio0_axis_i;
  oc_mmio0_axis_o             <= oc_mmio0_axis_o_pipe_out;
  oc_cfg0_axis_i_pipe_in      <= oc_cfg0_axis_i;
  oc_cfg0_axis_o              <= oc_cfg0_axis_o_pipe_out;
  c3s_dlx_axis_i_pipe_in      <= c3s_dlx_axis_i;
  c3s_dlx_axis_o              <= c3s_dlx_axis_o_pipe_out;
  fbist_axis_i_pipe_in        <= fbist_axis_i;
  fbist_axis_o                <= fbist_axis_o_pipe_out;
  oc_host_cfg0_axis_i_pipe_in <= oc_host_cfg0_axis_i;               -- input to fire_core from kwaxi
  oc_host_cfg0_axis_o         <= oc_host_cfg0_axis_o_pipe_out;      -- output from fire_core to kwaxi

  oc_fbist_axis_aclk          <= fbist_oc_axim_aclk;
  oc_fbist_axis_i             <= axi3_master_slave_connect(fbist_oc_axim_o);
  fbist_oc_axim_i             <= axi3_master_slave_connect(oc_fbist_axis_o);

  -- Configuration signals
  send_first                 <= '1';
  cfg_tlx_xmit_tmpl_config_0 <= cfg_tlx_xmit_tmpl_config(0);
  cfg_tlx_xmit_tmpl_config_1 <= cfg_tlx_xmit_tmpl_config(1);
  cfg_tlx_xmit_tmpl_config_2 <= cfg_tlx_xmit_tmpl_config(4);  -- Actually template 4
  cfg_tlx_xmit_tmpl_config_3 <= cfg_tlx_xmit_tmpl_config(3);

  -- AFU / TLX interface
  afu_tlx_cmd_credit          <= '0';
  afu_tlx_cmd_initial_credit  <= (others => '0');
  afu_tlx_cmd_rd_cnt          <= (others => '0');
  afu_tlx_cmd_rd_req          <= '0';
  afu_tlx_rdata_bdi           <= '0';
  afu_tlx_rdata_bus           <= (others => '0');
  afu_tlx_rdata_valid         <= '0';
  afu_tlx_resp_capptag        <= (others => '0');
  afu_tlx_resp_code           <= (others => '0');
  afu_tlx_resp_dl             <= (others => '0');
  afu_tlx_resp_dp             <= (others => '0');
  afu_tlx_resp_opcode         <= (others => '0');
  afu_tlx_resp_valid          <= '0';
  cfg_tlx_credit_return       <= '0';
  cfg_tlx_initial_credit      <= (others => '0');
  cfg_tlx_rdata_bdi           <= '0';
  cfg_tlx_rdata_bus           <= (others => '0');
  cfg_tlx_rdata_offset        <= (others => '0');
  cfg_tlx_resp_capptag        <= (others => '0');
  cfg_tlx_resp_code           <= (others => '0');
  cfg_tlx_resp_opcode         <= (others => '0');
  cfg_tlx_resp_valid          <= '0';
  cfg_tlx_xmit_rate_config_0  <= (others => '0');
  cfg_tlx_xmit_rate_config_1  <= (others => '0');
  cfg_tlx_xmit_rate_config_2  <= (others => '0');
  cfg_tlx_xmit_rate_config_3  <= (others => '0');

  -- C3S / DLX Connection
  c3s_dlx_response(511 downto 0) <= dlx_tlx_flit(511 downto 0);
  c3s_dlx_response_valid         <= dlx_tlx_flit_valid;

  dlx_tlx_flit_valid_gate        <= dlx_tlx_flit_valid AND NOT c3s_tl_gate_bit_staged;

  tlx_dlx_flit(511 downto 0)     <= gate(c3s_dlx_command_staged(511 downto 0),     c3s_dlx_command_sel_staged OR c3s_tl_gate_bit_staged) or
                                    gate(tlx_dlx_flit_int(511 downto 0),       not c3s_dlx_command_sel_staged AND NOT c3s_tl_gate_bit_staged);
  tlx_dlx_flit_valid             <= (c3s_dlx_command_valid_staged and     (c3s_dlx_command_sel_staged or c3s_tl_gate_bit_staged)) or
                                    (tlx_dlx_flit_valid_int       and not c3s_dlx_command_sel_staged AND NOT c3s_tl_gate_bit_staged);

  

  stage_1: entity work.ocx_dlx_tlx_stage
    PORT MAP (
      ---------------------------------------------------------------------------
      -- Clocking
      ---------------------------------------------------------------------------
      opt_gckn               => cclk,                -- [in  std_ulogic]
      tlx_dlx_flit (511 downto 0)   => tlx_dlx_flit (511 downto 0)         , -- MSR: ocx_dlx_wrap(dl)
      tlx_dlx_flit_valid            => tlx_dlx_flit_valid,                    -- MSR: ocx_dlx_wrap(dl)
      ---------------------------------------------------------------------------
      -- RX Interface
      ---------------------------------------------------------------------------
      i_dlx_tlx_flit_valid   => i_dlx_tlx_flit_valid,    -- [in  std_ulogic]
      i_dlx_tlx_flit         => i_dlx_tlx_flit,          -- [in  std_ulogic_vector(511 downto 0)]
      i_dlx_tlx_flit_crc_err => i_dlx_tlx_flit_crc_err,  -- [in  std_ulogic]
      i_dlx_tlx_link_up      => i_dlx_tlx_link_up,       -- [in  std_ulogic]
      -- Interface to TLx
      dlx_tlx_flit_valid     => dlx_tlx_flit_valid,      -- [out std_ulogic]
      dlx_tlx_flit           => dlx_tlx_flit,            -- [out std_ulogic_vector(511 downto 0)]
      dlx_tlx_flit_crc_err   => dlx_tlx_flit_crc_err,    -- [out std_ulogic]
      dlx_tlx_link_up        => dlx_tlx_link_up);        -- [out std_ulogic]
dl : entity work.ocx_dlx_wrap
port map (
    clk_156_25MHz                        => rclk,                                 -- MSR: ocx_dlx_wrap(dl)
    dlx_config_info (31 downto 0)        => dlx_config_info (31 downto 0)       , -- MSD: ocx_dlx_wrap(dl)
    lane_force_unlock (7 downto 0)       => lane_force_unlock (7 downto 0)      ,
    tsm_state2_to_3                        => tsm_state2_to_3,
    tsm_state6_to_1                      => tsm_state6_to_1,
    tsm_state4_to_5                      => tsm_state4_to_5,
--    tsm_state5_to_6                      => tsm_state5_to_6,
    o_dlx_reset                          => o_dlx_reset,
    dlx_l0_tx_data (63 downto 0)         => dlx_l0_tx_data (63 downto 0)        , -- MSD: ocx_dlx_wrap(dl)
    dlx_l0_tx_header (1 downto 0)        => dlx_l0_tx_header (1 downto 0)       , -- MSD: ocx_dlx_wrap(dl)
    dlx_l0_tx_seq (5 downto 0)           => dlx_l0_tx_seq (5 downto 0)          , -- MSD: ocx_dlx_wrap(dl)
    dlx_l1_tx_data (63 downto 0)         => dlx_l1_tx_data (63 downto 0)        , -- MSD: ocx_dlx_wrap(dl)
    dlx_l1_tx_header (1 downto 0)        => dlx_l1_tx_header (1 downto 0)       , -- MSD: ocx_dlx_wrap(dl)
    dlx_l1_tx_seq (5 downto 0)           => dlx_l1_tx_seq (5 downto 0)          , -- MSD: ocx_dlx_wrap(dl)
    dlx_l2_tx_data (63 downto 0)         => dlx_l2_tx_data (63 downto 0)        , -- MSD: ocx_dlx_wrap(dl)
    dlx_l2_tx_header (1 downto 0)        => dlx_l2_tx_header (1 downto 0)       , -- MSD: ocx_dlx_wrap(dl)
    dlx_l2_tx_seq (5 downto 0)           => dlx_l2_tx_seq (5 downto 0)          , -- MSD: ocx_dlx_wrap(dl)
    dlx_l3_tx_data (63 downto 0)         => dlx_l3_tx_data (63 downto 0)        , -- MSD: ocx_dlx_wrap(dl)
    dlx_l3_tx_header (1 downto 0)        => dlx_l3_tx_header (1 downto 0)       , -- MSD: ocx_dlx_wrap(dl)
    dlx_l3_tx_seq (5 downto 0)           => dlx_l3_tx_seq (5 downto 0)          , -- MSD: ocx_dlx_wrap(dl)
    dlx_l4_tx_data (63 downto 0)         => dlx_l4_tx_data (63 downto 0)        , -- MSD: ocx_dlx_wrap(dl)
    dlx_l4_tx_header (1 downto 0)        => dlx_l4_tx_header (1 downto 0)       , -- MSD: ocx_dlx_wrap(dl)
    dlx_l4_tx_seq (5 downto 0)           => dlx_l4_tx_seq (5 downto 0)          , -- MSD: ocx_dlx_wrap(dl)
    dlx_l5_tx_data (63 downto 0)         => dlx_l5_tx_data (63 downto 0)        , -- MSD: ocx_dlx_wrap(dl)
    dlx_l5_tx_header (1 downto 0)        => dlx_l5_tx_header (1 downto 0)       , -- MSD: ocx_dlx_wrap(dl)
    dlx_l5_tx_seq (5 downto 0)           => dlx_l5_tx_seq (5 downto 0)          , -- MSD: ocx_dlx_wrap(dl)
    dlx_l6_tx_data (63 downto 0)         => dlx_l6_tx_data (63 downto 0)        , -- MSD: ocx_dlx_wrap(dl)
    dlx_l6_tx_header (1 downto 0)        => dlx_l6_tx_header (1 downto 0)       , -- MSD: ocx_dlx_wrap(dl)
    dlx_l6_tx_seq (5 downto 0)           => dlx_l6_tx_seq (5 downto 0)          , -- MSD: ocx_dlx_wrap(dl)
    dlx_l7_tx_data (63 downto 0)         => dlx_l7_tx_data (63 downto 0)        , -- MSD: ocx_dlx_wrap(dl)
    dlx_l7_tx_header (1 downto 0)        => dlx_l7_tx_header (1 downto 0)       , -- MSD: ocx_dlx_wrap(dl)
    dlx_l7_tx_seq (5 downto 0)           => dlx_l7_tx_seq (5 downto 0)          , -- MSD: ocx_dlx_wrap(dl)
    dlx_tlx_flit (511 downto 0)          => i_dlx_tlx_flit (511 downto 0)         , -- MSD: ocx_dlx_wrap(dl)
    dlx_tlx_flit_crc_err                 => i_dlx_tlx_flit_crc_err                , -- MSD: ocx_dlx_wrap(dl)
    dlx_tlx_flit_credit                  => dlx_tlx_flit_credit                 , -- MSD: ocx_dlx_wrap(dl)
    dlx_tlx_flit_valid                   => i_dlx_tlx_flit_valid                  , -- MSD: ocx_dlx_wrap(dl)
    dlx_tlx_init_flit_depth (2 downto 0) => dlx_tlx_init_flit_depth (2 downto 0), -- MSD: ocx_dlx_wrap(dl)
    dlx_tlx_link_up                      => i_dlx_tlx_link_up                     , -- MSD: ocx_dlx_wrap(dl)
    gtwiz_buffbypass_rx_done_in          => gtwiz_buffbypass_rx_done_in         , -- MSR: ocx_dlx_wrap(dl)
    gtwiz_buffbypass_tx_done_in          => gtwiz_buffbypass_tx_done_in         , -- MSR: ocx_dlx_wrap(dl)
    gtwiz_reset_all_out                  => gtwiz_reset_all_out                 , -- MSD: ocx_dlx_wrap(dl)
    gtwiz_reset_rx_datapath_out          => gtwiz_reset_rx_datapath_out         , -- MSD: ocx_dlx_wrap(dl)
    gtwiz_reset_rx_done_in               => gtwiz_reset_rx_done_in              , -- MSR: ocx_dlx_wrap(dl)
    gtwiz_reset_tx_done_in               => gtwiz_reset_tx_done_in              , -- MSR: ocx_dlx_wrap(dl)
    gtwiz_userclk_rx_active_in           => gtwiz_userclk_rx_active_in          , -- MSR: ocx_dlx_wrap(dl)
    gtwiz_userclk_tx_active_in           => gtwiz_userclk_tx_active_in          , -- MSR: ocx_dlx_wrap(dl)
    hb_gtwiz_reset_all_in                => hb_gtwiz_reset_all_in               , -- MSR: ocx_dlx_wrap(dl)
    ln0_rx_data (63 downto 0)            => ln0_rx_data (63 downto 0)           , -- MSR: ocx_dlx_wrap(dl)
    ln0_rx_header (1 downto 0)           => ln0_rx_header (1 downto 0)          , -- MSR: ocx_dlx_wrap(dl)
    ln0_rx_slip                          => ln0_rx_slip                         , -- MSD: ocx_dlx_wrap(dl)
    ln0_rx_valid                         => ln0_rx_valid                        , -- MSR: ocx_dlx_wrap(dl)
    ln1_rx_data (63 downto 0)            => ln1_rx_data (63 downto 0)           , -- MSR: ocx_dlx_wrap(dl)
    ln1_rx_header (1 downto 0)           => ln1_rx_header (1 downto 0)          , -- MSR: ocx_dlx_wrap(dl)
    ln1_rx_slip                          => ln1_rx_slip                         , -- MSD: ocx_dlx_wrap(dl)
    ln1_rx_valid                         => ln1_rx_valid                        , -- MSR: ocx_dlx_wrap(dl)
    ln2_rx_data (63 downto 0)            => ln2_rx_data (63 downto 0)           , -- MSR: ocx_dlx_wrap(dl)
    ln2_rx_header (1 downto 0)           => ln2_rx_header (1 downto 0)          , -- MSR: ocx_dlx_wrap(dl)
    ln2_rx_slip                          => ln2_rx_slip                         , -- MSD: ocx_dlx_wrap(dl)
    ln2_rx_valid                         => ln2_rx_valid                        , -- MSR: ocx_dlx_wrap(dl)
    ln3_rx_data (63 downto 0)            => ln3_rx_data (63 downto 0)           , -- MSR: ocx_dlx_wrap(dl)
    ln3_rx_header (1 downto 0)           => ln3_rx_header (1 downto 0)          , -- MSR: ocx_dlx_wrap(dl)
    ln3_rx_slip                          => ln3_rx_slip                         , -- MSD: ocx_dlx_wrap(dl)
    ln3_rx_valid                         => ln3_rx_valid                        , -- MSR: ocx_dlx_wrap(dl)
    ln4_rx_data (63 downto 0)            => ln4_rx_data (63 downto 0)           , -- MSR: ocx_dlx_wrap(dl)
    ln4_rx_header (1 downto 0)           => ln4_rx_header (1 downto 0)          , -- MSR: ocx_dlx_wrap(dl)
    ln4_rx_slip                          => ln4_rx_slip                         , -- MSD: ocx_dlx_wrap(dl)
    ln4_rx_valid                         => ln4_rx_valid                        , -- MSR: ocx_dlx_wrap(dl)
    ln5_rx_data (63 downto 0)            => ln5_rx_data (63 downto 0)           , -- MSR: ocx_dlx_wrap(dl)
    ln5_rx_header (1 downto 0)           => ln5_rx_header (1 downto 0)          , -- MSR: ocx_dlx_wrap(dl)
    ln5_rx_slip                          => ln5_rx_slip                         , -- MSD: ocx_dlx_wrap(dl)
    ln5_rx_valid                         => ln5_rx_valid                        , -- MSR: ocx_dlx_wrap(dl)
    ln6_rx_data (63 downto 0)            => ln6_rx_data (63 downto 0)           , -- MSR: ocx_dlx_wrap(dl)
    ln6_rx_header (1 downto 0)           => ln6_rx_header (1 downto 0)          , -- MSR: ocx_dlx_wrap(dl)
    ln6_rx_slip                          => ln6_rx_slip                         , -- MSD: ocx_dlx_wrap(dl)
    ln6_rx_valid                         => ln6_rx_valid                        , -- MSR: ocx_dlx_wrap(dl)
    ln7_rx_data (63 downto 0)            => ln7_rx_data (63 downto 0)           , -- MSR: ocx_dlx_wrap(dl)
    ln7_rx_header (1 downto 0)           => ln7_rx_header (1 downto 0)          , -- MSR: ocx_dlx_wrap(dl)
    ln7_rx_slip                          => ln7_rx_slip                         , -- MSD: ocx_dlx_wrap(dl)
    ln7_rx_valid                         => ln7_rx_valid                        , -- MSR: ocx_dlx_wrap(dl)
    ocde                                 => ocde                                , -- MSR: ocx_dlx_wrap(dl)
    dl_debug_vector                      => dl_debug_vector                     , -- MSR: ocx_dlx_wrap(dl)
    reg_04_val                           => reg_04_value_o                      , -- MSR: ocx_dlx_wrap(dl)
    reg_04_hwwe                          => reg_04_hwwe_i                       , -- MSD: ocx_dlx_wrap(dl)
    reg_04_update                        => reg_04_update_i                     , -- MSD: ocx_dlx_wrap(dl)
    reg_05_hwwe                          => reg_05_hwwe_i                       , -- MSD: ocx_dlx_wrap(dl)
    reg_05_update                        => reg_05_update_i                     , -- MSD: ocx_dlx_wrap(dl)
    reg_06_hwwe                          => reg_06_hwwe_i                       , -- MSD: ocx_dlx_wrap(dl)
    reg_06_update                        => reg_06_update_i                     , -- MSD: ocx_dlx_wrap(dl)
    reg_07_hwwe                          => reg_07_hwwe_i                       , -- MSD: ocx_dlx_wrap(dl)
    reg_07_update                        => reg_07_update_i                     , -- MSD: ocx_dlx_wrap(dl)
    opt_gckn                             => cclk                                , -- MSR: ocx_dlx_wrap(dl)
    ro_dlx_version                       => open                                , -- MSD: ocx_dlx_wrap(dl)
    send_first                           => send_first                          , -- MSR: ocx_dlx_wrap(dl)
    tlx_dlx_debug_encode (3 downto 0)    => tlx_dlx_debug_encode (3 downto 0)   , -- MSR: ocx_dlx_wrap(dl)
    tlx_dlx_debug_info (31 downto 0)     => tlx_dlx_debug_info (31 downto 0)    , -- MSR: ocx_dlx_wrap(dl)
    tlx_dlx_flit (511 downto 0)          => tlx_dlx_flit (511 downto 0)         , -- MSR: ocx_dlx_wrap(dl)
    tlx_dlx_flit_valid                   => tlx_dlx_flit_valid                   -- MSR: ocx_dlx_wrap(dl)
);

c3s_dlx : entity work.c3s_mac
generic map (
    C_COMMAND_WIDTH => 512,
    C_ADDRESS_WIDTH => 5
)
port map (
    c3s_axis_aclk      => cclk                         , -- OVR: c3s_mac(c3s_dlx)
    c3s_axis_i         => c3s_dlx_axis_i_pipe_out      , -- OVR: c3s_mac(c3s_dlx)
    c3s_axis_o         => c3s_dlx_axis_o_pipe_in       , -- OVD: c3s_mac(c3s_dlx)
    c3s_command        => c3s_dlx_command              , -- OVD: c3s_mac(c3s_dlx)
    c3s_command_sel    => c3s_dlx_command_sel          , -- OVD: c3s_mac(c3s_dlx)
    c3s_command_valid  => c3s_dlx_command_valid        , -- OVD: c3s_mac(c3s_dlx)
    c3s_response       => c3s_dlx_response_staged      , -- OVR: c3s_mac(c3s_dlx)
    c3s_response_valid => c3s_dlx_response_valid_staged, -- OVR: c3s_mac(c3s_dlx)
    c3s_tl_gate_bit    => c3s_tl_gate_bit              ,
    cclk               => cclk                         , -- MSR: c3s_mac(c3s_dlx)
    creset             => creset                         -- MSR: c3s_mac(c3s_dlx)
);


c3s_dlx_staging : entity work.c3s_staging
generic map (
    C_STAGING_CYCLES           => 4
  )
port map (
    cclk                       => cclk,
    creset                     => creset,
    c3s_tl_gate_bit_stg_in     => c3s_tl_gate_bit,       
    c3s_tl_gate_bit_stg_out    => c3s_tl_gate_bit_staged,
    c3s_command_stg_in         => c3s_dlx_command,
    c3s_command_valid_stg_in   => c3s_dlx_command_valid,
    c3s_command_sel_stg_in     => c3s_dlx_command_sel,
    c3s_command_stg_out        => c3s_dlx_command_staged,
    c3s_command_valid_stg_out  => c3s_dlx_command_valid_staged,
    c3s_command_sel_stg_out    => c3s_dlx_command_sel_staged,
    c3s_response_stg_in        => c3s_dlx_response,
    c3s_response_valid_stg_in  => c3s_dlx_response_valid,
    c3s_response_stg_out       => c3s_dlx_response_staged,
    c3s_response_valid_stg_out => c3s_dlx_response_valid_staged
);

 fbist : entity work.fbist_mac
 port map (
     cclk               => cclk                   , -- MSR: fbist_mac(fbist)
     creset             => creset                 , -- MSR: fbist_mac(fbist)
     fbist_oc_axim_aclk => fbist_oc_axim_aclk     , -- MSD: fbist_mac(fbist)
     fbist_oc_axim_i    => fbist_oc_axim_i        , -- MSR: fbist_mac(fbist)
     fbist_oc_axim_o    => fbist_oc_axim_o        , -- MSD: fbist_mac(fbist)
     fbist_axis_aclk    => cclk                   , -- MSR: fbist_mac(fbist)
     fbist_axis_i       => fbist_axis_i_pipe_out  , -- OVR: fbist_mac(fbist)
     fbist_axis_o       => fbist_axis_o_pipe_in   , -- OVD: fbist_mac(fbist)
     sys_reset          => creset                , -- MSR: fbist_mac(fbist)
     sysclk             => cclk                     -- MSR: fbist_mac(fbist)
 );

oc_host_cfg0 : entity work.oc_host_cfg
port map (
    cclk                     => cclk                        , -- MSR: oc_host_cfg(oc_host_cfg0)
    dl_debug_vector          => dl_debug_vector             ,
    cfg_tlx_xmit_tmpl_config => cfg_tlx_xmit_tmpl_config    , -- MSD: oc_host_cfg(oc_host_cfg0)
    oc_host_cfg0_axis_aclk   => cclk                        , -- MSR: oc_host_cfg(oc_host_cfg0)
    oc_host_cfg0_axis_i      => oc_host_cfg0_axis_i_pipe_out, -- OVR: oc_host_cfg(oc_host_cfg0) input to oc_host_cfg
    oc_host_cfg0_axis_o      => oc_host_cfg0_axis_o_pipe_in , -- OVD: oc_host_cfg(oc_host_cfg0) output from oc_host_cfg

    reg_01_update_i          =>    reg_01_update_i,
    reg_01_hwwe_i            =>    reg_01_hwwe_i,
    reg_01_o                 =>    reg_01_o,
    reg_02_update_i          =>    reg_02_update_i,
    reg_02_hwwe_i            =>    reg_02_hwwe_i,
    reg_02_o                 =>    reg_02_o,
    reg_03_o                 =>    reg_03_o,
    reg_04_o                 =>    reg_04_value_o,
    reg_04_update_i          =>    reg_04_update_i,
    reg_04_hwwe_i            =>    reg_04_hwwe_i,
    reg_05_hwwe_i            =>    reg_05_hwwe_i,
    reg_05_update_i          =>    reg_05_update_i,
    reg_06_hwwe_i            =>    reg_06_hwwe_i,
    reg_06_update_i          =>    reg_06_update_i,
    reg_07_hwwe_i            =>    reg_07_hwwe_i ,
    reg_07_update_i          =>    reg_07_update_i,
    -- register w will be the memcntl register
    creset                   => creset                      -- MSR: oc_host_cfg(oc_host_cfg0)
);

tl : entity work.ocx_tlx_wrap
port map (
    afu_tlx_cmd_credit                            => afu_tlx_cmd_credit                           , -- MSR: ocx_tlx_wrap(tl)
    afu_tlx_cmd_initial_credit (6 downto 0)       => afu_tlx_cmd_initial_credit (6 downto 0)      , -- MSR: ocx_tlx_wrap(tl)
    afu_tlx_cmd_rd_cnt (2 downto 0)               => afu_tlx_cmd_rd_cnt (2 downto 0)              , -- MSR: ocx_tlx_wrap(tl)
    afu_tlx_cmd_rd_req                            => afu_tlx_cmd_rd_req                           , -- MSR: ocx_tlx_wrap(tl)
    afu_tlx_rdata_bdi                             => afu_tlx_rdata_bdi                            , -- MSR: ocx_tlx_wrap(tl)
    afu_tlx_rdata_bus (511 downto 0)              => afu_tlx_rdata_bus (511 downto 0)             , -- MSR: ocx_tlx_wrap(tl)
    afu_tlx_rdata_valid                           => afu_tlx_rdata_valid                          , -- MSR: ocx_tlx_wrap(tl)
    afu_tlx_resp_capptag (15 downto 0)            => afu_tlx_resp_capptag (15 downto 0)           , -- MSR: ocx_tlx_wrap(tl)
    afu_tlx_resp_code (3 downto 0)                => afu_tlx_resp_code (3 downto 0)               , -- MSR: ocx_tlx_wrap(tl)
    afu_tlx_resp_dl (1 downto 0)                  => afu_tlx_resp_dl (1 downto 0)                 , -- MSR: ocx_tlx_wrap(tl)
    afu_tlx_resp_dp (1 downto 0)                  => afu_tlx_resp_dp (1 downto 0)                 , -- MSR: ocx_tlx_wrap(tl)
    afu_tlx_resp_opcode (7 downto 0)              => afu_tlx_resp_opcode (7 downto 0)             , -- MSR: ocx_tlx_wrap(tl)
    afu_tlx_resp_valid                            => afu_tlx_resp_valid                           , -- MSR: ocx_tlx_wrap(tl)
    cfg_tlx_credit_return                         => cfg_tlx_credit_return                        , -- MSR: ocx_tlx_wrap(tl)
    cfg_tlx_initial_credit (3 downto 0)           => cfg_tlx_initial_credit (3 downto 0)          , -- MSR: ocx_tlx_wrap(tl)
    cfg_tlx_rdata_bdi                             => cfg_tlx_rdata_bdi                            , -- MSR: ocx_tlx_wrap(tl)
    cfg_tlx_rdata_bus (31 downto 0)               => cfg_tlx_rdata_bus (31 downto 0)              , -- MSR: ocx_tlx_wrap(tl)
    cfg_tlx_rdata_offset (3 downto 0)             => cfg_tlx_rdata_offset (3 downto 0)            , -- MSR: ocx_tlx_wrap(tl)
    cfg_tlx_resp_capptag (15 downto 0)            => cfg_tlx_resp_capptag (15 downto 0)           , -- MSR: ocx_tlx_wrap(tl)
    cfg_tlx_resp_code (3 downto 0)                => cfg_tlx_resp_code (3 downto 0)               , -- MSR: ocx_tlx_wrap(tl)
    cfg_tlx_resp_opcode (7 downto 0)              => cfg_tlx_resp_opcode (7 downto 0)             , -- MSR: ocx_tlx_wrap(tl)
    cfg_tlx_resp_valid                            => cfg_tlx_resp_valid                           , -- MSR: ocx_tlx_wrap(tl)
    cfg_tlx_xmit_rate_config_0 (3 downto 0)       => cfg_tlx_xmit_rate_config_0 (3 downto 0)      , -- MSR: ocx_tlx_wrap(tl)
    cfg_tlx_xmit_rate_config_1 (3 downto 0)       => cfg_tlx_xmit_rate_config_1 (3 downto 0)      , -- MSR: ocx_tlx_wrap(tl)
    cfg_tlx_xmit_rate_config_2 (3 downto 0)       => cfg_tlx_xmit_rate_config_2 (3 downto 0)      , -- MSR: ocx_tlx_wrap(tl)
    cfg_tlx_xmit_rate_config_3 (3 downto 0)       => cfg_tlx_xmit_rate_config_3 (3 downto 0)      , -- MSR: ocx_tlx_wrap(tl)
    cfg_tlx_xmit_tmpl_config_0                    => cfg_tlx_xmit_tmpl_config_0                   , -- MSR: ocx_tlx_wrap(tl)
    cfg_tlx_xmit_tmpl_config_1                    => cfg_tlx_xmit_tmpl_config_1                   , -- MSR: ocx_tlx_wrap(tl)
    cfg_tlx_xmit_tmpl_config_2                    => cfg_tlx_xmit_tmpl_config_2                   , -- MSR: ocx_tlx_wrap(tl)
    cfg_tlx_xmit_tmpl_config_3                    => cfg_tlx_xmit_tmpl_config_3                   , -- MSR: ocx_tlx_wrap(tl)
    clock                                         => cclk                                         , -- MSR: ocx_tlx_wrap(tl)
    dlx_tlx_dlx_config_info (31 downto 0)         => dlx_config_info (31 downto 0)                , -- OVR: ocx_tlx_wrap(tl)
    dlx_tlx_flit (511 downto 0)                   => dlx_tlx_flit (511 downto 0)                  , -- MSR: ocx_tlx_wrap(tl)
    dlx_tlx_flit_crc_err                          => dlx_tlx_flit_crc_err                         , -- MSR: ocx_tlx_wrap(tl)
    dlx_tlx_flit_credit                           => dlx_tlx_flit_credit                          , -- MSR: ocx_tlx_wrap(tl)
    dlx_tlx_flit_valid                            => dlx_tlx_flit_valid_gate                      , -- MSR: ocx_tlx_wrap(tl)
    dlx_tlx_init_flit_depth (2 downto 0)          => dlx_tlx_init_flit_depth (2 downto 0)         , -- MSR: ocx_tlx_wrap(tl)
    dlx_tlx_link_up                               => dlx_tlx_link_up                              , -- MSR: ocx_tlx_wrap(tl)
    oc_fbist_axis_aclk                            => oc_fbist_axis_aclk                           , -- MSR: ocx_tlx_wrap(tl)
    oc_fbist_axis_i                               => oc_fbist_axis_i                              , -- MSR: ocx_tlx_wrap(tl)
    oc_fbist_axis_o                               => oc_fbist_axis_o                              , -- MSD: ocx_tlx_wrap(tl)
    oc_cfg_axis_aclk                              => cclk                                         , -- OVR: ocx_tlx_wrap(tl)
    oc_cfg_axis_i                                 => oc_cfg0_axis_i_pipe_out                      , -- OVR: ocx_tlx_wrap(tl)
    oc_cfg_axis_o                                 => oc_cfg0_axis_o_pipe_in                       , -- OVD: ocx_tlx_wrap(tl)
    oc_memory_axis_aclk                           => cclk                                         , -- OVR: ocx_tlx_wrap(tl)
    oc_memory_axis_i                              => oc_memory0_axis_i_pipe_out                   , -- OVR: ocx_tlx_wrap(tl)
    oc_memory_axis_o                              => oc_memory0_axis_o_pipe_in                    , -- OVD: ocx_tlx_wrap(tl)
    oc_mmio_axis_aclk                             => cclk                                         , -- OVR: ocx_tlx_wrap(tl)
    oc_mmio_axis_i                                => oc_mmio0_axis_i_pipe_out                     , -- OVR: ocx_tlx_wrap(tl)
    oc_mmio_axis_o                                => oc_mmio0_axis_o_pipe_in                      , -- OVD: ocx_tlx_wrap(tl)
    reset_n                                       => cresetn                                      , -- MSR: ocx_tlx_wrap(tl)
    tlx_afu_cmd_be (63 downto 0)                  => tlx_afu_cmd_be (63 downto 0)                 , -- MSD: ocx_tlx_wrap(tl)
    tlx_afu_cmd_capptag (15 downto 0)             => tlx_afu_cmd_capptag (15 downto 0)            , -- MSD: ocx_tlx_wrap(tl)
    tlx_afu_cmd_data_bdi                          => tlx_afu_cmd_data_bdi                         , -- MSD: ocx_tlx_wrap(tl)
    tlx_afu_cmd_data_bus (511 downto 0)           => tlx_afu_cmd_data_bus (511 downto 0)          , -- MSD: ocx_tlx_wrap(tl)
    tlx_afu_cmd_data_valid                        => tlx_afu_cmd_data_valid                       , -- MSD: ocx_tlx_wrap(tl)
    tlx_afu_cmd_dl (1 downto 0)                   => tlx_afu_cmd_dl (1 downto 0)                  , -- MSD: ocx_tlx_wrap(tl)
    tlx_afu_cmd_end                               => tlx_afu_cmd_end                              , -- MSD: ocx_tlx_wrap(tl)
    tlx_afu_cmd_flag (3 downto 0)                 => tlx_afu_cmd_flag (3 downto 0)                , -- MSD: ocx_tlx_wrap(tl)
    tlx_afu_cmd_opcode (7 downto 0)               => tlx_afu_cmd_opcode (7 downto 0)              , -- MSD: ocx_tlx_wrap(tl)
    tlx_afu_cmd_os                                => tlx_afu_cmd_os                               , -- MSD: ocx_tlx_wrap(tl)
    tlx_afu_cmd_pa (63 downto 0)                  => tlx_afu_cmd_pa (63 downto 0)                 , -- MSD: ocx_tlx_wrap(tl)
    tlx_afu_cmd_pl (2 downto 0)                   => tlx_afu_cmd_pl (2 downto 0)                  , -- MSD: ocx_tlx_wrap(tl)
    tlx_afu_cmd_valid                             => tlx_afu_cmd_valid                            , -- MSD: ocx_tlx_wrap(tl)
    tlx_afu_ready                                 => tlx_afu_ready                                , -- MSD: ocx_tlx_wrap(tl)
    tlx_afu_resp_credit                           => tlx_afu_resp_credit                          , -- MSD: ocx_tlx_wrap(tl)
    tlx_afu_resp_data_credit                      => tlx_afu_resp_data_credit                     , -- MSD: ocx_tlx_wrap(tl)
    tlx_cfg_capptag (15 downto 0)                 => tlx_cfg_capptag (15 downto 0)                , -- MSD: ocx_tlx_wrap(tl)
    tlx_cfg_data_bdi                              => tlx_cfg_data_bdi                             , -- MSD: ocx_tlx_wrap(tl)
    tlx_cfg_data_bus (31 downto 0)                => tlx_cfg_data_bus (31 downto 0)               , -- MSD: ocx_tlx_wrap(tl)
    tlx_cfg_in_rcv_rate_capability_0 (3 downto 0) => tlx_cfg_in_rcv_rate_capability_0 (3 downto 0), -- MSD: ocx_tlx_wrap(tl)
    tlx_cfg_in_rcv_rate_capability_1 (3 downto 0) => tlx_cfg_in_rcv_rate_capability_1 (3 downto 0), -- MSD: ocx_tlx_wrap(tl)
    tlx_cfg_in_rcv_rate_capability_2 (3 downto 0) => tlx_cfg_in_rcv_rate_capability_2 (3 downto 0), -- MSD: ocx_tlx_wrap(tl)
    tlx_cfg_in_rcv_rate_capability_3 (3 downto 0) => tlx_cfg_in_rcv_rate_capability_3 (3 downto 0), -- MSD: ocx_tlx_wrap(tl)
    tlx_cfg_in_rcv_tmpl_capability_0              => tlx_cfg_in_rcv_tmpl_capability_0             , -- MSD: ocx_tlx_wrap(tl)
    tlx_cfg_in_rcv_tmpl_capability_1              => tlx_cfg_in_rcv_tmpl_capability_1             , -- MSD: ocx_tlx_wrap(tl)
    tlx_cfg_in_rcv_tmpl_capability_2              => tlx_cfg_in_rcv_tmpl_capability_2             , -- MSD: ocx_tlx_wrap(tl)
    tlx_cfg_in_rcv_tmpl_capability_3              => tlx_cfg_in_rcv_tmpl_capability_3             , -- MSD: ocx_tlx_wrap(tl)
    tlx_cfg_oc3_tlx_version (31 downto 0)         => tlx_cfg_oc3_tlx_version (31 downto 0)        , -- MSD: ocx_tlx_wrap(tl)
    tlx_cfg_opcode (7 downto 0)                   => tlx_cfg_opcode (7 downto 0)                  , -- MSD: ocx_tlx_wrap(tl)
    tlx_cfg_pa (63 downto 0)                      => tlx_cfg_pa (63 downto 0)                     , -- MSD: ocx_tlx_wrap(tl)
    tlx_cfg_pl (2 downto 0)                       => tlx_cfg_pl (2 downto 0)                      , -- MSD: ocx_tlx_wrap(tl)
    tlx_cfg_t                                     => tlx_cfg_t                                    , -- MSD: ocx_tlx_wrap(tl)
    tlx_cfg_valid                                 => tlx_cfg_valid                                , -- MSD: ocx_tlx_wrap(tl)
    tlx_dlx_debug_encode (3 downto 0)             => tlx_dlx_debug_encode (3 downto 0)            , -- MSD: ocx_tlx_wrap(tl)
    tlx_dlx_debug_info (31 downto 0)              => tlx_dlx_debug_info (31 downto 0)             , -- MSD: ocx_tlx_wrap(tl)
    tlx_dlx_flit(511 downto 0)                    => tlx_dlx_flit_int(511 downto 0)               , -- OVD: ocx_tlx_wrap(tl)
    tlx_dlx_flit_valid                            => tlx_dlx_flit_valid_int                       , -- OVD: ocx_tlx_wrap(tl)
    reg_01_update_i                               => reg_01_update_i                              ,
    reg_01_hwwe_i                                 => reg_01_hwwe_i                                ,
    reg_01_o                                      => reg_01_o                                     ,
    reg_02_update_i                               => reg_02_update_i                              ,
    reg_02_hwwe_i                                 => reg_02_hwwe_i                                ,
    reg_02_o                                      => reg_02_o                                     ,
    reg_03_o                                      => reg_03_o
);

oc_memory0_axi_async : entity work.axi3_async
port map (
    s0_axi_aclk_a => oc_memory0_axis_aclk      , -- OVR: axi3_async(oc_memory0_axi_async)
    s0_axi_aclk_b => cclk                      , -- OVR: axi3_async(oc_memory0_axi_async)
    s0_axi_i_a    => oc_memory0_axis_i_pipe_in , -- OVR: axi3_async(oc_memory0_axi_async)
    s0_axi_i_b    => oc_memory0_axis_i_pipe_out, -- OVD: axi3_async(oc_memory0_axi_async)
    s0_axi_o_a    => oc_memory0_axis_o_pipe_out, -- OVD: axi3_async(oc_memory0_axi_async)
    s0_axi_o_b    => oc_memory0_axis_o_pipe_in   -- OVR: axi3_async(oc_memory0_axi_async)
);

oc_mmio0_axi_async : entity work.axi3_async
port map (
    s0_axi_aclk_a => oc_mmio0_axis_aclk      , -- OVR: axi3_async(oc_mmio0_axi_async)
    s0_axi_aclk_b => cclk                    , -- OVR: axi3_async(oc_mmio0_axi_async)
    s0_axi_i_a    => oc_mmio0_axis_i_pipe_in , -- OVR: axi3_async(oc_mmio0_axi_async)
    s0_axi_i_b    => oc_mmio0_axis_i_pipe_out, -- OVD: axi3_async(oc_mmio0_axi_async)
    s0_axi_o_a    => oc_mmio0_axis_o_pipe_out, -- OVD: axi3_async(oc_mmio0_axi_async)
    s0_axi_o_b    => oc_mmio0_axis_o_pipe_in   -- OVR: axi3_async(oc_mmio0_axi_async)
);

oc_cfg0_axi_async : entity work.axi3_async
port map (
    s0_axi_aclk_a => oc_cfg0_axis_aclk      , -- OVR: axi3_async(oc_cfg0_axi_async)
    s0_axi_aclk_b => cclk                   , -- OVR: axi3_async(oc_cfg0_axi_async)
    s0_axi_i_a    => oc_cfg0_axis_i_pipe_in , -- OVR: axi3_async(oc_cfg0_axi_async)
    s0_axi_i_b    => oc_cfg0_axis_i_pipe_out, -- OVD: axi3_async(oc_cfg0_axi_async)
    s0_axi_o_a    => oc_cfg0_axis_o_pipe_out, -- OVD: axi3_async(oc_cfg0_axi_async)
    s0_axi_o_b    => oc_cfg0_axis_o_pipe_in   -- OVR: axi3_async(oc_cfg0_axi_async)
);

c3s_axi_async : entity work.axi_async
port map (
   s0_axi_aclk_a => c3s_dlx_axis_aclk      , -- OVR: axi_async(c3s_axi_async)
   s0_axi_aclk_b => cclk                   , -- OVR: axi_async(c3s_axi_async)
   s0_axi_i_a    => c3s_dlx_axis_i_pipe_in , -- OVR: axi_async(c3s_axi_async)
   s0_axi_i_b    => c3s_dlx_axis_i_pipe_out, -- OVD: axi_async(c3s_axi_async)
   s0_axi_o_a    => c3s_dlx_axis_o_pipe_out, -- OVD: axi_async(c3s_axi_async)
   s0_axi_o_b    => c3s_dlx_axis_o_pipe_in   -- OVR: axi_async(c3s_axi_async)
);

 fbist_axi_async : entity work.axi_async
 port map (
     s0_axi_aclk_a => fbist_axis_aclk      , -- OVR: axi_async(fbist_axi_async)
     s0_axi_aclk_b => cclk                 , -- OVR: axi_async(fbist_axi_async)
     s0_axi_i_a    => fbist_axis_i_pipe_in , -- OVR: axi_async(fbist_axi_async)
     s0_axi_i_b    => fbist_axis_i_pipe_out, -- OVD: axi_async(fbist_axi_async)
     s0_axi_o_a    => fbist_axis_o_pipe_out, -- OVD: axi_async(fbist_axi_async)
     s0_axi_o_b    => fbist_axis_o_pipe_in   -- OVR: axi_async(fbist_axi_async)
 );

oc_host_cfg0_axi_async : entity work.axi_async
port map (
    s0_axi_aclk_a => oc_host_cfg0_axis_aclk      , -- OVR: axi_async(oc_host_cfg0_axi_async)
    s0_axi_aclk_b => cclk                        , -- OVR: axi_async(oc_host_cfg0_axi_async)
    s0_axi_i_a    => oc_host_cfg0_axis_i_pipe_in , -- OVR: axi_async(oc_host_cfg0_axi_async)
    s0_axi_i_b    => oc_host_cfg0_axis_i_pipe_out, -- OVD: axi_async(oc_host_cfg0_axi_async)
    s0_axi_o_a    => oc_host_cfg0_axis_o_pipe_out, -- OVD: axi_async(oc_host_cfg0_axi_async)
    s0_axi_o_b    => oc_host_cfg0_axis_o_pipe_in   -- OVR: axi_async(oc_host_cfg0_axi_async)
);
end fire_core;
