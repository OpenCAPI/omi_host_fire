# FBIST Command Generation
# Ryan King - rpking@us.ibm.com
# June 4, 2018

# Test FBIST command generator

use facility;
use strict;
use warnings;

sub myclock {
    my $count = shift;

    for (0..$count-1) {
        fusion::stick(1, "clock", 0, 0, 0, 0);
        fusion::clock(1);
        fusion::stick(0, "clock", 0, 0, 0, 0);
        fusion::clock(1);
    }
}

sub convert {
    my ($hexvalue) = @_;
    my $str = sprintf( "%08b", $hexvalue);
    my $num = join '', (reverse (split(//, $str)));
    my $final = oct("0b$num");

    return $final;
}

myclock(10);

foreach my $i (0..7) {
    fusion::stick(convert($i), "fbist_cfg_engine${i}_command", 0, 0, 0, 7);
}
fusion::stick(7, "fbist_cfg_spacing_count", 0, 0, 0, 2);
fusion::stick(1, "axi_fifo_full_gate", 0, 0, 0, 0);
fusion::stick(0, "fbist_cfg_spacing_scheme", 0, 0, 0, 0);

myclock(10);

fusion::stick(1, "fbist_cfg_status_ip", 0, 0, 0, 0);

myclock(1000);

fusion::stick(0, "fbist_cfg_status_ip", 0, 0, 0, 0);

myclock(10);

print("Hello, World!\n");
fusion::pass("Saying hello to the world...\n");
fusion::clock(0);
