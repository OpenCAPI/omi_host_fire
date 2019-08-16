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

entity axi_64_32_width_converter is
  port (
    sysclk         : in  std_ulogic;
    sys_resetn     : in  std_ulogic;
    s0_axi_i       : in  t_AXI3_64_SLAVE_INPUT;
    s0_axi_o       : out t_AXI3_64_SLAVE_OUTPUT;
    m0_axi_i       : in  t_AXI3_MASTER_INPUT;
    m0_axi_o       : out t_AXI3_MASTER_OUTPUT
  );
end axi_64_32_width_converter;

architecture axi_64_32_width_converter of axi_64_32_width_converter is

  signal s0_axi_i_arsaved_q : t_AXI3_64_SLAVE_INPUT;
  signal s0_axi_i_awsaved_q : t_AXI3_64_SLAVE_INPUT;
  signal s0_axi_i_wsaved_q  : t_AXI3_64_SLAVE_INPUT;
  signal m0_axi_i_r0saved_q : t_AXI3_MASTER_INPUT;
  signal m0_axi_i_r1saved_q : t_AXI3_MASTER_INPUT;
  signal m0_axi_i_bsaved_q  : t_AXI3_MASTER_INPUT;
  signal read_64            : std_ulogic;
  signal write_64           : std_ulogic;

  type ST_CONTROL is (
    ST_CONTROL_IDLE,                    -- 0
    ST_CONTROL_SEND_ARVALID,            -- 1
    ST_CONTROL_WAIT_FOR_RVALID_0,       -- 2
    ST_CONTROL_WAIT_FOR_RVALID_1,       -- 3
    ST_CONTROL_SEND_RVALID,             -- 4
    ST_CONTROL_WAIT_FOR_WVALID,         -- 5
    ST_CONTROL_SEND_AWVALID,            -- 6
    ST_CONTROL_SEND_WVALID_0,           -- 7
    ST_CONTROL_SEND_WVALID_1,           -- 8
    ST_CONTROL_WAIT_FOR_BVALID,         -- 9
    ST_CONTROL_SEND_BVALID,             -- 10
    ST_CONTROL_ERROR                    -- 11
  );

  signal control_state : ST_CONTROL := ST_CONTROL_IDLE;

  attribute mark_debug : string;
  attribute keep       : string;

  attribute mark_debug of control_state : signal is "true";
  attribute mark_debug of read_64       : signal is "true";
  attribute mark_debug of write_64      : signal is "true";

begin

  -- Upstream
  s0_axi_o.s0_axi_awready <= '1' when (control_state = ST_CONTROL_IDLE)            else '0';
  s0_axi_o.s0_axi_wready  <= '1' when (control_state = ST_CONTROL_WAIT_FOR_WVALID) else '0';
  s0_axi_o.s0_axi_bid(0)  <= m0_axi_i_bsaved_q.m0_axi_bid(0);
  s0_axi_o.s0_axi_bresp   <= m0_axi_i_bsaved_q.m0_axi_bresp;
  s0_axi_o.s0_axi_bvalid  <= '1' when (control_state = ST_CONTROL_SEND_BVALID)     else '0';
  s0_axi_o.s0_axi_arready <= '1' when (control_state = ST_CONTROL_IDLE)            else '0';
  s0_axi_o.s0_axi_rid(0)  <= m0_axi_i_r0saved_q.m0_axi_rid(0);
  s0_axi_o.s0_axi_rdata   <= m0_axi_i_r0saved_q.m0_axi_rdata & m0_axi_i_r1saved_q.m0_axi_rdata when (read_64 = '1') else
                             m0_axi_i_r0saved_q.m0_axi_rdata & m0_axi_i_r0saved_q.m0_axi_rdata;
  s0_axi_o.s0_axi_rresp   <= m0_axi_i_r0saved_q.m0_axi_rresp;
  s0_axi_o.s0_axi_rlast   <= '1';
  s0_axi_o.s0_axi_rvalid  <= '1' when (control_state = ST_CONTROL_SEND_RVALID)     else '0';

  -- Downstream
  m0_axi_o.m0_axi_aresetn <= s0_axi_i.s0_axi_aresetn;
  m0_axi_o.m0_axi_awid    <= "000000" & s0_axi_i_awsaved_q.s0_axi_awid;
  m0_axi_o.m0_axi_awaddr  <= s0_axi_i_awsaved_q.s0_axi_awaddr;
  m0_axi_o.m0_axi_awlen   <= "0001" when (write_64 = '1') else
                             "0000";
  m0_axi_o.m0_axi_awsize  <= "010";
  m0_axi_o.m0_axi_awburst <= s0_axi_i_awsaved_q.s0_axi_awburst;
  m0_axi_o.m0_axi_awlock  <= s0_axi_i_awsaved_q.s0_axi_awlock;
  m0_axi_o.m0_axi_awcache <= s0_axi_i_awsaved_q.s0_axi_awcache;
  m0_axi_o.m0_axi_awprot  <= s0_axi_i_awsaved_q.s0_axi_awprot;
  m0_axi_o.m0_axi_awvalid <= '1' when (control_state = ST_CONTROL_SEND_AWVALID)    else '0';
  m0_axi_o.m0_axi_wid     <= "000000" & s0_axi_i_wsaved_q.s0_axi_wid;
  m0_axi_o.m0_axi_wdata   <= s0_axi_i_wsaved_q.s0_axi_wdata(63 downto 32) when (control_state = ST_CONTROL_SEND_WVALID_0) and (write_64 = '1') else
                             s0_axi_i_wsaved_q.s0_axi_wdata(31 downto 0);
  m0_axi_o.m0_axi_wstrb   <= s0_axi_i_wsaved_q.s0_axi_wstrb(7 downto 4) when (control_state = ST_CONTROL_SEND_WVALID_0) else
                             s0_axi_i_wsaved_q.s0_axi_wstrb(3 downto 0);
  m0_axi_o.m0_axi_wlast   <= '1' when (control_state = ST_CONTROL_SEND_WVALID_1)                    else
                             '1' when (control_state = ST_CONTROL_SEND_WVALID_0 and write_64 = '0') else
                             '0';
  m0_axi_o.m0_axi_wvalid  <= '1' when (control_state = ST_CONTROL_SEND_WVALID_0) or
                                      (control_state = ST_CONTROL_SEND_WVALID_1)   else '0';
  m0_axi_o.m0_axi_bready  <= '1' when (control_state = ST_CONTROL_WAIT_FOR_BVALID) else '0';
  m0_axi_o.m0_axi_arid    <= "000000" & s0_axi_i_arsaved_q.s0_axi_arid;
  m0_axi_o.m0_axi_araddr  <= s0_axi_i_arsaved_q.s0_axi_araddr;
  m0_axi_o.m0_axi_arlen   <= "0001" when (read_64 = '1') else
                             "0000";
  m0_axi_o.m0_axi_arsize  <= "010";
  m0_axi_o.m0_axi_arburst <= s0_axi_i_arsaved_q.s0_axi_arburst;
  m0_axi_o.m0_axi_arlock  <= s0_axi_i_arsaved_q.s0_axi_arlock;
  m0_axi_o.m0_axi_arcache <= s0_axi_i_arsaved_q.s0_axi_arcache;
  m0_axi_o.m0_axi_arprot  <= s0_axi_i_arsaved_q.s0_axi_arprot;
  m0_axi_o.m0_axi_arvalid <= '1' when (control_state = ST_CONTROL_SEND_ARVALID)    else '0';
  m0_axi_o.m0_axi_rready  <= '1' when (control_state = ST_CONTROL_WAIT_FOR_RVALID_0) or
                             (control_state = ST_CONTROL_WAIT_FOR_RVALID_1)        else '0';

  read_64  <= '1' when (s0_axi_i_arsaved_q.s0_axi_arsize = "011") else '0';
  write_64 <= '1' when (s0_axi_i_awsaved_q.s0_axi_awsize = "011") else '0';

  process (sysclk) is
  begin
    if rising_edge(sysclk) then
      if (sys_resetn = '0') then
        control_state    <= ST_CONTROL_IDLE;

      else
        -- CONTROL STATE MACHINE
        case control_state is
          when ST_CONTROL_IDLE =>
            if (s0_axi_i.s0_axi_arvalid = '1') then
              s0_axi_i_arsaved_q <= s0_axi_i;
              control_state      <= ST_CONTROL_SEND_ARVALID;
            elsif (s0_axi_i.s0_axi_awvalid = '1') then
              s0_axi_i_awsaved_q <= s0_axi_i;
              control_state      <= ST_CONTROL_WAIT_FOR_WVALID;
            else
              control_state      <= ST_CONTROL_IDLE;
            end if;
          when ST_CONTROL_SEND_ARVALID =>
            if (m0_axi_i.m0_axi_arready = '1') then
              control_state      <= ST_CONTROL_WAIT_FOR_RVALID_0;
            else
              control_state      <= ST_CONTROL_SEND_ARVALID;
            end if;
          when ST_CONTROL_WAIT_FOR_RVALID_0 =>
            if (m0_axi_i.m0_axi_rvalid = '1') then
              m0_axi_i_r0saved_q <= m0_axi_i;
              if (read_64 = '1') then
                control_state    <= ST_CONTROL_WAIT_FOR_RVALID_1;
              else
                control_state    <= ST_CONTROL_SEND_RVALID;
              end if;
            else
              control_state      <= ST_CONTROL_WAIT_FOR_RVALID_0;
            end if;
          when ST_CONTROL_WAIT_FOR_RVALID_1 =>
            if (m0_axi_i.m0_axi_rvalid = '1') then
              m0_axi_i_r1saved_q <= m0_axi_i;
              control_state      <= ST_CONTROL_SEND_RVALID;
            else
              control_state      <= ST_CONTROL_WAIT_FOR_RVALID_1;
            end if;
          when ST_CONTROL_SEND_RVALID =>
            if (s0_axi_i.s0_axi_rready = '1') then
              control_state      <= ST_CONTROL_IDLE;
            else
              control_state      <= ST_CONTROL_SEND_RVALID;
            end if;
          when ST_CONTROL_WAIT_FOR_WVALID =>
            if (s0_axi_i.s0_axi_wvalid = '1') then
              s0_axi_i_wsaved_q  <= s0_axi_i;
              control_state      <= ST_CONTROL_SEND_AWVALID;
            else
              control_state      <= ST_CONTROL_WAIT_FOR_WVALID;
            end if;
          when ST_CONTROL_SEND_AWVALID =>
            if (m0_axi_i.m0_axi_awready = '1') then
              control_state      <= ST_CONTROL_SEND_WVALID_0;
            else
              control_state      <= ST_CONTROL_SEND_AWVALID;
            end if;
          when ST_CONTROL_SEND_WVALID_0 =>
            if (m0_axi_i.m0_axi_wready = '1') then
              if (write_64 = '1') then
                control_state    <= ST_CONTROL_SEND_WVALID_1;
              else
                control_state    <= ST_CONTROL_WAIT_FOR_BVALID;
              end if;
            else
              control_state      <= ST_CONTROL_SEND_WVALID_0;
            end if;
          when ST_CONTROL_SEND_WVALID_1 =>
            if (m0_axi_i.m0_axi_wready = '1') then
              control_state      <= ST_CONTROL_WAIT_FOR_BVALID;
            else
              control_state      <= ST_CONTROL_SEND_WVALID_1;
            end if;
          when ST_CONTROL_WAIT_FOR_BVALID =>
            if (m0_axi_i.m0_axi_bvalid = '1') then
              m0_axi_i_bsaved_q  <= m0_axi_i;
              control_state      <= ST_CONTROL_SEND_BVALID;
            else
              control_state      <= ST_CONTROL_WAIT_FOR_BVALID;
            end if;
          when ST_CONTROL_SEND_BVALID =>
            if (s0_axi_i.s0_axi_bready = '1') then
              control_state      <= ST_CONTROL_IDLE;
            else
              control_state      <= ST_CONTROL_SEND_BVALID;
            end if;
          when others =>
            control_state        <= ST_CONTROL_ERROR;
        end case;
      end if;
    end if;
  end process;

end axi_64_32_width_converter;
