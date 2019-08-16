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

module ocx_tlx_axi_rr
  #(
   parameter BITS   = 4,
   parameter SELFISH = 1
  ) (
   input                clock,
   input [2**BITS-1:0]  request,
   input                pause,
   output [2**BITS-1:0] select,
   output [BITS-1:0]    select_encode,
   output               select_valid
   );

   wire [2**BITS-1:0] select_int;

   // If we were doing a normal priority decoder, this is what we
   // would do. However, this can suffer starvation. We need this for
   // the base case, and we'll expand on it.
   wire [2**BITS-1:0] unmasked_select;
   assign unmasked_select = request & (~request + {{2**BITS-1{1'b0}},1'b1});

   // We don't want to select requests we've already done, until we
   // wrap around. So store the last one selected, and mask off that
   // one and every lower one.
   wire [2**BITS-1:0] prev_sel_mask;
   wire [2**BITS-1:0] prev_sel_d;
   reg [2**BITS-1:0]  prev_sel_q;

   assign prev_sel_d = select_int;
   // A SELFISH Arbiter won't select another input as long as the
   // currently selected request is still asserted. This would starve
   // other inputs until the current selection is not requested, at
   // which point the arbiter will move on. A non-SELFISH arbiter will
   // select the next input every single cycle, and not select the
   // same input 2 cycles in a row as long as there are 2 or more
   // requests. We accomplish this by not masking off the request we
   // just selected in the SELFISH case.
   assign prev_sel_mask = (SELFISH == 1) ?              (prev_sel_q - {{2**BITS-1{1'b0}},1'b1}) :
                                           prev_sel_q | (prev_sel_q - {{2**BITS-1{1'b0}},1'b1});

   always @(posedge clock) begin
      if (pause == 0) begin
        prev_sel_q = prev_sel_d;
      end
   end

   // Do a priority decode on unmasked requests; aka pick a request we
   // haven't gotten to this time around.
   wire [2**BITS-1:0] masked_request;
   wire [2**BITS-1:0] masked_select;
   assign masked_request = request & ~prev_sel_mask;
   assign masked_select = masked_request & (~masked_request + {{2**BITS-1{1'b0}},1'b1});

   // If there is an unmasked request, pick it. Otherwise wrap around
   // and go with the normal priority decoder.
   assign select_int = |masked_select ? masked_select : unmasked_select;
   assign select = select_int;

   function [BITS-1:0] encode;
      input [2**BITS-1:0] select;
      integer             i;
      begin
         for(i = 0; i < 2**BITS; i = i + 1) begin
            if(select[i] == 1'b1) begin
               encode = i[BITS-1:0];
            end
         end
      end
   endfunction

   assign select_encode = encode(select_int);

   assign select_valid = |select_int;

endmodule
