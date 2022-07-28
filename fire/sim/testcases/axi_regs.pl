# AXI4-Lite Register Reads and Writes

use facility;
use strict;
use warnings;

use Term::ANSIColor;

print("\n");
print "##################################################################\n";
print "## RESET #########################################################\n";
print "##################################################################\n";
axi_reset();

my @reg_we = (
    0xFFFFFFFF,
    0x00000000,
    0xAAAAAAAA,
    0x55555555,
    0xFFFFFFFF,
    0x00000000,
    0xAAAAAAAA,
    0x55555555,
    0xFFFFFFFF,
    0x00000000,
    0xAAAAAAAA,
    0x55555555,
    0xFFFFFFFF,
    0x00000000,
    0xAAAAAAAA,
    0x55555555,
    );

my @reg_hwwe = (
    0x00000000,
    0x00000000,
    0x00000000,
    0x00000000,
    0xFFFFFFFF,
    0xFFFFFFFF,
    0xFFFFFFFF,
    0xFFFFFFFF,
    0xAAAAAAAA,
    0xAAAAAAAA,
    0xAAAAAAAA,
    0xAAAAAAAA,
    0x55555555,
    0x55555555,
    0x55555555,
    0x55555555,
    );

my @reg_sticky = (
    0x00000000,
    0xFFFFFFFF,
    0x00000000,
    0xAAAA5555,
    0x00000000,
    0xFFFFFFFF,
    0x00000000,
    0xAAAA5555,
    0x00000000,
    0xFFFFFFFF,
    0x00000000,
    0xAAAA5555,
    0x00000000,
    0xFFFFFFFF,
    0x00000000,
    0xAAAA5555,
    );

my $pass = 1;

print("\n");
print "##################################################################\n";
print "## RUNNING DETERMINISTIC SCOM READ/WRITE TEST ####################\n";
print "##################################################################\n";
reset_regs();

my @test_data = (
    0xFFFFFFFF,
    0x00000000,
    0xAAAAAAAA,
    0x55555555,
    0x01234567,
    0x76543210,
    0xFEDCBA98,
    0x89ABCDEF,
    0xDEADBEEF,
    );

my $i = 0;
foreach my $write_data (@test_data) {
    printf("Subtest %i / %i\n", $i++, $#test_data);
    foreach my $reg (0..15) {
        my $address = $reg * 4;
        write_reg($address, $write_data);
        fusion::clock(200);

        my $expected_data = $write_data & $reg_we[$reg];

        my $read_data = read_reg($address);
        result($reg, $write_data, $expected_data, $read_data);
        fusion::clock(20);
    }
}

print("\n");
print "##################################################################\n";
print "## RUNNING RANDOM SCOM READ/WRITE TEST ###########################\n";
print "##################################################################\n";
reset_regs();

my $num_test = 100;
foreach my $i (0..$num_test-1) {
    printf("Subtest %i / %i\n", $i + 1, $num_test);
    my $reg = int(rand(16));
    my $write_data = int(rand(0xFFFFFFFF+1));

    my $address = $reg * 4;
    write_reg($address, $write_data);
    fusion::clock(200);

    my $expected_data = $write_data & $reg_we[$reg];

    my $read_data = read_reg($address);
    result($reg, $write_data, $expected_data, $read_data);
    fusion::clock(20);
}

print("\n");
print "##################################################################\n";
print "## RUNNING DETERMINISTIC HARDWARE UPDATE TEST ####################\n";
print "##################################################################\n";
reset_regs();

@test_data = (
    0xFFFFFFFF,
    0x00000000,
    0xAAAAAAAA,
    0x55555555,
    0x01234567,
    0x76543210,
    0xFEDCBA98,
    0x89ABCDEF,
    0xDEADBEEF,
    );

$i = 0;
foreach my $write_data (@test_data) {
    printf("Subtest %i / %i\n", $i++, $#test_data);
    foreach my $reg (0..15) {
        my $address = $reg * 4;
        update_reg($reg, $write_data);
        fusion::clock(200);

        my $expected_data = $write_data & $reg_hwwe[$reg];

        my $read_data = read_reg($address);
        result($reg, $write_data, $expected_data, $read_data);
        fusion::clock(20);
    }
    reset_regs();
}

print("\n");
print "##################################################################\n";
print "## RUNNING RANDOM HARDWARE UPDATE TEST ###########################\n";
print "##################################################################\n";
reset_regs();

$num_test = 100;
foreach my $i (0..$num_test-1) {
    printf("Subtest %i / %i\n", $i + 1, $num_test);
    my $reg = int(rand(16));
    my $write_data = int(rand(0xFFFFFFFF+1));

    my $address = $reg * 4;
    update_reg($reg, $write_data);
    fusion::clock(200);

    my $expected_data = $write_data & $reg_hwwe[$reg];

    my $read_data = read_reg($address);
    result($reg, $write_data, $expected_data, $read_data);
    fusion::clock(20);
    reset_regs();
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

sub axi_reset {
    fusion::clock(20);
    fusion::stick(0, "s0_axi_aresetn", 0, 0, 0, 0);
    fusion::clock(20);
    fusion::unstick("s0_axi_aresetn", 0, 0, 0, 0);
    fusion::clock(20);
}

sub reset_regs {
    my $cycle = 0;
    fusion::currentCycleL($cycle);
    printf("    Cycle %-8i    Resetting regs\n", $cycle);
    my $write_data = 0;

    $write_data = convert(0);
    foreach my $reg (0..15) {
        my $vhdl_name = sprintf("%02X", $reg);
        fusion::put($write_data, "axi_regs.reg_${vhdl_name}_q", 0, 0, 0, 31);
    }
    fusion::clock(20);
}

sub write_reg {
    my $address = convert(shift);
    my $data = convert(shift);

    fusion::stick(1, "s0_axi_awvalid", 0, 0, 0, 0);
    fusion::stick($address, "s0_axi_awaddr", 0, 0, 0, 31);
    fusion::clock(8);

    fusion::unstick("s0_axi_awvalid", 0, 0, 0, 0);
    fusion::unstick("s0_axi_awaddr", 0, 0, 0, 31);
    fusion::clock(20);

    fusion::stick(1, "s0_axi_wvalid", 0, 0, 0, 0);
    fusion::stick($data, "s0_axi_wdata", 0, 0, 0, 31);
    fusion::clock(8);

    fusion::unstick("s0_axi_wvalid", 0, 0, 0, 0);
    fusion::unstick("s0_axi_wdata", 0, 0, 0, 31);
    fusion::clock(20);

    fusion::stick(1, "s0_axi_bready", 0, 0, 0, 0);
    fusion::clock(8);

    fusion::unstick("s0_axi_bready", 0, 0, 0, 0);

    return 0;
}

sub read_reg {
    my $address = convert(shift);

    fusion::stick(1, "s0_axi_arvalid", 0, 0, 0, 0);
    fusion::stick($address, "s0_axi_araddr", 0, 0, 0, 31);
    fusion::clock(8);

    fusion::unstick("s0_axi_arvalid", 0, 0, 0, 0);
    fusion::unstick("s0_axi_araddr", 0, 0, 0, 31);
    fusion::clock(20);

    fusion::stick(1, "s0_axi_rready", 0, 0, 0, 0);
    fusion::clock(8);

    fusion::unstick("s0_axi_rready", 0, 0, 0, 0);

    my $data = 0;
    fusion::get($data, "s0_axi_rdata", 0, 0, 0, 31);
    return convert($data);
}

sub update_reg {
    my $reg = sprintf("%02X", shift);
    my $data = convert(shift);

    fusion::stick($data, "reg_${reg}_update_i", 0, 0, 0, 31);
    fusion::stick(1, "reg_${reg}_hwwe_i", 0, 0, 0, 0);

    fusion::clock(4);

    fusion::unstick("reg_${reg}_update_i", 0, 0, 0, 31);
    fusion::unstick("reg_${reg}_hwwe_i", 0, 0, 0, 0);

    return 0;
}

sub convert {
    my ($hexvalue) = @_;
    my $str = sprintf( "%032b", $hexvalue);
    my $num = join '', (reverse (split(//, $str)));
    my $final = oct("0b$num");

    return $final;
}

sub result {
    my $reg = shift;
    my $write_data = shift;
    my $expected = shift;
    my $actual = shift;

    my $cycle = 0;
    fusion::currentCycleL($cycle);

    printf("    Cycle %-8i    Register 0x%X:    Input Data 0x%08X    Expected 0x%08X    Actual ", $cycle, $reg, $write_data, $expected);
    if ($expected == $actual) {
        print color('bold green');
    } else {
        print color('bold red');
        $pass = 0;
    }
    printf("0x%08X\n", $actual);
    print color('reset');
}
