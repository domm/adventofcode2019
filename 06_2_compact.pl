use 5.028;
use strict;
use warnings;

my %o = map { /^(.*?)\)(.*)$/; $2 => $1  } <STDIN>;
my %map;

for my $who (qw(YOU SAN)) {
    my $ob = $o{$who};
    while ($ob = $o{$ob}) {
        $map{$who}->{$ob} = ++$map{cnt}->{$who};
        if ($who eq 'SAN' && $map{YOU}->{$ob}) {
            say $map{YOU}->{$ob} + $map{SAN}->{$ob};
            exit;
        }
    }
}

