use 5.030;
use strict;
use warnings;
use Math::BigInt;

my @instructions = <STDIN>;

my $pos           = Math::BigInt->new(2020);
my $size          = Math::BigInt->new(119315717514047);
my $size_2        = Math::BigInt->new(119315717514045);
my $iterations    = Math::BigInt->new(101741582076661);
my $increment_mul = Math::BigInt->new(1);
my $offset_diff   = Math::BigInt->new(0);

# reimplement the Python code linked here in Perl:
# https://www.reddit.com/r/adventofcode/comments/ee0rqi/2019_day_22_solutions/fbpz92k

for my $line (@instructions) {
    chomp($line);
    if ( $line eq 'deal into new stack' ) {
        $offset_diff += $increment_mul->bneg;
    }
    elsif ( $line =~ /cut (-?\d+)/ ) {
        my $cut = Math::BigInt->new($1);
        $offset_diff += $cut * $increment_mul;
    }
    elsif ( $line =~ /deal with.* (\d+)/ ) {
        my $n = Math::BigInt->new("$1");
        $increment_mul *= $n->bmodpow( $size_2, $size );
    }
}

my $increment = $increment_mul->copy->bmodpow( $iterations, $size );
my $offset =
    $offset_diff *
    ( 1 - $increment ) *
    ( ( 1 - $increment_mul ) % $size )->bmodpow( $size_2, $size );

my $card = ( $pos * $increment + $offset ) % $size;

say "Card at $pos after $iterations iterations: $card";

