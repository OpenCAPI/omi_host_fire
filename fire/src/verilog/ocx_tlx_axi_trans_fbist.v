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

module ocx_tlx_axi_trans_fbist
  #(
   // Generics don't work perfectly because BRAM widths need to be a multiple of 32 and thus are manual
   parameter ADDR_WIDTH = 64,
   parameter DATA_WIDTH = 512,
   parameter ID_WIDTH = 12
  ) (
   input                            s0_axi_aclk,
   input                            s0_axi_aresetn,

   // AXI Write Address Channel (Input)
   input [ID_WIDTH - 1 : 0]         axi_trans_awid,
   input [ADDR_WIDTH - 1 : 0]       axi_trans_awaddr,
   input [7 : 0]                    axi_trans_awlen,
   input [2 : 0]                    axi_trans_awsize,
   input                            axi_trans_awvalid,

   // AXI Write Data Channel (Input)
   input [ID_WIDTH - 1 : 0]         axi_trans_wid,
   input [DATA_WIDTH - 1 : 0]       axi_trans_wdata,
   input [DATA_WIDTH - 1 : 0]       axi_trans_wdata2,
   input                            axi_trans_wvalid,

   // AXI Write Response Channel (Output)
   output [ID_WIDTH - 1 : 0]        axi_write_response_ready_id,
   output [1 : 0]                   axi_write_response_ready_response,
   output                           axi_write_response_ready,
   input                            axi_write_response_taken,

   // AXI Read Address Channel (Input)
   input [ID_WIDTH - 1 : 0]         axi_trans_arid,
   input [ADDR_WIDTH - 1 : 0]       axi_trans_araddr,
   input [7 : 0]                    axi_trans_arlen,
   input [2 : 0]                    axi_trans_arsize,
   input                            axi_trans_arvalid,

   // AXI Read Data Channel (Output)
   output [ID_WIDTH - 1 : 0]        axi_read_data_ready_id,
   output [DATA_WIDTH - 1 : 0]      axi_read_data_ready_data,
   output [1 : 0]                   axi_read_data_ready_response,
   output [2 : 0]                   axi_read_data_ready_user,
   output                           axi_read_data_ready,
   input                            axi_read_data_taken,

   // OpenCAPI Write Command Channel (Output)
   output [ID_WIDTH - 1 : 0]        oc_write_command_ready_id,
   output [ADDR_WIDTH - 1 : 0]      oc_write_command_ready_address,
   output [7 : 0]                   oc_write_command_ready_length,
   output [2 : 0]                   oc_write_command_ready_size,
   output [DATA_WIDTH - 1 : 0]      oc_write_command_ready_data,
   output [DATA_WIDTH - 1 : 0]      oc_write_command_ready_data2,
   output                           oc_write_command_ready,
   input                            oc_write_command_taken,

   // OpenCAPI Write Response Channel (Input)
   input [ID_WIDTH - 1 : 0]         oc_trans_bid,
   input [1 : 0]                    oc_trans_bresp,
   input                            oc_trans_bvalid,

   // OpenCAPI Read Command Channel (Output)
   output [ID_WIDTH - 1 : 0]        oc_read_command_ready_id,
   output [ADDR_WIDTH - 1 : 0]      oc_read_command_ready_address,
   output [7 : 0]                   oc_read_command_ready_length,
   output [2 : 0]                   oc_read_command_ready_size,
   output                           oc_read_command_ready,
   input                            oc_read_command_taken,

   // OpenCAPI Read Data Channel (Input)
   input [ID_WIDTH - 1 : 0]         oc_trans_rid,
   input [DATA_WIDTH - 1 : 0]       oc_trans_rdata,
   input [1 : 0]                    oc_trans_rresp,
   input [2 : 0]                    oc_trans_ruser,
   input                            oc_trans_rvalid,

   // Transaction Status Tracking

   // Used to store read and write transactions that are anywhere in
   // flight. We only need to start the valids. The address/length are
   // available in the pending arrays, which we don't clear.
   output write_address_block, //output reg [2**ID_WIDTH - 1 : 0] outstanding_write_valid,
   output write_data_block, //output reg [2**ID_WIDTH - 1 : 0] outstanding_write_data_valid,
   output read_address_block //output reg [2**ID_WIDTH - 1 : 0] outstanding_read_valid,
   );

   wire [95 : 0] axi_write_address_fifo_in;
   wire [95 : 0] axi_write_address_fifo_out;
   wire          axi_write_address_fifo_write;
   wire          axi_write_address_fifo_full;
   wire          axi_write_address_fifo_empty;

   wire [1023 : 0] axi_write_data_fifo_in;
   wire [1023 : 0] axi_write_data_fifo_out;
   wire            axi_write_data_fifo_write;
   wire            axi_write_data_fifo_full;
   wire            axi_write_data_fifo_empty;

   wire [95 : 0] axi_read_address_fifo_in;
   wire [95 : 0] axi_read_address_fifo_out;
   wire          axi_read_address_fifo_write;
   wire          axi_read_address_fifo_full;
   wire          axi_read_address_fifo_empty;

   wire [31 : 0] axi_write_response_fifo_in;
   reg  [31 : 0] axi_write_response_fifo_out;
   wire          axi_write_response_fifo_write;
// wire          axi_write_response_fifo_full;
   reg           axi_write_response_fifo_empty;

   wire [543 : 0] axi_read_data_fifo_in;
   reg  [543 : 0] axi_read_data_fifo_out;
   wire           axi_read_data_fifo_write;
// wire           axi_read_data_fifo_full;
   reg            axi_read_data_fifo_empty;

   // Channel Controls
   assign write_address_block = axi_write_address_fifo_full;
   assign write_data_block    = axi_write_data_fifo_full;
   assign read_address_block  = axi_read_address_fifo_full;

   // AXI Write Address Channel (Input)
   assign axi_write_address_fifo_in[ID_WIDTH - 1                  : 0]                         = axi_trans_awid;
   assign axi_write_address_fifo_in[ADDR_WIDTH - 1 + ID_WIDTH     : ID_WIDTH]                  = axi_trans_awaddr;
   assign axi_write_address_fifo_in[7 + ADDR_WIDTH + ID_WIDTH     : ADDR_WIDTH + ID_WIDTH]     = axi_trans_awlen;
   assign axi_write_address_fifo_in[2 + 8 + ADDR_WIDTH + ID_WIDTH : 8 + ADDR_WIDTH + ID_WIDTH] = axi_trans_awsize;
   assign axi_write_address_fifo_in[95 : 87]                                                   = 9'b0;
   assign axi_write_address_fifo_write                                                         = axi_trans_awvalid;

   sync_fifo_dist
     #(.WIDTH         ( 96 ),
       .ADDRESS_WIDTH ( 2  )
       )
   axi_write_address_fifo
     (
      .clock        ( s0_axi_aclk                  ),
      .reset        ( ~s0_axi_aresetn              ),
      .w_full       ( axi_write_address_fifo_full  ),
      .r_empty      ( axi_write_address_fifo_empty ),
      .w_data       ( axi_write_address_fifo_in    ),
      .w_data_valid ( axi_write_address_fifo_write ),
      .r_data       ( axi_write_address_fifo_out   ),
      .r_data_taken ( oc_write_command_taken       )
      );

   // AXI Write Data Channel (Input)
   //assign axi_write_data_fifo_in = axi_trans_wid; // assert = axi_trans_awid
   assign axi_write_data_fifo_in[DATA_WIDTH - 1              : 0]          = axi_trans_wdata;
   assign axi_write_data_fifo_in[DATA_WIDTH - 1 + DATA_WIDTH : DATA_WIDTH] = axi_trans_wdata2;
   assign axi_write_data_fifo_write = axi_trans_wvalid;

   sync_fifo_dist
     #(.WIDTH         ( 1024 ), // Needs to be a multiple of 32
       .ADDRESS_WIDTH ( 2    )
       )
   axi_write_data_fifo
     (
      .clock        ( s0_axi_aclk               ),
      .reset        ( ~s0_axi_aresetn           ),
      .w_full       ( axi_write_data_fifo_full  ),
      .r_empty      ( axi_write_data_fifo_empty ),
      .w_data       ( axi_write_data_fifo_in    ),
      .w_data_valid ( axi_write_data_fifo_write ),
      .r_data       ( axi_write_data_fifo_out   ),
      .r_data_taken ( oc_write_command_taken    )
      );

   // AXI Write Response Channel (Output)
   assign axi_write_response_ready_id       = axi_write_response_fifo_out[ID_WIDTH - 1 : 0];
   assign axi_write_response_ready_response = axi_write_response_fifo_out[1 + ID_WIDTH : ID_WIDTH];
   assign axi_write_response_ready          = ~axi_write_response_fifo_empty;

   // AXI Read Address Channel (Input)
   assign axi_read_address_fifo_in[ID_WIDTH - 1                  : 0]                         = axi_trans_arid;
   assign axi_read_address_fifo_in[ADDR_WIDTH - 1 + ID_WIDTH     : ID_WIDTH]                  = axi_trans_araddr;
   assign axi_read_address_fifo_in[7 + ADDR_WIDTH + ID_WIDTH     : ADDR_WIDTH + ID_WIDTH]     = axi_trans_arlen;
   assign axi_read_address_fifo_in[2 + 8 + ADDR_WIDTH + ID_WIDTH : 8 + ADDR_WIDTH + ID_WIDTH] = axi_trans_arsize;
   assign axi_read_address_fifo_in[95 : 87]                                                   = 9'b0;
   assign axi_read_address_fifo_write                                                         = axi_trans_arvalid;

   sync_fifo_dist
     #(.WIDTH         ( 96 ), // Needs to be a multiple of 32
       .ADDRESS_WIDTH ( 2  )
       )
   axi_read_address_fifo
     (
      .clock        ( s0_axi_aclk                 ),
      .reset        ( ~s0_axi_aresetn             ),
      .w_full       ( axi_read_address_fifo_full  ),
      .r_empty      ( axi_read_address_fifo_empty ),
      .w_data       ( axi_read_address_fifo_in    ),
      .w_data_valid ( axi_read_address_fifo_write ),
      .r_data       ( axi_read_address_fifo_out   ),
      .r_data_taken ( oc_read_command_taken       )
      );

   // AXI Read Data Channel (Output)
   assign axi_read_data_ready_id       = axi_read_data_fifo_out[ID_WIDTH - 1                  : 0];
   assign axi_read_data_ready_data     = axi_read_data_fifo_out[DATA_WIDTH - 1 + ID_WIDTH     : ID_WIDTH];
   assign axi_read_data_ready_response = axi_read_data_fifo_out[1 + DATA_WIDTH + ID_WIDTH     : DATA_WIDTH + ID_WIDTH];
   assign axi_read_data_ready_user     = axi_read_data_fifo_out[2 + 2 + DATA_WIDTH + ID_WIDTH : 2 + DATA_WIDTH + ID_WIDTH];
   assign axi_read_data_ready          = ~axi_read_data_fifo_empty;

   // OpenCAPI Write Command Channel (Output)
   assign oc_write_command_ready_id      = axi_write_address_fifo_out[ID_WIDTH - 1              : 0];
   assign oc_write_command_ready_address = axi_write_address_fifo_out[ADDR_WIDTH - 1 + ID_WIDTH : ID_WIDTH];
   assign oc_write_command_ready_length  = axi_write_address_fifo_out[7 + ADDR_WIDTH + ID_WIDTH : ADDR_WIDTH + ID_WIDTH];
   assign oc_write_command_ready_size    = axi_write_address_fifo_out[2 + 8 + ADDR_WIDTH + ID_WIDTH : 8 + ADDR_WIDTH + ID_WIDTH];
   assign oc_write_command_ready_data    = axi_write_data_fifo_out[DATA_WIDTH - 1               : 0];
   assign oc_write_command_ready_data2   = axi_write_data_fifo_out[DATA_WIDTH - 1 + DATA_WIDTH  : DATA_WIDTH];
   assign oc_write_command_ready         = ~axi_write_address_fifo_empty & ~axi_write_data_fifo_empty;

   // OpenCAPI Write Response Channel (Input)
   assign axi_write_response_fifo_in[ID_WIDTH - 1 : 0]        = oc_trans_bid;
   assign axi_write_response_fifo_in[1 + ID_WIDTH : ID_WIDTH] = oc_trans_bresp;
   assign axi_write_response_fifo_in[31 : 14]                 = 18'b0;
   assign axi_write_response_fifo_write                       = oc_trans_bvalid;

   always @(posedge s0_axi_aclk) begin
     axi_write_response_fifo_out   <= axi_write_response_fifo_in;
     axi_write_response_fifo_empty <= ~axi_write_response_fifo_write;
   end

   // OpenCAPI Read Command Channel (Output)
   assign oc_read_command_ready_id      = axi_read_address_fifo_out[ID_WIDTH - 1              : 0];
   assign oc_read_command_ready_address = axi_read_address_fifo_out[ADDR_WIDTH - 1 + ID_WIDTH : ID_WIDTH];
   assign oc_read_command_ready_length  = axi_read_address_fifo_out[7 + ADDR_WIDTH + ID_WIDTH : ADDR_WIDTH + ID_WIDTH];
   assign oc_read_command_ready_size    = axi_read_address_fifo_out[2 + 8 + ADDR_WIDTH + ID_WIDTH : 8 + ADDR_WIDTH + ID_WIDTH];
   assign oc_read_command_ready         = ~axi_read_address_fifo_empty;

   // OpenCAPI Read Data Channel (Input)
   assign axi_read_data_fifo_in[ID_WIDTH - 1 : 0]                                          = oc_trans_rid;
   assign axi_read_data_fifo_in[DATA_WIDTH - 1 + ID_WIDTH : ID_WIDTH]                      = oc_trans_rdata;
   assign axi_read_data_fifo_in[1 + DATA_WIDTH + ID_WIDTH : DATA_WIDTH + ID_WIDTH]         = oc_trans_rresp;
   assign axi_read_data_fifo_in[2 + 2 + DATA_WIDTH + ID_WIDTH : 2 + DATA_WIDTH + ID_WIDTH] = oc_trans_ruser;
   assign axi_read_data_fifo_in[543 : 529]                                                 = 15'b0;
   assign axi_read_data_fifo_write                                                         = oc_trans_rvalid;

   always @(posedge s0_axi_aclk) begin
     axi_read_data_fifo_out   <= axi_read_data_fifo_in;
     axi_read_data_fifo_empty <= ~axi_read_data_fifo_write;
   end

endmodule
