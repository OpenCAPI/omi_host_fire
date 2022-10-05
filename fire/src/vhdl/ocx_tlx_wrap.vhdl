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
use support.logic_support_pkg.all;
use work.axi_pkg.all;

entity ocx_tlx_wrap is
  port (
    ---------------------------------------------------------------------------
    -- Clocking
    ---------------------------------------------------------------------------
    clock    : in    std_ulogic;
    reset_n  : in    std_ulogic;
    -----------------------------------------------------------------------------
    -- Interrupt logging register and mem_cntl register
    --------------------------------------------------------------------------
    reg_01_update_i     : out std_ulogic_vector(31 downto 0);
    reg_01_hwwe_i       : out std_ulogic;
    reg_01_o            : in std_ulogic_vector(31 downto 0);
    reg_02_update_i     : out std_ulogic_vector(31 downto 0);
    reg_02_hwwe_i       : out std_ulogic;
    reg_02_o            : in std_ulogic_vector(31 downto 0);
    reg_03_o            : in std_ulogic_vector(31 downto 0);
    ---------------------------------------------------------------------------
    -- AXI
    ---------------------------------------------------------------------------
    oc_mmio_axis_aclk   : in  std_ulogic;
    oc_mmio_axis_i      : in  t_AXI3_SLAVE_INPUT;
    oc_mmio_axis_o      : out t_AXI3_SLAVE_OUTPUT;
    oc_memory_axis_aclk : in  std_ulogic;
    oc_memory_axis_i    : in  t_AXI3_SLAVE_INPUT;
    oc_memory_axis_o    : out t_AXI3_SLAVE_OUTPUT;
    oc_cfg_axis_aclk    : in  std_ulogic;
    oc_cfg_axis_i       : in  t_AXI3_SLAVE_INPUT;
    oc_cfg_axis_o       : out t_AXI3_SLAVE_OUTPUT;
    oc_fbist_axis_aclk  : in  std_ulogic;
    oc_fbist_axis_i     : in  t_AXI3_512_SLAVE_INPUT;
    oc_fbist_axis_o     : out t_AXI3_512_SLAVE_OUTPUT;

    ---------------------------------------------------------------------------
    -- TLX Parser to AFU Receive Interface
    ---------------------------------------------------------------------------
    tlx_afu_ready : out std_ulogic;

    -- Command interface to AFU
    afu_tlx_cmd_initial_credit : in  std_ulogic_vector(6 downto 0);
    afu_tlx_cmd_credit         : in  std_ulogic;
    tlx_afu_cmd_valid          : out std_ulogic;
    tlx_afu_cmd_opcode         : out std_ulogic_vector(7 downto 0);
    tlx_afu_cmd_dl             : out std_ulogic_vector(1 downto 0);
    tlx_afu_cmd_end            : out std_ulogic;
    tlx_afu_cmd_pa             : out std_ulogic_vector(63 downto 0);
    tlx_afu_cmd_flag           : out std_ulogic_vector(3 downto 0);
    tlx_afu_cmd_os             : out std_ulogic;
    tlx_afu_cmd_capptag        : out std_ulogic_vector(15 downto 0);
    tlx_afu_cmd_pl             : out std_ulogic_vector(2 downto 0);
    tlx_afu_cmd_be             : out std_ulogic_vector(63 downto 0);

    -- Config Command interface to AFU
    cfg_tlx_initial_credit : in  std_ulogic_vector(3 downto 0);
    cfg_tlx_credit_return  : in  std_ulogic;
    tlx_cfg_valid          : out std_ulogic;
    tlx_cfg_opcode         : out std_ulogic_vector(7 downto 0);
    tlx_cfg_pa             : out std_ulogic_vector(63 downto 0);
    tlx_cfg_t              : out std_ulogic;
    tlx_cfg_pl             : out std_ulogic_vector(2 downto 0);
    tlx_cfg_capptag        : out std_ulogic_vector(15 downto 0);
    tlx_cfg_data_bus       : out std_ulogic_vector(31 downto 0);
    tlx_cfg_data_bdi       : out std_ulogic;

    -- Command data interface to AFU
    afu_tlx_cmd_rd_req     : in  std_ulogic;
    afu_tlx_cmd_rd_cnt     : in  std_ulogic_vector(2 downto 0);
    tlx_afu_cmd_data_valid : out std_ulogic;
    tlx_afu_cmd_data_bdi   : out std_ulogic;
    tlx_afu_cmd_data_bus   : out std_ulogic_vector(511 downto 0);

    ---------------------------------------------------------------------------
    -- AFU to TLX Framer Transmit Interface
    ---------------------------------------------------------------------------
    -- Responses from AFU
    tlx_afu_resp_credit  : out std_ulogic;
    afu_tlx_resp_valid   : in  std_ulogic;
    afu_tlx_resp_opcode  : in  std_ulogic_vector(7 downto 0);
    afu_tlx_resp_dl      : in  std_ulogic_vector(1 downto 0);
    afu_tlx_resp_capptag : in  std_ulogic_vector(15 downto 0);
    afu_tlx_resp_dp      : in  std_ulogic_vector(1 downto 0);
    afu_tlx_resp_code    : in  std_ulogic_vector(3 downto 0);

    -- Response data from AFU
    tlx_afu_resp_data_credit : out std_ulogic;
    afu_tlx_rdata_valid      : in  std_ulogic;
    afu_tlx_rdata_bus        : in  std_ulogic_vector(511 downto 0);
    afu_tlx_rdata_bdi        : in  std_ulogic;

    -- Config Responses from AFU
    cfg_tlx_resp_valid   : in std_ulogic;
    cfg_tlx_resp_opcode  : in std_ulogic_vector(7 downto 0);
    cfg_tlx_resp_capptag : in std_ulogic_vector(15 downto 0);
    cfg_tlx_resp_code    : in std_ulogic_vector(3 downto 0);

    -- Config Response data from AFU
    cfg_tlx_rdata_offset : in std_ulogic_vector(3 downto 0);
    cfg_tlx_rdata_bus    : in std_ulogic_vector(31 downto 0);
    cfg_tlx_rdata_bdi    : in std_ulogic;

    ---------------------------------------------------------------------------
    -- DLX to TLX Parser Interface
    ---------------------------------------------------------------------------
    dlx_tlx_flit_valid   : in std_ulogic;
    dlx_tlx_flit         : in std_ulogic_vector(511 downto 0);
    dlx_tlx_flit_crc_err : in std_ulogic;
    dlx_tlx_link_up      : in std_ulogic;

    -----------------------------------------------------------------------
    -- TLX Framer to DLX Interface
    -----------------------------------------------------------------------
    dlx_tlx_init_flit_depth : in  std_ulogic_vector(2 downto 0);
    dlx_tlx_flit_credit     : in  std_ulogic;
    tlx_dlx_flit_valid      : out std_ulogic;
    tlx_dlx_flit            : out std_ulogic_vector(511 downto 0);
    tlx_dlx_debug_encode    : out std_ulogic_vector(3 downto 0);
    tlx_dlx_debug_info      : out std_ulogic_vector(31 downto 0);
    dlx_tlx_dlx_config_info : in  std_ulogic_vector(31 downto 0);

    ---------------------------------------------------------------------------
    -- Configuration Ports
    ---------------------------------------------------------------------------
    tlx_cfg_oc3_tlx_version : out std_ulogic_vector(31 downto 0);

    cfg_tlx_xmit_tmpl_config_0 : in std_ulogic;
    cfg_tlx_xmit_tmpl_config_1 : in std_ulogic;
    cfg_tlx_xmit_tmpl_config_2 : in std_ulogic;
    cfg_tlx_xmit_tmpl_config_3 : in std_ulogic;
    cfg_tlx_xmit_rate_config_0 : in std_ulogic_vector(3 downto 0);
    cfg_tlx_xmit_rate_config_1 : in std_ulogic_vector(3 downto 0);
    cfg_tlx_xmit_rate_config_2 : in std_ulogic_vector(3 downto 0);
    cfg_tlx_xmit_rate_config_3 : in std_ulogic_vector(3 downto 0);

    tlx_cfg_in_rcv_tmpl_capability_0 : out std_ulogic;
    tlx_cfg_in_rcv_tmpl_capability_1 : out std_ulogic;
    tlx_cfg_in_rcv_tmpl_capability_2 : out std_ulogic;
    tlx_cfg_in_rcv_tmpl_capability_3 : out std_ulogic;
    tlx_cfg_in_rcv_rate_capability_0 : out std_ulogic_vector(3 downto 0);
    tlx_cfg_in_rcv_rate_capability_1 : out std_ulogic_vector(3 downto 0);
    tlx_cfg_in_rcv_rate_capability_2 : out std_ulogic_vector(3 downto 0);
    tlx_cfg_in_rcv_rate_capability_3 : out std_ulogic_vector(3 downto 0)
    );

  attribute BLOCK_TYPE of ocx_tlx_wrap : entity is SOFT;
  attribute BTR_NAME of ocx_tlx_wrap : entity is "OCX_TLX_WRAP";
  attribute RECURSIVE_SYNTHESIS of ocx_tlx_wrap : entity is 2;

end ocx_tlx_wrap;

architecture ocx_tlx_wrap of ocx_tlx_wrap is

  signal s0_axi_aclk    : std_ulogic;
  signal s0_axi_aresetn : std_ulogic;
  signal s0_axi_awid    : std_ulogic_vector(0 downto 0);
  signal s0_axi_awaddr  : std_ulogic_vector(63 downto 0);
  signal s0_axi_awlen   : std_ulogic_vector(7 downto 0);
  signal s0_axi_awsize  : std_ulogic_vector(2 downto 0);
  signal s0_axi_awburst : std_ulogic_vector(1 downto 0);
  signal s0_axi_awlock  : std_ulogic_vector(1 downto 0);
  signal s0_axi_awcache : std_ulogic_vector(3 downto 0);
  signal s0_axi_awprot  : std_ulogic_vector(2 downto 0);
  signal s0_axi_awvalid : std_ulogic;
  signal s0_axi_awready : std_ulogic;
  signal s0_axi_wid     : std_ulogic_vector(0 downto 0);
  signal s0_axi_wdata   : std_ulogic_vector(31 downto 0);
  signal s0_axi_wstrb   : std_ulogic_vector(3 downto 0);
  signal s0_axi_wlast   : std_ulogic;
  signal s0_axi_wvalid  : std_ulogic;
  signal s0_axi_wready  : std_ulogic;
  signal s0_axi_bid     : std_ulogic_vector(0 downto 0);
  signal s0_axi_bresp   : std_ulogic_vector(1 downto 0);
  signal s0_axi_bvalid  : std_ulogic;
  signal s0_axi_bready  : std_ulogic;
  signal s0_axi_arid    : std_ulogic_vector(0 downto 0);
  signal s0_axi_araddr  : std_ulogic_vector(63 downto 0);
  signal s0_axi_arlen   : std_ulogic_vector(7 downto 0);
  signal s0_axi_arsize  : std_ulogic_vector(2 downto 0);
  signal s0_axi_arburst : std_ulogic_vector(1 downto 0);
  signal s0_axi_arlock  : std_ulogic_vector(1 downto 0);
  signal s0_axi_arcache : std_ulogic_vector(3 downto 0);
  signal s0_axi_arprot  : std_ulogic_vector(2 downto 0);
  signal s0_axi_arvalid : std_ulogic;
  signal s0_axi_arready : std_ulogic;
  signal s0_axi_rid     : std_ulogic_vector(0 downto 0);
  signal s0_axi_rdata   : std_ulogic_vector(31 downto 0);
  signal s0_axi_rresp   : std_ulogic_vector(1 downto 0);
  signal s0_axi_rlast   : std_ulogic;
  signal s0_axi_rvalid  : std_ulogic;
  signal s0_axi_rready  : std_ulogic;

  signal s1_axi_aclk    : std_ulogic;
  signal s1_axi_aresetn : std_ulogic;
  signal s1_axi_awid    : std_ulogic_vector(0 downto 0);
  signal s1_axi_awaddr  : std_ulogic_vector(63 downto 0);
  signal s1_axi_awlen   : std_ulogic_vector(7 downto 0);
  signal s1_axi_awsize  : std_ulogic_vector(2 downto 0);
  signal s1_axi_awburst : std_ulogic_vector(1 downto 0);
  signal s1_axi_awlock  : std_ulogic_vector(1 downto 0);
  signal s1_axi_awcache : std_ulogic_vector(3 downto 0);
  signal s1_axi_awprot  : std_ulogic_vector(2 downto 0);
  signal s1_axi_awvalid : std_ulogic;
  signal s1_axi_awready : std_ulogic;
  signal s1_axi_wid     : std_ulogic_vector(0 downto 0);
  signal s1_axi_wdata   : std_ulogic_vector(31 downto 0);
  signal s1_axi_wstrb   : std_ulogic_vector(3 downto 0);
  signal s1_axi_wlast   : std_ulogic;
  signal s1_axi_wvalid  : std_ulogic;
  signal s1_axi_wready  : std_ulogic;
  signal s1_axi_bid     : std_ulogic_vector(0 downto 0);
  signal s1_axi_bresp   : std_ulogic_vector(1 downto 0);
  signal s1_axi_bvalid  : std_ulogic;
  signal s1_axi_bready  : std_ulogic;
  signal s1_axi_arid    : std_ulogic_vector(0 downto 0);
  signal s1_axi_araddr  : std_ulogic_vector(63 downto 0);
  signal s1_axi_arlen   : std_ulogic_vector(7 downto 0);
  signal s1_axi_arsize  : std_ulogic_vector(2 downto 0);
  signal s1_axi_arburst : std_ulogic_vector(1 downto 0);
  signal s1_axi_arlock  : std_ulogic_vector(1 downto 0);
  signal s1_axi_arcache : std_ulogic_vector(3 downto 0);
  signal s1_axi_arprot  : std_ulogic_vector(2 downto 0);
  signal s1_axi_arvalid : std_ulogic;
  signal s1_axi_arready : std_ulogic;
  signal s1_axi_rid     : std_ulogic_vector(0 downto 0);
  signal s1_axi_rdata   : std_ulogic_vector(31 downto 0);
  signal s1_axi_rresp   : std_ulogic_vector(1 downto 0);
  signal s1_axi_rlast   : std_ulogic;
  signal s1_axi_rvalid  : std_ulogic;
  signal s1_axi_rready  : std_ulogic;

  signal s2_axi_aclk    : std_ulogic;
  signal s2_axi_aresetn : std_ulogic;
  signal s2_axi_awid    : std_ulogic_vector(0 downto 0);
  signal s2_axi_awaddr  : std_ulogic_vector(63 downto 0);
  signal s2_axi_awlen   : std_ulogic_vector(7 downto 0);
  signal s2_axi_awsize  : std_ulogic_vector(2 downto 0);
  signal s2_axi_awburst : std_ulogic_vector(1 downto 0);
  signal s2_axi_awlock  : std_ulogic_vector(1 downto 0);
  signal s2_axi_awcache : std_ulogic_vector(3 downto 0);
  signal s2_axi_awprot  : std_ulogic_vector(2 downto 0);
  signal s2_axi_awvalid : std_ulogic;
  signal s2_axi_awready : std_ulogic;
  signal s2_axi_wid     : std_ulogic_vector(0 downto 0);
  signal s2_axi_wdata   : std_ulogic_vector(31 downto 0);
  signal s2_axi_wstrb   : std_ulogic_vector(3 downto 0);
  signal s2_axi_wlast   : std_ulogic;
  signal s2_axi_wvalid  : std_ulogic;
  signal s2_axi_wready  : std_ulogic;
  signal s2_axi_bid     : std_ulogic_vector(0 downto 0);
  signal s2_axi_bresp   : std_ulogic_vector(1 downto 0);
  signal s2_axi_bvalid  : std_ulogic;
  signal s2_axi_bready  : std_ulogic;
  signal s2_axi_arid    : std_ulogic_vector(0 downto 0);
  signal s2_axi_araddr  : std_ulogic_vector(63 downto 0);
  signal s2_axi_arlen   : std_ulogic_vector(7 downto 0);
  signal s2_axi_arsize  : std_ulogic_vector(2 downto 0);
  signal s2_axi_arburst : std_ulogic_vector(1 downto 0);
  signal s2_axi_arlock  : std_ulogic_vector(1 downto 0);
  signal s2_axi_arcache : std_ulogic_vector(3 downto 0);
  signal s2_axi_arprot  : std_ulogic_vector(2 downto 0);
  signal s2_axi_arvalid : std_ulogic;
  signal s2_axi_arready : std_ulogic;
  signal s2_axi_rid     : std_ulogic_vector(0 downto 0);
  signal s2_axi_rdata   : std_ulogic_vector(31 downto 0);
  signal s2_axi_rresp   : std_ulogic_vector(1 downto 0);
  signal s2_axi_rlast   : std_ulogic;
  signal s2_axi_rvalid  : std_ulogic;
  signal s2_axi_rready  : std_ulogic;

  signal s3_axi_aclk    : std_ulogic;
  signal s3_axi_aresetn : std_ulogic;
  signal s3_axi_awid    : std_ulogic_vector(11 downto 0);
  signal s3_axi_awaddr  : std_ulogic_vector(63 downto 0);
  signal s3_axi_awlen   : std_ulogic_vector(7 downto 0);
  signal s3_axi_awsize  : std_ulogic_vector(2 downto 0);
  signal s3_axi_awburst : std_ulogic_vector(1 downto 0);
  signal s3_axi_awlock  : std_ulogic_vector(1 downto 0);
  signal s3_axi_awcache : std_ulogic_vector(3 downto 0);
  signal s3_axi_awprot  : std_ulogic_vector(2 downto 0);
  signal s3_axi_awvalid : std_ulogic;
  signal s3_axi_awready : std_ulogic;
  signal s3_axi_wid     : std_ulogic_vector(11 downto 0);
  signal s3_axi_wdata   : std_ulogic_vector(511 downto 0);
  signal s3_axi_wstrb   : std_ulogic_vector(63 downto 0);
  signal s3_axi_wlast   : std_ulogic;
  signal s3_axi_wvalid  : std_ulogic;
  signal s3_axi_wready  : std_ulogic;
  signal s3_axi_bid     : std_ulogic_vector(11 downto 0);
  signal s3_axi_bresp   : std_ulogic_vector(1 downto 0);
  signal s3_axi_bvalid  : std_ulogic;
  signal s3_axi_bready  : std_ulogic;
  signal s3_axi_arid    : std_ulogic_vector(11 downto 0);
  signal s3_axi_araddr  : std_ulogic_vector(63 downto 0);
  signal s3_axi_arlen   : std_ulogic_vector(7 downto 0);
  signal s3_axi_arsize  : std_ulogic_vector(2 downto 0);
  signal s3_axi_arburst : std_ulogic_vector(1 downto 0);
  signal s3_axi_arlock  : std_ulogic_vector(1 downto 0);
  signal s3_axi_arcache : std_ulogic_vector(3 downto 0);
  signal s3_axi_arprot  : std_ulogic_vector(2 downto 0);
  signal s3_axi_arvalid : std_ulogic;
  signal s3_axi_arready : std_ulogic;
  signal s3_axi_rid     : std_ulogic_vector(11 downto 0);
  signal s3_axi_rdata   : std_ulogic_vector(511 downto 0);
  signal s3_axi_rresp   : std_ulogic_vector(1 downto 0);
  signal s3_axi_rlast   : std_ulogic;
  signal s3_axi_ruser   : std_ulogic_vector(2 downto 0);
  signal s3_axi_rvalid  : std_ulogic;
  signal s3_axi_rready  : std_ulogic;

  signal afu_tlx_resp_initial_credit     : std_ulogic_vector(6 downto 0);
  signal afu_tlx_resp_credit             : std_ulogic;
  signal tlx_afu_resp_valid              : std_ulogic;
  signal tlx_afu_resp_opcode             : std_ulogic_vector(7 downto 0);
  signal tlx_afu_resp_afutag             : std_ulogic_vector(15 downto 0);
  signal tlx_afu_resp_code               : std_ulogic_vector(3 downto 0);
  signal tlx_afu_resp_pg_size            : std_ulogic_vector(5 downto 0);
  signal tlx_afu_resp_dl                 : std_ulogic_vector(1 downto 0);
  signal tlx_afu_resp_dp                 : std_ulogic_vector(1 downto 0);
  signal tl_afu_resp_dp                  : std_ulogic_vector(2 downto 0);
  signal tlx_afu_resp_host_tag           : std_ulogic_vector(23 downto 0);
  signal tlx_afu_resp_cache_state        : std_ulogic_vector(3 downto 0);
  signal tlx_afu_resp_addr_tag           : std_ulogic_vector(17 downto 0);
  signal afu_tlx_resp_rd_req             : std_ulogic;
  signal afu_tlx_resp_rd_cnt             : std_ulogic_vector(2 downto 0);
  signal tlx_afu_resp_data_valid         : std_ulogic;
  signal tlx_afu_resp_data_bdi           : std_ulogic;
  signal tlx_afu_resp_data_xmeta         : std_ulogic_vector(63 downto 0);
  signal tlx_afu_resp_data_bus           : std_ulogic_vector(511 downto 0);
  signal tlx_afu_cmd_initial_credit      : std_ulogic_vector(3 downto 0);
  signal tlx_afu_cmd_credit              : std_ulogic;
  signal afu_tlx_cmd_valid               : std_ulogic;
  signal afu_tlx_cmd_opcode              : std_ulogic_vector(7 downto 0);
  signal afu_tlx_cmd_pa_or_obj           : std_ulogic_vector(63 downto 0);
  signal afu_tlx_cmd_afutag              : std_ulogic_vector(15 downto 0);
  signal afu_tlx_cmd_dl                  : std_ulogic_vector(1 downto 0);
  signal afu_tlx_cmd_pl                  : std_ulogic_vector(2 downto 0);
  signal afu_tlx_cmd_be                  : std_ulogic_vector(63 downto 0);
  signal afu_tlx_cmd_flag                : std_ulogic_vector(3 downto 0);
  signal afu_tlx_cmd_bdf                 : std_ulogic_vector(15 downto 0);
  signal afu_tlx_cmd_resp_code           : std_ulogic_vector(3 downto 0);
  signal afu_tlx_cmd_capptag             : std_ulogic_vector(15 downto 0);
  signal tlx_afu_cmd_data_initial_credit : std_ulogic_vector(5 downto 0);
  signal tlx_afu_cmd_data_credit         : std_ulogic;
  signal afu_tlx_cdata_valid             : std_ulogic;
  signal afu_tlx_cdata_bus               : std_ulogic_vector(511 downto 0);
  signal afu_tlx_cdata_bdi               : std_ulogic;
  signal memcntl_oc_cmd_ready            : std_ulogic;
  signal memcntl_oc_cmd_flag             : std_ulogic_vector(3 downto 0);
  signal memcntl_oc_cmd_tag              : std_ulogic_vector(15 downto 0);
  signal oc_memcntl_taken                : std_ulogic;
  signal rcv_xmt_tlx_credit_valid        : std_ulogic;
  signal rcv_xmt_tlx_credit_vc0          : std_ulogic_vector(3 downto 0);

  signal oc_mmio_skinny_axis_i   : t_AXI3_SLAVE_INPUT;
  signal oc_mmio_skinny_axis_o   : t_AXI3_SLAVE_OUTPUT;
  signal oc_memory_skinny_axis_i : t_AXI3_SLAVE_INPUT;
  signal oc_memory_skinny_axis_o : t_AXI3_SLAVE_OUTPUT;
  signal oc_cfg_skinny_axis_i    : t_AXI3_SLAVE_INPUT;
  signal oc_cfg_skinny_axis_o    : t_AXI3_SLAVE_OUTPUT;

  signal cfg_bar : std_ulogic_vector(63 downto 0);
  constant use_new_tl                : boolean := true;   -- always

  component ocx_tlx_top
    port (
      ---------------------------------------------------------------------------
      -- Clocking
      ---------------------------------------------------------------------------
      clock    : in    std_ulogic;
      reset_n  : in    std_ulogic;

      ---------------------------------------------------------------------------
      -- TLX Parser to AFU Receive Interface
      ---------------------------------------------------------------------------
      tlx_afu_ready : out std_ulogic;

      -- Command interface to AFU
      afu_tlx_cmd_initial_credit : in  std_ulogic_vector(6 downto 0);
      afu_tlx_cmd_credit         : in  std_ulogic;
      tlx_afu_cmd_valid          : out std_ulogic;
      tlx_afu_cmd_opcode         : out std_ulogic_vector(7 downto 0);
      tlx_afu_cmd_dl             : out std_ulogic_vector(1 downto 0);
      tlx_afu_cmd_end            : out std_ulogic;
      tlx_afu_cmd_pa             : out std_ulogic_vector(63 downto 0);
      tlx_afu_cmd_flag           : out std_ulogic_vector(3 downto 0);
      tlx_afu_cmd_os             : out std_ulogic;
      tlx_afu_cmd_capptag        : out std_ulogic_vector(15 downto 0);
      tlx_afu_cmd_pl             : out std_ulogic_vector(2 downto 0);
      tlx_afu_cmd_be             : out std_ulogic_vector(63 downto 0);

      -- Config Command interface to AFU
      cfg_tlx_initial_credit : in  std_ulogic_vector(3 downto 0);
      cfg_tlx_credit_return  : in  std_ulogic;
      tlx_cfg_valid          : out std_ulogic;
      tlx_cfg_opcode         : out std_ulogic_vector(7 downto 0);
      tlx_cfg_pa             : out std_ulogic_vector(63 downto 0);
      tlx_cfg_t              : out std_ulogic;
      tlx_cfg_pl             : out std_ulogic_vector(2 downto 0);
      tlx_cfg_capptag        : out std_ulogic_vector(15 downto 0);
      tlx_cfg_data_bus       : out std_ulogic_vector(31 downto 0);
      tlx_cfg_data_bdi       : out std_ulogic;

      -- Response interface to AFU
      afu_tlx_resp_initial_credit : in  std_ulogic_vector(6 downto 0);
      afu_tlx_resp_credit         : in  std_ulogic;
      tlx_afu_resp_valid          : out std_ulogic;
      tlx_afu_resp_opcode         : out std_ulogic_vector(7 downto 0);
      tlx_afu_resp_afutag         : out std_ulogic_vector(15 downto 0);
      tlx_afu_resp_code           : out std_ulogic_vector(3 downto 0);
      tlx_afu_resp_pg_size        : out std_ulogic_vector(5 downto 0);
      tlx_afu_resp_dl             : out std_ulogic_vector(1 downto 0);
      tlx_afu_resp_dp             : out std_ulogic_vector(1 downto 0);
      tlx_afu_resp_host_tag       : out std_ulogic_vector(23 downto 0);
      tlx_afu_resp_cache_state    : out std_ulogic_vector(3 downto 0);
      tlx_afu_resp_addr_tag       : out std_ulogic_vector(17 downto 0);

      -- Command data interface to AFU
      afu_tlx_cmd_rd_req     : in  std_ulogic;
      afu_tlx_cmd_rd_cnt     : in  std_ulogic_vector(2 downto 0);
      tlx_afu_cmd_data_valid : out std_ulogic;
      tlx_afu_cmd_data_bdi   : out std_ulogic;
      tlx_afu_cmd_data_bus   : out std_ulogic_vector(511 downto 0);

      -- Response data interface to AFU
      afu_tlx_resp_rd_req     : in  std_ulogic;
      afu_tlx_resp_rd_cnt     : in  std_ulogic_vector(2 downto 0);
      tlx_afu_resp_data_valid : out std_ulogic;
      tlx_afu_resp_data_bdi   : out std_ulogic;
      tlx_afu_resp_data_bus   : out std_ulogic_vector(511 downto 0);

      ---------------------------------------------------------------------------
      -- AFU to TLX Framer Transmit Interface
      ---------------------------------------------------------------------------
      -- Commands from AFU
      tlx_afu_cmd_initial_credit : out std_ulogic_vector(3 downto 0);
      tlx_afu_cmd_credit    : out std_ulogic;
      afu_tlx_cmd_valid     : in  std_ulogic;
      afu_tlx_cmd_opcode    : in  std_ulogic_vector(7 downto 0);
      afu_tlx_cmd_pa_or_obj : in  std_ulogic_vector(63 downto 0);
      afu_tlx_cmd_afutag    : in  std_ulogic_vector(15 downto 0);
      afu_tlx_cmd_dl        : in  std_ulogic_vector(1 downto 0);
      afu_tlx_cmd_pl        : in  std_ulogic_vector(2 downto 0);
      afu_tlx_cmd_be        : in  std_ulogic_vector(63 downto 0);
      afu_tlx_cmd_flag      : in  std_ulogic_vector(3 downto 0);
      afu_tlx_cmd_bdf       : in  std_ulogic_vector(15 downto 0);
      afu_tlx_cmd_resp_code : in  std_ulogic_vector(3 downto 0);
      afu_tlx_cmd_capptag   : in  std_ulogic_vector(15 downto 0);

      -- Command data from AFU
      tlx_afu_cmd_data_initial_credit : out std_ulogic_vector(5 downto 0);
      tlx_afu_cmd_data_credit : out std_ulogic;
      afu_tlx_cdata_valid     : in  std_ulogic;
      afu_tlx_cdata_bus       : in  std_ulogic_vector(511 downto 0);
      afu_tlx_cdata_bdi       : in  std_ulogic;

      -- Responses from AFU
      tlx_afu_resp_initial_credit : out std_ulogic_vector(3 downto 0);
      tlx_afu_resp_credit  : out std_ulogic;
      afu_tlx_resp_valid   : in  std_ulogic;
      afu_tlx_resp_opcode  : in  std_ulogic_vector(7 downto 0);
      afu_tlx_resp_dl      : in  std_ulogic_vector(1 downto 0);
      afu_tlx_resp_capptag : in  std_ulogic_vector(15 downto 0);
      afu_tlx_resp_dp      : in  std_ulogic_vector(1 downto 0);
      afu_tlx_resp_code    : in  std_ulogic_vector(3 downto 0);

      -- Response data from AFU
      tlx_afu_resp_data_initial_credit : out std_ulogic_vector(5 downto 0);
      tlx_afu_resp_data_credit : out std_ulogic;
      afu_tlx_rdata_valid      : in  std_ulogic;
      afu_tlx_rdata_bus        : in  std_ulogic_vector(511 downto 0);
      afu_tlx_rdata_bdi        : in  std_ulogic;

      -- Config Responses from AFU
      cfg_tlx_resp_valid   : in std_ulogic;
      cfg_tlx_resp_opcode  : in std_ulogic_vector(7 downto 0);
      cfg_tlx_resp_capptag : in std_ulogic_vector(15 downto 0);
      cfg_tlx_resp_code    : in std_ulogic_vector(3 downto 0);
      tlx_cfg_resp_ack     : out std_ulogic;

      -- Config Response data from AFU
      cfg_tlx_rdata_offset : in std_ulogic_vector(3 downto 0);
      cfg_tlx_rdata_bus    : in std_ulogic_vector(31 downto 0);
      cfg_tlx_rdata_bdi    : in std_ulogic;

      ---------------------------------------------------------------------------
      -- DLX to TLX Parser Interface
      ---------------------------------------------------------------------------
      dlx_tlx_flit_valid   : in std_ulogic;
      dlx_tlx_flit         : in std_ulogic_vector(511 downto 0);
      dlx_tlx_flit_crc_err : in std_ulogic;
      dlx_tlx_link_up      : in std_ulogic;

      -----------------------------------------------------------------------
      -- TLX Framer to DLX Interface
      -----------------------------------------------------------------------
      dlx_tlx_init_flit_depth : in  std_ulogic_vector(2 downto 0);
      dlx_tlx_flit_credit     : in  std_ulogic;
      tlx_dlx_flit_valid      : out std_ulogic;
      tlx_dlx_flit            : out std_ulogic_vector(511 downto 0);
      tlx_dlx_debug_encode    : out std_ulogic_vector(3 downto 0);
      tlx_dlx_debug_info      : out std_ulogic_vector(31 downto 0);
      dlx_tlx_dlx_config_info : in  std_ulogic_vector(31 downto 0);

      ---------------------------------------------------------------------------
      -- Configuration Ports
      ---------------------------------------------------------------------------
      tlx_cfg_oc3_tlx_version : out std_ulogic_vector(31 downto 0);

      cfg_tlx_xmit_tmpl_config_0 : in std_ulogic;
      cfg_tlx_xmit_tmpl_config_1 : in std_ulogic;
      cfg_tlx_xmit_tmpl_config_2 : in std_ulogic;
      cfg_tlx_xmit_tmpl_config_3 : in std_ulogic;
      cfg_tlx_xmit_rate_config_0 : in std_ulogic_vector(3 downto 0);
      cfg_tlx_xmit_rate_config_1 : in std_ulogic_vector(3 downto 0);
      cfg_tlx_xmit_rate_config_2 : in std_ulogic_vector(3 downto 0);
      cfg_tlx_xmit_rate_config_3 : in std_ulogic_vector(3 downto 0);

      tlx_cfg_in_rcv_tmpl_capability_0 : out std_ulogic;
      tlx_cfg_in_rcv_tmpl_capability_1 : out std_ulogic;
      tlx_cfg_in_rcv_tmpl_capability_2 : out std_ulogic;
      tlx_cfg_in_rcv_tmpl_capability_3 : out std_ulogic;
      tlx_cfg_in_rcv_rate_capability_0 : out std_ulogic_vector(3 downto 0);
      tlx_cfg_in_rcv_rate_capability_1 : out std_ulogic_vector(3 downto 0);
      tlx_cfg_in_rcv_rate_capability_2 : out std_ulogic_vector(3 downto 0);
      tlx_cfg_in_rcv_rate_capability_3 : out std_ulogic_vector(3 downto 0)
      );
  end component;

  component ocx_tlx_axi
    generic (
      ADDR_WIDTH     :    natural;
      AXI_DATA_WIDTH :    natural;
      OC_DATA_WIDTH  :    natural;
      ID_WIDTH       :    natural
      );
    port (
      -- Global
      s0_axi_aclk    : in std_ulogic;
      s0_axi_aresetn : in std_ulogic;

      -- Write Address Channel
      s0_axi_awid    : in  std_ulogic_vector(0 downto 0);
      s0_axi_awaddr  : in  std_ulogic_vector(63 downto 0);
      s0_axi_awlen   : in  std_ulogic_vector(7 downto 0);
      s0_axi_awsize  : in  std_ulogic_vector(2 downto 0);
      s0_axi_awburst : in  std_ulogic_vector(1 downto 0);
      s0_axi_awlock  : in  std_ulogic_vector(1 downto 0);
      s0_axi_awcache : in  std_ulogic_vector(3 downto 0);
      s0_axi_awprot  : in  std_ulogic_vector(2 downto 0);
      s0_axi_awvalid : in  std_ulogic;
      s0_axi_awready : out std_ulogic;

      -- Write Data Channel
      s0_axi_wid    : in  std_ulogic_vector(0 downto 0);
      s0_axi_wdata  : in  std_ulogic_vector(31 downto 0);
      s0_axi_wstrb  : in  std_ulogic_vector(3 downto 0);
      s0_axi_wlast  : in  std_ulogic;
      s0_axi_wvalid : in  std_ulogic;
      s0_axi_wready : out std_ulogic;

      -- Write Response Channel
      s0_axi_bid    : out std_ulogic_vector(0 downto 0);
      s0_axi_bresp  : out std_ulogic_vector(1 downto 0);
      s0_axi_bvalid : out std_ulogic;
      s0_axi_bready : in  std_ulogic;

      -- Read Address Channel
      s0_axi_arid    : in  std_ulogic_vector(0 downto 0);
      s0_axi_araddr  : in  std_ulogic_vector(63 downto 0);
      s0_axi_arlen   : in  std_ulogic_vector(7 downto 0);
      s0_axi_arsize  : in  std_ulogic_vector(2 downto 0);
      s0_axi_arburst : in  std_ulogic_vector(1 downto 0);
      s0_axi_arlock  : in  std_ulogic_vector(1 downto 0);
      s0_axi_arcache : in  std_ulogic_vector(3 downto 0);
      s0_axi_arprot  : in  std_ulogic_vector(2 downto 0);
      s0_axi_arvalid : in  std_ulogic;
      s0_axi_arready : out std_ulogic;

      -- Read Data Channel
      s0_axi_rid    : out std_ulogic_vector(0 downto 0);
      s0_axi_rdata  : out std_ulogic_vector(31 downto 0);
      s0_axi_rresp  : out std_ulogic_vector(1 downto 0);
      s0_axi_rlast  : out std_ulogic;
      s0_axi_rvalid : out std_ulogic;
      s0_axi_rready : in  std_ulogic;

      -- Global
      s1_axi_aclk    : in std_ulogic;
      s1_axi_aresetn : in std_ulogic;

      -- Write Address Channel
      s1_axi_awid    : in  std_ulogic_vector(0 downto 0);
      s1_axi_awaddr  : in  std_ulogic_vector(63 downto 0);
      s1_axi_awlen   : in  std_ulogic_vector(7 downto 0);
      s1_axi_awsize  : in  std_ulogic_vector(2 downto 0);
      s1_axi_awburst : in  std_ulogic_vector(1 downto 0);
      s1_axi_awlock  : in  std_ulogic_vector(1 downto 0);
      s1_axi_awcache : in  std_ulogic_vector(3 downto 0);
      s1_axi_awprot  : in  std_ulogic_vector(2 downto 0);
      s1_axi_awvalid : in  std_ulogic;
      s1_axi_awready : out std_ulogic;

      -- Write Data Channel
      s1_axi_wid    : in  std_ulogic_vector(0 downto 0);
      s1_axi_wdata  : in  std_ulogic_vector(31 downto 0);
      s1_axi_wstrb  : in  std_ulogic_vector(3 downto 0);
      s1_axi_wlast  : in  std_ulogic;
      s1_axi_wvalid : in  std_ulogic;
      s1_axi_wready : out std_ulogic;

      -- Write Response Channel
      s1_axi_bid    : out std_ulogic_vector(0 downto 0);
      s1_axi_bresp  : out std_ulogic_vector(1 downto 0);
      s1_axi_bvalid : out std_ulogic;
      s1_axi_bready : in  std_ulogic;

      -- Read Address Channel
      s1_axi_arid    : in  std_ulogic_vector(0 downto 0);
      s1_axi_araddr  : in  std_ulogic_vector(63 downto 0);
      s1_axi_arlen   : in  std_ulogic_vector(7 downto 0);
      s1_axi_arsize  : in  std_ulogic_vector(2 downto 0);
      s1_axi_arburst : in  std_ulogic_vector(1 downto 0);
      s1_axi_arlock  : in  std_ulogic_vector(1 downto 0);
      s1_axi_arcache : in  std_ulogic_vector(3 downto 0);
      s1_axi_arprot  : in  std_ulogic_vector(2 downto 0);
      s1_axi_arvalid : in  std_ulogic;
      s1_axi_arready : out std_ulogic;

      -- Read Data Channel
      s1_axi_rid    : out std_ulogic_vector(0 downto 0);
      s1_axi_rdata  : out std_ulogic_vector(31 downto 0);
      s1_axi_rresp  : out std_ulogic_vector(1 downto 0);
      s1_axi_rlast  : out std_ulogic;
      s1_axi_rvalid : out std_ulogic;
      s1_axi_rready : in  std_ulogic;

      -- Global
      s2_axi_aclk    : in std_ulogic;
      s2_axi_aresetn : in std_ulogic;

      -- Write Address Channel
      s2_axi_awid    : in  std_ulogic_vector(0 downto 0);
      s2_axi_awaddr  : in  std_ulogic_vector(63 downto 0);
      s2_axi_awlen   : in  std_ulogic_vector(7 downto 0);
      s2_axi_awsize  : in  std_ulogic_vector(2 downto 0);
      s2_axi_awburst : in  std_ulogic_vector(1 downto 0);
      s2_axi_awlock  : in  std_ulogic_vector(1 downto 0);
      s2_axi_awcache : in  std_ulogic_vector(3 downto 0);
      s2_axi_awprot  : in  std_ulogic_vector(2 downto 0);
      s2_axi_awvalid : in  std_ulogic;
      s2_axi_awready : out std_ulogic;

      -- Write Data Channel
      s2_axi_wid    : in  std_ulogic_vector(0 downto 0);
      s2_axi_wdata  : in  std_ulogic_vector(31 downto 0);
      s2_axi_wstrb  : in  std_ulogic_vector(3 downto 0);
      s2_axi_wlast  : in  std_ulogic;
      s2_axi_wvalid : in  std_ulogic;
      s2_axi_wready : out std_ulogic;

      -- Write Response Channel
      s2_axi_bid    : out std_ulogic_vector(0 downto 0);
      s2_axi_bresp  : out std_ulogic_vector(1 downto 0);
      s2_axi_bvalid : out std_ulogic;
      s2_axi_bready : in  std_ulogic;

      -- Read Address Channel
      s2_axi_arid    : in  std_ulogic_vector(0 downto 0);
      s2_axi_araddr  : in  std_ulogic_vector(63 downto 0);
      s2_axi_arlen   : in  std_ulogic_vector(7 downto 0);
      s2_axi_arsize  : in  std_ulogic_vector(2 downto 0);
      s2_axi_arburst : in  std_ulogic_vector(1 downto 0);
      s2_axi_arlock  : in  std_ulogic_vector(1 downto 0);
      s2_axi_arcache : in  std_ulogic_vector(3 downto 0);
      s2_axi_arprot  : in  std_ulogic_vector(2 downto 0);
      s2_axi_arvalid : in  std_ulogic;
      s2_axi_arready : out std_ulogic;

      -- Read Data Channel
      s2_axi_rid    : out std_ulogic_vector(0 downto 0);
      s2_axi_rdata  : out std_ulogic_vector(31 downto 0);
      s2_axi_rresp  : out std_ulogic_vector(1 downto 0);
      s2_axi_rlast  : out std_ulogic;
      s2_axi_rvalid : out std_ulogic;
      s2_axi_rready : in  std_ulogic;

      -- Global
      s3_axi_aclk    : in std_ulogic;
      s3_axi_aresetn : in std_ulogic;

      -- Write Address Channel
      s3_axi_awid    : in  std_ulogic_vector(11 downto 0);
      s3_axi_awaddr  : in  std_ulogic_vector(63 downto 0);
      s3_axi_awlen   : in  std_ulogic_vector(7 downto 0);
      s3_axi_awsize  : in  std_ulogic_vector(2 downto 0);
      s3_axi_awburst : in  std_ulogic_vector(1 downto 0);
      s3_axi_awlock  : in  std_ulogic_vector(1 downto 0);
      s3_axi_awcache : in  std_ulogic_vector(3 downto 0);
      s3_axi_awprot  : in  std_ulogic_vector(2 downto 0);
      s3_axi_awvalid : in  std_ulogic;
      s3_axi_awready : out std_ulogic;

      -- Write Data Channel
      s3_axi_wid    : in  std_ulogic_vector(11 downto 0);
      s3_axi_wdata  : in  std_ulogic_vector(511 downto 0);
      s3_axi_wstrb  : in  std_ulogic_vector(63 downto 0);
      s3_axi_wlast  : in  std_ulogic;
      s3_axi_wvalid : in  std_ulogic;
      s3_axi_wready : out std_ulogic;

      -- Write Response Channel
      s3_axi_bid    : out std_ulogic_vector(11 downto 0);
      s3_axi_bresp  : out std_ulogic_vector(1 downto 0);
      s3_axi_bvalid : out std_ulogic;
      s3_axi_bready : in  std_ulogic;

      -- Read Address Channel
      s3_axi_arid    : in  std_ulogic_vector(11 downto 0);
      s3_axi_araddr  : in  std_ulogic_vector(63 downto 0);
      s3_axi_arlen   : in  std_ulogic_vector(7 downto 0);
      s3_axi_arsize  : in  std_ulogic_vector(2 downto 0);
      s3_axi_arburst : in  std_ulogic_vector(1 downto 0);
      s3_axi_arlock  : in  std_ulogic_vector(1 downto 0);
      s3_axi_arcache : in  std_ulogic_vector(3 downto 0);
      s3_axi_arprot  : in  std_ulogic_vector(2 downto 0);
      s3_axi_arvalid : in  std_ulogic;
      s3_axi_arready : out std_ulogic;

      -- Read Data Channel
      s3_axi_rid    : out std_ulogic_vector(11 downto 0);
      s3_axi_rdata  : out std_ulogic_vector(511 downto 0);
      s3_axi_rresp  : out std_ulogic_vector(1 downto 0);
      s3_axi_rlast  : out std_ulogic;
      s3_axi_ruser  : out std_ulogic_vector(2 downto 0);
      s3_axi_rvalid : out std_ulogic;
      s3_axi_rready : in  std_ulogic;

      -- TL Command Interface
      -- Command
      tlx_afu_cmd_initial_credit : in  std_ulogic_vector(3 downto 0);
      tlx_afu_cmd_credit    : in  std_ulogic;
      afu_tlx_cmd_valid     : out std_ulogic;
      afu_tlx_cmd_opcode    : out std_ulogic_vector(7 downto 0);
      afu_tlx_cmd_pa_or_obj : out std_ulogic_vector(63 downto 0);
      afu_tlx_cmd_afutag    : out std_ulogic_vector(15 downto 0);
      afu_tlx_cmd_dl        : out std_ulogic_vector(1 downto 0);
      afu_tlx_cmd_pl        : out std_ulogic_vector(2 downto 0);
      afu_tlx_cmd_be        : out std_ulogic_vector(63 downto 0);
      afu_tlx_cmd_flag      : out std_ulogic_vector(3 downto 0);
      afu_tlx_cmd_bdf       : out std_ulogic_vector(15 downto 0);
      afu_tlx_cmd_resp_code : out std_ulogic_vector(3 downto 0);
      afu_tlx_cmd_capptag   : out std_ulogic_vector(15 downto 0);

      -- Command data
      tlx_afu_cmd_data_initial_credit : in  std_ulogic_vector(5 downto 0);
      tlx_afu_cmd_data_credit : in  std_ulogic;
      afu_tlx_cdata_valid     : out std_ulogic;
      afu_tlx_cdata_bus       : out std_ulogic_vector(511 downto 0);
      afu_tlx_cdata_bdi       : out std_ulogic;

      -- Response
      afu_tlx_resp_initial_credit : out std_ulogic_vector(6 downto 0);
      afu_tlx_resp_credit         : out std_ulogic;
      tlx_afu_resp_valid          : in  std_ulogic;
      tlx_afu_resp_opcode         : in  std_ulogic_vector(7 downto 0);
      tlx_afu_resp_afutag         : in  std_ulogic_vector(15 downto 0);
      tlx_afu_resp_code           : in  std_ulogic_vector(3 downto 0);
      tlx_afu_resp_pg_size        : in  std_ulogic_vector(5 downto 0);
      tlx_afu_resp_dl             : in  std_ulogic_vector(1 downto 0);
      tlx_afu_resp_dp             : in  std_ulogic_vector(1 downto 0);
      tlx_afu_resp_host_tag       : in  std_ulogic_vector(23 downto 0);
      tlx_afu_resp_cache_state    : in  std_ulogic_vector(3 downto 0);
      tlx_afu_resp_addr_tag       : in  std_ulogic_vector(17 downto 0);

      -- Response data
      afu_tlx_resp_rd_req     : out std_ulogic;
      afu_tlx_resp_rd_cnt     : out std_ulogic_vector(2 downto 0);
      tlx_afu_resp_data_valid : in  std_ulogic;
      tlx_afu_resp_data_bdi   : in  std_ulogic;
      tlx_afu_resp_data_bus   : in  std_ulogic_vector(511 downto 0);

      -- mem_cntl
      memcntl_oc_cmd_ready       : in  std_ulogic;
      memcntl_oc_cmd_flag        : in  std_ulogic_vector(3 downto 0);
      memcntl_oc_cmd_tag         : in  std_ulogic_vector(15 downto 0);
      oc_memcntl_taken           : out std_ulogic ;

      -- Configuration
      cfg_bar : in std_ulogic_vector(63 downto 0)
      );
    end component;

begin

  cfg_bar <= reg_03_o & x"00000000";

  -----------------------------------------------------------------------------
  -- AXI3 Record
  -----------------------------------------------------------------------------
  -- Global
  s0_axi_aclk    <= oc_mmio_axis_aclk;
  s0_axi_aresetn <= oc_mmio_axis_i.s0_axi_aresetn;

  -- Write Address Channel
  s0_axi_awid(0 downto 0)              <= oc_mmio_skinny_axis_i.s0_axi_awid(0 downto 0);
  s0_axi_awaddr(63 downto 0)           <= oc_mmio_skinny_axis_i.s0_axi_awaddr(63 downto 0);
  s0_axi_awlen(7 downto 0)             <= "0000" & oc_mmio_skinny_axis_i.s0_axi_awlen(3 downto 0);
  s0_axi_awsize(2 downto 0)            <= oc_mmio_skinny_axis_i.s0_axi_awsize(2 downto 0);
  s0_axi_awburst(1 downto 0)           <= oc_mmio_skinny_axis_i.s0_axi_awburst(1 downto 0);
  s0_axi_awlock(1 downto 0)            <= oc_mmio_skinny_axis_i.s0_axi_awlock(1 downto 0);
  s0_axi_awcache(3 downto 0)           <= oc_mmio_skinny_axis_i.s0_axi_awcache(3 downto 0);
  s0_axi_awprot(2 downto 0)            <= oc_mmio_skinny_axis_i.s0_axi_awprot(2 downto 0);
  s0_axi_awvalid                       <= oc_mmio_skinny_axis_i.s0_axi_awvalid;
  oc_mmio_skinny_axis_o.s0_axi_awready <= s0_axi_awready;

  -- Write Data Channel
  s0_axi_wid(0 downto 0)              <= oc_mmio_skinny_axis_i.s0_axi_wid(0 downto 0);
  s0_axi_wdata(31 downto 0)           <= oc_mmio_skinny_axis_i.s0_axi_wdata(31 downto 0);
  s0_axi_wstrb(3 downto 0)            <= oc_mmio_skinny_axis_i.s0_axi_wstrb(3 downto 0);
  s0_axi_wlast                        <= oc_mmio_skinny_axis_i.s0_axi_wlast;
  s0_axi_wvalid                       <= oc_mmio_skinny_axis_i.s0_axi_wvalid;
  oc_mmio_skinny_axis_o.s0_axi_wready <= s0_axi_wready;

  -- Write Response Channel
  oc_mmio_skinny_axis_o.s0_axi_bid(6 downto 0)   <= "000000" & s0_axi_bid(0 downto 0);
  oc_mmio_skinny_axis_o.s0_axi_bresp(1 downto 0) <= s0_axi_bresp(1 downto 0);
  oc_mmio_skinny_axis_o.s0_axi_bvalid            <= s0_axi_bvalid;
  s0_axi_bready                                  <= oc_mmio_skinny_axis_i.s0_axi_bready;

  -- Read Address Channel
  s0_axi_arid(0 downto 0)              <= oc_mmio_skinny_axis_i.s0_axi_arid(0 downto 0);
  s0_axi_araddr(63 downto 0)           <= oc_mmio_skinny_axis_i.s0_axi_araddr(63 downto 0);
  s0_axi_arlen(7 downto 0)             <= "0000" & oc_mmio_skinny_axis_i.s0_axi_arlen(3 downto 0);
  s0_axi_arsize(2 downto 0)            <= oc_mmio_skinny_axis_i.s0_axi_arsize(2 downto 0);
  s0_axi_arburst(1 downto 0)           <= oc_mmio_skinny_axis_i.s0_axi_arburst(1 downto 0);
  s0_axi_arlock(1 downto 0)            <= oc_mmio_skinny_axis_i.s0_axi_arlock(1 downto 0);
  s0_axi_arcache(3 downto 0)           <= oc_mmio_skinny_axis_i.s0_axi_arcache(3 downto 0);
  s0_axi_arprot(2 downto 0)            <= oc_mmio_skinny_axis_i.s0_axi_arprot(2 downto 0);
  s0_axi_arvalid                       <= oc_mmio_skinny_axis_i.s0_axi_arvalid;
  oc_mmio_skinny_axis_o.s0_axi_arready <= s0_axi_arready;

  -- Read Data Channel
  oc_mmio_skinny_axis_o.s0_axi_rid(6 downto 0)    <= "000000" & s0_axi_rid(0 downto 0);
  oc_mmio_skinny_axis_o.s0_axi_rdata(31 downto 0) <= s0_axi_rdata(31 downto 0);
  oc_mmio_skinny_axis_o.s0_axi_rresp(1 downto 0)  <= s0_axi_rresp(1 downto 0);
  oc_mmio_skinny_axis_o.s0_axi_rlast              <= s0_axi_rlast;
  oc_mmio_skinny_axis_o.s0_axi_rvalid             <= s0_axi_rvalid;
  s0_axi_rready                                   <= oc_mmio_skinny_axis_i.s0_axi_rready;

  -- Global
  s1_axi_aclk    <= oc_memory_axis_aclk;
  s1_axi_aresetn <= oc_memory_skinny_axis_i.s0_axi_aresetn;

  -- Write Address Channel
  s1_axi_awid(0 downto 0)                <= oc_memory_skinny_axis_i.s0_axi_awid(0 downto 0);
  s1_axi_awaddr(63 downto 0)             <= oc_memory_skinny_axis_i.s0_axi_awaddr(63 downto 0);
  s1_axi_awlen(7 downto 0)               <= "0000" & oc_memory_skinny_axis_i.s0_axi_awlen(3 downto 0);
  s1_axi_awsize(2 downto 0)              <= oc_memory_skinny_axis_i.s0_axi_awsize(2 downto 0);
  s1_axi_awburst(1 downto 0)             <= oc_memory_skinny_axis_i.s0_axi_awburst(1 downto 0);
  s1_axi_awlock(1 downto 0)              <= oc_memory_skinny_axis_i.s0_axi_awlock(1 downto 0);
  s1_axi_awcache(3 downto 0)             <= oc_memory_skinny_axis_i.s0_axi_awcache(3 downto 0);
  s1_axi_awprot(2 downto 0)              <= oc_memory_skinny_axis_i.s0_axi_awprot(2 downto 0);
  s1_axi_awvalid                         <= oc_memory_skinny_axis_i.s0_axi_awvalid;
  oc_memory_skinny_axis_o.s0_axi_awready <= s1_axi_awready;

  -- Write Data Channel
  s1_axi_wid(0 downto 0)                <= oc_memory_skinny_axis_i.s0_axi_wid(0 downto 0);
  s1_axi_wdata(31 downto 0)             <= oc_memory_skinny_axis_i.s0_axi_wdata(31 downto 0);
  s1_axi_wstrb(3 downto 0)              <= oc_memory_skinny_axis_i.s0_axi_wstrb(3 downto 0);
  s1_axi_wlast                          <= oc_memory_skinny_axis_i.s0_axi_wlast;
  s1_axi_wvalid                         <= oc_memory_skinny_axis_i.s0_axi_wvalid;
  oc_memory_skinny_axis_o.s0_axi_wready <= s1_axi_wready;

  -- Write Response Channel
  oc_memory_skinny_axis_o.s0_axi_bid(6 downto 0)   <= "000000" & s1_axi_bid(0 downto 0);
  oc_memory_skinny_axis_o.s0_axi_bresp(1 downto 0) <= s1_axi_bresp(1 downto 0);
  oc_memory_skinny_axis_o.s0_axi_bvalid            <= s1_axi_bvalid;
  s1_axi_bready                                    <= oc_memory_skinny_axis_i.s0_axi_bready;

  -- Read Address Channel
  s1_axi_arid(0 downto 0)                <= oc_memory_skinny_axis_i.s0_axi_arid(0 downto 0);
  s1_axi_araddr(63 downto 0)             <= oc_memory_skinny_axis_i.s0_axi_araddr(63 downto 0);
  s1_axi_arlen(7 downto 0)               <= "0000" & oc_memory_skinny_axis_i.s0_axi_arlen(3 downto 0);
  s1_axi_arsize(2 downto 0)              <= oc_memory_skinny_axis_i.s0_axi_arsize(2 downto 0);
  s1_axi_arburst(1 downto 0)             <= oc_memory_skinny_axis_i.s0_axi_arburst(1 downto 0);
  s1_axi_arlock(1 downto 0)              <= oc_memory_skinny_axis_i.s0_axi_arlock(1 downto 0);
  s1_axi_arcache(3 downto 0)             <= oc_memory_skinny_axis_i.s0_axi_arcache(3 downto 0);
  s1_axi_arprot(2 downto 0)              <= oc_memory_skinny_axis_i.s0_axi_arprot(2 downto 0);
  s1_axi_arvalid                         <= oc_memory_skinny_axis_i.s0_axi_arvalid;
  oc_memory_skinny_axis_o.s0_axi_arready <= s1_axi_arready;

  -- Read Data Channel
  oc_memory_skinny_axis_o.s0_axi_rid(6 downto 0)    <= "000000" & s1_axi_rid(0 downto 0);
  oc_memory_skinny_axis_o.s0_axi_rdata(31 downto 0) <= s1_axi_rdata(31 downto 0);
  oc_memory_skinny_axis_o.s0_axi_rresp(1 downto 0)  <= s1_axi_rresp(1 downto 0);
  oc_memory_skinny_axis_o.s0_axi_rlast              <= s1_axi_rlast;
  oc_memory_skinny_axis_o.s0_axi_rvalid             <= s1_axi_rvalid;
  s1_axi_rready                                     <= oc_memory_skinny_axis_i.s0_axi_rready;

  -- Global
  s2_axi_aclk    <= oc_cfg_axis_aclk;
  s2_axi_aresetn <= oc_cfg_skinny_axis_i.s0_axi_aresetn;

  -- Write Address Channel
  s2_axi_awid(0 downto 0)             <= oc_cfg_skinny_axis_i.s0_axi_awid(0 downto 0);
  s2_axi_awaddr(63 downto 0)          <= oc_cfg_skinny_axis_i.s0_axi_awaddr(63 downto 0);
  s2_axi_awlen(7 downto 0)            <= "0000" & oc_cfg_skinny_axis_i.s0_axi_awlen(3 downto 0);
  s2_axi_awsize(2 downto 0)           <= oc_cfg_skinny_axis_i.s0_axi_awsize(2 downto 0);
  s2_axi_awburst(1 downto 0)          <= oc_cfg_skinny_axis_i.s0_axi_awburst(1 downto 0);
  s2_axi_awlock(1 downto 0)           <= oc_cfg_skinny_axis_i.s0_axi_awlock(1 downto 0);
  s2_axi_awcache(3 downto 0)          <= oc_cfg_skinny_axis_i.s0_axi_awcache(3 downto 0);
  s2_axi_awprot(2 downto 0)           <= oc_cfg_skinny_axis_i.s0_axi_awprot(2 downto 0);
  s2_axi_awvalid                      <= oc_cfg_skinny_axis_i.s0_axi_awvalid;
  oc_cfg_skinny_axis_o.s0_axi_awready <= s2_axi_awready;

  -- Write Data Channel
  s2_axi_wid(0 downto 0)             <= oc_cfg_skinny_axis_i.s0_axi_wid(0 downto 0);
  s2_axi_wdata(31 downto 0)          <= oc_cfg_skinny_axis_i.s0_axi_wdata(31 downto 0);
  s2_axi_wstrb(3 downto 0)           <= oc_cfg_skinny_axis_i.s0_axi_wstrb(3 downto 0);
  s2_axi_wlast                       <= oc_cfg_skinny_axis_i.s0_axi_wlast;
  s2_axi_wvalid                      <= oc_cfg_skinny_axis_i.s0_axi_wvalid;
  oc_cfg_skinny_axis_o.s0_axi_wready <= s2_axi_wready;

  -- Write Response Channel
  oc_cfg_skinny_axis_o.s0_axi_bid(6 downto 0)   <= "000000" & s2_axi_bid(0 downto 0);
  oc_cfg_skinny_axis_o.s0_axi_bresp(1 downto 0) <= s2_axi_bresp(1 downto 0);
  oc_cfg_skinny_axis_o.s0_axi_bvalid            <= s2_axi_bvalid;
  s2_axi_bready                                 <= oc_cfg_skinny_axis_i.s0_axi_bready;

  -- Read Address Channel
  s2_axi_arid(0 downto 0)             <= oc_cfg_skinny_axis_i.s0_axi_arid(0 downto 0);
  s2_axi_araddr(63 downto 0)          <= oc_cfg_skinny_axis_i.s0_axi_araddr(63 downto 0);
  s2_axi_arlen(7 downto 0)            <= "0000" & oc_cfg_skinny_axis_i.s0_axi_arlen(3 downto 0);
  s2_axi_arsize(2 downto 0)           <= oc_cfg_skinny_axis_i.s0_axi_arsize(2 downto 0);
  s2_axi_arburst(1 downto 0)          <= oc_cfg_skinny_axis_i.s0_axi_arburst(1 downto 0);
  s2_axi_arlock(1 downto 0)           <= oc_cfg_skinny_axis_i.s0_axi_arlock(1 downto 0);
  s2_axi_arcache(3 downto 0)          <= oc_cfg_skinny_axis_i.s0_axi_arcache(3 downto 0);
  s2_axi_arprot(2 downto 0)           <= oc_cfg_skinny_axis_i.s0_axi_arprot(2 downto 0);
  s2_axi_arvalid                      <= oc_cfg_skinny_axis_i.s0_axi_arvalid;
  oc_cfg_skinny_axis_o.s0_axi_arready <= s2_axi_arready;

  -- Read Data Channel
  oc_cfg_skinny_axis_o.s0_axi_rid(6 downto 0)    <= "000000" & s2_axi_rid(0 downto 0);
  oc_cfg_skinny_axis_o.s0_axi_rdata(31 downto 0) <= s2_axi_rdata(31 downto 0);
  oc_cfg_skinny_axis_o.s0_axi_rresp(1 downto 0)  <= s2_axi_rresp(1 downto 0);
  oc_cfg_skinny_axis_o.s0_axi_rlast              <= s2_axi_rlast;
  oc_cfg_skinny_axis_o.s0_axi_rvalid             <= s2_axi_rvalid;
  s2_axi_rready                                  <= oc_cfg_skinny_axis_i.s0_axi_rready;

  -- Global
  s3_axi_aclk    <= oc_fbist_axis_aclk;
  s3_axi_aresetn <= oc_fbist_axis_i.s0_axi_aresetn;

  -- Write Address Channel
  s3_axi_awid(11 downto 0)       <= oc_fbist_axis_i.s0_axi_awid(11 downto 0);
  s3_axi_awaddr(63 downto 0)     <= oc_fbist_axis_i.s0_axi_awaddr(63 downto 0);
  s3_axi_awlen(7 downto 0)       <= "0000" & oc_fbist_axis_i.s0_axi_awlen(3 downto 0);
  s3_axi_awsize(2 downto 0)      <= oc_fbist_axis_i.s0_axi_awsize(2 downto 0);
  s3_axi_awburst(1 downto 0)     <= oc_fbist_axis_i.s0_axi_awburst(1 downto 0);
  s3_axi_awlock(1 downto 0)      <= oc_fbist_axis_i.s0_axi_awlock(1 downto 0);
  s3_axi_awcache(3 downto 0)     <= oc_fbist_axis_i.s0_axi_awcache(3 downto 0);
  s3_axi_awprot(2 downto 0)      <= oc_fbist_axis_i.s0_axi_awprot(2 downto 0);
  s3_axi_awvalid                 <= oc_fbist_axis_i.s0_axi_awvalid;
  oc_fbist_axis_o.s0_axi_awready <= s3_axi_awready;

  -- Write Data Channel
  s3_axi_wid(11 downto 0)       <= oc_fbist_axis_i.s0_axi_wid(11 downto 0);
  s3_axi_wdata(511 downto 0)    <= oc_fbist_axis_i.s0_axi_wdata(511 downto 0);
  s3_axi_wstrb(63 downto 0)     <= oc_fbist_axis_i.s0_axi_wstrb(63 downto 0);
  s3_axi_wlast                  <= oc_fbist_axis_i.s0_axi_wlast;
  s3_axi_wvalid                 <= oc_fbist_axis_i.s0_axi_wvalid;
  oc_fbist_axis_o.s0_axi_wready <= s3_axi_wready;

  -- Write Response Channel
  oc_fbist_axis_o.s0_axi_bid(11 downto 0)  <= s3_axi_bid(11 downto 0);
  oc_fbist_axis_o.s0_axi_bresp(1 downto 0) <= s3_axi_bresp(1 downto 0);
  oc_fbist_axis_o.s0_axi_bvalid            <= s3_axi_bvalid;
  s3_axi_bready                            <= oc_fbist_axis_i.s0_axi_bready;

  -- Read Address Channel
  s3_axi_arid(11 downto 0)       <= oc_fbist_axis_i.s0_axi_arid(11 downto 0);
  s3_axi_araddr(63 downto 0)     <= oc_fbist_axis_i.s0_axi_araddr(63 downto 0);
  s3_axi_arlen(7 downto 0)       <= "0000" & oc_fbist_axis_i.s0_axi_arlen(3 downto 0);
  s3_axi_arsize(2 downto 0)      <= oc_fbist_axis_i.s0_axi_arsize(2 downto 0);
  s3_axi_arburst(1 downto 0)     <= oc_fbist_axis_i.s0_axi_arburst(1 downto 0);
  s3_axi_arlock(1 downto 0)      <= oc_fbist_axis_i.s0_axi_arlock(1 downto 0);
  s3_axi_arcache(3 downto 0)     <= oc_fbist_axis_i.s0_axi_arcache(3 downto 0);
  s3_axi_arprot(2 downto 0)      <= oc_fbist_axis_i.s0_axi_arprot(2 downto 0);
  s3_axi_arvalid                 <= oc_fbist_axis_i.s0_axi_arvalid;
  oc_fbist_axis_o.s0_axi_arready <= s3_axi_arready;

  -- Read Data Channel
  oc_fbist_axis_o.s0_axi_rid(11 downto 0)    <= s3_axi_rid(11 downto 0);
  oc_fbist_axis_o.s0_axi_rdata(511 downto 0) <= s3_axi_rdata(511 downto 0);
  oc_fbist_axis_o.s0_axi_rresp(1 downto 0)   <= s3_axi_rresp(1 downto 0);
  oc_fbist_axis_o.s0_axi_rlast               <= s3_axi_rlast;
  oc_fbist_axis_o.s0_axi_ruser               <= s3_axi_ruser;
  oc_fbist_axis_o.s0_axi_rvalid              <= s3_axi_rvalid;
  s3_axi_rready                              <= oc_fbist_axis_i.s0_axi_rready;

  mmio_axi_width_converter : entity work.axi_width_converter
    port map (
      s0_axi_aclk => oc_mmio_axis_aclk,
      s0_axi_i_a  => oc_mmio_axis_i,
      s0_axi_i_b  => oc_mmio_skinny_axis_i,
      s0_axi_o_a  => oc_mmio_axis_o,
      s0_axi_o_b  => oc_mmio_skinny_axis_o
      );

  memory_axi_width_converter : entity work.axi_width_converter
    port map (
      s0_axi_aclk => oc_memory_axis_aclk,
      s0_axi_i_a  => oc_memory_axis_i,
      s0_axi_i_b  => oc_memory_skinny_axis_i,
      s0_axi_o_a  => oc_memory_axis_o,
      s0_axi_o_b  => oc_memory_skinny_axis_o
      );

  cfg_axi_width_converter : entity work.axi_width_converter
    port map (
      s0_axi_aclk => oc_cfg_axis_aclk,
      s0_axi_i_a  => oc_cfg_axis_i,
      s0_axi_i_b  => oc_cfg_skinny_axis_i,
      s0_axi_o_a  => oc_cfg_axis_o,
      s0_axi_o_b  => oc_cfg_skinny_axis_o
      );

  mem_cntl_cntl : entity work.ocx_mem_cntl
    port map (
       clock                      => clock,                                   -- in  std_ulogic;
       reset_n                    => reset_n,                                 -- in  std_ulogic;
   -- interface to axi_regs_32.vhdl oc_host_cfg.vhdl (fire_core.oc_host_cfg0) --
       reg_02_update_i            => reg_02_update_i,                         -- out std_ulogic_vector(31 downto 0);
       reg_02_hwwe_i              => reg_02_hwwe_i,                           -- out std_ulogic;
       reg_02_o                   => reg_02_o,                                -- in  std_ulogic_vector(31 downto 0);
   -- interface to ocx_tl_top                                                 --
       tlx_afu_resp_valid         => tlx_afu_resp_valid,                      -- in  std_ulogic;
       tlx_afu_resp_opcode        => tlx_afu_resp_opcode,                     -- in  std_ulogic_vector(7 downto 0);
       tlx_afu_resp_afutag        => tlx_afu_resp_afutag,                     -- in  std_ulogic_vector(15 downto 0);
       tlx_afu_resp_code          => tlx_afu_resp_code,                       -- in  std_ulogic_vector(3 downto 0);
      rcv_xmt_tlx_credit_valid    => rcv_xmt_tlx_credit_valid,
      rcv_xmt_tlx_credit_vc0      => rcv_xmt_tlx_credit_vc0,

   -- interface to ocx_tlx_axi.v                                              --
       memcntl_oc_cmd_ready       => memcntl_oc_cmd_ready,                    -- out std_ulogic;
       memcntl_oc_cmd_flag        => memcntl_oc_cmd_flag,                     -- out std_ulogic_vector(3 downto 0);
       memcntl_oc_cmd_tag         => memcntl_oc_cmd_tag,                      -- out std_ulogic_vector(15 downto 0);
       oc_memcntl_taken           => oc_memcntl_taken                         -- in  std_ulogic
    );

old_tlx_top: if (not use_new_tl) generate

  tlx : component ocx_tlx_top
    port map (
      clock                            => clock,
      reset_n                          => reset_n,
      tlx_afu_ready                    => tlx_afu_ready,
      afu_tlx_cmd_initial_credit       => afu_tlx_cmd_initial_credit,
      afu_tlx_cmd_credit               => afu_tlx_cmd_credit,
      tlx_afu_cmd_valid                => tlx_afu_cmd_valid,
      tlx_afu_cmd_opcode               => tlx_afu_cmd_opcode,
      tlx_afu_cmd_dl                   => tlx_afu_cmd_dl,
      tlx_afu_cmd_end                  => tlx_afu_cmd_end,
      tlx_afu_cmd_pa                   => tlx_afu_cmd_pa,
      tlx_afu_cmd_flag                 => tlx_afu_cmd_flag,
      tlx_afu_cmd_os                   => tlx_afu_cmd_os,
      tlx_afu_cmd_capptag              => tlx_afu_cmd_capptag,
      tlx_afu_cmd_pl                   => tlx_afu_cmd_pl,
      tlx_afu_cmd_be                   => tlx_afu_cmd_be,
      cfg_tlx_initial_credit           => cfg_tlx_initial_credit,
      cfg_tlx_credit_return            => cfg_tlx_credit_return,
      tlx_cfg_valid                    => tlx_cfg_valid,
      tlx_cfg_opcode                   => tlx_cfg_opcode,
      tlx_cfg_pa                       => tlx_cfg_pa,
      tlx_cfg_t                        => tlx_cfg_t,
      tlx_cfg_pl                       => tlx_cfg_pl,
      tlx_cfg_capptag                  => tlx_cfg_capptag,
      tlx_cfg_data_bus                 => tlx_cfg_data_bus,
      tlx_cfg_data_bdi                 => tlx_cfg_data_bdi,
      afu_tlx_resp_initial_credit      => afu_tlx_resp_initial_credit,
      afu_tlx_resp_credit              => afu_tlx_resp_credit,
      tlx_afu_resp_valid               => tlx_afu_resp_valid,
      tlx_afu_resp_opcode              => tlx_afu_resp_opcode,
      tlx_afu_resp_afutag              => tlx_afu_resp_afutag,
      tlx_afu_resp_code                => tlx_afu_resp_code,
      tlx_afu_resp_pg_size             => tlx_afu_resp_pg_size,
      tlx_afu_resp_dl                  => tlx_afu_resp_dl,
      tlx_afu_resp_dp                  => tlx_afu_resp_dp,
      tlx_afu_resp_host_tag            => tlx_afu_resp_host_tag,
      tlx_afu_resp_cache_state         => tlx_afu_resp_cache_state,
      tlx_afu_resp_addr_tag            => tlx_afu_resp_addr_tag,
      afu_tlx_cmd_rd_req               => afu_tlx_cmd_rd_req,
      afu_tlx_cmd_rd_cnt               => afu_tlx_cmd_rd_cnt,
      tlx_afu_cmd_data_valid           => tlx_afu_cmd_data_valid,
      tlx_afu_cmd_data_bdi             => tlx_afu_cmd_data_bdi,
      tlx_afu_cmd_data_bus             => tlx_afu_cmd_data_bus,
      afu_tlx_resp_rd_req              => afu_tlx_resp_rd_req,
      afu_tlx_resp_rd_cnt              => afu_tlx_resp_rd_cnt,
      tlx_afu_resp_data_valid          => tlx_afu_resp_data_valid,
      tlx_afu_resp_data_bdi            => tlx_afu_resp_data_bdi,
      tlx_afu_resp_data_bus            => tlx_afu_resp_data_bus,
      tlx_afu_cmd_initial_credit       => tlx_afu_cmd_initial_credit,
      tlx_afu_cmd_credit               => tlx_afu_cmd_credit,
      afu_tlx_cmd_valid                => afu_tlx_cmd_valid,
      afu_tlx_cmd_opcode               => afu_tlx_cmd_opcode,
      afu_tlx_cmd_pa_or_obj            => afu_tlx_cmd_pa_or_obj,
      afu_tlx_cmd_afutag               => afu_tlx_cmd_afutag,
      afu_tlx_cmd_dl                   => afu_tlx_cmd_dl,
      afu_tlx_cmd_pl                   => afu_tlx_cmd_pl,
      afu_tlx_cmd_be                   => afu_tlx_cmd_be,
      afu_tlx_cmd_flag                 => afu_tlx_cmd_flag,
      afu_tlx_cmd_bdf                  => afu_tlx_cmd_bdf,
      afu_tlx_cmd_resp_code            => afu_tlx_cmd_resp_code,
      afu_tlx_cmd_capptag              => afu_tlx_cmd_capptag,
      tlx_afu_cmd_data_initial_credit  => tlx_afu_cmd_data_initial_credit,
      tlx_afu_cmd_data_credit          => tlx_afu_cmd_data_credit,
      afu_tlx_cdata_valid              => afu_tlx_cdata_valid,
      afu_tlx_cdata_bus                => afu_tlx_cdata_bus,
      afu_tlx_cdata_bdi                => afu_tlx_cdata_bdi,
      tlx_afu_resp_initial_credit      => open,
      tlx_afu_resp_credit              => tlx_afu_resp_credit,
      afu_tlx_resp_valid               => afu_tlx_resp_valid,
      afu_tlx_resp_opcode              => afu_tlx_resp_opcode,
      afu_tlx_resp_dl                  => afu_tlx_resp_dl,
      afu_tlx_resp_capptag             => afu_tlx_resp_capptag,
      afu_tlx_resp_dp                  => afu_tlx_resp_dp,
      afu_tlx_resp_code                => afu_tlx_resp_code,
      tlx_afu_resp_data_initial_credit => open,
      tlx_afu_resp_data_credit         => tlx_afu_resp_data_credit,
      afu_tlx_rdata_valid              => afu_tlx_rdata_valid,
      afu_tlx_rdata_bus                => afu_tlx_rdata_bus,
      afu_tlx_rdata_bdi                => afu_tlx_rdata_bdi,
      cfg_tlx_resp_valid               => cfg_tlx_resp_valid,
      cfg_tlx_resp_opcode              => cfg_tlx_resp_opcode,
      cfg_tlx_resp_capptag             => cfg_tlx_resp_capptag,
      cfg_tlx_resp_code                => cfg_tlx_resp_code,
      tlx_cfg_resp_ack                 => open,
      cfg_tlx_rdata_offset             => cfg_tlx_rdata_offset,
      cfg_tlx_rdata_bus                => cfg_tlx_rdata_bus,
      cfg_tlx_rdata_bdi                => cfg_tlx_rdata_bdi,
      dlx_tlx_flit_valid               => dlx_tlx_flit_valid,
      dlx_tlx_flit                     => dlx_tlx_flit,
      dlx_tlx_flit_crc_err             => dlx_tlx_flit_crc_err,
      dlx_tlx_link_up                  => dlx_tlx_link_up,
      dlx_tlx_init_flit_depth          => dlx_tlx_init_flit_depth,
      dlx_tlx_flit_credit              => dlx_tlx_flit_credit,
      tlx_dlx_flit_valid               => tlx_dlx_flit_valid,
      tlx_dlx_flit                     => tlx_dlx_flit,
      tlx_dlx_debug_encode             => tlx_dlx_debug_encode,
      tlx_dlx_debug_info               => tlx_dlx_debug_info,
      dlx_tlx_dlx_config_info          => dlx_tlx_dlx_config_info,
      tlx_cfg_oc3_tlx_version          => tlx_cfg_oc3_tlx_version,
      cfg_tlx_xmit_tmpl_config_0       => cfg_tlx_xmit_tmpl_config_0,
      cfg_tlx_xmit_tmpl_config_1       => cfg_tlx_xmit_tmpl_config_1,
      cfg_tlx_xmit_tmpl_config_2       => cfg_tlx_xmit_tmpl_config_2,
      cfg_tlx_xmit_tmpl_config_3       => cfg_tlx_xmit_tmpl_config_3,
      cfg_tlx_xmit_rate_config_0       => cfg_tlx_xmit_rate_config_0,
      cfg_tlx_xmit_rate_config_1       => cfg_tlx_xmit_rate_config_1,
      cfg_tlx_xmit_rate_config_2       => cfg_tlx_xmit_rate_config_2,
      cfg_tlx_xmit_rate_config_3       => cfg_tlx_xmit_rate_config_3,
      tlx_cfg_in_rcv_tmpl_capability_0 => tlx_cfg_in_rcv_tmpl_capability_0,
      tlx_cfg_in_rcv_tmpl_capability_1 => tlx_cfg_in_rcv_tmpl_capability_1,
      tlx_cfg_in_rcv_tmpl_capability_2 => tlx_cfg_in_rcv_tmpl_capability_2,
      tlx_cfg_in_rcv_tmpl_capability_3 => tlx_cfg_in_rcv_tmpl_capability_3,
      tlx_cfg_in_rcv_rate_capability_0 => tlx_cfg_in_rcv_rate_capability_0,
      tlx_cfg_in_rcv_rate_capability_1 => tlx_cfg_in_rcv_rate_capability_1,
      tlx_cfg_in_rcv_rate_capability_2 => tlx_cfg_in_rcv_rate_capability_2,
      tlx_cfg_in_rcv_rate_capability_3 => tlx_cfg_in_rcv_rate_capability_3
      );
end generate old_tlx_top;

new_tl_top: if ( use_new_tl) generate

  TL_TOP: entity work.ocx_tl_top
    port map (
      clock                            => clock,
      reset_n                          => reset_n,
      reg_01_hwwe_i                    => reg_01_hwwe_i,
      reg_01_update_i                  => reg_01_update_i,
      reg_01_o                         => reg_01_o,
      tlx_afu_ready                    => tlx_afu_ready,
      afu_tlx_cmd_initial_credit       => afu_tlx_cmd_initial_credit,
      afu_tlx_cmd_credit               => afu_tlx_cmd_credit,
      tlx_afu_cmd_valid                => tlx_afu_cmd_valid,
      tlx_afu_cmd_opcode               => tlx_afu_cmd_opcode,
      tlx_afu_cmd_dl                   => tlx_afu_cmd_dl,
      tlx_afu_cmd_end                  => tlx_afu_cmd_end,
      tlx_afu_cmd_pa                   => tlx_afu_cmd_pa,
      tlx_afu_cmd_flag                 => tlx_afu_cmd_flag,
      tlx_afu_cmd_os                   => tlx_afu_cmd_os,
      tlx_afu_cmd_capptag              => tlx_afu_cmd_capptag,
      tlx_afu_cmd_pl                   => tlx_afu_cmd_pl,
      tlx_afu_cmd_be                   => tlx_afu_cmd_be,
      cfg_tlx_initial_credit           => cfg_tlx_initial_credit,
      cfg_tlx_credit_return            => cfg_tlx_credit_return,
      tlx_cfg_valid                    => tlx_cfg_valid,
      tlx_cfg_opcode                   => tlx_cfg_opcode,
      tlx_cfg_pa                       => tlx_cfg_pa,
      tlx_cfg_t                        => tlx_cfg_t,
      tlx_cfg_pl                       => tlx_cfg_pl,
      tlx_cfg_capptag                  => tlx_cfg_capptag,
      tlx_cfg_data_bus                 => tlx_cfg_data_bus,
      tlx_cfg_data_bdi                 => tlx_cfg_data_bdi,
      afu_tlx_resp_initial_credit      => afu_tlx_resp_initial_credit,
      afu_tlx_resp_credit              => afu_tlx_resp_credit,
      tlx_afu_resp_valid               => tlx_afu_resp_valid,
      tlx_afu_resp_opcode              => tlx_afu_resp_opcode,
      tlx_afu_resp_afutag              => tlx_afu_resp_afutag,
      tlx_afu_resp_code                => tlx_afu_resp_code,
      tlx_afu_resp_pg_size             => tlx_afu_resp_pg_size,
      tlx_afu_resp_dl                  => tlx_afu_resp_dl,
      tlx_afu_resp_dp                  => tl_afu_resp_dp,
      tlx_afu_resp_host_tag            => tlx_afu_resp_host_tag,
      tlx_afu_resp_cache_state         => tlx_afu_resp_cache_state,
      tlx_afu_resp_addr_tag            => tlx_afu_resp_addr_tag,
      afu_tlx_cmd_rd_req               => afu_tlx_cmd_rd_req,
      afu_tlx_cmd_rd_cnt               => afu_tlx_cmd_rd_cnt,
      tlx_afu_cmd_data_valid           => tlx_afu_cmd_data_valid,
      tlx_afu_cmd_data_bdi             => tlx_afu_cmd_data_bdi,
      tlx_afu_cmd_data_bus             => tlx_afu_cmd_data_bus,
      afu_tlx_resp_rd_req              => afu_tlx_resp_rd_req,
      afu_tlx_resp_rd_cnt              => afu_tlx_resp_rd_cnt,
      tlx_afu_resp_data_valid          => tlx_afu_resp_data_valid,
      tlx_afu_resp_data_bdi            => tlx_afu_resp_data_bdi,
      tlx_afu_resp_data_xmeta          => tlx_afu_resp_data_xmeta,
      tlx_afu_resp_data_bus            => tlx_afu_resp_data_bus,
      tlx_afu_cmd_initial_credit       => tlx_afu_cmd_initial_credit,
      tlx_afu_cmd_credit               => tlx_afu_cmd_credit,
      afu_tlx_cmd_valid                => afu_tlx_cmd_valid,
      afu_tlx_cmd_opcode               => afu_tlx_cmd_opcode,
      afu_tlx_cmd_pa_or_obj            => afu_tlx_cmd_pa_or_obj,
      afu_tlx_cmd_afutag               => afu_tlx_cmd_afutag,
      afu_tlx_cmd_dl                   => afu_tlx_cmd_dl,
      afu_tlx_cmd_pl                   => afu_tlx_cmd_pl,
      afu_tlx_cmd_be                   => afu_tlx_cmd_be,
      afu_tlx_cmd_flag                 => afu_tlx_cmd_flag,
      afu_tlx_cmd_bdf                  => afu_tlx_cmd_bdf,
      afu_tlx_cmd_resp_code            => afu_tlx_cmd_resp_code,
      afu_tlx_cmd_capptag              => afu_tlx_cmd_capptag,
      tlx_afu_cmd_data_initial_credit  => tlx_afu_cmd_data_initial_credit,
      tlx_afu_cmd_data_credit          => tlx_afu_cmd_data_credit,
      afu_tlx_cdata_valid              => afu_tlx_cdata_valid,
      afu_tlx_cdata_bus                => afu_tlx_cdata_bus,
      afu_tlx_cdata_bdi                => afu_tlx_cdata_bdi,
      tlx_afu_resp_initial_credit      => open,
      tlx_afu_resp_credit              => tlx_afu_resp_credit,
      afu_tlx_resp_valid               => afu_tlx_resp_valid,
      afu_tlx_resp_opcode              => afu_tlx_resp_opcode,
      afu_tlx_resp_dl                  => afu_tlx_resp_dl,
      afu_tlx_resp_capptag             => afu_tlx_resp_capptag,
      afu_tlx_resp_dp                  => afu_tlx_resp_dp,
      afu_tlx_resp_code                => afu_tlx_resp_code,
      tlx_afu_resp_data_initial_credit => open,
      tlx_afu_resp_data_credit         => tlx_afu_resp_data_credit,
      afu_tlx_rdata_valid              => afu_tlx_rdata_valid,
      afu_tlx_rdata_bus                => afu_tlx_rdata_bus,
      afu_tlx_rdata_bdi                => afu_tlx_rdata_bdi,
      cfg_tlx_resp_valid               => cfg_tlx_resp_valid,
      cfg_tlx_resp_opcode              => cfg_tlx_resp_opcode,
      cfg_tlx_resp_capptag             => cfg_tlx_resp_capptag,
      cfg_tlx_resp_code                => cfg_tlx_resp_code,
      tlx_cfg_resp_ack                 => open,
      cfg_tlx_rdata_offset             => cfg_tlx_rdata_offset,
      cfg_tlx_rdata_bus                => cfg_tlx_rdata_bus,
      cfg_tlx_rdata_bdi                => cfg_tlx_rdata_bdi,
      dlx_tlx_flit_valid               => dlx_tlx_flit_valid,
      dlx_tlx_flit                     => dlx_tlx_flit,
      dlx_tlx_flit_crc_err             => dlx_tlx_flit_crc_err,
      dlx_tlx_link_up                  => dlx_tlx_link_up,
      dlx_tlx_init_flit_depth          => dlx_tlx_init_flit_depth,
      dlx_tlx_flit_credit              => dlx_tlx_flit_credit,
      tlx_dlx_flit_valid               => tlx_dlx_flit_valid,
      tlx_dlx_flit                     => tlx_dlx_flit,
      tlx_dlx_debug_encode             => tlx_dlx_debug_encode,
      tlx_dlx_debug_info               => tlx_dlx_debug_info,
      dlx_tlx_dlx_config_info          => dlx_tlx_dlx_config_info,
      tlx_cfg_oc3_tlx_version          => tlx_cfg_oc3_tlx_version,
      cfg_tlx_xmit_tmpl_config_0       => cfg_tlx_xmit_tmpl_config_0,
      cfg_tlx_xmit_tmpl_config_1       => cfg_tlx_xmit_tmpl_config_1,
      cfg_tlx_xmit_tmpl_config_2       => cfg_tlx_xmit_tmpl_config_2,
      cfg_tlx_xmit_tmpl_config_3       => cfg_tlx_xmit_tmpl_config_3,
      cfg_tlx_xmit_rate_config_0       => cfg_tlx_xmit_rate_config_0,
      cfg_tlx_xmit_rate_config_1       => cfg_tlx_xmit_rate_config_1,
      cfg_tlx_xmit_rate_config_2       => cfg_tlx_xmit_rate_config_2,
      cfg_tlx_xmit_rate_config_3       => cfg_tlx_xmit_rate_config_3,
      tlx_cfg_in_rcv_tmpl_capability_0 => tlx_cfg_in_rcv_tmpl_capability_0,
      tlx_cfg_in_rcv_tmpl_capability_1 => tlx_cfg_in_rcv_tmpl_capability_1,
      tlx_cfg_in_rcv_tmpl_capability_2 => tlx_cfg_in_rcv_tmpl_capability_2,
      tlx_cfg_in_rcv_tmpl_capability_3 => tlx_cfg_in_rcv_tmpl_capability_3,
      tlx_cfg_in_rcv_rate_capability_0 => tlx_cfg_in_rcv_rate_capability_0,
      tlx_cfg_in_rcv_rate_capability_1 => tlx_cfg_in_rcv_rate_capability_1,
      tlx_cfg_in_rcv_rate_capability_2 => tlx_cfg_in_rcv_rate_capability_2,
      tlx_cfg_in_rcv_rate_capability_3 => tlx_cfg_in_rcv_rate_capability_3,
      rcv_xmt_tlx_credit_valid         => rcv_xmt_tlx_credit_valid,
      rcv_xmt_tlx_credit_vc0           => rcv_xmt_tlx_credit_vc0
      );

      tlx_afu_resp_dp <= tl_afu_resp_dp(1 downto 0);

end generate new_tl_top;

  axi : component ocx_tlx_axi
    generic map (
      ADDR_WIDTH                      => 64,
      AXI_DATA_WIDTH                  => 32,
      OC_DATA_WIDTH                   => 64,
      ID_WIDTH                        => 1
      )
    port map (
      s0_axi_aclk                     => s0_axi_aclk,
      s0_axi_aresetn                  => s0_axi_aresetn,
      s0_axi_awid                     => s0_axi_awid,
      s0_axi_awaddr                   => s0_axi_awaddr,
      s0_axi_awlen                    => s0_axi_awlen,
      s0_axi_awsize                   => s0_axi_awsize,
      s0_axi_awburst                  => s0_axi_awburst,
      s0_axi_awlock                   => s0_axi_awlock,
      s0_axi_awcache                  => s0_axi_awcache,
      s0_axi_awprot                   => s0_axi_awprot,
      s0_axi_awvalid                  => s0_axi_awvalid,
      s0_axi_awready                  => s0_axi_awready,
      s0_axi_wid                      => s0_axi_wid,
      s0_axi_wdata                    => s0_axi_wdata,
      s0_axi_wstrb                    => s0_axi_wstrb,
      s0_axi_wlast                    => s0_axi_wlast,
      s0_axi_wvalid                   => s0_axi_wvalid,
      s0_axi_wready                   => s0_axi_wready,
      s0_axi_bid                      => s0_axi_bid,
      s0_axi_bresp                    => s0_axi_bresp,
      s0_axi_bvalid                   => s0_axi_bvalid,
      s0_axi_bready                   => s0_axi_bready,
      s0_axi_arid                     => s0_axi_arid,
      s0_axi_araddr                   => s0_axi_araddr,
      s0_axi_arlen                    => s0_axi_arlen,
      s0_axi_arsize                   => s0_axi_arsize,
      s0_axi_arburst                  => s0_axi_arburst,
      s0_axi_arlock                   => s0_axi_arlock,
      s0_axi_arcache                  => s0_axi_arcache,
      s0_axi_arprot                   => s0_axi_arprot,
      s0_axi_arvalid                  => s0_axi_arvalid,
      s0_axi_arready                  => s0_axi_arready,
      s0_axi_rid                      => s0_axi_rid,
      s0_axi_rdata                    => s0_axi_rdata,
      s0_axi_rresp                    => s0_axi_rresp,
      s0_axi_rlast                    => s0_axi_rlast,
      s0_axi_rvalid                   => s0_axi_rvalid,
      s0_axi_rready                   => s0_axi_rready,
      s1_axi_aclk                     => s1_axi_aclk,
      s1_axi_aresetn                  => s1_axi_aresetn,
      s1_axi_awid                     => s1_axi_awid,
      s1_axi_awaddr                   => s1_axi_awaddr,
      s1_axi_awlen                    => s1_axi_awlen,
      s1_axi_awsize                   => s1_axi_awsize,
      s1_axi_awburst                  => s1_axi_awburst,
      s1_axi_awlock                   => s1_axi_awlock,
      s1_axi_awcache                  => s1_axi_awcache,
      s1_axi_awprot                   => s1_axi_awprot,
      s1_axi_awvalid                  => s1_axi_awvalid,
      s1_axi_awready                  => s1_axi_awready,
      s1_axi_wid                      => s1_axi_wid,
      s1_axi_wdata                    => s1_axi_wdata,
      s1_axi_wstrb                    => s1_axi_wstrb,
      s1_axi_wlast                    => s1_axi_wlast,
      s1_axi_wvalid                   => s1_axi_wvalid,
      s1_axi_wready                   => s1_axi_wready,
      s1_axi_bid                      => s1_axi_bid,
      s1_axi_bresp                    => s1_axi_bresp,
      s1_axi_bvalid                   => s1_axi_bvalid,
      s1_axi_bready                   => s1_axi_bready,
      s1_axi_arid                     => s1_axi_arid,
      s1_axi_araddr                   => s1_axi_araddr,
      s1_axi_arlen                    => s1_axi_arlen,
      s1_axi_arsize                   => s1_axi_arsize,
      s1_axi_arburst                  => s1_axi_arburst,
      s1_axi_arlock                   => s1_axi_arlock,
      s1_axi_arcache                  => s1_axi_arcache,
      s1_axi_arprot                   => s1_axi_arprot,
      s1_axi_arvalid                  => s1_axi_arvalid,
      s1_axi_arready                  => s1_axi_arready,
      s1_axi_rid                      => s1_axi_rid,
      s1_axi_rdata                    => s1_axi_rdata,
      s1_axi_rresp                    => s1_axi_rresp,
      s1_axi_rlast                    => s1_axi_rlast,
      s1_axi_rvalid                   => s1_axi_rvalid,
      s1_axi_rready                   => s1_axi_rready,
      s2_axi_aclk                     => s2_axi_aclk,
      s2_axi_aresetn                  => s2_axi_aresetn,
      s2_axi_awid                     => s2_axi_awid,
      s2_axi_awaddr                   => s2_axi_awaddr,
      s2_axi_awlen                    => s2_axi_awlen,
      s2_axi_awsize                   => s2_axi_awsize,
      s2_axi_awburst                  => s2_axi_awburst,
      s2_axi_awlock                   => s2_axi_awlock,
      s2_axi_awcache                  => s2_axi_awcache,
      s2_axi_awprot                   => s2_axi_awprot,
      s2_axi_awvalid                  => s2_axi_awvalid,
      s2_axi_awready                  => s2_axi_awready,
      s2_axi_wid                      => s2_axi_wid,
      s2_axi_wdata                    => s2_axi_wdata,
      s2_axi_wstrb                    => s2_axi_wstrb,
      s2_axi_wlast                    => s2_axi_wlast,
      s2_axi_wvalid                   => s2_axi_wvalid,
      s2_axi_wready                   => s2_axi_wready,
      s2_axi_bid                      => s2_axi_bid,
      s2_axi_bresp                    => s2_axi_bresp,
      s2_axi_bvalid                   => s2_axi_bvalid,
      s2_axi_bready                   => s2_axi_bready,
      s2_axi_arid                     => s2_axi_arid,
      s2_axi_araddr                   => s2_axi_araddr,
      s2_axi_arlen                    => s2_axi_arlen,
      s2_axi_arsize                   => s2_axi_arsize,
      s2_axi_arburst                  => s2_axi_arburst,
      s2_axi_arlock                   => s2_axi_arlock,
      s2_axi_arcache                  => s2_axi_arcache,
      s2_axi_arprot                   => s2_axi_arprot,
      s2_axi_arvalid                  => s2_axi_arvalid,
      s2_axi_arready                  => s2_axi_arready,
      s2_axi_rid                      => s2_axi_rid,
      s2_axi_rdata                    => s2_axi_rdata,
      s2_axi_rresp                    => s2_axi_rresp,
      s2_axi_rlast                    => s2_axi_rlast,
      s2_axi_rvalid                   => s2_axi_rvalid,
      s2_axi_rready                   => s2_axi_rready,
      s3_axi_aclk                     => s3_axi_aclk,
      s3_axi_aresetn                  => s3_axi_aresetn,
      s3_axi_awid                     => s3_axi_awid,
      s3_axi_awaddr                   => s3_axi_awaddr,
      s3_axi_awlen                    => s3_axi_awlen,
      s3_axi_awsize                   => s3_axi_awsize,
      s3_axi_awburst                  => s3_axi_awburst,
      s3_axi_awlock                   => s3_axi_awlock,
      s3_axi_awcache                  => s3_axi_awcache,
      s3_axi_awprot                   => s3_axi_awprot,
      s3_axi_awvalid                  => s3_axi_awvalid,
      s3_axi_awready                  => s3_axi_awready,
      s3_axi_wid                      => s3_axi_wid,
      s3_axi_wdata                    => s3_axi_wdata,
      s3_axi_wstrb                    => s3_axi_wstrb,
      s3_axi_wlast                    => s3_axi_wlast,
      s3_axi_wvalid                   => s3_axi_wvalid,
      s3_axi_wready                   => s3_axi_wready,
      s3_axi_bid                      => s3_axi_bid,
      s3_axi_bresp                    => s3_axi_bresp,
      s3_axi_bvalid                   => s3_axi_bvalid,
      s3_axi_bready                   => s3_axi_bready,
      s3_axi_arid                     => s3_axi_arid,
      s3_axi_araddr                   => s3_axi_araddr,
      s3_axi_arlen                    => s3_axi_arlen,
      s3_axi_arsize                   => s3_axi_arsize,
      s3_axi_arburst                  => s3_axi_arburst,
      s3_axi_arlock                   => s3_axi_arlock,
      s3_axi_arcache                  => s3_axi_arcache,
      s3_axi_arprot                   => s3_axi_arprot,
      s3_axi_arvalid                  => s3_axi_arvalid,
      s3_axi_arready                  => s3_axi_arready,
      s3_axi_rid                      => s3_axi_rid,
      s3_axi_rdata                    => s3_axi_rdata,
      s3_axi_rresp                    => s3_axi_rresp,
      s3_axi_rlast                    => s3_axi_rlast,
      s3_axi_ruser                    => s3_axi_ruser,
      s3_axi_rvalid                   => s3_axi_rvalid,
      s3_axi_rready                   => s3_axi_rready,
      tlx_afu_cmd_initial_credit      => tlx_afu_cmd_initial_credit,
      tlx_afu_cmd_credit              => tlx_afu_cmd_credit,
      afu_tlx_cmd_valid               => afu_tlx_cmd_valid,
      afu_tlx_cmd_opcode              => afu_tlx_cmd_opcode,
      afu_tlx_cmd_pa_or_obj           => afu_tlx_cmd_pa_or_obj,
      afu_tlx_cmd_afutag              => afu_tlx_cmd_afutag,
      afu_tlx_cmd_dl                  => afu_tlx_cmd_dl,
      afu_tlx_cmd_pl                  => afu_tlx_cmd_pl,
      afu_tlx_cmd_be                  => afu_tlx_cmd_be,
      afu_tlx_cmd_flag                => afu_tlx_cmd_flag,
      afu_tlx_cmd_bdf                 => afu_tlx_cmd_bdf,
      afu_tlx_cmd_resp_code           => afu_tlx_cmd_resp_code,
      afu_tlx_cmd_capptag             => afu_tlx_cmd_capptag,
      tlx_afu_cmd_data_initial_credit => tlx_afu_cmd_data_initial_credit,
      tlx_afu_cmd_data_credit         => tlx_afu_cmd_data_credit,
      afu_tlx_cdata_valid             => afu_tlx_cdata_valid,
      afu_tlx_cdata_bus               => afu_tlx_cdata_bus,
      afu_tlx_cdata_bdi               => afu_tlx_cdata_bdi,
      afu_tlx_resp_initial_credit     => afu_tlx_resp_initial_credit,
      afu_tlx_resp_credit             => afu_tlx_resp_credit,
      tlx_afu_resp_valid              => tlx_afu_resp_valid,
      tlx_afu_resp_opcode             => tlx_afu_resp_opcode,
      tlx_afu_resp_afutag             => tlx_afu_resp_afutag,
      tlx_afu_resp_code               => tlx_afu_resp_code,
      tlx_afu_resp_pg_size            => tlx_afu_resp_pg_size,
      tlx_afu_resp_dl                 => tlx_afu_resp_dl,
      tlx_afu_resp_dp                 => tlx_afu_resp_dp,
      tlx_afu_resp_host_tag           => tlx_afu_resp_host_tag,
      tlx_afu_resp_cache_state        => tlx_afu_resp_cache_state,
      tlx_afu_resp_addr_tag           => tlx_afu_resp_addr_tag,
      afu_tlx_resp_rd_req             => afu_tlx_resp_rd_req,
      afu_tlx_resp_rd_cnt             => afu_tlx_resp_rd_cnt,
      tlx_afu_resp_data_valid         => tlx_afu_resp_data_valid,
      tlx_afu_resp_data_bdi           => tlx_afu_resp_data_bdi,
      tlx_afu_resp_data_bus           => tlx_afu_resp_data_bus,
      memcntl_oc_cmd_ready            => memcntl_oc_cmd_ready,
      memcntl_oc_cmd_flag             => memcntl_oc_cmd_flag,
      memcntl_oc_cmd_tag              => memcntl_oc_cmd_tag,
      oc_memcntl_taken                => oc_memcntl_taken,
      cfg_bar                         => cfg_bar
      );

end ocx_tlx_wrap;
