use 5.028;
use strict;
use warnings;

my $in = <STDIN>;
chomp($in);
my @signal = split(//, $in x 10000);
my $offset = substr($in,0,7);
say "offset $offset";

my $sl = @signal;
my @bp = (0, 1, 0, -1);
my @pattern;
my $start = my $prev = time;
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
    if ($pos % 1000 == 0) {
        my $now = time;
        my $took = $now - $start;
        my $reltook = $now - $prev;
        say "cal pos $pos %".( $pos/$sl*100 );
        say "took abs $took sec, rel $reltook";
        $prev = $now;
    }
    shift(@ppattern);
    push(@pattern,\@ppattern);
}
say "done with pattern";
my $phase=0;
my @in = @signal;
while ($phase < 100) {
    my @out;
    for my $i (0 .. $#signal) {
        say "phase $phase, pos $i %".($i/$sl*100) if $i % 1000 == 0;
        my $sum=0;
        for my $j (0 .. $#signal) {
            $sum+=$in[$j] * $pattern[$i][$j];
       }
       my ($next) = $sum=~/(\d)$/;
       push(@out,$next);
    }
    @in = @out;
    $phase++;
    say $phase;
}

open (my $out, ">", '16.out');
my $code = join('',@in);
say $out $code;
say substr($code,$offset,7);

