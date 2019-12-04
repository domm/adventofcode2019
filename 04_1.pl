use 5.010;
use strict;
use warnings;

my $from = 172930;
my $to = 683082;

my $cnt;
PASSWD: for my $p ($from .. $to) {
    my @digits = split(//,$p);
    my $f=shift@digits;
    for my $d (@digits) {
        next PASSWD if $d < $f;
        $f = $d;
    }
    next unless $p =~ /(.)\1/;
    $cnt++;
}

say $cnt;

