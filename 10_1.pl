use 5.028;
use strict;
use warnings;
use Math::Vec;

my @map;
foreach my $line (<STDIN>) {
    chomp($line);
    push(@map, [split(//,$line)]);
}

my $rows = $#map;
my $cols = $map[0]->@* - 1;

my $max=0;
my $hit;

for my $y (0 .. $rows) {
    for my $x (0 .. $cols) {
        my $val = $map[$y]->[$x];
        next unless $val eq '#';
        #say "M at $x $y";
        count($x, $y);
    }
}

say "$hit: $max";

sub count {
    my ($mx, $my) = @_;
    my $found=0;
    my @cmap;
    my %lines;
    for my $y (0 .. $rows) {
        for my $x (0 .. $cols) {
            next if $mx == $x && $my==$y; # self
            my $val = $map[$y]->[$x];
            next unless $val eq '#';
            my $dx = $x - $mx;
            my $dy = $y - $my;
            my $v = Math::Vec->new($dx, $dy);
            my ($a, $b, $c) = map { sprintf("%.5f", $_) }  $v->UnitVector;
            $lines{$a.'|'.$b}++;
            #say "$mx|$mx => $x|$y = $dx|$dy";
        }
    }
    #use Data::Dumper; $Data::Dumper::Maxdepth=3;$Data::Dumper::Sortkeys=1;warn Data::Dumper::Dumper \%lines;

    my $seen = keys %lines;
    #say "$mx|$my sees $seen";
    if ($seen > $max) {
        $max = $seen;
        $hit="$mx|$my";
    }
}


