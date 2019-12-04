use 5.010;
use strict;
use warnings;

my @cand = (172930 .. 683082);
#my @cand = (112233, 123444, 111122);
my $cnt;
PASSWD: for my $p (@cand) {
    my @digits = split(//,$p);
    my $f=shift@digits;
    my @same;
    for my $d (@digits) {
        next PASSWD if $d < $f;
        $same[$d]++ if $d == $f;
        $f = $d;
    }
    next unless $p =~ /(.)\1/;
    next unless grep { $_ && $_ == 1 } @same;
    $cnt++;
}

say $cnt;

