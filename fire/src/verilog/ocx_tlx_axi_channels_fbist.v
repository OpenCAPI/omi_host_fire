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

module ocx_tlx_axi_channels_fbist
  #(
   parameter ADDR_WIDTH = 64,
   parameter AXI_DATA_WIDTH = 512,
   parameter OC_DATA_WIDTH = 512,
   parameter ID_WIDTH = 12
  ) (
   // Global
   input                          s0_axi_aclk,
   input                          s0_axi_aresetn,

   // AXI Write Address Channel
   input [ID_WIDTH-1:0]           s0_axi_awid,
   input [ADDR_WIDTH-1:0]         s0_axi_awaddr,
   input [7:0]                    s0_axi_awlen,
   input [2:0]                    s0_axi_awsize,
   input [1:0]                    s0_axi_awburst,
   input [1:0]                    s0_axi_awlock,
   input [3:0]                    s0_axi_awcache,
   input [2:0]                    s0_axi_awprot,
   input                          s0_axi_awvalid,
   output                         s0_axi_awready,

   // AXI Write Data Channel
   input [ID_WIDTH-1:0]           s0_axi_wid,
   input [AXI_DATA_WIDTH-1:0]     s0_axi_wdata,
   input [AXI_DATA_WIDTH/8-1:0]   s0_axi_wstrb,
   input                          s0_axi_wlast,
   input                          s0_axi_wvalid,
   output                         s0_axi_wready,

   // AXI Write Response Channel
   output [ID_WIDTH-1:0]          s0_axi_bid,
   output [1:0]                   s0_axi_bresp,
   output                         s0_axi_bvalid,
   input                          s0_axi_bready,

   // AXI Read Address Channel
   input [ID_WIDTH-1:0]           s0_axi_arid,
   input [ADDR_WIDTH-1:0]         s0_axi_araddr,
   input [7:0]                    s0_axi_arlen,
   input [2:0]                    s0_axi_arsize,
   input [1:0]                    s0_axi_arburst,
   input [1:0]                    s0_axi_arlock,
   input [3:0]                    s0_axi_arcache,
   input [2:0]                    s0_axi_arprot,
   input                          s0_axi_arvalid,
   output                         s0_axi_arready,

   // AXI Read Data Channel
   output [ID_WIDTH-1:0]          s0_axi_rid,
   output [AXI_DATA_WIDTH-1:0]    s0_axi_rdata,
   output [1:0]                   s0_axi_rresp,
   output                         s0_axi_rlast,
   output [2:0]                   s0_axi_ruser,
   output                         s0_axi_rvalid,
   input                          s0_axi_rready,

   // OpenCAPI Write Command Channel
   output                         oc_write_command_ready,
   output [ID_WIDTH - 1 : 0]      oc_write_command_ready_id,
   output [ADDR_WIDTH - 1 : 0]    oc_write_command_ready_address,
   output [7 : 0]                 oc_write_command_ready_length,
   output [2 : 0]                 oc_write_command_ready_size,
   output [OC_DATA_WIDTH - 1 : 0] oc_write_command_ready_data,
   output [OC_DATA_WIDTH - 1 : 0] oc_write_command_ready_data2,
   input                          oc_write_command_taken,

   // OpenCAPI Write Response Channel
   input                          oc_trans_bvalid,
   input [ID_WIDTH - 1 : 0]       oc_trans_bid,
   input [1 : 0]                  oc_trans_bresp,

   // OpenCAPI Read Command Channel
   output                         oc_read_command_ready,
   output [ID_WIDTH - 1 : 0]      oc_read_command_ready_id,
   output [ADDR_WIDTH - 1 : 0]    oc_read_command_ready_address,
   output [7 : 0]                 oc_read_command_ready_length,
   output [2 : 0]                 oc_read_command_ready_size,
   input                          oc_read_command_taken,

   // OpenCAPI Read Data Channel
   input                          oc_trans_rvalid,
   input [ID_WIDTH - 1 : 0]       oc_trans_rid,
   input [OC_DATA_WIDTH - 1 : 0]  oc_trans_rdata,
   input [1 : 0]                  oc_trans_rresp,
   input [2 : 0]                  oc_trans_ruser,

   // Transaction Status Tracking
   input [ID_WIDTH - 1 : 0]       outstanding_oc_lookup_id,
   output [ADDR_WIDTH - 1 : 0]    outstanding_read_araddr_oc_lookup,
   output [7 : 0]                 outstanding_read_arlen_oc_lookup,
   output [2 : 0]                 outstanding_read_arsize_oc_lookup
   );

   parameter ID_COUNT = 2**ID_WIDTH;

   wire [1 : 0]             axi_write_response_ready_response;
   wire                     axi_write_response_ready;
   wire [ID_WIDTH - 1 : 0]  axi_write_response_ready_id;
   wire                     axi_write_response_taken;
   wire [OC_DATA_WIDTH-1:0] axi_read_data_ready_data;
   wire [1 : 0]             axi_read_data_ready_response;
   wire [2 : 0]             axi_read_data_ready_user;
   wire                     axi_read_data_ready;
   wire [ID_WIDTH - 1 : 0]  axi_read_data_ready_id;
   wire                     axi_read_data_taken;
   wire [7 : 0]             outstanding_read_arlen_axi_lookup;
   wire                     write_address_block;
   wire                     write_data_block;
   wire                     read_address_block;

   /*
    * AXI Write Address Channel
    */
   parameter ST_AXI_WRITE_ADDRESS_IDLE          = 2'b00;
   parameter ST_AXI_WRITE_ADDRESS_GOT_VALID     = 2'b01;
   parameter ST_AXI_WRITE_ADDRESS_SENT_READY    = 2'b10;
   parameter ST_AXI_WRITE_ADDRESS_ERROR         = 2'b11;

   wire [1:0] axi_write_address_state_d;
   reg [1:0] axi_write_address_state_q;

   // Downstream
   wire [ID_WIDTH-1:0] axi_trans_awid;
   wire [ADDR_WIDTH-1:0] axi_trans_awaddr;
   wire [7:0] axi_trans_awlen;
   wire [2:0] axi_trans_awsize;
   // [1:0] s0_axi_awburst
   // [1:0] s0_axi_awlock
   // [3:0] s0_axi_awcache
   // [2:0] s0_axi_awprot
   wire axi_trans_awvalid;

   assign axi_write_address_state_d = (axi_write_address_state_q == ST_AXI_WRITE_ADDRESS_IDLE)       ? ((s0_axi_awvalid & ~write_address_block) ? ST_AXI_WRITE_ADDRESS_GOT_VALID : ST_AXI_WRITE_ADDRESS_IDLE) :
                                      (axi_write_address_state_q == ST_AXI_WRITE_ADDRESS_GOT_VALID)  ? ST_AXI_WRITE_ADDRESS_SENT_READY :
                                      (axi_write_address_state_q == ST_AXI_WRITE_ADDRESS_SENT_READY) ? ST_AXI_WRITE_ADDRESS_IDLE :
                                      ST_AXI_WRITE_ADDRESS_ERROR;

   assign axi_trans_awid = s0_axi_awid;
   assign axi_trans_awaddr = s0_axi_awaddr;
   assign axi_trans_awlen = s0_axi_awlen;
   assign axi_trans_awsize = s0_axi_awsize;
   assign axi_trans_awvalid = (axi_write_address_state_q == ST_AXI_WRITE_ADDRESS_GOT_VALID);

   // Upstream
   assign s0_axi_awready = (axi_write_address_state_q == ST_AXI_WRITE_ADDRESS_GOT_VALID);

   /*
    * AXI Write Data Channel
    */
   parameter ST_AXI_WRITE_DATA_IDLE          = 3'b000;
   parameter ST_AXI_WRITE_DATA_GOT_VALID     = 3'b001;
   parameter ST_AXI_WRITE_DATA_LAST_BEAT     = 3'b010; // Unused state
   parameter ST_AXI_WRITE_DATA_SENT_READY    = 3'b011;
   parameter ST_AXI_WRITE_DATA_ERROR         = 3'b111;

   wire [2:0] axi_write_data_state_d;
   reg [2:0] axi_write_data_state_q;

   wire      write_beat_count_d; // Only support up to 2 beats
   reg       write_beat_count_q;

   // Downstream
   wire [ID_WIDTH-1:0] axi_trans_wid;
   wire [OC_DATA_WIDTH-1:0] axi_trans_wdata;
   wire [OC_DATA_WIDTH-1:0] axi_trans_wdata2;
   // s0_axi_wstrb,
   wire axi_trans_wvalid;

   reg [OC_DATA_WIDTH-1:0] write_data_q;

   assign axi_write_data_state_d = (axi_write_data_state_q == ST_AXI_WRITE_DATA_IDLE)       ? ((s0_axi_wvalid & ~write_data_block) ? ST_AXI_WRITE_DATA_GOT_VALID : ST_AXI_WRITE_DATA_IDLE) :
                                   (axi_write_data_state_q == ST_AXI_WRITE_DATA_GOT_VALID)  ? (~s0_axi_wlast ? ST_AXI_WRITE_DATA_GOT_VALID : ST_AXI_WRITE_DATA_SENT_READY) :
                                   (axi_write_data_state_q == ST_AXI_WRITE_DATA_SENT_READY) ? ST_AXI_WRITE_DATA_IDLE :
                                   ST_AXI_WRITE_DATA_ERROR;
   //assign axi_write_data_state_d = (axi_write_data_state_q == ST_AXI_WRITE_DATA_IDLE)       ? ((s0_axi_wvalid & ~outstanding_write_data_valid[s0_axi_awid]) ? 
   //                                                                                            (s0_axi_wlast ? ST_AXI_WRITE_DATA_LAST_BEAT : ST_AXI_WRITE_DATA_GOT_VALID) :
   //                                                                                            ST_AXI_WRITE_DATA_IDLE) :
   //                                (axi_write_data_state_q == ST_AXI_WRITE_DATA_GOT_VALID)  ? (s0_axi_wlast ? ST_AXI_WRITE_DATA_LAST_BEAT : ST_AXI_WRITE_DATA_GOT_VALID) :
   //                                (axi_write_data_state_q == ST_AXI_WRITE_DATA_LAST_BEAT)  ? ST_AXI_WRITE_DATA_SENT_READY :
   //                                (axi_write_data_state_q == ST_AXI_WRITE_DATA_SENT_READY) ? (s0_axi_wvalid ? ST_AXI_WRITE_DATA_SENT_READY : ST_AXI_WRITE_DATA_IDLE) :
   //                                ST_AXI_WRITE_DATA_ERROR;

   assign write_beat_count_d = (axi_write_data_state_q == ST_AXI_WRITE_DATA_GOT_VALID) ? write_beat_count_q + 1'b1 : 1'b0;

   assign axi_trans_wid = s0_axi_wid;
   always @(posedge s0_axi_aclk) begin
      if (s0_axi_wvalid == 1'b1) begin
         write_data_q <= s0_axi_wdata;
      end
   end
   assign axi_trans_wdata2 = write_data_q[AXI_DATA_WIDTH-1:0];
   assign axi_trans_wdata = s0_axi_wdata[AXI_DATA_WIDTH-1:0];
   assign axi_trans_wvalid = (axi_write_data_state_q == ST_AXI_WRITE_DATA_GOT_VALID) & s0_axi_wlast;

   // Upstream
   assign s0_axi_wready = (axi_write_data_state_q == ST_AXI_WRITE_DATA_GOT_VALID) | 
                          (axi_write_data_state_q == ST_AXI_WRITE_DATA_LAST_BEAT);

   /*
    * AXI Write Response Channel
    */
   // For FBIST, we can assume ready will also we asserted
   assign axi_write_response_taken = axi_write_response_ready;

   assign s0_axi_bid = axi_write_response_ready_id;
   assign s0_axi_bresp = axi_write_response_ready_response;
   assign s0_axi_bvalid = axi_write_response_ready;

   /*
    * AXI Read Address Channel
    */
   parameter ST_AXI_READ_ADDRESS_IDLE          = 2'b00;
   parameter ST_AXI_READ_ADDRESS_GOT_VALID     = 2'b01;
   parameter ST_AXI_READ_ADDRESS_SENT_READY    = 2'b10;
   parameter ST_AXI_READ_ADDRESS_ERROR         = 2'b11;

   wire [1:0] axi_read_address_state_d;
   reg [1:0] axi_read_address_state_q;

   // Downstream
   wire [ID_WIDTH-1:0] axi_trans_arid;
   wire [ADDR_WIDTH-1:0] axi_trans_araddr;
   wire [7:0] axi_trans_arlen;
   wire [2:0] axi_trans_arsize;
   // [1:0] s0_axi_arburst
   // [1:0] s0_axi_arlock
   // [3:0] s0_axi_arcache
   // [2:0] s0_axi_arprot
   wire axi_trans_arvalid;

   assign axi_read_address_state_d = (axi_read_address_state_q == ST_AXI_READ_ADDRESS_IDLE)       ? ((s0_axi_arvalid & ~read_address_block) ? ST_AXI_READ_ADDRESS_GOT_VALID : ST_AXI_READ_ADDRESS_IDLE) :
                                     (axi_read_address_state_q == ST_AXI_READ_ADDRESS_GOT_VALID)  ? ST_AXI_READ_ADDRESS_SENT_READY :
                                     (axi_read_address_state_q == ST_AXI_READ_ADDRESS_SENT_READY) ? ST_AXI_READ_ADDRESS_IDLE :
                                      ST_AXI_READ_ADDRESS_ERROR;

   assign axi_trans_arid = s0_axi_arid;
   assign axi_trans_araddr = s0_axi_araddr;
   assign axi_trans_arlen = s0_axi_arlen;
   assign axi_trans_arsize = s0_axi_arsize;
   assign axi_trans_arvalid = (axi_read_address_state_q == ST_AXI_READ_ADDRESS_GOT_VALID);

   // Upstream
   assign s0_axi_arready = (axi_read_address_state_q == ST_AXI_READ_ADDRESS_GOT_VALID);

   /*
    * AXI Read Data Channel
    */
   // For FBIST, we can assume ready will also we asserted and we only
   // have one beat of data.
   assign axi_read_data_taken = axi_read_data_ready;

   assign s0_axi_rid = axi_read_data_ready_id;
   assign s0_axi_rdata = axi_read_data_ready_data[AXI_DATA_WIDTH-1:0];
   assign s0_axi_rresp = axi_read_data_ready_response;
   assign s0_axi_rlast = 1'b1;
   assign s0_axi_ruser = axi_read_data_ready_user;
   assign s0_axi_rvalid = axi_read_data_ready;

   /*
    * LATCHES
    */
   always @(posedge s0_axi_aclk) begin
      if (!s0_axi_aresetn) begin
         axi_write_address_state_q <= ST_AXI_WRITE_ADDRESS_IDLE;
         axi_write_data_state_q <= ST_AXI_WRITE_DATA_IDLE;
         write_beat_count_q <= 1'b0;
         axi_read_address_state_q <= ST_AXI_READ_ADDRESS_IDLE;
      end
      else begin
         axi_write_address_state_q <= axi_write_address_state_d;
         axi_write_data_state_q <= axi_write_data_state_d;
         write_beat_count_q <= write_beat_count_d;
         axi_read_address_state_q <= axi_read_address_state_d;
      end
   end

   ocx_tlx_axi_trans_fbist
     #(.ADDR_WIDTH                        (ADDR_WIDTH                        ),
       .DATA_WIDTH                        (OC_DATA_WIDTH                     ),
       .ID_WIDTH                          (ID_WIDTH                          )
       )
   axi_trans
     (
      .s0_axi_aclk                        (s0_axi_aclk                       ),
      .s0_axi_aresetn                     (s0_axi_aresetn                    ),
      .axi_trans_awid                     (axi_trans_awid                    ),
      .axi_trans_awaddr                   (axi_trans_awaddr                  ),
      .axi_trans_awlen                    (axi_trans_awlen                   ),
      .axi_trans_awsize                   (axi_trans_awsize                  ),
      .axi_trans_awvalid                  (axi_trans_awvalid                 ),
      .axi_trans_wid                      (axi_trans_wid                     ),
      .axi_trans_wdata                    (axi_trans_wdata                   ),
      .axi_trans_wdata2                   (axi_trans_wdata2                  ),
      .axi_trans_wvalid                   (axi_trans_wvalid                  ),
      .axi_write_response_ready_response  (axi_write_response_ready_response ),
      .axi_write_response_ready           (axi_write_response_ready          ),
      .axi_write_response_ready_id        (axi_write_response_ready_id       ),
      .axi_write_response_taken           (axi_write_response_taken          ),
      .axi_trans_arid                     (axi_trans_arid                    ),
      .axi_trans_araddr                   (axi_trans_araddr                  ),
      .axi_trans_arlen                    (axi_trans_arlen                   ),
      .axi_trans_arsize                   (axi_trans_arsize                  ),
      .axi_trans_arvalid                  (axi_trans_arvalid                 ),
      .axi_read_data_ready_data           (axi_read_data_ready_data          ),
      .axi_read_data_ready_response       (axi_read_data_ready_response      ),
      .axi_read_data_ready_user           (axi_read_data_ready_user          ),
      .axi_read_data_ready                (axi_read_data_ready               ),
      .axi_read_data_ready_id             (axi_read_data_ready_id            ),
      .axi_read_data_taken                (axi_read_data_taken               ),
      .oc_write_command_ready             (oc_write_command_ready            ),
      .oc_write_command_ready_id          (oc_write_command_ready_id         ),
      .oc_write_command_ready_address     (oc_write_command_ready_address    ),
      .oc_write_command_ready_length      (oc_write_command_ready_length     ),
      .oc_write_command_ready_size        (oc_write_command_ready_size       ),
      .oc_write_command_ready_data        (oc_write_command_ready_data       ),
      .oc_write_command_ready_data2       (oc_write_command_ready_data2      ),
      .oc_write_command_taken             (oc_write_command_taken            ),
      .oc_trans_bvalid                    (oc_trans_bvalid                   ),
      .oc_trans_bid                       (oc_trans_bid                      ),
      .oc_trans_bresp                     (oc_trans_bresp                    ),
      .oc_read_command_ready              (oc_read_command_ready             ),
      .oc_read_command_ready_id           (oc_read_command_ready_id          ),
      .oc_read_command_ready_address      (oc_read_command_ready_address     ),
      .oc_read_command_ready_length       (oc_read_command_ready_length      ),
      .oc_read_command_ready_size         (oc_read_command_ready_size        ),
      .oc_read_command_taken              (oc_read_command_taken             ),
      .oc_trans_rvalid                    (oc_trans_rvalid                   ),
      .oc_trans_rid                       (oc_trans_rid                      ),
      .oc_trans_rdata                     (oc_trans_rdata                    ),
      .oc_trans_rresp                     (oc_trans_rresp                    ),
      .oc_trans_ruser                     (oc_trans_ruser                    ),
      .write_address_block                (write_address_block               ),
      .write_data_block                   (write_data_block                  ),
      .read_address_block                 (read_address_block                )
      );

   assign outstanding_read_arlen_axi_lookup = 8'b0;
   assign outstanding_read_araddr_oc_lookup = {ADDR_WIDTH{1'b0}};
   assign outstanding_read_arlen_oc_lookup  = 8'b0;
   assign outstanding_read_arsize_oc_lookup = 3'b0;

endmodule
