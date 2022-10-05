# Reset file for fire_emulate Testbench
# Ryan King - rpking@us.ibm.com
# January 19, 2018

# Code to reset fire_emulate_tb.  Should be included in all testcases.

package lib::Reset;

use facility;
use fac;
use strict;
use warnings;

my $testbench;

sub import {
    my ($package, $tb) = @_;
    if (defined $tb) {
        $testbench = $tb;
    } else {
        $testbench = "";
    }
}

sub run {
    fusion::clock(100);
    fusion::stick(1, "fire0_gtwiz_done", 0, 0, 0, 0);
    if ($testbench eq "fire_fire") {
        fusion::stick(1, "fire1_gtwiz_done", 0, 0, 0, 0);
    } else {
        fusion::stick(1, "phy_dlx_init_done_0", 0, 0, 0, 0);
        fusion::stick(1, "phy_dlx_init_done_1", 0, 0, 0, 0);
        fusion::stick(1, "phy_dlx_init_done_2", 0, 0, 0, 0);
        fusion::stick(1, "phy_dlx_init_done_3", 0, 0, 0, 0);
        fusion::stick(1, "phy_dlx_init_done_4", 0, 0, 0, 0);
        fusion::stick(1, "phy_dlx_init_done_5", 0, 0, 0, 0);
        fusion::stick(1, "phy_dlx_init_done_6", 0, 0, 0, 0);
        fusion::stick(1, "phy_dlx_init_done_7", 0, 0, 0, 0);
    }
    fusion::stick(1, "reset", 0, 0, 0, 0);
    fusion::clock(100);
    fusion::unstick("reset", 0, 0, 0, 0);

    my $cycle = 0;
    fusion::currentCycleL($cycle);
    fusion::currentCycleL($cycle);
    print("Reset completed at sim tick $cycle\n");
}

1;
