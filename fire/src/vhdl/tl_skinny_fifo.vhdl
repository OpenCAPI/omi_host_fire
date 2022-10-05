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

entity tl_skinny_fifo is
  generic (
     depth    : positive range 2 to 512  -- width is always 1. use tlx_fifo if you need wider
  );
  port (
    clock                          : in std_ulogic;
    reset                          : in std_ulogic;        -- synchronous. clears control bits not the array (maybe xilinx does that anyway ? (don't care really))
    data_in                        : in std_ulogic;
    write                          : in std_ulogic;
    read                           : in std_ulogic;        -- reads next (output is valid in same cycle as read)
    data_out                       : out std_ulogic;
    empty                          : out std_ulogic;
    overflow                       : out std_ulogic;
    underflow                      : out std_ulogic;
    full                           : out std_ulogic
  );
end  tl_skinny_fifo ;

architecture tl_skinny_fifo of tl_skinny_fifo is

    signal farray      :  std_ulogic_vector(depth downto 1);    -- the array
    signal fifo_state  :  std_ulogic_vector(depth downto 1);   -- one "valid" bit per stage, shifting right so stage 0 is the output;

begin

 func: process(clock) is
    begin
      if rising_edge(clock) then

f_gen:   for i in 1 to depth loop       --   for each stage gererate the full bits then do the dataflow/array contents. first and last stages have to be done separately
            if i = 1 then
               fifo_state(i) <=  (fifo_state(i) or (not fifo_state(i+1) and not fifo_state(i) and not read and write)) and
                                 (fifo_state(i+1) or not fifo_state(i) or not read or write)                           and
                                 (not reset);
               farray(i)     <= (farray(i) and fifo_state(i) and not read)                                       or
                                (data_in   and not fifo_state(i+1) and write and (not (read xor fifo_state(i)))) or
                                (farray(i+1) and fifo_state(i+1) and fifo_state(i) and read);
            elsif i = depth then
               fifo_state(i) <=  (fifo_state(i) or (not fifo_state(i) and fifo_state(i-1) and not read and write)) and   -- reset to all invalid - ie fifo is empty
                                 (not fifo_state(i) or not fifo_state(i-1) or not read or write)                   and
                                 (not reset);

               farray(i)     <= (farray(i) and fifo_state(i) and fifo_state(i-1) and not read)              or
                                (data_in and fifo_state(i-1) and write and (not (read xor fifo_state(i))));

            else                    --- all the bits that are not first or last
               fifo_state(i) <=  (fifo_state(i) or (not fifo_state(i+1) and not fifo_state(i) and fifo_state(i-1) and not read and write))  and
                                 (fifo_state(i+1) or not fifo_state(i) or not fifo_state(i-1) or not read or write)                         and
                                 (not reset);

               farray(i)     <= (farray(i) and fifo_state(i) and fifo_state(i-1) and not read)                                     or
                                (data_in and not fifo_state(i+1) and fifo_state(i-1) and write and (not (read xor fifo_state(i)))) or
                                (farray(i+1) and fifo_state(i+1) and fifo_state(i) and fifo_state(i-1) and read);
            end if;

end loop f_gen;
      end if;
 end process func;

              -- form the outputs
    data_out                       <= farray(1);
    empty                          <= not fifo_state(1);
    overflow                       <= write and not read and fifo_state(depth);
    underflow                      <= read and not fifo_state(1);
    full                           <= fifo_state(depth);

end  tl_skinny_fifo;

