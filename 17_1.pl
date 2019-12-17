use 5.030;
use strict;
use warnings;
use lib '.';
use Intcode;

my $intcode = Intcode->from_file($ARGV[0]);
my @map;
my ($r, $c) = (0,0);
my $maxc=0;
while (!$intcode->waiting) {
    $intcode->runit;
    my $ascii = $intcode->output;
    if ($ascii == 10) {
        $r++;
        $c=0;
    }
    else {
        push($map[$r]->@*,chr($ascii));
        $c++;
        $maxc=$c if $c>$maxc;
    }
}
#show();
find_intersection();

sub show {
    for my $r (0 .. $#map) {
        for my $c ( 0 .. $maxc ) {
            print $map[$r]->[$c] || ' ';
        }
        print "\n";
    }
}

sub find_intersection {
    my $algn=0;
    for my $r (0 .. $#map) {
        for my $c ( 0 .. $maxc ) {
            my $here = $map[$r]->[$c] || '';
            next unless $here eq '#';
            my $there=0;
            for my $look ([-1,0],[0,1],[1,0],[0,-1]) {
                my $rl = $r + $look->[0];
                my $cl= $c + $look->[1];
                next if ($rl || $cl) < 0;
                $there++ if ($map[$rl]->[$cl] && $map[$rl]->[$cl]  eq '#');
            }
            if ($there == 4) {
                $algn += ($r * $c);
            }
        }
    }
    say "alignment sum: $algn";
}

