use 5.010;
use strict;
use warnings;
my @wires = ( <STDIN> );
my @grid;
my $wire=1;
my @hits;
my @start = (100000,100000);
#my @start = (20,20);
my @hit;
my $short=9999999999999;
my @length=(0,0,0);
for my $path (@wires) {
    my @w = split(',',$path);
    my $x = $start[0];
    my $y = $start[1];
    $grid[$y][$x]=['s',0,0];
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

# Lattenzaun!!!! TODO fix? take care
say $short;

sub move {
    my ($w, $mx, $my) = @_;
    if ($grid[$my][$mx][$w]) {
        say "already there";
        $length[$w]++;
    }
    else {
        $grid[$my][$mx][$w] = $length[$w]++;
    }
    #say "w $w ". $grid[$my][$mx][$w]++;
    if ($grid[$my][$mx][0] && $grid[$my][$mx][0] == $w-1) {
        my $dist = $grid[$my][$mx][1] + $grid[$my][$mx][2];
        if ($dist < $short) {
            $short = $dist;
        }
    }
    $grid[$my][$mx][0] = $w;
}

