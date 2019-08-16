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

entity axi4lite_crossbar_top is
  port (
    -- Global
    aclk    : in std_ulogic;
    aresetn : in std_ulogic;

    -- Slave 0
    s0_axi_i : in t_AXI4_LITE_SLAVE_INPUT;
    s0_axi_o : out t_AXI4_LITE_SLAVE_OUTPUT;

    -- Master 0, Base = 0x0100000000000000, Width = 24
    m0_axi_i : in t_AXI4_LITE_MASTER_INPUT;
    m0_axi_o : out t_AXI4_LITE_MASTER_OUTPUT;

    -- Master 1, Base = 0x0101000000000000, Width = 24
    m1_axi_i : in t_AXI4_LITE_MASTER_INPUT;
    m1_axi_o : out t_AXI4_LITE_MASTER_OUTPUT;

    -- Master 2, Base = 0x0102000000000000, Width = 24
    m2_axi_i : in t_AXI4_LITE_MASTER_INPUT;
    m2_axi_o : out t_AXI4_LITE_MASTER_OUTPUT;

    -- Master 3, Base = 0x0103000000000000, Width = 24, Register Slice
    m3_axi_i : in t_AXI4_LITE_MASTER_INPUT;
    m3_axi_o : out t_AXI4_LITE_MASTER_OUTPUT;

    -- Master 4, Base = 0x0104000000000000, Width = 24
    m4_axi_i : in t_AXI4_LITE_MASTER_INPUT;
    m4_axi_o : out t_AXI4_LITE_MASTER_OUTPUT;

    -- Master 5, Base = 0x0105000000000000, Width = 24
    m5_axi_i : in t_AXI4_LITE_MASTER_INPUT;
    m5_axi_o : out t_AXI4_LITE_MASTER_OUTPUT
  );
end axi4lite_crossbar_top;

architecture axi4lite_crossbar_top of axi4lite_crossbar_top is

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
  signal m_axi_awaddr  : std_logic_vector(383 downto 0);
  signal m_axi_awprot  : std_logic_vector(17 downto 0);
  signal m_axi_awvalid : std_logic_vector(5 downto 0);
  signal m_axi_awready : std_logic_vector(5 downto 0);
  signal m_axi_wdata   : std_logic_vector(191 downto 0);
  signal m_axi_wstrb   : std_logic_vector(23 downto 0);
  signal m_axi_wvalid  : std_logic_vector(5 downto 0);
  signal m_axi_wready  : std_logic_vector(5 downto 0);
  signal m_axi_bresp   : std_logic_vector(11 downto 0);
  signal m_axi_bvalid  : std_logic_vector(5 downto 0);
  signal m_axi_bready  : std_logic_vector(5 downto 0);
  signal m_axi_araddr  : std_logic_vector(383 downto 0);
  signal m_axi_arprot  : std_logic_vector(17 downto 0);
  signal m_axi_arvalid : std_logic_vector(5 downto 0);
  signal m_axi_arready : std_logic_vector(5 downto 0);
  signal m_axi_rdata   : std_logic_vector(191 downto 0);
  signal m_axi_rresp   : std_logic_vector(11 downto 0);
  signal m_axi_rvalid  : std_logic_vector(5 downto 0);
  signal m_axi_rready  : std_logic_vector(5 downto 0);
  
  signal m3_awaddr_slice_in   : std_logic_vector(63 downto 0);
  signal m3_awprot_slice_in   : std_logic_vector(2 downto 0);
  signal m3_awvalid_slice_in  : std_logic;
  signal m3_awready_slice_out : std_logic;
  signal m3_wdata_slice_in    : std_logic_vector(31 downto 0);
  signal m3_wstrb_slice_in    : std_logic_vector(3 downto 0);
  signal m3_wvalid_slice_in   : std_logic;
  signal m3_wready_slice_out  : std_logic;
  signal m3_bresp_slice_out   : std_logic_vector(1 downto 0);
  signal m3_bvalid_slice_out  : std_logic;
  signal m3_bready_slice_in   : std_logic;
  signal m3_araddr_slice_in   : std_logic_vector(63 downto 0);
  signal m3_arprot_slice_in   : std_logic_vector(2 downto 0);
  signal m3_arvalid_slice_in  : std_logic;
  signal m3_arready_slice_out : std_logic;
  signal m3_rdata_slice_out   : std_logic_vector(31 downto 0);
  signal m3_rresp_slice_out   : std_logic_vector(1 downto 0);
  signal m3_rvalid_slice_out  : std_logic;
  signal m3_rready_slice_in   : std_logic;
  signal m3_awaddr_slice_out  : std_logic_vector(63 downto 0);
  signal m3_awprot_slice_out  : std_logic_vector(2 downto 0);
  signal m3_awvalid_slice_out : std_logic;
  signal m3_awready_slice_in  : std_logic;
  signal m3_wdata_slice_out   : std_logic_vector(31 downto 0);
  signal m3_wstrb_slice_out   : std_logic_vector(3 downto 0);
  signal m3_wvalid_slice_out  : std_logic;
  signal m3_wready_slice_in   : std_logic;
  signal m3_bresp_slice_in    : std_logic_vector(1 downto 0);
  signal m3_bvalid_slice_in   : std_logic;
  signal m3_bready_slice_out  : std_logic;
  signal m3_araddr_slice_out  : std_logic_vector(63 downto 0);
  signal m3_arprot_slice_out  : std_logic_vector(2 downto 0);
  signal m3_arvalid_slice_out : std_logic;
  signal m3_arready_slice_in  : std_logic;
  signal m3_rdata_slice_in    : std_logic_vector(31 downto 0);
  signal m3_rresp_slice_in    : std_logic_vector(1 downto 0);
  signal m3_rvalid_slice_in   : std_logic;
  signal m3_rready_slice_out  : std_logic;

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
      m_axi_awaddr : OUT STD_LOGIC_VECTOR(383 DOWNTO 0);
      m_axi_awprot : OUT STD_LOGIC_VECTOR(17 DOWNTO 0);
      m_axi_awvalid : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
      m_axi_awready : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
      m_axi_wdata : OUT STD_LOGIC_VECTOR(191 DOWNTO 0);
      m_axi_wstrb : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
      m_axi_wvalid : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
      m_axi_wready : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
      m_axi_bresp : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
      m_axi_bvalid : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
      m_axi_bready : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
      m_axi_araddr : OUT STD_LOGIC_VECTOR(383 DOWNTO 0);
      m_axi_arprot : OUT STD_LOGIC_VECTOR(17 DOWNTO 0);
      m_axi_arvalid : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
      m_axi_arready : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
      m_axi_rdata : IN STD_LOGIC_VECTOR(191 DOWNTO 0);
      m_axi_rresp : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
      m_axi_rvalid : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
      m_axi_rready : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)
      );
  END COMPONENT;

  COMPONENT axi4lite_register_slice_0
    PORT (
      aclk : IN STD_LOGIC;
      aresetn : IN STD_LOGIC;
      s_axi_awaddr : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
      s_axi_awprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_awvalid : IN STD_LOGIC;
      s_axi_awready : OUT STD_LOGIC;
      s_axi_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      s_axi_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axi_wvalid : IN STD_LOGIC;
      s_axi_wready : OUT STD_LOGIC;
      s_axi_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      s_axi_bvalid : OUT STD_LOGIC;
      s_axi_bready : IN STD_LOGIC;
      s_axi_araddr : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
      s_axi_arprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      s_axi_arvalid : IN STD_LOGIC;
      s_axi_arready : OUT STD_LOGIC;
      s_axi_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      s_axi_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
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
  m0_axi_o.m0_axi_aresetn <= aresetn;
  m1_axi_o.m0_axi_aresetn <= aresetn;
  m2_axi_o.m0_axi_aresetn <= aresetn;
  m3_axi_o.m0_axi_aresetn <= aresetn;
  m4_axi_o.m0_axi_aresetn <= aresetn;
  m5_axi_o.m0_axi_aresetn <= aresetn;

  m0_axi_o.m0_axi_awaddr  <= To_StdULogicVector(m_axi_awaddr(63 downto 0));
  m1_axi_o.m0_axi_awaddr  <= To_StdULogicVector(m_axi_awaddr(127 downto 64));
  m2_axi_o.m0_axi_awaddr  <= To_StdULogicVector(m_axi_awaddr(191 downto 128));
  m3_awaddr_slice_in      <= m_axi_awaddr(255 downto 192);
  m3_axi_o.m0_axi_awaddr  <= To_StdULogicVector(m3_awaddr_slice_out);
  m4_axi_o.m0_axi_awaddr  <= To_StdULogicVector(m_axi_awaddr(319 downto 256));
  m5_axi_o.m0_axi_awaddr  <= To_StdULogicVector(m_axi_awaddr(383 downto 320));
  m0_axi_o.m0_axi_awprot  <= To_StdULogicVector(m_axi_awprot(2 downto 0));
  m1_axi_o.m0_axi_awprot  <= To_StdULogicVector(m_axi_awprot(5 downto 3));
  m2_axi_o.m0_axi_awprot  <= To_StdULogicVector(m_axi_awprot(8 downto 6));
  m3_awprot_slice_in      <= m_axi_awprot(11 downto 9);
  m3_axi_o.m0_axi_awprot  <= To_StdULogicVector(m3_awprot_slice_out);
  m4_axi_o.m0_axi_awprot  <= To_StdULogicVector(m_axi_awprot(14 downto 12));
  m5_axi_o.m0_axi_awprot  <= To_StdULogicVector(m_axi_awprot(17 downto 15));
  m0_axi_o.m0_axi_awvalid <= m_axi_awvalid(0);
  m1_axi_o.m0_axi_awvalid <= m_axi_awvalid(1);
  m2_axi_o.m0_axi_awvalid <= m_axi_awvalid(2);
  m3_awvalid_slice_in     <= m_axi_awvalid(3);
  m3_axi_o.m0_axi_awvalid <= m3_awvalid_slice_out;
  m4_axi_o.m0_axi_awvalid <= m_axi_awvalid(4);
  m5_axi_o.m0_axi_awvalid <= m_axi_awvalid(5);
  m_axi_awready(0)        <= m0_axi_i.m0_axi_awready;
  m_axi_awready(1)        <= m1_axi_i.m0_axi_awready;
  m_axi_awready(2)        <= m2_axi_i.m0_axi_awready;
  m3_awready_slice_in     <= m3_axi_i.m0_axi_awready;
  m_axi_awready(3)        <= m3_awready_slice_out;
  m_axi_awready(4)        <= m4_axi_i.m0_axi_awready;
  m_axi_awready(5)        <= m5_axi_i.m0_axi_awready;

  m0_axi_o.m0_axi_wdata  <= To_StdULogicVector(m_axi_wdata(31 downto 0));
  m1_axi_o.m0_axi_wdata  <= To_StdULogicVector(m_axi_wdata(63 downto 32));
  m2_axi_o.m0_axi_wdata  <= To_StdULogicVector(m_axi_wdata(95 downto 64));
  m3_wdata_slice_in      <= m_axi_wdata(127 downto 96);
  m3_axi_o.m0_axi_wdata  <= To_StdULogicVector(m3_wdata_slice_out);
  m4_axi_o.m0_axi_wdata  <= To_StdULogicVector(m_axi_wdata(159 downto 128));
  m5_axi_o.m0_axi_wdata  <= To_StdULogicVector(m_axi_wdata(191 downto 160));
  m0_axi_o.m0_axi_wstrb  <= To_StdULogicVector(m_axi_wstrb(3 downto 0));
  m1_axi_o.m0_axi_wstrb  <= To_StdULogicVector(m_axi_wstrb(7 downto 4));
  m2_axi_o.m0_axi_wstrb  <= To_StdULogicVector(m_axi_wstrb(11 downto 8));
  m3_wstrb_slice_in      <= m_axi_wstrb(15 downto 12);
  m3_axi_o.m0_axi_wstrb  <= To_StdULogicVector(m3_wstrb_slice_out);
  m4_axi_o.m0_axi_wstrb  <= To_StdULogicVector(m_axi_wstrb(19 downto 16));
  m5_axi_o.m0_axi_wstrb  <= To_StdULogicVector(m_axi_wstrb(23 downto 20));
  m0_axi_o.m0_axi_wvalid <= m_axi_wvalid(0);
  m1_axi_o.m0_axi_wvalid <= m_axi_wvalid(1);
  m2_axi_o.m0_axi_wvalid <= m_axi_wvalid(2);
  m3_wvalid_slice_in     <= m_axi_wvalid(3);
  m3_axi_o.m0_axi_wvalid <= m3_wvalid_slice_out;
  m4_axi_o.m0_axi_wvalid <= m_axi_wvalid(4);
  m5_axi_o.m0_axi_wvalid <= m_axi_wvalid(5);
  m_axi_wready(0)        <= m0_axi_i.m0_axi_wready;
  m_axi_wready(1)        <= m1_axi_i.m0_axi_wready;
  m_axi_wready(2)        <= m2_axi_i.m0_axi_wready;
  m3_wready_slice_in     <= m3_axi_i.m0_axi_wready;
  m_axi_wready(3)        <= m3_wready_slice_out;
  m_axi_wready(4)        <= m4_axi_i.m0_axi_wready;
  m_axi_wready(5)        <= m5_axi_i.m0_axi_wready;

  m_axi_bresp(1 downto 0)   <= To_StdLogicVector(m0_axi_i.m0_axi_bresp);
  m_axi_bresp(3 downto 2)   <= To_StdLogicVector(m1_axi_i.m0_axi_bresp);
  m_axi_bresp(5 downto 4)   <= To_StdLogicVector(m2_axi_i.m0_axi_bresp);
  m3_bresp_slice_in         <= To_StdLogicVector(m3_axi_i.m0_axi_bresp);
  m_axi_bresp(7 downto 6)   <= m3_bresp_slice_out;
  m_axi_bresp(9 downto 8)   <= To_StdLogicVector(m4_axi_i.m0_axi_bresp);
  m_axi_bresp(11 downto 10) <= To_StdLogicVector(m5_axi_i.m0_axi_bresp);
  m_axi_bvalid(0)           <= m0_axi_i.m0_axi_bvalid;
  m_axi_bvalid(1)           <= m1_axi_i.m0_axi_bvalid;
  m_axi_bvalid(2)           <= m2_axi_i.m0_axi_bvalid;
  m3_bvalid_slice_in        <= m3_axi_i.m0_axi_bvalid;
  m_axi_bvalid(3)           <= m3_bvalid_slice_out;
  m_axi_bvalid(4)           <= m4_axi_i.m0_axi_bvalid;
  m_axi_bvalid(5)           <= m5_axi_i.m0_axi_bvalid;
  m0_axi_o.m0_axi_bready    <= m_axi_bready(0);
  m1_axi_o.m0_axi_bready    <= m_axi_bready(1);
  m2_axi_o.m0_axi_bready    <= m_axi_bready(2);
  m3_bready_slice_in        <= m_axi_bready(3);
  m3_axi_o.m0_axi_bready    <= m3_bready_slice_out;
  m4_axi_o.m0_axi_bready    <= m_axi_bready(4);
  m5_axi_o.m0_axi_bready    <= m_axi_bready(5);

  m0_axi_o.m0_axi_araddr  <= To_StdULogicVector(m_axi_araddr(63 downto 0));
  m1_axi_o.m0_axi_araddr  <= To_StdULogicVector(m_axi_araddr(127 downto 64));
  m2_axi_o.m0_axi_araddr  <= To_StdULogicVector(m_axi_araddr(191 downto 128));
  m3_araddr_slice_in      <= m_axi_araddr(255 downto 192);
  m3_axi_o.m0_axi_araddr  <= To_StdULogicVector(m3_araddr_slice_out);
  m4_axi_o.m0_axi_araddr  <= To_StdULogicVector(m_axi_araddr(319 downto 256));
  m5_axi_o.m0_axi_araddr  <= To_StdULogicVector(m_axi_araddr(383 downto 320));
  m0_axi_o.m0_axi_arprot  <= To_StdULogicVector(m_axi_arprot(2 downto 0));
  m1_axi_o.m0_axi_arprot  <= To_StdULogicVector(m_axi_arprot(5 downto 3));
  m2_axi_o.m0_axi_arprot  <= To_StdULogicVector(m_axi_arprot(8 downto 6));
  m3_arprot_slice_in      <= m_axi_arprot(11 downto 9);
  m3_axi_o.m0_axi_arprot  <= To_StdULogicVector(m3_arprot_slice_out);
  m4_axi_o.m0_axi_arprot  <= To_StdULogicVector(m_axi_arprot(14 downto 12));
  m5_axi_o.m0_axi_arprot  <= To_StdULogicVector(m_axi_arprot(17 downto 15));
  m0_axi_o.m0_axi_arvalid <= m_axi_arvalid(0);
  m1_axi_o.m0_axi_arvalid <= m_axi_arvalid(1);
  m2_axi_o.m0_axi_arvalid <= m_axi_arvalid(2);
  m3_arvalid_slice_in     <= m_axi_arvalid(3);
  m3_axi_o.m0_axi_arvalid <= m3_arvalid_slice_out;
  m4_axi_o.m0_axi_arvalid <= m_axi_arvalid(4);
  m5_axi_o.m0_axi_arvalid <= m_axi_arvalid(5);
  m_axi_arready(0)        <= m0_axi_i.m0_axi_arready;
  m_axi_arready(1)        <= m1_axi_i.m0_axi_arready;
  m_axi_arready(2)        <= m2_axi_i.m0_axi_arready;
  m3_arready_slice_in     <= m3_axi_i.m0_axi_arready;
  m_axi_arready(3)        <= m3_arready_slice_out;
  m_axi_arready(4)        <= m4_axi_i.m0_axi_arready;
  m_axi_arready(5)        <= m5_axi_i.m0_axi_arready;

  m_axi_rdata(31 downto 0)    <= To_StdLogicVector(m0_axi_i.m0_axi_rdata);
  m_axi_rdata(63 downto 32)   <= To_StdLogicVector(m1_axi_i.m0_axi_rdata);
  m_axi_rdata(95 downto 64)   <= To_StdLogicVector(m2_axi_i.m0_axi_rdata);
  m3_rdata_slice_in           <= To_StdLogicVector(m3_axi_i.m0_axi_rdata);
  m_axi_rdata(127 downto 96)  <= m3_rdata_slice_out;
  m_axi_rdata(159 downto 128) <= To_StdLogicVector(m4_axi_i.m0_axi_rdata);
  m_axi_rdata(191 downto 160) <= To_StdLogicVector(m5_axi_i.m0_axi_rdata);
  m_axi_rresp(1 downto 0)     <= To_StdLogicVector(m0_axi_i.m0_axi_rresp);
  m_axi_rresp(3 downto 2)     <= To_StdLogicVector(m1_axi_i.m0_axi_rresp);
  m_axi_rresp(5 downto 4)     <= To_StdLogicVector(m2_axi_i.m0_axi_rresp);
  m3_rresp_slice_in           <= To_StdLogicVector(m3_axi_i.m0_axi_rresp);
  m_axi_rresp(7 downto 6)     <= m3_rresp_slice_out;
  m_axi_rresp(9 downto 8)     <= To_StdLogicVector(m4_axi_i.m0_axi_rresp);
  m_axi_rresp(11 downto 10)   <= To_StdLogicVector(m5_axi_i.m0_axi_rresp);
  m_axi_rvalid(0)             <= m0_axi_i.m0_axi_rvalid;
  m_axi_rvalid(1)             <= m1_axi_i.m0_axi_rvalid;
  m_axi_rvalid(2)             <= m2_axi_i.m0_axi_rvalid;
  m3_rvalid_slice_in          <= m3_axi_i.m0_axi_rvalid;
  m_axi_rvalid(3)             <= m3_rvalid_slice_out;
  m_axi_rvalid(4)             <= m4_axi_i.m0_axi_rvalid;
  m_axi_rvalid(5)             <= m5_axi_i.m0_axi_rvalid;
  m0_axi_o.m0_axi_rready      <= m_axi_rready(0);
  m1_axi_o.m0_axi_rready      <= m_axi_rready(1);
  m2_axi_o.m0_axi_rready      <= m_axi_rready(2);
  m3_rready_slice_in          <= m_axi_rready(3);
  m3_axi_o.m0_axi_rready      <= m3_rready_slice_out;
  m4_axi_o.m0_axi_rready      <= m_axi_rready(4);
  m5_axi_o.m0_axi_rready      <= m_axi_rready(5);

  m3_register_slice : axi4lite_register_slice_0
    PORT MAP (
      aclk => aclk,
      aresetn => aresetn,
      s_axi_awaddr => m3_awaddr_slice_in,
      s_axi_awprot => m3_awprot_slice_out,
      s_axi_awvalid => m3_awvalid_slice_in,
      s_axi_awready => m3_awready_slice_out,
      s_axi_wdata => m3_wdata_slice_in,
      s_axi_wstrb => m3_wstrb_slice_in,
      s_axi_wvalid => m3_wvalid_slice_in,
      s_axi_wready => m3_wready_slice_out,
      s_axi_bresp => m3_bresp_slice_out,
      s_axi_bvalid => m3_bvalid_slice_out,
      s_axi_bready => m3_bready_slice_in,
      s_axi_araddr => m3_araddr_slice_in,
      s_axi_arprot => m3_arprot_slice_in,
      s_axi_arvalid => m3_arvalid_slice_in,
      s_axi_arready => m3_arready_slice_out,
      s_axi_rdata => m3_rdata_slice_out,
      s_axi_rresp => m3_rresp_slice_out,
      s_axi_rvalid => m3_rvalid_slice_out,
      s_axi_rready => m3_rready_slice_out,
      m_axi_awaddr => m3_awaddr_slice_out,
      m_axi_awprot => m3_awprot_slice_out,
      m_axi_awvalid => m3_awvalid_slice_out,
      m_axi_awready => m3_awready_slice_in,
      m_axi_wdata => m3_wdata_slice_out,
      m_axi_wstrb => m3_wstrb_slice_out,
      m_axi_wvalid => m3_wvalid_slice_out,
      m_axi_wready => m3_wready_slice_in,
      m_axi_bresp => m3_bresp_slice_in,
      m_axi_bvalid => m3_bvalid_slice_in,
      m_axi_bready => m3_bready_slice_out,
      m_axi_araddr => m3_araddr_slice_out,
      m_axi_arprot => m3_arprot_slice_out,
      m_axi_arvalid => m3_arvalid_slice_out,
      m_axi_arready => m3_arready_slice_in,
      m_axi_rdata => m3_rdata_slice_in,
      m_axi_rresp => m3_rresp_slice_in,
      m_axi_rvalid => m3_rvalid_slice_in,
      m_axi_rready => m3_rready_slice_out
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

end axi4lite_crossbar_top;
