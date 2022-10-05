`timescale 1ns / 1ps
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

module bram
  #(
    //----------------------------------------------------------------------
    parameter   NUM_COL         =  16,
    parameter   COL_WIDTH       =  32,
    parameter   ADDR_WIDTH      =  5
    // Addr  Width in bits : 2**ADDR_WIDTH = RAM Depth
    //----------------------------------------------------------------------
    )
   (
    input clock,

    input [NUM_COL-1:0] bram_wen_a,
    input [ADDR_WIDTH-1:0] bram_addr_a,
    input [NUM_COL*COL_WIDTH-1:0] bram_din_a,
    output reg [NUM_COL*COL_WIDTH-1:0] bram_dout_a,

    input [NUM_COL-1:0] bram_wen_b,
    input [ADDR_WIDTH-1:0] bram_addr_b,
    input [NUM_COL*COL_WIDTH-1:0] bram_din_b,
    output reg [NUM_COL*COL_WIDTH-1:0] bram_dout_b
    );

   wire                            bram_clock_a, bram_clock_b;
   wire                            bram_en_a, bram_en_b;

   // Core Memory
   (* ram_style = "block" *) reg [NUM_COL*COL_WIDTH-1:0]     ram_block [(2**ADDR_WIDTH)-1:0];

   assign bram_clock_a = clock;
   assign bram_clock_b = clock;
   assign bram_en_a = 1'b1;
   assign bram_en_b = 1'b1;

   // Port-A Operation
   generate
      genvar i;
      for(i=0;i<NUM_COL;i=i+1) begin : port_a
         always @ (posedge bram_clock_a) begin
            if(bram_en_a) begin
               if(bram_wen_a[i]) begin
                  ram_block[bram_addr_a][i*COL_WIDTH + COL_WIDTH - 1:i*COL_WIDTH] <= bram_din_a[i*COL_WIDTH + COL_WIDTH - 1:i*COL_WIDTH];
                  bram_dout_a[i*COL_WIDTH + COL_WIDTH - 1:i*COL_WIDTH] <= bram_din_a[i*COL_WIDTH + COL_WIDTH - 1:i*COL_WIDTH] ;
               end else begin
                  bram_dout_a[i*COL_WIDTH + COL_WIDTH - 1:i*COL_WIDTH] <= ram_block[bram_addr_a][i*COL_WIDTH + COL_WIDTH - 1:i*COL_WIDTH] ;
               end
            end
         end
      end
   endgenerate

   // Port-B Operation:
   generate
      for(i=0;i<NUM_COL;i=i+1) begin : port_b
         always @ (posedge bram_clock_b) begin
            if(bram_en_b) begin
               if(bram_wen_b[i]) begin
                  ram_block[bram_addr_b][i*COL_WIDTH + COL_WIDTH - 1:i*COL_WIDTH] <= bram_din_b[i*COL_WIDTH + COL_WIDTH - 1:i*COL_WIDTH];
                  bram_dout_b[i*COL_WIDTH + COL_WIDTH - 1:i*COL_WIDTH] <= bram_din_b[i*COL_WIDTH + COL_WIDTH - 1:i*COL_WIDTH] ;
               end else begin
                  bram_dout_b[i*COL_WIDTH + COL_WIDTH - 1:i*COL_WIDTH] <= ram_block[bram_addr_b][i*COL_WIDTH + COL_WIDTH - 1:i*COL_WIDTH] ;
               end
            end
         end
      end
   endgenerate

endmodule // bram
