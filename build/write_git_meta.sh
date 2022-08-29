#!/usr/bin/env bash

# This script auto-generates registers to capture the git version in
# VHDL and Verilog designs. This is primarily useful to compare
# generated HW with a specific source.

set -eu

# cd to the directory containing this script
cd $(dirname "$(readlink -f "$0")")

# Grab 28 bits of hash
SHORT_HASH=$(git rev-parse --short=7 HEAD)
echo -n "Writing meta files for commit ${SHORT_HASH}"

# Check if there are any modified or staged files
if ! git diff-index --quiet HEAD --; then
    DIRTY=1
    echo "-dirty"
else
    DIRTY=0
    echo # Complete newline
fi

# Meta Version Register:
#   BIT 31:29 = was Reserved but are now defined to enter frequency into design code
#   Bit 31:29 = 001=21.33GBPS - 010=23.46GBPS - 011=25.6GBPS
#             - 000 + 100 to 111=unsupported
#   Bit    28 = dirty (1 if repository has untracked or staged changes, 0 otherwise)
#   Bits 27:0 = 7 character git hash
if [ ${OMI_FREQ} -eq 333 ]; then
 #Bit 31:29 = 001=21.33GBPS > SPEED_FIELD=2 (1 <<1)
 SPEED_FIELD=2
else
 #Bit 31:29 = 011=25.6GBPS > SPEED_FIELD=6 (4 <<1)
 SPEED_FIELD=6
fi
DIRTY_FIELD=${SPEED_FIELD}+${DIRTY}
QUALIFIER_FIELD=$(printf "%x" $((DIRTY_FIELD * 1)))
META_REGISTER_VALUE="${QUALIFIER_FIELD}${SHORT_HASH}"

META_REGISTER_VERILOG_DEFINE="\`define FIRE_ICE_META_VERSION 32'h${META_REGISTER_VALUE}"
echo
echo "# VERILOG"
echo "${META_REGISTER_VERILOG_DEFINE}"

read -r -d '' META_REGISTER_VHDL_CONSTANT<<EOM || true
library ieee;
use ieee.std_logic_1164.all;

package meta_pkg is
  constant FIRE_ICE_META_VERSION : std_ulogic_vector(31 downto 0) := x"${META_REGISTER_VALUE}";
end package meta_pkg;
EOM
echo
echo "# VHDL"
echo "${META_REGISTER_VHDL_CONSTANT}"

HEADER_TEXT="This file automatically generated from $(basename -- $0)"
VERILOG_HEADER="// ${HEADER_TEXT}"
VHDL_HEADER="-- ${HEADER_TEXT}"

# Generate vhdl and verilog files. Each file is purposely put on it's
# own line in the for loop to make diffs look good.
echo
for file in \
    ../fire/src/vhdl/meta_pkg.vhdl \
    ; do
    echo "${VHDL_HEADER}" > $file
    echo "${META_REGISTER_VHDL_CONSTANT}" >> $file
    echo "Updated ${file}"
done

