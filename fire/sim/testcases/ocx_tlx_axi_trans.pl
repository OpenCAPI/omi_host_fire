# OpenCAPI/AXI Transactions
# Ryan King - rpking@us.ibm.com
# October 22, 2018

# Exercise OpenCAPI/AXI transaction staging

use facility;
use strict;
use warnings;

sub clock {
    my $count = shift;
    $count = 1 if not defined $count;

    foreach my $i (0..$count-1) {
        fusion::stick(0, "clock", 0, 0, 0, 0);
        fusion::clock(1);
        fusion::stick(1, "clock", 0, 0, 0, 0);
        fusion::clock(1);
    }
}

clock(10);

fusion::stick(1, "axi_read_address_valid", 0, 0, 0, 0);
fusion::stick(5, "axi_arid", 0, 0, 0, 3);
fusion::stick(42, "axi_araddr", 0, 0, 0, 31);
fusion::stick(2, "axi_arlen", 0, 0, 0, 1);

clock(1);

fusion::stick(0, "axi_read_address_valid", 0, 0, 0, 0);
fusion::stick(0, "axi_arid", 0, 0, 0, 3);
fusion::stick(0, "axi_araddr", 0, 0, 0, 31);
fusion::stick(0, "axi_arlen", 0, 0, 0, 1);

clock(10);

fusion::stick(1, "oc_read_command_taken", 0, 0, 0, 0);
fusion::stick(5, "oc_read_command_taken_id", 0, 0, 0, 3);

clock(1);

fusion::stick(0, "oc_read_command_taken", 0, 0, 0, 0);
fusion::stick(0, "oc_read_command_taken_id", 0, 0, 0, 3);

clock(10);

fusion::pass("");
fusion::clock(0);
