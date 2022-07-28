# AXI Channels
# Ryan King - rpking@us.ibm.com
# October 24, 2018

# Test new AXI transactions

use facility;
use fac;
use strict;
use warnings;

srand(42);

sub clock {
    my $count = shift;
    $count = 1 if not defined $count;

    foreach my $i (0..$count-1) {
        fusion::stick(0, "s0_axi_aclk", 0, 0, 0, 0);
        fusion::clock(1);
        fusion::stick(1, "s0_axi_aclk", 0, 0, 0, 0);
        fusion::clock(1);
    }
}

sub send_write_address {
    my $id = shift;
    my $ready = fac->new("s0_axi_awready", 0, 0, 0, 0);

    fusion::stick($id, "s0_axi_awid", 0, 0, 0, 3);
    fusion::stick(int(rand(2**31)), "s0_axi_awaddr", 0, 0, 0, 31);
    fusion::stick(0, "s0_axi_awlen", 0, 0, 0, 7);
    fusion::stick(0, "s0_axi_awsize", 0, 0, 0, 2);
    fusion::stick(0, "s0_axi_awburst", 0, 0, 0, 1);
    fusion::stick(0, "s0_axi_awlock", 0, 0, 0, 1);
    fusion::stick(0, "s0_axi_awcache", 0, 0, 0, 3);
    fusion::stick(0, "s0_axi_awprot", 0, 0, 0, 2);
    fusion::stick(1, "s0_axi_awvalid", 0, 0, 0, 0);

    my $ready_value = oct($ready->getbin());
    do {
        clock(1);
        $ready_value = oct($ready->getbin());
    } until ($ready_value == 1);

    fusion::stick(0, "s0_axi_awvalid", 0, 0, 0, 0);
    clock(1);
}

sub send_write_data {
    my $id = shift;
    my $ready = fac->new("s0_axi_wready", 0, 0, 0, 0);

    fusion::stick($id, "s0_axi_wid", 0, 0, 0, 3);
    fusion::stick(int(rand(2**31)), "s0_axi_wdata", 0, 0, 0, 31);
    fusion::stick(0, "s0_axi_wstrb", 0, 0, 0, 0);
    fusion::stick(0, "s0_axi_wlast", 0, 0, 0, 0);
    fusion::stick(1, "s0_axi_wvalid", 0, 0, 0, 0);

    my $ready_value = oct($ready->getbin());
    do {
        clock(1);
        $ready_value = oct($ready->getbin());
    } until ($ready_value == 1);

    fusion::stick(0, "s0_axi_wvalid", 0, 0, 0, 0);
    clock(1);
}

clock(10);

send_write_address(1);
send_write_address(0);
send_write_address(9);
send_write_data(3);
send_write_data(9);
send_write_data(1);

clock(10);

fusion::stick(1, "oc_write_command_taken", 0, 0, 0, 0);
fusion::stick(9, "oc_write_command_taken_id", 0, 0, 0, 3);

clock(1);

fusion::stick(0, "oc_write_command_taken", 0, 0, 0, 0);

clock(1);

fusion::stick(1, "oc_write_command_taken", 0, 0, 0, 0);
fusion::stick(1, "oc_write_command_taken_id", 0, 0, 0, 3);

clock(1);

fusion::stick(0, "oc_write_command_taken", 0, 0, 0, 0);

clock(10);

fusion::pass("");
fusion::clock(0);
