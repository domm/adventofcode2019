use 5.028;
use strict;
use warnings;

my $in = <STDIN>;
chomp($in);
my @signal = split(//,$in);

my $sl = @signal;
my @bp = (0, 1, 0, -1);

my @pattern;
for my $pos (0 .. $sl) {
    my $times = $pos+1;
    my $bi=0;
    my @ppattern;
    my $lt = $times;
    for my $i (0 .. $sl+1) {
        my $p = $bp[$bi % @bp];
        push(@ppattern, $p);
        if (--$lt == 0) {
            $bi++;
            $lt = $times;
        }
    }
    shift(@ppattern);
    push(@pattern,\@ppattern);
}

my $phase=0;
my @in = @signal;
while ($phase < 100) {
    my @out;
    for my $i (0 .. $#signal) {
        my $sum=0;
        for my $j (0 .. $#signal) {
            $sum+=$in[$j] * $pattern[$i][$j];
       }
       my ($next) = $sum=~/(\d)$/;
       push(@out,$next);
    }
    @in = @out;
    $phase++;
}

say join('',@in[0 .. 7]);

