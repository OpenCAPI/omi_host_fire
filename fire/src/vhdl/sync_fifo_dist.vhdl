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

library ieee, support, ibm, work;
  use ieee.std_logic_1164.all;
  use ibm.std_ulogic_unsigned.all;
  use ibm.std_ulogic_function_support.all;
  use ibm.std_ulogic_support.all;
  use work.axi_pkg.all;

entity sync_fifo_dist is
  generic (
    WIDTH         :    positive := 32;
    ADDRESS_WIDTH :    positive := 4
    );
  port (
    clock : in std_ulogic;
    reset : in std_ulogic;

    w_full  : out std_ulogic;
    r_empty : out std_ulogic;

    w_data       : in std_ulogic_vector(WIDTH - 1 downto 0);
    w_data_valid : in std_ulogic;

    r_data       : out std_ulogic_vector(WIDTH - 1 downto 0);
    r_data_taken : in  std_ulogic
    );
end sync_fifo_dist;

architecture sync_fifo_dist of sync_fifo_dist is

  SIGNAL wptr_bin_d : std_ulogic_vector(ADDRESS_WIDTH downto 0);
  SIGNAL wptr_bin_q : std_ulogic_vector(ADDRESS_WIDTH downto 0);
  SIGNAL rptr_bin_d : std_ulogic_vector(ADDRESS_WIDTH downto 0);
  SIGNAL rptr_bin_q : std_ulogic_vector(ADDRESS_WIDTH downto 0);
  SIGNAL wptr_gry_d : std_ulogic_vector(ADDRESS_WIDTH downto 0);
  SIGNAL wptr_gry_q : std_ulogic_vector(ADDRESS_WIDTH downto 0);
  SIGNAL rptr_gry_d : std_ulogic_vector(ADDRESS_WIDTH downto 0);
  SIGNAL rptr_gry_q : std_ulogic_vector(ADDRESS_WIDTH downto 0);
  SIGNAL wptr_gry_sync1_d : std_ulogic_vector(ADDRESS_WIDTH downto 0);
  SIGNAL wptr_gry_sync1_q : std_ulogic_vector(ADDRESS_WIDTH downto 0);
  SIGNAL wptr_gry_sync2_d : std_ulogic_vector(ADDRESS_WIDTH downto 0);
  SIGNAL wptr_gry_sync2_q : std_ulogic_vector(ADDRESS_WIDTH downto 0);
  SIGNAL rptr_gry_sync1_d : std_ulogic_vector(ADDRESS_WIDTH downto 0);
  SIGNAL rptr_gry_sync1_q : std_ulogic_vector(ADDRESS_WIDTH downto 0);
  SIGNAL rptr_gry_sync2_d : std_ulogic_vector(ADDRESS_WIDTH downto 0);
  SIGNAL rptr_gry_sync2_q : std_ulogic_vector(ADDRESS_WIDTH downto 0);
  SIGNAL full_d : std_ulogic;
  SIGNAL full_q : std_ulogic;
  SIGNAL empty_d : std_ulogic;
  SIGNAL empty_q : std_ulogic := '1';
  SIGNAL w_incr : std_ulogic;
  SIGNAL w_incr_v : std_ulogic_vector((WIDTH / 32) - 1 downto 0);
  SIGNAL r_incr : std_ulogic;

begin

  w_full  <= full_q;
  r_empty <= empty_q;

  -- Write Domain
  w_incr     <= not full_q and w_data_valid;
  w_incr_v   <= (others => w_incr);
  wptr_bin_d <= (wptr_bin_q + '1') when w_incr = '1' else
                wptr_bin_q;
  wptr_gry_d <= de_bin2gray(wptr_bin_d);

  rptr_gry_sync1_d <= rptr_gry_q;
  rptr_gry_sync2_d <= rptr_gry_sync1_q;

  full_d <= (rptr_gry_sync2_q(ADDRESS_WIDTH) /= wptr_gry_d(ADDRESS_WIDTH)) and
            (rptr_gry_sync2_q(ADDRESS_WIDTH - 1) /= wptr_gry_d(ADDRESS_WIDTH - 1)) and
            (rptr_gry_sync2_q(ADDRESS_WIDTH - 2 downto 0) = wptr_gry_d(ADDRESS_WIDTH - 2 downto 0));

  process (clock)
  begin
    if clock'event and clock = '1' then
      if reset = '1' then
        wptr_bin_q       <= (others => '0');
        wptr_gry_q       <= (others => '0');
        rptr_gry_sync1_q <= (others => '0');
        rptr_gry_sync2_q <= (others => '0');
        full_q           <= '0';
      else
        wptr_bin_q       <= wptr_bin_d;
        wptr_gry_q       <= wptr_gry_d;
        rptr_gry_sync1_q <= rptr_gry_sync1_d;
        rptr_gry_sync2_q <= rptr_gry_sync2_d;
        full_q           <= full_d;
      end if;
    end if;
  end process;

  -- Read Domain
  r_incr     <= not empty_q and r_data_taken;
  rptr_bin_d <= (rptr_bin_q + '1') when r_incr = '1' else
                rptr_bin_q;
  rptr_gry_d <= de_bin2gray(rptr_bin_d);

  wptr_gry_sync1_d <= wptr_gry_q;
  wptr_gry_sync2_d <= wptr_gry_sync1_q;

  empty_d <= (wptr_gry_sync2_q = rptr_gry_d);

  process (clock)
  begin
    if clock'event and clock = '1' then
      if reset = '1' then
        rptr_bin_q       <= (others => '0');
        rptr_gry_q       <= (others => '0');
        wptr_gry_sync1_q <= (others => '0');
        wptr_gry_sync2_q <= (others => '0');
        empty_q          <= '1';
      else
        rptr_bin_q       <= rptr_bin_d;
        rptr_gry_q       <= rptr_gry_d;
        wptr_gry_sync1_q <= wptr_gry_sync1_d;
        wptr_gry_sync2_q <= wptr_gry_sync2_d;
        empty_q          <= empty_d;
      end if;
    end if;
  end process;

fifo : entity work.dist_ram_1w_wrap
generic map (
    C_DATA_WIDTH    => WIDTH,
    C_ADDRESS_WIDTH => ADDRESS_WIDTH
)
port map (
    bram_addr_a => wptr_bin_q(ADDRESS_WIDTH - 1 downto 0),
    bram_addr_b => rptr_bin_d(ADDRESS_WIDTH - 1 downto 0), -- There's an output latch on the read path, so send the read address early so we align with the valid.
    bram_din_a  => open,
    bram_din_b  => r_data,
    bram_dout_a => w_data,
    bram_wen_a  => w_incr_v,
    clock       => clock,
    reset       => reset
);

end sync_fifo_dist;
