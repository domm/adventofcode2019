use 5.030;
use strict;
use warnings;
use lib '.';
use Intcode;

my $intcode = Intcode->from_file($ARGV[0]);
my @map;
#$map[30]->[30]='X';
my $x = my $y = 24;
my @moves=(
    undef,
    [-1, 0, 4, 3], #n
    [1,0, 3, 4],   #s 
    [0,-1, 1, 2],  #w 
    [0,1, 2, 1],   #e
);

my $s=0;
my $dir=1;
my $distance=0;
my %dist;
my $clear_string = `clear`;
while (!$intcode->waiting) {
    show() if $s % 1000 == 0;
    #say "$s at $y $x";
    my $here = $map[$y]->[$x];
    my @free;
    for my $ld (qw(1 4 2 3)) {
        push(@free,$ld) if !wall_at($x, $y, $ld);
    }
    if (@free == 1) {
        #   say "dead end $y $x, block for later";
        $here = '+';
    }
    $dir = $free[rand(@free)];
    #say "move $dir";

    $intcode->input([$dir]);
    $intcode->runit;
    my $status = $intcode->output;
    #say "got $status";
    my $ty = $y + $moves[$dir]->[0];
    my $tx = $x + $moves[$dir]->[1];
    if ($status == 0) {
        $map[$ty]->[$tx] = '#';
    }
    elsif ($status == 1) {
        if ($dist{$ty.':'.$tx}) {
            $distance = $dist{$ty.':'.$tx};
        }
        else {
            $distance++;
            $dist{$ty.':'.$tx} = $distance;
            $map[$ty]->[$tx]='.';
        }
        $map[$y]->[$x] = $here;
        $y = $ty;
        $x = $tx;
        #   say "moved to $ty $tx";
    }
    elsif ($status == 2) {
        $map[$ty]->[$tx]='O';
        $distance++;
        show();
        say "$s FOUND at $ty $tx, distance $distance";
        last;
    }
    $s++;
    #last if $s>3000;
}

sub wall_at {
    my ($x, $y, $dir) = @_;
    my $ty = $y + $moves[$dir]->[0];
    my $tx = $x + $moves[$dir]->[1];

    if ($map[$ty]->[$tx] && ($map[$ty]->[$tx] eq '#' || $map[$ty]->[$tx] eq '+' )) {
        return 1;
    }
    else {
        return
    }

}

sub show {
    #select(undef,undef,undef,0.001);
    print $clear_string;
    #$map[30]->[30]='X';
    say "currently at $y / $x, distance: ".$dist{$y.':'.$x};
    for my $r (0 .. 45) {
        for my $c ( 0 .. 45 ) {
            if ($r == 24 && $c == 24) {
                print 'S';
            }
            elsif ($r == $y && $c == $x) {
                print '*';
            }
            else {
                print $map[$r]->[$c] || ' ';
            }
        }
        print "\n";
    }
    print "\n";

}


