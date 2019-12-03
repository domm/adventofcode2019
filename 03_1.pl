use 5.010;
use strict;
use warnings;
my @wires = ( <STDIN> );
my @grid;
my $wire=1;
my @hits;
my @start = (100000,100000);
my @hit;
my $short=9999999999999;
for my $path (@wires) {
    my @w = split(',',$path);
    my $x = $start[0];
    my $y = $start[1];
    $grid[$y][$x]='s';
    for my $move (@w) {
        my ($dir,$cnt) = $move =~ /(\w)(\d+)/;
        #say "$wire $dir  -> $cnt";
        if ($dir eq 'R') {
            for (1 .. $cnt) {
                move($wire, ++$x, $y);
            }
        }
        elsif ($dir eq 'L') {
            for (1 .. $cnt) {
                move($wire, --$x, $y);
            }
        }
        elsif ($dir eq 'U') {
            for (1 .. $cnt) {
                move($wire, $x, --$y);
            }
        }
        elsif ($dir eq 'D') {
            for (1 .. $cnt) {
                move($wire, $x, ++$y);
            }
        }
        die 'too small' if $x <0 || $y <0;


    }
    $wire++;
}

#use Data::Dumper; $Data::Dumper::Maxdepth=3;$Data::Dumper::Sortkeys=1;warn Data::Dumper::Dumper \@hits;
#dumpgrid();
say $short;

sub move {
    my ($w, $mx, $my) = @_;
    #    say "$mx $my";
    if ($grid[$my][$mx] && $grid[$my][$mx] == $w-1) {
        my $dist = abs($start[0] - $mx) + abs($start[1]- $my);
        if ($dist < $short) {
            push(@hits,[$my,$mx]);
            $short = $dist;
        }
    }
    $grid[$my][$mx] = $w;
}


sub dumpgrid {
for my $r (@grid) {
    for my $c (@$r) {
        print $c || ' ';
    }
    print "\n";
}
}


