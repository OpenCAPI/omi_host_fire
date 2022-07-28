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

`define OPCODE_NOP                 8'h00
`define OPCODE_INTRP_RDY           8'h1A
`define OPCODE_RD_MEM              8'h20
`define OPCODE_PR_RD_MEM           8'h28
`define OPCODE_PAD_MEM             8'h80
`define OPCODE_WRITE_MEM           8'h81
`define OPCODE_WRITE_MEM_BE        8'h82
`define OPCODE_PR_WR_MEM           8'h86
`define OPCODE_CONFIG_READ         8'hE0
`define OPCODE_CONFIG_WRITE        8'hE1
`define OPCODE_MEM_CNTL            8'hEF
`define OPCODE_ASSIGN_ACTAG        8'h50
`define OPCODE_INTRP_REQ           8'h58
`define OPCODE_INTRP_REQ_D         8'h5A
`define OPCODE_RETURN_TLX_CREDITS  8'h01
`define OPCODE_INTRP_RESP          8'h0C
`define OPCODE_READ_RESPONSE_OW    8'h0D
`define OPCODE_READ_RESPONSE_XW    8'h0E
`define OPCODE_MEM_RD_RESPONSE     8'h01
`define OPCODE_MEM_RD_FAIL         8'h02
`define OPCODE_MEM_RD_RESPONSE_OW  8'h03
`define OPCODE_MEM_WR_RESPONSE     8'h04
`define OPCODE_MEM_WR_FAIL         8'h05
`define OPCODE_MEM_RD_RESPONSE_XW  8'h07
`define OPCODE_RETURN_TL_CREDITS   8'h08
`define OPCODE_MEM_CNTL_DONE       8'h0B
