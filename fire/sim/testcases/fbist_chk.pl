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

fusion::stick(convert(0x42), "agen_chk_command", 0, 0, 0, 7);
fusion::stick(1, "agen_chk_command_valid", 0, 0, 0, 0);
fusion::stick(0b101, "agen_chk_command_engine", 0, 0, 0, 2);
fusion::stick(convert(0x1), "agen_chk_command_tag", 0, 0, 0, 7);
fusion::stick(convert(0xDEADBEEF), "agen_chk_command_address", 0, 0, 0, 31);

myclock(1);

fusion::stick(convert(0x10), "agen_chk_command", 0, 0, 0, 7);
fusion::stick(1, "agen_chk_command_valid", 0, 0, 0, 0);
fusion::stick(0b111, "agen_chk_command_engine", 0, 0, 0, 2);
fusion::stick(convert(0x2), "agen_chk_command_tag", 0, 0, 0, 7);
fusion::stick(convert(0xBADC0FEE), "agen_chk_command_address", 0, 0, 0, 31);

myclock(1);

fusion::stick(0, "agen_chk_command_valid", 0, 0, 0, 0);

myclock(10);

fusion::stick(0, "axi_chk_response", 0, 0, 0, 7);
fusion::stick(1, "axi_chk_response_valid", 0, 0, 0, 0);
fusion::stick(convert(0x2), "axi_chk_response_tag", 0, 0, 0, 7);
foreach my $i (0..15) {
    if ($i % 2 == 0) {
        fusion::stick(convert(0xBADC0FEE), "axi_chk_response_data", 0, 0, 32*$i, 32*$i + 31);
    }
}

myclock(1);

fusion::stick(0, "axi_chk_response_valid", 0, 0, 0, 0);

myclock(10);

fusion::stick(0, "axi_chk_response", 0, 0, 0, 7);
fusion::stick(1, "axi_chk_response_valid", 0, 0, 0, 0);
fusion::stick(convert(0x1), "axi_chk_response_tag", 0, 0, 0, 7);
foreach my $i (0..15) {
    if ($i % 2 == 0) {
        fusion::stick(convert(0xDEADBEEF), "axi_chk_response_data", 0, 0, 32*$i, 32*$i + 31);
    }
}

myclock(1);

fusion::stick(0, "axi_chk_response_valid", 0, 0, 0, 0);

myclock(10);

print("Hello, World!\n");
fusion::pass("Saying hello to the world...\n");
fusion::clock(0);
