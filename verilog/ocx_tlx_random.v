`timescale 1ns / 10ps//
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

module ocx_tlx_random (clock, resetn, rand);
input clock,resetn;
output reg [7:0] rand;

wire feedback;
assign feedback = ~(rand[7] ^ rand[6]);

always @(posedge clock)

begin

if (resetn == 1'b0)
    rand = 8'h42;
else
    rand = {rand[6:0],feedback};
end
endmodule

