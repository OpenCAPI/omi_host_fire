# FPGA Build Scripts

This directory contains the various scripts needed to synthesize and
implement RTL, as well as generate a bitstream, for an FPGA using the
Fire design.

To quickly get started, the sequence is (`$design` is fire )

```
./run_fire $design synthesize_fire.tcl
./run_fire $design implement.tcl
./run_fire $design gen_bitstream.tcl
```

## Main Scripts and Directories

__run__: Takes a TCL script file and a design as an argument, and runs
that TCL script on that design using Vivado 2018.3 in the terminal (no
GUI). The command output is written to `$design/$command.log`, and
also colorized and printed to the screen. Output files are saved in
the `$design/` directory, including a design checkpoint (.dcp file).

__fire/__ : Contain all output files from Vivado. Each
command outputs to a log stored in the top-level directory, and other
files are stored in a sub-directory per command.

__fire_deploy/__ : Contain "important" files from
the run_all.sh script. These are files that could be worth using at a
later point.

## Vivado TCL Scripts

__synthesize_fire.tcl__: Load libraries and read RTL and constraint files,
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
