-- Modified from latches/c_morph_dff_core.vhdl

library ieee, support;
use ieee.std_logic_1164.all;

entity fire_morph_dff_core is
  GENERIC ( width            : natural range 1 to 65535 := 1
          );
  port (
    d           : in  std_ulogic_vector(0 to (width - 1));       -- data in
    gckn        : in  std_ulogic;       -- clock
    e           : in  std_ulogic := '1';       -- local clock active signal but also include force and thold_b
    q           : out std_ulogic_vector(0 to (width -1));     -- data output of flipflop
    qn          : out std_ulogic_vector(0 to (width -1))
    );

end fire_morph_dff_core;


architecture fire_morph_dff_core of fire_morph_dff_core is
  signal l2 : std_ulogic_vector(0 to width-1);

begin
  process(gckn)
  begin
    if (rising_edge(gckn)) then
      if (e = '1') then
        l2 <= d;
      end if;
    end if;
  end process;

  q <= l2;
  qn <= not(l2);

end fire_morph_dff_core;
