# Calibrate and Run
# Ryan King - rpking@us.ibm.com
# May 16, 2018

# Test to calibrate the DL2DL interface and run for a bit, monitoring
# the interface

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

        lib::DLX::print_dlx_interface();
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
gridclock(1000);

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
