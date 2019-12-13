use 5.030;
use strict;
use warnings;
use lib '.';
use Intcode;

my $intcode = Intcode->from_file($ARGV[0]);
#$intcode->input( [ 2 ]);
$intcode->code->[0]=2;
my @data;
while (!$intcode->waiting) {
    $intcode->runit;
    push(@data,$intcode->output);
}

#@data = (1,2,3,6,5,4);

my @game;
my $clear_string = `clear`;

my $paddle=0;
my $ball=0;
while (@data) {
    my ($x, $y, $t) = (shift(@data), shift(@data), shift(@data));
    $game[$y]->[$x] = $t;
    if ($t == 3) {
        $paddle=$x;
    }
    elsif ($t == 4) {
        $ball=$x;
    }
}
my %in=(
j=>-1,
k=>0,
l=>1
);
my @score;
my $total=0;
say "$ball $paddle";
my $ball_dir=0;
my $no_first_left=1;
show();
while (!$intcode->halted) {
    my $x;
    say "Ball $ball paddle $paddle";
    if ($intcode->waiting) {
        my $in=0;
        say "Ball $ball paddle $paddle";
        if ($ball > $paddle) {
            $in=1;
            say "move right";
        }
        elsif ($ball < $paddle) {
            $in = -1;
            if ($no_first_left) {
                $in=0;
                $no_first_left=0;
            }
            say "move left";
        }
        else {
            #      $in = $ball_dir;
        }
        say "in $in";
        $intcode->input([$in]);
        select(undef,undef,undef,0.1);
        $intcode->waiting(0);
    }
    my @update;
    for (1..3) {
        $intcode->runit;
        push(@update,$intcode->output);
    }
    say join(" ","got from engine",@update);
    if ($update[0] == -1 && $update[1] == 0) {
        push(@score,$update[2]);
        $total+=$update[2];
        say "SCORE ".$update[2];
    }
    else {
        $game[$update[1]]->[$update[0]] = $update[2];
        if ($update[2] == 4) {
            if ($update[0] !=4 && $update[1] !=4) {
                say "ball moved from $ball to $update[0]";
                $ball_dir = $update[0] > $ball ? 1 : -1;
                $ball = $update[0];
            }
        }
        elsif ($update[2] = 3) {
            $paddle = $update[0];
        }
    }
    show();
}

# 45,75, 166,208
sub show {
    #print $clear_string;
    say "j=left, k=stay, l=right    SCORE ".$total;
    for my $r ( @game ) {
        for my $c ( @$r ) {
            print $c || ' ';
        }
        print "\n";
    }
}

