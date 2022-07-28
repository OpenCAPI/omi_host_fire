-- $Id: tb_ln_dly4to1_half.vhdl 2455 2016-02-01 19:13:39Z lonny $
-- $URL: file:///afs/awd/projects/eclipz/c14/libs/fbc/.svnDB/p9ndd1/main/vhdl/tb_ln_dly4to1_half.vhdl $
-- @!Created with MAKESCH v.1.53
-- *!********************************************************************
-- *! (C) Copyright International Business Machines Corporation 2007-2013
-- *!           All Rights Reserved -- Property of IBM
-- *!                    *** IBM Confidential ***
-- *!********************************************************************
-- *! FILE NAME   :  tb_ln_dly4to1_half.vhdl
-- *! TITLE       :
-- *! DESCRIPTION : OpenCapi DL logic
-- *!
-- *!
-- *! OWNER NAME  :  Lambrecht, Lonny      (uid: lonny)
-- *! BACKUP NAME :  Ganfield, Paul        (uid: pag)
-- *!
-- *!********************************************************************
-- Revision History:
-- ----------------------------------------------------------------------
-- Version:|Author: | Date:  | Comment:
-- --------|--------|--------|-------------------------------------------
--         |lonny   |02/16/16| initial entry
-------------------------------------------------------------------------

---- MR_PARAMS -dec a -ri _din -clk opt_gckn -vd vdn -scan_ios -nolcbcntl -parse_subs
-- MR_PARAMS -dec a -ri _din -clk opt_gckn -vd vdn -parse_subs -sde tc_pbiooa_scan_diag_dc

-- Global VHDL language/common libraries:
library ibm, ieee, support, work;
 use ibm.std_ulogic_function_support.all;
 use ibm.std_ulogic_support.all;
 use ibm.synthesis_support.all;
 use ieee.std_logic_1164.all;
 use support.logic_support_pkg.all;

use ibm.std_ulogic_unsigned.all;

-- MAKE SCHEMATIC DIRECTIVES
-- MS_U



Entity tb_ln_dly4to1_half is port (

  halfspeedmode                  : in std_ulogic;
  lane_in                        : in std_ulogic_vector(0 to 15);
  lane_out                       : out std_ulogic_vector(0 to 15);

---------------------------
-- clock controls
---------------------------

  opt_gckn                       : in std_ulogic

);
 Attribute BLOCK_TYPE of tb_ln_dly4to1_half : entity is leaf;
 Attribute BTR_NAME of tb_ln_dly4to1_half : entity is "TB_LN_DLY4TO1_HALF";
 Attribute RECURSIVE_SYNTHESIS of tb_ln_dly4to1_half : entity is 2;
 attribute pin_data of opt_gckn   : signal is "PIN_FUNCTION=/G_CLK/";

end tb_ln_dly4to1_half ;
----------
Architecture tb_ln_dly4to1_half of tb_ln_dly4to1_half is

  SIGNAL data_din, data_q : std_ulogic_vector(0 to 15);
  SIGNAL dout_din, dout_q : std_ulogic_vector(0 to 15);
  SIGNAL odd_cycle_din, odd_cycle_q : std_ulogic;

  SIGNAL act : std_ulogic;

BEGIN
act                                          <= '1';

odd_cycle_din             <= not odd_cycle_q;
data_din(0 to 15)         <= lane_in(0 to 15);
dout_din(0 to 15)         <= (data_q(0)   & data_q(2)   & data_q(4)   & data_q(6)   &
                              data_q(8)   & data_q(10)  & data_q(12)  & data_q(14)  & 
                              lane_in(0)  & lane_in(2)  & lane_in(4)  & lane_in(6)  &
                              lane_in(8)  & lane_in(10) & lane_in(12) & lane_in(14)) when odd_cycle_q = '1' else dout_q(0 to 15);

lane_out(0 to 15)         <= dout_q(0 to 15) when halfspeedmode = '1' else data_q(0 to 15);

dataq: entity work.fire_morph_dff
  generic map (width => 16)
  port map(gckn                 => opt_gckn,
           e                    => act,
           d                    => data_din(0 to 15),
           q                    => data_q(0 to 15));

doutq: entity work.fire_morph_dff
  generic map (width => 16)
  port map(gckn                 => opt_gckn,
           e                    => act,
           d                    => dout_din(0 to 15),
           q                    => dout_q(0 to 15));

odd_cycleq: entity work.fire_morph_dff
  generic map (width => 1)
  port map(gckn                 => opt_gckn,
           e                    => act,
           d(0)                 => odd_cycle_din,
           q(0)                 => odd_cycle_q);

End tb_ln_dly4to1_half;


