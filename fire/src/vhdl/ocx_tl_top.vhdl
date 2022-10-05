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

library ieee,ibm,support,work;
use ieee.std_logic_1164.all;
use ibm.synthesis_support.all;
use support.logic_support_pkg.all;
use work.axi_pkg.all;
use work.apollo_tlx_pkg.all;

entity ocx_tl_top is
    PORT (
        -- -----------------------------------
        -- TLX Parser to AFU Receive Interface
        -- -----------------------------------
        -- --TLX Ready signal
        tlx_afu_ready                     : out std_ulogic;                      -- sinkless in fire_core.vhdl

        -- Command interface to AFU   (not used in apollo)
        afu_tlx_cmd_initial_credit        : in  std_ulogic_vector(6 downto 0);   -- tied "0000000" in fire_core.vhdl
        afu_tlx_cmd_credit                : in  std_ulogic;                      -- tied '0' in fire_core.vhdl
        tlx_afu_cmd_valid                 : out std_ulogic;                      -- sinkless in fire_core.vhdl
        tlx_afu_cmd_opcode                : out std_ulogic_vector(7 downto 0);
        tlx_afu_cmd_dl                    : out std_ulogic_vector(1 downto 0);
        tlx_afu_cmd_end                   : out std_ulogic;
        tlx_afu_cmd_pa                    : out std_ulogic_vector(63 downto 0);
        tlx_afu_cmd_flag                  : out std_ulogic_vector(3 downto 0);
        tlx_afu_cmd_os                    : out std_ulogic;
        tlx_afu_cmd_capptag               : out std_ulogic_vector(15 downto 0);
        tlx_afu_cmd_pl                    : out std_ulogic_vector(2 downto 0);
        tlx_afu_cmd_be                    : out std_ulogic_vector(63 downto 0);

        -- Config Command interface to AFU  (not used in apollo)
        cfg_tlx_initial_credit            : in  std_ulogic_vector(3 downto 0);   -- tied "00000" in fire_core.vhdl
        cfg_tlx_credit_return             : in  std_ulogic;                      -- tied '0' in fire_core.vhdl
        tlx_cfg_valid                     : out std_ulogic;                      -- sinkless in fire_core.vhdl
        tlx_cfg_opcode                    : out std_ulogic_vector(7 downto 0);
        tlx_cfg_pa                        : out std_ulogic_vector(63 downto 0);
        tlx_cfg_t                         : out std_ulogic;
        tlx_cfg_pl                        : out std_ulogic_vector(2 downto 0);
        tlx_cfg_capptag                   : out std_ulogic_vector(15 downto 0);
        tlx_cfg_data_bus                  : out std_ulogic_vector(31 downto 0);
        tlx_cfg_data_bdi                  : out std_ulogic;

        -- Response interface to AFU
        afu_tlx_resp_initial_credit       :  in  std_ulogic_vector(6 downto 0);    -- from ocx_tlx_axi_top.v
        afu_tlx_resp_credit               :  in  std_ulogic;                       -- from ocx_tlx_axi_top.v
        tlx_afu_resp_valid                :  out std_ulogic;                       -- into ocx_tlx_axi.v
        tlx_afu_resp_opcode               :  out std_ulogic_vector(7 downto 0);
        tlx_afu_resp_afutag               :  out std_ulogic_vector(15 downto 0);   -- tlx_host_capptag
        tlx_afu_resp_code                 :  out std_ulogic_vector(3 downto 0);
        tlx_afu_resp_pg_size              :  out std_ulogic_vector(5 downto 0);    -- not used in apollo
        tlx_afu_resp_dl                   :  out std_ulogic_vector(1 downto 0);
        tlx_afu_resp_dp                   :  out std_ulogic_vector(2 downto 0);    -- !!! need an extra bit
        tlx_afu_resp_host_tag             :  out std_ulogic_vector(23 downto 0);   -- not used in apollo
        tlx_afu_resp_cache_state          :  out std_ulogic_vector(3 downto 0);    -- not used in apollo
        tlx_afu_resp_addr_tag             :  out std_ulogic_vector(17 downto 0);   -- not used in apollo

        -- Command data interface to AFU  (not used in apollo)
        afu_tlx_cmd_rd_req                : in  std_ulogic;                        -- tied zero in fire_core.vhdl
        afu_tlx_cmd_rd_cnt                : in  std_ulogic_vector(2 downto 0);
        tlx_afu_cmd_data_valid            : out std_ulogic;                        -- sinkless in fire_core.vhdl
        tlx_afu_cmd_data_bus              : out std_ulogic_vector(511 downto 0);
        tlx_afu_cmd_data_bdi              : out std_ulogic;

        -- Response data interface to AFU
        afu_tlx_resp_rd_req               : in  std_ulogic;                        -- output from ocx_tlx_axi.v   (currently mem_rd_response but that's for TLX not TL)
        afu_tlx_resp_rd_cnt               : in  std_ulogic_vector(2 downto 0);     -- when it sees tlx_afu_resp_valid the axi may request data for it
        tlx_afu_resp_data_valid           : out std_ulogic;                        -- in response to the data request we might get this.
        tlx_afu_resp_data_bus             : out std_ulogic_vector(511 downto 0);
        tlx_afu_resp_data_bdi             : out std_ulogic;
        tlx_afu_resp_data_xmeta           : out std_ulogic_vector(63 downto 0);

        -- -----------------------------------
        -- AFU to TLX Framer Transmit Interface
        -- -----------------------------------

        ------ Commands from AFU
        tlx_afu_cmd_initial_credit        : out std_ulogic_vector(3 downto 0);
        tlx_afu_cmd_credit                : out std_ulogic;
        afu_tlx_cmd_valid                 : in  std_ulogic;                        --  output from ocx_tlx_axi.v (into framer)
        afu_tlx_cmd_opcode                : in  std_ulogic_vector(7 downto 0);     --  normal vc1 type commands from host
        afu_tlx_cmd_pa_or_obj             : in  std_ulogic_vector(63 downto 0);
        afu_tlx_cmd_afutag                : in  std_ulogic_vector(15 downto 0);
        afu_tlx_cmd_dl                    : in  std_ulogic_vector(1 downto 0);
        afu_tlx_cmd_pl                    : in  std_ulogic_vector(2 downto 0);
        afu_tlx_cmd_be                    : in  std_ulogic_vector(63 downto 0);
        afu_tlx_cmd_flag                  : in  std_ulogic_vector(3 downto 0);
        afu_tlx_cmd_bdf                   : in  std_ulogic_vector(15 downto 0);
        afu_tlx_cmd_resp_code             : in  std_ulogic_vector(3 downto 0);
        afu_tlx_cmd_capptag               : in  std_ulogic_vector(15 downto 0);

        -- --- Command data from AFU
        tlx_afu_cmd_data_initial_credit   : out std_ulogic_vector(5 downto 0);
        tlx_afu_cmd_data_credit           : out std_ulogic;
        afu_tlx_cdata_valid               : in  std_ulogic;
        afu_tlx_cdata_bus                 : in  std_ulogic_vector(511 downto 0);
        afu_tlx_cdata_bdi                 : in  std_ulogic;

        -- --- Responses from AFU
        tlx_afu_resp_initial_credit       : out std_ulogic_vector(3 downto 0);
        tlx_afu_resp_credit               : out std_ulogic;
        afu_tlx_resp_valid                : in  std_ulogic;                        -- tied '0' in fire_core
        afu_tlx_resp_opcode               : in  std_ulogic_vector(7 downto 0);
        afu_tlx_resp_dl                   : in  std_ulogic_vector(1 downto 0);     -- no responses from host for apollo ?
        afu_tlx_resp_capptag              : in  std_ulogic_vector(15 downto 0);
        afu_tlx_resp_dp                   : in  std_ulogic_vector(1 downto 0);
        afu_tlx_resp_code                 : in  std_ulogic_vector(3 downto 0);

        -- --- Response data from AFU
        tlx_afu_resp_data_initial_credit  : out std_ulogic_vector(5 downto 0);
        tlx_afu_resp_data_credit          : out std_ulogic;
        afu_tlx_rdata_valid               : in  std_ulogic;
        afu_tlx_rdata_bus                 : in  std_ulogic_vector(511 downto 0);
        afu_tlx_rdata_bdi                 : in  std_ulogic;

        -- --- Config Responses from AFU
        cfg_tlx_resp_valid                : in  std_ulogic;
        cfg_tlx_resp_opcode               : in  std_ulogic_vector(7 downto 0);
        cfg_tlx_resp_capptag              : in  std_ulogic_vector(15 downto 0);
        cfg_tlx_resp_code                 : in  std_ulogic_vector(3 downto 0);
        tlx_cfg_resp_ack                  : out std_ulogic;

        -- --- Config Response data from AFU
        cfg_tlx_rdata_offset              : in  std_ulogic_vector(3 downto 0);
        cfg_tlx_rdata_bus                 : in  std_ulogic_vector(31 downto 0);
        cfg_tlx_rdata_bdi                 : in  std_ulogic;

        -- -----------------------------------
        -- DLX to TLX Parser Interface          in apollo tl not tlx
        -- -----------------------------------
        dlx_tlx_flit_valid                : in  std_ulogic;
        dlx_tlx_flit                      : in  std_ulogic_vector(511 downto 0);
        dlx_tlx_flit_crc_err              : in  std_ulogic;
        dlx_tlx_link_up                   : in  std_ulogic;                        -- replaces VALID when crc error


        -- -----------------------------------
        -- TLX Framer to DLX Interface
        -- -----------------------------------
        dlx_tlx_flit_credit               : in  std_ulogic;
        dlx_tlx_init_flit_depth           : in  std_ulogic_vector(2 downto 0);
        tlx_dlx_flit_valid                : out std_ulogic;                        -- muxed with c3s and sent to dl
        tlx_dlx_flit                      : out std_ulogic_vector(511 downto 0);
        tlx_dlx_debug_encode              : out std_ulogic_vector(3 downto 0);
        tlx_dlx_debug_info                : out std_ulogic_vector(31 downto 0);
        dlx_tlx_dlx_config_info           : in  std_ulogic_vector(31 downto 0);


        -- -----------------------------------
        -- Configuration Ports
        -- -----------------------------------
        cfg_tlx_xmit_tmpl_config_0        : in  std_ulogic;
        cfg_tlx_xmit_tmpl_config_1        : in  std_ulogic;
        cfg_tlx_xmit_tmpl_config_2        : in  std_ulogic;
        cfg_tlx_xmit_tmpl_config_3        : in  std_ulogic;
        cfg_tlx_xmit_rate_config_0        : in  std_ulogic_vector(3 downto 0);
        cfg_tlx_xmit_rate_config_1        : in  std_ulogic_vector(3 downto 0);
        cfg_tlx_xmit_rate_config_2        : in  std_ulogic_vector(3 downto 0);
        cfg_tlx_xmit_rate_config_3        : in  std_ulogic_vector(3 downto 0);

        tlx_cfg_in_rcv_tmpl_capability_0  : out std_ulogic;
        tlx_cfg_in_rcv_tmpl_capability_1  : out std_ulogic;
        tlx_cfg_in_rcv_tmpl_capability_2  : out std_ulogic;
        tlx_cfg_in_rcv_tmpl_capability_3  : out std_ulogic;
        tlx_cfg_in_rcv_rate_capability_0  : out std_ulogic_vector(3 downto 0);
        tlx_cfg_in_rcv_rate_capability_1  : out std_ulogic_vector(3 downto 0);
        tlx_cfg_in_rcv_rate_capability_2  : out std_ulogic_vector(3 downto 0);
        tlx_cfg_in_rcv_rate_capability_3  : out std_ulogic_vector(3 downto 0);

        tlx_cfg_oc3_tlx_version           : out std_ulogic_vector(31 downto 0);


        -- -----------------------------------
        -- Miscellaneous Ports
        -- -----------------------------------
        rcv_xmt_tlx_credit_valid          : out  std_ulogic;
        rcv_xmt_tlx_credit_vc0            : out  std_ulogic_vector(3 downto 0);
        reg_01_hwwe_i                     : out std_ulogic;
        reg_01_update_i                   : out std_ulogic_vector(31 downto 0);
        reg_01_o                          : in  std_ulogic_vector(31 downto 0);
        clock                             : in  std_ulogic;
        reset_n                           : in  std_ulogic

    ) ;
end ocx_tl_top;

architecture ocx_tl_top of ocx_tl_top is


-- ==============================================================================================================================
-- @@@  Wires and Variables (Regs)
-- ==============================================================================================================================


        -- -----------------------------------
        -- TLX Parser to TLX Framer Interface
        -- -----------------------------------
        signal    rcv_xmt_tl_credit_vc0_valid       :  std_ulogic;                         -- TL credit for VC0,  to send to TL
        signal    rcv_xmt_tl_credit_vc1_valid       :  std_ulogic;                         -- TL credit for VC1,  to send to TL
        signal    rcv_xmt_tl_credit_dcp0_valid      :  std_ulogic;                         -- TL credit for DCP0, to send to TL
        signal    rcv_xmt_tl_credit_dcp1_valid      :  std_ulogic;                         -- TL credit for DCP1, to send to TL
        signal    rcv_xmt_tl_crd_cfg_dcp1_valid     :  std_ulogic;                         -- TL credit for DCP1, to send to TL
                                                                                           --
        signal    rcv_xmt_tlx_credit_valid_int      :  std_ulogic;                         -- Indicates there are valid TLX credits to capture and use
        signal    rcv_xmt_tlx_credit_vc0_int        :  std_ulogic_vector(3 downto 0);     -- TLX credit for VC0,  to be used by TLX
        signal    rcv_xmt_tlx_credit_vc3            :  std_ulogic_vector(3 downto 0);     -- TLX credit for VC3,  to be used by TLX
        signal    rcv_xmt_tlx_credit_dcp0           :  std_ulogic_vector(5 downto 0);     -- TLX credit for DCP0, to be used by TLX
        signal    rcv_xmt_tlx_credit_dcp3           :  std_ulogic_vector(5 downto 0);     -- TLX credit for DCP3, to be used by TLX

        signal    rcv_xmt_debug_info                :  std_ulogic_vector(31 downto 0);
        signal    rcv_xmt_debug_fatal               :  std_ulogic;
        signal    rcv_xmt_debug_valid               :  std_ulogic;

        constant  OC3_TLX_VERSION                   : std_ulogic_vector(31 downto 0) := x"20190213";   -- YYYYMMDD Some clean up for tvc compile warnings.   No functional change.

-- ==============================================================================================================================
-- @@@  Ties and Hard-coded  Assignments
-- ==============================================================================================================================

    begin

    tlx_cfg_oc3_tlx_version(31 downto 0) <= OC3_TLX_VERSION ;
    tlx_afu_ready <= dlx_tlx_link_up;
    rcv_xmt_tl_crd_cfg_dcp1_valid  <= '0'; -- required for correct dcp1 count in framer

    tlx_cfg_in_rcv_tmpl_capability_0  <= '1'; -- template 0
    tlx_cfg_in_rcv_tmpl_capability_1  <= '1'; -- template 1
    tlx_cfg_in_rcv_tmpl_capability_2  <= '1'; -- template 4
    tlx_cfg_in_rcv_tmpl_capability_3  <= '0'; -- template 3
    tlx_cfg_in_rcv_rate_capability_0  <= (others => '0'); -- ignored by fbist anyway
    tlx_cfg_in_rcv_rate_capability_1  <= (others => '0'); -- ignored by fbist anyway
    tlx_cfg_in_rcv_rate_capability_2  <= (others => '0'); -- ignored by fbist anyway
    tlx_cfg_in_rcv_rate_capability_3  <= (others => '0'); -- ignored by fbist anyway
    rcv_xmt_debug_fatal         <=  '0';
    rcv_xmt_debug_info          <=  (others => '0');
    rcv_xmt_debug_valid         <=  '0';
    tlx_afu_cmd_be              <=  (others => '0');
    tlx_afu_cmd_capptag         <=  (others => '0');
    tlx_afu_cmd_data_bdi        <=  '0';
    tlx_afu_cmd_data_bus        <=  (others => '0');
    tlx_afu_cmd_data_valid      <=  '0';
    tlx_afu_cmd_dl              <=  (others => '0');
    tlx_afu_cmd_end             <=  '0';
    tlx_afu_cmd_flag            <=  (others => '0');
    tlx_afu_cmd_opcode          <=  (others => '0');
    tlx_afu_cmd_os              <=  '0';
    tlx_afu_cmd_pa              <=  (others => '0');
    tlx_afu_cmd_pl              <=  (others => '0');
    tlx_afu_cmd_valid           <=  '0';
    tlx_afu_resp_addr_tag       <=  (others => '0');
    tlx_afu_resp_cache_state    <=  (others => '0');
    tlx_afu_resp_host_tag       <=  (others => '0');
    tlx_afu_resp_pg_size        <=  (others => '0');
    tlx_cfg_capptag             <=  (others => '0');
    tlx_cfg_data_bdi            <=  '0';
    tlx_cfg_data_bus            <=  (others => '0');
    tlx_cfg_opcode              <=  (others => '0');
    tlx_cfg_pa                  <=  (others => '0');
    tlx_cfg_pl                  <=  (others => '0');
    tlx_cfg_t                   <=  '0';
    tlx_cfg_valid               <=  '0';
    rcv_xmt_tlx_credit_valid    <=  rcv_xmt_tlx_credit_valid_int;
    rcv_xmt_tlx_credit_vc0      <=  rcv_xmt_tlx_credit_vc0_int;
-- ==============================================================================================================================
-- @@@  Instances of Sub Modules
-- ==============================================================================================================================

    -- ----------
    -- TL  Parser
    -- ----------
    ocx_tl_rcv_top: entity work.ocx_tl_rcv
      port map (
           tlx_clk                        =>  clock,                                                                  -- in std_ulogic;
           reset_n                        =>  reset_n,                                                                -- in std_ulogic;
           dlx_tlx_link_up                =>  dlx_tlx_link_up,                                                        -- in std_ulogic;
           dlx_tlx_flit_valid             =>  dlx_tlx_flit_valid,                                                     -- in std_ulogic;
           dlx_tlx_flit_crc_err           =>  dlx_tlx_flit_crc_err,                                                   -- in std_ulogic;
           dlx_tlx_flit                   =>  dlx_tlx_flit,                                                           -- in std_ulogic_vector(511 downto 0);
                                                                                                                      --
           afu_tlx_resp_rd_req            =>  afu_tlx_resp_rd_req,                                                    -- in std_ulogic;                         -- input that asks for response read data
           afu_tlx_resp_rd_cnt            =>  afu_tlx_resp_rd_cnt,                                                    -- in std_ulogic_vector(2 downto 0);      -- beats of response read data to provide (always 1 for apollo)
           tlx_afu_resp_data_valid        =>  tlx_afu_resp_data_valid,                                                -- out std_ulogic;                        --  in response to above req
           tlx_afu_resp_data_bus          =>  tlx_afu_resp_data_bus,                                                  -- out std_ulogic_vector(511 downto 0);   --
           tlx_afu_resp_data_bdi          =>  tlx_afu_resp_data_bdi,                                                  -- out std_ulogic;                        --
           tlx_afu_resp_data_xmeta        =>  tlx_afu_resp_data_xmeta,                                                --

           afu_tlx_resp_credit            =>  afu_tlx_resp_credit,                                                    -- in std_ulogic;                         -- this is response credit TLX.VC0 returned by the axi
           afu_tlx_resp_initial_credit    =>  afu_tlx_resp_initial_credit,                                            -- in std_ulogic_vector(6 downto 0);      -- TLX.vc.0 initial value currently 1
                                                                                                                      --
           tlx_afu_resp_valid             =>  tlx_afu_resp_valid,                                                     -- out std_ulogic;                        -- same cycle as the opcode and stuff  below
           tlx_afu_resp_opcode            =>  tlx_afu_resp_opcode,                                                    -- out std_ulogic_vector(7  downto 0);    -- 8      x
           tlx_afu_resp_captag            =>  tlx_afu_resp_afutag,                                                    -- out std_ulogic_vector(15 downto 0);
           tlx_afu_resp_code              =>  tlx_afu_resp_code,                                                      -- out std_ulogic_vector(3  downto 0);    -- 28     x
           tlx_afu_resp_dl                =>  tlx_afu_resp_dl,                                                        -- out std_ulogic_vector(1  downto 0);    -- 36     x
           tlx_afu_resp_dp                =>  tlx_afu_resp_dp,                                                        -- out std_ulogic_vector(2  downto 0);    -- 38     x   (need 3 bits now !!!)

           reg_01_hwwe_i                  =>  reg_01_hwwe_i,                                                          -- write strobe
           reg_01_update_i                =>  reg_01_update_i,                                                        -- write data (31:0)
           reg_01_o                       =>  reg_01_o,
                                                                                                                      --
           rcv_xmt_tlx_credit_vc0         =>  rcv_xmt_tlx_credit_vc0_int,                                             -- out std_ulogic_vector(3 downto 0);     -- from a return_tlx_credits - 08
           rcv_xmt_tlx_credit_vc3         =>  rcv_xmt_tlx_credit_vc3,                                                 -- out std_ulogic_vector(3 downto 0);     -- (sent from upstream)
           rcv_xmt_tlx_credit_dcp0        =>  rcv_xmt_tlx_credit_dcp0,                                                -- out std_ulogic_vector(5 downto 0);     --
           rcv_xmt_tlx_credit_dcp3        =>  rcv_xmt_tlx_credit_dcp3,                                                -- out std_ulogic_vector(5 downto 0);     -- vc0 and dcp0 for responses and data
           rcv_xmt_tlx_credit_valid       =>  rcv_xmt_tlx_credit_valid_int,                                           -- out std_ulogic;                        -- this needt to be from a return_tl_credits
                                                                                                                      --                                        --
           rcv_xmt_tl_credit_vc0_valid    =>  rcv_xmt_tl_credit_vc0_valid,                                            -- out std_ulogic;                        -- rcv_xmt_credit_vc0_v in   ocx_tlx_rcv_mac T
           rcv_xmt_tl_credit_vc1_valid    =>  rcv_xmt_tl_credit_vc1_valid,                                            -- out std_ulogic;                        -- rcv_xmt_credit_v          ocx_tlx_resp_fifo_mac
           rcv_xmt_tl_credit_dcp0_valid   =>  rcv_xmt_tl_credit_dcp0_valid,                                           -- out std_ulogic;                        --
           rcv_xmt_tl_credit_dcp1_valid   =>  rcv_xmt_tl_credit_dcp1_valid                                            -- out std_ulogic                         -- presume these should be VC1 for commands and dcp1 for data, coming out of some counters which say how much
       );

    -- ----------
    -- TLX Framer
    -- ----------
    ocxtlx_framer : component ocx_tlx_framer
       port map (

        -- -----------------------------------
        -- AFU Command/Response/Data Interface
        -- -----------------------------------
        -- --- Initial credit allocation

        -- --- Commands from AFU
        tlx_afu_cmd_initial_credit        =>   tlx_afu_cmd_initial_credit ,
        tlx_afu_cmd_credit                =>   tlx_afu_cmd_credit,
        afu_tlx_cmd_valid                 =>   afu_tlx_cmd_valid,
        afu_tlx_cmd_opcode                =>   afu_tlx_cmd_opcode,
        afu_tlx_cmd_pa_or_obj             =>   afu_tlx_cmd_pa_or_obj,
        afu_tlx_cmd_afutag                =>   afu_tlx_cmd_afutag,
        afu_tlx_cmd_dl                    =>   afu_tlx_cmd_dl,
        afu_tlx_cmd_pl                    =>   afu_tlx_cmd_pl,
        afu_tlx_cmd_be                    =>   afu_tlx_cmd_be,
        afu_tlx_cmd_flag                  =>   afu_tlx_cmd_flag,
        afu_tlx_cmd_bdf                   =>   afu_tlx_cmd_bdf,
        afu_tlx_cmd_resp_code             =>   afu_tlx_cmd_resp_code,
        afu_tlx_cmd_capptag               =>   afu_tlx_cmd_capptag  ,

        -- --- Command data from AFU      =>
        tlx_afu_cmd_data_initial_credit   =>   tlx_afu_cmd_data_initial_credit,
        tlx_afu_cmd_data_credit           =>   tlx_afu_cmd_data_credit,
        afu_tlx_cdata_valid               =>   afu_tlx_cdata_valid,
        afu_tlx_cdata_bus                 =>   afu_tlx_cdata_bus,
        afu_tlx_cdata_bdi                 =>   afu_tlx_cdata_bdi,

        -- --- Responses from AFU         =>
        tlx_afu_resp_initial_credit       =>   tlx_afu_resp_initial_credit,
        tlx_afu_resp_credit               =>   tlx_afu_resp_credit,
        afu_tlx_resp_valid                =>   afu_tlx_resp_valid,
        afu_tlx_resp_opcode               =>   afu_tlx_resp_opcode,
        afu_tlx_resp_dl                   =>   afu_tlx_resp_dl,
        afu_tlx_resp_capptag              =>   afu_tlx_resp_capptag,
        afu_tlx_resp_dp                   =>   afu_tlx_resp_dp,
        afu_tlx_resp_code                 =>   afu_tlx_resp_code,

        -- --- Response data from AFU     =>
        tlx_afu_resp_data_initial_credit  =>   tlx_afu_resp_data_initial_credit,
        tlx_afu_resp_data_credit          =>   tlx_afu_resp_data_credit,
        afu_tlx_rdata_valid               =>   afu_tlx_rdata_valid,
        afu_tlx_rdata_bus                 =>   afu_tlx_rdata_bus,
        afu_tlx_rdata_bdi                 =>   afu_tlx_rdata_bdi,

        -- --- Config Responses from AFU  =>
        cfg_tlx_resp_valid                =>   cfg_tlx_resp_valid,
        cfg_tlx_resp_opcode               =>   cfg_tlx_resp_opcode,
        cfg_tlx_resp_capptag              =>   cfg_tlx_resp_capptag,
        cfg_tlx_resp_code                 =>   cfg_tlx_resp_code,
        tlx_cfg_resp_ack                  =>   tlx_cfg_resp_ack,

        -- --- Config Response data from AFU
        cfg_tlx_rdata_offset              =>   cfg_tlx_rdata_offset,
        cfg_tlx_rdata_bus                 =>   cfg_tlx_rdata_bus,
        cfg_tlx_rdata_bdi                 =>   cfg_tlx_rdata_bdi,


        -- -----------------------------------
        -- TLX to DLX Interface
        -- -----------------------------------
        dlx_tlx_link_up                   =>   dlx_tlx_link_up,
        dlx_tlx_init_flit_depth           =>   dlx_tlx_init_flit_depth,
        dlx_tlx_flit_credit               =>   dlx_tlx_flit_credit,
        tlx_dlx_flit_valid                =>   tlx_dlx_flit_valid,
        tlx_dlx_flit                      =>   tlx_dlx_flit,

        -- -----------------------------------
        -- TLX Parser to TLX Framer Interface
        -- -----------------------------------
        rcv_xmt_tl_credit_vc0_valid       =>   rcv_xmt_tl_credit_vc0_valid,
        rcv_xmt_tl_credit_vc1_valid       =>   rcv_xmt_tl_credit_vc1_valid,
        rcv_xmt_tl_credit_dcp0_valid      =>   rcv_xmt_tl_credit_dcp0_valid ,
        rcv_xmt_tl_credit_dcp1_valid      =>   rcv_xmt_tl_credit_dcp1_valid ,
        rcv_xmt_tl_crd_cfg_dcp1_valid     =>   rcv_xmt_tl_crd_cfg_dcp1_valid,

        rcv_xmt_tlx_credit_valid          =>   rcv_xmt_tlx_credit_valid_int,
        rcv_xmt_tlx_credit_vc0            =>   rcv_xmt_tlx_credit_vc0_int,
        rcv_xmt_tlx_credit_vc3            =>   rcv_xmt_tlx_credit_vc3 ,
        rcv_xmt_tlx_credit_dcp0           =>   rcv_xmt_tlx_credit_dcp0 ,
        rcv_xmt_tlx_credit_dcp3           =>   rcv_xmt_tlx_credit_dcp3 ,

        -- -----------------------------------
        -- Configuration Ports
        -- -----------------------------------
        cfg_tlx_xmit_tmpl_config_0        =>   cfg_tlx_xmit_tmpl_config_0,
        cfg_tlx_xmit_tmpl_config_1        =>   cfg_tlx_xmit_tmpl_config_1,
        cfg_tlx_xmit_tmpl_config_2        =>   cfg_tlx_xmit_tmpl_config_2,
        cfg_tlx_xmit_tmpl_config_3        =>   cfg_tlx_xmit_tmpl_config_3,
        cfg_tlx_xmit_rate_config_0        =>   cfg_tlx_xmit_rate_config_0,
        cfg_tlx_xmit_rate_config_1        =>   cfg_tlx_xmit_rate_config_1,
        cfg_tlx_xmit_rate_config_2        =>   cfg_tlx_xmit_rate_config_2,
        cfg_tlx_xmit_rate_config_3        =>   cfg_tlx_xmit_rate_config_3,

        -- -----------------------------------
        -- Debug Ports
        -- -----------------------------------
        rcv_xmt_debug_info                =>   rcv_xmt_debug_info,
        rcv_xmt_debug_fatal               =>   rcv_xmt_debug_fatal,
        rcv_xmt_debug_valid               =>   rcv_xmt_debug_valid,
        tlx_dlx_debug_encode              =>   tlx_dlx_debug_encode,
        tlx_dlx_debug_info                =>   tlx_dlx_debug_info,
        dlx_tlx_dlx_config_info           =>   dlx_tlx_dlx_config_info,


        -- -----------------------------------
        -- Misc. Interface
        -- -----------------------------------
        clock                             =>   clock,
        reset_n                           =>   reset_n
    ) ;


-- ==============================================================================================================================
-- @@@  ocx_tlx_top Logic
-- ==============================================================================================================================


end architecture;
