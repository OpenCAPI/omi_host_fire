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

library ieee;
use ieee.std_logic_1164.all;

package axi_pkg is

  ---------------------------------------------------------------------------
  -- Type Aliases for AXI4-Lite Interface
  ---------------------------------------------------------------------------
  type t_AXI4_LITE_SLAVE_INPUT is record
    -- Global
    s0_axi_aresetn : std_ulogic;

    -- Write Address Channel
    s0_axi_awvalid : std_ulogic;
    s0_axi_awaddr  : std_ulogic_vector(63 downto 0);
    s0_axi_awprot  : std_ulogic_vector(2 downto 0);

    -- Write Data Channel
    s0_axi_wvalid : std_ulogic;
    s0_axi_wdata  : std_ulogic_vector(31 downto 0);
    s0_axi_wstrb  : std_ulogic_vector(3 downto 0);

    -- Write Response Channel
    s0_axi_bready : std_ulogic;

    -- Read Address Channel
    s0_axi_arvalid : std_ulogic;
    s0_axi_araddr  : std_ulogic_vector(63 downto 0);
    s0_axi_arprot  : std_ulogic_vector(2 downto 0);

    -- Read Data Channel
    s0_axi_rready : std_ulogic;
  end record t_AXI4_LITE_SLAVE_INPUT;

  type t_AXI4_LITE_SLAVE_OUTPUT is record
    -- Global

    -- Write Address Channel
    s0_axi_awready : std_ulogic;

    -- Write Data Channel
    s0_axi_wready : std_ulogic;

    -- Write Response Channel
    s0_axi_bvalid : std_ulogic;
    s0_axi_bresp  : std_ulogic_vector(1 downto 0);

    -- Read Address Channel
    s0_axi_arready : std_ulogic;

    -- Read Data Channel
    s0_axi_rvalid : std_ulogic;
    s0_axi_rdata  : std_ulogic_vector(31 downto 0);
    s0_axi_rresp  : std_ulogic_vector(1 downto 0);
  end record t_AXI4_LITE_SLAVE_OUTPUT;

  type t_AXI4_LITE_MASTER_OUTPUT is record
    -- Global
    m0_axi_aresetn : std_ulogic;

    -- Write Address Channel
    m0_axi_awvalid : std_ulogic;
    m0_axi_awaddr  : std_ulogic_vector(63 downto 0);
    m0_axi_awprot  : std_ulogic_vector(2 downto 0);

    -- Write Data Channel
    m0_axi_wvalid : std_ulogic;
    m0_axi_wdata  : std_ulogic_vector(31 downto 0);
    m0_axi_wstrb  : std_ulogic_vector(3 downto 0);

    -- Write Response Channel
    m0_axi_bready : std_ulogic;

    -- Read Address Channel
    m0_axi_arvalid : std_ulogic;
    m0_axi_araddr  : std_ulogic_vector(63 downto 0);
    m0_axi_arprot  : std_ulogic_vector(2 downto 0);

    -- Read Data Channel
    m0_axi_rready : std_ulogic;
  end record t_AXI4_LITE_MASTER_OUTPUT;

  type t_AXI4_LITE_MASTER_INPUT is record
    -- Global

    -- Write Address Channel
    m0_axi_awready : std_ulogic;

    -- Write Data Channel
    m0_axi_wready : std_ulogic;

    -- Write Response Channel
    m0_axi_bvalid : std_ulogic;
    m0_axi_bresp  : std_ulogic_vector(1 downto 0);

    -- Read Address Channel
    m0_axi_arready : std_ulogic;

    -- Read Data Channel
    m0_axi_rvalid : std_ulogic;
    m0_axi_rdata  : std_ulogic_vector(31 downto 0);
    m0_axi_rresp  : std_ulogic_vector(1 downto 0);
  end record t_AXI4_LITE_MASTER_INPUT;

  ---------------------------------------------------------------------------
  -- Type Aliases for AXI3 Interface
  ---------------------------------------------------------------------------
  type t_AXI3_SLAVE_INPUT is record
    -- Global
    s0_axi_aresetn : std_ulogic;

    -- Write Address Channel
    s0_axi_awid    : std_ulogic_vector(6 downto 0);
    s0_axi_awaddr  : std_ulogic_vector(63 downto 0);
    s0_axi_awlen   : std_ulogic_vector(3 downto 0);
    s0_axi_awsize  : std_ulogic_vector(2 downto 0);
    s0_axi_awburst : std_ulogic_vector(1 downto 0);
    s0_axi_awlock  : std_ulogic_vector(1 downto 0);
    s0_axi_awcache : std_ulogic_vector(3 downto 0);
    s0_axi_awprot  : std_ulogic_vector(2 downto 0);
    s0_axi_awvalid : std_ulogic;

    -- Write Data Channel
    s0_axi_wid    : std_ulogic_vector(6 downto 0);
    s0_axi_wdata  : std_ulogic_vector(31 downto 0);
    s0_axi_wstrb  : std_ulogic_vector(3 downto 0);
    s0_axi_wlast  : std_ulogic;
    s0_axi_wvalid : std_ulogic;

    -- Write Response Channel
    s0_axi_bready : std_ulogic;

    -- Read Address Channel
    s0_axi_arid    : std_ulogic_vector(6 downto 0);
    s0_axi_araddr  : std_ulogic_vector(63 downto 0);
    s0_axi_arlen   : std_ulogic_vector(3 downto 0);
    s0_axi_arsize  : std_ulogic_vector(2 downto 0);
    s0_axi_arburst : std_ulogic_vector(1 downto 0);
    s0_axi_arlock  : std_ulogic_vector(1 downto 0);
    s0_axi_arcache : std_ulogic_vector(3 downto 0);
    s0_axi_arprot  : std_ulogic_vector(2 downto 0);
    s0_axi_arvalid : std_ulogic;

    -- Read Data Channel
    s0_axi_rready : std_ulogic;
  end record t_AXI3_SLAVE_INPUT;

  type t_AXI3_SLAVE_OUTPUT is record
    -- Global

    -- Write Address Channel
    s0_axi_awready : std_ulogic;

    -- Write Data Channel
    s0_axi_wready : std_ulogic;

    -- Write Response Channel
    s0_axi_bid    : std_ulogic_vector(6 downto 0);
    s0_axi_bresp  : std_ulogic_vector(1 downto 0);
    s0_axi_bvalid : std_ulogic;

    -- Read Address Channel
    s0_axi_arready : std_ulogic;

    -- Read Data Channel
    s0_axi_rid    : std_ulogic_vector(6 downto 0);
    s0_axi_rdata  : std_ulogic_vector(31 downto 0);
    s0_axi_rresp  : std_ulogic_vector(1 downto 0);
    s0_axi_rlast  : std_ulogic;
    s0_axi_rvalid : std_ulogic;
  end record t_AXI3_SLAVE_OUTPUT;

  type t_AXI3_MASTER_OUTPUT is record
    -- Global
    m0_axi_aresetn : std_ulogic;

    -- Write Address Channel
    m0_axi_awid    : std_ulogic_vector(6 downto 0);
    m0_axi_awaddr  : std_ulogic_vector(63 downto 0);
    m0_axi_awlen   : std_ulogic_vector(3 downto 0);
    m0_axi_awsize  : std_ulogic_vector(2 downto 0);
    m0_axi_awburst : std_ulogic_vector(1 downto 0);
    m0_axi_awlock  : std_ulogic_vector(1 downto 0);
    m0_axi_awcache : std_ulogic_vector(3 downto 0);
    m0_axi_awprot  : std_ulogic_vector(2 downto 0);
    m0_axi_awvalid : std_ulogic;

    -- Write Data Channel
    m0_axi_wid    : std_ulogic_vector(6 downto 0);
    m0_axi_wdata  : std_ulogic_vector(31 downto 0);
    m0_axi_wstrb  : std_ulogic_vector(3 downto 0);
    m0_axi_wlast  : std_ulogic;
    m0_axi_wvalid : std_ulogic;

    -- Write Response Channel
    m0_axi_bready : std_ulogic;

    -- Read Address Channel
    m0_axi_arid    : std_ulogic_vector(6 downto 0);
    m0_axi_araddr  : std_ulogic_vector(63 downto 0);
    m0_axi_arlen   : std_ulogic_vector(3 downto 0);
    m0_axi_arsize  : std_ulogic_vector(2 downto 0);
    m0_axi_arburst : std_ulogic_vector(1 downto 0);
    m0_axi_arlock  : std_ulogic_vector(1 downto 0);
    m0_axi_arcache : std_ulogic_vector(3 downto 0);
    m0_axi_arprot  : std_ulogic_vector(2 downto 0);
    m0_axi_arvalid : std_ulogic;

    -- Read Data Channel
    m0_axi_rready : std_ulogic;
  end record t_AXI3_MASTER_OUTPUT;

  type t_AXI3_MASTER_INPUT is record
    -- Global

    -- Write Address Channel
    m0_axi_awready : std_ulogic;

    -- Write Data Channel
    m0_axi_wready : std_ulogic;

    -- Write Response Channel
    m0_axi_bid    : std_ulogic_vector(6 downto 0);
    m0_axi_bresp  : std_ulogic_vector(1 downto 0);
    m0_axi_bvalid : std_ulogic;

    -- Read Address Channel
    m0_axi_arready : std_ulogic;

    -- Read Data Channel
    m0_axi_rid    : std_ulogic_vector(6 downto 0);
    m0_axi_rdata  : std_ulogic_vector(31 downto 0);
    m0_axi_rresp  : std_ulogic_vector(1 downto 0);
    m0_axi_rlast  : std_ulogic;
    m0_axi_rvalid : std_ulogic;
  end record t_AXI3_MASTER_INPUT;

  type t_AXI3_512_SLAVE_INPUT is record
    -- Global
    s0_axi_aresetn : std_ulogic;

    -- Write Address Channel
    s0_axi_awid    : std_ulogic_vector(11 downto 0);
    s0_axi_awaddr  : std_ulogic_vector(63 downto 0);
    s0_axi_awlen   : std_ulogic_vector(3 downto 0);
    s0_axi_awsize  : std_ulogic_vector(2 downto 0);
    s0_axi_awburst : std_ulogic_vector(1 downto 0);
    s0_axi_awlock  : std_ulogic_vector(1 downto 0);
    s0_axi_awcache : std_ulogic_vector(3 downto 0);
    s0_axi_awprot  : std_ulogic_vector(2 downto 0);
    s0_axi_awvalid : std_ulogic;

    -- Write Data Channel
    s0_axi_wid    : std_ulogic_vector(11 downto 0);
    s0_axi_wdata  : std_ulogic_vector(511 downto 0);
    s0_axi_wstrb  : std_ulogic_vector(63 downto 0);
    s0_axi_wlast  : std_ulogic;
    s0_axi_wvalid : std_ulogic;

    -- Write Response Channel
    s0_axi_bready : std_ulogic;

    -- Read Address Channel
    s0_axi_arid    : std_ulogic_vector(11 downto 0);
    s0_axi_araddr  : std_ulogic_vector(63 downto 0);
    s0_axi_arlen   : std_ulogic_vector(3 downto 0);
    s0_axi_arsize  : std_ulogic_vector(2 downto 0);
    s0_axi_arburst : std_ulogic_vector(1 downto 0);
    s0_axi_arlock  : std_ulogic_vector(1 downto 0);
    s0_axi_arcache : std_ulogic_vector(3 downto 0);
    s0_axi_arprot  : std_ulogic_vector(2 downto 0);
    s0_axi_arvalid : std_ulogic;

    -- Read Data Channel
    s0_axi_rready : std_ulogic;
  end record t_AXI3_512_SLAVE_INPUT;

  type t_AXI3_512_SLAVE_OUTPUT is record
    -- Global

    -- Write Address Channel
    s0_axi_awready : std_ulogic;

    -- Write Data Channel
    s0_axi_wready : std_ulogic;

    -- Write Response Channel
    s0_axi_bid    : std_ulogic_vector(11 downto 0);
    s0_axi_bresp  : std_ulogic_vector(1 downto 0);
    s0_axi_bvalid : std_ulogic;

    -- Read Address Channel
    s0_axi_arready : std_ulogic;

    -- Read Data Channel
    s0_axi_rid    : std_ulogic_vector(11 downto 0);
    s0_axi_rdata  : std_ulogic_vector(511 downto 0);
    s0_axi_rresp  : std_ulogic_vector(1 downto 0);
    s0_axi_rlast  : std_ulogic;
    s0_axi_ruser  : std_ulogic_vector(2 downto 0);
    s0_axi_rvalid : std_ulogic;
  end record t_AXI3_512_SLAVE_OUTPUT;

  type t_AXI3_512_MASTER_OUTPUT is record
    -- Global
    m0_axi_aresetn : std_ulogic;

    -- Write Address Channel
    m0_axi_awid    : std_ulogic_vector(11 downto 0);
    m0_axi_awaddr  : std_ulogic_vector(63 downto 0);
    m0_axi_awlen   : std_ulogic_vector(3 downto 0);
    m0_axi_awsize  : std_ulogic_vector(2 downto 0);
    m0_axi_awburst : std_ulogic_vector(1 downto 0);
    m0_axi_awlock  : std_ulogic_vector(1 downto 0);
    m0_axi_awcache : std_ulogic_vector(3 downto 0);
    m0_axi_awprot  : std_ulogic_vector(2 downto 0);
    m0_axi_awvalid : std_ulogic;

    -- Write Data Channel
    m0_axi_wid    : std_ulogic_vector(11 downto 0);
    m0_axi_wdata  : std_ulogic_vector(511 downto 0);
    m0_axi_wstrb  : std_ulogic_vector(63 downto 0);
    m0_axi_wlast  : std_ulogic;
    m0_axi_wvalid : std_ulogic;

    -- Write Response Channel
    m0_axi_bready : std_ulogic;

    -- Read Address Channel
    m0_axi_arid    : std_ulogic_vector(11 downto 0);
    m0_axi_araddr  : std_ulogic_vector(63 downto 0);
    m0_axi_arlen   : std_ulogic_vector(3 downto 0);
    m0_axi_arsize  : std_ulogic_vector(2 downto 0);
    m0_axi_arburst : std_ulogic_vector(1 downto 0);
    m0_axi_arlock  : std_ulogic_vector(1 downto 0);
    m0_axi_arcache : std_ulogic_vector(3 downto 0);
    m0_axi_arprot  : std_ulogic_vector(2 downto 0);
    m0_axi_arvalid : std_ulogic;

    -- Read Data Channel
    m0_axi_rready : std_ulogic;
  end record t_AXI3_512_MASTER_OUTPUT;

  type t_AXI3_512_MASTER_INPUT is record
    -- Global

    -- Write Address Channel
    m0_axi_awready : std_ulogic;

    -- Write Data Channel
    m0_axi_wready : std_ulogic;

    -- Write Response Channel
    m0_axi_bid    : std_ulogic_vector(11 downto 0);
    m0_axi_bresp  : std_ulogic_vector(1 downto 0);
    m0_axi_bvalid : std_ulogic;

    -- Read Address Channel
    m0_axi_arready : std_ulogic;

    -- Read Data Channel
    m0_axi_rid    : std_ulogic_vector(11 downto 0);
    m0_axi_rdata  : std_ulogic_vector(511 downto 0);
    m0_axi_rresp  : std_ulogic_vector(1 downto 0);
    m0_axi_rlast  : std_ulogic;
    m0_axi_ruser  : std_ulogic_vector(2 downto 0);
    m0_axi_rvalid : std_ulogic;
  end record t_AXI3_512_MASTER_INPUT;

  type t_AXI3_64_SLAVE_INPUT is record
    -- Global
    s0_axi_aresetn : std_ulogic;

    -- Write Address Channel
    s0_axi_awid    : std_ulogic_vector(0 downto 0);
    s0_axi_awaddr  : std_ulogic_vector(63 downto 0);
    s0_axi_awlen   : std_ulogic_vector(3 downto 0);
    s0_axi_awsize  : std_ulogic_vector(2 downto 0);
    s0_axi_awburst : std_ulogic_vector(1 downto 0);
    s0_axi_awlock  : std_ulogic_vector(1 downto 0);
    s0_axi_awcache : std_ulogic_vector(3 downto 0);
    s0_axi_awprot  : std_ulogic_vector(2 downto 0);
    s0_axi_awvalid : std_ulogic;

    -- Write Data Channel
    s0_axi_wid    : std_ulogic_vector(0 downto 0);
    s0_axi_wdata  : std_ulogic_vector(63 downto 0);
    s0_axi_wstrb  : std_ulogic_vector(7 downto 0);
    s0_axi_wlast  : std_ulogic;
    s0_axi_wvalid : std_ulogic;

    -- Write Response Channel
    s0_axi_bready : std_ulogic;

    -- Read Address Channel
    s0_axi_arid    : std_ulogic_vector(0 downto 0);
    s0_axi_araddr  : std_ulogic_vector(63 downto 0);
    s0_axi_arlen   : std_ulogic_vector(3 downto 0);
    s0_axi_arsize  : std_ulogic_vector(2 downto 0);
    s0_axi_arburst : std_ulogic_vector(1 downto 0);
    s0_axi_arlock  : std_ulogic_vector(1 downto 0);
    s0_axi_arcache : std_ulogic_vector(3 downto 0);
    s0_axi_arprot  : std_ulogic_vector(2 downto 0);
    s0_axi_arvalid : std_ulogic;

    -- Read Data Channel
    s0_axi_rready : std_ulogic;
  end record t_AXI3_64_SLAVE_INPUT;

  type t_AXI3_64_SLAVE_OUTPUT is record
    -- Global

    -- Write Address Channel
    s0_axi_awready : std_ulogic;

    -- Write Data Channel
    s0_axi_wready : std_ulogic;

    -- Write Response Channel
    s0_axi_bid    : std_ulogic_vector(0 downto 0);
    s0_axi_bresp  : std_ulogic_vector(1 downto 0);
    s0_axi_bvalid : std_ulogic;

    -- Read Address Channel
    s0_axi_arready : std_ulogic;

    -- Read Data Channel
    s0_axi_rid    : std_ulogic_vector(0 downto 0);
    s0_axi_rdata  : std_ulogic_vector(63 downto 0);
    s0_axi_rresp  : std_ulogic_vector(1 downto 0);
    s0_axi_rlast  : std_ulogic;
    s0_axi_rvalid : std_ulogic;
  end record t_AXI3_64_SLAVE_OUTPUT;

  type t_AXI3_64_MASTER_OUTPUT is record
    -- Global
    m0_axi_aresetn : std_ulogic;

    -- Write Address Channel
    m0_axi_awid    : std_ulogic_vector(0 downto 0);
    m0_axi_awaddr  : std_ulogic_vector(63 downto 0);
    m0_axi_awlen   : std_ulogic_vector(3 downto 0);
    m0_axi_awsize  : std_ulogic_vector(2 downto 0);
    m0_axi_awburst : std_ulogic_vector(1 downto 0);
    m0_axi_awlock  : std_ulogic_vector(1 downto 0);
    m0_axi_awcache : std_ulogic_vector(3 downto 0);
    m0_axi_awprot  : std_ulogic_vector(2 downto 0);
    m0_axi_awvalid : std_ulogic;

    -- Write Data Channel
    m0_axi_wid    : std_ulogic_vector(0 downto 0);
    m0_axi_wdata  : std_ulogic_vector(63 downto 0);
    m0_axi_wstrb  : std_ulogic_vector(7 downto 0);
    m0_axi_wlast  : std_ulogic;
    m0_axi_wvalid : std_ulogic;

    -- Write Response Channel
    m0_axi_bready : std_ulogic;

    -- Read Address Channel
    m0_axi_arid    : std_ulogic_vector(0 downto 0);
    m0_axi_araddr  : std_ulogic_vector(63 downto 0);
    m0_axi_arlen   : std_ulogic_vector(3 downto 0);
    m0_axi_arsize  : std_ulogic_vector(2 downto 0);
    m0_axi_arburst : std_ulogic_vector(1 downto 0);
    m0_axi_arlock  : std_ulogic_vector(1 downto 0);
    m0_axi_arcache : std_ulogic_vector(3 downto 0);
    m0_axi_arprot  : std_ulogic_vector(2 downto 0);
    m0_axi_arvalid : std_ulogic;

    -- Read Data Channel
    m0_axi_rready : std_ulogic;
  end record t_AXI3_64_MASTER_OUTPUT;

  type t_AXI3_64_MASTER_INPUT is record
    -- Global

    -- Write Address Channel
    m0_axi_awready : std_ulogic;

    -- Write Data Channel
    m0_axi_wready : std_ulogic;

    -- Write Response Channel
    m0_axi_bid    : std_ulogic_vector(0 downto 0);
    m0_axi_bresp  : std_ulogic_vector(1 downto 0);
    m0_axi_bvalid : std_ulogic;

    -- Read Address Channel
    m0_axi_arready : std_ulogic;

    -- Read Data Channel
    m0_axi_rid    : std_ulogic_vector(0 downto 0);
    m0_axi_rdata  : std_ulogic_vector(63 downto 0);
    m0_axi_rresp  : std_ulogic_vector(1 downto 0);
    m0_axi_rlast  : std_ulogic;
    m0_axi_rvalid : std_ulogic;
  end record t_AXI3_64_MASTER_INPUT;

  ---------------------------------------------------------------------------
  -- Type Aliases for AXI4 Interface
  ---------------------------------------------------------------------------
  type t_AXI4_SLAVE_INPUT is record
    -- Global
    s0_axi_aresetn : std_ulogic;

    -- Write Address Channel
    s0_axi_awid     : std_ulogic_vector(0 downto 0);
    s0_axi_awaddr   : std_ulogic_vector(63 downto 0);
    s0_axi_awlen    : std_ulogic_vector(7 downto 0);
    s0_axi_awsize   : std_ulogic_vector(2 downto 0);
    s0_axi_awburst  : std_ulogic_vector(1 downto 0);
    s0_axi_awlock   : std_ulogic_vector(0 downto 0);
    s0_axi_awcache  : std_ulogic_vector(3 downto 0);
    s0_axi_awprot   : std_ulogic_vector(2 downto 0);
    s0_axi_awregion : std_ulogic_vector(3 downto 0);
    s0_axi_awvalid  : std_ulogic;

    -- Write Data Channel
    s0_axi_wdata  : std_ulogic_vector(31 downto 0);
    s0_axi_wstrb  : std_ulogic_vector(3 downto 0);
    s0_axi_wlast  : std_ulogic;
    s0_axi_wvalid : std_ulogic;

    -- Write Response Channel
    s0_axi_bready : std_ulogic;

    -- Read Address Channel
    s0_axi_arid     : std_ulogic_vector(0 downto 0);
    s0_axi_araddr   : std_ulogic_vector(63 downto 0);
    s0_axi_arlen    : std_ulogic_vector(7 downto 0);
    s0_axi_arsize   : std_ulogic_vector(2 downto 0);
    s0_axi_arburst  : std_ulogic_vector(1 downto 0);
    s0_axi_arlock   : std_ulogic_vector(0 downto 0);
    s0_axi_arcache  : std_ulogic_vector(3 downto 0);
    s0_axi_arprot   : std_ulogic_vector(2 downto 0);
    s0_axi_arregion : std_ulogic_vector(3 downto 0);
    s0_axi_arvalid  : std_ulogic;

    -- Read Data Channel
    s0_axi_rready : std_ulogic;
  end record t_AXI4_SLAVE_INPUT;

  type t_AXI4_SLAVE_OUTPUT is record
    -- Global

    -- Write Address Channel
    s0_axi_awready : std_ulogic;

    -- Write Data Channel
    s0_axi_wready : std_ulogic;

    -- Write Response Channel
    s0_axi_bid    : std_ulogic_vector(0 downto 0);
    s0_axi_bresp  : std_ulogic_vector(1 downto 0);
    s0_axi_bvalid : std_ulogic;

    -- Read Address Channel
    s0_axi_arready : std_ulogic;

    -- Read Data Channel
    s0_axi_rid    : std_ulogic_vector(0 downto 0);
    s0_axi_rdata  : std_ulogic_vector(31 downto 0);
    s0_axi_rresp  : std_ulogic_vector(1 downto 0);
    s0_axi_rlast  : std_ulogic;
    s0_axi_rvalid : std_ulogic;
  end record t_AXI4_SLAVE_OUTPUT;

  type t_AXI4_MASTER_OUTPUT is record
    -- Global
    m0_axi_aresetn : std_ulogic;

    -- Write Address Channel
    m0_axi_awid     : std_ulogic_vector(0 downto 0);
    m0_axi_awaddr   : std_ulogic_vector(63 downto 0);
    m0_axi_awlen    : std_ulogic_vector(7 downto 0);
    m0_axi_awsize   : std_ulogic_vector(2 downto 0);
    m0_axi_awburst  : std_ulogic_vector(1 downto 0);
    m0_axi_awlock   : std_ulogic_vector(0 downto 0);
    m0_axi_awcache  : std_ulogic_vector(3 downto 0);
    m0_axi_awprot   : std_ulogic_vector(2 downto 0);
    m0_axi_awregion : std_ulogic_vector(3 downto 0);
    m0_axi_awvalid  : std_ulogic;

    -- Write Data Channel
    m0_axi_wdata  : std_ulogic_vector(31 downto 0);
    m0_axi_wstrb  : std_ulogic_vector(3 downto 0);
    m0_axi_wlast  : std_ulogic;
    m0_axi_wvalid : std_ulogic;

    -- Write Response Channel
    m0_axi_bready : std_ulogic;

    -- Read Address Channel
    m0_axi_arid     : std_ulogic_vector(0 downto 0);
    m0_axi_araddr   : std_ulogic_vector(63 downto 0);
    m0_axi_arlen    : std_ulogic_vector(7 downto 0);
    m0_axi_arsize   : std_ulogic_vector(2 downto 0);
    m0_axi_arburst  : std_ulogic_vector(1 downto 0);
    m0_axi_arlock   : std_ulogic_vector(0 downto 0);
    m0_axi_arcache  : std_ulogic_vector(3 downto 0);
    m0_axi_arprot   : std_ulogic_vector(2 downto 0);
    m0_axi_arregion : std_ulogic_vector(3 downto 0);
    m0_axi_arvalid  : std_ulogic;

    -- Read Data Channel
    m0_axi_rready : std_ulogic;
  end record t_AXI4_MASTER_OUTPUT;

  type t_AXI4_MASTER_INPUT is record
    -- Global

    -- Write Address Channel
    m0_axi_awready : std_ulogic;

    -- Write Data Channel
    m0_axi_wready : std_ulogic;

    -- Write Response Channel
    m0_axi_bid    : std_ulogic_vector(0 downto 0);
    m0_axi_bresp  : std_ulogic_vector(1 downto 0);
    m0_axi_bvalid : std_ulogic;

    -- Read Address Channel
    m0_axi_arready : std_ulogic;

    -- Read Data Channel
    m0_axi_rid    : std_ulogic_vector(0 downto 0);
    m0_axi_rdata  : std_ulogic_vector(31 downto 0);
    m0_axi_rresp  : std_ulogic_vector(1 downto 0);
    m0_axi_rlast  : std_ulogic;
    m0_axi_rvalid : std_ulogic;
  end record t_AXI4_MASTER_INPUT;

  ---------------------------------------------------------------------------
  -- Functions to Connect Master and Slaves
  ---------------------------------------------------------------------------
  function axi4lite_master_slave_connect (
    i : in t_AXI4_LITE_SLAVE_OUTPUT
    ) return t_AXI4_LITE_MASTER_INPUT;

  function axi4lite_master_slave_connect (
    i : in t_AXI4_LITE_MASTER_OUTPUT
    ) return t_AXI4_LITE_SLAVE_INPUT;

  function axi3_master_slave_connect (
    i : in t_AXI3_SLAVE_OUTPUT
    ) return t_AXI3_MASTER_INPUT;

  function axi3_master_slave_connect (
    i : in t_AXI3_MASTER_OUTPUT
    ) return t_AXI3_SLAVE_INPUT;

  function axi3_master_slave_connect (
    i : in t_AXI3_512_SLAVE_OUTPUT
    ) return t_AXI3_512_MASTER_INPUT;

  function axi3_master_slave_connect (
    i : in t_AXI3_512_MASTER_OUTPUT
    ) return t_AXI3_512_SLAVE_INPUT;

  function axi3_master_slave_connect (
    i : in t_AXI3_64_SLAVE_OUTPUT
    ) return t_AXI3_64_MASTER_INPUT;

  function axi3_master_slave_connect (
    i : in t_AXI3_64_MASTER_OUTPUT
    ) return t_AXI3_64_SLAVE_INPUT;

  function axi4_master_slave_connect (
    i : in t_AXI4_SLAVE_OUTPUT
    ) return t_AXI4_MASTER_INPUT;

  function axi4_master_slave_connect (
    i : in t_AXI4_MASTER_OUTPUT
    ) return t_AXI4_SLAVE_INPUT;

  ---------------------------------------------------------------------------
  -- Functions to Convert Binary <-> Graycode
  ---------------------------------------------------------------------------
  function de_bin2gray(A:std_ulogic_vector)
           return std_ulogic_vector;
  
  function de_gray2bin(A:std_ulogic_vector)
           return std_ulogic_vector; 

end package axi_pkg;

package body axi_pkg is

  function axi4lite_master_slave_connect (
    i : in t_AXI4_LITE_SLAVE_OUTPUT
    ) return t_AXI4_LITE_MASTER_INPUT is
    variable o : t_AXI4_LITE_MASTER_INPUT;

  begin
    o.m0_axi_awready := i.s0_axi_awready;
    o.m0_axi_wready  := i.s0_axi_wready;
    o.m0_axi_bvalid  := i.s0_axi_bvalid;
    o.m0_axi_bresp   := i.s0_axi_bresp;
    o.m0_axi_arready := i.s0_axi_arready;
    o.m0_axi_rvalid  := i.s0_axi_rvalid;
    o.m0_axi_rdata   := i.s0_axi_rdata;
    o.m0_axi_rresp   := i.s0_axi_rresp;
    return o;
  end;

  function axi4lite_master_slave_connect (
    i : in t_AXI4_LITE_MASTER_OUTPUT
    ) return t_AXI4_LITE_SLAVE_INPUT is
    variable o : t_AXI4_LITE_SLAVE_INPUT;

  begin
    o.s0_axi_aresetn := i.m0_axi_aresetn;
    o.s0_axi_awvalid := i.m0_axi_awvalid;
    o.s0_axi_awaddr  := i.m0_axi_awaddr;
    o.s0_axi_awprot  := i.m0_axi_awprot;
    o.s0_axi_wvalid  := i.m0_axi_wvalid;
    o.s0_axi_wdata   := i.m0_axi_wdata;
    o.s0_axi_wstrb   := i.m0_axi_wstrb;
    o.s0_axi_bready  := i.m0_axi_bready;
    o.s0_axi_arvalid := i.m0_axi_arvalid;
    o.s0_axi_araddr  := i.m0_axi_araddr;
    o.s0_axi_arprot  := i.m0_axi_arprot;
    o.s0_axi_rready  := i.m0_axi_rready;
    return o;
  end;

  function axi3_master_slave_connect (
    i : in t_AXI3_SLAVE_OUTPUT
    ) return t_AXI3_MASTER_INPUT is
    variable o : t_AXI3_MASTER_INPUT;

  begin
    o.m0_axi_awready := i.s0_axi_awready;
    o.m0_axi_wready  := i.s0_axi_wready;
    o.m0_axi_bid     := i.s0_axi_bid;
    o.m0_axi_bresp   := i.s0_axi_bresp;
    o.m0_axi_bvalid  := i.s0_axi_bvalid;
    o.m0_axi_arready := i.s0_axi_arready;
    o.m0_axi_rid     := i.s0_axi_rid;
    o.m0_axi_rdata   := i.s0_axi_rdata;
    o.m0_axi_rresp   := i.s0_axi_rresp;
    o.m0_axi_rlast   := i.s0_axi_rlast;
    o.m0_axi_rvalid  := i.s0_axi_rvalid;
    return o;
  end;

  function axi3_master_slave_connect (
    i : in t_AXI3_MASTER_OUTPUT
    ) return t_AXI3_SLAVE_INPUT is
    variable o : t_AXI3_SLAVE_INPUT;

  begin
    o.s0_axi_aresetn := i.m0_axi_aresetn;
    o.s0_axi_awid    := i.m0_axi_awid;
    o.s0_axi_awaddr  := i.m0_axi_awaddr;
    o.s0_axi_awlen   := i.m0_axi_awlen;
    o.s0_axi_awsize  := i.m0_axi_awsize;
    o.s0_axi_awburst := i.m0_axi_awburst;
    o.s0_axi_awlock  := i.m0_axi_awlock;
    o.s0_axi_awcache := i.m0_axi_awcache;
    o.s0_axi_awprot  := i.m0_axi_awprot;
    o.s0_axi_awvalid := i.m0_axi_awvalid;
    o.s0_axi_wid     := i.m0_axi_wid;
    o.s0_axi_wdata   := i.m0_axi_wdata;
    o.s0_axi_wstrb   := i.m0_axi_wstrb;
    o.s0_axi_wlast   := i.m0_axi_wlast;
    o.s0_axi_wvalid  := i.m0_axi_wvalid;
    o.s0_axi_bready  := i.m0_axi_bready;
    o.s0_axi_arid    := i.m0_axi_arid;
    o.s0_axi_araddr  := i.m0_axi_araddr;
    o.s0_axi_arlen   := i.m0_axi_arlen;
    o.s0_axi_arsize  := i.m0_axi_arsize;
    o.s0_axi_arburst := i.m0_axi_arburst;
    o.s0_axi_arlock  := i.m0_axi_arlock;
    o.s0_axi_arcache := i.m0_axi_arcache;
    o.s0_axi_arprot  := i.m0_axi_arprot;
    o.s0_axi_arvalid := i.m0_axi_arvalid;
    o.s0_axi_rready  := i.m0_axi_rready;
    o.s0_axi_aresetn := i.m0_axi_aresetn;
    o.s0_axi_awvalid := i.m0_axi_awvalid;
    o.s0_axi_awaddr  := i.m0_axi_awaddr;
    o.s0_axi_awprot  := i.m0_axi_awprot;
    o.s0_axi_wvalid  := i.m0_axi_wvalid;
    o.s0_axi_wdata   := i.m0_axi_wdata;
    o.s0_axi_wstrb   := i.m0_axi_wstrb;
    o.s0_axi_bready  := i.m0_axi_bready;
    o.s0_axi_arvalid := i.m0_axi_arvalid;
    o.s0_axi_araddr  := i.m0_axi_araddr;
    o.s0_axi_arprot  := i.m0_axi_arprot;
    o.s0_axi_rready  := i.m0_axi_rready;
    return o;
  end;

  function axi3_master_slave_connect (
    i : in t_AXI3_512_SLAVE_OUTPUT
    ) return t_AXI3_512_MASTER_INPUT is
    variable o : t_AXI3_512_MASTER_INPUT;

  begin
    o.m0_axi_awready := i.s0_axi_awready;
    o.m0_axi_wready  := i.s0_axi_wready;
    o.m0_axi_bid     := i.s0_axi_bid;
    o.m0_axi_bresp   := i.s0_axi_bresp;
    o.m0_axi_bvalid  := i.s0_axi_bvalid;
    o.m0_axi_arready := i.s0_axi_arready;
    o.m0_axi_rid     := i.s0_axi_rid;
    o.m0_axi_rdata   := i.s0_axi_rdata;
    o.m0_axi_rresp   := i.s0_axi_rresp;
    o.m0_axi_rlast   := i.s0_axi_rlast;
    o.m0_axi_ruser   := i.s0_axi_ruser;
    o.m0_axi_rvalid  := i.s0_axi_rvalid;
    return o;
  end;

  function axi3_master_slave_connect (
    i : in t_AXI3_512_MASTER_OUTPUT
    ) return t_AXI3_512_SLAVE_INPUT is
    variable o : t_AXI3_512_SLAVE_INPUT;

  begin
    o.s0_axi_aresetn := i.m0_axi_aresetn;
    o.s0_axi_awid    := i.m0_axi_awid;
    o.s0_axi_awaddr  := i.m0_axi_awaddr;
    o.s0_axi_awlen   := i.m0_axi_awlen;
    o.s0_axi_awsize  := i.m0_axi_awsize;
    o.s0_axi_awburst := i.m0_axi_awburst;
    o.s0_axi_awlock  := i.m0_axi_awlock;
    o.s0_axi_awcache := i.m0_axi_awcache;
    o.s0_axi_awprot  := i.m0_axi_awprot;
    o.s0_axi_awvalid := i.m0_axi_awvalid;
    o.s0_axi_wid     := i.m0_axi_wid;
    o.s0_axi_wdata   := i.m0_axi_wdata;
    o.s0_axi_wstrb   := i.m0_axi_wstrb;
    o.s0_axi_wlast   := i.m0_axi_wlast;
    o.s0_axi_wvalid  := i.m0_axi_wvalid;
    o.s0_axi_bready  := i.m0_axi_bready;
    o.s0_axi_arid    := i.m0_axi_arid;
    o.s0_axi_araddr  := i.m0_axi_araddr;
    o.s0_axi_arlen   := i.m0_axi_arlen;
    o.s0_axi_arsize  := i.m0_axi_arsize;
    o.s0_axi_arburst := i.m0_axi_arburst;
    o.s0_axi_arlock  := i.m0_axi_arlock;
    o.s0_axi_arcache := i.m0_axi_arcache;
    o.s0_axi_arprot  := i.m0_axi_arprot;
    o.s0_axi_arvalid := i.m0_axi_arvalid;
    o.s0_axi_rready  := i.m0_axi_rready;
    o.s0_axi_aresetn := i.m0_axi_aresetn;
    o.s0_axi_awvalid := i.m0_axi_awvalid;
    o.s0_axi_awaddr  := i.m0_axi_awaddr;
    o.s0_axi_awprot  := i.m0_axi_awprot;
    o.s0_axi_wvalid  := i.m0_axi_wvalid;
    o.s0_axi_wdata   := i.m0_axi_wdata;
    o.s0_axi_wstrb   := i.m0_axi_wstrb;
    o.s0_axi_bready  := i.m0_axi_bready;
    o.s0_axi_arvalid := i.m0_axi_arvalid;
    o.s0_axi_araddr  := i.m0_axi_araddr;
    o.s0_axi_arprot  := i.m0_axi_arprot;
    o.s0_axi_rready  := i.m0_axi_rready;
    return o;
  end;

  function axi3_master_slave_connect (
    i : in t_AXI3_64_SLAVE_OUTPUT
    ) return t_AXI3_64_MASTER_INPUT is
    variable o : t_AXI3_64_MASTER_INPUT;

  begin
    o.m0_axi_awready := i.s0_axi_awready;
    o.m0_axi_wready  := i.s0_axi_wready;
    o.m0_axi_bid     := i.s0_axi_bid;
    o.m0_axi_bresp   := i.s0_axi_bresp;
    o.m0_axi_bvalid  := i.s0_axi_bvalid;
    o.m0_axi_arready := i.s0_axi_arready;
    o.m0_axi_rid     := i.s0_axi_rid;
    o.m0_axi_rdata   := i.s0_axi_rdata;
    o.m0_axi_rresp   := i.s0_axi_rresp;
    o.m0_axi_rlast   := i.s0_axi_rlast;
    o.m0_axi_rvalid  := i.s0_axi_rvalid;
    return o;
  end;

  function axi3_master_slave_connect (
    i : in t_AXI3_64_MASTER_OUTPUT
    ) return t_AXI3_64_SLAVE_INPUT is
    variable o : t_AXI3_64_SLAVE_INPUT;

  begin
    o.s0_axi_aresetn := i.m0_axi_aresetn;
    o.s0_axi_awid    := i.m0_axi_awid;
    o.s0_axi_awaddr  := i.m0_axi_awaddr;
    o.s0_axi_awlen   := i.m0_axi_awlen;
    o.s0_axi_awsize  := i.m0_axi_awsize;
    o.s0_axi_awburst := i.m0_axi_awburst;
    o.s0_axi_awlock  := i.m0_axi_awlock;
    o.s0_axi_awcache := i.m0_axi_awcache;
    o.s0_axi_awprot  := i.m0_axi_awprot;
    o.s0_axi_awvalid := i.m0_axi_awvalid;
    o.s0_axi_wid     := i.m0_axi_wid;
    o.s0_axi_wdata   := i.m0_axi_wdata;
    o.s0_axi_wstrb   := i.m0_axi_wstrb;
    o.s0_axi_wlast   := i.m0_axi_wlast;
    o.s0_axi_wvalid  := i.m0_axi_wvalid;
    o.s0_axi_bready  := i.m0_axi_bready;
    o.s0_axi_arid    := i.m0_axi_arid;
    o.s0_axi_araddr  := i.m0_axi_araddr;
    o.s0_axi_arlen   := i.m0_axi_arlen;
    o.s0_axi_arsize  := i.m0_axi_arsize;
    o.s0_axi_arburst := i.m0_axi_arburst;
    o.s0_axi_arlock  := i.m0_axi_arlock;
    o.s0_axi_arcache := i.m0_axi_arcache;
    o.s0_axi_arprot  := i.m0_axi_arprot;
    o.s0_axi_arvalid := i.m0_axi_arvalid;
    o.s0_axi_rready  := i.m0_axi_rready;
    o.s0_axi_aresetn := i.m0_axi_aresetn;
    o.s0_axi_awvalid := i.m0_axi_awvalid;
    o.s0_axi_awaddr  := i.m0_axi_awaddr;
    o.s0_axi_awprot  := i.m0_axi_awprot;
    o.s0_axi_wvalid  := i.m0_axi_wvalid;
    o.s0_axi_wdata   := i.m0_axi_wdata;
    o.s0_axi_wstrb   := i.m0_axi_wstrb;
    o.s0_axi_bready  := i.m0_axi_bready;
    o.s0_axi_arvalid := i.m0_axi_arvalid;
    o.s0_axi_araddr  := i.m0_axi_araddr;
    o.s0_axi_arprot  := i.m0_axi_arprot;
    o.s0_axi_rready  := i.m0_axi_rready;
    return o;
  end;

  function axi4_master_slave_connect (
    i : in t_AXI4_SLAVE_OUTPUT
    ) return t_AXI4_MASTER_INPUT is
    variable o : t_AXI4_MASTER_INPUT;

  begin
    o.m0_axi_awready := i.s0_axi_awready;
    o.m0_axi_wready  := i.s0_axi_wready;
    o.m0_axi_bid     := i.s0_axi_bid;
    o.m0_axi_bresp   := i.s0_axi_bresp;
    o.m0_axi_bvalid  := i.s0_axi_bvalid;
    o.m0_axi_arready := i.s0_axi_arready;
    o.m0_axi_rid     := i.s0_axi_rid;
    o.m0_axi_rdata   := i.s0_axi_rdata;
    o.m0_axi_rresp   := i.s0_axi_rresp;
    o.m0_axi_rlast   := i.s0_axi_rlast;
    o.m0_axi_rvalid  := i.s0_axi_rvalid;
    return o;
  end;

  function axi4_master_slave_connect (
    i : in t_AXI4_MASTER_OUTPUT
    ) return t_AXI4_SLAVE_INPUT is
    variable o : t_AXI4_SLAVE_INPUT;

  begin
    o.s0_axi_aresetn := i.m0_axi_aresetn;
    o.s0_axi_awid    := i.m0_axi_awid;
    o.s0_axi_awaddr  := i.m0_axi_awaddr;
    o.s0_axi_awlen   := i.m0_axi_awlen;
    o.s0_axi_awsize  := i.m0_axi_awsize;
    o.s0_axi_awburst := i.m0_axi_awburst;
    o.s0_axi_awlock  := i.m0_axi_awlock;
    o.s0_axi_awcache := i.m0_axi_awcache;
    o.s0_axi_awprot  := i.m0_axi_awprot;
    o.s0_axi_awvalid := i.m0_axi_awvalid;
    o.s0_axi_wdata   := i.m0_axi_wdata;
    o.s0_axi_wstrb   := i.m0_axi_wstrb;
    o.s0_axi_wlast   := i.m0_axi_wlast;
    o.s0_axi_wvalid  := i.m0_axi_wvalid;
    o.s0_axi_bready  := i.m0_axi_bready;
    o.s0_axi_arid    := i.m0_axi_arid;
    o.s0_axi_araddr  := i.m0_axi_araddr;
    o.s0_axi_arlen   := i.m0_axi_arlen;
    o.s0_axi_arsize  := i.m0_axi_arsize;
    o.s0_axi_arburst := i.m0_axi_arburst;
    o.s0_axi_arlock  := i.m0_axi_arlock;
    o.s0_axi_arcache := i.m0_axi_arcache;
    o.s0_axi_arprot  := i.m0_axi_arprot;
    o.s0_axi_arvalid := i.m0_axi_arvalid;
    o.s0_axi_rready  := i.m0_axi_rready;
    o.s0_axi_aresetn := i.m0_axi_aresetn;
    o.s0_axi_awvalid := i.m0_axi_awvalid;
    o.s0_axi_awaddr  := i.m0_axi_awaddr;
    o.s0_axi_awprot  := i.m0_axi_awprot;
    o.s0_axi_wvalid  := i.m0_axi_wvalid;
    o.s0_axi_wdata   := i.m0_axi_wdata;
    o.s0_axi_wstrb   := i.m0_axi_wstrb;
    o.s0_axi_bready  := i.m0_axi_bready;
    o.s0_axi_arvalid := i.m0_axi_arvalid;
    o.s0_axi_araddr  := i.m0_axi_araddr;
    o.s0_axi_arprot  := i.m0_axi_arprot;
    o.s0_axi_rready  := i.m0_axi_rready;
    return o;
  end;

  function de_bin2gray(A:std_ulogic_vector)
           return std_ulogic_vector is
    constant len: positive := A'length;
    alias binval: std_ulogic_vector(0 to len -1)
                       is A;
    variable grayval: std_ulogic_vector(0 to len - 1);
  
  begin
     grayval(0) := binval(0);
     for i in 1 to len-1 loop
        grayval(i) := binval(i-1)  
                              xor binval(i);   
     end loop;
     return grayval;
  end;
  
  function de_gray2bin(A:std_ulogic_vector)
           return std_ulogic_vector is
    constant len: positive := A'length;
    alias grayval: std_ulogic_vector(0 to len -1)
                       is A;
    variable binval: std_ulogic_vector(0 to len - 1);
  begin
    binval(0) := grayval(0);
     for i in 1 to len-1 loop
        binval(i) := binval(i-1)
                              xor grayval(i);
     end loop;
     return binval;
  end;

end package body axi_pkg;
