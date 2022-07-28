-- Modified from latches/c_morph_dff.vhdl

library ieee;
  use ieee.std_logic_1164.all;
library ibm;
  USE ibm.synthesis_support.all; 
  use ibm.std_ulogic_function_support.all;
  USE ibm.std_ulogic_support.all;

entity fire_morph_dff is
  GENERIC ( width            : natural range 1 to 65535 := 1
          );
  port (
    d           : in  std_ulogic_vector(0 to width - 1);       -- data in
    gckn        : in  std_ulogic;       -- clock
    e           : in  std_ulogic := '1';       -- local clock active signal
    edis        : in  std_ulogic := '0';       -- local clock active signal disable
    hldn        : in std_ulogic := '1';  -- thold_b in case clock is split above
    q           : out std_ulogic_vector(0 to (width -1));     -- data output of flipflop
    qn          : out std_ulogic_vector(0 to (width -1))     -- data output of flipflop
    );


end fire_morph_dff;


architecture fire_morph_dff of fire_morph_dff is

-- internal e signal so it can also be used for clock gating without affecting the design if e is also used for logic.
  signal dff_e : std_ulogic;
  signal morph_ck : std_ulogic;

begin
  dff_e <= e or edis;

  morph_ck <= not(gckn) and hldn;

  latc: entity work.fire_morph_dff_core
    generic map (width => width)
    port map(gckn         => morph_ck,
             e            => dff_e,
             d            => d,
             q     => q,
             qn   => qn );

end fire_morph_dff;
