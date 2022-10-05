# Round Robin Arbiter
# Ryan King - rpking@us.ibm.com
# October 24, 2018

# Test the round robin arbiter used for AXI

use facility;
use strict;
use warnings;

fusion::stick(0b0000000001101001, "request", 0, 0, 0, 15);

foreach my $i (0..20) {
    fusion::stick(0, "clock", 0, 0, 0, 0);
    fusion::clock(1);
    fusion::stick(1, "clock", 0, 0, 0, 0);
    fusion::clock(1);
}

fusion::stick(0b0010000000001001, "request", 0, 0, 0, 15);

foreach my $i (0..20) {
    fusion::stick(0, "clock", 0, 0, 0, 0);
    fusion::clock(1);
    fusion::stick(1, "clock", 0, 0, 0, 0);
    fusion::clock(1);
}

fusion::stick(0b0000000000000000, "request", 0, 0, 0, 15);

foreach my $i (0..20) {
    fusion::stick(0, "clock", 0, 0, 0, 0);
    fusion::clock(1);
    fusion::stick(1, "clock", 0, 0, 0, 0);
    fusion::clock(1);
}

fusion::pass("");
fusion::clock(0);
