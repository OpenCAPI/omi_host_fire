# FBIST Checking
# Ryan King - rpking@us.ibm.com
# November 7, 2018

# Test FBIST checker

use facility;
use strict;
use warnings;

sub myclock {
    my $count = shift;

    for (0..$count-1) {
        fusion::stick(0, "clock", 0, 0, 0, 0);
        fusion::clock(1);
        fusion::stick(1, "clock", 0, 0, 0, 0);
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

fusion::stick(1, "din_valid", 0, 0, 0, 0);
fusion::stick(convert(1), "din", 0, 0, 0, 31);
myclock(1);
fusion::stick(0, "din_valid", 0, 0, 0, 0);
myclock(1);

fusion::stick(1, "din_valid", 0, 0, 0, 0);
foreach my $i (0..16) {
    fusion::stick(convert($i+2), "din", 0, 0, 0, 31);
    myclock(1);
}
fusion::stick(0, "din_valid", 0, 0, 0, 0);

myclock(10);

# Read 1
fusion::stick(1, "dout_taken", 0, 0, 0, 0);
myclock(1);
fusion::stick(0, "dout_taken", 0, 0, 0, 0);
myclock(1);

# Write 1, REad 1
fusion::stick(1, "din_valid", 0, 0, 0, 0);
fusion::stick(convert(50), "din", 0, 0, 0, 31);
fusion::stick(1, "dout_taken", 0, 0, 0, 0);
myclock(1);
fusion::stick(0, "din_valid", 0, 0, 0, 0);
fusion::stick(0, "dout_taken", 0, 0, 0, 0);
myclock(1);

# Read rest
fusion::stick(1, "dout_taken", 0, 0, 0, 0);
myclock(18);
fusion::stick(0, "dout_taken", 0, 0, 0, 0);
myclock(1);

print("Hello, World!\n");
fusion::pass("Saying hello to the world...\n");
fusion::clock(0);
