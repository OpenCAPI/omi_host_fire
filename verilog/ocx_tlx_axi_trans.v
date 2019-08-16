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

module ocx_tlx_axi_trans
  #(
   parameter ADDR_WIDTH = 64,
   parameter DATA_WIDTH = 64,
   parameter ID_WIDTH = 4
  ) (
   input                            s0_axi_aclk,
   input                            s0_axi_aresetn,

   // AXI Write Address Channel (Input)
   input [ID_WIDTH - 1 : 0]         axi_trans_awid,
   input [ADDR_WIDTH - 1 : 0]       axi_trans_awaddr,
   input [7 : 0]                    axi_trans_awlen,
   input                            axi_trans_awvalid,

   // AXI Write Data Channel (Input)
   input [ID_WIDTH - 1 : 0]         axi_trans_wid,
   input [DATA_WIDTH - 1 : 0]       axi_trans_wdata,
   input [DATA_WIDTH - 1 : 0]       axi_trans_wdata2,
   input                            axi_trans_wvalid,

   // AXI Write Response Channel (Output)
   output [1 : 0]                   axi_write_response_ready_response,
   output                           axi_write_response_ready,
   output [ID_WIDTH - 1 : 0]        axi_write_response_ready_id,
   input                            axi_write_response_taken,

   // AXI Read Address Channel (Input)
   input [ID_WIDTH - 1 : 0]         axi_trans_arid,
   input [ADDR_WIDTH - 1 : 0]       axi_trans_araddr, 
   input [7 : 0]                    axi_trans_arlen,
   input                            axi_trans_arvalid,

   // AXI Read Data Channel (Output)
   output [DATA_WIDTH - 1 : 0]      axi_read_data_ready_data,
   output [1 : 0]                   axi_read_data_ready_response,
   output [2 : 0]                   axi_read_data_ready_user,
   output                           axi_read_data_ready,
   output [ID_WIDTH - 1 : 0]        axi_read_data_ready_id,
   input                            axi_read_data_taken,

   // OpenCAPI Write Command Channel (Output)
   output [ADDR_WIDTH - 1 : 0]      oc_write_command_ready_address,
   output [7 : 0]                   oc_write_command_ready_length,
   output [DATA_WIDTH - 1 : 0]      oc_write_command_ready_data,
   output [DATA_WIDTH - 1 : 0]      oc_write_command_ready_data2,
   output                           oc_write_command_ready,
   output [ID_WIDTH - 1 : 0]        oc_write_command_ready_id,
   input                            oc_write_command_taken,

   // OpenCAPI Write Response Channel (Input)
   input                            oc_trans_bvalid,
   input [ID_WIDTH - 1 : 0]         oc_trans_bid,
   input [1 : 0]                    oc_trans_bresp,

   // OpenCAPI Read Command Channel (Output)
   output [ADDR_WIDTH - 1 : 0]      oc_read_command_ready_address,
   output [7 : 0]                   oc_read_command_ready_length,
   output                           oc_read_command_ready,
   output [ID_WIDTH - 1 : 0]        oc_read_command_ready_id,
   input                            oc_read_command_taken,

   // OpenCAPI Read Data Channel (Input)
   input                            oc_trans_rvalid,
   input [ID_WIDTH - 1 : 0]         oc_trans_rid,
   input [DATA_WIDTH - 1 : 0]       oc_trans_rdata,
   input [1 : 0]                    oc_trans_rresp,
   input [2 : 0]                    oc_trans_ruser,

   // Transaction Status Tracking

   // Used to store read and write transactions that are anywhere in
   // flight. We only need to start the valids. The address/length are
   // available in the pending arrays, which we don't clear.
   output reg [2**ID_WIDTH - 1 : 0] outstanding_write_valid,
   output reg [2**ID_WIDTH - 1 : 0] outstanding_write_data_valid,
   output reg [2**ID_WIDTH - 1 : 0] outstanding_read_valid,
   input [ID_WIDTH - 1 : 0]         outstanding_axi_lookup_id,
   output [7 : 0]                   outstanding_read_arlen_axi_lookup,
   input [ID_WIDTH - 1 : 0]         outstanding_oc_lookup_id,
   output [ADDR_WIDTH - 1 : 0]      outstanding_read_araddr_oc_lookup,
   output [7 : 0]                   outstanding_read_arlen_oc_lookup
   );

   // Used to store transactions we've received but not started
   reg [2**ID_WIDTH - 1 : 0] pending_axi_write_address_valid;
   reg [ADDR_WIDTH - 1 : 0]  pending_axi_write_address_awaddr[2**ID_WIDTH - 1 : 0];
   reg [7 : 0]               pending_axi_write_address_awlen[2**ID_WIDTH - 1 : 0];
   reg [2**ID_WIDTH - 1 : 0] pending_axi_write_data_valid;
   reg [DATA_WIDTH - 1 : 0]  pending_axi_write_data_wdata[2**ID_WIDTH - 1 : 0];
   reg [DATA_WIDTH - 1 : 0]  pending_axi_write_data_wdata2[2**ID_WIDTH - 1 : 0];
   reg [2**ID_WIDTH - 1 : 0] pending_oc_write_response_valid;
   reg [1:0]                 pending_oc_write_response_bresp[2**ID_WIDTH - 1 : 0];
   reg [2**ID_WIDTH - 1 : 0] pending_axi_read_address_valid;
   reg [ADDR_WIDTH - 1 : 0]  pending_axi_read_address_araddr[2**ID_WIDTH - 1 : 0];
   reg [7 : 0]               pending_axi_read_address_arlen[2**ID_WIDTH - 1 : 0];
   reg [2**ID_WIDTH - 1 : 0] pending_oc_read_data_valid;
   reg [DATA_WIDTH - 1 : 0]  pending_oc_read_data_rdata[2**ID_WIDTH - 1 : 0];
   reg [1:0]                 pending_oc_read_data_rresp[2**ID_WIDTH - 1 : 0];
   reg [2:0]                 pending_oc_read_data_ruser[2**ID_WIDTH - 1 : 0];

   wire [2**ID_WIDTH - 1 : 0] axi_write_response_ready_decode; // Unused
   wire [ID_WIDTH - 1 : 0]    axi_write_response_ready_id_int;
   wire [2**ID_WIDTH - 1 : 0] axi_read_data_ready_decode;      // Unused
   wire [ID_WIDTH - 1 : 0]    axi_read_data_ready_id_int;
   wire [2**ID_WIDTH - 1 : 0] oc_write_command_ready_decode;   // Unused
   wire [ID_WIDTH - 1 : 0]    oc_write_command_ready_id_int;
   wire [2**ID_WIDTH - 1 : 0] oc_read_command_ready_decode;    // Unused
   wire [ID_WIDTH - 1 : 0]    oc_read_command_ready_id_int;

   assign outstanding_read_arlen_axi_lookup = pending_axi_read_address_arlen[outstanding_axi_lookup_id];
   assign outstanding_read_araddr_oc_lookup = pending_axi_read_address_araddr[outstanding_oc_lookup_id];
   assign outstanding_read_arlen_oc_lookup = pending_axi_read_address_arlen[outstanding_oc_lookup_id];

   // AXI Write Address Channel (Input)
   always @(posedge s0_axi_aclk) begin
      if (~s0_axi_aresetn) begin
         outstanding_write_valid <= {2**ID_WIDTH{1'b0}};
         pending_axi_write_address_valid <= {2**ID_WIDTH{1'b0}};
      end
      else begin
         if (axi_trans_awvalid) begin
            outstanding_write_valid[axi_trans_awid] <= 1'b1;
            pending_axi_write_address_valid[axi_trans_awid] <= 1'b1;
            pending_axi_write_address_awaddr[axi_trans_awid] <= axi_trans_awaddr;
            pending_axi_write_address_awlen[axi_trans_awid] <= axi_trans_awlen;
         end
         if (oc_write_command_taken) begin
            pending_axi_write_address_valid[oc_write_command_ready_id_int] <= 1'b0;
         end
         if (axi_write_response_taken) begin
            outstanding_write_valid[axi_write_response_ready_id_int] <= 1'b0;
         end
      end
   end

   // AXI Write Data Channel (Input)
   always @(posedge s0_axi_aclk) begin
      // No Error if already valid
      // No Error if response from opencapi has no tag
      // No error if taking and pushing same cycle
      if (~s0_axi_aresetn) begin
         outstanding_write_data_valid <= {2**ID_WIDTH{1'b0}};
         pending_axi_write_data_valid <= {2**ID_WIDTH{1'b0}};
      end
      else begin
         if (axi_trans_wvalid) begin
            outstanding_write_data_valid[axi_trans_wid] <= 1'b1;
            pending_axi_write_data_valid[axi_trans_wid] <= 1'b1;
            pending_axi_write_data_wdata[axi_trans_wid] <= axi_trans_wdata;
            pending_axi_write_data_wdata2[axi_trans_wid] <= axi_trans_wdata2;
         end
         if (oc_write_command_taken) begin
            pending_axi_write_data_valid[oc_write_command_ready_id_int] <= 1'b0;
         end
         if (axi_write_response_taken) begin
            outstanding_write_data_valid[axi_write_response_ready_id_int] <= 1'b0;
         end
      end
   end

   // AXI Write Response Channel (Output)
   assign axi_write_response_ready_id = axi_write_response_ready_id_int;
   assign axi_write_response_ready_response = pending_oc_write_response_bresp[axi_write_response_ready_id_int];

   ocx_tlx_axi_rr #(.BITS(ID_WIDTH))
   axi_write_response_arb
     (
      .clock         (s0_axi_aclk                    ),
      .request       (pending_oc_write_response_valid),
      .pause         (1'b0                           ),
      .select        (axi_write_response_ready_decode),
      .select_valid  (axi_write_response_ready       ),
      .select_encode (axi_write_response_ready_id_int)
      );

   // AXI Read Address Channel (Input)
   always @(posedge s0_axi_aclk) begin
      if (~s0_axi_aresetn) begin
         outstanding_read_valid <= {2**ID_WIDTH{1'b0}};
         pending_axi_read_address_valid <= {2**ID_WIDTH{1'b0}};
      end
      else begin
         if (axi_trans_arvalid) begin
            outstanding_read_valid[axi_trans_arid] <= 1'b1;
            pending_axi_read_address_valid[axi_trans_arid] <= 1'b1;
            pending_axi_read_address_araddr[axi_trans_arid] <= axi_trans_araddr;
            pending_axi_read_address_arlen[axi_trans_arid] <= axi_trans_arlen;
         end
         if (oc_read_command_taken) begin
            pending_axi_read_address_valid[oc_read_command_ready_id_int] <= 1'b0;
         end
         if (axi_read_data_taken) begin
            if (~(oc_trans_rvalid && oc_trans_rid == axi_read_data_ready_id_int)) begin
               outstanding_read_valid[axi_read_data_ready_id_int] <= 1'b0;
            end
         end
      end
   end

   // AXI Read Data Channel (Output)
   assign axi_read_data_ready_id = axi_read_data_ready_id_int;
   assign axi_read_data_ready_response = pending_oc_read_data_rresp[axi_read_data_ready_id_int];
   assign axi_read_data_ready_user = pending_oc_read_data_ruser[axi_read_data_ready_id_int];
   assign axi_read_data_ready_data = pending_oc_read_data_rdata[axi_read_data_ready_id_int];

   ocx_tlx_axi_rr #(.BITS(ID_WIDTH))
   axi_read_data_arb
     (
      .clock         (s0_axi_aclk               ),
      .request       (pending_oc_read_data_valid),
      .pause         (1'b0                      ),
      .select        (axi_read_data_ready_decode),
      .select_valid  (axi_read_data_ready       ),
      .select_encode (axi_read_data_ready_id_int)
      );

   // OpenCAPI Write Command Channel (Output)
   assign oc_write_command_ready_id = oc_write_command_ready_id_int;
   assign oc_write_command_ready_address = pending_axi_write_address_awaddr[oc_write_command_ready_id_int];
   assign oc_write_command_ready_length = pending_axi_write_address_awlen[oc_write_command_ready_id_int];
   assign oc_write_command_ready_data = pending_axi_write_data_wdata[oc_write_command_ready_id_int];
   assign oc_write_command_ready_data2 = pending_axi_write_data_wdata2[oc_write_command_ready_id_int];

   ocx_tlx_axi_rr #(.BITS(ID_WIDTH))
   oc_write_command_arb
     (
      .clock         (s0_axi_aclk                                                   ),
      .request       (pending_axi_write_address_valid & pending_axi_write_data_valid),
      .pause         (1'b0                                                          ),
      .select        (oc_write_command_ready_decode                                 ),
      .select_valid  (oc_write_command_ready                                        ),
      .select_encode (oc_write_command_ready_id_int                                 )
      );

   // OpenCAPI Write Response Channel (Input)
   always @(posedge s0_axi_aclk) begin
      if (~s0_axi_aresetn) begin
         pending_oc_write_response_valid <= {2**ID_WIDTH{1'b0}};
      end
      else begin
         if (oc_trans_bvalid) begin
            pending_oc_write_response_valid[oc_trans_bid] <= 1'b1;
            pending_oc_write_response_bresp[oc_trans_bid] <= oc_trans_bresp;
         end
         if (axi_write_response_taken) begin
            pending_oc_write_response_valid[axi_write_response_ready_id_int] <= 1'b0;
            //outstanding_write_valid[axi_write_response_ready_id_int] <= 1'b0;
            //outstanding_write_data_valid[axi_write_response_ready_id_int] <= 1'b0;
         end
      end
   end

   // OpenCAPI Read Command Channel (Output)
   assign oc_read_command_ready_id = oc_read_command_ready_id_int;
   assign oc_read_command_ready_address = pending_axi_read_address_araddr[oc_read_command_ready_id_int];
   assign oc_read_command_ready_length = pending_axi_read_address_arlen[oc_read_command_ready_id_int];

   ocx_tlx_axi_rr #(.BITS(ID_WIDTH))
   oc_read_command_arb
     (
      .clock         (s0_axi_aclk                   ),
      .request       (pending_axi_read_address_valid),
      .pause         (1'b0                          ),
      .select        (oc_read_command_ready_decode  ),
      .select_valid  (oc_read_command_ready         ),
      .select_encode (oc_read_command_ready_id_int  )
      );

   // OpenCAPI Read Data Channel (Input)
   always @(posedge s0_axi_aclk) begin
      if (~s0_axi_aresetn) begin
         pending_oc_read_data_valid <= {2**ID_WIDTH{1'b0}};
      end
      else begin
         if (oc_trans_rvalid) begin
            pending_oc_read_data_valid[oc_trans_rid] <= 1'b1;
            pending_oc_read_data_rdata[oc_trans_rid] <= oc_trans_rdata;
            pending_oc_read_data_rresp[oc_trans_rid] <= oc_trans_rresp;
            pending_oc_read_data_ruser[oc_trans_rid] <= oc_trans_ruser;
         end
         if (axi_read_data_taken) begin
            if (~(oc_trans_rvalid && oc_trans_rid == axi_read_data_ready_id_int)) begin
               pending_oc_read_data_valid[axi_read_data_ready_id_int] <= 1'b0;
               //outstanding_read_valid[axi_read_data_ready_id_int] <= 1'b0;
            end
         end
      end
   end

endmodule
