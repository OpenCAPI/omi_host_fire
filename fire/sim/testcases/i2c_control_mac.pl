# I2C/AXI Algorithm
# Ryan King - rpking@us.ibm.com
# July 31, 2018

# Test the main I2C/AXI control algorithm. Very basic testcase as a
# sanity check before putting on FPGA.

use facility;
use fac;
use strict;
use warnings;

use Term::ANSIColor;

print("\n");
print "##################################################################\n";
print "## LOADING SIGNALS ###############################################\n";
print "##################################################################\n";
my $pass = 1;

my $clock = fac->new("clock", 0, 0, 0, 0);

sub convert {
    my ($hexvalue) = @_;
    my $str = sprintf( "%032b", $hexvalue);
    my $num = join '', (reverse (split(//, $str)));
    my $final = oct("0b$num");

    return $final;
}

sub myclock {
    my $count = shift;
    $count = 1 if not defined $count;

    foreach (0..$count) {
        $clock->stick([0]);
        fusion::clock(1);
        $clock->stick([1]);
        fusion::clock(1);
    }
}

print("\n");
print "##################################################################\n";
print "## RUNNING TEST ##################################################\n";
print "##################################################################\n";
myclock(10);
fusion::stick(1, "s0_axi_awready", 0, 0, 0, 0);
fusion::stick(1, "s0_axi_wready", 0, 0, 0, 0);
fusion::stick(1, "s0_axi_bvalid", 0, 0, 0, 0);
myclock(50);
fusion::stick(1, "s0_axi_arready", 0, 0, 0, 0);
fusion::stick(1, "s0_axi_rvalid", 0, 0, 0, 0);
myclock(20);
fusion::stick(convert(0x00000040), "s0_axi_rdata", 0, 0, 0, 31);
myclock(20);
fusion::stick(convert(0x00000002), "s0_axi_rdata", 0, 0, 0, 31);
myclock(100);

print("\n");
print "##################################################################\n";
print "## RESULTS #######################################################\n";
print "##################################################################\n";
if ($pass == 1) {
    print color('bold green');
    print("All tests match!\n");
    print color('reset');
    fusion::pass("All tests match!\n");
} else {
    print color('bold red');
    print("There was an error!\n");
    print color('reset');
    fusion::error("There was an error!\n");
}
fusion::clock(0);
