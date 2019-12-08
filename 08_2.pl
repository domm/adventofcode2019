use 5.028;
use strict;
use warnings;

my $w=25;
my $h=6;
my $l=1;

my %layer;
my @data=split(//,<STDIN>);
if ($data[-1] !~/\d/) { pop @data };

my $c=1;
my $r=1;
my $zc=0;
my $hit;
while (@data) {
    my $p = shift(@data);
    push($layer{$l}{d}{$r}->@*,$p);
    $zc++ if $p == 0;
    $layer{$l}{$p}++;
    #say "$l $r $c";
    if ($c == $w) {
        $c=1;
        if ($r == $h) {
            $r=1;
            $l++;
        }
        else {
            $r++;
        }
    } else {
        $c++;
    }
}
#use Data::Dumper; $Data::Dumper::Maxdepth=3;$Data::Dumper::Sortkeys=1;warn Data::Dumper::Dumper \%layer;

my $maxl=$l - 1;

for my $r (1 ..$h) {
    for my $c (1 .. $w) {
        COL: for my $l (1 .. $maxl) {
            my $col = $layer{$l}{d}{$r}[$c -1];
            #say "$l $r $c -> ".$col;
            if ($col != 2) {
                print $col == 1 ? '#' : ' ';
                last COL;
            }
        }
    }
    print "\n";
}

