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

library ieee, ibm, work, support;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ibm.std_ulogic_support.all;
use ibm.std_ulogic_unsigned.all;
use ibm.std_ulogic_function_support.all;
use ibm.synthesis_support.all;
use support.logic_support_pkg.all;
use  work.apollo_tlx_pkg.all;
use ieee.numeric_std.std_match;

entity ocx_tl_rcv is
   PORT (
     tlx_clk                           : in std_ulogic;
     reset_n                           : in std_ulogic;
     dlx_tlx_link_up                   : in std_ulogic;
     dlx_tlx_flit_valid                : in std_ulogic;
     dlx_tlx_flit_crc_err              : in std_ulogic;
     dlx_tlx_flit                      : in std_ulogic_vector(511 downto 0);

--   afu_tlx_cmd_rd_req                : in std_ulogic;                         -- | not used in apollo
--   afu_tlx_cmd_rd_cnt                : in std_ulogic_vector(2 downto 0);      -- | not used in apollo
--   afu_tlx_cmd_credit                : in std_ulogic;                         -- | not used in apollo
--   afu_tlx_cmd_initial_credit        : in std_ulogic_vector(6 downto 0);      -- | not used in apollo
                                                                                -- |

     afu_tlx_resp_rd_req               : in std_ulogic;                         -- input that asks for response read data
     afu_tlx_resp_rd_cnt               : in std_ulogic_vector(2 downto 0);      -- beats of response read data to provide (always 1 for apollo)
     tlx_afu_resp_data_valid           : out std_ulogic;                        --  in response to above req
     tlx_afu_resp_data_bus             : out std_ulogic_vector(511 downto 0);   --
     tlx_afu_resp_data_bdi             : out std_ulogic;                        --
     tlx_afu_resp_data_xmeta           : out std_ulogic_vector(63 downto 0);                        --

     afu_tlx_resp_credit               : in std_ulogic;                         -- this is response credit TLX.VC0 returned by the axi
     afu_tlx_resp_initial_credit       : in std_ulogic_vector(6 downto 0);      -- TLX.vc.0 initial value currently 1

     tlx_afu_resp_valid                : out std_ulogic;                        -- same cycle as the opcode and stuff  below
     tlx_afu_resp_opcode               : out std_ulogic_vector(7  downto 0);    -- 8      x
--   tlx_afu_resp_afutag               : out std_ulogic_vector(15 downto 0);    -- 24     not used in apollo
     tlx_afu_resp_captag               : out std_ulogic_vector(15 downto 0);
     tlx_afu_resp_code                 : out std_ulogic_vector(3  downto 0);    -- 28     x
--   tlx_afu_resp_pg_size              : out std_ulogic_vector(5  downto 0);    -- 34     not used in apollo
     tlx_afu_resp_dl                   : out std_ulogic_vector(1  downto 0);    -- 36     x
     tlx_afu_resp_dp                   : out std_ulogic_vector(2  downto 0);    -- 38     x   (need 3 bits now !!!)
--   tlx_afu_resp_host_tag             : out std_ulogic_vector(23 downto 0);    -- 62     not used in apollo
--   tlx_afu_resp_addr_tag             : out std_ulogic_vector(17 downto 0);    -- 80     not used in apollo
--   tlx_afu_resp_cache_state          : out std_ulogic_vector(3  downto 0);    -- 84     not used in apollo

     reg_01_hwwe_i                     : out std_ulogic;                         -- write strobe
     reg_01_update_i                   : out std_ulogic_vector(31 downto 0);     -- write data
     reg_01_o                          : in  std_ulogic_vector(31 downto 0);    -- only bits 2:0 used

     rcv_xmt_tlx_credit_vc0            : out std_ulogic_vector(3 downto 0);     -- from a return_tl(x)_credits - 08
     rcv_xmt_tlx_credit_vc3            : out std_ulogic_vector(3 downto 0);     --
     rcv_xmt_tlx_credit_dcp0           : out std_ulogic_vector(5 downto 0);     --
     rcv_xmt_tlx_credit_dcp3           : out std_ulogic_vector(5 downto 0);     --
     rcv_xmt_tlx_credit_valid          : out std_ulogic;                        -- this need to be from a return_tl_credits   (this comes on when I get an 8)
                                                                                --
     rcv_xmt_tl_credit_vc0_valid       : out std_ulogic;                        -- rcv_xmt_credit_vc0_v in   ocx_tlx_rcv_mac
     rcv_xmt_tl_credit_vc1_valid       : out std_ulogic;                        -- rcv_xmt_credit_v          ocx_tlx_resp_fifo_mac
     rcv_xmt_tl_credit_dcp0_valid      : out std_ulogic;                        --
     rcv_xmt_tl_credit_dcp1_valid      : out std_ulogic                         -- presume these should be VC1 for commands and dcp1 for data, coming out of some counters which say how much
                                                                                --
--   rcv_xmt_tl_crd_cfg_dcp1_valid     : out std_ulogic;                        -- required to be 0 in apollo for dcp1 credit count in the framer (next level up)
--                                                                              --
--   rcv_xmt_debug_info               : out std_ulogic_vector(31 downto 0);     -- not used in apollo
--   rcv_xmt_debug_valid              : out std_ulogic;                         -- not used in apol
--   rcv_xmt_debug_fatal              : out std_ulogic;                         -- not used in apol
--                                                                              --
--   tlx_afu_cmd_valid                 : out std_ulogic;                        -- not used in apollo
--   tlx_afu_cmd_opcode                : out std_ulogic_vector(7 downto 0);     -- not used in apollo
--   tlx_afu_cmd_dl                    : out std_ulogic_vector(1 downto 0);     --
--   tlx_afu_cmd_end                   : out std_ulogic;                        --
--   tlx_afu_cmd_pa                    : out std_ulogic_vector(63 downto 0);    --
--   tlx_afu_cmd_flag                  : out std_ulogic_vector(3 downto 0);     --
--   tlx_afu_cmd_os                    : out std_ulogic;                        --
--   tlx_afu_cmd_pl                    : out std_ulogic_vector(2 downto 0);     --
--   tlx_afu_cmd_be                    : out std_ulogic_vector(63 downto 0);    --
--   tlx_afu_cmd_capptag               : out std_ulogic_vector(15 downto 0);    --
--
--   tlx_afu_cmd_data_valid            : out std_ulogic;                        -- not used in apollo
--   tlx_afu_cmd_data_bus              : out std_ulogic_vector(511 downto 0);   -- not used in apollo
--   tlx_afu_cmd_data_bdi              : out std_ulogic;                        -- not used in apollo
--
--   tlx_afu_ready                     : out std_ulogic                         -- currently implemented as  dlx_tlx_link_up
    );
    end ocx_tl_rcv;


architecture ocx_tl_rcv of ocx_tl_rcv is

   signal bdi_32B_carrier                              : std_ulogic;
   signal bdi_count_d,bdi_count_q                      : std_ulogic_vector(2 downto 0);
   signal bdi_count_nz_d,bdi_count_nz_q                : std_ulogic;
   signal bdi_f1_din                                   : std_ulogic_vector(10 downto 0);
   signal bdi_f1_dout                                  : std_ulogic_vector(10 downto 0);
   signal bdi_f1_empty,bdi_f2_empty                    : std_ulogic;
   signal bdi_f1_overf,bdi_f2_overf                    : std_ulogic;
   signal bdi_f1_read                                  : std_ulogic;
   signal bdi_f1_underf,bdi_f2_underf                  : std_ulogic;
   signal bdi_f1_write,bdi_f2_write                    : std_ulogic;
   signal bdi_f2_din                                   : std_ulogic;
   signal bdi_f2_full                                  : std_ulogic;
   signal cflit                                        : std_ulogic_vector(511 downto 0);
   signal credits_d,credits_q                          : std_ulogic_vector(6 downto 0);
   signal data_rx                                      : std_ulogic;
   signal dcp_in,dcp_out                               : std_ulogic_vector(512 downto 0);
   signal dcp_re,dcp_empty,dcp_overf,dcp_underf        : std_ulogic;
   signal dcp_we                                       : std_ulogic;
   signal dcp_wptr_d,dcp_wptr_q                        : std_ulogic_vector(5 downto 0);
   signal dec_cred,banana                              : std_ulogic;
   signal dflit_cnt_d,dflit_cnt_q                      : std_ulogic_vector(3 downto 0);
   signal dl_din                                       : std_ulogic_vector(512 downto 0);
   signal dl_read,dl_empty                             : std_ulogic;
   signal dl_dout                                      : std_ulogic_vector(512 downto 0);
   signal dl_overf                                     : std_ulogic;
   signal dl_underf                                    : std_ulogic;
   signal dl_valid,dl_write                            : std_ulogic;
   signal ee_0,ee_1,ee_5,ee_9,ee_B                     : std_ulogic;       -- early exit
   signal extended_reset                               : std_ulogic;
   signal finished_ctl                                 : std_ulogic;
   signal init_cnt                                     : std_ulogic_vector(8 downto 0);
   signal last_good_dflit_cnt_d,last_good_dflit_cnt_q  : std_ulogic_vector(3 downto 0);
   signal mux_f1_bit_d,mux_f1_bit_q                    : std_ulogic_vector(2 downto 0);
   signal no_credit                                    : std_ulogic;
   signal parse_st                                     : std_ulogic_vector(10 downto 0);
   signal parsing_ctl_d,parsing_ctl_q                  : std_ulogic;
   signal reset                                        : std_ulogic;
   signal resp_in_d,resp_in_q                          : std_ulogic_vector(55 downto 0);
   signal resp_needs_data,resp_has_data                : std_ulogic;
   signal resp_out                                     : std_ulogic_vector(55 downto 0);
   signal resp_we,resp_overf,resp_empty,resp_underf    : std_ulogic;
   signal resp_wptr_d,resp_wptr_q                      : std_ulogic_vector(6 downto 0);
   signal run_length_d,run_length_q                    : std_ulogic_vector(3 downto 0);
   signal sd_0                                         : std_ulogic_vector(111 downto 0);
   signal sd_1                                         : std_ulogic_vector(111 downto 0);
   signal sd_5                                         : std_ulogic_vector(55 downto 0);
   signal sd_9                                         : std_ulogic_vector(55 downto 0);
   signal sd_b                                         : std_ulogic_vector(55 downto 0);
   signal start_ctl                                    : std_ulogic;
   signal thirty_two_carrier                           : std_ulogic;
   signal tlx_afu_resp_valid_a                         : std_ulogic;
   signal tlx_afu_resp_opcode_a                        : std_ulogic_vector(7 downto 0);
   signal tpl_9B_data_strobe                           : std_ulogic;
   signal vc3_return                                   : std_ulogic;
   signal input_overflow                               : std_ulogic;

   begin

      --synopsys translate_off
      assert not (tlx_clk 'event and tlx_clk = '1' and dlx_tlx_flit_crc_err = '1' and dlx_tlx_flit_valid = '1')
           report "DLX supplying valid and error in the same cycle !)" severity error;
      assert not (tlx_clk 'event and tlx_clk = '1' and dflit_cnt_q > "1000") report "dflit_cnt more than 8!" severity error;
      assert not (tlx_clk 'event and tlx_clk = '1' and dl_overf = '1')   report "TL: input fifo overflowed" severity error;
      assert not (tlx_clk 'event and tlx_clk = '1' and dl_underf = '1')  report "TL: input fifo underflowed" severity error;
      assert not (tlx_clk 'event and tlx_clk = '1' and input_overflow = '1')  report "TL: input array overflowed - issue 42 ?" severity error;
      --synopsys translate_on

    TLX_AFU_RESP_DATA_VALID <= '0'; -- unused

     reset          <= not reset_n;
      ------------------------------------------------------------------------------------
      -- feed stuff from the dl into a fifo.  +data/control : flit(511 downto 0) --
      ------------------------------------------------------------------------------------

    last_good_dflit_cnt_d <= GATE(DLX_TLX_FLIT(451 downto 448), dlx_tlx_flit_valid and not data_rx) or
                             GATE(last_good_dflit_cnt_q, not dlx_tlx_flit_valid or data_rx);

    dflit_cnt_d         <=  last_good_dflit_cnt_q when dlx_tlx_flit_crc_err = '1' else
                            DLX_TLX_FLIT(451 downto 448) when (dlx_tlx_flit_valid and not data_rx) = '1' else
                            dflit_cnt_q - "0001"  when (dlx_tlx_flit_valid and data_rx) = '1' else
                            dflit_cnt_q;

    data_rx  <= OR_REDUCE(dflit_cnt_q);
    dl_din   <= data_rx & dlx_tlx_flit;                                                          -- 512 is + data flit
    dl_write <= dlx_tlx_flit_valid ;

dl_fifo: entity work.aram_input_fifo
  port map (
    clock           => tlx_clk,
    reset           => reset,
    remove_nulls    => '1',
    crc_error       => dlx_tlx_flit_crc_err,
    data_in         => dl_din,
    write           => dl_write,
    read            => dl_read,
    data_out        => dl_dout,
    empty           => dl_empty,
    full            => open,
    overflow        => dl_overf,
    underflow       => dl_underf,
    array_overflow  => input_overflow
  );

    dl_valid   <= not dl_empty;


-- on the output of the fifo we need to regenerate a run length to incrememnt the data pointer with when the following good crc comes in

  run_length_d <= dl_dout(451 downto 448) when start_ctl = '1' else run_length_q;


           ----------------------------------------------------------
           -- parse the output of the fifo if it is a control flit --
           ----------------------------------------------------------

infer: process(tlx_clk)
   begin
    if tlx_clk 'event and tlx_clk = '1' then
       if reset_n = '0' then
          parse_st <= (others=>'0');
          init_cnt <= (others => '0');
          extended_reset <= '1';
          last_good_dflit_cnt_q <= (others => '0');
          dflit_cnt_q           <= (others => '0');
          resp_wptr_q           <= (others => '0');
          cflit(459 downto 0)   <= (others => '0');
          run_length_q          <= (others => '0');
       else
          parse_st(10 downto 0) <= GATE(parse_st(9 downto 0),not finished_ctl) & start_ctl;

          banana <=     run_length_d(0);  -- should get a sinkless warning

          dflit_cnt_q           <= dflit_cnt_d;
          if (init_cnt(3 downto 0) = "1111" or extended_reset = '0') then  extended_reset <= '0'; end if;
          if init_cnt /= "111111111" then
             init_cnt <= init_cnt +  "000000001";
          end if;
          last_good_dflit_cnt_q <= last_good_dflit_cnt_d;
          if start_ctl = '1' then
            cflit(511 downto 0)   <= dl_dout(511 downto 0); -- the flit we are going to parse (this allows us to do data flits at the same time in some cases)
          end if;
          run_length_q          <= run_length_d;
       end if;

       credits_q       <=  credits_d;
       resp_in_q       <=  resp_in_d;
       parsing_ctl_q   <=  parsing_ctl_d;
       dcp_wptr_q      <=  dcp_wptr_d;
       bdi_count_nz_q               <=  bdi_count_nz_d;
       bdi_count_q                  <=  bdi_count_d;
       mux_f1_bit_q                 <=  mux_f1_bit_d;
--       dcp_re                     <=  resp_needs_data and dec_cred; -- the data comes straight out but the response has a latch in the way
    end if;
end process infer;

     dcp_re                       <=  resp_needs_data and resp_has_data;

     tlx_afu_resp_opcode <= tlx_afu_resp_opcode_a;


    parsing_ctl_d <=  OR_REDUCE(parse_st);

    start_ctl <= (not parsing_ctl_d or finished_ctl ) and dl_valid and not dl_dout(512);

-- throw out flits with empty slot zero before they go into the fifo. if the fifo is empty for a few clocks then I could put one in if it locks up at the end

    ee_0  <= (not OR_REDUCE(cflit(119 downto 112)) and  parse_st(0)) or
             parse_st(1);
    ee_1  <= (not OR_REDUCE(cflit(119 downto 112)) and  parse_st(0)  ) or
             (not OR_REDUCE(cflit(231 downto 224)) and  parse_st(1)  ) or
             (not OR_REDUCE(cflit(343 downto 336)) and  parse_st(2)  ) or
             parse_st(3);
    ee_5  <= (not OR_REDUCE(cflit(119 downto 112)) and  parse_st(0)  ) or
             (not OR_REDUCE(cflit(147 downto 140)) and  parse_st(1)  ) or
             (not OR_REDUCE(cflit(175 downto 168)) and  parse_st(2)  ) or
             (not OR_REDUCE(cflit(203 downto 196)) and  parse_st(3)  ) or
             (not OR_REDUCE(cflit(231 downto 224)) and  parse_st(4)  ) or
             (not OR_REDUCE(cflit(259 downto 252)) and  parse_st(5)  ) or
             (not OR_REDUCE(cflit(287 downto 280)) and  parse_st(6)  ) or
             (not OR_REDUCE(cflit(315 downto 308)) and  parse_st(7)  ) or
             (not OR_REDUCE(cflit(343 downto 336)) and  parse_st(8)  ) or
             parse_st(9);
    ee_9  <= (not OR_REDUCE(cflit(343 downto 336)) and  parse_st(0)  ) or
             (not OR_REDUCE(cflit(371 downto 364)) and  parse_st(1)  ) or
             (not OR_REDUCE(cflit(399 downto 392)) and  parse_st(2)  ) or
             (not OR_REDUCE(cflit(427 downto 420)) and  parse_st(3)  ) or
             parse_st(4);
    ee_B  <= (not OR_REDUCE(cflit(399 downto 392)) and  parse_st(0)  ) or
             (not OR_REDUCE(cflit(427 downto 420)) and  parse_st(1)  ) or
             parse_st(2);

    finished_ctl  <= (ee_0 and not cflit(465) and not cflit(464) and not cflit(463) and not cflit(462) and not cflit(461) and not cflit(460) ) or  -- t0
                     (ee_1 and not cflit(465) and not cflit(464) and not cflit(463) and not cflit(462) and not cflit(461) and     cflit(460) ) or  -- t1
                     (ee_5 and not cflit(465) and not cflit(464) and not cflit(463) and     cflit(462) and not cflit(461) and     cflit(460) ) or  -- t5
                     (ee_9 and not cflit(465) and not cflit(464) and     cflit(463) and not cflit(462) and not cflit(461) and     cflit(460) ) or  -- t9
                     (ee_B and not cflit(465) and not cflit(464) and     cflit(463) and not cflit(462) and     cflit(461) and     cflit(460) );    -- tB

    dl_read <=  not reset and dl_valid and (start_ctl or dcp_we);


    sd_0 <= x"00000000000000" & GATE(cflit(55 downto 0),parse_st(0)) or
                                GATE(cflit(223 downto 112),parse_st(1));
    sd_1 <= GATE(cflit(111 downto   0),parse_st(0)) or                  -- 4
            GATE(cflit(223 downto 112),parse_st(1)) or
            GATE(cflit(335 downto 224),parse_st(2)) or
            GATE(cflit(447 downto 336),parse_st(3));
    sd_5 <= GATE(cflit( 55 downto   0),parse_st(0)) or                  -- 2
            x"0000000" & GATE(cflit(139 downto 112),parse_st(1)) or
            x"0000000" & GATE(cflit(167 downto 140),parse_st(2)) or
            x"0000000" & GATE(cflit(195 downto 168),parse_st(3)) or
            x"0000000" & GATE(cflit(223 downto 196),parse_st(4)) or
            x"0000000" & GATE(cflit(251 downto 224),parse_st(5)) or
            x"0000000" & GATE(cflit(279 downto 252),parse_st(6)) or
            x"0000000" & GATE(cflit(307 downto 280),parse_st(7)) or
            x"0000000" & GATE(cflit(335 downto 308),parse_st(8)) or
            GATE(cflit(391 downto 336),parse_st(9));                   -- 4 slot packet but if it's intrp_req we don't use
    sd_9 <=              GATE(cflit(335 downto 280),parse_st(0)) or     -- 2
            x"0000000" & GATE(cflit(363 downto 336),parse_st(1)) or
            x"0000000" & GATE(cflit(391 downto 364),parse_st(2)) or
            x"0000000" & GATE(cflit(419 downto 392),parse_st(3)) or
            x"0000000" & GATE(cflit(447 downto 420),parse_st(4));
    sd_B <=              GATE(cflit(391 downto 336),parse_st(0)) or     -- 2
            x"0000000" & GATE(cflit(419 downto 392),parse_st(1)) or
            x"0000000" & GATE(cflit(447 downto 420),parse_st(2));

    resp_in_d(55  downto  0)  <= GATE(sd_0(55  downto  0),cflit(465 downto 460) = "000000") or
                                 GATE(sd_1(55  downto  0),cflit(465 downto 460) = "000001") or
                                 GATE(sd_5(55  downto  0),cflit(465 downto 460) = "000101") or
                                 GATE(sd_9(55  downto  0),cflit(465 downto 460) = "001001") or
                                 GATE(sd_B(55  downto  0),cflit(465 downto 460) = "001011");

--                                 credit      slots   opcode    data required                 comments
--             assign_ac_tag          vc3         2      50          0                    not supported in Apollo
--             intrp_req              vc3         4      58          0                    not supported in Apollo like other commands
--             mem_rd_fail            vc0         2      02          0                    put into vc0 fifo . data requirement  0
--             mem_rd_resp          vc0/dcp0      1      01       64 or =< 32             always 1 carrier
--             mem_rd_resp.ow       vc0/dcp0      1      03          32                   always 1 carrier
--             mem_wr_fail            vc0         2      05          0
--             mem_wr_resp            vc0         1      04          0
--             memctl_done            vc0         1      0B          0
--             nop                     -          1      00          0
--             return_tl_credits       -          2      08          0

  ---- write side of the response fifo (need a fifo because we stall until data is available) ----

   resp_we <= parsing_ctl_q and (resp_in_q(2) or resp_in_q(1) or resp_in_q(0));     -- exclude nop, cred return assign actag and intrp_req

   vc3_return <=  parsing_ctl_q and resp_in_q(4); -- vc3 things assign_actag or intrp_req

--  REG_XX_RESET: reset value of the register, default 0.
--  REG_XX_WE_MASK: mask to indicate which bits are writeable over AXI, default all 1.
--  REG_XX_HWWE_MASK: mask to indicate which bits are writeable from HW, default 0.
--  REG_XX_STICKY_MASK: mask to indicate that the hw updatable bits are sticky (when set to 1, they can only be cleared via an AXI write), default 1.
--  reg_XX_o: Current register value
--  reg_XX_update_i: Value to update the register to from HW, takes into account REG_XX_HWWE_MASK before being written to register
--  reg_XX_hwwe_i: When 1, reg_XX_update_i AND REG_XX_HWWE_MASK is written to the register
-- xx is some number

   reg_01_hwwe_i    <= parsing_ctl_q and not OR_REDUCE(resp_in_q(7 downto 0) xor x"58") and OR_REDUCE(not reg_01_o(2) & not reg_01_o(1) & not reg_01_o(0));

   reg_01_update_i  <= GATE(                           resp_in_q(11 downto 8) & x"000000" &  "0001",reg_01_o(2 downto 0) = "000") or  -- send command flag rather than afutag as we have that latched and it is programmable
                       GATE( reg_01_o(31 downto 28) &  resp_in_q(11 downto 8) & x"00000"  &  "0010",reg_01_o(2 downto 0) = "001") or
                       GATE( reg_01_o(31 downto 24) &  resp_in_q(11 downto 8) & x"0000"   &  "0011",reg_01_o(2 downto 0) = "010") or
                       GATE( reg_01_o(31 downto 20) &  resp_in_q(11 downto 8) & x"000"    &  "0100",reg_01_o(2 downto 0) = "011") or
                       GATE( reg_01_o(31 downto 16) &  resp_in_q(11 downto 8) & x"00"     &  "0101",reg_01_o(2 downto 0) = "100") or
                       GATE( reg_01_o(31 downto 12) &  resp_in_q(11 downto 8) & x"0"      &  "0110",reg_01_o(2 downto 0) = "101") or
                       GATE( reg_01_o(31 downto  8) &  resp_in_q(11 downto 8) &              "0111",reg_01_o(2 downto 0) = "110");

--  0x1 => channel checkstop
--  0x2 => recoverable attention
--  0x3 => special attention
--  0x4 => application interrupt

   resp_wptr_d <= GATE(resp_wptr_q           ,not resp_we and reset_n) or
                  GATE(resp_wptr_q +"0000001",    resp_we and reset_n) ;
  -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  -- read side of response fifo - basically if data_wtg > 0 or output valid and no data needed then we unstack one. we can assert output not valid and data_wtg>0 never happens
  -- The resp fifo is in two parts, a big bram part and a smaller latch based one that enables streaming rstrm_fifo
  -------------------------------------------------------------------------------------------------------

 --  resp_needs_data <= resp_out(0) and not resp_out(3);       -- ie opcodes 1 or 3 but not B
   resp_needs_data <= '1' when resp_out(3 downto 0) = x"1" or resp_out(3 downto 0) = x"3"
                      else '0';

   resp_has_data   <= not dcp_empty;

   tlx_afu_resp_valid_a <= not resp_empty and (not resp_needs_data or resp_has_data) and not no_credit;

   tlx_afu_resp_valid     <= tlx_afu_resp_valid_a;

   dec_cred <= tlx_afu_resp_valid_a and OR_REDUCE(credits_q & afu_tlx_resp_credit);

   credits_d <= GATE(afu_tlx_resp_initial_credit , reset) or
                GATE(credits_q + "0000001", afu_tlx_resp_credit and not dec_cred and not reset) or
                GATE(credits_q - "0000001", not afu_tlx_resp_credit and dec_cred and not reset) or
                GATE(credits_q, not ((afu_tlx_resp_credit xor dec_cred) or reset) );   -- this is real one

   no_credit <= not OR_REDUCE(credits_q);

   ---- write side of the dcp fifo ----

   dcp_we <= ( dl_valid and dl_dout(512) ) or       -- and data flit
             tpl_9B_data_strobe;

   tpl_9B_data_strobe <= start_ctl and dl_dout(463) and (  (dl_dout(461) and dl_dout(329)) or (not dl_dout(461) and dl_dout(264)));   -- tb or t9 + valid

   dcp_wptr_d <= "000000" when reset = '1'               else
                 dcp_wptr_q + "000001" when dcp_we = '1' else
                 dcp_wptr_q;

   dcp_in(511 downto 0)  <= dl_dout(511 downto 0);

   dcp_in(512) <= not tpl_9B_data_strobe;   -- tells us if it was a data flit (1) or a template 9/B (0)

  ---- read side of the dcp fifo ----

                  ---- various counters ----

  -- count how much data has been delivered for responses that have not been shown to axi yet ( - ie waiting)-
  -- can improve timing by latching decrement and waiting for no-collision opportunity if needed

  thirty_two_carrier <= '1' when (  cflit(465 downto 460) & cflit(264)  = "0010011" or     -- can't collide with 64B carrier update
                                    cflit(465 downto 460) & cflit(329)  = "0010111"  ) and parse_st(0) = '1' else
                                     '0';


-- when we put the command into the command fifo we push the data requirement into the data required fifo too
-- we count data flits between control flits .... and
--      if we see a good t9 or tb with data we add 32 bytes to that count
-- we then send commands out of the command fifo decrementing the count by that command's usage and ensuring that we don't wrap down through zero
--
-- if we get a backup/error we have to revert
--

 resp_fifo: entity work.aram_fifo_64x56       -- 64 deep 56 wide
  port map (
    clock           => tlx_clk,
    reset           => reset,
    data_in         => resp_in_q,
    write           => resp_we,
    read            => dec_cred,
    data_out        => resp_out,
    empty           => resp_empty,
    full            => open,
    overflow        => resp_overf,
    underflow       => resp_underf
  );

    tlx_afu_resp_opcode_a        <=  resp_out(7 downto 0);
    tlx_afu_resp_captag          <=  resp_out(23 downto 8);
    tlx_afu_resp_dl              <=  resp_out(27 downto 26);
    tlx_afu_resp_dp              <=  resp_out(26 downto 24);
    tlx_afu_resp_code            <=  GATE(resp_out(27 downto 24),resp_out(3)) or -- memctl_done
                                     GATE(resp_out(55 downto 52),not resp_out(3));

 dcp0_fifo: entity work.aram_fifo_64x513       -- 64 deep 513 wide. top bit is +64 / -32 carrier
  port map (
    clock           => tlx_clk,
    reset           => reset,
    data_in         => dcp_in,
    write           => dcp_we,
    read            => dcp_re,
    data_out        => dcp_out,
    empty           => dcp_empty,
    full            => open,
    overflow        => dcp_overf,
    underflow       => dcp_underf
  );

    tlx_afu_resp_data_bus(255 downto 0) <= dcp_out(255 downto 0);
    tlx_afu_resp_data_bus(511 downto 256) <=  GATE(dcp_out(255 downto 0)  ,not dcp_out(512)) or -- t9 or tB
                                              GATE(dcp_out(511 downto 256),    dcp_out(512)) ;  -- data flit

    tlx_afu_resp_data_xmeta <=  GATE(dcp_out(319 downto 256), not dcp_out(512));                -- tB or data flit (T9 don't care)

--   credit start timers plus return_tl_credit (08) (which has to go thru fifo for upstream)

     rcv_xmt_tl_credit_vc0_valid      <= not OR_REDUCE(reset & init_cnt(8 downto 5)) or tlx_afu_resp_valid_a;   -- responses including mem_cntl_done
     rcv_xmt_tl_credit_vc1_valid      <= not OR_REDUCE(reset & init_cnt(8 downto 3)) or vc3_return;             -- intrp_req or assign_actag

     rcv_xmt_tl_credit_dcp0_valid     <= not OR_REDUCE(reset & init_cnt(8 downto 6)) or dcp_re; -- initial or ongoing
     rcv_xmt_tl_credit_dcp1_valid     <= not OR_REDUCE(reset & init_cnt(8 downto 3));

ret_tlc : process(tlx_clk)                   -- in upstream direction credit return can be slots other than 0 and 1
   begin
    if tlx_clk 'event and tlx_clk = '1' then
       if resp_in_q(7 downto 0) = x"08" and parsing_ctl_q = '1' then
          rcv_xmt_tlx_credit_valid  <= '1';
       else
          rcv_xmt_tlx_credit_valid  <= '0';
       end if;
       rcv_xmt_tlx_credit_vc0    <= resp_in_q(11 downto 8);
       rcv_xmt_tlx_credit_vc3    <= resp_in_q(15 downto 12);
       rcv_xmt_tlx_credit_dcp0   <= resp_in_q(37 downto 32);
       rcv_xmt_tlx_credit_dcp3   <= resp_in_q(43 downto 38);
    end if;
end process ret_tlc;

-- now the bidi bits.At each good control flit we push 3 bits of previous run length (1-8) plus eight bits of bdi into fifo1 (8 deep).
-- We keep trying try to fill BDI_F2(8deep 1 wide) from fifo1 - reading an appropriate number of bits from each fifo1 entry before bumping.
-- we then use fifo2 output to deliver bdi bit in parallel with the data - incrementing the read pointer at the same time as data read pointer
--
                                                                     -- probably need to go parse_st(0) rather than start_ctl
    bdi_count_d(2 downto 0) <= GATE(one_less(cflit(451 downto 448)),start_ctl) or
                               GATE(bdi_count_q , not start_ctl and not reset);

    bdi_count_nz_d   <= (   ( (    cflit(451) and not or_reduce(cflit(450 downto 448)) )                -- run length >0 and < 9
                                                   or
                              (  not cflit(451) and     or_reduce(cflit(450 downto 448)))
                            )
                             and start_ctl
                        )
                                         or
                         (bdi_count_nz_q and not start_ctl and not reset);


    bdi_32B_carrier <= ( parse_st(2) and  cflit(463) and  not cflit(461) and cflit(264) and cflit(263) )   or   -- template 9 and data valid
                       ( parse_st(2) and  cflit(463) and      cflit(461) and cflit(329) and cflit(328));        -- template B and data valid

    bdi_f1_din <= GATE(bdi_count_q & cflit(459 downto 452), parse_st(0)) or                                -- write f1
                  GATE("000" & "0000000" & bdi_32B_carrier,parse_st(2));

    bdi_f1_write <=  (bdi_count_nz_q and parse_st(0)) or
                     ( parse_st(2) and  cflit(463) and  not cflit(461) and cflit(264)) or   --T9 with data
                     ( parse_st(2) and  cflit(463) and      cflit(461) and cflit(329));     --TB with data

    mux_f1_bit_d <= "000"                 when bdi_f1_write = '1' else
                     mux_f1_bit_q + "001" when bdi_f2_write = '1' else
                     mux_f1_bit_q;

    bdi_f1_read <= bdi_f2_write and not OR_REDUCE(mux_f1_bit_q xor bdi_f1_dout(10 downto 8));

    bdi_f2_din  <= (bdi_f1_dout(0) and not mux_f1_bit_q(2) and not mux_f1_bit_q(1) and not mux_f1_bit_q(0)) or
                   (bdi_f1_dout(1) and not mux_f1_bit_q(2) and not mux_f1_bit_q(1) and     mux_f1_bit_q(0)) or
                   (bdi_f1_dout(2) and not mux_f1_bit_q(2) and     mux_f1_bit_q(1) and not mux_f1_bit_q(0)) or
                   (bdi_f1_dout(3) and not mux_f1_bit_q(2) and     mux_f1_bit_q(1) and     mux_f1_bit_q(0)) or
                   (bdi_f1_dout(4) and     mux_f1_bit_q(2) and not mux_f1_bit_q(1) and not mux_f1_bit_q(0)) or
                   (bdi_f1_dout(5) and     mux_f1_bit_q(2) and not mux_f1_bit_q(1) and     mux_f1_bit_q(0)) or
                   (bdi_f1_dout(6) and     mux_f1_bit_q(2) and     mux_f1_bit_q(1) and not mux_f1_bit_q(0)) or
                   (bdi_f1_dout(7) and     mux_f1_bit_q(2) and     mux_f1_bit_q(1) and     mux_f1_bit_q(0));

    bdi_f2_write <= not bdi_f1_empty and not bdi_f2_full;

 BIDI_F1: entity work.tlx_fifo
   generic map (
      width    => 11,
      depth    => 8
   )
   port map (
     clock       =>  tlx_clk,                                             -- in std_ulogic;       no backup needed on this one we only write it when there's a good ctl flit
     reset       =>  reset,                                               -- in std_ulogic;        -- synchronous. clears control bits not the array (maybe xilinx does that anyway ? (don't care really))
     data_in     =>  bdi_f1_din,                                          -- in std_ulogic_vector(width-1 downto 0);
     write       =>  bdi_f1_write,                                        -- in std_ulogic;
     read        =>  bdi_f1_read,                                         -- in std_ulogic;        -- reads next (output is valid in same cycle as read)
     data_out    =>  bdi_f1_dout,                                         -- out std_ulogic_vector(width-1 downto 0);
     empty       =>  bdi_f1_empty,                                        -- out std_ulogic;
     full        =>  open,                                                -- out std_ulogic;
     overflow    =>  bdi_f1_overf,                                        -- out std_ulogic;
     underflow   =>  bdi_f1_underf                                        -- out std_ulogic
   );

 BIDI_F2: entity work.tl_skinny_fifo
   generic map (
      depth    => 64                                                      -- has to be the same as dcp fifo. no backup needed on this one we only write it when there's a good ctl flit
   )
   port map (
     clock       =>  tlx_clk,                                             -- in std_ulogic;
     reset       =>  reset,                                               -- in std_ulogic;        -- synchronous. clears control bits not the array (maybe xilinx does that anyway ? (don't care really))
     data_in     =>  bdi_f2_din,                                          -- in std_ulogic_vector(width-1 downto 0);
     write       =>  bdi_f2_write,                                        -- in std_ulogic;
     read        =>  dcp_re,                                              -- in std_ulogic;        -- reads next (output is valid in same cycle as read)
     data_out    =>  tlx_afu_resp_data_bdi,                               -- out std_ulogic_vector(width-1 downto 0);
     empty       =>  bdi_f2_empty,                                        -- out std_ulogic;
     overflow    =>  bdi_f2_overf,                                        -- out std_ulogic;
     underflow   =>  bdi_f2_underf,                                       -- out std_ulogic
     full        =>  bdi_f2_full
   );

end ocx_tl_rcv ;

