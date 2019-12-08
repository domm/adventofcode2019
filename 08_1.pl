use 5.028;
use strict;
use warnings;

my $w=25;
my $h=6;

#my $w=3;
#my $h=2;
my $l=1;

my %layer;
my @data=split(//,<STDIN>);
if ($data[-1] !~/\d/) { pop @data };

my $c=1;
my $r=1;
my $zc=0;
my $zeros=99999999;
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
            if ($layer{$l}{0} < $zeros) {
                $hit = $l;
                $zeros = $layer{$l}{0};
            }
            $l++;
        }
        else {
            $r++;
        }
    } else {
        $c++;
    }
}
my $l = $layer{$hit};

say $l->{1} * $l->{2};
