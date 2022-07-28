# FBIST Address Generation
# Ryan King - rpking@us.ibm.com
# June 4, 2018

# Test FBIST address generator

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

fusion::stick(1, "axi_fifo_full_gate", 0, 0, 0, 0);
fusion::stick(1, "fbist_cfg_status_ip", 0, 0, 0, 0);
fusion::stick(0xFFFFFFFF, "fbist_cfg_address_and_mask", 0, 0, 0, 31);

fusion::stick(convert(0), "fbist_cfg_engine0_address_mode", 0, 0, 0, 7); # CONSTANT
fusion::stick(convert(1), "fbist_cfg_engine1_address_mode", 0, 0, 0, 7); # INCR
fusion::stick(convert(2), "fbist_cfg_engine2_address_mode", 0, 0, 0, 7); # DECR
fusion::stick(convert(3), "fbist_cfg_engine3_address_mode", 0, 0, 0, 7); # LFSR
fusion::stick(convert(0), "fbist_cfg_engine4_address_mode", 0, 0, 0, 7); # CONSTANT
fusion::stick(convert(1), "fbist_cfg_engine5_address_mode", 0, 0, 0, 7); # INCR
fusion::stick(convert(2), "fbist_cfg_engine6_address_mode", 0, 0, 0, 7); # DECR
fusion::stick(convert(3), "fbist_cfg_engine7_address_mode", 0, 0, 0, 7); # LFSR

fusion::stick(1, "cgen_agen_command_valid", 0, 0, 0, 0);

foreach my $j (0..7) {
    foreach my $i (0..7) {
        fusion::stick(convert($i), "cgen_agen_command", 0, 0, 0, 7);
        fusion::stick($i, "cgen_agen_command_engine", 0, 0, 0, 2);
        myclock(1);
    }
}

fusion::stick(0, "cgen_agen_command", 0, 0, 0, 7);
fusion::stick(0, "cgen_agen_command_valid", 0, 0, 0, 0);
fusion::stick(0, "cgen_agen_command_engine", 0, 0, 0, 2);

fusion::stick(0, "fbist_cfg_status_ip", 0, 0, 0, 0);

myclock(10);

print("Hello, World!\n");
fusion::pass("Saying hello to the world...\n");
fusion::clock(0);
