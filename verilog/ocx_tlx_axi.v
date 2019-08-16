`timescale 1ns / 10ps
//
// Copyright 2019 International Business Machines
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
//
// The patent license granted to you in Section 3 of the License, as applied
// to the "Work," hereby includes implementations of the Work in physical form.
//
// Unless required by applicable law or agreed to in writing, the reference design
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// The background Specification upon which this is based is managed by and available from
// the OpenCAPI Consortium.  More information can be found at https://opencapi.org.
//

`include "oc_pkg.v"

module ocx_tlx_axi
  #(
    parameter ADDR_WIDTH = 64,
    parameter AXI_DATA_WIDTH = 32, // Not Used for FBIST
    parameter OC_DATA_WIDTH = 64,  // Not Used for FBIST
    parameter ID_WIDTH = 7,
    parameter FBIST_ID_WIDTH = 12 // Assume FBIST_ID_WIDTH > ID_WIDTH
  ) (
   // Global
   input                        s0_axi_aclk,
   input                        s0_axi_aresetn,

   // Write Address Channel
   input [ID_WIDTH-1:0]         s0_axi_awid,
   input [ADDR_WIDTH-1:0]       s0_axi_awaddr,
   input [7:0]                  s0_axi_awlen,
   input [2:0]                  s0_axi_awsize,
   input [1:0]                  s0_axi_awburst,
   input [1:0]                  s0_axi_awlock,
   input [3:0]                  s0_axi_awcache,
   input [2:0]                  s0_axi_awprot,
   input                        s0_axi_awvalid,
   output                       s0_axi_awready,

   // Write Data Channel
   input [ID_WIDTH-1:0]         s0_axi_wid,
   input [AXI_DATA_WIDTH-1:0]   s0_axi_wdata,
   input [AXI_DATA_WIDTH/8-1:0] s0_axi_wstrb,
   input                        s0_axi_wlast,
   input                        s0_axi_wvalid,
   output                       s0_axi_wready,

   // Write Response Channel
   output [ID_WIDTH-1:0]        s0_axi_bid,
   output [1:0]                 s0_axi_bresp,
   output                       s0_axi_bvalid,
   input                        s0_axi_bready,

   // Read Address Channel
   input [ID_WIDTH-1:0]         s0_axi_arid,
   input [ADDR_WIDTH-1:0]       s0_axi_araddr,
   input [7:0]                  s0_axi_arlen,
   input [2:0]                  s0_axi_arsize,
   input [1:0]                  s0_axi_arburst,
   input [1:0]                  s0_axi_arlock,
   input [3:0]                  s0_axi_arcache,
   input [2:0]                  s0_axi_arprot,
   input                        s0_axi_arvalid,
   output                       s0_axi_arready,

   // Read Data Channel
   output [ID_WIDTH-1:0]        s0_axi_rid,
   output [AXI_DATA_WIDTH-1:0]  s0_axi_rdata,
   output [1:0]                 s0_axi_rresp,
   output                       s0_axi_rlast,
   output                       s0_axi_rvalid,
   input                        s0_axi_rready,

   // Global
   input                        s1_axi_aclk,
   input                        s1_axi_aresetn,

   // Write Address Channel
   input [ID_WIDTH-1:0]         s1_axi_awid,
   input [ADDR_WIDTH-1:0]       s1_axi_awaddr,
   input [7:0]                  s1_axi_awlen,
   input [2:0]                  s1_axi_awsize,
   input [1:0]                  s1_axi_awburst,
   input [1:0]                  s1_axi_awlock,
   input [3:0]                  s1_axi_awcache,
   input [2:0]                  s1_axi_awprot,
   input                        s1_axi_awvalid,
   output                       s1_axi_awready,

   // Write Data Channel
   input [ID_WIDTH-1:0]         s1_axi_wid,
   input [AXI_DATA_WIDTH-1:0]   s1_axi_wdata,
   input [AXI_DATA_WIDTH/8-1:0] s1_axi_wstrb,
   input                        s1_axi_wlast,
   input                        s1_axi_wvalid,
   output                       s1_axi_wready,

   // Write Response Channel
   output [ID_WIDTH-1:0]        s1_axi_bid,
   output [1:0]                 s1_axi_bresp,
   output                       s1_axi_bvalid,
   input                        s1_axi_bready,

   // Read Address Channel
   input [ID_WIDTH-1:0]         s1_axi_arid,
   input [ADDR_WIDTH-1:0]       s1_axi_araddr,
   input [7:0]                  s1_axi_arlen,
   input [2:0]                  s1_axi_arsize,
   input [1:0]                  s1_axi_arburst,
   input [1:0]                  s1_axi_arlock,
   input [3:0]                  s1_axi_arcache,
   input [2:0]                  s1_axi_arprot,
   input                        s1_axi_arvalid,
   output                       s1_axi_arready,

   // Read Data Channel
   output [ID_WIDTH-1:0]        s1_axi_rid,
   output [AXI_DATA_WIDTH-1:0]  s1_axi_rdata,
   output [1:0]                 s1_axi_rresp,
   output                       s1_axi_rlast,
   output                       s1_axi_rvalid,
   input                        s1_axi_rready,

   // Global
   input                        s2_axi_aclk,
   input                        s2_axi_aresetn,

   // Write Address Channel
   input [ID_WIDTH-1:0]         s2_axi_awid,
   input [ADDR_WIDTH-1:0]       s2_axi_awaddr,
   input [7:0]                  s2_axi_awlen,
   input [2:0]                  s2_axi_awsize,
   input [1:0]                  s2_axi_awburst,
   input [1:0]                  s2_axi_awlock,
   input [3:0]                  s2_axi_awcache,
   input [2:0]                  s2_axi_awprot,
   input                        s2_axi_awvalid,
   output                       s2_axi_awready,

   // Write Data Channel
   input [ID_WIDTH-1:0]         s2_axi_wid,
   input [AXI_DATA_WIDTH-1:0]   s2_axi_wdata,
   input [AXI_DATA_WIDTH/8-1:0] s2_axi_wstrb,
   input                        s2_axi_wlast,
   input                        s2_axi_wvalid,
   output                       s2_axi_wready,

   // Write Response Channel
   output [ID_WIDTH-1:0]        s2_axi_bid,
   output [1:0]                 s2_axi_bresp,
   output                       s2_axi_bvalid,
   input                        s2_axi_bready,

   // Read Address Channel
   input [ID_WIDTH-1:0]         s2_axi_arid,
   input [ADDR_WIDTH-1:0]       s2_axi_araddr,
   input [7:0]                  s2_axi_arlen,
   input [2:0]                  s2_axi_arsize,
   input [1:0]                  s2_axi_arburst,
   input [1:0]                  s2_axi_arlock,
   input [3:0]                  s2_axi_arcache,
   input [2:0]                  s2_axi_arprot,
   input                        s2_axi_arvalid,
   output                       s2_axi_arready,

   // Read Data Channel
   output [ID_WIDTH-1:0]        s2_axi_rid,
   output [AXI_DATA_WIDTH-1:0]  s2_axi_rdata,
   output [1:0]                 s2_axi_rresp,
   output                       s2_axi_rlast,
   output                       s2_axi_rvalid,
   input                        s2_axi_rready,

   // Global
   input                        s3_axi_aclk,
   input                        s3_axi_aresetn,

   // Write Address Channel
   input [FBIST_ID_WIDTH-1:0]   s3_axi_awid,
   input [ADDR_WIDTH-1:0]       s3_axi_awaddr,
   input [7:0]                  s3_axi_awlen,
   input [2:0]                  s3_axi_awsize,
   input [1:0]                  s3_axi_awburst,
   input [1:0]                  s3_axi_awlock,
   input [3:0]                  s3_axi_awcache,
   input [2:0]                  s3_axi_awprot,
   input                        s3_axi_awvalid,
   output                       s3_axi_awready,

   // Write Data Channel
   input [FBIST_ID_WIDTH-1:0]   s3_axi_wid,
   input [511:0]                s3_axi_wdata,
   input [511/8:0]              s3_axi_wstrb,
   input                        s3_axi_wlast,
   input                        s3_axi_wvalid,
   output                       s3_axi_wready,

   // Write Response Channel
   output [FBIST_ID_WIDTH-1:0]  s3_axi_bid,
   output [1:0]                 s3_axi_bresp,
   output                       s3_axi_bvalid,
   input                        s3_axi_bready,

   // Read Address Channel
   input [FBIST_ID_WIDTH-1:0]   s3_axi_arid,
   input [ADDR_WIDTH-1:0]       s3_axi_araddr,
   input [7:0]                  s3_axi_arlen,
   input [2:0]                  s3_axi_arsize,
   input [1:0]                  s3_axi_arburst,
   input [1:0]                  s3_axi_arlock,
   input [3:0]                  s3_axi_arcache,
   input [2:0]                  s3_axi_arprot,
   input                        s3_axi_arvalid,
   output                       s3_axi_arready,

   // Read Data Channel
   output [FBIST_ID_WIDTH-1:0]  s3_axi_rid,
   output [511:0]               s3_axi_rdata,
   output [1:0]                 s3_axi_rresp,
   output                       s3_axi_rlast,
   output [2:0]                 s3_axi_ruser,
   output                       s3_axi_rvalid,
   input                        s3_axi_rready,

   // TL Command Interface
   // Command
   input [3 : 0]                tlx_afu_cmd_initial_credit,
   input                        tlx_afu_cmd_credit,
   output                       afu_tlx_cmd_valid,
   output [ 7:0]                afu_tlx_cmd_opcode,
   output [ 63:0]               afu_tlx_cmd_pa_or_obj,
   output [ 15:0]               afu_tlx_cmd_afutag,
   output [ 1:0]                afu_tlx_cmd_dl,
   output [ 2:0]                afu_tlx_cmd_pl,
   output [ 63:0]               afu_tlx_cmd_be,
   output [ 3:0]                afu_tlx_cmd_flag,
   output [ 15:0]               afu_tlx_cmd_bdf,
   output [ 3:0]                afu_tlx_cmd_resp_code,
   output [ 15:0]               afu_tlx_cmd_capptag,

   // Command data
   input [ 5 : 0]               tlx_afu_cmd_data_initial_credit,
   input                        tlx_afu_cmd_data_credit,
   output                       afu_tlx_cdata_valid,
   output [511:0]               afu_tlx_cdata_bus,
   output                       afu_tlx_cdata_bdi,

   // Response
   output [ 6:0]                afu_tlx_resp_initial_credit,
   output                       afu_tlx_resp_credit,
   input                        tlx_afu_resp_valid,
   input [ 7:0]                 tlx_afu_resp_opcode,
   input [ 15:0]                tlx_afu_resp_afutag,
   input [ 3:0]                 tlx_afu_resp_code,
   input [ 5:0]                 tlx_afu_resp_pg_size,
   input [ 1:0]                 tlx_afu_resp_dl,
   input [ 1:0]                 tlx_afu_resp_dp,
   input [ 23:0]                tlx_afu_resp_host_tag,
   input [ 3:0]                 tlx_afu_resp_cache_state,
   input [ 17:0]                tlx_afu_resp_addr_tag,

   // Response data
   output                       afu_tlx_resp_rd_req,
   output [ 2:0]                afu_tlx_resp_rd_cnt,
   input                        tlx_afu_resp_data_valid,
   input                        tlx_afu_resp_data_bdi,
   input [511:0]                tlx_afu_resp_data_bus,

   // Mem_cntl
   input                        memcntl_oc_cmd_ready,
   input [ 3:0]                 memcntl_oc_cmd_flag,
   input [ 15:0]                memcntl_oc_cmd_tag,
   output                       oc_memcntl_taken,

   // Configuration
   input [63:0]                 cfg_bar
   );

   wire [7 : 0]                  oc_write_command_ready_opcode_eff;
   wire [ADDR_WIDTH - 1 : 0]     oc_write_command_ready_address_eff;
   wire [7 : 0]                  oc_write_command_ready_length;
   wire [1023 : 0]               oc_write_command_ready_data;
   wire                          oc_write_command_ready;
   wire [15 : 0]                 oc_write_command_ready_id_eff;
   wire                          oc_write_command_taken;
   wire                          oc_trans_bvalid;
   wire [FBIST_ID_WIDTH - 1 : 0] oc_trans_bid;
   wire [1 : 0]                  oc_trans_bresp;
   wire [7 : 0]                  oc_read_command_ready_opcode_eff;
   wire [ADDR_WIDTH - 1 : 0]     oc_read_command_ready_address_eff;
   wire [7 : 0]                  oc_read_command_ready_length;
   wire                          oc_read_command_ready;
   wire [15 : 0]                 oc_read_command_ready_id_eff;
   wire                          oc_read_command_taken;
   wire                          oc_trans_rvalid;
   wire [FBIST_ID_WIDTH - 1 : 0] oc_trans_rid;
   wire [1023 : 0]               oc_trans_rdata;
   wire [1 : 0]                  oc_trans_rresp;
   wire [2 : 0]                  oc_trans_ruser;
   wire [FBIST_ID_WIDTH - 1 : 0] outstanding_oc_lookup_id;
   wire [ADDR_WIDTH - 1 : 0]     outstanding_read_araddr_oc_lookup;
   wire [7 : 0]                  outstanding_read_arlen_oc_lookup;
   wire                          command_credits_available;
   wire                          data_credits_available;
   wire [3 : 0]                  command_credits_available_count_d;
   reg  [3 : 0]                  command_credits_available_count_q = 4'b1000;
   wire [5 : 0]                  data_credits_available_count_d;
   reg  [5 : 0]                  data_credits_available_count_q = 6'b100000;

   wire [ADDR_WIDTH - 1 : 0]    mmio_oc_write_command_ready_address;
   wire [7 : 0]                 mmio_oc_write_command_ready_length;
   wire [OC_DATA_WIDTH - 1 : 0] mmio_oc_write_command_ready_data;
   wire                         mmio_oc_write_command_ready;
   wire [ID_WIDTH - 1 : 0]      mmio_oc_write_command_ready_id;
   wire                         mmio_oc_write_command_taken;
   wire                         mmio_oc_trans_bvalid;
   wire [ID_WIDTH - 1 : 0]      mmio_oc_trans_bid;
   wire [1 : 0]                 mmio_oc_trans_bresp;
   wire [ADDR_WIDTH - 1 : 0]    mmio_oc_read_command_ready_address;
   wire [7 : 0]                 mmio_oc_read_command_ready_length;
   wire                         mmio_oc_read_command_ready;
   wire [ID_WIDTH - 1 : 0]      mmio_oc_read_command_ready_id;
   wire                         mmio_oc_read_command_taken;
   wire                         mmio_oc_trans_rvalid;
   wire [ID_WIDTH - 1 : 0]      mmio_oc_trans_rid;
   wire [OC_DATA_WIDTH - 1 : 0] mmio_oc_trans_rdata;
   wire [1 : 0]                 mmio_oc_trans_rresp;
   wire [2 : 0]                 mmio_oc_trans_ruser;
   wire [ID_WIDTH - 1 : 0]      mmio_outstanding_oc_lookup_id;
   wire [ADDR_WIDTH - 1 : 0]    mmio_outstanding_read_araddr_oc_lookup;
   wire [7 : 0]                 mmio_outstanding_read_arlen_oc_lookup;

   wire [ADDR_WIDTH - 1 : 0]    memory_oc_write_command_ready_address;
   wire [7 : 0]                 memory_oc_write_command_ready_length;
   wire [OC_DATA_WIDTH - 1 : 0] memory_oc_write_command_ready_data;
   wire                         memory_oc_write_command_ready;
   wire [ID_WIDTH - 1 : 0]      memory_oc_write_command_ready_id;
   wire                         memory_oc_write_command_taken;
   wire                         memory_oc_trans_bvalid;
   wire [ID_WIDTH - 1 : 0]      memory_oc_trans_bid;
   wire [1 : 0]                 memory_oc_trans_bresp;
   wire [ADDR_WIDTH - 1 : 0]    memory_oc_read_command_ready_address;
   wire [7 : 0]                 memory_oc_read_command_ready_length;
   wire                         memory_oc_read_command_ready;
   wire [ID_WIDTH - 1 : 0]      memory_oc_read_command_ready_id;
   wire                         memory_oc_read_command_taken;
   wire                         memory_oc_trans_rvalid;
   wire [ID_WIDTH - 1 : 0]      memory_oc_trans_rid;
   wire [OC_DATA_WIDTH - 1 : 0] memory_oc_trans_rdata;
   wire [1 : 0]                 memory_oc_trans_rresp;
   wire [2 : 0]                 memory_oc_trans_ruser;
   wire [ID_WIDTH - 1 : 0]      memory_outstanding_oc_lookup_id;
   wire [ADDR_WIDTH - 1 : 0]    memory_outstanding_read_araddr_oc_lookup;
   wire [7 : 0]                 memory_outstanding_read_arlen_oc_lookup;

   wire [ADDR_WIDTH - 1 : 0]    cfg_oc_write_command_ready_address;
   wire [7 : 0]                 cfg_oc_write_command_ready_length;
   wire [OC_DATA_WIDTH - 1 : 0] cfg_oc_write_command_ready_data;
   wire                         cfg_oc_write_command_ready;
   wire [ID_WIDTH - 1 : 0]      cfg_oc_write_command_ready_id;
   wire                         cfg_oc_write_command_taken;
   wire                         cfg_oc_trans_bvalid;
   wire [ID_WIDTH - 1 : 0]      cfg_oc_trans_bid;
   wire [1 : 0]                 cfg_oc_trans_bresp;
   wire [ADDR_WIDTH - 1 : 0]    cfg_oc_read_command_ready_address;
   wire [7 : 0]                 cfg_oc_read_command_ready_length;
   wire                         cfg_oc_read_command_ready;
   wire [ID_WIDTH - 1  : 0]     cfg_oc_read_command_ready_id;
   wire                         cfg_oc_read_command_taken;
   wire                         cfg_oc_trans_rvalid;
   wire [ID_WIDTH - 1 : 0]      cfg_oc_trans_rid;
   wire [OC_DATA_WIDTH - 1 : 0] cfg_oc_trans_rdata;
   wire [1 : 0]                 cfg_oc_trans_rresp;
   wire [2 : 0]                 cfg_oc_trans_ruser;
   wire [ID_WIDTH - 1 : 0]      cfg_outstanding_oc_lookup_id;
   wire [ADDR_WIDTH - 1 : 0]    cfg_outstanding_read_araddr_oc_lookup;
   wire [7 : 0]                 cfg_outstanding_read_arlen_oc_lookup;

   wire [ADDR_WIDTH - 1 : 0]      fbist_oc_write_command_ready_address;
   wire [7 : 0]                   fbist_oc_write_command_ready_length;
   wire [2 : 0]                   fbist_oc_write_command_ready_size; // Only FBIST uses size
   wire [511 : 0]                 fbist_oc_write_command_ready_data;
   wire [511 : 0]                 fbist_oc_write_command_ready_data2;
   wire                           fbist_oc_write_command_ready;
   wire [FBIST_ID_WIDTH - 1 : 0]  fbist_oc_write_command_ready_id;
   wire                           fbist_oc_write_command_taken;
   wire                           fbist_oc_trans_bvalid;
   wire [FBIST_ID_WIDTH - 1 : 0]  fbist_oc_trans_bid;
   wire [1 : 0]                   fbist_oc_trans_bresp;
   wire [ADDR_WIDTH - 1 : 0]      fbist_oc_read_command_ready_address;
   wire [7 : 0]                   fbist_oc_read_command_ready_length;
   wire [2 : 0]                   fbist_oc_read_command_ready_size;
   wire                           fbist_oc_read_command_ready;
   wire [FBIST_ID_WIDTH - 1  : 0] fbist_oc_read_command_ready_id;
   wire                           fbist_oc_read_command_taken;
   wire                           fbist_oc_trans_rvalid;
   wire [FBIST_ID_WIDTH - 1 : 0]  fbist_oc_trans_rid;
   wire [511 : 0]                 fbist_oc_trans_rdata;
   wire [1 : 0]                   fbist_oc_trans_rresp;
   wire [2 : 0]                   fbist_oc_trans_ruser;
   wire [FBIST_ID_WIDTH - 1 : 0]  fbist_outstanding_oc_lookup_id;
   wire [ADDR_WIDTH - 1 : 0]      fbist_outstanding_read_araddr_oc_lookup;
   wire [7 : 0]                   fbist_outstanding_read_arlen_oc_lookup;
   wire [2 : 0]                   fbist_outstanding_read_arsize_oc_lookup;

   wire [15:0]               tlx_afu_resp_capptag;
   reg [ 1:0]                afu_tlx_cmd_dl_q;

   //Debug latches
   reg               tlx_afu_resp_valid_q;
   reg [ 7:0]        tlx_afu_resp_opcode_q;
   reg               tlx_afu_resp_valid_1;
   reg [ 7:0]        tlx_afu_resp_opcode_1;
   (* mark_debug = "true" *) reg                     tlx_afu_resp_valid_2;
   (* mark_debug = "true" *) reg [ 7:0]              tlx_afu_resp_opcode_2;

   reg                          oc_trans_bvalid_q;
   reg                          oc_trans_rvalid_q;
   reg                          oc_trans_bvalid_1;
   reg                          oc_trans_rvalid_1;
   (* mark_debug = "true" *) reg                          oc_trans_bvalid_2;
   (* mark_debug = "true" *) reg                          oc_trans_rvalid_2;


   /*
    * OpenCAPI Command Channel
    */
   parameter ST_OC_COMMAND_IDLE_WR_PRIORITY = 3'b000;
   parameter ST_OC_COMMAND_IDLE_RD_PRIORITY = 3'b001;
   parameter ST_OC_COMMAND_WR = 3'b010;
   parameter ST_OC_COMMAND_WR_2 = 3'b011;
   parameter ST_OC_COMMAND_RD = 3'b100;
   parameter ST_OC_COMMAND_MCR = 3'b101;
   parameter ST_OC_COMMAND_MCW = 3'b110;
   parameter ST_OC_COMMAND_ERROR = 3'b111;

   wire [2:0]                oc_command_state_d;
   reg [2:0]                 oc_command_state_q;

   wire [7:0]                random8;
   wire                      mc_slot;

   ocx_tlx_random
   rand_8
     (
      .clock         (s0_axi_aclk),
      .resetn        (s0_axi_aresetn),
      .rand          (random8)
     );

   assign mc_slot = random8[0]; // half the time

   wire need_wr_2_d;
   reg  need_wr_2_q;
   assign need_wr_2_d = (oc_write_command_ready_length == 8'b00011111);

                                                                                 // command_credits_available refers to space in the 8 deep command fifo in ocx_tlx_framer.v and not to anything in ocmb
   assign oc_command_state_d = (oc_command_state_q == ST_OC_COMMAND_IDLE_WR_PRIORITY) ? ((memcntl_oc_cmd_ready && mc_slot && command_credits_available                 ) ? ST_OC_COMMAND_MCW :
                                                                                         (oc_write_command_ready && command_credits_available && data_credits_available) ? ST_OC_COMMAND_WR :
                                                                                         (oc_read_command_ready  && command_credits_available)                           ? ST_OC_COMMAND_RD :
                                                                                         ST_OC_COMMAND_IDLE_WR_PRIORITY) :
                               (oc_command_state_q == ST_OC_COMMAND_IDLE_RD_PRIORITY) ? ((memcntl_oc_cmd_ready && mc_slot && command_credits_available)                  ? ST_OC_COMMAND_MCR :
                                                                                         (oc_read_command_ready  && command_credits_available)                           ? ST_OC_COMMAND_RD :
                                                                                         (oc_write_command_ready && command_credits_available && data_credits_available) ? ST_OC_COMMAND_WR :
                                                                                         ST_OC_COMMAND_IDLE_RD_PRIORITY) :
                               (oc_command_state_q == ST_OC_COMMAND_WR) ? (need_wr_2_q                                    ? ST_OC_COMMAND_WR_2 :
                                                                           ST_OC_COMMAND_IDLE_RD_PRIORITY) :
                               (oc_command_state_q == ST_OC_COMMAND_WR_2) ? ST_OC_COMMAND_IDLE_RD_PRIORITY :
                               (oc_command_state_q == ST_OC_COMMAND_RD) ? ST_OC_COMMAND_IDLE_WR_PRIORITY :
                               (oc_command_state_q == ST_OC_COMMAND_MCW) ? ST_OC_COMMAND_IDLE_WR_PRIORITY :
                               (oc_command_state_q == ST_OC_COMMAND_MCR) ? ST_OC_COMMAND_IDLE_RD_PRIORITY :
                               ST_OC_COMMAND_ERROR;

   assign oc_memcntl_taken = ((oc_command_state_d == ST_OC_COMMAND_MCR) | (oc_command_state_d == ST_OC_COMMAND_MCW));
   assign oc_write_command_taken = ((oc_command_state_d == ST_OC_COMMAND_WR) & oc_write_command_ready_length != 8'b00011111) | (oc_command_state_d == ST_OC_COMMAND_WR_2);
   assign oc_read_command_taken = (oc_command_state_d == ST_OC_COMMAND_RD);

   // Command and command data credits
   // Writes need both command and data; reads only need command
   assign command_credits_available_count_d[3:0] =  (oc_command_state_q == ST_OC_COMMAND_WR || oc_command_state_q == ST_OC_COMMAND_RD || oc_command_state_q == ST_OC_COMMAND_MCR || oc_command_state_q == ST_OC_COMMAND_MCW) &&  tlx_afu_cmd_credit ? command_credits_available_count_q :     // Use and receive credit
                                                    (oc_command_state_q == ST_OC_COMMAND_WR || oc_command_state_q == ST_OC_COMMAND_RD || oc_command_state_q == ST_OC_COMMAND_MCR || oc_command_state_q == ST_OC_COMMAND_MCW) && ~tlx_afu_cmd_credit ? command_credits_available_count_q - 1 : // Use credit
                                                   ~(oc_command_state_q == ST_OC_COMMAND_WR || oc_command_state_q == ST_OC_COMMAND_RD || oc_command_state_q == ST_OC_COMMAND_MCR || oc_command_state_q == ST_OC_COMMAND_MCW) &&  tlx_afu_cmd_credit ? command_credits_available_count_q + 1 : // Receive credit
                                                                                                                                                                command_credits_available_count_q;      // Neither use nor receive
   assign data_credits_available_count_d[5:0] = ~(oc_command_state_q == ST_OC_COMMAND_WR) &&                              tlx_afu_cmd_data_credit ? data_credits_available_count_q + 1 : // Receive credit
                                                 (oc_command_state_q == ST_OC_COMMAND_WR) && ~(afu_tlx_cmd_dl_q == 2'b10) && ~tlx_afu_cmd_data_credit ? data_credits_available_count_q - 1 : // Use credit for !128B op
                                                 (oc_command_state_q == ST_OC_COMMAND_WR) &&  (afu_tlx_cmd_dl_q == 2'b10) && ~tlx_afu_cmd_data_credit ? data_credits_available_count_q - 2 : // Use credit for 128B op
                                                 (oc_command_state_q == ST_OC_COMMAND_WR) &&  (afu_tlx_cmd_dl_q == 2'b10) &&  tlx_afu_cmd_data_credit ? data_credits_available_count_q - 1 : // Use credit for 128B op and receive credit
                                                                                                                                                    data_credits_available_count_q;      // Otherwise use and receive cancel out

   assign command_credits_available = command_credits_available_count_d != 4'b0; // Use the _d values to save a cycle on credit turnaround
   assign data_credits_available = data_credits_available_count_d != 6'b0 & data_credits_available_count_d != 6'b1; // Make sure we have at least 2 in case there's a 128 B write. This can be optimized in the future for 64B/32B.

   // Command
   assign afu_tlx_cmd_valid = (oc_command_state_d == ST_OC_COMMAND_WR)  | (oc_command_state_d == ST_OC_COMMAND_RD) |
                              (oc_command_state_d == ST_OC_COMMAND_MCW) | (oc_command_state_d == ST_OC_COMMAND_MCR);

   assign afu_tlx_cmd_opcode[7:0] = (oc_command_state_d == ST_OC_COMMAND_WR) ? oc_write_command_ready_opcode_eff                               :
                                    (oc_command_state_d == ST_OC_COMMAND_RD) ? oc_read_command_ready_opcode_eff                                :
                                    ((oc_command_state_d == ST_OC_COMMAND_MCR) | (oc_command_state_d == ST_OC_COMMAND_MCW)) ? `OPCODE_MEM_CNTL :
                                    `OPCODE_NOP;
   assign afu_tlx_cmd_pa_or_obj[63:0] = (oc_command_state_d == ST_OC_COMMAND_WR) ? oc_write_command_ready_address_eff :
                                        (oc_command_state_d == ST_OC_COMMAND_RD) ? oc_read_command_ready_address_eff :
                                        64'b0;
   assign afu_tlx_cmd_afutag[15:0] = 16'b0;
   assign afu_tlx_cmd_dl[1:0] = (oc_command_state_d == ST_OC_COMMAND_WR) ? ((oc_write_command_ready_length == 8'b00001111) ? 2'b01 : // 64 bytes
                                                                            (oc_write_command_ready_length == 8'b00011111) ? 2'b10 : // 128 bytes
                                                                            (oc_write_command_ready_length == 8'b00111111) ? 2'b11 : // 256 bytes
                                                                            2'b00) :
                                (oc_command_state_d == ST_OC_COMMAND_RD) ? ((oc_read_command_ready_length == 8'b00001111) ? 2'b01 : // 64 bytes
                                                                            (oc_read_command_ready_length == 8'b00011111) ? 2'b10 : // 128 bytes
                                                                            (oc_read_command_ready_length == 8'b00111111) ? 2'b11 : // 256 bytes
                                                                            2'b00) :
                                2'b00;
   assign afu_tlx_cmd_pl[2:0] = (oc_command_state_d == ST_OC_COMMAND_WR) ? ((oc_write_command_ready_length == 8'b00000000) ? 3'b010 : // 4 bytes
                                                                            (oc_write_command_ready_length == 8'b00000001) ? 3'b011 : // 8 bytes
                                                                            (oc_write_command_ready_length == 8'b00000011) ? 3'b100 : // 16 bytes
                                                                            (oc_write_command_ready_length == 8'b00000111) ? 3'b101 : // 32 bytes
                                                                            3'b111) :
                                (oc_command_state_d == ST_OC_COMMAND_RD) ? ((oc_read_command_ready_length == 8'b00000000) ? 3'b010 : // 4 bytes
                                                                            (oc_read_command_ready_length == 8'b00000001) ? 3'b011 : // 8 bytes
                                                                            (oc_read_command_ready_length == 8'b00000011) ? 3'b100 : // 16 bytes
                                                                            (oc_read_command_ready_length == 8'b00000111) ? 3'b101 : // 32 bytes
                                                                            3'b111) :
                                3'b000;
   assign afu_tlx_cmd_be[63:0] = 64'b0;
   assign afu_tlx_cmd_flag[3:0] = memcntl_oc_cmd_flag;
   assign afu_tlx_cmd_bdf[15:0] = 16'b0;
   assign afu_tlx_cmd_resp_code[3:0] = 4'b0;
   assign afu_tlx_cmd_capptag[15:0] = (oc_command_state_d == ST_OC_COMMAND_WR) ? oc_write_command_ready_id_eff :
                                      (oc_command_state_d == ST_OC_COMMAND_RD) ? oc_read_command_ready_id_eff :
                                      memcntl_oc_cmd_tag;

   // Command data
   assign afu_tlx_cdata_valid = (oc_command_state_d == ST_OC_COMMAND_WR) | (oc_command_state_d == ST_OC_COMMAND_WR_2);
   assign afu_tlx_cdata_bus[511:0] = (oc_write_command_ready_length == 8'b00000000)                                            ? {16{oc_write_command_ready_data[31:0]}} :    // 4 bytes
                                     (oc_write_command_ready_length == 8'b00000001)                                            ? {8{oc_write_command_ready_data[63:0]}} :     // 8 bytes
                                     (oc_write_command_ready_length == 8'b00000111)                                            ? {2{oc_write_command_ready_data[255:0]}} :    // 32 bytes
                                     (oc_write_command_ready_length == 8'b00001111)                                            ? {1{oc_write_command_ready_data[511:0]}} :    // 64 bytes
                                     (oc_write_command_ready_length == 8'b00011111 & oc_command_state_d == ST_OC_COMMAND_WR)   ? {1{oc_write_command_ready_data[511:0]}} :    // 128 bytes (first half)
                                     (oc_write_command_ready_length == 8'b00011111 & oc_command_state_d == ST_OC_COMMAND_WR_2) ? {1{oc_write_command_ready_data[1023:512]}} : // 128 bytes (second half)
                                     512'b0;
   assign afu_tlx_cdata_bdi = 1'b0;

   /*
    * OpenCAPI Response Channel
    */
   // Response
   assign afu_tlx_resp_initial_credit[6:0] = 7'b1111111;
   assign afu_tlx_resp_credit = tlx_afu_resp_valid;
   //input [ 15:0]  tlx_afu_resp_afutag,
   //input [ 5:0]   tlx_afu_resp_pg_size,
   //input [ 1:0]   tlx_afu_resp_dl,
   //input [ 23:0]  tlx_afu_resp_host_tag,
   //input [ 3:0]   tlx_afu_resp_cache_state,
   //input [ 17:0]  tlx_afu_resp_addr_tag,

   // Response data
   assign afu_tlx_resp_rd_req = 1'b0;        // Obsolete after change to data valid with response
   assign afu_tlx_resp_rd_cnt[2:0] = 3'b000; // Obsolete after change to data valid with response
   //input         tlx_afu_resp_data_valid,
   //input         tlx_afu_resp_data_bdi,

   assign tlx_afu_resp_capptag = tlx_afu_resp_afutag;
   assign outstanding_oc_lookup_id = oc_trans_rid;

   assign oc_trans_bvalid = tlx_afu_resp_valid & ((tlx_afu_resp_opcode == `OPCODE_MEM_WR_RESPONSE) | (tlx_afu_resp_opcode == `OPCODE_MEM_WR_FAIL));
   assign oc_trans_bid = tlx_afu_resp_capptag[FBIST_ID_WIDTH - 1 : 0];
   assign oc_trans_bresp = (tlx_afu_resp_code == 4'b0000) ? 2'b00 : // OKAY
                                                            2'b10;  // SLVERR

   assign oc_trans_rvalid = tlx_afu_resp_valid & ((tlx_afu_resp_opcode == `OPCODE_MEM_RD_RESPONSE) | (tlx_afu_resp_opcode == `OPCODE_MEM_RD_FAIL) | (tlx_afu_resp_opcode == `OPCODE_MEM_RD_RESPONSE_OW));
   assign oc_trans_rid = tlx_afu_resp_capptag[FBIST_ID_WIDTH - 1 : 0];
   assign oc_trans_rdata = (outstanding_read_arlen_oc_lookup == 8'b00000000) ? ((outstanding_read_araddr_oc_lookup[5:2] == 4'b0000) ? {992'b0, tlx_afu_resp_data_bus[ 31 :   0]} :
                                                                                (outstanding_read_araddr_oc_lookup[5:2] == 4'b0001) ? {992'b0, tlx_afu_resp_data_bus[ 63 :  32]} :
                                                                                (outstanding_read_araddr_oc_lookup[5:2] == 4'b0010) ? {992'b0, tlx_afu_resp_data_bus[ 95 :  64]} :
                                                                                (outstanding_read_araddr_oc_lookup[5:2] == 4'b0011) ? {992'b0, tlx_afu_resp_data_bus[127 :  96]} :
                                                                                (outstanding_read_araddr_oc_lookup[5:2] == 4'b0100) ? {992'b0, tlx_afu_resp_data_bus[159 : 128]} :
                                                                                (outstanding_read_araddr_oc_lookup[5:2] == 4'b0101) ? {992'b0, tlx_afu_resp_data_bus[191 : 160]} :
                                                                                (outstanding_read_araddr_oc_lookup[5:2] == 4'b0110) ? {992'b0, tlx_afu_resp_data_bus[223 : 192]} :
                                                                                (outstanding_read_araddr_oc_lookup[5:2] == 4'b0111) ? {992'b0, tlx_afu_resp_data_bus[255 : 224]} :
                                                                                (outstanding_read_araddr_oc_lookup[5:2] == 4'b1000) ? {992'b0, tlx_afu_resp_data_bus[287 : 256]} :
                                                                                (outstanding_read_araddr_oc_lookup[5:2] == 4'b1001) ? {992'b0, tlx_afu_resp_data_bus[319 : 288]} :
                                                                                (outstanding_read_araddr_oc_lookup[5:2] == 4'b1010) ? {992'b0, tlx_afu_resp_data_bus[351 : 320]} :
                                                                                (outstanding_read_araddr_oc_lookup[5:2] == 4'b1011) ? {992'b0, tlx_afu_resp_data_bus[383 : 352]} :
                                                                                (outstanding_read_araddr_oc_lookup[5:2] == 4'b1100) ? {992'b0, tlx_afu_resp_data_bus[415 : 384]} :
                                                                                (outstanding_read_araddr_oc_lookup[5:2] == 4'b1101) ? {992'b0, tlx_afu_resp_data_bus[447 : 416]} :
                                                                                (outstanding_read_araddr_oc_lookup[5:2] == 4'b1110) ? {992'b0, tlx_afu_resp_data_bus[479 : 448]} :
                                                                                                                                      {992'b0, tlx_afu_resp_data_bus[511 : 480]}) :
                           (outstanding_read_arlen_oc_lookup == 8'b00000001) ? ((outstanding_read_araddr_oc_lookup[5:3] == 3'b000) ? {960'b0, tlx_afu_resp_data_bus[ 63 :   0]} :
                                                                                (outstanding_read_araddr_oc_lookup[5:3] == 3'b001) ? {960'b0, tlx_afu_resp_data_bus[127 :  64]} :
                                                                                (outstanding_read_araddr_oc_lookup[5:3] == 3'b010) ? {960'b0, tlx_afu_resp_data_bus[191 : 128]} :
                                                                                (outstanding_read_araddr_oc_lookup[5:3] == 3'b011) ? {960'b0, tlx_afu_resp_data_bus[255 : 192]} :
                                                                                (outstanding_read_araddr_oc_lookup[5:3] == 3'b100) ? {960'b0, tlx_afu_resp_data_bus[319 : 256]} :
                                                                                (outstanding_read_araddr_oc_lookup[5:3] == 3'b101) ? {960'b0, tlx_afu_resp_data_bus[383 : 320]} :
                                                                                (outstanding_read_araddr_oc_lookup[5:3] == 3'b110) ? {960'b0, tlx_afu_resp_data_bus[447 : 384]} :
                                                                                                                                     {960'b0, tlx_afu_resp_data_bus[511 : 448]}) :
                           (outstanding_read_arlen_oc_lookup == 8'b00001111) ? {512'b0, tlx_afu_resp_data_bus[511 : 0]} :
                           // (outstanding_read_arlen_oc_lookup == 8'b00011111) ? {512'b0, tlx_afu_resp_data_bus[511 : 0]} : // This was FBIST 128B, but we only grab 64B at a time
                           1024'b0;
   assign oc_trans_rresp = (tlx_afu_resp_code == 4'b0000) ? 2'b00 : // OKAY
                                                            2'b10;  // SLVERR
   // For FBIST, we're abandoning the AXI spec and returning multiple
   // responses to the FBIST checker, like OpenCAPI does, rather than
   // reassembling them here. FBIST needs the dPart, so send it.
   assign oc_trans_ruser = {tlx_afu_resp_opcode == `OPCODE_MEM_RD_RESPONSE_OW, tlx_afu_resp_dp[1:0]};

   /////////////////////////////////////////////////////////////////////////////
   // Arbitration
   /////////////////////////////////////////////////////////////////////////////
   wire [3:0] oc_command_winner_decode_d;
   reg  [3:0] oc_command_winner_decode_q;
   wire       oc_command_winner_valid_d;
   reg        oc_command_winner_valid_q;
   wire [1:0] oc_command_winner_d;
   reg  [1:0] oc_command_winner_q;

   wire [3:0] oc_response_winner_decode;

   ocx_tlx_axi_rr #(.BITS(2), .SELFISH(0))
   oc_command_arb
     (
      .clock         (s0_axi_aclk                  ),
      .request       ({fbist_oc_write_command_ready | fbist_oc_read_command_ready,
                       cfg_oc_write_command_ready | cfg_oc_read_command_ready,
                       memory_oc_write_command_ready | memory_oc_read_command_ready,
                       mmio_oc_write_command_ready | mmio_oc_read_command_ready
                       }
                      ),
      .pause         (~(oc_write_command_taken | oc_read_command_taken)),
      .select        (oc_command_winner_decode_d ),
      .select_valid  (oc_command_winner_valid_d  ),
      .select_encode (oc_command_winner_d        )
      );

   assign oc_response_winner_decode = {tlx_afu_resp_capptag[15:13] == 3'b000,  // assume that mem_cntl_done is safely ignored here
                                       tlx_afu_resp_capptag[15:13] == 3'b111,  // as it is handled only in its own logic. (15:13 will be 101)
                                       tlx_afu_resp_capptag[15:13] == 3'b100,
                                       tlx_afu_resp_capptag[15:13] == 3'b110
                                       };

   assign oc_write_command_ready_opcode_eff = oc_command_winner_decode_q[0] ? ((oc_write_command_ready_length > 8'h07) ? `OPCODE_WRITE_MEM : `OPCODE_PR_WR_MEM) :
                                              oc_command_winner_decode_q[1] ? ((oc_write_command_ready_length > 8'h07) ? `OPCODE_WRITE_MEM : `OPCODE_PR_WR_MEM) :
                                              oc_command_winner_decode_q[2] ? `OPCODE_CONFIG_WRITE :
                                              oc_command_winner_decode_q[3] ? ((oc_write_command_ready_length > 8'h07) ? `OPCODE_WRITE_MEM : `OPCODE_PR_WR_MEM) :
                                              8'b00;
   assign oc_write_command_ready_address_eff = oc_command_winner_decode_q[0] ? {cfg_bar[63:32], mmio_oc_write_command_ready_address[31:0]} :
                                               oc_command_winner_decode_q[1] ? memory_oc_write_command_ready_address :
                                               oc_command_winner_decode_q[2] ? {33'b0, cfg_oc_write_command_ready_address[30:0]} :
                                               oc_command_winner_decode_q[3] ? fbist_oc_write_command_ready_address :
                                               {ADDR_WIDTH{1'b0}};
   assign oc_write_command_ready_length = oc_command_winner_decode_q[0] ? mmio_oc_write_command_ready_length :
                                          oc_command_winner_decode_q[1] ? memory_oc_write_command_ready_length :
                                          oc_command_winner_decode_q[2] ? cfg_oc_write_command_ready_length :
                                          oc_command_winner_decode_q[3] ? (fbist_oc_write_command_ready_size == 3'b101 & fbist_oc_write_command_ready_length == 8'b00000000 ? 8'b00000111 :
                                                                           fbist_oc_write_command_ready_size == 3'b110 & fbist_oc_write_command_ready_length == 8'b00000000 ? 8'b00001111 :
                                                                           fbist_oc_write_command_ready_size == 3'b110 & fbist_oc_write_command_ready_length == 8'b00000001 ? 8'b00011111 :
                                                                           8'b11111111) : // FBIST has a wider interface, so we need to adjust the lengths so the logic made for 32 bits work
                                          8'b0;
   assign oc_write_command_ready_data = oc_command_winner_decode_q[0] ? {{960{1'b0}}, mmio_oc_write_command_ready_data} :
                                        oc_command_winner_decode_q[1] ? {{960{1'b0}}, memory_oc_write_command_ready_data} :
                                        oc_command_winner_decode_q[2] ? {{960{1'b0}}, cfg_oc_write_command_ready_data} :
                                        oc_command_winner_decode_q[3] ? {fbist_oc_write_command_ready_data, fbist_oc_write_command_ready_data2} :
                                        {1024{1'b0}};
   assign oc_write_command_ready = oc_command_winner_valid_q & (oc_command_winner_decode_q[0] ? mmio_oc_write_command_ready :
                                                                oc_command_winner_decode_q[1] ? memory_oc_write_command_ready :
                                                                oc_command_winner_decode_q[2] ? cfg_oc_write_command_ready :
                                                                oc_command_winner_decode_q[3] ? fbist_oc_write_command_ready :
                                                                1'b0);
   assign oc_write_command_ready_id_eff = oc_command_winner_decode_q[0] ? {4'b1100, {12-ID_WIDTH{1'b0}}, mmio_oc_write_command_ready_id} :
                                          oc_command_winner_decode_q[1] ? {4'b1000, {12-ID_WIDTH{1'b0}}, memory_oc_write_command_ready_id} :
                                          oc_command_winner_decode_q[2] ? {4'b1110, {12-ID_WIDTH{1'b0}}, cfg_oc_write_command_ready_id} :
                                          oc_command_winner_decode_q[3] ? {4'b0000, fbist_oc_write_command_ready_id} :
                                          16'b0;

   assign mmio_oc_write_command_taken = oc_command_winner_decode_q[0] & oc_write_command_taken;
   assign memory_oc_write_command_taken = oc_command_winner_decode_q[1] & oc_write_command_taken;
   assign cfg_oc_write_command_taken = oc_command_winner_decode_q[2] & oc_write_command_taken;
   assign fbist_oc_write_command_taken = oc_command_winner_decode_q[3] & oc_write_command_taken;

   assign oc_read_command_ready_opcode_eff = oc_command_winner_decode_q[0] ? ((oc_read_command_ready_length > 8'h07) ? `OPCODE_RD_MEM : `OPCODE_PR_RD_MEM) :
                                             oc_command_winner_decode_q[1] ? ((oc_read_command_ready_length > 8'h07) ? `OPCODE_RD_MEM : `OPCODE_PR_RD_MEM) :
                                             oc_command_winner_decode_q[2] ? `OPCODE_CONFIG_READ :
                                             oc_command_winner_decode_q[3] ? ((oc_read_command_ready_length > 8'h07) ? `OPCODE_RD_MEM : `OPCODE_PR_RD_MEM) :
                                             8'b00;
   assign oc_read_command_ready_address_eff = oc_command_winner_decode_q[0] ? {cfg_bar[63:32], mmio_oc_read_command_ready_address[31:0]} :
                                              oc_command_winner_decode_q[1] ? memory_oc_read_command_ready_address :
                                              oc_command_winner_decode_q[2] ? {33'b0, cfg_oc_read_command_ready_address[30:0]} :
                                              oc_command_winner_decode_q[3] ? fbist_oc_read_command_ready_address :
                                              {ADDR_WIDTH{1'b0}};
   assign oc_read_command_ready_length = oc_command_winner_decode_q[0] ? mmio_oc_read_command_ready_length :
                                         oc_command_winner_decode_q[1] ? memory_oc_read_command_ready_length :
                                         oc_command_winner_decode_q[2] ? cfg_oc_read_command_ready_length :
                                         oc_command_winner_decode_q[3] ? (fbist_oc_read_command_ready_size == 3'b101 & fbist_oc_read_command_ready_length == 8'b00000000 ? 8'b00000111 :
                                                                          fbist_oc_read_command_ready_size == 3'b110 & fbist_oc_read_command_ready_length == 8'b00000000 ? 8'b00001111 :
                                                                          fbist_oc_read_command_ready_size == 3'b110 & fbist_oc_read_command_ready_length == 8'b00000001 ? 8'b00011111 :
                                                                          8'b11111111) : // FBIST has a wider interface, so we need to adjust the lengths so the logic made for 32 bits work
                                         8'b0;
   assign oc_read_command_ready = oc_command_winner_valid_q & (oc_command_winner_decode_q[0] ? mmio_oc_read_command_ready :
                                                               oc_command_winner_decode_q[1] ? memory_oc_read_command_ready :
                                                               oc_command_winner_decode_q[2] ? cfg_oc_read_command_ready :
                                                               oc_command_winner_decode_q[3] ? fbist_oc_read_command_ready :
                                                               1'b0);
   assign oc_read_command_ready_id_eff = oc_command_winner_decode_q[0] ? {4'b1101, {12-ID_WIDTH{1'b0}}, mmio_oc_read_command_ready_id} :
                                         oc_command_winner_decode_q[1] ? {4'b1001, {12-ID_WIDTH{1'b0}}, memory_oc_read_command_ready_id} :
                                         oc_command_winner_decode_q[2] ? {4'b1111, {12-ID_WIDTH{1'b0}}, cfg_oc_read_command_ready_id} :
                                         oc_command_winner_decode_q[3] ? {4'b0000, fbist_oc_read_command_ready_id} :
                                         16'b0;

   assign mmio_oc_read_command_taken = oc_command_winner_decode_q[0] & oc_read_command_taken;
   assign memory_oc_read_command_taken = oc_command_winner_decode_q[1] & oc_read_command_taken;
   assign cfg_oc_read_command_taken = oc_command_winner_decode_q[2] & oc_read_command_taken;
   assign fbist_oc_read_command_taken = oc_command_winner_decode_q[3] & oc_read_command_taken;

   assign mmio_outstanding_oc_lookup_id = outstanding_oc_lookup_id;
   assign memory_outstanding_oc_lookup_id = outstanding_oc_lookup_id;
   assign cfg_outstanding_oc_lookup_id = outstanding_oc_lookup_id;
   assign fbist_outstanding_oc_lookup_id = outstanding_oc_lookup_id;
   assign outstanding_read_araddr_oc_lookup = oc_response_winner_decode[0] ? mmio_outstanding_read_araddr_oc_lookup :
                                              oc_response_winner_decode[1] ? memory_outstanding_read_araddr_oc_lookup :
                                              oc_response_winner_decode[2] ? cfg_outstanding_read_araddr_oc_lookup :
                                              oc_response_winner_decode[3] ? fbist_outstanding_read_araddr_oc_lookup :
                                              {ADDR_WIDTH{1'b0}};
   assign outstanding_read_arlen_oc_lookup = oc_response_winner_decode[0] ? mmio_outstanding_read_arlen_oc_lookup :
                                             oc_response_winner_decode[1] ? memory_outstanding_read_arlen_oc_lookup :
                                             oc_response_winner_decode[2] ? cfg_outstanding_read_arlen_oc_lookup :
                                             oc_response_winner_decode[3] ? 8'b00001111 : // FBIST has a wider interface, so we need to adjust the lengths so the logic made for 32 bits work
                                                                                          // This is actually 00001111 for 64B and 00011111 for 128B, but we just grab a whole data flit either way, so we don't really care.
                                             8'b0;

   assign mmio_oc_trans_bvalid = oc_response_winner_decode[0] & oc_trans_bvalid;
   assign mmio_oc_trans_bid = oc_trans_bid;
   assign mmio_oc_trans_bresp = oc_trans_bresp;
   assign mmio_oc_trans_rvalid = oc_response_winner_decode[0] & oc_trans_rvalid;
   assign mmio_oc_trans_rid = oc_trans_rid;
   assign mmio_oc_trans_rdata = oc_trans_rdata[63 : 0];
   assign mmio_oc_trans_rresp = oc_trans_rresp;
   assign mmio_oc_trans_ruser = oc_trans_ruser;

   assign memory_oc_trans_bvalid = oc_response_winner_decode[1] & oc_trans_bvalid;
   assign memory_oc_trans_bid = oc_trans_bid;
   assign memory_oc_trans_bresp = oc_trans_bresp;
   assign memory_oc_trans_rvalid = oc_response_winner_decode[1] & oc_trans_rvalid;
   assign memory_oc_trans_rid = oc_trans_rid;
   assign memory_oc_trans_rdata = oc_trans_rdata[63 : 0];
   assign memory_oc_trans_rresp = oc_trans_rresp;
   assign memory_oc_trans_ruser = oc_trans_ruser;

   assign cfg_oc_trans_bvalid = oc_response_winner_decode[2] & oc_trans_bvalid;
   assign cfg_oc_trans_bid = oc_trans_bid;
   assign cfg_oc_trans_bresp = oc_trans_bresp;
   assign cfg_oc_trans_rvalid = oc_response_winner_decode[2] & oc_trans_rvalid;
   assign cfg_oc_trans_rid = oc_trans_rid;
   assign cfg_oc_trans_rdata = oc_trans_rdata[63 : 0];
   assign cfg_oc_trans_rresp = oc_trans_rresp;
   assign cfg_oc_trans_ruser = oc_trans_ruser;

   assign fbist_oc_trans_bvalid = oc_response_winner_decode[3] & oc_trans_bvalid;
   assign fbist_oc_trans_bid = oc_trans_bid;
   assign fbist_oc_trans_bresp = oc_trans_bresp;
   assign fbist_oc_trans_rvalid = oc_response_winner_decode[3] & oc_trans_rvalid;
   assign fbist_oc_trans_rid = oc_trans_rid;
   assign fbist_oc_trans_rdata = oc_trans_rdata[511 : 0];
   assign fbist_oc_trans_rresp = oc_trans_rresp;
   assign fbist_oc_trans_ruser = oc_trans_ruser;

   /////////////////////////////////////////////////////////////////////////////
   // Latches
   /////////////////////////////////////////////////////////////////////////////
   always @(posedge s0_axi_aclk) begin
      if (!s0_axi_aresetn) begin
         oc_command_state_q <= ST_OC_COMMAND_IDLE_WR_PRIORITY;
         command_credits_available_count_q <= tlx_afu_cmd_initial_credit;
         data_credits_available_count_q <= tlx_afu_cmd_data_initial_credit;
         oc_command_winner_decode_q <= 4'b0000;
         oc_command_winner_valid_q <= 1'b0;
         oc_command_winner_q <= 2'b00;
         afu_tlx_cmd_dl_q <= 2'b00;
      end
      else begin
         oc_command_state_q <= oc_command_state_d;
         command_credits_available_count_q <= command_credits_available_count_d;
         data_credits_available_count_q <= data_credits_available_count_d;
         oc_command_winner_decode_q <= oc_command_winner_decode_d;
         oc_command_winner_valid_q <= oc_command_winner_valid_d;
         oc_command_winner_q <= oc_command_winner_d;
         afu_tlx_cmd_dl_q <= afu_tlx_cmd_dl;
         need_wr_2_q <= need_wr_2_d;
      end
   end // always @ (posedge s0_axi_aclk)

   always @(posedge s0_axi_aclk) begin
      tlx_afu_resp_opcode_q <= tlx_afu_resp_opcode;
      tlx_afu_resp_opcode_1 <= tlx_afu_resp_opcode_q;
      tlx_afu_resp_opcode_2 <= tlx_afu_resp_opcode_1;

      tlx_afu_resp_valid_q <= tlx_afu_resp_valid;
      tlx_afu_resp_valid_1 <= tlx_afu_resp_valid_q;
      tlx_afu_resp_valid_2 <= tlx_afu_resp_valid_1;

      oc_trans_bvalid_q <= oc_trans_bvalid;
      oc_trans_bvalid_1 <= oc_trans_bvalid_q;
      oc_trans_bvalid_2 <= oc_trans_bvalid_1;
      oc_trans_rvalid_q <= oc_trans_rvalid;
      oc_trans_rvalid_1 <= oc_trans_rvalid_q;
      oc_trans_rvalid_2 <= oc_trans_rvalid_1;


   end


   ocx_tlx_axi_channels
     #(.ADDR_WIDTH                       (ADDR_WIDTH                             ),
       .AXI_DATA_WIDTH                   (AXI_DATA_WIDTH                         ),
       .ID_WIDTH                         (ID_WIDTH                               )
       )
   mmio_axi_channels
     (
      .s0_axi_aclk                       (s0_axi_aclk                            ),
      .s0_axi_aresetn                    (s0_axi_aresetn                         ),
      .s0_axi_awid                       (s0_axi_awid                            ),
      .s0_axi_awaddr                     (s0_axi_awaddr                          ),
      .s0_axi_awlen                      (s0_axi_awlen                           ),
      .s0_axi_awsize                     (s0_axi_awsize                          ),
      .s0_axi_awburst                    (s0_axi_awburst                         ),
      .s0_axi_awlock                     (s0_axi_awlock                          ),
      .s0_axi_awcache                    (s0_axi_awcache                         ),
      .s0_axi_awprot                     (s0_axi_awprot                          ),
      .s0_axi_awvalid                    (s0_axi_awvalid                         ),
      .s0_axi_awready                    (s0_axi_awready                         ),
      .s0_axi_wid                        (s0_axi_wid                             ),
      .s0_axi_wdata                      (s0_axi_wdata                           ),
      .s0_axi_wstrb                      (s0_axi_wstrb                           ),
      .s0_axi_wlast                      (s0_axi_wlast                           ),
      .s0_axi_wvalid                     (s0_axi_wvalid                          ),
      .s0_axi_wready                     (s0_axi_wready                          ),
      .s0_axi_bid                        (s0_axi_bid                             ),
      .s0_axi_bresp                      (s0_axi_bresp                           ),
      .s0_axi_bvalid                     (s0_axi_bvalid                          ),
      .s0_axi_bready                     (s0_axi_bready                          ),
      .s0_axi_arid                       (s0_axi_arid                            ),
      .s0_axi_araddr                     (s0_axi_araddr                          ),
      .s0_axi_arlen                      (s0_axi_arlen                           ),
      .s0_axi_arsize                     (s0_axi_arsize                          ),
      .s0_axi_arburst                    (s0_axi_arburst                         ),
      .s0_axi_arlock                     (s0_axi_arlock                          ),
      .s0_axi_arcache                    (s0_axi_arcache                         ),
      .s0_axi_arprot                     (s0_axi_arprot                          ),
      .s0_axi_arvalid                    (s0_axi_arvalid                         ),
      .s0_axi_arready                    (s0_axi_arready                         ),
      .s0_axi_rid                        (s0_axi_rid                             ),
      .s0_axi_rdata                      (s0_axi_rdata                           ),
      .s0_axi_rresp                      (s0_axi_rresp                           ),
      .s0_axi_rlast                      (s0_axi_rlast                           ),
      .s0_axi_rvalid                     (s0_axi_rvalid                          ),
      .s0_axi_rready                     (s0_axi_rready                          ),
      .oc_write_command_ready_address    (mmio_oc_write_command_ready_address    ),
      .oc_write_command_ready_length     (mmio_oc_write_command_ready_length     ),
      .oc_write_command_ready_data       (mmio_oc_write_command_ready_data       ),
      .oc_write_command_ready            (mmio_oc_write_command_ready            ),
      .oc_write_command_ready_id         (mmio_oc_write_command_ready_id         ),
      .oc_write_command_taken            (mmio_oc_write_command_taken            ),
      .oc_trans_bvalid                   (mmio_oc_trans_bvalid                   ),
      .oc_trans_bid                      (mmio_oc_trans_bid                      ),
      .oc_trans_bresp                    (mmio_oc_trans_bresp                    ),
      .oc_read_command_ready_address     (mmio_oc_read_command_ready_address     ),
      .oc_read_command_ready_length      (mmio_oc_read_command_ready_length      ),
      .oc_read_command_ready             (mmio_oc_read_command_ready             ),
      .oc_read_command_ready_id          (mmio_oc_read_command_ready_id          ),
      .oc_read_command_taken             (mmio_oc_read_command_taken             ),
      .oc_trans_rvalid                   (mmio_oc_trans_rvalid                   ),
      .oc_trans_rid                      (mmio_oc_trans_rid                      ),
      .oc_trans_rdata                    (mmio_oc_trans_rdata                    ),
      .oc_trans_rresp                    (mmio_oc_trans_rresp                    ),
      .oc_trans_ruser                    (mmio_oc_trans_ruser                    ),
      .outstanding_oc_lookup_id          (mmio_outstanding_oc_lookup_id          ),
      .outstanding_read_araddr_oc_lookup (mmio_outstanding_read_araddr_oc_lookup ),
      .outstanding_read_arlen_oc_lookup  (mmio_outstanding_read_arlen_oc_lookup  )
      );

   ocx_tlx_axi_channels
     #(.ADDR_WIDTH                       (ADDR_WIDTH                               ),
       .AXI_DATA_WIDTH                   (AXI_DATA_WIDTH                           ),
       .ID_WIDTH                         (ID_WIDTH                                 )
       )
   memory_axi_channels
     (
      .s0_axi_aclk                       (s1_axi_aclk                              ),
      .s0_axi_aresetn                    (s1_axi_aresetn                           ),
      .s0_axi_awid                       (s1_axi_awid                              ),
      .s0_axi_awaddr                     (s1_axi_awaddr                            ),
      .s0_axi_awlen                      (s1_axi_awlen                             ),
      .s0_axi_awsize                     (s1_axi_awsize                            ),
      .s0_axi_awburst                    (s1_axi_awburst                           ),
      .s0_axi_awlock                     (s1_axi_awlock                            ),
      .s0_axi_awcache                    (s1_axi_awcache                           ),
      .s0_axi_awprot                     (s1_axi_awprot                            ),
      .s0_axi_awvalid                    (s1_axi_awvalid                           ),
      .s0_axi_awready                    (s1_axi_awready                           ),
      .s0_axi_wid                        (s1_axi_wid                               ),
      .s0_axi_wdata                      (s1_axi_wdata                             ),
      .s0_axi_wstrb                      (s1_axi_wstrb                             ),
      .s0_axi_wlast                      (s1_axi_wlast                             ),
      .s0_axi_wvalid                     (s1_axi_wvalid                            ),
      .s0_axi_wready                     (s1_axi_wready                            ),
      .s0_axi_bid                        (s1_axi_bid                               ),
      .s0_axi_bresp                      (s1_axi_bresp                             ),
      .s0_axi_bvalid                     (s1_axi_bvalid                            ),
      .s0_axi_bready                     (s1_axi_bready                            ),
      .s0_axi_arid                       (s1_axi_arid                              ),
      .s0_axi_araddr                     (s1_axi_araddr                            ),
      .s0_axi_arlen                      (s1_axi_arlen                             ),
      .s0_axi_arsize                     (s1_axi_arsize                            ),
      .s0_axi_arburst                    (s1_axi_arburst                           ),
      .s0_axi_arlock                     (s1_axi_arlock                            ),
      .s0_axi_arcache                    (s1_axi_arcache                           ),
      .s0_axi_arprot                     (s1_axi_arprot                            ),
      .s0_axi_arvalid                    (s1_axi_arvalid                           ),
      .s0_axi_arready                    (s1_axi_arready                           ),
      .s0_axi_rid                        (s1_axi_rid                               ),
      .s0_axi_rdata                      (s1_axi_rdata                             ),
      .s0_axi_rresp                      (s1_axi_rresp                             ),
      .s0_axi_rlast                      (s1_axi_rlast                             ),
      .s0_axi_rvalid                     (s1_axi_rvalid                            ),
      .s0_axi_rready                     (s1_axi_rready                            ),
      .oc_write_command_ready_address    (memory_oc_write_command_ready_address    ),
      .oc_write_command_ready_length     (memory_oc_write_command_ready_length     ),
      .oc_write_command_ready_data       (memory_oc_write_command_ready_data       ),
      .oc_write_command_ready            (memory_oc_write_command_ready            ),
      .oc_write_command_ready_id         (memory_oc_write_command_ready_id         ),
      .oc_write_command_taken            (memory_oc_write_command_taken            ),
      .oc_trans_bvalid                   (memory_oc_trans_bvalid                   ),
      .oc_trans_bid                      (memory_oc_trans_bid                      ),
      .oc_trans_bresp                    (memory_oc_trans_bresp                    ),
      .oc_read_command_ready_address     (memory_oc_read_command_ready_address     ),
      .oc_read_command_ready_length      (memory_oc_read_command_ready_length      ),
      .oc_read_command_ready             (memory_oc_read_command_ready             ),
      .oc_read_command_ready_id          (memory_oc_read_command_ready_id          ),
      .oc_read_command_taken             (memory_oc_read_command_taken             ),
      .oc_trans_rvalid                   (memory_oc_trans_rvalid                   ),
      .oc_trans_rid                      (memory_oc_trans_rid                      ),
      .oc_trans_rdata                    (memory_oc_trans_rdata                    ),
      .oc_trans_rresp                    (memory_oc_trans_rresp                    ),
      .oc_trans_ruser                    (memory_oc_trans_ruser                    ),
      .outstanding_oc_lookup_id          (memory_outstanding_oc_lookup_id          ),
      .outstanding_read_araddr_oc_lookup (memory_outstanding_read_araddr_oc_lookup ),
      .outstanding_read_arlen_oc_lookup  (memory_outstanding_read_arlen_oc_lookup  )
      );

   ocx_tlx_axi_channels
     #(.ADDR_WIDTH                       (ADDR_WIDTH                            ),
       .AXI_DATA_WIDTH                   (AXI_DATA_WIDTH                        ),
       .ID_WIDTH                         (ID_WIDTH                              )
       )
   cfg_axi_channels
     (
      .s0_axi_aclk                       (s2_axi_aclk                           ),
      .s0_axi_aresetn                    (s2_axi_aresetn                        ),
      .s0_axi_awid                       (s2_axi_awid                           ),
      .s0_axi_awaddr                     (s2_axi_awaddr                         ),
      .s0_axi_awlen                      (s2_axi_awlen                          ),
      .s0_axi_awsize                     (s2_axi_awsize                         ),
      .s0_axi_awburst                    (s2_axi_awburst                        ),
      .s0_axi_awlock                     (s2_axi_awlock                         ),
      .s0_axi_awcache                    (s2_axi_awcache                        ),
      .s0_axi_awprot                     (s2_axi_awprot                         ),
      .s0_axi_awvalid                    (s2_axi_awvalid                        ),
      .s0_axi_awready                    (s2_axi_awready                        ),
      .s0_axi_wid                        (s2_axi_wid                            ),
      .s0_axi_wdata                      (s2_axi_wdata                          ),
      .s0_axi_wstrb                      (s2_axi_wstrb                          ),
      .s0_axi_wlast                      (s2_axi_wlast                          ),
      .s0_axi_wvalid                     (s2_axi_wvalid                         ),
      .s0_axi_wready                     (s2_axi_wready                         ),
      .s0_axi_bid                        (s2_axi_bid                            ),
      .s0_axi_bresp                      (s2_axi_bresp                          ),
      .s0_axi_bvalid                     (s2_axi_bvalid                         ),
      .s0_axi_bready                     (s2_axi_bready                         ),
      .s0_axi_arid                       (s2_axi_arid                           ),
      .s0_axi_araddr                     (s2_axi_araddr                         ),
      .s0_axi_arlen                      (s2_axi_arlen                          ),
      .s0_axi_arsize                     (s2_axi_arsize                         ),
      .s0_axi_arburst                    (s2_axi_arburst                        ),
      .s0_axi_arlock                     (s2_axi_arlock                         ),
      .s0_axi_arcache                    (s2_axi_arcache                        ),
      .s0_axi_arprot                     (s2_axi_arprot                         ),
      .s0_axi_arvalid                    (s2_axi_arvalid                        ),
      .s0_axi_arready                    (s2_axi_arready                        ),
      .s0_axi_rid                        (s2_axi_rid                            ),
      .s0_axi_rdata                      (s2_axi_rdata                          ),
      .s0_axi_rresp                      (s2_axi_rresp                          ),
      .s0_axi_rlast                      (s2_axi_rlast                          ),
      .s0_axi_rvalid                     (s2_axi_rvalid                         ),
      .s0_axi_rready                     (s2_axi_rready                         ),
      .oc_write_command_ready_address    (cfg_oc_write_command_ready_address    ),
      .oc_write_command_ready_length     (cfg_oc_write_command_ready_length     ),
      .oc_write_command_ready_data       (cfg_oc_write_command_ready_data       ),
      .oc_write_command_ready            (cfg_oc_write_command_ready            ),
      .oc_write_command_ready_id         (cfg_oc_write_command_ready_id         ),
      .oc_write_command_taken            (cfg_oc_write_command_taken            ),
      .oc_trans_bvalid                   (cfg_oc_trans_bvalid                   ),
      .oc_trans_bid                      (cfg_oc_trans_bid                      ),
      .oc_trans_bresp                    (cfg_oc_trans_bresp                    ),
      .oc_read_command_ready_address     (cfg_oc_read_command_ready_address     ),
      .oc_read_command_ready_length      (cfg_oc_read_command_ready_length      ),
      .oc_read_command_ready             (cfg_oc_read_command_ready             ),
      .oc_read_command_ready_id          (cfg_oc_read_command_ready_id          ),
      .oc_read_command_taken             (cfg_oc_read_command_taken             ),
      .oc_trans_rvalid                   (cfg_oc_trans_rvalid                   ),
      .oc_trans_rid                      (cfg_oc_trans_rid                      ),
      .oc_trans_rdata                    (cfg_oc_trans_rdata                    ),
      .oc_trans_rresp                    (cfg_oc_trans_rresp                    ),
      .oc_trans_ruser                    (cfg_oc_trans_ruser                    ),
      .outstanding_oc_lookup_id          (cfg_outstanding_oc_lookup_id          ),
      .outstanding_read_araddr_oc_lookup (cfg_outstanding_read_araddr_oc_lookup ),
      .outstanding_read_arlen_oc_lookup  (cfg_outstanding_read_arlen_oc_lookup  )
      );

   ocx_tlx_axi_channels_fbist
     #(.ADDR_WIDTH                       (ADDR_WIDTH                              ),
       .AXI_DATA_WIDTH                   (512                                     ),
       .OC_DATA_WIDTH                    (512                                     ),
       .ID_WIDTH                         (FBIST_ID_WIDTH                          )
       )
   fbist_axi_channels
     (
      .s0_axi_aclk                       (s3_axi_aclk                             ),
      .s0_axi_aresetn                    (s3_axi_aresetn                          ),
      .s0_axi_awid                       (s3_axi_awid                             ),
      .s0_axi_awaddr                     (s3_axi_awaddr                           ),
      .s0_axi_awlen                      (s3_axi_awlen                            ),
      .s0_axi_awsize                     (s3_axi_awsize                           ),
      .s0_axi_awburst                    (s3_axi_awburst                          ),
      .s0_axi_awlock                     (s3_axi_awlock                           ),
      .s0_axi_awcache                    (s3_axi_awcache                          ),
      .s0_axi_awprot                     (s3_axi_awprot                           ),
      .s0_axi_awvalid                    (s3_axi_awvalid                          ),
      .s0_axi_awready                    (s3_axi_awready                          ),
      .s0_axi_wid                        (s3_axi_wid                              ),
      .s0_axi_wdata                      (s3_axi_wdata                            ),
      .s0_axi_wstrb                      (s3_axi_wstrb                            ),
      .s0_axi_wlast                      (s3_axi_wlast                            ),
      .s0_axi_wvalid                     (s3_axi_wvalid                           ),
      .s0_axi_wready                     (s3_axi_wready                           ),
      .s0_axi_bid                        (s3_axi_bid                              ),
      .s0_axi_bresp                      (s3_axi_bresp                            ),
      .s0_axi_bvalid                     (s3_axi_bvalid                           ),
      .s0_axi_bready                     (s3_axi_bready                           ),
      .s0_axi_arid                       (s3_axi_arid                             ),
      .s0_axi_araddr                     (s3_axi_araddr                           ),
      .s0_axi_arlen                      (s3_axi_arlen                            ),
      .s0_axi_arsize                     (s3_axi_arsize                           ),
      .s0_axi_arburst                    (s3_axi_arburst                          ),
      .s0_axi_arlock                     (s3_axi_arlock                           ),
      .s0_axi_arcache                    (s3_axi_arcache                          ),
      .s0_axi_arprot                     (s3_axi_arprot                           ),
      .s0_axi_arvalid                    (s3_axi_arvalid                          ),
      .s0_axi_arready                    (s3_axi_arready                          ),
      .s0_axi_rid                        (s3_axi_rid                              ),
      .s0_axi_rdata                      (s3_axi_rdata                            ),
      .s0_axi_rresp                      (s3_axi_rresp                            ),
      .s0_axi_rlast                      (s3_axi_rlast                            ),
      .s0_axi_ruser                      (s3_axi_ruser                            ),
      .s0_axi_rvalid                     (s3_axi_rvalid                           ),
      .s0_axi_rready                     (s3_axi_rready                           ),
      .oc_write_command_ready_address    (fbist_oc_write_command_ready_address    ),
      .oc_write_command_ready_length     (fbist_oc_write_command_ready_length     ),
      .oc_write_command_ready_size       (fbist_oc_write_command_ready_size       ),
      .oc_write_command_ready_data       (fbist_oc_write_command_ready_data       ),
      .oc_write_command_ready_data2      (fbist_oc_write_command_ready_data2      ),
      .oc_write_command_ready            (fbist_oc_write_command_ready            ),
      .oc_write_command_ready_id         (fbist_oc_write_command_ready_id         ),
      .oc_write_command_taken            (fbist_oc_write_command_taken            ),
      .oc_trans_bvalid                   (fbist_oc_trans_bvalid                   ),
      .oc_trans_bid                      (fbist_oc_trans_bid                      ),
      .oc_trans_bresp                    (fbist_oc_trans_bresp                    ),
      .oc_read_command_ready_address     (fbist_oc_read_command_ready_address     ),
      .oc_read_command_ready_length      (fbist_oc_read_command_ready_length      ),
      .oc_read_command_ready_size        (fbist_oc_read_command_ready_size        ),
      .oc_read_command_ready             (fbist_oc_read_command_ready             ),
      .oc_read_command_ready_id          (fbist_oc_read_command_ready_id          ),
      .oc_read_command_taken             (fbist_oc_read_command_taken             ),
      .oc_trans_rvalid                   (fbist_oc_trans_rvalid                   ),
      .oc_trans_rid                      (fbist_oc_trans_rid                      ),
      .oc_trans_rdata                    (fbist_oc_trans_rdata                    ),
      .oc_trans_rresp                    (fbist_oc_trans_rresp                    ),
      .oc_trans_ruser                    (fbist_oc_trans_ruser                    ),
      .outstanding_oc_lookup_id          (fbist_outstanding_oc_lookup_id          ),
      .outstanding_read_araddr_oc_lookup (fbist_outstanding_read_araddr_oc_lookup ),
      .outstanding_read_arlen_oc_lookup  (fbist_outstanding_read_arlen_oc_lookup  ),
      .outstanding_read_arsize_oc_lookup (fbist_outstanding_read_arsize_oc_lookup )
      );

endmodule // ocx_tlx_axi
