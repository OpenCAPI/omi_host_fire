--MR_PARAMS -dontrun t
--===========================================================
--   Copyright (c)  2002 by IBM Corp.  All rights reserved
--   IBM Unclassified
--
--   Filename:     variable_osc.vhd
--   Discription:  This is a varible Oscillator. It generates
--                 programable oscilator controlled by the
--                 signal Rate.  Rate defaults to 1 up, 1 down
--                 In addition it provides a second output that can be divided by an
--                 integer in the range of 2..16
--   Author:       L. E. Grosbach, enhanced by K.D.Schubert
--   Simulator:    MESA, MTI (hope it still works on MTI)
--   Synthesis:    no way
--   Dependancies: none
--
--  Change History
--  Version  Author    Date      Description
--    0.0     leg    11/20/2002  created
--    1.0     kds    01/16/2006  created
--
--===========================================================
--$Log: variable_osc.vhdl,v $
--Revision 1.1  2007/04/06 16:29:46  ddavids
--*** empty log message ***
--
Library IEEE,IBM;
   USE IEEE.Std_Logic_1164.all ;
   Use IEEE.numeric_std.all;
   Use IBM.std_ulogic_support.all;
   Use IBM.std_ulogic_unsigned.all;
   Use IBM.synthesis_support.all;
   Use IBM.std_ulogic_function_support.all;

Entity variable_osc is
  Port (
        rate_in  : in  std_ulogic_vector(0 to 15);
        div_in   : in  std_ulogic_vector(0 to 3);
        reset_in : in  std_ulogic;
        osc1     : out std_ulogic;
        osc2     : out std_ulogic
        );
end variable_osc;

--===========================================================

Architecture variable_osc of variable_osc is
  signal rtx_cntl         : std_ulogic;
  signal reset            : std_ulogic;
  signal hot_clock        : std_ulogic;
  signal osc_int          : std_ulogic;
  signal oscout1          : std_ulogic;
  signal oscout1_dly      : std_ulogic;
  signal oscout2          : std_ulogic;
  signal oscold           : std_ulogic;

  signal count1           : std_ulogic_vector(0 to 7);
  signal count2           : std_ulogic_vector(0 to 3);         -- Allows divide by 15 as max
  signal rate             : std_ulogic_vector(0 to 15);
  signal frac             : std_ulogic_vector(0 to 7);
  signal div              : std_ulogic_vector(0 to 3);

  signal rate_new         : std_ulogic_vector(0 to 15);
  signal div_new          : std_ulogic_vector(0 to 3);
  signal reset_lt         : std_ulogic;

  signal rate_sig         : std_ulogic_vector(0 to 15);
  signal div_sig          : std_ulogic_vector(0 to 3);

-- To set Rate calculate the following:
-- Rate = 256 * Max Model Freq / Desired Model Freq
-- Rate needs to be 256 or bigger (otherwise pulses will be missed sometimes)
-- Max Model Frequency must be identical for every simulation run for all oscillators in a model

Begin

  -- Default is max frequency for osc1 and osc2 = osc1 / 2
--  --## Switch use_dials (rtx_cntl) = off;
--  --## Switch reset (reset_lt) = off;
--  --## IDial rate (rate_new(0 to 15)) = 256;
--  --## IDial div (div_new(0 to 3)) = 2;

  switch: process(rtx_cntl, div_in, div_new, rate_in, rate_new, reset, reset_lt)
  begin
    if (rtx_cntl = '0') then                                -- external input
      rate_sig  <= rate_in;
      div_sig   <= div_in;
      reset     <= reset_in;
    else                                                    -- latch inputs (set by RTX)
      rate_sig  <= rate_new;
      div_sig   <= div_new - 1;
      reset     <= reset_lt;
    end if;
  end process;

  hot_clock <= '1';
  crystal: process(hot_clock, osc_int, reset)
  begin
    rate_new <= rate_new;                                   -- hold values forever
    div_new  <= div_new;
    reset_lt <= reset_lt;
    rtx_cntl <= rtx_cntl;

    if (reset = '1') then
      osc_int <= '0';
    else
      if (hot_clock = '1') then
        osc_int <= not osc_int;                            -- 10 Ghz clock,
      end if;
    end if;
  end process;


  clockProc : process(osc_int, reset)
  variable fracSum : std_ulogic_vector(0 to 8);
  begin
    fracSum := ('0' & rate(8 to 15)) + ('0' & Frac);
    if (reset = '1') then
      count1  <= x"00";
    --  count1  <= rate_sig(0 to 7);
      oscout1 <= '0';
      frac    <= x"00";
      rate    <= rate_sig;
    else
      if (hot_clock = '1') then
        oscout1_dly <= oscout1;
        if (count1 = x"00") then
           frac    <= FracSum(1 to 8);
           oscout1 <= not oscout1;
           if (fracSum(0) = '1') then
              count1 <= rate(0 to 7);
           else
              count1 <= rate(0 to 7) - 1 ;
           end if;
        else
           count1 <= count1 - 1 ;
        end if;
      end if;
    end if;
  end process;
  osc1  <= oscout1_dly;                             -- Oscillator output 1 (divided)

  divide:process (osc_int, reset)
  begin
    if (reset = '1') then
      -- count2     <= div_sig - 1;
      count2     <= x"0";
      div        <= div_sig - 1;
      oscout2    <= '0';
      oscold     <= '0';
    else
      if (oscold = oscout1) then
        oscold  <= not oscout1;
        if (count2 = x"0") then
          oscout2 <= not oscout2;
          count2     <= div;
        else
          count2     <= count2 - 1;
        end if;
      end if;
    end if;
  end process;
  osc2 <= oscout2;                             -- Oscillator output 2 (divided)

End variable_osc;
