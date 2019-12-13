use 5.030;
use strict;
use warnings;
use lib '.';
use Intcode;
use utf8;
binmode(STDOUT, ":utf8");

my $speed = 5000;
my $show = 0;
if ($ARGV[1]) {
    $speed = $ARGV[1];
    $show = 1;
}
else {
    say "If you want to see the game, pass speed param (default 5000)";
}
my $pause = 1 / $speed;


my $intcode = Intcode->from_file($ARGV[0]);
$intcode->code->[0]=2;
my @game;
my @data;
while (!$intcode->waiting) {
    $intcode->runit;
    push(@data,$intcode->output);
    if (@data % 3 == 0) {
        $game[$data[1]]->[$data[0]] = $data[2];
        @data=();
    }
}
my $clear_string = `clear`;

my $score=0;
my $paddle=0;
my $ball=0;
my $move = 0;
my @nice=('','@','#','-','*');
$intcode->input([$move]);
while (!$intcode->halted) {
    show() if $show;
    #say "Ball $ball paddle $paddle";
    my @update;
    for (1..3) {
        $intcode->runit;
        push(@update,$intcode->output);
    }
    if ($update[0] == -1 && $update[1] == 0) {
        $score=$update[2];
    }
    else {
        $game[$update[1]]->[$update[0]] = $update[2];
        if ($update[2] == 4) {
            #say "paddle at $paddle, ball moved from $ball to $update[0]";
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
                #        say "paddle move: $move";
        }
        elsif ($update[2] == 3) {
            #say "paddled moved from $paddle to ".$update[0];
            $paddle = $update[0];
        }
    }
    $intcode->input([$move]);
}
say "FINAL SCORE $score";

sub show {
    say "Speed: $speed\tSCORE ".$score;
    for my $r ( @game ) {
        for my $c ( @$r ) {
            print $nice[$c] || ' ';
        }
        print "\n";
    }
    select(undef,undef,undef,$pause);
    print $clear_string;
}

