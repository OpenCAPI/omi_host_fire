--MR_PARAMS -dontrun t
Library IEEE,IBM,support;
USE IEEE.Std_Logic_1164.all ;
Use IEEE.numeric_std.all;
Use IBM.std_ulogic_support.all;
Use IBM.std_ulogic_unsigned.all;
Use IBM.synthesis_support.all;
Use IBM.std_ulogic_function_support.all;
use support.logic_support_pkg.all;

entity apollo_pll_model is
  port (
    axi_clock         : out std_ulogic;
    axi_clock_reset   : in  std_ulogic;
    opt_gckn          : out std_ulogic;
    opt_gckn_reset    : in  std_ulogic;
    opt_gckn_4x       : out std_ulogic;
    opt_gckn_4x_reset : in  std_ulogic
    );
end entity apollo_pll_model;

architecture apollo_pll_model of apollo_pll_model is

  ATTRIBUTE geyzer_waive of axi_clk_pll     : label is "ANALYSIS";  --to black box clock generator behaviour in geyzer
  ATTRIBUTE geyzer_waive of opt_gckn_pll    : label is "ANALYSIS";  --to black box clock generator behaviour in geyzer
  ATTRIBUTE geyzer_waive of opt_gckn_4x_pll : label is "ANALYSIS";  --to black box clock generator behaviour in geyzer

begin

  axi_clk_pll : entity work.variable_osc
    port map
    ( rate_in  => x"0800",            -- = [16 (8up/8dn) sim cycs = 1 machine cycle]
      div_in   => x"0",
      reset_in => axi_clock_reset,
      osc1     => axi_clock,
      osc2     => OPEN
      );
  opt_gckn_pll : entity work.variable_osc
    port map
    ( rate_in  => x"0800",            -- = [16 (8up/8dn) sim cycs = 1 machine cycle]
      div_in   => x"0",
      reset_in => opt_gckn_reset,
      osc1     => opt_gckn,
      osc2     => OPEN
      );
  opt_gckn_4x_pll : entity work.variable_osc
    port map
    ( rate_in  => x"2000",            -- = [64 (32up/32dn) sim cycs = 1 machine cycle]
      div_in   => x"0",
      reset_in => opt_gckn_4x_reset,
      osc1     => opt_gckn_4x,
      osc2     => OPEN
      );
  
end architecture apollo_pll_model;
