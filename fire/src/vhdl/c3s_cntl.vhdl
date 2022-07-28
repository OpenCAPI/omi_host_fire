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

entity c3s_cntl is
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
    -- Function
    ---------------------------------------------------------------------------
    c3s_command                    : out std_ulogic_vector(C_COMMAND_WIDTH - 1 downto 0);
    c3s_command_valid              : out std_ulogic;
    c3s_command_sel                : out std_ulogic;
    c3s_response                   : in std_ulogic_vector(C_COMMAND_WIDTH - 1 downto 0);
    c3s_response_valid             : in std_ulogic;
    c3s_config                     : in  std_ulogic_vector(31 downto 0);
    c3s_ip                         : out std_ulogic;
    c3s_resp_addr_a_overflow       : out std_ulogic;
    c3s_resp_addr_a_reset          : in std_ulogic;

    ---------------------------------------------------------------------------
    -- Array Interfaces
    ---------------------------------------------------------------------------
    -- Data Array, Port A
    c3s_data_addr_a                : out std_ulogic_vector(C_ADDRESS_WIDTH - 1 downto 0);
    c3s_data_din_a                 : in std_ulogic_vector(C_COMMAND_WIDTH - 1 downto 0);
    c3s_data_dout_a                : out std_ulogic_vector(C_COMMAND_WIDTH - 1 downto 0);
    c3s_data_wen_a                 : out std_ulogic_vector((C_COMMAND_WIDTH / 32) - 1 downto 0);

    -- Flow Control Array, Port A
    c3s_flow_addr_a                : out std_ulogic_vector(C_ADDRESS_WIDTH - 1 downto 0);
    c3s_flow_din_a                 : in std_ulogic_vector(31 downto 0);
    c3s_flow_dout_a                : out std_ulogic_vector(31 downto 0);
    c3s_flow_wen_a                 : out std_ulogic_vector(0 downto 0);

    -- Response Array, Port A
    c3s_resp_addr_a                : out std_ulogic_vector(C_ADDRESS_WIDTH - 1 downto 0);
    c3s_resp_din_a                 : in std_ulogic_vector(C_COMMAND_WIDTH - 1 + 32 downto 0);
    c3s_resp_dout_a                : out std_ulogic_vector(C_COMMAND_WIDTH - 1 + 32 downto 0);
    c3s_resp_wen_a                 : out std_ulogic_vector((C_COMMAND_WIDTH / 32) - 1 + 1 downto 0)
    );

  attribute BLOCK_TYPE of c3s_cntl : entity is LEAF;
  attribute BTR_NAME of c3s_cntl : entity is "C3S_CNTL";
  attribute RECURSIVE_SYNTHESIS of c3s_cntl : entity is 2;
  attribute PIN_DATA of cclk : signal is "PIN_FUNCTION=/G_CLK/";
end c3s_cntl;

architecture c3s_cntl of c3s_cntl is
  SIGNAL last_instr : std_ulogic;
  SIGNAL repeat_runner : std_ulogic;
  SIGNAL continuous_repeat : std_ulogic;
  SIGNAL c3s_repeat_counts : std_ulogic_vector(2 downto 0);
  SIGNAL temp_d : std_ulogic_vector(2 downto 0);
  SIGNAL temp_q : std_ulogic_vector(2 downto 0) := "000";
  SIGNAL c3s_arr_rd_addr : std_ulogic_vector(C_ADDRESS_WIDTH - 1 downto 0);
  SIGNAL c3s_data_rd_data_d : std_ulogic_vector(C_COMMAND_WIDTH - 1 downto 0);
  SIGNAL c3s_data_rd_data_q : std_ulogic_vector(C_COMMAND_WIDTH - 1 downto 0) := (others => '0');
  SIGNAL c3s_flow_rd_data_d : std_ulogic_vector(31 downto 0);
  SIGNAL c3s_flow_rd_data_q : std_ulogic_vector(31 downto 0) := x"00000000";
  SIGNAL c3s_fsm_d : std_ulogic_vector(3 downto 0);
  SIGNAL c3s_fsm_q : std_ulogic_vector(3 downto 0) := "0001";
  SIGNAL c3s_st_ns0_0 : std_ulogic;
  SIGNAL c3s_st_ns0_1 : std_ulogic;
  SIGNAL c3s_st_ns1_1 : std_ulogic;
  SIGNAL c3s_st_ns1_2 : std_ulogic;
  SIGNAL c3s_st_ns1_3 : std_ulogic;
  SIGNAL c3s_st_ns2_0 : std_ulogic;
  SIGNAL c3s_st_ns3_1 : std_ulogic;
  SIGNAL c3s_st_ns3_3 : std_ulogic;
  SIGNAL c3s_start_bit : std_ulogic;
  SIGNAL c3s_stop_bit : std_ulogic;
  SIGNAL c3s_ip_bit : std_ulogic;
  SIGNAL idle_input : std_ulogic_vector(C_COMMAND_WIDTH - 1 downto 0);
  SIGNAL resp_write_addr_d : std_ulogic_vector(C_ADDRESS_WIDTH - 1 downto 0);
  SIGNAL resp_write_addr_q : std_ulogic_vector(C_ADDRESS_WIDTH - 1 downto 0) := (others => '0');
  SIGNAL c3s_wrap_enable : std_ulogic;
  SIGNAL c3s_sel_disable : std_ulogic;
  SIGNAL c3s_command_sel_int : std_ulogic;
  SIGNAL c3s_command_valid_int : std_ulogic;
  SIGNAL c3s_command_int : std_ulogic_vector(C_COMMAND_WIDTH - 1 downto 0);
  SIGNAL c3s_response_valid_int : std_ulogic;
  SIGNAL c3s_response_int : std_ulogic_vector(C_COMMAND_WIDTH - 1 downto 0);
  SIGNAL resp_write_addr_overflow_d : std_ulogic;
  SIGNAL resp_write_addr_overflow_q : std_ulogic;
  SIGNAL resp_write_addr_zero : std_ulogic_vector(C_ADDRESS_WIDTH - 1 downto 0);
  SIGNAL c3s_runtime_d : std_ulogic_vector(31 downto 0);
  SIGNAL c3s_runtime_q : std_ulogic_vector(31 downto 0);
  SIGNAL c3s_tmpl_b_mask : std_ulogic;

  attribute mark_debug : string;

  attribute mark_debug of c3s_fsm_q       : signal is "true";
  attribute mark_debug of c3s_arr_rd_addr : signal is "true";
  attribute mark_debug of c3s_start_bit   : signal is "true";
  attribute mark_debug of c3s_stop_bit    : signal is "true";
  attribute mark_debug of c3s_ip          : signal is "true";

begin

  -----------------------------------------------------------------------------
  -- Array & Register controls
  -----------------------------------------------------------------------------
  -- 2 arrays are always read together
  c3s_data_addr_a(C_ADDRESS_WIDTH - 1 downto 0) <= c3s_arr_rd_addr;
  c3s_flow_addr_a(C_ADDRESS_WIDTH - 1 downto 0) <= c3s_arr_rd_addr;

  -- We never write the data/flow arrays from port A
  c3s_data_dout_a(C_COMMAND_WIDTH - 1 downto 0)       <= (others => '0');
  c3s_data_wen_a((C_COMMAND_WIDTH / 32) - 1 downto 0) <= (others => '0');
  c3s_flow_dout_a(31 downto 0)                        <= (others => '0');
  c3s_flow_wen_a(0 downto 0)                          <= (others => '0');

  -- Decode config register
  c3s_start_bit   <= c3s_config(0);
  c3s_stop_bit    <= c3s_config(1);
  c3s_tl_gate_bit <= c3s_config(4);
  c3s_wrap_enable <= c3s_config(8);
  c3s_sel_disable <= c3s_config(9);
  c3s_tmpl_b_mask <= c3s_config(10);

  -----------------------------------------------------------------------------
  -- Output and wrap interface
  -----------------------------------------------------------------------------
  c3s_command(C_COMMAND_WIDTH - 1 downto 0) <= c3s_command_int(C_COMMAND_WIDTH - 1 downto 0);
  c3s_command_valid                         <= c3s_command_valid_int;
  c3s_command_sel                           <= c3s_command_sel_int and not c3s_sel_disable;

  -- Allow us to save the command in the response array for debug
  c3s_response_int(C_COMMAND_WIDTH - 1 downto 0) <= gate(c3s_response(C_COMMAND_WIDTH - 1 downto 0),    not c3s_wrap_enable) or
                                                    gate(c3s_command_int(C_COMMAND_WIDTH - 1 downto 0),     c3s_wrap_enable);
  c3s_response_valid_int                         <= (c3s_response_valid and (not c3s_tmpl_b_mask or c3s_response(465 downto 460) /= "001011" or c3s_response(329) or or_reduce(c3s_response(343 downto 336)) or or_reduce(c3s_response(399 downto 392)) or or_reduce(c3s_response(427 downto 420))) and not c3s_wrap_enable) or
                                                    (c3s_command_valid_int                                                                                                                                                                                                                         and     c3s_wrap_enable);
  -- Technically we don't know if we're looking at a control flit, so the comparison with "001011" to find a template B has a risk of picking up a false positive in data flits. We'll take the risk.

  -----------------------------------------------------------------------------
  -- C3S response capture
  -----------------------------------------------------------------------------
  c3s_resp_dout_a(C_COMMAND_WIDTH - 1 + 32 downto 0)      <= c3s_runtime_q(31 downto 0) & c3s_response_int(C_COMMAND_WIDTH - 1 downto 0);
  c3s_resp_wen_a((C_COMMAND_WIDTH / 32) - 1 + 1 downto 0) <= (others => c3s_response_valid_int);
  c3s_resp_addr_a(C_ADDRESS_WIDTH - 1 downto 0)           <= resp_write_addr_q(C_ADDRESS_WIDTH - 1 downto 0);

  -- When the pointer maxes out, roll over. That way we capture the N most
  -- recent commands.
  resp_write_addr_zero(C_ADDRESS_WIDTH - 1 downto 0) <= (others => '0');
  resp_write_addr_d(C_ADDRESS_WIDTH - 1 downto 0)    <= gate(resp_write_addr_zero,                                    c3s_resp_addr_a_reset                               ) or
                                                        gate(resp_write_addr_q(C_ADDRESS_WIDTH - 1 downto 0),     not c3s_resp_addr_a_reset and not c3s_response_valid_int) or
                                                        gate(resp_write_addr_q(C_ADDRESS_WIDTH - 1 downto 0) + 1, not c3s_resp_addr_a_reset and     c3s_response_valid_int);

  -- Send an overflow pulse to the cfg logic to be captured in a
  -- register. An overflow is when the new value of the register is 0,
  -- and we just took the increment path of the mux.
  resp_write_addr_overflow_d <= resp_write_addr_d(C_ADDRESS_WIDTH - 1 downto 0) = 0 and not c3s_resp_addr_a_reset and c3s_response_valid_int;
  c3s_resp_addr_a_overflow   <= resp_write_addr_overflow_q;

  -----------------------------------------------------------------------------
  -- C3S controls
  -----------------------------------------------------------------------------
  -- Currently we have an all-0 idle pattern. This works for current
  -- applications. If it doesn't work for something eventually we can
  -- add config regs.
  idle_input <= (others => '0');

  last_instr <= c3s_flow_rd_data_q(8);

  c3s_ip_bit <= not (c3s_fsm_q(0));
  c3s_ip     <= c3s_ip_bit;

  c3s_repeat_counts(2 downto 0) <= c3s_flow_rd_data_q(14 downto 12);

  repeat_runner <= c3s_flow_rd_data_q(14 downto 12) /= "000";

  c3s_command_int(C_COMMAND_WIDTH - 1 downto 0) <= GATE(c3s_data_rd_data_q(C_COMMAND_WIDTH - 1 downto 0), not last_instr) or
                                                   GATE(idle_input(C_COMMAND_WIDTH - 1 downto 0),             last_instr);
  c3s_command_valid_int                         <= (c3s_flow_rd_data_q(31) and not last_instr) or
                                                   ('0'                    and     last_instr);

  c3s_command_sel_int <= c3s_fsm_q(1) or c3s_fsm_q(3);

  c3s_arr_rd_addr(C_ADDRESS_WIDTH - 1 downto 0) <= c3s_flow_rd_data_d(C_ADDRESS_WIDTH - 1 downto 0);

  temp_d <= GATE("000",      temp_q  = c3s_flow_rd_data_q(14 downto 12) or c3s_fsm_d(3) /= '1')
         or GATE(temp_q + 1, temp_q /= c3s_flow_rd_data_q(14 downto 12) and c3s_fsm_d(3) = '1');

  continuous_repeat <= temp_q = c3s_flow_rd_data_q(14 downto 12);

  -----------------------------------------------------------------------------
  -- STATE_MACHINE_DESCRIPTION
  -----------------------------------------------------------------------------

  -- State 0 - Idle - waiting for the start bit
  -- State 1 - Send instruction - state
  -- State 2 - Done - state
  -- State 3 - Continuous repeat - state

  -- FSM STATE TRANSITION

  -- Transitions from state 0 - Idle - waiting for the start bit
  c3s_st_ns0_0 <= c3s_fsm_q(0) and not c3s_start_bit;
  c3s_st_ns0_1 <= c3s_fsm_q(0) and     c3s_start_bit;

  -- Transitions from state 1 - Send instruction
  c3s_st_ns1_1 <= c3s_fsm_q(1) and not last_instr and not repeat_runner;
  c3s_st_ns1_2 <= c3s_fsm_q(1) and     last_instr                      ;
  c3s_st_ns1_3 <= c3s_fsm_q(1) and not last_instr and     repeat_runner;

  -- Transition from state 2 - Done - Sends idles afterwards
  c3s_st_ns2_0 <= c3s_fsm_q(2);

  -- Transition from state 3 - Continuous repeat
  c3s_st_ns3_1 <=  c3s_fsm_q(3) and     continuous_repeat;
  c3s_st_ns3_3 <=  c3s_fsm_q(3) and not continuous_repeat;

  -- Combine next state arcs for actual next stage signals
  c3s_fsm_d(0) <= (c3s_st_ns0_0 or                 c3s_st_ns2_0                ) or      creset;
  c3s_fsm_d(1) <= (c3s_st_ns0_1 or c3s_st_ns1_1 or                 c3s_st_ns3_1) and not creset;
  c3s_fsm_d(2) <= (                c3s_st_ns1_2                                ) and not creset;
  c3s_fsm_d(3) <= (                c3s_st_ns1_3 or                 c3s_st_ns3_3) and not creset;

  -----------------------------------------------------------------------------
  -- Runtime counter
  -----------------------------------------------------------------------------
  c3s_runtime_d(31 downto 0) <= x"00000000" when c3s_st_ns0_1 = '1' else
                                x"00000000" when c3s_runtime_q = x"FFFFFFFF" else
                                c3s_runtime_q(31 downto 0) + 1;

  -------------------------------------------------------------------------------
  -- Connecting the values for read data
  -------------------------------------------------------------------------------
  c3s_data_rd_data_d(C_COMMAND_WIDTH - 1 downto 0) <= GATE( c3s_data_din_a(C_COMMAND_WIDTH - 1 downto 0),         (c3s_st_ns0_1 or c3s_st_ns1_1 or c3s_st_ns3_1)) or
                                                      GATE( c3s_data_rd_data_q(C_COMMAND_WIDTH - 1 downto 0), not (c3s_st_ns0_1 or c3s_st_ns1_1 or c3s_st_ns3_1));
  c3s_flow_rd_data_d(31 downto 0)                  <= GATE( c3s_flow_din_a(31 downto 0),                          (c3s_st_ns0_1 or c3s_st_ns1_1 or c3s_st_ns3_1)) or
                                                      GATE( c3s_flow_rd_data_q(31 downto 0),                  not (c3s_st_ns0_1 or c3s_st_ns1_1 or c3s_st_ns3_1));

  -------------------------------------------------------------------------------
  -- Latches
  -------------------------------------------------------------------------------
  process(cclk)
  begin
    if (cclk'EVENT AND cclk = '1') then
      c3s_fsm_q(3 downto 0)                            <= c3s_fsm_d(3 downto 0);
      c3s_data_rd_data_q(C_COMMAND_WIDTH - 1 downto 0) <= c3s_data_rd_data_d(C_COMMAND_WIDTH - 1 downto 0);
      c3s_flow_rd_data_q(31 downto 0)                  <= c3s_flow_rd_data_d(31 downto 0);
      temp_q(2 downto 0)                               <= temp_d(2 downto 0);
      resp_write_addr_q(C_ADDRESS_WIDTH - 1 downto 0)  <= resp_write_addr_d(C_ADDRESS_WIDTH - 1 downto 0);
      resp_write_addr_overflow_q                       <= resp_write_addr_overflow_d;
      c3s_runtime_q(31 downto 0)                       <= c3s_runtime_d(31 downto 0);
    end if;
  end process;

end c3s_cntl;
