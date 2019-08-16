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

// From: https://www.xilinx.com/support/documentation/sw_manuals/xilinx2014_2/ug901-vivado-synthesis.pdf
//       page 104 "Simple Dual-Port Block RAM with Single Clock Verilog Coding Example"

module aram_1r1w1ck_64x513
   (clk,ena,enb,wea,addra,addrb,dia,dob);
   input clk,ena,enb,wea;
   input [5:0] addra,addrb;
   input [512:0] dia;
   output [512:0] dob;
   reg[512:0] ram [63:0];
   reg[512:0] dob;

always @(posedge clk) begin
 if (ena) begin
    if (wea)
        ram[addra] <= dia;
 end
end

always @(posedge clk) begin
  if (enb)
    dob <= ram[addrb];
end

endmodule

