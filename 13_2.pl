use 5.030;
use strict;
use warnings;
use lib '.';
use Intcode;

my $intcode = Intcode->from_file($ARGV[0]);
$intcode->code->[0]=2;
my @data;
while (!$intcode->waiting) {
    $intcode->runit;
    push(@data,$intcode->output);
}
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
my @score;
my $total=0;
say "$ball $paddle";
my $move = 0;
show();
$intcode->input([0]);
while (!$intcode->halted) {
    say "Ball $ball paddle $paddle";
    #if ($intcode->waiting) {
    #    $intcode->input([$move]);
    #    select(undef,undef,undef,0.0005);
    #    $intcode->waiting(0);
    #}
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
                say "paddle at $paddle, ball moved from $ball to $update[0]";
                $ball = $update[0];
                if ($ball > $paddle) {
                    $move=1;
                }
                elsif ($ball < $paddle) {
                    $move=-1;
                }
                else {
                    $move = 0;
                }
                say "paddle move: $move";
            }
        }
        elsif ($update[2] == 3) {
            say "paddled moved from $paddle to ".$update[0];
            $paddle = $update[0];
        }
    }
    $intcode->input([$move]);
        select(undef,undef,undef,0.0005);
    show();
}

# 45,75, 166,208
sub show {
    print $clear_string;
    say "j=left, k=stay, l=right    SCORE ".$total;
    for my $r ( @game ) {
        for my $c ( @$r ) {
            print $c || ' ';
        }
        print "\n";
    }
}

