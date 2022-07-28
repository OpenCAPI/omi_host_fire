-- $Id: tb_rx_gb.vhdl 2455 2016-02-01 19:13:39Z lonny $
-- $URL: file:///afs/awd/projects/eclipz/c14/libs/fbc/.svnDB/p9ndd1/main/vhdl/tb_rx_gb.vhdl $
-- @!Created with MAKESCH v.1.53
-- *!********************************************************************
-- *! (C) Copyright International Business Machines Corporation 2007-2013
-- *!           All Rights Reserved -- Property of IBM
-- *!                    *** IBM Confidential ***
-- *!********************************************************************
-- *! FILE NAME   :  tb_rx_gb.vhdl
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



Entity tb_rx_gb is port (

  lane_in                        : in std_ulogic_vector(0 to 63);
  valid_out                      : out std_ulogic;                             
  hdr_out                        : out std_ulogic_vector(1 downto 0);
  lane_out                       : out std_ulogic_vector(63 downto 0);
  slip                           : in std_ulogic;

---------------------------
-- clock controls
---------------------------

  opt_gckn                       : in std_ulogic

);
 Attribute BLOCK_TYPE of tb_rx_gb : entity is leaf;
 Attribute BTR_NAME of tb_rx_gb : entity is "TB_RX_GB";
 Attribute RECURSIVE_SYNTHESIS of tb_rx_gb : entity is 2;
 attribute pin_data of opt_gckn   : signal is "PIN_FUNCTION=/G_CLK/";

end tb_rx_gb ;
----------
Architecture tb_rx_gb of tb_rx_gb is



-- Register signal declarations
  SIGNAL buffer_din, buffer_q : std_ulogic_vector(0 to 255);
  SIGNAL data_din, data_q : std_ulogic_vector(0 to 63);
  SIGNAL data_cnt_din, data_cnt_q : std_ulogic_vector(0 to 7);
  SIGNAL data_ptr_din, data_ptr_q : std_ulogic_vector(0 to 7);
  SIGNAL header_din, header_q : std_ulogic_vector(0 to 1);
  SIGNAL in_cnt_din, in_cnt_q : std_ulogic_vector(0 to 1);
  SIGNAL valid_din, valid_q : std_ulogic;

-- Internal signal declarations
  SIGNAL act : std_ulogic;
  SIGNAL valid : std_ulogic;
  SIGNAL next_dat : std_ulogic_vector(0 to 65);

BEGIN
act                                          <= '1';

in_cnt_din(0 to 1)                           <= in_cnt_q(0 to 1) + 1;

with (in_cnt_q(0 to 1)) select
buffer_din(0 to 255)                         <=                        lane_in(0 to 63) & buffer_q( 64 to 255) when "00",
                                                buffer_q(  0 to  63) & lane_in(0 to 63) & buffer_q(128 to 255) when "01",
                                                buffer_q(  0 to 127) & lane_in(0 to 63) & buffer_q(192 to 255) when "10",
                                                buffer_q(  0 to 191) & lane_in(0 to 63)                        when "11",
                                                buffer_q(  0 to 255)                                           when others;

valid                                        <= ((data_cnt_q(0 to 7) > "01000001") and valid_q) or ((data_cnt_q(0 to 7) > "10000001") and not valid_q); --greater than 66

data_cnt_din(0 to 7)                         <= data_cnt_q(0 to 7) + 64 when valid = '0' and slip = '0' else
                                                data_cnt_q(0 to 7) + 63 when valid = '0' and slip = '1' else
                                                data_cnt_q(0 to 7) -  2 when valid = '1' and slip = '0' else
                                                data_cnt_q(0 to 7) -  3 when valid = '1' and slip = '1' else
                                                data_cnt_q(0 to 7);

data_ptr_din(0 to 7)                         <= data_ptr_q(0 to 7) + 66 when valid = '1' and slip = '0' else
                                                data_ptr_q(0 to 7) + 67 when valid = '1' and slip = '1' else
                                                data_ptr_q(0 to 7) +  1 when valid = '0' and slip = '1' else
                                                data_ptr_q(0 to 7);

with data_ptr_q(0 to 7) select
next_dat(0 to 65)                            <= buffer_q(  0 to  65)                        when "00000000",
                                                buffer_q(  1 to  66)                        when "00000001",
                                                buffer_q(  2 to  67)                        when "00000010",
                                                buffer_q(  3 to  68)                        when "00000011",
                                                buffer_q(  4 to  69)                        when "00000100",
                                                buffer_q(  5 to  70)                        when "00000101",
                                                buffer_q(  6 to  71)                        when "00000110",
                                                buffer_q(  7 to  72)                        when "00000111",
                                                buffer_q(  8 to  73)                        when "00001000",
                                                buffer_q(  9 to  74)                        when "00001001",
                                                buffer_q( 10 to  75)                        when "00001010",
                                                buffer_q( 11 to  76)                        when "00001011",
                                                buffer_q( 12 to  77)                        when "00001100",
                                                buffer_q( 13 to  78)                        when "00001101",
                                                buffer_q( 14 to  79)                        when "00001110",
                                                buffer_q( 15 to  80)                        when "00001111",
                                                buffer_q( 16 to  81)                        when "00010000",
                                                buffer_q( 17 to  82)                        when "00010001",
                                                buffer_q( 18 to  83)                        when "00010010",
                                                buffer_q( 19 to  84)                        when "00010011",
                                                buffer_q( 20 to  85)                        when "00010100",
                                                buffer_q( 21 to  86)                        when "00010101",
                                                buffer_q( 22 to  87)                        when "00010110",
                                                buffer_q( 23 to  88)                        when "00010111",
                                                buffer_q( 24 to  89)                        when "00011000",
                                                buffer_q( 25 to  90)                        when "00011001",
                                                buffer_q( 26 to  91)                        when "00011010",
                                                buffer_q( 27 to  92)                        when "00011011",
                                                buffer_q( 28 to  93)                        when "00011100",
                                                buffer_q( 29 to  94)                        when "00011101",
                                                buffer_q( 30 to  95)                        when "00011110",
                                                buffer_q( 31 to  96)                        when "00011111",
                                                buffer_q( 32 to  97)                        when "00100000",
                                                buffer_q( 33 to  98)                        when "00100001",
                                                buffer_q( 34 to  99)                        when "00100010",
                                                buffer_q( 35 to 100)                        when "00100011",
                                                buffer_q( 36 to 101)                        when "00100100",
                                                buffer_q( 37 to 102)                        when "00100101",
                                                buffer_q( 38 to 103)                        when "00100110",
                                                buffer_q( 39 to 104)                        when "00100111",
                                                buffer_q( 40 to 105)                        when "00101000",
                                                buffer_q( 41 to 106)                        when "00101001",
                                                buffer_q( 42 to 107)                        when "00101010",
                                                buffer_q( 43 to 108)                        when "00101011",
                                                buffer_q( 44 to 109)                        when "00101100",
                                                buffer_q( 45 to 110)                        when "00101101",
                                                buffer_q( 46 to 111)                        when "00101110",
                                                buffer_q( 47 to 112)                        when "00101111",
                                                buffer_q( 48 to 113)                        when "00110000",
                                                buffer_q( 49 to 114)                        when "00110001",
                                                buffer_q( 50 to 115)                        when "00110010",
                                                buffer_q( 51 to 116)                        when "00110011",
                                                buffer_q( 52 to 117)                        when "00110100",
                                                buffer_q( 53 to 118)                        when "00110101",
                                                buffer_q( 54 to 119)                        when "00110110",
                                                buffer_q( 55 to 120)                        when "00110111",
                                                buffer_q( 56 to 121)                        when "00111000",
                                                buffer_q( 57 to 122)                        when "00111001",
                                                buffer_q( 58 to 123)                        when "00111010",
                                                buffer_q( 59 to 124)                        when "00111011",
                                                buffer_q( 60 to 125)                        when "00111100",
                                                buffer_q( 61 to 126)                        when "00111101",
                                                buffer_q( 62 to 127)                        when "00111110",
                                                buffer_q( 63 to 128)                        when "00111111",
                                                buffer_q( 64 to 129)                        when "01000000",
                                                buffer_q( 65 to 130)                        when "01000001",
                                                buffer_q( 66 to 131)                        when "01000010",
                                                buffer_q( 67 to 132)                        when "01000011",
                                                buffer_q( 68 to 133)                        when "01000100",
                                                buffer_q( 69 to 134)                        when "01000101",
                                                buffer_q( 70 to 135)                        when "01000110",
                                                buffer_q( 71 to 136)                        when "01000111",
                                                buffer_q( 72 to 137)                        when "01001000",
                                                buffer_q( 73 to 138)                        when "01001001",
                                                buffer_q( 74 to 139)                        when "01001010",
                                                buffer_q( 75 to 140)                        when "01001011",
                                                buffer_q( 76 to 141)                        when "01001100",
                                                buffer_q( 77 to 142)                        when "01001101",
                                                buffer_q( 78 to 143)                        when "01001110",
                                                buffer_q( 79 to 144)                        when "01001111",
                                                buffer_q( 80 to 145)                        when "01010000",
                                                buffer_q( 81 to 146)                        when "01010001",
                                                buffer_q( 82 to 147)                        when "01010010",
                                                buffer_q( 83 to 148)                        when "01010011",
                                                buffer_q( 84 to 149)                        when "01010100",
                                                buffer_q( 85 to 150)                        when "01010101",
                                                buffer_q( 86 to 151)                        when "01010110",
                                                buffer_q( 87 to 152)                        when "01010111",
                                                buffer_q( 88 to 153)                        when "01011000",
                                                buffer_q( 89 to 154)                        when "01011001",
                                                buffer_q( 90 to 155)                        when "01011010",
                                                buffer_q( 91 to 156)                        when "01011011",
                                                buffer_q( 92 to 157)                        when "01011100",
                                                buffer_q( 93 to 158)                        when "01011101",
                                                buffer_q( 94 to 159)                        when "01011110",
                                                buffer_q( 95 to 160)                        when "01011111",
                                                buffer_q( 96 to 161)                        when "01100000",
                                                buffer_q( 97 to 162)                        when "01100001",
                                                buffer_q( 98 to 163)                        when "01100010",
                                                buffer_q( 99 to 164)                        when "01100011",
                                                buffer_q(100 to 165)                        when "01100100",
                                                buffer_q(101 to 166)                        when "01100101",
                                                buffer_q(102 to 167)                        when "01100110",
                                                buffer_q(103 to 168)                        when "01100111",
                                                buffer_q(104 to 169)                        when "01101000",
                                                buffer_q(105 to 170)                        when "01101001",
                                                buffer_q(106 to 171)                        when "01101010",
                                                buffer_q(107 to 172)                        when "01101011",
                                                buffer_q(108 to 173)                        when "01101100",
                                                buffer_q(109 to 174)                        when "01101101",
                                                buffer_q(110 to 175)                        when "01101110",
                                                buffer_q(111 to 176)                        when "01101111",
                                                buffer_q(112 to 177)                        when "01110000",
                                                buffer_q(113 to 178)                        when "01110001",
                                                buffer_q(114 to 179)                        when "01110010",
                                                buffer_q(115 to 180)                        when "01110011",
                                                buffer_q(116 to 181)                        when "01110100",
                                                buffer_q(117 to 182)                        when "01110101",
                                                buffer_q(118 to 183)                        when "01110110",
                                                buffer_q(119 to 184)                        when "01110111",
                                                buffer_q(120 to 185)                        when "01111000",
                                                buffer_q(121 to 186)                        when "01111001",
                                                buffer_q(122 to 187)                        when "01111010",
                                                buffer_q(123 to 188)                        when "01111011",
                                                buffer_q(124 to 189)                        when "01111100",
                                                buffer_q(125 to 190)                        when "01111101",
                                                buffer_q(126 to 191)                        when "01111110",
                                                buffer_q(127 to 192)                        when "01111111",
                                                buffer_q(128 to 193)                        when "10000000",
                                                buffer_q(129 to 194)                        when "10000001",
                                                buffer_q(130 to 195)                        when "10000010",
                                                buffer_q(131 to 196)                        when "10000011",
                                                buffer_q(132 to 197)                        when "10000100",
                                                buffer_q(133 to 198)                        when "10000101",
                                                buffer_q(134 to 199)                        when "10000110",
                                                buffer_q(135 to 200)                        when "10000111",
                                                buffer_q(136 to 201)                        when "10001000",
                                                buffer_q(137 to 202)                        when "10001001",
                                                buffer_q(138 to 203)                        when "10001010",
                                                buffer_q(139 to 204)                        when "10001011",
                                                buffer_q(140 to 205)                        when "10001100",
                                                buffer_q(141 to 206)                        when "10001101",
                                                buffer_q(142 to 207)                        when "10001110",
                                                buffer_q(143 to 208)                        when "10001111",
                                                buffer_q(144 to 209)                        when "10010000",
                                                buffer_q(145 to 210)                        when "10010001",
                                                buffer_q(146 to 211)                        when "10010010",
                                                buffer_q(147 to 212)                        when "10010011",
                                                buffer_q(148 to 213)                        when "10010100",
                                                buffer_q(149 to 214)                        when "10010101",
                                                buffer_q(150 to 215)                        when "10010110",
                                                buffer_q(151 to 216)                        when "10010111",
                                                buffer_q(152 to 217)                        when "10011000",
                                                buffer_q(153 to 218)                        when "10011001",
                                                buffer_q(154 to 219)                        when "10011010",
                                                buffer_q(155 to 220)                        when "10011011",
                                                buffer_q(156 to 221)                        when "10011100",
                                                buffer_q(157 to 222)                        when "10011101",
                                                buffer_q(158 to 223)                        when "10011110",
                                                buffer_q(159 to 224)                        when "10011111",
                                                buffer_q(160 to 225)                        when "10100000",
                                                buffer_q(161 to 226)                        when "10100001",
                                                buffer_q(162 to 227)                        when "10100010",
                                                buffer_q(163 to 228)                        when "10100011",
                                                buffer_q(164 to 229)                        when "10100100",
                                                buffer_q(165 to 230)                        when "10100101",
                                                buffer_q(166 to 231)                        when "10100110",
                                                buffer_q(167 to 232)                        when "10100111",
                                                buffer_q(168 to 233)                        when "10101000",
                                                buffer_q(169 to 234)                        when "10101001",
                                                buffer_q(170 to 235)                        when "10101010",
                                                buffer_q(171 to 236)                        when "10101011",
                                                buffer_q(172 to 237)                        when "10101100",
                                                buffer_q(173 to 238)                        when "10101101",
                                                buffer_q(174 to 239)                        when "10101110",
                                                buffer_q(175 to 240)                        when "10101111",
                                                buffer_q(176 to 241)                        when "10110000",
                                                buffer_q(177 to 242)                        when "10110001",
                                                buffer_q(178 to 243)                        when "10110010",
                                                buffer_q(179 to 244)                        when "10110011",
                                                buffer_q(180 to 245)                        when "10110100",
                                                buffer_q(181 to 246)                        when "10110101",
                                                buffer_q(182 to 247)                        when "10110110",
                                                buffer_q(183 to 248)                        when "10110111",
                                                buffer_q(184 to 249)                        when "10111000",
                                                buffer_q(185 to 250)                        when "10111001",
                                                buffer_q(186 to 251)                        when "10111010",
                                                buffer_q(187 to 252)                        when "10111011",
                                                buffer_q(188 to 253)                        when "10111100",
                                                buffer_q(189 to 254)                        when "10111101",
                                                buffer_q(190 to 255)                        when "10111110",
                                                buffer_q(191 to 255) & buffer_q(  0)        when "10111111",
                                                buffer_q(192 to 255) & buffer_q(  0 to   1) when "11000000",
                                                buffer_q(193 to 255) & buffer_q(  0 to   2) when "11000001",
                                                buffer_q(194 to 255) & buffer_q(  0 to   3) when "11000010",
                                                buffer_q(195 to 255) & buffer_q(  0 to   4) when "11000011",
                                                buffer_q(196 to 255) & buffer_q(  0 to   5) when "11000100",
                                                buffer_q(197 to 255) & buffer_q(  0 to   6) when "11000101",
                                                buffer_q(198 to 255) & buffer_q(  0 to   7) when "11000110",
                                                buffer_q(199 to 255) & buffer_q(  0 to   8) when "11000111",
                                                buffer_q(200 to 255) & buffer_q(  0 to   9) when "11001000",
                                                buffer_q(201 to 255) & buffer_q(  0 to  10) when "11001001",
                                                buffer_q(202 to 255) & buffer_q(  0 to  11) when "11001010",
                                                buffer_q(203 to 255) & buffer_q(  0 to  12) when "11001011",
                                                buffer_q(204 to 255) & buffer_q(  0 to  13) when "11001100",
                                                buffer_q(205 to 255) & buffer_q(  0 to  14) when "11001101",
                                                buffer_q(206 to 255) & buffer_q(  0 to  15) when "11001110",
                                                buffer_q(207 to 255) & buffer_q(  0 to  16) when "11001111",
                                                buffer_q(208 to 255) & buffer_q(  0 to  17) when "11010000",
                                                buffer_q(209 to 255) & buffer_q(  0 to  18) when "11010001",
                                                buffer_q(210 to 255) & buffer_q(  0 to  19) when "11010010",
                                                buffer_q(211 to 255) & buffer_q(  0 to  20) when "11010011",
                                                buffer_q(212 to 255) & buffer_q(  0 to  21) when "11010100",
                                                buffer_q(213 to 255) & buffer_q(  0 to  22) when "11010101",
                                                buffer_q(214 to 255) & buffer_q(  0 to  23) when "11010110",
                                                buffer_q(215 to 255) & buffer_q(  0 to  24) when "11010111",
                                                buffer_q(216 to 255) & buffer_q(  0 to  25) when "11011000",
                                                buffer_q(217 to 255) & buffer_q(  0 to  26) when "11011001",
                                                buffer_q(218 to 255) & buffer_q(  0 to  27) when "11011010",
                                                buffer_q(219 to 255) & buffer_q(  0 to  28) when "11011011",
                                                buffer_q(220 to 255) & buffer_q(  0 to  29) when "11011100",
                                                buffer_q(221 to 255) & buffer_q(  0 to  30) when "11011101",
                                                buffer_q(222 to 255) & buffer_q(  0 to  31) when "11011110",
                                                buffer_q(223 to 255) & buffer_q(  0 to  32) when "11011111",
                                                buffer_q(224 to 255) & buffer_q(  0 to  33) when "11100000",
                                                buffer_q(225 to 255) & buffer_q(  0 to  34) when "11100001",
                                                buffer_q(226 to 255) & buffer_q(  0 to  35) when "11100010",
                                                buffer_q(227 to 255) & buffer_q(  0 to  36) when "11100011",
                                                buffer_q(228 to 255) & buffer_q(  0 to  37) when "11100100",
                                                buffer_q(229 to 255) & buffer_q(  0 to  38) when "11100101",
                                                buffer_q(230 to 255) & buffer_q(  0 to  39) when "11100110",
                                                buffer_q(231 to 255) & buffer_q(  0 to  40) when "11100111",
                                                buffer_q(232 to 255) & buffer_q(  0 to  41) when "11101000",
                                                buffer_q(233 to 255) & buffer_q(  0 to  42) when "11101001",
                                                buffer_q(234 to 255) & buffer_q(  0 to  43) when "11101010",
                                                buffer_q(235 to 255) & buffer_q(  0 to  44) when "11101011",
                                                buffer_q(236 to 255) & buffer_q(  0 to  45) when "11101100",
                                                buffer_q(237 to 255) & buffer_q(  0 to  46) when "11101101",
                                                buffer_q(238 to 255) & buffer_q(  0 to  47) when "11101110",
                                                buffer_q(239 to 255) & buffer_q(  0 to  48) when "11101111",
                                                buffer_q(240 to 255) & buffer_q(  0 to  49) when "11110000",
                                                buffer_q(241 to 255) & buffer_q(  0 to  50) when "11110001",
                                                buffer_q(242 to 255) & buffer_q(  0 to  51) when "11110010",
                                                buffer_q(243 to 255) & buffer_q(  0 to  52) when "11110011",
                                                buffer_q(244 to 255) & buffer_q(  0 to  53) when "11110100",
                                                buffer_q(245 to 255) & buffer_q(  0 to  54) when "11110101",
                                                buffer_q(246 to 255) & buffer_q(  0 to  55) when "11110110",
                                                buffer_q(247 to 255) & buffer_q(  0 to  56) when "11110111",
                                                buffer_q(248 to 255) & buffer_q(  0 to  57) when "11111000",
                                                buffer_q(249 to 255) & buffer_q(  0 to  58) when "11111001",
                                                buffer_q(250 to 255) & buffer_q(  0 to  59) when "11111010",
                                                buffer_q(251 to 255) & buffer_q(  0 to  60) when "11111011",
                                                buffer_q(252 to 255) & buffer_q(  0 to  61) when "11111100",
                                                buffer_q(253 to 255) & buffer_q(  0 to  62) when "11111101",
                                                buffer_q(254 to 255) & buffer_q(  0 to  63) when "11111110",
                                                buffer_q(255)        & buffer_q(  0 to  64) when others;

valid_din                                    <= valid;
header_din(0 to 1)                           <= next_dat(0 to 1);
data_din(0 to 63)                            <= next_dat(2 to 65);

valid_out                                    <= valid_q;
hdr_out(1 downto 0)                          <= header_q(0 to 1);
lane_out(63 downto 0)                        <= data_q(0 to 63);

bufferq: entity work.fire_morph_dff
  generic map (width => 256)
  port map(gckn                 => opt_gckn,
           e                    => act,
           d                    => buffer_din(0 to 255),
           q                    => buffer_q(0 to 255));

data_cntq: entity work.fire_morph_dff
  generic map (width => 8)
  port map(gckn                 => opt_gckn,
           e                    => act,
           d                    => data_cnt_din(0 to 7),
           q                    => data_cnt_q(0 to 7));

dataq: entity work.fire_morph_dff
  generic map (width => 64)
  port map(gckn                 => opt_gckn,
           e                    => act,
           d                    => data_din(0 to 63),
           q                    => data_q(0 to 63));

data_ptrq: entity work.fire_morph_dff
  generic map (width => 8)
  port map(gckn                 => opt_gckn,
           e                    => act,
           d                    => data_ptr_din(0 to 7),
           q                    => data_ptr_q(0 to 7));

headerq: entity work.fire_morph_dff
  generic map (width => 2)
  port map(gckn                 => opt_gckn,
           e                    => act,
           d                    => header_din(0 to 1),
           q                    => header_q(0 to 1));

in_cntq: entity work.fire_morph_dff
  generic map (width => 2)
  port map(gckn                 => opt_gckn,
           e                    => act,
           d                    => in_cnt_din(0 to 1),
           q                    => in_cnt_q(0 to 1));

validq: entity work.fire_morph_dff
  generic map (width => 1)
  port map(gckn                 => opt_gckn,
           e                    => act,
           d(0)                 => valid_din,
           q(0)                 => valid_q);

End tb_rx_gb;


