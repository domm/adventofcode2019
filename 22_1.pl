use 5.028;
use strict;
use warnings;

my $size = 10006;
my @cards = (0 .. $size);

my @instructions=<STDIN>;

for my $line (@instructions) {
    chomp($line);
    if ($line eq 'deal into new stack') {
        @cards = reverse @cards;
    }
    elsif ($line =~/cut (-?\d+)/) {
        my $cut = $1;
        if ($cut > 0) {
            push(@cards, splice(@cards,0,$cut));
        }
        else {
            unshift(@cards, splice(@cards,$cut,abs($cut)));
        }
    }
    elsif ($line =~ /deal with.* (\d+)/) {
        my $inc = $1;
        my $pos = 0;
        my @new = shift (@cards);
        while (@cards) {
            my $card = shift @cards;
            $pos += $inc;
            if ($pos > $size ) {
                $pos= $pos - $size - 1;
            }
            $new[$pos] = $card;
        }
        @cards = @new;
    }
}

for my $i (0 .. @cards) {
    if ($cards[$i] == 2019) {
        say "2019 at $i";
        exit;
    }
}

