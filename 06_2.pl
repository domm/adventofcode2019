use 5.028;
use strict;
use warnings;

my %o;

for (<STDIN>) {
    chomp();
    my ($a, $b) = split(/\)/,$_);
    $o{$b} = $a;
};

my %map;
transfer('YOU');
my $common = transfer('SAN');

say $map{YOU}->{$common} + $map{SAN}->{$common};

sub transfer {
    my ($who) = @_;
    my $ob = $o{$who};
    while (1) {
        return unless my $p = $o{$ob};
        $map{$who}->{$p} = ++$map{cnt}->{$who};
        return $p if $who eq 'SAN' && $map{YOU}->{$p};
        $ob = $p;
    }
}

