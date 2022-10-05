-- $Id: tb_ln_dly4to1.vhdl 2455 2016-02-01 19:13:39Z lonny $
-- $URL: file:///afs/awd/projects/eclipz/c14/libs/fbc/.svnDB/p9ndd1/main/vhdl/tb_ln_dly4to1.vhdl $
-- @!Created with MAKESCH v.1.53
-- *!********************************************************************
-- *! (C) Copyright International Business Machines Corporation 2007-2013
-- *!           All Rights Reserved -- Property of IBM
-- *!                    *** IBM Confidential ***
-- *!********************************************************************
-- *! FILE NAME   :  tb_ln_dly4to1.vhdl
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



Entity tb_ln_dly4to1 is port (

  delay                          : in std_ulogic_vector(0 to 7);
  lane_in                        : in std_ulogic_vector(0 to 15);
  lane_out                       : out std_ulogic_vector(63 downto 0);
  clock_out                      : out std_ulogic;

  ln_rx_valid                    : out std_ulogic;
  ln_rx_header                   : out std_ulogic_vector(1 downto 0);
  ln_rx_data                     : out std_ulogic_vector(63 downto 0);
  ln_rx_slip                     : in std_ulogic;


  inject_crc                     : in std_ulogic;

---------------------------
-- clock controls
---------------------------

  opt_gckn                       : in std_ulogic

);
 Attribute BLOCK_TYPE of tb_ln_dly4to1 : entity is leaf;
 Attribute BTR_NAME of tb_ln_dly4to1 : entity is "TB_LN_DLY4TO1";
 Attribute RECURSIVE_SYNTHESIS of tb_ln_dly4to1 : entity is 2;
 attribute pin_data of opt_gckn   : signal is "PIN_FUNCTION=/G_CLK/";


end tb_ln_dly4to1 ;
----------
Architecture tb_ln_dly4to1 of tb_ln_dly4to1 is



-- Register signal declarations
  SIGNAL carryover_din, carryover_q : std_ulogic_vector(0 to 255);
  SIGNAL clk_cnt_din, clk_cnt_q : std_ulogic_vector(0 to 1);
  SIGNAL delay_din, delay_q : std_ulogic_vector(0 to 7);
  SIGNAL init_din, init_q : std_ulogic;
  SIGNAL lane_out_din, lane_out_q : std_ulogic_vector(0 to 63);
  SIGNAL lane_out_d1_din, lane_out_d1_q : std_ulogic_vector(0 to 15);
  SIGNAL lane_out_d2_din, lane_out_d2_q : std_ulogic_vector(0 to 15);
  SIGNAL lane_out_d3_din, lane_out_d3_q : std_ulogic_vector(0 to 15);
  SIGNAL lane_out_d4_din, lane_out_d4_q : std_ulogic_vector(0 to 15);
  SIGNAL lfsr_din, lfsr_q : std_ulogic_vector(0 to 15);

-- Internal signal declarations
  SIGNAL act : std_ulogic;
  SIGNAL zeros : std_ulogic_vector(0 to 255);
  SIGNAL updated_lfsr : std_ulogic_vector(0 to 15);
  SIGNAL lane_out_int_ecc : std_ulogic_vector(0 to 15);
  SIGNAL clock_out_int : std_ulogic;
  SIGNAL lane_out_int : std_ulogic_vector(0 to 15);
  SIGNAL halfspeedmode : std_ulogic;
  SIGNAL half_out : std_ulogic_vector(0 to 15);


attribute ANALYSIS_NOT_REFERENCED of carryover_q                           : signal is "<128:255>TRUE";
BEGIN
act                                          <= '1';
zeros (0 to 255)                             <= (others => '0');

init_din                     <= '1';
lfsr_din(0 to 15)            <= "1111111111111111"    when init_q = '0' else
                                updated_lfsr(0 to 15);
delay_din(0 to 7)            <= delay(0 to 7) when init_q = '0' else delay_q(0 to 7);

updated_lfsr(0)              <= lfsr_q(15);
updated_lfsr(1)              <= lfsr_q(0);
updated_lfsr(2)              <= lfsr_q(1) xor lfsr_q(15);  -- 
updated_lfsr(3)              <= lfsr_q(2) xor lfsr_q(15);
updated_lfsr(4)              <= lfsr_q(3);
updated_lfsr(5)              <= lfsr_q(4) xor lfsr_q(15);
updated_lfsr(6 to 15)        <= lfsr_q(5 to 14);

halfspeedmode <= '0';
    half : entity work.tb_ln_dly4to1_half
    port map (
        halfspeedmode                  => halfspeedmode                  , -- OVR: tb_ln_dly1to4_4x(half)
        lane_in (0 to 15)              => lane_in (0 to 15)              , -- OVR: tb_ln_dly1to4_4x(half)
        lane_out (0 to 15)             => half_out (0 to 15)             , -- OVD: tb_ln_dly1to4_4x(half)
        opt_gckn                       => opt_gckn                         -- OVR: tb_ln_dly1to4_4x(half)
    ) ;

lane_out_din(0 to 63)                        <= (lane_out_d3_q(0 to 15) & lane_out_d2_q(0 to 15) & lane_out_d1_q(0 to 15) & lane_out_int_ecc(0 to 15)) when clk_cnt_q(0 to 1) = "11" else
                                                lane_out_q(0 to 63);

lane_out_int_ecc(0 to 15)                    <= lane_out_int(0 to 15) when inject_crc = '0' else (lane_out_int(0 to 14) & not lane_out_int(15));
lane_out_d1_din(0 to 15)                     <= lane_out_int_ecc(0 to 15);
lane_out_d2_din(0 to 15)                     <= lane_out_d1_q(0 to 15);
lane_out_d3_din(0 to 15)                     <= lane_out_d2_q(0 to 15);
lane_out_d4_din(0 to 15)                     <= lane_out_d3_q(0 to 15);

lane_out(63 downto 0)                        <= lane_out_q(0 to 63);


gb : entity work.tb_rx_gb
port map (
    valid_out                      => ln_rx_valid                    , -- MSD: tb_rx_gb(gb)
    hdr_out (1 downto 0)           => ln_rx_header (1 downto 0)      , -- MSD: tb_rx_gb(gb)
    lane_in (0 to 63)              => lane_out_q (0 to 63)           , -- MSR: tb_rx_gb(gb)
    lane_out (63 downto 0)         => ln_rx_data     (63 downto 0)   , -- OVD: tb_rx_gb(gb)
    slip                           => ln_rx_slip                     , -- MSR: tb_rx_gb(gb)
    opt_gckn                       => clock_out_int                    -- MSR: tb_rx_gb(gb)
) ;




clk_cnt_din(0 to 1)                          <= clk_cnt_q(0 to 1) + 1;

clock_out_int                                <= not clk_cnt_q(0);
clock_out                                    <= clock_out_int;

with delay_q(0 to 7) select
lane_out_int(0 to 15)                        <=                        half_out(0 to 15)     when "00000000",
                                                carryover_q(0)       & half_out(0 to 14)     when "00000001",
                                                carryover_q(0 to  1) & half_out(0 to 13)     when "00000010",
                                                carryover_q(0 to  2) & half_out(0 to 12)     when "00000011",
                                                carryover_q(0 to  3) & half_out(0 to 11)     when "00000100",
                                                carryover_q(0 to  4) & half_out(0 to 10)     when "00000101",
                                                carryover_q(0 to  5) & half_out(0 to  9)     when "00000110",
                                                carryover_q(0 to  6) & half_out(0 to  8)     when "00000111",
                                                carryover_q(0 to  7) & half_out(0 to  7)     when "00001000",
                                                carryover_q(0 to  8) & half_out(0 to  6)     when "00001001",
                                                carryover_q(0 to  9) & half_out(0 to  5)     when "00001010",
                                                carryover_q(0 to 10) & half_out(0 to  4)     when "00001011",
                                                carryover_q(0 to 11) & half_out(0 to  3)     when "00001100",
                                                carryover_q(0 to 12) & half_out(0 to  2)     when "00001101",
                                                carryover_q(0 to 13) & half_out(0 to  1)     when "00001110",
                                                carryover_q(0 to 14) & half_out(0)           when "00001111",
                                                zeros(0 to 15)                              when "11111110",
                                                lfsr_q(0 to 15)                             when "11111111",
                                                carryover_q(0 to 15)                        when others;

with delay_q(0 to 7) select
carryover_din(0 to 255)                      <=                                              zeros(0 to 255)     when "00000000",
                                                                         half_out(15)       & zeros(0 to 254)     when "00000001",
                                                                         half_out(14 to 15) & zeros(0 to 253)     when "00000010",
                                                                         half_out(13 to 15) & zeros(0 to 252)     when "00000011",
                                                                         half_out(12 to 15) & zeros(0 to 251)     when "00000100",
                                                                         half_out(11 to 15) & zeros(0 to 250)     when "00000101",
                                                                         half_out(10 to 15) & zeros(0 to 249)     when "00000110",
                                                                         half_out( 9 to 15) & zeros(0 to 248)     when "00000111",
                                                                         half_out( 8 to 15) & zeros(0 to 247)     when "00001000",
                                                                         half_out( 7 to 15) & zeros(0 to 246)     when "00001001",
                                                                         half_out( 6 to 15) & zeros(0 to 245)     when "00001010",
                                                                         half_out( 5 to 15) & zeros(0 to 244)     when "00001011",
                                                                         half_out( 4 to 15) & zeros(0 to 243)     when "00001100",
                                                                         half_out( 3 to 15) & zeros(0 to 242)     when "00001101",
                                                                         half_out( 2 to 15) & zeros(0 to 241)     when "00001110",
                                                                         half_out( 1 to 15) & zeros(0 to 240)     when "00001111",
                                                                         half_out( 0 to 15) & zeros(0 to 239)     when "00010000",
                                                carryover_q(16)        & half_out( 0 to 15) & zeros(0 to 238)     when "00010001",
                                                carryover_q(16 to  17) & half_out( 0 to 15) & zeros(0 to 237)     when "00010010",
                                                carryover_q(16 to  18) & half_out( 0 to 15) & zeros(0 to 236)     when "00010011",
                                                carryover_q(16 to  19) & half_out( 0 to 15) & zeros(0 to 235)     when "00010100",
                                                carryover_q(16 to  20) & half_out( 0 to 15) & zeros(0 to 234)     when "00010101",
                                                carryover_q(16 to  21) & half_out( 0 to 15) & zeros(0 to 233)     when "00010110",
                                                carryover_q(16 to  22) & half_out( 0 to 15) & zeros(0 to 232)     when "00010111",
                                                carryover_q(16 to  23) & half_out( 0 to 15) & zeros(0 to 231)     when "00011000",
                                                carryover_q(16 to  24) & half_out( 0 to 15) & zeros(0 to 230)     when "00011001",
                                                carryover_q(16 to  25) & half_out( 0 to 15) & zeros(0 to 229)     when "00011010",
                                                carryover_q(16 to  26) & half_out( 0 to 15) & zeros(0 to 228)     when "00011011",
                                                carryover_q(16 to  27) & half_out( 0 to 15) & zeros(0 to 227)     when "00011100",
                                                carryover_q(16 to  28) & half_out( 0 to 15) & zeros(0 to 226)     when "00011101",
                                                carryover_q(16 to  29) & half_out( 0 to 15) & zeros(0 to 225)     when "00011110",
                                                carryover_q(16 to  30) & half_out( 0 to 15) & zeros(0 to 224)     when "00011111",
                                                carryover_q(16 to  31) & half_out( 0 to 15) & zeros(0 to 223)     when "00100000",
                                                carryover_q(16 to  32) & half_out( 0 to 15) & zeros(0 to 222)     when "00100001",
                                                carryover_q(16 to  33) & half_out( 0 to 15) & zeros(0 to 221)     when "00100010",
                                                carryover_q(16 to  34) & half_out( 0 to 15) & zeros(0 to 220)     when "00100011",
                                                carryover_q(16 to  35) & half_out( 0 to 15) & zeros(0 to 219)     when "00100100",
                                                carryover_q(16 to  36) & half_out( 0 to 15) & zeros(0 to 218)     when "00100101",
                                                carryover_q(16 to  37) & half_out( 0 to 15) & zeros(0 to 217)     when "00100110",
                                                carryover_q(16 to  38) & half_out( 0 to 15) & zeros(0 to 216)     when "00100111",
                                                carryover_q(16 to  39) & half_out( 0 to 15) & zeros(0 to 215)     when "00101000",
                                                carryover_q(16 to  40) & half_out( 0 to 15) & zeros(0 to 214)     when "00101001",
                                                carryover_q(16 to  41) & half_out( 0 to 15) & zeros(0 to 213)     when "00101010",
                                                carryover_q(16 to  42) & half_out( 0 to 15) & zeros(0 to 212)     when "00101011",
                                                carryover_q(16 to  43) & half_out( 0 to 15) & zeros(0 to 211)     when "00101100",
                                                carryover_q(16 to  44) & half_out( 0 to 15) & zeros(0 to 210)     when "00101101",
                                                carryover_q(16 to  45) & half_out( 0 to 15) & zeros(0 to 209)     when "00101110",
                                                carryover_q(16 to  46) & half_out( 0 to 15) & zeros(0 to 208)     when "00101111",
                                                carryover_q(16 to  47) & half_out( 0 to 15) & zeros(0 to 207)     when "00110000",
                                                carryover_q(16 to  48) & half_out( 0 to 15) & zeros(0 to 206)     when "00110001",
                                                carryover_q(16 to  49) & half_out( 0 to 15) & zeros(0 to 205)     when "00110010",
                                                carryover_q(16 to  50) & half_out( 0 to 15) & zeros(0 to 204)     when "00110011",
                                                carryover_q(16 to  51) & half_out( 0 to 15) & zeros(0 to 203)     when "00110100",
                                                carryover_q(16 to  52) & half_out( 0 to 15) & zeros(0 to 202)     when "00110101",
                                                carryover_q(16 to  53) & half_out( 0 to 15) & zeros(0 to 201)     when "00110110",
                                                carryover_q(16 to  54) & half_out( 0 to 15) & zeros(0 to 200)     when "00110111",
                                                carryover_q(16 to  55) & half_out( 0 to 15) & zeros(0 to 199)     when "00111000",
                                                carryover_q(16 to  56) & half_out( 0 to 15) & zeros(0 to 198)     when "00111001",
                                                carryover_q(16 to  57) & half_out( 0 to 15) & zeros(0 to 197)     when "00111010",
                                                carryover_q(16 to  58) & half_out( 0 to 15) & zeros(0 to 196)     when "00111011",
                                                carryover_q(16 to  59) & half_out( 0 to 15) & zeros(0 to 195)     when "00111100",
                                                carryover_q(16 to  60) & half_out( 0 to 15) & zeros(0 to 194)     when "00111101",
                                                carryover_q(16 to  61) & half_out( 0 to 15) & zeros(0 to 193)     when "00111110",
                                                carryover_q(16 to  62) & half_out( 0 to 15) & zeros(0 to 192)     when "00111111",
                                                carryover_q(16 to  63) & half_out( 0 to 15) & zeros(0 to 191)     when "01000000",
                                                carryover_q(16 to  64) & half_out( 0 to 15) & zeros(0 to 190)     when "01000001",
                                                carryover_q(16 to  65) & half_out( 0 to 15) & zeros(0 to 189)     when "01000010",
                                                carryover_q(16 to  66) & half_out( 0 to 15) & zeros(0 to 188)     when "01000011",
                                                carryover_q(16 to  67) & half_out( 0 to 15) & zeros(0 to 187)     when "01000100",
                                                carryover_q(16 to  68) & half_out( 0 to 15) & zeros(0 to 186)     when "01000101",
                                                carryover_q(16 to  69) & half_out( 0 to 15) & zeros(0 to 185)     when "01000110",
                                                carryover_q(16 to  70) & half_out( 0 to 15) & zeros(0 to 184)     when "01000111",
                                                carryover_q(16 to  71) & half_out( 0 to 15) & zeros(0 to 183)     when "01001000",
                                                carryover_q(16 to  72) & half_out( 0 to 15) & zeros(0 to 182)     when "01001001",
                                                carryover_q(16 to  73) & half_out( 0 to 15) & zeros(0 to 181)     when "01001010",
                                                carryover_q(16 to  74) & half_out( 0 to 15) & zeros(0 to 180)     when "01001011",
                                                carryover_q(16 to  75) & half_out( 0 to 15) & zeros(0 to 179)     when "01001100",
                                                carryover_q(16 to  76) & half_out( 0 to 15) & zeros(0 to 178)     when "01001101",
                                                carryover_q(16 to  77) & half_out( 0 to 15) & zeros(0 to 177)     when "01001110",
                                                carryover_q(16 to  78) & half_out( 0 to 15) & zeros(0 to 176)     when "01001111",
                                                carryover_q(16 to  79) & half_out( 0 to 15) & zeros(0 to 175)     when "01010000",
                                                carryover_q(16 to  80) & half_out( 0 to 15) & zeros(0 to 174)     when "01010001",
                                                carryover_q(16 to  81) & half_out( 0 to 15) & zeros(0 to 173)     when "01010010",
                                                carryover_q(16 to  82) & half_out( 0 to 15) & zeros(0 to 172)     when "01010011",
                                                carryover_q(16 to  83) & half_out( 0 to 15) & zeros(0 to 171)     when "01010100",
                                                carryover_q(16 to  84) & half_out( 0 to 15) & zeros(0 to 170)     when "01010101",
                                                carryover_q(16 to  85) & half_out( 0 to 15) & zeros(0 to 169)     when "01010110",
                                                carryover_q(16 to  86) & half_out( 0 to 15) & zeros(0 to 168)     when "01010111",
                                                carryover_q(16 to  87) & half_out( 0 to 15) & zeros(0 to 167)     when "01011000",
                                                carryover_q(16 to  88) & half_out( 0 to 15) & zeros(0 to 166)     when "01011001",
                                                carryover_q(16 to  89) & half_out( 0 to 15) & zeros(0 to 165)     when "01011010",
                                                carryover_q(16 to  90) & half_out( 0 to 15) & zeros(0 to 164)     when "01011011",
                                                carryover_q(16 to  91) & half_out( 0 to 15) & zeros(0 to 163)     when "01011100",
                                                carryover_q(16 to  92) & half_out( 0 to 15) & zeros(0 to 162)     when "01011101",
                                                carryover_q(16 to  93) & half_out( 0 to 15) & zeros(0 to 161)     when "01011110",
                                                carryover_q(16 to  94) & half_out( 0 to 15) & zeros(0 to 160)     when "01011111",
                                                carryover_q(16 to  95) & half_out( 0 to 15) & zeros(0 to 159)     when "01100000",
                                                carryover_q(16 to  96) & half_out( 0 to 15) & zeros(0 to 158)     when "01100001",
                                                carryover_q(16 to  97) & half_out( 0 to 15) & zeros(0 to 157)     when "01100010",
                                                carryover_q(16 to  98) & half_out( 0 to 15) & zeros(0 to 156)     when "01100011",
                                                carryover_q(16 to  99) & half_out( 0 to 15) & zeros(0 to 155)     when "01100100",
                                                carryover_q(16 to 100) & half_out( 0 to 15) & zeros(0 to 154)     when "01100101",
                                                carryover_q(16 to 101) & half_out( 0 to 15) & zeros(0 to 153)     when "01100110",
                                                carryover_q(16 to 102) & half_out( 0 to 15) & zeros(0 to 152)     when "01100111",
                                                carryover_q(16 to 103) & half_out( 0 to 15) & zeros(0 to 151)     when "01101000",
                                                carryover_q(16 to 104) & half_out( 0 to 15) & zeros(0 to 150)     when "01101001",
                                                carryover_q(16 to 105) & half_out( 0 to 15) & zeros(0 to 149)     when "01101010",
                                                carryover_q(16 to 106) & half_out( 0 to 15) & zeros(0 to 148)     when "01101011",
                                                carryover_q(16 to 107) & half_out( 0 to 15) & zeros(0 to 147)     when "01101100",
                                                carryover_q(16 to 108) & half_out( 0 to 15) & zeros(0 to 146)     when "01101101",
                                                carryover_q(16 to 109) & half_out( 0 to 15) & zeros(0 to 145)     when "01101110",
                                                carryover_q(16 to 110) & half_out( 0 to 15) & zeros(0 to 144)     when "01101111",
                                                carryover_q(16 to 111) & half_out( 0 to 15) & zeros(0 to 143)     when "01110000",
                                                carryover_q(16 to 112) & half_out( 0 to 15) & zeros(0 to 142)     when "01110001",
                                                carryover_q(16 to 113) & half_out( 0 to 15) & zeros(0 to 141)     when "01110010",
                                                carryover_q(16 to 114) & half_out( 0 to 15) & zeros(0 to 140)     when "01110011",
                                                carryover_q(16 to 115) & half_out( 0 to 15) & zeros(0 to 139)     when "01110100",
                                                carryover_q(16 to 116) & half_out( 0 to 15) & zeros(0 to 138)     when "01110101",
                                                carryover_q(16 to 117) & half_out( 0 to 15) & zeros(0 to 137)     when "01110110",
                                                carryover_q(16 to 118) & half_out( 0 to 15) & zeros(0 to 136)     when "01110111",
                                                carryover_q(16 to 119) & half_out( 0 to 15) & zeros(0 to 135)     when "01111000",
                                                carryover_q(16 to 120) & half_out( 0 to 15) & zeros(0 to 134)     when "01111001",
                                                carryover_q(16 to 121) & half_out( 0 to 15) & zeros(0 to 133)     when "01111010",
                                                carryover_q(16 to 122) & half_out( 0 to 15) & zeros(0 to 132)     when "01111011",
                                                carryover_q(16 to 123) & half_out( 0 to 15) & zeros(0 to 131)     when "01111100",
                                                carryover_q(16 to 124) & half_out( 0 to 15) & zeros(0 to 130)     when "01111101",
                                                carryover_q(16 to 125) & half_out( 0 to 15) & zeros(0 to 129)     when "01111110",
                                                carryover_q(16 to 126) & half_out( 0 to 15) & zeros(0 to 128)     when "01111111",
                                                carryover_q(16 to 127) & half_out( 0 to 15) & zeros(0 to 127)     when others;

carryoverq: entity work.fire_morph_dff
  generic map (width => 256)
  port map(gckn                 => opt_gckn,
           e                    => act,
           d                    => carryover_din(0 to 255),
           q                    => carryover_q(0 to 255));

clk_cntq: entity work.fire_morph_dff
  generic map (width => 2)
  port map(gckn                 => opt_gckn,
           e                    => act,
           d                    => clk_cnt_din(0 to 1),
           q                    => clk_cnt_q(0 to 1));

delayq: entity work.fire_morph_dff
  generic map (width => 8)
  port map(gckn                 => opt_gckn,
           e                    => act,
           d                    => delay_din(0 to 7),
           q                    => delay_q(0 to 7));

initq: entity work.fire_morph_dff
  generic map (width => 1)
  port map(gckn                 => opt_gckn,
           e                    => act,
           d(0)                 => Tconv(init_din),
           q(0)                 => init_q);

lane_out_d1q: entity work.fire_morph_dff
  generic map (width => 16)
  port map(gckn                 => opt_gckn,
           e                    => act,
           d                    => lane_out_d1_din(0 to 15),
           q                    => lane_out_d1_q(0 to 15));

lane_out_d2q: entity work.fire_morph_dff
  generic map (width => 16)
  port map(gckn                 => opt_gckn,
           e                    => act,
           d                    => lane_out_d2_din(0 to 15),
           q                    => lane_out_d2_q(0 to 15));

lane_out_d3q: entity work.fire_morph_dff
  generic map (width => 16)
  port map(gckn                 => opt_gckn,
           e                    => act,
           d                    => lane_out_d3_din(0 to 15),
           q                    => lane_out_d3_q(0 to 15));

lane_out_d4q: entity work.fire_morph_dff
  generic map (width => 16)
  port map(gckn                 => opt_gckn,
           e                    => act,
           d                    => lane_out_d4_din(0 to 15),
           q                    => lane_out_d4_q(0 to 15));

lane_outq: entity work.fire_morph_dff
  generic map (width => 64)
  port map(gckn                 => opt_gckn,
           e                    => act,
           d                    => lane_out_din(0 to 63),
           q                    => lane_out_q(0 to 63));

lfsrq: entity work.fire_morph_dff
  generic map (width => 16)
  port map(gckn                 => opt_gckn,
           e                    => act,
           d                    => lfsr_din(0 to 15),
           q                    => lfsr_q(0 to 15));

End tb_ln_dly4to1;
