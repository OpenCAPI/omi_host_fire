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

library ieee, ibm, work, support;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ibm.std_ulogic_support.all;
use ibm.std_ulogic_unsigned.all;
use ibm.std_ulogic_function_support.all;
use ibm.synthesis_support.all;
use support.logic_support_pkg.all;
use  work.apollo_tlx_pkg.all;
use ieee.numeric_std.std_match;

entity fbist_fes_buffer is
    PORT (
      CCLK                       : in  std_ulogic;
      CRESET                     : in  std_ulogic;
      SYSCLK                     : in  std_ulogic;
      SYS_RESET                  : in  std_ulogic;
      FBIST_CFG_STATUS_IP        : in  std_ulogic;
   -- expansion interface to axi_regs_32_large reads
      EXP_RD_VALID               : in  std_ulogic;
      EXP_RD_ADDRESS             : in  std_ulogic_vector(31 downto 0);
      EXP_RD_DATA                : out std_ulogic_vector(31 downto 0);
      EXP_RD_DATA_VALID          : out std_ulogic;
    -- expansion interface to axi_regs_32_large writes (only used for pointer reset)
      EXP_WR_VALID               : in std_ulogic;  --  (data don't care)
      EXP_WR_ADDRESS             : in std_ulogic_vector(31 downto 0);
    -- stuff to put into the buffer - from fbist_chk
      WRITE                      : in std_ulogic;
      DATA_IN                    : in std_ulogic_vector(543 downto 0)
    );
    end fbist_fes_buffer;

architecture fbist_fes_buffer of fbist_fes_buffer is

   signal wptr_q,wptr_d,rptr_q,rptr_d              : std_ulogic_vector(5 downto 0);
   signal qw_ptr_q,qw_ptr_d                        : std_ulogic_vector(4 downto 0); -- select 32bit of bram output
   signal exp_rd_data_valid_q,exp_rd_data_valid_d  : std_ulogic;
   signal latch_info_data,current_addr             : std_ulogic;
   signal bram_out                                 : std_ulogic_vector(543 downto 0);
   signal reset_read_ptr                           : std_ulogic;
   signal inc_read_ptr_q,inc_read_ptr_d            : std_ulogic;
   signal reset_ptrs,fbist_running                 : std_ulogic;

   constant   RESET_RPTR : std_ulogic_vector(31 downto 0) := x"000000C8"; -- any write to this address resets the read pointer
   constant   READ_BUFF  : std_ulogic_vector(31 downto 0) := x"000000C0"; -- read from the buffer
   constant   READ_INFO  : std_ulogic_vector(31 downto 0) := x"000000C4"; -- read number of valid buffer entries etc

    begin


    reset_ptrs <=  SYS_RESET or (fbist_running = '0' and  FBIST_CFG_STATUS_IP = '1'); -- clear pointers when fbist starts

bulk_bram :  component aram_1r1w2ck_64x544        -- clocked output
    port map (
      clka    => cclk,
      clkb    => sysclk,
      ena     => '1',
      enb     => '1',
      wea     => write,
      dia     => data_in,
      addra   => wptr_q(5 downto 0),
      addrb   => rptr_q(5 downto 0),
      dob     => bram_out
    );


    reset_read_ptr    <= '1' when reset_ptrs = '1' or (exp_wr_valid = '1' and exp_wr_address = RESET_RPTR) else '0';
    inc_read_ptr_d    <= '1' when exp_rd_valid = '1' and exp_rd_address = READ_BUFF else '0';

    latch_info_data   <=  '1' when exp_rd_valid = '1' and exp_rd_address = READ_INFO else '0';

    qw_ptr_d <= GATE(qw_ptr_q + "00001",  inc_read_ptr_q = '1' and inc_read_ptr_d = '0'  and reset_read_ptr = '0' and qw_ptr_q /= "10000") or
                GATE(qw_ptr_q          , (inc_read_ptr_q = '0' or  inc_read_ptr_d = '1') and reset_read_ptr = '0') ;

    rptr_d   <= GATE(rptr_q + "000001",reset_read_ptr = '0' and inc_read_ptr_d = '1' and qw_ptr_q = "10000" and rptr_q /= "111111"  ) or
                GATE(rptr_q           ,reset_read_ptr = '0' and (inc_read_ptr_d /= '1'  or rptr_q = "111111" ));

    exp_rd_data_valid_d <= '1' when reset_ptrs = '0' and ( exp_rd_valid = '1' or ( exp_rd_data_valid_q = '1' and (exp_rd_address = READ_BUFF or exp_rd_address = READ_INFO) and
                                                                                                          (current_addr = exp_rd_address(2)))) else '0';
    exp_rd_data_valid <=  exp_rd_data_valid_q;

    wptr_d <= "000000"          when reset_ptrs = '1' else
              wptr_q + "000001" when write = '1' and  wptr_q /= "111111" else
              wptr_q;

latches_cclk : process(cclk)
   begin
     if cclk 'event and cclk = '1' then
        wptr_q <= wptr_d;
     end if;
end process;

latches_sysclk : process(sysclk)
   begin
     if sysclk 'event and sysclk = '1' then
        if inc_read_ptr_d = '1' then -- latch muxed data
             exp_rd_data   <= GATE(bram_out( 31 downto   0),qw_ptr_q = "00000") or
                              GATE(bram_out( 63 downto  32),qw_ptr_q = "00001") or
                              GATE(bram_out( 95 downto  64),qw_ptr_q = "00010") or
                              GATE(bram_out(127 downto  96),qw_ptr_q = "00011") or
                              GATE(bram_out(159 downto 128),qw_ptr_q = "00100") or
                              GATE(bram_out(191 downto 160),qw_ptr_q = "00101") or
                              GATE(bram_out(223 downto 192),qw_ptr_q = "00110") or
                              GATE(bram_out(255 downto 224),qw_ptr_q = "00111") or
                              GATE(bram_out(287 downto 256),qw_ptr_q = "01000") or
                              GATE(bram_out(319 downto 288),qw_ptr_q = "01001") or
                              GATE(bram_out(351 downto 320),qw_ptr_q = "01010") or
                              GATE(bram_out(383 downto 352),qw_ptr_q = "01011") or
                              GATE(bram_out(415 downto 384),qw_ptr_q = "01100") or
                              GATE(bram_out(447 downto 416),qw_ptr_q = "01101") or
                              GATE(bram_out(479 downto 448),qw_ptr_q = "01110") or
                              GATE(bram_out(511 downto 480),qw_ptr_q = "01111") or
                              GATE(bram_out(543 downto 512),qw_ptr_q = "10000");
        elsif latch_info_data = '1' then
             exp_rd_data <= "00" & wptr_q & x"00" & "00" & rptr_q & "000" & qw_ptr_q ;
        end if;

        exp_rd_data_valid_q <=  exp_rd_data_valid_d;

        rptr_q <= rptr_d;
        inc_read_ptr_q <= inc_read_ptr_d;
        qw_ptr_q <= qw_ptr_d;
        if reset_ptrs = '1' then
           current_addr <=  '0';
        elsif exp_rd_valid = '1' then
           current_addr <=  EXP_RD_ADDRESS(2);   -- 1 for info 0 for data
        end if;
        fbist_running <= FBIST_CFG_STATUS_IP;
     end if;
end process;

end architecture fbist_fes_buffer;
