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

entity axi3_register_slice_wrap is
  Port ( 
    aclk : in STD_LOGIC;

    s0_axi_i : in t_AXI3_SLAVE_INPUT;
    s0_axi_o : out t_AXI3_SLAVE_OUTPUT;
    m0_axi_i : in t_AXI3_MASTER_INPUT;
    m0_axi_o : out t_AXI3_MASTER_OUTPUT
  );
end axi3_register_slice_wrap;

architecture axi3_register_slice_wrap of axi3_register_slice_wrap is

  signal s0_axi_bid_int     : std_logic_vector(6 downto 0);
  signal s0_axi_bresp_int   : std_logic_vector(1 downto 0);
  signal s0_axi_rid_int     : std_logic_vector(6 downto 0);
  signal s0_axi_rdata_int   : std_logic_vector(31 downto 0);
  signal s0_axi_rresp_int   : std_logic_vector(1 downto 0);
  signal m0_axi_awid_int    : std_logic_vector(6 downto 0);
  signal m0_axi_awaddr_int  : std_logic_vector(63 downto 0);
  signal m0_axi_awlen_int   : std_logic_vector(3 downto 0);
  signal m0_axi_awsize_int  : std_logic_vector(2 downto 0);
  signal m0_axi_awburst_int : std_logic_vector(1 downto 0);
  signal m0_axi_awlock_int  : std_logic_vector(1 downto 0);
  signal m0_axi_awcache_int : std_logic_vector(3 downto 0);
  signal m0_axi_awprot_int  : std_logic_vector(2 downto 0);
  signal m0_axi_wid_int     : std_logic_vector(6 downto 0);
  signal m0_axi_wdata_int   : std_logic_vector(31 downto 0);
  signal m0_axi_wstrb_int   : std_logic_vector(3 downto 0);
  signal m0_axi_arid_int    : std_logic_vector(6 downto 0);
  signal m0_axi_araddr_int  : std_logic_vector(63 downto 0);
  signal m0_axi_arlen_int   : std_logic_vector(3 downto 0);
  signal m0_axi_arsize_int  : std_logic_vector(2 downto 0);
  signal m0_axi_arburst_int : std_logic_vector(1 downto 0);
  signal m0_axi_arlock_int  : std_logic_vector(1 downto 0);
  signal m0_axi_arcache_int : std_logic_vector(3 downto 0);
  signal m0_axi_arprot_int  : std_logic_vector(2 downto 0);

  COMPONENT axi3_register_slice_0
    PORT (
      aclk          : IN  STD_LOGIC;
      aresetn       : IN  STD_LOGIC;
      s_axi_awid    : IN  STD_LOGIC_VECTOR(6 DOWNTO 0);
      s_axi_awaddr  : IN  STD_LOGIC_VECTOR(63 DOWNTO 0);
      s_axi_awlen   : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axi_awsize  : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_awburst : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
      s_axi_awlock  : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
      s_axi_awcache : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axi_awprot  : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_awqos   : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axi_awvalid : IN  STD_LOGIC;
      s_axi_awready : OUT STD_LOGIC;
      s_axi_wid     : IN  STD_LOGIC_VECTOR(6 DOWNTO 0);
      s_axi_wdata   : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      s_axi_wstrb   : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axi_wlast   : IN  STD_LOGIC;
      s_axi_wvalid  : IN  STD_LOGIC;
      s_axi_wready  : OUT STD_LOGIC;
      s_axi_bid     : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
      s_axi_bresp   : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      s_axi_bvalid  : OUT STD_LOGIC;
      s_axi_bready  : IN  STD_LOGIC;
      s_axi_arid    : IN  STD_LOGIC_VECTOR(6 DOWNTO 0);
      s_axi_araddr  : IN  STD_LOGIC_VECTOR(63 DOWNTO 0);
      s_axi_arlen   : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axi_arsize  : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_arburst : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
      s_axi_arlock  : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
      s_axi_arcache : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axi_arprot  : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_arqos   : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axi_arvalid : IN  STD_LOGIC;
      s_axi_arready : OUT STD_LOGIC;
      s_axi_rid     : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
      s_axi_rdata   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      s_axi_rresp   : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      s_axi_rlast   : OUT STD_LOGIC;
      s_axi_rvalid  : OUT STD_LOGIC;
      s_axi_rready  : IN  STD_LOGIC;
      m_axi_awid    : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
      m_axi_awaddr  : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
      m_axi_awlen   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axi_awsize  : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      m_axi_awburst : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      m_axi_awlock  : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      m_axi_awcache : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axi_awprot  : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      m_axi_awqos   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axi_awvalid : OUT STD_LOGIC;
      m_axi_awready : IN  STD_LOGIC;
      m_axi_wid     : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
      m_axi_wdata   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      m_axi_wstrb   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axi_wlast   : OUT STD_LOGIC;
      m_axi_wvalid  : OUT STD_LOGIC;
      m_axi_wready  : IN  STD_LOGIC;
      m_axi_bid     : IN  STD_LOGIC_VECTOR(6 DOWNTO 0);
      m_axi_bresp   : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
      m_axi_bvalid  : IN  STD_LOGIC;
      m_axi_bready  : OUT STD_LOGIC;
      m_axi_arid    : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
      m_axi_araddr  : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
      m_axi_arlen   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axi_arsize  : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      m_axi_arburst : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      m_axi_arlock  : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      m_axi_arcache : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axi_arprot  : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      m_axi_arqos   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axi_arvalid : OUT STD_LOGIC;
      m_axi_arready : IN  STD_LOGIC;
      m_axi_rid     : IN  STD_LOGIC_VECTOR(6 DOWNTO 0);
      m_axi_rdata   : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      m_axi_rresp   : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
      m_axi_rlast   : IN  STD_LOGIC;
      m_axi_rvalid  : IN  STD_LOGIC;
      m_axi_rready  : OUT STD_LOGIC
    );
  END COMPONENT;

begin

  m0_axi_o.m0_axi_aresetn <= s0_axi_i.s0_axi_aresetn;
  s0_axi_o.s0_axi_bid     <= To_StdUlogicVector(s0_axi_bid_int);
  s0_axi_o.s0_axi_bresp   <= To_StdUlogicVector(s0_axi_bresp_int);
  s0_axi_o.s0_axi_rid     <= To_StdUlogicVector(s0_axi_rid_int);
  s0_axi_o.s0_axi_rdata   <= To_StdUlogicVector(s0_axi_rdata_int);
  s0_axi_o.s0_axi_rresp   <= To_StdUlogicVector(s0_axi_rresp_int);
  m0_axi_o.m0_axi_awid    <= To_StdUlogicVector(m0_axi_awid_int);
  m0_axi_o.m0_axi_awaddr  <= To_StdUlogicVector(m0_axi_awaddr_int);
  m0_axi_o.m0_axi_awlen   <= To_StdUlogicVector(m0_axi_awlen_int);
  m0_axi_o.m0_axi_awsize  <= To_StdUlogicVector(m0_axi_awsize_int);
  m0_axi_o.m0_axi_awburst <= To_StdUlogicVector(m0_axi_awburst_int);
  m0_axi_o.m0_axi_awlock  <= To_StdUlogicVector(m0_axi_awlock_int);
  m0_axi_o.m0_axi_awcache <= To_StdUlogicVector(m0_axi_awcache_int);
  m0_axi_o.m0_axi_awprot  <= To_StdUlogicVector(m0_axi_awprot_int);
  m0_axi_o.m0_axi_wid     <= To_StdUlogicVector(m0_axi_wid_int);
  m0_axi_o.m0_axi_wdata   <= To_StdUlogicVector(m0_axi_wdata_int);
  m0_axi_o.m0_axi_wstrb   <= To_StdUlogicVector(m0_axi_wstrb_int);
  m0_axi_o.m0_axi_arid    <= To_StdUlogicVector(m0_axi_arid_int);
  m0_axi_o.m0_axi_araddr  <= To_StdUlogicVector(m0_axi_araddr_int);
  m0_axi_o.m0_axi_arlen   <= To_StdUlogicVector(m0_axi_arlen_int);
  m0_axi_o.m0_axi_arsize  <= To_StdUlogicVector(m0_axi_arsize_int);
  m0_axi_o.m0_axi_arburst <= To_StdUlogicVector(m0_axi_arburst_int);
  m0_axi_o.m0_axi_arlock  <= To_StdUlogicVector(m0_axi_arlock_int);
  m0_axi_o.m0_axi_arcache <= To_StdUlogicVector(m0_axi_arcache_int);
  m0_axi_o.m0_axi_arprot  <= To_StdUlogicVector(m0_axi_arprot_int);

  slice : axi3_register_slice_0
    PORT MAP (
      aclk          => aclk,
      aresetn       => s0_axi_i.s0_axi_aresetn,
      s_axi_awid    => To_StdLogicVector(s0_axi_i.s0_axi_awid),
      s_axi_awaddr  => To_StdLogicVector(s0_axi_i.s0_axi_awaddr),
      s_axi_awlen   => To_StdLogicVector(s0_axi_i.s0_axi_awlen),
      s_axi_awsize  => To_StdLogicVector(s0_axi_i.s0_axi_awsize),
      s_axi_awburst => To_StdLogicVector(s0_axi_i.s0_axi_awburst),
      s_axi_awlock  => To_StdLogicVector(s0_axi_i.s0_axi_awlock),
      s_axi_awcache => To_StdLogicVector(s0_axi_i.s0_axi_awcache),
      s_axi_awprot  => To_StdLogicVector(s0_axi_i.s0_axi_awprot),
      s_axi_awqos   => "0000",
      s_axi_awvalid => s0_axi_i.s0_axi_awvalid,
      s_axi_awready => s0_axi_o.s0_axi_awready,
      s_axi_wid     => To_StdLogicVector(s0_axi_i.s0_axi_wid),
      s_axi_wdata   => To_StdLogicVector(s0_axi_i.s0_axi_wdata),
      s_axi_wstrb   => To_StdLogicVector(s0_axi_i.s0_axi_wstrb),
      s_axi_wlast   => s0_axi_i.s0_axi_wlast,
      s_axi_wvalid  => s0_axi_i.s0_axi_wvalid,
      s_axi_wready  => s0_axi_o.s0_axi_wready,
      s_axi_bid     => s0_axi_bid_int,
      s_axi_bresp   => s0_axi_bresp_int,
      s_axi_bvalid  => s0_axi_o.s0_axi_bvalid,
      s_axi_bready  => s0_axi_i.s0_axi_bready,
      s_axi_arid    => To_StdLogicVector(s0_axi_i.s0_axi_arid),
      s_axi_araddr  => To_StdLogicVector(s0_axi_i.s0_axi_araddr),
      s_axi_arlen   => To_StdLogicVector(s0_axi_i.s0_axi_arlen),
      s_axi_arsize  => To_StdLogicVector(s0_axi_i.s0_axi_arsize),
      s_axi_arburst => To_StdLogicVector(s0_axi_i.s0_axi_arburst),
      s_axi_arlock  => To_StdLogicVector(s0_axi_i.s0_axi_arlock),
      s_axi_arcache => To_StdLogicVector(s0_axi_i.s0_axi_arcache),
      s_axi_arprot  => To_StdLogicVector(s0_axi_i.s0_axi_arprot),
      s_axi_arqos   => "0000",
      s_axi_arvalid => s0_axi_i.s0_axi_arvalid,
      s_axi_arready => s0_axi_o.s0_axi_arready,
      s_axi_rid     => s0_axi_rid_int,
      s_axi_rdata   => s0_axi_rdata_int,
      s_axi_rresp   => s0_axi_rresp_int,
      s_axi_rlast   => s0_axi_o.s0_axi_rlast,
      s_axi_rvalid  => s0_axi_o.s0_axi_rvalid,
      s_axi_rready  => s0_axi_i.s0_axi_rready,
      m_axi_awid    => m0_axi_awid_int,
      m_axi_awaddr  => m0_axi_awaddr_int,
      m_axi_awlen   => m0_axi_awlen_int,
      m_axi_awsize  => m0_axi_awsize_int,
      m_axi_awburst => m0_axi_awburst_int,
      m_axi_awlock  => m0_axi_awlock_int,
      m_axi_awcache => m0_axi_awcache_int,
      m_axi_awprot  => m0_axi_awprot_int,
      m_axi_awqos   => open,
      m_axi_awvalid => m0_axi_o.m0_axi_awvalid,
      m_axi_awready => m0_axi_i.m0_axi_awready,
      m_axi_wid     => m0_axi_wid_int,
      m_axi_wdata   => m0_axi_wdata_int,
      m_axi_wstrb   => m0_axi_wstrb_int,
      m_axi_wlast   => m0_axi_o.m0_axi_wlast,
      m_axi_wvalid  => m0_axi_o.m0_axi_wvalid,
      m_axi_wready  => m0_axi_i.m0_axi_wready,
      m_axi_bid     => To_StdLogicVector(m0_axi_i.m0_axi_bid),
      m_axi_bresp   => To_StdLogicVector(m0_axi_i.m0_axi_bresp),
      m_axi_bvalid  => m0_axi_i.m0_axi_bvalid,
      m_axi_bready  => m0_axi_o.m0_axi_bready,
      m_axi_arid    => m0_axi_arid_int,
      m_axi_araddr  => m0_axi_araddr_int,
      m_axi_arlen   => m0_axi_arlen_int,
      m_axi_arsize  => m0_axi_arsize_int,
      m_axi_arburst => m0_axi_arburst_int,
      m_axi_arlock  => m0_axi_arlock_int,
      m_axi_arcache => m0_axi_arcache_int,
      m_axi_arprot  => m0_axi_arprot_int,
      m_axi_arqos   => open,
      m_axi_arvalid => m0_axi_o.m0_axi_arvalid,
      m_axi_arready => m0_axi_i.m0_axi_arready,
      m_axi_rid     => To_StdLogicVector(m0_axi_i.m0_axi_rid),
      m_axi_rdata   => To_StdLogicVector(m0_axi_i.m0_axi_rdata),
      m_axi_rresp   => To_StdLogicVector(m0_axi_i.m0_axi_rresp),
      m_axi_rlast   => m0_axi_i.m0_axi_rlast,
      m_axi_rvalid  => m0_axi_i.m0_axi_rvalid,
      m_axi_rready  => m0_axi_o.m0_axi_rready
    );

end axi3_register_slice_wrap;
