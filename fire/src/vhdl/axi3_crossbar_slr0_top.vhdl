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


library ieee, work;
use ieee.std_logic_1164.all;
use work.axi_pkg.all;

entity axi3_crossbar_slr0_top is
  port (
    -- Global
    aclk    : in std_ulogic;
    aresetn : in std_ulogic;

    -- Slave 0
    s0_axi_i : in t_AXI4_SLAVE_INPUT;
    s0_axi_o : out t_AXI4_SLAVE_OUTPUT;
 
    -- Slave 1
    s1_axi_i : in t_AXI3_64_SLAVE_INPUT;
    s1_axi_o : out t_AXI3_64_SLAVE_OUTPUT;

    -- Slave 2
    s2_axi_i : in t_AXI3_SLAVE_INPUT;
    s2_axi_o : out t_AXI3_SLAVE_OUTPUT;

    -- Master 0
    m0_axi_i : in t_AXI4_LITE_MASTER_INPUT;
    m0_axi_o : out t_AXI4_LITE_MASTER_OUTPUT;

    -- Master 1
    m1_axi_i : in t_AXI3_MASTER_INPUT;
    m1_axi_o : out t_AXI3_MASTER_OUTPUT;

    -- Master 2
    m2_axi_i : in t_AXI3_MASTER_INPUT;
    m2_axi_o : out t_AXI3_MASTER_OUTPUT;

    -- Master 3
    m3_axi_i : in t_AXI3_MASTER_INPUT;
    m3_axi_o : out t_AXI3_MASTER_OUTPUT;

    -- Master 4
    m4_axi_i : in t_AXI3_MASTER_INPUT;
    m4_axi_o : out t_AXI3_MASTER_OUTPUT;

    -- Master 5
    m5_axi_i : in t_AXI3_MASTER_INPUT;
    m5_axi_o : out t_AXI3_MASTER_OUTPUT;

    -- Master 6
    m6_axi_i : in t_AXI3_MASTER_INPUT;
    m6_axi_o : out t_AXI3_MASTER_OUTPUT;

    -- Master 7
    m7_axi_i : in t_AXI3_MASTER_INPUT;
    m7_axi_o : out t_AXI3_MASTER_OUTPUT
  );
end axi3_crossbar_slr0_top;

architecture axi3_crossbar_slr0_top of axi3_crossbar_slr0_top is

  CONSTANT WIDTH_MASTER_PORTS   : integer := 8;
  constant WIDTH_MASTER_AWID    : integer := 7;
  constant WIDTH_MASTER_AWADDR  : integer := 64;
  constant WIDTH_MASTER_AWLEN   : integer := 4;
  constant WIDTH_MASTER_AWSIZE  : integer := 3;
  constant WIDTH_MASTER_AWBURST : integer := 2;
  constant WIDTH_MASTER_AWLOCK  : integer := 2;
  constant WIDTH_MASTER_AWCACHE : integer := 4;
  constant WIDTH_MASTER_AWPROT  : integer := 3;
  constant WIDTH_MASTER_AWQOS   : integer := 4;
  constant WIDTH_MASTER_WID     : integer := 7;
  constant WIDTH_MASTER_WDATA   : integer := 32;
  constant WIDTH_MASTER_WSTRB   : integer := 4;
  constant WIDTH_MASTER_BID     : integer := 7;
  constant WIDTH_MASTER_BRESP   : integer := 2;
  constant WIDTH_MASTER_ARID    : integer := 7;
  constant WIDTH_MASTER_ARADDR  : integer := 64;
  constant WIDTH_MASTER_ARLEN   : integer := 4;
  constant WIDTH_MASTER_ARSIZE  : integer := 3;
  constant WIDTH_MASTER_ARBURST : integer := 2;
  constant WIDTH_MASTER_ARLOCK  : integer := 2;
  constant WIDTH_MASTER_ARCACHE : integer := 4;
  constant WIDTH_MASTER_ARPROT  : integer := 3;
  constant WIDTH_MASTER_ARQOS   : integer := 4;
  constant WIDTH_MASTER_RID     : integer := 7;
  constant WIDTH_MASTER_RDATA   : integer := 32;
  constant WIDTH_MASTER_RRESP   : integer := 2;

  signal s_axi_awid    : std_logic_vector(20 DOWNTO 0);
  signal s_axi_awaddr  : std_logic_vector(191 DOWNTO 0);
  signal s_axi_awlen   : std_logic_vector(11 DOWNTO 0);
  signal s_axi_awsize  : std_logic_vector(8 DOWNTO 0);
  signal s_axi_awburst : std_logic_vector(5 DOWNTO 0);
  signal s_axi_awlock  : std_logic_vector(5 DOWNTO 0);
  signal s_axi_awcache : std_logic_vector(11 DOWNTO 0);
  signal s_axi_awprot  : std_logic_vector(8 DOWNTO 0);
  signal s_axi_awqos   : std_logic_vector(11 DOWNTO 0);
  signal s_axi_awvalid : std_logic_vector(2 DOWNTO 0);
  signal s_axi_awready : std_logic_vector(2 DOWNTO 0);
  signal s_axi_wid     : std_logic_vector(20 DOWNTO 0);
  signal s_axi_wdata   : std_logic_vector(95 DOWNTO 0);
  signal s_axi_wstrb   : std_logic_vector(11 DOWNTO 0);
  signal s_axi_wlast   : std_logic_vector(2 DOWNTO 0);
  signal s_axi_wvalid  : std_logic_vector(2 DOWNTO 0);
  signal s_axi_wready  : std_logic_vector(2 DOWNTO 0);
  signal s_axi_bid     : std_logic_vector(20 DOWNTO 0);
  signal s_axi_bresp   : std_logic_vector(5 DOWNTO 0);
  signal s_axi_bvalid  : std_logic_vector(2 DOWNTO 0);
  signal s_axi_bready  : std_logic_vector(2 DOWNTO 0);
  signal s_axi_arid    : std_logic_vector(20 DOWNTO 0);
  signal s_axi_araddr  : std_logic_vector(191 DOWNTO 0);
  signal s_axi_arlen   : std_logic_vector(11 DOWNTO 0);
  signal s_axi_arsize  : std_logic_vector(8 DOWNTO 0);
  signal s_axi_arburst : std_logic_vector(5 DOWNTO 0);
  signal s_axi_arlock  : std_logic_vector(5 DOWNTO 0);
  signal s_axi_arcache : std_logic_vector(11 DOWNTO 0);
  signal s_axi_arprot  : std_logic_vector(8 DOWNTO 0);
  signal s_axi_arqos   : std_logic_vector(11 DOWNTO 0);
  signal s_axi_arvalid : std_logic_vector(2 DOWNTO 0);
  signal s_axi_arready : std_logic_vector(2 DOWNTO 0);
  signal s_axi_rid     : std_logic_vector(20 DOWNTO 0);
  signal s_axi_rdata   : std_logic_vector(95 DOWNTO 0);
  signal s_axi_rresp   : std_logic_vector(5 DOWNTO 0);
  signal s_axi_rlast   : std_logic_vector(2 DOWNTO 0);
  signal s_axi_rvalid  : std_logic_vector(2 DOWNTO 0);
  signal s_axi_rready  : std_logic_vector(2 DOWNTO 0);
  signal m_axi_awid    : std_logic_vector(WIDTH_MASTER_PORTS * WIDTH_MASTER_AWID - 1 DOWNTO 0);
  signal m_axi_awaddr  : std_logic_vector(WIDTH_MASTER_PORTS * WIDTH_MASTER_AWADDR - 1 DOWNTO 0);
  signal m_axi_awlen   : std_logic_vector(WIDTH_MASTER_PORTS * WIDTH_MASTER_AWLEN - 1 DOWNTO 0);
  signal m_axi_awsize  : std_logic_vector(WIDTH_MASTER_PORTS * WIDTH_MASTER_AWSIZE - 1 DOWNTO 0);
  signal m_axi_awburst : std_logic_vector(WIDTH_MASTER_PORTS * WIDTH_MASTER_AWBURST - 1 DOWNTO 0);
  signal m_axi_awlock  : std_logic_vector(WIDTH_MASTER_PORTS * WIDTH_MASTER_AWLOCK - 1 DOWNTO 0);
  signal m_axi_awcache : std_logic_vector(WIDTH_MASTER_PORTS * WIDTH_MASTER_AWCACHE - 1 DOWNTO 0);
  signal m_axi_awprot  : std_logic_vector(WIDTH_MASTER_PORTS * WIDTH_MASTER_AWPROT - 1 DOWNTO 0);
  signal m_axi_awqos   : std_logic_vector(WIDTH_MASTER_PORTS * WIDTH_MASTER_AWQOS - 1 DOWNTO 0);
  signal m_axi_awvalid : std_logic_vector(WIDTH_MASTER_PORTS - 1 DOWNTO 0);
  signal m_axi_awready : std_logic_vector(WIDTH_MASTER_PORTS - 1 DOWNTO 0);
  signal m_axi_wid     : std_logic_vector(WIDTH_MASTER_PORTS * WIDTH_MASTER_WID - 1 DOWNTO 0);
  signal m_axi_wdata   : std_logic_vector(WIDTH_MASTER_PORTS * WIDTH_MASTER_WDATA- 1  DOWNTO 0);
  signal m_axi_wstrb   : std_logic_vector(WIDTH_MASTER_PORTS * WIDTH_MASTER_WSTRB - 1 DOWNTO 0);
  signal m_axi_wlast   : std_logic_vector(WIDTH_MASTER_PORTS - 1 DOWNTO 0);
  signal m_axi_wvalid  : std_logic_vector(WIDTH_MASTER_PORTS - 1 DOWNTO 0);
  signal m_axi_wready  : std_logic_vector(WIDTH_MASTER_PORTS - 1 DOWNTO 0);
  signal m_axi_bid     : std_logic_vector(WIDTH_MASTER_PORTS * WIDTH_MASTER_BID - 1 DOWNTO 0);
  signal m_axi_bresp   : std_logic_vector(WIDTH_MASTER_PORTS * WIDTH_MASTER_BRESP - 1 DOWNTO 0);
  signal m_axi_bvalid  : std_logic_vector(WIDTH_MASTER_PORTS - 1 DOWNTO 0);
  signal m_axi_bready  : std_logic_vector(WIDTH_MASTER_PORTS - 1 DOWNTO 0);
  signal m_axi_arid    : std_logic_vector(WIDTH_MASTER_PORTS * WIDTH_MASTER_ARID - 1 DOWNTO 0);
  signal m_axi_araddr  : std_logic_vector(WIDTH_MASTER_PORTS * WIDTH_MASTER_ARADDR - 1 DOWNTO 0);
  signal m_axi_arlen   : std_logic_vector(WIDTH_MASTER_PORTS * WIDTH_MASTER_ARLEN - 1 DOWNTO 0);
  signal m_axi_arsize  : std_logic_vector(WIDTH_MASTER_PORTS * WIDTH_MASTER_ARSIZE - 1 DOWNTO 0);
  signal m_axi_arburst : std_logic_vector(WIDTH_MASTER_PORTS * WIDTH_MASTER_ARBURST - 1 DOWNTO 0);
  signal m_axi_arlock  : std_logic_vector(WIDTH_MASTER_PORTS * WIDTH_MASTER_ARLOCK - 1 DOWNTO 0);
  signal m_axi_arcache : std_logic_vector(WIDTH_MASTER_PORTS * WIDTH_MASTER_ARCACHE - 1 DOWNTO 0);
  signal m_axi_arprot  : std_logic_vector(WIDTH_MASTER_PORTS * WIDTH_MASTER_ARPROT - 1 DOWNTO 0);
  signal m_axi_arqos   : std_logic_vector(WIDTH_MASTER_PORTS * WIDTH_MASTER_ARQOS - 1 DOWNTO 0);
  signal m_axi_arvalid : std_logic_vector(WIDTH_MASTER_PORTS - 1 DOWNTO 0);
  signal m_axi_arready : std_logic_vector(WIDTH_MASTER_PORTS - 1 DOWNTO 0);
  signal m_axi_rid     : std_logic_vector(WIDTH_MASTER_PORTS * WIDTH_MASTER_RID - 1 DOWNTO 0);
  signal m_axi_rdata   : std_logic_vector(WIDTH_MASTER_PORTS * WIDTH_MASTER_RDATA - 1 DOWNTO 0);
  signal m_axi_rresp   : std_logic_vector(WIDTH_MASTER_PORTS * WIDTH_MASTER_RRESP - 1 DOWNTO 0);
  signal m_axi_rlast   : std_logic_vector(WIDTH_MASTER_PORTS - 1 DOWNTO 0);
  signal m_axi_rvalid  : std_logic_vector(WIDTH_MASTER_PORTS - 1 DOWNTO 0);
  signal m_axi_rready  : std_logic_vector(WIDTH_MASTER_PORTS - 1 DOWNTO 0);

  signal s0_axi4_i : t_AXI4_SLAVE_INPUT;
  signal s0_axi4_o : t_AXI4_SLAVE_OUTPUT;
  signal s0_axi3_i : t_AXI3_SLAVE_INPUT;
  signal s0_axi3_o : t_AXI3_SLAVE_OUTPUT;

  signal m0_axi3_i     : t_AXI3_MASTER_INPUT;
  signal m0_axi3_o     : t_AXI3_MASTER_OUTPUT;
  signal m0_axi4lite_i : t_AXI4_LITE_MASTER_INPUT;
  signal m0_axi4lite_o : t_AXI4_LITE_MASTER_OUTPUT;

  signal s1_axi_32_i : t_AXI3_SLAVE_INPUT;
  signal s1_axi_32_o : t_AXI3_SLAVE_OUTPUT;
  signal s1_axi_64_i : t_AXI3_64_SLAVE_INPUT;
  signal s1_axi_64_o : t_AXI3_64_SLAVE_OUTPUT;
  signal m1_axi_32_i : t_AXI3_MASTER_INPUT;
  signal m1_axi_32_o : t_AXI3_MASTER_OUTPUT;

  signal s0_axi4_bid_int     : std_logic_vector(0 downto 0);
  signal s0_axi4_bresp_int   : std_logic_vector(1 downto 0);
  signal s0_axi4_rid_int     : std_logic_vector(0 downto 0);
  signal s0_axi4_rdata_int   : std_logic_vector(31 downto 0);
  signal s0_axi4_rresp_int   : std_logic_vector(1 downto 0);
  signal s0_axi3_awid_int    : std_logic_vector(0 downto 0);
  signal s0_axi3_awaddr_int  : std_logic_vector(63 downto 0);
  signal s0_axi3_awlen_int   : std_logic_vector(3 downto 0);
  signal s0_axi3_awsize_int  : std_logic_vector(2 downto 0);
  signal s0_axi3_awburst_int : std_logic_vector(1 downto 0);
  signal s0_axi3_awlock_int  : std_logic_vector(1 downto 0);
  signal s0_axi3_awcache_int : std_logic_vector(3 downto 0);
  signal s0_axi3_awprot_int  : std_logic_vector(2 downto 0);
  signal s0_axi3_wid_int     : std_logic_vector(0 downto 0);
  signal s0_axi3_wdata_int   : std_logic_vector(31 downto 0);
  signal s0_axi3_wstrb_int   : std_logic_vector(3 downto 0);
  signal bid_tmp             : std_ulogic_vector(6 downto 0);
  signal s0_axi3_bid_int     : std_logic_vector(0 downto 0);
  signal s0_axi3_arid_int    : std_logic_vector(0 downto 0);
  signal s0_axi3_araddr_int  : std_logic_vector(63 downto 0);
  signal s0_axi3_arlen_int   : std_logic_vector(3 downto 0);
  signal s0_axi3_arsize_int  : std_logic_vector(2 downto 0);
  signal s0_axi3_arburst_int : std_logic_vector(1 downto 0);
  signal s0_axi3_arlock_int  : std_logic_vector(1 downto 0);
  signal s0_axi3_arcache_int : std_logic_vector(3 downto 0);
  signal s0_axi3_arprot_int  : std_logic_vector(2 downto 0);
  signal rid_tmp             : std_ulogic_vector(6 downto 0);
  signal s0_axi3_rid_int     : std_logic_vector(0 downto 0);

  signal m0_axi3_bid_int        : std_logic_vector(6 downto 0);
  signal m0_axi3_bresp_int      : std_logic_vector(1 downto 0);
  signal m0_axi3_rid_int        : std_logic_vector(6 downto 0);
  signal m0_axi3_rdata_int      : std_logic_vector(31 downto 0);
  signal m0_axi3_rresp_int      : std_logic_vector(1 downto 0);
  signal m0_axi4lite_awaddr_int : std_logic_vector(63 downto 0);
  signal m0_axi4lite_awprot_int : std_logic_vector(2 downto 0);
  signal m0_axi4lite_wdata_int  : std_logic_vector(31 downto 0);
  signal m0_axi4lite_wstrb_int  : std_logic_vector(3 downto 0);
  signal m0_axi4lite_araddr_int : std_logic_vector(63 downto 0);
  signal m0_axi4lite_arprot_int : std_logic_vector(2 downto 0);

  signal m0_axi_slice_i  : t_AXI3_SLAVE_INPUT;
  signal m0_axi_slice_o  : t_AXI3_SLAVE_OUTPUT;
  signal m1_axi_slice_i  : t_AXI3_SLAVE_INPUT;
  signal m1_axi_slice_o  : t_AXI3_SLAVE_OUTPUT;
  signal m2_axi_slice_i  : t_AXI3_SLAVE_INPUT;
  signal m2_axi_slice_o  : t_AXI3_SLAVE_OUTPUT;
  signal m3_axi_slice_i  : t_AXI3_SLAVE_INPUT;
  signal m3_axi_slice_o  : t_AXI3_SLAVE_OUTPUT;
  signal m4_axi_slice_i  : t_AXI3_SLAVE_INPUT;
  signal m4_axi_slice_o  : t_AXI3_SLAVE_OUTPUT;
  signal m5_axi_slice_i  : t_AXI3_SLAVE_INPUT;
  signal m5_axi_slice_o  : t_AXI3_SLAVE_OUTPUT;
  signal m6_axi_slice_i  : t_AXI3_SLAVE_INPUT;
  signal m6_axi_slice_o  : t_AXI3_SLAVE_OUTPUT;
  signal m7_axi_slice_i  : t_AXI3_SLAVE_INPUT;
  signal m7_axi_slice_o  : t_AXI3_SLAVE_OUTPUT;

  COMPONENT axi4_axi3_protocol_converter_0
    PORT (
      aclk : IN STD_LOGIC;
      aresetn : IN STD_LOGIC;
      s_axi_awid : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      s_axi_awaddr : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
      s_axi_awlen : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      s_axi_awsize : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_awburst : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      s_axi_awlock : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      s_axi_awcache : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axi_awprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_awregion : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axi_awqos : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axi_awvalid : IN STD_LOGIC;
      s_axi_awready : OUT STD_LOGIC;
      s_axi_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      s_axi_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axi_wlast : IN STD_LOGIC;
      s_axi_wvalid : IN STD_LOGIC;
      s_axi_wready : OUT STD_LOGIC;
      s_axi_bid : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      s_axi_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      s_axi_bvalid : OUT STD_LOGIC;
      s_axi_bready : IN STD_LOGIC;
      s_axi_arid : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      s_axi_araddr : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
      s_axi_arlen : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      s_axi_arsize : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_arburst : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      s_axi_arlock : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      s_axi_arcache : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axi_arprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_arregion : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axi_arqos : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axi_arvalid : IN STD_LOGIC;
      s_axi_arready : OUT STD_LOGIC;
      s_axi_rid : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      s_axi_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      s_axi_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      s_axi_rlast : OUT STD_LOGIC;
      s_axi_rvalid : OUT STD_LOGIC;
      s_axi_rready : IN STD_LOGIC;
      m_axi_awid : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      m_axi_awaddr : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
      m_axi_awlen : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axi_awsize : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      m_axi_awburst : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      m_axi_awlock : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      m_axi_awcache : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axi_awprot : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      m_axi_awqos : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axi_awvalid : OUT STD_LOGIC;
      m_axi_awready : IN STD_LOGIC;
      m_axi_wid : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      m_axi_wdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      m_axi_wstrb : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axi_wlast : OUT STD_LOGIC;
      m_axi_wvalid : OUT STD_LOGIC;
      m_axi_wready : IN STD_LOGIC;
      m_axi_bid : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      m_axi_bresp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      m_axi_bvalid : IN STD_LOGIC;
      m_axi_bready : OUT STD_LOGIC;
      m_axi_arid : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      m_axi_araddr : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
      m_axi_arlen : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axi_arsize : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      m_axi_arburst : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      m_axi_arlock : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      m_axi_arcache : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axi_arprot : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      m_axi_arqos : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axi_arvalid : OUT STD_LOGIC;
      m_axi_arready : IN STD_LOGIC;
      m_axi_rid : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      m_axi_rdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      m_axi_rresp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      m_axi_rlast : IN STD_LOGIC;
      m_axi_rvalid : IN STD_LOGIC;
      m_axi_rready : OUT STD_LOGIC
      );
  END COMPONENT;

  COMPONENT axi3_axi4lite_protocol_converter_0
    PORT (
      aclk : IN STD_LOGIC;
      aresetn : IN STD_LOGIC;
      s_axi_awid : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
      s_axi_awaddr : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
      s_axi_awlen : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axi_awsize : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_awburst : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      s_axi_awlock : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      s_axi_awcache : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axi_awprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_awqos : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axi_awvalid : IN STD_LOGIC;
      s_axi_awready : OUT STD_LOGIC;
      s_axi_wid : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
      s_axi_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      s_axi_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axi_wlast : IN STD_LOGIC;
      s_axi_wvalid : IN STD_LOGIC;
      s_axi_wready : OUT STD_LOGIC;
      s_axi_bid : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
      s_axi_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      s_axi_bvalid : OUT STD_LOGIC;
      s_axi_bready : IN STD_LOGIC;
      s_axi_arid : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
      s_axi_araddr : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
      s_axi_arlen : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axi_arsize : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_arburst : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      s_axi_arlock : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      s_axi_arcache : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axi_arprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_arqos : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axi_arvalid : IN STD_LOGIC;
      s_axi_arready : OUT STD_LOGIC;
      s_axi_rid : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
      s_axi_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      s_axi_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      s_axi_rlast : OUT STD_LOGIC;
      s_axi_rvalid : OUT STD_LOGIC;
      s_axi_rready : IN STD_LOGIC;
      m_axi_awaddr : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
      m_axi_awprot : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      m_axi_awvalid : OUT STD_LOGIC;
      m_axi_awready : IN STD_LOGIC;
      m_axi_wdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      m_axi_wstrb : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axi_wvalid : OUT STD_LOGIC;
      m_axi_wready : IN STD_LOGIC;
      m_axi_bresp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      m_axi_bvalid : IN STD_LOGIC;
      m_axi_bready : OUT STD_LOGIC;
      m_axi_araddr : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
      m_axi_arprot : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      m_axi_arvalid : OUT STD_LOGIC;
      m_axi_arready : IN STD_LOGIC;
      m_axi_rdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      m_axi_rresp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      m_axi_rvalid : IN STD_LOGIC;
      m_axi_rready : OUT STD_LOGIC
      );
  END COMPONENT;

  COMPONENT axi3_crossbar_0
    PORT (
      aclk : IN STD_LOGIC;
      aresetn : IN STD_LOGIC;
      s_axi_awid : IN STD_LOGIC_VECTOR(20 DOWNTO 0);
      s_axi_awaddr : IN STD_LOGIC_VECTOR(191 DOWNTO 0);
      s_axi_awlen : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
      s_axi_awsize : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
      s_axi_awburst : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
      s_axi_awlock : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
      s_axi_awcache : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
      s_axi_awprot : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
      s_axi_awqos : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
      s_axi_awvalid : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_awready : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_wid : IN STD_LOGIC_VECTOR(20 DOWNTO 0);
      s_axi_wdata : IN STD_LOGIC_VECTOR(95 DOWNTO 0);
      s_axi_wstrb : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
      s_axi_wlast : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_wvalid : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_wready : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_bid : OUT STD_LOGIC_VECTOR(20 DOWNTO 0);
      s_axi_bresp : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
      s_axi_bvalid : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_bready : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_arid : IN STD_LOGIC_VECTOR(20 DOWNTO 0);
      s_axi_araddr : IN STD_LOGIC_VECTOR(191 DOWNTO 0);
      s_axi_arlen : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
      s_axi_arsize : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
      s_axi_arburst : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
      s_axi_arlock : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
      s_axi_arcache : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
      s_axi_arprot : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
      s_axi_arqos : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
      s_axi_arvalid : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_arready : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_rid : OUT STD_LOGIC_VECTOR(20 DOWNTO 0);
      s_axi_rdata : OUT STD_LOGIC_VECTOR(95 DOWNTO 0);
      s_axi_rresp : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
      s_axi_rlast : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_rvalid : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_rready : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      m_axi_awid : OUT STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS * WIDTH_MASTER_AWID - 1 DOWNTO 0);
      m_axi_awaddr : OUT STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS * WIDTH_MASTER_AWADDR - 1 DOWNTO 0);
      m_axi_awlen : OUT STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS * WIDTH_MASTER_AWLEN - 1 DOWNTO 0);
      m_axi_awsize : OUT STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS * WIDTH_MASTER_AWSIZE - 1 DOWNTO 0);
      m_axi_awburst : OUT STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS * WIDTH_MASTER_AWBURST - 1 DOWNTO 0);
      m_axi_awlock : OUT STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS * WIDTH_MASTER_AWLOCK - 1 DOWNTO 0);
      m_axi_awcache : OUT STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS * WIDTH_MASTER_AWCACHE - 1 DOWNTO 0);
      m_axi_awprot : OUT STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS * WIDTH_MASTER_AWPROT - 1 DOWNTO 0);
      m_axi_awqos : OUT STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS * WIDTH_MASTER_AWQOS - 1 DOWNTO 0);
      m_axi_awvalid : OUT STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS - 1 DOWNTO 0);
      m_axi_awready : IN STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS - 1 DOWNTO 0);
      m_axi_wid : OUT STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS * WIDTH_MASTER_WID - 1 DOWNTO 0);
      m_axi_wdata : OUT STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS * WIDTH_MASTER_WDATA- 1  DOWNTO 0);
      m_axi_wstrb : OUT STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS * WIDTH_MASTER_WSTRB - 1 DOWNTO 0);
      m_axi_wlast : OUT STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS - 1 DOWNTO 0);
      m_axi_wvalid : OUT STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS - 1 DOWNTO 0);
      m_axi_wready : IN STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS - 1 DOWNTO 0);
      m_axi_bid : IN STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS * WIDTH_MASTER_BID - 1 DOWNTO 0);
      m_axi_bresp : IN STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS * WIDTH_MASTER_BRESP - 1 DOWNTO 0);
      m_axi_bvalid : IN STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS - 1 DOWNTO 0);
      m_axi_bready : OUT STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS - 1 DOWNTO 0);
      m_axi_arid : OUT STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS * WIDTH_MASTER_ARID - 1 DOWNTO 0);
      m_axi_araddr : OUT STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS * WIDTH_MASTER_ARADDR - 1 DOWNTO 0);
      m_axi_arlen : OUT STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS * WIDTH_MASTER_ARLEN - 1 DOWNTO 0);
      m_axi_arsize : OUT STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS * WIDTH_MASTER_ARSIZE - 1 DOWNTO 0);
      m_axi_arburst : OUT STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS * WIDTH_MASTER_ARBURST - 1 DOWNTO 0);
      m_axi_arlock : OUT STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS * WIDTH_MASTER_ARLOCK - 1 DOWNTO 0);
      m_axi_arcache : OUT STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS * WIDTH_MASTER_ARCACHE - 1 DOWNTO 0);
      m_axi_arprot : OUT STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS * WIDTH_MASTER_ARPROT - 1 DOWNTO 0);
      m_axi_arqos : OUT STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS * WIDTH_MASTER_ARQOS - 1 DOWNTO 0);
      m_axi_arvalid : OUT STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS - 1 DOWNTO 0);
      m_axi_arready : IN STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS - 1 DOWNTO 0);
      m_axi_rid : IN STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS * WIDTH_MASTER_RID - 1 DOWNTO 0);
      m_axi_rdata : IN STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS * WIDTH_MASTER_RDATA - 1 DOWNTO 0);
      m_axi_rresp : IN STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS * WIDTH_MASTER_RRESP - 1 DOWNTO 0);
      m_axi_rlast : IN STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS - 1 DOWNTO 0);
      m_axi_rvalid : IN STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS - 1 DOWNTO 0);
      m_axi_rready : OUT STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS - 1 DOWNTO 0)
      );
  END COMPONENT;

begin

  -- Slave Mapping
  s_axi_awid(6 downto 0)       <= To_StdLogicVector(s0_axi3_i.s0_axi_awid);
  s_axi_awid(13 downto 7)      <= To_StdLogicVector(s1_axi_32_i.s0_axi_awid);
  s_axi_awid(20 downto 14)     <= To_StdLogicVector(s2_axi_i.s0_axi_awid);
  s_axi_awaddr(63 downto 0)    <= To_StdLogicVector(s0_axi3_i.s0_axi_awaddr);
  s_axi_awaddr(127 downto 64)  <= To_StdLogicVector(s1_axi_32_i.s0_axi_awaddr);
  s_axi_awaddr(191 downto 128) <= To_StdLogicVector(s2_axi_i.s0_axi_awaddr);
  s_axi_awlen(3 downto 0)      <= To_StdLogicVector(s0_axi3_i.s0_axi_awlen);
  s_axi_awlen(7 downto 4)      <= To_StdLogicVector(s1_axi_32_i.s0_axi_awlen);
  s_axi_awlen(11 downto 8)     <= To_StdLogicVector(s2_axi_i.s0_axi_awlen);
  s_axi_awsize(2 downto 0)     <= To_StdLogicVector(s0_axi3_i.s0_axi_awsize);
  s_axi_awsize(5 downto 3)     <= To_StdLogicVector(s1_axi_32_i.s0_axi_awsize);
  s_axi_awsize(8 downto 6)     <= To_StdLogicVector(s2_axi_i.s0_axi_awsize);
  s_axi_awburst(1 downto 0)    <= To_StdLogicVector(s0_axi3_i.s0_axi_awburst);
  s_axi_awburst(3 downto 2)    <= To_StdLogicVector(s1_axi_32_i.s0_axi_awburst);
  s_axi_awburst(5 downto 4)    <= To_StdLogicVector(s2_axi_i.s0_axi_awburst);
  s_axi_awlock(1 downto 0)     <= To_StdLogicVector(s0_axi3_i.s0_axi_awlock);
  s_axi_awlock(3 downto 2)     <= To_StdLogicVector(s1_axi_32_i.s0_axi_awlock);
  s_axi_awlock(5 downto 4)     <= To_StdLogicVector(s2_axi_i.s0_axi_awlock);
  s_axi_awcache(3 downto 0)    <= To_StdLogicVector(s0_axi3_i.s0_axi_awcache);
  s_axi_awcache(7 downto 4)    <= To_StdLogicVector(s1_axi_32_i.s0_axi_awcache);
  s_axi_awcache(11 downto 8)   <= To_StdLogicVector(s2_axi_i.s0_axi_awcache);
  s_axi_awprot(2 downto 0)     <= To_StdLogicVector(s0_axi3_i.s0_axi_awprot);
  s_axi_awprot(5 downto 3)     <= To_StdLogicVector(s1_axi_32_i.s0_axi_awprot);
  s_axi_awprot(8 downto 6)     <= To_StdLogicVector(s2_axi_i.s0_axi_awprot);
  s_axi_awqos(3 downto 0)      <= "0000";  -- QOS is not in AXI3
  s_axi_awqos(7 downto 4)      <= "0000";
  s_axi_awqos(11 downto 8)     <= "0000";
  s_axi_awvalid(0)             <= s0_axi3_i.s0_axi_awvalid;
  s_axi_awvalid(1)             <= s1_axi_32_i.s0_axi_awvalid;
  s_axi_awvalid(2)             <= s2_axi_i.s0_axi_awvalid;
  s0_axi3_o.s0_axi_awready     <= s_axi_awready(0);
  s1_axi_32_o.s0_axi_awready   <= s_axi_awready(1);
  s2_axi_o.s0_axi_awready      <= s_axi_awready(2);

  s_axi_wid(6 downto 0)     <= To_StdLogicVector(s0_axi3_i.s0_axi_wid);
  s_axi_wid(13 downto 7)    <= To_StdLogicVector(s1_axi_32_i.s0_axi_wid);
  s_axi_wid(20 downto 14)   <= To_StdLogicVector(s2_axi_i.s0_axi_wid);
  s_axi_wdata(31 downto 0)  <= To_StdLogicVector(s0_axi3_i.s0_axi_wdata);
  s_axi_wdata(63 downto 32) <= To_StdLogicVector(s1_axi_32_i.s0_axi_wdata);
  s_axi_wdata(95 downto 64) <= To_StdLogicVector(s2_axi_i.s0_axi_wdata);
  s_axi_wstrb(3 downto 0)   <= To_StdLogicVector(s0_axi3_i.s0_axi_wstrb);
  s_axi_wstrb(7 downto 4)   <= To_StdLogicVector(s1_axi_32_i.s0_axi_wstrb);
  s_axi_wstrb(11 downto 8)  <= To_StdLogicVector(s2_axi_i.s0_axi_wstrb);
  s_axi_wlast(0)            <= s0_axi3_i.s0_axi_wlast;
  s_axi_wlast(1)            <= s1_axi_32_i.s0_axi_wlast;
  s_axi_wlast(2)            <= s2_axi_i.s0_axi_wlast;
  s_axi_wvalid(0)           <= s0_axi3_i.s0_axi_wvalid;
  s_axi_wvalid(1)           <= s1_axi_32_i.s0_axi_wvalid;
  s_axi_wvalid(2)           <= s2_axi_i.s0_axi_wvalid;
  s0_axi3_o.s0_axi_wready   <= s_axi_wready(0);
  s1_axi_32_o.s0_axi_wready <= s_axi_wready(1);
  s2_axi_o.s0_axi_wready    <= s_axi_wready(2);

  s0_axi3_o.s0_axi_bid      <= To_StdULogicVector(s_axi_bid(6 downto 0));
  s1_axi_32_o.s0_axi_bid    <= To_StdULogicVector(s_axi_bid(13 downto 7));
  s2_axi_o.s0_axi_bid       <= To_StdULogicVector(s_axi_bid(20 downto 14));
  s0_axi3_o.s0_axi_bresp    <= To_StdULogicVector(s_axi_bresp(1 downto 0));
  s1_axi_32_o.s0_axi_bresp  <= To_StdULogicVector(s_axi_bresp(3 downto 2));
  s2_axi_o.s0_axi_bresp     <= To_StdULogicVector(s_axi_bresp(5 downto 4));
  s0_axi3_o.s0_axi_bvalid   <= s_axi_bvalid(0);
  s1_axi_32_o.s0_axi_bvalid <= s_axi_bvalid(1);
  s2_axi_o.s0_axi_bvalid    <= s_axi_bvalid(2);
  s_axi_bready(0)           <= s0_axi3_i.s0_axi_bready;
  s_axi_bready(1)           <= s1_axi_32_i.s0_axi_bready;
  s_axi_bready(2)           <= s2_axi_i.s0_axi_bready;

  s_axi_arid(6 downto 0)       <= To_StdLogicVector(s0_axi3_i.s0_axi_arid);
  s_axi_arid(13 downto 7)      <= To_StdLogicVector(s1_axi_32_i.s0_axi_arid);
  s_axi_arid(20 downto 14)     <= To_StdLogicVector(s2_axi_i.s0_axi_arid);
  s_axi_araddr(63 downto 0)    <= To_StdLogicVector(s0_axi3_i.s0_axi_araddr);
  s_axi_araddr(127 downto 64)  <= To_StdLogicVector(s1_axi_32_i.s0_axi_araddr);
  s_axi_araddr(191 downto 128) <= To_StdLogicVector(s2_axi_i.s0_axi_araddr);
  s_axi_arlen(3 downto 0)      <= To_StdLogicVector(s0_axi3_i.s0_axi_arlen);
  s_axi_arlen(7 downto 4)      <= To_StdLogicVector(s1_axi_32_i.s0_axi_arlen);
  s_axi_arlen(11 downto 8)     <= To_StdLogicVector(s2_axi_i.s0_axi_arlen);
  s_axi_arsize(2 downto 0)     <= To_StdLogicVector(s0_axi3_i.s0_axi_arsize);
  s_axi_arsize(5 downto 3)     <= To_StdLogicVector(s1_axi_32_i.s0_axi_arsize);
  s_axi_arsize(8 downto 6)     <= To_StdLogicVector(s2_axi_i.s0_axi_arsize);
  s_axi_arburst(1 downto 0)    <= To_StdLogicVector(s0_axi3_i.s0_axi_arburst);
  s_axi_arburst(3 downto 2)    <= To_StdLogicVector(s1_axi_32_i.s0_axi_arburst);
  s_axi_arburst(5 downto 4)    <= To_StdLogicVector(s2_axi_i.s0_axi_arburst);
  s_axi_arlock(1 downto 0)     <= To_StdLogicVector(s0_axi3_i.s0_axi_arlock);
  s_axi_arlock(3 downto 2)     <= To_StdLogicVector(s1_axi_32_i.s0_axi_arlock);
  s_axi_arlock(5 downto 4)     <= To_StdLogicVector(s2_axi_i.s0_axi_arlock);
  s_axi_arcache(3 downto 0)    <= To_StdLogicVector(s0_axi3_i.s0_axi_arcache);
  s_axi_arcache(7 downto 4)    <= To_StdLogicVector(s1_axi_32_i.s0_axi_arcache);
  s_axi_arcache(11 downto 8)   <= To_StdLogicVector(s2_axi_i.s0_axi_arcache);
  s_axi_arprot(2 downto 0)     <= To_StdLogicVector(s0_axi3_i.s0_axi_arprot);
  s_axi_arprot(5 downto 3)     <= To_StdLogicVector(s1_axi_32_i.s0_axi_arprot);
  s_axi_arprot(8 downto 6)     <= To_StdLogicVector(s2_axi_i.s0_axi_arprot);
  s_axi_arqos(3 downto 0)      <= "0000";  -- QOS is not in AXI3
  s_axi_arqos(7 downto 4)      <= "0000";
  s_axi_arqos(11 downto 8)     <= "0000";
  s_axi_arvalid(0)             <= s0_axi3_i.s0_axi_arvalid;
  s_axi_arvalid(1)             <= s1_axi_32_i.s0_axi_arvalid;
  s_axi_arvalid(2)             <= s2_axi_i.s0_axi_arvalid;
  s0_axi3_o.s0_axi_arready     <= s_axi_arready(0);
  s1_axi_32_o.s0_axi_arready   <= s_axi_arready(1);
  s2_axi_o.s0_axi_arready      <= s_axi_arready(2);

  s0_axi3_o.s0_axi_rid      <= To_StdULogicVector(s_axi_rid(6 downto 0));
  s1_axi_32_o.s0_axi_rid    <= To_StdULogicVector(s_axi_rid(13 downto 7));
  s2_axi_o.s0_axi_rid       <= To_StdULogicVector(s_axi_rid(20 downto 14));
  s0_axi3_o.s0_axi_rdata    <= To_StdULogicVector(s_axi_rdata(31 downto 0));
  s1_axi_32_o.s0_axi_rdata  <= To_StdULogicVector(s_axi_rdata(63 downto 32));
  s2_axi_o.s0_axi_rdata     <= To_StdULogicVector(s_axi_rdata(95 downto 64));
  s0_axi3_o.s0_axi_rresp    <= To_StdULogicVector(s_axi_rresp(1 downto 0));
  s1_axi_32_o.s0_axi_rresp  <= To_StdULogicVector(s_axi_rresp(3 downto 2));
  s2_axi_o.s0_axi_rresp     <= To_StdULogicVector(s_axi_rresp(5 downto 4));
  s0_axi3_o.s0_axi_rlast    <= s_axi_rlast(0);
  s1_axi_32_o.s0_axi_rlast  <= s_axi_rlast(1);
  s2_axi_o.s0_axi_rlast     <= s_axi_rlast(2);
  s0_axi3_o.s0_axi_rvalid   <= s_axi_rvalid(0);
  s1_axi_32_o.s0_axi_rvalid <= s_axi_rvalid(1);
  s2_axi_o.s0_axi_rvalid    <= s_axi_rvalid(2);
  s_axi_rready(0)           <= s0_axi3_i.s0_axi_rready;
  s_axi_rready(1)           <= s1_axi_32_i.s0_axi_rready;
  s_axi_rready(2)           <= s2_axi_i.s0_axi_rready;

  -- Master Mapping
  m0_axi3_o.m0_axi_aresetn       <= aresetn;
  m1_axi_slice_i.s0_axi_aresetn  <= aresetn;
  m2_axi_slice_i.s0_axi_aresetn  <= aresetn;
  m3_axi_slice_i.s0_axi_aresetn  <= aresetn;
  m4_axi_slice_i.s0_axi_aresetn  <= aresetn;
  m5_axi_slice_i.s0_axi_aresetn  <= aresetn;
  m6_axi_slice_i.s0_axi_aresetn  <= aresetn;
  m7_axi_slice_i.s0_axi_aresetn  <= aresetn;

  m0_axi3_o.m0_axi_awid          <= To_StdULogicVector(m_axi_awid( 1*WIDTH_MASTER_AWID - 1 downto  0*WIDTH_MASTER_AWID));
  m1_axi_slice_i.s0_axi_awid     <= To_StdULogicVector(m_axi_awid( 2*WIDTH_MASTER_AWID - 1 downto  1*WIDTH_MASTER_AWID));
  m2_axi_slice_i.s0_axi_awid     <= To_StdULogicVector(m_axi_awid( 3*WIDTH_MASTER_AWID - 1 downto  2*WIDTH_MASTER_AWID));
  m3_axi_slice_i.s0_axi_awid     <= To_StdULogicVector(m_axi_awid( 4*WIDTH_MASTER_AWID - 1 downto  3*WIDTH_MASTER_AWID));
  m4_axi_slice_i.s0_axi_awid     <= To_StdULogicVector(m_axi_awid( 5*WIDTH_MASTER_AWID - 1 downto  4*WIDTH_MASTER_AWID));
  m5_axi_slice_i.s0_axi_awid     <= To_StdULogicVector(m_axi_awid( 6*WIDTH_MASTER_AWID - 1 downto  5*WIDTH_MASTER_AWID));
  m6_axi_slice_i.s0_axi_awid     <= To_StdULogicVector(m_axi_awid( 7*WIDTH_MASTER_AWID - 1 downto  6*WIDTH_MASTER_AWID));
  m7_axi_slice_i.s0_axi_awid     <= To_StdULogicVector(m_axi_awid( 8*WIDTH_MASTER_AWID - 1 downto  7*WIDTH_MASTER_AWID));
  m0_axi3_o.m0_axi_awaddr        <= To_StdULogicVector(m_axi_awaddr( 1*WIDTH_MASTER_AWADDR - 1 downto  0*WIDTH_MASTER_AWADDR));
  m1_axi_slice_i.s0_axi_awaddr   <= To_StdULogicVector(m_axi_awaddr( 2*WIDTH_MASTER_AWADDR - 1 downto  1*WIDTH_MASTER_AWADDR));
  m2_axi_slice_i.s0_axi_awaddr   <= To_StdULogicVector(m_axi_awaddr( 3*WIDTH_MASTER_AWADDR - 1 downto  2*WIDTH_MASTER_AWADDR));
  m3_axi_slice_i.s0_axi_awaddr   <= To_StdULogicVector(m_axi_awaddr( 4*WIDTH_MASTER_AWADDR - 1 downto  3*WIDTH_MASTER_AWADDR));
  m4_axi_slice_i.s0_axi_awaddr   <= To_StdULogicVector(m_axi_awaddr( 5*WIDTH_MASTER_AWADDR - 1 downto  4*WIDTH_MASTER_AWADDR));
  m5_axi_slice_i.s0_axi_awaddr   <= To_StdULogicVector(m_axi_awaddr( 6*WIDTH_MASTER_AWADDR - 1 downto  5*WIDTH_MASTER_AWADDR));
  m6_axi_slice_i.s0_axi_awaddr   <= To_StdULogicVector(m_axi_awaddr( 7*WIDTH_MASTER_AWADDR - 1 downto  6*WIDTH_MASTER_AWADDR));
  m7_axi_slice_i.s0_axi_awaddr   <= To_StdULogicVector(m_axi_awaddr( 8*WIDTH_MASTER_AWADDR - 1 downto  7*WIDTH_MASTER_AWADDR));
  m0_axi3_o.m0_axi_awlen         <= To_StdULogicVector(m_axi_awlen( 1*WIDTH_MASTER_AWLEN - 1 downto  0*WIDTH_MASTER_AWLEN));
  m1_axi_slice_i.s0_axi_awlen    <= To_StdULogicVector(m_axi_awlen( 2*WIDTH_MASTER_AWLEN - 1 downto  1*WIDTH_MASTER_AWLEN));
  m2_axi_slice_i.s0_axi_awlen    <= To_StdULogicVector(m_axi_awlen( 3*WIDTH_MASTER_AWLEN - 1 downto  2*WIDTH_MASTER_AWLEN));
  m3_axi_slice_i.s0_axi_awlen    <= To_StdULogicVector(m_axi_awlen( 4*WIDTH_MASTER_AWLEN - 1 downto  3*WIDTH_MASTER_AWLEN));
  m4_axi_slice_i.s0_axi_awlen    <= To_StdULogicVector(m_axi_awlen( 5*WIDTH_MASTER_AWLEN - 1 downto  4*WIDTH_MASTER_AWLEN));
  m5_axi_slice_i.s0_axi_awlen    <= To_StdULogicVector(m_axi_awlen( 6*WIDTH_MASTER_AWLEN - 1 downto  5*WIDTH_MASTER_AWLEN));
  m6_axi_slice_i.s0_axi_awlen    <= To_StdULogicVector(m_axi_awlen( 7*WIDTH_MASTER_AWLEN - 1 downto  6*WIDTH_MASTER_AWLEN));
  m7_axi_slice_i.s0_axi_awlen    <= To_StdULogicVector(m_axi_awlen( 8*WIDTH_MASTER_AWLEN - 1 downto  7*WIDTH_MASTER_AWLEN));
  m0_axi3_o.m0_axi_awsize        <= To_StdULogicVector(m_axi_awsize( 1*WIDTH_MASTER_AWSIZE - 1 downto  0*WIDTH_MASTER_AWSIZE));
  m1_axi_slice_i.s0_axi_awsize   <= To_StdULogicVector(m_axi_awsize( 2*WIDTH_MASTER_AWSIZE - 1 downto  1*WIDTH_MASTER_AWSIZE));
  m2_axi_slice_i.s0_axi_awsize   <= To_StdULogicVector(m_axi_awsize( 3*WIDTH_MASTER_AWSIZE - 1 downto  2*WIDTH_MASTER_AWSIZE));
  m3_axi_slice_i.s0_axi_awsize   <= To_StdULogicVector(m_axi_awsize( 4*WIDTH_MASTER_AWSIZE - 1 downto  3*WIDTH_MASTER_AWSIZE));
  m4_axi_slice_i.s0_axi_awsize   <= To_StdULogicVector(m_axi_awsize( 5*WIDTH_MASTER_AWSIZE - 1 downto  4*WIDTH_MASTER_AWSIZE));
  m5_axi_slice_i.s0_axi_awsize   <= To_StdULogicVector(m_axi_awsize( 6*WIDTH_MASTER_AWSIZE - 1 downto  5*WIDTH_MASTER_AWSIZE));
  m6_axi_slice_i.s0_axi_awsize   <= To_StdULogicVector(m_axi_awsize( 7*WIDTH_MASTER_AWSIZE - 1 downto  6*WIDTH_MASTER_AWSIZE));
  m7_axi_slice_i.s0_axi_awsize   <= To_StdULogicVector(m_axi_awsize( 8*WIDTH_MASTER_AWSIZE - 1 downto  7*WIDTH_MASTER_AWSIZE));
  m0_axi3_o.m0_axi_awburst       <= To_StdULogicVector(m_axi_awburst( 1*WIDTH_MASTER_AWBURST - 1 downto  0*WIDTH_MASTER_AWBURST));
  m1_axi_slice_i.s0_axi_awburst  <= To_StdULogicVector(m_axi_awburst( 2*WIDTH_MASTER_AWBURST - 1 downto  1*WIDTH_MASTER_AWBURST));
  m2_axi_slice_i.s0_axi_awburst  <= To_StdULogicVector(m_axi_awburst( 3*WIDTH_MASTER_AWBURST - 1 downto  2*WIDTH_MASTER_AWBURST));
  m3_axi_slice_i.s0_axi_awburst  <= To_StdULogicVector(m_axi_awburst( 4*WIDTH_MASTER_AWBURST - 1 downto  3*WIDTH_MASTER_AWBURST));
  m4_axi_slice_i.s0_axi_awburst  <= To_StdULogicVector(m_axi_awburst( 5*WIDTH_MASTER_AWBURST - 1 downto  4*WIDTH_MASTER_AWBURST));
  m5_axi_slice_i.s0_axi_awburst  <= To_StdULogicVector(m_axi_awburst( 6*WIDTH_MASTER_AWBURST - 1 downto  5*WIDTH_MASTER_AWBURST));
  m6_axi_slice_i.s0_axi_awburst  <= To_StdULogicVector(m_axi_awburst( 7*WIDTH_MASTER_AWBURST - 1 downto  6*WIDTH_MASTER_AWBURST));
  m7_axi_slice_i.s0_axi_awburst  <= To_StdULogicVector(m_axi_awburst( 8*WIDTH_MASTER_AWBURST - 1 downto  7*WIDTH_MASTER_AWBURST));
  m0_axi3_o.m0_axi_awlock        <= To_StdULogicVector(m_axi_awlock( 1*WIDTH_MASTER_AWLOCK - 1 downto  0*WIDTH_MASTER_AWLOCK));
  m1_axi_slice_i.s0_axi_awlock   <= To_StdULogicVector(m_axi_awlock( 2*WIDTH_MASTER_AWLOCK - 1 downto  1*WIDTH_MASTER_AWLOCK));
  m2_axi_slice_i.s0_axi_awlock   <= To_StdULogicVector(m_axi_awlock( 3*WIDTH_MASTER_AWLOCK - 1 downto  2*WIDTH_MASTER_AWLOCK));
  m3_axi_slice_i.s0_axi_awlock   <= To_StdULogicVector(m_axi_awlock( 4*WIDTH_MASTER_AWLOCK - 1 downto  3*WIDTH_MASTER_AWLOCK));
  m4_axi_slice_i.s0_axi_awlock   <= To_StdULogicVector(m_axi_awlock( 5*WIDTH_MASTER_AWLOCK - 1 downto  4*WIDTH_MASTER_AWLOCK));
  m5_axi_slice_i.s0_axi_awlock   <= To_StdULogicVector(m_axi_awlock( 6*WIDTH_MASTER_AWLOCK - 1 downto  5*WIDTH_MASTER_AWLOCK));
  m6_axi_slice_i.s0_axi_awlock   <= To_StdULogicVector(m_axi_awlock( 7*WIDTH_MASTER_AWLOCK - 1 downto  6*WIDTH_MASTER_AWLOCK));
  m7_axi_slice_i.s0_axi_awlock   <= To_StdULogicVector(m_axi_awlock( 8*WIDTH_MASTER_AWLOCK - 1 downto  7*WIDTH_MASTER_AWLOCK));
  m0_axi3_o.m0_axi_awcache       <= To_StdULogicVector(m_axi_awcache( 1*WIDTH_MASTER_AWCACHE - 1 downto  0*WIDTH_MASTER_AWCACHE));
  m1_axi_slice_i.s0_axi_awcache  <= To_StdULogicVector(m_axi_awcache( 2*WIDTH_MASTER_AWCACHE - 1 downto  1*WIDTH_MASTER_AWCACHE));
  m2_axi_slice_i.s0_axi_awcache  <= To_StdULogicVector(m_axi_awcache( 3*WIDTH_MASTER_AWCACHE - 1 downto  2*WIDTH_MASTER_AWCACHE));
  m3_axi_slice_i.s0_axi_awcache  <= To_StdULogicVector(m_axi_awcache( 4*WIDTH_MASTER_AWCACHE - 1 downto  3*WIDTH_MASTER_AWCACHE));
  m4_axi_slice_i.s0_axi_awcache  <= To_StdULogicVector(m_axi_awcache( 5*WIDTH_MASTER_AWCACHE - 1 downto  4*WIDTH_MASTER_AWCACHE));
  m5_axi_slice_i.s0_axi_awcache  <= To_StdULogicVector(m_axi_awcache( 6*WIDTH_MASTER_AWCACHE - 1 downto  5*WIDTH_MASTER_AWCACHE));
  m6_axi_slice_i.s0_axi_awcache  <= To_StdULogicVector(m_axi_awcache( 7*WIDTH_MASTER_AWCACHE - 1 downto  6*WIDTH_MASTER_AWCACHE));
  m7_axi_slice_i.s0_axi_awcache  <= To_StdULogicVector(m_axi_awcache( 8*WIDTH_MASTER_AWCACHE - 1 downto  7*WIDTH_MASTER_AWCACHE));
  m0_axi3_o.m0_axi_awprot        <= To_StdULogicVector(m_axi_awprot( 1*WIDTH_MASTER_AWPROT - 1 downto  0*WIDTH_MASTER_AWPROT));
  m1_axi_slice_i.s0_axi_awprot   <= To_StdULogicVector(m_axi_awprot( 2*WIDTH_MASTER_AWPROT - 1 downto  1*WIDTH_MASTER_AWPROT));
  m2_axi_slice_i.s0_axi_awprot   <= To_StdULogicVector(m_axi_awprot( 3*WIDTH_MASTER_AWPROT - 1 downto  2*WIDTH_MASTER_AWPROT));
  m3_axi_slice_i.s0_axi_awprot   <= To_StdULogicVector(m_axi_awprot( 4*WIDTH_MASTER_AWPROT - 1 downto  3*WIDTH_MASTER_AWPROT));
  m4_axi_slice_i.s0_axi_awprot   <= To_StdULogicVector(m_axi_awprot( 5*WIDTH_MASTER_AWPROT - 1 downto  4*WIDTH_MASTER_AWPROT));
  m5_axi_slice_i.s0_axi_awprot   <= To_StdULogicVector(m_axi_awprot( 6*WIDTH_MASTER_AWPROT - 1 downto  5*WIDTH_MASTER_AWPROT));
  m6_axi_slice_i.s0_axi_awprot   <= To_StdULogicVector(m_axi_awprot( 7*WIDTH_MASTER_AWPROT - 1 downto  6*WIDTH_MASTER_AWPROT));
  m7_axi_slice_i.s0_axi_awprot   <= To_StdULogicVector(m_axi_awprot( 8*WIDTH_MASTER_AWPROT - 1 downto  7*WIDTH_MASTER_AWPROT));
  m0_axi3_o.m0_axi_awvalid       <= m_axi_awvalid( 0);
  m1_axi_slice_i.s0_axi_awvalid  <= m_axi_awvalid( 1);
  m2_axi_slice_i.s0_axi_awvalid  <= m_axi_awvalid( 2);
  m3_axi_slice_i.s0_axi_awvalid  <= m_axi_awvalid( 3);
  m4_axi_slice_i.s0_axi_awvalid  <= m_axi_awvalid( 4);
  m5_axi_slice_i.s0_axi_awvalid  <= m_axi_awvalid( 5);
  m6_axi_slice_i.s0_axi_awvalid  <= m_axi_awvalid( 6);
  m7_axi_slice_i.s0_axi_awvalid  <= m_axi_awvalid( 7);
  m_axi_awready(0)               <= m0_axi3_i.m0_axi_awready;
  m_axi_awready(1)               <= m1_axi_slice_o.s0_axi_awready;
  m_axi_awready(2)               <= m2_axi_slice_o.s0_axi_awready;
  m_axi_awready(3)               <= m3_axi_slice_o.s0_axi_awready;
  m_axi_awready(4)               <= m4_axi_slice_o.s0_axi_awready;
  m_axi_awready(5)               <= m5_axi_slice_o.s0_axi_awready;
  m_axi_awready(6)               <= m6_axi_slice_o.s0_axi_awready;
  m_axi_awready(7)               <= m7_axi_slice_o.s0_axi_awready;

  m0_axi3_o.m0_axi_wid          <= To_StdULogicVector(m_axi_wid( 1*WIDTH_MASTER_WID - 1 downto  0*WIDTH_MASTER_WID));
  m1_axi_slice_i.s0_axi_wid     <= To_StdULogicVector(m_axi_wid( 2*WIDTH_MASTER_WID - 1 downto  1*WIDTH_MASTER_WID));
  m2_axi_slice_i.s0_axi_wid     <= To_StdULogicVector(m_axi_wid( 3*WIDTH_MASTER_WID - 1 downto  2*WIDTH_MASTER_WID));
  m3_axi_slice_i.s0_axi_wid     <= To_StdULogicVector(m_axi_wid( 4*WIDTH_MASTER_WID - 1 downto  3*WIDTH_MASTER_WID));
  m4_axi_slice_i.s0_axi_wid     <= To_StdULogicVector(m_axi_wid( 5*WIDTH_MASTER_WID - 1 downto  4*WIDTH_MASTER_WID));
  m5_axi_slice_i.s0_axi_wid     <= To_StdULogicVector(m_axi_wid( 6*WIDTH_MASTER_WID - 1 downto  5*WIDTH_MASTER_WID));
  m6_axi_slice_i.s0_axi_wid     <= To_StdULogicVector(m_axi_wid( 7*WIDTH_MASTER_WID - 1 downto  6*WIDTH_MASTER_WID));
  m7_axi_slice_i.s0_axi_wid     <= To_StdULogicVector(m_axi_wid( 8*WIDTH_MASTER_WID - 1 downto  7*WIDTH_MASTER_WID));
  m0_axi3_o.m0_axi_wdata        <= To_StdULogicVector(m_axi_wdata( 1*WIDTH_MASTER_WDATA - 1 downto  0*WIDTH_MASTER_WDATA));
  m1_axi_slice_i.s0_axi_wdata   <= To_StdULogicVector(m_axi_wdata( 2*WIDTH_MASTER_WDATA - 1 downto  1*WIDTH_MASTER_WDATA));
  m2_axi_slice_i.s0_axi_wdata   <= To_StdULogicVector(m_axi_wdata( 3*WIDTH_MASTER_WDATA - 1 downto  2*WIDTH_MASTER_WDATA));
  m3_axi_slice_i.s0_axi_wdata   <= To_StdULogicVector(m_axi_wdata( 4*WIDTH_MASTER_WDATA - 1 downto  3*WIDTH_MASTER_WDATA));
  m4_axi_slice_i.s0_axi_wdata   <= To_StdULogicVector(m_axi_wdata( 5*WIDTH_MASTER_WDATA - 1 downto  4*WIDTH_MASTER_WDATA));
  m5_axi_slice_i.s0_axi_wdata   <= To_StdULogicVector(m_axi_wdata( 6*WIDTH_MASTER_WDATA - 1 downto  5*WIDTH_MASTER_WDATA));
  m6_axi_slice_i.s0_axi_wdata   <= To_StdULogicVector(m_axi_wdata( 7*WIDTH_MASTER_WDATA - 1 downto  6*WIDTH_MASTER_WDATA));
  m7_axi_slice_i.s0_axi_wdata   <= To_StdULogicVector(m_axi_wdata( 8*WIDTH_MASTER_WDATA - 1 downto  7*WIDTH_MASTER_WDATA));
  m0_axi3_o.m0_axi_wstrb        <= To_StdULogicVector(m_axi_wstrb( 1*WIDTH_MASTER_WSTRB - 1 downto  0*WIDTH_MASTER_WSTRB));
  m1_axi_slice_i.s0_axi_wstrb   <= To_StdULogicVector(m_axi_wstrb( 2*WIDTH_MASTER_WSTRB - 1 downto  1*WIDTH_MASTER_WSTRB));
  m2_axi_slice_i.s0_axi_wstrb   <= To_StdULogicVector(m_axi_wstrb( 3*WIDTH_MASTER_WSTRB - 1 downto  2*WIDTH_MASTER_WSTRB));
  m3_axi_slice_i.s0_axi_wstrb   <= To_StdULogicVector(m_axi_wstrb( 4*WIDTH_MASTER_WSTRB - 1 downto  3*WIDTH_MASTER_WSTRB));
  m4_axi_slice_i.s0_axi_wstrb   <= To_StdULogicVector(m_axi_wstrb( 5*WIDTH_MASTER_WSTRB - 1 downto  4*WIDTH_MASTER_WSTRB));
  m5_axi_slice_i.s0_axi_wstrb   <= To_StdULogicVector(m_axi_wstrb( 6*WIDTH_MASTER_WSTRB - 1 downto  5*WIDTH_MASTER_WSTRB));
  m6_axi_slice_i.s0_axi_wstrb   <= To_StdULogicVector(m_axi_wstrb( 7*WIDTH_MASTER_WSTRB - 1 downto  6*WIDTH_MASTER_WSTRB));
  m7_axi_slice_i.s0_axi_wstrb   <= To_StdULogicVector(m_axi_wstrb( 8*WIDTH_MASTER_WSTRB - 1 downto  7*WIDTH_MASTER_WSTRB));
  m0_axi3_o.m0_axi_wlast        <= m_axi_wlast( 0);
  m1_axi_slice_i.s0_axi_wlast   <= m_axi_wlast( 1);
  m2_axi_slice_i.s0_axi_wlast   <= m_axi_wlast( 2);
  m3_axi_slice_i.s0_axi_wlast   <= m_axi_wlast( 3);
  m4_axi_slice_i.s0_axi_wlast   <= m_axi_wlast( 4);
  m5_axi_slice_i.s0_axi_wlast   <= m_axi_wlast( 5);
  m6_axi_slice_i.s0_axi_wlast   <= m_axi_wlast( 6);
  m7_axi_slice_i.s0_axi_wlast   <= m_axi_wlast( 7);
  m0_axi3_o.m0_axi_wvalid       <= m_axi_wvalid(0);
  m1_axi_slice_i.s0_axi_wvalid  <= m_axi_wvalid(1);
  m2_axi_slice_i.s0_axi_wvalid  <= m_axi_wvalid(2);
  m3_axi_slice_i.s0_axi_wvalid  <= m_axi_wvalid(3);
  m4_axi_slice_i.s0_axi_wvalid  <= m_axi_wvalid(4);
  m5_axi_slice_i.s0_axi_wvalid  <= m_axi_wvalid(5);
  m6_axi_slice_i.s0_axi_wvalid  <= m_axi_wvalid(6);
  m7_axi_slice_i.s0_axi_wvalid  <= m_axi_wvalid(7);
  m_axi_wready(0)               <= m0_axi3_i.m0_axi_wready;
  m_axi_wready(1)               <= m1_axi_slice_o.s0_axi_wready;
  m_axi_wready(2)               <= m2_axi_slice_o.s0_axi_wready;
  m_axi_wready(3)               <= m3_axi_slice_o.s0_axi_wready;
  m_axi_wready(4)               <= m4_axi_slice_o.s0_axi_wready;
  m_axi_wready(5)               <= m5_axi_slice_o.s0_axi_wready;
  m_axi_wready(6)               <= m6_axi_slice_o.s0_axi_wready;
  m_axi_wready(7)               <= m7_axi_slice_o.s0_axi_wready;

  m_axi_bid( 1*WIDTH_MASTER_BID - 1 downto  0*WIDTH_MASTER_BID)       <= To_StdLogicVector(m0_axi3_i.m0_axi_bid);
  m_axi_bid( 2*WIDTH_MASTER_BID - 1 downto  1*WIDTH_MASTER_BID)       <= To_StdLogicVector(m1_axi_slice_o.s0_axi_bid);
  m_axi_bid( 3*WIDTH_MASTER_BID - 1 downto  2*WIDTH_MASTER_BID)       <= To_StdLogicVector(m2_axi_slice_o.s0_axi_bid);
  m_axi_bid( 4*WIDTH_MASTER_BID - 1 downto  3*WIDTH_MASTER_BID)       <= To_StdLogicVector(m3_axi_slice_o.s0_axi_bid);
  m_axi_bid( 5*WIDTH_MASTER_BID - 1 downto  4*WIDTH_MASTER_BID)       <= To_StdLogicVector(m4_axi_slice_o.s0_axi_bid);
  m_axi_bid( 6*WIDTH_MASTER_BID - 1 downto  5*WIDTH_MASTER_BID)       <= To_StdLogicVector(m5_axi_slice_o.s0_axi_bid);
  m_axi_bid( 7*WIDTH_MASTER_BID - 1 downto  6*WIDTH_MASTER_BID)       <= To_StdLogicVector(m6_axi_slice_o.s0_axi_bid);
  m_axi_bid( 8*WIDTH_MASTER_BID - 1 downto  7*WIDTH_MASTER_BID)       <= To_StdLogicVector(m7_axi_slice_o.s0_axi_bid);
  m_axi_bresp( 1*WIDTH_MASTER_BRESP - 1 downto  0*WIDTH_MASTER_BRESP) <= To_StdLogicVector(m0_axi3_i.m0_axi_bresp);
  m_axi_bresp( 2*WIDTH_MASTER_BRESP - 1 downto  1*WIDTH_MASTER_BRESP) <= To_StdLogicVector(m1_axi_slice_o.s0_axi_bresp);
  m_axi_bresp( 3*WIDTH_MASTER_BRESP - 1 downto  2*WIDTH_MASTER_BRESP) <= To_StdLogicVector(m2_axi_slice_o.s0_axi_bresp);
  m_axi_bresp( 4*WIDTH_MASTER_BRESP - 1 downto  3*WIDTH_MASTER_BRESP) <= To_StdLogicVector(m3_axi_slice_o.s0_axi_bresp);
  m_axi_bresp( 5*WIDTH_MASTER_BRESP - 1 downto  4*WIDTH_MASTER_BRESP) <= To_StdLogicVector(m4_axi_slice_o.s0_axi_bresp);
  m_axi_bresp( 6*WIDTH_MASTER_BRESP - 1 downto  5*WIDTH_MASTER_BRESP) <= To_StdLogicVector(m5_axi_slice_o.s0_axi_bresp);
  m_axi_bresp( 7*WIDTH_MASTER_BRESP - 1 downto  6*WIDTH_MASTER_BRESP) <= To_StdLogicVector(m6_axi_slice_o.s0_axi_bresp);
  m_axi_bresp( 8*WIDTH_MASTER_BRESP - 1 downto  7*WIDTH_MASTER_BRESP) <= To_StdLogicVector(m7_axi_slice_o.s0_axi_bresp);
  m_axi_bvalid( 0)                                                    <= m0_axi3_i.m0_axi_bvalid;
  m_axi_bvalid( 1)                                                    <= m1_axi_slice_o.s0_axi_bvalid;
  m_axi_bvalid( 2)                                                    <= m2_axi_slice_o.s0_axi_bvalid;
  m_axi_bvalid( 3)                                                    <= m3_axi_slice_o.s0_axi_bvalid;
  m_axi_bvalid( 4)                                                    <= m4_axi_slice_o.s0_axi_bvalid;
  m_axi_bvalid( 5)                                                    <= m5_axi_slice_o.s0_axi_bvalid;
  m_axi_bvalid( 6)                                                    <= m6_axi_slice_o.s0_axi_bvalid;
  m_axi_bvalid( 7)                                                    <= m7_axi_slice_o.s0_axi_bvalid;
  m0_axi3_o.m0_axi_bready                                             <= m_axi_bready( 0);
  m1_axi_slice_i.s0_axi_bready                                        <= m_axi_bready( 1);
  m2_axi_slice_i.s0_axi_bready                                        <= m_axi_bready( 2);
  m3_axi_slice_i.s0_axi_bready                                        <= m_axi_bready( 3);
  m4_axi_slice_i.s0_axi_bready                                        <= m_axi_bready( 4);
  m5_axi_slice_i.s0_axi_bready                                        <= m_axi_bready( 5);
  m6_axi_slice_i.s0_axi_bready                                        <= m_axi_bready( 6);
  m7_axi_slice_i.s0_axi_bready                                        <= m_axi_bready( 7);

  m0_axi3_o.m0_axi_arid          <= To_StdULogicVector(m_axi_arid( 1*WIDTH_MASTER_ARID - 1 downto  0*WIDTH_MASTER_ARID));
  m1_axi_slice_i.s0_axi_arid     <= To_StdULogicVector(m_axi_arid( 2*WIDTH_MASTER_ARID - 1 downto  1*WIDTH_MASTER_ARID));
  m2_axi_slice_i.s0_axi_arid     <= To_StdULogicVector(m_axi_arid( 3*WIDTH_MASTER_ARID - 1 downto  2*WIDTH_MASTER_ARID));
  m3_axi_slice_i.s0_axi_arid     <= To_StdULogicVector(m_axi_arid( 4*WIDTH_MASTER_ARID - 1 downto  3*WIDTH_MASTER_ARID));
  m4_axi_slice_i.s0_axi_arid     <= To_StdULogicVector(m_axi_arid( 5*WIDTH_MASTER_ARID - 1 downto  4*WIDTH_MASTER_ARID));
  m5_axi_slice_i.s0_axi_arid     <= To_StdULogicVector(m_axi_arid( 6*WIDTH_MASTER_ARID - 1 downto  5*WIDTH_MASTER_ARID));
  m6_axi_slice_i.s0_axi_arid     <= To_StdULogicVector(m_axi_arid( 7*WIDTH_MASTER_ARID - 1 downto  6*WIDTH_MASTER_ARID));
  m7_axi_slice_i.s0_axi_arid     <= To_StdULogicVector(m_axi_arid( 8*WIDTH_MASTER_ARID - 1 downto  7*WIDTH_MASTER_ARID));
  m0_axi3_o.m0_axi_araddr        <= To_StdULogicVector(m_axi_araddr( 1*WIDTH_MASTER_ARADDR - 1 downto  0*WIDTH_MASTER_ARADDR));
  m1_axi_slice_i.s0_axi_araddr   <= To_StdULogicVector(m_axi_araddr( 2*WIDTH_MASTER_ARADDR - 1 downto  1*WIDTH_MASTER_ARADDR));
  m2_axi_slice_i.s0_axi_araddr   <= To_StdULogicVector(m_axi_araddr( 3*WIDTH_MASTER_ARADDR - 1 downto  2*WIDTH_MASTER_ARADDR));
  m3_axi_slice_i.s0_axi_araddr   <= To_StdULogicVector(m_axi_araddr( 4*WIDTH_MASTER_ARADDR - 1 downto  3*WIDTH_MASTER_ARADDR));
  m4_axi_slice_i.s0_axi_araddr   <= To_StdULogicVector(m_axi_araddr( 5*WIDTH_MASTER_ARADDR - 1 downto  4*WIDTH_MASTER_ARADDR));
  m5_axi_slice_i.s0_axi_araddr   <= To_StdULogicVector(m_axi_araddr( 6*WIDTH_MASTER_ARADDR - 1 downto  5*WIDTH_MASTER_ARADDR));
  m6_axi_slice_i.s0_axi_araddr   <= To_StdULogicVector(m_axi_araddr( 7*WIDTH_MASTER_ARADDR - 1 downto  6*WIDTH_MASTER_ARADDR));
  m7_axi_slice_i.s0_axi_araddr   <= To_StdULogicVector(m_axi_araddr( 8*WIDTH_MASTER_ARADDR - 1 downto  7*WIDTH_MASTER_ARADDR));
  m0_axi3_o.m0_axi_arlen         <= To_StdULogicVector(m_axi_arlen( 1*WIDTH_MASTER_ARLEN - 1 downto  0*WIDTH_MASTER_ARLEN));
  m1_axi_slice_i.s0_axi_arlen    <= To_StdULogicVector(m_axi_arlen( 2*WIDTH_MASTER_ARLEN - 1 downto  1*WIDTH_MASTER_ARLEN));
  m2_axi_slice_i.s0_axi_arlen    <= To_StdULogicVector(m_axi_arlen( 3*WIDTH_MASTER_ARLEN - 1 downto  2*WIDTH_MASTER_ARLEN));
  m3_axi_slice_i.s0_axi_arlen    <= To_StdULogicVector(m_axi_arlen( 4*WIDTH_MASTER_ARLEN - 1 downto  3*WIDTH_MASTER_ARLEN));
  m4_axi_slice_i.s0_axi_arlen    <= To_StdULogicVector(m_axi_arlen( 5*WIDTH_MASTER_ARLEN - 1 downto  4*WIDTH_MASTER_ARLEN));
  m5_axi_slice_i.s0_axi_arlen    <= To_StdULogicVector(m_axi_arlen( 6*WIDTH_MASTER_ARLEN - 1 downto  5*WIDTH_MASTER_ARLEN));
  m6_axi_slice_i.s0_axi_arlen    <= To_StdULogicVector(m_axi_arlen( 7*WIDTH_MASTER_ARLEN - 1 downto  6*WIDTH_MASTER_ARLEN));
  m7_axi_slice_i.s0_axi_arlen    <= To_StdULogicVector(m_axi_arlen( 8*WIDTH_MASTER_ARLEN - 1 downto  7*WIDTH_MASTER_ARLEN));
  m0_axi3_o.m0_axi_arsize        <= To_StdULogicVector(m_axi_arsize( 1*WIDTH_MASTER_ARSIZE - 1 downto  0*WIDTH_MASTER_ARSIZE));
  m1_axi_slice_i.s0_axi_arsize   <= To_StdULogicVector(m_axi_arsize( 2*WIDTH_MASTER_ARSIZE - 1 downto  1*WIDTH_MASTER_ARSIZE));
  m2_axi_slice_i.s0_axi_arsize   <= To_StdULogicVector(m_axi_arsize( 3*WIDTH_MASTER_ARSIZE - 1 downto  2*WIDTH_MASTER_ARSIZE));
  m3_axi_slice_i.s0_axi_arsize   <= To_StdULogicVector(m_axi_arsize( 4*WIDTH_MASTER_ARSIZE - 1 downto  3*WIDTH_MASTER_ARSIZE));
  m4_axi_slice_i.s0_axi_arsize   <= To_StdULogicVector(m_axi_arsize( 5*WIDTH_MASTER_ARSIZE - 1 downto  4*WIDTH_MASTER_ARSIZE));
  m5_axi_slice_i.s0_axi_arsize   <= To_StdULogicVector(m_axi_arsize( 6*WIDTH_MASTER_ARSIZE - 1 downto  5*WIDTH_MASTER_ARSIZE));
  m6_axi_slice_i.s0_axi_arsize   <= To_StdULogicVector(m_axi_arsize( 7*WIDTH_MASTER_ARSIZE - 1 downto  6*WIDTH_MASTER_ARSIZE));
  m7_axi_slice_i.s0_axi_arsize   <= To_StdULogicVector(m_axi_arsize( 8*WIDTH_MASTER_ARSIZE - 1 downto  7*WIDTH_MASTER_ARSIZE));
  m0_axi3_o.m0_axi_arburst       <= To_StdULogicVector(m_axi_arburst( 1*WIDTH_MASTER_ARBURST - 1 downto  0*WIDTH_MASTER_ARBURST));
  m1_axi_slice_i.s0_axi_arburst  <= To_StdULogicVector(m_axi_arburst( 2*WIDTH_MASTER_ARBURST - 1 downto  1*WIDTH_MASTER_ARBURST));
  m2_axi_slice_i.s0_axi_arburst  <= To_StdULogicVector(m_axi_arburst( 3*WIDTH_MASTER_ARBURST - 1 downto  2*WIDTH_MASTER_ARBURST));
  m3_axi_slice_i.s0_axi_arburst  <= To_StdULogicVector(m_axi_arburst( 4*WIDTH_MASTER_ARBURST - 1 downto  3*WIDTH_MASTER_ARBURST));
  m4_axi_slice_i.s0_axi_arburst  <= To_StdULogicVector(m_axi_arburst( 5*WIDTH_MASTER_ARBURST - 1 downto  4*WIDTH_MASTER_ARBURST));
  m5_axi_slice_i.s0_axi_arburst  <= To_StdULogicVector(m_axi_arburst( 6*WIDTH_MASTER_ARBURST - 1 downto  5*WIDTH_MASTER_ARBURST));
  m6_axi_slice_i.s0_axi_arburst  <= To_StdULogicVector(m_axi_arburst( 7*WIDTH_MASTER_ARBURST - 1 downto  6*WIDTH_MASTER_ARBURST));
  m7_axi_slice_i.s0_axi_arburst  <= To_StdULogicVector(m_axi_arburst( 8*WIDTH_MASTER_ARBURST - 1 downto  7*WIDTH_MASTER_ARBURST));
  m0_axi3_o.m0_axi_arlock        <= To_StdULogicVector(m_axi_arlock( 1*WIDTH_MASTER_ARLOCK - 1 downto  0*WIDTH_MASTER_ARLOCK));
  m1_axi_slice_i.s0_axi_arlock   <= To_StdULogicVector(m_axi_arlock( 2*WIDTH_MASTER_ARLOCK - 1 downto  1*WIDTH_MASTER_ARLOCK));
  m2_axi_slice_i.s0_axi_arlock   <= To_StdULogicVector(m_axi_arlock( 3*WIDTH_MASTER_ARLOCK - 1 downto  2*WIDTH_MASTER_ARLOCK));
  m3_axi_slice_i.s0_axi_arlock   <= To_StdULogicVector(m_axi_arlock( 4*WIDTH_MASTER_ARLOCK - 1 downto  3*WIDTH_MASTER_ARLOCK));
  m4_axi_slice_i.s0_axi_arlock   <= To_StdULogicVector(m_axi_arlock( 5*WIDTH_MASTER_ARLOCK - 1 downto  4*WIDTH_MASTER_ARLOCK));
  m5_axi_slice_i.s0_axi_arlock   <= To_StdULogicVector(m_axi_arlock( 6*WIDTH_MASTER_ARLOCK - 1 downto  5*WIDTH_MASTER_ARLOCK));
  m6_axi_slice_i.s0_axi_arlock   <= To_StdULogicVector(m_axi_arlock( 7*WIDTH_MASTER_ARLOCK - 1 downto  6*WIDTH_MASTER_ARLOCK));
  m7_axi_slice_i.s0_axi_arlock   <= To_StdULogicVector(m_axi_arlock( 8*WIDTH_MASTER_ARLOCK - 1 downto  7*WIDTH_MASTER_ARLOCK));
  m0_axi3_o.m0_axi_arcache       <= To_StdULogicVector(m_axi_arcache( 1*WIDTH_MASTER_ARCACHE - 1 downto  0*WIDTH_MASTER_ARCACHE));
  m1_axi_slice_i.s0_axi_arcache  <= To_StdULogicVector(m_axi_arcache( 2*WIDTH_MASTER_ARCACHE - 1 downto  1*WIDTH_MASTER_ARCACHE));
  m2_axi_slice_i.s0_axi_arcache  <= To_StdULogicVector(m_axi_arcache( 3*WIDTH_MASTER_ARCACHE - 1 downto  2*WIDTH_MASTER_ARCACHE));
  m3_axi_slice_i.s0_axi_arcache  <= To_StdULogicVector(m_axi_arcache( 4*WIDTH_MASTER_ARCACHE - 1 downto  3*WIDTH_MASTER_ARCACHE));
  m4_axi_slice_i.s0_axi_arcache  <= To_StdULogicVector(m_axi_arcache( 5*WIDTH_MASTER_ARCACHE - 1 downto  4*WIDTH_MASTER_ARCACHE));
  m5_axi_slice_i.s0_axi_arcache  <= To_StdULogicVector(m_axi_arcache( 6*WIDTH_MASTER_ARCACHE - 1 downto  5*WIDTH_MASTER_ARCACHE));
  m6_axi_slice_i.s0_axi_arcache  <= To_StdULogicVector(m_axi_arcache( 7*WIDTH_MASTER_ARCACHE - 1 downto  6*WIDTH_MASTER_ARCACHE));
  m7_axi_slice_i.s0_axi_arcache  <= To_StdULogicVector(m_axi_arcache( 8*WIDTH_MASTER_ARCACHE - 1 downto  7*WIDTH_MASTER_ARCACHE));
  m0_axi3_o.m0_axi_arprot        <= To_StdULogicVector(m_axi_arprot( 1*WIDTH_MASTER_ARPROT - 1 downto  0*WIDTH_MASTER_ARPROT));
  m1_axi_slice_i.s0_axi_arprot   <= To_StdULogicVector(m_axi_arprot( 2*WIDTH_MASTER_ARPROT - 1 downto  1*WIDTH_MASTER_ARPROT));
  m2_axi_slice_i.s0_axi_arprot   <= To_StdULogicVector(m_axi_arprot( 3*WIDTH_MASTER_ARPROT - 1 downto  2*WIDTH_MASTER_ARPROT));
  m3_axi_slice_i.s0_axi_arprot   <= To_StdULogicVector(m_axi_arprot( 4*WIDTH_MASTER_ARPROT - 1 downto  3*WIDTH_MASTER_ARPROT));
  m4_axi_slice_i.s0_axi_arprot   <= To_StdULogicVector(m_axi_arprot( 5*WIDTH_MASTER_ARPROT - 1 downto  4*WIDTH_MASTER_ARPROT));
  m5_axi_slice_i.s0_axi_arprot   <= To_StdULogicVector(m_axi_arprot( 6*WIDTH_MASTER_ARPROT - 1 downto  5*WIDTH_MASTER_ARPROT));
  m6_axi_slice_i.s0_axi_arprot   <= To_StdULogicVector(m_axi_arprot( 7*WIDTH_MASTER_ARPROT - 1 downto  6*WIDTH_MASTER_ARPROT));
  m7_axi_slice_i.s0_axi_arprot   <= To_StdULogicVector(m_axi_arprot( 8*WIDTH_MASTER_ARPROT - 1 downto  7*WIDTH_MASTER_ARPROT));
  m0_axi3_o.m0_axi_arvalid       <= m_axi_arvalid( 0);
  m1_axi_slice_i.s0_axi_arvalid  <= m_axi_arvalid( 1);
  m2_axi_slice_i.s0_axi_arvalid  <= m_axi_arvalid( 2);
  m3_axi_slice_i.s0_axi_arvalid  <= m_axi_arvalid( 3);
  m4_axi_slice_i.s0_axi_arvalid  <= m_axi_arvalid( 4);
  m5_axi_slice_i.s0_axi_arvalid  <= m_axi_arvalid( 5);
  m6_axi_slice_i.s0_axi_arvalid  <= m_axi_arvalid( 6);
  m7_axi_slice_i.s0_axi_arvalid  <= m_axi_arvalid( 7);
  m_axi_arready(0)               <= m0_axi3_i.m0_axi_arready;
  m_axi_arready(1)               <= m1_axi_slice_o.s0_axi_arready;
  m_axi_arready(2)               <= m2_axi_slice_o.s0_axi_arready;
  m_axi_arready(3)               <= m3_axi_slice_o.s0_axi_arready;
  m_axi_arready(4)               <= m4_axi_slice_o.s0_axi_arready;
  m_axi_arready(5)               <= m5_axi_slice_o.s0_axi_arready;
  m_axi_arready(6)               <= m6_axi_slice_o.s0_axi_arready;
  m_axi_arready(7)               <= m7_axi_slice_o.s0_axi_arready;

  m_axi_rid( 1*WIDTH_MASTER_RID - 1 downto  0*WIDTH_MASTER_RID)       <= To_StdLogicVector(m0_axi3_i.m0_axi_rid);
  m_axi_rid( 2*WIDTH_MASTER_RID - 1 downto  1*WIDTH_MASTER_RID)       <= To_StdLogicVector(m1_axi_slice_o.s0_axi_rid);
  m_axi_rid( 3*WIDTH_MASTER_RID - 1 downto  2*WIDTH_MASTER_RID)       <= To_StdLogicVector(m2_axi_slice_o.s0_axi_rid);
  m_axi_rid( 4*WIDTH_MASTER_RID - 1 downto  3*WIDTH_MASTER_RID)       <= To_StdLogicVector(m3_axi_slice_o.s0_axi_rid);
  m_axi_rid( 5*WIDTH_MASTER_RID - 1 downto  4*WIDTH_MASTER_RID)       <= To_StdLogicVector(m4_axi_slice_o.s0_axi_rid);
  m_axi_rid( 6*WIDTH_MASTER_RID - 1 downto  5*WIDTH_MASTER_RID)       <= To_StdLogicVector(m5_axi_slice_o.s0_axi_rid);
  m_axi_rid( 7*WIDTH_MASTER_RID - 1 downto  6*WIDTH_MASTER_RID)       <= To_StdLogicVector(m6_axi_slice_o.s0_axi_rid);
  m_axi_rid( 8*WIDTH_MASTER_RID - 1 downto  7*WIDTH_MASTER_RID)       <= To_StdLogicVector(m7_axi_slice_o.s0_axi_rid);
  m_axi_rdata( 1*WIDTH_MASTER_RDATA - 1 downto  0*WIDTH_MASTER_RDATA) <= To_StdLogicVector(m0_axi3_i.m0_axi_rdata);
  m_axi_rdata( 2*WIDTH_MASTER_RDATA - 1 downto  1*WIDTH_MASTER_RDATA) <= To_StdLogicVector(m1_axi_slice_o.s0_axi_rdata);
  m_axi_rdata( 3*WIDTH_MASTER_RDATA - 1 downto  2*WIDTH_MASTER_RDATA) <= To_StdLogicVector(m2_axi_slice_o.s0_axi_rdata);
  m_axi_rdata( 4*WIDTH_MASTER_RDATA - 1 downto  3*WIDTH_MASTER_RDATA) <= To_StdLogicVector(m3_axi_slice_o.s0_axi_rdata);
  m_axi_rdata( 5*WIDTH_MASTER_RDATA - 1 downto  4*WIDTH_MASTER_RDATA) <= To_StdLogicVector(m4_axi_slice_o.s0_axi_rdata);
  m_axi_rdata( 6*WIDTH_MASTER_RDATA - 1 downto  5*WIDTH_MASTER_RDATA) <= To_StdLogicVector(m5_axi_slice_o.s0_axi_rdata);
  m_axi_rdata( 7*WIDTH_MASTER_RDATA - 1 downto  6*WIDTH_MASTER_RDATA) <= To_StdLogicVector(m6_axi_slice_o.s0_axi_rdata);
  m_axi_rdata( 8*WIDTH_MASTER_RDATA - 1 downto  7*WIDTH_MASTER_RDATA) <= To_StdLogicVector(m7_axi_slice_o.s0_axi_rdata);
  m_axi_rresp( 1*WIDTH_MASTER_RRESP - 1 downto  0*WIDTH_MASTER_RRESP) <= To_StdLogicVector(m0_axi3_i.m0_axi_rresp);
  m_axi_rresp( 2*WIDTH_MASTER_RRESP - 1 downto  1*WIDTH_MASTER_RRESP) <= To_StdLogicVector(m1_axi_slice_o.s0_axi_rresp);
  m_axi_rresp( 3*WIDTH_MASTER_RRESP - 1 downto  2*WIDTH_MASTER_RRESP) <= To_StdLogicVector(m2_axi_slice_o.s0_axi_rresp);
  m_axi_rresp( 4*WIDTH_MASTER_RRESP - 1 downto  3*WIDTH_MASTER_RRESP) <= To_StdLogicVector(m3_axi_slice_o.s0_axi_rresp);
  m_axi_rresp( 5*WIDTH_MASTER_RRESP - 1 downto  4*WIDTH_MASTER_RRESP) <= To_StdLogicVector(m4_axi_slice_o.s0_axi_rresp);
  m_axi_rresp( 6*WIDTH_MASTER_RRESP - 1 downto  5*WIDTH_MASTER_RRESP) <= To_StdLogicVector(m5_axi_slice_o.s0_axi_rresp);
  m_axi_rresp( 7*WIDTH_MASTER_RRESP - 1 downto  6*WIDTH_MASTER_RRESP) <= To_StdLogicVector(m6_axi_slice_o.s0_axi_rresp);
  m_axi_rresp( 8*WIDTH_MASTER_RRESP - 1 downto  7*WIDTH_MASTER_RRESP) <= To_StdLogicVector(m7_axi_slice_o.s0_axi_rresp);
  m_axi_rlast( 0)                                                     <= m0_axi3_i.m0_axi_rlast;
  m_axi_rlast( 1)                                                     <= m1_axi_slice_o.s0_axi_rlast;
  m_axi_rlast( 2)                                                     <= m2_axi_slice_o.s0_axi_rlast;
  m_axi_rlast( 3)                                                     <= m3_axi_slice_o.s0_axi_rlast;
  m_axi_rlast( 4)                                                     <= m4_axi_slice_o.s0_axi_rlast;
  m_axi_rlast( 5)                                                     <= m5_axi_slice_o.s0_axi_rlast;
  m_axi_rlast( 6)                                                     <= m6_axi_slice_o.s0_axi_rlast;
  m_axi_rlast( 7)                                                     <= m7_axi_slice_o.s0_axi_rlast;
  m_axi_rvalid(0)                                                     <= m0_axi3_i.m0_axi_rvalid;
  m_axi_rvalid(1)                                                     <= m1_axi_slice_o.s0_axi_rvalid;
  m_axi_rvalid(2)                                                     <= m2_axi_slice_o.s0_axi_rvalid;
  m_axi_rvalid(3)                                                     <= m3_axi_slice_o.s0_axi_rvalid;
  m_axi_rvalid(4)                                                     <= m4_axi_slice_o.s0_axi_rvalid;
  m_axi_rvalid(5)                                                     <= m5_axi_slice_o.s0_axi_rvalid;
  m_axi_rvalid(6)                                                     <= m6_axi_slice_o.s0_axi_rvalid;
  m_axi_rvalid(7)                                                     <= m7_axi_slice_o.s0_axi_rvalid;
  m0_axi3_o.m0_axi_rready                                             <= m_axi_rready( 0);
  m1_axi_slice_i.s0_axi_rready                                        <= m_axi_rready( 1);
  m2_axi_slice_i.s0_axi_rready                                        <= m_axi_rready( 2);
  m3_axi_slice_i.s0_axi_rready                                        <= m_axi_rready( 3);
  m4_axi_slice_i.s0_axi_rready                                        <= m_axi_rready( 4);
  m5_axi_slice_i.s0_axi_rready                                        <= m_axi_rready( 5);
  m6_axi_slice_i.s0_axi_rready                                        <= m_axi_rready( 6);
  m7_axi_slice_i.s0_axi_rready                                        <= m_axi_rready( 7);

  -- AXI4/AXI3 Conversion
  -- JTAG drives AXI4, so convert it here.
  s0_axi4_i                <= s0_axi_i;
  s0_axi_o                 <= s0_axi4_o;
  -- We can't convert types on the RHS of an output, so do so here.
  s0_axi4_o.s0_axi_bid     <= To_StdULogicVector(s0_axi4_bid_int);
  s0_axi4_o.s0_axi_bresp   <= To_StdULogicVector(s0_axi4_bresp_int);
  s0_axi4_o.s0_axi_rid     <= To_StdULogicVector(s0_axi4_rid_int);
  s0_axi4_o.s0_axi_rdata   <= To_StdULogicVector(s0_axi4_rdata_int);
  s0_axi4_o.s0_axi_rresp   <= To_StdULogicVector(s0_axi4_rresp_int);
  s0_axi3_i.s0_axi_awid    <= "000000" & To_StdULogicVector(s0_axi3_awid_int);
  s0_axi3_i.s0_axi_awaddr  <= To_StdULogicVector(s0_axi3_awaddr_int);
  s0_axi3_i.s0_axi_awlen   <= To_StdULogicVector(s0_axi3_awlen_int);
  s0_axi3_i.s0_axi_awsize  <= To_StdULogicVector(s0_axi3_awsize_int);
  s0_axi3_i.s0_axi_awburst <= To_StdULogicVector(s0_axi3_awburst_int);
  s0_axi3_i.s0_axi_awlock  <= To_StdULogicVector(s0_axi3_awlock_int);
  s0_axi3_i.s0_axi_awcache <= To_StdULogicVector(s0_axi3_awcache_int);
  s0_axi3_i.s0_axi_awprot  <= To_StdULogicVector(s0_axi3_awprot_int);
  s0_axi3_i.s0_axi_wid     <= "000000" & To_StdULogicVector(s0_axi3_wid_int);
  s0_axi3_i.s0_axi_wdata   <= To_StdULogicVector(s0_axi3_wdata_int);
  s0_axi3_i.s0_axi_wstrb   <= To_StdULogicVector(s0_axi3_wstrb_int);
  bid_tmp                  <= s0_axi3_o.s0_axi_bid; -- Vivado can't seem to figure out how to do this in one step
  s0_axi3_bid_int          <= (0 => bid_tmp(0));
  s0_axi3_i.s0_axi_arid    <= "000000" & To_StdULogicVector(s0_axi3_arid_int);
  s0_axi3_i.s0_axi_araddr  <= To_StdULogicVector(s0_axi3_araddr_int);
  s0_axi3_i.s0_axi_arlen   <= To_StdULogicVector(s0_axi3_arlen_int);
  s0_axi3_i.s0_axi_arsize  <= To_StdULogicVector(s0_axi3_arsize_int);
  s0_axi3_i.s0_axi_arburst <= To_StdULogicVector(s0_axi3_arburst_int);
  s0_axi3_i.s0_axi_arlock  <= To_StdULogicVector(s0_axi3_arlock_int);
  s0_axi3_i.s0_axi_arcache <= To_StdULogicVector(s0_axi3_arcache_int);
  s0_axi3_i.s0_axi_arprot  <= To_StdULogicVector(s0_axi3_arprot_int);
  rid_tmp                  <= s0_axi3_o.s0_axi_rid; -- Vivado can't seem to figure out how to do this in one step
  s0_axi3_rid_int          <= (0 => rid_tmp(0));

  -- AXI3/AXI4-Lite Conversion
  -- One output drives the AXI4-Lite interconnect, so convert it here.
  m0_axi4lite_i                <= m0_axi_i;
  m0_axi_o                     <= m0_axi4lite_o;
  -- We can't convert types on the RHS of an output, so do so here.
  m0_axi3_i.m0_axi_bid         <= To_StdULogicVector(m0_axi3_bid_int);
  m0_axi3_i.m0_axi_bresp       <= To_StdULogicVector(m0_axi3_bresp_int);
  m0_axi3_i.m0_axi_rid         <= To_StdULogicVector(m0_axi3_rid_int);
  m0_axi3_i.m0_axi_rdata       <= To_StdULogicVector(m0_axi3_rdata_int);
  m0_axi3_i.m0_axi_rresp       <= To_StdULogicVector(m0_axi3_rresp_int);
  m0_axi4lite_o.m0_axi_aresetn <= aresetn;
  m0_axi4lite_o.m0_axi_awaddr  <= To_StdULogicVector(m0_axi4lite_awaddr_int);
  m0_axi4lite_o.m0_axi_awprot  <= To_StdULogicVector(m0_axi4lite_awprot_int);
  m0_axi4lite_o.m0_axi_wdata   <= To_StdULogicVector(m0_axi4lite_wdata_int);
  m0_axi4lite_o.m0_axi_wstrb   <= To_StdULogicVector(m0_axi4lite_wstrb_int);
  m0_axi4lite_o.m0_axi_araddr  <= To_StdULogicVector(m0_axi4lite_araddr_int);
  m0_axi4lite_o.m0_axi_arprot  <= To_StdULogicVector(m0_axi4lite_arprot_int);

  -- AXI3 32/64-bit Conversion
  -- I2C Control drives a 64-bit AXI data bus, convert to 32-bit.
  s1_axi_64_i <= s1_axi_i;
  s1_axi_o    <= s1_axi_64_o;
  s1_axi_32_i <= axi3_master_slave_connect(m1_axi_32_o);
  m1_axi_32_i <= axi3_master_slave_connect(s1_axi_32_o);

  axi4_axi3_protocol_converter : axi4_axi3_protocol_converter_0
    PORT MAP (
      aclk           => aclk,
      aresetn        => aresetn,
      s_axi_awid     => To_StdLogicVector(s0_axi4_i.s0_axi_awid),
      s_axi_awaddr   => To_StdLogicVector(s0_axi4_i.s0_axi_awaddr),
      s_axi_awlen    => To_StdLogicVector(s0_axi4_i.s0_axi_awlen),
      s_axi_awsize   => To_StdLogicVector(s0_axi4_i.s0_axi_awsize),
      s_axi_awburst  => To_StdLogicVector(s0_axi4_i.s0_axi_awburst),
      s_axi_awlock   => To_StdLogicVector(s0_axi4_i.s0_axi_awlock),
      s_axi_awcache  => To_StdLogicVector(s0_axi4_i.s0_axi_awcache),
      s_axi_awprot   => To_StdLogicVector(s0_axi4_i.s0_axi_awprot),
      s_axi_awregion => To_StdLogicVector(s0_axi4_i.s0_axi_awregion),
      s_axi_awqos    => "0000",
      s_axi_awvalid  => s0_axi4_i.s0_axi_awvalid,
      s_axi_awready  => s0_axi4_o.s0_axi_awready,
      s_axi_wdata    => To_StdLogicVector(s0_axi4_i.s0_axi_wdata),
      s_axi_wstrb    => To_StdLogicVector(s0_axi4_i.s0_axi_wstrb),
      s_axi_wlast    => s0_axi4_i.s0_axi_wlast,
      s_axi_wvalid   => s0_axi4_i.s0_axi_wvalid,
      s_axi_wready   => s0_axi4_o.s0_axi_wready,
      s_axi_bid      => s0_axi4_bid_int,
      s_axi_bresp    => s0_axi4_bresp_int,
      s_axi_bvalid   => s0_axi4_o.s0_axi_bvalid,
      s_axi_bready   => s0_axi4_i.s0_axi_bready,
      s_axi_arid     => To_StdLogicVector(s0_axi4_i.s0_axi_arid),
      s_axi_araddr   => To_StdLogicVector(s0_axi4_i.s0_axi_araddr),
      s_axi_arlen    => To_StdLogicVector(s0_axi4_i.s0_axi_arlen),
      s_axi_arsize   => To_StdLogicVector(s0_axi4_i.s0_axi_arsize),
      s_axi_arburst  => To_StdLogicVector(s0_axi4_i.s0_axi_arburst),
      s_axi_arlock   => To_StdLogicVector(s0_axi4_i.s0_axi_arlock),
      s_axi_arcache  => To_StdLogicVector(s0_axi4_i.s0_axi_arcache),
      s_axi_arprot   => To_StdLogicVector(s0_axi4_i.s0_axi_arprot),
      s_axi_arregion => To_StdLogicVector(s0_axi4_i.s0_axi_arregion),
      s_axi_arqos    => "0000",
      s_axi_arvalid  => s0_axi4_i.s0_axi_arvalid,
      s_axi_arready  => s0_axi4_o.s0_axi_arready,
      s_axi_rid      => s0_axi4_rid_int,
      s_axi_rdata    => s0_axi4_rdata_int,
      s_axi_rresp    => s0_axi4_rresp_int,
      s_axi_rlast    => s0_axi4_o.s0_axi_rlast,
      s_axi_rvalid   => s0_axi4_o.s0_axi_rvalid,
      s_axi_rready   => s0_axi4_i.s0_axi_rready,
      m_axi_awid     => s0_axi3_awid_int,
      m_axi_awaddr   => s0_axi3_awaddr_int,
      m_axi_awlen    => s0_axi3_awlen_int,
      m_axi_awsize   => s0_axi3_awsize_int,
      m_axi_awburst  => s0_axi3_awburst_int,
      m_axi_awlock   => s0_axi3_awlock_int,
      m_axi_awcache  => s0_axi3_awcache_int,
      m_axi_awprot   => s0_axi3_awprot_int,
      m_axi_awqos    => open,
      m_axi_awvalid  => s0_axi3_i.s0_axi_awvalid,
      m_axi_awready  => s0_axi3_o.s0_axi_awready,
      m_axi_wid      => s0_axi3_wid_int,
      m_axi_wdata    => s0_axi3_wdata_int,
      m_axi_wstrb    => s0_axi3_wstrb_int,
      m_axi_wlast    => s0_axi3_i.s0_axi_wlast,
      m_axi_wvalid   => s0_axi3_i.s0_axi_wvalid,
      m_axi_wready   => s0_axi3_o.s0_axi_wready,
      m_axi_bid      => s0_axi3_bid_int,
      m_axi_bresp    => To_StdLogicVector(s0_axi3_o.s0_axi_bresp),
      m_axi_bvalid   => s0_axi3_o.s0_axi_bvalid,
      m_axi_bready   => s0_axi3_i.s0_axi_bready,
      m_axi_arid     => s0_axi3_arid_int,
      m_axi_araddr   => s0_axi3_araddr_int,
      m_axi_arlen    => s0_axi3_arlen_int,
      m_axi_arsize   => s0_axi3_arsize_int,
      m_axi_arburst  => s0_axi3_arburst_int,
      m_axi_arlock   => s0_axi3_arlock_int,
      m_axi_arcache  => s0_axi3_arcache_int,
      m_axi_arprot   => s0_axi3_arprot_int,
      m_axi_arqos    => open,
      m_axi_arvalid  => s0_axi3_i.s0_axi_arvalid,
      m_axi_arready  => s0_axi3_o.s0_axi_arready,
      m_axi_rid      => s0_axi3_rid_int,
      m_axi_rdata    => To_StdLogicVector(s0_axi3_o.s0_axi_rdata),
      m_axi_rresp    => To_StdLogicVector(s0_axi3_o.s0_axi_rresp),
      m_axi_rlast    => s0_axi3_o.s0_axi_rlast,
      m_axi_rvalid   => s0_axi3_o.s0_axi_rvalid,
      m_axi_rready   => s0_axi3_i.s0_axi_rready
      );

  axi3_axi4lite_protocol_converter : axi3_axi4lite_protocol_converter_0
    PORT MAP (
      aclk          => aclk,
      aresetn       => aresetn,
      s_axi_awid    => To_StdLogicVector(m0_axi3_o.m0_axi_awid),
      s_axi_awaddr  => To_StdLogicVector(m0_axi3_o.m0_axi_awaddr),
      s_axi_awlen   => To_StdLogicVector(m0_axi3_o.m0_axi_awlen),
      s_axi_awsize  => To_StdLogicVector(m0_axi3_o.m0_axi_awsize),
      s_axi_awburst => To_StdLogicVector(m0_axi3_o.m0_axi_awburst),
      s_axi_awlock  => To_StdLogicVector(m0_axi3_o.m0_axi_awlock),
      s_axi_awcache => To_StdLogicVector(m0_axi3_o.m0_axi_awcache),
      s_axi_awprot  => To_StdLogicVector(m0_axi3_o.m0_axi_awprot),
      s_axi_awqos   => "0000",
      s_axi_awvalid => m0_axi3_o.m0_axi_awvalid,
      s_axi_awready => m0_axi3_i.m0_axi_awready,
      s_axi_wid     => To_StdLogicVector(m0_axi3_o.m0_axi_wid),
      s_axi_wdata   => To_StdLogicVector(m0_axi3_o.m0_axi_wdata),
      s_axi_wstrb   => To_StdLogicVector(m0_axi3_o.m0_axi_wstrb),
      s_axi_wlast   => m0_axi3_o.m0_axi_wlast,
      s_axi_wvalid  => m0_axi3_o.m0_axi_wvalid,
      s_axi_wready  => m0_axi3_i.m0_axi_wready,
      s_axi_bid     => m0_axi3_bid_int,
      s_axi_bresp   => m0_axi3_bresp_int,
      s_axi_bvalid  => m0_axi3_i.m0_axi_bvalid,
      s_axi_bready  => m0_axi3_o.m0_axi_bready,
      s_axi_arid    => To_StdLogicVector(m0_axi3_o.m0_axi_arid),
      s_axi_araddr  => To_StdLogicVector(m0_axi3_o.m0_axi_araddr),
      s_axi_arlen   => To_StdLogicVector(m0_axi3_o.m0_axi_arlen),
      s_axi_arsize  => To_StdLogicVector(m0_axi3_o.m0_axi_arsize),
      s_axi_arburst => To_StdLogicVector(m0_axi3_o.m0_axi_arburst),
      s_axi_arlock  => To_StdLogicVector(m0_axi3_o.m0_axi_arlock),
      s_axi_arcache => To_StdLogicVector(m0_axi3_o.m0_axi_arcache),
      s_axi_arprot  => To_StdLogicVector(m0_axi3_o.m0_axi_arprot),
      s_axi_arqos   => "0000",
      s_axi_arvalid => m0_axi3_o.m0_axi_arvalid,
      s_axi_arready => m0_axi3_i.m0_axi_arready,
      s_axi_rid     => m0_axi3_rid_int,
      s_axi_rdata   => m0_axi3_rdata_int,
      s_axi_rresp   => m0_axi3_rresp_int,
      s_axi_rlast   => m0_axi3_i.m0_axi_rlast,
      s_axi_rvalid  => m0_axi3_i.m0_axi_rvalid,
      s_axi_rready  => m0_axi3_o.m0_axi_rready,
      m_axi_awaddr  => m0_axi4lite_awaddr_int,
      m_axi_awprot  => m0_axi4lite_awprot_int,
      m_axi_awvalid => m0_axi4lite_o.m0_axi_awvalid,
      m_axi_awready => m0_axi4lite_i.m0_axi_awready,
      m_axi_wdata   => m0_axi4lite_wdata_int,
      m_axi_wstrb   => m0_axi4lite_wstrb_int,
      m_axi_wvalid  => m0_axi4lite_o.m0_axi_wvalid,
      m_axi_wready  => m0_axi4lite_i.m0_axi_wready,
      m_axi_bresp   => To_StdLogicVector(m0_axi4lite_i.m0_axi_bresp),
      m_axi_bvalid  => m0_axi4lite_i.m0_axi_bvalid,
      m_axi_bready  => m0_axi4lite_o.m0_axi_bready,
      m_axi_araddr  => m0_axi4lite_araddr_int,
      m_axi_arprot  => m0_axi4lite_arprot_int,
      m_axi_arvalid => m0_axi4lite_o.m0_axi_arvalid,
      m_axi_arready => m0_axi4lite_i.m0_axi_arready,
      m_axi_rdata   => To_StdLogicVector(m0_axi4lite_i.m0_axi_rdata),
      m_axi_rresp   => To_StdLogicVector(m0_axi4lite_i.m0_axi_rresp),
      m_axi_rvalid  => m0_axi4lite_i.m0_axi_rvalid,
      m_axi_rready  => m0_axi4lite_o.m0_axi_rready
      );

  axi_64_32_width_converter : entity work.axi_64_32_width_converter
    port map (
      sysclk     => aclk,
      sys_resetn => aresetn,
      s0_axi_i   => s1_axi_64_i,
      s0_axi_o   => s1_axi_64_o,
      m0_axi_i   => m1_axi_32_i,
      m0_axi_o   => m1_axi_32_o
      );

  m1_register_slice : entity work.axi3_register_slice_wrap
    PORT MAP (
      aclk     => aclk,
      s0_axi_i => m1_axi_slice_i,
      s0_axi_o => m1_axi_slice_o,
      m0_axi_i => m1_axi_i,
      m0_axi_o => m1_axi_o
    );

  m2_register_slice : entity work.axi3_register_slice_wrap
    PORT MAP (
      aclk     => aclk,
      s0_axi_i => m2_axi_slice_i,
      s0_axi_o => m2_axi_slice_o,
      m0_axi_i => m2_axi_i,
      m0_axi_o => m2_axi_o
    );

  m3_register_slice : entity work.axi3_register_slice_wrap
    PORT MAP (
      aclk     => aclk,
      s0_axi_i => m3_axi_slice_i,
      s0_axi_o => m3_axi_slice_o,
      m0_axi_i => m3_axi_i,
      m0_axi_o => m3_axi_o
    );

  m4_register_slice : entity work.axi3_register_slice_wrap
    PORT MAP (
      aclk     => aclk,
      s0_axi_i => m4_axi_slice_i,
      s0_axi_o => m4_axi_slice_o,
      m0_axi_i => m4_axi_i,
      m0_axi_o => m4_axi_o
    );

  m5_register_slice : entity work.axi3_register_slice_wrap
    PORT MAP (
      aclk     => aclk,
      s0_axi_i => m5_axi_slice_i,
      s0_axi_o => m5_axi_slice_o,
      m0_axi_i => m5_axi_i,
      m0_axi_o => m5_axi_o
    );

  m6_register_slice : entity work.axi3_register_slice_wrap
    PORT MAP (
      aclk     => aclk,
      s0_axi_i => m6_axi_slice_i,
      s0_axi_o => m6_axi_slice_o,
      m0_axi_i => m6_axi_i,
      m0_axi_o => m6_axi_o
    );

  m7_register_slice : entity work.axi3_register_slice_slr_wrap
    PORT MAP (
      aclk     => aclk,
      s0_axi_i => m7_axi_slice_i,
      s0_axi_o => m7_axi_slice_o,
      m0_axi_i => m7_axi_i,
      m0_axi_o => m7_axi_o
    );

  axi3_crossbar : axi3_crossbar_0
    PORT MAP (
      aclk => aclk,
      aresetn => aresetn,
      s_axi_awid => s_axi_awid,
      s_axi_awaddr => s_axi_awaddr,
      s_axi_awlen => s_axi_awlen,
      s_axi_awsize => s_axi_awsize,
      s_axi_awburst => s_axi_awburst,
      s_axi_awlock => s_axi_awlock,
      s_axi_awcache => s_axi_awcache,
      s_axi_awprot => s_axi_awprot,
      s_axi_awqos => s_axi_awqos,
      s_axi_awvalid => s_axi_awvalid,
      s_axi_awready => s_axi_awready,
      s_axi_wid => s_axi_wid,
      s_axi_wdata => s_axi_wdata,
      s_axi_wstrb => s_axi_wstrb,
      s_axi_wlast => s_axi_wlast,
      s_axi_wvalid => s_axi_wvalid,
      s_axi_wready => s_axi_wready,
      s_axi_bid => s_axi_bid,
      s_axi_bresp => s_axi_bresp,
      s_axi_bvalid => s_axi_bvalid,
      s_axi_bready => s_axi_bready,
      s_axi_arid => s_axi_arid,
      s_axi_araddr => s_axi_araddr,
      s_axi_arlen => s_axi_arlen,
      s_axi_arsize => s_axi_arsize,
      s_axi_arburst => s_axi_arburst,
      s_axi_arlock => s_axi_arlock,
      s_axi_arcache => s_axi_arcache,
      s_axi_arprot => s_axi_arprot,
      s_axi_arqos => s_axi_arqos,
      s_axi_arvalid => s_axi_arvalid,
      s_axi_arready => s_axi_arready,
      s_axi_rid => s_axi_rid,
      s_axi_rdata => s_axi_rdata,
      s_axi_rresp => s_axi_rresp,
      s_axi_rlast => s_axi_rlast,
      s_axi_rvalid => s_axi_rvalid,
      s_axi_rready => s_axi_rready,
      m_axi_awid => m_axi_awid,
      m_axi_awaddr => m_axi_awaddr,
      m_axi_awlen => m_axi_awlen,
      m_axi_awsize => m_axi_awsize,
      m_axi_awburst => m_axi_awburst,
      m_axi_awlock => m_axi_awlock,
      m_axi_awcache => m_axi_awcache,
      m_axi_awprot => m_axi_awprot,
      m_axi_awqos => m_axi_awqos,
      m_axi_awvalid => m_axi_awvalid,
      m_axi_awready => m_axi_awready,
      m_axi_wid => m_axi_wid,
      m_axi_wdata => m_axi_wdata,
      m_axi_wstrb => m_axi_wstrb,
      m_axi_wlast => m_axi_wlast,
      m_axi_wvalid => m_axi_wvalid,
      m_axi_wready => m_axi_wready,
      m_axi_bid => m_axi_bid,
      m_axi_bresp => m_axi_bresp,
      m_axi_bvalid => m_axi_bvalid,
      m_axi_bready => m_axi_bready,
      m_axi_arid => m_axi_arid,
      m_axi_araddr => m_axi_araddr,
      m_axi_arlen => m_axi_arlen,
      m_axi_arsize => m_axi_arsize,
      m_axi_arburst => m_axi_arburst,
      m_axi_arlock => m_axi_arlock,
      m_axi_arcache => m_axi_arcache,
      m_axi_arprot => m_axi_arprot,
      m_axi_arqos => m_axi_arqos,
      m_axi_arvalid => m_axi_arvalid,
      m_axi_arready => m_axi_arready,
      m_axi_rid => m_axi_rid,
      m_axi_rdata => m_axi_rdata,
      m_axi_rresp => m_axi_rresp,
      m_axi_rlast => m_axi_rlast,
      m_axi_rvalid => m_axi_rvalid,
      m_axi_rready => m_axi_rready
      );

end axi3_crossbar_slr0_top;
