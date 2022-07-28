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

entity aram_input_fifo is
  port (
    clock                          : in std_ulogic;
    reset                          : in std_ulogic;        -- synchronous. clears control bits not the array (maybe xilinx does that anyway ? (don't care really))
    remove_nulls                   : in std_ulogic;
    crc_error                      : in std_ulogic;
    data_in                        : in std_ulogic_vector(512 downto 0);       -- 512 = +data 511 downto 0 data/control flit
    write                          : in std_ulogic;
    read                           : in std_ulogic;        -- reads next (output is valid in same cycle as read)
    data_out                       : out std_ulogic_vector(512 downto 0);
    empty                          : out std_ulogic;
    full                           : out std_ulogic;
    overflow                       : out std_ulogic;
    underflow                      : out std_ulogic;
    array_overflow                 : out std_ulogic
  );
end  aram_input_fifo ;

architecture aram_input_fifo of aram_input_fifo is

 signal wptr_d,wptr_q,rptr_d,rptr_q         : std_ulogic_vector (6 downto 0);      -- one too many gives empty-full distinction
 signal bram_out,data_out_int               : std_ulogic_vector (512 downto 0);
 signal bram_valid_d,bram_valid_q           : std_ulogic;
 signal inc_rptr,full_int,empty_int         : std_ulogic;
 signal write_fifo                          : std_ulogic;
 signal overwritable_d,overwritable_q       : std_ulogic;
 signal last_good_wptr_d,last_good_wptr_q   : std_ulogic_vector (6 downto 0);
 signal wptr_plus_one                       : std_ulogic_vector (6 downto 0);
 signal tail_null,empty_c_flit              : std_ulogic;

 constant unity : std_ulogic_vector     := "0000001"; --  (log2(depth) downto 1 => '0') & '1';
begin

bulk_bram :  component aram_1r1w1ck_64x513
    port map (
      clk     => clock,
      ena     => '1',
      enb     => '1',
      wea     => write,
      dia     => data_in,
      addra   => wptr_q(5 downto 0),
      addrb   => rptr_q(5 downto 0),
      dob     => bram_out
    );

streaming_fifo: entity work.tlx_fifo
   generic map (
      width    => 513,
      depth    => 2
   )
   port map (
     clock       =>  clock,
     reset       =>  reset,
     data_in     =>  bram_out,
     write       =>  write_fifo,
     read        =>  read,
     data_out    =>  data_out_int,
     empty       =>  empty_int,
     full        =>  full_int,
     overflow    =>  overflow,
     underflow   =>  underflow
   );
   data_out <= data_out_int;
                                             -- fifo signals

   write_fifo <= bram_valid_q and not full_int;
   full <= full_int;
   empty <= empty_int;

                                             -- bulk ram signals

   inc_rptr <= '1' when (last_good_wptr_q /= rptr_q ) and ( read or empty_int or (not full_int and not write_fifo)) = '1' else '0';

   rptr_d <= GATE(rptr_q + unity , not reset and     inc_rptr) or
             GATE(rptr_q             , not reset and not inc_rptr);

   bram_valid_d <= '1' when (last_good_wptr_q /= rptr_q ) else '0';    -- bram_valid_q will say when bram output is valid

   wptr_plus_one <= wptr_q + unity;

   last_good_wptr_d <= GATE( wptr_plus_one    , write and not data_in(512) and not empty_c_flit) or
                       GATE( wptr_q           , write and not data_in(512) and     empty_c_flit) or
                       GATE( last_good_wptr_q , not (write and not data_in(512)));

        -- treat control templates with nothing useful in them as empty flits

   empty_c_flit <= remove_nulls when  data_in(459 downto 448) = x"000"  and data_in(512) = '0' and    -- no runlength or bdi bits in a control flit
                                     ( (data_in(465 downto 460) = "000000" and  data_in(7 downto 0) = x"00" and        -- template 0 has slots 0 and 4
                                                        data_in(119 downto 112) = x"00" )
                                                                                   or
                                       (data_in(465 downto 460) = "000001" and  data_in(7 downto 0) = x"00" )       -- template 1 has slots 0 and 4 8 12 but no weird skips
                                                                                   or
                                       (data_in(465 downto 460) = "001001" and  data_in(264) = '0' and              -- template 9 has data and slots 10, 12-15
                                          data_in(287 downto 280) = x"00"  and  data_in(343 downto 336) = x"00" )   -- but only possible skip is slot 10 and 12)
                                                                                   or
                                       (data_in(465 downto 460) = "001011" and  data_in(329) = '0' and              -- template B has data and slots 12, 14-15
                                          data_in(343 downto 336) = x"00"  and  data_in(399 downto 392) = x"00" )   -- but only possible skip is slot 15)
                                                                                  or
                                       (data_in(465 downto 460) = "000101" and  data_in(329) = '0' and              --
                                          data_in(7 downto 0) = x"00"  and  data_in(119 downto 112) = x"00" and     --
                                          data_in(343 downto 336) = x"00")

                                     ) else '0';

   overwritable_d     <=     (write and empty_c_flit ) or                                  -- this means that we did not increment the write pointer after writing a null flit
                             (overwritable_q and not (write or crc_error or tail_null));

   tail_null <=  not write and overwritable_q and empty_int; -- the fifo is empty and the last thing we did was write a null but not advance the pointer

   wptr_d <= GATE(wptr_plus_one, write and (data_in(512) or not empty_c_flit)) or  -- normal case writing data or non-null control
             GATE(wptr_plus_one, tail_null and not crc_error                 ) or
             GATE(last_good_wptr_q, crc_error                                ) or  -- remember we assert we can't have crc error and write in the same cycle
             GATE(wptr_q, not crc_error and not tail_null and not (write and (data_in(512) or not empty_c_flit)));

   array_overflow <= AND_REDUCE( (wptr_q(5 downto 0) xnor rptr_q(5 downto 0)) &  (wptr_q(6) xor rptr_q(6)) & write);
                      -- get into discussion about how the xilinx ip works but -- this is the safest

latches : process(clock)
   begin
     if clock 'event and clock = '1' then
        if reset = '1' then
           last_good_wptr_q <= (others => '0');
           overwritable_q  <= '0';
           wptr_q <= (others => '0');
        else
           last_good_wptr_q <= last_good_wptr_d;
           overwritable_q  <= overwritable_d;

--synopsys translate_off
           assert  (last_good_wptr_q(5 downto 0) <=  wptr_q(5 downto 0)  and last_good_wptr_q(6) = wptr_q(6)) or
                   (last_good_wptr_q(5 downto 0) >=  wptr_q(5 downto 0)  and last_good_wptr_q(6) /= wptr_q(6))
            report "issue 43 - incrementing last_good wptr when null flit written" severity error;
--synopsys translate_on

           wptr_q <= wptr_d;
        end if;
        bram_valid_q <= bram_valid_d and not reset;
        rptr_q <= rptr_d;
     end if;
end process;

end architecture;


