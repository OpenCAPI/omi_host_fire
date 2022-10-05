# License

Copyright 2019 International Business Machines

Licensed under the Apache License, Version 2.0 (the "License");
you may not use the files in this repository except in compliance with the License.
You may obtain a copy of the License at
http://www.apache.org/licenses/LICENSE-2.0 

The patent license granted to you in Section 3 of the License, as applied
to the "Work," hereby includes implementations of the Work in physical form.  

Unless required by applicable law or agreed to in writing, the reference design
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

The background Specification upon which this is based is managed by and available from
the OpenCAPI Consortium.  More information can be found at https://opencapi.org.

# Purpose

This FIRE design contains the FPGA code of an OMI host. It has all the features needed to 
configure, initialize, train and test an OMI DDIMM through OMI links.
OMI stands for Open Memory Interface. Check OMI web site at https://openmemoryinterface.org
Friendly documentation providing reference documentation, design and enablement code 
can also be found at https://opencapi.github.io/omi-doc/

# Hardware requirements

This FIRE design targets as of today 2 boards:
* __Apollo__ board which is a lab experimentation board (not for distribution)
    * AMD/Xilinx FPGA __XCVU7P__
    * 4 ports (x8 OMI links) enabled in this design

* AMD/Xilinx __VCU128__ evaluation board (https://www.xilinx.com/products/boards-and-kits/vcu128.html)
    * AMD/Xilinx FPGA __XCVU37P__
    * 2 ports (x8 OMI links) enabled in this design
    * An adapter Tormem card is required to plug the DDIMMs (https://www.tormem.com/contact)
Any new board or additional ports can be easily added. Board specific files can be found in ~/fire/src/board/

I2C communication with these boards is done through a RasberryPi.
AMD/Xilinx Vivado 2018.3 is used to build the FPGA binary images.
Code is designed for AMD/Xilinx UltraScale+ FPGA family.
More about enablement on https://opencapi.github.io/omi-doc/blocs/enablement

# FPGA Build Scripts

The /build directory contains the various scripts needed to synthesize and
implement RTL, as well as generate a bitstream, for an FPGA using the
Fire design. (it was targeting fire (host) and ice (device) but
only fire is available yet)

To quickly get started, the sequence is (`$design` is fire ):

```
cd build
./run $design synthesize.tcl
./run $design implement.tcl
./run $design gen_bitstream.tcl
```

The following command launches for the entire process, with some optimization choices:

```
./run_fire.sh
```

## Main Scripts and Directories

__run__: Takes a TCL script file and a design as an argument, and runs
that TCL script on that design using Vivado 2018.3 in the terminal (no
GUI). The command output is written to `$design/$command.log`, and
also colorized and printed to the screen. Output files are saved in
the `$design/` directory, including a design checkpoint (.dcp file).

__run_fire.sh__: Runs the main synthesize, then implement using strategy 8,
and gen_bitstream with implementation strategy result 8. This number will be
adapted depending on the design and the WNS result displayed at the end of 
the place and route phase.  If run on
a machine with a `bsub` binary found (aka LSF is installed), then the
commands are dispatched via LSF. Additionally, 16 implementation
strategies are launched in parallel, and the timing results are
checked on completed runs. The first completed implementation strategy
that meets timing is used for the bitstream. Also in this mode, the
"important" output files are copied to the `$design_deploy/` directory.

__fire/__ : Contain all output files from Vivado. Each
command outputs to a log stored in the top-level directory, and other
files are stored in a sub-directory per command.

## Vivado TCL Scripts

__synthesize.tcl__: Load libraries and read RTL and constraint files,
recompile IP (if needed), synthesize the design, and add the ILA IP.

__insert_ila.tcl__: Helper script for synthesize.tcl that adds all
signals marked with the mark_debug to a correctly clocked Integrated
Logic Analyzer (ILA) (Trace Array in IBM speak).

__implement.tcl__: Implements a synthesized design, and creates
various reports. Takes an argument to select the implementation
strategy used (uses strategy 1 if not given).

__gen_bitstream.tcl__: Generate the bistream and debug probes for an
implemented design. Takes an argument to select the implementation
strategy used (uses strategy 1 if not given).

__edit_ip.tcl__: Open all the IP in `src/ip/` for editing in the Vivado
GUI (not in a project). Also used to add new IP.

## LSF Wrappers and Configurations

__bsub_run__: Same as run, but run a command via `bsub` and print
output to the screen.

__bsub_batch__: Same as run, but run a command via `bsub` and run in
background.

__build.lsf__: LSF configuration used for all commands submitted via `bsub`.

__clean_all.sh__: clean the whole project removing all files generated by scripts.

## Work-In-Progress

These files are either a work-in-progress or stale, and should not be
used.

__waived_warnings.txt__: List of warnings that are known and
acceptable.

__print_warnings.sh__: Print all the warnings in run.log that are not
waived in waived_warnings.txt.
