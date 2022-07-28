# FBIST Command Generation
# Ryan King - rpking@us.ibm.com
# June 4, 2018

# Test FBIST command generator

use facility;
use fac;
use strict;
use warnings;

use Term::ANSIColor;

sub convert {
    my ($hexvalue, $length) = @_;
    my $str = sprintf( "%0${length}b", $hexvalue);
    my $num = join '', (reverse (split(//, $str)));
    my $final = oct("0b$num");

    return $final;
}

use lib::DLX;

print("\n");
print "##################################################################\n";
print "## RESET #########################################################\n";
print "##################################################################\n";
use lib::Reset;
lib::Reset::run();

print("\n");
print "##################################################################\n";
print "## LOADING SIGNALS ###############################################\n";
print "##################################################################\n";
fusion::stick(convert(2, 8), "FIRE0.FIRE.FBIST.CFG.FBIST_CFG_POOL0_ENGINE0", 0, 0, 0, 7);
fusion::stick(convert(1, 8), "FIRE0.FIRE.FBIST.CFG.FBIST_CFG_POOL0_ENGINE0", 0, 0, 8, 15);

fusion::stick(convert(5, 8), "FIRE0.FIRE.FBIST.CFG.FBIST_CFG_POOL0_ENGINE1", 0, 0, 0, 7);
fusion::stick(convert(1, 8), "FIRE0.FIRE.FBIST.CFG.FBIST_CFG_POOL0_ENGINE1", 0, 0, 8, 15);

fusion::stick(convert(5, 8), "FIRE0.FIRE.FBIST.CFG.FBIST_CFG_POOL0_ENGINE2", 0, 0, 0, 7);
fusion::stick(convert(1, 8), "FIRE0.FIRE.FBIST.CFG.FBIST_CFG_POOL0_ENGINE2", 0, 0, 8, 15);

fusion::stick(convert(2, 8), "FIRE0.FIRE.FBIST.CFG.FBIST_CFG_POOL0_ENGINE3", 0, 0, 0, 7);
fusion::stick(convert(1, 8), "FIRE0.FIRE.FBIST.CFG.FBIST_CFG_POOL0_ENGINE3", 0, 0, 8, 15);

fusion::stick(convert(0, 8), "FIRE0.FIRE.FBIST.CFG.FBIST_CFG_POOL0_ENGINE4", 0, 0, 0, 7);
fusion::stick(convert(1, 8), "FIRE0.FIRE.FBIST.CFG.FBIST_CFG_POOL0_ENGINE4", 0, 0, 8, 15);

fusion::stick(convert(5, 8), "FIRE0.FIRE.FBIST.CFG.FBIST_CFG_POOL0_ENGINE5", 0, 0, 0, 7);
fusion::stick(convert(1, 8), "FIRE0.FIRE.FBIST.CFG.FBIST_CFG_POOL0_ENGINE5", 0, 0, 8, 15);

fusion::stick(convert(5, 8), "FIRE0.FIRE.FBIST.CFG.FBIST_CFG_POOL0_ENGINE6", 0, 0, 0, 7);
fusion::stick(convert(1, 8), "FIRE0.FIRE.FBIST.CFG.FBIST_CFG_POOL0_ENGINE6", 0, 0, 8, 15);

fusion::stick(convert(0, 8), "FIRE0.FIRE.FBIST.CFG.FBIST_CFG_POOL0_ENGINE7", 0, 0, 0, 7);
fusion::stick(convert(1, 8), "FIRE0.FIRE.FBIST.CFG.FBIST_CFG_POOL0_ENGINE7", 0, 0, 8, 15);

fusion::stick(convert(10, 16), "FIRE0.FIRE.FBIST.CFG.FBIST_CFG_POOL0_SPACING_COUNT", 0, 0, 0, 15);
fusion::stick(0xFFFFFFFF, "FIRE0.FIRE.FBIST.CFG.FBIST_CFG_POOL0_ADDRESS_AND_MASK_LOW", 0, 0, 0, 31);
fusion::stick(0xFFFFFFFF, "FIRE0.FIRE.FBIST.CFG.FBIST_CFG_POOL0_ADDRESS_AND_MASK_HIGH", 0, 0, 0, 31);

fusion::clock(10);

print("\n");
print "##################################################################\n";
print "## RUNNING CALIBRATION ###########################################\n";
print "##################################################################\n";
lib::DLX::calibrate();

print("\n");
print "##################################################################\n";
print "## RUNNING TEST ##################################################\n";
print "##################################################################\n";
fusion::stick(1, "FIRE0.FIRE.FBIST.CFG.FBIST_CFG_STATUS_IP_INT", 0, 0, 0, 0);

fusion::clock(22000);

fusion::stick(0, "FIRE0.FIRE.FBIST.CFG.FBIST_CFG_STATUS_IP_INT", 0, 0, 0, 0);

fusion::clock(1000);

my $pass = 1;

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
