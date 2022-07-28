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
use ibm.std_ulogic_support.all;
use ibm.std_ulogic_unsigned.all;
use ibm.std_ulogic_function_support.all;
use support.logic_support_pkg.all;
use work.axi_pkg.all;
use work.fbist_pkg.all;

entity fbist_axi is
  port (
    sysclk    : in std_ulogic;
    sys_reset : in std_ulogic;
    cclk      : in std_ulogic;
    creset    : in std_ulogic;

    fbist_oc_axim_aclk : out std_ulogic;
    fbist_oc_axim_i    : in  t_AXI3_512_MASTER_INPUT;
    fbist_oc_axim_o    : out t_AXI3_512_MASTER_OUTPUT;

    axi_fifo_full_gate : out std_ulogic;

    dgen_axi_command         : in std_ulogic_vector(7 downto 0);
    dgen_axi_command_address : in std_ulogic_vector(63 downto 0);
    dgen_axi_command_data    : in std_ulogic_vector(511 downto 0);
    dgen_axi_command_engine  : in std_ulogic_vector(2 downto 0);
    dgen_axi_command_tag     : in std_ulogic_vector(15 downto 0);
    dgen_axi_command_valid   : in std_ulogic;

    axi_chk_response       : out std_ulogic_vector(7 downto 0);
    axi_chk_response_data  : out std_ulogic_vector(511 downto 0);
    axi_chk_response_tag   : out std_ulogic_vector(15 downto 0);
    axi_chk_response_dpart : out std_ulogic_vector(1 downto 0);
    axi_chk_response_ow    : out std_ulogic;
    axi_chk_response_valid : out std_ulogic;

    cfg_axi_address_inject_enable : in  std_ulogic;
    cfg_axi_data_inject_enable    : in  std_ulogic;
    cfg_axi_address_inject_done   : out std_ulogic;
    cfg_axi_data_inject_done      : out std_ulogic;

    fbist_freeze : in std_ulogic
    );

  attribute BLOCK_TYPE of fbist_axi : entity is LEAF;
  attribute BTR_NAME of fbist_axi : entity is "FBIST_AXI";
  attribute RECURSIVE_SYNTHESIS of fbist_axi : entity is 2;
  attribute PIN_DATA of sysclk : signal is "PIN_FUNCTION=/G_CLK/";
end fbist_axi;

architecture fbist_axi of fbist_axi is

  SIGNAL fifo_axi_command : std_ulogic_vector(7 downto 0);
  SIGNAL fifo_axi_command_address : std_ulogic_vector(63 downto 0);
  SIGNAL fifo_axi_command_data : std_ulogic_vector(511 downto 0);
  SIGNAL fifo_axi_command_engine : std_ulogic_vector(2 downto 0);
  SIGNAL fifo_axi_command_tag : std_ulogic_vector(15 downto 0);
  SIGNAL fifo_axi_command_valid : std_ulogic;
  SIGNAL fifo_wr_data : std_ulogic_vector(607 downto 0);
  SIGNAL fifo_rd_data : std_ulogic_vector(607 downto 0);
  SIGNAL fifo_wr_data_valid : std_ulogic;
  SIGNAL fifo_rd_data_valid : std_ulogic;
  SIGNAL fifo_rd_data_taken : std_ulogic;
  SIGNAL fifo_full : std_ulogic;
  SIGNAL fifo_empty : std_ulogic;
  SIGNAL fbist_axi_response_collision : std_ulogic;
  SIGNAL dgen_axi_command_address_inj : std_ulogic_vector(63 downto 0);
  SIGNAL address_inject_enable_d : std_ulogic;
  SIGNAL address_inject_enable_q : std_ulogic;
  SIGNAL address_inject_enable_rising_edge : std_ulogic;
  SIGNAL inject_address_error_valid_d : std_ulogic;
  SIGNAL inject_address_error_valid_q : std_ulogic;
  SIGNAL address_error_injected : std_ulogic;
  SIGNAL dgen_axi_command_data_inj : std_ulogic_vector(511 downto 0);
  SIGNAL data_inject_enable_d : std_ulogic;
  SIGNAL data_inject_enable_q : std_ulogic;
  SIGNAL data_inject_enable_rising_edge : std_ulogic;
  SIGNAL inject_data_error_valid_d : std_ulogic;
  SIGNAL inject_data_error_valid_q : std_ulogic;
  SIGNAL data_error_injected : std_ulogic;

  --------------------------------------------------------------------------------------------------
  -- Debug signals
  --------------------------------------------------------------------------------------------------
  signal dbg_m0_axi_bvalid_d : std_ulogic; 
  signal dbg_m0_axi_rvalid_d : std_ulogic;
  signal dbg_m0_axi_bvalid_q : std_ulogic; 
  signal dbg_m0_axi_rvalid_q : std_ulogic;
  signal dbg_m0_axi_bvalid_1_d : std_ulogic; 
  signal dbg_m0_axi_rvalid_1_d : std_ulogic;
  signal dbg_m0_axi_bvalid_1_q : std_ulogic; 
  signal dbg_m0_axi_rvalid_1_q : std_ulogic;
  signal dbg_m0_axi_bvalid_2_d : std_ulogic; 
  signal dbg_m0_axi_rvalid_2_d : std_ulogic;
  signal dbg_m0_axi_bvalid_2_q : std_ulogic; 
  signal dbg_m0_axi_rvalid_2_q : std_ulogic;

  signal dbg_m0_axi_bresp_d : std_ulogic_vector(1 downto 0); 
  signal dbg_m0_axi_rresp_d : std_ulogic_vector(1 downto 0);
  signal dbg_m0_axi_bresp_q : std_ulogic_vector(1 downto 0); 
  signal dbg_m0_axi_rresp_q : std_ulogic_vector(1 downto 0);
  signal dbg_m0_axi_bresp_1_d : std_ulogic_vector(1 downto 0); 
  signal dbg_m0_axi_rresp_1_d : std_ulogic_vector(1 downto 0);
  signal dbg_m0_axi_bresp_1_q : std_ulogic_vector(1 downto 0); 
  signal dbg_m0_axi_rresp_1_q : std_ulogic_vector(1 downto 0);
  signal dbg_m0_axi_bresp_2_d : std_ulogic_vector(1 downto 0); 
  signal dbg_m0_axi_rresp_2_d : std_ulogic_vector(1 downto 0);
  signal dbg_m0_axi_bresp_2_q : std_ulogic_vector(1 downto 0); 
  signal dbg_m0_axi_rresp_2_q : std_ulogic_vector(1 downto 0);

  
    
  type ST_AXI_COMMAND is (
    ST_AXI_COMMAND_IDLE,                 -- 0
    ST_AXI_COMMAND_SENDING_WRITE,        -- 1
    ST_AXI_COMMAND_SENT_WRITE,           -- 2
    ST_AXI_COMMAND_SENDING_WRITE_DATA_2, -- 3
    ST_AXI_COMMAND_SENT_WRITE_DATA_2,    -- 4
    ST_AXI_COMMAND_SENDING_READ,         -- 5
    ST_AXI_COMMAND_SENT_READ,            -- 6
    ST_AXI_COMMAND_DROP,                 -- 7
    ST_AXI_COMMAND_ERROR                 -- 8
    );
  SIGNAL axi_command_state_d : ST_AXI_COMMAND;
  SIGNAL axi_command_state_q : ST_AXI_COMMAND;

  function "="(L : ST_AXI_COMMAND; R : ST_AXI_COMMAND) return std_ulogic is
    variable o : std_ulogic;
  begin
    if L = R then
      o := '1';
    else
      o := '0';
    end if;
    return o;
  end;

begin

  -- AXI Command State Machine
  axi_command_state_d <= ST_AXI_COMMAND_SENDING_WRITE when (axi_command_state_q = ST_AXI_COMMAND_IDLE and
                                                            fifo_axi_command_valid and
                                                            (fifo_axi_command = FBIST_COMMAND_WRITE_128 or
                                                             fifo_axi_command = FBIST_COMMAND_WRITE_64 or
                                                             fifo_axi_command = FBIST_COMMAND_WRITE_32
                                                             )) = '1' else
                         ST_AXI_COMMAND_SENDING_WRITE when (axi_command_state_q = ST_AXI_COMMAND_SENDING_WRITE and
                                                            not fbist_oc_axim_i.m0_axi_awready
                                                            ) = '1' else
                         ST_AXI_COMMAND_SENT_WRITE when (axi_command_state_q = ST_AXI_COMMAND_SENDING_WRITE and
                                                         fbist_oc_axim_i.m0_axi_awready
                                                         ) = '1' else
                         ST_AXI_COMMAND_SENDING_WRITE_DATA_2 when (axi_command_state_q = ST_AXI_COMMAND_IDLE and
                                                                   fifo_axi_command_valid and
                                                                   (fifo_axi_command = FBIST_COMMAND_WRITE_128_SECOND_DATA
                                                                    )) = '1' else
                         ST_AXI_COMMAND_SENDING_WRITE_DATA_2 when (axi_command_state_q = ST_AXI_COMMAND_SENDING_WRITE_DATA_2 and
                                                                   not fbist_oc_axim_i.m0_axi_wready -- Purposely use wready here
                                                                   ) = '1' else
                         ST_AXI_COMMAND_SENT_WRITE_DATA_2 when (axi_command_state_q = ST_AXI_COMMAND_SENDING_WRITE_DATA_2 and
                                                                fbist_oc_axim_i.m0_axi_wready -- Purposely use wready here
                                                                ) = '1' else
                         ST_AXI_COMMAND_SENDING_READ when (axi_command_state_q = ST_AXI_COMMAND_IDLE and
                                                           fifo_axi_command_valid and
                                                           (fifo_axi_command = FBIST_COMMAND_READ_128 or
                                                            fifo_axi_command = FBIST_COMMAND_READ_64 or
                                                            fifo_axi_command = FBIST_COMMAND_READ_32
                                                            )) = '1' else
                         ST_AXI_COMMAND_SENDING_READ when (axi_command_state_q = ST_AXI_COMMAND_SENDING_READ and
                                                           not fbist_oc_axim_i.m0_axi_arready
                                                           ) = '1' else
                         ST_AXI_COMMAND_SENT_READ when (axi_command_state_q = ST_AXI_COMMAND_SENDING_READ and
                                                        fbist_oc_axim_i.m0_axi_arready
                                                        ) = '1' else
                         ST_AXI_COMMAND_DROP when (axi_command_state_q = ST_AXI_COMMAND_IDLE and
                                                   fifo_axi_command_valid
                                                   ) = '1' else -- fbist commands other than the ones for SENDING_WRITE and SENDING_READ
                         ST_AXI_COMMAND_IDLE;

  fbist_oc_axim_aclk             <= cclk;
  fbist_oc_axim_o.m0_axi_aresetn <= not creset;

  fbist_oc_axim_o.m0_axi_awid    <= fifo_axi_command_tag(11 downto 0);
  fbist_oc_axim_o.m0_axi_awaddr  <= fifo_axi_command_address;
  fbist_oc_axim_o.m0_axi_awlen   <= x"1" when fifo_axi_command = FBIST_COMMAND_WRITE_128 else
                                    x"0";
  fbist_oc_axim_o.m0_axi_awsize  <= "101" when fifo_axi_command = FBIST_COMMAND_WRITE_32 else
                                    "110";
  fbist_oc_axim_o.m0_axi_awburst <= (others => '0');
  fbist_oc_axim_o.m0_axi_awlock  <= (others => '0');
  fbist_oc_axim_o.m0_axi_awcache <= (others => '0');
  fbist_oc_axim_o.m0_axi_awprot  <= (others => '0');
  fbist_oc_axim_o.m0_axi_awvalid <= axi_command_state_q = ST_AXI_COMMAND_SENDING_WRITE;

  fbist_oc_axim_o.m0_axi_wid    <= fifo_axi_command_tag(11 downto 0);
  fbist_oc_axim_o.m0_axi_wdata  <= fifo_axi_command_data;
  fbist_oc_axim_o.m0_axi_wstrb  <= (others => '1');
  fbist_oc_axim_o.m0_axi_wlast  <= (axi_command_state_q = ST_AXI_COMMAND_SENDING_WRITE and fifo_axi_command /= FBIST_COMMAND_WRITE_128) or
                                   axi_command_state_q = ST_AXI_COMMAND_SENDING_WRITE_DATA_2;
  fbist_oc_axim_o.m0_axi_wvalid <= axi_command_state_q = ST_AXI_COMMAND_SENDING_WRITE or
                                   axi_command_state_q = ST_AXI_COMMAND_SENDING_WRITE_DATA_2;

  fbist_oc_axim_o.m0_axi_arid    <= fifo_axi_command_tag(11 downto 0);
  fbist_oc_axim_o.m0_axi_araddr  <= fifo_axi_command_address;
  fbist_oc_axim_o.m0_axi_arlen   <= x"1" when fifo_axi_command = FBIST_COMMAND_READ_128 else
                                    x"0";
  fbist_oc_axim_o.m0_axi_arsize  <= "101" when fifo_axi_command = FBIST_COMMAND_READ_32 else
                                    "110";
  fbist_oc_axim_o.m0_axi_arburst <= (others => '0');
  fbist_oc_axim_o.m0_axi_arlock  <= (others => '0');
  fbist_oc_axim_o.m0_axi_arcache <= (others => '0');
  fbist_oc_axim_o.m0_axi_arprot  <= (others => '0');
  fbist_oc_axim_o.m0_axi_arvalid <= axi_command_state_q = ST_AXI_COMMAND_SENDING_READ;

  -- AXI Responses
  -- Downstream we know that we'll only ever receive one TL response a cycle,
  -- so we know we'll only receive one response a cycle here.
  fbist_oc_axim_o.m0_axi_bready <= '1';
  fbist_oc_axim_o.m0_axi_rready <= '1';

  axi_chk_response       <= FBIST_RESPONSE_WRITE_OK   when fbist_oc_axim_i.m0_axi_bvalid = '1' and fbist_oc_axim_i.m0_axi_bresp = "00" else
                            FBIST_RESPONSE_WRITE_FAIL when fbist_oc_axim_i.m0_axi_bvalid = '1' and fbist_oc_axim_i.m0_axi_bresp /= "00" else
                            FBIST_RESPONSE_READ_OK    when fbist_oc_axim_i.m0_axi_rvalid = '1' and fbist_oc_axim_i.m0_axi_rresp = "00" else
                            FBIST_RESPONSE_READ_FAIL  when fbist_oc_axim_i.m0_axi_rvalid = '1' and fbist_oc_axim_i.m0_axi_rresp /= "00" else
                            FBIST_RESPONSE_NOP;
  axi_chk_response_data  <= fbist_oc_axim_i.m0_axi_rdata;
  axi_chk_response_tag   <= x"0" & fbist_oc_axim_i.m0_axi_bid when fbist_oc_axim_i.m0_axi_bvalid = '1' else
                            x"0" & fbist_oc_axim_i.m0_axi_rid when fbist_oc_axim_i.m0_axi_rvalid = '1' else
                            x"0000";
  axi_chk_response_dpart <= fbist_oc_axim_i.m0_axi_ruser(1 downto 0);
  axi_chk_response_ow    <= fbist_oc_axim_i.m0_axi_ruser(2);
  axi_chk_response_valid <= fbist_oc_axim_i.m0_axi_bvalid = '1' or
                            fbist_oc_axim_i.m0_axi_rvalid = '1';

  -- This shouldn't happen, because we should only get one response a cycle.
  fbist_axi_response_collision <= fbist_oc_axim_i.m0_axi_bvalid = '1' and fbist_oc_axim_i.m0_axi_rvalid = '1';
  --synopsys translate_off
  assert not (rising_edge(cclk) and fbist_axi_response_collision = '1' and not sys_reset = '1') report "read and write response collision in fbist_axi" severity error;
  --synopsys translate_on

  -- Inject an address error to solicit a fail response due to an unaligned address
  address_inject_enable_d           <= cfg_axi_address_inject_enable;
  address_inject_enable_rising_edge <= address_inject_enable_d and not address_inject_enable_q;

  inject_address_error_valid_d <= '1' when address_inject_enable_rising_edge = '1' else
                                  '0' when address_error_injected = '1'            else
                                  inject_address_error_valid_q;

  address_error_injected      <= inject_address_error_valid_q = '1' and fifo_wr_data_valid = '1' and (dgen_axi_command = FBIST_COMMAND_WRITE_128 or
                                                                                                      dgen_axi_command = FBIST_COMMAND_WRITE_64 or
                                                                                                      dgen_axi_command = FBIST_COMMAND_WRITE_32 or
                                                                                                      dgen_axi_command = FBIST_COMMAND_READ_128 or
                                                                                                      dgen_axi_command = FBIST_COMMAND_READ_64 or
                                                                                                      dgen_axi_command = FBIST_COMMAND_READ_32
                                                                                                      );
  cfg_axi_address_inject_done <= address_error_injected;

  dgen_axi_command_address_inj(63 downto 1) <= dgen_axi_command_address(63 downto 1);
  dgen_axi_command_address_inj(0)           <= dgen_axi_command_address(0) xor inject_address_error_valid_q;

  -- Inject a data error to solicit a data miscompare in the checker
  data_inject_enable_d           <= cfg_axi_data_inject_enable;
  data_inject_enable_rising_edge <= data_inject_enable_d and not data_inject_enable_q;

  inject_data_error_valid_d <= '1' when data_inject_enable_rising_edge = '1' else
                               '0' when data_error_injected = '1'            else
                               inject_data_error_valid_q;

  data_error_injected      <= inject_data_error_valid_q = '1' and fifo_wr_data_valid = '1' and (dgen_axi_command = FBIST_COMMAND_WRITE_128 or
                                                                                                dgen_axi_command = FBIST_COMMAND_WRITE_64 or
                                                                                                dgen_axi_command = FBIST_COMMAND_WRITE_32
                                                                                                );
  cfg_axi_data_inject_done <= data_error_injected;

  dgen_axi_command_data_inj(511 downto 1) <= dgen_axi_command_data(511 downto 1);
  dgen_axi_command_data_inj(0)            <= dgen_axi_command_data(0) xor inject_data_error_valid_q;

  -- FIFO Write Data
  -- Width must be a multiple of 32 for BRAM to work
  fifo_wr_data(7 downto 0)     <= dgen_axi_command;
  fifo_wr_data(71 downto 8)    <= dgen_axi_command_address_inj;
  fifo_wr_data(583 downto 72)  <= dgen_axi_command_data_inj;
  fifo_wr_data(586 downto 584) <= dgen_axi_command_engine;
  fifo_wr_data(602 downto 587) <= dgen_axi_command_tag;
  fifo_wr_data(607 downto 603) <= "00000";
  fifo_wr_data_valid           <= dgen_axi_command_valid and not fbist_freeze;

  -- FIFO Read Data
  fifo_axi_command         <= fifo_rd_data(7 downto 0);
  fifo_axi_command_address <= fifo_rd_data(71 downto 8);
  fifo_axi_command_data    <= fifo_rd_data(583 downto 72);
  fifo_axi_command_engine  <= fifo_rd_data(586 downto 584); -- Unused
  fifo_axi_command_tag     <= fifo_rd_data(602 downto 587);
  fifo_axi_command_valid   <= fifo_rd_data_valid;

  fifo_rd_data_taken <= (axi_command_state_q = ST_AXI_COMMAND_SENT_WRITE) or
                        (axi_command_state_q = ST_AXI_COMMAND_SENT_WRITE_DATA_2) or
                        (axi_command_state_q = ST_AXI_COMMAND_SENT_READ) or
                        (axi_command_state_q = ST_AXI_COMMAND_DROP);
                        -- No error if non-NOP command is dropped

  axi_fifo_full_gate <= not fifo_full;
  fifo_rd_data_valid <= not fifo_empty;

--   fifo : entity work.async_fifo
--     generic map (
--       WIDTH         => 608,
--       ADDRESS_WIDTH => 4
--       )
--     port map (
--       w_clock       => sysclk,
--       r_clock       => cclk,
--       reset         => sys_reset,
--       w_full        => fifo_full,
--       r_empty       => fifo_empty,
--       w_data        => fifo_wr_data,
--       w_data_valid  => fifo_wr_data_valid,
--       r_data        => fifo_rd_data,
--       r_data_taken  => fifo_rd_data_taken
--       );
 fifo : entity work.sync_fifo_dist
    generic map (
      WIDTH         => 608,
      ADDRESS_WIDTH => 2
      )
    port map (
      clock       => cclk,
      reset         => sys_reset,
      w_full        => fifo_full,
      r_empty       => fifo_empty,
      w_data        => fifo_wr_data,
      w_data_valid  => fifo_wr_data_valid,
      r_data        => fifo_rd_data,
      r_data_taken  => fifo_rd_data_taken
      );

  --------------------------------------------------------------------------------------------------
  -- debug
  --------------------------------------------------------------------------------------------------
  dbg_m0_axi_rvalid_d <= fbist_oc_axim_i.m0_axi_rvalid;
  dbg_m0_axi_rvalid_1_d <= dbg_m0_axi_rvalid_q;
  dbg_m0_axi_rvalid_2_d <= dbg_m0_axi_rvalid_1_q;

  dbg_m0_axi_bvalid_d <= fbist_oc_axim_i.m0_axi_bvalid;
  dbg_m0_axi_bvalid_1_d <= dbg_m0_axi_bvalid_q;
  dbg_m0_axi_bvalid_2_d <= dbg_m0_axi_bvalid_1_q;

  dbg_m0_axi_rresp_d <= fbist_oc_axim_i.m0_axi_rresp;
  dbg_m0_axi_rresp_1_d <= dbg_m0_axi_rresp_q;
  dbg_m0_axi_rresp_2_d <= dbg_m0_axi_rresp_1_q;

  dbg_m0_axi_bresp_d <= fbist_oc_axim_i.m0_axi_bresp;
  dbg_m0_axi_bresp_1_d <= dbg_m0_axi_bresp_q;
  dbg_m0_axi_bresp_2_d <= dbg_m0_axi_bresp_1_q;

  -----------------------------------------------------------------------------
  -- Latches
  -----------------------------------------------------------------------------
  process (cclk) is
  begin
    if rising_edge(cclk) then
      if (creset = '1') then
        axi_command_state_q  <= ST_AXI_COMMAND_IDLE;

        --NSR debug
        dbg_m0_axi_rvalid_q  <= '0';
        dbg_m0_axi_bvalid_q  <= '0';
        dbg_m0_axi_rvalid_1_q  <= '0';
        dbg_m0_axi_bvalid_1_q  <= '0';
        dbg_m0_axi_rvalid_2_q  <= '0';
        dbg_m0_axi_bvalid_2_q  <= '0';

        dbg_m0_axi_rresp_q  <= "00";
        dbg_m0_axi_bresp_q  <= "00";
        dbg_m0_axi_rresp_1_q  <= "00";
        dbg_m0_axi_bresp_1_q  <= "00";
        dbg_m0_axi_rresp_2_q  <= "00";
        dbg_m0_axi_bresp_2_q  <= "00";

        inject_address_error_valid_q <= '0';
        address_inject_enable_q      <= '0';
        data_inject_enable_q         <= '0';
        inject_data_error_valid_q    <= '0';
        
      else
        axi_command_state_q  <= axi_command_state_d;

        --NSR Debug
        dbg_m0_axi_rvalid_q   <= dbg_m0_axi_rvalid_d  ;
        dbg_m0_axi_bvalid_q   <= dbg_m0_axi_bvalid_d  ;
        dbg_m0_axi_rvalid_1_q <= dbg_m0_axi_rvalid_1_d;
        dbg_m0_axi_bvalid_1_q <= dbg_m0_axi_bvalid_1_d;
        dbg_m0_axi_rvalid_2_q <= dbg_m0_axi_rvalid_2_d;
        dbg_m0_axi_bvalid_2_q <= dbg_m0_axi_bvalid_2_d;

        dbg_m0_axi_rresp_q   <= dbg_m0_axi_rresp_d  ;
        dbg_m0_axi_bresp_q   <= dbg_m0_axi_bresp_d  ;
        dbg_m0_axi_rresp_1_q <= dbg_m0_axi_rresp_1_d;
        dbg_m0_axi_bresp_1_q <= dbg_m0_axi_bresp_1_d;
        dbg_m0_axi_rresp_2_q <= dbg_m0_axi_rresp_2_d;
        dbg_m0_axi_bresp_2_q <= dbg_m0_axi_bresp_2_d;

        inject_address_error_valid_q <= inject_address_error_valid_d;
        address_inject_enable_q      <= address_inject_enable_d;
        data_inject_enable_q         <= data_inject_enable_d;
        inject_data_error_valid_q    <= inject_data_error_valid_d;
      end if;
    end if;
  end process;
  
end fbist_axi;
