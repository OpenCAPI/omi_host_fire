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

-- Implements a synchronous crossing for AXI3 using a synchronous FIFO
-- for each channel. Assuming side A is the master and side B is the
-- slave.
--
--     i_a --> i_b
--
--     o_a <-- o_b

library ieee, work, ibm;
  use ieee.std_logic_1164.all;
  use work.axi_pkg.all;
  use ibm.std_ulogic_function_support.all;

entity axi_sync is
  port (
    s0_axi_aclk                    : in std_ulogic;
    s0_axi_i_a                     : in t_AXI4_LITE_SLAVE_INPUT;
    s0_axi_i_b                     : out t_AXI4_LITE_SLAVE_INPUT;
    s0_axi_o_a                     : out t_AXI4_LITE_SLAVE_OUTPUT;
    s0_axi_o_b                     : in t_AXI4_LITE_SLAVE_OUTPUT
    );
end axi_sync;

architecture axi_sync of axi_sync is

  SIGNAL write_address_fifo_wr_data : std_ulogic_vector(95 downto 0);
  SIGNAL write_address_fifo_rd_data : std_ulogic_vector(95 downto 0);
  SIGNAL write_data_fifo_wr_data : std_ulogic_vector(63 downto 0);
  SIGNAL write_data_fifo_rd_data : std_ulogic_vector(63 downto 0);
  SIGNAL write_response_fifo_wr_data : std_ulogic_vector(31 downto 0);
  SIGNAL write_response_fifo_rd_data : std_ulogic_vector(31 downto 0);
  SIGNAL read_address_fifo_wr_data : std_ulogic_vector(95 downto 0);
  SIGNAL read_address_fifo_rd_data : std_ulogic_vector(95 downto 0);
  SIGNAL read_data_fifo_wr_data : std_ulogic_vector(63 downto 0);
  SIGNAL read_data_fifo_rd_data : std_ulogic_vector(63 downto 0);

  SIGNAL write_address_pad : std_ulogic_vector(28 downto 0);
  SIGNAL write_address_pad_unused : std_ulogic_vector(28 downto 0);
  SIGNAL write_data_pad : std_ulogic_vector(27 downto 0);
  SIGNAL write_data_pad_unused : std_ulogic_vector(27 downto 0);
  SIGNAL read_address_pad : std_ulogic_vector(28 downto 0);
  SIGNAL read_address_pad_unused : std_ulogic_vector(28 downto 0);
  SIGNAL write_response_pad : std_ulogic_vector(29 downto 0);
  SIGNAL write_response_pad_unused : std_ulogic_vector(29 downto 0);
  SIGNAL read_data_pad : std_ulogic_vector(29 downto 0);
  SIGNAL read_data_pad_unused : std_ulogic_vector(29 downto 0);

  SIGNAL write_address_fifo_wr : std_ulogic;
  SIGNAL write_data_fifo_wr : std_ulogic;
  SIGNAL read_address_fifo_wr : std_ulogic;
  SIGNAL write_response_fifo_wr : std_ulogic;
  SIGNAL read_data_fifo_wr : std_ulogic;

  SIGNAL write_address_fifo_rd : std_ulogic;
  SIGNAL write_data_fifo_rd : std_ulogic;
  SIGNAL read_address_fifo_rd : std_ulogic;
  SIGNAL write_response_fifo_rd : std_ulogic;
  SIGNAL read_data_fifo_rd : std_ulogic;

  SIGNAL write_address_fifo_full : std_ulogic;
  SIGNAL write_data_fifo_full : std_ulogic;
  SIGNAL read_address_fifo_full : std_ulogic;
  SIGNAL write_response_fifo_full : std_ulogic;
  SIGNAL read_data_fifo_full : std_ulogic;
  SIGNAL write_address_fifo_empty : std_ulogic;
  SIGNAL write_data_fifo_empty : std_ulogic;
  SIGNAL read_address_fifo_empty : std_ulogic;
  SIGNAL write_response_fifo_empty : std_ulogic;
  SIGNAL read_data_fifo_empty : std_ulogic;

  SIGNAL palladium_shift_address_right_2 : std_ulogic;

begin

  -- This is set hierarchially in Palladium to deal with the fact that
  -- we made the addressing in C3S confusing and increment by 1. The MIPS deals
  -- with byte aligned addresses.
  palladium_shift_address_right_2 <= '0';

  -- TODO synchronize s0_axi_aresetn
  s0_axi_i_b.s0_axi_aresetn <= s0_axi_i_a.s0_axi_aresetn;

  -- Explicitly assign these to signals to make sure we don't misalign
  -- the wr/rd assignments if we edit this in the future. Padding is
  -- in here because the width of the BRAMs needs to be a multiple of
  -- 32.
  write_address_pad  <= "00000000000000000000000000000";
  write_data_pad     <= "0000000000000000000000000000";
  read_address_pad   <= "00000000000000000000000000000";
  write_response_pad <= "000000000000000000000000000000";
  read_data_pad      <= "000000000000000000000000000000";

  -- Downstream
  write_address_fifo_wr_data <=
    (gate("00" & s0_axi_i_a.s0_axi_awaddr(63 downto 2),     palladium_shift_address_right_2) or
     gate(s0_axi_i_a.s0_axi_awaddr,                     not palladium_shift_address_right_2)) &
    s0_axi_i_a.s0_axi_awprot  &
    write_address_pad;

  write_data_fifo_wr_data <=
    s0_axi_i_a.s0_axi_wdata &
    s0_axi_i_a.s0_axi_wstrb &
    write_data_pad;

  read_address_fifo_wr_data <=
    (gate("00" & s0_axi_i_a.s0_axi_araddr(63 downto 2),     palladium_shift_address_right_2) or
     gate(s0_axi_i_a.s0_axi_araddr,                     not palladium_shift_address_right_2)) &
    s0_axi_i_a.s0_axi_arprot  &
    read_address_pad;

  -- Upstream
  write_response_fifo_wr_data <=
    s0_axi_o_b.s0_axi_bresp &
    write_response_pad;

  read_data_fifo_wr_data <=
    s0_axi_o_b.s0_axi_rdata &
    s0_axi_o_b.s0_axi_rresp &
    read_data_pad;

  -- Downstream FIFOs
  write_address_fifo_wr <= not write_address_fifo_full and s0_axi_i_a.s0_axi_awvalid;
  write_data_fifo_wr    <= not write_data_fifo_full    and s0_axi_i_a.s0_axi_wvalid;
  read_address_fifo_wr  <= not read_address_fifo_full  and s0_axi_i_a.s0_axi_arvalid;

  write_address_fifo_rd <= not write_address_fifo_empty and s0_axi_o_b.s0_axi_awready;
  write_data_fifo_rd    <= not write_data_fifo_empty    and s0_axi_o_b.s0_axi_wready;
  read_address_fifo_rd  <= not read_address_fifo_empty  and s0_axi_o_b.s0_axi_arready;

  s0_axi_o_a.s0_axi_awready <= not write_address_fifo_full;
  s0_axi_o_a.s0_axi_wready  <= not write_data_fifo_full;
  s0_axi_o_a.s0_axi_arready <= not read_address_fifo_full;

  s0_axi_i_b.s0_axi_awvalid <= not write_address_fifo_empty;
  s0_axi_i_b.s0_axi_wvalid  <= not write_data_fifo_empty;
  s0_axi_i_b.s0_axi_arvalid <= not read_address_fifo_empty;

  write_address_fifo : entity work.sync_fifo_dist
    generic map (
      WIDTH         => write_address_fifo_wr_data'length,
      ADDRESS_WIDTH => 4
      )
    port map (
    clock           => s0_axi_aclk,
    reset           => not s0_axi_i_a.s0_axi_aresetn,
    w_full          => write_address_fifo_full,
    r_empty         => write_address_fifo_empty,
    w_data          => write_address_fifo_wr_data,
    w_data_valid    => write_address_fifo_wr,
    r_data          => write_address_fifo_rd_data,
    r_data_taken    => write_address_fifo_rd
    );

  write_data_fifo : entity work.sync_fifo_dist
    generic map (
      WIDTH         => write_data_fifo_wr_data'length,
      ADDRESS_WIDTH => 4
      )
    port map (
    clock           => s0_axi_aclk,
    reset           => not s0_axi_i_a.s0_axi_aresetn,
    w_full          => write_data_fifo_full,
    r_empty         => write_data_fifo_empty,
    w_data          => write_data_fifo_wr_data,
    w_data_valid    => write_data_fifo_wr,
    r_data          => write_data_fifo_rd_data,
    r_data_taken    => write_data_fifo_rd
    );

  read_address_fifo : entity work.sync_fifo_dist
    generic map (
      WIDTH         => read_address_fifo_wr_data'length,
      ADDRESS_WIDTH => 4
      )
    port map (
    clock           => s0_axi_aclk,
    reset           => not s0_axi_i_a.s0_axi_aresetn,
    w_full          => read_address_fifo_full,
    r_empty         => read_address_fifo_empty,
    w_data          => read_address_fifo_wr_data,
    w_data_valid    => read_address_fifo_wr,
    r_data          => read_address_fifo_rd_data,
    r_data_taken    => read_address_fifo_rd
    );

  -- Upstream FIFOs
  write_response_fifo_wr <= not write_response_fifo_full and s0_axi_o_b.s0_axi_bvalid;
  read_data_fifo_wr      <= not read_data_fifo_full      and s0_axi_o_b.s0_axi_rvalid;

  write_response_fifo_rd <= not write_response_fifo_empty and s0_axi_i_a.s0_axi_bready;
  read_data_fifo_rd      <= not read_data_fifo_empty      and s0_axi_i_a.s0_axi_rready;

  s0_axi_i_b.s0_axi_bready <= not write_response_fifo_full;
  s0_axi_i_b.s0_axi_rready <= not read_data_fifo_full;

  s0_axi_o_a.s0_axi_bvalid <= not write_response_fifo_empty;
  s0_axi_o_a.s0_axi_rvalid <= not read_data_fifo_empty;

  write_response_fifo : entity work.sync_fifo_dist
    generic map (
      WIDTH         => write_response_fifo_wr_data'length,
      ADDRESS_WIDTH => 4
      )
    port map (
    clock           => s0_axi_aclk,
    reset           => not s0_axi_i_a.s0_axi_aresetn,
    w_full          => write_response_fifo_full,
    r_empty         => write_response_fifo_empty,
    w_data          => write_response_fifo_wr_data,
    w_data_valid    => write_response_fifo_wr,
    r_data          => write_response_fifo_rd_data,
    r_data_taken    => write_response_fifo_rd
    );

  read_data_fifo : entity work.sync_fifo_dist
    generic map (
      WIDTH         => read_data_fifo_wr_data'length,
      ADDRESS_WIDTH => 4
      )
    port map (
    clock           => s0_axi_aclk,
    reset           => not s0_axi_i_a.s0_axi_aresetn,
    w_full          => read_data_fifo_full,
    r_empty         => read_data_fifo_empty,
    w_data          => read_data_fifo_wr_data,
    w_data_valid    => read_data_fifo_wr,
    r_data          => read_data_fifo_rd_data,
    r_data_taken    => read_data_fifo_rd
    );

  -- Downstream
  s0_axi_i_b.s0_axi_awaddr  <= write_address_fifo_rd_data(95 downto 32);
  s0_axi_i_b.s0_axi_awprot  <= write_address_fifo_rd_data(31 downto 29);
  write_address_pad_unused  <= write_address_fifo_rd_data(28 downto 0);

  s0_axi_i_b.s0_axi_wdata <= write_data_fifo_rd_data(63 downto 32);
  s0_axi_i_b.s0_axi_wstrb <= write_data_fifo_rd_data(31 downto 28);
  write_data_pad_unused   <= write_data_fifo_rd_data(27 downto 0);

  s0_axi_i_b.s0_axi_araddr  <= read_address_fifo_rd_data(95 downto 32);
  s0_axi_i_b.s0_axi_arprot  <= read_address_fifo_rd_data(31 downto 29);
  read_address_pad_unused   <= read_address_fifo_rd_data(28 downto 0);

  -- Upstream
  s0_axi_o_a.s0_axi_bresp   <= write_response_fifo_rd_data(31 downto 30);
  write_response_pad_unused <= write_response_fifo_rd_data(29 downto 0);

  s0_axi_o_a.s0_axi_rdata <= read_data_fifo_rd_data(63 downto 32);
  s0_axi_o_a.s0_axi_rresp <= read_data_fifo_rd_data(31 downto 30);
  read_data_pad_unused    <= read_data_fifo_rd_data(29 downto 0);

end axi_sync;
