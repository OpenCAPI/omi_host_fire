-- $Id: tb_ln_dly1to4_4x.vhdl 2455 2016-02-01 19:13:39Z lonny $
-- $URL: file:///afs/awd/projects/eclipz/c14/libs/fbc/.svnDB/p9ndd1/main/vhdl/tb_ln_dly1to4_4x.vhdl $
-- @!Created with MAKESCH v.1.53
-- *!********************************************************************
-- *! (C) Copyright International Business Machines Corporation 2007-2013
-- *!           All Rights Reserved -- Property of IBM
-- *!                    *** IBM Confidential ***
-- *!********************************************************************
-- *! FILE NAME   :  tb_ln_dly1to4_4x.vhdl
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
library ibm, ieee,support, work;
 use ibm.std_ulogic_function_support.all;
 use ibm.std_ulogic_support.all;
 use ibm.synthesis_support.all;
 use ieee.std_logic_1164.all;
 use support.logic_support_pkg.all;

use ibm.std_ulogic_unsigned.all;

-- MAKE SCHEMATIC DIRECTIVES
-- MS_U



-- MAKEREGS IO DECLARATIONS START
Entity tb_ln_dly1to4_4x is port (

  lane_in_header                 : in  std_ulogic_vector(0 to 1);
  lane_in_data                   : in  std_ulogic_vector(0 to 63);
  lane_in_seq                    : in  std_ulogic_vector(0 to 5);
  prev_in_header                 : out std_ulogic_vector(0 to 1);
  prev_in_data                   : out std_ulogic_vector(0 to 63);
  prev_in_seq                    : out std_ulogic_vector(0 to 5);
  prev2_in_data                  : out std_ulogic_vector(0 to 63);




---------------------------
-- clock controls
---------------------------

  opt_gckn                       : in  std_ulogic

);
 Attribute BLOCK_TYPE of tb_ln_dly1to4_4x : entity is leaf;
 Attribute BTR_NAME of tb_ln_dly1to4_4x : entity is "TB_LN_DLY1TO4_4X";
 Attribute RECURSIVE_SYNTHESIS of tb_ln_dly1to4_4x : entity is 2;
 attribute pin_data of opt_gckn   : signal is "PIN_FUNCTION=/G_CLK/";

end tb_ln_dly1to4_4x ;
-- MAKEREGS IO DECLARATIONS END
-- MAKEREGS IO DECLARATIONS END
----------
Architecture tb_ln_dly1to4_4x of tb_ln_dly1to4_4x is
-- MAKEREGS SIGNAL DECLARATIONS START
-----------------------------------------------------------
-- Input and output signal declarations (including       --
-- scan signals) auto-generated by MAKEREGS version 311 --
-----------------------------------------------------------

-- Register signal declarations
  SIGNAL data_din, data_q : std_ulogic_vector(0 to 63);
  SIGNAL data_d1_din, data_d1_q : std_ulogic_vector(0 to 63);
  SIGNAL header_din, header_q : std_ulogic_vector(0 to 1);
  SIGNAL seq_din, seq_q : std_ulogic_vector(0 to 5);

-- Internal signal declarations
  SIGNAL act : std_ulogic;

--  Enhancement to VS to help detect unused latch input/outputs
-- %VS_PORT_MAP c_nlat_scan.q out
-- %VS_PORT_MAP c_nlat_scan.qL1 out
-- %VS_PORT_MAP c_nlat_scan.data in
-- %VS_PORT_MAP c_nlat_scan.q out
-- %VS_PORT_MAP c_nlat_scan.qL1 out
-- %VS_PORT_MAP c_nlat_scan.data in
---------------------------------------------------------------
-- End auto-generated register and scan signal declarations  --
---------------------------------------------------------------
-- MAKEREGS SIGNAL DECLARATIONS END
BEGIN
act                                          <= '1';

header_din(0 to 1)        <= lane_in_header(0 to 1);
data_din(0 to 63)         <= lane_in_data(0 to 63);
seq_din(0 to 5)           <= lane_in_seq(0 to 5);
data_d1_din(0 to 63)      <= data_q(0 to 63);

prev_in_header(0 to 1)    <= header_q(0 to 1);
prev_in_data(0 to 63)     <= data_q(0 to 63);
prev_in_seq(0 to 5)       <= seq_q(0 to 5);
prev2_in_data(0 to 63)    <= data_d1_q(0 to 63);

  dataq: entity work.fire_morph_dff
    generic map (width => 64)
    port map(gckn            => opt_gckn,
             e               => act,
             d               => data_din(0 to 63),
             q               => data_q(0 to 63));

  data_d1q: entity work.fire_morph_dff
    generic map (width => 64)
    port map(gckn            => opt_gckn,
             e               => act,
             d               => data_d1_din(0 to 63),
             q               => data_d1_q(0 to 63));

  headerq: entity work.fire_morph_dff
    generic map (width => 2)
    port map(gckn            => opt_gckn,
             e               => act,
             d               => header_din(0 to 1),
             q               => header_q(0 to 1));

  seqq: entity work.fire_morph_dff
    generic map (width => 6)
    port map(gckn            => opt_gckn,
             e               => act,
             d               => seq_din(0 to 5),
             q               => seq_q(0 to 5));
End tb_ln_dly1to4_4x;


