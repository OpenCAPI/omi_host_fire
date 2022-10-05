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

library ieee,ibm,support;
use ieee.std_logic_1164.all;
use ibm.synthesis_support.all;
use support.logic_support_pkg.all;
use work.axi_pkg.all;

entity c3s_mac is
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

    c3s_tl_gate_bit                : OUT std_ulogic;
    ---------------------------------------------------------------------------
    -- Register Interface (AXI4-Lite Slave)
    ---------------------------------------------------------------------------
    c3s_axis_aclk                  : in std_ulogic;
    c3s_axis_i                     : in t_AXI4_LITE_SLAVE_INPUT;
    c3s_axis_o                     : out t_AXI4_LITE_SLAVE_OUTPUT;

    ---------------------------------------------------------------------------
    -- Functional Interface
    ---------------------------------------------------------------------------
    c3s_command                    : out std_ulogic_vector(C_COMMAND_WIDTH - 1 downto 0);
    c3s_command_valid              : out std_ulogic;
    c3s_command_sel                : out std_ulogic;
    c3s_response                   : in std_ulogic_vector(C_COMMAND_WIDTH - 1 downto 0);
    c3s_response_valid             : in std_ulogic
    );

  attribute BLOCK_TYPE of c3s_mac : entity is SUPERRLM;
  attribute BTR_NAME of c3s_mac : entity is "C3S_MAC";
  attribute RECURSIVE_SYNTHESIS of c3s_mac : entity is 2;
  attribute PIN_DATA of cclk : signal is "PIN_FUNCTION=/G_CLK/";
end c3s_mac;

architecture c3s_mac of c3s_mac is
  SIGNAL c3s_data_addr_a : std_ulogic_vector(C_ADDRESS_WIDTH - 1 downto 0);
  SIGNAL c3s_data_addr_b : std_ulogic_vector(C_ADDRESS_WIDTH - 1 downto 0);
  SIGNAL c3s_data_din_a : std_ulogic_vector(C_COMMAND_WIDTH - 1 downto 0);
  SIGNAL c3s_data_din_b : std_ulogic_vector(C_COMMAND_WIDTH - 1 downto 0);
  SIGNAL c3s_data_dout_a : std_ulogic_vector(C_COMMAND_WIDTH - 1 downto 0);
  SIGNAL c3s_data_dout_b : std_ulogic_vector(C_COMMAND_WIDTH - 1 downto 0);
  SIGNAL c3s_data_wen_a : std_ulogic_vector((C_COMMAND_WIDTH / 32) - 1 downto 0);
  SIGNAL c3s_data_wen_b : std_ulogic_vector((C_COMMAND_WIDTH / 32) - 1 downto 0);
  SIGNAL c3s_flow_addr_a : std_ulogic_vector(C_ADDRESS_WIDTH - 1 downto 0);
  SIGNAL c3s_flow_addr_b : std_ulogic_vector(C_ADDRESS_WIDTH - 1 downto 0);
  SIGNAL c3s_flow_din_a : std_ulogic_vector(31 downto 0);
  SIGNAL c3s_flow_din_b : std_ulogic_vector(31 downto 0);
  SIGNAL c3s_flow_dout_a : std_ulogic_vector(31 downto 0);
  SIGNAL c3s_flow_dout_b : std_ulogic_vector(31 downto 0);
  SIGNAL c3s_flow_wen_a : std_ulogic_vector(0 downto 0);
  SIGNAL c3s_flow_wen_b : std_ulogic_vector(0 downto 0);
  SIGNAL c3s_resp_addr_a : std_ulogic_vector(C_ADDRESS_WIDTH - 1 downto 0);
  SIGNAL c3s_resp_addr_b : std_ulogic_vector(C_ADDRESS_WIDTH - 1 downto 0);
  SIGNAL c3s_resp_din_a : std_ulogic_vector(C_COMMAND_WIDTH - 1 + 32 downto 0);
  SIGNAL c3s_resp_din_b : std_ulogic_vector(C_COMMAND_WIDTH - 1 + 32 downto 0);
  SIGNAL c3s_resp_dout_a : std_ulogic_vector(C_COMMAND_WIDTH - 1 + 32 downto 0);
  SIGNAL c3s_resp_dout_b : std_ulogic_vector(C_COMMAND_WIDTH - 1 + 32 downto 0);
  SIGNAL c3s_resp_wen_a : std_ulogic_vector((C_COMMAND_WIDTH / 32) - 1 + 1 downto 0);
  SIGNAL c3s_resp_wen_b : std_ulogic_vector((C_COMMAND_WIDTH / 32) - 1 + 1 downto 0);
  SIGNAL c3s_config : std_ulogic_vector(31 downto 0);
  SIGNAL c3s_ip : std_ulogic;
  SIGNAL c3s_resp_addr_a_reset : std_ulogic;
  SIGNAL c3s_resp_addr_a_overflow : std_ulogic;
  signal c3s_axis_i_stage : t_AXI4_LITE_SLAVE_INPUT;
  signal c3s_axis_o_stage : t_AXI4_LITE_SLAVE_OUTPUT;

  --additional pipeline stage for timing
  signal c3s_data_din_b_d : std_ulogic_vector(C_COMMAND_WIDTH - 1 downto 0);
  signal c3s_data_din_b_q : std_ulogic_vector(C_COMMAND_WIDTH - 1 downto 0);
  signal c3s_resp_din_b_d : std_ulogic_vector(C_COMMAND_WIDTH - 1 + 32 downto 0);
  signal c3s_resp_din_b_q : std_ulogic_vector(C_COMMAND_WIDTH - 1 + 32 downto 0);
  signal c3s_flow_din_b_d : std_ulogic_vector(31 downto 0);
  signal c3s_flow_din_b_q : std_ulogic_vector(31 downto 0);

begin

  --Latches for pipeline
  latches: process (cclk)
  begin  -- process latches
    if cclk'event and cclk = '1' then  -- rising clock edge
      c3s_flow_din_b_q <= c3s_flow_din_b_d;
      c3s_resp_din_b_q <= c3s_resp_din_b_d; 
      c3s_data_din_b_q <= c3s_data_din_b_d;
    end if;
  end process latches;

  c3s_data_din_b_d <= c3s_data_din_b;
  c3s_resp_din_b_d <= c3s_resp_din_b;
  c3s_flow_din_b_d <= c3s_flow_din_b;
  --end pipelineing

c3s_data : entity work.bram_wrap
generic map (
    C_DATA_WIDTH    => C_COMMAND_WIDTH,
    C_ADDRESS_WIDTH => C_ADDRESS_WIDTH
)
port map (
    bram_addr_a => c3s_data_addr_a, -- OVR: bram_wrap(c3s_data)
    bram_addr_b => c3s_data_addr_b, -- OVR: bram_wrap(c3s_data)
    bram_din_a  => c3s_data_din_a , -- OVD: bram_wrap(c3s_data)
    bram_din_b  => c3s_data_din_b , -- OVD: bram_wrap(c3s_data)
    bram_dout_a => c3s_data_dout_a, -- OVR: bram_wrap(c3s_data)
    bram_dout_b => c3s_data_dout_b, -- OVR: bram_wrap(c3s_data)
    bram_wen_a  => c3s_data_wen_a , -- OVR: bram_wrap(c3s_data)
    bram_wen_b  => c3s_data_wen_b , -- OVR: bram_wrap(c3s_data)
    clock       => cclk           , -- MSR: bram_wrap(c3s_data)
    reset       => creset           -- MSR: bram_wrap(c3s_data)
);

c3s_flow : entity work.dist_ram_wrap
generic map (
    C_DATA_WIDTH    => 32,
    C_ADDRESS_WIDTH => C_ADDRESS_WIDTH
)
port map (
    bram_addr_a => c3s_flow_addr_a, -- OVR: bram_wrap(c3s_flow)
    bram_addr_b => c3s_flow_addr_b, -- OVR: bram_wrap(c3s_flow)
    bram_din_a  => c3s_flow_din_a , -- OVD: bram_wrap(c3s_flow)
    bram_din_b  => c3s_flow_din_b , -- OVD: bram_wrap(c3s_flow)
    bram_dout_a => c3s_flow_dout_a, -- OVR: bram_wrap(c3s_flow)
    bram_dout_b => c3s_flow_dout_b, -- OVR: bram_wrap(c3s_flow)
    bram_wen_a  => c3s_flow_wen_a , -- OVR: bram_wrap(c3s_flow)
    bram_wen_b  => c3s_flow_wen_b , -- OVR: bram_wrap(c3s_flow)
    clock       => cclk           , -- MSR: bram_wrap(c3s_flow)
    reset       => creset           -- MSR: bram_wrap(c3s_flow)
);

c3s_resp : entity work.bram_wrap
generic map (
    C_DATA_WIDTH    => C_COMMAND_WIDTH + 32,
    C_ADDRESS_WIDTH => C_ADDRESS_WIDTH
)
port map (
    bram_addr_a => c3s_resp_addr_a, -- OVR: bram_wrap(c3s_resp)
    bram_addr_b => c3s_resp_addr_b, -- OVR: bram_wrap(c3s_resp)
    bram_din_a  => c3s_resp_din_a , -- OVD: bram_wrap(c3s_resp)
    bram_din_b  => c3s_resp_din_b , -- OVD: bram_wrap(c3s_resp)
    bram_dout_a => c3s_resp_dout_a, -- OVR: bram_wrap(c3s_resp)
    bram_dout_b => c3s_resp_dout_b, -- OVR: bram_wrap(c3s_resp)
    bram_wen_a  => c3s_resp_wen_a , -- OVR: bram_wrap(c3s_resp)
    bram_wen_b  => c3s_resp_wen_b , -- OVR: bram_wrap(c3s_resp)
    clock       => cclk           , -- MSR: bram_wrap(c3s_resp)
    reset       => creset           -- MSR: bram_wrap(c3s_resp)
);

c3s_cntl : entity work.c3s_cntl
generic map (
    C_COMMAND_WIDTH => C_COMMAND_WIDTH,
    C_ADDRESS_WIDTH => C_ADDRESS_WIDTH
)
port map (
    c3s_command              => c3s_command             , -- MSD: c3s_cntl(c3s_cntl)
    c3s_command_sel          => c3s_command_sel         , -- MSD: c3s_cntl(c3s_cntl)
    c3s_command_valid        => c3s_command_valid       , -- MSD: c3s_cntl(c3s_cntl)
    c3s_config               => c3s_config              , -- MSR: c3s_cntl(c3s_cntl)
    c3s_data_addr_a          => c3s_data_addr_a         , -- MSD: c3s_cntl(c3s_cntl)
    c3s_data_din_a           => c3s_data_din_a          , -- MSR: c3s_cntl(c3s_cntl)
    c3s_data_dout_a          => c3s_data_dout_a         , -- MSD: c3s_cntl(c3s_cntl)
    c3s_data_wen_a           => c3s_data_wen_a          , -- MSD: c3s_cntl(c3s_cntl)
    c3s_flow_addr_a          => c3s_flow_addr_a         , -- MSD: c3s_cntl(c3s_cntl)
    c3s_flow_din_a           => c3s_flow_din_a          , -- MSR: c3s_cntl(c3s_cntl)
    c3s_flow_dout_a          => c3s_flow_dout_a         , -- MSD: c3s_cntl(c3s_cntl)
    c3s_flow_wen_a           => c3s_flow_wen_a          , -- MSD: c3s_cntl(c3s_cntl)
    c3s_ip                   => c3s_ip                  , -- MSD: c3s_cntl(c3s_cntl)
    c3s_resp_addr_a          => c3s_resp_addr_a         , -- MSD: c3s_cntl(c3s_cntl)
    c3s_resp_addr_a_reset    => c3s_resp_addr_a_reset   , -- MSR: c3s_cntl(c3s_cntl)
    c3s_resp_addr_a_overflow => c3s_resp_addr_a_overflow, -- MSD: c3s_cntl(c3s_cntl)
    c3s_resp_din_a           => c3s_resp_din_a          , -- MSR: c3s_cntl(c3s_cntl)
    c3s_resp_dout_a          => c3s_resp_dout_a         , -- MSD: c3s_cntl(c3s_cntl)
    c3s_resp_wen_a           => c3s_resp_wen_a          , -- MSD: c3s_cntl(c3s_cntl)
    c3s_response             => c3s_response            , -- MSR: c3s_cntl(c3s_cntl)
    c3s_response_valid       => c3s_response_valid      , -- MSR: c3s_cntl(c3s_cntl)
    c3s_tl_gate_bit          => c3s_tl_gate_bit,      --       : OUT std_ulogic;
    cclk                     => cclk                    , -- MSR: c3s_cntl(c3s_cntl)
    creset                   => creset                    -- MSR: c3s_cntl(c3s_cntl)
);

c3s_cfg : entity work.c3s_cfg
generic map (
    C_COMMAND_WIDTH => C_COMMAND_WIDTH,
    C_ADDRESS_WIDTH => C_ADDRESS_WIDTH
)
port map (
    c3s_axis_aclk            => c3s_axis_aclk           , -- MSR: c3s_cfg(c3s_cfg)
    c3s_axis_i               => c3s_axis_i_stage        , -- MSR: c3s_cfg(c3s_cfg)
    c3s_axis_o               => c3s_axis_o_stage        , -- MSD: c3s_cfg(c3s_cfg)
    c3s_config               => c3s_config              , -- MSD: c3s_cfg(c3s_cfg)
    c3s_data_addr_b          => c3s_data_addr_b         , -- MSD: c3s_cfg(c3s_cfg)
    c3s_data_din_b           => c3s_data_din_b_q        , -- MSR: c3s_cfg(c3s_cfg)
    c3s_data_dout_b          => c3s_data_dout_b         , -- MSD: c3s_cfg(c3s_cfg)
    c3s_data_wen_b           => c3s_data_wen_b          , -- MSD: c3s_cfg(c3s_cfg)
    c3s_flow_addr_b          => c3s_flow_addr_b         , -- MSD: c3s_cfg(c3s_cfg)
    c3s_flow_din_b           => c3s_flow_din_b_q        , -- MSR: c3s_cfg(c3s_cfg)
    c3s_flow_dout_b          => c3s_flow_dout_b         , -- MSD: c3s_cfg(c3s_cfg)
    c3s_flow_wen_b           => c3s_flow_wen_b          , -- MSD: c3s_cfg(c3s_cfg)
    c3s_ip                   => c3s_ip                  , -- MSR: c3s_cfg(c3s_cfg)
    c3s_resp_addr_a          => c3s_resp_addr_a         , -- MSR: c3s_cfg(c3s_cfg)
    c3s_resp_addr_a_reset    => c3s_resp_addr_a_reset   , -- MSD: c3s_cfg(c3s_cfg)
    c3s_resp_addr_a_overflow => c3s_resp_addr_a_overflow, -- MSR: c3s_cfg(c3s_cfg)
    c3s_resp_addr_b          => c3s_resp_addr_b         , -- MSD: c3s_cfg(c3s_cfg)
    c3s_resp_din_b           => c3s_resp_din_b_q        , -- MSR: c3s_cfg(c3s_cfg)
    c3s_resp_dout_b          => c3s_resp_dout_b         , -- MSD: c3s_cfg(c3s_cfg)
    c3s_resp_wen_b           => c3s_resp_wen_b          , -- MSD: c3s_cfg(c3s_cfg)
    cclk                     => cclk                    , -- MSR: c3s_cfg(c3s_cfg)
    creset                   => creset                    -- MSR: c3s_cfg(c3s_cfg)
);

c3s_axi_stage : entity work.axi_sync
  port map (
    s0_axi_aclk => c3s_axis_aclk,
    s0_axi_i_a  => c3s_axis_i,
    s0_axi_i_b  => c3s_axis_i_stage,
    s0_axi_o_a  => c3s_axis_o,
    s0_axi_o_b  => c3s_axis_o_stage
    );
  
end c3s_mac;
