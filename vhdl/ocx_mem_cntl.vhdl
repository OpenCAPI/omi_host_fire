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

entity ocx_mem_cntl is
    PORT (
      CLOCK                      : in  std_ulogic;
      RESET_N                    : in  std_ulogic;
   -- interface to axi_regs_32.vhdl oc_host_cfg.vhdl (fire_core.oc_host_cfg0)
      REG_02_UPDATE_I            : out std_ulogic_vector(31 downto 0);
      REG_02_HWWE_I              : out std_ulogic;
      REG_02_O                   : in  std_ulogic_vector(31 downto 0);
   -- interface to ocx_tl_top
      TLX_AFU_RESP_VALID         : in  std_ulogic;
      TLX_AFU_RESP_OPCODE        : in  std_ulogic_vector(7 downto 0);
      TLX_AFU_RESP_AFUTAG        : in  std_ulogic_vector(15 downto 0);
      TLX_AFU_RESP_CODE          : in  std_ulogic_vector(3 downto 0);
   -- credit from ocx_tl_top
      RCV_XMT_TLX_CREDIT_VALID   : in  std_ulogic;
      RCV_XMT_TLX_CREDIT_VC0     : in  std_ulogic_vector(3 downto 0);
   -- interface to ocx_tlx_axi.v
      MEMCNTL_OC_CMD_READY       : out std_ulogic;
      MEMCNTL_OC_CMD_FLAG        : out std_ulogic_vector(3 downto 0);
      MEMCNTL_OC_CMD_TAG         : out std_ulogic_vector(15 downto 0);
      OC_MEMCNTL_TAKEN           : in  std_ulogic
    );
    end ocx_mem_cntl;

architecture ocx_mem_cntl of ocx_mem_cntl is

   signal state_d,state_q                                : std_ulogic_vector(7 downto 0);
   signal taken,badresp,tag_match,goodresp               : std_ulogic_vector(3 downto 0);
   signal update_d,update_q                              : std_ulogic;
   signal memcntl_oc_cmd_flag_d                          : std_ulogic_vector(3 downto 0);
   signal memcntl_oc_cmd_ready_d,memcntl_oc_cmd_ready_q  : std_ulogic;
   signal unknown_resp_d,unknown_resp_q                  : std_ulogic;
   signal tag_count_d,tag_count_q                        : std_ulogic_vector(7 downto 0);
   type e_type is array(3 downto 0) of std_ulogic_vector(7 downto 0);
   signal exp_tag_d,exp_tag_q                            : e_type;
   signal tlvc0_credit_d,tlvc0_credit_q                  : std_ulogic_vector(3 downto 0);

   constant TOP_FOUR_TAG_BITS                            : std_ulogic_vector(3 downto 0) := "1010";

    begin
--         read             write
-- mmio     D                C
-- memory   9                8
-- config   F                E
-- fbist      0-7
-- we use tag AXXX

G1: for i in 0 to 3 GENERATE                     -- two bits of state for four mem_cntls 3 downto 0
   begin
      state_d(i*2+1 downto i*2) <= GATE("01", reg_02_o(i) = '1' and not (reg_02_o(20) = '1' or RESET_N = '0')) or
                                   GATE("10", taken(i)    = '1' and not (reg_02_o(20) = '1' or RESET_N = '0')) or
                                   GATE("11", badresp(i)    = '1' and not (reg_02_o(20) = '1' or RESET_N = '0')) or
                                   GATE(state_q(i*2+1 downto i*2), taken(i) = '0' and reg_02_o(i) = '0' and badresp(i) = '0' and goodresp(i) = '0' and not (reg_02_o(20) = '1' or RESET_N = '0'));

      tag_match(i) <=  '1' when exp_tag_q(i)  =  tlx_afu_resp_afutag(7 downto 0) and tlx_afu_resp_afutag(15 downto 8) = (TOP_FOUR_TAG_BITS & "0000") else '0';
      badresp(i)   <= '1' when tag_match(i) = '1' and tlx_afu_resp_valid = '1' and tlx_afu_resp_code /= "0000" and  tlx_afu_resp_opcode = x"0B" else '0';
      goodresp(i)  <= '1' when tag_match(i) = '1' and tlx_afu_resp_valid = '1' and tlx_afu_resp_code  = "0000" and  tlx_afu_resp_opcode = x"0B" else '0';
      exp_tag_d(i) <=  tag_count_q when taken(i) = '1' else exp_tag_q(i);

   end generate;

   unknown_resp_d <= '1' when  (unknown_resp_q = '1' and reg_02_o(20) = '0' and RESET_N = '1') or
                               (tlx_afu_resp_valid = '1' and  tlx_afu_resp_opcode = x"0B" and tag_match = "0000")
                       else '0';

   taken(3) <= oc_memcntl_taken when state_q(7 downto 6) = "01" and  state_q(5 downto 4) /= "01" else '0';
   taken(2) <= oc_memcntl_taken when state_q(5 downto 4) = "01" and  state_q(3 downto 2) /= "01" else '0';
   taken(1) <= oc_memcntl_taken when state_q(3 downto 2) = "01" and  state_q(1 downto 0) /= "01" else '0';
   taken(0) <= oc_memcntl_taken when state_q(1 downto 0) = "01" else '0';                                      -- inline because this one makes it messy in the generate


-- update the register when we need to clear any reset or start bit, or if any state is stale

   reg_02_hwwe_i    <= reg_02_o(20) or reg_02_o(3) or reg_02_o(2) or reg_02_o(1) or reg_02_o(0) or update_q;
   reg_02_update_i  <= state_q(7 downto 0) & unknown_resp_q & "000" & x"00000";
   update_d <= '1' when reg_02_o(31 downto 24) /= state_q(7 downto 0) else '0';

-- pick highest priority active mem_ctl and offer to ocx_tlx_axi

   memcntl_oc_cmd_ready_d <= '1' when ( (tlvc0_credit_q /= "0000") and
                                        ( state_d(7 downto 6) = "01" or  state_d(5 downto 4) = "01" or
                                          state_d(3 downto 2) = "01" or  state_d(1 downto 0) = "01"
                                        )
                                      ) else '0';

    memcntl_oc_cmd_flag_d  <=   reg_02_o(7 downto 4)   when  state_d(1 downto 0) = "01" else
                                reg_02_o(11 downto 8)  when  state_d(3 downto 2) = "01" else
                                reg_02_o(15 downto 12) when  state_d(5 downto 4) = "01" else
                                reg_02_o(19 downto 16);

    memcntl_oc_cmd_tag     <= TOP_FOUR_TAG_BITS & x"0" & tag_count_q;

    tag_count_d <= GATE(tag_count_q + "00000001", oc_memcntl_taken = '1' and not (reg_02_o(20) = '1' or RESET_N = '0')) or
                   GATE(tag_count_q            , oc_memcntl_taken = '0' and not (reg_02_o(20) = '1' or RESET_N = '0'));


    tlvc0_credit_d <=  "0000" when RESET_N = '0' else
                                   tlvc0_credit_q + RCV_XMT_TLX_CREDIT_VC0 when RCV_XMT_TLX_CREDIT_VALID = '1' and  OC_MEMCNTL_TAKEN = '0' else
                                   tlvc0_credit_q - "0001"                 when RCV_XMT_TLX_CREDIT_VALID = '0' and  OC_MEMCNTL_TAKEN = '1' else
                                   tlvc0_credit_q;

    MEMCNTL_OC_CMD_READY <= memcntl_oc_cmd_ready_q;

latches : process(clock)
   begin
   if clock 'event and clock = '1' then
      memcntl_oc_cmd_flag     <= memcntl_oc_cmd_flag_d;
      memcntl_oc_cmd_ready_q  <= memcntl_oc_cmd_ready_d;
      tag_count_q             <= tag_count_d;
      unknown_resp_q          <= unknown_resp_d;
      state_q                 <= state_d;
      update_q                <= update_d;
      exp_tag_q               <= exp_tag_d;
      tlvc0_credit_q          <= tlvc0_credit_d;
   end if;
end process;

end architecture ocx_mem_cntl;
