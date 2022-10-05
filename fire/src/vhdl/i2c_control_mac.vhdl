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

entity i2c_control_mac is
  generic (
    axi_iic_offset : std_ulogic_vector(63 downto 0) := (others => '0')
  );
  port (
    sysclk         : in  std_ulogic;
    sys_resetn     : in  std_ulogic;
    m0_axi_i       : in  t_AXI3_64_MASTER_INPUT;
    m0_axi_o       : out t_AXI3_64_MASTER_OUTPUT
  );
end i2c_control_mac;

architecture i2c_control_mac of i2c_control_mac is

  signal m0_axi_aresetn : std_ulogic;
  signal m0_axi_awvalid : std_ulogic;
  signal m0_axi_awready : std_ulogic;
  signal m0_axi_awaddr  : std_ulogic_vector(63 downto 0);
  signal m0_axi_awsize  : std_ulogic_vector(2 downto 0);
  signal m0_axi_awprot  : std_ulogic_vector(2 downto 0);
  signal m0_axi_wvalid  : std_ulogic;
  signal m0_axi_wready  : std_ulogic;
  signal m0_axi_wdata   : std_ulogic_vector(63 downto 0);
  signal m0_axi_wstrb   : std_ulogic_vector(7 downto 0);
  signal m0_axi_bvalid  : std_ulogic;
  signal m0_axi_bready  : std_ulogic;
  signal m0_axi_bresp   : std_ulogic_vector(1 downto 0);
  signal m0_axi_arvalid : std_ulogic;
  signal m0_axi_arready : std_ulogic;
  signal m0_axi_araddr  : std_ulogic_vector(63 downto 0);
  signal m0_axi_arsize  : std_ulogic_vector(2 downto 0);
  signal m0_axi_araddr_hold_q  : std_ulogic_vector(63 downto 0);
  signal m0_axi_arsize_hold_q  : std_ulogic_vector(2 downto 0);
  signal m0_axi_araddr_hold_d  : std_ulogic_vector(63 downto 0);
  signal m0_axi_arsize_hold_d  : std_ulogic_vector(2 downto 0);
  signal m0_axi_arprot  : std_ulogic_vector(2 downto 0);
  signal m0_axi_rvalid  : std_ulogic;
  signal m0_axi_rready  : std_ulogic;
  signal m0_axi_rdata   : std_ulogic_vector(63 downto 0);
  signal m0_axi_rresp   : std_ulogic_vector(1 downto 0);

  type ST_CONTROL is (
    ST_CONTROL_IDLE,                    -- 0
    ST_CONTROL_SET_SOFTR,               -- 1
    ST_CONTROL_SET_CR_0,                -- 2
    ST_CONTROL_SET_CR_1,                -- 3
    ST_CONTROL_SET_ADR,                 -- 4
    ST_CONTROL_SET_RX_FIFO_PIRQ,        -- 5
    ST_CONTROL_WAIT_STATUS_ADDRESSED_AS_SLAVE_SET_AND_RECEIVE_FIFO_EMPTY_CLEAR,  -- 6
    ST_CONTROL_WAIT_STATUS_ADDRESSED_AS_SLAVE_CLEAR,  -- 7
    ST_CONTROL_GET_RX_FIFO0,            -- 8
    ST_CONTROL_GET_RX_FIFO1,            -- 9
    ST_CONTROL_GET_RX_FIFO2,            -- 10
    ST_CONTROL_GET_RX_FIFO3,            -- 11
    ST_CONTROL_GET_RX_FIFO4,            -- 12
    ST_CONTROL_GET_RX_FIFO5,            -- 13
    ST_CONTROL_GET_RX_FIFO6,            -- 14
    ST_CONTROL_GET_RX_FIFO7,            -- 15
    ST_CONTROL_GET_STATUS_RECEIVE_FIFO_EMPTY,         -- 16
    ST_CONTROL_I2C_READ,                -- 17
    ST_CONTROL_I2C_WRITE,               -- 18
    ST_CONTROL_WAIT_STATUS_TRANSMIT_FIFO_EMPTY_SET,   -- 19
    ST_CONTROL_ERROR                    -- 20
  );

  signal control_state : ST_CONTROL := ST_CONTROL_IDLE;

  type ST_AXI_READ is (
    ST_AXI_READ_IDLE,                   -- 0
    ST_AXI_READ_CMD,                    -- 1
    ST_AXI_READ_WAIT,                   -- 2
    ST_AXI_READ_DONE,                   -- 3
    ST_AXI_READ_ERROR                   -- 4
  );

  signal axi_read_state                    : ST_AXI_READ := ST_AXI_READ_IDLE;
  signal axi_read_valid                    : std_ulogic;
  signal axi_read_address                  : std_ulogic_vector(63 downto 0);
  signal axi_read_data                     : std_ulogic_vector(63 downto 0);
  signal axi_read_valid_during_i2c_read    : std_ulogic;
  signal axi_read_address_during_i2c_read  : std_ulogic_vector(63 downto 0);
  signal axi_read_valid_during_i2c_write   : std_ulogic;
  signal axi_read_address_during_i2c_write : std_ulogic_vector(63 downto 0);

  type ST_AXI_WRITE is (
    ST_AXI_WRITE_IDLE,                  -- 0
    ST_AXI_WRITE_CMD,                   -- 1
    ST_AXI_WRITE_DATA,                  -- 2
    ST_AXI_WRITE_WAIT,                  -- 3
    ST_AXI_WRITE_DONE,                  -- 4
    ST_AXI_WRITE_ERROR                  -- 5
  );

  type ST_I2C_READ is (
    ST_I2C_READ_IDLE,                   -- 0
    ST_I2C_READ_GET_AXI_REG,            -- 1
    ST_I2C_READ_SET_TX_FIFO0,           -- 2
    ST_I2C_READ_SET_TX_FIFO1,           -- 3
    ST_I2C_READ_SET_TX_FIFO2,           -- 4
    ST_I2C_READ_SET_TX_FIFO3,           -- 5
    ST_I2C_READ_SET_TX_FIFO4,           -- 6
    ST_I2C_READ_SET_TX_FIFO5,           -- 7
    ST_I2C_READ_SET_TX_FIFO6,           -- 8
    ST_I2C_READ_SET_TX_FIFO7,           -- 9
    ST_I2C_READ_DONE,                   -- 10
    ST_I2C_READ_ERROR                   -- 11
  );

  signal i2c_read_state : ST_I2C_READ := ST_I2C_READ_IDLE;

  type ST_I2C_WRITE is (
    ST_I2C_WRITE_IDLE,                  -- 0
    ST_I2C_WRITE_GET_RX_FIFO0,          -- 1
    ST_I2C_WRITE_GET_RX_FIFO1,          -- 2
    ST_I2C_WRITE_GET_RX_FIFO2,          -- 3
    ST_I2C_WRITE_GET_RX_FIFO3,          -- 4
    ST_I2C_WRITE_GET_RX_FIFO4,          -- 5
    ST_I2C_WRITE_GET_RX_FIFO5,          -- 6
    ST_I2C_WRITE_GET_RX_FIFO6,          -- 7
    ST_I2C_WRITE_GET_RX_FIFO7,          -- 8
    ST_I2C_WRITE_SET_AXI_REG,           -- 9
    ST_I2C_WRITE_DONE,                  -- 10
    ST_I2C_WRITE_ERROR                  -- 11
  );

  signal i2c_write_state : ST_I2C_WRITE := ST_I2C_WRITE_IDLE;

  signal axi_write_state                    : ST_AXI_WRITE := ST_AXI_WRITE_IDLE;
  signal axi_write_valid                    : std_ulogic;
  signal axi_write_address                  : std_ulogic_vector(63 downto 0);
  signal axi_write_data                     : std_ulogic_vector(63 downto 0);
  signal axi_write_valid_during_i2c_read    : std_ulogic;
  signal axi_write_address_during_i2c_read  : std_ulogic_vector(63 downto 0);
  signal axi_write_data_during_i2c_read     : std_ulogic_vector(63 downto 0);
  signal axi_write_valid_during_i2c_write   : std_ulogic;
  signal axi_write_address_during_i2c_write : std_ulogic_vector(63 downto 0);
  signal axi_write_data_during_i2c_write    : std_ulogic_vector(63 downto 0);

  signal axi_read_state_is_done  : std_ulogic;
  signal axi_write_state_is_done : std_ulogic;
  signal i2c_read_state_is_done  : std_ulogic;
  signal i2c_write_state_is_done : std_ulogic;

  signal address_from_i2c : std_ulogic_vector(63 downto 0) := X"0000000000000000";
  signal data_to_i2c      : std_ulogic_vector(63 downto 0) := X"0000000000000000";
  signal data_from_i2c    : std_ulogic_vector(63 downto 0) := X"0000000000000000";

  attribute mark_debug : string;
  attribute keep       : string;
  --For ILA, commented some out for space
  attribute mark_debug of control_state            : signal is "true";
  attribute mark_debug of axi_read_state           : signal is "true";
  attribute mark_debug of i2c_read_state           : signal is "true";
  attribute mark_debug of axi_write_state          : signal is "true";
  attribute mark_debug of i2c_write_state          : signal is "true";
  attribute mark_debug of address_from_i2c         : signal is "true";
  attribute mark_debug of data_to_i2c              : signal is "true";
  attribute mark_debug of data_from_i2c            : signal is "true";

begin

  m0_axi_aresetn          <= sys_resetn;
  m0_axi_o.m0_axi_aresetn <= m0_axi_aresetn;
  m0_axi_o.m0_axi_awid    <= (others => '0');
  m0_axi_o.m0_axi_awaddr  <= m0_axi_awaddr;
  m0_axi_o.m0_axi_awlen   <= (others => '0');
  m0_axi_o.m0_axi_awsize  <= m0_axi_awsize;
  m0_axi_o.m0_axi_awburst <= "01";
  m0_axi_o.m0_axi_awlock  <= (others => '0');
  m0_axi_o.m0_axi_awcache <= (others => '0');
  m0_axi_o.m0_axi_awprot  <= m0_axi_awprot;
  m0_axi_o.m0_axi_awvalid <= m0_axi_awvalid;
  m0_axi_awready          <= m0_axi_i.m0_axi_awready;
  m0_axi_o.m0_axi_wid     <= (others => '0');
  m0_axi_o.m0_axi_wdata   <= m0_axi_wdata;
  m0_axi_o.m0_axi_wstrb   <= m0_axi_wstrb;
  m0_axi_o.m0_axi_wlast   <= '1';
  m0_axi_o.m0_axi_wvalid  <= m0_axi_wvalid;
  m0_axi_wready           <= m0_axi_i.m0_axi_wready;
  m0_axi_bresp            <= m0_axi_i.m0_axi_bresp;
  m0_axi_bvalid           <= m0_axi_i.m0_axi_bvalid;
  m0_axi_o.m0_axi_bready  <= m0_axi_bready;
  m0_axi_o.m0_axi_arid    <= (others => '0');
  m0_axi_o.m0_axi_araddr  <= m0_axi_araddr;
  m0_axi_o.m0_axi_arlen   <= (others => '0');
  m0_axi_o.m0_axi_arsize  <= m0_axi_arsize;
  m0_axi_o.m0_axi_arburst <= "01";
  m0_axi_o.m0_axi_arlock  <= (others => '0');
  m0_axi_o.m0_axi_arcache <= (others => '0');
  m0_axi_o.m0_axi_arprot  <= m0_axi_arprot;
  m0_axi_o.m0_axi_arvalid <= m0_axi_arvalid;
  m0_axi_arready          <= m0_axi_i.m0_axi_arready;
  m0_axi_rdata            <= m0_axi_i.m0_axi_rdata;
  m0_axi_rresp            <= m0_axi_i.m0_axi_rresp;
  m0_axi_rvalid           <= m0_axi_i.m0_axi_rvalid;
  m0_axi_o.m0_axi_rready  <= m0_axi_rready;

  m0_axi_awprot             <= (others => '0');
  m0_axi_arprot             <= (others => '0');

  axi_read_state_is_done  <= '1' when axi_read_state = ST_AXI_READ_DONE   else '0';
  axi_write_state_is_done <= '1' when axi_write_state = ST_AXI_WRITE_DONE else '0';
  i2c_read_state_is_done  <= '1' when i2c_read_state = ST_I2C_READ_DONE   else '0';
  i2c_write_state_is_done <= '1' when i2c_write_state = ST_I2C_WRITE_DONE else '0';

  with control_state select axi_read_valid <=
    '1'                             when ST_CONTROL_WAIT_STATUS_ADDRESSED_AS_SLAVE_SET_AND_RECEIVE_FIFO_EMPTY_CLEAR,
    '1'                             when ST_CONTROL_WAIT_STATUS_ADDRESSED_AS_SLAVE_CLEAR,
    '1'                             when ST_CONTROL_GET_RX_FIFO0,
    '1'                             when ST_CONTROL_GET_RX_FIFO1,
    '1'                             when ST_CONTROL_GET_RX_FIFO2,
    '1'                             when ST_CONTROL_GET_RX_FIFO3,
    '1'                             when ST_CONTROL_GET_RX_FIFO4,
    '1'                             when ST_CONTROL_GET_RX_FIFO5,
    '1'                             when ST_CONTROL_GET_RX_FIFO6,
    '1'                             when ST_CONTROL_GET_RX_FIFO7,
    '1'                             when ST_CONTROL_GET_STATUS_RECEIVE_FIFO_EMPTY,
    axi_read_valid_during_i2c_read  when ST_CONTROL_I2C_READ,
    axi_read_valid_during_i2c_write when ST_CONTROL_I2C_WRITE,
    '1'                             when ST_CONTROL_WAIT_STATUS_TRANSMIT_FIFO_EMPTY_SET,
    '0'                             when others;

  with control_state select axi_read_address <=
    axi_iic_offset(63 downto 12) & x"104" when ST_CONTROL_WAIT_STATUS_ADDRESSED_AS_SLAVE_SET_AND_RECEIVE_FIFO_EMPTY_CLEAR,
    axi_iic_offset(63 downto 12) & x"104" when ST_CONTROL_WAIT_STATUS_ADDRESSED_AS_SLAVE_CLEAR,
    axi_iic_offset(63 downto 12) & x"10C" when ST_CONTROL_GET_RX_FIFO0,
    axi_iic_offset(63 downto 12) & x"10C" when ST_CONTROL_GET_RX_FIFO1,
    axi_iic_offset(63 downto 12) & x"10C" when ST_CONTROL_GET_RX_FIFO2,
    axi_iic_offset(63 downto 12) & x"10C" when ST_CONTROL_GET_RX_FIFO3,
    axi_iic_offset(63 downto 12) & x"10C" when ST_CONTROL_GET_RX_FIFO4,
    axi_iic_offset(63 downto 12) & x"10C" when ST_CONTROL_GET_RX_FIFO5,
    axi_iic_offset(63 downto 12) & x"10C" when ST_CONTROL_GET_RX_FIFO6,
    axi_iic_offset(63 downto 12) & x"10C" when ST_CONTROL_GET_RX_FIFO7,
    axi_iic_offset(63 downto 12) & x"104" when ST_CONTROL_GET_STATUS_RECEIVE_FIFO_EMPTY,
    axi_read_address_during_i2c_read      when ST_CONTROL_I2C_READ,
    axi_read_address_during_i2c_write     when ST_CONTROL_I2C_WRITE,
    axi_iic_offset(63 downto 12) & x"104" when ST_CONTROL_WAIT_STATUS_TRANSMIT_FIFO_EMPTY_SET,
    (others => '0')                       when others;

  with i2c_read_state select axi_read_valid_during_i2c_read <=
    '1' when ST_I2C_READ_GET_AXI_REG,
    '0' when others;

  with i2c_read_state select axi_read_address_during_i2c_read <=
    address_from_i2c when ST_I2C_READ_GET_AXI_REG,
    (others => '0')  when others;

  with i2c_write_state select axi_read_valid_during_i2c_write <=
    '1' when ST_I2C_WRITE_GET_RX_FIFO0,
    '1' when ST_I2C_WRITE_GET_RX_FIFO1,
    '1' when ST_I2C_WRITE_GET_RX_FIFO2,
    '1' when ST_I2C_WRITE_GET_RX_FIFO3,
    '1' when ST_I2C_WRITE_GET_RX_FIFO4,
    '1' when ST_I2C_WRITE_GET_RX_FIFO5,
    '1' when ST_I2C_WRITE_GET_RX_FIFO6,
    '1' when ST_I2C_WRITE_GET_RX_FIFO7,
    '0' when others;

  with i2c_write_state select axi_read_address_during_i2c_write <=
    axi_iic_offset(63 downto 12) & X"10C" when ST_I2C_WRITE_GET_RX_FIFO0,
    axi_iic_offset(63 downto 12) & X"10C" when ST_I2C_WRITE_GET_RX_FIFO1,
    axi_iic_offset(63 downto 12) & X"10C" when ST_I2C_WRITE_GET_RX_FIFO2,
    axi_iic_offset(63 downto 12) & X"10C" when ST_I2C_WRITE_GET_RX_FIFO3,
    axi_iic_offset(63 downto 12) & X"10C" when ST_I2C_WRITE_GET_RX_FIFO4,
    axi_iic_offset(63 downto 12) & X"10C" when ST_I2C_WRITE_GET_RX_FIFO5,
    axi_iic_offset(63 downto 12) & X"10C" when ST_I2C_WRITE_GET_RX_FIFO6,
    axi_iic_offset(63 downto 12) & X"10C" when ST_I2C_WRITE_GET_RX_FIFO7,
    (others => '0')                       when others;

  with control_state select axi_write_valid <=
    '1'                              when ST_CONTROL_SET_SOFTR,
    '1'                              when ST_CONTROL_SET_CR_0,
    '1'                              when ST_CONTROL_SET_CR_1,
    '1'                              when ST_CONTROL_SET_ADR,
    '1'                              when ST_CONTROL_SET_RX_FIFO_PIRQ,
    axi_write_valid_during_i2c_read  when ST_CONTROL_I2C_READ,
    axi_write_valid_during_i2c_write when ST_CONTROL_I2C_WRITE,
    '0'                              when others;

  with control_state select axi_write_address <=
    axi_iic_offset(63 downto 12) & X"040" when ST_CONTROL_SET_SOFTR,
    axi_iic_offset(63 downto 12) & X"100" when ST_CONTROL_SET_CR_0,
    axi_iic_offset(63 downto 12) & X"100" when ST_CONTROL_SET_CR_1,
    axi_iic_offset(63 downto 12) & X"110" when ST_CONTROL_SET_ADR,
    axi_iic_offset(63 downto 12) & X"120" when ST_CONTROL_SET_RX_FIFO_PIRQ,
    axi_write_address_during_i2c_read     when ST_CONTROL_I2C_READ,
    axi_write_address_during_i2c_write    when ST_CONTROL_I2C_WRITE,
    (others => '0')                       when others;

  -- Duplicate data on first and second half to make things simpler by
  -- not figuring out the correct address offset. One half is don't
  -- care, and with these scheme it doesn't matter which.
  with control_state select axi_write_data <=
    X"0000000A0000000A"             when ST_CONTROL_SET_SOFTR,
    X"0000000000000000"             when ST_CONTROL_SET_CR_0,
    X"0000000100000001"             when ST_CONTROL_SET_CR_1,
    X"0000007000000070"             when ST_CONTROL_SET_ADR,
    X"000000FF000000FF"             when ST_CONTROL_SET_RX_FIFO_PIRQ,
    axi_write_data_during_i2c_read  when ST_CONTROL_I2C_READ,
    axi_write_data_during_i2c_write when ST_CONTROL_I2C_WRITE,
    (others => '0')                 when others;

  with i2c_read_state select axi_write_valid_during_i2c_read <=
    '1' when ST_I2C_READ_SET_TX_FIFO0,
    '1' when ST_I2C_READ_SET_TX_FIFO1,
    '1' when ST_I2C_READ_SET_TX_FIFO2,
    '1' when ST_I2C_READ_SET_TX_FIFO3,
    '1' when ST_I2C_READ_SET_TX_FIFO4,
    '1' when ST_I2C_READ_SET_TX_FIFO5,
    '1' when ST_I2C_READ_SET_TX_FIFO6,
    '1' when ST_I2C_READ_SET_TX_FIFO7,
    '0' when others;

  with i2c_read_state select axi_write_address_during_i2c_read <=
    axi_iic_offset(63 downto 12) & X"108" when ST_I2C_READ_SET_TX_FIFO0,
    axi_iic_offset(63 downto 12) & X"108" when ST_I2C_READ_SET_TX_FIFO1,
    axi_iic_offset(63 downto 12) & X"108" when ST_I2C_READ_SET_TX_FIFO2,
    axi_iic_offset(63 downto 12) & X"108" when ST_I2C_READ_SET_TX_FIFO3,
    axi_iic_offset(63 downto 12) & X"108" when ST_I2C_READ_SET_TX_FIFO4,
    axi_iic_offset(63 downto 12) & X"108" when ST_I2C_READ_SET_TX_FIFO5,
    axi_iic_offset(63 downto 12) & X"108" when ST_I2C_READ_SET_TX_FIFO6,
    axi_iic_offset(63 downto 12) & X"108" when ST_I2C_READ_SET_TX_FIFO7,
    (others => '0')                       when others;

  -- Duplicate data on first and second half to make things simpler by
  -- not figuring out the correct address offset. One half is don't
  -- care, and with these scheme it doesn't matter which.
  with i2c_read_state select axi_write_data_during_i2c_read <=
    X"000000" & data_to_i2c(63 downto 56) & X"000000" & data_to_i2c(63 downto 56) when ST_I2C_READ_SET_TX_FIFO0,
    X"000000" & data_to_i2c(55 downto 48) & X"000000" & data_to_i2c(55 downto 48) when ST_I2C_READ_SET_TX_FIFO1,
    X"000000" & data_to_i2c(47 downto 40) & X"000000" & data_to_i2c(47 downto 40) when ST_I2C_READ_SET_TX_FIFO2,
    X"000000" & data_to_i2c(39 downto 32) & X"000000" & data_to_i2c(39 downto 32) when ST_I2C_READ_SET_TX_FIFO3,
    X"000000" & data_to_i2c(31 downto 24) & X"000000" & data_to_i2c(31 downto 24) when ST_I2C_READ_SET_TX_FIFO4,
    X"000000" & data_to_i2c(23 downto 16) & X"000000" & data_to_i2c(23 downto 16) when ST_I2C_READ_SET_TX_FIFO5,
    X"000000" & data_to_i2c(15 downto 8)  & X"000000" & data_to_i2c(15 downto 8)  when ST_I2C_READ_SET_TX_FIFO6,
    X"000000" & data_to_i2c(7 downto 0)   & X"000000" & data_to_i2c(7 downto 0)   when ST_I2C_READ_SET_TX_FIFO7,
    (others => '0')                       when others;

  with i2c_write_state select axi_write_valid_during_i2c_write <=
    '1' when ST_I2C_WRITE_SET_AXI_REG,
    '0' when others;

  with i2c_write_state select axi_write_address_during_i2c_write <=
    address_from_i2c when ST_I2C_WRITE_SET_AXI_REG,
    (others => '0')  when others;

  with i2c_write_state select axi_write_data_during_i2c_write <=
    data_from_i2c when ST_I2C_WRITE_SET_AXI_REG,
    (others => '0') when others;

  process (sysclk) is
  begin
    if rising_edge(sysclk) then
      if (sys_resetn = '0') then
        control_state    <= ST_CONTROL_IDLE;
        i2c_read_state   <= ST_I2C_READ_IDLE;
        i2c_write_state  <= ST_I2C_WRITE_IDLE;
        axi_read_state   <= ST_AXI_READ_IDLE;
        axi_write_state  <= ST_AXI_WRITE_IDLE;
        address_from_i2c <= (others => '0');
        data_to_i2c      <= (others => '0');
        data_from_i2c    <= (others => '0');

      else
      m0_axi_araddr_hold_q  <= m0_axi_araddr_hold_d; --: std_ulogic_vector(63 downto 0);
      m0_axi_arsize_hold_q  <= m0_axi_arsize_hold_d; --: std_ulogic_vector(2 downto 0);
        -- CONTROL STATE MACHINE
        case control_state is
          when ST_CONTROL_IDLE =>
            control_state <= ST_CONTROL_SET_SOFTR;
          when ST_CONTROL_SET_SOFTR =>
            if (axi_write_state_is_done = '1') then
              control_state <= ST_CONTROL_SET_CR_0;
            end if;
          when ST_CONTROL_SET_CR_0 =>
            if (axi_write_state_is_done = '1') then
              control_state <= ST_CONTROL_SET_CR_1;
            end if;
          when ST_CONTROL_SET_CR_1 =>
            if (axi_write_state_is_done = '1') then
              control_state <= ST_CONTROL_SET_ADR;
            end if;
          when ST_CONTROL_SET_ADR =>
            if (axi_write_state_is_done = '1') then
              control_state <= ST_CONTROL_SET_RX_FIFO_PIRQ;
            end if;
          when ST_CONTROL_SET_RX_FIFO_PIRQ =>
            if (axi_write_state_is_done = '1') then
              control_state <= ST_CONTROL_WAIT_STATUS_ADDRESSED_AS_SLAVE_SET_AND_RECEIVE_FIFO_EMPTY_CLEAR;
            end if;
          when ST_CONTROL_WAIT_STATUS_ADDRESSED_AS_SLAVE_SET_AND_RECEIVE_FIFO_EMPTY_CLEAR =>
            if (axi_read_state_is_done = '1' and axi_read_data(1) = '1' and axi_read_data(6) = '0') then
              control_state <= ST_CONTROL_WAIT_STATUS_ADDRESSED_AS_SLAVE_CLEAR;
            end if;
          when ST_CONTROL_WAIT_STATUS_ADDRESSED_AS_SLAVE_CLEAR =>
            -- This used to only check bit 1, but because the RX_FIFO
            -- is 16 entries, it would fill up when using 8 byte
            -- addresses and 8 byte data. Because we send 16 bytes max
            -- total, add an additional check for the fifo being full,
            -- otherwise we'll get stuck here because the AXI IIC
            -- won't ACK the last byte and we know everything is
            -- here. If we ever send more than 16 bytes, we would need
            -- a check at some later point to wait for the next bytes
            -- to arrive.
            if (axi_read_state_is_done = '1' and (axi_read_data(1) = '0' or axi_read_data(5) = '1')) then
              control_state <= ST_CONTROL_GET_RX_FIFO0;
            end if;
          when ST_CONTROL_GET_RX_FIFO0 =>
            if (axi_read_state_is_done = '1') then
              address_from_i2c(63 downto 56) <= axi_read_data(7 downto 0);
              control_state <= ST_CONTROL_GET_RX_FIFO1;
            end if;
          when ST_CONTROL_GET_RX_FIFO1 =>
            if (axi_read_state_is_done = '1') then
              address_from_i2c(55 downto 48) <= axi_read_data(7 downto 0);
              control_state <= ST_CONTROL_GET_RX_FIFO2;
            end if;
          when ST_CONTROL_GET_RX_FIFO2 =>
            if (axi_read_state_is_done = '1') then
              address_from_i2c(47 downto 40) <= axi_read_data(7 downto 0);
              control_state <= ST_CONTROL_GET_RX_FIFO3;
            end if;
          when ST_CONTROL_GET_RX_FIFO3 =>
            if (axi_read_state_is_done = '1') then
              address_from_i2c(39 downto 32) <= axi_read_data(7 downto 0);
              control_state <= ST_CONTROL_GET_RX_FIFO4;
            end if;
          when ST_CONTROL_GET_RX_FIFO4 =>
            if (axi_read_state_is_done = '1') then
              address_from_i2c(31 downto 24) <= axi_read_data(7 downto 0);
              control_state <= ST_CONTROL_GET_RX_FIFO5;
            end if;
          when ST_CONTROL_GET_RX_FIFO5 =>
            if (axi_read_state_is_done = '1') then
              address_from_i2c(23 downto 16) <= axi_read_data(7 downto 0);
              control_state <= ST_CONTROL_GET_RX_FIFO6;
            end if;
          when ST_CONTROL_GET_RX_FIFO6 =>
            if (axi_read_state_is_done = '1') then
              address_from_i2c(15 downto 8) <= axi_read_data(7 downto 0);
              control_state <= ST_CONTROL_GET_RX_FIFO7;
            end if;
          when ST_CONTROL_GET_RX_FIFO7 =>
            if (axi_read_state_is_done = '1') then
              address_from_i2c(7 downto 0) <= axi_read_data(7 downto 0);
              control_state <= ST_CONTROL_GET_STATUS_RECEIVE_FIFO_EMPTY;
            end if;
          when ST_CONTROL_GET_STATUS_RECEIVE_FIFO_EMPTY =>
            if (axi_read_state_is_done = '1' and axi_read_data(6) = '1') then
              control_state <= ST_CONTROL_I2C_READ;
            elsif (axi_read_state_is_done = '1' and axi_read_data(6) = '0') then
              control_state <= ST_CONTROL_I2C_WRITE;
            end if;
          when ST_CONTROL_I2C_READ =>
            if (i2c_read_state_is_done = '1') then
              control_state <= ST_CONTROL_WAIT_STATUS_TRANSMIT_FIFO_EMPTY_SET;
            end if;
          when ST_CONTROL_I2C_WRITE =>
            if (i2c_write_state_is_done = '1') then
              control_state <= ST_CONTROL_WAIT_STATUS_TRANSMIT_FIFO_EMPTY_SET;
            end if;
          when ST_CONTROL_WAIT_STATUS_TRANSMIT_FIFO_EMPTY_SET =>
            if (axi_read_state_is_done = '1' and axi_read_data(6) = '1') then
              control_state <= ST_CONTROL_WAIT_STATUS_ADDRESSED_AS_SLAVE_SET_AND_RECEIVE_FIFO_EMPTY_CLEAR;
            end if;
          when others =>
            control_state <= ST_CONTROL_ERROR;
        end case;

        -- I2C READ STATE MACHINE
        case i2c_read_state is
          when ST_I2C_READ_IDLE =>
            if (control_state = ST_CONTROL_I2C_READ) then
              i2c_read_state <= ST_I2C_READ_GET_AXI_REG;
            end if;
          when ST_I2C_READ_GET_AXI_REG =>
            if (axi_read_state_is_done = '1') then
              data_to_i2c <= axi_read_data;
              i2c_read_state <= ST_I2C_READ_SET_TX_FIFO0;
            end if;
          when ST_I2C_READ_SET_TX_FIFO0 =>
            if (axi_write_state_is_done = '1') then
              i2c_read_state <= ST_I2C_READ_SET_TX_FIFO1;
            end if;
          when ST_I2C_READ_SET_TX_FIFO1 =>
            if (axi_write_state_is_done = '1') then
              i2c_read_state <= ST_I2C_READ_SET_TX_FIFO2;
            end if;
          when ST_I2C_READ_SET_TX_FIFO2 =>
            if (axi_write_state_is_done = '1') then
              i2c_read_state <= ST_I2C_READ_SET_TX_FIFO3;
            end if;
          when ST_I2C_READ_SET_TX_FIFO3 =>
            if (axi_write_state_is_done = '1') then
              i2c_read_state <= ST_I2C_READ_SET_TX_FIFO4;
            end if;
          when ST_I2C_READ_SET_TX_FIFO4 =>
            if (axi_write_state_is_done = '1') then
              i2c_read_state <= ST_I2C_READ_SET_TX_FIFO5;
            end if;
          when ST_I2C_READ_SET_TX_FIFO5 =>
            if (axi_write_state_is_done = '1') then
              i2c_read_state <= ST_I2C_READ_SET_TX_FIFO6;
            end if;
          when ST_I2C_READ_SET_TX_FIFO6 =>
            if (axi_write_state_is_done = '1') then
              i2c_read_state <= ST_I2C_READ_SET_TX_FIFO7;
            end if;
          when ST_I2C_READ_SET_TX_FIFO7 =>
            if (axi_write_state_is_done = '1') then
              i2c_read_state <= ST_I2C_READ_DONE;
            end if;
          when ST_I2C_READ_DONE =>
            i2c_read_state <= ST_I2C_READ_IDLE;
          when others =>
            i2c_read_state <= ST_I2C_READ_ERROR;
        end case;

        -- I2C WRITE STATE MACHINE
        case i2c_write_state is
          when ST_I2C_WRITE_IDLE =>
            if (control_state = ST_CONTROL_I2C_WRITE) then
              i2c_write_state <= ST_I2C_WRITE_GET_RX_FIFO0;
            end if;
          when ST_I2C_WRITE_GET_RX_FIFO0 =>
            if (axi_read_state_is_done = '1') then
              data_from_i2c(63 downto 56) <= axi_read_data(7 downto 0);
              i2c_write_state <= ST_I2C_WRITE_GET_RX_FIFO1;
            end if;
          when ST_I2C_WRITE_GET_RX_FIFO1 =>
            if (axi_read_state_is_done = '1') then
              data_from_i2c(55 downto 48) <= axi_read_data(7 downto 0);
              i2c_write_state <= ST_I2C_WRITE_GET_RX_FIFO2;
            end if;
          when ST_I2C_WRITE_GET_RX_FIFO2 =>
            if (axi_read_state_is_done = '1') then
              data_from_i2c(47 downto 40) <= axi_read_data(7 downto 0);
              i2c_write_state <= ST_I2C_WRITE_GET_RX_FIFO3;
            end if;
          when ST_I2C_WRITE_GET_RX_FIFO3 =>
            if (axi_read_state_is_done = '1') then
              data_from_i2c(39 downto 32) <= axi_read_data(7 downto 0);
              i2c_write_state <= ST_I2C_WRITE_GET_RX_FIFO4;
            end if;
          when ST_I2C_WRITE_GET_RX_FIFO4 =>
            if (axi_read_state_is_done = '1') then
              data_from_i2c(31 downto 24) <= axi_read_data(7 downto 0);
              i2c_write_state <= ST_I2C_WRITE_GET_RX_FIFO5;
            end if;
          when ST_I2C_WRITE_GET_RX_FIFO5 =>
            if (axi_read_state_is_done = '1') then
              data_from_i2c(23 downto 16) <= axi_read_data(7 downto 0);
              i2c_write_state <= ST_I2C_WRITE_GET_RX_FIFO6;
            end if;
          when ST_I2C_WRITE_GET_RX_FIFO6 =>
            if (axi_read_state_is_done = '1') then
              data_from_i2c(15 downto 8) <= axi_read_data(7 downto 0);
              i2c_write_state <= ST_I2C_WRITE_GET_RX_FIFO7;
            end if;
          when ST_I2C_WRITE_GET_RX_FIFO7 =>
            if (axi_read_state_is_done = '1') then
              data_from_i2c(7 downto 0) <= axi_read_data(7 downto 0);
              i2c_write_state <= ST_I2C_WRITE_SET_AXI_REG;
            end if;
          when ST_I2C_WRITE_SET_AXI_REG =>
            if (axi_write_state_is_done = '1') then
              i2c_write_state <= ST_I2C_WRITE_DONE;
            end if;
          when ST_I2C_WRITE_DONE =>
            i2c_write_state <= ST_I2C_WRITE_IDLE;
          when others =>
            i2c_write_state <= ST_I2C_WRITE_ERROR;
        end case;

        -- AXI READ STATE MACHINE
        case axi_read_state is
          when ST_AXI_READ_IDLE =>
            if (axi_read_valid = '1') then
              axi_read_state <= ST_AXI_READ_CMD;
            end if;
          when ST_AXI_READ_CMD =>
            if (m0_axi_arready = '1') then
              axi_read_state <= ST_AXI_READ_WAIT;
            end if;
          when ST_AXI_READ_WAIT =>
            if (m0_axi_rvalid = '1') then
              -- If a 32-bit access, align the data here so we don't
              -- have to downstream.
              if (m0_axi_arsize = "010") then  -- 4B
                if (m0_axi_araddr(2) = '1') then
                  axi_read_data <= x"00000000" & m0_axi_rdata(63 downto 32);
                else
                  axi_read_data <= x"00000000" & m0_axi_rdata(31 downto 0);
                end if;
              else -- (m0_axi_arsize = "011") -- 8B
                axi_read_data <= m0_axi_rdata;
              end if;
              axi_read_state <= ST_AXI_READ_DONE;
            end if;
          when ST_AXI_READ_DONE =>
            axi_read_state <= ST_AXI_READ_IDLE;
          when others =>
            axi_read_state <= ST_AXI_READ_ERROR;
        end case;

        -- AXI WRITE STATE MACHINE
        case axi_write_state is
          when ST_AXI_WRITE_IDLE =>
            if (axi_write_valid = '1') then
              axi_write_state <= ST_AXI_WRITE_CMD;
            end if;
          when ST_AXI_WRITE_CMD =>
            if (m0_axi_awready = '1') then
              axi_write_state <= ST_AXI_WRITE_DATA;
            end if;
          when ST_AXI_WRITE_DATA =>
            if (m0_axi_wready = '1') then
              axi_write_state <= ST_AXI_WRITE_WAIT;
            end if;
          when ST_AXI_WRITE_WAIT =>
            if (m0_axi_bvalid = '1') then
              axi_write_state <= ST_AXI_WRITE_DONE;
            end if;
          when ST_AXI_WRITE_DONE =>
            axi_write_state <= ST_AXI_WRITE_IDLE;
          when others =>
            axi_write_state <= ST_AXI_WRITE_ERROR;
        end case;
      end if;
    end if;
  end process;

  process(axi_read_state) is
    begin
      -- AXI READ STATE MACHINE
      case axi_read_state is
        when ST_AXI_READ_IDLE =>
          m0_axi_arvalid <= '0';
          m0_axi_araddr <= (others => '0');
          m0_axi_arsize <= (others => '0');
          m0_axi_rready <= '0';
        when ST_AXI_READ_CMD =>
          m0_axi_arvalid <= '1';
          m0_axi_araddr <= X"0" & axi_read_address(59 downto 0);
          if (control_state = ST_CONTROL_I2C_READ) and (axi_read_address(63 downto 60) = X"3") then
            m0_axi_arsize <= "011";
          else
            m0_axi_arsize <= "010";
          end if;
          m0_axi_rready <= '0';
        when ST_AXI_READ_WAIT =>
          m0_axi_arvalid <= '0';
          -- m0_axi_araddr hold for ST_AXI_READ_WAIT
          -- m0_axi_arsize hold for ST_AXI_READ_WAIT
          m0_axi_araddr <= m0_axi_araddr_hold_q;
          m0_axi_arsize <= m0_axi_arsize_hold_q;
          m0_axi_rready <= '1';
        when ST_AXI_READ_DONE =>
          m0_axi_arvalid <= '0';
          m0_axi_araddr <= (others => '0');
          m0_axi_arsize <= (others => '0');
          m0_axi_rready <= '0';
        when others =>
          m0_axi_arvalid <= '0';
          m0_axi_araddr <= (others => '0');
          m0_axi_arsize <= (others => '0');
          m0_axi_rready <= '0';
      end case;
    end process;

          m0_axi_araddr_hold_d <= m0_axi_araddr WHEN (axi_read_state=ST_AXI_READ_CMD) else m0_axi_araddr_hold_q;

          m0_axi_arsize_hold_d <= m0_axi_arsize when (axi_read_state=ST_AXI_READ_CMD) ELSE m0_axi_arsize_hold_q;

  process(axi_write_state) is
    begin
      -- AXI WRITE STATE MACHINE
      case axi_write_state is
        when ST_AXI_WRITE_IDLE =>
          m0_axi_awvalid <= '0';
          m0_axi_awaddr <= (others => '0');
          m0_axi_awsize <= (others => '0');
          m0_axi_wvalid <= '0';
          m0_axi_wdata <= (others => '0');
          m0_axi_wstrb <= (others => '0');
          m0_axi_bready <= '0';
        when ST_AXI_WRITE_CMD =>
          m0_axi_awvalid <= '1';
          m0_axi_awaddr <= X"0" & axi_write_address(59 downto 0);
          if (control_state = ST_CONTROL_I2C_WRITE) and (axi_write_address(63 downto 60) = X"3") then
            m0_axi_awsize <= "011";
          else
            m0_axi_awsize <= "010";
          end if;
          m0_axi_wvalid <= '0';
          m0_axi_wdata <= (others => '0');
          m0_axi_wstrb <= (others => '0');
          m0_axi_bready <= '0';
        when ST_AXI_WRITE_DATA =>
          m0_axi_awvalid <= '0';
          m0_axi_awaddr <= (others => '0');
          m0_axi_awsize <= (others => '0');
          m0_axi_wvalid <= '1';
          m0_axi_wdata <= axi_write_data;
          m0_axi_wstrb <= (others => '1');
          m0_axi_bready <= '0';
        when ST_AXI_WRITE_WAIT =>
          m0_axi_awvalid <= '0';
          m0_axi_awaddr <= (others => '0');
          m0_axi_awsize <= (others => '0');
          m0_axi_wvalid <= '0';
          m0_axi_wdata <= (others => '0');
          m0_axi_wstrb <= (others => '0');
          m0_axi_bready <= '1';
        when ST_AXI_WRITE_DONE =>
          m0_axi_awvalid <= '0';
          m0_axi_awaddr <= (others => '0');
          m0_axi_awsize <= (others => '0');
          m0_axi_wvalid <= '0';
          m0_axi_wdata <= (others => '0');
          m0_axi_wstrb <= (others => '0');
          m0_axi_bready <= '0';
        when others =>
          m0_axi_awvalid <= '0';
          m0_axi_awaddr <= (others => '0');
          m0_axi_awsize <= (others => '0');
          m0_axi_wvalid <= '0';
          m0_axi_wdata <= (others => '0');
          m0_axi_wstrb <= (others => '0');
          m0_axi_bready <= '0';
      end case;
    end process;

end i2c_control_mac;
