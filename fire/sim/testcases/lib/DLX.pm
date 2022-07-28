# DLX Interface Code
# Ryan King - rpking@us.ibm.com
# January 21, 2018

# Monitor and driver code for DLX

package lib::DLX;

use facility;
use fac;
use strict;
use warnings;

use Term::ANSIColor;

my $testbench;

# Fields making up the DL content
# Other fields in DL content always get sent to us as 0
my @rx_flit_dl_tl_template;
my @rx_flit_dl_bad_data_flit;
my @rx_flit_dl_data_run_length;
my @rx_flit_valid;

# Grab the flit as a whole, and we can get parts of it later
my @flit_signal_name;

sub import {
    my ($package, $tb) = @_;
    if (defined $tb) {
        $testbench = $tb;
    } else {
        $testbench = "";
    }
    if ($testbench eq "fire_fire") {
        @rx_flit_dl_tl_template = ( fac->new("FIRE0.FIRE.dlx_tlx_flit", 0, 0, 465, 460) ,
                                    fac->new("FIRE1.FIRE.dlx_tlx_flit", 0, 0, 465, 460) );
        @rx_flit_dl_bad_data_flit = ( fac->new("FIRE0.FIRE.dlx_tlx_flit", 0, 0, 459, 452) ,
                                      fac->new("FIRE1.FIRE.dlx_tlx_flit", 0, 0, 459, 452) );
        @rx_flit_dl_data_run_length = ( fac->new("FIRE0.FIRE.dlx_tlx_flit", 0, 0, 451, 448) ,
                                        fac->new("FIRE1.FIRE.dlx_tlx_flit", 0, 0, 451, 448) );
        @rx_flit_valid = ( fac->new("FIRE0.FIRE.dlx_tlx_flit_valid", 0, 0, 0, 0) ,
                           fac->new("FIRE1.FIRE.dlx_tlx_flit_valid", 0, 0, 0, 0) );
    } else {
        @rx_flit_dl_tl_template = ( fac->new("FIRE0.FIRE.dlx_tlx_flit", 0, 0, 465, 460) ,
                                    fac->new("dbg_dlx_tlxr_flit_full", 0, 0, 465, 460) );
        @rx_flit_dl_bad_data_flit = ( fac->new("FIRE0.FIRE.dlx_tlx_flit", 0, 0, 459, 452) ,
                                      fac->new("dbg_dlx_tlxr_flit_full", 0, 0, 459, 452) );
        @rx_flit_dl_data_run_length = ( fac->new("FIRE0.FIRE.dlx_tlx_flit", 0, 0, 451, 448) ,
                                        fac->new("dbg_dlx_tlxr_flit_full", 0, 0, 451, 448) );
        @rx_flit_valid = ( fac->new("FIRE0.FIRE.dlx_tlx_flit_valid", 0, 0, 0, 0) ,
                           fac->new("dbg_dlx_tlxr_flit_valid_full", 0, 0, 0, 0) );
    }
    if ($testbench eq "fire_fire") {
        @flit_signal_name = ("FIRE0.FIRE.dlx_tlx_flit",
                             "FIRE1.FIRE.dlx_tlx_flit");
    } else {
        @flit_signal_name = ("FIRE0.FIRE.dlx_tlx_flit",
                             "dbg_dlx_tlxr_flit_full");
    }
}

# Opcode to mnemonic decode, only 3.1 commands
# All undefined opcodes are not supported
my @OPCODES = ("unsupported") x 256;
$OPCODES[0b00000000] = "nop";
$OPCODES[0b00000001] = "return_tlx_credits / mem_rd_response"; # Meaning is dependent on direction
$OPCODES[0b00000010] = "mem_rd_fail";
$OPCODES[0b00000011] = "mem_rd_response.ow";
$OPCODES[0b00000100] = "mem_wr_response";
$OPCODES[0b00000101] = "mem_wr_fail";
$OPCODES[0b00000111] = "mem_rd_response.xw";
$OPCODES[0b00001000] = "return_tl_credits";
$OPCODES[0b00001011] = "mem_cntl_done";
$OPCODES[0b00001100] = "intrp_resp";
$OPCODES[0b00011010] = "intrp_rdy";
$OPCODES[0b00100000] = "rd_mem";
$OPCODES[0b00101000] = "pr_rd_mem";
$OPCODES[0b01010000] = "assign_actag";
$OPCODES[0b01011000] = "intrp_req";
$OPCODES[0b01011010] = "intrp_req.d";
$OPCODES[0b10000000] = "pad_mem";
$OPCODES[0b10000001] = "write_mem";
$OPCODES[0b10000010] = "write_mem.be";
$OPCODES[0b10000110] = "pr_wr_mem";
$OPCODES[0b11100000] = "config_read";
$OPCODES[0b11100001] = "config_write";
$OPCODES[0b11101111] = "mem_cntl";

# Look at data run length to see how many data flits are coming next
# Set is_data_flit to number of data flits coming, and decrement when one arrives
my @is_data_flit = (0, 0);

# Need to initialze this variable to avoid a warning
my $cycle = 0;

sub print_opcode_detail {
    my $mnemonic = shift;
    my $signal = shift;
    my $offset = shift;

    if ($mnemonic eq "nop") {
        # NOOP
    } elsif ($mnemonic eq "return_tl_credits") {
        my $vc0 =  fac->new($signal, 0, 0, $offset + 11, $offset +  8);
        my $vc1 =  fac->new($signal, 0, 0, $offset + 15, $offset + 12);
        my $dcp0 = fac->new($signal, 0, 0, $offset + 37, $offset + 32);
        my $dcp1 = fac->new($signal, 0, 0, $offset + 43, $offset + 38);
        printf("      TL.vc.0: %i\n", oct($vc0->getbin()));
        printf("      TL.vc.1: %i\n", oct($vc1->getbin()));
        printf("      TL.dcp.0: %i\n", oct($dcp0->getbin()));
        printf("      TL.dcp.1: %i\n", oct($dcp1->getbin()));
    } elsif ($mnemonic eq "return_tlx_credits / mem_rd_response") {
        my $vc0 =  fac->new($signal, 0, 0, $offset + 11, $offset +  8);
        my $vc1 =  fac->new($signal, 0, 0, $offset + 23, $offset + 20);
        my $dcp0 = fac->new($signal, 0, 0, $offset + 37, $offset + 32);
        my $dcp1 = fac->new($signal, 0, 0, $offset + 55, $offset + 50);
        printf("      TL.vc.0: %i\n", oct($vc0->getbin()));
        printf("      TL.vc.1: %i\n", oct($vc1->getbin()));
        printf("      TL.dcp.0: %i\n", oct($dcp0->getbin()));
        printf("      TL.dcp.1: %i\n", oct($dcp1->getbin()));
    } elsif ($mnemonic eq "mem_rd_response.ow") {
        my $capptag = fac->new($signal, 0, 0, $offset + 23, $offset +  8);
        my $dp      = fac->new($signal, 0, 0, $offset + 26, $offset + 24);
        printf("      CAPPTag: 0x%04X\n", oct($capptag->getbin()));
        printf("      dP: 0x%01X\n", oct($capptag->getbin()));
    } elsif ($mnemonic eq "config_write") {
        my $pa =      fac->new($signal, 0, 0, $offset +  91, $offset +  28);
        my $capptag = fac->new($signal, 0, 0, $offset + 107, $offset +  92);
        my $pl      = fac->new($signal, 0, 0, $offset + 111, $offset + 109);
        printf("      PA: 0x%016X\n", oct($pa->getbin()));
        printf("      CAPPTag: 0x%04X\n", oct($capptag->getbin()));
        printf("      pL: %i\n", oct($pl->getbin()));
    } elsif ($mnemonic eq "config_read") {
        my $pa =      fac->new($signal, 0, 0, $offset +  91, $offset +  28); # TODO does this get all the bits?
        my $capptag = fac->new($signal, 0, 0, $offset + 107, $offset +  92);
        my $pl      = fac->new($signal, 0, 0, $offset + 111, $offset + 109);
        printf("      PA: 0x%016X\n", oct($pa->getbin()));
        printf("      CAPPTag: 0x%04X\n", oct($capptag->getbin()));
        printf("      pL: %i\n", oct($pl->getbin()));
    } elsif ($mnemonic eq "mem_wr_response") {
        my $capptag = fac->new($signal, 0, 0, $offset + 23, $offset +  8);
        my $dp      = fac->new($signal, 0, 0, $offset + 25, $offset + 24);
        my $dl      = fac->new($signal, 0, 0, $offset + 27, $offset + 26);
        printf("      CAPPTag: 0x%04X\n", oct($capptag->getbin()));
        printf("      dP: %i\n", oct($dp->getbin()));
        printf("      dL: %i\n", oct($dl->getbin()));
    } elsif ($mnemonic eq "mem_wr_fail" || $mnemonic eq "mem_rd_fail") {
        my $capptag   = fac->new($signal, 0, 0, $offset + 23, $offset +  8);
        my $dp        = fac->new($signal, 0, 0, $offset + 25, $offset + 24);
        my $dl        = fac->new($signal, 0, 0, $offset + 27, $offset + 26);
        my $resp_code = fac->new($signal, 0, 0, $offset + 55, $offset + 52);

        my $resp_code_encode = oct($resp_code->getbin());
        my $resp_code_description = "Reserved";
        if    ($resp_code_encode == 2)  { $resp_code_description = "Retry request";              }
        elsif ($resp_code_encode == 8)  { $resp_code_description = "Data error";                 }
        elsif ($resp_code_encode == 9)  { $resp_code_description = "Unsupported operand length"; }
        elsif ($resp_code_encode == 11) { $resp_code_description = "Bad address specification";  }
        elsif ($resp_code_encode == 14) { $resp_code_description = "Failed";                     }

        printf("      CAPPTag: 0x%04X\n", oct($capptag->getbin()));
        printf("      dP: %i\n", oct($dp->getbin()));
        printf("      dL: %i\n", oct($dl->getbin()));
        printf("      Resp_code: %i (%s)\n", $resp_code_encode, $resp_code_description);
    } elsif ($mnemonic eq "write_mem" || $mnemonic eq "rd_mem") {
        my $pa =      fac->new($signal, 0, 0, $offset +  91, $offset +  28);
        my $capptag = fac->new($signal, 0, 0, $offset + 107, $offset +  92);
        my $dl      = fac->new($signal, 0, 0, $offset + 111, $offset + 110);
        printf("      PA: 0x%016X\n", oct($pa->getbin()));
        printf("      CAPPTag: 0x%04X\n", oct($capptag->getbin()));
        printf("      dL: %i\n", oct($dl->getbin()));
    } elsif ($mnemonic eq "pr_wr_mem" || $mnemonic eq "pr_rd_mem") {
        my $pa =      fac->new($signal, 0, 0, $offset +  91, $offset +  28);
        my $capptag = fac->new($signal, 0, 0, $offset + 107, $offset +  92);
        my $pl      = fac->new($signal, 0, 0, $offset + 111, $offset + 109);
        printf("      PA: 0x%016X\n", oct($pa->getbin()));
        printf("      CAPPTag: 0x%04X\n", oct($capptag->getbin()));
        printf("      pL: %i\n", oct($pl->getbin()));
    }
}

sub print_dlx_interface {
    foreach my $dlx (0..1) {
        if (oct($rx_flit_valid[$dlx]->getbin()) != 0) {
            $dlx == 0 ? print color("bold cyan") : print color("bold magenta");
            if ($is_data_flit[$dlx] == 0) {
                print "DLX $dlx received a Control flit\n";
                print color("reset");

                fusion::currentCycleL($cycle);
                printf("Cycle %s\n", $cycle);
                printf("  DL Content\n");
                printf("    TL template:     0x%02X\n", oct($rx_flit_dl_tl_template[$dlx]->getbin()));
                printf("    Bad data flit:   0x%02X\n", oct($rx_flit_dl_bad_data_flit[$dlx]->getbin()));
                printf("    Data run length: 0x%01X\n", oct($rx_flit_dl_data_run_length[$dlx]->getbin()));

                $is_data_flit[$dlx] = oct($rx_flit_dl_data_run_length[$dlx]->getbin());

                # Print information specific for each template
                my $template = oct($rx_flit_dl_tl_template[$dlx]->getbin());
                if ($template == 0x0) {
                    my @opcode_fac = ( fac->new($flit_signal_name[$dlx], 0, 0,  7,    0) ,
                                       fac->new($flit_signal_name[$dlx], 0, 0,  63,  56) ,
                                       fac->new($flit_signal_name[$dlx], 0, 0, 119, 112) ,
                                       fac->new($flit_signal_name[$dlx], 0, 0, 287, 280) );

                    printf("  Slot  0 -  1 (2, return_tlx_credits)\n");
                    my $opcode = oct($opcode_fac[0]->getbin());
                    printf("    Opcode: 0x%02X (%s)\n", $opcode, $OPCODES[$opcode]);
                    print_opcode_detail("$OPCODES[$opcode]", $flit_signal_name[$dlx], 0);

                    printf("  Slot  2 -  3 (2, reserved)\n");
                    $opcode = oct($opcode_fac[1]->getbin());
                    printf("    Opcode: 0x%02X (%s)\n", $opcode, $OPCODES[$opcode]);
                    print_opcode_detail("$OPCODES[$opcode]", $flit_signal_name[$dlx], 56);

                    printf("  Slot  4 -  9 (6)\n");
                    $opcode = oct($opcode_fac[2]->getbin());
                    printf("    Opcode: 0x%02X (%s)\n", $opcode, $OPCODES[$opcode]);
                    print_opcode_detail("$OPCODES[$opcode]", $flit_signal_name[$dlx], 112);

                    printf("  Slot 10 - 15 (6, reserved)\n");
                    $opcode = oct($opcode_fac[3]->getbin());
                    printf("    Opcode: 0x%02X (%s)\n", $opcode, $OPCODES[$opcode]);
                    print_opcode_detail("$OPCODES[$opcode]", $flit_signal_name[$dlx], 280);
                } elsif ($template == 0x1) {
                    my @opcode_fac = ( fac->new($flit_signal_name[$dlx], 0, 0,   7,   0) ,
                                       fac->new($flit_signal_name[$dlx], 0, 0, 119, 112) ,
                                       fac->new($flit_signal_name[$dlx], 0, 0, 231, 224) ,
                                       fac->new($flit_signal_name[$dlx], 0, 0, 343, 336) );

                    printf("  Slot  0 -  3 (4)\n");
                    my $opcode = oct($opcode_fac[0]->getbin());
                    printf("    Opcode: 0x%02X (%s)\n", $opcode, $OPCODES[$opcode]);
                    print_opcode_detail("$OPCODES[$opcode]", $flit_signal_name[$dlx], 0);

                    printf("  Slot  4 -  7 (4)\n");
                    $opcode = oct($opcode_fac[1]->getbin());
                    printf("    Opcode: 0x%02X (%s)\n", $opcode, $OPCODES[$opcode]);
                    print_opcode_detail("$OPCODES[$opcode]", $flit_signal_name[$dlx], 112);

                    printf("  Slot  8 - 11 (4)\n");
                    $opcode = oct($opcode_fac[2]->getbin());
                    printf("    Opcode: 0x%02X (%s)\n", $opcode, $OPCODES[$opcode]);
                    print_opcode_detail("$OPCODES[$opcode]", $flit_signal_name[$dlx], 224);

                    printf("  Slot 12 - 15 (4)\n");
                    $opcode = oct($opcode_fac[3]->getbin());
                    printf("    Opcode: 0x%02X (%s)\n", $opcode, $OPCODES[$opcode]);
                    print_opcode_detail("$OPCODES[$opcode]", $flit_signal_name[$dlx], 336);
                } elsif ($template == 0xA) {
                    my @opcode_fac = ( fac->new($flit_signal_name[$dlx], 0, 0, 343, 336) );

                    printf("  Slot 12 - 15 (4)\n");
                    my $opcode = oct($opcode_fac[0]->getbin());
                    printf("    Opcode: 0x%02X (%s)\n", $opcode, $OPCODES[$opcode]);
                    print_opcode_detail("$OPCODES[$opcode]", $flit_signal_name[$dlx], 336);

                    my $v_fac = fac->new($flit_signal_name[$dlx], 0, 0, 329, 328);
                    my $data_valid = (oct($v_fac->getbin()) & 0x2) >> 1;
                    my $data_bad   = (oct($v_fac->getbin()) & 0x1) >> 0;

                    if ($data_valid == 1) {
                        printf("  Bad data indication: %i\n", $data_bad);
                        printf("  Data\n");
                        my $word_fac;
                        for my $i (reverse 0..7) {
                            $word_fac = fac->new($flit_signal_name[$dlx], 0, 0, 32*$i + 31, 32*$i);
                            if ($i % 4 == 3) {
                                printf("    0x");
                            }
                            printf("%08X", oct($word_fac->getbin()));
                            if ($i % 4 == 0) {
                                printf("\n");
                            } else {
                                printf(" ");
                            }
                        }

                        printf("  xmeta\n");
                        # This loop looks pretty weird compared to the
                        # others because we're no longer aligned on 32
                        # bits, and the length isn't a multiple of 32
                        # bits.
                        for my $i (reverse 8..10) {
                            my $length = 32;
                            if ($i == 10) {
                                $length = 8;
                            }
                            $word_fac = fac->new($flit_signal_name[$dlx], 0, 0, 32*$i + $length - 1, 32*$i);
                            if ($i % 4 == 2) {
                                printf("    0x");
                            }
                            my $length_div4 = $length / 4;
                            printf("%0${length_div4}X", oct($word_fac->getbin()));
                            if ($i % 4 == 0) {
                                printf("\n");
                            } else {
                                printf(" ");
                            }
                        }
                    }
                } elsif ($template == 0xB) {
                    my @opcode_fac = ( fac->new($flit_signal_name[$dlx], 0, 0, 343, 336) ,
                                       fac->new($flit_signal_name[$dlx], 0, 0, 399, 392) ,
                                       fac->new($flit_signal_name[$dlx], 0, 0, 427, 420) );

                    printf("  Slot 12 - 13 (2)\n");
                    my $opcode = oct($opcode_fac[0]->getbin());
                    printf("    Opcode: 0x%02X (%s)\n", $opcode, $OPCODES[$opcode]);
                    print_opcode_detail("$OPCODES[$opcode]", $flit_signal_name[$dlx], 336);

                    printf("  Slot 14      (1)\n");
                    $opcode = oct($opcode_fac[1]->getbin());
                    printf("    Opcode: 0x%02X (%s)\n", $opcode, $OPCODES[$opcode]);
                    print_opcode_detail("$OPCODES[$opcode]", $flit_signal_name[$dlx], 392);

                    printf("  Slot 15      (1)\n");
                    $opcode = oct($opcode_fac[2]->getbin());
                    printf("    Opcode: 0x%02X (%s)\n", $opcode, $OPCODES[$opcode]);
                    print_opcode_detail("$OPCODES[$opcode]", $flit_signal_name[$dlx], 420);

                    my $v_fac = fac->new($flit_signal_name[$dlx], 0, 0, 329, 328);
                    my $data_valid = (oct($v_fac->getbin()) & 0x2) >> 1;
                    my $data_bad   = (oct($v_fac->getbin()) & 0x1) >> 0;

                    if ($data_valid == 1) {
                        printf("  Bad data indication: %i\n", $data_bad);
                        printf("  Data\n");
                        my $word_fac;
                        for my $i (reverse 0..7) {
                            $word_fac = fac->new($flit_signal_name[$dlx], 0, 0, 32*$i + 31, 32*$i);
                            if ($i % 4 == 3) {
                                printf("    0x");
                            }
                            printf("%08X", oct($word_fac->getbin()));
                            if ($i % 4 == 0) {
                                printf("\n");
                            } else {
                                printf(" ");
                            }
                        }

                        printf("  xmeta\n");
                        # This loop looks pretty weird compared to the
                        # others because we're no longer aligned on 32
                        # bits, and the length isn't a multiple of 32
                        # bits.
                        for my $i (reverse 8..10) {
                            my $length = 32;
                            if ($i == 10) {
                                $length = 8;
                            }
                            $word_fac = fac->new($flit_signal_name[$dlx], 0, 0, 32*$i + $length - 1, 32*$i);
                            if ($i % 4 == 2) {
                                printf("    0x");
                            }
                            my $length_div4 = $length / 4;
                            printf("%0${length_div4}X", oct($word_fac->getbin()));
                            if ($i % 4 == 0) {
                                printf("\n");
                            } else {
                                printf(" ");
                            }
                        }
                    }
                }
            } else {
                print "DLX $dlx received a Data flit\n";
                print color("reset");
                my $word_fac;
                for my $i (reverse 0..15) {
                    $word_fac = fac->new($flit_signal_name[$dlx], 0, 0, 32*$i + 31, 32*$i);
                    if ($i % 4 == 3) {
                        printf("  0x");
                    }
                    printf("%08X", oct($word_fac->getbin()));
                    if ($i % 4 == 0) {
                        printf("\n");
                    } else {
                        printf(" ");
                    }
                }

                $is_data_flit[$dlx]--;
            }
        }
    }
}

# Only support sending flits from Fire to OCMB. Doing the other way is
# much more complicated.
my $tx_flit_dl_crc = fac->new("FIRE0.FIRE.tlx_dlx_flit", 0, 0, 476, 511);
my $tx_flit_dl_ack_count = fac->new("FIRE0.FIRE.tlx_dlx_flit", 0, 0, 471, 475);
my $tx_flit_dl_reserved = fac->new("FIRE0.FIRE.tlx_dlx_flit", 0, 0, 468, 470);
my $tx_flit_dl_data_stalled = fac->new("FIRE0.FIRE.tlx_dlx_flit", 0, 0, 467, 467);
my $tx_flit_dl_short_flit_next = fac->new("FIRE0.FIRE.tlx_dlx_flit", 0, 0, 466, 466);
my $tx_flit_dl_tl_template = fac->new("FIRE0.FIRE.tlx_dlx_flit", 0, 0, 465, 460);
my $tx_flit_dl_bad_data_flit = fac->new("FIRE0.FIRE.tlx_dlx_flit", 0, 0, 452, 459);
my $tx_flit_dl_data_run_length = fac->new("FIRE0.FIRE.tlx_dlx_flit", 0, 0, 451, 448);
my $tx_flit = fac->new("FIRE0.FIRE.tlx_dlx_flit", 0, 0, 0, 511);
my $tx_flit_valid = fac->new("FIRE0.FIRE.tlx_dlx_flit_valid", 0, 0, 0, 0);

sub send_flit {
    my $tl_template = shift;
    my $data_run_length = shift;

    # Get rest of arguments depending on template
    my @opcode_fac;
    my @opcode;
    if ($tl_template == 0) {
        $opcode[0] = shift;
        $opcode[1] = 0; # Reserved
        $opcode[2] = shift;
        $opcode[3] = 0; # Reserved

        $opcode[0] == 0 or index($OPCODES[$opcode[0]], "return_tlx_credits") != -1 or
            die "opcode is reserved for return_tlx_credits or nop";

        @opcode_fac = ( fac->new("FIRE0.FIRE.tlx_dlx_flit", 0, 0, 427, 420) ,
                        fac->new("FIRE0.FIRE.tlx_dlx_flit", 0, 0, 371, 364) ,
                        fac->new("FIRE0.FIRE.tlx_dlx_flit", 0, 0, 315, 308) ,
                        fac->new("FIRE0.FIRE.tlx_dlx_flit", 0, 0, 147, 140) );
    } elsif ($tl_template == 1) {
        $opcode[0] = shift;
        $opcode[1] = shift;
        $opcode[2] = shift;
        $opcode[3] = shift;

        @opcode_fac = ( fac->new("FIRE0.FIRE.tlx_dlx_flit", 0, 0, 427, 420) ,
                        fac->new("FIRE0.FIRE.tlx_dlx_flit", 0, 0, 315, 308) ,
                        fac->new("FIRE0.FIRE.tlx_dlx_flit", 0, 0, 203, 196) ,
                        fac->new("FIRE0.FIRE.tlx_dlx_flit", 0, 0,  91,  84) );
    }

    $tx_flit_valid->stick([1]);

    $tx_flit_dl_tl_template->stick([$tl_template]);
    $tx_flit_dl_data_run_length->stick([$data_run_length]);

    for my $i (0..$#opcode) {
        $opcode_fac[$i]->stick([$opcode[$i]]);
    }
}

# Create list of signals to unstick after every cycle
my @unstick_list = (
    $tx_flit,
    $tx_flit_valid
    );

sub unstick_signals {
    # Unstick signals after clock in case they don't get driven again
    foreach my $signal (@unstick_list) {
        $signal->unstick();
    }
}

my $training_state0_prev = 0;
my $training_state1_prev = 0;
sub print_training_state {
    my $tsm0 = fac->new("FIRE0.FIRE.DL.DLX.tx.ctl.tsm_q", 0, 0, 2, 0);
    my $tsm1;
    if ($testbench eq "fire_fire") {
        $tsm1 = fac->new("FIRE1.FIRE.DL.DLX.tx.ctl.tsm_q", 0, 0, 2, 0);
    } else {
        $tsm1 = fac->new("MB_TOP.DLX.DLX.OMDL.otx.trn.tsm_q", 0, 0, 2, 0);
    }
    my $training_state0 = oct($tsm0->getbin());
    my $training_state1 = oct($tsm1->getbin());
    if($training_state0 != $training_state0_prev) {
        print color('bold cyan');
        printf("training state 0: 0x%x => 0x%x\n", $training_state0_prev, $training_state0);
        print color('reset');
        $training_state0_prev = $training_state0;
    }
    if($training_state1 != $training_state1_prev) {
        print color('bold magenta');
        printf("training state 1: 0x%x => 0x%x\n", $training_state1_prev, $training_state1);
        print color('reset');
        $training_state1_prev = $training_state1;
    }
}

sub calibrate {
    my $link_up0 = fac->new("FIRE0.FIRE.dlx_tlx_link_up", 0, 0, 0, 0);
    my $link_up1;
    if ($testbench eq "fire_fire") {
        $link_up1 = fac->new("FIRE1.FIRE.dlx_tlx_link_up", 0, 0, 0, 0);
    } else {
        $link_up1 = fac->new("MB_TOP.DLX.dl0_mc_link_up", 0, 0, 0, 0);
        fusion::stick(1, "MB_TOP.DLX.REG.DL0_CONFIG0_Q", 0, 0, 2, 2);
        fusion::stick(15, "MB_TOP.DLX.DLX.REG_DL_CONFIG0", 0, 0, 8, 11); # CFG_DL0_TRAIN_MODE (enable automatic training)
        fusion::stick(0, "MB_TOP.DLX.DLX.REG_DL_CONFIG0", 0, 0, 20, 23); # CFG_DL0_PHY_CNTR_LIMIT (1 us)
        fusion::stick(0, "MB_TOP.DLX.DLX.REG_DL_CONFIG1", 0, 0, 0, 0); # CFG_DL0_EDPL_ENA
    }

    do {
        print_training_state();
        fusion::clock(16);
    } while (not (oct($link_up0->getbin()) == 1 and oct($link_up1->getbin()) == 1));
}

1;
