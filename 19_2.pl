use 5.030;
use strict;
use warnings;
use lib '.';
use Intcode;

my $t = 0;
my $x=1200;
my $start_y=300;

while (1) {
    my $y ;
    FIRST: for my $ty (0 .. $x) {
        if (scan($x, $start_y+$ty)) {
            $y = $start_y+$ty;
            last FIRST;
        }
    }
    unless (scan($x, $y + 99)) {
        $start_y = $y;
        $x++;
    }
    else {
        my $last=0;
        LAST: for my $ty (0 .. 1000) {
            my $val = scan($x, $y + 99 + $ty + 1);
            if (!$val) {
                my $end_of_beam = $y + $ty + 99;
                my $ship_fit = $end_of_beam - 99;
                my $other_row = $x+99;
                say "lookahead from row $x / $ship_fit .. $end_of_beam to $other_row / $ship_fit";
                if (scan($other_row, $ship_fit)) {
                    say "HIT at $x / ".($y + $ty);
                    say "res ". ($y + $ty + ($x * 10000));
                    exit;
                }
                else {
                    $x++;
                    last LAST;
                }

            }
        }
    }
}

sub scan {
    my ($x, $y) = @_;
    my $intcode = Intcode->from_file($ARGV[0]);
    $intcode->input([$x, $y]);
    $intcode->runit;
    return $intcode->output;
}

