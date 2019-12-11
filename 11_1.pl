use 5.030;
use strict;
use warnings;
use lib '.';
use Intcode;

my $intcode = Intcode->from_file($ARGV[0]);

my @hull;
my $r=100;
my $c=100;
my $dir = 0;
my @move=(
[-1,0], # up
[0, 1], # right
[1,0], # down
[0,-1], # left
);
$hull[$r]->[$c] = '0';
my %first;
my $cnt=0;
while (!$intcode->halted) {
    my $old_col = $hull[$r]->[$c] || 0;
    say "step $cnt: pos $r $c, color is $old_col";
    $intcode->input( [ $old_col ]);
    $intcode->runit;
    my $color = $intcode->output;
    $intcode->runit;
    my $turn = $intcode->output;

    $hull[$r]->[$c] = $color;
    $first{$r.'_'.$c}++;

    if ($turn ==1) {
        $dir++;
    }
    else {
        $dir--;
    }
    $dir=3 if $dir<0;
    $dir=0 if $dir>3;

    say "color $color, turn: $turn, dir is now $dir";
    $r += $move[$dir]->[0];
    $c += $move[$dir]->[1];
    die if $r<0;
    die if $c<0;
    $intcode->runit;
    #last if $cnt++ > 100;
}

say scalar keys %first;



