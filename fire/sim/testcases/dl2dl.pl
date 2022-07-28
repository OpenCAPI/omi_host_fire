# DL2DL Traffic
# Ryan King - rpking@us.ibm.com
# January 19, 2018

# Test to calibrate the DL2DL interface and send a few flits

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

print("\n");
print "##################################################################\n";
print "## RUNNING CALIBRATION ###########################################\n";
print "##################################################################\n";
lib::DLX::calibrate();

print("\n");
print "##################################################################\n";
print "## RUNNING TEST ##################################################\n";
print "##################################################################\n";
my $clk = fac->new("opt_gckn_4x", 0, 0, 0, 0);
my $clk_value = oct($clk->getbin());
my $clk_value_prev;

# List of commands to send
my @command_list = (
    [0, 0, 0, 0b00100000], # rd_mem
    [1, 0, 0b00100000, 0b00100000, 0b10000001, 0b10000001] # 2 rd_mem, 2 write_mem
    );

my $cycle = 0;
while ($cycle < 500000) {
    fusion::currentCycleL($cycle);

    # Clock until the next rising edge of the clock
    my $done = 0;
    while ($done == 0) {
        fusion::clock(1);

        $clk_value_prev = $clk_value;
        $clk_value = oct($clk->getbin());
        if ($clk_value == 0 and $clk_value_prev == 1) {
            $done = 1;
        }
    }

    lib::DLX::unstick_signals();
    lib::DLX::print_dlx_interface();

    # Send flits until the list is empty
    if (@command_list) {
        my $command = shift @command_list;
        lib::DLX::send_flit(@{$command});
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
