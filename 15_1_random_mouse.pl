use 5.030;
use strict;
use warnings;
use lib '.';
use Intcode;

my $intcode = Intcode->from_file($ARGV[0]);
my @map;
$map[30]->[30]='X';
my $x = my $y = 30;
my @moves=(
    undef,
    [-1, 0, 4, 3], #n
    [1,0, 3, 4],   #s 
    [0,-1, 1, 2],  #w 
    [0,1, 2, 1],   #e
);

my $s=0;
my $dir = 1 ;
my $clear_string = `clear`;
while (!$intcode->waiting) {
    show() if $s % 10000 == 0;
    #say "$s at $y $x, move $dir";
    $intcode->input([$dir]);
    $intcode->runit;
    my $status = $intcode->output;
    #say "got $status";
    my $ty = $y + $moves[$dir]->[0];
    my $tx = $x + $moves[$dir]->[1];
    if ($status == 0) {
        $map[$ty]->[$tx] = '#';
        #   say "$ty $tx is a wall";
        $dir = int(rand(4) + 1);
        # my $ndir = $moves[$dir]->[2];
        # say "check if we know next target at $ndir";
        # say $y + $moves[$ndir]->[0];
        # say $x + $moves[$ndir]->[1];

        # while ($map[ $y + $moves[$ndir]->[0] ]->[ $x + $moves[$ndir]->[1]] eq '#') {
        #     say "dir is a wall!";
        #     $ndir = int(rand(4) + 1);
        #     say "$ndir";
        #     #$ndir = $moves[$dir]->[3];
        # }
    }
    elsif ($status == 1) {
        $map[$ty]->[$tx] ||='.';
        $map[$y]->[$x] = '.';
        $y = $ty;
        $x = $tx;
        $map[$ty]->[$tx] = 'd';
        #say "moved to $ty $tx";
        $dir = int(rand(4) + 1);
    }
    elsif ($status == 2) {
        $map[$ty]->[$tx]='O';
        show();
        
        say "$s FOUND at $ty $tx";
        last;
    }
    $s++;
    #last if $s>10000;
}

sub show {
    # select(undef,undef,undef,0.0001);
    print $clear_string;
    $map[30]->[30]='X';
    open(my $out, ">","15.out");
    for my $r ( @map ) {
        for my $c ( @$r ) {
            print  $c || ' ';
        }
        print "\n";
    }
    print "\n";

}


