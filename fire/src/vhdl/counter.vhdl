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

entity counter is
  port (
    clock           : in std_ulogic;
    reset           : in std_ulogic;
    tsm_state6_to_1 : out std_ulogic
    );
end counter;

architecture counter of counter is

  SIGNAL count_0_q           : std_ulogic_vector(25 downto 0);
  SIGNAL reset_q            : std_ulogic:= '0';
  signal tsm_state6_to_1_q   : std_ulogic;
  SIGNAL count_compare_valid : std_ulogic_vector(25 downto 0);
begin

  -- Explicitly bring this out so we can override if needed to cut
  -- down on sim time
  count_compare_valid <= (others => '1');

  process (clock)
  begin
    if clock'event and clock = '1' then
      tsm_state6_to_1_q <= (count_0_q(25 DOWNTO 2) = count_compare_valid(25 downto 2));
      reset_q <= reset;
      if reset = '1' then
         count_0_q <= (others => '0');
      elsif (reset = '0' and reset_q = '1') OR (count_0_q /= 0) then
         count_0_q <= count_0_q + 1;
      end if;
     end if;
  end process;

  tsm_state6_to_1 <= tsm_state6_to_1_q;

end counter;
