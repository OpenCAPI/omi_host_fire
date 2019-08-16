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

-- Convert a 7 bit AXI id to a 1 bit AXI id. We do this by zeroing out
-- id bits 6 downto 1, and storing these bits in a register here to be
-- appended on responses. This is allowed because at this point in the
-- link we are guaranteed that the slave downstream won't accept a
-- repeat ID, and we don't latch the AXI path at all.  If this wasn't
-- the case, this logic wouldn't work.

-- This design also assumes that the awid and wid transactions will
-- happen in the same order. If they don't, then we'll incorrectly
-- link them together if the LSB bits match (for example, if awid = 0
-- and wid = 8, we'll treat them as if they are part of the same
-- transaction. This is a correct assumption in AXI4, but not in AXI3.

library ieee, work, ibm;
  use ieee.std_logic_1164.all;
  use work.axi_pkg.all;
  use ibm.std_ulogic_support.all;
  use ibm.std_ulogic_function_support.all;

entity axi_width_converter is
  port (
    s0_axi_aclk                    : in std_ulogic;
    s0_axi_i_a                     : in t_AXI3_SLAVE_INPUT;
    s0_axi_i_b                     : out t_AXI3_SLAVE_INPUT;
    s0_axi_o_a                     : out t_AXI3_SLAVE_OUTPUT;
    s0_axi_o_b                     : in t_AXI3_SLAVE_OUTPUT
    );
end axi_width_converter;

architecture axi_width_converter of axi_width_converter is

  signal awid0_msb_d : std_ulogic_vector(6 downto 1);
  signal awid1_msb_d : std_ulogic_vector(6 downto 1);
  signal awid0_msb_q : std_ulogic_vector(6 downto 1);
  signal awid1_msb_q : std_ulogic_vector(6 downto 1);

  signal wid0_msb_d : std_ulogic_vector(6 downto 1);
  signal wid1_msb_d : std_ulogic_vector(6 downto 1);
  signal wid0_msb_q : std_ulogic_vector(6 downto 1);
  signal wid1_msb_q : std_ulogic_vector(6 downto 1);

  signal bid_sel : std_ulogic_vector(6 downto 1);

  signal arid0_msb_d : std_ulogic_vector(6 downto 1);
  signal arid1_msb_d : std_ulogic_vector(6 downto 1);
  signal arid0_msb_q : std_ulogic_vector(6 downto 1);
  signal arid1_msb_q : std_ulogic_vector(6 downto 1);

  signal rid_sel : std_ulogic_vector(6 downto 1);

begin

  -- Downstream Connections
  s0_axi_i_b.s0_axi_aresetn <= s0_axi_i_a.s0_axi_aresetn;
  s0_axi_i_b.s0_axi_awid    <= "000000" & s0_axi_i_a.s0_axi_awid(0 downto 0);
  s0_axi_i_b.s0_axi_awaddr  <= s0_axi_i_a.s0_axi_awaddr;
  s0_axi_i_b.s0_axi_awlen   <= s0_axi_i_a.s0_axi_awlen;
  s0_axi_i_b.s0_axi_awsize  <= s0_axi_i_a.s0_axi_awsize;
  s0_axi_i_b.s0_axi_awburst <= s0_axi_i_a.s0_axi_awburst;
  s0_axi_i_b.s0_axi_awlock  <= s0_axi_i_a.s0_axi_awlock;
  s0_axi_i_b.s0_axi_awcache <= s0_axi_i_a.s0_axi_awcache;
  s0_axi_i_b.s0_axi_awprot  <= s0_axi_i_a.s0_axi_awprot;
  s0_axi_i_b.s0_axi_awvalid <= s0_axi_i_a.s0_axi_awvalid;
  s0_axi_i_b.s0_axi_wid     <= "000000" & s0_axi_i_a.s0_axi_wid(0 downto 0);
  s0_axi_i_b.s0_axi_wdata   <= s0_axi_i_a.s0_axi_wdata;
  s0_axi_i_b.s0_axi_wstrb   <= s0_axi_i_a.s0_axi_wstrb;
  s0_axi_i_b.s0_axi_wlast   <= s0_axi_i_a.s0_axi_wlast;
  s0_axi_i_b.s0_axi_wvalid  <= s0_axi_i_a.s0_axi_wvalid;
  s0_axi_i_b.s0_axi_bready  <= s0_axi_i_a.s0_axi_bready;
  s0_axi_i_b.s0_axi_arid    <= "000000" & s0_axi_i_a.s0_axi_arid(0 downto 0);
  s0_axi_i_b.s0_axi_araddr  <= s0_axi_i_a.s0_axi_araddr;
  s0_axi_i_b.s0_axi_arlen   <= s0_axi_i_a.s0_axi_arlen;
  s0_axi_i_b.s0_axi_arsize  <= s0_axi_i_a.s0_axi_arsize;
  s0_axi_i_b.s0_axi_arburst <= s0_axi_i_a.s0_axi_arburst;
  s0_axi_i_b.s0_axi_arlock  <= s0_axi_i_a.s0_axi_arlock;
  s0_axi_i_b.s0_axi_arcache <= s0_axi_i_a.s0_axi_arcache;
  s0_axi_i_b.s0_axi_arprot  <= s0_axi_i_a.s0_axi_arprot;
  s0_axi_i_b.s0_axi_arvalid <= s0_axi_i_a.s0_axi_arvalid;
  s0_axi_i_b.s0_axi_rready  <= s0_axi_i_a.s0_axi_rready;

  -- Upstream Connections
  s0_axi_o_a.s0_axi_awready <= s0_axi_o_b.s0_axi_awready;
  s0_axi_o_a.s0_axi_wready  <= s0_axi_o_b.s0_axi_wready;
  s0_axi_o_a.s0_axi_bid     <= bid_sel & s0_axi_o_b.s0_axi_bid(0 downto 0);
  s0_axi_o_a.s0_axi_bresp   <= s0_axi_o_b.s0_axi_bresp;
  s0_axi_o_a.s0_axi_bvalid  <= s0_axi_o_b.s0_axi_bvalid;
  s0_axi_o_a.s0_axi_arready <= s0_axi_o_b.s0_axi_arready;
  s0_axi_o_a.s0_axi_rid     <= rid_sel & s0_axi_o_b.s0_axi_rid(0 downto 0);
  s0_axi_o_a.s0_axi_rdata   <= s0_axi_o_b.s0_axi_rdata;
  s0_axi_o_a.s0_axi_rresp   <= s0_axi_o_b.s0_axi_rresp;
  s0_axi_o_a.s0_axi_rlast   <= s0_axi_o_b.s0_axi_rlast;
  s0_axi_o_a.s0_axi_rvalid  <= s0_axi_o_b.s0_axi_rvalid;

  -- Write Address
  awid0_msb_d <= gate(s0_axi_i_a.s0_axi_awid(6 downto 1),     (s0_axi_i_a.s0_axi_awvalid and s0_axi_o_b.s0_axi_awready and s0_axi_i_a.s0_axi_awid(0 downto 0) = "0")) or
                 gate(awid0_msb_q,                        not (s0_axi_i_a.s0_axi_awvalid and s0_axi_o_b.s0_axi_awready and s0_axi_i_a.s0_axi_awid(0 downto 0) = "0"));
  awid1_msb_d <= gate(s0_axi_i_a.s0_axi_awid(6 downto 1),     (s0_axi_i_a.s0_axi_awvalid and s0_axi_o_b.s0_axi_awready and s0_axi_i_a.s0_axi_awid(0 downto 0) = "1")) or
                 gate(awid1_msb_q,                        not (s0_axi_i_a.s0_axi_awvalid and s0_axi_o_b.s0_axi_awready and s0_axi_i_a.s0_axi_awid(0 downto 0) = "1"));

  -- Write Data
  wid0_msb_d <= gate(s0_axi_i_a.s0_axi_wid(6 downto 1),     (s0_axi_i_a.s0_axi_wvalid and s0_axi_o_b.s0_axi_wready and s0_axi_i_a.s0_axi_wid(0 downto 0) = "0")) or
                gate(wid0_msb_q,                        not (s0_axi_i_a.s0_axi_wvalid and s0_axi_o_b.s0_axi_wready and s0_axi_i_a.s0_axi_wid(0 downto 0) = "0"));
  wid1_msb_d <= gate(s0_axi_i_a.s0_axi_wid(6 downto 1),     (s0_axi_i_a.s0_axi_wvalid and s0_axi_o_b.s0_axi_wready and s0_axi_i_a.s0_axi_wid(0 downto 0) = "1")) or
                gate(wid1_msb_q,                        not (s0_axi_i_a.s0_axi_wvalid and s0_axi_o_b.s0_axi_wready and s0_axi_i_a.s0_axi_wid(0 downto 0) = "1"));

  -- Write Response
  -- No error response if awid*_msb_q and wid*_msb_q don't match
  bid_sel <= gate(awid0_msb_q, s0_axi_o_b.s0_axi_bid(0 downto 0) = "0") or
             gate(awid1_msb_q, s0_axi_o_b.s0_axi_bid(0 downto 0) = "1");

  -- Read Address
  arid0_msb_d <= gate(s0_axi_i_a.s0_axi_arid(6 downto 1),     (s0_axi_i_a.s0_axi_arvalid and s0_axi_o_b.s0_axi_arready and s0_axi_i_a.s0_axi_arid(0 downto 0) = "0")) or
                 gate(arid0_msb_q,                        not (s0_axi_i_a.s0_axi_arvalid and s0_axi_o_b.s0_axi_arready and s0_axi_i_a.s0_axi_arid(0 downto 0) = "0"));
  arid1_msb_d <= gate(s0_axi_i_a.s0_axi_arid(6 downto 1),     (s0_axi_i_a.s0_axi_arvalid and s0_axi_o_b.s0_axi_arready and s0_axi_i_a.s0_axi_arid(0 downto 0) = "1")) or
                 gate(arid1_msb_q,                        not (s0_axi_i_a.s0_axi_arvalid and s0_axi_o_b.s0_axi_arready and s0_axi_i_a.s0_axi_arid(0 downto 0) = "1"));

  -- Read Data
  rid_sel <= gate(arid0_msb_q, s0_axi_o_b.s0_axi_rid(0 downto 0) = "0") or
             gate(arid1_msb_q, s0_axi_o_b.s0_axi_rid(0 downto 0) = "1");

  process (s0_axi_aclk)
  begin
    if s0_axi_aclk'event and s0_axi_aclk = '1' then
      awid0_msb_q <= awid0_msb_d;
      awid1_msb_q <= awid1_msb_d;
      wid0_msb_q  <= wid0_msb_d;
      wid1_msb_q  <= wid1_msb_d;
      arid0_msb_q <= arid0_msb_d;
      arid1_msb_q <= arid1_msb_d;
    end if;
  end process;

end axi_width_converter;
