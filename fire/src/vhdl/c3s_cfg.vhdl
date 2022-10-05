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

library ieee, ibm, support;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ibm.std_ulogic_support.all;
use ibm.std_ulogic_unsigned.all;
use ibm.std_ulogic_function_support.all;
use ibm.synthesis_support.all;
use support.logic_support_pkg.all;
use work.axi_pkg.all;

entity c3s_cfg is
  generic (
    C_COMMAND_WIDTH                : positive range 1 to 8192 := 512;
    C_ADDRESS_WIDTH                : positive range 1 to 8    := 5
    );
  port (
    ---------------------------------------------------------------------------
    -- Clocking & Power
    ---------------------------------------------------------------------------
    cclk                           : in std_ulogic;
    creset                         : in std_ulogic;

    ---------------------------------------------------------------------------
    -- Register Interface (AXI4-Lite Slave)
    ---------------------------------------------------------------------------
    c3s_axis_aclk                  : in std_ulogic;
    c3s_axis_i                     : in t_AXI4_LITE_SLAVE_INPUT;
    c3s_axis_o                     : out t_AXI4_LITE_SLAVE_OUTPUT;

    ---------------------------------------------------------------------------
    -- Function
    ---------------------------------------------------------------------------
    c3s_config                     : out std_ulogic_vector(31 downto 0);
    c3s_ip                         : in std_ulogic;
    c3s_resp_addr_a                : in std_ulogic_vector(C_ADDRESS_WIDTH - 1 downto 0);
    c3s_resp_addr_a_overflow       : in std_ulogic;
    c3s_resp_addr_a_reset          : out std_ulogic;

    ---------------------------------------------------------------------------
    -- Array Interfaces
    ---------------------------------------------------------------------------
    -- Data Array, Port B
    c3s_data_addr_b                : out std_ulogic_vector(C_ADDRESS_WIDTH - 1 downto 0);
    c3s_data_din_b                 : in std_ulogic_vector(C_COMMAND_WIDTH - 1 downto 0);
    c3s_data_dout_b                : out std_ulogic_vector(C_COMMAND_WIDTH - 1 downto 0);
    c3s_data_wen_b                 : out std_ulogic_vector((C_COMMAND_WIDTH / 32) - 1 downto 0);

    -- Flow Control Array, Port B
    c3s_flow_addr_b                : out std_ulogic_vector(C_ADDRESS_WIDTH - 1 downto 0);
    c3s_flow_din_b                 : in std_ulogic_vector(31 downto 0);
    c3s_flow_dout_b                : out std_ulogic_vector(31 downto 0);
    c3s_flow_wen_b                 : out std_ulogic_vector(0 downto 0);

    -- Response Array, Port B
    c3s_resp_addr_b                : out std_ulogic_vector(C_ADDRESS_WIDTH - 1 downto 0);
    c3s_resp_din_b                 : in std_ulogic_vector(C_COMMAND_WIDTH - 1 + 32 downto 0);
    c3s_resp_dout_b                : out std_ulogic_vector(C_COMMAND_WIDTH - 1 + 32 downto 0);
    c3s_resp_wen_b                 : out std_ulogic_vector((C_COMMAND_WIDTH / 32) - 1 + 1 downto 0)
    );

  attribute BLOCK_TYPE of c3s_cfg : entity is LEAF;
  attribute BTR_NAME of c3s_cfg : entity is "C3S_CFG";
  attribute RECURSIVE_SYNTHESIS of c3s_cfg : entity is 2;
  attribute PIN_DATA of cclk : signal is "PIN_FUNCTION=/G_CLK/";
end c3s_cfg;

architecture c3s_cfg of c3s_cfg is

  signal c3s_config_update      : std_ulogic_vector(31 downto 0);
  signal c3s_config_hwwe        : std_ulogic;
  signal c3s_config_int         : std_ulogic_vector(31 downto 0);
  signal c3s_ip_d               : std_ulogic;
  signal c3s_ip_q               : std_ulogic;
  signal c3s_ip_edge            : std_ulogic;
  signal exp_wr_valid           : std_ulogic;
  signal exp_wr_address         : std_ulogic_vector(31 downto 0);
  signal exp_wr_data            : std_ulogic_vector(31 downto 0);
  signal exp_rd_valid           : std_ulogic;
  signal exp_rd_address         : std_ulogic_vector(31 downto 0);
  signal exp_rd_data            : std_ulogic_vector(31 downto 0);
  signal exp_rd_data_valid      : std_ulogic;
  signal c3s_data_rd_data       : std_ulogic_vector(31 downto 0);
  signal c3s_resp_rd_data       : std_ulogic_vector(31 downto 0);
  signal c3s_flow_rd_data       : std_ulogic_vector(31 downto 0);
  signal exp_rd_valid_d         : std_ulogic;
  signal exp_rd_valid_q         : std_ulogic;
  signal exp_rd_valid_n1_d      : std_ulogic;
  signal exp_rd_valid_n1_q      : std_ulogic;
  signal exp_rd_address_d       : std_ulogic_vector(17 downto 16);
  signal exp_rd_address_q       : std_ulogic_vector(17 downto 16);
  signal exp_rd_address_n1_d    : std_ulogic_vector(17 downto 16);
  signal exp_rd_address_n1_q    : std_ulogic_vector(17 downto 16);
  signal c3s_done_set           : std_ulogic;
  signal c3s_done_reset         : std_ulogic;
  signal c3s_done               : std_ulogic;
  signal c3s_done_d             : std_ulogic;
  signal c3s_done_q             : std_ulogic;
  signal c3s_done_edge          : std_ulogic;
  signal c3s_resp_config_update : std_ulogic_vector(31 downto 0);
  signal c3s_resp_config_hwwe   : std_ulogic;
  signal c3s_resp_config_int    : std_ulogic_vector(31 downto 0);
  signal c3s_resp_addr_edge     : std_ulogic;
  signal c3s_resp_addr_d        : std_ulogic_vector(C_ADDRESS_WIDTH - 1 downto 0);
  signal c3s_resp_addr_q        : std_ulogic_vector(C_ADDRESS_WIDTH - 1 downto 0);

begin

  c3s_config <= c3s_config_int;

  -----------------------------------------------------------------------------
  -- Register Interface
  -----------------------------------------------------------------------------
  -- Broadcast the data and address to all 32 bit slices and all
  -- arrays, but only write enable the 32 bit register we're writing
  -- to

  -- Row is address bits 15:8, and column is 7:0, although not all
  -- bits of those are used depending on array size.

  -- Data (Offset 0x00000)
  c3s_data_addr_b     <= gate(exp_wr_address(C_ADDRESS_WIDTH - 1 + 8 downto 0 + 8), exp_wr_valid) or
                         gate(exp_rd_address(C_ADDRESS_WIDTH - 1 + 8 downto 0 + 8), exp_rd_valid);
  data_we_gen : for i in (C_COMMAND_WIDTH / 32) - 1 downto 0 generate
    c3s_data_dout_b(32 * i  + 31 downto 32 * i) <= exp_wr_data(31 downto 0);
    c3s_data_wen_b(i) <= exp_wr_valid and
                         (exp_wr_address(17 downto 16) = "00") and
                         (exp_wr_address(7 downto 0) = std_ulogic_vector(to_unsigned(i, 8)));
  end generate;

  process (exp_rd_address, c3s_data_din_b)
    variable rd_data : std_ulogic_vector(31 downto 0) := (others => '0');
  begin
    rd_data := (others => '0');
    for i in (C_COMMAND_WIDTH / 32) - 1 downto 0 loop
      if (To_Std_Ulogic_Vector(i,8) = exp_rd_address(7 downto 0))
      then
        rd_data := c3s_data_din_b(32 * i + 31 downto 32 * i);
      end if;
    end loop;
    c3s_data_rd_data <= rd_data;
  end process;

  -- Response (Offset 0x10000)
  c3s_resp_addr_b     <= gate(exp_wr_address(C_ADDRESS_WIDTH - 1 + 8 downto 0 + 8), exp_wr_valid) or
                         gate(exp_rd_address(C_ADDRESS_WIDTH - 1 + 8 downto 0 + 8), exp_rd_valid);
  resp_we_gen : for i in (C_COMMAND_WIDTH / 32) - 1 + 1 downto 0 generate
    c3s_resp_dout_b(32 * i  + 31 downto 32 * i) <= exp_wr_data(31 downto 0);
    c3s_resp_wen_b(i) <= exp_wr_valid and
                         (exp_wr_address(17 downto 16) = "01") and
                         (exp_wr_address(7 downto 0) = std_ulogic_vector(to_unsigned(i, 8)));
  end generate;

  process (exp_rd_address, c3s_resp_din_b)
    variable rd_data : std_ulogic_vector(31 downto 0) := (others => '0');
  begin
    rd_data := (others => '0');
    for i in (C_COMMAND_WIDTH / 32) - 1 + 1 downto 0 loop
      if (To_Std_Ulogic_Vector(i,8) = exp_rd_address(7 downto 0))
      then
        rd_data := c3s_resp_din_b(32 * i + 31 downto 32 * i);
      end if;
    end loop;
    c3s_resp_rd_data <= rd_data;
  end process;

  -- Flow (Offset 0x20000)
  c3s_flow_addr_b   <= gate(exp_wr_address(C_ADDRESS_WIDTH - 1 + 8 downto 0 + 8), exp_wr_valid) or
                       gate(exp_rd_address(C_ADDRESS_WIDTH - 1 + 8 downto 0 + 8), exp_rd_valid);
  c3s_flow_dout_b   <= exp_wr_data;
  c3s_flow_wen_b(0) <= exp_wr_valid and
                       (exp_wr_address(17 downto 16) = "10") and
                       (exp_wr_address(7 downto 0) = x"00");
  c3s_flow_rd_data  <= gate(c3s_flow_din_b(31 downto 0), exp_wr_address(7 downto 0) = x"00");

  -- Read Data Select
  exp_rd_valid_d                    <= exp_rd_valid;
  exp_rd_valid_n1_d                 <= exp_rd_valid_q;
  exp_rd_address_d(17 downto 16)    <= exp_rd_address(17 downto 16);
  exp_rd_address_n1_d(17 downto 16) <= exp_rd_address_q(17 downto 16);

  exp_rd_data_valid <= exp_rd_valid_n1_q and ((exp_rd_address_n1_q(17 downto 16) = "00") or
                                              (exp_rd_address_n1_q(17 downto 16) = "01") or
                                              (exp_rd_address_n1_q(17 downto 16) = "10"));
  exp_rd_data       <= gate(c3s_data_rd_data, exp_rd_address_n1_q(17 downto 16) = "00") or
                       gate(c3s_resp_rd_data, exp_rd_address_n1_q(17 downto 16) = "01") or
                       gate(c3s_flow_rd_data, exp_rd_address_n1_q(17 downto 16) = "10");

  -- Reset done bit when starting C3S, and set when finishing
  c3s_done_reset <=     c3s_ip_d and not c3s_ip_q;
  c3s_done_set   <= not c3s_ip_d and     c3s_ip_q;
  c3s_done       <= '1' when c3s_done_set = '1' else
                    '0' when c3s_done_reset = '1' else
                    c3s_config_int(3);

  -- Edge detect to write done bit to reg
  c3s_done_d     <= c3s_done;
  c3s_done_edge  <= c3s_done_q /= c3s_done_d;

  -- Edge detect to write IP bit to reg
  -- There is actually a 1 cycle gap from writing the start bit / done
  -- being reset to the IP bit being, but the register will never be
  -- read 1 cycle after being written, so we don't care.
  c3s_ip_d <= c3s_ip;
  c3s_ip_edge <= c3s_ip_q /= c3s_ip_d;

  -- Edge detect for resp write address. We need to look at all the
  -- bits even though it's a counter that always increments by 1, to
  -- account for the reset to 0 via AXI.
  c3s_resp_addr_d    <= c3s_resp_addr_a;
  c3s_resp_addr_edge <= c3s_resp_addr_q /= c3s_resp_addr_d;

  -- Reset the response write address to 0. Designed to be written
  -- when C3S or traffic is not running, so that parsing results start
  -- at a known and repeatable point.
  c3s_resp_addr_a_reset <= c3s_resp_config_int(9);

  -- Self resetting and reserved bits get hwwe tied to 0. Others get
  -- their functional update value.
  c3s_config_update(31 downto 4) <= (others => '0');
  c3s_config_update(3)           <= c3s_done;
  c3s_config_update(2)           <= c3s_ip;
  c3s_config_update(1 downto 0)  <= (others => '0');
  c3s_config_hwwe                <= c3s_done_edge or c3s_ip_edge or c3s_config_int(1) or c3s_config_int(0);

  -- Write bit 9 to reset the resp counter in cntl logic, and also
  -- reset the overflow bit. Writing to this bit triggers a hardware
  -- update the next cycle, which resets bit 9. The next cycle,
  -- c3s_resp_addr_a will trigger another hardware update and reset to
  -- 0. The overflow bit must be written to 0 to be reset. AND it with
  -- NOT the reset so an overflow doesn't sneak in during that 1 cycle
  -- window between the write and the counter reset.
  c3s_resp_config_update(31 downto 9)                  <= (others => '0');
  c3s_resp_config_update(8)                            <= c3s_resp_addr_a_overflow and not c3s_resp_config_int(9);
  c3s_resp_config_update(7 downto C_ADDRESS_WIDTH)     <= (others => '0');
  c3s_resp_config_update(C_ADDRESS_WIDTH - 1 downto 0) <= c3s_resp_addr_a;
  c3s_resp_config_hwwe                                 <= c3s_resp_addr_edge or c3s_resp_config_int(9);

  c3s_cfg_regs : entity work.axi_regs_32
    generic map (
      offset             => 16#30000#,
      REG_00_WE_MASK     => x"0000071B",
      REG_01_WE_MASK     => x"00000300",
      REG_02_WE_MASK     => x"00000000",
      REG_03_WE_MASK     => x"00000000",
      REG_04_WE_MASK     => x"00000000",
      REG_05_WE_MASK     => x"00000000",
      REG_06_WE_MASK     => x"00000000",
      REG_07_WE_MASK     => x"00000000",
      REG_08_WE_MASK     => x"00000000",
      REG_09_WE_MASK     => x"00000000",
      REG_0A_WE_MASK     => x"00000000",
      REG_0B_WE_MASK     => x"00000000",
      REG_0C_WE_MASK     => x"00000000",
      REG_0D_WE_MASK     => x"00000000",
      REG_0E_WE_MASK     => x"00000000",
      REG_0F_WE_MASK     => x"00000000",
      REG_00_HWWE_MASK   => x"0000000F",
      REG_01_HWWE_MASK   => x"000003FF",
      REG_01_STICKY_MASK => x"00000100"
      )

    port map (
      s0_axi_aclk       => c3s_axis_aclk,
      s0_axi_i          => c3s_axis_i,
      s0_axi_o          => c3s_axis_o,
      reg_00_o          => c3s_config_int,
      reg_00_update_i   => c3s_config_update,
      reg_00_hwwe_i     => c3s_config_hwwe,
      reg_01_o          => c3s_resp_config_int,
      reg_01_update_i   => c3s_resp_config_update,
      reg_01_hwwe_i     => c3s_resp_config_hwwe,
      exp_rd_valid      => exp_rd_valid,
      exp_rd_address    => exp_rd_address,
      exp_rd_data       => exp_rd_data,
      exp_rd_data_valid => exp_rd_data_valid,
      exp_wr_valid      => exp_wr_valid,
      exp_wr_address    => exp_wr_address,
      exp_wr_data       => exp_wr_data
      );

  process (cclk) is
  begin
    if rising_edge(cclk) then
      if (creset = '1') then
        c3s_ip_q            <= '0';
        exp_rd_address_q    <= (others => '0');
        exp_rd_address_n1_q <= (others => '0');
        exp_rd_valid_q      <= '0';
        exp_rd_valid_n1_q   <= '0';
        c3s_done_q          <= '0';
        c3s_resp_addr_q     <= (others => '0');
      else
        c3s_ip_q            <= c3s_ip_d;
        exp_rd_address_q    <= exp_rd_address_d;
        exp_rd_address_n1_q <= exp_rd_address_n1_d;
        exp_rd_valid_q      <= exp_rd_valid_d;
        exp_rd_valid_n1_q   <= exp_rd_valid_n1_d;
        c3s_done_q          <= c3s_done_d;
        c3s_resp_addr_q     <= c3s_resp_addr_d;
      end if;
    end if;
  end process;

end c3s_cfg;
