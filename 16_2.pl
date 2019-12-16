use 5.028;
use strict;
use warnings;

my $in = <STDIN>;
chomp($in);
my @signal = split(//,$in x 10_000);
my $looking_for = join('',@signal[0..6]);
my @relevant = reverse @signal[$looking_for .. $#signal];

my $phase = 0;
my @in = @relevant;
while ($phase < 100) {
    my @out = ($in[0]);
    for my $i (1 .. $#in) {
        my $this_digit = $in[$i];
        my $next_digit_in_next_phase = $out[$i - 1];
        $out[$i] = ($this_digit + $next_digit_in_next_phase) % 10;
    }
    @in = @out;
    $phase++;
    say "phase $phase : ".join('',reverse @in[-8 .. -1]);
}

__END__

As pointed out on reddit, the sequence we are looking for is always in the second half of the signal. But the pattern for the second half will only consist of 0 and 1. This comment was especially helpful: https://www.reddit.com/r/adventofcode/comments/ebf5cy/2019_day_16_part_2_understanding_how_to_come_up/fb4a34p

Here's my explanation:

this_phase: ... 6  9  9  8
next_phase: ... ?  ?  ?  ?

* Work from right to left (i.e. reverse the list)
* For the last digit, just copy the last digit to the next row

this_phase: ... 6  9  9  8
next_phase: ... ?  ?  ?  8

From then on, take the current digit and add the next digit from the next phase

this_phase: ... 6  9 >9< 8
next_phase: ... ?  ?  ? >8<

8 + 9 = 17, take the last digit (i.e. modulo 10) and store it in the next phase

this_phase: ... 6  9  9  8
next_phase: ... ?  ? >7< 8

Repeat, i.e. 9 + 7 = 16 => 6; 6 + 6 = 12 => 2, ...







