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

library ieee, support, ibm, work;
  use ieee.std_logic_1164.all;
  use ibm.std_ulogic_unsigned.all;
  use ibm.std_ulogic_function_support.all;
  use ibm.std_ulogic_support.all;
  use work.axi_pkg.all;
entity ocx_dlx_tlx_stage is
  port (
    ---------------------------------------------------------------------------
    -- Clocking
    ---------------------------------------------------------------------------
    opt_gckn                       : in std_ulogic;
    tlx_dlx_flit  : IN std_ulogic_vector(511 downto 0);
    tlx_dlx_flit_valid           : IN std_ulogic;
    ---------------------------------------------------------------------------
    -- RX Interface
    ---------------------------------------------------------------------------
    i_dlx_tlx_flit_valid             : in std_ulogic;
    i_dlx_tlx_flit                   : in std_ulogic_vector(511 downto 0);
    i_dlx_tlx_flit_crc_err           : in std_ulogic;
    i_dlx_tlx_link_up                : in std_ulogic;
    -- Interface to TLx
    dlx_tlx_flit_valid             : out std_ulogic;
    dlx_tlx_flit                   : out std_ulogic_vector(511 downto 0);
    dlx_tlx_flit_crc_err           : out std_ulogic;
    dlx_tlx_link_up                : out std_ulogic
   
    );

end ocx_dlx_tlx_stage;

architecture ocx_dlx_tlx_stage of ocx_dlx_tlx_stage is

  signal  tlx_dlx_flit_q  : std_ulogic_vector(511 downto 0);
  signal  tlx_dlx_flit_valid_q  : std_ulogic;

  signal  dlx_tlx_flit_valid_q             :  std_ulogic;
  signal  dlx_tlx_flit_q                   :  std_ulogic_vector(511 downto 0);
  signal  dlx_tlx_flit_crc_err_q           :  std_ulogic;
  signal  dlx_tlx_link_up_q                :  std_ulogic;

  signal  dlx_tlx_flit_valid_qq             :  std_ulogic;
  signal  dlx_tlx_flit_qq                   :  std_ulogic_vector(511 downto 0);
  signal  dlx_tlx_flit_crc_err_qq           :  std_ulogic;
  signal  dlx_tlx_link_up_qq                :  std_ulogic;

  attribute keep                : string;
  attribute mark_debug                : string;
  attribute mark_debug of  tlx_dlx_flit_q              : signal is "true";
  attribute mark_debug of  tlx_dlx_flit_valid_q              : signal is "true";
  attribute keep of  tlx_dlx_flit_q              : signal is "true";
  attribute keep of  tlx_dlx_flit_valid_q              : signal is "true";
begin

dlx_tlx_flit_valid   <= dlx_tlx_flit_valid_qq;
dlx_tlx_flit         <= dlx_tlx_flit_qq;
dlx_tlx_flit_crc_err <= dlx_tlx_flit_crc_err_qq;
dlx_tlx_link_up      <= dlx_tlx_link_up_qq;

  process (opt_gckn)
  begin
    if opt_gckn'event and opt_gckn = '1' then
      dlx_tlx_flit_valid_q   <= i_dlx_tlx_flit_valid;
      dlx_tlx_flit_q         <= i_dlx_tlx_flit;
      dlx_tlx_flit_crc_err_q <= i_dlx_tlx_flit_crc_err;
      dlx_tlx_link_up_q      <= i_dlx_tlx_link_up;

      dlx_tlx_flit_valid_qq   <= dlx_tlx_flit_valid_q;
      dlx_tlx_flit_qq         <= dlx_tlx_flit_q;
      dlx_tlx_flit_crc_err_qq <= dlx_tlx_flit_crc_err_q;
      dlx_tlx_link_up_qq      <= dlx_tlx_link_up_q;

      
      tlx_dlx_flit_q                 <= tlx_dlx_flit;
      tlx_dlx_flit_valid_q           <= tlx_dlx_flit_valid;

    end if;
  end process;


end ocx_dlx_tlx_stage;




