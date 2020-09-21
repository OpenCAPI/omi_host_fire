-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity u_ila_clk_out1_clk_wiz_sysclk is
  Port ( 
    clk : in STD_LOGIC;
    probe0 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe1 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe2 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe3 : in STD_LOGIC_VECTOR ( 63 downto 0 );
    probe4 : in STD_LOGIC_VECTOR ( 63 downto 0 );
    probe5 : in STD_LOGIC_VECTOR ( 2 downto 0 );
    probe6 : in STD_LOGIC_VECTOR ( 63 downto 0 );
    probe7 : in STD_LOGIC_VECTOR ( 2 downto 0 );
    probe8 : in STD_LOGIC_VECTOR ( 4 downto 0 );
    probe9 : in STD_LOGIC_VECTOR ( 63 downto 0 );
    probe10 : in STD_LOGIC_VECTOR ( 63 downto 0 );
    probe11 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe12 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe13 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe14 : in STD_LOGIC_VECTOR ( 0 to 0 )
  );

end u_ila_clk_out1_clk_wiz_sysclk;

architecture stub of u_ila_clk_out1_clk_wiz_sysclk is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "ila,Vivado 2018.3.1";
begin
end;
