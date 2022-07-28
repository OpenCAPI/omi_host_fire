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
        fusion::stick(0, "s0_axi_aclk", 0, 0, 0, 0);
        fusion::clock(1);
        fusion::stick(1, "s0_axi_aclk", 0, 0, 0, 0);
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

sub write_1 {
    myclock(10);

    fusion::stick(0, "s0_axi_awaddr", 0, 0, 0, 31);
    fusion::stick(1, "s0_axi_awid", 0, 0, 0, 6);
    fusion::stick(1, "s0_axi_awvalid", 0, 0, 0, 0);
    fusion::stick(1, "s0_axi_wvalid", 0, 0, 0, 0);

    myclock(2);

    fusion::stick(0, "s0_axi_awaddr", 0, 0, 0, 31);
    fusion::stick(0, "s0_axi_awvalid", 0, 0, 0, 0);

    myclock(2);

    fusion::stick(0, "s0_axi_wvalid", 0, 0, 0, 0);

    myclock(3);

    fusion::stick(1, "m0_axi_awready", 0, 0, 0, 0);

    myclock(1);

    fusion::stick(0, "m0_axi_awready", 0, 0, 0, 0);

    myclock(2);

    fusion::stick(1, "m0_axi_wready", 0, 0, 0, 0);

    myclock(1);

    fusion::stick(0, "m0_axi_wready", 0, 0, 0, 0);

    myclock(10);
}

sub write_2 {
    myclock(10);

    fusion::stick(2, "s0_axi_awaddr", 0, 0, 0, 31);
    fusion::stick(1, "s0_axi_awid", 0, 0, 0, 6);
    fusion::stick(1, "s0_axi_awvalid", 0, 0, 0, 0);
    fusion::stick(1, "s0_axi_wvalid", 0, 0, 0, 0);

    myclock(2);

    fusion::stick(0, "s0_axi_awaddr", 0, 0, 0, 31);
    fusion::stick(0, "s0_axi_awvalid", 0, 0, 0, 0);

    myclock(2);

    fusion::stick(0, "s0_axi_wvalid", 0, 0, 0, 0);

    myclock(3);

    fusion::stick(1, "s0_axi_bready", 0, 0, 0, 0);

    myclock(1);

    fusion::stick(0, "s0_axi_bready", 0, 0, 0, 0);

    myclock(3);

    fusion::stick(2, "s0_axi_awaddr", 0, 0, 0, 31);
    fusion::stick(2, "s0_axi_awid", 0, 0, 0, 6);
    fusion::stick(1, "s0_axi_awvalid", 0, 0, 0, 0);
    fusion::stick(1, "s0_axi_wvalid", 0, 0, 0, 0);

    myclock(2);

    fusion::stick(0, "s0_axi_awaddr", 0, 0, 0, 31);
    fusion::stick(0, "s0_axi_awvalid", 0, 0, 0, 0);

    myclock(2);

    fusion::stick(0, "s0_axi_wvalid", 0, 0, 0, 0);

    myclock(3);

    fusion::stick(1, "m0_axi_awready", 0, 0, 0, 0);

    myclock(1);

    fusion::stick(0, "m0_axi_awready", 0, 0, 0, 0);

    myclock(2);

    fusion::stick(1, "m0_axi_wready", 0, 0, 0, 0);

    myclock(1);

    fusion::stick(0, "m0_axi_wready", 0, 0, 0, 0);

    myclock(2);

    fusion::stick(1, "m0_axi_wready", 0, 0, 0, 0);

    myclock(1);

    fusion::stick(0, "m0_axi_wready", 0, 0, 0, 0);

    myclock(10);

    fusion::stick(1, "m0_axi_bvalid", 0, 0, 0, 0);
    fusion::stick(2, "m0_axi_bid", 0, 0, 0, 6);

    myclock(2);

    fusion::stick(0, "m0_axi_bvalid", 0, 0, 0, 0);
    fusion::stick(0, "m0_axi_bid", 0, 0, 0, 6);

    myclock(2);

    fusion::stick(1, "s0_axi_bready", 0, 0, 0, 0);

    myclock(1);

    fusion::stick(0, "s0_axi_bready", 0, 0, 0, 0);

    myclock(10);
}

sub resp_1 {
    myclock(10);

    fusion::stick(1, "m0_axi_bvalid", 0, 0, 0, 0);
    fusion::stick(1, "m0_axi_bid", 0, 0, 0, 6);

    myclock(2);

    fusion::stick(0, "m0_axi_bvalid", 0, 0, 0, 0);
    fusion::stick(0, "m0_axi_bid", 0, 0, 0, 6);

    myclock(2);

    fusion::stick(1, "s0_axi_bready", 0, 0, 0, 0);

    myclock(1);

    fusion::stick(0, "s0_axi_bready", 0, 0, 0, 0);

    myclock(10);
}

sub read_1 {
    myclock(10);

    fusion::stick(0x00000002, "s0_axi_araddr", 0, 0, 0, 31);
    fusion::stick(1, "s0_axi_arid", 0, 0, 0, 6);
    fusion::stick(1, "s0_axi_arvalid", 0, 0, 0, 0);

    myclock(1);

    fusion::stick(1, "m0_axi_arready", 0, 0, 0, 0);

    myclock(1);

    fusion::stick(0, "s0_axi_arvalid", 0, 0, 0, 0);
    fusion::stick(0, "m0_axi_arready", 0, 0, 0, 0);

    myclock(3);

    fusion::stick(1, "m0_axi_rid", 0, 0, 0, 6);
    fusion::stick(1, "m0_axi_rvalid", 0, 0, 0, 0);
    fusion::stick(1, "m0_axi_rlast", 0, 0, 0, 0);
    fusion::stick(0xFFFFFFFF, "m0_axi_rdata", 0, 0, 0, 31);

    myclock(1);

    fusion::stick(0, "m0_axi_rvalid", 0, 0, 0, 0);

    myclock(2);

    fusion::stick(1, "s0_axi_rready", 0, 0, 0, 0);

    myclock(1);

    fusion::stick(0, "s0_axi_rready", 0, 0, 0, 0);

    myclock(10);
}

sub read_2 {
    myclock(10);

    fusion::stick(0x20000002, "s0_axi_araddr", 0, 0, 0, 31);
    fusion::stick(1, "s0_axi_arid", 0, 0, 0, 6);
    fusion::stick(1, "s0_axi_arvalid", 0, 0, 0, 0);

    myclock(1);

    fusion::stick(1, "m0_axi_arready", 0, 0, 0, 0);

    myclock(1);

    fusion::stick(0, "s0_axi_arvalid", 0, 0, 0, 0);
    fusion::stick(0, "m0_axi_arready", 0, 0, 0, 0);

    myclock(3);

    fusion::stick(1, "m0_axi_rid", 0, 0, 0, 6);
    fusion::stick(1, "m0_axi_rvalid", 0, 0, 0, 0);
    fusion::stick(0xFFFFFFFF, "m0_axi_rdata", 0, 0, 0, 31);

    myclock(1);

    fusion::stick(1, "m0_axi_rlast", 0, 0, 0, 0);
    fusion::stick(0xAAAAAAAA, "m0_axi_rdata", 0, 0, 0, 31);

    myclock(1);

    fusion::stick(0, "m0_axi_rvalid", 0, 0, 0, 0);

    myclock(2);

    fusion::stick(1, "s0_axi_rready", 0, 0, 0, 0);

    myclock(1);

    fusion::stick(0, "s0_axi_rready", 0, 0, 0, 0);

    myclock(10);
}

fusion::stick(1, "s0_axi_aresetn", 0, 0, 0, 0);

read_2();

print("Hello, World!\n");
fusion::pass("Saying hello to the world...\n");
fusion::clock(0);
