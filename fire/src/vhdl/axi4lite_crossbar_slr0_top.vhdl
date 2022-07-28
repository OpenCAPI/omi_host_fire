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

entity axi4lite_crossbar_slr0_top is
  port (
    -- Global
    aclk    : in std_ulogic;
    aresetn : in std_ulogic;

    -- Slave 0
    s0_axi_i : in t_AXI4_LITE_SLAVE_INPUT;
    s0_axi_o : out t_AXI4_LITE_SLAVE_OUTPUT;

    -- Master 0
    m0_axi_i : in t_AXI4_LITE_MASTER_INPUT;
    m0_axi_o : out t_AXI4_LITE_MASTER_OUTPUT;

    -- Master 1
    m1_axi_i : in t_AXI4_LITE_MASTER_INPUT;
    m1_axi_o : out t_AXI4_LITE_MASTER_OUTPUT;

    -- Master 2
    m2_axi_i : in t_AXI4_LITE_MASTER_INPUT;
    m2_axi_o : out t_AXI4_LITE_MASTER_OUTPUT;

    -- Master 3
    m3_axi_i : in t_AXI4_LITE_MASTER_INPUT;
    m3_axi_o : out t_AXI4_LITE_MASTER_OUTPUT;

    -- Master 4
    m4_axi_i : in t_AXI4_LITE_MASTER_INPUT;
    m4_axi_o : out t_AXI4_LITE_MASTER_OUTPUT;

    -- Master 5
    m5_axi_i : in t_AXI4_LITE_MASTER_INPUT;
    m5_axi_o : out t_AXI4_LITE_MASTER_OUTPUT;

    -- Master 6
    m6_axi_i : in t_AXI4_LITE_MASTER_INPUT;
    m6_axi_o : out t_AXI4_LITE_MASTER_OUTPUT;

    -- Master 7
    m7_axi_i : in t_AXI4_LITE_MASTER_INPUT;
    m7_axi_o : out t_AXI4_LITE_MASTER_OUTPUT;

    -- Master 8
    m8_axi_i : in t_AXI4_LITE_MASTER_INPUT;
    m8_axi_o : out t_AXI4_LITE_MASTER_OUTPUT
  );
end axi4lite_crossbar_slr0_top;

architecture axi4lite_crossbar_slr0_top of axi4lite_crossbar_slr0_top is

  CONSTANT WIDTH_MASTER_PORTS   : integer := 9;
  CONSTANT WIDTH_MASTER_AWADDR  : integer := 64;
  CONSTANT WIDTH_MASTER_AWPROT  : integer := 3;
  CONSTANT WIDTH_MASTER_WDATA   : integer := 32;
  CONSTANT WIDTH_MASTER_WSTRB   : integer := 4;
  CONSTANT WIDTH_MASTER_BRESP   : integer := 2;
  CONSTANT WIDTH_MASTER_ARADDR  : integer := 64;
  CONSTANT WIDTH_MASTER_ARPROT  : integer := 3;
  CONSTANT WIDTH_MASTER_RDATA   : integer := 32;
  CONSTANT WIDTH_MASTER_RRESP   : integer := 2;

  signal s_axi_awaddr  : std_logic_vector(63 downto 0);
  signal s_axi_awprot  : std_logic_vector(2 downto 0);
  signal s_axi_awvalid : std_logic_vector(0 downto 0);
  signal s_axi_awready : std_logic_vector(0 downto 0);
  signal s_axi_wdata   : std_logic_vector(31 downto 0);
  signal s_axi_wstrb   : std_logic_vector(3 downto 0);
  signal s_axi_wvalid  : std_logic_vector(0 downto 0);
  signal s_axi_wready  : std_logic_vector(0 downto 0);
  signal s_axi_bresp   : std_logic_vector(1 downto 0);
  signal s_axi_bvalid  : std_logic_vector(0 downto 0);
  signal s_axi_bready  : std_logic_vector(0 downto 0);
  signal s_axi_araddr  : std_logic_vector(63 downto 0);
  signal s_axi_arprot  : std_logic_vector(2 downto 0);
  signal s_axi_arvalid : std_logic_vector(0 downto 0);
  signal s_axi_arready : std_logic_vector(0 downto 0);
  signal s_axi_rdata   : std_logic_vector(31 downto 0);
  signal s_axi_rresp   : std_logic_vector(1 downto 0);
  signal s_axi_rvalid  : std_logic_vector(0 downto 0);
  signal s_axi_rready  : std_logic_vector(0 downto 0);
  signal m_axi_awaddr  : std_logic_vector(WIDTH_MASTER_PORTS * WIDTH_MASTER_AWADDR - 1 DOWNTO 0);
  signal m_axi_awprot  : std_logic_vector(WIDTH_MASTER_PORTS * WIDTH_MASTER_AWPROT - 1 DOWNTO 0);
  signal m_axi_awvalid : std_logic_vector(WIDTH_MASTER_PORTS - 1 DOWNTO 0);
  signal m_axi_awready : std_logic_vector(WIDTH_MASTER_PORTS - 1 DOWNTO 0);
  signal m_axi_wdata   : std_logic_vector(WIDTH_MASTER_PORTS * WIDTH_MASTER_WDATA- 1  DOWNTO 0);
  signal m_axi_wstrb   : std_logic_vector(WIDTH_MASTER_PORTS * WIDTH_MASTER_WSTRB - 1 DOWNTO 0);
  signal m_axi_wvalid  : std_logic_vector(WIDTH_MASTER_PORTS - 1 DOWNTO 0);
  signal m_axi_wready  : std_logic_vector(WIDTH_MASTER_PORTS - 1 DOWNTO 0);
  signal m_axi_bresp   : std_logic_vector(WIDTH_MASTER_PORTS * WIDTH_MASTER_BRESP - 1 DOWNTO 0);
  signal m_axi_bvalid  : std_logic_vector(WIDTH_MASTER_PORTS - 1 DOWNTO 0);
  signal m_axi_bready  : std_logic_vector(WIDTH_MASTER_PORTS - 1 DOWNTO 0);
  signal m_axi_araddr  : std_logic_vector(WIDTH_MASTER_PORTS * WIDTH_MASTER_ARADDR - 1 DOWNTO 0);
  signal m_axi_arprot  : std_logic_vector(WIDTH_MASTER_PORTS * WIDTH_MASTER_ARPROT - 1 DOWNTO 0);
  signal m_axi_arvalid : std_logic_vector(WIDTH_MASTER_PORTS - 1 DOWNTO 0);
  signal m_axi_arready : std_logic_vector(WIDTH_MASTER_PORTS - 1 DOWNTO 0);
  signal m_axi_rdata   : std_logic_vector(WIDTH_MASTER_PORTS * WIDTH_MASTER_RDATA - 1 DOWNTO 0);
  signal m_axi_rresp   : std_logic_vector(WIDTH_MASTER_PORTS * WIDTH_MASTER_RRESP - 1 DOWNTO 0);
  signal m_axi_rvalid  : std_logic_vector(WIDTH_MASTER_PORTS - 1 DOWNTO 0);
  signal m_axi_rready  : std_logic_vector(WIDTH_MASTER_PORTS - 1 DOWNTO 0);

  signal m0_axi_slice_i  : t_AXI4_LITE_SLAVE_INPUT;
  signal m0_axi_slice_o  : t_AXI4_LITE_SLAVE_OUTPUT;
  signal m1_axi_slice_i  : t_AXI4_LITE_SLAVE_INPUT;
  signal m1_axi_slice_o  : t_AXI4_LITE_SLAVE_OUTPUT;
  signal m2_axi_slice_i  : t_AXI4_LITE_SLAVE_INPUT;
  signal m2_axi_slice_o  : t_AXI4_LITE_SLAVE_OUTPUT;
  signal m3_axi_slice_i  : t_AXI4_LITE_SLAVE_INPUT;
  signal m3_axi_slice_o  : t_AXI4_LITE_SLAVE_OUTPUT;
  signal m4_axi_slice_i  : t_AXI4_LITE_SLAVE_INPUT;
  signal m4_axi_slice_o  : t_AXI4_LITE_SLAVE_OUTPUT;
  signal m5_axi_slice_i  : t_AXI4_LITE_SLAVE_INPUT;
  signal m5_axi_slice_o  : t_AXI4_LITE_SLAVE_OUTPUT;
  signal m6_axi_slice_i  : t_AXI4_LITE_SLAVE_INPUT;
  signal m6_axi_slice_o  : t_AXI4_LITE_SLAVE_OUTPUT;
  signal m7_axi_slice_i  : t_AXI4_LITE_SLAVE_INPUT;
  signal m7_axi_slice_o  : t_AXI4_LITE_SLAVE_OUTPUT;
  signal m8_axi_slice_i  : t_AXI4_LITE_SLAVE_INPUT;
  signal m8_axi_slice_o  : t_AXI4_LITE_SLAVE_OUTPUT;

  COMPONENT axi4lite_crossbar_0
    PORT (
      aclk : IN STD_LOGIC;
      aresetn : IN STD_LOGIC;
      s_axi_awaddr : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
      s_axi_awprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_awvalid : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      s_axi_awready : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      s_axi_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      s_axi_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axi_wvalid : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      s_axi_wready : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      s_axi_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      s_axi_bvalid : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      s_axi_bready : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      s_axi_araddr : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
      s_axi_arprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_arvalid : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      s_axi_arready : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      s_axi_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      s_axi_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      s_axi_rvalid : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      s_axi_rready : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      m_axi_awaddr : OUT STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS * WIDTH_MASTER_AWADDR - 1 DOWNTO 0);
      m_axi_awprot : OUT STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS * WIDTH_MASTER_AWPROT - 1 DOWNTO 0);
      m_axi_awvalid : OUT STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS - 1 DOWNTO 0);
      m_axi_awready : IN STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS - 1 DOWNTO 0);
      m_axi_wdata : OUT STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS * WIDTH_MASTER_WDATA- 1  DOWNTO 0);
      m_axi_wstrb : OUT STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS * WIDTH_MASTER_WSTRB - 1 DOWNTO 0);
      m_axi_wvalid : OUT STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS - 1 DOWNTO 0);
      m_axi_wready : IN STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS - 1 DOWNTO 0);
      m_axi_bresp : IN STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS * WIDTH_MASTER_BRESP - 1 DOWNTO 0);
      m_axi_bvalid : IN STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS - 1 DOWNTO 0);
      m_axi_bready : OUT STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS - 1 DOWNTO 0);
      m_axi_araddr : OUT STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS * WIDTH_MASTER_ARADDR - 1 DOWNTO 0);
      m_axi_arprot : OUT STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS * WIDTH_MASTER_ARPROT - 1 DOWNTO 0);
      m_axi_arvalid : OUT STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS - 1 DOWNTO 0);
      m_axi_arready : IN STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS - 1 DOWNTO 0);
      m_axi_rdata : IN STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS * WIDTH_MASTER_RDATA - 1 DOWNTO 0);
      m_axi_rresp : IN STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS * WIDTH_MASTER_RRESP - 1 DOWNTO 0);
      m_axi_rvalid : IN STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS - 1 DOWNTO 0);
      m_axi_rready : OUT STD_LOGIC_VECTOR(WIDTH_MASTER_PORTS - 1 DOWNTO 0)
      );
  END COMPONENT;

begin

  -- Slave Mapping
  s_axi_awaddr(63 downto 0)    <= To_StdLogicVector(s0_axi_i.s0_axi_awaddr);
  s_axi_awprot(2 downto 0)     <= To_StdLogicVector(s0_axi_i.s0_axi_awprot);
  s_axi_awvalid(0)             <= s0_axi_i.s0_axi_awvalid;
  s0_axi_o.s0_axi_awready      <= s_axi_awready(0);

  s_axi_wdata(31 downto 0)  <= To_StdLogicVector(s0_axi_i.s0_axi_wdata);
  s_axi_wstrb(3 downto 0)   <= To_StdLogicVector(s0_axi_i.s0_axi_wstrb);
  s_axi_wvalid(0)           <= s0_axi_i.s0_axi_wvalid;
  s0_axi_o.s0_axi_wready    <= s_axi_wready(0);

  s0_axi_o.s0_axi_bresp  <= To_StdULogicVector(s_axi_bresp(1 downto 0));
  s0_axi_o.s0_axi_bvalid <= s_axi_bvalid(0);
  s_axi_bready(0)        <= s0_axi_i.s0_axi_bready;

  s_axi_araddr(63 downto 0)    <= To_StdLogicVector(s0_axi_i.s0_axi_araddr);
  s_axi_arprot(2 downto 0)     <= To_StdLogicVector(s0_axi_i.s0_axi_arprot);
  s_axi_arvalid(0)             <= s0_axi_i.s0_axi_arvalid;
  s0_axi_o.s0_axi_arready      <= s_axi_arready(0);

  s0_axi_o.s0_axi_rdata  <= To_StdULogicVector(s_axi_rdata(31 downto 0));
  s0_axi_o.s0_axi_rresp  <= To_StdULogicVector(s_axi_rresp(1 downto 0));
  s0_axi_o.s0_axi_rvalid <= s_axi_rvalid(0);
  s_axi_rready(0)        <= s0_axi_i.s0_axi_rready;

  -- Master Mapping
  m0_axi_slice_i.s0_axi_aresetn  <= aresetn;
  m1_axi_slice_i.s0_axi_aresetn  <= aresetn;
  m2_axi_slice_i.s0_axi_aresetn  <= aresetn;
  m3_axi_slice_i.s0_axi_aresetn  <= aresetn;
  m4_axi_slice_i.s0_axi_aresetn  <= aresetn;
  m5_axi_slice_i.s0_axi_aresetn  <= aresetn;
  m6_axi_slice_i.s0_axi_aresetn  <= aresetn;
  m7_axi_slice_i.s0_axi_aresetn  <= aresetn;
  m8_axi_slice_i.s0_axi_aresetn  <= aresetn;
  
  m0_axi_slice_i.s0_axi_awaddr   <= To_StdULogicVector(m_axi_awaddr( 1*WIDTH_MASTER_AWADDR - 1 downto  0*WIDTH_MASTER_AWADDR));
  m1_axi_slice_i.s0_axi_awaddr   <= To_StdULogicVector(m_axi_awaddr( 2*WIDTH_MASTER_AWADDR - 1 downto  1*WIDTH_MASTER_AWADDR));
  m2_axi_slice_i.s0_axi_awaddr   <= To_StdULogicVector(m_axi_awaddr( 3*WIDTH_MASTER_AWADDR - 1 downto  2*WIDTH_MASTER_AWADDR));
  m3_axi_slice_i.s0_axi_awaddr   <= To_StdULogicVector(m_axi_awaddr( 4*WIDTH_MASTER_AWADDR - 1 downto  3*WIDTH_MASTER_AWADDR));
  m4_axi_slice_i.s0_axi_awaddr   <= To_StdULogicVector(m_axi_awaddr( 5*WIDTH_MASTER_AWADDR - 1 downto  4*WIDTH_MASTER_AWADDR));
  m5_axi_slice_i.s0_axi_awaddr   <= To_StdULogicVector(m_axi_awaddr( 6*WIDTH_MASTER_AWADDR - 1 downto  5*WIDTH_MASTER_AWADDR));
  m6_axi_slice_i.s0_axi_awaddr   <= To_StdULogicVector(m_axi_awaddr( 7*WIDTH_MASTER_AWADDR - 1 downto  6*WIDTH_MASTER_AWADDR));
  m7_axi_slice_i.s0_axi_awaddr   <= To_StdULogicVector(m_axi_awaddr( 8*WIDTH_MASTER_AWADDR - 1 downto  7*WIDTH_MASTER_AWADDR));
  m8_axi_slice_i.s0_axi_awaddr   <= To_StdULogicVector(m_axi_awaddr( 9*WIDTH_MASTER_AWADDR - 1 downto  8*WIDTH_MASTER_AWADDR));
  m0_axi_slice_i.s0_axi_awprot   <= To_StdULogicVector(m_axi_awprot( 1*WIDTH_MASTER_AWPROT - 1 downto  0*WIDTH_MASTER_AWPROT));
  m1_axi_slice_i.s0_axi_awprot   <= To_StdULogicVector(m_axi_awprot( 2*WIDTH_MASTER_AWPROT - 1 downto  1*WIDTH_MASTER_AWPROT));
  m2_axi_slice_i.s0_axi_awprot   <= To_StdULogicVector(m_axi_awprot( 3*WIDTH_MASTER_AWPROT - 1 downto  2*WIDTH_MASTER_AWPROT));
  m3_axi_slice_i.s0_axi_awprot   <= To_StdULogicVector(m_axi_awprot( 4*WIDTH_MASTER_AWPROT - 1 downto  3*WIDTH_MASTER_AWPROT));
  m4_axi_slice_i.s0_axi_awprot   <= To_StdULogicVector(m_axi_awprot( 5*WIDTH_MASTER_AWPROT - 1 downto  4*WIDTH_MASTER_AWPROT));
  m5_axi_slice_i.s0_axi_awprot   <= To_StdULogicVector(m_axi_awprot( 6*WIDTH_MASTER_AWPROT - 1 downto  5*WIDTH_MASTER_AWPROT));
  m6_axi_slice_i.s0_axi_awprot   <= To_StdULogicVector(m_axi_awprot( 7*WIDTH_MASTER_AWPROT - 1 downto  6*WIDTH_MASTER_AWPROT));
  m7_axi_slice_i.s0_axi_awprot   <= To_StdULogicVector(m_axi_awprot( 8*WIDTH_MASTER_AWPROT - 1 downto  7*WIDTH_MASTER_AWPROT));
  m8_axi_slice_i.s0_axi_awprot   <= To_StdULogicVector(m_axi_awprot( 9*WIDTH_MASTER_AWPROT - 1 downto  8*WIDTH_MASTER_AWPROT));
  m0_axi_slice_i.s0_axi_awvalid  <= m_axi_awvalid( 0);
  m1_axi_slice_i.s0_axi_awvalid  <= m_axi_awvalid( 1);
  m2_axi_slice_i.s0_axi_awvalid  <= m_axi_awvalid( 2);
  m3_axi_slice_i.s0_axi_awvalid  <= m_axi_awvalid( 3);
  m4_axi_slice_i.s0_axi_awvalid  <= m_axi_awvalid( 4);
  m5_axi_slice_i.s0_axi_awvalid  <= m_axi_awvalid( 5);
  m6_axi_slice_i.s0_axi_awvalid  <= m_axi_awvalid( 6);
  m7_axi_slice_i.s0_axi_awvalid  <= m_axi_awvalid( 7);
  m8_axi_slice_i.s0_axi_awvalid  <= m_axi_awvalid( 8);
  m_axi_awready( 0)              <= m0_axi_slice_o.s0_axi_awready;
  m_axi_awready( 1)              <= m1_axi_slice_o.s0_axi_awready;
  m_axi_awready( 2)              <= m2_axi_slice_o.s0_axi_awready;
  m_axi_awready( 3)              <= m3_axi_slice_o.s0_axi_awready;
  m_axi_awready( 4)              <= m4_axi_slice_o.s0_axi_awready;
  m_axi_awready( 5)              <= m5_axi_slice_o.s0_axi_awready;
  m_axi_awready( 6)              <= m6_axi_slice_o.s0_axi_awready;
  m_axi_awready( 7)              <= m7_axi_slice_o.s0_axi_awready;
  m_axi_awready( 8)              <= m8_axi_slice_o.s0_axi_awready;

  m0_axi_slice_i.s0_axi_wdata   <= To_StdULogicVector(m_axi_wdata( 1*WIDTH_MASTER_WDATA - 1 downto  0*WIDTH_MASTER_WDATA));
  m1_axi_slice_i.s0_axi_wdata   <= To_StdULogicVector(m_axi_wdata( 2*WIDTH_MASTER_WDATA - 1 downto  1*WIDTH_MASTER_WDATA));
  m2_axi_slice_i.s0_axi_wdata   <= To_StdULogicVector(m_axi_wdata( 3*WIDTH_MASTER_WDATA - 1 downto  2*WIDTH_MASTER_WDATA));
  m3_axi_slice_i.s0_axi_wdata   <= To_StdULogicVector(m_axi_wdata( 4*WIDTH_MASTER_WDATA - 1 downto  3*WIDTH_MASTER_WDATA));
  m4_axi_slice_i.s0_axi_wdata   <= To_StdULogicVector(m_axi_wdata( 5*WIDTH_MASTER_WDATA - 1 downto  4*WIDTH_MASTER_WDATA));
  m5_axi_slice_i.s0_axi_wdata   <= To_StdULogicVector(m_axi_wdata( 6*WIDTH_MASTER_WDATA - 1 downto  5*WIDTH_MASTER_WDATA));
  m6_axi_slice_i.s0_axi_wdata   <= To_StdULogicVector(m_axi_wdata( 7*WIDTH_MASTER_WDATA - 1 downto  6*WIDTH_MASTER_WDATA));
  m7_axi_slice_i.s0_axi_wdata   <= To_StdULogicVector(m_axi_wdata( 8*WIDTH_MASTER_WDATA - 1 downto  7*WIDTH_MASTER_WDATA));
  m8_axi_slice_i.s0_axi_wdata   <= To_StdULogicVector(m_axi_wdata( 9*WIDTH_MASTER_WDATA - 1 downto  8*WIDTH_MASTER_WDATA));
  m0_axi_slice_i.s0_axi_wstrb   <= To_StdULogicVector(m_axi_wstrb( 1*WIDTH_MASTER_WSTRB - 1 downto  0*WIDTH_MASTER_WSTRB));
  m1_axi_slice_i.s0_axi_wstrb   <= To_StdULogicVector(m_axi_wstrb( 2*WIDTH_MASTER_WSTRB - 1 downto  1*WIDTH_MASTER_WSTRB));
  m2_axi_slice_i.s0_axi_wstrb   <= To_StdULogicVector(m_axi_wstrb( 3*WIDTH_MASTER_WSTRB - 1 downto  2*WIDTH_MASTER_WSTRB));
  m3_axi_slice_i.s0_axi_wstrb   <= To_StdULogicVector(m_axi_wstrb( 4*WIDTH_MASTER_WSTRB - 1 downto  3*WIDTH_MASTER_WSTRB));
  m4_axi_slice_i.s0_axi_wstrb   <= To_StdULogicVector(m_axi_wstrb( 5*WIDTH_MASTER_WSTRB - 1 downto  4*WIDTH_MASTER_WSTRB));
  m5_axi_slice_i.s0_axi_wstrb   <= To_StdULogicVector(m_axi_wstrb( 6*WIDTH_MASTER_WSTRB - 1 downto  5*WIDTH_MASTER_WSTRB));
  m6_axi_slice_i.s0_axi_wstrb   <= To_StdULogicVector(m_axi_wstrb( 7*WIDTH_MASTER_WSTRB - 1 downto  6*WIDTH_MASTER_WSTRB));
  m7_axi_slice_i.s0_axi_wstrb   <= To_StdULogicVector(m_axi_wstrb( 8*WIDTH_MASTER_WSTRB - 1 downto  7*WIDTH_MASTER_WSTRB));
  m8_axi_slice_i.s0_axi_wstrb   <= To_StdULogicVector(m_axi_wstrb( 9*WIDTH_MASTER_WSTRB - 1 downto  8*WIDTH_MASTER_WSTRB));
  m0_axi_slice_i.s0_axi_wvalid  <= m_axi_wvalid( 0);
  m1_axi_slice_i.s0_axi_wvalid  <= m_axi_wvalid( 1);
  m2_axi_slice_i.s0_axi_wvalid  <= m_axi_wvalid( 2);
  m3_axi_slice_i.s0_axi_wvalid  <= m_axi_wvalid( 3);
  m4_axi_slice_i.s0_axi_wvalid  <= m_axi_wvalid( 4);
  m5_axi_slice_i.s0_axi_wvalid  <= m_axi_wvalid( 5);
  m6_axi_slice_i.s0_axi_wvalid  <= m_axi_wvalid( 6);
  m7_axi_slice_i.s0_axi_wvalid  <= m_axi_wvalid( 7);
  m8_axi_slice_i.s0_axi_wvalid  <= m_axi_wvalid( 8);
  m_axi_wready( 0)              <= m0_axi_slice_o.s0_axi_wready;
  m_axi_wready( 1)              <= m1_axi_slice_o.s0_axi_wready;
  m_axi_wready( 2)              <= m2_axi_slice_o.s0_axi_wready;
  m_axi_wready( 3)              <= m3_axi_slice_o.s0_axi_wready;
  m_axi_wready( 4)              <= m4_axi_slice_o.s0_axi_wready;
  m_axi_wready( 5)              <= m5_axi_slice_o.s0_axi_wready;
  m_axi_wready( 6)              <= m6_axi_slice_o.s0_axi_wready;
  m_axi_wready( 7)              <= m7_axi_slice_o.s0_axi_wready;
  m_axi_wready( 8)              <= m8_axi_slice_o.s0_axi_wready;

  m_axi_bresp( 1*WIDTH_MASTER_BRESP - 1 downto  0*WIDTH_MASTER_BRESP) <= To_StdLogicVector(m0_axi_slice_o.s0_axi_bresp);
  m_axi_bresp( 2*WIDTH_MASTER_BRESP - 1 downto  1*WIDTH_MASTER_BRESP) <= To_StdLogicVector(m1_axi_slice_o.s0_axi_bresp);
  m_axi_bresp( 3*WIDTH_MASTER_BRESP - 1 downto  2*WIDTH_MASTER_BRESP) <= To_StdLogicVector(m2_axi_slice_o.s0_axi_bresp);
  m_axi_bresp( 4*WIDTH_MASTER_BRESP - 1 downto  3*WIDTH_MASTER_BRESP) <= To_StdLogicVector(m3_axi_slice_o.s0_axi_bresp);
  m_axi_bresp( 5*WIDTH_MASTER_BRESP - 1 downto  4*WIDTH_MASTER_BRESP) <= To_StdLogicVector(m4_axi_slice_o.s0_axi_bresp);
  m_axi_bresp( 6*WIDTH_MASTER_BRESP - 1 downto  5*WIDTH_MASTER_BRESP) <= To_StdLogicVector(m5_axi_slice_o.s0_axi_bresp);
  m_axi_bresp( 7*WIDTH_MASTER_BRESP - 1 downto  6*WIDTH_MASTER_BRESP) <= To_StdLogicVector(m6_axi_slice_o.s0_axi_bresp);
  m_axi_bresp( 8*WIDTH_MASTER_BRESP - 1 downto  7*WIDTH_MASTER_BRESP) <= To_StdLogicVector(m7_axi_slice_o.s0_axi_bresp);
  m_axi_bresp( 9*WIDTH_MASTER_BRESP - 1 downto  8*WIDTH_MASTER_BRESP) <= To_StdLogicVector(m8_axi_slice_o.s0_axi_bresp);
  m_axi_bvalid( 0)                                                    <= m0_axi_slice_o.s0_axi_bvalid;
  m_axi_bvalid( 1)                                                    <= m1_axi_slice_o.s0_axi_bvalid;
  m_axi_bvalid( 2)                                                    <= m2_axi_slice_o.s0_axi_bvalid;
  m_axi_bvalid( 3)                                                    <= m3_axi_slice_o.s0_axi_bvalid;
  m_axi_bvalid( 4)                                                    <= m4_axi_slice_o.s0_axi_bvalid;
  m_axi_bvalid( 5)                                                    <= m5_axi_slice_o.s0_axi_bvalid;
  m_axi_bvalid( 6)                                                    <= m6_axi_slice_o.s0_axi_bvalid;
  m_axi_bvalid( 7)                                                    <= m7_axi_slice_o.s0_axi_bvalid;
  m_axi_bvalid( 8)                                                    <= m8_axi_slice_o.s0_axi_bvalid;
  m0_axi_slice_i.s0_axi_bready                                        <= m_axi_bready( 0);
  m1_axi_slice_i.s0_axi_bready                                        <= m_axi_bready( 1);
  m2_axi_slice_i.s0_axi_bready                                        <= m_axi_bready( 2);
  m3_axi_slice_i.s0_axi_bready                                        <= m_axi_bready( 3);
  m4_axi_slice_i.s0_axi_bready                                        <= m_axi_bready( 4);
  m5_axi_slice_i.s0_axi_bready                                        <= m_axi_bready( 5);
  m6_axi_slice_i.s0_axi_bready                                        <= m_axi_bready( 6);
  m7_axi_slice_i.s0_axi_bready                                        <= m_axi_bready( 7);
  m8_axi_slice_i.s0_axi_bready                                        <= m_axi_bready( 8);

  m0_axi_slice_i.s0_axi_araddr   <= To_StdULogicVector(m_axi_araddr( 1*WIDTH_MASTER_ARADDR - 1 downto  0*WIDTH_MASTER_ARADDR));
  m1_axi_slice_i.s0_axi_araddr   <= To_StdULogicVector(m_axi_araddr( 2*WIDTH_MASTER_ARADDR - 1 downto  1*WIDTH_MASTER_ARADDR));
  m2_axi_slice_i.s0_axi_araddr   <= To_StdULogicVector(m_axi_araddr( 3*WIDTH_MASTER_ARADDR - 1 downto  2*WIDTH_MASTER_ARADDR));
  m3_axi_slice_i.s0_axi_araddr   <= To_StdULogicVector(m_axi_araddr( 4*WIDTH_MASTER_ARADDR - 1 downto  3*WIDTH_MASTER_ARADDR));
  m4_axi_slice_i.s0_axi_araddr   <= To_StdULogicVector(m_axi_araddr( 5*WIDTH_MASTER_ARADDR - 1 downto  4*WIDTH_MASTER_ARADDR));
  m5_axi_slice_i.s0_axi_araddr   <= To_StdULogicVector(m_axi_araddr( 6*WIDTH_MASTER_ARADDR - 1 downto  5*WIDTH_MASTER_ARADDR));
  m6_axi_slice_i.s0_axi_araddr   <= To_StdULogicVector(m_axi_araddr( 7*WIDTH_MASTER_ARADDR - 1 downto  6*WIDTH_MASTER_ARADDR));
  m7_axi_slice_i.s0_axi_araddr   <= To_StdULogicVector(m_axi_araddr( 8*WIDTH_MASTER_ARADDR - 1 downto  7*WIDTH_MASTER_ARADDR));
  m8_axi_slice_i.s0_axi_araddr   <= To_StdULogicVector(m_axi_araddr( 9*WIDTH_MASTER_ARADDR - 1 downto  8*WIDTH_MASTER_ARADDR));
  m0_axi_slice_i.s0_axi_arprot   <= To_StdULogicVector(m_axi_arprot( 1*WIDTH_MASTER_ARPROT - 1 downto  0*WIDTH_MASTER_ARPROT));
  m1_axi_slice_i.s0_axi_arprot   <= To_StdULogicVector(m_axi_arprot( 2*WIDTH_MASTER_ARPROT - 1 downto  1*WIDTH_MASTER_ARPROT));
  m2_axi_slice_i.s0_axi_arprot   <= To_StdULogicVector(m_axi_arprot( 3*WIDTH_MASTER_ARPROT - 1 downto  2*WIDTH_MASTER_ARPROT));
  m3_axi_slice_i.s0_axi_arprot   <= To_StdULogicVector(m_axi_arprot( 4*WIDTH_MASTER_ARPROT - 1 downto  3*WIDTH_MASTER_ARPROT));
  m4_axi_slice_i.s0_axi_arprot   <= To_StdULogicVector(m_axi_arprot( 5*WIDTH_MASTER_ARPROT - 1 downto  4*WIDTH_MASTER_ARPROT));
  m5_axi_slice_i.s0_axi_arprot   <= To_StdULogicVector(m_axi_arprot( 6*WIDTH_MASTER_ARPROT - 1 downto  5*WIDTH_MASTER_ARPROT));
  m6_axi_slice_i.s0_axi_arprot   <= To_StdULogicVector(m_axi_arprot( 7*WIDTH_MASTER_ARPROT - 1 downto  6*WIDTH_MASTER_ARPROT));
  m7_axi_slice_i.s0_axi_arprot   <= To_StdULogicVector(m_axi_arprot( 8*WIDTH_MASTER_ARPROT - 1 downto  7*WIDTH_MASTER_ARPROT));
  m8_axi_slice_i.s0_axi_arprot   <= To_StdULogicVector(m_axi_arprot( 9*WIDTH_MASTER_ARPROT - 1 downto  8*WIDTH_MASTER_ARPROT));
  m0_axi_slice_i.s0_axi_arvalid  <= m_axi_arvalid( 0);
  m1_axi_slice_i.s0_axi_arvalid  <= m_axi_arvalid( 1);
  m2_axi_slice_i.s0_axi_arvalid  <= m_axi_arvalid( 2);
  m3_axi_slice_i.s0_axi_arvalid  <= m_axi_arvalid( 3);
  m4_axi_slice_i.s0_axi_arvalid  <= m_axi_arvalid( 4);
  m5_axi_slice_i.s0_axi_arvalid  <= m_axi_arvalid( 5);
  m6_axi_slice_i.s0_axi_arvalid  <= m_axi_arvalid( 6);
  m7_axi_slice_i.s0_axi_arvalid  <= m_axi_arvalid( 7);
  m8_axi_slice_i.s0_axi_arvalid  <= m_axi_arvalid( 8);
  m_axi_arready( 0)              <= m0_axi_slice_o.s0_axi_arready;
  m_axi_arready( 1)              <= m1_axi_slice_o.s0_axi_arready;
  m_axi_arready( 2)              <= m2_axi_slice_o.s0_axi_arready;
  m_axi_arready( 3)              <= m3_axi_slice_o.s0_axi_arready;
  m_axi_arready( 4)              <= m4_axi_slice_o.s0_axi_arready;
  m_axi_arready( 5)              <= m5_axi_slice_o.s0_axi_arready;
  m_axi_arready( 6)              <= m6_axi_slice_o.s0_axi_arready;
  m_axi_arready( 7)              <= m7_axi_slice_o.s0_axi_arready;
  m_axi_arready( 8)              <= m8_axi_slice_o.s0_axi_arready;

  m_axi_rdata( 1*WIDTH_MASTER_RDATA - 1 downto  0*WIDTH_MASTER_RDATA) <= To_StdLogicVector(m0_axi_slice_o.s0_axi_rdata);
  m_axi_rdata( 2*WIDTH_MASTER_RDATA - 1 downto  1*WIDTH_MASTER_RDATA) <= To_StdLogicVector(m1_axi_slice_o.s0_axi_rdata);
  m_axi_rdata( 3*WIDTH_MASTER_RDATA - 1 downto  2*WIDTH_MASTER_RDATA) <= To_StdLogicVector(m2_axi_slice_o.s0_axi_rdata);
  m_axi_rdata( 4*WIDTH_MASTER_RDATA - 1 downto  3*WIDTH_MASTER_RDATA) <= To_StdLogicVector(m3_axi_slice_o.s0_axi_rdata);
  m_axi_rdata( 5*WIDTH_MASTER_RDATA - 1 downto  4*WIDTH_MASTER_RDATA) <= To_StdLogicVector(m4_axi_slice_o.s0_axi_rdata);
  m_axi_rdata( 6*WIDTH_MASTER_RDATA - 1 downto  5*WIDTH_MASTER_RDATA) <= To_StdLogicVector(m5_axi_slice_o.s0_axi_rdata);
  m_axi_rdata( 7*WIDTH_MASTER_RDATA - 1 downto  6*WIDTH_MASTER_RDATA) <= To_StdLogicVector(m6_axi_slice_o.s0_axi_rdata);
  m_axi_rdata( 8*WIDTH_MASTER_RDATA - 1 downto  7*WIDTH_MASTER_RDATA) <= To_StdLogicVector(m7_axi_slice_o.s0_axi_rdata);
  m_axi_rdata( 9*WIDTH_MASTER_RDATA - 1 downto  8*WIDTH_MASTER_RDATA) <= To_StdLogicVector(m8_axi_slice_o.s0_axi_rdata);
  m_axi_rresp( 1*WIDTH_MASTER_RRESP - 1 downto  0*WIDTH_MASTER_RRESP) <= To_StdLogicVector(m0_axi_slice_o.s0_axi_rresp);
  m_axi_rresp( 2*WIDTH_MASTER_RRESP - 1 downto  1*WIDTH_MASTER_RRESP) <= To_StdLogicVector(m1_axi_slice_o.s0_axi_rresp);
  m_axi_rresp( 3*WIDTH_MASTER_RRESP - 1 downto  2*WIDTH_MASTER_RRESP) <= To_StdLogicVector(m2_axi_slice_o.s0_axi_rresp);
  m_axi_rresp( 4*WIDTH_MASTER_RRESP - 1 downto  3*WIDTH_MASTER_RRESP) <= To_StdLogicVector(m3_axi_slice_o.s0_axi_rresp);
  m_axi_rresp( 5*WIDTH_MASTER_RRESP - 1 downto  4*WIDTH_MASTER_RRESP) <= To_StdLogicVector(m4_axi_slice_o.s0_axi_rresp);
  m_axi_rresp( 6*WIDTH_MASTER_RRESP - 1 downto  5*WIDTH_MASTER_RRESP) <= To_StdLogicVector(m5_axi_slice_o.s0_axi_rresp);
  m_axi_rresp( 7*WIDTH_MASTER_RRESP - 1 downto  6*WIDTH_MASTER_RRESP) <= To_StdLogicVector(m6_axi_slice_o.s0_axi_rresp);
  m_axi_rresp( 8*WIDTH_MASTER_RRESP - 1 downto  7*WIDTH_MASTER_RRESP) <= To_StdLogicVector(m7_axi_slice_o.s0_axi_rresp);
  m_axi_rresp( 9*WIDTH_MASTER_RRESP - 1 downto  8*WIDTH_MASTER_RRESP) <= To_StdLogicVector(m8_axi_slice_o.s0_axi_rresp);
  m_axi_rvalid( 0)                                                    <= m0_axi_slice_o.s0_axi_rvalid;
  m_axi_rvalid( 1)                                                    <= m1_axi_slice_o.s0_axi_rvalid;
  m_axi_rvalid( 2)                                                    <= m2_axi_slice_o.s0_axi_rvalid;
  m_axi_rvalid( 3)                                                    <= m3_axi_slice_o.s0_axi_rvalid;
  m_axi_rvalid( 4)                                                    <= m4_axi_slice_o.s0_axi_rvalid;
  m_axi_rvalid( 5)                                                    <= m5_axi_slice_o.s0_axi_rvalid;
  m_axi_rvalid( 6)                                                    <= m6_axi_slice_o.s0_axi_rvalid;
  m_axi_rvalid( 7)                                                    <= m7_axi_slice_o.s0_axi_rvalid;
  m_axi_rvalid( 8)                                                    <= m8_axi_slice_o.s0_axi_rvalid;
  m0_axi_slice_i.s0_axi_rready                                        <= m_axi_rready( 0);
  m1_axi_slice_i.s0_axi_rready                                        <= m_axi_rready( 1);
  m2_axi_slice_i.s0_axi_rready                                        <= m_axi_rready( 2);
  m3_axi_slice_i.s0_axi_rready                                        <= m_axi_rready( 3);
  m4_axi_slice_i.s0_axi_rready                                        <= m_axi_rready( 4);
  m5_axi_slice_i.s0_axi_rready                                        <= m_axi_rready( 5);
  m6_axi_slice_i.s0_axi_rready                                        <= m_axi_rready( 6);
  m7_axi_slice_i.s0_axi_rready                                        <= m_axi_rready( 7);
  m8_axi_slice_i.s0_axi_rready                                        <= m_axi_rready( 8);

  m0_register_slice : entity work.axi4lite_register_slice_wrap
    PORT MAP (
      aclk     => aclk,
      s0_axi_i => m0_axi_slice_i,
      s0_axi_o => m0_axi_slice_o,
      m0_axi_i => m0_axi_i,
      m0_axi_o => m0_axi_o
    );

  m1_register_slice : entity work.axi4lite_register_slice_wrap
    PORT MAP (
      aclk     => aclk,
      s0_axi_i => m1_axi_slice_i,
      s0_axi_o => m1_axi_slice_o,
      m0_axi_i => m1_axi_i,
      m0_axi_o => m1_axi_o
    );

  m2_register_slice : entity work.axi4lite_register_slice_wrap
    PORT MAP (
      aclk     => aclk,
      s0_axi_i => m2_axi_slice_i,
      s0_axi_o => m2_axi_slice_o,
      m0_axi_i => m2_axi_i,
      m0_axi_o => m2_axi_o
    );

  m3_register_slice : entity work.axi4lite_register_slice_wrap
    PORT MAP (
      aclk     => aclk,
      s0_axi_i => m3_axi_slice_i,
      s0_axi_o => m3_axi_slice_o,
      m0_axi_i => m3_axi_i,
      m0_axi_o => m3_axi_o
    );

  m4_register_slice : entity work.axi4lite_register_slice_wrap
    PORT MAP (
      aclk     => aclk,
      s0_axi_i => m4_axi_slice_i,
      s0_axi_o => m4_axi_slice_o,
      m0_axi_i => m4_axi_i,
      m0_axi_o => m4_axi_o
    );

  m5_register_slice : entity work.axi4lite_register_slice_wrap
    PORT MAP (
      aclk     => aclk,
      s0_axi_i => m5_axi_slice_i,
      s0_axi_o => m5_axi_slice_o,
      m0_axi_i => m5_axi_i,
      m0_axi_o => m5_axi_o
    );

  m6_register_slice : entity work.axi4lite_register_slice_wrap
    PORT MAP (
      aclk     => aclk,
      s0_axi_i => m6_axi_slice_i,
      s0_axi_o => m6_axi_slice_o,
      m0_axi_i => m6_axi_i,
      m0_axi_o => m6_axi_o
    );

  m7_register_slice : entity work.axi4lite_register_slice_wrap
    PORT MAP (
      aclk     => aclk,
      s0_axi_i => m7_axi_slice_i,
      s0_axi_o => m7_axi_slice_o,
      m0_axi_i => m7_axi_i,
      m0_axi_o => m7_axi_o
    );

  m8_register_slice : entity work.axi4lite_register_slice_wrap
    PORT MAP (
      aclk     => aclk,
      s0_axi_i => m8_axi_slice_i,
      s0_axi_o => m8_axi_slice_o,
      m0_axi_i => m8_axi_i,
      m0_axi_o => m8_axi_o
    );

  axi4lite_crossbar : axi4lite_crossbar_0
    PORT MAP (
      aclk => aclk,
      aresetn => aresetn,
      s_axi_awaddr => s_axi_awaddr,
      s_axi_awprot => s_axi_awprot,
      s_axi_awvalid => s_axi_awvalid,
      s_axi_awready => s_axi_awready,
      s_axi_wdata => s_axi_wdata,
      s_axi_wstrb => s_axi_wstrb,
      s_axi_wvalid => s_axi_wvalid,
      s_axi_wready => s_axi_wready,
      s_axi_bresp => s_axi_bresp,
      s_axi_bvalid => s_axi_bvalid,
      s_axi_bready => s_axi_bready,
      s_axi_araddr => s_axi_araddr,
      s_axi_arprot => s_axi_arprot,
      s_axi_arvalid => s_axi_arvalid,
      s_axi_arready => s_axi_arready,
      s_axi_rdata => s_axi_rdata,
      s_axi_rresp => s_axi_rresp,
      s_axi_rvalid => s_axi_rvalid,
      s_axi_rready => s_axi_rready,
      m_axi_awaddr => m_axi_awaddr,
      m_axi_awprot => m_axi_awprot,
      m_axi_awvalid => m_axi_awvalid,
      m_axi_awready => m_axi_awready,
      m_axi_wdata => m_axi_wdata,
      m_axi_wstrb => m_axi_wstrb,
      m_axi_wvalid => m_axi_wvalid,
      m_axi_wready => m_axi_wready,
      m_axi_bresp => m_axi_bresp,
      m_axi_bvalid => m_axi_bvalid,
      m_axi_bready => m_axi_bready,
      m_axi_araddr => m_axi_araddr,
      m_axi_arprot => m_axi_arprot,
      m_axi_arvalid => m_axi_arvalid,
      m_axi_arready => m_axi_arready,
      m_axi_rdata => m_axi_rdata,
      m_axi_rresp => m_axi_rresp,
      m_axi_rvalid => m_axi_rvalid,
      m_axi_rready => m_axi_rready
      );

end axi4lite_crossbar_slr0_top;
