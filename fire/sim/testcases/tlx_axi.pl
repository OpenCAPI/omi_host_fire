# OpenCAPI MMIO
# Ryan King - rpking@us.ibm.com
# July 20, 2018

# Test to send MMIO via OpenCAPI link

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
$prefix = "FIRE0.OC_MMIO0_AXIS_";
#$prefix = "FIRE0.OC_MEMORY0_AXIS_";
# Global
$c3s_axi{"s0_axi_aclk"} = fac->new("${prefix}aclk", 0, 0, 0, 0);
$c3s_axi{"s0_axi_aresetn"} = fac->new("${prefix}aresetn", 0, 0, 0, 0);

# Write Address Channel
$c3s_axi{"s0_axi_awid"} = fac->new("${prefix}awid", 0, 0, 0, 3);
$c3s_axi{"s0_axi_awaddr"} = fac->new("${prefix}awaddr", 0, 0, 0, 31);
$c3s_axi{"s0_axi_awlen"} = fac->new("${prefix}awlen", 0, 0, 0, 7);
$c3s_axi{"s0_axi_awvalid"} = fac->new("${prefix}awvalid", 0, 0, 0, 0);
$c3s_axi{"s0_axi_awready"} = fac->new("${prefix}awready", 0, 0, 0, 0);

# Write Data Channel
$c3s_axi{"s0_axi_wid"} = fac->new("${prefix}wid", 0, 0, 0, 3);
$c3s_axi{"s0_axi_wdata"} = fac->new("${prefix}wdata", 0, 0, 0, 31);
$c3s_axi{"s0_axi_wstrb"} = fac->new("${prefix}wstrb", 0, 0, 0, 3);
$c3s_axi{"s0_axi_wlast"} = fac->new("${prefix}wlast", 0, 0, 0, 0);
$c3s_axi{"s0_axi_wvalid"} = fac->new("${prefix}wvalid", 0, 0, 0, 0);
$c3s_axi{"s0_axi_wready"} = fac->new("${prefix}wready", 0, 0, 0, 0);

# Write Response Channel
$c3s_axi{"s0_axi_bid"} = fac->new("${prefix}bid", 0, 0, 0, 3);
$c3s_axi{"s0_axi_bresp"} = fac->new("${prefix}bresp", 0, 0, 0, 1);
$c3s_axi{"s0_axi_bvalid"} = fac->new("${prefix}bvalid", 0, 0, 0, 0);
$c3s_axi{"s0_axi_bready"} = fac->new("${prefix}bready", 0, 0, 0, 0);

# Read Address Channel
$c3s_axi{"s0_axi_arid"} = fac->new("${prefix}arid", 0, 0, 0, 3);
$c3s_axi{"s0_axi_araddr"} = fac->new("${prefix}araddr", 0, 0, 0, 31);
$c3s_axi{"s0_axi_arlen"} = fac->new("${prefix}arlen", 0, 0, 0, 7);
$c3s_axi{"s0_axi_arvalid"} = fac->new("${prefix}arvalid", 0, 0, 0, 0);
$c3s_axi{"s0_axi_arready"} = fac->new("${prefix}arready", 0, 0, 0, 0);

# Read Data Channel
$c3s_axi{"s0_axi_rid"} = fac->new("${prefix}rid", 0, 0, 0, 3);
$c3s_axi{"s0_axi_rdata"} = fac->new("${prefix}rdata", 0, 0, 0, 31);
$c3s_axi{"s0_axi_rresp"} = fac->new("${prefix}rresp", 0, 0, 0, 2);
$c3s_axi{"s0_axi_rlast"} = fac->new("${prefix}rlast", 0, 0, 0, 0);
$c3s_axi{"s0_axi_rvalid"} = fac->new("${prefix}rvalid", 0, 0, 0, 0);
$c3s_axi{"s0_axi_rready"} = fac->new("${prefix}rready", 0, 0, 0, 0);

sub convert {
    my ($hexvalue) = @_;
    if (!defined $hexvalue) {
        return undef;
    }
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

    my $clk = fac->new("oc_mmio0_axis_aclk", 0, 0, 0, 0);
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
        } until ($clk_value_prev == 0 and $clk_value == 1);
    }
}

sub axi_reset {
    axiclock();
    $c3s_axi{"s0_axi_aresetn"} -> stick([0]);
    axiclock(10);
    $c3s_axi{"s0_axi_aresetn"} -> unstick();
    axiclock();
}

sub write_reg {
    my $address = convert(shift);
    my $data0 = convert(shift);
    my $data1 = convert(shift);

    axiclock();

    $c3s_axi{"s0_axi_awvalid"} -> stick([1]);
    $c3s_axi{"s0_axi_awid"} -> stick([1]);
    $c3s_axi{"s0_axi_awaddr"} -> stick([$address]);
    if (defined $data1) {
        $c3s_axi{"s0_axi_awlen"} -> stick([128]);
    } else {
        $c3s_axi{"s0_axi_awlen"} -> stick([0]);
    }
    do {
        axiclock();
    } while (oct($c3s_axi{"s0_axi_awready"} -> getbin()) != 1);

    $c3s_axi{"s0_axi_awvalid"} -> unstick();
    $c3s_axi{"s0_axi_awid"} -> unstick();
    $c3s_axi{"s0_axi_awaddr"} -> unstick();
    $c3s_axi{"s0_axi_awlen"} -> unstick();
    axiclock();

    $c3s_axi{"s0_axi_wvalid"} -> stick([1]);
    $c3s_axi{"s0_axi_wid"} -> stick([1]);
    $c3s_axi{"s0_axi_wdata"} -> stick([$data0]);
    if (defined $data1) {
        $c3s_axi{"s0_axi_wlast"} -> stick([0]);
    } else {
        $c3s_axi{"s0_axi_wlast"} -> stick([1]);
    }
    do {
        axiclock();
    } while (oct($c3s_axi{"s0_axi_wready"} -> getbin()) != 1);

    if (defined $data1) {
        $c3s_axi{"s0_axi_wdata"} -> stick([$data1]);
        $c3s_axi{"s0_axi_wlast"} -> stick([1]);
        axiclock();
    }

    $c3s_axi{"s0_axi_wvalid"} -> unstick();
    $c3s_axi{"s0_axi_wid"} -> unstick();
    $c3s_axi{"s0_axi_wdata"} -> unstick();
    $c3s_axi{"s0_axi_wlast"} -> unstick();
    axiclock();

    $c3s_axi{"s0_axi_bready"} -> stick([1]);
    do {
        axiclock();
    } while (oct($c3s_axi{"s0_axi_bvalid"} -> getbin()) != 1);

    $c3s_axi{"s0_axi_bready"} -> unstick();

    return 0;
}

sub read_reg {
    my $address = convert(shift);
    my $bursts = shift;

    axiclock();

    $c3s_axi{"s0_axi_arvalid"} -> stick([1]);
    $c3s_axi{"s0_axi_arid"} -> stick([2]);
    $c3s_axi{"s0_axi_araddr"} -> stick([$address]);
    if(!defined $bursts) {
        $c3s_axi{"s0_axi_arlen"} -> stick([0]);
    } elsif ($bursts == 2) {
        $c3s_axi{"s0_axi_arlen"} -> stick([128]);
    } else {
        $c3s_axi{"s0_axi_arlen"} -> stick([0]);
    }
    do {
        axiclock();
    } while (oct($c3s_axi{"s0_axi_arready"} -> getbin()) != 1);

    $c3s_axi{"s0_axi_arvalid"} -> unstick();
    $c3s_axi{"s0_axi_arid"} -> unstick();
    $c3s_axi{"s0_axi_araddr"} -> unstick();
    $c3s_axi{"s0_axi_arlen"} -> unstick();
    axiclock();

    $c3s_axi{"s0_axi_rready"} -> stick([1]);
    axiclock();
    do {
        axiclock();
    } while (oct($c3s_axi{"s0_axi_rvalid"} -> getbin()) != 1);

    my $data = oct($c3s_axi{"s0_axi_rdata"} -> getbin());

    $c3s_axi{"s0_axi_rready"} -> unstick();

    return convert($data);
}

print("\n");
print "##################################################################\n";
print "## RUNNING CALIBRATION ###########################################\n";
print "##################################################################\n";
fusion::stick(1, "MB_TOP.MB_SIM.MMIO.CFGP.CFG_F1_CSH_MEMORY_SPACE_Q", 0, 0, 0, 0);
fusion::stick(0, "MB_TOP.MB_SIM.MMIO.CFGP.CFG_F1_CSH_P_Q", 0, 0, 0, 0);
fusion::stick(1, "MB_TOP.MB_SIM.TP_MB_UNIT_TOP.TPGIF2PCB.SIMMUX_COMP.SIMONLY_PATH_ENABLE", 0, 0, 0, 0);
fusion::stick(1, "MB_TOP.MB_SIM.TP_MB_UNIT_TOP.TPPIB2GIF.SIMMUX_COMP.SIMONLY_PATH_ENABLE", 0, 0, 0, 0);

lib::DLX::calibrate();

my $cycle_start = 0;
fusion::currentCycleL($cycle_start);
my $cycle = $cycle_start;
while (($cycle - $cycle_start) < 4000) {
    fusion::currentCycleL($cycle);

    gridclock();

    lib::DLX::print_dlx_interface();
}

print("\n");
print "##################################################################\n";
print "## RUNNING TEST ##################################################\n";
print "##################################################################\n";
axi_reset();

# 0x0801186f
fusion::stick(0x84060000, "MB_TOP.MB_SIM.MCBIST.MBA_SCOMFIR.CFG_MBXLT0Q.LATC.L2", 0, 0, 0, 31);
fusion::stick(0x002001AC, "MB_TOP.MB_SIM.MCBIST.MBA_SCOMFIR.CFG_MBXLT0Q.LATC.L2", 0, 0, 32, 63);

# 0x08011870
fusion::stick(0, "MB_TOP.MB_SIM.MCBIST.MBA_SCOMFIR.CFG_MBXLT1Q.LATC.L2", 0, 0, 3, 7);
fusion::stick(0, "MB_TOP.MB_SIM.MCBIST.MBA_SCOMFIR.CFG_MBXLT1Q.LATC.L2", 0, 0, 11, 15);
fusion::stick(0, "MB_TOP.MB_SIM.MCBIST.MBA_SCOMFIR.CFG_MBXLT1Q.LATC.L2", 0, 0, 19, 23);
fusion::stick(1, "MB_TOP.MB_SIM.MCBIST.MBA_SCOMFIR.CFG_MBXLT1Q.LATC.L2", 0, 0, 30, 34);
fusion::stick(6, "MB_TOP.MB_SIM.MCBIST.MBA_SCOMFIR.CFG_MBXLT1Q.LATC.L2", 0, 0, 35, 39);
fusion::stick(7, "MB_TOP.MB_SIM.MCBIST.MBA_SCOMFIR.CFG_MBXLT1Q.LATC.L2", 0, 0, 43, 47);
fusion::stick(8, "MB_TOP.MB_SIM.MCBIST.MBA_SCOMFIR.CFG_MBXLT1Q.LATC.L2", 0, 0, 51, 55);
fusion::stick(9, "MB_TOP.MB_SIM.MCBIST.MBA_SCOMFIR.CFG_MBXLT1Q.LATC.L2", 0, 0, 59, 63);

# 0x08011871
fusion::stick(10, "MB_TOP.MB_SIM.MCBIST.MBA_SCOMFIR.CFG_MBXLT2Q.LATC.L2", 0, 0, 3, 7);
fusion::stick(11, "MB_TOP.MB_SIM.MCBIST.MBA_SCOMFIR.CFG_MBXLT2Q.LATC.L2", 0, 0, 11, 15);
fusion::stick(5, "MB_TOP.MB_SIM.MCBIST.MBA_SCOMFIR.CFG_MBXLT2Q.LATC.L2", 0, 0, 19, 23);
fusion::stick(4, "MB_TOP.MB_SIM.MCBIST.MBA_SCOMFIR.CFG_MBXLT2Q.LATC.L2", 0, 0, 27, 31);
fusion::stick(0, "MB_TOP.MB_SIM.MCBIST.MBA_SCOMFIR.CFG_MBXLT2Q.LATC.L2", 0, 0, 35, 39);
fusion::stick(3, "MB_TOP.MB_SIM.MCBIST.MBA_SCOMFIR.CFG_MBXLT2Q.LATC.L2", 0, 0, 43, 47);
fusion::stick(2, "MB_TOP.MB_SIM.MCBIST.MBA_SCOMFIR.CFG_MBXLT2Q.LATC.L2", 0, 0, 51, 55);

fusion::stick(0, "MB_TOP.MB_SIM.SRQ.FARB.CFG_SRQ_FARB5Q.LATC.L2", 0, 0, 5, 5);
fusion::stick(1, "MB_TOP.MB_SIM.SRQ.FARB.CFG_SRQ_FARB5Q.LATC.L2", 0, 0, 4, 4);

fusion::stick(0, "MB_TOP.MB_SIM.SRQ.FARB.CFG_SRQ_FARB0Q.LATC.L2", 0, 0, 19, 19);

#fusion::stick(1, "MB_TOP.MB_SIM.MMIO.SCOM.MENTERP_Q", 0, 0, 1, 1); # Half DIMM
#fusion::stick(1, "MB_TOP.MB_SIM.MMIO.CFGP.CFG_F0_OTL0_TL_XMT_TMPL_CONFIG_Q", 0, 0, 11, 11); # send template B
#fusion::stick(0, "MB_TOP.MB_SIM.MMIO.CFGP.CFG_F0_OTL0_TL_XMT_TMPL_CONFIG_P_Q", 0, 0, 0, 0);

for my $i (0..0) {
    write_reg(0x08011815 * 8, 0xDEADBEEF, 0xBADC0FEE);
    #write_reg(0x0, 0xDEADBEEF);

    $cycle_start = 0;
    fusion::currentCycleL($cycle_start);
    $cycle = $cycle_start;
    while (($cycle - $cycle_start) < 20000) {
        fusion::currentCycleL($cycle);

        gridclock();

        lib::DLX::print_dlx_interface();
    }

    read_reg(0x08011815 * 8, 2);

    $cycle_start = 0;
    fusion::currentCycleL($cycle_start);
    $cycle = $cycle_start;
    while (($cycle - $cycle_start) < 20000) {
        fusion::currentCycleL($cycle);

        gridclock();

        lib::DLX::print_dlx_interface();
    }
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
