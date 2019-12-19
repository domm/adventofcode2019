use 5.030;
use strict;
use warnings;
use lib '.';
use Intcode;

my @map;
my $maxc=0;

my $t = 0;
for my $x (0 .. 100) {
    for my $y (0 .. 100) {
        my $intcode = Intcode->from_file($ARGV[0]);
        $intcode->input([$x, $y]);
        $intcode->runit;
        my $val = $intcode->output;
        if ($val) {
            $t++;
            say ("row $x / col $y");
        }
        #print $intcode->output;
    }
    # print "\n";
}

say $t;

