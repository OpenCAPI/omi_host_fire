# OpenCAPI Config
# Ryan King - rpking@us.ibm.com
# May 21, 2018

# Write some OpenCAPI config regs and read the results back, both via
# C3S.

use facility;
use fac;
use strict;
use warnings;

use Term::ANSIColor;

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
my $pass = 1;

my %c3s_axi;
my $prefix;
$prefix = "FIRE0.C3S_DLX0_AXIS_";
# Global
$c3s_axi{"s0_axi_aclk"} = fac->new("${prefix}aclk", 0, 0, 0, 0);
$c3s_axi{"s0_axi_aresetn"} = fac->new("${prefix}aresetn", 0, 0, 0, 0);

# Write Address Channel
$c3s_axi{"s0_axi_awvalid"} = fac->new("${prefix}awvalid", 0, 0, 0, 0);
$c3s_axi{"s0_axi_awready"} = fac->new("${prefix}awready", 0, 0, 0, 0);
$c3s_axi{"s0_axi_awaddr"} = fac->new("${prefix}awaddr", 0, 0, 0, 31);
$c3s_axi{"s0_axi_awprot"} = fac->new("${prefix}awprot", 0, 0, 0, 2);

# Write Data Channel
$c3s_axi{"s0_axi_wvalid"} = fac->new("${prefix}wvalid", 0, 0, 0, 0);
$c3s_axi{"s0_axi_wready"} = fac->new("${prefix}wready", 0, 0, 0, 0);
$c3s_axi{"s0_axi_wdata"} = fac->new("${prefix}wdata", 0, 0, 0, 31);
$c3s_axi{"s0_axi_wstrb"} = fac->new("${prefix}wstrb", 0, 0, 0, 3);

# Write Response Channel
$c3s_axi{"s0_axi_bvalid"} = fac->new("${prefix}bvalid", 0, 0, 0, 0);
$c3s_axi{"s0_axi_bready"} = fac->new("${prefix}bready", 0, 0, 0, 0);
$c3s_axi{"s0_axi_bresp"} = fac->new("${prefix}bresp", 0, 0, 0, 1);

# Read Address Channel
$c3s_axi{"s0_axi_arvalid"} = fac->new("${prefix}arvalid", 0, 0, 0, 0);
$c3s_axi{"s0_axi_arready"} = fac->new("${prefix}arready", 0, 0, 0, 0);
$c3s_axi{"s0_axi_araddr"} = fac->new("${prefix}araddr", 0, 0, 0, 31);
$c3s_axi{"s0_axi_arprot"} = fac->new("${prefix}arprot", 0, 0, 0, 2);

# Read Data Channel
$c3s_axi{"s0_axi_rvalid"} = fac->new("${prefix}rvalid", 0, 0, 0, 0);
$c3s_axi{"s0_axi_rready"} = fac->new("${prefix}rready", 0, 0, 0, 0);
$c3s_axi{"s0_axi_rdata"} = fac->new("${prefix}rdata", 0, 0, 0, 31);
$c3s_axi{"s0_axi_rresp"} = fac->new("${prefix}rresp", 0, 0, 0, 2);

sub convert {
    my ($hexvalue) = @_;
    my $str = sprintf( "%032b", $hexvalue);
    my $num = join '', (reverse (split(//, $str)));
    my $final = oct("0b$num");

    return $final;
}

# Clock until the next rising edge of the clock
sub gridclock {
    my $count = shift;
    $count = 1 if not defined $count;

    my $clk = fac->new("opt_gckn_4x", 0, 0, 0, 0);
    my $clk_value = oct($clk->getbin());
    my $clk_value_prev;
    for my $i (0..$count-1) {
        do {
            fusion::clock(1);
            $clk_value_prev = $clk_value;
            $clk_value = oct($clk->getbin());
        } until ($clk_value_prev == 1 and $clk_value == 0); # Using inverted clock, so actually look for falling edge
    }
}

# Clock until the next rising edge of the AXI clock
sub axiclock {
    my $count = shift;
    $count = 1 if not defined $count;

    my $clk = fac->new("c3s_dlx0_axis_aclk", 0, 0, 0, 0);
    my $clk_value = oct($clk->getbin());
    my $clk_value_prev;

    my $grid_clk = fac->new("opt_gckn_4x", 0, 0, 0, 0);
    my $grid_clk_value = oct($grid_clk->getbin());
    my $grid_clk_value_prev;
    for my $i (0..$count-1) {
        do {
            fusion::clock(1);
            $clk_value_prev = $clk_value;
            $clk_value = oct($clk->getbin());

            $grid_clk_value_prev = $grid_clk_value;
            $grid_clk_value = oct($grid_clk->getbin());
            if ($grid_clk_value_prev == 1 and $grid_clk_value == 0) {
                lib::DLX::print_dlx_interface();
            }
        } until ($clk_value_prev == 1 and $clk_value == 0); # Using inverted clock, so actually look for falling edge
    }
}

sub axi_reset {
    axiclock();
    $c3s_axi{"s0_axi_aresetn"} -> stick([0]);
    axiclock();
    $c3s_axi{"s0_axi_aresetn"} -> unstick();
    axiclock();
}

sub write_reg {
    my $address = convert(shift);
    my $data = convert(shift);

    axiclock();

    $c3s_axi{"s0_axi_awvalid"} -> stick([1]);
    $c3s_axi{"s0_axi_awaddr"} -> stick([$address]);
    while (oct($c3s_axi{"s0_axi_awready"} -> getbin()) != 1) {
        axiclock();
    }

    $c3s_axi{"s0_axi_awvalid"} -> unstick();
    $c3s_axi{"s0_axi_awaddr"} -> unstick();
    axiclock();

    $c3s_axi{"s0_axi_wvalid"} -> stick([1]);
    $c3s_axi{"s0_axi_wdata"} -> stick([$data]);
    while (oct($c3s_axi{"s0_axi_wready"} -> getbin()) != 1) {
        axiclock();
    }

    $c3s_axi{"s0_axi_wvalid"} -> unstick();
    $c3s_axi{"s0_axi_wdata"} -> unstick();
    axiclock();

    $c3s_axi{"s0_axi_bready"} -> stick([1]);
    while (oct($c3s_axi{"s0_axi_bvalid"} -> getbin()) != 1) {
        axiclock();
    }

    $c3s_axi{"s0_axi_bready"} -> unstick();

    return 0;
}

sub read_reg {
    my $address = convert(shift);

    axiclock();

    $c3s_axi{"s0_axi_arvalid"} -> stick([1]);
    $c3s_axi{"s0_axi_araddr"} -> stick([$address]);
    while (oct($c3s_axi{"s0_axi_arready"} -> getbin()) != 1) {
        axiclock();
    }

    $c3s_axi{"s0_axi_arvalid"} -> unstick();
    $c3s_axi{"s0_axi_araddr"} -> unstick();
    axiclock();

    $c3s_axi{"s0_axi_rready"} -> stick([1]);
    axiclock();
    while (oct($c3s_axi{"s0_axi_rvalid"} -> getbin()) != 1) {
        axiclock();
    }

    my $data = oct($c3s_axi{"s0_axi_rdata"} -> getbin());

    $c3s_axi{"s0_axi_rready"} -> unstick();

    return convert($data);
}

print("\n");
print "##################################################################\n";
print "## RUNNING CALIBRATION ###########################################\n";
print "##################################################################\n";
lib::DLX::calibrate();

print("\n");
print "##################################################################\n";
print "## RUNNING TEST ##################################################\n";
print "##################################################################\n";
axi_reset();

# Control
write_reg(0x30000, 0x00000000); # Don't enable wrap

# Data Array

##################################################################
# O1BAR0 Left = 0x00000008
# config_write, opcode = 0b11100001, PA = 0x00010014, CAPPTag = 0x0000, pL = 0b010
write_reg(0x0000E, 0x00000001); # Template 0 (Bit 460), DRL = 1 (Bit 448)
write_reg(0x00006, 0x40000000);
write_reg(0x00005, 0x00000000);
write_reg(0x00004, 0x10014000);
write_reg(0x00003, 0x00E10000);

write_reg(0x00105, 0x00000008); # Data

# config_read, opcode = 0b11100000, PA = 0x00010014, CAPPTag = 0x0001, pL = 0b010
write_reg(0x0020E, 0x00000000); # Template 0 (Bit 460), DRL = 0 (Bit 448)
write_reg(0x00206, 0x40001000);
write_reg(0x00205, 0x00000000);
write_reg(0x00204, 0x10014000);
write_reg(0x00203, 0x00E00000);

##################################################################
# OTTCFG Left = 0x00000003
# config_write, opcode = 0b11100001, PA = 0x00000224, CAPPTag = 0x0002, pL = 0b010
write_reg(0x0030E, 0x00000001); # Template 0 (Bit 460), DRL = 1 (Bit 448)
write_reg(0x00306, 0x40002000);
write_reg(0x00305, 0x00000000);
write_reg(0x00304, 0x00224000);
write_reg(0x00303, 0x00E10000);

write_reg(0x00409, 0x00000003); # Data

# config_read, opcode = 0b11100000, PA = 0x00000224, CAPPTag = 0x0003, pL = 0b010
write_reg(0x0050E, 0x00000000); # Template 0 (Bit 460), DRL = 0 (Bit 448)
write_reg(0x00506, 0x40003000);
write_reg(0x00505, 0x00000000);
write_reg(0x00504, 0x00224000);
write_reg(0x00503, 0x00E00000);

# Flow Array
write_reg(0x20000, 0x80000001); # Valid, GOTO 1
write_reg(0x20100, 0x00000002); # Valid, GOTO 2
write_reg(0x20200, 0x80000003); # Valid, GOTO 3
write_reg(0x20300, 0x80000004); # Valid, GOTO 4
write_reg(0x20400, 0x80000005); # Valid, GOTO 5
write_reg(0x20500, 0x80000006); # Valid, GOTO 6
write_reg(0x20600, 0x00000100); # END

printf("Set Addr => Data\n");
printf("0x30000  => 0x%08X\n", read_reg(0x30000));
print "\n";

# Start C3S in Fire 0
# OR in start bit to not overwrite other config bits
write_reg(0x30000, 0x1 | read_reg(0x30000));

# Let C3S run for a while
my $cycle_start = 0;
fusion::currentCycleL($cycle_start);
my $cycle = $cycle_start;
while (($cycle - $cycle_start) < 10000) {
    fusion::currentCycleL($cycle);

    gridclock();

    lib::DLX::print_dlx_interface();
}

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
