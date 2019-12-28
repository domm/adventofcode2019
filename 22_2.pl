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
        $offset_diff->badd($increment_mul->bneg);
    }
    elsif ( $line =~ /cut (-?\d+)/ ) {
        my $cut = Math::BigInt->new($1);
        $offset_diff->badd( $cut->bmul($increment_mul) );
    }
    elsif ( $line =~ /deal with.* (\d+)/ ) {
        my $n = Math::BigInt->new("$1");
        $increment_mul->bmul( $n->bmodpow( $size_2, $size ) );
    }
    $increment_mul->bmod($size);
    $offset_diff->bmod($size);
}

my $increment = $increment_mul->copy->bmodpow( $iterations, $size );
my $foo       = Math::BigInt->new("1")->bsub($increment);
my $bar       = Math::BigInt->new("1")->bsub($increment_mul)->bmod($size);
my $baz       = $bar->bmodpow( $size_2, $size );
my $offset    = $offset_diff->copy->bmul($foo)->bmul($baz);

my $card = $pos->copy->bmul($increment)->badd($offset)->bmod($size);

say "Card at $pos after $iterations iterations: $card";

